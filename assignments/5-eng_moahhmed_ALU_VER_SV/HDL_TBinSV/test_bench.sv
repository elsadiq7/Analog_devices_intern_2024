import test_pack::* ;



module tb;
    bit clk;
    intf intf_tb(clk); // Instantiate the interface

    // Declare the virtual interface
    virtual intf v_intf_tb;

    // Clock generation
    always #10 clk = ~clk;

    // Instantiate the DUT
    alu dut (intf_tb.dut); // Connect the interface to the DUT

    test t1;
    initial begin
        v_intf_tb = intf_tb; // Assign the interface to the virtual interface
        t1 = new; // Pass the virtual interface to the test class

        // Initialize signals
        clk <= 0;
        intf_tb.reset_n <= 0;
        #20 intf_tb.reset_n <= 1;

        t1.run(intf_tb);

        #200 $finish;
    end

    // Simulator dependent system tasks that can be used to
    // dump simulation waves.
    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end
endmodule