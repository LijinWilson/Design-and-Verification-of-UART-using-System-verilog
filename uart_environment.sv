class environment;
    generator g;  //  Creat the test data.
  driver d;  //  used to send data to DUT
    monitor m;  // observe DUT output 
    scoreboard s;  // check the correctness of the data.

    mailbox gen2drv = new();
    mailbox mon2scb = new();
    virtual uart_if uart;

    function new(virtual uart_if uart);
        this.uart = uart;
        g = new(gen2drv);
        d = new(uart, gen2drv);
        m = new(uart, mon2scb);
        s = new(mon2scb);
    endfunction

  // All four component run in parallel,so used the Fork Join
    task run();
        fork
            g.run();
            d.run();
            m.run();
            s.run();
        join
    endtask
endclass
