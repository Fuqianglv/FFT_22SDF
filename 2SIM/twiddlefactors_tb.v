//testbench for twiddlefactors.v
`timescale 1ns / 1ps

module twiddlefactors_tb;

    // Inputs
    reg clk;
    reg [5:0] addr;

    // Outputs
    wire signed [7:0] twiddle_re;
    wire signed [7:0] twiddle_im;

    // Instantiate the Unit Under Test (UUT)
    twiddlefactors 
    #(.N(8)) uut(
        .clk(clk), 
        .addr(addr), 
        .twiddle_re(twiddle_re), 
        .twiddle_im(twiddle_im)
    );

    integer i;
    initial begin
        // Initialize Inputs
        clk = 0;
        addr = 0;

        // Wait 100 ns for global reset to finish
        #105;

        for(i = 0; i < 64; i = i + 1) begin
            addr = i;
            #10;
        end
        // Add stimulus here
    end

    always begin
        #5 clk = ~clk;
    end

endmodule
