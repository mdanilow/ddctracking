`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2015 10:18:07
// Design Name: 
// Module Name: RGB_unpack
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


module RGB_unpack(
	input [23:0]in_RGB,
	input in_HSync,
	input in_VSync,
	input in_DE,
	input in_PClk,
    
    output [7:0] out_R,
    output [7:0] out_G,
    output [7:0] out_B,
    output out_HSync,
    output out_VSync,
    output out_DE,
    output out_PClk
    );
    
	assign out_R = in_RGB[23:16];
	assign out_G = in_RGB[7:0];
	assign out_B = in_RGB[15:8];
	
	assign out_HSync = in_HSync;
	assign out_VSync = in_VSync;
	assign out_DE = in_DE;
	assign out_PClk = in_PClk;
    
endmodule

