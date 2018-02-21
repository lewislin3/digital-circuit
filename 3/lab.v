`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:06 10/14/2015 
// Design Name: 
// Module Name:    lab 
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
module lab(
    input clk,
    input reset,
    input btn_east,
    input btn_west,
    output reg signed[7:0] led
    );
	 reg [15:0] num;
	 reg [20:0] cnt;
	 reg downw,downe;


	 
	 always@(posedge clk)begin
		if(reset==1)begin
			led<=0;
			
		end
		else begin
			cnt<=cnt+1;
			
			if(cnt==1000000)begin
			downe<=btn_east;
			downw<=btn_west;
				if(btn_west==1&&downw!=btn_west&&led<=6)begin
					  led<=led+1;
					  cnt<=0;
				end
				else if(btn_east==1&&downe!=btn_east&&led>=-7)begin
					  led<=led-1;
					  cnt<=0;
				end
			end
		end
		
		
		
		end


endmodule
