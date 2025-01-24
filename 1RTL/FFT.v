//this module is the Fast Fourier Transform module

module FFT#(parameter N = 128,
            parameter WIDTH = 8)
           (input clk,
            input enable_in,
            input signed [WIDTH-1:0] in_re,
            input signed [WIDTH-1:0] in_im,
            output reg enable_out,
            output reg signed [WIDTH-1:0] out_re,
            output reg signed [WIDTH-1:0] out_im);
    
    generate
    localparam DEPTH_DATA = ($clog2(N)+1)>>1;
    localparam STAGE_NUM  = $clog2(N)>>1;
    reg [DEPTH_DATA-1:0] buffer_enable_in;
    reg [WIDTH-1:0] buffer_in_re[0:DEPTH_DATA-1];
    reg [WIDTH-1:0] buffer_in_im[0:DEPTH_DATA-1];
    wire [DEPTH_DATA-1:0] buffer_enable_out;
    wire [WIDTH-1:0] buffer_out_re[0:DEPTH_DATA-1];
    wire [WIDTH-1:0] buffer_out_im[0:DEPTH_DATA-1];
    always @(posedge clk) begin
        buffer_enable_in[0] <= enable_in;
        buffer_in_re[0]     <= in_re;
        buffer_in_im[0]     <= in_im;
        enable_out          <= buffer_enable_out[DEPTH_DATA-1];
        out_re              <= buffer_out_re[DEPTH_DATA-1];
        out_im              <= buffer_out_im[DEPTH_DATA-1];
    end
    
    genvar i;
    for(i = 0; i < DEPTH_DATA-1; i = i + 1) begin
        always @(posedge clk) begin
            buffer_in_re[i+1]     <= buffer_out_re[i];
            buffer_in_im[i+1]     <= buffer_out_im[i];
            buffer_enable_in[i+1] <= buffer_enable_out[i];
        end
    end
    for(i = 0; i < STAGE_NUM; i = i + 1) begin : sdf4_gen
    sdf4 #(.N(N), .S(N>>(2*i)), .WIDTH(WIDTH)) u_sdf4(
    .clk        (clk),
    .enable_in  (buffer_enable_in[i]),
    .in_re      (buffer_in_re[i]),
    .in_im      (buffer_in_im[i]),
    .enable_out (buffer_enable_out[i]),
    .out_re     (buffer_out_re[i]),
    .out_im     (buffer_out_im[i])
    );
    end
    if (DEPTH_DATA!= STAGE_NUM) begin : sdf2_gen
    sdf2 #(.WIDTH(WIDTH)) u_sdf2(
    .clk        (clk),
    .enable_in  (buffer_enable_in[STAGE_NUM-1]),
    .in_re      (buffer_in_re[STAGE_NUM-1]),
    .in_im      (buffer_in_im[STAGE_NUM-1]),
    .enable_out (buffer_enable_out[STAGE_NUM]),
    .out_re     (buffer_out_re[STAGE_NUM]),
    .out_im     (buffer_out_im[STAGE_NUM])
    );
    end
    endgenerate
    
    
endmodule
