package alu_scb ;
    import trans::*;
    class scoreboard;

        // Mailbox to receive transactions from the monitor
        mailbox scb_mbx;

        // Task to compare the actual and expected results
        task run();
            Transaction_object trans;
            bit signed [3:0] expected_C;
            bit expected_overflow;
            forever begin
                scb_mbx.get(trans); // Get the transaction from the mailbox
     
                // Calculate the expected result based on the operation code
                case (trans.op_code)
                    2'b00: begin
                        expected_C = trans.A | trans.B;
                        expected_overflow = 1'b0;
                    end
                    2'b01: begin
                        expected_C = trans.A & trans.B;
                        expected_overflow = 1'b0;
                    end
                    2'b10: begin
                        expected_C = trans.A + trans.B;
                        expected_overflow = (trans.A[3] == trans.B[3]) && (trans.A[3] != expected_C[3]);
                    end
                    2'b11: begin
                        {expected_overflow, expected_C} = trans.A - trans.B;
                        expected_overflow = (trans.A[3] != trans.B[3]) && (trans.A[3] != expected_C[3]);
                    end
                endcase

                // Compare the actual and expected results
                if (trans.C !== expected_C || trans.overflow !== expected_overflow) begin
                    $error("Mismatch: op_code=%b, A=%d, B=%d, Expected C=%d, Actual C=%d, Expected overflow=%b, Actual overflow=%b",
                           trans.op_code, trans.A, trans.B, expected_C, trans.C, expected_overflow, trans.overflow);
                end else begin
                    $display("Match: op_code=%b, A=%d, B=%d, C=%d, overflow=%b",
                             trans.op_code, trans.A, trans.B, trans.C, trans.overflow);
                end
            end
        endtask

    endclass
endpackage     