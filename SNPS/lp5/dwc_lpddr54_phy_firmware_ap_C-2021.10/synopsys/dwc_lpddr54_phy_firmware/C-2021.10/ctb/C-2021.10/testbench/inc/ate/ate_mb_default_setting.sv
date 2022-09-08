
          
TestOptions               =    16'h0000    ;   // CSR Address: 0x58002      
RESERVED_0                =    16'h0000    ;   // CSR Address: 0x58003         
                          
UseMsgBlkPhyCfg           =   8'h00                  ;                                      // CSR Address: 0x58008
PhyCfgNumChan             =   cfg.NumCh[7:0]         ;                                      // CSR Address: 0x58008
PhyCfgNumDbPerChan        =   cfg.NumDbytesPerCh[7:0];                                      // CSR Address: 0x58009
PhyCfgDmiEn               =   8 'h00                 ;                                      // CSR Address: 0x58009
PhyCfgNumRank             =   cfg.NumRank_dfi0[7:0]  ;                                      // CSR Address: 0x5800a
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
PhyCfgLp5En               =   8 'h01                 ;                                      // CSR Address: 0x5800a
`else
PhyCfgLp5En               =   8 'h00                 ;  
`endif

//UseMsgBlkPhyCfg           =    PhyCfgLp5En ? 8'h00: 8'h01 ; //CSR Address: 0x58008. From Andrew in JIRA P80001562-139618. The PhyCfg override message block fields are used to override the CSR 'PhyConfig', and aren't enabled by default.
ZCalRZN                   =    16'h0808    ;                                               // CSR Address: 0x5800b



DfiClkFreqRatio           =    cfg.DfiFreqRatio[0];                                        // CSR Address: 0x5800d

`ifdef ATE_LP4	
	if(DfiClkFreqRatio[0]==1)
           DfiClkFreq = cfg.Frequency[0]/2 ;
	else
	   DfiClkFreq = cfg.Frequency[0]/4 ;
`elsif ATE_LP5
       DfiClkFreq = cfg.Frequency[0] ;
`endif


`ifdef ATE_LP4
ClockingMode              =    8'h00    ;                                                  // CSR Address: 0x5800d
`elsif ATE_LP5 
ClockingMode              =    8'h01    ;
`endif


