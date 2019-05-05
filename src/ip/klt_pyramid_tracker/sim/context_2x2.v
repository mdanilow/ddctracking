`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2018 06:49:52 PM
// Design Name: 
// Module Name: context_3x3
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


module context_2x2 #(
    
    parameter H_SIZE = 800//800 //83 //1650
)
(

    input clk,
    input [7 : 0] pixel_in,
    input de_in,
    input h_sync_in,
    input v_sync_in,
    
    output context_valid,
    output A11_hsync,
    output A11_vsync,
    output [7 : 0] A11,
    output [7 : 0] A12,
    output [7 : 0] A21,
    output [7 : 0] A22
);
    
    //bo nie zapisuje de oraz pixel tak jak trzeba
    reg synch_de_in = 0;
    reg synch_h_sync_in = 0;
    reg synch_v_sync_in = 0;
    reg [7 : 0] synch_pixel_in = 0;

    reg [10:0] D11 = 0;
    reg [10:0] D12 = 0;
   
    reg [10:0] D21 = 0;
    reg [10:0] D22 = 0;
    
    wire [10 : 0] line1_out;
    
    
    //synchronize input
    always @(negedge clk)
    begin
    
        synch_de_in <= de_in;
        synch_v_sync_in <= v_sync_in;
        synch_h_sync_in <= h_sync_in;
        synch_pixel_in <= pixel_in;
    end
    
    
    //generate context
    always @(posedge clk)
    begin
        
        D11 <= {synch_pixel_in, synch_de_in, synch_h_sync_in, synch_v_sync_in};
        D12 <= D11;
        D21 <= line1_out;
        D22 <= D21;
    end
    
    
    delayLinieBRAM_WP line1(

        .clk(clk),
        .rst(1'b0),
        .ce(1'b1),
        .h_size(H_SIZE-2),
        .din(D12),
        .dout(line1_out)
    );
    
    
    assign context_valid = D11[2]&D12[2]&D21[2]&D22[2];
    
    assign A11 = D22[10-:8];
    assign A12 = D21[10-:8];
    assign A21 = D12[10-:8];
    assign A22 = D11[10-:8];  
    
    assign A11_vsync = D22[0];
    assign A11_hsync = D22[1];
endmodule

