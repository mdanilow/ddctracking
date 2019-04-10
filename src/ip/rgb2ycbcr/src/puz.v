`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2018 12:50:55 AM
// Design Name: 
// Module Name: puz
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


module puz #(

    parameter N = 8
)
(
    input clk,
    input [N-1 : 0] in,
    output [N-1 : 0] out
);    
    
    reg [N-1 : 0] state = 0;
    
    always @(posedge clk)
    begin
        
        state <= in;
    end
    
    assign out = state;
endmodule
