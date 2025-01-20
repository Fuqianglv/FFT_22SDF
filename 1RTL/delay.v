//this moudle is used to generate the delay signal

module delay#(parameter DEPTH = 32,
              parameter WIDTH = 8)
             (input clk,
              input signed [WIDTH-1:0] in_re,
              input signed [WIDTH-1:0] in_im,
              output reg signed [WIDTH-1:0] out_re,
              output reg signed [WIDTH-1:0] out_im);
    
    reg signed [WIDTH-1:0] buffer_re[0:DEPTH-1];
    reg signed [WIDTH-1:0] buffer_im[0:DEPTH-1];

    integer i;
    always @(posedge clk) begin
        buffer_re[0] <= in_re;
        buffer_im[0] <= in_im;
        for(i = 1; i < DEPTH; i = i + 1) begin
            buffer_re[i] <= buffer_re[i-1];
            buffer_im[i] <= buffer_im[i-1];
        end
        out_re <= buffer_re[DEPTH-1];
        out_im <= buffer_im[DEPTH-1];
    end


endmodule