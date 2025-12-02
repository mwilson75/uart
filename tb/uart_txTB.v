module uart_txTB();
localparam DATA_BITS = 8;
localparam CLK_RATE = 8;
localparam BAUD_RATE = 1;
localparam CLK_PER_BIT = CLK_RATE / BAUD_RATE;
reg clk = 1'b0, enable = 1'b0, in = 1'b1, data_sent,serial_out;
reg[DATA_BITS-1:0] data;
always #1 clk = ~clk;


uart_tx #(.BAUD_RATE(1),.CLK_RATE(CLK_RATE),.DATA_BITS(DATA_BITS))uut
(
    .clk(clk),
    .enable(enable),
    .outgoing_data(data),
    .data_sent(data_sent),
    .data_bit(serial_out)
);

initial begin

    data <= 8'h65;
    #4;
    enable <= 1'b1;
    @(data_sent);
    enable <= 1'b0;
    #20;
end


endmodule