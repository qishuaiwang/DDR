
          
TestOptions               =    16'h0000    ;   // CSR Address: 0x58002      
RESERVED_0                =    16'h0000    ;   // CSR Address: 0x58003                                   
UseMsgBlkPhyCfg           =    8'h00       ;                    // CSR Address: 0x58008
PhyCfgNumChan             =    8'h00       ;                    // CSR Address: 0x58008
PhyCfgNumDbPerChan        =    8 'h00      ;                    // CSR Address: 0x58009
PhyCfgDmiEn               =    8 'h00      ;                    // CSR Address: 0x58009
PhyCfgNumRank             =    8 'h00      ;                    // CSR Address: 0x5800a
PhyCfgLp5En               =    8 'h00      ;                    // CSR Address: 0x5800a
ZCalRZN                   =    16'h0808    ;                    // CSR Address: 0x5800b
DfiClkFreq                =    16'h02bc    ;                    // CSR Address: 0x5800c
DfiClkFreqRatio           =    8'h02       ;                    // CSR Address: 0x5800d                                              
ClockingMode              =    8'h01       ;                    // CSR Address: 0x5800d
DacRefModeCtl             =    16'h0000    ;                    // CSR Address: 0x5800e
ZCalCompVref              =    16'h0040    ;                     // CSR Address: 0x5800f
AcVrefDac                 =    16'h0040    ;                     // CSR Address: 0x58010
DbVrefDac                 =    16'h0040    ;                     // CSR Address: 0x58011
DbRxVrefCtl               =    16'h0001    ;                     // CSR Address: 0x58012
DbRxDfeModeCfg            =    16'h0001    ;                     // CSR Address: 0x58013
RESERVED_1                =    16'h0000    ;                     // CSR Address: 0x58014
AcTxImpedanceSe           =    16'h0f0f    ;                     // CSR Address: 0x58015
AcTxImpedanceDiff         =    16'h0f0f    ;                     // CSR Address: 0x58016
AcTxImpedanceSec          =    16'h0022    ;                     // CSR Address: 0x58017
DbTxImpedanceSe           =    16'h0f0f    ;                     // CSR Address: 0x58018
DbTxImpedanceDiff         =    16'h0f0f    ;                     // CSR Address: 0x58019
AcTxSlewSe                =    16'h0022    ;                     // CSR Address: 0x5801a
AcTxSlewDiff              =    16'h0022    ;                     // CSR Address: 0x5801b
DbTxSlewSe                =    16'h0022    ;                     // CSR Address: 0x5801c
DbTxSlewDiff              =    16'h0022    ;                     // CSR Address: 0x5801d                    
RESERVED_2[0 ]            =    16'h0000    ;                     // CSR Address: 0x5801e
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
PubRev                    =    16'h0000    ;
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
LcdlClksToRun             =    16'h03e8    ;                           // CSR Address: 0x5803d
LcdlStartPhase            =    16'h0000    ;                           // CSR Address: 0x5803e
LcdlEndPhase              =    16'h01ff    ;                           // CSR Address: 0x5803f
`ifdef DWC_DDRPHY_GATESIM_SDF
LcdlStride                =    8'h47       ;                           // CSR Address: 0x58040, for gatesim
`else 
LcdlStride                =    8'h11       ;                           // CSR Address: 0x58040
`endif
LcdlPassPercent           =    8'h64       ;                           // CSR Address: 0x58040
LcdlObserveCfg[0]         =    16'h0000    ;                           // CSR Address: 0x58041
LcdlObserveCfg[1]         =    16'h0010    ;
LcdlObserveCfg[2]         =    16'h0020    ;
LcdlObserveCfg[3]         =    16'h0030    ;
RESERVED_5[0]             =    16'h0000   ;                            // CSR Address: 0x58045
RESERVED_5[1]             =    16'h0000   ;
RESERVED_5[2]             =    16'h0000   ;
RESERVED_5[3]             =    16'h0000   ;                                                                           
AcLoopLaneMask[0]         =    16'h0000    ;                             // CSR Address: 0x58049
AcLoopLaneMask[1]         =    16'h0000    ;                             // CSR Address: 0x5804a
                                                                                                                                               
AcLoopClksToRun           =    16'h0200    ;                             // CSR Address: 0x5804b
AcLoopMinLoopPwr          =    8'h00       ;                             // CSR Address: 0x5804c
AcLoopCoreLoopBk          =    8'h01       ;                             // CSR Address: 0x5804c
RESERVED_6                =    8'h00       ;                             // CSR Address: 0x5804d
AcLoopIncrement           =    8'h04       ;                             // CSR Address: 0x5804d
AcMinEyeWidthSe           =    8'h10       ;                             // CSR Address: 0x5804e

AcMinEyeWidthDiff         =    8'h08       ;                             // CSR Address: 0x5804e,for gatesim

AcLoopDiffTestMode        =    8'h00       ;                             // CSR Address: 0x5804f                
AcLoopDiffBitmapSel       =    8'h00       ;                             // CSR Address: 0x5804f
if(DfiClkFreqRatio == 8'h2 && ClockingMode == 8'h0)                      // CSR Address: 0x58050
  AcMinEyeWidthSec        =    16'h20      ;
else 
  AcMinEyeWidthSec        =    16'h10      ;
RESERVED_7                =    16'h0000    ;                             // CSR Address: 0x58051
                          
                                                                         
DatLoopClksToRun          =    16'h0001    ;                             // CSR Address: 0x58052
DatLoopCoreLoopBk         =    16'h0001    ;                             // CSR Address: 0x58053
                                                                         
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
`ifdef DWC_DDRPHY_GATESIM_SDF
DatLoopFineIncr           =    8'h07       ;                             // CSR Address: 0x5805e, for gatesim
`else 
DatLoopFineIncr           =    8'h01        ;                            // CSR Address: 0x5805e
`endif
`ifdef DWC_DDRPHY_GATESIM_SDF
DatLoopMinEyeWidth        =    8'h03       ;                             // CSR Address: 0x5805e, for gatesim
`else
DatLoopMinEyeWidth        =    8'h10       ;                             // CSR Address: 0x5805e
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


