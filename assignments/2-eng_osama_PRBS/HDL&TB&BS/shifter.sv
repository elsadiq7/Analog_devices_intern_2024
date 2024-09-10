module byte_4_shifter (clk, reset_n, load, state, in_byte_4, shifter_o_p,shifted_byte_4);

    // Inputs
    input clk, reset_n, load;               // Clock signal, active-low reset, and load signal to initialize the shifter
    input [31:0] in_byte_4;                 // 32-bit input data representing four 8-bit bytes
    input [2:0] state;                      // 3-bit state input to control shifter behavior
    // Outputs
    output [7:0] shifter_o_p;               // 8-bit output after shifting or randomizing logic

    // Internal byte signals extracted from the 32-bit input
    wire [7:0] by0 = in_byte_4[7:0];        // Byte 0 from the 32-bit input
    wire [7:0] by1 = in_byte_4[15:8];       // Byte 1 from the 32-bit input
    wire [7:0] by2 = in_byte_4[23:16];      // Byte 2 from the 32-bit input
    wire [7:0] by3 = in_byte_4[31:24];      // Byte 3 from the 32-bit input

    // Intermediate 32-bit shifted output from the byte shifters
    output wire [31:0] shifted_byte_4;

    // Instantiating four byte shifters, which shift each byte and output a shifted result
    byte_shifter bsh0 (clk, reset_n, load, by0, shifted_byte_4[15:8], shifted_byte_4[7:0]);      // Shifts Byte 0
    byte_shifter bsh1 (clk, reset_n, load, by1, shifted_byte_4[23:16], shifted_byte_4[15:8]);     // Shifts Byte 1
    byte_shifter bsh2 (clk, reset_n, load, by2, shifted_byte_4[31:24], shifted_byte_4[23:16]);    // Shifts Byte 2
    byte_shifter bsh3 (clk, reset_n, load, by3, shifted_byte_4[7:0], shifted_byte_4[31:24]);    // Shifts Byte 3

    // Selector logic to handle the state-based output selection
    selector s1 (state, shifted_byte_4, shifter_o_p);                           // Selects the output based on the state

endmodule : byte_4_shifter


module byte_shifter (clk, reset_n, load, in_byte, shifted_byte, shifter_o_p);
    // Inputs
    input clk, reset_n, load;                // Clock, active-low reset, and load signal
    input [7:0] in_byte, shifted_byte;       // 8-bit input byte and the next byte to shift to

    // Output
    output reg [7:0] shifter_o_p;            // 8-bit output byte after shifting or loading

    // Sequential logic for loading or shifting bytes
    always @(posedge clk or negedge reset_n) begin : seq
        if (~reset_n) begin
            shifter_o_p <= 8'b0;             // Reset the output to zero when reset is low
        end else if (load) begin
            shifter_o_p <= in_byte;          // Load the input byte when load signal is high
        end else begin
            shifter_o_p <= shifted_byte;     // Shift to the next byte if load is not active
        end
    end : seq

endmodule : byte_shifter


module selector (state, shifted_byte_4, out);

    // Inputs
    input [2:0] state;                       // 3-bit state signal to determine the behavior
    input [31:0] shifted_byte_4;             // 32-bit shifted data from the byte shifters

    // Output
    output reg [7:0] out;                    // 8-bit output byte depending on state
    reg [31:0]inter;

    // State definitions
    parameter [2:0] random = 3'd5;           // Defining a specific state for random logic

    // Combinational logic for state-based output selection
    always @(*) begin
        if (state == random) begin
            // Custom random logic: XOR bits and rearrange based on the defined pattern
            inter = (shifted_byte_4 << 2) ^ shifted_byte_4[13] ^ shifted_byte_4[14] ^ {shifted_byte_4[3:0], 2'b01};

            // Output more randomized bits using combination of rotated bits and 'inter'
            out = {shifted_byte_4[10:4], inter};
        
        end else begin
            // Default behavior: Select the least significant byte from shifted data
            out = shifted_byte_4[7:0];
            inter=32'd0;
          

        end
    end

endmodule : selector
