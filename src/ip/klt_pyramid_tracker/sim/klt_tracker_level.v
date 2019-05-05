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


module klt_tracker_level #(
    
    parameter H_SIZE = 800//800 //83 //1650
)
(
    
    input rx_pclk,
    input rx_de,
    input rx_hsync,
    input rx_vsync,
    input [11 : 0] level_x0,
    input [10 : 0] level_y0,
    input [87 : 0] pyramidal_guess_x,
    input [87 : 0] pyramidal_guess_y,
    input [7 : 0] pixel_in,
    
    output reg [87 : 0] guess_out_x = 0,
    output reg [87 : 0] guess_out_y = 0,
    output reg guess_valid = 0,
    output halt_me_pls,
    output [87 : 0] disposition_x,
    output [87 : 0] disposition_y,
    
    output context_valid,
    output [10 : 0] center,
    output [7 : 0] leftpx,
    output [7 : 0] rightpx,
    output [7 : 0] uppx,
    output [7 : 0] downpx,
    output [7 : 0] prev_up_pixel,
    output [7 : 0] prev_down_pixel,
    output [7 : 0] prev_left_pixel,
    output [7 : 0] prev_right_pixel,
    output [10 : 0] pyramidal_guess_pixel,
    output [5 : 0] pyramidal_guess_x_int,
    output [5 : 0] pyramidal_guess_y_int,
    output [11 : 0] x_pos,
    output [10 : 0] y_pos,
    output in_roi,
    output in_extended_roi,
    output [7 : 0] prev_center_pixel,
    output [25 : 0] G11,
    output [25 : 0] G12,
    output [25 : 0] G21,
    output [25 : 0] G22,
    output [25 : 0] b1,
    output [25 : 0] b2,
    output [52 : 0] ed_minus_bf,
    output [52 : 0] af_minus_ec,
    output [51 : 0] ad_minus_bc,
    output [9 : 0] write_addr_test,
    output [9 : 0] read_addr_test,
    output [9 : 0] read_offset,
    output [11 : 0] delta_x0,
    output [10 : 0] delta_y0,
    output first_frame,
    output roi_end
);

    assign leftpx = left[10 -: 8];
    assign rightpx = right[10 -: 8];
    assign uppx = up[10 -: 8];
    assign downpx = down[10 -: 8];
    
    localparam P_GUESS_INT_WIDTH = 6;
    
    reg guess_updated_flag = 0;
    
    wire [P_GUESS_INT_WIDTH-1 : 0] pyramidal_guess_x_int; //rounded input pyramidal guess
    wire [P_GUESS_INT_WIDTH-1 : 0] pyramidal_guess_y_int;
    
    wire [10 : 0] center;   //{pixel, de, h_sync, v_sync}
    wire [10 : 0] up;
    wire [10 : 0] down;
    wire [10 : 0] left;
    wire [10 : 0] right;
    wire [10 : 0] pyramidal_guess_pixel;
    
    wire [11 : 0] x_pos;
    wire [10 : 0] y_pos;
    wire first_frame;
    
    wire in_extended_roi;
    wire in_roi;
    wire roi_end;
    
    wire [7 : 0] prev_center_pixel;
    wire [7 : 0] prev_left_pixel;
    wire [7 : 0] prev_right_pixel;
    wire [7 : 0] prev_up_pixel;
    wire [7 : 0] prev_down_pixel;
    
    wire G_b_valid;
    wire [25 : 0] G11;
    wire [25 : 0] G12;
    wire [25 : 0] G21;
    wire [25 : 0] G22;
    wire [25 : 0] b1;
    wire [25 : 0] b2;
    
    wire level_guess_valid;
    wire [87 : 0] level_guess_x;
    wire [87 : 0] level_guess_y;
    
    wire [87 : 0] sum_level_guess_x;    //computed level_guess + input pyramidal_guess
    wire [87 : 0] sum_level_guess_y;
    
    
    context_level #(
    
        .H_SIZE(H_SIZE),
        .CONTEXT_SIZE(7),
        .CONTEXT_CENTER(4),
        .P_GUESS_INT_WIDTH(P_GUESS_INT_WIDTH)
    )
    context(
    
        .clk(rx_pclk),
        .pixel_in(pixel_in),
        .de_in(rx_de),
        .h_sync_in(rx_hsync),
        .v_sync_in(rx_vsync),
        .pyramidal_guess_x_int(pyramidal_guess_x_int),
        .pyramidal_guess_y_int(pyramidal_guess_y_int),
        
        .center(center),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .pyramidal_guess_pixel(pyramidal_guess_pixel)
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
    
    
    in_roi_check_level inroi(
    
        .center_vsync_in(center[0]),
        .clk(rx_pclk),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .level_x0(level_x0),
        .level_y0(level_y0),
        
        .in_roi(in_roi),
        .in_extended_roi(in_extended_roi),
        .roi_end(roi_end),
        .halt_me_pls(halt_me_pls)
    );
    
    
    prev_frame_context prev_con(
    
        .clk(rx_pclk),
        .center_pixel(center),
        .left_pixel(left),
        .right_pixel(right),
        .up_pixel(up),
        .down_pixel(down),
        
        .in_roi(in_roi),
        .in_extended_roi(in_extended_roi),
        .roi_end(roi_end),
        .center_vsync(center[0]),
        .point_x0(level_x0),
        .point_y0(level_y0),
        .first_frame(first_frame),
    
        .prev_center_pixel(prev_center_pixel),
        .prev_left_pixel(prev_left_pixel),
        .prev_right_pixel(prev_right_pixel),
        .prev_up_pixel(prev_up_pixel),
        .prev_down_pixel(prev_down_pixel),
        
        .write_addr_test(write_addr_test),
        .read_addr_test(read_addr_test),
        .delta_x0(delta_x0),
        .delta_y0(delta_y0),
        .read_offset(read_offset)
    );
    
    
    klt_integrator_level kltboy(
    
        .clk(rx_pclk),
        .in_roi(in_roi),
        .roi_end(roi_end),
        .first_frame(first_frame),
        .end_of_frame(center[0]),
        
        .prev_center_pixel(prev_center_pixel),
        .prev_left_pixel(prev_left_pixel),
        .prev_right_pixel(prev_right_pixel),
        .prev_up_pixel(prev_up_pixel),
        .prev_down_pixel(prev_down_pixel),
        .pyramidal_guess_pixel(pyramidal_guess_pixel[10 : 3]),
        
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
        
        .x_output_valid(level_guess_valid),
        .x(level_guess_x),
        .y(level_guess_y),
        
        ._2_ed_minus_bf_output(ed_minus_bf),
        ._2_af_minus_ec_output(af_minus_ec),
        .ad_minus_bc_output(ad_minus_bc)
    );
    
    
    //update pyramidal guess
    always @(posedge rx_pclk)
    begin
    
        if(level_guess_valid == 1 && guess_updated_flag == 0)
        begin
        
            guess_out_x <= {sum_level_guess_x[0 +: 87], 1'b0};  //multiply by 2
            guess_out_y <= {sum_level_guess_y[0 +: 87], 1'b0};
            guess_valid <= 1'b1;
            guess_updated_flag <= 1;
        end
        
        if(center[0] == 1)
        begin
            
            guess_valid <= 1'b0;
            guess_updated_flag <= 0;
        end
    end
    
    
    //rounding input pyramidal guess for context generation module
    //pyramidal_guess[28] is most significant franction bit
//    always @(*)
//    begin
    
//        pyramidal_guess_x_int = pyramidal_guess_x[29 +: P_GUESS_INT_WIDTH];
//        pyramidal_guess_y_int = pyramidal_guess_y[29 +: P_GUESS_INT_WIDTH];
        
//        if(pyramidal_guess_x[28] == 1)
//        begin
            
//            //if negative
//            if(pyramidal_guess_x[87] == 1)
//                pyramidal_guess_x_int = pyramidal_guess_x[29 +: P_GUESS_INT_WIDTH] - 1;
            
//            else
//                pyramidal_guess_x_int = pyramidal_guess_x[29 +: P_GUESS_INT_WIDTH] + 1;
//        end
        
//        if(pyramidal_guess_y[28] == 1)
//        begin
            
//            //if negative
//            if(pyramidal_guess_y[87] == 1)
//                pyramidal_guess_y_int = pyramidal_guess_y[29 +: P_GUESS_INT_WIDTH] - 1;
            
//            else
//                pyramidal_guess_y_int = pyramidal_guess_y[29 +: P_GUESS_INT_WIDTH] + 1;
//        end     
//    end
    
    //rounding
    assign pyramidal_guess_x_int = pyramidal_guess_x[28] ? (pyramidal_guess_x[29 +: P_GUESS_INT_WIDTH] + 1) : pyramidal_guess_x[29 +: P_GUESS_INT_WIDTH];
    assign pyramidal_guess_y_int = pyramidal_guess_y[28] ? (pyramidal_guess_y[29 +: P_GUESS_INT_WIDTH] + 1) : pyramidal_guess_y[29 +: P_GUESS_INT_WIDTH];
    
    assign sum_level_guess_x = pyramidal_guess_x + level_guess_x;
    assign sum_level_guess_y = pyramidal_guess_y + level_guess_y;
    assign disposition_x = level_guess_x;
    assign disposition_y = level_guess_y;
endmodule
