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
    
    //********************************************************
    //Stage 1
    //********************************************************
    // define the variables stage 1
    reg [LOGN-1:0] in_cnt = 0;
    wire S_half;
    reg S_half_d1                = 0;
    reg S_half_d2                = 0;
    reg S_half_d3                = 0;
    reg S_half_d4                = 0;

    wire [WIDTH-1:0] delay1_in_re;
    wire [WIDTH-1:0] delay1_in_im;
    wire [WIDTH-1:0] delay1_out_re;
    wire [WIDTH-1:0] delay1_out_im;
    wire [WIDTH-1:0] butterfly1_out_a_re;
    wire [WIDTH-1:0] butterfly1_out_a_im;
    wire [WIDTH-1:0] butterfly1_out_b_re;
    wire [WIDTH-1:0] butterfly1_out_b_im;
    
    reg [WIDTH-1:0] delay1_out_re_last;
    reg [WIDTH-1:0] delay1_out_im_last;
    
    reg [LOGN-1:0] stage1_out_cnt = 0;
    reg stage1_out_en             = 0;
    reg [WIDTH-1:0] stage1_out_re = 0;
    reg [WIDTH-1:0] stage1_out_im = 0;
    
    //data input counter
    always @(posedge clk) begin
        if (enable_in) begin
            in_cnt <= in_cnt + 1;
        end
        else begin
            in_cnt <= 0;
        end
    end
    
    //S_half is used to determine the input of the delay module
    assign S_half = in_cnt[LOGS-1];//S_half = 0 when in_cnt[LOGS-1:0] < S/2, 1 otherwise
    
    always @(posedge clk) begin
        S_half_d1 <= S_half;
        S_half_d2 <= S_half_d1;
        S_half_d3 <= S_half_d2;
        S_half_d4 <= S_half_d3;
    end
    
    //input data
    assign delay1_in_re = S_half ? butterfly1_out_b_re : in_re;
    assign delay1_in_im = S_half ? butterfly1_out_b_im : in_im;
    
    //delay data_in
    delay #(.DEPTH((S>>1)), .WIDTH(WIDTH)) u_delay1(
    .clk    (clk),
    .in_re  (delay1_in_re),
    .in_im  (delay1_in_im),
    .out_re (delay1_out_re),
    .out_im (delay1_out_im)
    );
    
    butterfly u1_butterfly(
    .clk      (clk),
    .in_a_re  (delay1_out_re),
    .in_a_im  (delay1_out_im),
    .in_b_re  (in_re),
    .in_b_im  (in_im),
    .out_a_re (butterfly1_out_a_re),
    .out_a_im (butterfly1_out_a_im),
    .out_b_re (butterfly1_out_b_re),
    .out_b_im (butterfly1_out_b_im)
    );

    //save out_b last data
    always @(posedge clk ) begin
        if(~S_half&&S_half_d1) 
        begin
            delay1_out_re_last <= butterfly1_out_b_re;
            delay1_out_im_last <= butterfly1_out_b_im;
        end
        else
        begin
            delay1_out_re_last <= delay1_out_re_last;
            delay1_out_im_last <= delay1_out_re_last;
        end
    end
    //output data
    always @(posedge clk) begin
        if(S_half_d1)
        begin
            stage1_out_en <= 1;
        end
        else if(stage1_out_cnt == N - 1)
        begin
            stage1_out_en <= 0;
        end

    end

    always @(posedge clk) begin
        if(stage1_out_en)
        begin
            stage1_out_cnt <= stage1_out_cnt + 1;
        end
        else
        begin
            stage1_out_cnt <= 0;
        end
    end


    always @(posedge clk) begin
        if(S_half_d1)
        begin
            stage1_out_re <= butterfly1_out_a_re;
            stage1_out_im <= butterfly1_out_a_im;
        end
        else if(stage1_out_cnt == S>>1 - 1)
        begin 
            stage1_out_re <= delay1_out_re_last;
            stage1_out_im <= delay1_out_im_last;
        end
    end

    
    //********************************************************
    //Stage 2
    //********************************************************
    
    
endmodule
