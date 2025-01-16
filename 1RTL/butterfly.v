//********************************************************************************
//This module is used to calculate the butterfly operation in FFT
//The input is in_a, in_b
//The output is out_a, out_b
//The butterfly operation is as follows:
//out_a = in_a + in_b
//out_b = in_a - in_b
//********************************************************************************

module butterfly#(parameter WIDTH = 8,
                  parameter ROUND = 0)
                 (input clk,
                  input signed [WIDTH-1:0] in_a_re,
                  input signed [WIDTH-1:0] in_a_im,
                  input signed [WIDTH-1:0] in_b_re,
                  input signed [WIDTH-1:0] in_b_im,
                  output reg signed [WIDTH-1:0] out_a_re,
                  output reg signed [WIDTH-1:0] out_a_im,
                  output reg signed [WIDTH-1:0] out_b_re,
                  output reg signed [WIDTH-1:0] out_b_im);
    
    generate if (ROUND == 1) begin
    always @(posedge clk) begin
        //calculate the butterfly operation
        out_a_re <= (in_a_re + in_b_re+ROUND) >>> 1;
        out_a_im <= (in_a_im + in_b_im+ROUND) >>> 1;
        out_b_re <= (in_a_re - in_b_re+ROUND) >>> 1;
        out_b_im <= (in_a_im - in_b_im+ROUND) >>> 1;
    end
    end else begin
    always @(posedge clk) begin
        //calculate the butterfly operation
        out_a_re <= (in_a_re + in_b_re) >>> 1;
        out_a_im <= (in_a_im + in_b_im) >>> 1;
        out_b_re <= (in_a_re - in_b_re) >>> 1;
        out_b_im <= (in_a_im - in_b_im) >>> 1;
    end
    end
    endgenerate
    
endmodule
