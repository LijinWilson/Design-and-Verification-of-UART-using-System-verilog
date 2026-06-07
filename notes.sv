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


















