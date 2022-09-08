typedef enum {CTB_DDR5, CTB_DDR4, CTB_DDR3, CTB_LPDDR5, CTB_LPDDR4, CTB_LPDDR3, CTB_NONE } DramType_t;
typedef enum {CTB_UDIMM, CTB_SODIMM, CTB_RDIMM, CTB_LRDIMM, CTB_NODIMM} DimmType_t;

module cfg;

    DramType_t DramType;
    DimmType_t DimmType;

    int debug      = 0   ;
    int skip_train = 0   ;
    int apb_freq   = 500 ;
    int tdr_freq   = 50  ;
                  
    bit[1:0] PState       ; // PState (from 0:3)
    int      DisableFspOp ; // FSP-OP disable cfg
    int      FirstPState  ; // DRAM fisrt mission pstate.

    int Train2D;            // Set 1 to choose 2D Training, otherwise 1D Training will execute
    			    // Only valid if training firmware will be executed


    int NumCh;              // Enter number of channel
    int NumDbytesPerCh;     // Enter number of dbytes each channel
    int NumDbyte;           // Enter number of dbytes
    int NumActiveDbyteDfi0; // Enter number of dbytes to be controlled by dfi0
    int NumActiveDbyteDfi1; // Enter number of dbytes to be controlled by dfi1
    
    int NumAnib;            // Enter number of ANIBs
    
    int NumRank_dfi0;       // Number of ranks in DFI0 channel
    
    int NumRank_dfi1;       // Number of ranks in DFI1 channel (if DFI1 exists)
    
    int DramDataWidth;      // Enter 4,8,16 or 32 depending on protocol and dram type. 
                            // See below for legal types for each protocol.
                            // DDR3   X4,X8		 -- default = X8
                            // DDR4   X4,X8,X16	 -- default = X8
                            // LPDDR3 X16,X32    -- default = X16
                            // LPDDR4 X8,X16     -- default = X16
    int Lp4xMode;
    int HardMacroVer;

    int BurstLength;        // 


    int NumPStates;         // Number of p-states used
    
    int Frequency[4];       // [0] - P0 Memclk frequency in MHz
                            // [1] - P1 Memclk frequency in MHz
                            // [2] - P2 Memclk frequency in MHz
                            // [3] - P3 Memclk frequency in MHz
    
    bit [15:0] TestsToRun = 16'h13f; // TestsToRun[0]     = DMEM / IMEM revision check 
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

    bit [15:0] MR0[4];
    bit [15:0] MR1[4];
    bit [15:0] MR2[4];
    bit [15:0] MR3[4];
    bit [15:0] MR4[4];
    bit [15:0] MR5[4];
    bit [15:0] MR6[4];
    bit [15:0] MR10[4];
    bit [15:0] MR18[4];
    bit [15:0] MR19[4];
    bit [15:0] MR20[4];
    bit [15:0] MR13[4];
    bit [15:0] MR16[4];
    bit [15:0] MR22[4];

    bit [15:0] F0RC0A_D0[4];
    bit [15:0] F0RC3x_D0[4];
    bit [15:0] F0RC0D_D0[4];
    bit [15:0] F0RC0F_D0[4];

    int CWL[4];             // [0] - P0 Cas write latency
                            // [1] - P1 Cas write latency
                            // [2] - P2 Cas write latency
                            // [3] - P3 Cas write latency
    int CL[4];              // [0] - P0 Cas latency
                            // [1] - P1 Cas latency
                            // [2] - P2 Cas latency
                            // [3] - P3 Cas latency
    
    int PllBypass[4];       // [0] - PLL Bypass Enable for P0
                            // [1] - PLL Bypass Enable for P1
                            // [2] - PLL Bypass Enable for P2
                            // [3] - PLL Bypass Enable for P3
    
    int DfiFreqRatio[4];    // 2'b00 = 1:1
                            // 2'b01 = 1:2
                            // 2'b1x = 1:4
                            // [0] - DFI Frequency Ratio for P0 
                            // [1] - DFI Frequency Ratio for P1 
                            // [2] - DFI Frequency Ratio for P2 
                            // [3] - DFI Frequency Ratio for P3 
    
    int Dfi1Exists;         // Indicates whether they PHY config has Dfi1 channel 
    
    int DfiMode;            // Applicable only if DramType == LPDDR4 || LPDDR3
                            // 0x0 = DFI0 is enabled and controls the entire PHY
                            // 0x1 = DFI0 controls 1/2 the PHY, external logic ties off inputs to DFI1
                            // 0x2 = DFI0 and DFI1 are active and are separately controlled
    
    int ReadDBIEnable[4];   // Set 1 to enable Read-DBI function
                            // Only application for DD4 and LPDDR4
                            // [0] - enable for P0
                            // [1] - enable for P1
                            // [2] - enable for P2
                            // [3] - enable for P3

    int CATerminatingRankChA;  // (LPDDR4 Only) Terminating Rank for CA bus on Channel A. Set bit[x] when Rank x is the terminating rank

    int CATerminatingRankChB;  // (LPDDR4 Only) Terminating Rank for CA bus on Channel B. Set bit[x] when Rank x is the terminating rank

    int MsgMisc;            // See the description in the message block associated with your DRAM Type for details
    
    int SequenceCtrl;       // Enables training procedures.  See the description in the message block 
                            // associated with your DRAM Type
    
    int MR[25][4];          // MR Values 0-24.  See the description in the message block associated with your 
                            // DRAM Type to determine which MR registers to load
    
    int EnabledDQsA;        // Total number of DQ bits enabled in PHY for DDR3/4, and LPDDR3/4 Ch. A
    int EnabledDQsB;        // Total number of DQ bits enabled in PHY for LPDDR3/4 Ch. B
    
                            // DDR3/DDR4 ONLY:
    int CsPresentD0;        //   The CS signals from field CsPresent that are routed to DIMM connector 0
    int CsPresentD1;        //   The CS signals from field CsPresent that are routed to DIMM connector 1
    
    int AddrMirror;         //   See the description in the message block associated with your DRAM Type for details
    
    int AcsmOdtCtrl[8];     //   ODT Pattern.  See the description in the message block associated with your DRAM Type for details.
   
    int  BPZNResVal ;       // ZN Resistor value
                            //  0 = 240 Ohm
                            //  1 = 120 Ohm
                            //  2 = 40 Ohm
                            //  Other values are RFU

    int  PhyOdtImpedance;   // Impedance in ohm
                            // 0 = Firmware skips programming


