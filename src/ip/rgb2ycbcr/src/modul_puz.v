`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2018 12:54:17 AM
// Design Name: 
// Module Name: modul_puz
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


module modul_puz #(
    
    parameter N = 8,
    parameter DELAY = 2
)
(
    
    input clk,
    input [N-1 : 0] in,
    output [N-1 : 0] out
);

    wire [N-1 : 0] data [DELAY : 0];
    
    genvar i;
    generate
        
        for(i = 0; i < DELAY; i = i+1)
        begin
            
            puz #(
                
                .N(N)
            )
            puz_i(
                
                .clk(clk),
                .in(data[i]),
                .out(data[i+1])
            );
        end
    endgenerate
    
    assign data[0] = in;
    assign out = data[DELAY];
endmodule
