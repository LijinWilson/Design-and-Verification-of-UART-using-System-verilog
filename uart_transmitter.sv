module Uart_Transmitter (uart_if uart);

    parameter int clk_freq = 50_000_000;    // 50 million cycle per second
    parameter int baud_rate = 115200;    // bits per second
    parameter int div_counter = clk_freq / baud_rate;     // 434 cycle is used to send 1 bit.

    logic [8:0] cycle_counter;    // count from 0 to 433, this time to wait for before sending next bit.
    logic [3:0] bit_index;   // Track which bit is being out of 8
    logic [9:0] tx_shift;    // Store the full data, including the {start, data, stop}.
    logic sending;    // Flag used to data is tranmitting or not.

    always_ff @(posedge uart.clk or posedge uart.reset) begin
        if (uart.reset) begin
            uart.Txd <= 1;
            sending <= 0;
            cycle_counter <= 0;
            bit_index <= 0;
            uart.busy <= 0;
        end else begin
            if (uart.transmit && !sending) begin    // user request data transmission and currently no data is in sending status
                tx_shift <= {1'b1, uart.TxData, 1'b0};    // {start_bit, Data, Stop_bit}
                sending <= 1;
                bit_index <= 0;
                cycle_counter <= 0;
                uart.busy <= 1;    // setting UART is bussy in sending data (Flag)
            end else if (sending) begin    // Data is in tranmission progress
                // Here it will start counting from 0 to 433
                if (cycle_counter == div_counter - 1) begin
                    cycle_counter <= 0;
                    uart.Txd <= tx_shift[bit_index];    // sending the next bit
                    bit_index <= bit_index + 1;    // increementing the bit_index bit

                    if (bit_index == 9) begin
                        sending <= 0;    // data tranmission flag to 0; 
                        uart.Txd <= 1;    // Making the transmission line back to 0
                        uart.busy <= 0;    // Returning the bussy flag back to zero
                    end
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end
        end
    end

endmodule
