module tb_top;

// Clock and reset
logic clk;
logic rst_n;
logic enable;

// Inputs to the top module
logic signed [31:0] a, b, c;
logic signed [31:0] d, e, f;
logic signed [31:0] g, h, i;

logic signed [31:0] A_inv [2:0][2:0];
logic signed [31:0] A_inv_expected [2:0][2:0];
// Outputs from the top module
logic signed [31:0] a_out_q, b_out_q, c_out_q;
logic signed [31:0] d_out_q, e_out_q, f_out_q;
logic signed [31:0] g_out_q, h_out_q, i_out_q;

logic signed [31:0] a_out_q_expected, b_out_q_expected, c_out_q_expected;
logic signed [31:0] d_out_q_expected, e_out_q_expected, f_out_q_expected;
logic signed [31:0] g_out_q_expected, h_out_q_expected, i_out_q_expected;


logic signed [31:0] a_out_r, b_out_r, c_out_r;
logic signed [31:0] d_out_r, e_out_r, f_out_r;
logic signed [31:0] g_out_r, h_out_r, i_out_r;

logic signed [31:0] a_out_r_expected, b_out_r_expected, c_out_r_expected;
logic signed [31:0] d_out_r_expected, e_out_r_expected, f_out_r_expected;
logic signed [31:0] g_out_r_expected, h_out_r_expected, i_out_r_expected;
int passed_cases,failed_cases;



logic data_valid;
logic data_valid_qr;

// Function to convert fixed-point values to float
function real fixed_to_float(input logic signed [31:0] fixed_val);
    real result;
    result = fixed_val / (2.0 ** 24); // Assume fixed-point with 24 fractional bits
    return result;
endfunction
// Function to sum the elements of the array
function logic signed [31:0] sum_array(logic signed [31:0] arr [2:0][2:0]);
        logic signed [31:0] total;
        total = 0; // Initialize total to zero
        
        // Loop through the array and sum the elements
        for (int i = 0; i < 3; i++) begin
            for (int j = 0; j < 3; j++) begin
                total += arr[i][j];
            end
        end
        return total; // Return the sum
    endfunction


function logic signed [31:0] abs(logic signed [31:0] value);
        if (value < 0) begin
            return -value; // Return the negation if the value is negative
        end else begin
            return value; // Return the value as is if it's non-negative
        end
    endfunction
// Instantiate the top module
top uut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .a(a), .b(b), .c(c),
    .d(d), .e(e), .f(f),
    .g(g), .h(h), .i(i),
    .A_inv(A_inv),
    .data_valid(data_valid)
  );

assign data_valid_qr=uut.valid_top;

assign a_out_r=uut.a_out;
assign b_out_r=uut.b_out;
assign c_out_r=uut.c_out;
assign d_out_r=uut.d_out;
assign e_out_r=uut.e_out;
assign f_out_r=uut.f_out;
assign g_out_r=uut.g_out;
assign h_out_r=uut.h_out;
assign i_out_r=uut.i_out;

assign a_out_q=uut.Q_top[0][0];
assign b_out_q=uut.Q_top[0][1];
assign c_out_q=uut.Q_top[0][2];
assign d_out_q=uut.Q_top[1][0];
assign e_out_q=uut.Q_top[1][1];
assign f_out_q=uut.Q_top[1][2];
assign g_out_q=uut.Q_top[2][0];
assign h_out_q=uut.Q_top[2][1];
assign i_out_q=uut.Q_top[2][2];






// Clock generation
always #5 clk = ~clk;

