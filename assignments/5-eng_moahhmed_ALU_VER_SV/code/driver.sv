package alu_drv ;
  import trans ::* ;
  class driver;

    virtual intf intf_drv;  // Declare the virtual interface
    mailbox driver_mailbox; // Mailbox for transaction communication

    task run();

      $display("T:%0t [Driver] starting ...", $time);

      forever begin

        Transaction_object item = new() ;

        @(negedge  intf_drv.clk);  // Wait for a positive clock edge

        $display("T:%0t [Driver] waiting for item ...", $time);

        driver_mailbox.get(item) ;  // Get transaction from the mailbox
        item.print("Driver");

        // Drive the signals onto the interface
        intf_drv.reset_n = item.reset_n;
        intf_drv.op_code = item.op_code;
        intf_drv.A  = item.A;
        intf_drv.B  = item.B;

      end
      
    endtask : run

  endclass : driver
endpackage 