//    int Lp4RxPreambleMode[4];  // Selects between static read preamble and toggle read preamble
                            // 1 - toggling preamble
                            // 0 - static preamble
                            // Applicable only if DramType == LPDDR4
                            // Same as MR1[3]

    int Lp4ReadPostambleLength; 

    
    int Lp4PostambleExt[4];    // Extend write postamble in LPDDR4
                            // 0 - half Memclk postamble
                            // 1 - 1.5 Memclk postabmle
    
    int D4RxPreambleLength[4]; // Length of read preamble in DDR4 mode
                            // DDR MR4-A11
                            // 0 - 1 Tck
                            // 1 - 2 Tck
    
    int D4TxPreambleLength[4]; // Length of write preamble in DDR4 mode
                            // DDR MR4-A12
                            // 0 - 1 Tck
                            // 1 - 2 Tck
    
    int ExtCalResVal;       // External pull-down resistor value in Ohm
                            // Drop-down menu:
                            // 0 - 240 ohm
                            // 1 - 120 ohm
                            // 2 -  40 ohm
    
    int Is2Ttiming[4];      // Set to 1 to use 2T timing for address/command, otherwise 1T timing will be used
                            // In 1T mode, CK, CS, CA all have the same nominal timing, ie. ATxDly[6:0] will have same value for all ANIBs
                            // In 2T mode, CK, CS,have the same nominal timing (e.g. AtxDly[6:0]=0x00), while CA is delayed by 1UI 
                            // (e.g. ATxDly[6:0]=0x40)
                            // [0] - setting for P0
                            // [1] - setting for P1
                            // [2] - setting for P2
                            // [3] - setting for P3
    
    real ODTImpedance[4];  // Enter desired ODT impedance in Ohm 
                            // Enter 0 for high-impedance
                            // [0] - ODT in Ohm for P0
                            // [1] - ODT in Ohm for P1
                            // [2] - ODT in Ohm for P2
                            // [3] - ODT in Ohm for P3
                            // Valid values for DDR4   = 240, 120, 80, 60, 40
                            // Valid values for DDR3   = high-impedance, 120, 60, 40
                            // Valid values for LPDDR4 = 240, 120, 80, 60, 40
                            // Valid values for LPDDR3 = 240, 120, 80, 60, 40
    
    real  TxImpedance[4];  // Tx Drive Impedance for DQ/DQS in ohm
                            // [0] - impedance in Ohm for P0
                            // [1] - impedance in Ohm for P1
                            // [2] - impedance in Ohm for P2
                            // [3] - impedance in Ohm for P3
                            // Valid values for all DramType = 240, 120, 80, 60, 48, 40, 34

    
    int MemAlertEn;         // Enables MemAlert feature
                            // Applicatle only if DramType == DDR3 or DDR4
    
    int MemAlertPUImp;      // Specify MemAlert Pull-up Termination Impedance
                            // 
                            // Choose from the following settings:
                            //    0000 -      No PullUp Strength
                            //    0001 - 240 Ohm PullUp Strength
                            //    0010 - 240 Ohm PullUp Strength
                            //    0011 - 120 Ohm PullUp Strength
                            //    0100 - 120 Ohm PullUp Strength
                            //    0101 -  80 Ohm PullUp Strength
                            //    0110 -  80 Ohm PullUp Strength
                            //    0111 -  60 Ohm PullUp Strength
                            //    1000 - 120 Ohm PullUp Strength
                            //    1001 -  80 Ohm PullUp Strength
                            //    1010 -  80 Ohm PullUp Strength
                            //    1011 -  60 Ohm PullUp Strength
                            //    1100 -  60 Ohm PullUp Strength
                            //    1101 -  48 Ohm PullUp Strength
                            //    1110 -  48 Ohm PullUp Strength
                            //    1111 -  40 Ohm PullUp Strength
                            //
                            //    Default = 0101 (80 Ohm Pullup)
    
    int MemAlertVrefLevel;  // Specify the Vref level for MemAlert Receiver
                            // VREF is determined by this equation:
                            //
                            //      VREF = VDDQ*(0.51 + MALERTVrefLevel[6:0]*0.00345)
                            //
                            // Default VREF = 0.65 * VDDQ --> MemAlertVrefLevel[6:0] = 7'd41
   
    int MemAlertSyncBypass; // When set, this bit bypasses the DfiClk synchronizer on dfi_alert_n
                            // Default = 0

    int DisDynAdrTri[4];	// Set to 1 to disable dynamic tristating
    						//   In DDR3/2T mode, the dynamic tristate feature should be disabled 
    						// if the controller cannot follow the 2T PHY tristate protocol.
     						//   In DDR4/2T/2N mode, the dynamic tristate feature should be disabled 
    						// if the controller cannot follow the 2T PHY tristate protocol.
     						//   In LPDDR4 mode, the dynamic tristate feature should be disabled.

    int PhyMstrTrainInterval[4]; // Specifies the time between the end of one training and the start of the next.
                                 // it is the max expected time from dfi_init_complete asserted to tdfi_phymstr_ack asserted
                                 // 4'b0000 Disable PHY Master Interface
                                 // 4'b0001 PPT Train Interval = 524288 MEMCLKs
                                 // 4'b0010 PPT Train Interval = 1048576 MEMCLKs
                                 // 4'b0011 PPT Train Interval = 2097152 MEMCLKs
                                 // 4'b0100 PPT Train Interval = 4194304 MEMCLKs
                                 // 4'b0101 PPT Train Interval = 8388608 MEMCLKs
                                 // 4'b0110 PPT Train Interval = 16777216 MEMCLKs
                                 // 4'b0111 PPT Train Interval = 33554432 MEMCLKs
                                 // 4'b1000 PPT Train Interval = 67108864 MEMCLKs
                                 // 4'b1001 PPT Train Interval = 134217728 MEMCLKs
                                 // 4'b1010 PPT Train Interval = 268435456 MEMCLKs
                                 // 4'b1011 - 4'b1111 PPT Train Interval = undefined

    int PhyMstrMaxReqToAck[4];   // Specifies the max time from tdfi_phymstr_req asserted to tdfi_phymstr_ack asserted
                                 // 3'b000 Disable PHY Master Interface
                                 // 3'b001 PPT Max. Req to Ack. = 512 MEMCLKs
                                 // 3'b010 PPT Max. Req to Ack. = 1024 MEMCLKs
                                 // 3'b011 PPT Max. Req to Ack. = 2048 MEMCLKs
                                 // 3'b100 PPT Max. Req to Ack. = 4096 MEMCLKs
                                 // 3'b101 PPT Max. Req to Ack. = 8192 MEMCLKs
                                 // 3'b110 - 3'b111 PPT Max. Req to Ack. = undefined

    int WDQSExt;             // Write DQS Extension.  See App Note "DesignWare Cores LPDDR4 MultiPHY : WDQS Extension Application Note"

    int HdtCtrl;            // To be set at 0xFF unless debugging PHY training via mailbox message to host

    int PhyVref;           // Vref for Phy (can be different than DDR4 MR6, or DDR3 VDDQ/2)

    int DFIMRLMargin[4];    //   Margin added to smallest passing trained DFI Max Read Latency value, in units of DFI clocks. Recommended to be >= 1
                            //   By pstate. 

                            //   DDR4 ONLY
    int CsSetupGDDec;       //      Controls timing of chip select signals when DDR4 gear-down mode is active
                            //      See the description in the message block associated with your DRAM Type for details.

    int VrefDq;             //      Override VrefDq value for all ranks & nibbles 


                            // LPDDR3/4 Only
    int  CATrainOpt;        //      See the description in the message block associated with your DRAM Type for details.

    int CalInterval;        // Specifies the interval between successive calibrations, in mS.
                            // csrValue : Interval (mS)
                            //   0      : 0 (continuous)
                            //   1      : 0.01 (13 uS)
                            //   2      : 0.10
                            //   3      : 1
                            //   4      : 2
                            //   5      : 3
                            //   6      : 4
                            //   7      : 8
                            //   8      : 10
                            //   9      : 20
                            //   10-15  : Reserved.
                            //
                            // This field should only be changed while the calibrator is idle.
                            // ie before csr CalRun is set.
                            
                           
    int CalOnce;            // This setting changes the behaviour of CSR CalRun.
                            // 1: The 0->1 transition of CSR CalRun causes a single iteration of the calibration
                            //    sequence to occur.
                            // 0: Calibration will proceed at the rate determined by CSRCalInterval.
                            // This field should only be changed while the calibrator is idle.
                            // ie before csr CalRun is set.
                    
    int Lp3MR1[4];               // MR1 for LPDDR3 - please refer to JEDEC JESD209-3C (LPDDR3) Spec for definition
                                 // This is used to program AcsmPlayback CSRs for LPDDR3 PPT
                                 // [0] - MR for P0
                                 // [1] - MR for P1
                                 // [2] - MR for P2
                                 // [3] - MR for P3

    int Lp3MR2[4];               // MR2 for LPDDR3 - please refer to JEDEC JESD209-3C (LPDDR3) Spec for definition
                                 // This is used to program AcsmPlayback CSRs for LPDDR3 PPT
                                 // [0] - MR for P0
                                 // [1] - MR for P1
                                 // [2] - MR for P2
                                 // [3] - MR for P3

    int Lp3MR3[4];               // MR3 for LPDDR3 - please refer to JEDEC JESD209-3C (LPDDR3) Spec for definition
                                 // This is used to program AcsmPlayback CSRs for LPDDR3 PPT
                                 // [0] - MR for P0
                                 // [1] - MR for P1
                                 // [2] - MR for P2
                                 // [3] - MR for P3

    int Lp3MR11[4];              // MR11 for LPDDR3 - please refer to JEDEC JESD209-3C (LPDDR3) Spec for definition
                                 // This is used to program AcsmPlayback CSRs for LPDDR3 PPT
                                 // [0] - MR for P0
                                 // [1] - MR for P1
                                 // [2] - MR for P2
                                 // [3] - MR for P3

    int Lp4RL[4];                // LPDDR4 Dram Read Latency
                                 // This is equivalent to LPDDR4 MR2-OP[2:0]
                                 // Applicable only if DramType == LPDDR4
                                 // Please refer to JEDEC JESD209-4A (LPDDR4) Spec for definition
                                 // [0] - setting for P0
                                 // [1] - setting for P1
                                 // [2] - setting for P2
                                 // [3] - setting for P3
 
    int Lp4WL[4];                // LPDDR4 Dram Write Latency
                                 // This is equivalent to LPDDR4 MR2-OP[5:3]
                                 // Applicable only if DramType == LPDDR4
                                 // Please refer to JEDEC JESD209-4A (LPDDR4) Spec for definition
                                 // [0] - setting for P0
                                 // [1] - setting for P1
                                 // [2] - setting for P2
                                 // [3] - setting for P3
                                   
    int Lp4WLS[4];               // LPDDR4 Dram WL Set
                                 // 0 - WL Set "A"
                                 // 1 - WL Set "B"
                                 // This is equivalent to LPDDR4 MR2-OP[6]
                                 // Applicable only if DramType == LPDDR4
                                 // Please refer to JEDEC JESD209-4A (LPDDR4) Spec for definition
                                 // [0] - setting for P0
                                 // [1] - setting for P1
                                 // [2] - setting for P2
                                 // [3] - setting for P3
                                    
    int Lp4DbiRd[4];             // LPDDR4 Dram DBI-Read Enable
                                 // 0 - Disabled
                                 // 1 - Enabled
                                 // This is equivalent to LPDDR4 MR3-OP[6]
                                 // Applicable only if DramType == LPDDR4
                                 // Please refer to JEDEC JESD209-4A (LPDDR4) Spec for definition
                                 // [0] - setting for P0
                                 // [1] - setting for P1
                                 // [2] - setting for P2
                                 // [3] - setting for P3

    int Lp4DbiWr[4];             // LPDDR4 Dram DBI-Write Enable
                                 // 0 - Disabled
                                 // 1 - Enabled
                                 // This is equivalent to LPDDR4 MR3-OP[7]
                                 // Applicable only if DramType == LPDDR4
                                 // Please refer to JEDEC JESD209-4A (LPDDR4) Spec for definition
                                 // [0] - setting for P0
                                 // [1] - setting for P1
                                 // [2] - setting for P2
                                 // [3] - setting for P3


    int tDQS2DQ;                // Enter the value of tDQS2DQ for LPDDR4 dram (in ps)

    int tDQSCK;                 // Enter the value of tDQSCK in ps
    
    int tSTAOFF[4];             // Enter the value of tSTAOFF in ps
                                // Applicable only if DimmType==RDIMM or LRDIMM
                                // [0] - tSTAOFF for P0
                                // [1] - tSTAOFF for P1
                                // [2] - tSTAOFF for P2
                                // [3] - tSTAOFF for P3

    int DramByteSwap;           // Set to 1 if DRAM is Byte routing is swapped. 

    int X4Dimm;                 // Indicates whether Dram is X4 data width
                                // Only needed in SNPS internal simulation

    int RxEnBackOff;            // Amount of UI Back off for RxEn with static Preamble in LPDDR4 
                                // valid values are 1 or 2.
