module alu (
    intf.dut intf_inst      // Interface instance
);

    // Internal registers to hold the next state of C and overflow
    reg signed [3:0] C_next;
    reg overflow_next;

    // Combinational logic block
    always @(*) begin : comb
        case(intf_inst.op_code)
            2'b00: begin
                C_next = intf_inst.A | intf_inst.B; // Bitwise OR operation
                overflow_next = 1'b0; // No overflow for OR operation
            end
            2'b01: begin
                C_next = intf_inst.A & intf_inst.B; // Bitwise AND operation
                overflow_next = 1'b0; // No overflow for AND operation
            end
            2'b10: begin
                C_next = intf_inst.A + intf_inst.B; // Addition operation
                // Check for overflow in addition
                overflow_next = (intf_inst.A[3] == intf_inst.B[3]) && (intf_inst.A[3] != C_next[3]);
            end
            2'b11: begin
                {overflow_next, C_next} = intf_inst.A - intf_inst.B; // Subtraction operation
                // Check for overflow in subtraction
                overflow_next = (intf_inst.A[3] != intf_inst.B[3]) && (intf_inst.A[3] != C_next[3]);
            end
        endcase
    end : comb

    // Sequential logic block
    always @( posedge intf_inst.clk or negedge intf_inst.reset_n ) begin : seq
        if (~intf_inst.reset_n) begin
            intf_inst.overflow <= 1'b0; // Reset overflow flag
            intf_inst.C <= 4'sb0;       // Reset result
        end else begin
            intf_inst.overflow <= overflow_next; // Update overflow flag
            intf_inst.C <= C_next;               // Update result
        end
    end : seq

endmodule

