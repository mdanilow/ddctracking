`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:      AGH
// Engineer: 	  Tomasz Kryjak 	
// 
// Create Date:    08:17:01 10/29/2013 
// Design Name: 
// Module Name:    delayLinieBRAM_WP 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module delayLinieBRAM_WP
  #(
    parameter WIDTH = 11,
    parameter BRAM_SIZE_W = 12
    )
   (
    input 		    clk,
    input 		    rst,
    input 		    ce,
    input [WIDTH-1:0] 	    din,
    output [WIDTH-1:0] 	    dout,
    input [BRAM_SIZE_W-1:0] h_size
    );



   
   reg [BRAM_SIZE_W-1:0]    position = 0;
   
   wire [WIDTH-1:0] 	    dina;
   wire [WIDTH-1:0] 	    douta;
   
   
   // RAM controller
   always @(posedge clk)
     begin
	if ( ce == 1'b1)
	  begin
	     if (rst == 1'b1)
	       begin
		  position <= 0;
	       end
	     else
	       begin
		  position <= position+1;
		  if (position == h_size-3)
		    begin
		       position <= 0;
		    end
	       end		
	  end	
     end
   
   
   // Block RAM
   delayLineBRAM BRAM (
		       .clka(clk), // input clka
		       .wea(1'b1), // input [0 : 0] wea
		       .addra(position), // input [10 : 0] addra
		       .dina(din), // input [15 : 0] dina
		       .douta(dout) // output [15 : 0] douta
		       );
   
endmodule
