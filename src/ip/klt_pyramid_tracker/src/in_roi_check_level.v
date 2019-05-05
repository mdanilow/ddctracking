`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2018 12:19:28 AM
// Design Name: 
// Module Name: in_roi_check
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

//left up corner pixel is [1, 1]

module in_roi_check_level #(

    parameter NEIGH_SIZE = 10,
    parameter BORDER_WIDTH = 5
)
(  

    input center_vsync_in,
    input clk,
    input [11 : 0] x_pos,
    input [10 : 0] y_pos,
    input [11 : 0] level_x0,
    input [10 : 0] level_y0,

    output in_roi,
    output in_extended_roi,
    output roi_end,
    output halt_me_pls
);
    
    reg roi_end_reg = 0;
    reg roi_end_impulse_state = 0;
    reg roi_ended = 0;
    reg [11 : 0] latched_x0_int = 0;        //x0, y0 are updated a moment after we leave ROI, but we want to have pre-update coords for valid in_extended_roi flag generation
    reg [10 : 0] latched_y0_int = 0;

    
    //roi_end impulse generation
    always @(negedge clk)
    begin
        
        if(x_pos == (level_x0 + NEIGH_SIZE) && y_pos == (level_y0 + NEIGH_SIZE) )
        begin
        
            roi_end_reg <= 1;
            roi_end_impulse_state <= 1;
        end
        
        if(roi_end_impulse_state == 1)
        begin
            
            roi_end_reg <= 0;
            roi_end_impulse_state <= 0;
        end
    end
    
    
    always @(posedge clk)
    begin
        
        if(roi_end == 1)
            roi_ended <= 1;
            
        if(center_vsync_in == 1)
        begin
        
            latched_x0_int <= level_x0;
            latched_y0_int <= level_y0;
            roi_ended <= 0;
        end
    end
    
    
    assign roi_end = roi_end_reg;
    assign in_roi = (x_pos >= level_x0 - NEIGH_SIZE) && (x_pos <= level_x0 + NEIGH_SIZE) && (y_pos >= level_y0 - NEIGH_SIZE) && (y_pos <= level_y0 + NEIGH_SIZE) && (roi_ended == 0);
    assign in_extended_roi = (x_pos >= latched_x0_int - (NEIGH_SIZE + BORDER_WIDTH)) && (x_pos <= latched_x0_int + (NEIGH_SIZE + BORDER_WIDTH)) && (y_pos >= latched_y0_int - (NEIGH_SIZE + BORDER_WIDTH)) && (y_pos <= latched_y0_int + (NEIGH_SIZE + BORDER_WIDTH));
    assign halt_me_pls = (y_pos == level_y0 - NEIGH_SIZE) && (x_pos >= level_x0 - NEIGH_SIZE - 3);
endmodule
