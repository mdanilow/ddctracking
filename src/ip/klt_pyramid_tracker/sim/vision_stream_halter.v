`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2019 20:36:29
// Design Name: 
// Module Name: vision_stream_halter
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


module vision_stream_halter(
    
    input clk,
    input [7 : 0] pixel_in,
    input hsync_in,
    input vsync_in,
    input de_in,
    input halt,
    input start,
    input reset,
    
    output clk_out,
    output [7 : 0] pixel_out,
    output hsync_out,
    output vsync_out,
    output de_out
);  

    wire [11 : 0] read_data;

    reg [2 : 0] state = 0;
    reg write_enable = 0;
    reg read_enable = 0;
    reg first_clock_after_halt = 0;

    always @(posedge clk)
    begin
        
        //idle
        if(state == 0)
        begin
            
            //start writing
            if(halt == 1)
            begin
                
                write_enable <= 1;
                state <= 1;
            end
        end
        
        //writing
        else if(state == 1)
        begin
            
//            assign clk_out = (state == 1 && first_clock_after_halt == 1) ? read_data[0] : clk; //if writing, stop klt tracker

//            if(first_clock_after_halt == 0)
//                first_clock_after_halt <= 1;
        
            //start reading
            if(start == 1) 
            begin
                
                read_enable <= 1;
                state <= 2;
            end
        end
        
        //stop clock for one more cycle due to fifo read latency (1)
        else if(state == 2)
        begin
        
            state <= 3;
        end
        
        //reading
        else if(state == 3)
        begin
        
            if(reset == 1)
            begin
                
                //first_clock_after_halt <= 0;
                write_enable <= 0;
                read_enable <= 0;
                state <= 0;
            end
        end
    end
    
    
    stream_halter_fifo fajfo(
    
        .clk(clk),
        .din({pixel_in, de_in, hsync_in, vsync_in, clk}),
        .dout(read_data),
        .wr_en(write_enable),
        .rd_en(read_enable),
        .srst(reset)
    );

    
    assign clk_out = (state == 1 || state == 2 || (state == 0 && halt == 1)) ? 1'b0 : clk; //if writing, stop klt tracker
    assign pixel_out = (state == 0) ? pixel_in : read_data[4 +: 8];
    assign de_out = (state == 0) ? de_in : read_data[3];
    assign hsync_out = (state == 0) ? hsync_in : read_data[2];
    assign vsync_out = (state == 0) ? vsync_in : read_data[1];
endmodule
