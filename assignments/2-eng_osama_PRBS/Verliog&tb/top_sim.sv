
module clock_generator (output bit clk);
  initial 
     forever #5  clk =!clk;

endmodule : clock_generator



module top_sim( clk, reset_n, load, in_byte_4, count_N, shifter_out, state, counter, shifted_byte_4);
   output wire clk,reset_n,load;
   output wire[31:0] in_byte_4,shifted_byte_4;
   output wire[3:0] count_N,counter;
   output wire[7:0]shifter_out;
   output wire[2:0]state;


   clock_generator gen1(clk);
   test_bench tb1  ( clk, reset_n, load, in_byte_4, count_N, shifter_out, state, counter, shifted_byte_4);
   top_module tm1  ( clk, reset_n, load, in_byte_4, count_N, shifter_out, state, counter, shifted_byte_4);

   initial begin
     $dumpfile("test.vcd");
     $dumpvars;
     #600 $finish;

   end

endmodule