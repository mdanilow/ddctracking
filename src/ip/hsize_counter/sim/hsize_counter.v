`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2019 23:59:04
// Design Name: 
// Module Name: hsize_counter
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


module hsize_counter(
    
    input clk,
    input de,
    input hsync,
    input vsync,
    
    output reg [11 : 0] counter = 0,
    output reg [11 : 0] max = 0,
    output reg [2 : 0] state = 0
);
    

    always @(posedge clk)
    begin
    
        if(counter >= max)
            max <= counter;
    
        if(state == 0)
        begin
            
            if(hsync == 1)
            begin
            
                counter <= 0;
                state <= 1;
            end
        end
        
        else if(state == 1)
        begin
        
            counter <= counter + 1;
            
            if(hsync == 0)
                state <= 2;
        end
        
        else if(state == 2)
        begin
            
            counter <= counter + 1;
            
            if(hsync == 1)
                state <= 0;
        end

    end
endmodule
