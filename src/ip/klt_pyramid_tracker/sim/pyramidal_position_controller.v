`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2019 02:29:42
// Design Name: 
// Module Name: pyramidal_position_controller
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


module pyramidal_position_controller(

    input clk,
    input [11 : 0] set_x0,
    input [10 : 0] set_y0,
    input [87 : 0] disposition_L0_x,
    input [87 : 0] disposition_L0_y,
    input [87 : 0] pyramidal_guess_L1_x,
    input [87 : 0] pyramidal_guess_L1_y,
    input d_ready,
    input reset,
    input enable,
    input center_vsync_in,
    
    output [11 : 0] point_x0_L0,
    output [10 : 0] point_y0_L0,
    output [11 : 0] point_x0_L1,
    output [10 : 0] point_y0_L1,
    output [11 : 0] point_x0_L2,
    output [10 : 0] point_y0_L2,
    
    output reg [2 : 0] updated_in_this_frame = 0
);

    reg [87 : 0] x0 = {59'd300, 29'b0};  
    reg [87 : 0] y0 = {59'd290, 29'b0};
    
    wire d_ready_del;
    wire data_ready;
    
    always @(posedge clk)
    begin
    
        if(reset == 1)
        begin
        
            x0 <= {47'd0, set_x0, 29'd0};
            y0 <= {48'd0, set_y0, 29'd0};
        end
        
        else if(enable == 1 && data_ready == 1)
        begin
        
            updated_in_this_frame <= updated_in_this_frame + 1;
            x0 <= x0 + disposition_L0_x + pyramidal_guess_L1_x;
            y0 <= y0 + disposition_L0_y + pyramidal_guess_L1_y;
        end  
        
        else if(center_vsync_in == 1)
            updated_in_this_frame <= 0;
    end
    
    
    modul_puz #(
            
        .N(1),
        .DELAY(1)
    )d_ready_delay(
    
        .clk(clk),
        .in(d_ready),
        .out(d_ready_del)
    );
    
    
    //d_ready rising edge detection
    assign data_ready = d_ready_del == 0 && d_ready == 1;

    assign point_x0_L0 = x0[28] ? (x0[29 +: 12] + 1) : x0[29 +: 12];
    assign point_y0_L0 = y0[28] ? (y0[29 +: 11] + 1) : y0[29 +: 11];
    
    assign point_x0_L1 = x0[29] ? (x0[30 +: 12] + 1) : x0[30 +: 12]; //divide by 2 with rounding
    assign point_y0_L1 = y0[29] ? (y0[30 +: 11] + 1) : y0[30 +: 11];
    
    assign point_x0_L2 = x0[30] ? (x0[31 +: 12] + 1) : x0[31 +: 12]; //divide by 4 with rounding
    assign point_y0_L2 = y0[30] ? (y0[31 +: 11] + 1) : y0[31 +: 11];
endmodule
