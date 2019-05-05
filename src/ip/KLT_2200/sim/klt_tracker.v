`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2019 04:01:46 PM
// Design Name: 
// Module Name: klt_tracker
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module klt_tracker #(
    
    parameter H_SIZE = 2200//800 //83 //1650
)
(
    
    input rx_pclk,
    input rx_de,
    input rx_hsync,
    input rx_vsync,
    input enable_tracking,
    input reset_position,
    input [7 : 0] pixel_in,
    
    output [11 : 0] point_x0,       //center of tracked roi
    output [10 : 0] point_y0,
    output [7 : 0] centerpx,
    output [7 : 0] uppx,
    output [7 : 0] downpx,
    output [10 : 0] center,
    output [10 : 0] up,
    output [10 : 0] down,
    output [10 : 0] left,
    output [10 : 0] right,
    output [11 : 0] x_pos,
    output [10 : 0] y_pos,
    output in_roi,
    output in_extended_roi,
    output dx_valid,
    output [7 : 0] prev_frame_pixel,
    output [25 : 0] G11,
    output [25 : 0] G12,
    output [25 : 0] G21,
    output [25 : 0] G22,
    output [25 : 0] b1,
    output [25 : 0] b2,
    output [52 : 0] ed_minus_bf,
    output [52 : 0] af_minus_ec,
    output [51 : 0] ad_minus_bc,
    output [87 : 0] dx,
    output [87 : 0] dy,
    output [9 : 0] write_addr_test,
    output [9 : 0] read_addr_test,
    output [9 : 0] read_offset,
    output [16 : 0] read_offset_mult,
    output [11 : 0] delta_x0,
    output [10 : 0] delta_y0,
    output first_frame,
    output [11 : 0] latched_x0,
    output [10 : 0] latched_y0,
    output roi_end,
    output [16 : 0] dy_times_window,
    output updated_in_this_frame
);
    
    wire [10 : 0] center;   //{pixel, de, h_sync, v_sync}
    wire [10 : 0] up;
    wire [10 : 0] down;
    wire [10 : 0] left;
    wire [10 : 0] right;
    
    wire [11 : 0] x_pos;
    wire [10 : 0] y_pos;
    wire first_frame;
    
    wire dx_valid;
    wire [87 : 0] dx;
    wire [87 : 0] dy;
    
    wire [11 : 0] point_x0; //center of tracked ROI
    wire [10 : 0] point_y0;
    wire in_extended_roi;
    wire in_roi;
    wire roi_end;
    
    wire [7 : 0] prev_frame_pixel;
    
    wire G_b_valid;
    wire [25 : 0] G11;
    wire [25 : 0] G12;
    wire [25 : 0] G21;
    wire [25 : 0] G22;
    wire [25 : 0] b1;
    wire [25 : 0] b2;

    
    context_3x3 #(
    
        .H_SIZE(H_SIZE)
    )
    context(
    
        .clk(rx_pclk),
        .pixel_in(pixel_in),
        .de_in(rx_de),
        .h_sync_in(rx_hsync),
        .v_sync_in(rx_vsync),
        
        .center(center),
        .up(up),
        .down(down),
        .left(left),
        .right(right)
    );
    
    
    pixel_position context_pos(
    
        .clk(rx_pclk),
        .de_in(center[2]),
        .hsync_in(center[1]),
        .vsync_in(center[0]),
        
        .x(x_pos),
        .y(y_pos),
        .first_frame(first_frame)
    );
    
    
    in_roi_check inroi(
    
        .enable(enable_tracking),
        .reset_position(reset_position),
        .center_vsync_in(center[0]),
        .clk(rx_pclk),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .d_ready(dx_valid),
        .dx(dx),
        .dy(dy),
        
        .x0_int_out(point_x0),
        .y0_int_out(point_y0),
        .in_roi(in_roi),
        .in_extended_roi(in_extended_roi),
        .roi_end(roi_end),
//        .latched_x0_int(latched_x0),
//        .latched_y0_int(latched_y0)
        .updated_in_this_frame(updated_in_this_frame)
    );
    
    
    previous_roi_buffer previous_frame_pixel(
    
        .clk(rx_pclk),
        .center_pixel(center),
        .in_roi(in_roi),
        .in_extended_roi(in_extended_roi),
        .roi_end(roi_end),
        .center_vsync(center[0]),
        .point_x0(point_x0),
        .point_y0(point_y0),
        .first_frame(first_frame),
    
        .prev_frame_pixel(prev_frame_pixel)
//        .write_addr_test(write_addr_test),
//        .read_addr_test(read_addr_test),
//        .delta_x0(delta_x0),
//        .delta_y0(delta_y0),
//        .read_offset(read_offset),
//        .dy_times_window(dy_times_window)
    );
    
    
    klt_integrator kltboy(
    
        .clk(rx_pclk),
        .in_roi(in_roi),
        .roi_end(roi_end),
        .first_frame(first_frame),
        .end_of_frame(center[0]),
        .prev_center_pixel(prev_frame_pixel),
        .center_pixel(center[10 : 3]),
        .left_pixel(left[10 : 3]),
        .right_pixel(right[10 : 3]),
        .up_pixel(up[10 : 3]),
        .down_pixel(down[10 : 3]),
        
        .data_valid(G_b_valid),
        .G11(G11),
        .G12(G12),
        .G21(G21),
        .G22(G22),
        .b1(b1),
        .b2(b2)
    );
    
    
    linsolve disposition(
    
        .clk(rx_pclk),
        .data_valid(G_b_valid),
        .end_of_frame(center[0]),
        .G11(G11),
        .G12(G12),
        .G22(G22),
        .b1(b1),
        .b2(b2),
        
        .x_output_valid(dx_valid),
        .x(dx),
        .y(dy)
        
//        ._2_ed_minus_bf_output(ed_minus_bf),
//        ._2_af_minus_ec_output(af_minus_ec),
//        .ad_minus_bc_output(ad_minus_bc)
    );
    
    
//    wysw_box box(
    
//        .clk(rx_pclk),
//        .de_in(rx_de),
//        .hsync_in(rx_hsync),
//        .vsync_in(rx_vsync),
//        .pixel_in({pixel_in, pixel_in, pixel_in}),
//        .x0(point_x0 - 4'd10), //module takes left-up corner of box
//        .y0(point_y0 - 4'd10),
//        .width(11'd21),
//        .height(11'd21),
        
//        .pixel_out(pixel_out)
//    );
    
    assign centerpx = center[10 -: 8];
    assign uppx = up[10 -: 8];
    assign downpx = down[10 -: 8];
    
endmodule
