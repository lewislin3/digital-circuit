`timescale 1ns / 1ps

module postfix(IN_VALID,IN,OP_MODE,OUT_VALID,OUT,CLK,RESET);

input IN_VALID;
input [3:0] IN;
input OP_MODE;
input CLK,RESET;
output reg OUT_VALID;
output reg [15:0]OUT;


reg [15:0] w1[7:0];
reg [3:0] w3,iv;


always @(posedge CLK,negedge RESET)begin

iv<=IN_VALID;

if(RESET==1'b0)
w3<=4'b0000;



else if(IN_VALID==1'b1)begin
	

	if (OP_MODE==1'b1)begin
		
		if(IN==4'b0001)begin
		w1[w3-2]<=w1[w3-1]+w1[w3-2];
		w3<=w3-1;
		end
		
		if(IN==4'b0010)begin
		w1[w3-2]<=w1[w3-2]-w1[w3-1];
		w3<=w3-1;
		end
		
		if(IN==4'b0100)begin
		w1[w3-2]<=w1[w3-1]*w1[w3-2];
		w3<=w3-1;
		end
		
		
		
	end
	
	if (OP_MODE==1'b0)begin
		w1[w3]<=IN;
		w3<=w3+1'b1;
	end
	
end

else if(iv==1'b1 &&IN_VALID==1'b0)begin
OUT_VALID<=1'b1;
OUT<=w1[0];
w3<=4'b0000;
end
else 
OUT_VALID<=1'b0;

end





endmodule
