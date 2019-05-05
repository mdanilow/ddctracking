`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2019 16:48:30
// Design Name: 
// Module Name: split_rgb
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


module split_rgb(
    
    input [23 : 0] pixel_in,
    
    output [7 : 0] r_out,
    output [7 : 0] g_out,
    output [7 : 0] b_out
);

    assign r_out = pixel_in[23 -: 8];
    assign g_out = pixel_in[15 -: 8];
    assign b_out = pixel_in[7 : 0];
endmodule
