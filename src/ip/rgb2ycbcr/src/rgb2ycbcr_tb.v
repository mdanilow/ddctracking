`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2018 09:19:45 PM
// Design Name: 
// Module Name: rgb2ycbcr_tb
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


module rgb2ycbcr_tb(

);

    reg clk = 0;
    reg de_in = 0;
    reg h_sync_in = 0;
    reg v_sync_in = 0;
    
    wire de_out;
    wire h_sync_out;
    wire v_sync_out;
    
    wire [8 : 0] y;
    wire [8 : 0] cb;
    wire [8 : 0] cr;
    
    wire [7 : 0] R = 8'b01111011;
    wire [7 : 0] G = 8'b01010011;
    wire [7 : 0] B = 8'b11001001;
    
    wire [23 : 0] pixel_in = {R, G, B};
    
    initial
    begin
        
        while(1)
        begin
        
            #1;
            clk <= 1;

            #1;
            clk <= 0;
         
        end
    end
    
    rgb2ycbcr test(
    
        .clk(clk),
        .h_sync_in(clk),
        .v_sync_in(clk),
        .de_in(clk),
        .pixel_in(pixel_in),
        
        .h_sync_out(h_sync_out),
        .v_sync_out(v_sync_out),
        .de_out(de_out),
        .y(y),
        .cb(cb),
        .cr(cr)
    );
endmodule
