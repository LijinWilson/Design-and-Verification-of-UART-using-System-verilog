// ========================== UNIVERSAL ASYNCHRONOUS RECIEVER/TRANSMITTER ==========================

/*
  -  SERIAL COMMUNICATION: Data are sent serially between 2 devices.
  -  ASYNCHRONOUS: No clock is used for syncheronization. DATA SYNCHRONIZATION is done by Controlling the data transmission speed(Baud Rate).
  -  OPERATION/COMMUNICATION: peer to peer and AD-HOC Method.
                                - PEER TO PEER: No master slave concept
                                - AD-HOC: No inbuilt synchronization methods.
  -  
*/

// ------------------------------ DATA TRANSMISSION ------------------------------
/*
  -  One to One communication.
  -  Tranmission bit order: {START_BIT(0), DATA(8bit), PARITY_BIT(Optional), STOP_BIT(1 or more stop bit)}.
  -  Consider two devices A and B:
      -  Transmitter of A is connected to the reciever of B and vice versa.
      -  Transmitter line remain during ideal condition and transmission is initiated by making the line 0 by start bit.
      -  STOP BIT: 1 or more stop bit are send to make the transmitter line back to high(1) in ideal case.
      
*/

// ------------------------------ UART Synchronization ------------------------------

/*
  -  Consider Device A and B.
  -  BAUD RATE Synchronization: Here synchronizatio between the two device are synchronized by giving same BAUD RATE.
  -  Device A and B are configured to use same BAUD RATE.
  -  Each device use its clock to match the BAUD RATE.

  
  - *** BAUD RATE Synchronization using internal clock. ***
      -  BAUD RATE is of 9600 and 115200, in this project we are using 115200.
      -  Matching BAUD RATE
          -  Formula: Clock/BAUD RATE.
          -  For Device A TX
              -  TX -> its clock freq is of 100MHz.
                  -  100,000,000/115200  =  868 cycles per bit  =>  BAUD RATE = 8.68μs (time per bit).
          -  For Device B
              -  RX -> Clock freq is 50MHz.
                  -  50,000,000/115200  =  434 cycles per bit  =>  BAUD RATE = 8.68μs (time per bit). 
      - >> Here Device with different internal clock but we make data rate in synchronization. <<
*/

/*
  -  DETEECTING START BIT
      -  Reciever device B will be waiting for a falling edge (1 -> 0), which signals a start bit.
      -  When receiver sees the line go from 1 to 0, it understands that transmission has started. 
      -  It resets its internal timing and uses that moment as a reference to correctly sample all upcoming bits at the right time.
*/

/*
  -  OverSampling Accuracy
      -  In 16× oversampling, the receiver checks the same signal 16 times within one bit period (1/baud rate),
      -  it uses the middle sample (around the 8th) to decide the bit value.
*/

/*
  -  Data Shifting parallel to serial and vice versa.
      -  Data coming to TX of A is in parallel form, Inside a parellel to serial shift register is used to convert the data from parallel to serial
      -  This shift register is using the clock for shifting operation.
      -  Same for RX side a shift register is used to convert the data from serial to back in parallel.
*/

/*
===============================================================================
        UART TRANSMITTER TIMING AND INTERNAL VARIABLES
===============================================================================

Parameter / Variable              Value / Formula              Result / Explanation
-------------------------------------------------------------------------------

Clock Frequency (clk_freq)        50,000,000 Hz                50 MHz

Time Period of 1 Clock Cycle      1 / clk_freq                 20 ns

Baud Rate                         115200                       Standard UART speed

Time for 1 Bit Transmission       1 / baud_rate                8680 ns (approx.)

Clock Cycles per Bit              clk_freq / baud_rate         50,000,000 / 115200
(div_counter)                                                 = 434 clock cycles

No. of Bits Required for          ceil(log2(434))              9 bits
cycle_counter                                                 (since 2^9 = 512 > 434)

Bit Index (bit_index)             0 to 9                       10 bits total
                                                             (1 start, 8 data, 1 stop)

Transmission Shift Register       {1'b1, TxData, 1'b0}         10-bit shift register
(tx_shift)                                                    [stop][data][start]

Total Transmission Time           10 / baud_rate               86.8 µs per byte
for 10 bits

Total Clock Cycles per Byte       10 * div_counter             10 * 434
                                                             = 4340 clock cycles

===============================================================================
*/

/*
===============================================================================
        UART RECEIVER TIMING AND INTERNAL VARIABLES
===============================================================================

Parameter / Variable              Value / Formula              Result / Explanation
-------------------------------------------------------------------------------

Clock Frequency (clk_freq)        50,000,000 Hz                50 MHz

Time Period of 1 Clock Cycle      1 / clk_freq                 20 ns

Baud Rate                         115200                       Standard UART speed

Time for 1 Bit Transmission       1 / baud_rate                8680 ns

Oversampling Rate (div_sample)    16                           UART is sampled 16 times per bit

Sampling Clock Cycles per Bit     clk_freq / (baud_rate *      50,000,000 / (115200 * 16)
                                  div_sample)                 = 434 / 16 = 27 clock cycles

Clock Cycles per Sample           27                           Each sample occurs every
(div_counter)                                                  27 clock cycles

No. of Bits Required for          ceil(log2(27))               5 bits
cycle_counter                                                 (since 2^5 = 32 > 27)

Total UART Frame Length           10                           1 start + 8 data + 1 stop
(total_bits)

Shift Register (rxshift_reg)      10 bits                      Stores full UART frame:
                                                             [stop][data][start]

Valid Output Byte (RxData)        rxshift_reg[8:1]             Extracted data
                                                             (excluding start & stop bits)

Total Time per Byte               10 / baud_rate               86.8 µs
                                                             (same as transmitter)

===============================================================================
*/














