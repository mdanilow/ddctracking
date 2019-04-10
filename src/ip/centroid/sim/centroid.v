`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2018 11:50:20 AM
// Design Name: 
// Module Name: centroid
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


module centroid(
    input clk,
    input ce,
    input rst,
    input de,
    input hsync,
    input vsync,
    input mask,
    
    output [31 : 0] x,
    output [31 : 0] y,
    output [19 : 0] m_00,
    output [31 : 0] m_10,
    output [31 : 0] m_01  
);
    
    wire eof;
    wire prev_vsync;
    wire [31 : 0] x_temp;
    wire [31 : 0] y_temp;
    wire qv_x;
    wire qv_y;
    
    reg [10 : 0] x_pos = 0;
    reg [9 : 0] y_pos = 0;
    reg [19 : 0] m00 = 0;
    reg [31 : 0] m01 = 0;
    reg [31 : 0] m10 = 0;
    reg [31 : 0] x_reg = 0;
    reg [31 : 0] y_reg = 0;
    
    always @(posedge clk)
    begin
        
        if(vsync == 1)
        begin
            
            x_pos <= 1;
            y_pos <= 1;
        end
        
        if(de == 1)
            x_pos <= x_pos + 1;
        
        if(hsync == 1 && x_pos != 1)
        begin
        
            x_pos <= 1;
            y_pos <= y_pos + 1;
        end
    end
    
    
    modul_puz #(
        
        .N(1),
        .DELAY(1)
    )
    delay(
        
        .clk(clk),
        .in(vsync),
        .out(prev_vsync)
    );
    
    
    always @(posedge clk)
    begin
    
        if(qv_y == 1)
        begin
            
            y_reg <= y_temp;
        end
    
        if(qv_x == 1)
        begin
        
            x_reg <= x_temp;
        end
        
        if(eof == 1)
        begin
            m10 <= 0;
            m01 <= 0;
            m00 <= 0;
        end
        
        else if(de == 1) 
        begin
            
            if(mask == 1)
            begin
            
                m10 <= m10 + x_pos;
                m01 <= m01 + y_pos;
            end
            
            m00 <= m00 + mask;
        end
    end
    
    divider_32_20_0 divx(
        
        .clk(clk),
        .dividend(m10),
        .divisor(m00),
        .quotient(x_temp),
        .start(eof),
        .qv(qv_x)
    );
    
    divider_32_20_0 divy(
        
        .clk(clk),
        .dividend(m01),
        .divisor(m00),
        .quotient(y_temp),
        .start(eof),
        .qv(qv_y)
    );

    assign eof = (prev_vsync == 1'b0 && vsync == 1'b1) ? 1'b1 : 1'b0;
    
    assign x = x_reg;
    assign y = y_reg;
    assign m_00 = m00;
    assign m_10 = m10;
    assign m_01 = m01;
endmodule
