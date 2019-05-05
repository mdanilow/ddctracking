`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2019 05:08:40 PM
// Design Name: 
// Module Name: pixel_position
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


module pixel_position(

    input clk,
    input de_in,
    input hsync_in,
    input vsync_in,
    
    output [11 : 0] x,
    output [10 : 0] y,
    output first_frame
);


    reg [10 : 0] x_pos = 1;
    reg [9 : 0] y_pos = 1;
    reg first_frame_reg = 1;
    reg valid_pixel_existed = 0;
    
    
    always @(posedge clk)
    begin
        
        if(vsync_in == 1)
        begin
            
            if(valid_pixel_existed)
                first_frame_reg <= 0;
                
            x_pos <= 1;
            y_pos <= 1;
        end
        
        if(de_in == 1)
        begin
            valid_pixel_existed <= 1;
            x_pos <= x_pos + 1;        
        end
        
        if(hsync_in == 1 && x_pos != 1)
        begin
        
            x_pos <= 1;
            y_pos <= y_pos + 1;
        end  
    end
    
    
    assign x = x_pos;
    assign y = y_pos;
    assign first_frame = first_frame_reg;
endmodule
