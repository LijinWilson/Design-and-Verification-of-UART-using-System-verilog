// ================================= UART TESTBENCH ARCHITECURE ===================================

/*
  -  It follows UVM like testing architecture.
  -  🔧 Testbench Components:
        -  Test (Top Level) – Initializes the entire testbench and controls simulation flow.
        -  Environment – Creates and connects all components using mailboxes.
            • gen2drv mailbox: Transfers transactions from Generator to Driver.
            • mon2scb mailbox: Transfers observed data from Monitor to Scoreboard.
        -  Generator – Creates test stimulus (UART transactions).
        -  Transaction – Class object holding a single data byte for UART transfer.
        -  Driver – Retrieves transactions from gen2drv mailbox and drives DUT inputs.
        -  Monitor – Captures DUT outputs and sends them to mon2scb mailbox.
        -  Scoreboard – Compares expected vs actual data and gives PASS/FAIL results.
        -  Interface – Connects Testbench to DUT (Tx and Rx lines).
        -  DUT (UART) – Transmitter and Receiver logic to be verified.
*/

/*
+------------------------------------------------------------------+
|                              test                                |
|  +------------------------------------------------------------+  |
|  |                              env                           |  |
|  |                                                            |  |
|  |        +---------------------------------------------+     |  |
|  |        |                 scoreboard                 |      |  |
|  |        +---------------------------------------------+     |  |
|  |                     ^    ^                                 |  |
|  |                     |    |                                 |  |
|  |      +--------------|---------------------------------+    |  |
|  |      |              |       agent                    |     |  |
|  |      |              |                                |     |  |
|  |      |  transaction |            +-----------+       |     |  |
|  |      |        [ ]   |           | generator |        |     |  |
|  |      |              |            +-----------+       |     |  |
|  |      |              |                 |              |     |  |
|  |      |              |           transaction          |     |  |
|  |      |              |                 v              |     |  |
|  |      |     +-----------+        +-----------+        |     |  |
|  |      |     |  monitor  |        |   driver  |        |     |  |
|  |      |     +-----------+        +-----------+        |     |  |
|  |      |           ^                   ^               |     |  |
|  |      +-----------|-------------------|---------------+     |  |
|  |                  |                   v                     |  |
|  +------------------|----------------------------------------+  |
|                     |                                         |
|        +---------------------------------------------+        |
|        |                 interface                   |        |
|        +---------------------------------------------+        |
|                     ^                     |                   |
|                     |                     v                   |
|        +---------------------------------------------+        |
|        |                     DUT                     |        |
|        +---------------------------------------------+        |
+------------------------------------------------------------------+
*/

// ---------------------------------- TEST FLOW ----------------------------------
/*
  -  Generator(gen2drv) -> Driver(TXData, transmit) -> DUT(Tx->Rx) -> Monitor(mon2scb) -> Score board -> Pass or Fail Result. 
*/










