`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2018 03:36:30 PM
// Design Name: 
// Module Name: mux
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


module mux(

    input [2 : 0] addr,
    
    input [23 : 0] pixel_in_0,
    input [23 : 0] pixel_in_1,
    input [23 : 0] pixel_in_2,
    input [23 : 0] pixel_in_3,
    input [23 : 0] pixel_in_4,
    input [23 : 0] pixel_in_5,
    input [23 : 0] pixel_in_6,
    input [23 : 0] pixel_in_7,
    
    input de_in_0,
    input de_in_1,
    input de_in_2,
    input de_in_3,
    input de_in_4,
    input de_in_5,
    input de_in_6,
    input de_in_7,
    
    input h_sync_0,
    input h_sync_1,
    input h_sync_2,
    input h_sync_3,
    input h_sync_4,
    input h_sync_5,
    input h_sync_6,
    input h_sync_7,
    
    input v_sync_0,
    input v_sync_1,
    input v_sync_2,
    input v_sync_3,
    input v_sync_4,
    input v_sync_5,
    input v_sync_6,
    input v_sync_7,
    
    output [23 : 0] pixel_out,
    output de_out,
    output h_sync_out,
    output v_sync_out
);

    wire [23 : 0] pixel_mux [7 : 0];
    wire de_mux [7 : 0];
    wire h_sync_mux [7 : 0];
    wire v_sync_mux [7 : 0];
    
    assign pixel_mux[0] = pixel_in_0;
    assign pixel_mux[1] = pixel_in_1;
    assign pixel_mux[2] = pixel_in_2;
    assign pixel_mux[3] = pixel_in_3;
    assign pixel_mux[4] = pixel_in_4;
    assign pixel_mux[5] = pixel_in_5;
    assign pixel_mux[6] = pixel_in_6;
    assign pixel_mux[7] = pixel_in_7;
    
    assign de_mux[0] = de_in_0;
    assign de_mux[1] = de_in_1;
    assign de_mux[2] = de_in_2;
    assign de_mux[3] = de_in_3;
    assign de_mux[4] = de_in_4;
    assign de_mux[5] = de_in_5;
    assign de_mux[6] = de_in_6;
    assign de_mux[7] = de_in_7;
    
    assign h_sync_mux[0] = h_sync_0;
    assign h_sync_mux[1] = h_sync_1;
    assign h_sync_mux[2] = h_sync_2;
    assign h_sync_mux[3] = h_sync_3;
    assign h_sync_mux[4] = h_sync_4;
    assign h_sync_mux[5] = h_sync_5;
    assign h_sync_mux[6] = h_sync_6;
    assign h_sync_mux[7] = h_sync_7;
    
    assign v_sync_mux[0] = v_sync_0;
    assign v_sync_mux[1] = v_sync_1;
    assign v_sync_mux[2] = v_sync_2;
    assign v_sync_mux[3] = v_sync_3;
    assign v_sync_mux[4] = v_sync_4;
    assign v_sync_mux[5] = v_sync_5;
    assign v_sync_mux[6] = v_sync_6;
    assign v_sync_mux[7] = v_sync_7;
    
    assign pixel_out = pixel_mux[addr];
    assign de_out = de_mux[addr];
    assign h_sync_out = h_sync_mux[addr];
    assign v_sync_out = v_sync_mux[addr];
endmodule