//----------Added by Cunming Shi to skip unsupported override_c----------//
    int CsMode;
    int CsPresent;
    int EnabledDQs;
    int ALT_CAS_L[4];
    int ALT_WCAS_L[4];
    int UseBroadcastMR;
    int X8Mode;
//-----------------------------------------------------------------------//


    int Lp4nWR[4];        
    int Lp4PuCal;
    int Lp4PDDS[4];
    int Lp4DramThermalOffset;
    int Lp4DqOdt[4];
    int Lp4CaOdt[4];
    int Lp4VrefCa[4];
    int Lp4VrefCaRange[4];
    int Lp4VrefDq[4];
    int Lp4VrefDqRange[4];
    int Lp4BankRefreshMaskA;
    int Lp4BankRefreshMaskB;
    int Lp4SocOdtA0      ; 
    int Lp4SocOdtA1      ;
    int Lp4SocOdtB0      ;
    int Lp4SocOdtB1      ;
    int Lp4CkOdtEnA0     ;
    int Lp4CkOdtEnA1     ;
    int Lp4CkOdtEnB0     ;
    int Lp4CkOdtEnB1     ;
    int Lp4CsOdtEnA0     ;
    int Lp4CsOdtEnA1     ;
    int Lp4CsOdtEnB0     ;
    int Lp4CsOdtEnB1     ;
    int Lp4CaOdtDisA0    ;
    int Lp4CaOdtDisA1    ;
    int Lp4CaOdtDisB0    ;
    int Lp4CaOdtDisB1    ;
    int Lp4SegRefreshMaskA;
    int Lp4SegRefreshMaskB;
    int TrainSequenceCtrl;
    int Lp4Quickboot;
    int TxSlewRiseDQ[4];
    int TxSlewFallDQ[4];
    int TxSlewRiseAC;
    int TxSlewFallAC;

