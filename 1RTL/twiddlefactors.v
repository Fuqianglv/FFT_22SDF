// This file is the output of the twiddlefactors
// generator. It contains the twiddle factors for
// the FFT module.


module twiddlefactors#(parameter N = 64,
                       parameter ADDR_WIDTH =  ( $clog2(N) < 4 ) ? 4 : $clog2(N))
                      (input clk,
                       input [ADDR_WIDTH-1:0] addr,
                       output reg signed [7:0] twiddle_re,
                       output reg signed [7:0] twiddle_im);

    localparam WIDTH = 8;

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
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    end
    else if (N == 16) begin
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    assign wn_re[1] = 8'sd118;assign wn_im[1] = -8'sd49;
    end
    else if (N == 32) begin
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    assign wn_re[1] = 8'sd126;assign wn_im[1] = -8'sd25;
    assign wn_re[2] = 8'sd118;assign wn_im[2] = -8'sd49;
    assign wn_re[3] = 8'sd106;assign wn_im[3] = -8'sd71;
    end
    else if (N == 64) begin
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    assign wn_re[1] = 8'sd127;assign wn_im[1] = -8'sd13;
    assign wn_re[2] = 8'sd126;assign wn_im[2] = -8'sd25;
    assign wn_re[3] = 8'sd122;assign wn_im[3] = -8'sd37;
    assign wn_re[4] = 8'sd118;assign wn_im[4] = -8'sd49;
    assign wn_re[5] = 8'sd113;assign wn_im[5] = -8'sd60;
    assign wn_re[6] = 8'sd106;assign wn_im[6] = -8'sd71;
    assign wn_re[7] = 8'sd99;assign wn_im[7] = -8'sd81;
    end
    else if (N == 128) begin
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    assign wn_re[1] = 8'sd128;assign wn_im[1] = -8'sd6;
    assign wn_re[2] = 8'sd127;assign wn_im[2] = -8'sd13;
    assign wn_re[3] = 8'sd127;assign wn_im[3] = -8'sd19;
    assign wn_re[4] = 8'sd126;assign wn_im[4] = -8'sd25;
    assign wn_re[5] = 8'sd124;assign wn_im[5] = -8'sd31;
    assign wn_re[6] = 8'sd122;assign wn_im[6] = -8'sd37;
    assign wn_re[7] = 8'sd121;assign wn_im[7] = -8'sd43;
    assign wn_re[8] = 8'sd118;assign wn_im[8] = -8'sd49;
    assign wn_re[9] = 8'sd116;assign wn_im[9] = -8'sd55;
    assign wn_re[10] = 8'sd113;assign wn_im[10] = -8'sd60;
    assign wn_re[11] = 8'sd110;assign wn_im[11] = -8'sd66;
    assign wn_re[12] = 8'sd106;assign wn_im[12] = -8'sd71;
    assign wn_re[13] = 8'sd103;assign wn_im[13] = -8'sd76;
    assign wn_re[14] = 8'sd99;assign wn_im[14] = -8'sd81;
    assign wn_re[15] = 8'sd95;assign wn_im[15] = -8'sd86;
    end
    else if (N == 256) begin
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    assign wn_re[1] = 8'sd128;assign wn_im[1] = -8'sd3;
    assign wn_re[2] = 8'sd128;assign wn_im[2] = -8'sd6;
    assign wn_re[3] = 8'sd128;assign wn_im[3] = -8'sd9;
    assign wn_re[4] = 8'sd127;assign wn_im[4] = -8'sd13;
    assign wn_re[5] = 8'sd127;assign wn_im[5] = -8'sd16;
    assign wn_re[6] = 8'sd127;assign wn_im[6] = -8'sd19;
    assign wn_re[7] = 8'sd126;assign wn_im[7] = -8'sd22;
    assign wn_re[8] = 8'sd126;assign wn_im[8] = -8'sd25;
    assign wn_re[9] = 8'sd125;assign wn_im[9] = -8'sd28;
    assign wn_re[10] = 8'sd124;assign wn_im[10] = -8'sd31;
    assign wn_re[11] = 8'sd123;assign wn_im[11] = -8'sd34;
    assign wn_re[12] = 8'sd122;assign wn_im[12] = -8'sd37;
    assign wn_re[13] = 8'sd122;assign wn_im[13] = -8'sd40;
    assign wn_re[14] = 8'sd121;assign wn_im[14] = -8'sd43;
    assign wn_re[15] = 8'sd119;assign wn_im[15] = -8'sd46;
    assign wn_re[16] = 8'sd118;assign wn_im[16] = -8'sd49;
    assign wn_re[17] = 8'sd117;assign wn_im[17] = -8'sd52;
    assign wn_re[18] = 8'sd116;assign wn_im[18] = -8'sd55;
    assign wn_re[19] = 8'sd114;assign wn_im[19] = -8'sd58;
    assign wn_re[20] = 8'sd113;assign wn_im[20] = -8'sd60;
    assign wn_re[21] = 8'sd111;assign wn_im[21] = -8'sd63;
    assign wn_re[22] = 8'sd110;assign wn_im[22] = -8'sd66;
    assign wn_re[23] = 8'sd108;assign wn_im[23] = -8'sd68;
    assign wn_re[24] = 8'sd106;assign wn_im[24] = -8'sd71;
    assign wn_re[25] = 8'sd105;assign wn_im[25] = -8'sd74;
    assign wn_re[26] = 8'sd103;assign wn_im[26] = -8'sd76;
    assign wn_re[27] = 8'sd101;assign wn_im[27] = -8'sd79;
    assign wn_re[28] = 8'sd99;assign wn_im[28] = -8'sd81;
    assign wn_re[29] = 8'sd97;assign wn_im[29] = -8'sd84;
    assign wn_re[30] = 8'sd95;assign wn_im[30] = -8'sd86;
    assign wn_re[31] = 8'sd93;assign wn_im[31] = -8'sd88;
    end
    else if (N == 512) begin
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    assign wn_re[1] = 8'sd128;assign wn_im[1] = -8'sd2;
    assign wn_re[2] = 8'sd128;assign wn_im[2] = -8'sd3;
    assign wn_re[3] = 8'sd128;assign wn_im[3] = -8'sd5;
    assign wn_re[4] = 8'sd128;assign wn_im[4] = -8'sd6;
    assign wn_re[5] = 8'sd128;assign wn_im[5] = -8'sd8;
    assign wn_re[6] = 8'sd128;assign wn_im[6] = -8'sd9;
    assign wn_re[7] = 8'sd128;assign wn_im[7] = -8'sd11;
    assign wn_re[8] = 8'sd127;assign wn_im[8] = -8'sd13;
    assign wn_re[9] = 8'sd127;assign wn_im[9] = -8'sd14;
    assign wn_re[10] = 8'sd127;assign wn_im[10] = -8'sd16;
    assign wn_re[11] = 8'sd127;assign wn_im[11] = -8'sd17;
    assign wn_re[12] = 8'sd127;assign wn_im[12] = -8'sd19;
    assign wn_re[13] = 8'sd126;assign wn_im[13] = -8'sd20;
    assign wn_re[14] = 8'sd126;assign wn_im[14] = -8'sd22;
    assign wn_re[15] = 8'sd126;assign wn_im[15] = -8'sd23;
    assign wn_re[16] = 8'sd126;assign wn_im[16] = -8'sd25;
    assign wn_re[17] = 8'sd125;assign wn_im[17] = -8'sd27;
    assign wn_re[18] = 8'sd125;assign wn_im[18] = -8'sd28;
    assign wn_re[19] = 8'sd125;assign wn_im[19] = -8'sd30;
    assign wn_re[20] = 8'sd124;assign wn_im[20] = -8'sd31;
    assign wn_re[21] = 8'sd124;assign wn_im[21] = -8'sd33;
    assign wn_re[22] = 8'sd123;assign wn_im[22] = -8'sd34;
    assign wn_re[23] = 8'sd123;assign wn_im[23] = -8'sd36;
    assign wn_re[24] = 8'sd122;assign wn_im[24] = -8'sd37;
    assign wn_re[25] = 8'sd122;assign wn_im[25] = -8'sd39;
    assign wn_re[26] = 8'sd122;assign wn_im[26] = -8'sd40;
    assign wn_re[27] = 8'sd121;assign wn_im[27] = -8'sd42;
    assign wn_re[28] = 8'sd121;assign wn_im[28] = -8'sd43;
    assign wn_re[29] = 8'sd120;assign wn_im[29] = -8'sd45;
    assign wn_re[30] = 8'sd119;assign wn_im[30] = -8'sd46;
    assign wn_re[31] = 8'sd119;assign wn_im[31] = -8'sd48;
    assign wn_re[32] = 8'sd118;assign wn_im[32] = -8'sd49;
    assign wn_re[33] = 8'sd118;assign wn_im[33] = -8'sd50;
    assign wn_re[34] = 8'sd117;assign wn_im[34] = -8'sd52;
    assign wn_re[35] = 8'sd116;assign wn_im[35] = -8'sd53;
    assign wn_re[36] = 8'sd116;assign wn_im[36] = -8'sd55;
    assign wn_re[37] = 8'sd115;assign wn_im[37] = -8'sd56;
    assign wn_re[38] = 8'sd114;assign wn_im[38] = -8'sd58;
    assign wn_re[39] = 8'sd114;assign wn_im[39] = -8'sd59;
    assign wn_re[40] = 8'sd113;assign wn_im[40] = -8'sd60;
    assign wn_re[41] = 8'sd112;assign wn_im[41] = -8'sd62;
    assign wn_re[42] = 8'sd111;assign wn_im[42] = -8'sd63;
    assign wn_re[43] = 8'sd111;assign wn_im[43] = -8'sd64;
    assign wn_re[44] = 8'sd110;assign wn_im[44] = -8'sd66;
    assign wn_re[45] = 8'sd109;assign wn_im[45] = -8'sd67;
    assign wn_re[46] = 8'sd108;assign wn_im[46] = -8'sd68;
    assign wn_re[47] = 8'sd107;assign wn_im[47] = -8'sd70;
    assign wn_re[48] = 8'sd106;assign wn_im[48] = -8'sd71;
    assign wn_re[49] = 8'sd106;assign wn_im[49] = -8'sd72;
    assign wn_re[50] = 8'sd105;assign wn_im[50] = -8'sd74;
    assign wn_re[51] = 8'sd104;assign wn_im[51] = -8'sd75;
    assign wn_re[52] = 8'sd103;assign wn_im[52] = -8'sd76;
    assign wn_re[53] = 8'sd102;assign wn_im[53] = -8'sd78;
    assign wn_re[54] = 8'sd101;assign wn_im[54] = -8'sd79;
    assign wn_re[55] = 8'sd100;assign wn_im[55] = -8'sd80;
    assign wn_re[56] = 8'sd99;assign wn_im[56] = -8'sd81;
    assign wn_re[57] = 8'sd98;assign wn_im[57] = -8'sd82;
    assign wn_re[58] = 8'sd97;assign wn_im[58] = -8'sd84;
    assign wn_re[59] = 8'sd96;assign wn_im[59] = -8'sd85;
    assign wn_re[60] = 8'sd95;assign wn_im[60] = -8'sd86;
    assign wn_re[61] = 8'sd94;assign wn_im[61] = -8'sd87;
    assign wn_re[62] = 8'sd93;assign wn_im[62] = -8'sd88;
    assign wn_re[63] = 8'sd92;assign wn_im[63] = -8'sd89;
    end
    else if (N == 1024) begin
    assign wn_re[0] = 8'sd128;assign wn_im[0] = -8'sd0;
    assign wn_re[1] = 8'sd128;assign wn_im[1] = -8'sd1;
    assign wn_re[2] = 8'sd128;assign wn_im[2] = -8'sd2;
    assign wn_re[3] = 8'sd128;assign wn_im[3] = -8'sd2;
    assign wn_re[4] = 8'sd128;assign wn_im[4] = -8'sd3;
    assign wn_re[5] = 8'sd128;assign wn_im[5] = -8'sd4;
    assign wn_re[6] = 8'sd128;assign wn_im[6] = -8'sd5;
    assign wn_re[7] = 8'sd128;assign wn_im[7] = -8'sd5;
    assign wn_re[8] = 8'sd128;assign wn_im[8] = -8'sd6;
    assign wn_re[9] = 8'sd128;assign wn_im[9] = -8'sd7;
    assign wn_re[10] = 8'sd128;assign wn_im[10] = -8'sd8;
    assign wn_re[11] = 8'sd128;assign wn_im[11] = -8'sd9;
    assign wn_re[12] = 8'sd128;assign wn_im[12] = -8'sd9;
    assign wn_re[13] = 8'sd128;assign wn_im[13] = -8'sd10;
    assign wn_re[14] = 8'sd128;assign wn_im[14] = -8'sd11;
    assign wn_re[15] = 8'sd127;assign wn_im[15] = -8'sd12;
    assign wn_re[16] = 8'sd127;assign wn_im[16] = -8'sd13;
    assign wn_re[17] = 8'sd127;assign wn_im[17] = -8'sd13;
    assign wn_re[18] = 8'sd127;assign wn_im[18] = -8'sd14;
    assign wn_re[19] = 8'sd127;assign wn_im[19] = -8'sd15;
    assign wn_re[20] = 8'sd127;assign wn_im[20] = -8'sd16;
    assign wn_re[21] = 8'sd127;assign wn_im[21] = -8'sd16;
    assign wn_re[22] = 8'sd127;assign wn_im[22] = -8'sd17;
    assign wn_re[23] = 8'sd127;assign wn_im[23] = -8'sd18;
    assign wn_re[24] = 8'sd127;assign wn_im[24] = -8'sd19;
    assign wn_re[25] = 8'sd126;assign wn_im[25] = -8'sd20;
    assign wn_re[26] = 8'sd126;assign wn_im[26] = -8'sd20;
    assign wn_re[27] = 8'sd126;assign wn_im[27] = -8'sd21;
    assign wn_re[28] = 8'sd126;assign wn_im[28] = -8'sd22;
    assign wn_re[29] = 8'sd126;assign wn_im[29] = -8'sd23;
    assign wn_re[30] = 8'sd126;assign wn_im[30] = -8'sd23;
    assign wn_re[31] = 8'sd126;assign wn_im[31] = -8'sd24;
    assign wn_re[32] = 8'sd126;assign wn_im[32] = -8'sd25;
    assign wn_re[33] = 8'sd125;assign wn_im[33] = -8'sd26;
    assign wn_re[34] = 8'sd125;assign wn_im[34] = -8'sd27;
    assign wn_re[35] = 8'sd125;assign wn_im[35] = -8'sd27;
    assign wn_re[36] = 8'sd125;assign wn_im[36] = -8'sd28;
    assign wn_re[37] = 8'sd125;assign wn_im[37] = -8'sd29;
    assign wn_re[38] = 8'sd125;assign wn_im[38] = -8'sd30;
    assign wn_re[39] = 8'sd124;assign wn_im[39] = -8'sd30;
    assign wn_re[40] = 8'sd124;assign wn_im[40] = -8'sd31;
    assign wn_re[41] = 8'sd124;assign wn_im[41] = -8'sd32;
    assign wn_re[42] = 8'sd124;assign wn_im[42] = -8'sd33;
    assign wn_re[43] = 8'sd124;assign wn_im[43] = -8'sd33;
    assign wn_re[44] = 8'sd123;assign wn_im[44] = -8'sd34;
    assign wn_re[45] = 8'sd123;assign wn_im[45] = -8'sd35;
    assign wn_re[46] = 8'sd123;assign wn_im[46] = -8'sd36;
    assign wn_re[47] = 8'sd123;assign wn_im[47] = -8'sd36;
    assign wn_re[48] = 8'sd122;assign wn_im[48] = -8'sd37;
    assign wn_re[49] = 8'sd122;assign wn_im[49] = -8'sd38;
    assign wn_re[50] = 8'sd122;assign wn_im[50] = -8'sd39;
    assign wn_re[51] = 8'sd122;assign wn_im[51] = -8'sd39;
    assign wn_re[52] = 8'sd122;assign wn_im[52] = -8'sd40;
    assign wn_re[53] = 8'sd121;assign wn_im[53] = -8'sd41;
    assign wn_re[54] = 8'sd121;assign wn_im[54] = -8'sd42;
    assign wn_re[55] = 8'sd121;assign wn_im[55] = -8'sd42;
    assign wn_re[56] = 8'sd121;assign wn_im[56] = -8'sd43;
    assign wn_re[57] = 8'sd120;assign wn_im[57] = -8'sd44;
    assign wn_re[58] = 8'sd120;assign wn_im[58] = -8'sd45;
    assign wn_re[59] = 8'sd120;assign wn_im[59] = -8'sd45;
    assign wn_re[60] = 8'sd119;assign wn_im[60] = -8'sd46;
    assign wn_re[61] = 8'sd119;assign wn_im[61] = -8'sd47;
    assign wn_re[62] = 8'sd119;assign wn_im[62] = -8'sd48;
    assign wn_re[63] = 8'sd119;assign wn_im[63] = -8'sd48;
    assign wn_re[64] = 8'sd118;assign wn_im[64] = -8'sd49;
    assign wn_re[65] = 8'sd118;assign wn_im[65] = -8'sd50;
    assign wn_re[66] = 8'sd118;assign wn_im[66] = -8'sd50;
    assign wn_re[67] = 8'sd117;assign wn_im[67] = -8'sd51;
    assign wn_re[68] = 8'sd117;assign wn_im[68] = -8'sd52;
    assign wn_re[69] = 8'sd117;assign wn_im[69] = -8'sd53;
    assign wn_re[70] = 8'sd116;assign wn_im[70] = -8'sd53;
    assign wn_re[71] = 8'sd116;assign wn_im[71] = -8'sd54;
    assign wn_re[72] = 8'sd116;assign wn_im[72] = -8'sd55;
    assign wn_re[73] = 8'sd115;assign wn_im[73] = -8'sd55;
    assign wn_re[74] = 8'sd115;assign wn_im[74] = -8'sd56;
    assign wn_re[75] = 8'sd115;assign wn_im[75] = -8'sd57;
    assign wn_re[76] = 8'sd114;assign wn_im[76] = -8'sd58;
    assign wn_re[77] = 8'sd114;assign wn_im[77] = -8'sd58;
    assign wn_re[78] = 8'sd114;assign wn_im[78] = -8'sd59;
    assign wn_re[79] = 8'sd113;assign wn_im[79] = -8'sd60;
    assign wn_re[80] = 8'sd113;assign wn_im[80] = -8'sd60;
    assign wn_re[81] = 8'sd113;assign wn_im[81] = -8'sd61;
    assign wn_re[82] = 8'sd112;assign wn_im[82] = -8'sd62;
    assign wn_re[83] = 8'sd112;assign wn_im[83] = -8'sd62;
    assign wn_re[84] = 8'sd111;assign wn_im[84] = -8'sd63;
    assign wn_re[85] = 8'sd111;assign wn_im[85] = -8'sd64;
    assign wn_re[86] = 8'sd111;assign wn_im[86] = -8'sd64;
    assign wn_re[87] = 8'sd110;assign wn_im[87] = -8'sd65;
    assign wn_re[88] = 8'sd110;assign wn_im[88] = -8'sd66;
    assign wn_re[89] = 8'sd109;assign wn_im[89] = -8'sd66;
    assign wn_re[90] = 8'sd109;assign wn_im[90] = -8'sd67;
    assign wn_re[91] = 8'sd109;assign wn_im[91] = -8'sd68;
    assign wn_re[92] = 8'sd108;assign wn_im[92] = -8'sd68;
    assign wn_re[93] = 8'sd108;assign wn_im[93] = -8'sd69;
    assign wn_re[94] = 8'sd107;assign wn_im[94] = -8'sd70;
    assign wn_re[95] = 8'sd107;assign wn_im[95] = -8'sd70;
    assign wn_re[96] = 8'sd106;assign wn_im[96] = -8'sd71;
    assign wn_re[97] = 8'sd106;assign wn_im[97] = -8'sd72;
    assign wn_re[98] = 8'sd106;assign wn_im[98] = -8'sd72;
    assign wn_re[99] = 8'sd105;assign wn_im[99] = -8'sd73;
    assign wn_re[100] = 8'sd105;assign wn_im[100] = -8'sd74;
    assign wn_re[101] = 8'sd104;assign wn_im[101] = -8'sd74;
    assign wn_re[102] = 8'sd104;assign wn_im[102] = -8'sd75;
    assign wn_re[103] = 8'sd103;assign wn_im[103] = -8'sd76;
    assign wn_re[104] = 8'sd103;assign wn_im[104] = -8'sd76;
    assign wn_re[105] = 8'sd102;assign wn_im[105] = -8'sd77;
    assign wn_re[106] = 8'sd102;assign wn_im[106] = -8'sd78;
    assign wn_re[107] = 8'sd101;assign wn_im[107] = -8'sd78;
    assign wn_re[108] = 8'sd101;assign wn_im[108] = -8'sd79;
    assign wn_re[109] = 8'sd100;assign wn_im[109] = -8'sd79;
    assign wn_re[110] = 8'sd100;assign wn_im[110] = -8'sd80;
    assign wn_re[111] = 8'sd99;assign wn_im[111] = -8'sd81;
    assign wn_re[112] = 8'sd99;assign wn_im[112] = -8'sd81;
    assign wn_re[113] = 8'sd98;assign wn_im[113] = -8'sd82;
    assign wn_re[114] = 8'sd98;assign wn_im[114] = -8'sd82;
    assign wn_re[115] = 8'sd97;assign wn_im[115] = -8'sd83;
    assign wn_re[116] = 8'sd97;assign wn_im[116] = -8'sd84;
    assign wn_re[117] = 8'sd96;assign wn_im[117] = -8'sd84;
    assign wn_re[118] = 8'sd96;assign wn_im[118] = -8'sd85;
    assign wn_re[119] = 8'sd95;assign wn_im[119] = -8'sd85;
    assign wn_re[120] = 8'sd95;assign wn_im[120] = -8'sd86;
    assign wn_re[121] = 8'sd94;assign wn_im[121] = -8'sd87;
    assign wn_re[122] = 8'sd94;assign wn_im[122] = -8'sd87;
    assign wn_re[123] = 8'sd93;assign wn_im[123] = -8'sd88;
    assign wn_re[124] = 8'sd93;assign wn_im[124] = -8'sd88;
    assign wn_re[125] = 8'sd92;assign wn_im[125] = -8'sd89;
    assign wn_re[126] = 8'sd92;assign wn_im[126] = -8'sd89;
    assign wn_re[127] = 8'sd91;assign wn_im[127] = -8'sd90;
    end
    else begin
        //default case
    end
    endgenerate

endmodule