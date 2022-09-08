module ate_cfg;

  bit[15:0] TestsToRun;               
  bit[15:0] PassFailResults;          
  bit[15:0] TestOptions;              // Byte Offset: 0x4 / CSR Address: 0x58002
  bit[15:0] RESERVED_0;               // Byte Offset: 0x6 / CSR Address: 0x58003
  bit[31:0] AteImemRevision;          // Byte Offset: 0x8 / CSR Address: 0x58004
  bit[31:0] AteDmemRevision;          // Byte Offset: 0xc / CSR Address: 0x58006
  bit[7:0]  UseMsgBlkPhyCfg;  
  bit[7:0]  PhyCfgNumChan;  
  bit[7:0]  PhyCfgNumDbPerChan;     
  bit[7:0]  PhyCfgDmiEn;  
  bit[7:0]  PhyCfgNumRank;  
  bit[7:0]  PhyCfgLp5En;  
  bit[15:0] ZCalRZN;  
  bit[15:0] DfiClkFreq;     
  bit[7:0]  DfiClkFreqRatio;  
  bit[7:0]  ClockingMode;  
  bit[15:0] DacRefModeCtl;
  bit[15:0] ZCalCompVref; 
  bit[15:0] AcVrefDac;    
  bit[15:0] DbVrefDac;    
  bit[15:0] DbRxVrefCtl;  
  bit[15:0] DbRxDfeModeCfg;   
  bit[15:0] RESERVED_1;  
  bit[15:0] AcTxImpedanceSe;  
  bit[15:0] AcTxImpedanceDiff;
  bit[15:0] AcTxImpedanceSec; 
  bit[15:0] DbTxImpedanceSe;  
  bit[15:0] DbTxImpedanceDiff;
  bit[15:0] AcTxSlewSe;  
  bit[15:0] AcTxSlewDiff;
  bit[15:0] DbTxSlewSe;    
  bit[15:0] DbTxSlewDiff;
  bit[15:0] PubRev; 
  bit[15:0] RESERVED_2[17];  
  bit[7:0]  ContinuousCal;  
  bit[7:0]  CalInterval;  
  bit[15:0] RESERVED_3[2]; 
  bit[15:0] MemClkToggle; 
  bit[15:0] MemClkTime;  
  bit[15:0] RESERVED_4[8];                             
  bit[15:0] LcdlClksToRun; 
  bit[15:0] LcdlStartPhase; 
  bit[15:0] LcdlEndPhase; 
  bit[7:0]  LcdlStride; 
  bit[7:0]  LcdlPassPercent;  
  bit[15:0] LcdlObserveCfg[4]; 
  bit[15:0] RESERVED_5[4]; 
  bit[15:0] AcLoopLaneMask[2];  
  bit[15:0] AcLoopClksToRun;  
  bit[7:0]  AcLoopMinLoopPwr;  
  bit[7:0]  AcLoopCoreLoopBk;  
  bit[7:0]  RESERVED_6;  
  bit[7:0]  AcLoopIncrement;  
  bit[7:0]  AcMinEyeWidthSe;  
  bit[7:0]  AcMinEyeWidthDiff; 
  bit[7:0]  AcLoopDiffTestMode;
  bit[7:0]  AcLoopDiffBitmapSel;
  bit[15:0] AcMinEyeWidthSec;
  bit[15:0] RESERVED_7;  
  bit[15:0] DatLoopClksToRun;  
  bit[15:0] DatLoopCoreLoopBk;  
  bit[7:0]  DatLoopMinLoopPwr; 
  bit[7:0]  RESERVED_8; 
  bit[15:0] RESERVED_9;  
  bit[15:0] TxDqsDly;  
  bit[15:0] TxWckDly;  
  bit[15:0] RxEnDly;  
  bit[15:0] RxDigStrbDly;  
  bit[15:0] RxClkT2UIDly;  
  bit[15:0] RxClkC2UIDly;  
  bit[7:0]  DatLoopDiffTestMode;
  bit[7:0]  DatLoopDiffBitmapSel;  
  bit[7:0]  DatLoopCoarseStart;  
  bit[7:0]  DatLoopCoarseEnd;  
  bit[7:0]  DatLoopFineIncr;  
  bit[7:0]  DatLoopMinEyeWidth;  
  bit[7:0]  DatLoopByte;  
  bit[7:0]  DatLoopBit;  
  bit[7:0]  DatLoop2dVrefStart;  
  bit[7:0]  DatLoop2dVrefEnd;  
  bit[7:0]  DatLoop2dVrefIncr;  
  bit[7:0]  RESERVED_10;  
  bit[15:0] RESERVED_11[5];
  bit[7:0]  DcaLoopMinLoopPwr; 
  bit[7:0]  DcaLoopDelayIncr; 
  bit[7:0]  DcaLoopDcaCoarseSkip; 
  bit[7:0]  DcaLoopDcaFineIncr; 
  bit[7:0]  DcaLoopBitmapSel; 
  bit[7:0]  RESERVED_12[6]; 

initial
begin // DO NOT CHANGE FILE ORDER ! ! ! 
`include "ate_mb_default_setting.sv"
$display(" Load ate_mb_default_setting.sv ");//only to display in simv.log 
  `ifdef CUSTOMER_ATE_MB_CFG
  `include "tmp_ate_mb_cust_setting.sv" 
$display(" Load ATE message block customer setting done ");//only to display in simv.log 
  `endif
end 
  
endmodule

