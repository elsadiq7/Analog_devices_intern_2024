module tb_cordic(clk,rst_n,select,enable,x_in,y_in,z_in,x_out,y_out,z_out,done);
    // Testbench signals
    output logic clk;
    output logic rst_n;
    output logic select;
    output logic enable;
    output logic signed [31:0] x_in;
    output logic signed [31:0] y_in;
    output logic signed [31:0] z_in;
    output logic signed [31:0] x_out;
    output logic signed [31:0] y_out;
    output logic signed [31:0] z_out;
    output logic done;
    

    logic signed [31:0] expected_x_out,expected_y_out,expected_z_out;
    int passed_cases,failed_cases;

  // Instantiate the CORDIC module
    cordic uut (
        .clk(clk),
        .rst_n(rst_n),
        .select(select),
        .enable(enable),
        .x_in(x_in),
        .y_in(y_in),
        .z_in(z_in),
        .x_out(x_out),
        .y_out(y_out),
        .z_out(z_out),
        .done(done)
    );



    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock period of 10 time units
    end

    
    // Test procedure
    initial begin
        passed_cases=0;
        failed_cases=0;
        //////////////////reset ////////////////////////////
        ////////////////////////////////////////////////////
        #4
        @(negedge clk) rst_n <= 0;
        @(posedge clk)
        passed_cases++;
        assert( (done == 0) && (x_out ==0) && (y_out==0) && (z_out==0))
        else begin
            failed_cases++;
            passed_cases--;
            $display("rest @%0t: reset failed",$time);
        end 
        rst_n = 1;  
        ////////////////////////////////////////////////////
        ////////////////////////////////////////////////////


        ////////////////////////////////////////////////////
        ////////////////////////////////////////////////////
        $display("Rotation Mode");
        //Rotation mode
        select = 0;
        enable = 1;

       //test 1 rotation 
        @(negedge clk);
        x_in = 32'h0100_0000;   //1
        y_in = 32'h0000_0000;   //0
        z_in = 32'b00000000110010010000111111011010;  // pi/4
        expected_x_out=32'b00000000101101010000010011110011;
        expected_y_out=32'b00000000101101010000010011110011;
        expected_z_out=32'd0;

        wait (done == 1);
        @(negedge clk) 
        passed_cases++;
        assert(((y_out - expected_y_out <= 32'h0000_ffff) || (expected_y_out - y_out <= 32'h0000_ffff)) && ((x_out - expected_x_out <=32'h0000_ffff) || (expected_x_out - x_out <= 32'h0000_ffff)))
        else begin
            failed_cases++;
            passed_cases--;
            $display("@%0t:xin=%0f,yin=%0f,zin=%0f,x_out = %0f,expected=%0f, y_out = %0f,expected=%0f",$time,fixed_to_float(x_in), fixed_to_float(y_in),fixed_to_float(z_in),fixed_to_float(x_out),fixed_to_float(expected_x_out),fixed_to_float(y_out),fixed_to_float(expected_y_out)); 
        end 


        //test 2 rotation 
        @(negedge clk);
        x_in = 32'h0100_0000;  //1
        y_in = 32'b00000000001000000000000000000000;  //.125
        z_in = 32'b00000001001010110101101111011111;  //67 deg
        expected_x_out=32'b00000000010001100111101000001111;
        expected_y_out=32'b00000000111110000010010000001011;
        expected_z_out=32'd0;
        
        wait (done == 1);
        @(negedge clk) 
        passed_cases++;
        assert(((y_out - expected_y_out <= 32'h0000_ffff) || (expected_y_out - y_out <= 32'h0000_ffff)) && ((x_out - expected_x_out <=32'h0000_ffff) || (expected_x_out - x_out <= 32'h0000_ffff)))
        else begin
            failed_cases++;
            passed_cases--;
            $display("@%0t:xin=%0f,yin=%0f,zin=%0f,x_out = %0f,expected=%0f, y_out = %0f,expected=%0f",$time,fixed_to_float(x_in), fixed_to_float(y_in),fixed_to_float(z_in),fixed_to_float(x_out),fixed_to_float(expected_x_out),fixed_to_float(y_out),fixed_to_float(expected_y_out)); 
        end 

      
        ////////////////////////////////////////////////////
        ////////////////////////////////////////////////////
        @(negedge clk)
        $display("vectoring Mode");
        //vectoring mode
        select = 1;
        enable = 1;

       //test 1 vectroing 
        @(negedge clk);
        x_in = 32'b00000000110000000000000000000000;   //.75
        y_in = 32'b00000000011011100001010001111010;   //.43
        z_in = 32'd0;  
        expected_x_out=32'b00000000110111010010111100011010;
        expected_y_out=32'd0;
        expected_z_out=32'b00000000100001010100011000001010;




        wait (done == 1);
        @(negedge clk) 
        passed_cases++;
        assert(((z_out - expected_z_out <= 32'h0000_ffff) || (expected_z_out - z_out <= 32'h0000_ffff)) && ((x_out - expected_x_out <=32'h0000_ffff) || (expected_x_out - x_out <= 32'h0000_ffff)))
        else begin
            failed_cases++;
            passed_cases--;
            $display("@%0t:xin=%0f,yin=%0f,zin=%0f,x_out = %0f,expected=%0f, z_out = %0f,expected=%0f",$time,fixed_to_float(x_in), fixed_to_float(y_in),fixed_to_float(z_in),fixed_to_float(x_out),fixed_to_float(expected_x_out),fixed_to_float(z_out),fixed_to_float(expected_z_out)); 
        end 


      
       //test 2 vectroing 
        @(negedge clk);
        x_in = 32'b00000001000000000000000000000000;   //1
        y_in = 32'b00000000100000000000000000000000;   //.5
        z_in = 32'd0;  
        expected_x_out=32'b00000001000111100011011101111001;
        expected_y_out=32'd0;
        expected_z_out=32'b00000000011101101011000110011100;

        wait (done == 1);
        @(negedge clk) 
        passed_cases++;
        assert(((z_out - expected_z_out <= 32'h0000_ffff) || (expected_z_out - z_out <= 32'h0000_ffff)) && ((x_out - expected_x_out <=32'h0000_ffff) || (expected_x_out - x_out <= 32'h0000_ffff)))
        else begin
            failed_cases++;
            passed_cases--;
            $display("@%0t:xin=%0f,yin=%0f,zin=%0f,x_out = %0f,expected=%0f, z_out = %0f,expected=%0f",$time,fixed_to_float(x_in), fixed_to_float(y_in),fixed_to_float(z_in),fixed_to_float(x_out),fixed_to_float(expected_x_out),fixed_to_float(z_out),fixed_to_float(expected_z_out)); 
        end 
        



        // End simulation
        $display("Number of passed cases:%0d",passed_cases);
        $display("Number of failed cases:%0d",failed_cases);
        $finish;
    end
