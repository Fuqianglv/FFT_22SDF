//this moudle is used to generate the delay signal

module delay#(parameter DEPTH = 32,
              parameter WIDTH = 8)
             (input clk,
              input signed [WIDTH-1:0] in_re,
              input signed [WIDTH-1:0] in_im,
              output reg signed [WIDTH-1:0] out_re = 0,
              output reg signed [WIDTH-1:0] out_im = 0);
    
    
    generate if (DEPTH > 1) begin
    integer i;
    localparam DEPTH_ = DEPTH <= 1 ? 1 : DEPTH - 1;
    reg signed [WIDTH-1:0] buffer_re[0:DEPTH_-1];
    reg signed [WIDTH-1:0] buffer_im[0:DEPTH_-1];
    always @(posedge clk) begin
        buffer_re[0] <= in_re;
        buffer_im[0] <= in_im;
        for(i = 1; i < DEPTH_; i = i + 1) begin
            buffer_re[i] <= buffer_re[i-1];
            buffer_im[i] <= buffer_im[i-1];
        end
        out_re <= buffer_re[DEPTH_-1];
        out_im <= buffer_im[DEPTH_-1];
    end
    end
    else begin
    always @(posedge clk) begin
        out_re <= in_re;
        out_im <= in_im;
    end
    end
    endgenerate
    
    /*generate if (DEPTH ! = 0) begin
     genvar i;
     for(i = 0; i < WIDTH; i = i + 1) begin
     SRLC32E #(
     .INIT(32'h00000000) // Initial Value of Shift Register
     ) SRLC32E_inst (
     .Q(buffer_re[i]),     // SRL data output
     .Q31(), // SRL cascade output pin
     .A(DEPTH),     // 5-bit shift depth select input
     .CE(1),   // Clock enable input
     .CLK(clk), // Clock input
     .D(in_re[i])      // SRL data input
     );
     
     SRLC32E #(
     .INIT(32'h00000000) // Initial Value of Shift Register
     ) SRLC32E_inst1 (
     .Q(buffer_im[i]),     // SRL data output
     .Q31(), // SRL cascade output pin
     .A(DEPTH),     // 5-bit shift depth select input
     .CE(1),   // Clock enable input
     .CLK(clk), // Clock input
     .D(in_im[i])      // SRL data input
     );
     end
     end
     else begin
     always @(posedge clk) begin
     out_re <= in_re;
     out_im <= in_im;
     end
     end
     endgenerate*/
    
    
    
    
endmodule
