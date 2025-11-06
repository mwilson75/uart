module uart_rx #(parameter BAUD_RATE = 115200,
                 parameter DATA_BITS = 8,
                 parameter STOP_BITS = 1)
(
    input clk,
    input reset,
    input incoming_data,
    output [DATA_BITS-1:0] data
);

localparam NUM_STATES = 5;
localparam IDLE = 0, RECEIVING = 1, STOPPING = 2, OUT_OF_SYNC = 3, DONE = 4;
reg [$clog2(NUM_STATES)-1:0] current_state;
//reg [DATA_BITS-1:0] r_data;
reg [$clog2(DATA_BITS):0] counter;
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        counter <= 0;
        //r_data <= 0;
    end
    else begin
        case(current_state)
            IDLE:begin 
                if(incoming_data == 1'b0) begin
                    current_state <= RECEIVING;
                end
                counter <= 0;
            end
            RECEIVING: begin

                if(counter == DATA_BITS ) begin
                    current_state <= STOPPING;
                    
                end
                //r_data <= {incoming_data,r_data[DATA_BITS-1:1]};
                counter <= counter + 1;
            end
            STOPPING: begin
                if(incoming_data == 1'b1) begin
                    current_state <= DONE;
                end
                else begin
                    current_state <= OUT_OF_SYNC;
                end
                counter <= 0;
            end
            OUT_OF_SYNC: begin
                if(incoming_data == 1'b1) begin
                    current_state = IDLE;
                end
                else begin
                    current_state <= OUT_OF_SYNC;
                end
                counter <= 0;
            end
            DONE: begin
                counter <= 0;
                current_state <= IDLE;
            end
        endcase
    end 
end

assign data = 0;//(current_state == STOPPING) ? 
endmodule