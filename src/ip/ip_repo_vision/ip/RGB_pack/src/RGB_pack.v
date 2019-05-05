`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH-UST EAIIB 
// Engineer xD: Mateusz Wozniak 
// 
// Create Date: 08.12.2015 10:18:07
// Design Name: 
// Module Name: RGB_pack
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


module RGB_pack(
    input [7:0] in_R,
	input [7:0] in_G,
	input [7:0] in_B,
	input in_HSync,
	input in_VSync,
	input in_DE,
	input in_PClk,
	
	output [23:0]out_RGB,
	output out_HSync,
	output out_VSync,
	output out_DE,
	output out_PClk
    );
	
	
	assign out_RGB = {in_R, in_B, in_G};
	
	assign out_HSync = in_HSync;
	assign out_VSync = in_VSync;
	assign out_DE = in_DE;
	assign out_PClk = in_PClk;
    
endmodule
