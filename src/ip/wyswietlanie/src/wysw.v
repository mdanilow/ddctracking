`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2018 06:21:49 PM
// Design Name: 
// Module Name: wysw
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


module wysw(

    input clk,
    input de_in,
    input hsync_in,
    input vsync_in,
    input [31 : 0] x,
    input [31 : 0] y,
    input [23 : 0] pixel_in,
    
    output de_out,
    output hsync_out,
    output vsync_out,
    output [31 : 0] x_temp,
    output [31 : 0] y_temp,
    output [23 : 0] pixel_out
);
    
    reg [31 : 0] x_pos = 1;
    reg [31 : 0] y_pos = 1;

    always @(posedge clk)
    begin
        
        if(vsync_in == 1)
        begin
            
            x_pos <= 1;
            y_pos <= 1;
        end
        
        if(de_in == 1)
            x_pos <= x_pos + 1;
        
        if(hsync_in == 1 && x_pos != 1)
        begin
        
            x_pos <= 1;
            y_pos <= y_pos + 1;
        end  
    end
    
    assign de_out = de_in;
    assign hsync_out = hsync_in;
    assign vsync_out = vsync_in;
    assign pixel_out = (x_pos == x || y_pos == y) ? {8'hff, 8'b0, 8'b0} : pixel_in;
endmodule