`ifdef ATE_LP4
DacRefModeCtl             =    16'h0001    ;                                               // CSR Address: 0x5800e
`elsif ATE_LP5
DacRefModeCtl             =    16'h0000    ; 
`endif




ZCalCompVref              =    16'h0040    ;                     // CSR Address: 0x5800f
AcVrefDac                 =    16'h0040    ;                     // CSR Address: 0x58010
DbVrefDac                 =    16'h0001    ;                     // CSR Address: 0x58011
DbRxVrefCtl               =    16'h0001    ;                     // CSR Address: 0x58012
DbRxDfeModeCfg            =    16'h0001    ;                     // CSR Address: 0x58013
RESERVED_1                =    16'h0000    ;                     // CSR Address: 0x58014
AcTxImpedanceSe           =    16'h0f0f    ;                     // CSR Address: 0x58015
AcTxImpedanceDiff         =    16'h0f0f    ;                     // CSR Address: 0x58016
AcTxImpedanceSec          =    16'h0002    ;                     // CSR Address: 0x58017
DbTxImpedanceSe           =    16'h0f0f    ;                     // CSR Address: 0x58018
DbTxImpedanceDiff         =    16'h0f0f    ;                     // CSR Address: 0x58019
AcTxSlewSe                =    16'h0022    ;                     // CSR Address: 0x5801a
AcTxSlewDiff              =    16'h0022    ;                     // CSR Address: 0x5801b
DbTxSlewSe                =    16'h0022    ;                     // CSR Address: 0x5801c
DbTxSlewDiff              =    16'h0022    ;                     // CSR Address: 0x5801d
                    
PubRev                    =    16'h0000    ;                     // CSR Address: 0x5801e
RESERVED_2[0 ]            =    16'h0000    ;                    
RESERVED_2[1 ]            =    16'h0000    ;
RESERVED_2[2 ]            =    16'h0000    ;
RESERVED_2[3 ]            =    16'h0000    ;
RESERVED_2[4 ]            =    16'h0000    ;
RESERVED_2[5 ]            =    16'h0000    ;
RESERVED_2[6 ]            =    16'h0000    ;
RESERVED_2[7 ]            =    16'h0000    ;
RESERVED_2[8 ]            =    16'h0000    ;
RESERVED_2[9 ]            =    16'h0000    ;
RESERVED_2[10]            =    16'h0000    ;
RESERVED_2[11]            =    16'h0000    ;
RESERVED_2[12]            =    16'h0000    ;
RESERVED_2[13]            =    16'h0000    ;
RESERVED_2[14]            =    16'h0000    ;
RESERVED_2[15]            =    16'h0000    ;
RESERVED_2[16]            =    16'h0000    ;
RESERVED_2[17]            =    16'h0000    ;






                                                                     

ContinuousCal             =    8'h01       ;                      // CSR Address: 0x58030
CalInterval               =    8'h00       ;                      // CSR Address: 0x58030

RESERVED_3[0]             =    16'h0000    ;                      // CSR Address: 0x58031
RESERVED_3[1]             =    16'h0000    ; 


MemClkToggle              =    16'h0002    ;                      // CSR Address: 0x58033
MemClkTime                =    16'h001f    ;                      // CSR Address: 0x58034

RESERVED_4[0]             =    16'h0000    ;                      // CSR Address: 0x58035
RESERVED_4[1]             =    16'h0000    ;
RESERVED_4[2]             =    16'h0000    ;
RESERVED_4[3]             =    16'h0000    ;
RESERVED_4[4]             =    16'h0000    ;
RESERVED_4[5]             =    16'h0000    ;
RESERVED_4[6]             =    16'h0000    ;
RESERVED_4[7]             =    16'h0000    ;





                                                                                  

LcdlClksToRun             =    16'h0064    ;                           // CSR Address: 0x5803d
LcdlStartPhase            =    16'h0000    ;                           // CSR Address: 0x5803e
LcdlEndPhase              =    16'h01ff    ;                           // CSR Address: 0x5803f
LcdlStride                =    8'hf0       ;                           // CSR Address: 0x58040
LcdlPassPercent           =    8'h64       ;                           // CSR Address: 0x58040

LcdlObserveCfg[0]         =    16'h0000    ;                           // CSR Address: 0x58041
LcdlObserveCfg[1]         =    16'h0010    ;
LcdlObserveCfg[2]         =    16'h0020    ;
LcdlObserveCfg[3]         =    16'h0030    ;

RESERVED_5[0]             =    16'h0000   ;                            // CSR Address: 0x58045
RESERVED_5[1]             =    16'h0000   ;
RESERVED_5[2]             =    16'h0000   ;
RESERVED_5[3]             =    16'h0000   ;



                                                                             

AcLoopLaneMask[0]         =    16'h0172    ;                             // CSR Address: 0x58049
AcLoopLaneMask[1]         =    16'h0016    ;                             // CSR Address: 0x5804a
                                                                         
                                                                         
AcLoopClksToRun           =    16'h0001    ;                             // CSR Address: 0x5804b
AcLoopMinLoopPwr          =    8'h00       ;                             // CSR Address: 0x5804c
`ifdef AC_PAD_LBK
AcLoopCoreLoopBk          =    8'h00       ;                             // CSR Address: 0x5804c
`else
AcLoopCoreLoopBk          =    8'h01       ;                             // CSR Address: 0x5804c
`endif
RESERVED_6                =    8'h00       ;                             // CSR Address: 0x5804d
`ifdef DWC_DDRPHY_GATESIM_SDF
  AcLoopIncrement    = 8'h04       ;                          // CSR Address: 0x5804d
  AcMinEyeWidthSe    = AcLoopCoreLoopBk ? 8'h18 : 8'h10    ; // CSR Address: 0x5804e
  AcMinEyeWidthDiff  = AcLoopCoreLoopBk ? 8'h0c : 8'h8     ; // CSR Address: 0x5804e
  if(DfiClkFreqRatio == 8'h2 && ClockingMode == 8'h0)         // CSR Address: 0x58050
    AcMinEyeWidthSec = AcLoopCoreLoopBk ? 16'h30 : 16'h20   ;
  else
    AcMinEyeWidthSec = AcLoopCoreLoopBk ? 16'h18 : 16'h10   ;
`else 
  AcLoopIncrement    = 8'h01       ;                          // CSR Address: 0x5804d
  AcMinEyeWidthSe    = AcLoopCoreLoopBk ? 8'h60 : 8'h40     ; // CSR Address: 0x5804e
  AcMinEyeWidthDiff  = AcLoopCoreLoopBk ? 8'h30 : 8'h20     ; // CSR Address: 0x5804e
  if(DfiClkFreqRatio == 8'h2 && ClockingMode == 8'h0)         // CSR Address: 0x58050
    AcMinEyeWidthSec = AcLoopCoreLoopBk ? 16'hc0 : 16'h80   ;
  else
    AcMinEyeWidthSec = AcLoopCoreLoopBk ? 16'h60 : 16'h40   ;
