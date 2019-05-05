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


module context_3x3 #(
    
    parameter H_SIZE = 2200//800 //83 //1650
)
(

    input clk,
    input [7 : 0] pixel_in,
    input de_in,
    input h_sync_in,
    input v_sync_in,
    
    output context_valid,
    output [10 : 0] center,
    output [10 : 0] up,
    output [10 : 0] down,
    output [10 : 0] left,
    output [10 : 0] right
);
    
    //bo nie zapisuje de oraz pixel tak jak trzeba
    reg synch_de_in = 0;
    reg synch_h_sync_in = 0;
    reg synch_v_sync_in = 0;
    reg [7 : 0] synch_pixel_in = 0;

    reg [10:0] D11 = 0;
    reg [10:0] D12 = 0;
    reg [10:0] D13 = 0;
   
    reg [10:0] D21 = 0;
    reg [10:0] D22 = 0;
    reg [10:0] D23 = 0;
   
    reg [10:0] D31 = 0;
    reg [10:0] D32 = 0;
    reg [10:0] D33 = 0;
    
    wire [10 : 0] line1_out;
    wire [10 : 0] line2_out;
    
    
//    //synchronize input
//    always @(negedge clk)
//    begin
    
//        synch_de_in <= de_in;
//        synch_v_sync_in <= v_sync_in;
//        synch_h_sync_in <= h_sync_in;
//        synch_pixel_in <= pixel_in;
//    end
    
    
    //generate context
    always @(posedge clk)
    begin
        
//        D11 <= {synch_pixel_in, synch_de_in, synch_h_sync_in, synch_v_sync_in};
        D11 <= {pixel_in, de_in, h_sync_in, v_sync_in};
        D12 <= D11;
        D13 <= D12;
        D21 <= line1_out;
        D22 <= D21;
        D23 <= D22;
        D31 <= line2_out;
        D32 <= D31;
        D33 <= D32;
    end
    
    
    delayLinieBRAM_WP line1(

        .clk(clk),
        .rst(1'b0),
        .ce(1'b1),
        .h_size(H_SIZE-3),
        .din(D13),
        .dout(line1_out)
    );
    
    
    delayLinieBRAM_WP line2(
    
        .clk(clk),
        .rst(1'b0),
        .ce(1'b1),
        .h_size(H_SIZE-3),
        .din(D23),
        .dout(line2_out)
    );
    
    
    assign context_valid = D11[2]&D12[2]&D13[2]&D21[2]&D22[2]&D23[2]&D31[2]&D32[2]&D33[2];
    
    assign center = D22;
    assign down = D12;
    assign up = D32;
    assign right = D21;
    assign left = D23;  
endmodule

