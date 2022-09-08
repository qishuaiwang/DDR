`include "test_head.sv"
`include "ate_cfg.sv"

module test;

`include "common_test_inc.sv"
`include "set_dfi_input_dut_0.sv"


// For callbacks
`ifdef USER_TEST

`ifndef PRE_PWRON
task pre_pwron(); endtask
`endif
`ifndef POST_PWRON
task post_pwron(); endtask
`endif
`ifndef PRE_ATE_CFG
task pre_ate_cfg(); endtask
`endif
`ifndef POST_ATE_CFG
task post_ate_cfg(); endtask
`endif

`endif

// control which sections are executedn in ATE MASIS test.
// TestsToRun[0]     = DMEM / IMEM revision check
// TestsToRun[1]     = Impedance Calibration
// TestsToRun[2]     = PLL Lock
// TestsToRun[3]     = LCDL Linearity
// TestsToRun[4]     = Address / Command Loopback
// TestsToRun[5]     = Data Loopback 1D
// TestsToRun[6]     = Data Loopback 2D
// TestsToRun[7]     = Burn-In
// TestsToRun[8]     = RxReplica Calibration
// TestsToRun[9]     = DCA Loopback
// TestsToRun[15:10] = Reserved (must be written to 0)
reg [15:0] TestsToRun;

// Bit value of 0 = fail / 1 = pass
// PassFailResults[0]     = DMEM / IMEM revision check
// PassFailResults[1]     = Impedance Calibration
// PassFailResults[2]     = PLL Lock
// PassFailResults[3]     = LCDL Linearity
// PassFailResults[4]     = Address / Command Loopback
// PassFailResults[5]     = Data Loopback 1D
// PassFailResults[6]     = Data Loopback 2D 
// PassFailResults[7]     = Burn-In
// PassFailResults[8]     = RxReplica Calibration
// PassFailResults[9]     = DCA Loopback
// PassFailResults[15:10] = Reserved (will be 0)
reg [15:0] PassFailResults;

reg [15:0] data;
int SRAM_instance;
int fimem;
int fdmem;
reg [31:0] SRAM_addr;
reg [31:0] data_word;
reg [31:0] my_apb_addr;


task tech_spec_pll_set;
  apb_wr(32'h02004a, 'b000_1000_0000_0100); //DWC_DDRPHYA_MASTER0_p0__PllCtrl1_p0
  apb_wr(32'h12004a, 'b000_1000_0000_0100); //DWC_DDRPHYA_MASTER0_p1__PllCtrl1_p1
  apb_wr(32'h02004b, 'b010_0100_0011_1100);//DWC_DDRPHYA_MASTER0_p0__PllCtrl4_p0
  apb_wr(32'h12004b, 'b010_0100_0011_1100);//DWC_DDRPHYA_MASTER0_p1__PllCtrl4_p1
  apb_wr(`DWC_DDRPHYA_MASTER0_p0_PllUPllProg0, 16'h2531);
  apb_wr(`DWC_DDRPHYA_MASTER0_p0_PllUPllProg1, 16'h1800);
  apb_wr(`DWC_DDRPHYA_MASTER0_p0_PllUPllProg2, 16'h3);
  apb_wr(`DWC_DDRPHYA_MASTER0_p0_PllUPllProg3, 16'h0);
endtask


// technology specific settings, example for default settings, please refer to PHY databook to customize optimal settings according to technology
`ifdef CUSTOMER_ATE_CSR_CFG
  task ate_cust_csr_setting;
    `include "tmp_ate_csr_cust_setting.sv"
    $display(" Load ATE CSR customer setting done ");//only to display in simv.log
  endtask
`endif

task run_fw_ate;
reg [15:0] UctShadowRegs;
begin
  repeat(10) @(posedge top.dfi_clk);
  apb_wr (`DWC_DDRPHYA_DRTUB0_UctWriteProt,      16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0009);    //Reset MicroController [csrMicroReset ; Reset = 1; Stall = 1}
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0001);    //De-assert MicroController [csrMicroReset ; Reset = 0 Stall = 1}
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0000);    //Start MicroController [csrMicroReset : Reset = 0 ; Stall = 0}

  `ifdef ATE_dsply
    $display("-----------------------------------------------");
    $display("##### MASIS Section 5 ends #####");  
    $display("-----------------------------------------------");
  `endif

  `ifdef ATE_burn_in 
    while (test.top.dut.u_DWC_ddrphy_pub.MRTUB.csrSequenceReg0b0s0[15:0] != 16'hb011) begin
      repeat(10000) @(posedge top.apb_clk);
      $display( "[%0t] <%m> INFO: csrSequenceReg0b0s0 = %h",$time,test.top.dut.u_DWC_ddrphy_pub.MRTUB.csrSequenceReg0b0s0[15:0]);
    end 
    #(`BURN_IN_TIME);     
    repeat(1000) @(posedge top.dfi_clk);
    apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0000);
    repeat ( ( (cfg.Frequency[0]/2*cfg.DfiFreqRatio[0]) * 1000000 ) / (2*100) ) @(posedge top.dfi_clk);
    repeat(700000) @(posedge top.dfi_clk);
    apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0001);
  `endif

  UctShadowRegs[0] = 1;
  while (UctShadowRegs[0]) begin
    $display("[%0t] <%m> INFO: polling DWC_DDRPHYA_APBONLY0_UctShadowRegs, bit 0...",$time);
    repeat(1000) @(posedge top.apb_clk);
    apb_rd(`DWC_DDRPHYA_APBONLY0_UctShadowRegs,  UctShadowRegs);
  end 


  apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0000);
  apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h0000);
