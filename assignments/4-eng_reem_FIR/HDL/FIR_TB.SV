
module fir_tb(clk,rst_n,x_n,y_n,ff1,ff2,ff3);

    // Declare parameters
    parameter in_len = 20;     //15 fraction 5 signed int   // Input signal length
    parameter out_len = 20;       // Output signal length

    // Declare clock and reset signals
    output reg clk;                      // Clock signal
    output reg rst_n;                    // Active-low reset signal

    // Declare input and output signals
    output logic [in_len-1:0] x_n;       // Input signal (x_n)
    output logic [out_len-1:0] y_n;       // Output signal (y_n)


    // Declare integer variables for file handling, error count, and pass count
    integer file;
    integer errors_num = 0;       // Error counter
    integer passes_cased_num = 0; // Passed test cases counter

    // Instantiate the FIR filter module
    fir #(.in_len(in_len), .out_len(out_len)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .x_n(x_n),
        .y_n(y_n)
    );
    
    output wire [out_len-1:0] ff1,ff2,ff3;
     assign ff1=dut.ff1;
     assign ff2=dut.ff2;
     assign ff3=dut.ff3; 
    // Initial block: initialize signals, open file, and run the test
    initial begin
        clk <= 0;                             // Initialize clock to 0
        rst_n <= 1'b1;                        // Initialize reset to high (inactive)
        //x_n <= {in_len{1'b0}};                // Initialize input signal to zero
        #5
        @(negedge clk) rst_n<=1'b0;
        
        passes_cased_num++;
        @(posedge clk)  assert (y_n==0) $display("@%0t:reset is working",$time); else begin errors_num++; passes_cased_num--;  $display("@%0t:Error in reset",$time); end 

        @(negedge clk) repeat(2);rst_n<=1'b1;



        // // Open the input-output data file
        open_file("D:/in_op.txt", file);

        // // Read from the file and run the test casesAssertion failed
        read_from_file_run(file, x_n, y_n, errors_num, passes_cased_num);

    end



    // VCD dump: generate waveform file for debugging
    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
        #7000
        //display results at the end of the simulation
        $display("@%0t:Number of errors: %0d",$time, errors_num);
        $display("@%0t:Number of passed cases: %0d",$time, passes_cased_num);
        $finish;    // End simulation after 1500 time units
    end


    // Clock generation: Toggle clock every 5 time units
    always #5 clk = ~clk;


    // Task to open a file for reading input-output data
    task open_file;
        input string path;
        output integer file;

        file = $fopen(path, "r");

        // Check if the file is opened successfully
        if (file == 0) begin
            $display("@%0t:Error opening file: %s",$time, path);
            $finish;
        end
        else  begin
           $display("@%0t:file is opened: %s",$time, path);

        end
    endtask: open_file

task automatic read_from_file_run(
    input integer file,                                // File handle
    ref logic [in_len-1:0] x_n,                        // Input signal reference
    ref logic [out_len-1:0] y_n,                       // Output signal reference
    ref integer errors_num,                            // Error count reference
    ref integer passes_cased_num                       // Pass count reference
);

    integer status;                                    // Status variable for file reading
    string line;                                       // Store each line as a string
    logic [in_len-1:0] in;                             // Input from the file
    logic [out_len-1:0] out;                           // Expected output from the file
    integer line_num = 0;                              // Line number counter

    // Read data from file until EOF or specified limit
    while (!$feof(file)) begin
        line = "";                                     // Clear line string
        status = $fgets(line, file);                   // Read a line from the file
        if (status != 0) begin                         // Check if fgets was successful
            line_num++;                                // Increment line number
            status = $sscanf(line, "%b %b", in, out);  // Parse input and output from the line
            
            if (status == 2) begin                     // Ensure both in and out are read
                // Proceed with the simulation for the current line
                $display("##########################################");
                $display("Line %0d: in=%b, out=%b", line_num, in, out);  // Display parsed values
                run_sim(in, out, line_num, x_n, y_n, errors_num, passes_cased_num);
                $display("##########################################");

            end else begin
                $display("##########################################");
                $display("Error parsing line %0d: %s", line_num, line);  // Error in parsing
            end
        end else begin
            $display("Error reading data from line %0d", line_num);      // Reading error
            $finish;                                                     // Exit if error occurs
        end
    end
    $fclose(file);  // Close the file

endtask: read_from_file_run


task automatic run_sim(
    input logic [in_len-1:0] in,               // Input data
    input logic [out_len-1:0] out,             // Expected output data
    input integer line_num,                    // Line number (for error reporting)
    ref logic [in_len-1:0] x_n,                // Input signal (reference)
    ref logic [out_len-1:0] y_n,               // Output signal (constant reference)
    ref integer errors_num,                    // Error counter (reference)
    ref integer passes_cased_num               // Passed cases counter (reference)
);



    // Step 1: Apply input to the DUT at the falling edge of the clock
    @(negedge clk) 
       x_n = in;

    // Step 2: Check output at the next falling edge of the clock
    #6

    if (line_num <= 3) begin
        $display("%0t: We are still in initialization at line %0d", $time, line_num);
    end
    // Step 3: Compare the output wither difference  very low   15 mean very low int(00000)_frac(0_000_0000_0011_11)
    else if ((out-y_n)<=15 || (y_n-out)<=15) begin
        // Output is within the margin, increment the pass counter
        passes_cased_num++;
        $display("%0t: Assertion passed at line %0d: y_n = %0d, expected = %0d", 
                 $time, line_num, y_n, out);
    end else begin
        // Output is outside the margin, report an error and increment the error counter
        $display("%0t: Assertion failed at line %0d: y_n = %0d, expected = %0d", 
                 $time, line_num,y_n, out);
        errors_num++;
    end

endtask: run_sim

endmodule