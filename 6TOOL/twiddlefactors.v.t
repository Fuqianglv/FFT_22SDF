// This file is the output of the twiddlefactors
// generator. It contains the twiddle factors for
// the FFT module.


module twiddlefactors#(parameter N = 64,
                       parameter ADDR_WIDTH =  ( $clog2(N) < 4 ) ? 4 : $clog2(N))
                      (input clk,
                       input [ADDR_WIDTH-1:0] addr,
                       output reg signed [{{tf_width-1}}:0] twiddle_re,
                       output reg signed [{{tf_width-1}}:0] twiddle_im);

    localparam WIDTH = {{tf_width}};

    localparam signed [WIDTH-1:0] COS_SIN_PI_4 = (((32'h5A82799A<<1) >> (32-WIDTH)) + 1)>>>1; // cos(pi/4) / sin(pi/4)
    localparam signed [WIDTH-1:0] SIN_PI_2 = (32'h80000000-1) >>> (32-WIDTH); // sin(pi/2)

    wire signed [WIDTH-1:0]  wn_re[0:(N>>3)-1]; 
    wire signed [WIDTH-1:0]  wn_im[0:(N>>3)-1]; 

    reg [ADDR_WIDTH-4:0]  select_addr = 0;
    reg [2:0]  select_addr_m = 0;

    generate if (N > 8) begin
    always @(posedge clk) begin
        select_addr_m <= addr[ADDR_WIDTH-1:ADDR_WIDTH-3];
        if(addr[ADDR_WIDTH-3]) begin
            select_addr <= -addr[ADDR_WIDTH-4:0];
        end
        else begin
            select_addr <= addr[ADDR_WIDTH-4:0];
        end
    end
    end
    else if (N == 8) begin
    always @(posedge clk) begin
        select_addr_m <= addr[2:0];
        select_addr <= 0;
    end
    end
    else begin

    end
    endgenerate

    always @(posedge clk) begin
        if(select_addr == 0) begin
            case(select_addr_m)
                3'b000: {twiddle_re, twiddle_im} <= { SIN_PI_2, {WIDTH{1'b0}} };
                3'b001: {twiddle_re, twiddle_im} <= { COS_SIN_PI_4, -COS_SIN_PI_4 };
                3'b010: {twiddle_re, twiddle_im} <= { {WIDTH{1'b0}}, -SIN_PI_2 };
                3'b011: {twiddle_re, twiddle_im} <= { -COS_SIN_PI_4, -COS_SIN_PI_4} ;
                default: {twiddle_re, twiddle_im} <= { {WIDTH{1'b0}}, {WIDTH{1'b0}} };
            endcase
        end
        else begin
            case(select_addr_m)
                3'b000: {twiddle_re, twiddle_im} <= { wn_re[select_addr], wn_im[select_addr] };
                3'b001: {twiddle_re, twiddle_im} <= { -wn_im[select_addr], -wn_re[select_addr] };
                3'b010: {twiddle_re, twiddle_im} <= { wn_im[select_addr], -wn_re[select_addr] };
                3'b011: {twiddle_re, twiddle_im} <= { -wn_re[select_addr], wn_im[select_addr] };
                3'b100: {twiddle_re, twiddle_im} <= { -wn_re[select_addr], -wn_im[select_addr] };
                3'b101: {twiddle_re, twiddle_im} <= { wn_im[select_addr], wn_re[select_addr] };
                default: {twiddle_re, twiddle_im} <= { {WIDTH{1'b0}}, {WIDTH{1'b0}} };
            endcase
        end
    end

    generate if (N == 8) begin
    {% for tf in tfs[8] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else if (N == 16) begin
    {% for tf in tfs[16] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else if (N == 32) begin
    {% for tf in tfs[32] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else if (N == 64) begin
    {% for tf in tfs[64] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else if (N == 128) begin
    {% for tf in tfs[128] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else if (N == 256) begin
    {% for tf in tfs[256] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else if (N == 512) begin
    {% for tf in tfs[512] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else if (N == 1024) begin
    {% for tf in tfs[1024] %}assign wn_re[{{tf.k}}] = {{tf.re_sign}}{{tf_width}}'sd{{tf.re}};assign wn_im[{{tf.k}}] = {{tf.im_sign}}{{tf_width}}'sd{{tf.im}};
    {% endfor %}end
    else begin
        //default case
    end
    endgenerate

endmodule