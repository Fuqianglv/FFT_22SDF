
module sdf2 #(parameter WIDTH = 8)
             (input clk,
              input enable_in,
              input signed [WIDTH-1:0] in_re,
              input signed [WIDTH-1:0] in_im,
              output reg enable_out,
              output reg signed [WIDTH-1:0] out_re,
              output reg signed [WIDTH-1:0] out_im);
    
    
    reg [WIDTH-1:0] delay_in_re;
    reg [WIDTH-1:0] delay_in_im;
    
    wire [WIDTH-1:0] butterfly_out_a_re;
    wire [WIDTH-1:0] butterfly_out_a_im;
    wire [WIDTH-1:0] butterfly_out_b_re;
    wire [WIDTH-1:0] butterfly_out_b_im;
    
    reg [WIDTH-1:0] delay_butterfly_out_b_re;
    reg [WIDTH-1:0] delay_butterfly_out_b_im;
    
    reg S_half = 0;
    
    reg enable_in_d1 = 0;
    reg enable_in_d2 = 0;
    reg enable_in_d3 = 0;
    
    always @(posedge clk) begin
        if (enable_in||enable_out) begin
            S_half <= ~S_half;
        end
    end
    
    always @(posedge clk) begin
        delay_in_re <= in_re;
        delay_in_im <= in_im;
    end
    
    
    butterfly u_butterfly(
    .clk      (clk),
    .in_a_re  (delay_in_re),
    .in_a_im  (delay_in_re),
    .in_b_re  (in_re),
    .in_b_im  (in_im),
    .out_a_re (butterfly_out_a_re),
    .out_a_im (butterfly_out_a_im),
    .out_b_re (butterfly_out_b_re),
    .out_b_im (butterfly_out_b_im)
    );
    
    always @(posedge clk) begin
        delay_butterfly_out_b_re <= butterfly_out_b_re;
        delay_butterfly_out_b_im <= butterfly_out_b_im;
    end
    
    always@(posedge clk) begin
        if (S_half) begin
            out_re <= delay_butterfly_out_b_re;
        end
        else begin
            out_re <= butterfly_out_a_re;
        end
    end

    always @(posedge clk) begin
        enable_in_d1 <= enable_in;
        enable_in_d2 <= enable_in_d1;
        enable_out <= enable_in_d2;
    end
    
endmodule
