`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:17 11/25/2015 
// Design Name: 
// Module Name:    lab8 
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
module lab8(
input clk,
input ROT_A,
input ROT_B,
input reset,
output [7:0] led
    );

wire rotary_event;
wire rotary_right;	

reg light;
reg [30:0]cnt;
reg [30:0]state;
	 
assign led[0]=(light)?1:0;
assign led[1]=0;
assign led[2]=0;
assign led[3]=0;
assign led[4]=0;
assign led[5]=0;
assign led[6]=0;
assign led[7]=0;
Rotation_direction Rotation_direction(
	.CLK(clk),
	.ROT_A(ROT_A),
	.ROT_B(ROT_B),
	.rotary_event(rotary_event),
	.rotary_right(rotary_right)
);

always@(posedge clk)begin
	if(reset)begin 
		cnt<=0;
	end
	else begin
		if(cnt == 1000000) begin
			cnt<=0;
		end
		else begin
			cnt<=cnt+1;
		end
	end
end
	 

always@(posedge clk)begin
	if(reset)begin 
		state<=1000000;
		light<=0;
	end
	else begin
		if(rotary_event==1)begin
			if(rotary_right==0&&state<=900000)begin
				state<=state+100000;
			end
			else if(rotary_right==1 && state>0)begin
				state<=state-100000;
			end
		end
	

	 if(cnt>state )begin
		light<=1;
	 end
	 else light<=0;
	 
	 
	
		

		
	end
	
	

end


endmodule
