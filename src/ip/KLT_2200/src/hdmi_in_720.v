`timescale 1ns / 1ps
//-----------------------------------------------
// Company: agh
// Engineer: komorkiewicz
// Create Date: 23:14:48 04/19/2011 
// Description: vga generator
//-----------------------------------------------
module hdmi_in_720(
  //hdmi outputs
  output reg hdmi_clk,
  output hdmi_de,
  output hdmi_hs,
  output hdmi_vs,
  //image data
  output [7:0]hdmi_r,
  output [7:0]hdmi_g,
  output [7:0]hdmi_b
); 
//-----------------------------------------------
//for now supports VGA 640x480 60Hz only
  //horizontal
  parameter hr=1280; //resolution
  parameter hbp=220; //back porch //48 EEEEEEEEEEEEEEEEEEEEEEE
  parameter hfp=110; //front porch
  parameter hs=40;  //sync len
  //vertical
  parameter vr=720; //resolution
  parameter vbp=20; //back porch
  parameter vfp=5; //front porch
  parameter vs=5;   //sync len
//-----------------------------------------------
//for now supports VGA 640x480 60Hz only
//  //horizontal
//  parameter hr=64; //resolution
//  parameter hbp=8; //back porch
//  parameter hfp=8; //front porch
//  parameter hs=2;  //sync len
//  //vertical
//  parameter vr=64; //resolution
//  parameter vbp=8; //back porch
//  parameter vfp=8; //front porch
//  parameter vs=4;   //sync len
//-----------------------------------------------
  reg line=1'b0;
  reg vsync=1'b1;
  reg hsync=1'b1;
  reg enab=1'b0;
  reg eenab=1'b0;
  reg h_enable=1'b0;
  reg v_enable=1'b0;
  reg [10:0]hcounter=0;
  reg [10:0]vcounter=720+10;//480+7;//64+1
//-----------------------------------------------
  reg [7:0]red;
  reg [7:0]green;
  reg [7:0]blue;
  
  //reg hdmi_clk=1'b0;
//-----------------------------------------------
initial
begin
  while(1)
  begin
    #1 hdmi_clk=1'b0;
	 #1 hdmi_clk=1'b1;
  end
end  
//-----------------------------------------------
integer rgbfile,i,v,clo,cle,wl,x;

//-----------------------------------------------
always @(posedge hdmi_clk)
begin
  hcounter<=hcounter+1;
  
  eenab<=enab;

  if(hcounter==(hr+hbp)) begin
    hsync<=1'b0;
  end
  if(hcounter==(hr+hbp+hs)) begin
    hsync<=1'b1;
	 line<=1'b0;
  end

  if(hcounter<hr) 
      h_enable<=1'b1;
  else 
		h_enable<=1'b0;
  
  if(vcounter<vr) 
		v_enable<=1'b1;
  else 
		v_enable<=1'b0;
		
  if((v_enable==1'b1)&&(h_enable==1'b1))
		enab<=1'b1;
  else 
		enab<=1'b0;
		  	  
  if(hcounter==(hr+hbp+hs+hfp)) 
  begin
    hcounter<=0;
	 line<=1'b1;
  end
end
//-----------------------------------------------
//TB only

always @(posedge hdmi_clk)
begin
  if(enab)
  begin
    red=$fgetc(rgbfile);
	 green=$fgetc(rgbfile);
	 blue=$fgetc(rgbfile);
 	 
  end
end
//TB end
//-----------------------------------------------
reg [7:0]vsc=0;

always @(posedge line)
begin
  vcounter<=vcounter+1;
  if(vcounter==(vr+vbp))
  begin  
    vsync<=1'b0;
	 //TB only
	 vsc=vsc+1;

   
    //rgbfile = $fopen({"E:/rzeczy/matlab/pudelko/res_640_480/frame_", vsc/100+8'h30, (vsc%100)/10+8'h30, vsc%10+8'h30, ".ppm"},"rb");
    rgbfile = $fopen({"C:/konkurs/matlab/DDC/res_1280_720/frame_", vsc/100+8'h30, (vsc%100)/10+8'h30, vsc%10+8'h30, ".ppm"},"rb");

	 // read header file
	 for(i=0;i<16;i=i+1)
    begin
      v=$fgetc(rgbfile); 
    end	
	 //TB end
  end
  if(vcounter==(vr+vbp+vs)) vsync<=1'b1;
  if(vcounter==(vr+vbp+vs+vfp)) vcounter<=0;
end
//-----------------------------------------------

assign hdmi_r=red;
assign hdmi_g=green;
assign hdmi_b=blue;

assign hdmi_de=eenab;
// +TK Changed to negatve for Zybo
assign hdmi_hs=!hsync;
assign hdmi_vs=!vsync;
//-----------------------------------------------
endmodule
//-----------------------------------------------
