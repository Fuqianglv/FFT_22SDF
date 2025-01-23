//********************************************************
//this module is used to multiply two complex numbers
//The input is in_a, in_b
//The output is out
//The multiplication operation is as follows:
//out = in_a * in_b
//********************************************************

module MulComplex#(parameter WIDTH = 8)
                  (input clk,
                   input signed [WIDTH-1:0] in_a_re,
                   input signed [WIDTH-1:0] in_a_im,
                   input signed [WIDTH-1:0] in_b_re,
                   input signed [WIDTH-1:0] in_b_im,
                   output reg signed [WIDTH-1:0] out_re,
                   output reg signed [WIDTH-1:0] out_im);
    
    reg signed [2 * WIDTH-1:0] out_re1;
    reg signed [2 * WIDTH-1:0] out_im1;
    reg signed [2 * WIDTH-1:0] out_re2;
    reg signed [2 * WIDTH-1:0] out_im2;
    
    always @(posedge clk) begin
        //calculate the multiplication operation
        out_re1 <= (in_a_re * in_b_re)>>>(WIDTH-1);
        out_re2 <= (in_a_im * in_b_im)>>>(WIDTH-1);
        out_im1 <= (in_a_re * in_b_im)>>>(WIDTH-1);
        out_im2 <= (in_a_im * in_b_re)>>>(WIDTH-1);
    end
    
    always @(posedge clk) begin
        //calculate the multiplication operation
        out_re <= out_re1 - out_re2;
        out_im <= out_im1 + out_im2;
    end
    
endmodule
