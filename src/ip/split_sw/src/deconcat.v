`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2019 17:56:57
// Design Name: 
// Module Name: deconcat
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


module deconcat(
    
    input [3 : 0] SW,
    
    output SW0,
    output SW1,
    output SW2,
    output SW3
);

    assign SW0 = SW[0];
    assign SW1 = SW[1];
    assign SW2 = SW[2];
    assign SW3 = SW[3];
endmodule
