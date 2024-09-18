interface intf (input bit clk);
    logic reset_n;        // Active-low reset signal
    logic [1:0] op_code;  // Operation code to select the operation
    logic signed [3:0] A; // First operand
    logic signed [3:0] B; // Second operand
    logic signed [3:0] C; // Result of the operation
    logic overflow;       // Overflow flag

    modport dut (input clk, reset_n, op_code, A, B, output C, overflow);
endinterface : intf
