// Module to generate a clock signal
module clock_generator (output bit clk);
  initial 
    // Toggle the clock signal every 5 time units
    forever #5 clk = !clk;
endmodule : clock_generator

// Top-level simulation module
module top_sim(
  output wire clk, reset_n, load,
  output wire [31:0] in_byte_4, shifted_byte_4,
  output wire [3:0] count_N, counter,
  output wire [7:0] shifter_out,
  output wire [2:0] state
);

  // Instantiate the clock generator
  clock_generator gen1(clk);

  // Instantiate the test bench
  test_bench tb1 (
    clk, reset_n, load, in_byte_4, count_N, 
    shifter_out, state, counter, shifted_byte_4
  );

  // Instantiate the top module
  top_module tm1 (
    clk, reset_n, load, in_byte_4, count_N, 
    shifter_out, state, counter, shifted_byte_4
  );

  initial begin
    // Specify the dump file for waveform viewing
    $dumpfile("test.vcd");
    // Dump all variables for waveform viewing
    $dumpvars;
    // Finish simulation after 600 time units
    #600 $finish;
  end

endmodule
