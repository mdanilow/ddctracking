`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2019 02:25:20 AM
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


module tb_pyramid(

    );
    
    wire rx_pclk;

    wire rx_de;
    wire rx_hsync;
    wire rx_vsync;
    
    wire [7:0] rx_red;
    wire [7:0] rx_green;
    wire [7:0] rx_blue;

    wire clk_2x;
    wire [7 : 0] pixel_2x;
    wire de_2x;
    wire hsync_2x;
    wire vsync_2x;
    
    wire clk_4x;
    wire [7 : 0] pixel_4x;
    wire de_4x;
    wire hsync_4x;
    wire vsync_4x;
    
    wire [11 : 0] point_x0_L0;
    wire [10 : 0] point_y0_L0;
    wire [11 : 0] point_x0_L1;
    wire [10 : 0] point_y0_L1;
    wire [11 : 0] point_x0_L2;
    wire [10 : 0] point_y0_L2;
    
    wire [87 : 0] pyramidal_guess_L2_x;
    wire [87 : 0] pyramidal_guess_L2_y;
    wire guess_valid_L2;
    
    wire [87 : 0] pyramidal_guess_L1_x;
    wire [87 : 0] pyramidal_guess_L1_y;
    wire guess_valid_L1;
    
    wire guess_valid_L0;
    
    wire halt_L1;
    wire [7 : 0] pixel_2x_halted;
    wire hsync_2x_halted;
    wire vsync_2x_halted;
    wire de_2x_halted;
    wire clk_2x_halted;
    
    wire halt_L0;
    wire [7 : 0] pixel_halted;
    wire hsync_halted;
    wire vsync_halted;
    wire de_halted;
    wire clk_halted;

    wire [10 : 0] pyramidal_guess_pixel;
    wire [7 : 0] pyramidal_guess_px;
    wire [5 : 0] pyramidal_guess_x_int;
    wire [5 : 0] pyramidal_guess_y_int;
    wire in_extended_roi_L2;
    wire [7 : 0] prev_frame_pixel;
    wire [9 : 0] write_addr_L2;
    wire [9 : 0] read_addr_L2;
    wire [9 : 0] read_offset_L2;
    wire [11 : 0] delta_x0_L2;
    wire [10 : 0] delta_y0_L2;
    wire center_vsync;
    wire first_frame;
    
    wire [10 : 0] center;
    wire [7 : 0] centerpx;
    wire [7 : 0] leftpx_L2;
    wire [7 : 0] rightpx_L2;
    wire [7 : 0] uppx_L2;
    wire [7 : 0] downpx_L2;
    wire [7 : 0] prev_leftpx_L2;
    wire [7 : 0] prev_rightpx_L2;
    wire [7 : 0] prev_uppx_L2;
    wire [7 : 0] prev_downpx_L2;
    wire [25 : 0] G11;
    wire [25 : 0] G12;
    wire [25 : 0] G21;
    wire [25 : 0] G22;
    wire [25 : 0] b1;
    wire [25 : 0] b2;
    wire [11 : 0] x_pos;
    wire [10 : 0] y_pos;
    wire in_roi;
    wire roi_end_L2;
    
    wire [10 : 0] center_L1;
    wire [7 : 0] centerpx_L1;
    wire [7 : 0] leftpx_L1;
    wire [7 : 0] rightpx_L1;
    wire [7 : 0] uppx_L1;
    wire [7 : 0] downpx_L1;
    wire [7 : 0] prev_leftpx_L1;
    wire [7 : 0] prev_rightpx_L1;
    wire [7 : 0] prev_uppx_L1;
    wire [7 : 0] prev_downpx_L1;
    wire [25 : 0] G11_L1;
    wire [25 : 0] G12_L1;
    wire [25 : 0] G21_L1;
    wire [25 : 0] G22_L1;
    wire [25 : 0] b1_L1;
    wire [25 : 0] b2_L1;
    wire [11 : 0] x_pos_L1;
    wire [10 : 0] y_pos_L1;
    wire in_roi_L1;
    wire [9 : 0] write_addr_L1;
    wire [9 : 0] read_addr_L1;
    wire [9 : 0] read_offset_L1;
    wire [11 : 0] delta_x0_L1;
    wire [10 : 0] delta_y0_L1;
    wire roi_end_L1;
    
    wire [10 : 0] center_L0;
    wire [7 : 0] centerpx_L0;
    wire [25 : 0] G11_L0;
    wire [25 : 0] G12_L0;
    wire [25 : 0] G21_L0;
    wire [25 : 0] G22_L0;
    wire [25 : 0] b1_L0;
    wire [25 : 0] b2_L0;
    wire [11 : 0] x_pos_L0;
    wire [10 : 0] y_pos_L0;
    wire in_roi_L0;
    wire [9 : 0] write_addr_L0;
    wire [9 : 0] read_addr_L0;
    wire [9 : 0] read_offset_L0;
    wire [11 : 0] delta_x0_L0;
    wire [10 : 0] delta_y0_L0;
    wire roi_end_L0;
    wire [7 : 0] prev_leftpx_L0;
    wire [7 : 0] prev_rightpx_L0;
    wire [7 : 0] prev_uppx_L0;
    wire [7 : 0] prev_downpx_L0;
    wire [7 : 0] leftpx_L0;
    wire [7 : 0] rightpx_L0;
    wire [7 : 0] uppx_L0;
    wire [7 : 0] downpx_L0;
    wire [2 : 0] updated_in_this_frame;
    
    wire [87 : 0] disposition_L0_x;
    wire [87 : 0] disposition_L0_y;
    
    wire [10 : 0] pyramidal_guess_pixel_L0;
    wire [7 : 0] pyramidal_guess_pixel_L0_int;
    wire [7 : 0] prev_center_pixel_L0;
    wire [5 : 0] pyramidal_guess_L1_x_int;
    wire [5 : 0] pyramidal_guess_L1_y_int;
    
    wire [10 : 0] pyramidal_guess_pixel_L1;
    wire [7 : 0] pyramidal_guess_pixel_L1_int;
    wire [7 : 0] prev_center_pixel_L1;
    wire [5 : 0] pyramidal_guess_L2_x_int;
    wire [5 : 0] pyramidal_guess_L2_y_int;

    assign centerpx = center[10 -: 8];
    assign centerpx_L0 = center_L0[10 -: 8];
    assign pyramidal_guess_pixel_L0_int = pyramidal_guess_pixel_L0[10 -: 8];
    assign pyramidal_guess_pixel_L1_int = pyramidal_guess_pixel_L1[10 -: 8];
    
    hdmi_in file_input(

        .hdmi_clk(rx_pclk), 
        .hdmi_de(rx_de), 
        .hdmi_hs(rx_hsync), 
        .hdmi_vs(rx_vsync), 
        .hdmi_r(rx_red), 
        .hdmi_g(rx_green), 
        .hdmi_b(rx_blue)
    );

    
    scale2x #(
    
        .H_SIZE(800)
    )
    scaled2x(
    
        .clk(rx_pclk),
        .pixel_in(rx_red),
        .de_in(rx_de),
        .hsync_in(rx_hsync),
        .vsync_in(rx_vsync),

        .clk_2x(clk_2x),
        .pixel_out(pixel_2x),
        .de_out(de_2x),
        .hsync_out(hsync_2x),
        .vsync_out(vsync_2x)
    );
    
    
    scale2x #(
    
        .H_SIZE(800),
        .CLK_PHASE(1)
    )
    scaled4x(
    
        .clk(clk_2x),
        .pixel_in(pixel_2x),
        .de_in(de_2x),
        .hsync_in(hsync_2x),
        .vsync_in(vsync_2x),

        .clk_2x(clk_4x),
        .pixel_out(pixel_4x),
        .de_out(de_4x),
        .hsync_out(hsync_4x),
        .vsync_out(vsync_4x)
//        .A11(A11),
//        .A12(A12),
//        .A21(A21),
//        .A22(A22),
//        .context_2x2_valid(context_2x2_valid),
//        .A11pA12(A11pA12),
//        .A21pA22(A21pA22),
//        .sum(sum),
//        .round_sum(round_sum)
    );
    
    
    pyramidal_position_controller poscon(
        
        .clk(rx_pclk),
        .set_x0(12'd300),
        .set_y0(11'd290),
        .disposition_L0_x(disposition_L0_x),
        .disposition_L0_y(disposition_L0_y),
        .pyramidal_guess_L1_x(pyramidal_guess_L1_x),
        .pyramidal_guess_L1_y(pyramidal_guess_L1_y),
        .d_ready(guess_valid_L0),
        .reset(1'b0),
        .enable(1'b1),
        .center_vsync_in(rx_vsync),
        
        .point_x0_L0(point_x0_L0),
        .point_y0_L0(point_y0_L0),
        .point_x0_L1(point_x0_L1),
        .point_y0_L1(point_y0_L1),
        .point_x0_L2(point_x0_L2),
        .point_y0_L2(point_y0_L2),
        
        .updated_in_this_frame(updated_in_this_frame)
    );
    
    
    klt_tracker_level tracker_L2(
        
        .rx_pclk(clk_4x),
        .rx_de(de_4x),
        .rx_hsync(hsync_4x),
        .rx_vsync(vsync_4x),
        .pixel_in(pixel_4x),
        .level_x0(point_x0_L2),
        .level_y0(point_y0_L2),
        .pyramidal_guess_x(88'b0),
        .pyramidal_guess_y(88'b0),
        
        .guess_out_x(pyramidal_guess_L2_x),
        .guess_out_y(pyramidal_guess_L2_y),
        .guess_valid(guess_valid_L2),
        
        .center(center),
        .leftpx(leftpx_L2),
        .rightpx(rightpx_L2),
        .uppx(uppx_L2),
        .downpx(downpx_L2),
        .prev_left_pixel(prev_leftpx_L2),
        .prev_right_pixel(prev_rightpx_L2),
        .prev_up_pixel(prev_uppx_L2),
        .prev_down_pixel(prev_downpx_L2),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .in_roi(in_roi),
        .G11(G11),
        .G12(G12),
        .G22(G22),
        .b1(b1),
        .b2(b2),
        .write_addr_test(write_addr_L2),
        .read_addr_test(read_addr_L2),
        .read_offset(read_offset_L2),
        .delta_x0(delta_x0_L2),
        .delta_y0(delta_y0_L2),
        .in_extended_roi(in_extended_roi_L2),
        .roi_end(roi_end_L2)
    );
    
    
    vision_stream_halter L1_halter(
    
        .clk(clk_2x),
        .pixel_in(pixel_2x),
        .hsync_in(hsync_2x),
        .vsync_in(vsync_2x),    
        .de_in(de_2x),
        .halt(halt_L1),
        .start(guess_valid_L2),
        .reset(vsync_2x),
        
        .clk_out(clk_2x_halted),
        .pixel_out(pixel_2x_halted),
        .hsync_out(hsync_2x_halted),
        .vsync_out(vsync_2x_halted),
        .de_out(de_2x_halted)
    );
    
    
    klt_tracker_level tracker_L1(
            
        .rx_pclk(clk_2x_halted),
        .rx_de(de_2x_halted),
        .rx_hsync(hsync_2x_halted),
        .rx_vsync(vsync_2x_halted),
        .pixel_in(pixel_2x_halted),
//        .rx_pclk(clk_2x),
//        .rx_de(de_2x),
//        .rx_hsync(hsync_2x),
//        .rx_vsync(vsync_2x),
//        .pixel_in(pixel_2x),
        
        .level_x0(point_x0_L1),
        .level_y0(point_y0_L1),
        .pyramidal_guess_x(pyramidal_guess_L2_x),
        .pyramidal_guess_y(pyramidal_guess_L2_y),
        
        .guess_out_x(pyramidal_guess_L1_x),
        .guess_out_y(pyramidal_guess_L1_y),
        .guess_valid(guess_valid_L1),
        .halt_me_pls(halt_L1),
      
//        .context_valid(context_valid),
        .center(center_L1),
        .leftpx(leftpx_L1),
        .rightpx(rightpx_L1),
        .uppx(uppx_L1),
        .downpx(downpx_L1),
        .prev_left_pixel(prev_leftpx_L1),
        .prev_right_pixel(prev_rightpx_L1),
        .prev_up_pixel(prev_uppx_L1),
        .prev_down_pixel(prev_downpx_L1),
        .x_pos(x_pos_L1),
        .y_pos(y_pos_L1),
        .in_roi(in_roi_L1),
        .G11(G11_L1),
        .G12(G12_L1),
        .G22(G22_L1),
        .b1(b1_L1),
        .b2(b2_L1),
        .pyramidal_guess_pixel(pyramidal_guess_pixel_L1),
        .prev_center_pixel(prev_center_pixel_L1),
        .pyramidal_guess_x_int(pyramidal_guess_L2_x_int),
        .pyramidal_guess_y_int(pyramidal_guess_L2_y_int),
        .write_addr_test(write_addr_L1),
        .read_addr_test(read_addr_L1),
        .read_offset(read_offset_L1),
        .delta_x0(delta_x0_L1),
        .delta_y0(delta_y0_L1),
        .roi_end(roi_end_L1)
    );
    
    
    vision_stream_halter L0_halter(
        
        .clk(rx_pclk),
        .pixel_in(rx_red),
        .hsync_in(rx_hsync),
        .vsync_in(rx_vsync),    
        .de_in(rx_de),
        .halt(halt_L0),
        .start(guess_valid_L1),
        .reset(rx_vsync),
        
        .clk_out(clk_halted),
        .pixel_out(pixel_halted),
        .hsync_out(hsync_halted),
        .vsync_out(vsync_halted),
        .de_out(de_halted)
    );
    
    
    klt_tracker_level tracker_L0(
                
        .rx_pclk(clk_halted),
        .rx_de(de_halted),
        .rx_hsync(hsync_halted),
        .rx_vsync(vsync_halted),
        .pixel_in(pixel_halted),
        
        .level_x0(point_x0_L0),
        .level_y0(point_y0_L0),
        .pyramidal_guess_x(pyramidal_guess_L1_x),
        .pyramidal_guess_y(pyramidal_guess_L1_y),
        
        .disposition_x(disposition_L0_x),
        .disposition_y(disposition_L0_y),
        .guess_valid(guess_valid_L0),
        .halt_me_pls(halt_L0),
      
        .center(center_L0),
        .x_pos(x_pos_L0),
        .y_pos(y_pos_L0),
        .in_roi(in_roi_L0),
        .G11(G11_L0),
        .G12(G12_L0),
        .G22(G22_L0),
        .b1(b1_L0),
        .b2(b2_L0),
        .pyramidal_guess_pixel(pyramidal_guess_pixel_L0),
        .prev_center_pixel(prev_center_pixel_L0),
        .pyramidal_guess_x_int(pyramidal_guess_L1_x_int),
        .pyramidal_guess_y_int(pyramidal_guess_L1_y_int),
        .write_addr_test(write_addr_L0),
        .read_addr_test(read_addr_L0),
        .read_offset(read_offset_L0),
        .delta_x0(delta_x0_L0),
        .delta_y0(delta_y0_L0),
        .roi_end(roi_end_L0),
        .leftpx(leftpx_L0),
        .rightpx(rightpx_L0),
        .uppx(uppx_L0),
        .downpx(downpx_L0)
    );
    
endmodule
