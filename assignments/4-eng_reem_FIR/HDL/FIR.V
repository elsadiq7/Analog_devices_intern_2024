module fir#(   // Parameters
    parameter in_len = 16,  
    parameter out_len = 16 )(
    input wire clk,          // Clock signal
    input wire rst_n,        // Active-low reset signal
    input  wire signed [in_len-1:0] x_n, // Input signal
    output  reg  signed[out_len-1:0] y_n // Output signal

);

    // Internal registers for storing intermediate values
     reg signed [out_len-1:0] ff1, ff2, ff3;

    // Parameters for multipliers, representing shifts
    parameter [1:0] mult_3 = 2'd0, // Shift right by 0 (no shift)
                    mult_2 = 2'd1, // Shift right by 1
                    mult_1 = 2'd2, // Shift right by 2
                    mult_0 = 2'd3; // Shift right by 3




    // Always block for sequential logic, triggered on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset all intermediate registers to zero
            ff3 <= {out_len{1'b0}};
            ff2 <= {out_len{1'b0}};
            ff1 <={out_len{1'b0}};
            y_n<={out_len{1'b0}};



        end else begin
            // Shift and accumulate operations
            ff3 <= x_n;          // Shift x_n by mult_3 and store in ff3
            ff2 <= ff3;    // Shift x_n by mult_2, add ff3, and store in ff2
            ff1 <= ff2;    // Shift x_n by mult_1, add ff2, and store in ff1
            y_n <= x_n+(ff3>>>mult_2)+(ff2>>>mult_1)+(ff1>>>mult_0);
           
        end
    end






 
endmodule







 
