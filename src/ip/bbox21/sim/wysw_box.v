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


module wysw_box(

    input clk,
    input de_in,
    input hsync_in,
    input vsync_in,
    input [11 : 0] point_x0,  //left-up corner of box
    input [10 : 0] point_y0,
    input [23 : 0] pixel_in,
    
    output de_out,
    output hsync_out,
    output vsync_out,
    output [23 : 0] pixel_out
);
    
    reg [11 : 0] x_pos = 1;
    reg [10 : 0] y_pos = 1;
    
    wire [11 : 0] x0;
    wire [10 : 0] y0;
    wire [10 : 0] width = 11'd21;
    wire [10 : 0] height = 11'd21;

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
    
    
    assign x0 = point_x0 - 12'd10;
    assign y0 = point_y0 - 11'd10;
    
    
    assign de_out = de_in;
    assign hsync_out = hsync_in;
    assign vsync_out = vsync_in;
    assign pixel_out = ((x_pos >= x0 && x_pos <= x0+width && y_pos == y0) || (x_pos >= x0 && x_pos <= x0+width && y_pos == y0+height) || (y_pos >= y0 && y_pos <= y0+height && x_pos == x0) || (y_pos >= y0 && y_pos <= y0+height && x_pos == x0+width)) ? {8'hff, 8'b0, 8'b0} : pixel_in;
endmodule
