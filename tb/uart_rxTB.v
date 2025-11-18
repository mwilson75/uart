module uart_rxTB();
localparam DATA_BITS = 8;
localparam CLK_RATE = 8;
localparam BAUD_RATE = 1;
localparam CLK_PER_BIT = CLK_RATE / BAUD_RATE;
reg clk = 1'b0, reset = 1'b1, in = 1'b1, data_valid = 1'b0;
reg[DATA_BITS-1:0] data;
always #1 clk = ~clk;


uart_rx #(.BAUD_RATE(1),.CLK_RATE(CLK_RATE),.DATA_BITS(DATA_BITS))uut
(
    .clk(clk),
    .reset(reset),
    .incoming_data(in),
    .is_data_valid(data_valid),
    .data(data)
);

initial begin
  #(CLK_PER_BIT << 2);
    reset = 1'b0;
  # (CLK_PER_BIT << 2);
    in = 1'b0;
  # (CLK_PER_BIT << 1);
  	in = 1'b1;
  #(CLK_PER_BIT << 1); 
  	in = 1'b0;
  #(CLK_PER_BIT << 1);
  	in = 1'b1;
  #(CLK_PER_BIT << 5)
  /*
  #(CLK_PER_BIT << 1);
  	in = 1'b0;
  	#(CLK_PER_BIT << 1);
  	in = 1'b1;
    #(CLK_PER_BIT * 10);
    in =1'b0;
  #(CLK_PER_BIT * 14);
    in = 1'b1;
    #(CLK_PER_BIT << 1);
    in = 1'b0;
  #(CLK_PER_BIT * 10);
    in = 1'b1;
    #(CLK_PER_BIT * 10);
    in = 1'b0;
    #(CLK_PER_BIT << 1);
    in = 1'b1;
  #(CLK_PER_BIT * 18);
    in = 1'b0;
    #(CLK_PER_BIT << 1);
    in = 1'b1;
  	#(CLK_PER_BIT << 1);
    in = 1'b0;
  #(CLK_PER_BIT * 12);
    in = 1'b1;
  #(CLK_PER_BIT * 12);
  */
end


endmodule