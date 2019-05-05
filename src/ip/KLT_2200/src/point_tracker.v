`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2019 06:11:53 PM
// Design Name: 
// Module Name: point_tracker
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


module previous_roi_buffer #(
    
    parameter NEIGH_SIZE = 6'd10,
    parameter BORDER_WIDTH = 6'd5
)
(   

    input clk,
    input [10 : 0] center_pixel,   
    input in_roi,
    input in_extended_roi,
    input roi_end,
    input center_vsync,     //next frame flag
    input [11 : 0] point_x0,
    input [10 : 0] point_y0,
    input first_frame,
    
    output [7 : 0] prev_frame_pixel,
    
    output [9 : 0] read_addr_test,
    output [9 : 0] write_addr_test,
    output [16 : 0] read_offset,
    output [11 : 0] delta_x0,
    output [10 : 0] delta_y0,
    output [16 : 0] dy_times_window
);

    localparam WRITE_ADDR_LIM = 960; //( 2*(NEIGH_SIZE+BORDER_WIDTH) + 1 )^2 - 1;

    reg [9 : 0] write_addr = 0;
    reg [16 : 0] read_offset = 0;  //because roi position changes from frame to frame, we need to start reading from diffrent location
    reg [11 : 0] prev_point_x0 = 0;
    reg [10 : 0] prev_point_y0 = 0;
    reg read_write_flag = 0; //0 - read from A, write to B; 1 - read from B, write to A; changed every vsync
    reg synchronize_read_offset_trigger = 0; //compute read_offset one clock after point_x0, point_y0 update
    
    wire [11 : 0] delta_x0;
    wire [10 : 0] delta_y0;
    wire [9 : 0] read_addr;
    wire [10 : 0] read_pixel_A;
    wire [10 : 0] read_pixel_B;
    wire write_enable_A;
    wire write_enable_B;
    wire [16 : 0] dy_times_window;
    wire delayed_synchronize_read_offset_trigger; //trigger further delayed by yoffcomp latency


    always @(posedge clk)
    begin
        
        //writing process
        if(in_extended_roi)
        begin
        
            if(write_addr >= WRITE_ADDR_LIM)
                write_addr <= 0;
                
            else
                write_addr <= write_addr + 1;
        end 
        
        if(delayed_synchronize_read_offset_trigger == 1)
        begin
            
            read_offset <= delta_x0 + dy_times_window;
            synchronize_read_offset_trigger <= 0;
        end
    end
    
    
    //update read_offset for next frame
    always @(point_x0, point_y0)
    begin
        
        if(first_frame == 0)
            synchronize_read_offset_trigger <= 1;
    end
    
    
    always @(posedge roi_end)
    begin
    
        prev_point_x0 <= point_x0;
        prev_point_y0 <= point_y0; 
    end
    
    
    //multiplex between BRAMs
    always @(posedge center_vsync)
    begin
        
        read_write_flag <= ~read_write_flag;
    end
    
    
    //delay trigger by multiplier latency
    modul_puz #(
    
        .DELAY(1),
        .N(1)
    )
    synch_offset_trigger(
        
        .clk(clk),
        .in(synchronize_read_offset_trigger),
        .out(delayed_synchronize_read_offset_trigger)
    );
    
    
    //compute read offset (delta_y0 part), latency 1
    mult_dy_times_window yoffcomp(
    
        .CLK(clk),
        .A(delta_y0),
        .B(NEIGH_SIZE + NEIGH_SIZE + BORDER_WIDTH + BORDER_WIDTH + 1),
        .P(dy_times_window)
    );
      
    //BRAM
    frame_delay_sim memA(

        .addra(write_addr),
        .clka(clk),
        .dina(center_pixel),
        .wea(write_enable_A),
        
        .addrb(read_addr + 2), //because bram has 2 clock cycles read latency
        .clkb(clk),
        .doutb(read_pixel_A)
    );
    
    //BRAM
    frame_delay_sim memB(

        .addra(write_addr),
        .clka(clk),
        .dina(center_pixel),
        .wea(write_enable_B),
        
        .addrb(read_addr + 2), //because bram has 2 clock cycles read latency
        .clkb(clk),
        .doutb(read_pixel_B)
    );

    
    assign read_addr = ((write_addr + read_offset) >= 10'd0) ? (write_addr + read_offset) : 10'd0;
    assign prev_frame_pixel = read_write_flag ? read_pixel_B[10 : 3] : read_pixel_A[10 : 3];
    assign write_enable_A = read_write_flag ? in_extended_roi : 1'b0;
    assign write_enable_B = read_write_flag ? 1'b0 : in_extended_roi;
    assign delta_x0 = point_x0 - prev_point_x0;
    assign delta_y0 = point_y0 - prev_point_y0;
    
    assign read_addr_test = read_addr;
    assign write_addr_test = write_addr; 
endmodule
