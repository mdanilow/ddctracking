`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2019 05:29:38 AM
// Design Name: 
// Module Name: scale2x
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


module scale2x #(
    
    parameter H_SIZE = 800, //800 //83 //1650
    parameter CLK_PHASE = 0
)
(
    
    input clk,
    input [7 : 0] pixel_in,
    input de_in,
    input hsync_in,
    input vsync_in,
    
    output clk_2x,
    output [7 : 0] pixel_out,
    output de_out,
    output hsync_out,
    output vsync_out,
    
    output [7 : 0] A11,
    output [7 : 0] A12,
    output [7 : 0] A21,
    output [7 : 0] A22,
    output context_2x2_valid,
    output [9 : 0] A11pA12,
    output [9 : 0] A21pA22,
    output [9 : 0] sum,
    output [7 : 0] round_sum
);
    
    wire context_2x2_vsync;
    wire context_2x2_hsync;
    wire context_2x2_valid;
    wire hsync_in_delayed;
    wire de_in_delayed;
    
    wire [7 : 0] A11;
    wire [7 : 0] A12;
    wire [7 : 0] A21;
    wire [7 : 0] A22;
    
    wire [9 : 0] A11pA12;
    wire [9 : 0] A21pA22;
    wire [9 : 0] sum;
    wire [7 : 0] round_sum;
    
    reg [7 : 0] output_reg = 0;
    reg clk_2x_reg = CLK_PHASE;
    reg ignore_this_row = 0;
    
    //state machine for ignoring every even row
    reg [1 : 0] state = 0;
    
    
    always @(posedge context_2x2_hsync)
    begin
    
        if(state == 2)
            ignore_this_row <= ~ignore_this_row;       
    end
    
    
    always @(posedge clk)
    begin
    
        if(vsync_out)
        begin
            state <= 1;     //new frame
            ignore_this_row <= 0;
        end
            
        if(state == 1 && context_2x2_valid)
            state <= 2;     //correct row start
        
        clk_2x_reg <= ~clk_2x_reg;
    end
    
    
    always @(posedge clk_2x)
    begin
        
        output_reg <= round_sum;
    end
    
    
    context_2x2 #(
        
        .H_SIZE(H_SIZE)
    )
    con(
    
        .clk(clk),
        .pixel_in(pixel_in),
        .de_in(de_in),
        .h_sync_in(hsync_in),
        .v_sync_in(vsync_in),
        
        .context_valid(context_2x2_valid),
        .A11_vsync(context_2x2_vsync),
        .A11_hsync(context_2x2_hsync),
        .A11(A11),
        .A12(A12),
        .A21(A21),
        .A22(A22)
    );


    adder_10p10e10 A11pA12_adder(
    
        .CLK(clk),
        .A({2'b00, A11}),
        .B({2'b00, A12}),
        .S(A11pA12)
    );     
    
    
    adder_10p10e10 A21pA22_adder(
    
        .CLK(clk),
        .A({2'b00, A21}),
        .B({2'b00, A22}),
        .S(A21pA22)
    );  
    
    
    adder_10p10e10 sum_adder(
    
        .CLK(clk),
        .A(A11pA12),
        .B(A21pA22),
        .S(sum)
    ); 
    
    
    modul_puz #(
        
        .N(3),
        .DELAY(2)
    )
    synch_delay(
        
        .clk(clk),
        .in({context_2x2_valid, context_2x2_hsync, context_2x2_vsync}),
        .out({de_in_delayed, hsync_in_delayed, vsync_out})
    );
    
    
    assign round_sum = sum[1] ? (sum[9-:8] + 1) : sum[9-:8];
    assign clk_2x = clk_2x_reg;
    assign pixel_out = output_reg;
    assign de_out = de_in_delayed & ~ignore_this_row;
    assign hsync_out = hsync_in_delayed & ~ignore_this_row;
endmodule
