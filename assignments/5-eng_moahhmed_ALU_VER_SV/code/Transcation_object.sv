package trans ;
    class Transaction_object;

        bit reset_n;        // Active-low reset signal
        bit [1:0] op_code;  // Operation code to select the operation
        bit signed [3:0] A; // First operand
        bit signed [3:0] B; // Second operand
        bit signed [3:0] C;      // Result of the operation
        bit overflow;            // Overflow flag

        // Function to print the content of the packet
        function void print(string tag="");
            $display("%s: reset_n=%b, op_code=%b, A=%d, B=%d, C=%d, overflow=%b", 
                     tag, reset_n, op_code, A, B, C, overflow);
        endfunction : print

        // Function to copy the content from another Transaction_object
        function void copy(Transaction_object tmp);
            this.reset_n = tmp.reset_n;
            this.op_code = tmp.op_code;
            this.A = tmp.A;
            this.B = tmp.B;
            this.C = tmp.C;
            this.overflow = tmp.overflow;
        endfunction : copy

    endclass : Transaction_object
endpackage     