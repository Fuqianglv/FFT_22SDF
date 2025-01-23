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
    wire S1_half;
    reg S1_half_d1 = 0;
    
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
    
    //S1_half is used to determine the input of the delay module
    assign S1_half = in_cnt[LOGS-1];//S1_half = 0 when in_cnt[LOGS-1:0] < S/2, 1 otherwise
    
    always @(posedge clk) begin
        S1_half_d1 <= S1_half;
    end
    
    //input data
    assign delay1_in_re = S1_half ? butterfly1_out_b_re : in_re;
    assign delay1_in_im = S1_half ? butterfly1_out_b_im : in_im;
    
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
    always @(posedge clk) begin
        if (~S1_half&&S1_half_d1)
        begin
            delay1_out_re_last <= butterfly1_out_b_re;
            delay1_out_im_last <= butterfly1_out_b_im;
        end
        else
        begin
            delay1_out_re_last <= delay1_out_re_last;
            delay1_out_im_last <= delay1_out_im_last;
        end
    end
    //output data
    always @(posedge clk) begin
        if (S1_half_d1)
        begin
            stage1_out_en <= 1;
        end
        else if (stage1_out_cnt == N - 1)
        begin
            stage1_out_en <= 0;
        end
        else
        begin
            stage1_out_en <= stage1_out_en;
        end
    end
    
    always @(posedge clk) begin
        if (stage1_out_en)
        begin
            stage1_out_cnt <= stage1_out_cnt + 1;
        end
        else
        begin
            stage1_out_cnt <= 0;
        end
    end
    
    
    always @(posedge clk) begin
        if (S1_half_d1)
        begin
            stage1_out_re <= butterfly1_out_a_re;
            stage1_out_im <= butterfly1_out_a_im;
        end
        else if (stage1_out_cnt[LOGS-1:0] == S - 2)
        begin
            stage1_out_re <= delay1_out_re_last;
            stage1_out_im <= delay1_out_im_last;
        end
        else
        begin
            stage1_out_re <= delay1_out_re;
            stage1_out_im <= delay1_out_im;
        end
    end
    
    
    //********************************************************
    //Stage 2
    //********************************************************
    // define the variables stage 2
    wire S2_half;
    reg S2_half_d1 = 0;
    
    wire [WIDTH-1:0] delay2_in_re;
    wire [WIDTH-1:0] delay2_in_im;
    wire [WIDTH-1:0] delay2_out_re;
    wire [WIDTH-1:0] delay2_out_im;
    wire [WIDTH-1:0] butterfly2_out_a_re;
    wire [WIDTH-1:0] butterfly2_out_a_im;
    wire [WIDTH-1:0] butterfly2_out_b_re;
    wire [WIDTH-1:0] butterfly2_out_b_im;
    
    reg [WIDTH-1:0] delay2_out_re_last;
    reg [WIDTH-1:0] delay2_out_im_last;
    
    reg [LOGN-1:0] stage2_out_cnt = 0;
    reg stage2_out_en             = 0;
    reg [WIDTH-1:0] stage2_out_re = 0;
    reg [WIDTH-1:0] stage2_out_im = 0;
    
    
    //S2_half is used to determine the input of the delay module
    assign S2_half = stage1_out_cnt[LOGS-2];//S2_half = 0 when in_cnt2[LOGS-1:0] < S/2, 1 otherwise
    
    always @(posedge clk) begin
        S2_half_d1 <= S2_half;
    end
    
    //input data
    assign delay2_in_re = S2_half ? butterfly2_out_b_re : stage1_out_re;
    assign delay2_in_im = S2_half ? butterfly2_out_b_im : stage1_out_im;
    
    //delay data_in
    delay #(.DEPTH((S>>2)), .WIDTH(WIDTH)) u_delay2(
    .clk    (clk),
    .in_re  (delay2_in_re),
    .in_im  (delay2_in_im),
    .out_re (delay2_out_re),
    .out_im (delay2_out_im)
    );
    
    butterfly u2_butterfly(
    .clk      (clk),
    .in_a_re  (delay2_out_re),
    .in_a_im  (delay2_out_im),
    .in_b_re  (stage1_out_re),
    .in_b_im  (stage1_out_im),
    .out_a_re (butterfly2_out_a_re),
    .out_a_im (butterfly2_out_a_im),
    .out_b_re (butterfly2_out_b_re),
    .out_b_im (butterfly2_out_b_im)
    );
    
    //save out_b last data
    always @(posedge clk) begin
        if (~S2_half&&S2_half_d1)
        begin
            delay2_out_re_last <= butterfly2_out_b_re;
            delay2_out_im_last <= butterfly2_out_b_im;
        end
        else
        begin
            delay2_out_re_last <= delay2_out_re_last;
            delay2_out_im_last <= delay2_out_im_last;
        end
    end
    //output data
    always @(posedge clk) begin
        if (S2_half_d1)
        begin
            stage2_out_en <= 1;
        end
        else if (stage2_out_cnt == N - 1)
        begin
            stage2_out_en <= 0;
        end
        else
        begin
            stage2_out_en <= stage2_out_en;
        end
    end
    
    always @(posedge clk) begin
        if (stage2_out_en)
        begin
            stage2_out_cnt <= stage2_out_cnt + 1;
        end
        else
        begin
            stage2_out_cnt <= 0;
        end
    end
    
    
    always @(posedge clk) begin
        if (S2_half_d1)
        begin
            stage2_out_re <= butterfly2_out_a_re;
            stage2_out_im <= butterfly2_out_a_im;
        end
        else if (stage2_out_cnt[LOGS-2:0] == (S>>1) - 2)
        begin
            stage2_out_re <= delay2_out_re_last;
            stage2_out_im <= delay2_out_im_last;
        end
        else
        begin
            stage2_out_re <= delay2_out_re;
            stage2_out_im <= delay2_out_im;
        end
    end
    
    //********************************************************
    //Multiplication
    //********************************************************
    // define the variables multiplication
    generate if (LOGS>2)
    begin
    wire [1:0] S2_bank;
    wire [WIDTH-1:0] twiddle_re;
    wire [WIDTH-1:0] twiddle_im;
    reg [LOGS-1:0] tw_addr         = 0; // twiddle address
    reg tw_addr_syn_en             = 0;
    reg [LOGN-1:0] tw_addr_syn_cnt = 0;
    
    always @(posedge clk) begin
        if (S2_half_d1&&~tw_addr_syn_en) begin
            tw_addr_syn_cnt <= 3;
            tw_addr_syn_en  <= 1;
        end
        else if (tw_addr_syn_cnt == N-1) begin
            tw_addr_syn_en <= 0;
        end
            else if (tw_addr_syn_en)
            begin
            tw_addr_syn_cnt <= tw_addr_syn_cnt + 1;
            end
        else
        begin
            tw_addr_syn_cnt <= 0;
        end
    end
    assign S2_bank = {tw_addr_syn_cnt[LOGS-2], tw_addr_syn_cnt[LOGS-1]};
    always @(posedge clk) begin
        tw_addr <= S2_bank*tw_addr_syn_cnt[LOGS-3:0];
    end
    twiddlefactors #(.N(S)) u_twiddlefactors(
    .clk        (clk),
    .addr       (tw_addr),
    .twiddle_re (twiddle_re),
    .twiddle_im (twiddle_im)
    );
    
    MulComplex #(.WIDTH(WIDTH)) u_MulComplex(
    .clk     (clk),
    .in_a_re (stage2_out_re),
    .in_a_im (stage2_out_im),
    .in_b_re (twiddle_re),
    .in_b_im (twiddle_im),
    .out_re  (out_re),
    .out_im  (out_im)
    );

    reg stage2_out_en_d1 = 0;
    reg stage2_out_en_d2 = 0;
    always @(posedge clk) begin
        stage2_out_en_d1 <= stage2_out_en;
        stage2_out_en_d2 <= stage2_out_en_d1;
    end
    assign enable_out = stage2_out_en_d2;

    end
    else
    begin
    assign out_re = stage2_out_re;
    assign out_im = stage2_out_im;
    assign enable_out = stage2_out_en;
    end
    endgenerate
   
endmodule
