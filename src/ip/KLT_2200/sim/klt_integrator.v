`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2018 10:34:33 PM
// Design Name: 
// Module Name: klt_integrator
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


module klt_integrator #(
    
    parameter BUFF_LENGTH = 28
)
(
    
    input clk,
    input in_roi,
    input roi_end,
    input first_frame,
    input end_of_frame,
    input [7 : 0] prev_center_pixel,
    input [7 : 0] center_pixel,
    input [7 : 0] left_pixel,
    input [7 : 0] right_pixel,
    input [7 : 0] up_pixel,
    input [7 : 0] down_pixel,
    
    output data_valid,
    output [25 : 0] G11,
    output [25 : 0] G12,
    output [25 : 0] G21,
    output [25 : 0] G22,
    output [25 : 0] b1,
    output [25 : 0] b2
);

reg [7 : 0] synch_center_pixel = 0;
reg [7 : 0] synch_left_pixel = 0;
reg [7 : 0] synch_right_pixel = 0;
reg [7 : 0] synch_up_pixel = 0;
reg [7 : 0] synch_down_pixel = 0;
reg [7 : 0] synch_prev_center_pixel = 0;

reg [7 : 0] neg_synch_center_pixel = 0;
reg [7 : 0] neg_synch_left_pixel = 0;
reg [7 : 0] neg_synch_right_pixel = 0;
reg [7 : 0] neg_synch_up_pixel = 0;
reg [7 : 0] neg_synch_down_pixel = 0;
reg [7 : 0] neg_synch_prev_center_pixel = 0;

wire integration_enable;
wire integration_enable_delay;
wire enable_computation;
wire synch_enable_computation;

wire synch_clear_computation;

wire [8 : 0] Ix2;
wire [8 : 0] Iy2;
wire [8 : 0] dI;

wire [17 : 0] dG11; //Ix^2
wire [17 : 0] dG12_G21; //Ix*Iy
wire [17 : 0] dG22; //Iy^2

wire [17 : 0] db1; //dI*Ix
wire [17 : 0] db2; //dI*Iy

reg [25 : 0] G11_reg = 0;
reg [25 : 0] G12_reg = 0;
reg [25 : 0] G22_reg = 0;

reg [25 : 0] b1_reg = 0;
reg [25 : 0] b2_reg = 0;

wire [25 : 0] G11_sum;
wire [25 : 0] G12_sum;
wire [25 : 0] G22_sum;

wire [25 : 0] b1_sum;
wire [25 : 0] b2_sum;

reg roi_ended = 0;  //sets on roi end, clears on frame end

//synchronize inputs
always @(negedge clk)
begin
    
    neg_synch_center_pixel <= center_pixel;
    neg_synch_left_pixel <= left_pixel;
    neg_synch_right_pixel <= right_pixel;
    neg_synch_down_pixel <= down_pixel;
    neg_synch_up_pixel <= up_pixel;
    neg_synch_prev_center_pixel <= prev_center_pixel;
end

//synchronize inputs with positive edge clock
always @(posedge clk)
begin

    synch_center_pixel <= neg_synch_center_pixel;
    synch_left_pixel <= neg_synch_left_pixel;
    synch_right_pixel <= neg_synch_right_pixel;
    synch_down_pixel <= neg_synch_down_pixel;
    synch_up_pixel <= neg_synch_up_pixel;
    synch_prev_center_pixel <= neg_synch_prev_center_pixel;
end

//delay "enable_computation" flag due to synchronization of inputs
modul_puz #(

    .N(1),
    .DELAY(1)
)
synch_comp(

    .clk(clk),
    .in(enable_computation),
    .out(synch_enable_computation)
);

//delayed "integration_enable" because we need to compute up to 2 ticks after end of roi (adders/multipliers delays)
modul_puz #(

    .N(1),
    .DELAY(2)
)
int_delay(

    .clk(clk),
    .in(integration_enable),
    .out(integration_enable_delay)
);

//latency 1
sub_8m8 Ix_sub(
    
    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(synch_right_pixel),
    .B(synch_left_pixel),
    .S(Ix2),
    .CE(synch_enable_computation)
);

//latency 1
sub_8m8 Iy_sub(
    
    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(synch_down_pixel),
    .B(synch_up_pixel),
    .S(Iy2),
    .CE(synch_enable_computation)
);

//latency 1
sub_8m8 dI_sub(
    
    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(synch_prev_center_pixel),
    .B(synch_center_pixel),
    .S(dI),
    .CE(synch_enable_computation)
);

//latency 1
mult_9t9 Ix_sq(
    
    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(Ix2),
    .B(Ix2),
    .CE(synch_enable_computation),
    .P(dG11)
);

//latency 1
mult_9t9 Ix_Iy(
    
    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(Ix2),
    .B(Iy2),
    .CE(synch_enable_computation),
    .P(dG12_G21)
);

//latency 1
mult_9t9 Iy_sq(
    
    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(Iy2),
    .B(Iy2),
    .CE(synch_enable_computation),
    .P(dG22)
);

//latency 1
mult_9t9 db1_mult(

    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(dI),
    .B(Ix2),
    .CE(synch_enable_computation),
    .P(db1)
);

//latency 1
mult_9t9 db2_mult(

    .SCLR(synch_clear_computation),
    .CLK(clk),
    .A(dI),
    .B(Iy2),
    .CE(synch_enable_computation),
    .P(db2)
);


//latency 0
add_26p18 G11_acc(

    .CE(synch_enable_computation),
    .A(G11_reg),
    .B(dG11),
    .S(G11_sum)
);


add_26p18 G12_acc(

    .CE(synch_enable_computation),
    .A(G12_reg),
    .B(dG12_G21),
    .S(G12_sum)
);


add_26p18 G22_acc(

    .CE(synch_enable_computation),
    .A(G22_reg),
    .B(dG22),
    .S(G22_sum)
);


add_26p18 b1_acc(

    .CE(synch_enable_computation),
    .A(b1_reg),
    .B(db1),
    .S(b1_sum)
);


add_26p18 b2_acc(

    .CE(synch_enable_computation),
    .A(b2_reg),
    .B(db2),
    .S(b2_sum)
);


//for G matrix accumulation
always @(posedge clk)
begin
    
    if(synch_enable_computation == 1)
    begin
    
        G11_reg <= G11_sum;
        G12_reg <= G12_sum;
        G22_reg <= G22_sum;
        
        b1_reg <= b1_sum;
        b2_reg <= b2_sum;
    end
    
    if(end_of_frame == 1)
    begin
    
        G11_reg <= 0;
        G12_reg <= 0;
        G22_reg <= 0;
        
        b1_reg <= 0;
        b2_reg <= 0;
        
        roi_ended <= 0;
    end
    
    if(roi_end == 1)
        roi_ended <= 1;
        
end


assign integration_enable = in_roi & ~first_frame;
assign enable_computation = integration_enable | integration_enable_delay;
assign synch_clear_computation = ~synch_enable_computation;

assign data_valid = ~synch_enable_computation & roi_ended;
assign G11 = G11_reg;
assign G12 = G12_reg;
assign G21 = G12_reg;
assign G22 = G22_reg;

assign b1 = b1_reg;
assign b2 = b2_reg;

//assign dg11 = dG11;
//assign dg12 = dG12_G21;
//assign dg22 = dG22;
//assign ix = Ix2;
//assign iy = Iy2;

//assign sync_prev_center_pixel = synch_prev_center_pixel;
//assign sync_center_pixel = synch_center_pixel;
//assign sync_up_pixel = synch_up_pixel;
//assign sync_down_pixel = synch_down_pixel;
//assign sync_left_pixel = synch_left_pixel;
//assign sync_right_pixel = synch_right_pixel;

endmodule
