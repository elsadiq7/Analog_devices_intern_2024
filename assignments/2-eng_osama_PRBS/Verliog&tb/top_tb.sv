
module test_bench( clk, reset_n, load, in_byte_4, count_N, shifter_out, state, counter, shifted_byte_4);

    // Inputs
    input clk;                               // Clock signal
    input [7:0] shifter_out;                 // 8-bit output from the byte_4_shifter
    input [2:0] state;                       // 3-bit state signal from the FSM
    input [3:0] counter;                     // 4-bit counter value
    input [31:0] shifted_byte_4;             // 32-bit shifted byte

    // Outputs
    output reg reset_n;                          // Active-low reset signal
    output reg load;                         // Load signal for initializing operations
    output reg [31:0] in_byte_4;             // 32-bit input byte for the shifter
    output reg [3:0] count_N;                // Number of counts for the counter

    // Internal variable
    int errors_sim=0;                           // Error counter

    // Initial block for testing
    initial begin
        errors_sim=0; 
        $display("----------------------------------------------------------------");

        $display("----------------------------------------------------------------");

        reset_n <= 1'b1;                     // Initialize reset_n to 1 (inactive)
        load <= 1'b0;                        // Initialize load to 0
        in_byte_4 <= 32'h96A5_32CF;          // Initialize in_byte_4 with a specific value
        count_N <= 4'd4;                     // Initialize count_N with 3
        $display("----------------------------------------------------------------");
        #10;
        // Test reset
        @(negedge clk) reset_n <= 1'b0;      // Assert reset_n (active low)
        assert property (reset_n_check)
            $display("@%0t,The reset_n is working",$time);
        else begin
            $display("@%0t,The reset isn't working",$time);
            errors_sim ++;
        end

        @(negedge clk) reset_n <= 1'b1;      // Deassert reset_n (inactive high)
        $display("----------------------------------------------------------------");

        // Test load
        @(negedge clk) load <= 1'b1;         // Assert load
        assert property (test_load)
            $display("@%0t,The load is working",$time);
        else begin
            $display("@%0t,The load isn't working",$time);
            errors_sim ++;
        end
        @(negedge clk) load <= 1'b0;         // Deassert load

       $display("----------------------------------------------------------------");

        // Test sequence
        @(negedge clk) load <= 1'b1;         // Assert load
       @(negedge clk) load <= 1'b0;         // Deassert load
        assert property (check_sequence)
            $display("@%0t,The sequence is working",$time);
        else begin
            $display("@%0t,The sequence isn't working",$time);
            errors_sim ++;
        end

       #300;
       $display("----------------------------------------------------------------");


        // Test random
        assert property (test_random)
            $display("@%0t,The randomaztion is working",$time);
        else begin
            $display("@%0t,The randomaztion isn't working",$time);
            errors_sim ++;
        end
       $display("----------------------------------------------------------------");


    end

    final begin
        $display("----------------------------------------------------------------");
        $display("@%0t,the number of error is:%0d",$time,errors_sim);
        $display("@%0t,the simulation is finished",$time);
       $display("----------------------------------------------------------------");
       $display("----------------------------------------------------------------");


    end

    // Property to check reset_n functionality
    property reset_n_check;
        @(posedge clk) (!reset_n) |->  (shifted_byte_4 == 32'd0);
    endproperty

    // Property to check load functionality
    property test_load;
        @(posedge clk)  (load) |-> ##1 (shifted_byte_4 == 32'h96A5_32CF);
    endproperty
 

    sequence  expected_sequence;
        @(posedge clk) shifter_out==8'hCF ##1 shifter_out==8'h32 ##1 shifter_out==8'hA5 ##1 shifter_out==8'h96 ##1 shifter_out==8'hCF ##1 shifter_out==8'h32 ##1 shifter_out==8'hA5 ##1 shifter_out==8'h96; 
    endsequence 

    // Property to check sequence functionality
    property check_sequence;
        @(posedge  clk) disable iff (~reset_n) expected_sequence;
    endproperty

    property test_random;
       @(posedge clk) disable iff (~reset_n) 
          (shifter_out != 8'h96 && shifter_out != 8'hA5 && shifter_out != 8'h32 && shifter_out != 8'hCF);
    endproperty




endmodule : test_bench


