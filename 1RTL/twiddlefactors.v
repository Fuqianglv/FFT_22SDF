// This file is the output of the twiddlefactors
// generator. It contains the twiddle factors for
// the FFT module.


module twiddlefactors#(parameter WIDTH = 8,
                       parameter N = 64,
                       parameter ADDR_WIDTH = $clog2(N))
                      (input clk,
                       input [ADDR_WIDTH-1:0] addr,
                       output reg signed [WIDTH-1:0] twiddle_re,
                       output reg signed [WIDTH-1:0] twiddle_im);


                       always @(posedge clk) begin
                        
                       end

    generate if (N ==4 ) begin
    always @(posedge clk) begin

    end
    end
    else if (N == 8) begin
    always @(posedge clk) begin

    end
    end
    else if (N == 16) begin
    always @(posedge clk) begin

    end 
    end
    else if (N == 32) begin
    always @(posedge clk) begin

    end
    end
    else if (N == 64) begin
    always @(posedge clk) begin

    end
    end
    else if (N == 128) begin
    always @(posedge clk) begin

    end
    end
    else if (N == 256) begin
    always @(posedge clk) begin

    end
    end
    else if (N == 512) begin
    always @(posedge clk) begin

    end
    end
    else if (N == 1024) begin
    always @(posedge clk) begin

    end
    end
    else begin
        //default case
    end

    endgenerate


endmodule