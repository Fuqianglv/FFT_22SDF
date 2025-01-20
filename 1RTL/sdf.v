//this module is sdf4
module sdf4 #(parameter N = 64,
              parameter S = 64,
              parameter WIDTH = 8)
             (input wire clk,
              input wire enable_in,
              input wire [WIDTH-1:0] in_re,
              input wire [WIDTH-1:0] in_im,
              output wire enable_out,
              output wire [WIDTH-1:0] out_re,
              output wire [WIDTH-1:0] out_im);
    
    localparam LOGN = $clog2(N);
    localparam LOGS = $clog2(S);

    // define the variables
    




endmodule
