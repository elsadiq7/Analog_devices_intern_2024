module top;

    // Declare the clock signal
    reg clk;
    
    // Declare the signals for the ALU
    reg reset_n;
    reg [1:0] op_code;
    reg signed [3:0] A;
    reg signed [3:0] B;
    wire signed [3:0] C;
    wire overflow;

    // Instantiate the ALU module
    alu alu_tb (
        .clk(clk),
        .reset_n(reset_n),
        .op_code(op_code),
        .A(A),
        .B(B),
        .C(C),
        .overflow(overflow)
    );

    // Initial block for simulation
    initial begin
        $dumpfile("file.vcd");
        $dumpvars(0, top);
    end


endmodule