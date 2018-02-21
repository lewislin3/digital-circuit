`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:16 10/20/2015 
// Design Name: 
// Module Name:    lab5 
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
module lab5(
    input clk,
    input reset,
    input button,
    input rx,
    output tx,
    output [7:0] led
    );

localparam [1:0] S_IDLE = 2'b00, S_WAIT = 2'b01, S_SEND = 2'b10, S_INCR = 2'b11;
localparam MEM_SIZE = 256;

// declare system variables
wire btn_pressed;
reg [7:0] send_counter;
reg [1:0] Q, Q_next;
reg [7:0] data[0:100];
reg [7:0] dataread[0:31];
reg [17:0] datamul[0:16]; 

reg [5:0] cntread;
reg [5:0] cntmul;
reg [6:0] cnt;
reg [6:0] cnt2;
reg [5:0] left;
reg [5:0] right;

// declare UART signals
wire transmit;
wire received;
wire [7:0] rx_byte;
reg  [7:0] rx_temp;
wire [7:0] tx_byte;
wire is_receiving;
wire is_transmitting;
wire recv_error;

assign led = data[4][7:0];
assign tx_byte = data[send_counter];


reg [32:0]i;
reg [32:0]j;

debounce btn_db(
    .clk(clk),
    .btn_input(button),
    .btn_output(btn_pressed)
    );

uart uart(
    .clk(clk),
    .rst(reset),
    .rx(rx),
    .tx(tx),
    .transmit(transmit),
    .tx_byte(tx_byte),
    .received(received),
    .rx_byte(rx_byte),
    .is_receiving(is_receiving),
    .is_transmitting(is_transmitting),
    .recv_error(recv_error)
    );

// Initializes the "Hello, World! " string

// ------------------------------------------------------------------------
// FSM of the "Hello, World!" transmission controller


always @(posedge clk) begin
  if (reset) Q <= S_IDLE;
  else Q <= Q_next;
end


always @(*) begin // FSM next-state logic
  case (Q)
    S_IDLE: // wait for button click
      if (btn_pressed == 1 ) begin 
		Q_next = S_WAIT;
		end
      else Q_next = S_IDLE;
    S_WAIT: // wait for the transmission of current data byte begins
      if (is_transmitting == 1) Q_next = S_SEND;
      else Q_next = S_WAIT;
    S_SEND: // wait for the transmission of current data byte finishes
      if (is_transmitting == 0) Q_next = S_INCR; // transmit next character
      else Q_next = S_SEND;
    S_INCR:
      if (tx_byte == 8'h0 )begin 
		Q_next = S_IDLE;

		end
		// string transmission ends
      else begin
		Q_next = S_WAIT;
	
		end
  endcase
end

// FSM output logics
assign transmit = (Q == S_WAIT)? 1 : 0;

// FSM-controlled send_counter incrementing data path
always @(posedge clk) begin
  if (reset || (Q == S_IDLE))
    send_counter <= 0;
  else if (Q == S_INCR)
    send_counter <= send_counter + 1;
end

// End of the FSM of the "Hello, World! " transmission controller
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// The following logic stores the UART input in a temporary buffer
// You must replace this code by your own code to store multiple
// bytes of data.
//
always @(posedge clk) begin
  if (reset)begin
	 for(j=0;j!=32;j=j+1)begin
			dataread[j]<=0;
	 end 
			cntread<=0;
	end
	
  else if (received)begin
		dataread[cntread]<=rx_byte;
		cntread<=cntread+1;
  end

end

always @(posedge clk) begin
  if (reset)begin
	 for(j=0;j!=16;j=j+1)begin
			datamul[j]<=0;
	 end 
			cntmul<=0;
			left<=0;
			right<=16;
	end
	
	else if(cntread==32 && cntmul<16)begin
			datamul[cntmul]<=dataread[left]*dataread[right]+dataread[left+1]*dataread[right+4]+dataread[left+2]*dataread[right+8]+dataread[left+3]*dataread[right+12];
			cntmul<=cntmul+1;
		if(cntmul==3 ||cntmul==7 ||cntmul==11)begin
			left<=left+4;
			right<=16;
		end
		else begin
			right<=right+1;
		end
	end


end

always @(posedge clk)begin
if (reset)begin
	 for(j=0;j!=100;j=j+1)begin
			data[j]<=0;
	 end 
		cnt<=0;
		cnt2<=0;
	end
	
else if(cntmul==16 && cnt<100)begin
	if(cnt2==3||cnt2==7||cnt2==11||cnt2==15)begin
	data[cnt+5]<=8'h0D;
	data[cnt+6]<=8'h0A;
	cnt<=cnt+7;
	end
	else begin
		data[cnt+5]<=32;
		cnt<=cnt+6;
	end

	if(datamul[cnt2][3:0]>=0 &&datamul[cnt2][3:0]<=9)
		data[cnt+4]<=datamul[cnt2][3:0]+48;
	else
		data[cnt+4]<=datamul[cnt2][3:0]+55;

	if(datamul[cnt2][7:4]>=0 &&datamul[cnt2][7:4]<=9)
		data[cnt+3]<=datamul[cnt2][7:4]+48;
	else
		data[cnt+3]<=datamul[cnt2][7:4]+55;

	if(datamul[cnt2][11:8]>=0 &&datamul[cnt2][11:8]<=9)
		data[cnt+2]<=datamul[cnt2][11:8]+48;
	else
		data[cnt+2]<=datamul[cnt2][11:8]+55;

	if(datamul[cnt2][15:12]>=0 &&datamul[cnt2][15:12]<=9)
		data[cnt+1]<=datamul[cnt2][15:12]+48;
	else
		data[cnt+1]<=datamul[cnt2][15:12]+55;

	if(datamul[cnt2][17:16]>=0 &&datamul[cnt2][17:16]<=9)
			data[cnt]<=datamul[cnt2][17:16]+48;
	else
		data[cnt]<=datamul[cnt2][17:16]+55;


		cnt2<=cnt2+1;


end


end
// ------------------------------------------------------------------------

endmodule
