
module debounce(input  clk, input btn_input,output btn_output);

parameter DEBOUNCE_PERIOD = 1000000; /* 20 msec @ 50MHz */

reg [20:0] cnt;
reg pressed;
reg flag;


always@(posedge clk)begin
if(btn_input==1)begin
			cnt<=cnt+1;
			pressed<=0;
			
			
			if(cnt==1000000 && flag==0)begin
					  pressed<=1;
					  flag<=1;
					  end
			
end
else begin
pressed<=0;
cnt<=0;
flag<=0;
end

end	

assign btn_output = pressed;	
endmodule