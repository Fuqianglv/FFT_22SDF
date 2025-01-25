// This file is the output of the twiddlefactors
// generator. It contains the twiddle factors for
// the FFT module.


module twiddlefactors#(parameter N = 64,
                       parameter ADDR_WIDTH =  ( $clog2(N) < 4 ) ? 4 : $clog2(N))
                      (input clk,
                       input [ADDR_WIDTH-1:0] addr,
                       output reg signed [15:0] twiddle_re,
                       output reg signed [15:0] twiddle_im);

    localparam WIDTH = 16;

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
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    end
    else if (N == 16) begin
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    assign wn_re[1] = 16'sd30274;assign wn_im[1] = -16'sd12540;
    end
    else if (N == 32) begin
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    assign wn_re[1] = 16'sd32138;assign wn_im[1] = -16'sd6393;
    assign wn_re[2] = 16'sd30274;assign wn_im[2] = -16'sd12540;
    assign wn_re[3] = 16'sd27246;assign wn_im[3] = -16'sd18205;
    end
    else if (N == 64) begin
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    assign wn_re[1] = 16'sd32610;assign wn_im[1] = -16'sd3212;
    assign wn_re[2] = 16'sd32138;assign wn_im[2] = -16'sd6393;
    assign wn_re[3] = 16'sd31357;assign wn_im[3] = -16'sd9512;
    assign wn_re[4] = 16'sd30274;assign wn_im[4] = -16'sd12540;
    assign wn_re[5] = 16'sd28899;assign wn_im[5] = -16'sd15447;
    assign wn_re[6] = 16'sd27246;assign wn_im[6] = -16'sd18205;
    assign wn_re[7] = 16'sd25330;assign wn_im[7] = -16'sd20788;
    end
    else if (N == 128) begin
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    assign wn_re[1] = 16'sd32729;assign wn_im[1] = -16'sd1608;
    assign wn_re[2] = 16'sd32610;assign wn_im[2] = -16'sd3212;
    assign wn_re[3] = 16'sd32413;assign wn_im[3] = -16'sd4808;
    assign wn_re[4] = 16'sd32138;assign wn_im[4] = -16'sd6393;
    assign wn_re[5] = 16'sd31786;assign wn_im[5] = -16'sd7962;
    assign wn_re[6] = 16'sd31357;assign wn_im[6] = -16'sd9512;
    assign wn_re[7] = 16'sd30853;assign wn_im[7] = -16'sd11039;
    assign wn_re[8] = 16'sd30274;assign wn_im[8] = -16'sd12540;
    assign wn_re[9] = 16'sd29622;assign wn_im[9] = -16'sd14010;
    assign wn_re[10] = 16'sd28899;assign wn_im[10] = -16'sd15447;
    assign wn_re[11] = 16'sd28106;assign wn_im[11] = -16'sd16846;
    assign wn_re[12] = 16'sd27246;assign wn_im[12] = -16'sd18205;
    assign wn_re[13] = 16'sd26320;assign wn_im[13] = -16'sd19520;
    assign wn_re[14] = 16'sd25330;assign wn_im[14] = -16'sd20788;
    assign wn_re[15] = 16'sd24279;assign wn_im[15] = -16'sd22006;
    end
    else if (N == 256) begin
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    assign wn_re[1] = 16'sd32758;assign wn_im[1] = -16'sd804;
    assign wn_re[2] = 16'sd32729;assign wn_im[2] = -16'sd1608;
    assign wn_re[3] = 16'sd32679;assign wn_im[3] = -16'sd2411;
    assign wn_re[4] = 16'sd32610;assign wn_im[4] = -16'sd3212;
    assign wn_re[5] = 16'sd32522;assign wn_im[5] = -16'sd4011;
    assign wn_re[6] = 16'sd32413;assign wn_im[6] = -16'sd4808;
    assign wn_re[7] = 16'sd32286;assign wn_im[7] = -16'sd5602;
    assign wn_re[8] = 16'sd32138;assign wn_im[8] = -16'sd6393;
    assign wn_re[9] = 16'sd31972;assign wn_im[9] = -16'sd7180;
    assign wn_re[10] = 16'sd31786;assign wn_im[10] = -16'sd7962;
    assign wn_re[11] = 16'sd31581;assign wn_im[11] = -16'sd8740;
    assign wn_re[12] = 16'sd31357;assign wn_im[12] = -16'sd9512;
    assign wn_re[13] = 16'sd31114;assign wn_im[13] = -16'sd10279;
    assign wn_re[14] = 16'sd30853;assign wn_im[14] = -16'sd11039;
    assign wn_re[15] = 16'sd30572;assign wn_im[15] = -16'sd11793;
    assign wn_re[16] = 16'sd30274;assign wn_im[16] = -16'sd12540;
    assign wn_re[17] = 16'sd29957;assign wn_im[17] = -16'sd13279;
    assign wn_re[18] = 16'sd29622;assign wn_im[18] = -16'sd14010;
    assign wn_re[19] = 16'sd29269;assign wn_im[19] = -16'sd14733;
    assign wn_re[20] = 16'sd28899;assign wn_im[20] = -16'sd15447;
    assign wn_re[21] = 16'sd28511;assign wn_im[21] = -16'sd16151;
    assign wn_re[22] = 16'sd28106;assign wn_im[22] = -16'sd16846;
    assign wn_re[23] = 16'sd27684;assign wn_im[23] = -16'sd17531;
    assign wn_re[24] = 16'sd27246;assign wn_im[24] = -16'sd18205;
    assign wn_re[25] = 16'sd26791;assign wn_im[25] = -16'sd18868;
    assign wn_re[26] = 16'sd26320;assign wn_im[26] = -16'sd19520;
    assign wn_re[27] = 16'sd25833;assign wn_im[27] = -16'sd20160;
    assign wn_re[28] = 16'sd25330;assign wn_im[28] = -16'sd20788;
    assign wn_re[29] = 16'sd24812;assign wn_im[29] = -16'sd21403;
    assign wn_re[30] = 16'sd24279;assign wn_im[30] = -16'sd22006;
    assign wn_re[31] = 16'sd23732;assign wn_im[31] = -16'sd22595;
    end
    else if (N == 512) begin
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    assign wn_re[1] = 16'sd32766;assign wn_im[1] = -16'sd402;
    assign wn_re[2] = 16'sd32758;assign wn_im[2] = -16'sd804;
    assign wn_re[3] = 16'sd32746;assign wn_im[3] = -16'sd1206;
    assign wn_re[4] = 16'sd32729;assign wn_im[4] = -16'sd1608;
    assign wn_re[5] = 16'sd32706;assign wn_im[5] = -16'sd2009;
    assign wn_re[6] = 16'sd32679;assign wn_im[6] = -16'sd2411;
    assign wn_re[7] = 16'sd32647;assign wn_im[7] = -16'sd2811;
    assign wn_re[8] = 16'sd32610;assign wn_im[8] = -16'sd3212;
    assign wn_re[9] = 16'sd32568;assign wn_im[9] = -16'sd3612;
    assign wn_re[10] = 16'sd32522;assign wn_im[10] = -16'sd4011;
    assign wn_re[11] = 16'sd32470;assign wn_im[11] = -16'sd4410;
    assign wn_re[12] = 16'sd32413;assign wn_im[12] = -16'sd4808;
    assign wn_re[13] = 16'sd32352;assign wn_im[13] = -16'sd5205;
    assign wn_re[14] = 16'sd32286;assign wn_im[14] = -16'sd5602;
    assign wn_re[15] = 16'sd32214;assign wn_im[15] = -16'sd5998;
    assign wn_re[16] = 16'sd32138;assign wn_im[16] = -16'sd6393;
    assign wn_re[17] = 16'sd32058;assign wn_im[17] = -16'sd6787;
    assign wn_re[18] = 16'sd31972;assign wn_im[18] = -16'sd7180;
    assign wn_re[19] = 16'sd31881;assign wn_im[19] = -16'sd7571;
    assign wn_re[20] = 16'sd31786;assign wn_im[20] = -16'sd7962;
    assign wn_re[21] = 16'sd31686;assign wn_im[21] = -16'sd8351;
    assign wn_re[22] = 16'sd31581;assign wn_im[22] = -16'sd8740;
    assign wn_re[23] = 16'sd31471;assign wn_im[23] = -16'sd9127;
    assign wn_re[24] = 16'sd31357;assign wn_im[24] = -16'sd9512;
    assign wn_re[25] = 16'sd31238;assign wn_im[25] = -16'sd9896;
    assign wn_re[26] = 16'sd31114;assign wn_im[26] = -16'sd10279;
    assign wn_re[27] = 16'sd30986;assign wn_im[27] = -16'sd10660;
    assign wn_re[28] = 16'sd30853;assign wn_im[28] = -16'sd11039;
    assign wn_re[29] = 16'sd30715;assign wn_im[29] = -16'sd11417;
    assign wn_re[30] = 16'sd30572;assign wn_im[30] = -16'sd11793;
    assign wn_re[31] = 16'sd30425;assign wn_im[31] = -16'sd12167;
    assign wn_re[32] = 16'sd30274;assign wn_im[32] = -16'sd12540;
    assign wn_re[33] = 16'sd30118;assign wn_im[33] = -16'sd12910;
    assign wn_re[34] = 16'sd29957;assign wn_im[34] = -16'sd13279;
    assign wn_re[35] = 16'sd29792;assign wn_im[35] = -16'sd13646;
    assign wn_re[36] = 16'sd29622;assign wn_im[36] = -16'sd14010;
    assign wn_re[37] = 16'sd29448;assign wn_im[37] = -16'sd14373;
    assign wn_re[38] = 16'sd29269;assign wn_im[38] = -16'sd14733;
    assign wn_re[39] = 16'sd29086;assign wn_im[39] = -16'sd15091;
    assign wn_re[40] = 16'sd28899;assign wn_im[40] = -16'sd15447;
    assign wn_re[41] = 16'sd28707;assign wn_im[41] = -16'sd15800;
    assign wn_re[42] = 16'sd28511;assign wn_im[42] = -16'sd16151;
    assign wn_re[43] = 16'sd28311;assign wn_im[43] = -16'sd16500;
    assign wn_re[44] = 16'sd28106;assign wn_im[44] = -16'sd16846;
    assign wn_re[45] = 16'sd27897;assign wn_im[45] = -16'sd17190;
    assign wn_re[46] = 16'sd27684;assign wn_im[46] = -16'sd17531;
    assign wn_re[47] = 16'sd27467;assign wn_im[47] = -16'sd17869;
    assign wn_re[48] = 16'sd27246;assign wn_im[48] = -16'sd18205;
    assign wn_re[49] = 16'sd27020;assign wn_im[49] = -16'sd18538;
    assign wn_re[50] = 16'sd26791;assign wn_im[50] = -16'sd18868;
    assign wn_re[51] = 16'sd26557;assign wn_im[51] = -16'sd19195;
    assign wn_re[52] = 16'sd26320;assign wn_im[52] = -16'sd19520;
    assign wn_re[53] = 16'sd26078;assign wn_im[53] = -16'sd19841;
    assign wn_re[54] = 16'sd25833;assign wn_im[54] = -16'sd20160;
    assign wn_re[55] = 16'sd25583;assign wn_im[55] = -16'sd20475;
    assign wn_re[56] = 16'sd25330;assign wn_im[56] = -16'sd20788;
    assign wn_re[57] = 16'sd25073;assign wn_im[57] = -16'sd21097;
    assign wn_re[58] = 16'sd24812;assign wn_im[58] = -16'sd21403;
    assign wn_re[59] = 16'sd24548;assign wn_im[59] = -16'sd21706;
    assign wn_re[60] = 16'sd24279;assign wn_im[60] = -16'sd22006;
    assign wn_re[61] = 16'sd24008;assign wn_im[61] = -16'sd22302;
    assign wn_re[62] = 16'sd23732;assign wn_im[62] = -16'sd22595;
    assign wn_re[63] = 16'sd23453;assign wn_im[63] = -16'sd22884;
    end
    else if (N == 1024) begin
    assign wn_re[0] = 16'sd32768;assign wn_im[0] = -16'sd0;
    assign wn_re[1] = 16'sd32767;assign wn_im[1] = -16'sd201;
    assign wn_re[2] = 16'sd32766;assign wn_im[2] = -16'sd402;
    assign wn_re[3] = 16'sd32762;assign wn_im[3] = -16'sd603;
    assign wn_re[4] = 16'sd32758;assign wn_im[4] = -16'sd804;
    assign wn_re[5] = 16'sd32753;assign wn_im[5] = -16'sd1005;
    assign wn_re[6] = 16'sd32746;assign wn_im[6] = -16'sd1206;
    assign wn_re[7] = 16'sd32738;assign wn_im[7] = -16'sd1407;
    assign wn_re[8] = 16'sd32729;assign wn_im[8] = -16'sd1608;
    assign wn_re[9] = 16'sd32718;assign wn_im[9] = -16'sd1809;
    assign wn_re[10] = 16'sd32706;assign wn_im[10] = -16'sd2009;
    assign wn_re[11] = 16'sd32693;assign wn_im[11] = -16'sd2210;
    assign wn_re[12] = 16'sd32679;assign wn_im[12] = -16'sd2411;
    assign wn_re[13] = 16'sd32664;assign wn_im[13] = -16'sd2611;
    assign wn_re[14] = 16'sd32647;assign wn_im[14] = -16'sd2811;
    assign wn_re[15] = 16'sd32629;assign wn_im[15] = -16'sd3012;
    assign wn_re[16] = 16'sd32610;assign wn_im[16] = -16'sd3212;
    assign wn_re[17] = 16'sd32590;assign wn_im[17] = -16'sd3412;
    assign wn_re[18] = 16'sd32568;assign wn_im[18] = -16'sd3612;
    assign wn_re[19] = 16'sd32546;assign wn_im[19] = -16'sd3812;
    assign wn_re[20] = 16'sd32522;assign wn_im[20] = -16'sd4011;
    assign wn_re[21] = 16'sd32496;assign wn_im[21] = -16'sd4211;
    assign wn_re[22] = 16'sd32470;assign wn_im[22] = -16'sd4410;
    assign wn_re[23] = 16'sd32442;assign wn_im[23] = -16'sd4609;
    assign wn_re[24] = 16'sd32413;assign wn_im[24] = -16'sd4808;
    assign wn_re[25] = 16'sd32383;assign wn_im[25] = -16'sd5007;
    assign wn_re[26] = 16'sd32352;assign wn_im[26] = -16'sd5205;
    assign wn_re[27] = 16'sd32319;assign wn_im[27] = -16'sd5404;
    assign wn_re[28] = 16'sd32286;assign wn_im[28] = -16'sd5602;
    assign wn_re[29] = 16'sd32251;assign wn_im[29] = -16'sd5800;
    assign wn_re[30] = 16'sd32214;assign wn_im[30] = -16'sd5998;
    assign wn_re[31] = 16'sd32177;assign wn_im[31] = -16'sd6195;
    assign wn_re[32] = 16'sd32138;assign wn_im[32] = -16'sd6393;
    assign wn_re[33] = 16'sd32099;assign wn_im[33] = -16'sd6590;
    assign wn_re[34] = 16'sd32058;assign wn_im[34] = -16'sd6787;
    assign wn_re[35] = 16'sd32015;assign wn_im[35] = -16'sd6983;
    assign wn_re[36] = 16'sd31972;assign wn_im[36] = -16'sd7180;
    assign wn_re[37] = 16'sd31927;assign wn_im[37] = -16'sd7376;
    assign wn_re[38] = 16'sd31881;assign wn_im[38] = -16'sd7571;
    assign wn_re[39] = 16'sd31834;assign wn_im[39] = -16'sd7767;
    assign wn_re[40] = 16'sd31786;assign wn_im[40] = -16'sd7962;
    assign wn_re[41] = 16'sd31737;assign wn_im[41] = -16'sd8157;
    assign wn_re[42] = 16'sd31686;assign wn_im[42] = -16'sd8351;
    assign wn_re[43] = 16'sd31634;assign wn_im[43] = -16'sd8546;
    assign wn_re[44] = 16'sd31581;assign wn_im[44] = -16'sd8740;
    assign wn_re[45] = 16'sd31527;assign wn_im[45] = -16'sd8933;
    assign wn_re[46] = 16'sd31471;assign wn_im[46] = -16'sd9127;
    assign wn_re[47] = 16'sd31415;assign wn_im[47] = -16'sd9319;
    assign wn_re[48] = 16'sd31357;assign wn_im[48] = -16'sd9512;
    assign wn_re[49] = 16'sd31298;assign wn_im[49] = -16'sd9704;
    assign wn_re[50] = 16'sd31238;assign wn_im[50] = -16'sd9896;
    assign wn_re[51] = 16'sd31177;assign wn_im[51] = -16'sd10088;
    assign wn_re[52] = 16'sd31114;assign wn_im[52] = -16'sd10279;
    assign wn_re[53] = 16'sd31050;assign wn_im[53] = -16'sd10469;
    assign wn_re[54] = 16'sd30986;assign wn_im[54] = -16'sd10660;
    assign wn_re[55] = 16'sd30920;assign wn_im[55] = -16'sd10850;
    assign wn_re[56] = 16'sd30853;assign wn_im[56] = -16'sd11039;
    assign wn_re[57] = 16'sd30784;assign wn_im[57] = -16'sd11228;
    assign wn_re[58] = 16'sd30715;assign wn_im[58] = -16'sd11417;
    assign wn_re[59] = 16'sd30644;assign wn_im[59] = -16'sd11605;
    assign wn_re[60] = 16'sd30572;assign wn_im[60] = -16'sd11793;
    assign wn_re[61] = 16'sd30499;assign wn_im[61] = -16'sd11980;
    assign wn_re[62] = 16'sd30425;assign wn_im[62] = -16'sd12167;
    assign wn_re[63] = 16'sd30350;assign wn_im[63] = -16'sd12354;
    assign wn_re[64] = 16'sd30274;assign wn_im[64] = -16'sd12540;
    assign wn_re[65] = 16'sd30196;assign wn_im[65] = -16'sd12725;
    assign wn_re[66] = 16'sd30118;assign wn_im[66] = -16'sd12910;
    assign wn_re[67] = 16'sd30038;assign wn_im[67] = -16'sd13095;
    assign wn_re[68] = 16'sd29957;assign wn_im[68] = -16'sd13279;
    assign wn_re[69] = 16'sd29875;assign wn_im[69] = -16'sd13463;
    assign wn_re[70] = 16'sd29792;assign wn_im[70] = -16'sd13646;
    assign wn_re[71] = 16'sd29707;assign wn_im[71] = -16'sd13828;
    assign wn_re[72] = 16'sd29622;assign wn_im[72] = -16'sd14010;
    assign wn_re[73] = 16'sd29535;assign wn_im[73] = -16'sd14192;
    assign wn_re[74] = 16'sd29448;assign wn_im[74] = -16'sd14373;
    assign wn_re[75] = 16'sd29359;assign wn_im[75] = -16'sd14553;
    assign wn_re[76] = 16'sd29269;assign wn_im[76] = -16'sd14733;
    assign wn_re[77] = 16'sd29178;assign wn_im[77] = -16'sd14912;
    assign wn_re[78] = 16'sd29086;assign wn_im[78] = -16'sd15091;
    assign wn_re[79] = 16'sd28993;assign wn_im[79] = -16'sd15269;
    assign wn_re[80] = 16'sd28899;assign wn_im[80] = -16'sd15447;
    assign wn_re[81] = 16'sd28803;assign wn_im[81] = -16'sd15624;
    assign wn_re[82] = 16'sd28707;assign wn_im[82] = -16'sd15800;
    assign wn_re[83] = 16'sd28610;assign wn_im[83] = -16'sd15976;
    assign wn_re[84] = 16'sd28511;assign wn_im[84] = -16'sd16151;
    assign wn_re[85] = 16'sd28411;assign wn_im[85] = -16'sd16326;
    assign wn_re[86] = 16'sd28311;assign wn_im[86] = -16'sd16500;
    assign wn_re[87] = 16'sd28209;assign wn_im[87] = -16'sd16673;
    assign wn_re[88] = 16'sd28106;assign wn_im[88] = -16'sd16846;
    assign wn_re[89] = 16'sd28002;assign wn_im[89] = -16'sd17018;
    assign wn_re[90] = 16'sd27897;assign wn_im[90] = -16'sd17190;
    assign wn_re[91] = 16'sd27791;assign wn_im[91] = -16'sd17361;
    assign wn_re[92] = 16'sd27684;assign wn_im[92] = -16'sd17531;
    assign wn_re[93] = 16'sd27576;assign wn_im[93] = -16'sd17700;
    assign wn_re[94] = 16'sd27467;assign wn_im[94] = -16'sd17869;
    assign wn_re[95] = 16'sd27357;assign wn_im[95] = -16'sd18037;
    assign wn_re[96] = 16'sd27246;assign wn_im[96] = -16'sd18205;
    assign wn_re[97] = 16'sd27133;assign wn_im[97] = -16'sd18372;
    assign wn_re[98] = 16'sd27020;assign wn_im[98] = -16'sd18538;
    assign wn_re[99] = 16'sd26906;assign wn_im[99] = -16'sd18703;
    assign wn_re[100] = 16'sd26791;assign wn_im[100] = -16'sd18868;
    assign wn_re[101] = 16'sd26674;assign wn_im[101] = -16'sd19032;
    assign wn_re[102] = 16'sd26557;assign wn_im[102] = -16'sd19195;
    assign wn_re[103] = 16'sd26439;assign wn_im[103] = -16'sd19358;
    assign wn_re[104] = 16'sd26320;assign wn_im[104] = -16'sd19520;
    assign wn_re[105] = 16'sd26199;assign wn_im[105] = -16'sd19681;
    assign wn_re[106] = 16'sd26078;assign wn_im[106] = -16'sd19841;
    assign wn_re[107] = 16'sd25956;assign wn_im[107] = -16'sd20001;
    assign wn_re[108] = 16'sd25833;assign wn_im[108] = -16'sd20160;
    assign wn_re[109] = 16'sd25708;assign wn_im[109] = -16'sd20318;
    assign wn_re[110] = 16'sd25583;assign wn_im[110] = -16'sd20475;
    assign wn_re[111] = 16'sd25457;assign wn_im[111] = -16'sd20632;
    assign wn_re[112] = 16'sd25330;assign wn_im[112] = -16'sd20788;
    assign wn_re[113] = 16'sd25202;assign wn_im[113] = -16'sd20943;
    assign wn_re[114] = 16'sd25073;assign wn_im[114] = -16'sd21097;
    assign wn_re[115] = 16'sd24943;assign wn_im[115] = -16'sd21251;
    assign wn_re[116] = 16'sd24812;assign wn_im[116] = -16'sd21403;
    assign wn_re[117] = 16'sd24680;assign wn_im[117] = -16'sd21555;
    assign wn_re[118] = 16'sd24548;assign wn_im[118] = -16'sd21706;
    assign wn_re[119] = 16'sd24414;assign wn_im[119] = -16'sd21856;
    assign wn_re[120] = 16'sd24279;assign wn_im[120] = -16'sd22006;
    assign wn_re[121] = 16'sd24144;assign wn_im[121] = -16'sd22154;
    assign wn_re[122] = 16'sd24008;assign wn_im[122] = -16'sd22302;
    assign wn_re[123] = 16'sd23870;assign wn_im[123] = -16'sd22449;
    assign wn_re[124] = 16'sd23732;assign wn_im[124] = -16'sd22595;
    assign wn_re[125] = 16'sd23593;assign wn_im[125] = -16'sd22740;
    assign wn_re[126] = 16'sd23453;assign wn_im[126] = -16'sd22884;
    assign wn_re[127] = 16'sd23312;assign wn_im[127] = -16'sd23028;
    end
    else begin
        //default case
    end
    endgenerate

endmodule