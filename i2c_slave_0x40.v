module i2c_slave_0x40 (
    input wire clk,
    input wire reset,
    inout wire sda,
    input wire scl,
    output reg data_ready,
    output reg [7:0] data_out,
    input wire [7:0] data_in
);
    parameter SLAVE_ADDRESS = 7'h40;
    reg [7:0] data_buffer;
    reg [3:0] scl_count;

    // State machine
    typedef enum reg [1:0] {
        IDLE,
        RECEIVE,
        TRANSMIT,
        ACK
    } state_t;
    state_t state;

    assign sda = (state == TRANSMIT) ? data_buffer[7] : 1'bz;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            scl_count <= 0;
            data_ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (scl && ~sda) begin // Start condition
                        state <= RECEIVE;
                        scl_count <= 0;
                    end
                end

                RECEIVE: begin
                    if (scl_count < 8) begin
                        data_buffer[scl_count] <= sda;
                        scl_count <= scl_count + 1;
                    end else begin
                        data_ready <= 1;
                        state <= ACK;
                    end
                end

                ACK: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule