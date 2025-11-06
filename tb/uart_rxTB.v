module uart_rxTB();
localparam DATA_BITS = 8;
reg clk = 1'b0, reset = 1'b1, in = 1'b1;
reg[DATA_BITS-1:0] data;
always #1 clk = ~clk;


uart_rx uut
(
    .clk(clk),
    .reset(reset),
    .incoming_data(in),
    .data(data)
);

initial begin
    #4
    reset = 1'b0;
    #10
    in = 1'b0;
    #4
  	in = 1'b1;
  	#6 
  	in = 1'b0;
  	#4
  	in = 1'b1;
  	#2
  	in = 1'b0;
  	#2
  	in = 1'b1;
    #10
    in =1'b0;
    #14
    in = 1'b1;
    #2 
    in = 1'b0;
    #10
    in = 1'b1;
    #10
    in = 1'b0;
    #2
    in = 1'b1;
    #18
    in = 1'b0;
    #14
    in = 1'b1;
    #12
end


endmodule