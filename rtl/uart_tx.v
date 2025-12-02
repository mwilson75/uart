module uart_tx #(parameter BAUD_RATE = 115200,
                 parameter DATA_BITS = 8,
                 parameter STOP_BITS = 1,
                 parameter CLK_RATE = 25000000)
(
    input clk,
    input enable,
    input[DATA_BITS-1:0] outgoing_data,
    output data_sent,
    output data_bit
);

localparam CLK_PER_BIT = CLK_RATE / BAUD_RATE;
localparam NUM_STATES = 5;
localparam IDLE = 0, STARTING = 4, SENDING = 1, STOPPING = 2, DONE = 3;

reg [$clog2(NUM_STATES)-1:0] current_state = IDLE;
reg [$clog2(DATA_BITS):0] bit_count = 1'b0;
reg r_data_bit;
wire clk_counter_en;
wire baud_clock;

assign data_sent = (current_state == DONE);
clock_counter #(.COUNT_LIMIT(CLK_PER_BIT)) inst
( 
    .clk(clk),
    .enable(clk_counter_en),
    .new_clk(baud_clock)
);

assign clk_counter_en = (current_state == STARTING) | (current_state == SENDING) | (current_state == STOPPING);

always @(posedge clk) begin
    case(current_state)
        IDLE: begin
            r_data_bit <= 1'b1;
            if(enable) begin
                current_state <= STARTING;
            end
        end
        STARTING: begin
            r_data_bit <= 1'b0;
            if(baud_clock) begin
                current_state <= SENDING;
            end
        end
        SENDING:begin
            if(bit_count == DATA_BITS) begin
                current_state <= STOPPING;
                bit_count <= 1'b0;
            end
            else begin
                r_data_bit <= outgoing_data[bit_count];
                if(baud_clock) begin
                    bit_count <= bit_count + 1;
                end
            end

        end
        STOPPING:begin
            if(bit_count == STOP_BITS) begin
                current_state <= DONE;
            end
            r_data_bit <= 1'b1;
            if(baud_clock) begin
                bit_count <= bit_count + 1;
            end
        end
        DONE:begin
            current_state <= IDLE; 
        end
    endcase
end

assign data_bit = r_data_bit;
endmodule