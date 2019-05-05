`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2018 06:49:52 PM
// Design Name: 
// Module Name: context_3x3
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


module context_level #(
    
    parameter H_SIZE = 800,//800 //83 //1650
    parameter CONTEXT_SIZE = 7,
    parameter CONTEXT_CENTER = 4,
    parameter P_GUESS_INT_WIDTH = 6
)
(

    input clk,
    input [7 : 0] pixel_in,
    input de_in,
    input h_sync_in,
    input v_sync_in,
    input signed [P_GUESS_INT_WIDTH-1 : 0] pyramidal_guess_x_int,
    input signed [P_GUESS_INT_WIDTH-1 : 0] pyramidal_guess_y_int,
    
    //relative to center pixel:
    output [10 : 0] center,
    output [10 : 0] up,
    output [10 : 0] down,
    output [10 : 0] left,
    output [10 : 0] right,
    //pixel shifted by pyramidal_guess, relative to center pixel
    output [10 : 0] pyramidal_guess_pixel
);
    
 
    reg synch_de_in = 0;
    reg synch_h_sync_in = 0;
    reg synch_v_sync_in = 0;
    reg [7 : 0] synch_pixel_in = 0;
    
    reg [10 : 0] context [CONTEXT_SIZE-1 : 0][CONTEXT_SIZE-1 : 0]; // context memory
    
    wire [10 : 0] bram_lines_out [CONTEXT_SIZE-2 : 0];  //notice that number of lines = context_size - 1, for example, 3x3 context = 2 bram lines
    
    
//    synchronize input
    always @(negedge clk)
    begin
    
        synch_de_in <= de_in;
        synch_v_sync_in <= v_sync_in;
        synch_h_sync_in <= h_sync_in;
        synch_pixel_in <= pixel_in;
    end
    
    
    //generate bram lines
    genvar b;
    generate
    
        for(b = 0; b < CONTEXT_SIZE-1; b = b+1)
        begin
        
            delayLinieBRAM_WP line_b(
        
                .clk(clk),
                .rst(1'b0),
                .ce(1'b1),
                .h_size(H_SIZE - CONTEXT_SIZE),
                .din(context[b][CONTEXT_SIZE - 1]),
                .dout(bram_lines_out[b])
            );
        end
    endgenerate
    
    
    //start context chain
    always @(posedge clk)
    begin
    
//        context[0][0] <= {pixel_in, de_in, h_sync_in, v_sync_in};
        context[0][0] <= {synch_pixel_in, synch_de_in, synch_h_sync_in, synch_v_sync_in};
    end
    
    
    //connect bram lines outputs to context rows
    genvar line;
    generate
        
        for(line = 1; line < CONTEXT_SIZE; line = line + 1)
        begin
        
            always @(posedge clk)
            begin
            
                context[line][0] <= bram_lines_out[line - 1];
            end
        end
    endgenerate
    
    
    //generate context connections
    genvar row, col;
    generate
    
        for(row = 0; row < CONTEXT_SIZE; row = row + 1)
        begin
        
            for(col = 1; col < CONTEXT_SIZE; col = col + 1)
            begin
             
                always @(posedge clk)
                begin
                
                    context[row][col] <= context[row][col-1];
                end
            end
        end
    endgenerate
    
    
//EXAMPLE for 3x3 case, for better understanding what tf is going on
//    always @(posedge clk)
//    begin
        
//        context[0][0] <= {synch_pixel_in, synch_de_in, synch_h_sync_in, synch_v_sync_in};
//        context[0][1] <= context[0][0];
//        context[0][2] <= context[0][1];
        
//        context[1][0] <= bram_lines_out[0];
//        context[1][1] <= context[1][0];
//        context[1][2] <= context[1][1];
        
//        context[2][0] <= bram_lines_out[1];
//        context[2][1] <= context[2][0];
//        context[2][2] <= context[2][1];
//    end
    
    
    //notice that, for example, right context pixel is on the left side in context register array (relative to center pixel)
    //same for up pixel
    assign center = context[CONTEXT_CENTER][CONTEXT_CENTER];
    assign down = context[CONTEXT_CENTER-1][CONTEXT_CENTER];
    assign up = context[CONTEXT_CENTER+1][CONTEXT_CENTER];
    assign right = context[CONTEXT_CENTER][CONTEXT_CENTER-1];
    assign left = context[CONTEXT_CENTER][CONTEXT_CENTER+1];  
    
    assign pyramidal_guess_pixel = context[CONTEXT_CENTER - pyramidal_guess_y_int][CONTEXT_CENTER - pyramidal_guess_x_int];
endmodule
