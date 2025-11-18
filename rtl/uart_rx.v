module uart_rx #(parameter BAUD_RATE = 115200,
                 parameter DATA_BITS = 8,
                 parameter STOP_BITS = 1,
                 parameter CLK_RATE = 25000000)
(
    input clk,
    input reset,
    input incoming_data,
    output is_data_valid,
    output [DATA_BITS-1:0] data
);
localparam CLK_PER_BIT = CLK_RATE / BAUD_RATE;
localparam NUM_STATES = 6;
localparam IDLE = 0, HALF_BAUD_WAIT = 5, RECEIVING = 1, STOPPING = 2, OUT_OF_SYNC = 3, DONE = 4;
wire full_toggle_out,full_period_en, new_bit,data_neg_edge,half_period_en,half_toggle_out;
reg[2:0] r_new_bit;
reg [$clog2(NUM_STATES)-1:0] current_state;
reg [DATA_BITS-1:0] r_data;
reg [$clog2(DATA_BITS):0] bit_counter;

always @(posedge clk) begin
    if(reset) begin
        r_new_bit <= 0;
    end
    else begin
        r_new_bit <= {r_new_bit[1:0],incoming_data};
    end
end
assign new_bit = r_new_bit[2];
assign data_neg_edge = r_new_bit[2] & ~ r_new_bit[1];
clock_counter #(.COUNT_LIMIT(CLK_PER_BIT)) inst
( 
    .clk(clk),
    .enable(full_period_en),
    .count_reached(full_toggle_out)
);

assign full_period_en = (current_state == RECEIVING) | (current_state == STOPPING);
clock_counter #(.COUNT_LIMIT(CLK_PER_BIT>>1)) half_inst
(
    .clk(clk),
    .enable(half_period_en),
    .count_reached(half_toggle_out)
);

assign half_period_en = current_state == HALF_BAUD_WAIT;
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        bit_counter <= 0;
        r_data <= 0;
    end
    else begin
        case(current_state)
            IDLE:begin 
                if(data_neg_edge) begin
                    current_state <= HALF_BAUD_WAIT;
                end
                bit_counter <= 0;
            end
            HALF_BAUD_WAIT:begin
                if(half_toggle_out) begin
                    current_state <= RECEIVING;
                end
            end
            RECEIVING: begin

                if(bit_counter == DATA_BITS) begin
                    current_state <= STOPPING;
                    bit_counter <= 0;
                end
                if(full_toggle_out) begin
                    r_data <= {new_bit,r_data[DATA_BITS-1:1]};
                    bit_counter <= bit_counter + 1;
                end
            end
            STOPPING: begin
                if(bit_counter == STOP_BITS) begin
                    if(new_bit) begin
                        current_state <= DONE;
                    end
                    else begin
                        current_state <= OUT_OF_SYNC;
                    end
                end
                if(full_toggle_out) begin
                    bit_counter <= bit_counter + 1;
                end
            end
            OUT_OF_SYNC: begin
                if(new_bit == 1'b1) begin
                    current_state <= IDLE;
                end
                else begin
                    current_state <= OUT_OF_SYNC;
                end
                bit_counter <= 0;
            end
            DONE: begin
                bit_counter <= 0;
                if(data_neg_edge) begin
                    current_state <= RECEIVING;
                end
                else begin
                    current_state <= IDLE;
                end
            end
        endcase
    end 
end

assign data = (current_state == DONE) ? r_data : 0;
assign is_data_valid = (current_state == DONE) ? 1'b1 : 1'b0;
endmodule