`endif
AcLoopDiffTestMode        =    8'h00       ;                             // CSR Address: 0x5804f                
AcLoopDiffBitmapSel       =    8'h00       ;                             // CSR Address: 0x5804f


RESERVED_7                =    16'h0000    ;                             // CSR Address: 0x58051
                          
                                                                         
DatLoopClksToRun          =    16'h0001    ;                             // CSR Address: 0x58052
`ifdef DAT_PAD_LBK
DatLoopCoreLoopBk         =    16'h0000    ;                             // CSR Address: 0x58053
`else
DatLoopCoreLoopBk         =    16'h0001    ;                             // CSR Address: 0x58053
`endif
                                                                         
DatLoopMinLoopPwr         =    8'h00       ;                             // CSR Address: 0x58054
RESERVED_8                =    8'h00       ;                             // CSR Address: 0x58054
RESERVED_9                =    16'h0000    ;                             // CSR Address: 0x58055
                                                                         
TxDqsDly                  =    16'hFFFF    ;                             // CSR Address: 0x58056
TxWckDly                  =    16'hFFFF    ;                             // CSR Address: 0x58057
RxEnDly                   =    16'hffff    ;                             // CSR Address: 0x58058
RxDigStrbDly              =    16'hffff    ;                             // CSR Address: 0x58059
RxClkT2UIDly              =    16'hFFFF    ;                             // CSR Address: 0x5805a
RxClkC2UIDly              =    16'hFFFF    ;                             // CSR Address: 0x5805b
DatLoopDiffTestMode       =    8'h00       ;                             // CSR Address: 0x5805c
DatLoopDiffBitmapSel      =    8'h00       ;                             // CSR Address: 0x5805c
                                                                         
DatLoopCoarseStart        =    8'h00       ;                             // CSR Address: 0x5805d
DatLoopCoarseEnd          =    8'h06       ;                             // CSR Address: 0x5805d
DatLoopFineIncr           =    8'h08       ;                             // CSR Address: 0x5805e
`ifdef DWC_DDRPHY_GATESIM_SDF
DatLoopMinEyeWidth        =    8'h06       ;                             // CSR Address: 0x5805e, for gatesim
`else
DatLoopMinEyeWidth        =    8'h07       ;                             // CSR Address: 0x5805e
`endif
DatLoopByte               =    8'h00       ;                             // CSR Address: 0x5805f
DatLoopBit                =    8'h00       ;                             // CSR Address: 0x5805f
DatLoop2dVrefStart        =    8'h20       ;                             // CSR Address: 0x58060
DatLoop2dVrefEnd          =    8'h40       ;                             // CSR Address: 0x58060
DatLoop2dVrefIncr         =    8'h20       ;                             // CSR Address: 0x58061
RESERVED_10               =    8'h00       ;                             // CSR Address: 0x58061
RESERVED_11[0]            =    16'h0000    ;                             // CSR Address: 0x58062
RESERVED_11[1]            =    16'h0000    ;
RESERVED_11[2]            =    16'h0000    ;
RESERVED_11[3]            =    16'h0000    ;
RESERVED_11[4]            =    16'h0000    ;
DcaLoopMinLoopPwr         =    8'h00       ;                             // CSR Address: 0x58067
DcaLoopDelayIncr          =    8'h01       ;
DcaLoopDcaCoarseSkip      =    8'h0e       ;                             // CSR Address: 0x58068
DcaLoopDcaFineIncr        =    8'h06       ;
DcaLoopBitmapSel          =    8'h00       ;                             // CSR Address: 0x58069
RESERVED_12[0]            =    8'h00       ;