end
endtask

//******************************************************
// Check simulation result
//******************************************************
task check_results; begin
  apb_rd(32'h58001, PassFailResults);

  $display("************************************************");
  `ifdef ATE_dsply
    $display("##### MASIS Section 6 begins #####");
  `endif
  $display("[%0t] Test INFO: TestsToRun = 0x%0h for current ATE test" ,$time, TestsToRun ); 
  $display("[%0t]     TestsToRun[0] = DMEM / IMEM revision check" ,$time); 
  $display("[%0t]     TestsToRun[1] = Impedance Calibration" ,$time);
  $display("[%0t]     TestsToRun[2] = PLL Lock" ,$time);
  $display("[%0t]     TestsToRun[3] = LCDL Linearity" ,$time);
  $display("[%0t]     TestsToRun[4] = Address / Command Loopback" ,$time);
  $display("[%0t]     TestsToRun[5] = Data Loopback 1D" ,$time);
  $display("[%0t]     TestsToRun[6] = Data Loopback 2D" ,$time);
  $display("[%0t]     TestsToRun[7] = Burn-In" ,$time);
  $display("[%0t]     TestsToRun[8] = RxReplica Calibration" ,$time);
  $display("[%0t]     TestsToRun[9] = DCA Loopback" ,$time);
  $display("[%0t]     TestsToRun[15:10] = Reserved (must be set to 0x0)" ,$time);
  $display("[%0t]     Test INFO:Begin ATE test result " ,$time);
  $display("[%0t]     PassFailResults = 0x%0h, which Bit value of 0 = fail / 1 = pass" ,$time, PassFailResults ); 
  $display("[%0t]     PassFailResults[0] = DMEM / IMEM revision check" ,$time); 
  $display("[%0t]     PassFailResults[1] = Impedance Calibration" ,$time);
  $display("[%0t]     PassFailResults[2] = PLL Lock" ,$time);
  $display("[%0t]     PassFailResults[3] = LCDL Linearity" ,$time);
  $display("[%0t]     PassFailResults[4] = Address / Command Loopback" ,$time);
  $display("[%0t]     PassFailResults[5] = Data Loopback 1D" ,$time);
  $display("[%0t]     PassFailResults[6] = Data Loopback 2D" ,$time);
  $display("[%0t]     PassFailResults[7] = Burn-In" ,$time);
  $display("[%0t]     PassFailResults[8] = RxReplica Calibration" ,$time);
  $display("[%0t]     PassFailResults[9] = DCA Loopback" ,$time);
  $display("[%0t]     PassFailResults[15:10] = Reserved (must be set to 0x0)" ,$time);
  $display("************************************************");

  if(TestsToRun[0]) begin
    if (PassFailResults[0])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Revision Check test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display ("[%0t] INFO: Revision Check test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end
  
  if (TestsToRun[1]) begin
    if (PassFailResults[1])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Impedance Calibration test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display ("[%0t] INFO: Impedance Calibration test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[2]) begin
    if (PassFailResults[2])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: PLL Lock test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display ("[%0t] INFO: PLL Lock test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[3]) begin
    if (PassFailResults[3])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: LCDL Linearity test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display ("[%0t] INFO: LCDL Linearity test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[4]) begin
    if (PassFailResults[4])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Address Command Loopback test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display ("[%0t] INFO: Address Command Loopback test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[5]) begin
    if (PassFailResults[5])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Data 1D Loopback test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Data 1D Loopback test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[6]) begin
    if (PassFailResults[6])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Data 2D Loopback test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display ("[%0t] INFO: Data 2D Loopback test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[7]) begin
    if (PassFailResults[7])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Burn-In test passed" ,$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: Burn-In test failed" ,$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[8]) begin
    if (PassFailResults[8])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: RxReplica test passed", $time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: RxReplica test failed",$time );
        $display("-----------------------------------------------");
        error;
      end
  end

  if (TestsToRun[9]) begin
    if (PassFailResults[9])
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: DCA test passed",$time);
        $display("-----------------------------------------------");
      end
    else
      begin
        $display("-----------------------------------------------");
        $display("[%0t] INFO: DCA test failed",$time);
        $display("-----------------------------------------------");
        error;
      end
  end

  `ifdef ATE_dsply
    $display("-----------------------------------------------");
    $display("[%0t] MASIS: End ATE MASIS result " ,$time);
    $display("##### MASIS Section 6 ends #####");  
    $display("-----------------------------------------------");
  `endif

end
endtask

task run_fw_ate_masis_short;
reg [15:0] UctShadowRegs;
begin
  repeat(10) @(posedge top.dfi_clk);
  apb_wr (`DWC_DDRPHYA_DRTUB0_UctWriteProt,      16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0009);    //Reset MicroController [csrMicroReset ; Reset = 1; Stall = 1}
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0001);    //De-assert MicroController [csrMicroReset ; Reset = 0 Stall = 1}
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0000);    //Start MicroController [csrMicroReset : Reset = 0 ; Stall = 0}
 
  UctShadowRegs[0] = 1;
  while (UctShadowRegs[0]) begin
    $display("[%0t] <%m> INFO: polling DWC_DDRPHYA_APBONLY0_UctShadowRegs, bit 0...",$time);
    repeat(1000) @(posedge top.apb_clk);
    apb_rd(`DWC_DDRPHYA_APBONLY0_UctShadowRegs,  UctShadowRegs);
  end

  apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0000);
  apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt,    16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroReset,      16'h0001);
  apb_wr (`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h0000);
end
endtask

task config_common_mb;
begin 
apb_wr(32'h58002,   ate_cfg.TestOptions          );    
apb_wr(32'h58003,   ate_cfg.RESERVED_0           );    
apb_wr(32'h58008,   {ate_cfg.PhyCfgNumChan,ate_cfg.UseMsgBlkPhyCfg   }      );
apb_wr(32'h58009,   {ate_cfg.PhyCfgDmiEn  ,ate_cfg.PhyCfgNumDbPerChan}      );   
apb_wr(32'h5800a,   {ate_cfg.PhyCfgLp5En  ,ate_cfg.PhyCfgNumRank     }      );
apb_wr(32'h5800b,   ate_cfg.ZCalRZN              );
apb_wr(32'h5800c,   ate_cfg.DfiClkFreq           );
apb_wr(32'h5800d,   {ate_cfg.ClockingMode ,ate_cfg.DfiClkFreqRatio   }      );
apb_wr(32'h5800e,   ate_cfg.DacRefModeCtl        );
apb_wr(32'h5800f,   ate_cfg.ZCalCompVref         );
apb_wr(32'h58010,   ate_cfg.AcVrefDac            );
apb_wr(32'h58011,   ate_cfg.DbVrefDac            );
apb_wr(32'h58012,   ate_cfg.DbRxVrefCtl          );
apb_wr(32'h58013,   ate_cfg.DbRxDfeModeCfg       );
apb_wr(32'h58014,   ate_cfg.RESERVED_1           );
apb_wr(32'h58015,   ate_cfg.AcTxImpedanceSe      );
apb_wr(32'h58016,   ate_cfg.AcTxImpedanceDiff    );
apb_wr(32'h58017,   ate_cfg.AcTxImpedanceSec     );
apb_wr(32'h58018,   ate_cfg.DbTxImpedanceSe      );
apb_wr(32'h58019,   ate_cfg.DbTxImpedanceDiff    );
apb_wr(32'h5801a,   ate_cfg.AcTxSlewSe           );
apb_wr(32'h5801b,   ate_cfg.AcTxSlewDiff         );
apb_wr(32'h5801c,   ate_cfg.DbTxSlewSe           );
apb_wr(32'h5801d,   ate_cfg.DbTxSlewDiff         );
apb_wr(32'h5801e,   ate_cfg.PubRev               );
apb_wr(32'h5801f,   ate_cfg.RESERVED_2[0 ]       ); 
apb_wr(32'h58020,   ate_cfg.RESERVED_2[1 ]       );
apb_wr(32'h58021,   ate_cfg.RESERVED_2[2 ]       );
apb_wr(32'h58022,   ate_cfg.RESERVED_2[3 ]       );
apb_wr(32'h58023,   ate_cfg.RESERVED_2[4 ]       );
apb_wr(32'h58024,   ate_cfg.RESERVED_2[5 ]       );
apb_wr(32'h58025,   ate_cfg.RESERVED_2[6 ]       );
apb_wr(32'h58026,   ate_cfg.RESERVED_2[7 ]       );
apb_wr(32'h58027,   ate_cfg.RESERVED_2[8 ]       );
apb_wr(32'h58028,   ate_cfg.RESERVED_2[9 ]       );
apb_wr(32'h58029,   ate_cfg.RESERVED_2[10]       );
apb_wr(32'h5802A,   ate_cfg.RESERVED_2[11]       );
apb_wr(32'h5802B,   ate_cfg.RESERVED_2[12]       );
apb_wr(32'h5802C,   ate_cfg.RESERVED_2[13]       );
apb_wr(32'h5802D,   ate_cfg.RESERVED_2[14]       );
apb_wr(32'h5802E,   ate_cfg.RESERVED_2[15]       );
apb_wr(32'h5802F,   ate_cfg.RESERVED_2[16]       );
apb_wr(32'h5802F,   ate_cfg.RESERVED_2[17]       );



apb_wr(32'h58030,   {ate_cfg.CalInterval  ,ate_cfg.ContinuousCal}         );
apb_wr(32'h58031,   ate_cfg.RESERVED_3[0]           );
apb_wr(32'h58032,   ate_cfg.RESERVED_3[1]           );

apb_wr(32'h58033,   ate_cfg.MemClkToggle         );
apb_wr(32'h58034,   ate_cfg.MemClkTime           ); 
apb_wr(32'h58035,   ate_cfg.RESERVED_4[0]        );
apb_wr(32'h58036,   ate_cfg.RESERVED_4[1]        );
apb_wr(32'h58037,   ate_cfg.RESERVED_4[2]        );
apb_wr(32'h58038,   ate_cfg.RESERVED_4[3]        );
apb_wr(32'h58039,   ate_cfg.RESERVED_4[4]        );
apb_wr(32'h5803A,   ate_cfg.RESERVED_4[5]        );
apb_wr(32'h5803B,   ate_cfg.RESERVED_4[6]        );
apb_wr(32'h5803C,   ate_cfg.RESERVED_4[7]        );

    
apb_wr(32'h5803d,   ate_cfg.LcdlClksToRun        );
apb_wr(32'h5803e,   ate_cfg.LcdlStartPhase       );
apb_wr(32'h5803f,   ate_cfg.LcdlEndPhase         );
apb_wr(32'h58040,   {ate_cfg.LcdlPassPercent,ate_cfg.LcdlStride}          );
apb_wr(32'h58041,   ate_cfg.LcdlObserveCfg[0]    );
apb_wr(32'h58042,   ate_cfg.LcdlObserveCfg[1]    );
apb_wr(32'h58043,   ate_cfg.LcdlObserveCfg[2]    );
apb_wr(32'h58044,   ate_cfg.LcdlObserveCfg[3]    );

apb_wr(32'h58045,   ate_cfg.RESERVED_5[0]        );
apb_wr(32'h58046,   ate_cfg.RESERVED_5[1]        );
apb_wr(32'h58047,   ate_cfg.RESERVED_5[2]        );
apb_wr(32'h58048,   ate_cfg.RESERVED_5[3]        );


apb_wr(32'h58049,   ate_cfg.AcLoopLaneMask[0]       );
apb_wr(32'h5804a,   ate_cfg.AcLoopLaneMask[1]       );

apb_wr(32'h5804b,   ate_cfg.AcLoopClksToRun      );
apb_wr(32'h5804c,   {ate_cfg.AcLoopCoreLoopBk,ate_cfg.AcLoopMinLoopPwr}   );
apb_wr(32'h5804d,   {ate_cfg.AcLoopIncrement ,ate_cfg.RESERVED_6}         );
apb_wr(32'h5804e,   {ate_cfg.AcMinEyeWidthDiff,ate_cfg.AcMinEyeWidthSe}   ); 
apb_wr(32'h5804f,   {ate_cfg.AcLoopDiffBitmapSel,ate_cfg.AcLoopDiffTestMode} );
apb_wr(32'h58050,   ate_cfg.AcMinEyeWidthSec        );
apb_wr(32'h58051,   ate_cfg.RESERVED_7              );
apb_wr(32'h58052,   ate_cfg.DatLoopClksToRun     );
apb_wr(32'h58053,   ate_cfg.DatLoopCoreLoopBk    );
apb_wr(32'h58054,   {ate_cfg.RESERVED_8,ate_cfg.DatLoopMinLoopPwr}  );
apb_wr(32'h58055,   ate_cfg.RESERVED_9           );
apb_wr(32'h58056,   ate_cfg.TxDqsDly             );
apb_wr(32'h58057,   ate_cfg.TxWckDly             );
apb_wr(32'h58058,   ate_cfg.RxEnDly              );
apb_wr(32'h58059,   ate_cfg.RxDigStrbDly         );
apb_wr(32'h5805a,   ate_cfg.RxClkT2UIDly         );
apb_wr(32'h5805b,   ate_cfg.RxClkC2UIDly         );
apb_wr(32'h5805c,   {ate_cfg.DatLoopDiffBitmapSel,ate_cfg.DatLoopDiffTestMode}                  );
apb_wr(32'h5805d,   {ate_cfg.DatLoopCoarseEnd        ,         ate_cfg.DatLoopCoarseStart   }   );
apb_wr(32'h5805e,   {ate_cfg.DatLoopMinEyeWidth      ,         ate_cfg.DatLoopFineIncr      }   );
apb_wr(32'h5805f,   {ate_cfg.DatLoopBit              ,         ate_cfg.DatLoopByte          }   );
apb_wr(32'h58060,   {ate_cfg.DatLoop2dVrefEnd        ,         ate_cfg.DatLoop2dVrefStart   }   );
apb_wr(32'h58061,   {ate_cfg.RESERVED_10             ,         ate_cfg.DatLoop2dVrefIncr    }   );
apb_wr(32'h58062,   ate_cfg.RESERVED_11[0]          );
apb_wr(32'h58063,   ate_cfg.RESERVED_11[1]          );
apb_wr(32'h58064,   ate_cfg.RESERVED_11[2]          );
apb_wr(32'h58065,   ate_cfg.RESERVED_11[3]          );
apb_wr(32'h58066,   ate_cfg.RESERVED_11[4]          );
apb_wr(32'h58067,   {ate_cfg.DcaLoopDelayIncr,ate_cfg.DcaLoopMinLoopPwr}          );
apb_wr(32'h58068,   {ate_cfg.DcaLoopDcaFineIncr,ate_cfg.DcaLoopDcaCoarseSkip}          );
apb_wr(32'h58069,   {ate_cfg.RESERVED_12[0],ate_cfg.DcaLoopBitmapSel}          );

end
endtask


task run_MASIS_10ATE_tests;
begin
  $display("-----------------------------------------------");
  $display( "##### MASIS Section 5 begins #####");
  $display("[%0t] MASIS INFO: TestsToRun = 0x%0h for current MASIS ATE test" ,$time, cfg.TestsToRun ); 
  $display("[%0t]   TestsToRun[0] = DMEM / IMEM revision check" ,$time); 
  $display("[%0t]   TestsToRun[1] = Impedance Calibration" ,$time);
  $display("[%0t]   TestsToRun[2] = PLL Lock" ,$time);
  $display("[%0t]   TestsToRun[3] = LCDL Linearity" ,$time);
  $display("[%0t]   TestsToRun[4] = Address / Command Loopback" ,$time);
  $display("[%0t]   TestsToRun[5] = Data Loopback 1D" ,$time);
  $display("[%0t]   TestsToRun[6] = Data Loopback 2D" ,$time);
  $display("[%0t]   TestsToRun[7] = Burn-In" ,$time);
  $display("[%0t]   TestsToRun[8] = RxReplica Calibration" ,$time);
  $display("[%0t]   TestsToRun[9] = DCA Loopback" ,$time);
  $display("[%0t]   TestsToRun[15:10] = Reserved (must be set to 0x0)" ,$time);
  $display("[%0t] MASIS INFO: Running ATE tests sequence for MASIS ATE patterns..." ,$time); 
  $display("-----------------------------------------------");

  //LP5: 16'h33f; LP4: 16'h13f
  TestsToRun = cfg.TestsToRun;
  apb_wr(32'h58000, TestsToRun);

  
end
endtask //run_MASIS_10ATE_tests

`ifdef DMEM_READ
task dmem_read;
begin
  `ifdef ATE_dsply
    $display("-----------------------------------------------");
    $display("##### MASIS Section 7  begins #####");  
    $display("MASIS DMEM dumping special");
    $display("[%0t] New MASIS pattern suite for debug",$time);
    $display("[%0t] Only does DMEM READS",$time);
    $display("[%0t] No Checking of READ values\n", $time);
    $display("##### MASIS DMEM dumping special #####");
    $display("-----------------------------------------------");
  `endif
for(int i=`DMEM_START_ADDRESS;i<=`DMEM_END_ADDRESS;i=i+1) 
    apb_rd(i, data);
  `ifdef ATE_dsply
    $display("-----------------------------------------------");
    $display("[%0t] END of Special DMEM dump\n", $time);
    $display("-----------------------------------------------");
    $display("##### MASIS Section 7  ends #####"); 
    $display("-----------------------------------------------");
  `endif
end
endtask
`endif

task imem_dump;
  begin
  SRAM_instance = 0;
  SRAM_addr = 0;
  my_apb_addr = 32'h50000;
  
  while (my_apb_addr < 32'h58000) begin
    apb_rd(my_apb_addr, data_word[15:0]);
    apb_rd(my_apb_addr+1, data_word[31:16]); 
    $fwrite(fimem, "CVVS IMEM: SRAM Inst = %d SRAM Addr = %h  Data[31:0]= %h\n",SRAM_instance, SRAM_addr, data_word); 
    my_apb_addr = my_apb_addr + 2;
    SRAM_addr = SRAM_addr + 1;
    if (SRAM_addr >= 32'h00800) begin
        SRAM_instance = SRAM_instance + 1;
	      SRAM_addr = 0;
    end
  end 
  end  
endtask

task dmem_dump; 
  SRAM_instance = 0;
  SRAM_addr = 0;
  my_apb_addr = 32'h58000;
  while (my_apb_addr < 32'h60000) begin
    apb_rd(my_apb_addr, data_word[15:0]);
    apb_rd(my_apb_addr+1, data_word[31:16]);
    $fwrite(fdmem, "CVVS DMEM: SRAM Inst = %d SRAM Addr = %h  Data[31:0]= %h\n",SRAM_instance, SRAM_addr, data_word); 

    my_apb_addr = my_apb_addr + 2;
    SRAM_addr = SRAM_addr + 1;
    if (SRAM_addr >= 32'h00800) begin
        SRAM_instance = SRAM_instance + 1;
	      SRAM_addr = 0;
    end
  end
endtask

reg [15:0] a[0:7];

initial begin
  
//-----------------------------------------------
// Test execution : uncomment subtest task to run
//-----------------------------------------------
  `ifdef USER_TEST
  pre_pwron(); 
  `endif
  if(!cfg.disable_pwron) begin
    top.clk_rst_drv.power_up();
    top.clk_rst_drv.start_clkRst();
  end
  `ifdef USER_TEST
  post_pwron(); 
  `endif

//**************************Instruction****************************
  `ifdef ATE_dsply
  repeat(10) @(posedge top.apb_clk);
    $display("-----------------------------------------------");
    $display("##### MASIS Instruction begins #####");
    $display( " INFO: This is a instruction about how you should do or can do for each section of MASIS");
    $display( " 1.For users seek for examples to check ICCM/DCCM data integrity, please refer to section 1 , where an example of 4 pairs of read-after-read is shown. ");
    $display( " 2.For users seek for examples to load ICCM/DCCM, please refer to section 2. , where example of initially load ICCM/DCCM data.");
    $display( " 3.For users seek for examples to load customized message block and program CSR settings, like *PllCtrl*, please refer to section 3. , where example of load customized message block and CSR settings.Note: customer needs to add runtc command options: ate_cust_mb_cfg_file=<*>, ate_cust_csr_cfg_file=<*>");
    $display( " 4.For users seek for finally completed loading of ICCM/DCCM data, please refer to section 4. , where read out the entire IMEM&DMEM to another two logs called 'imem.log' & 'dmem.log' with CTB command option: bkdoor=1 -mem_dump.Note:The data in this section if 'read' is change to 'write', the list can be used as ICCM/DCC loader at customer end.");
    $display( " 5.For users seek for programming of the MASIS ATE tests to start, please refer to section 5.");
    $display( " 6.For users seek for result polling out, please refer to section 6.");
    $display( " 7.For users seek for final DCCM data after MASIS tests, please refer to section 7. ,  with CTB command option: -mem_dump dmem_rd=1. It can be an reference for debugging.");
    $display("##### MASIS Instruction ends #####");
    $display("-----------------------------------------------");
  `endif

for(int i=0;i<8;i++)begin
  a[i]=$random();
end

  `ifdef ATE_dsply
    repeat(10) @(posedge top.apb_clk);
    $display("-----------------------------------------------");
    $display("##### MASIS Section 1 begins #####  ");
    $display("[%0t] MASIS INFO: Performing Write/Read to the IMEM/DMEM for TDI/TDO checking ",$time);
    $display("-----------------------------------------------");
    $display("[%0t] MASIS INFO: Performing Write/Read to the IMEM for TDI/TDO checking",$time);
    $display("[%0t] Put into single MASIS test pattern    ",$time);
    $display("-----------------------------------------------");
    apb_wr(32'h050000, a[0]);
    apb_wr(32'h050001, a[1]);
    
    apb_rd(32'h050000, data);
    $display("[%0t] INFO: Wrote %h Read back IMEM = %h",$time,a[0], data );
    if(a[0]!=data)begin
      $display("[%0t] Writing to the IMEM failed",$time);
    end
    apb_rd(32'h050001, data);

    $display("[%0t] INFO: Wrote %h Read back IMEM = %h",$time,a[1], data );
    if(a[1]!=data)begin
      $display("[%0t] Writing to the IMEM failed",$time);
    end
    apb_wr(32'h050000, 16'h0000);
    apb_wr(32'h050001, 16'h0000);

    apb_wr(32'h055000,a[2]);
    apb_wr(32'h055001,a[3]);

    apb_rd(32'h055000, data);
    $display("[%0t] INFO: Wrote %h Read back IMEM = %h",$time,a[2], data );
    if(a[2]!=data)begin
      $display("[%0t] Writing to the IMEM failed",$time);
    end

    apb_rd(32'h055001, data);
    $display("[%0t] INFO: Wrote %h Read back IMEM = %h",$time,a[3], data );
    if(a[3]!=data)begin
      $display("[%0t] Writing to the IMEM failed",$time);    
    end

    apb_wr(32'h055000, 16'h0000);
    apb_wr(32'h055001, 16'h0000);
    $display("-----------------------------------------------");
    $display("[%0t] MASIS: End the IMEM TDI/TDO checking    ",$time);
    $display("-----------------------------------------------");
    $display("[%0t] MASIS INFO: Performing Write/Read to the DMEM for TDI/TDO checking",$time);

    apb_wr(32'h058000,a[4]);
    apb_wr(32'h058001,a[5]); 

    apb_rd(32'h058000, data);
    $display("[%0t] INFO: Wrote %h Read back DMEM = %h",$time,a[4], data );    
    if(a[4]!=data)begin
      $display("[%0t] Writing to the DMEM failed",$time);
    end

    apb_rd(32'h058001, data);
    $display("[%0t] INFO: Wrote %h Read back DMEM = %h",$time,a[5], data );    
    if(a[5]!=data)begin
      $display("[%0t] Writing to the DMEM failed",$time);
    end


    apb_wr(32'h058000, 16'h0000);
    apb_wr(32'h058001, 16'h0000);

    apb_wr(32'h05a000,a[6]);
    apb_wr(32'h05a001,a[7]); 

    apb_rd(32'h05a000, data);
    $display("[%0t] INFO: Wrote %h Read back DMEM = %h",$time,a[6], data );    
    if(a[6]!=data)begin
      $display("[%0t] Writing to the DMEM failed",$time);
    end
    apb_rd(32'h05a001, data);
    $display("[%0t] INFO: Wrote %h Read back DMEM = %h",$time,a[7], data );    
    if(a[7]!=data)begin
      $display("[%0t] Writing to the DMEM failed",$time);
    end

    apb_wr(32'h05a000, 16'h0000);
    apb_wr(32'h05a001, 16'h0000);

    $display("-----------------------------------------------");
    $display ("[%0t] MASIS: End the DMEM TDI/TDO checking ",$time);
    $display("##### MASIS Section 1 ends #####  ");
    $display("-----------------------------------------------");
  `endif


  repeat(10) @(posedge top.apb_clk); 
  `ifndef ATE_BKDOOR_ECC // Load IMEM and DMEM from incv
    `ifdef ATE_dsply
      $display("-----------------------------------------------");
      $display("##### MASIS Section 2 begins #####");
      $display("[%0t] MASIS INFO:Loading IMEM and DMEM ",$time);      
      $display("-----------------------------------------------");
      $display("[%0t] MASIS INFO:Loading the IMEM",$time);
      $display("[%0t] Put into single MASIS test pattern\n", $time);
      $display("-----------------------------------------------");
     `include "ddr_ate_imem.incv"
      $display("-----------------------------------------------");  
      $display("[%0t] MASIS:End loading the IMEM\n", $time);
      $display("##### MASIS #####");
      $display("-----------------------------------------------");
      $display("##### MASIS #####");
      $display("[%0t] MASIS INFO:loading the DMEM",$time);
      $display("[%0t] Put into single MASIS test pattern\n", $time);
      $display("-----------------------------------------------");
     `include "ddr_ate_dmem.incv"
      $display("-----------------------------------------------");  
      $display("[%0t] MASIS:End loading the DMEM\n", $time);
      $display("##### MASIS Section 2 ends #####");
      $display("-----------------------------------------------");
    `else
      `include "ddr_ate_imem.incv"
      `include "ddr_ate_dmem.incv"
    `endif
  `else  //Load IMEM and DMEM from backdoor
    $readmemh ("ddr_ate_imem_ecc.txt", top.u_srams.u_iccm_ram0.iccm_mem_0);
    $readmemh ("ddr_ate_dmem_ecc.txt", top.u_srams.u_dccm_ram0.dccm_mem_1);
    $display("ECC back door load finished");
 `endif

  `ifdef USER_TEST
  pre_ate_cfg(); 
  `endif

  if(!cfg.disable_ate_cfg)
  begin
  `ifdef ATE_dsply
    $display("-----------------------------------------------");
    $display("##### MASIS Section 3 begins #####");
    $display("[%0t] MASIS INFO: programming customized message block and programming CSR settings begins",$time);     
    $display("-----------------------------------------------");
    $display("[%0t] MASIS INFO: Begin programming customized message block ", $time);
    $display("-----------------------------------------------");
  `else
    $display("Config start");
  `endif
    config_common_mb; 
  `ifdef ATE_dsply
    $display("-----------------------------------------------");  
    $display("[%0t] MASIS: End programming customized message block\n", $time);   
    $display("-----------------------------------------------");  
    $display("[%0t] MASIS INFO: Begin programming CSR settings",$time);
    $display("##### MASIS #####");
    $display("-----------------------------------------------");
  `else
    $display("Config end");
  `endif 
  `ifdef CUSTOMER_ATE_CSR_CFG
     ate_cust_csr_setting;
  `else
     tech_spec_pll_set;
  `endif
  `ifdef ATE_MASIS
    $display("-----------------------------------------------");  
    $display("[%0t] MASIS: End programming CSR settings ", $time); //comment   
    $display("-----------------------------------------------");
    $display("##### MASIS Section 3 ends #####");
    $display("-----------------------------------------------"); 
  `endif
  end
 
`ifdef MEM_DUMP
    fimem = $fopen("IMEM_Section4.log");
    `ifdef ATE_dsply
      $display("-----------------------------------------------");
      $display("##### MASIS Section 4 begins #####");
      $display("[%0t] MASIS INFO: Reading the entire IMEM and DMEM for back-door",$time);  
      $display("-----------------------------------------------");
      $display( "[%0t] MASIS INFO:Reading the entire IMEM for back-door",$time);
      $display( "[%0t] Do not include in MASIS generation\n", $time);
    `endif   
    imem_dump();
    `ifdef ATE_dsply
      $display("-----------------------------------------------"); 
      $display( "[%0t] MASIS:Before Testing IMEM dump is Done", $time);
      $display( "[%0t] See detailed info in IMEM_section4.log in current directory", $time);
      $display( "-----------------------------------------------");
    `endif
    $fclose(fimem);

    fdmem = $fopen("DMEM_Section4.log");
    `ifdef ATE_dsply
      $display("-----------------------------------------------");
      $display("##### MASIS #####");
      $display( "[%0t] MASIS INFO:Reading the entire DMEM for back-door",$time);
      $display( "[%0t] Do not include in MASIS generation\n", $time);
      $display("-----------------------------------------------");
    `endif
    dmem_dump();
    `ifdef ATE_dsply
      $display( "-----------------------------------------------");  
      $display( "[%0t] MASIS:Before Testing DMEM dump is Done",$time);
      $display( "[%0t] See detailed info in DMEM_Section4.log in current directory",$time);
      $display( "##### MASIS Section 4 ends #####");
      $display( "-----------------------------------------------");
    `endif
    $fclose(fdmem);
 `endif

  `ifdef USER_TEST
  post_ate_cfg(); 
  `endif
  `ifdef ATE_revision_check
    $display("[%0t] Running Revision Check test..." ,$time );
    TestsToRun=32'h1;
  `elsif ATE_impedance_cal  
    $display($time , " \nRunning Impedance Calibration test..." ,$time);
    TestsToRun=32'h2;
  `elsif ATE_pll_lock  
    $display($time , " \nRunning PLL Lock test..." ,$time);
    TestsToRun=32'h4;
  `elsif ATE_lcdl_linearity  
    $display($time , " \nRunning LCDL Linearity test..." ,$time);
    TestsToRun=32'h8;
  `elsif ATE_ac_loopback  
    $display($time , " \nRunning Address / Command Loopback test..." ,$time);
    TestsToRun=32'h10;
  `elsif ATE_data_1d_loopback  
    $display($time , " \nRunning Data Loopback 1D test...");
    TestsToRun=32'h20;
  `elsif ATE_data_2d_loopback  
    $display($time , " \nRunning Data Loopback 2D test...");
    TestsToRun=32'h40;
  `elsif ATE_burn_in
    $display($time , " \nRunning Burn-In test...");
    TestsToRun=32'h80;
  `elsif ATE_rxreplica  
    TestsToRun=32'h100;
  `elsif ATE_dca  
    TestsToRun=32'h200;
  `elsif ATE_MASIS  
    run_MASIS_10ATE_tests;
  `else
    $display("ERROR: No valid ATE test specified.");
    $finish();
  `endif



  apb_wr(32'h58000, TestsToRun);
  apb_wr(32'h58001, 16'h0);// Clean PassFailResults
  run_fw_ate;

  check_results;

  `ifdef DMEM_READ
    dmem_read;
  `endif




  repeat(4000) @(posedge top.dfi_clk);

  // finish test and generate test pass/fail status
  finish_test;
end

endmodule
