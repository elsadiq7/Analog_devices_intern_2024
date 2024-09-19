
package test_pack;
    
    import alu_env ::* ;
    import trans::* ; 
class test;

    env e0;
    mailbox drv_mbx;

    // Constructor to initialize the mailbox and environment
    function new();
        drv_mbx = new();
    endfunction

    // Task to run the environment and apply stimulus
    virtual task run(virtual intf intf_tb);

         e0 = new(intf_tb);
        e0.d0.driver_mailbox = drv_mbx;

        fork
            e0.run();
        join_none

        apply_stim();
    endtask

    // Task to apply stimulus
    virtual task apply_stim();
        Transaction_object item = new() ;

        $display("T=%0t [Test] Starting stimulus ...", $time);

        // Test case 1: OR operation
        item = new;
        item.reset_n = 1;
        item.op_code = 2'b00;
        item.A = 4'sb0101;
        item.B = 4'sb0011;
        drv_mbx.put(item);
        #10; // Wait for 10 time units

        // Test case 2: AND operation
        item = new;
        item.reset_n = 1;
        item.op_code = 2'b01;
        item.A = 4'sb0101;
        item.B = 4'sb0011;
        drv_mbx.put(item);
        #10; // Wait for 10 time units

        // Test case 3: Addition operation
        item = new;
        item.reset_n = 1;
        item.op_code = 2'b10;
        item.A = 4'sb0111;
        item.B = 4'sb0001;
        drv_mbx.put(item);
        #10; // Wait for 10 time units

        // Test case 4: Subtraction operation
        item = new;
        item.reset_n = 1;
        item.op_code = 2'b11;
        item.A = 4'sb0111;
        item.B = 4'sb0001;
        drv_mbx.put(item);
        #10; // Wait for 10 time units

        // Test case 5: Addition with overflow
        item = new;
        item.reset_n = 1;
        item.op_code = 2'b10;
        item.A = 4'sb0111;
        item.B = 4'sb0111;
        drv_mbx.put(item);
        #10; // Wait for 10 time units

        // Test case 6: Subtraction with overflow
        item = new;
        item.reset_n = 1;
        item.op_code = 2'b11;
        item.A = 4'sb1000;
        item.B = 4'sb0111;
        drv_mbx.put(item);
        #10; // Wait for 10 time units
    endtask

endclass


endpackage : test_pack