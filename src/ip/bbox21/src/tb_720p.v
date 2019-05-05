`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2019 09:46:27 PM
// Design Name: 
// Module Name: tb_pyramid
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


module tb_720p(

);
    
    wire rx_pclk;
    wire rx_de;
    wire rx_hsync;
    wire rx_vsync;
    wire [7:0] rx_red;
    wire [7:0] rx_green;
    wire [7:0] rx_blue;
    
    wire [23 : 0] klt_tracker_out;
    wire context_valid;
    wire [10 : 0] center;
    wire [10 : 0] up;
    wire [10 : 0] down;
    wire [10 : 0] left;
    wire [10 : 0] right;
    wire [7 : 0] centerpx;
    wire [7 : 0] uppx;
    wire [7 : 0] downpx;
    wire [7 : 0] leftpx;
    wire [7 : 0] rightpx;
    wire [11 : 0] x_pos;
    wire [10 : 0] y_pos;
    wire dx_valid;
    wire [11 : 0] point_x0;
    wire [10 : 0] point_y0;
    wire in_roi;
    wire in_extended_roi;
    wire [7 : 0] prev_frame_pixel;
    wire [25 : 0] G11;
    wire [25 : 0] G12;
    wire [25 : 0] G21;
    wire [25 : 0] G22;
    wire [25 : 0] b1;
    wire [25 : 0] b2;
    wire [52 : 0] ed_minus_bf;
    wire [52 : 0] af_minus_ec;
    wire [51 : 0] ad_minus_bc;
    wire [87 : 0] dx;
    wire [87 : 0] dy;
    wire [9 : 0] write_addr_test;
    wire [9 : 0] read_addr_test;
    wire [9 : 0] read_offset;
    wire [16 : 0] read_offset_mult;
    wire [11 : 0] delta_x0;
    wire [10 : 0] delta_y0;
    wire center_vsync;
    wire first_frame;
    wire [11 : 0] latched_x0;
    wire [10 : 0] latched_y0;
    wire [16 : 0] dy_times_window;
    wire updated_in_this_frame;
    
    wire gray_de;
    wire gray_vsync;
    wire gray_hsync;
    wire [8 : 0] gray_pixel;
    
    assign center_vsync = center[0];
    assign centerpx = center[10 -: 8];
    assign uppx = up[10 -: 8];
    assign downpx = down[10 -: 8];
    assign leftpx = left[10 -: 8];
    assign rightpx = right[10 -: 8];
        
    hdmi_in_720 file_input(
    
        .hdmi_clk(rx_pclk), 
        .hdmi_de(rx_de), 
        .hdmi_hs(rx_hsync), 
        .hdmi_vs(rx_vsync), 
        .hdmi_r(rx_red), 
        .hdmi_g(rx_green), 
        .hdmi_b(rx_blue)
    );
    
    
    rgb2ycbcr_0 gray(
    
        .clk(rx_pclk),
        .de_in(rx_de),
        .h_sync_in(rx_hsync),
        .v_sync_in(rx_vsync),
        .pixel_in({rx_red, rx_green, rx_blue}),
        
        .de_out(gray_de),
        .h_sync_out(gray_hsync),
        .v_sync_out(gray_vsync),
        .y(gray_pixel)
    );
    
    
//    klt_tracker_w10b2_mult_0 #(
    
//        .H_SIZE(800)
//    )
//    track(
    
//        .rx_pclk(rx_pclk),
//        .rx_de(gray_de),
//        .rx_hsync(gray_hsync),
//        .rx_vsync(gray_vsync),
//        .enable_tracking(1'b1),
//        .reset_position(1'b0),
//        .pixel_in(gray_pixel),
        
//        .pixel_out(klt_tracker_out),
//        .point_x0(point_x0),
//        .point_y0(point_y0)
//    );
    
    klt_tracker #(
    
        .H_SIZE(1650)
    )
    tracker(
    
        .rx_pclk(rx_pclk),
        .rx_de(rx_de),
        .rx_hsync(rx_hsync),
        .rx_vsync(rx_vsync),
        .enable_tracking(1'b1),
        .reset_position(1'b0),
        .pixel_in(rx_red),
        
        .pixel_out(klt_tracker_out),
        .center(center),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .in_roi(in_roi),
        .in_extended_roi(in_extended_roi),
        .dx_valid(dx_valid),
        .prev_frame_pixel(prev_frame_pixel),
        .point_x0(point_x0),
        .point_y0(point_y0),
        .G11(G11),
        .G12(G12),
        .G22(G22),
        .b1(b1),
        .b2(b2),
        .ed_minus_bf(ed_minus_bf),
        .af_minus_ec(af_minus_ec),
        .ad_minus_bc(ad_minus_bc),
        .dx(dx),
        .dy(dy),
        .write_addr_test(write_addr_test),
        .read_addr_test(read_addr_test),
        .read_offset(read_offset),
        .read_offset_mult(read_offset_mult),
        .delta_x0(delta_x0),
        .delta_y0(delta_y0),
        .first_frame(first_frame),
        .latched_x0(latched_x0),
        .latched_y0(latched_y0),
        .dy_times_window(dy_times_window),
        .updated_in_this_frame(updated_in_this_frame)
    );
    
    
    hdmi_out file_output (
    
        .hdmi_clk(rx_pclk), 
        .hdmi_vs(rx_vsync), 
        .hdmi_de(rx_de), 
        .hdmi_data({8'b0, klt_tracker_out})
    );

endmodule
