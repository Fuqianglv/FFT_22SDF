//this module is the Fast Fourier Transform module

module FFT#(parameter N = 32,
            parameter WIDTH = 8)
           (input clk,
            input enable_in,
            input signed [WIDTH-1:0] in_re,
            input signed [WIDTH-1:0] in_im,
            output reg enable_out,
            output reg signed [WIDTH-1:0] out_re,
            output reg signed [WIDTH-1:0] out_im);
    
    reg enable_in0;
    reg [WIDTH-1:0] in_re0;
    reg [WIDTH-1:0] in_im0;
    
    
    always @(posedge clk) begin
        enable_in0 <= enable_in;
        in_re0     <= in_re;
        in_im0     <= in_im;
    end
    
    //parameter
    sdf4 #(.N(N),.S(N/4),.WIDTH(WIDTH))u_sdf4(
    .clk        (clk),
    .enable_in  (enable_in0),
    .in_re      (in_re0),
    .in_im      (in_im0),
    .enable_out (enable_out0),
    .out_re     (out_re0),
    .out_im     (out_im0)
    );
    
endmodule
