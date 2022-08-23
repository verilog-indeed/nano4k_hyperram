module gw_gao(
    readDataValid,
    \readReg[31] ,
    \readReg[30] ,
    \readReg[29] ,
    \readReg[28] ,
    \readReg[27] ,
    \readReg[26] ,
    \readReg[25] ,
    \readReg[24] ,
    \readReg[23] ,
    \readReg[22] ,
    \readReg[21] ,
    \readReg[20] ,
    \readReg[19] ,
    \readReg[18] ,
    \readReg[17] ,
    \readReg[16] ,
    \readReg[15] ,
    \readReg[14] ,
    \readReg[13] ,
    \readReg[12] ,
    \readReg[11] ,
    \readReg[10] ,
    \readReg[9] ,
    \readReg[8] ,
    \readReg[7] ,
    \readReg[6] ,
    \readReg[5] ,
    \readReg[4] ,
    \readReg[3] ,
    \readReg[2] ,
    \readReg[1] ,
    \readReg[0] ,
    \testStateCounter[6] ,
    \testStateCounter[5] ,
    \testStateCounter[4] ,
    \testStateCounter[3] ,
    \testStateCounter[2] ,
    \testStateCounter[1] ,
    \testStateCounter[0] ,
    memoryClock,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input readDataValid;
input \readReg[31] ;
input \readReg[30] ;
input \readReg[29] ;
input \readReg[28] ;
input \readReg[27] ;
input \readReg[26] ;
input \readReg[25] ;
input \readReg[24] ;
input \readReg[23] ;
input \readReg[22] ;
input \readReg[21] ;
input \readReg[20] ;
input \readReg[19] ;
input \readReg[18] ;
input \readReg[17] ;
input \readReg[16] ;
input \readReg[15] ;
input \readReg[14] ;
input \readReg[13] ;
input \readReg[12] ;
input \readReg[11] ;
input \readReg[10] ;
input \readReg[9] ;
input \readReg[8] ;
input \readReg[7] ;
input \readReg[6] ;
input \readReg[5] ;
input \readReg[4] ;
input \readReg[3] ;
input \readReg[2] ;
input \readReg[1] ;
input \readReg[0] ;
input \testStateCounter[6] ;
input \testStateCounter[5] ;
input \testStateCounter[4] ;
input \testStateCounter[3] ;
input \testStateCounter[2] ;
input \testStateCounter[1] ;
input \testStateCounter[0] ;
input memoryClock;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire readDataValid;
wire \readReg[31] ;
wire \readReg[30] ;
wire \readReg[29] ;
wire \readReg[28] ;
wire \readReg[27] ;
wire \readReg[26] ;
wire \readReg[25] ;
wire \readReg[24] ;
wire \readReg[23] ;
wire \readReg[22] ;
wire \readReg[21] ;
wire \readReg[20] ;
wire \readReg[19] ;
wire \readReg[18] ;
wire \readReg[17] ;
wire \readReg[16] ;
wire \readReg[15] ;
wire \readReg[14] ;
wire \readReg[13] ;
wire \readReg[12] ;
wire \readReg[11] ;
wire \readReg[10] ;
wire \readReg[9] ;
wire \readReg[8] ;
wire \readReg[7] ;
wire \readReg[6] ;
wire \readReg[5] ;
wire \readReg[4] ;
wire \readReg[3] ;
wire \readReg[2] ;
wire \readReg[1] ;
wire \readReg[0] ;
wire \testStateCounter[6] ;
wire \testStateCounter[5] ;
wire \testStateCounter[4] ;
wire \testStateCounter[3] ;
wire \testStateCounter[2] ;
wire \testStateCounter[1] ;
wire \testStateCounter[0] ;
wire memoryClock;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i({\testStateCounter[6] ,\testStateCounter[5] ,\testStateCounter[4] ,\testStateCounter[3] ,\testStateCounter[2] ,\testStateCounter[1] ,\testStateCounter[0] }),
    .data_i({readDataValid,\readReg[31] ,\readReg[30] ,\readReg[29] ,\readReg[28] ,\readReg[27] ,\readReg[26] ,\readReg[25] ,\readReg[24] ,\readReg[23] ,\readReg[22] ,\readReg[21] ,\readReg[20] ,\readReg[19] ,\readReg[18] ,\readReg[17] ,\readReg[16] ,\readReg[15] ,\readReg[14] ,\readReg[13] ,\readReg[12] ,\readReg[11] ,\readReg[10] ,\readReg[9] ,\readReg[8] ,\readReg[7] ,\readReg[6] ,\readReg[5] ,\readReg[4] ,\readReg[3] ,\readReg[2] ,\readReg[1] ,\readReg[0] }),
    .clk_i(memoryClock)
);

endmodule
