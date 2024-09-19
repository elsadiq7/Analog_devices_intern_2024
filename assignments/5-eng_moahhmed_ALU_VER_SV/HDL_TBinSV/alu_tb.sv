module top(clk);

    output bit clk;
    intf intf_inst(clk); // Instantiate the interface

    // Instantiate the ALU module and connect the interface
    alu alu_inst (
        .intf_inst(intf_inst.dut)
    );

    // Clock generation
  
    always #5 clk = ~clk;
    


    // Testbench logic
    initial begin
        // Initialize signals
        intf_inst.reset_n = 0;
        intf_inst.op_code = 2'b00;
        intf_inst.A = 4'sd0;
        intf_inst.B = 4'sd0;

        // Release reset
        #10 intf_inst.reset_n = 1;

        // Apply test vectors
        #10 intf_inst.op_code = 2'b10; intf_inst.A = 4'sd3; intf_inst.B = 4'sd2;
        #10 intf_inst.op_code = 2'b11; intf_inst.A = 4'sd3; intf_inst.B = 4'sd5;
        #10 intf_inst.op_code = 2'b00; intf_inst.A = 4'sd1; intf_inst.B = 4'sd1;
        #10 intf_inst.op_code = 2'b01; intf_inst.A = 4'sd1; intf_inst.B = 4'sd1;

        // Finish simulation
        #50 $finish;
    end
endmodule