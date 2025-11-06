module uart_rxTB();

reg clk = 1'b0, reset = 1'b1, in = 1'b1;

always #1 clk = ~clk;


uart_rx uut
(
    .clk(clk),
    .reset(reset),
    .incoming_data(in),
    .data()
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
end


endmodule