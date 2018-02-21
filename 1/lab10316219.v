module Substractor(A,B,Bin,S,Bout);
	input [7:0] A,B;
	input Bin;
	output [8:0] S;
	output Bout;
	wire [7:0] t;
	wire [8:0] tb;

	twoC com(B,tb);
	FA_1bit FA0(.A(A[0]), .B(tb[0]), .Cin(Bin), .S(S[0]), .Cout(t[0]));
	FA_1bit FA1(.A(A[1]), .B(tb[1]), .Cin(t[0]), .S(S[1]), .Cout(t[1]));
	FA_1bit FA2(.A(A[2]), .B(tb[2]), .Cin(t[1]), .S(S[2]), .Cout(t[2]));
	FA_1bit FA3(.A(A[3]), .B(tb[3]), .Cin(t[2]), .S(S[3]), .Cout(t[3]));
	FA_1bit FA4(.A(A[4]), .B(tb[4]), .Cin(t[3]), .S(S[4]), .Cout(t[4]));
	FA_1bit FA5(.A(A[5]), .B(tb[5]), .Cin(t[4]), .S(S[5]), .Cout(t[5]));
	FA_1bit FA6(.A(A[6]), .B(tb[6]), .Cin(t[5]), .S(S[6]), .Cout(t[6]));
	FA_1bit FA7(.A(A[7]), .B(tb[7]), .Cin(t[6]), .S(S[7]), .Cout(t[7]));
	FA_1bit FA8(.A(A[7]), .B(tb[8]), .Cin(t[7]), .S(S[8]), .Cout(Bout));
	
endmodule

//---------A 1-bit 2'complements---------//


module twoC(b,ans);
	input [7:0] b;
	output [8:0] ans;
	wire [7:0] t;
	assign ans[0]=b[0]^(1'b0);
	assign t[0]=ans[0];
	assign ans[1]=t[0]^b[1];
	assign t[1]=ans[1]|t[0];
	assign ans[2]=b[2]^t[1];
	assign t[2]=ans[2]|t[1];
	assign ans[3]=b[3]^t[2];
	assign t[3]=ans[3]|t[2];
	assign ans[4]=b[4]^t[3];
	assign t[4]=ans[4]|t[3];
	assign ans[5]=b[5]^t[4];
	assign t[5]=ans[5]|t[4];
	assign ans[6]=b[6]^t[5];
	assign t[6]=ans[6]|t[5];
	assign ans[7]=b[7]^t[6];
	assign t[7]=ans[7]|t[6];
	assign ans[8]=b[7]^t[7];
	
endmodule 
//----------A 1-bit full adder-----------//
module FA_1bit(A,B,Cin,S,Cout);
	input A, B,Cin;
	output S,Cout;

	assign S = Cin^A^B;
	assign Cout = (A&B)|(Cin&B)|(Cin&A);
endmodule 