// Test procedure
initial begin
    #5
    passed_cases=0;
    failed_cases=0;
    // Initialize signals
    clk = 0;
    rst_n = 0;
    enable = 0;
    a = 32'd0; b = 32'd0; c = 32'd0;
    d = 32'd0; e = 32'd0; f = 32'd0;
    g = 32'd0; h = 32'd0; i = 32'd0;

    // Reset pulse
    //////////////////reset ////////////////////////////
    ////////////////////////////////////////////////////
        #4
        @(negedge clk) rst_n <= 0;
        @(posedge clk)
       //  passed_cases++;
       // assert (sum_array(A_inv)==0)
       //  else begin
       //      failed_cases++;
       //      passed_cases--;
       //      $error("\nrest @%0t: reset failed",$time);
       //  end 
        rst_n = 1; 


    ///////////////////////////////////////////////////////////////////////////////////////
    // Test case 1: Identity matrix
    @(negedge  clk);
    enable = 1;
    a = 32'h01_00_0000; // 1.0 in fixed-point format (assuming 24 fractional bits)
    b = 32'h00_00_0000;
    c = 32'h00_00_0000;
    d = 32'h00_00_0000;
    e = 32'h01_00_0000; // 1.0 in fixed-point format
    f = 32'h00_00_0000;
    g = 32'h00_00_0000;
    h = 32'h00_00_0000;
    i = 32'h01_00_0000; // 1.0 in fixed-point format
    a_out_q_expected=a; b_out_q_expected=b; c_out_q_expected=c;
    d_out_q_expected=d; e_out_q_expected=e; f_out_q_expected=f;
    g_out_q_expected=g; h_out_q_expected=h; i_out_q_expected=i;
    a_out_r_expected=a; b_out_r_expected=b; c_out_r_expected=c;
    d_out_r_expected=d; e_out_r_expected=e; f_out_r_expected=f;
    g_out_r_expected=g; h_out_r_expected=h; i_out_r_expected=i;
  A_inv_expected[0][0] = 32'b00000001000000000000000000000000;
  A_inv_expected[0][1] = 32'b00000000000000000000000000000000;
  A_inv_expected[0][2] = 32'b00000000000000000000000000000000;
  A_inv_expected[1][0] = 32'b00000000000000000000000000000000;
  A_inv_expected[1][1] = 32'b00000001000000000000000000000000;
  A_inv_expected[1][2] = 32'b00000000000000000000000000000000;
  A_inv_expected[2][0] = 32'b00000000000000000000000000000000;
  A_inv_expected[2][1] = 32'b00000000000000000000000000000000;
  A_inv_expected[2][2] = 32'b00000001000000000000000000000000;


    // Wait for data_valid signal
    ///////////////////////////////////////////////////////////////////////////////////////
    wait(data_valid_qr);
    @(negedge clk)
    $display("\nTest Case 1: Identity matrix");
    $display("\ninput Matrix");
    $display("\na=%0f, b=%0f, c=%0f", fixed_to_float(a), fixed_to_float(b), fixed_to_float(c));
    $display("\nd=%0f, e_=%0f, f=%0f", fixed_to_float(d), fixed_to_float(e), fixed_to_float(f));
    $display("\ng=%0f, h=%0f, i=%0f", fixed_to_float(g), fixed_to_float(h), fixed_to_float(i));
    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (Q ):");
    $display("\na_out_q=%0f, b_out_q=%0f, c_out_q=%0f", fixed_to_float(a_out_q), fixed_to_float(b_out_q), fixed_to_float(c_out_q));
    $display("\nd_out_q=%0f, e_out_q=%0f, f_out_q=%0f", fixed_to_float(d_out_q), fixed_to_float(e_out_q), fixed_to_float(f_out_q));
    $display("\ng_out_q=%0f, h_out_q=%0f, i_out_q=%0f", fixed_to_float(g_out_q), fixed_to_float(h_out_q), fixed_to_float(i_out_q));

    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (Q expected):");
    $display("\na_out_q=%0f, b_out_q=%0f, c_out_q=%0f", fixed_to_float(a_out_q_expected), fixed_to_float(b_out_q_expected), fixed_to_float(c_out_q_expected));
    $display("\nd_out_q=%0f, e_out_q=%0f, f_out_q=%0f", fixed_to_float(d_out_q_expected), fixed_to_float(e_out_q_expected), fixed_to_float(f_out_q_expected));
    $display("\ng_out_q=%0f, h_out_q=%0f, i_out_q=%0f", fixed_to_float(g_out_q_expected), fixed_to_float(h_out_q_expected), fixed_to_float(i_out_q_expected));
    ///////////////////////////////////////////////////////////////////////////////////////
    passed_cases++;
    // Assertions for Q and R matrices
    assert ((abs(a_out_q - a_out_q_expected) <= 32'h0000_ffff) &&
        (abs(b_out_q - b_out_q_expected) <= 32'h0000_ffff) &&
        (abs(c_out_q - c_out_q_expected) <= 32'h0000_ffff) &&
        (abs(d_out_q - d_out_q_expected) <= 32'h0000_ffff) &&
        (abs(e_out_q - e_out_q_expected) <= 32'h0000_ffff) &&
        (abs(f_out_q - f_out_q_expected) <= 32'h0000_ffff) &&
        (abs(g_out_q - g_out_q_expected) <= 32'h0000_ffff) &&
        (abs(h_out_q - h_out_q_expected) <= 32'h0000_ffff) &&
        (abs(i_out_q - i_out_q_expected) <= 32'h0000_ffff))
    else begin
        failed_cases++;
        passed_cases--;
        $error("\nTest Case 1 @%0t: Identity Matrix failed for Q ", $time);
    end

    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (R):");
    $display("\na_out_r=%0f, b_out_r=%0f, c_out_r=%0f", fixed_to_float(a_out_r), fixed_to_float(b_out_r), fixed_to_float(c_out_r));
    $display("\nd_out_r=%0f, e_out_r=%0f, f_out_r=%0f", fixed_to_float(d_out_r), fixed_to_float(e_out_r), fixed_to_float(f_out_r));
    $display("\ng_out_r=%0f, h_out_r=%0f, i_out_r=%0f", fixed_to_float(g_out_r), fixed_to_float(h_out_r), fixed_to_float(i_out_r));
    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (R expected):");
    $display("\na_out_r=%0f, b_out_r=%0f, c_out_r=%0f", fixed_to_float(a_out_r_expected), fixed_to_float(b_out_r_expected), fixed_to_float(c_out_r_expected));
    $display("\nd_out_r=%0f, e_out_r=%0f, f_out_r=%0f", fixed_to_float(d_out_r_expected), fixed_to_float(e_out_r_expected), fixed_to_float(f_out_r_expected));
    $display("\ng_out_r=%0f, h_out_r=%0f, i_out_r=%0f", fixed_to_float(g_out_r_expected), fixed_to_float(h_out_r_expected), fixed_to_float(i_out_r_expected));
    ///////////////////////////////////////////////////////////////////////////////////////
    passed_cases++;
    // Assertions for Q and R matrices
       // Assertions for R matrices
   assert ((abs(a_out_r - a_out_r_expected) <= 32'h0000_ffff) &&
        (abs(b_out_r - b_out_r_expected) <= 32'h0000_ffff) &&
        (abs(c_out_r - c_out_r_expected) <= 32'h0000_ffff) &&
        (abs(d_out_r - d_out_r_expected) <= 32'h0000_ffff) &&
        (abs(e_out_r - e_out_r_expected) <= 32'h0000_ffff) &&
        (abs(f_out_r - f_out_r_expected) <= 32'h0000_ffff) &&
        (abs(g_out_r - g_out_r_expected) <= 32'h0000_ffff) &&
        (abs(h_out_r - h_out_r_expected) <= 32'h0000_ffff) &&
        (abs(i_out_r - i_out_r_expected) <= 32'h0000_ffff))
    else begin
        failed_cases++;
        passed_cases--;
        $error("\nTest Case 1 @%0t: Identity Matrix failed for R", $time);
    end

    ///////////////////////////////////////////////////////////////////////////////////////
    wait(data_valid);
    $display("\nResult (INV Matrix):");
    $display("\na=%0f, b=%0f, c=%0f", fixed_to_float(A_inv[0][0]), fixed_to_float(A_inv[0][1]), fixed_to_float(A_inv[0][2]));
    $display("\nd=%0f, e=%0f, f=%0f", fixed_to_float(A_inv[1][0]), fixed_to_float(A_inv[1][1]), fixed_to_float(A_inv[1][2]));
    $display("\ng=%0f, h=%0f, i=%0f", fixed_to_float(A_inv[2][0]), fixed_to_float(A_inv[2][1]), fixed_to_float(A_inv[2][2]));

    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (INV Matrix expected):");
    $display("\na=%0f, b=%0f, c=%0f", fixed_to_float(A_inv_expected[0][0]), fixed_to_float(A_inv_expected[0][1]), fixed_to_float(A_inv_expected[0][2]));
    $display("\nd=%0f, e=%0f, f=%0f", fixed_to_float(A_inv_expected[1][0]), fixed_to_float(A_inv_expected[1][1]), fixed_to_float(A_inv_expected[1][2]));
    $display("\ng=%0f, h=%0f, i=%0f", fixed_to_float(A_inv_expected[2][0]), fixed_to_float(A_inv_expected[2][1]), fixed_to_float(A_inv_expected[2][2]));

    

    ///////////////////////////////////////////////////////////////////////////////////////
    passed_cases++;
    // Assertions for Q and R matrices
    assert (sum_array(A_inv)-sum_array(A_inv_expected) <=32'h000f_ffff)
    else begin
        failed_cases++;
        passed_cases--;
        $error("\nTest Case 1 @%0t: Identity Matrix failed for inversion ", $time);
    end

    //////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
    // Test case 2: Arbitrary matrix
    @(negedge  clk);
    enable = 1;
    a = 32'h01_00_0000; // 1.0 in fixed-point format (assuming 24 fractional bits)
    b = 32'h02_00_0000;
    c = 32'h03_00_0000;
    d = 32'h02_00_0000;
    e = 32'h01_00_0000; // 1.0 in fixed-point format
    f = 32'h01_00_0000;
    g = 32'h06_00_0000;
    h = 32'h00_00_0000;
    i = 32'h01_00_0000; // 1.0 in fixed-point format
    ///////////////////////////////////////////////////////////////////////////////////////
    a_out_q_expected=32'sb11111111110110000000010100000000; b_out_q_expected=32'sb11111111000111010010101000000101; c_out_q_expected=32'sb11111111100100000100010110111111;
    d_out_q_expected=32'sb11111111101100000000100111111111; e_out_q_expected=32'sb11111111101000000000011111101111; f_out_q_expected=32'sb00000000110111110111010010000010;
    g_out_q_expected=32'sb11111111000100000001110111111011; h_out_q_expected=32'sb00000000010001011100101110101111; i_out_q_expected=32'sb11111111110010000010001011100000;

    ///////////////////////////////////////////////////////////////////////////////////////
    a_out_r_expected=32'sb11111001100110001100110011011010; b_out_r_expected=32'sb11111111011000000001001111111101; c_out_r_expected=32'sb11111110010010000011011011110110;
    d_out_r_expected=32'sb00000000000000000000000000000000; e_out_r_expected=32'sb11111101110110100101101111110111; f_out_r_expected=32'sb11111101001111010101000110101011;
    g_out_r_expected=32'sb00000000000000000000000000000000; h_out_r_expected=32'sb00000000000000000000000000000000; i_out_r_expected=32'sb11111111010110000110100010011110;
    ///////////////////////////////////////////////////////////////////////////////////////
      A_inv_expected[0][0] = 32'b11111111111000111000111000111001;
      A_inv_expected[0][1] = 32'b00000000001110001110001110001110;
      A_inv_expected[0][2] = 32'b00000000000111000111000111000111;
      A_inv_expected[1][0] = 32'b11111111100011100011100011100100;
      A_inv_expected[1][1] = 32'b00000001111000111000111000111000;
      A_inv_expected[1][2] = 32'b11111111011100011100011100011101;
      A_inv_expected[2][0] = 32'b00000000101010101010101010101010;
      A_inv_expected[2][1] = 32'b11111110101010101010101010101011;
      A_inv_expected[2][2] = 32'b00000000010101010101010101010101;

    ///////////////////////////////////////////////////////////////////////////////////////
    // Wait for data_valid signal
    wait(data_valid_qr);
    @(negedge clk)
    $display("\nTest Case 1: Identity matrix");
    $display("\ninput Matrix");
    $display("\na=%0f, b=%0f, c=%0f", fixed_to_float(a), fixed_to_float(b), fixed_to_float(c));
    $display("\nd=%0f, e_=%0f, f=%0f", fixed_to_float(d), fixed_to_float(e), fixed_to_float(f));
    $display("\ng=%0f, h=%0f, i=%0f", fixed_to_float(g), fixed_to_float(h), fixed_to_float(i));
    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (Q ):");
    $display("\na_out_q=%0f, b_out_q=%0f, c_out_q=%0f", fixed_to_float(a_out_q), fixed_to_float(b_out_q), fixed_to_float(c_out_q));
    $display("\nd_out_q=%0f, e_out_q=%0f, f_out_q=%0f", fixed_to_float(d_out_q), fixed_to_float(e_out_q), fixed_to_float(f_out_q));
    $display("\ng_out_q=%0f, h_out_q=%0f, i_out_q=%0f", fixed_to_float(g_out_q), fixed_to_float(h_out_q), fixed_to_float(i_out_q));

    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (Q expected):");
    $display("\na_out_q=%0f, b_out_q=%0f, c_out_q=%0f", fixed_to_float(a_out_q_expected), fixed_to_float(b_out_q_expected), fixed_to_float(c_out_q_expected));
    $display("\nd_out_q=%0f, e_out_q=%0f, f_out_q=%0f", fixed_to_float(d_out_q_expected), fixed_to_float(e_out_q_expected), fixed_to_float(f_out_q_expected));
    $display("\ng_out_q=%0f, h_out_q=%0f, i_out_q=%0f", fixed_to_float(g_out_q_expected), fixed_to_float(h_out_q_expected), fixed_to_float(i_out_q_expected));
    ///////////////////////////////////////////////////////////////////////////////////////
    passed_cases++;
    // Assertions for Q and R matrices
    assert ((abs(a_out_q - a_out_q_expected) <= 32'h0000_ffff) &&
        (abs(b_out_q - b_out_q_expected) <= 32'h0000_ffff) &&
        (abs(c_out_q - c_out_q_expected) <= 32'h0000_ffff) &&
        (abs(d_out_q - d_out_q_expected) <= 32'h0000_ffff) &&
        (abs(e_out_q - e_out_q_expected) <= 32'h0000_ffff) &&
        (abs(f_out_q - f_out_q_expected) <= 32'h0000_ffff) &&
        (abs(g_out_q - g_out_q_expected) <= 32'h0000_ffff) &&
        (abs(h_out_q - h_out_q_expected) <= 32'h0000_ffff) &&
        (abs(i_out_q - i_out_q_expected) <= 32'h0000_ffff))
    else begin
        failed_cases++;
        passed_cases--;
        $error("\nTest Case 2 @%0t: Arbitrary Matrix failed for Q ", $time);
    end

    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (R):");
    $display("\na_out_r=%0f, b_out_r=%0f, c_out_r=%0f", fixed_to_float(a_out_r), fixed_to_float(b_out_r), fixed_to_float(c_out_r));
    $display("\nd_out_r=%0f, e_out_r=%0f, f_out_r=%0f", fixed_to_float(d_out_r), fixed_to_float(e_out_r), fixed_to_float(f_out_r));
    $display("\ng_out_r=%0f, h_out_r=%0f, i_out_r=%0f", fixed_to_float(g_out_r), fixed_to_float(h_out_r), fixed_to_float(i_out_r));
 
    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (R expected):");
    $display("\na_out_r=%0f, b_out_r=%0f, c_out_r=%0f", fixed_to_float(a_out_r_expected), fixed_to_float(b_out_r_expected), fixed_to_float(c_out_r_expected));
    $display("\nd_out_r=%0f, e_out_r=%0f, f_out_r=%0f", fixed_to_float(d_out_r_expected), fixed_to_float(e_out_r_expected), fixed_to_float(f_out_r_expected));
    $display("\ng_out_r=%0f, h_out_r=%0f, i_out_r=%0f", fixed_to_float(g_out_r_expected), fixed_to_float(h_out_r_expected), fixed_to_float(i_out_r_expected));
    ///////////////////////////////////////////////////////////////////////////////////////
    passed_cases++;
    // Assertions for R matrices
   assert ((abs(a_out_r - a_out_r_expected) <= 32'h0000_ffff) &&
        (abs(b_out_r - b_out_r_expected) <= 32'h0000_ffff) &&
        (abs(c_out_r - c_out_r_expected) <= 32'h0000_ffff) &&
        (abs(d_out_r - d_out_r_expected) <= 32'h0000_ffff) &&
        (abs(e_out_r - e_out_r_expected) <= 32'h0000_ffff) &&
        (abs(f_out_r - f_out_r_expected) <= 32'h0000_ffff) &&
        (abs(g_out_r - g_out_r_expected) <= 32'h0000_ffff) &&
        (abs(h_out_r - h_out_r_expected) <= 32'h0000_ffff) &&
        (abs(i_out_r - i_out_r_expected) <= 32'h0000_ffff))
    else begin
        failed_cases++;
        passed_cases--;
        $error("\nTest Case 2 @%0t: Arbitrary Matrix failed for R", $time);
    end

     ///////////////////////////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////
    wait(data_valid);
    $display("\nResult (INV Matrix):");
    $display("\na=%0f, b=%0f, c=%0f", fixed_to_float(A_inv[0][0]), fixed_to_float(A_inv[0][1]), fixed_to_float(A_inv[0][2]));
    $display("\nd=%0f, e=%0f, f=%0f", fixed_to_float(A_inv[1][0]), fixed_to_float(A_inv[1][1]), fixed_to_float(A_inv[1][2]));
    $display("\ng=%0f, h=%0f, i=%0f", fixed_to_float(A_inv[2][0]), fixed_to_float(A_inv[2][1]), fixed_to_float(A_inv[2][2]));

    ///////////////////////////////////////////////////////////////////////////////////////
    $display("\nResult (INV Matrix expected):");
    $display("\na=%0f, b=%0f, c=%0f", fixed_to_float(A_inv_expected[0][0]), fixed_to_float(A_inv_expected[0][1]), fixed_to_float(A_inv_expected[0][2]));
    $display("\nd=%0f, e=%0f, f=%0f", fixed_to_float(A_inv_expected[1][0]), fixed_to_float(A_inv_expected[1][1]), fixed_to_float(A_inv_expected[1][2]));
    $display("\ng=%0f, h=%0f, i=%0f", fixed_to_float(A_inv_expected[2][0]), fixed_to_float(A_inv_expected[2][1]), fixed_to_float(A_inv_expected[2][2]));

    
    ///////////////////////////////////////////////////////////////////////////////////////
    passed_cases++;
    // Assertions for Q and R matrices
    assert (sum_array(A_inv)-sum_array(A_inv_expected) <=32'h000f_ffff)
    else begin
        failed_cases++;
        passed_cases--;
        $error("\nTest Case 1 @%0t: Identity Matrix failed for inversion ", $time);
    end

    ///////////////////////////////////////////////////////////////////////////////////////
// End simulation
        $display("Number of passed cases:%0d",passed_cases);
        $display("Number of failed cases:%0d",failed_cases);
    $stop;
end

endmodule