function real fixed_to_float(input logic signed [31:0] fixed_val);
    real result;

    // Convert fixed-point to floating-point
    result = fixed_val / (2.0 **24);

    return result;
endfunction
endmodule








// module cordic_tb(
//     output logic clk,                             // Clock signal
//     output logic rst_n,                           // Active low reset signal
//     output logic select,                          // Select signal for the CORDIC operation
//     output logic signed [31:0] x_in,             // Input x coordinate
//     output logic signed [31:0] y_in,             // Input y coordinate
//     output logic signed [31:0] z_in,             // Input angle or rotation
//     output logic signed [31:0] x_out,            // Output x coordinate after processing
//     output logic signed [31:0] y_out,            // Output y coordinate after processing
//     output logic signed [31:0] z_out,            // Output angle after processing
//     output logic done                             // Signal indicating completion of processing
// );

//     // Parameter definitions for input and output signal lengths
//     parameter in_len = 32;                        // Length of input signals
//     parameter out_len = 32;                       // Length of output signals

//     // File handles for reading input-output data
//     integer file_vector;                          // File handle for vector data
//     integer file_rot;                             // File handle for rotation data
//     integer errors_num,passes_cased_num;  

//     // Instantiate the CORDIC module
//     cordic u_cordic (
//         .clk(clk),
//         .rst_n(rst_n),
//         .x_in(x_in),
//         .select(select),
//         .y_in(y_in),
//         .z_in(z_in),
//         .x_out(x_out),
//         .y_out(y_out),
//         .z_out(z_out),
//         .done(done)
//     );

//     // Clock generation: Toggle clock every 5 time units
//     always #5 clk = ~clk;

//     // Initial block: Initialize signals, open file, and run the test
//     initial begin
//         errors_num=0;
//         passes_cased_num=0;  

//         clk <= 0;                                 // Initialize clock to 0
//         rst_n <= 1'b1;                            // Set reset to high (inactive)
//         #5
//         @(negedge clk) rst_n <= 1'b0;            // Activate reset on the falling edge of the clock
        
//         // Test reset functionality
//         passes_cased_num++;
//         @(posedge clk) 
//             assert (x_out == 0 && z_out==0 && y_out==0) 
//             $display("@%0t: Reset is working", $time); 
//         else begin 
//             errors_num++; 
//             passes_cased_num--;  
//             $display("@%0t: Error in reset x_out,y_out,z_out=", $time,x_out,y_out,z_out); 
//         end 

//         @(negedge clk) repeat(2); 
//         rst_n <= 1'b1;                           // Deactivate reset
//         select<=1'd0;
//         // make x_in ,y_in equal  =1,0 tpo make x_out, y_out cos ,sin of zin
//         x_in<=32'h0000_0000_1000_0000;
//         y_in<=32'd0;
//         $display("start testing of rotating ");
//         // Open the input-output data file
//         open_file("../test_files/in_out_cordic_rot.txt", file_vector);

