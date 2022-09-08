
//The list will be updated sequentially following the implementation of training FW and ATE FW 
`ifdef DWC_DDRPHY_GATESIM_SDF
initial begin
    force test.top.dut.u_DWC_DDRPHYMASTER_top.zSync6_DLY500PS_PllLock.loop_0__sync6_async.viol_0 = 1'b0;
    force test.top.dut.u_DWC_DDRPHYMASTER_top.zSync6_DLY156PS_PtrInit_sync.loop_0__sync6_async.viol_0 = 1'b0;
    force test.top.dut.u_DWC_DDRPHYMASTER_top.zSync6_DLY3000PS_csrPORMemReset.loop_0__sync6_async.viol_0 = 1'b0; 
    force test.top.dut.u_DWC_DDRPHYMASTER_top.zSync6_DLY500PS_ZCalCompOut_cdc.loop_0__sync6_async.viol_0 = 1'b0;
    `ifdef DWC_DDRPHY_EXISTS_AC0
      force test.top.dut.u_AC_WRAPPER_0.DIFF_CK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.DIFF_CK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.DIFF_CK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SEC_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SEC_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_NUM_RANKS_2
      force test.top.dut.u_AC_WRAPPER_0.SEC_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SEC_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `endif
      force test.top.dut.u_AC_WRAPPER_0.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_NUM_RANKS_2
      force test.top.dut.u_AC_WRAPPER_0.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_0.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_AC1
      force test.top.dut.u_AC_WRAPPER_1.DIFF_CK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.DIFF_CK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.DIFF_CK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SEC_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SEC_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_NUM_RANKS_2
      force test.top.dut.u_AC_WRAPPER_1.SEC_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SEC_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `endif
      force test.top.dut.u_AC_WRAPPER_1.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_NUM_RANKS_2
      force test.top.dut.u_AC_WRAPPER_1.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_AC_WRAPPER_1.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB0
      force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_0.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;  
      `endif 
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB1
      force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_1.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB2
      force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_2.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB3
      force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_3.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB4
      force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_4.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB5
      force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_5.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB6
      force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_6.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
    `endif
    `ifdef DWC_DDRPHY_EXISTS_DB7
      force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 = 1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 = 1'b0;
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.zSync6_DLY500PS_repl_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_0.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_0.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_1.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_1.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_2.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_2.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_3.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_3.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_4.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_4.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_5.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_5.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_6.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_6.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_7.zSync6_DLY500PS_cal_clk_en_sync.loop_0__sync6.viol_0 =1'b0;
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_7.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
      force test.top.dut.u_DBYTE_WRAPPER_7.SE_8.RingOsc_lcdl.zSync6_DLY500PS_RO_run_sync.loop_0__sync6.viol_0 =1'b0;
      `endif
    `endif
	//Mantis55671 with confirmation from ATE FW team
	`ifdef ATE_ac_loopback
	    `ifdef DWC_DDRPHY_EXISTS_AC0
		   force test.top.dut.u_AC_WRAPPER_0.SEC_0.RxDataPD_RxStrb_reg.viol_0 = 1'b0;
		   force test.top.dut.u_AC_WRAPPER_0.DIFF_CK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
		   force test.top.dut.u_AC_WRAPPER_0.DIFF_CK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
		  `ifdef DWC_DDRPHY_NUM_RANKS_2
		   force test.top.dut.u_AC_WRAPPER_0.SEC_1.RxDataPD_RxStrb_reg.viol_0 = 1'b0;
		  `endif
		`endif
	    `ifdef DWC_DDRPHY_EXISTS_AC1
		   force test.top.dut.u_AC_WRAPPER_1.SEC_0.RxDataPD_RxStrb_reg.viol_0 = 1'b0;
		   force test.top.dut.u_AC_WRAPPER_1.DIFF_CK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
		   force test.top.dut.u_AC_WRAPPER_1.DIFF_CK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
		  `ifdef DWC_DDRPHY_NUM_RANKS_2
		   force test.top.dut.u_AC_WRAPPER_1.SEC_1.RxDataPD_RxStrb_reg.viol_0 = 1'b0;
		  `endif		
		`endif
	`endif
	//Mantis55671 with confirmation from ATE FW team
    `ifdef ATE_data_1d_loopback
      `ifdef DWC_DDRPHY_EXISTS_DB0
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
      `ifdef DWC_DDRPHY_EXISTS_DB1
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
      `ifdef DWC_DDRPHY_EXISTS_DB2
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
      `ifdef DWC_DDRPHY_EXISTS_DB3
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
      `ifdef DWC_DDRPHY_EXISTS_DB4
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
      `ifdef DWC_DDRPHY_EXISTS_DB5
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
      `ifdef DWC_DDRPHY_EXISTS_DB6
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
      `ifdef DWC_DDRPHY_EXISTS_DB7
      `ifdef DWC_DDRPHY_LPDDR5_ENABLED
	    force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
      `endif
	    force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.RxCoreSampRxEn_c_reg.viol_0 = 1'b0;
	    force test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.RxCoreSampRxEn_t_reg.viol_0 = 1'b0;
	  `endif
	`endif
