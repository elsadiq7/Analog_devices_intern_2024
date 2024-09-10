module fsm (clk, reset_n,load, shifter_out, counter, count_N, in_byte, state);

    // Inputs
    input clk, reset_n,load;                         // Clock and active-low reset and load signal to load new seq
    input [4*8-1:0] in_byte;                    // Input byte, 4 bytes wide
    input [8-1:0] shifter_out;                  // Shifter output, 1 byte wide
    input [3:0] counter, count_N;               // 'counter' tracks count, 'count_N' is the max value

    // Outputs
    output reg [2:0] state;                     // FSM state output

    // State definitions
    parameter [2:0] start = 3'd0,               // FSM start state
                    s0    = 3'd1,               // State 0
                    s1    = 3'd2,               // State 1
                    s2    = 3'd3,               // State 2
                    s3    = 3'd4,               // State 3
                    random = 3'd5;              // Random state
        // Internal register
    reg [2:0]next_state;
    reg [4*8-1:0]saved_inbytes;
    // Byte extraction from 'shifter_out'
    // reg [8-1:0] by0 = saved_inbytes[1*8-1:0*8],  // Byte 0
    //                   by1 = saved_inbytes[2*8-1:1*8],  // Byte 1
    //                   by2 = saved_inbytes[3*8-1:2*8],  // Byte 2
    //                   by3 = saved_inbytes[4*8-1:3*8];  // Byte 3


    // Combinational logic for FSM transitions
    always @(*) begin
        case (state)
            start: begin
                if ((shifter_out == saved_inbytes[7:0]) & (!load)) begin
                    next_state = s0;           // Move to state s0 if condition met
                end else begin
                    next_state = start;        // Remain in start state if error
                end
            end

            s0: begin
                if ((shifter_out == saved_inbytes[15:8]) & (!load)) begin
                    next_state = s1;           // Move to state s1
                end else begin
                    next_state = start;        // Go back to start if error
                end
            end

            s1: begin
                if ((shifter_out == saved_inbytes[23:16]) & (!load)) begin
                    next_state = s2;           // Move to state s2
                end else begin
                    next_state = start;        // Go back to start if error
                end
            end

            s2: begin
                if ((shifter_out == saved_inbytes[31:24]) & (!load)) begin
                    next_state = s3;           // Move to state s3
                end else begin
                    next_state = start;        // Go back to start if error
                end
            end

            s3: begin
                if ((counter == count_N - 1) &( !load)) begin
                    next_state = random;       // Move to random state when max counter is reached
                end else begin
                    next_state = start;        // Go back to start if error
                end
            end

            random: begin
                if (load) begin
                    next_state = start;        // Reset FSM to start if 'load' is asserted
                end else begin
                    next_state = random;       // Remain in random state if no load
                end
            end

            default: begin
                next_state = start;            // Default case, return to start
            end
        endcase
    end

    // Sequential logic to update state
    always @(posedge clk or negedge reset_n) begin : seq
        if (~reset_n) begin
            state <= 3'b0;                     // Reset state on negative edge of reset
            saved_inbytes<=32'd0;
        end 

        else if (load) begin
            state<=start;
            saved_inbytes<=in_byte;
        end else begin
            state <= next_state;               // Update state on clock edge
            saved_inbytes<=saved_inbytes;
        end
    end

endmodule : fsm