//         // Read from the file and run the test cases
//         read_from_file_run(file_vector, x_in, y_in, z_in, x_out, y_out, z_out, errors_num, passes_cased_num);
//     end

//     // VCD dump: Generate waveform file for debugging
//     initial begin
//         $dumpfile("test.vcd");                   // Create a VCD file for waveform dumping
//         $dumpvars;                               // Dump all variables
//         #15000
//         // Display results at the end of the simulation
//         $display("@%0t: Number of errors: %0d", $time, errors_num);
//         $display("@%0t: Number of passed cases: %0d", $time, passes_cased_num);
//         $finish;                                  // End simulation
//     end
// function real fixed_to_float(input logic signed [31:0] fixed_val);
//     real result;

//     // Convert fixed-point to floating-point
//     result = fixed_val / (2.0 **28);

//     return result;
// endfunction
//     // Task to open a file for reading input-output data
//     task open_file;
//         input string path;                       // File path to open
//         output integer file;                     // File handle

//         file = $fopen(path, "r");                // Open the file for reading

//         // Check if the file opened successfully
//         if (file == 0) begin
//             $display("@%0t: Error opening file: %s", $time, path);
//             $finish;                             // Exit if the file cannot be opened
//         end else begin
//             $display("@%0t: File opened successfully: %s", $time, path);
//         end
//     endtask: open_file

//     // Task to read data from the file and run tests
//     task automatic read_from_file_run(
//         input integer file,                      // File handle
//         ref logic signed [in_len-1:0] x_in, y_in, z_in, // Input signal references
//         ref logic signed  [out_len-1:0] x_out, y_out, z_out, // Output signal references
//         ref integer errors_num,                  // Error count reference
//         ref integer passes_cased_num             // Pass count reference
//     );

//         integer status;                          // Status variable for file reading
//         string line;                             // Store each line as a string
//         logic [in_len-1:0] zin;                  // Input from the file
//         logic [out_len-1:0] cos_, sin_;          // Expected output from the file
//         integer line_num = 0;                    // Line number counter

//         // Read data from the file until EOF or specified limit
//         while (!$feof(file)) begin
//             line = "";                            // Clear line string
//             status = $fgets(line, file);         // Read a line from the file
//             if (status != 0) begin               // Check if fgets was successful
//                 line_num++;                       // Increment line number
//                 status = $sscanf(line, "%b %b %b", zin, cos_, sin_);  // Parse input and output from the line

//                 if (status == 3) begin           // Ensure both in and out are read
//                     // Proceed with the simulation for the current line
//                     $display("##########################################");
//                     $display("Line %0d: zin=%0f, cos=%0f ,sin=%0f", line_num, fixed_to_float(z_in), fixed_to_float(cos_),fixed_to_float(sin_));  // Display parsed values
//                     run_sim(zin, cos_, sin_, line_num, z_in, x_out, y_out, errors_num, passes_cased_num);
//                     $display("##########################################");
//                 end else begin
//                     $display("##########################################");
//                     $display("Error parsing line %0d: %s", line_num, line);  // Error in parsing
//                 end
//             end else begin
//                 $display("Error reading data from line %0d", line_num); // Reading error
//                 $finish;                                  // Exit if error occurs
//             end
//         end
//         $fclose(file);  // Close the file
//     endtask: read_from_file_run



//     // Task to run the simulation for each case
// task automatic run_sim(
//         input logic signed [in_len-1:0] zin,           // Input data
//         input logic signed [out_len-1:0] cos_, sin_,   // Expected output data
//         input integer line_num,                  // Line number (for error reporting)
//         ref logic signed [in_len-1:0] z_in,            // Input signal (reference)
//         ref logic signed [out_len-1:0] x_out, y_out,   // Output signal (constant reference)
//         ref integer errors_num,                  // Error counter (reference)
//         ref integer passes_cased_num             // Passed cases counter (reference)
//     );

//         // Step 1: Apply input to the DUT at the falling edge of the clock
//         @(negedge clk) 
//             z_in = zin;

//         // Step 2: Check output at the next falling edge of the clock
//         #146;

//         // Step 3: Compare outputs for y_out with expected sin_ and x_out with expected cos_

//         // Check for y_out (sin) and x_out (cos)
//         if () begin
//             passes_cased_num++;
//             $display("%0t: Assertion passed at line  %0d: zin =  %0f, cos =  %0f, expected = %0f, sin = %0f, expected = %0f", $time, line_num, fixed_to_float(z_in), fixed_to_float(x_out), fixed_to_float(cos_), fixed_to_float(y_out), fixed_to_float(sin_));
//         end else begin
//             $display("%0t: Assertion failed at line  %0d: zin =  %0f, cos =  %0f, expected = %0f, sin = %0f, expected = %0f", $time, line_num, fixed_to_float(z_in), fixed_to_float(x_out), fixed_to_float(cos_), fixed_to_float(y_out), fixed_to_float(sin_));
//             errors_num++;
//         end
//     endtask: run_sim



// endmodule