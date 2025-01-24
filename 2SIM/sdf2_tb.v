//testbench for sdf module
`timescale 1ns / 1ps
module sdf2_tb();
    
    // Inputs
    reg clk;
    reg enable_in;
    reg [7:0] in_re = 0;
    reg [7:0] in_im = 0;
    
    // Outputs
    wire enable_out;
    wire [7:0] out_re;
    wire [7:0] out_im;
    
    
    integer i;
    initial begin
        // Initialize Inputs
        clk       = 0;
        enable_in = 0;
        in_re     = 0;
        in_im     = 0;
        
        // Wait 100 ns for global reset to finish
        #106;
        enable_in = 1;
        for(i = 0; i < 8; i = i + 1) begin
            in_re = i*2;
            in_im = -i;
            #10;
        end
        for(i = 8; i < 16; i = i + 1) begin
            in_re = -i;
            in_im = i;
            #10;
        end
        enable_in = 0;
    end
    
    // Instantiate the Unit Under Test (UUT)
    sdf2
    #(.WIDTH(8)) uut(
    .clk(clk),
    .enable_in(enable_in),
    .in_re(in_re),
    .in_im(in_im),
    .enable_out(enable_out),
    .out_re(out_re),
    .out_im(out_im)
    );
    
    always begin
        #5 clk = ~clk;
    end
    
    
endmodule
