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

module in_roi_check #(

    parameter NEIGH_SIZE = 10,
    parameter BORDER_WIDTH = 5
)
(  
    input [11 : 0] set_x0,
    input [10 : 0] set_y0,
    input enable,
    input reset_position,
    input center_vsync_in,
    input clk,
    input [11 : 0] x_pos,
    input [10 : 0] y_pos,
    input d_ready,
    input [87 : 0] dx,
    input [87 : 0] dy,
    
    output [11 : 0] x0_int_out,
    output [10 : 0] y0_int_out,
    output in_roi,
    output in_extended_roi,
    output roi_end,
    output [11 : 0] latched_x0_int,
    output [10 : 0] latched_y0_int,
    output updated_in_this_frame
);
    
    wire d_ready_del;
    
    reg updated_in_this_frame = 0;
    
    reg roi_end_reg = 0;
    reg roi_end_impulse_state = 0;
    reg roi_ended = 0;
    
//    reg [87 : 0] x0 = {59'd82, 1'b1, 28'b0};   //72.5
//    reg [87 : 0] y0 = {59'd82, 1'b1, 28'b0};    //72.5
    reg [87 : 0] x0 = {59'd700, 29'b0};  
    reg [87 : 0] y0 = {59'd500, 29'b0};    
    reg [11 : 0] latched_x0_int = 0;        //x0, y0 are updated a moment after we leave ROI, but we want to have pre-update coords for valid in_extended_roi flag generation
    reg [10 : 0] latched_y0_int = 0;
    
    wire [87 : 0] x_acc_sum;
    wire [87 : 0] y_acc_sum;
    
    wire [11 : 0] x0_int;
    wire [10 : 0] y0_int;
    
    //roi_end impulse generation
    always @(negedge clk)
    begin
        
        if(x_pos == (x0_int + NEIGH_SIZE) && y_pos == (y0_int + NEIGH_SIZE) )
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
    
    
    accumulator_adder x_acc(
    
        .CLK(clk),
        .A(x0),
        .B(dx),
        .S(x_acc_sum)
    );
    
    
    accumulator_adder y_acc(
        
        .CLK(clk),
        .A(y0),
        .B(dy),
        .S(y_acc_sum)
    );
    
    
    modul_puz #(
        
        .N(1),
        .DELAY(1)
    )d_ready_delay(
    
        .clk(clk),
        .in(d_ready),
        .out(d_ready_del)
    );
    
    
    //update roi position
    always @(posedge clk)
    begin
        
        if(reset_position == 1)
        begin
            
            x0 <= set_x0;
            y0 <= set_y0;
        end
        
        else if(center_vsync_in == 0 && d_ready_del == 1 && enable == 1 && updated_in_this_frame == 0)
        begin
        
            updated_in_this_frame <= 1;
            x0 <= x_acc_sum;
            y0 <= y_acc_sum;
        end  
        
        else if(center_vsync_in == 1)
        begin
            
            latched_x0_int <= x0_int;
            latched_y0_int <= y0_int;
            updated_in_this_frame <= 0;
        end
        
        if(roi_end == 1)
            roi_ended <= 1;
            
        if(center_vsync_in == 1)
            roi_ended <= 0;
    end
    
    
    assign x0_int = x0[28] ? (x0[29 +: 12] + 1) : x0[29 +: 12];
    assign y0_int = y0[28] ? (y0[29 +: 11] + 1) : y0[29 +: 11];
    assign x0_int_out = x0_int;
    assign y0_int_out = y0_int;
    
    assign roi_end = roi_end_reg;
    assign in_roi = (x_pos >= x0_int - NEIGH_SIZE) && (x_pos <= x0_int + NEIGH_SIZE) && (y_pos >= y0_int - NEIGH_SIZE) && (y_pos <= y0_int + NEIGH_SIZE) && (roi_ended == 0);
    assign in_extended_roi = (x_pos >= latched_x0_int - (NEIGH_SIZE + BORDER_WIDTH)) && (x_pos <= latched_x0_int + (NEIGH_SIZE + BORDER_WIDTH)) && (y_pos >= latched_y0_int - (NEIGH_SIZE + BORDER_WIDTH)) && (y_pos <= latched_y0_int + (NEIGH_SIZE + BORDER_WIDTH));
    
endmodule
