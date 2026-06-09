// UART Reciever
/*
  >>>>> TO IMPLEMENT <<<<<
    ->  Waiting for the start bit to come.
    ->  Use 16x sampling.
    ->  Sample the middle of each digit while sampling time.
    ->  Store bit in shift register.
    ->  Output the final data.
*/


module Uart_Receiver (uart_if uart);

    parameter int clk_freq = 50_000_000;  // clock freq
    parameter int baud_rate = 115200;
    parameter int div_sample = 16;
  parameter int div_counter = clk_freq / (baud_rate * div_sample);  // 27
    parameter int mid_sample = div_sample / 2;  //16
    parameter int total_bits = 10;

    logic state, nextstate;
    logic shift;  // When to store the incoming bit
  logic [3:0] bit_counter;  //  Select the which bit from 0 to 9 to select from incoming 10 bit.
  logic [3:0] sample_counter;  //  0 to 15 which bit in during the oversampling
  logic [4:0] cycle_counter;  //  0 to 26 cycles per bit, related to BAUD rate
  logic [9:0] rxshift_reg;  //  Stores the all 10 bit {start, data, stop}
    logic clear_bitcounter, inc_bitcounter;  //  reset counter
    logic clear_samplecounter, inc_samplecounter;  // Increement the counter
    logic valid_rx_next;  //  indicate the valid data.

    always_ff @(posedge uart.clk or posedge uart.reset) begin
      if (uart.reset) begin  //  RESET STATE ACTION
            state <= 0;
            bit_counter <= 0;
            sample_counter <= 0;
            cycle_counter <= 0;
            rxshift_reg <= 10'b11_1111_1111;
            uart.valid_rx <= 0;
        end else begin  //  NORMAL OPERATION
            uart.valid_rx <= 0;  // No valid data until it is proven correct and will add later steps
          //     Checking whether cycle_counter == 26(Baud Rate).
            if (cycle_counter == div_counter - 1) begin
                cycle_counter <= 0;
                state <= nextstate;

                if (shift)
                    rxshift_reg <= {uart.Txd, rxshift_reg[9:1]};

                if (clear_samplecounter)
                    sample_counter <= 0;
                if (inc_samplecounter)
                    sample_counter <= sample_counter + 1;

                if (clear_bitcounter)
                    bit_counter <= 0;
                if (inc_bitcounter)
                    bit_counter <= bit_counter + 1;

                if (valid_rx_next)
                    uart.valid_rx <= 1;

            end else begin
                cycle_counter <= cycle_counter + 1;
            end
        end
    end

    always_comb begin
        shift = 0;
        clear_samplecounter = 0;
        inc_samplecounter = 0;
        clear_bitcounter = 0;
        inc_bitcounter = 0;
        valid_rx_next = 0;
        nextstate = state;

        case (state)

            0: begin
                if (!uart.Txd) begin
                    nextstate = 1;
                    clear_bitcounter = 1;
                    clear_samplecounter = 1;
                end
            end

            1: begin
                if (sample_counter == mid_sample)
                    shift = 1;

                if (sample_counter == div_sample - 1) begin
                    clear_samplecounter = 1;

                    if (bit_counter == total_bits - 1) begin
                        nextstate = 0;
                        valid_rx_next = 1;
                    end else begin
                        inc_bitcounter = 1;
                    end

                end else begin
                    inc_samplecounter = 1;
                end
            end

        endcase
    end

    assign uart.RxData = rxshift_reg[8:1];

endmodule