//-----------------------------------------------------------------------//
    int tWCKPRE_WFR[4];
    int tWCKPRE_RFR[4];
    int tWCKENL_FS[4];
    int tWCKPRE_Static[4];
    int tWCKPRE_toggle_RD[4];
    int tWCKPRE_toggle_WR[4];
    int tWCKPRE_total_WR[4];
    int tWCKPRE_total_RD[4]; 
// Setting the variables
// -------------------------------------------------------------

    bit disable_phyinit;
    bit disable_devinit;
    bit [3:0] disable_write;
    bit [3:0] disable_read;
    bit [3:0] disable_write0;
    bit [3:0] disable_read0;
    bit [3:0] disable_write1;
    bit [3:0] disable_read1;
    bit disable_dfi_lp;
    bit [3:0] disable_freq_change;
    bit disable_lp3;
    bit disable_retention;
    bit disable_pwron;
    bit disable_ate_cfg;
// set for timeout control-------------------------------------------------------------
    int Timeout;

initial begin

if($test$plusargs("debug")) begin
  $value$plusargs("debug=%d", debug);
end

if($test$plusargs("skip_train")) begin
    $value$plusargs("skip_train=%d", skip_train);
end

if($test$plusargs("apb_freq")) begin
    $value$plusargs("apb_freq=%d", apb_freq);
end

if($test$plusargs("tdr_freq")) begin
    $value$plusargs("tdr_freq=%d", tdr_freq);
end




`include "cfg_data.sv"
end

endmodule

