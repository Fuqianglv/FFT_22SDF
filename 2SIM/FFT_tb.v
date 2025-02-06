//testbench for FFT_base2 module
`timescale 1ns / 1ps

module FFT_tb();
    
    parameter DATA_WIDTH = 8;
    // Inputs
    reg clk                   = 0;
    reg enable_in             = 0;
    reg [DATA_WIDTH-1:0] i_in = 0;
    reg [DATA_WIDTH-1:0] q_in = 0;
    reg [2*DATA_WIDTH:0] temp_array [0:8192-1];
    
    // Outputs
    wire out_fft_data_flag;
    wire [2*DATA_WIDTH-1:0] out_fft_data;
    
    integer i;
    initial begin
        $readmemb("E:/LFQ/FFT_22SDF/6TOOL/data_before_fft.txt", temp_array);
        #100 enable_in = 1;
        for(i = 0; i < 64; i = i + 1) begin
            i_in = temp_array[i][2*DATA_WIDTH-1:DATA_WIDTH];
            q_in = temp_array[i][DATA_WIDTH-1:0];
            #10;
        end
        enable_in = 0;
    end
    // ...existing code...
    
    always #5 clk = ~clk;
    
    reg [31:0] counter = 0;
    
    always @(posedge clk) begin
        if (enable_out)
            counter <= counter + 1;
        
        else
        counter <= 0;
    end
    
    wire [DATA_WIDTH-1:0] out_re;
    wire [DATA_WIDTH-1:0] out_im;
    
    
    FFT#(.N(1024),
    .WIDTH(DATA_WIDTH)) u_FFT(
    .clk        (clk),
    .enable_in  (enable_in),
    .in_re      (i_in),
    .in_im      (q_in),
    .enable_out (enable_out),
    .out_re     (out_re),
    .out_im     (out_im)
    );
    
    
endmodule
