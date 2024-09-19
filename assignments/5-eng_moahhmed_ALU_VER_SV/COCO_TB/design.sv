module alu (
    input wire clk,
    input wire reset_n,
    input wire [1:0] op_code,
    input wire signed [3:0] A,
    input wire signed [3:0] B,
    output reg signed [3:0] C,
    output reg overflow
);

    // Internal registers to hold the next state of C and overflow
    reg signed [3:0] C_next;
    reg overflow_next;

    // Combinational logic block
    always @(*) begin
        case(op_code)
            2'b00: begin
                C_next = A | B; // Bitwise OR operation
                overflow_next = 1'b0; // No overflow for OR operation
            end
            2'b01: begin
                C_next = A & B; // Bitwise AND operation
                overflow_next = 1'b0; // No overflow for AND operation
            end
            2'b10: begin
                C_next = A + B; // Addition operation
                // Check for overflow in addition
                overflow_next = (A[3] == B[3]) && (A[3] != C_next[3]);
            end
            2'b11: begin
                {overflow_next, C_next} = A - B; // Subtraction operation
                // Check for overflow in subtraction
                overflow_next = (A[3] != B[3]) && (A[3] != C_next[3]);
            end
        endcase
    end

    // Sequential logic block
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            overflow <= 1'b0; // Reset overflow flag
            C <= 4'sb0;       // Reset result
        end else begin
            overflow <= overflow_next; // Update overflow flag
            C <= C_next;               // Update result
        end
    end

endmodule