end

`ifdef BYPASS_CONTROL_INT_TEST
initial fork
`ifdef DWC_DDRPHY_EXISTS_AC0
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_0.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_0.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_0.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_1.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_1.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_1.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_2.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_2.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_2.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_3.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_3.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_3.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_4.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_4.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_4.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_5.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_5.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_5.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_6.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_6.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_6.CMDFIFO.I_RdDat1_X.viol_0;
  end
  `ifdef DWC_DDRPHY_NUM_RANKS_2
  begin
    force test.top.dut.u_AC_WRAPPER_0.SE_7.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_0.SE_7.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_0.SE_7.CMDFIFO.I_RdDat1_X.viol_0;
  end
  `endif
`endif
`ifdef DWC_DDRPHY_EXISTS_AC1
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_0.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_0.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_0.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_1.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_1.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_1.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_2.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_2.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_2.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_3.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_3.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_3.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_4.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_4.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_4.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_5.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_5.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_5.CMDFIFO.I_RdDat1_X.viol_0;
  end
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_6.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_6.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_6.CMDFIFO.I_RdDat1_X.viol_0;
  end
  `ifdef DWC_DDRPHY_NUM_RANKS_2
  begin
    force test.top.dut.u_AC_WRAPPER_1.SE_7.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
    wait(test.top.dut.u_AC_WRAPPER_1.SE_7.CMDFIFO.RdPtrInit_X === 1'b0); 
    release test.top.dut.u_AC_WRAPPER_1.SE_7.CMDFIFO.I_RdDat1_X.viol_0;
  end
  `endif
`endif
join

initial fork
  `ifdef DWC_DDRPHY_EXISTS_AC0
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[0] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[0]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_0.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_0.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_0.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_0.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[1] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[1]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_1.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_1.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_1.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_1.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[2] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[2]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_2.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_2.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_2.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_2.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[3] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[3]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_3.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_3.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_3.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_3.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[4] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[4]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_4.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_4.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_4.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_4.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[5] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[5]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_5.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_5.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_5.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_5.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[6] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[6]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_6.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_6.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_6.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_6.CMDFIFO.I_RdDat1_X.viol_0;
    end
    `ifdef DWC_DDRPHY_NUM_RANKS_2
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[7] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrAcLnDisable[7]);
      @(posedge test.top.dut.u_AC_WRAPPER_0.SE_7.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_0.SE_7.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_0.SE_7.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_0.SE_7.CMDFIFO.I_RdDat1_X.viol_0;
    end
    `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_AC1
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[0] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[0]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_0.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_0.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_0.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_0.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[1] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[1]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_1.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_1.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_1.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_1.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[2] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[2]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_2.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_2.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_2.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_2.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[3] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[3]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_3.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_3.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_3.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_3.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[4] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[4]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_4.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_4.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_4.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_4.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[5] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[5]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_5.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_5.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_5.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_5.CMDFIFO.I_RdDat1_X.viol_0;
    end
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[6] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[6]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_6.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_6.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_6.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_6.CMDFIFO.I_RdDat1_X.viol_0;
    end
    `ifdef DWC_DDRPHY_NUM_RANKS_2
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[7] !== 1'bx);
      @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_1.csrAcLnDisable[7]);
      @(posedge test.top.dut.u_AC_WRAPPER_1.SE_7.CMDFIFO.RdPtrInit_X);
      force test.top.dut.u_AC_WRAPPER_1.SE_7.CMDFIFO.I_RdDat1_X.viol_0 = 1'bx;
      repeat(2) @(posedge test.top.dut.u_AC_WRAPPER_1.SE_7.CMDFIFO.I_RdDat1_X.CK);
      release test.top.dut.u_AC_WRAPPER_1.SE_7.CMDFIFO.I_RdDat1_X.viol_0;
    end
    `endif 
  `endif
join
`endif
`endif
