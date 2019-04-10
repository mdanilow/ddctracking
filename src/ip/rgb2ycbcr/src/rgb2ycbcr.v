`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2018 03:02:41 PM
// Design Name: 
// Module Name: rgb2ycbcr
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


module rgb2ycbcr(
    
    input clk,
    input de_in,
    input h_sync_in,
    input v_sync_in,
    input [23 : 0] pixel_in,
    
    output de_out,
    output h_sync_out,
    output v_sync_out,
    output [23 : 0] ycbcr_out,
    output [8 : 0] y,
    output [8 : 0] cb,
    output [8 : 0] cr
);
    
    wire signed [17 : 0] R;
    wire signed [17 : 0] G;
    wire signed [17 : 0] B;
    
    wire signed [8 : 0] Y_predelay;
    wire signed [8 : 0] Y;
    wire signed [8 : 0] Cb;
    wire signed [8 : 0] Cr;
    
    wire signed [17 : 0] a11 = 18'b001001100100010111;
    wire signed [17 : 0] a12 = 18'b010010110010001011;
    wire signed [17 : 0] a13 = 18'b000011101001011110;
    wire signed [17 : 0] a21 = 18'b111010100110011011;
    wire signed [17 : 0] a22 = 18'b110101011001100101;
    wire signed [17 : 0] a23 = 18'b010000000000000000;
    wire signed [17 : 0] a31 = 18'b010000000000000000;
    wire signed [17 : 0] a32 = 18'b110010100110100010;
    wire signed [17 : 0] a33 = 18'b111101011001011110;
    
    wire signed [35 : 0] m11;
    wire signed [35 : 0] m12;
    wire signed [35 : 0] m13;
    wire signed [35 : 0] m21;
    wire signed [35 : 0] m22;
    wire signed [35 : 0] m23;
    wire signed [35 : 0] m31;
    wire signed [35 : 0] m32;
    wire signed [35 : 0] m33;
    
    wire signed [8 : 0] m11_int;
    wire signed [8 : 0] m12_int;
    wire signed [8 : 0] m13_int;
    wire signed [8 : 0] m21_int;
    wire signed [8 : 0] m22_int;
    wire signed [8 : 0] m23_int;
    wire signed [8 : 0] m31_int;
    wire signed [8 : 0] m32_int;
    wire signed [8 : 0] m33_int;
    
    wire signed [8 : 0] m13_int_d;
    wire signed [8 : 0] m23_int_d;
    wire signed [8 : 0] m33_int_d;
    
    assign m11_int = m11[25-:9];
    assign m12_int = m12[25-:9];
    assign m13_int = m13[25-:9];
    assign m21_int = m21[25-:9];
    assign m22_int = m22[25-:9];
    assign m23_int = m23[25-:9];
    assign m31_int = m31[25-:9];
    assign m32_int = m32[25-:9];
    assign m33_int = m33[25-:9];
   
    wire signed [8 : 0] s11;
    wire signed [8 : 0] s21;
    wire signed [8 : 0] s22;
    wire signed [8 : 0] s23;
    wire signed [8 : 0] s31;
    wire signed [8 : 0] s32;
    wire signed [8 : 0] s33;
    
    assign R = {10'b0, pixel_in[23 : 16]};
    assign G = {10'b0, pixel_in[15 : 8]};
    assign B = {10'b0, pixel_in[7 : 0]};

//mnożarki
    mult_gen_0 A11(
    
        .CLK(clk),
        .A(R),
        .B(a11),
        .P(m11)
    );
    
    mult_gen_0 A12(
    
        .CLK(clk),
        .A(G),
        .B(a12),
        .P(m12)
    );
        
    mult_gen_0 A13(
            
        .CLK(clk),
        .A(B),
        .B(a13),
        .P(m13)
    );
    
    mult_gen_0 A21(
                
        .CLK(clk),
        .A(R),
        .B(a21),
        .P(m21)
    );
        
    mult_gen_0 A22(
                    
        .CLK(clk),
        .A(G),
        .B(a22),
        .P(m22)
    );
    
    mult_gen_0 A23(
                        
        .CLK(clk),
        .A(B),
        .B(a23),
        .P(m23)
    );
    
    mult_gen_0 A31(
                    
        .CLK(clk),
        .A(R),
        .B(a31),
        .P(m31)
    );
        
    mult_gen_0 A32(
                    
        .CLK(clk),
        .A(G),
        .B(a32),
        .P(m32)
    );
    
    mult_gen_0 A33(
                        
        .CLK(clk),
        .A(B),
        .B(a33),
        .P(m33)
    );
    
//dodawacze Y

    c_addsub_0 S11(
    
        .CLK(clk),
        .A(m11_int),
        .B(m12_int),
        .S(s11)
    );
    
    modul_puz #(
        
        .N(9),
        .DELAY(1)
    )
    delay_Y1(
        
        .clk(clk),
        .in(m13_int),
        .out(m13_int_d)
    );
        
    c_addsub_0 S12(
        
        .CLK(clk),
        .A(s11),
        .B(m13_int_d),
        .S(Y_predelay)
    );
 
    modul_puz #(
        
        .N(9),
        .DELAY(1)
    )
    delay_Y2(
        
        .clk(clk),
        .in(Y_predelay),
        .out(Y)
    );  
//dodawacze Cb
    
    c_addsub_0 S21(
    
        .CLK(clk),
        .A(m21_int),
        .B(m22_int),
        .S(s21)
    );
    
    modul_puz #(
            
        .N(9),
        .DELAY(1)
    )
    delay_Cb1(
        
        .clk(clk),
        .in(m23_int),
        .out(m23_int_d)
    );
    
    c_addsub_0 S22(
    
        .CLK(clk),
        .A(s21),
        .B(m23_int_d),
        .S(s22)
    );
    
    c_addsub_0 S23(
    
        .CLK(clk),
        .A(s22),
        .B({1'b0, 8'b10000000}),
        .S(Cb)
    );
    
//dodawacze Cr

     c_addsub_0 S31(
    
        .CLK(clk),
        .A(m31_int),
        .B(m32_int),
        .S(s31)
    );
    
    modul_puz #(
            
        .N(9),
        .DELAY(1)
    )
    delay_Cr1(
        
        .clk(clk),
        .in(m33_int),
        .out(m33_int_d)
    );
    
    c_addsub_0 S32(
    
        .CLK(clk),
        .A(s31),
        .B(m33_int_d),
        .S(s32)
    );
    
    c_addsub_0 S33(
    
        .CLK(clk),
        .A(s32),
        .B({1'b0, 8'b10000000}),
        .S(Cr)
    );   
    
    assign y = Y;
    assign cb = Cb;
    assign cr = Cr;
    assign ycbcr_out = {Y, Cb, Cr};
    
    modul_puz #(
        
        .N(3),
        .DELAY(6)
    )
    sync_delay(
    
        .clk(clk),
        .in({de_in, h_sync_in, v_sync_in}),
        .out({de_out, h_sync_out, v_sync_out})
    );
endmodule
