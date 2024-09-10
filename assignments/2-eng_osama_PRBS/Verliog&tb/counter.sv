module count (clk, reset_n, load, state, count);

    // Inputs
    input clk, reset_n, load;               // Clock, active-low reset, and load signal to initialize counter
    input [2:0] state;                      // Current FSM state

    // Outputs
    output reg [3:0] count;                 // 4-bit counter output

    // Parameters
    parameter [2:0] state3 = 3'd4;          // Pattern detection state, triggering counter increment

    // Sequential logic for counting
    always @(posedge clk or negedge reset_n) begin : seq
        if (~reset_n) begin
            count <= 4'b0;                  // Reset counter to 0 when reset is active
        end else if (load) begin
            count <= 4'b0;                  // Reset counter when load signal is asserted
        end else if (state == state3) begin
            count <= count + 1;             // Increment counter in state3
        end else begin
            count <= count;                 // Maintain current count in other states
        end
    end : seq

endmodule : count
