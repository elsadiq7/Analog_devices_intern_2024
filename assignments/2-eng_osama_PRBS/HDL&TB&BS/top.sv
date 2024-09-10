module top_module (clk, reset_n, load, in_byte_4, count_N,shifter_out,state,counter,shifted_byte_4);

    // Inputs
    input clk;                               // Clock signal
    input reset_n;                           // Active-low reset signal
    input load;                              // Load signal for initializing operations
    input [31:0] in_byte_4;                  // 32-bit input byte for the shifter
    input [3:0] count_N;                     // Number of counts for the counter

    // Outputs

    output [7:0] shifter_out;                  // 8-bit output from the byte_4_shifter
    output [2:0] state;                        // 3-bit state signal from the FSM
    output [3:0] counter;                      // 4-bit counter value
    output [31:0]shifted_byte_4;

    // Instantiate FSM module
    fsm fsm_inst (
        .clk(clk), 
        .reset_n(reset_n), 
        .load(load), 
        .shifter_out(shifter_out), 
        .counter(counter), 
        .count_N(count_N), 
        .in_byte(in_byte_4), 
        .state(state));

    // Instantiate Counter module
    count counter_inst (
        .clk(clk), 
        .reset_n(reset_n), 
        .load(load), 
        .state(state), 
        .count(counter)
    );

    // Instantiate Byte Shifter module
    byte_4_shifter shifter_inst (
        .clk(clk), 
        .reset_n(reset_n), 
        .load(load), 
        .state(state), 
        .in_byte_4(in_byte_4), 
        .shifter_o_p(shifter_out),
        .shifted_byte_4(shifted_byte_4)
    );

endmodule : top_module
