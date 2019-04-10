`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 02:39:20 PM
// Design Name: 
// Module Name: bin_mask
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


module bin_mask(
    
    input wire[7 : 0] Ta,
    input wire[7 : 0] Tb,
    input wire[7 : 0] Tc,
    input wire[7 : 0] Td,
    
    input wire[7 : 0] Cb,
    input wire[7 : 0] Cr,
    
    output wire[7 : 0] mask
);

    assign mask = (Cb > Ta && Cb < Tb && Cr > Tc && Cr < Td) ? 8'd255 : 0;
endmodule
