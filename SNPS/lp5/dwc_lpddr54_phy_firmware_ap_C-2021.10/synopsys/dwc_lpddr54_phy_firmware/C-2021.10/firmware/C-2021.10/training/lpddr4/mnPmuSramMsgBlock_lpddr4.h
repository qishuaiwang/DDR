typedef struct _PMU_SMB_LPDDR4_1D_t {
   uint8_t  Reserved00;       // Byte offset 0x00, CSR Addr 0x58000, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  MsgMisc;          // Byte offset 0x01, CSR Addr 0x58000, Direction=In
                              // Contains various global options for training.  
                              // 
                              // Bit fields:
                              // 
                              // MsgMisc[0] MTESTEnable
                              //      0x1 = Pulse primary digital test output bump at the end of each major training stage. This enables observation of training stage completion by observing the digital test output.
                              //      0x0 = Do not pulse primary digital test output bump
                              // 
                              // MsgMisc[1] SimulationOnlyReset
                              //      0x1 = Verilog only simulation option to shorten duration of DRAM reset pulse length to 1ns. 
                              //                Must never be set to 1 in silicon.
                              //      0x0 = Use reset pulse length specifed by JEDEC standard
                              // 
                              // MsgMisc[2] SimulationOnlyTraining
                              //      0x1 = Verilog only simulation option to shorten the duration of the training steps by performing fewer iterations. 
                              //                Must never be set to 1 in silicon.
                              //      0x0 = Use standard training duration.
                              // 
                              // MsgMisc[3] Disable Boot Clock 
                              //      0x1 = Disable boot frequency clock when initializing DRAM. (not recommended)
                              //      0x0 = Use Boot Frequency Clock 
                              // 
                              // MsgMisc[4] Suppress streaming messages, including assertions, regardless of HdtCtrl setting.
                              //            Stage Completion messages, as well as training completion and error messages are
                              //            Still sent depending on HdtCtrl setting.
                              // 
                              // MsgMisc[5] RFU, must be zero
                              // 
                              // MsgMisc[6] Average out WrLvl delay values
                              //      0x1 = FW calculates average of training results across both the ranks and loads this new value to delay CSRs for both ranks, i.e.
                              //            TxDqsDly[db0] = (TxDqsDlyTg0[db0] + TxDqsDlyTg1[db0]) /2 ;
                              //            TxDqsDly[db1] = (TxDqsDlyTg0[db1] + TxDqsDlyTg1[db1]) /2 ;
                              //      0x0 = TxDqsDly delay CSR for each rank has independent value which is based on its training result (default mode)
                              // 
                              // MsgMisc[7] RFU, must be zero
                              // Notes: 
                              // 
                              // - SimulationOnlyReset and SimulationOnlyTraining can be used to speed up simulation run times, and must never be used in real silicon. Some VIPs may have checks on DRAM reset parameters that may need to be disabled when using SimulationOnlyReset.
   uint16_t PmuRevision;      // Byte offset 0x02, CSR Addr 0x58001, Direction=Out
                              // PMU firmware revision ID
                              // After training is run, this address will contain the revision ID of the firmware
   uint8_t  Pstate;           // Byte offset 0x04, CSR Addr 0x58002, Direction=In
                              // Must be set to the target Pstate to be trained 0 -15
                              //  Pstate [7] - when set will use 15 Pstate Mode DMA transfer
   uint8_t  PllBypassEn;      // Byte offset 0x05, CSR Addr 0x58002, Direction=In
                              // Set according to whether target Pstate uses PHY PLL bypass
                              //    0x0 = PHY PLL is enabled for target Pstate
                              //    0x1 = PHY PLL is bypassed for target Pstate
   uint16_t DRAMFreq;         // Byte offset 0x06, CSR Addr 0x58003, Direction=In
                              // DDR data rate for the target Pstate in units of MT/s.
                              // For example enter 0x0640 for DDR1600.
   uint8_t  DfiFreqRatio;     // Byte offset 0x08, CSR Addr 0x58004, Direction=In
                              // Frequency ratio betwen DfiCtlClk and SDRAM memclk.
                              //    0X2 = 1:2
                              //    0x4 = 1:4
   uint8_t  BitTimeControl;   // Byte offset 0x09, CSR Addr 0x58004, Direction=In
                              // BitTimeControl[0-2]:
                              // Input for the amount of data bits 1D/2D WFF/RFF per DQ before deciding if any specific voltage and delay setting passes or fails. Every time this input increases by 1, the number of 1D/2D data comparisons is doubled. The 1D/2D run time will increase proportionally to the number of bit times requested per point.                         
                              // 0 = 2^0 times of basic amount (default behavior)                            
                              // 1 = 2^1 times of basic amount                
                              // 2 = 2^2 times of basic amount      
                              //  . . .                    
                              // 7 = 2^7 times of basic amount
                              // 
                              // [3-7]: RFU, must be zero
   uint16_t Train2DMisc;      // Byte offset 0x0a, CSR Addr 0x58005, Direction=In
                              // 2D Training Miscellaneous Control
                              // 
                              // Bit fields:
                              // Train2DMisc[0]: Print Verbose 2D Eye Contour
                              //   0 = Do Not Print Verbose Eye Contour  (default behavior)
                              //   1 = Print Verbose Eye Contour
                              // 
                              // Train2DMisc[1]: Print Verbose Eye Optimization Output
                              //   0 = Do Not Print Verbose Eye Optimization Output  (default behavior)
                              //   1 = Print Verbose Eye Optimization Output
                              // 
                              // Train2DMisc[5:2]: Iteration Count for Optimization Algorithm
                              // Iteration count = Train2DMisc[5:2] << 1
                              // Iteration count == 0 is default count = 16
                              // iteration count == 2 early termination
                              // 
                              // Train2DMisc[7:6]: Number of Seeds for Optimization Algorithm
                              // 0 = 2 seeds, left and right of center, default behavior
                              // 1 = 1 seed, center seed
                              // 2 = 2 seeds, left and right of center
                              // 3 = 3 seeds, left, center and right
                              // 
                              // Train2DMisc[8]: Print Eye Contours prior to optimization
                              // 0 = Do Not Print Eye Contours prior to optimization (default behavior)
                              // 1 = Print Eye Contours prior to optimization
                              // 
                              // Train2DMisc[9]: Print full eye contours (instead of half)
                              // 0 = Print Half Eye Contours (default behavior)
                              // 1 = Print Full Eye Contours
                              // 
                              // Train2DMisc[10]: Use weighted mean algorithm for optimization of RX compounded eyes with DFE
                              // 0 = Use largest empty circle hill climb (default behavior)
                              // 1 = Use weighted mean
                              // 
                              // Train2DMisc[12:11]: Weighted mean algorithm bias function.
                              // 0 = Use regular weighted mean
                              // 1 = Use weighted mean with voltage squared
                              // 2 = Use weighted mean with log2 voltage
                              // 
                              // Train2DMisc[13]: Override RxVref runtime improvement scheme
                              // 0 = runtime scheme with RxVref range set by VrefStart and Vref End
                              // 1 = runtime speed scheme with range set by number of points before and after Si Friendly trained point
   uint8_t  reserved;         // Byte offset 0x0c, CSR Addr 0x58006, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Misc;             // Byte offset 0x0d, CSR Addr 0x58006, Direction=In
                              // Lp4/5 specific options for training.
                              // 
                              // Bit fields:
                              // 
                              // Misc[0] Enable dfi_reset_n
                              // 
                              // 0x0 = (Recommended) PHY internal registers control BP_MEMRESET_L pin until end of training. 
                              //  See PUB databook for requirement of dfi_reset_n control by MC before 1st dfi_init_start sequence.
                              // 
                              // 0x1 = Enables dfi_reset_n to control BP_MEMRESET_L pin during training. 
                              //  To ensure that no glitches occur on BP_MEMRESET at the end of training, 
                              //  The MC must drive dfi_reset_n=1'b1 prior to starting training and keep its value until the end of training.
                              // 
                              // Misc[1] Enable faster Read and Write training. Not available in all pubs.
                              // 0 : default
                              // 1 : Use faster error count checking
                              // Misc[2] unused
                              // Misc[3] Enable 4UI Si Friendly Scan
                              // 0: 4UI scan
                              // 1: 2UI scan
                              // Misc[4] PRBS Read training seeding
                              // 0: Use si friendly trained result
                              // 1: Use RxReplica Estimate
                              //  Misc[5] Pre Compute RxClk Coarse bit
                              //  0: compute RxClk coarse bit after generating both sets of eyes
                              //  1: estimate RxClk Coarse bit before RxClk training
                              //  Misc[6] Single RxClk scan in SI Friendly Read
                              //  0: Run both RxClkT and RxClkC scan
                              //  1: Run only RxClkT scan  
                              // Misc[7] RFU, must be zero
   int8_t   SIFriendlyDlyOffset; // Byte offset 0x0e, CSR Addr 0x58007, Direction=In
                              // SI Friendly Delay Offset
                              // SIFriendlyDlyOffset[7:1]
                              // This field can be used to modify the trained delay of an eye to be equal to an offset from the edge of that eye for the trained value of the voltage. This can be useful when performing SI friendly 2D training and encountering eye collapse in later training.
                              // SIFriendlyDlyOffset[7:1] = 0  Disable this mechanism
                              // SIFriendlyDlyOffset[7:1] > 0  Add offset to delay left edge of eye
                              // SIFriendlyDlyOffset[7:1] < 0 Subtract offset from delay right edge of eye
                              // 
                              // TruncV
                              // SIFriendlyDlyOffset[0]
                              //    0 = 2D Normal optimization. Treat any point outside of tested eye rectangle as failing.
                              //    1 = If eye is truncated at low voltages treat points at voltages lower than the minimum tested voltage as passing. The trained point will always be at a voltage above the minimum tested voltage.
   uint8_t  CsTestFail;       // Byte offset 0x0f, CSR Addr 0x58007, Direction=Out
                              // This field will be set if training fails on any rank.
                              //    0x0 = No failures
                              //    non-zero = one or more ranks failed training
   uint16_t SequenceCtrl;     // Byte offset 0x10, CSR Addr 0x58008, Direction=In
                              // Controls the training steps to be run. Each bit corresponds to a training step. 
                              // 
                              // If the bit is set to 1, the training step will run. 
                              // If the bit is set to 0, the training step will be skipped.
                              // 
                              // Training step to bit mapping:
                              //    SequenceCtrl[0] = Run DevInit - Device/phy initialization. Should always be set.
                              //    SequenceCtrl[1] = Run WrLvl - Write leveling
                              //    SequenceCtrl[2] = Run RxEn - Read gate training
                              //    SequenceCtrl[3] = Run RdDQS - read dqs training
                              //    SequenceCtrl[4] = Run WrDq - write dq training
                              //    SequenceCtrl[8-5] = RFU, must be zero
                              //    SequenceCtrl[9] = Run MxRdLat - Max read latency training
                              //    SequenceCtrl[11-10] = RFU, must be zero
                              //    SequenceCtrl[12] = Run LPCA - CA Training
                              //    SequenceCtrl[15-13] = RFU, must be zero
   uint8_t  HdtCtrl;          // Byte offset 0x12, CSR Addr 0x58009, Direction=In
                              // To control the total number of debug messages, a verbosity subfield (HdtCtrl, Hardware Debug Trace Control) exists in the message block. Every message has a verbosity level associated with it, and as the HdtCtrl value is increased, less important s messages stop being sent through the mailboxes. The meanings of several major HdtCtrl thresholds are explained below:
                              // 
                              //    0x05 = Detailed debug messages (e.g. Eye delays)
                              //    0x0A = Coarse debug messages (e.g. rank information)
                              //    0xC8 = Stage completion
                              //    0xC9 = Assertion messages
                              //    0xFF = Firmware completion messages only
                              // 
                              // See Training App Note for more detailed information on what messages are included for each threshold.
                              // 
   uint8_t  Reserved13;       // Byte offset 0x13, CSR Addr 0x58009, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint16_t InternalStatus;   // Byte offset 0x14, CSR Addr 0x5800a, Direction=Out
                              // RFU
   uint8_t  DFIMRLMargin;     // Byte offset 0x16, CSR Addr 0x5800b, Direction=In
                              // Margin added to smallest passing trained DFI Max Read Latency value, in units of DFI clocks. Recommended to be >= 1. See the Training App Note for more details on the training process and the use of this value.
                              // 
                              // This margin must include the maximum positive drift expected in tDQSCK over the target temperature and voltage range of the users system.
   uint8_t  TX2D_Delay_Weight; // Byte offset 0x17, CSR Addr 0x5800b, Direction=In
                              // [0-4] 0 ... 31
                              // During TX 2D training when finding an eye center the delay and voltage components are weighed such that the combined margin is delay margin * TX_Delay_Weight2D + voltage margin * TX_Voltage_Weight2D. Either weight may be zero but if both are zero each weight is taken to have a value of one.
   uint8_t  TX2D_Voltage_Weight; // Byte offset 0x18, CSR Addr 0x5800c, Direction=In
                              // [0-4] 0 ... 31
                              // During TX 2D training when finding an eye center the delay and voltage components are weighed such that the combined margin is delay margin * TX_Delay_Weight2D + voltage margin * TX_Voltage_Weight2D. Either weight may be zero but if both are zero each weight is taken to have a value of one.
   uint8_t  Quickboot;        // Byte offset 0x19, CSR Addr 0x5800c, Direction=In
                              // Reserved
   uint8_t  Reserved1A;       // Byte offset 0x1a, CSR Addr 0x5800d, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  CATrainOpt;       // Byte offset 0x1b, CSR Addr 0x5800d, Direction=In
                              // CA training option bit field
                              // [0] CA VREF Training
                              //        1 = Enable CA VREF Training
                              //        0 = Disable CA VREF Training
                              // [1-2] RFU must be zero
                              // [3] Delayed clock feature
                              //        0 = Use delayed clock
                              //        1 = Use normal clock
                              //  [4-7] Value by which ACTxDly is to be incremented during CA/CS training:
                              //       If bit 7 is set, delay is incremented by 8,
                              //       If bit 6 is set, delay is incremented by 4,
                              //       if bit 5 is set, delay is incremented by 2
                              //       else delay is incremented by 1
                              //       This helps in reducing test run time during simulations. For silicon, it is recommended to increment delay by steps of 1 only
   uint8_t  X8Mode;           // Byte offset 0x1c, CSR Addr 0x5800e, Direction=In
                              // X8Mode is encoded as a bit field for channel and rank. 
                              // Bit = 0 means x16 devices are connected. 
                              // Bit = 1 means 2 x8 devices are connected. 
                              // 
                              // X8Mode [0] - Channel A Rank 0
                              // X8Mode [1] - Channel A Rank 1
                              // X8Mode [2] - Channel B Rank 0
                              // X8Mode [3] - Channel B Rank 1
                              // 
   uint8_t  RX2D_TrainOpt;    // Byte offset 0x1d, CSR Addr 0x5800e, Direction=In
                              // RFU
   uint8_t  TX2D_TrainOpt;    // Byte offset 0x1e, CSR Addr 0x5800f, Direction=In
                              // RFU
   uint8_t  Reserved1F;       // Byte offset 0x1f, CSR Addr 0x5800f, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  RX2D_Delay_Weight; // Byte offset 0x20, CSR Addr 0x58010, Direction=In
                              // [0-4] 0 ... 31
                              // During RX 2D training when finding an eye center the delay and voltage components are weighed such that the combined margin is delay margin * RX_Delay_Weight2D + voltage margin * RX_Voltage_Weight2D. Either weight may be zero but if both are zero each weight is taken to have a value of one.
   uint8_t  RX2D_Voltage_Weight; // Byte offset 0x21, CSR Addr 0x58010, Direction=In
                              // [0-4] 0 ... 31
                              // During RX 2D training when finding an eye center the delay and voltage components are weighed such that the combined margin is delay margin * RX_Delay_Weight2D + voltage margin * RX_Voltage_Weight2D. Either weight may be zero but if both are zero each weight is taken to have a value of one.
   uint8_t  Reserved22;       // Byte offset 0x22, CSR Addr 0x58011, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved23;       // Byte offset 0x23, CSR Addr 0x58011, Direction=
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  EnabledDQsChA;    // Byte offset 0x24, CSR Addr 0x58012, Direction=In
                              // Total number of DQ bits enabled in PHY Channel A
   uint8_t  CsPresentChA;     // Byte offset 0x25, CSR Addr 0x58012, Direction=In
                              // Indicates presence of DRAM at each chip select for PHY channel A.
                              // 
                              //  0x1 = CS0 is populated with DRAM
                              //  0x3 = CS0 and CS1 are populated with DRAM
                              // 
                              // All other encodings are illegal
                              //  
   int8_t   CDD_ChA_RR_1_0;   // Byte offset 0x26, CSR Addr 0x58013, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RR_0_1;   // Byte offset 0x27, CSR Addr 0x58013, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_1_1;   // Byte offset 0x28, CSR Addr 0x58014, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_1_0;   // Byte offset 0x29, CSR Addr 0x58014, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_0_1;   // Byte offset 0x2a, CSR Addr 0x58015, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_RW_0_0;   // Byte offset 0x2b, CSR Addr 0x58015, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs0 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_1_1;   // Byte offset 0x2c, CSR Addr 0x58016, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_1_0;   // Byte offset 0x2d, CSR Addr 0x58016, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_0_1;   // Byte offset 0x2e, CSR Addr 0x58017, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WR_0_0;   // Byte offset 0x2f, CSR Addr 0x58017, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WW_1_0;   // Byte offset 0x30, CSR Addr 0x58018, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 1 to cs 0 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChA_WW_0_1;   // Byte offset 0x31, CSR Addr 0x58018, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 0 to cs 1 on Channel A
                              // See PUB Databook section 8.2 for details on use of CDD values.
   uint8_t  MR1_A0;           // Byte offset 0x32, CSR Addr 0x58019, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel A, Rank 0}
   uint8_t  MR2_A0;           // Byte offset 0x33, CSR Addr 0x58019, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel A, Rank 0}
   uint8_t  MR3_A0;           // Byte offset 0x34, CSR Addr 0x5801a, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel A, Rank 0}
   uint8_t  MR4_A0;           // Byte offset 0x35, CSR Addr 0x5801a, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel A, Rank 0}
   uint8_t  MR11_A0;          // Byte offset 0x36, CSR Addr 0x5801b, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel A, Rank 0}
   uint8_t  MR12_A0;          // Byte offset 0x37, CSR Addr 0x5801b, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel A, Rank 0}
   uint8_t  MR13_A0;          // Byte offset 0x38, CSR Addr 0x5801c, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel A, Rank 0}
   uint8_t  MR14_A0;          // Byte offset 0x39, CSR Addr 0x5801c, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel A, Rank 0}
   uint8_t  MR16_A0;          // Byte offset 0x3a, CSR Addr 0x5801d, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel A, Rank 0}
   uint8_t  MR17_A0;          // Byte offset 0x3b, CSR Addr 0x5801d, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel A, Rank 0}
   uint8_t  MR22_A0;          // Byte offset 0x3c, CSR Addr 0x5801e, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel A, Rank 0}
   uint8_t  MR24_A0;          // Byte offset 0x3d, CSR Addr 0x5801e, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel A, Rank 0}
   uint8_t  MR1_A1;           // Byte offset 0x3e, CSR Addr 0x5801f, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel A, Rank 1}
   uint8_t  MR2_A1;           // Byte offset 0x3f, CSR Addr 0x5801f, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel A, Rank 1}
   uint8_t  MR3_A1;           // Byte offset 0x40, CSR Addr 0x58020, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel A, Rank 1}
   uint8_t  MR4_A1;           // Byte offset 0x41, CSR Addr 0x58020, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel A, Rank 1}
   uint8_t  MR11_A1;          // Byte offset 0x42, CSR Addr 0x58021, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel A, Rank 1}
   uint8_t  MR12_A1;          // Byte offset 0x43, CSR Addr 0x58021, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel A, Rank 1}
   uint8_t  MR13_A1;          // Byte offset 0x44, CSR Addr 0x58022, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel A, Rank 1}
   uint8_t  MR14_A1;          // Byte offset 0x45, CSR Addr 0x58022, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel A, Rank 1}
   uint8_t  MR16_A1;          // Byte offset 0x46, CSR Addr 0x58023, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel A, Rank 1}
   uint8_t  MR17_A1;          // Byte offset 0x47, CSR Addr 0x58023, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel A, Rank 1}
   uint8_t  MR22_A1;          // Byte offset 0x48, CSR Addr 0x58024, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel A, Rank 1}
   uint8_t  MR24_A1;          // Byte offset 0x49, CSR Addr 0x58024, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel A, Rank 1}
   uint8_t  CATerminatingRankChA; // Byte offset 0x4a, CSR Addr 0x58025, Direction=In
                              // Terminating Rank for CA bus on Channel A
                              //    0x0 = Rank 0 is terminating rank
                              //    0x1 = Rank 1 is terminating rank
   uint8_t  TrainedVREFCA_A0; // Byte offset 0x4b, CSR Addr 0x58025, Direction=Out
                              // Trained CA Vref setting for Ch A Rank 0
   uint8_t  TrainedVREFCA_A1; // Byte offset 0x4c, CSR Addr 0x58026, Direction=Out
                              // Trained CA Vref setting for Ch A Rank 1
   uint8_t  TrainedVREFDQ_A0; // Byte offset 0x4d, CSR Addr 0x58026, Direction=Out
                              // Trained DQ Vref setting for Ch A Rank 0
   uint8_t  TrainedVREFDQ_A1; // Byte offset 0x4e, CSR Addr 0x58027, Direction=Out
                              // Trained DQ Vref setting for Ch A Rank 1
   uint8_t  RxClkDly_Margin_A0; // Byte offset 0x4f, CSR Addr 0x58027, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  VrefDac_Margin_A0; // Byte offset 0x50, CSR Addr 0x58028, Direction=Out
                              // Distance from the trained center to the closest failing region in phy DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  TxDqDly_Margin_A0; // Byte offset 0x51, CSR Addr 0x58028, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  DeviceVref_Margin_A0; // Byte offset 0x52, CSR Addr 0x58029, Direction=Out
                              // Distance from the trained center to the closest failing region in device DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  RxClkDly_Margin_A1; // Byte offset 0x53, CSR Addr 0x58029, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  VrefDac_Margin_A1; // Byte offset 0x54, CSR Addr 0x5802a, Direction=Out
                              // Distance from the trained center to the closest failing region in phy DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  TxDqDly_Margin_A1; // Byte offset 0x55, CSR Addr 0x5802a, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  DeviceVref_Margin_A1; // Byte offset 0x56, CSR Addr 0x5802b, Direction=Out
                              // Distance from the trained center to the closest failing region in device DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  EnabledDQsChB;    // Byte offset 0x57, CSR Addr 0x5802b, Direction=In
                              // Total number of DQ bits enabled in PHY Channel B
   uint8_t  CsPresentChB;     // Byte offset 0x58, CSR Addr 0x5802c, Direction=In
                              // Indicates presence of DRAM at each chip select for PHY channel B.
                              // 
                              //    0x0 = No chip selects are populated with DRAM
                              //    0x1 = CS0 is populated with DRAM
                              //    0x3 = CS0 and CS1 are populated with DRAM
                              // 
                              // All other encodings are illegal
                              //  
   int8_t   CDD_ChB_RR_1_0;   // Byte offset 0x59, CSR Addr 0x5802c, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RR_0_1;   // Byte offset 0x5a, CSR Addr 0x5802d, Direction=Out
                              // This is a signed integer value.
                              // Read to read critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_1_1;   // Byte offset 0x5b, CSR Addr 0x5802d, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_1_0;   // Byte offset 0x5c, CSR Addr 0x5802e, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_0_1;   // Byte offset 0x5d, CSR Addr 0x5802e, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_RW_0_0;   // Byte offset 0x5e, CSR Addr 0x5802f, Direction=Out
                              // This is a signed integer value.
                              // Read to write critical delay difference from cs01 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_1_1;   // Byte offset 0x5f, CSR Addr 0x5802f, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_1_0;   // Byte offset 0x60, CSR Addr 0x58030, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_0_1;   // Byte offset 0x61, CSR Addr 0x58030, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WR_0_0;   // Byte offset 0x62, CSR Addr 0x58031, Direction=Out
                              // This is a signed integer value.
                              // Write  to read critical delay difference from cs 0 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WW_1_0;   // Byte offset 0x63, CSR Addr 0x58031, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 1 to cs 0 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   int8_t   CDD_ChB_WW_0_1;   // Byte offset 0x64, CSR Addr 0x58032, Direction=Out
                              // This is a signed integer value.
                              // Write  to write critical delay difference from cs 0 to cs 1 on Channel B
                              // See PUB Databook section 8.2 for details on use of CDD values.
   uint8_t  MR1_B0;           // Byte offset 0x65, CSR Addr 0x58032, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel B, Rank 0}
   uint8_t  MR2_B0;           // Byte offset 0x66, CSR Addr 0x58033, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel B, Rank 0}
   uint8_t  MR3_B0;           // Byte offset 0x67, CSR Addr 0x58033, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel B, Rank 0}
   uint8_t  MR4_B0;           // Byte offset 0x68, CSR Addr 0x58034, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel B, Rank 0}
   uint8_t  MR11_B0;          // Byte offset 0x69, CSR Addr 0x58034, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel B, Rank 0}
   uint8_t  MR12_B0;          // Byte offset 0x6a, CSR Addr 0x58035, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel B, Rank 0}
   uint8_t  MR13_B0;          // Byte offset 0x6b, CSR Addr 0x58035, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel B, Rank 0}
   uint8_t  MR14_B0;          // Byte offset 0x6c, CSR Addr 0x58036, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel B, Rank 0}
   uint8_t  MR16_B0;          // Byte offset 0x6d, CSR Addr 0x58036, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel B, Rank 0}
   uint8_t  MR17_B0;          // Byte offset 0x6e, CSR Addr 0x58037, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel B, Rank 0}
   uint8_t  MR22_B0;          // Byte offset 0x6f, CSR Addr 0x58037, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel B, Rank 0}
   uint8_t  MR24_B0;          // Byte offset 0x70, CSR Addr 0x58038, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel B, Rank 0}
   uint8_t  MR1_B1;           // Byte offset 0x71, CSR Addr 0x58038, Direction=In
                              // Value to be programmed in DRAM Mode Register 1 {Channel B, Rank 1}
   uint8_t  MR2_B1;           // Byte offset 0x72, CSR Addr 0x58039, Direction=In
                              // Value to be programmed in DRAM Mode Register 2 {Channel B, Rank 1}
   uint8_t  MR3_B1;           // Byte offset 0x73, CSR Addr 0x58039, Direction=In
                              // Value to be programmed in DRAM Mode Register 3 {Channel B, Rank 1}
   uint8_t  MR4_B1;           // Byte offset 0x74, CSR Addr 0x5803a, Direction=In
                              // Value to be programmed in DRAM Mode Register 4 {Channel B, Rank 1}
   uint8_t  MR11_B1;          // Byte offset 0x75, CSR Addr 0x5803a, Direction=In
                              // Value to be programmed in DRAM Mode Register 11 {Channel B, Rank 1}
   uint8_t  MR12_B1;          // Byte offset 0x76, CSR Addr 0x5803b, Direction=In
                              // Value to be programmed in DRAM Mode Register 12 {Channel B, Rank 1}
   uint8_t  MR13_B1;          // Byte offset 0x77, CSR Addr 0x5803b, Direction=In
                              // Value to be programmed in DRAM Mode Register 13 {Channel B, Rank 1}
   uint8_t  MR14_B1;          // Byte offset 0x78, CSR Addr 0x5803c, Direction=In
                              // Value to be programmed in DRAM Mode Register 14 {Channel B, Rank 1}
   uint8_t  MR16_B1;          // Byte offset 0x79, CSR Addr 0x5803c, Direction=In
                              // Value to be programmed in DRAM Mode Register 16 {Channel B, Rank 1}
   uint8_t  MR17_B1;          // Byte offset 0x7a, CSR Addr 0x5803d, Direction=In
                              // Value to be programmed in DRAM Mode Register 17 {Channel B, Rank 1}
   uint8_t  MR22_B1;          // Byte offset 0x7b, CSR Addr 0x5803d, Direction=In
                              // Value to be programmed in DRAM Mode Register 22 {Channel B, Rank 1}
   uint8_t  MR24_B1;          // Byte offset 0x7c, CSR Addr 0x5803e, Direction=In
                              // Value to be programmed in DRAM Mode Register 24 {Channel B, Rank 1}
   uint8_t  CATerminatingRankChB; // Byte offset 0x7d, CSR Addr 0x5803e, Direction=In
                              // Terminating Rank for CA bus on Channel B
                              //    0x0 = Rank 0 is terminating rank
                              //    0x1 = Rank 1 is terminating rank
   uint8_t  TrainedVREFCA_B0; // Byte offset 0x7e, CSR Addr 0x5803f, Direction=Out
                              // Trained CA Vref setting for Ch B Rank 0
   uint8_t  TrainedVREFCA_B1; // Byte offset 0x7f, CSR Addr 0x5803f, Direction=Out
                              // Trained CA Vref setting for Ch B Rank 1
   uint8_t  TrainedVREFDQ_B0; // Byte offset 0x80, CSR Addr 0x58040, Direction=Out
                              // Trained DQ Vref setting for Ch B Rank 0
   uint8_t  TrainedVREFDQ_B1; // Byte offset 0x81, CSR Addr 0x58040, Direction=Out
                              // Trained DQ Vref setting for Ch B Rank 1
   uint8_t  RxClkDly_Margin_B0; // Byte offset 0x82, CSR Addr 0x58041, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  VrefDac_Margin_B0; // Byte offset 0x83, CSR Addr 0x58041, Direction=Out
                              // Distance from the trained center to the closest failing region in phy DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  TxDqDly_Margin_B0; // Byte offset 0x84, CSR Addr 0x58042, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  DeviceVref_Margin_B0; // Byte offset 0x85, CSR Addr 0x58042, Direction=Out
                              // Distance from the trained center to the closest failing region in device DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  RxClkDly_Margin_B1; // Byte offset 0x86, CSR Addr 0x58043, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  VrefDac_Margin_B1; // Byte offset 0x87, CSR Addr 0x58043, Direction=Out
                              // Distance from the trained center to the closest failing region in phy DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  TxDqDly_Margin_B1; // Byte offset 0x88, CSR Addr 0x58044, Direction=Out
                              // Distance from the trained center to the closest failing region in DLL steps. This value is the minimum of all eyes in this timing group.
   uint8_t  DeviceVref_Margin_B1; // Byte offset 0x89, CSR Addr 0x58044, Direction=Out
                              // Distance from the trained center to the closest failing region in device DAC steps. This value is the minimum of all eyes in this timing group.
   uint8_t  MR21_A0;          // Byte offset 0x8a, CSR Addr 0x58045, Direction=In
                              // Value to be programmed in DRAM Mode Register 21 {Channel A, Rank 0}
   uint8_t  MR51_A0;          // Byte offset 0x8b, CSR Addr 0x58045, Direction=In
                              // Value to be programmed in DRAM Mode Register 51 {Channel A, Rank 0}
   uint8_t  MR21_A1;          // Byte offset 0x8c, CSR Addr 0x58046, Direction=In
                              // Value to be programmed in DRAM Mode Register 21 {Channel A, Rank 1}
   uint8_t  MR51_A1;          // Byte offset 0x8d, CSR Addr 0x58046, Direction=In
                              // Value to be programmed in DRAM Mode Register 51 {Channel A, Rank 1}
   uint8_t  MR21_B0;          // Byte offset 0x8e, CSR Addr 0x58047, Direction=In
                              // Value to be programmed in DRAM Mode Register 21 {Channel B, Rank 0}
   uint8_t  MR51_B0;          // Byte offset 0x8f, CSR Addr 0x58047, Direction=In
                              // Value to be programmed in DRAM Mode Register 51 {Channel B, Rank 0}
   uint8_t  MR21_B1;          // Byte offset 0x90, CSR Addr 0x58048, Direction=In
                              // Value to be programmed in DRAM Mode Register 21 {Channel B, Rank 1}
   uint8_t  MR51_B1;          // Byte offset 0x91, CSR Addr 0x58048, Direction=In
                              // Value to be programmed in DRAM Mode Register 51 {Channel B. Rank 1}
   uint8_t  LP4XMode;         // Byte offset 0x92, CSR Addr 0x58049, Direction=In
                              // Must be Set if DRAM supports LP4X
   uint8_t  Disable2D;        // Byte offset 0x93, CSR Addr 0x58049, Direction=In
                              // Set to disable 2D training
                              // When this field is set to 1, it is not recommended to set RxDfeMode to DFE enabled with 1 previous bit lookup
   uint8_t  VrefSamples;      // Byte offset 0x94, CSR Addr 0x5804a, Direction=In
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ALT_RL;           // Byte offset 0x95, CSR Addr 0x5804a, Direction=In
                              // This is the alternate Read Latency for DBI off
   uint8_t  MAIN_RL;          // Byte offset 0x96, CSR Addr 0x5804b, Direction=In
                              // This is the main RL calculated by phyinit
   uint8_t  RdWrPatternA;     // Byte offset 0x97, CSR Addr 0x5804b, Direction=In
                              // Lower-byte read and write pattern for training 
                              // When set to 0 uses default patterns
   uint8_t  RdWrPatternB;     // Byte offset 0x98, CSR Addr 0x5804c, Direction=In
                              // Upper-byte read and write pattern for training 
                              // When set to 0 uses default patterns
   uint8_t  RdWrInvert;       // Byte offset 0x99, CSR Addr 0x5804c, Direction=In
                              // Per-byte per bit  invert for read and write pattern for training 
                              // When RdWrPatternA and RdWrPatternB = 0 this is unused
   uint8_t  LdffMode;         // Byte offset 0x9a, CSR Addr 0x5804d, Direction=In
                              // In LDFF mode raw PATN/PRBS sequences driven on DBI & EDC  lanes. If this is set to 0 pattern follows MR settings
                              // [0] = 1 Force DBI like patterns on all lanes
                              // [1] = 1 Force non DBI patterns on all lanes
   uint8_t  Reserved9B;       // Byte offset 0x9b, CSR Addr 0x5804d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint16_t FCDfi0AcsmStart;  // Byte offset 0x9c, CSR Addr 0x5804e, Direction=In
                              // Start Address for MRW commands for DFI0
   uint16_t FCDfi1AcsmStart;  // Byte offset 0x9e, CSR Addr 0x5804f, Direction=In
                              // Start Address for MRW commands for DFI1
   uint16_t FCDfi0AcsmStartPSY; // Byte offset 0xa0, CSR Addr 0x58050, Direction=In
                              // Start Address for MRW commands for DFI0 for the previous PState
   uint16_t FCDfi1AcsmStartPSY; // Byte offset 0xa2, CSR Addr 0x58051, Direction=In
                              // Start Address for MRW commands for DFI1 for the previous PState
   uint16_t FCDMAStartMR;     // Byte offset 0xa4, CSR Addr 0x58052, Direction=In
                              // Start DMA Address for FCDfi0AcsmStart
   uint16_t FCDMAStartCsr;    // Byte offset 0xa6, CSR Addr 0x58053, Direction=In
                              // Start DMA Address for Starting CSR
   uint8_t  EnCustomSettings; // Byte offset 0xa8, CSR Addr 0x58054, Direction=In
                              // Enable Custome TxSlew and TxImpedance Settings
                              // 
                              // When this field is set to 1, the following LS_ values shall be used in the corresponding AC CSRs during low speed operations.
                              // The values are programmed as it is in the CSRs by the firmware, so these should be set very carefully
                              // 
   uint8_t  LS_TxSlewSE0;     // Byte offset 0xa9, CSR Addr 0x58054, Direction=In
                              // Custom Low Speed AC TxSlew for SE0
   uint8_t  LS_TxSlewSE1;     // Byte offset 0xaa, CSR Addr 0x58055, Direction=In
                              // Custom Low Speed AC TxSlew for SE1
   uint8_t  LS_TxSlewDIFF0;   // Byte offset 0xab, CSR Addr 0x58055, Direction=In
                              // Custom Low Speed AC TxSlew for SE1
   uint16_t LS_TxImpedanceDIFF0T; // Byte offset 0xac, CSR Addr 0x58056, Direction=In
                              // Custom Low Speed AC TxImpedance for DIFF0T
   uint16_t LS_TxImpedanceDIFF0C; // Byte offset 0xae, CSR Addr 0x58057, Direction=In
                              // Custom Low Speed AC TxImpedance for DIFF0C
   uint16_t LS_TxImpedanceSE0; // Byte offset 0xb0, CSR Addr 0x58058, Direction=In
                              // Custom Low Speed AC TxImpedance for SE0
   uint16_t LS_TxImpedanceSE1; // Byte offset 0xb2, CSR Addr 0x58059, Direction=In
                              // Custom Low Speed AC TxImpedance for SE1
   uint8_t  VrefInc;          // Byte offset 0xb4, CSR Addr 0x5805a, Direction=In
                              // This field should be programmed to 1
                              // This controls the vrefIncrement size for 2D training
   uint8_t  WrLvlTrainOpt;    // Byte offset 0xb5, CSR Addr 0x5805a, Direction=In
                              // LP4 Write leveling training options. Currently not in use
   uint16_t FCDCCMStartCSR;   // Byte offset 0xb6, CSR Addr 0x5805b, Direction=out
                              // Start Address in DCCM for CSRs to be copied to DMA
   uint16_t FCDCCMLenCSR;     // Byte offset 0xb8, CSR Addr 0x5805c, Direction=out
                              // number of entries written into DCCM for CSRs
   uint16_t FCDCCMStartMR;    // Byte offset 0xba, CSR Addr 0x5805d, Direction=out
                              // Start Address in DCCM for Mrs to be copied to DMA
   uint16_t  FCDCCMLenMR;     // Byte offset 0xbc, CSR Addr 0x5805e, Direction=out
                              // number of entries written into DCCM for Mrs
   uint8_t  ReservedBE;       // Byte offset 0xbe, CSR Addr 0x5805f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedBF;       // Byte offset 0xbf, CSR Addr 0x5805f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC0;       // Byte offset 0xc0, CSR Addr 0x58060, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC1;       // Byte offset 0xc1, CSR Addr 0x58060, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC2;       // Byte offset 0xc2, CSR Addr 0x58061, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC3;       // Byte offset 0xc3, CSR Addr 0x58061, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC4;       // Byte offset 0xc4, CSR Addr 0x58062, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC5;       // Byte offset 0xc5, CSR Addr 0x58062, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC6;       // Byte offset 0xc6, CSR Addr 0x58063, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedC7;       // Byte offset 0xc7, CSR Addr 0x58063, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  RxVrefStartPatDfe0; // Byte offset 0xc8, CSR Addr 0x58064, Direction=In
                              // Starting VREF Value for Rx Training for DFE0 for Pattern Mode
   uint8_t  RxVrefStartPatDfe1; // Byte offset 0xc9, CSR Addr 0x58064, Direction=In
                              // Starting VREF Value for Rx Training for DFE1 for Pattern Mode
   uint8_t  RxVrefStartPrbsDfe0; // Byte offset 0xca, CSR Addr 0x58065, Direction=In
                              // Train2Dmisc[13]= 0, Starting VREF Value for Rx Training for DFE0 for Prbs Mode
                              // Train2Dmisc[13]= 1, number of points to scan before the si friendly trained vref
   uint8_t  RxVrefStartPrbsDfe1; // Byte offset 0xcb, CSR Addr 0x58065, Direction=In
                              // Train2Dmisc[13]= 0, Starting VREF Value for Rx Training for DFE0 for Prbs Mode
                              // Train2Dmisc[13]= 1, number of points to scan before the si friendly trained vref
   uint8_t  TxVrefStart;      // Byte offset 0xcc, CSR Addr 0x58066, Direction=In
                              // Starting VREF Value for Tx Training for Prbs Mode
   uint8_t  RxVrefEndPatDfe0; // Byte offset 0xcd, CSR Addr 0x58066, Direction=In
                              // Ending VREF Value for Rx Training for DFE0 for Pattern Mode
   uint8_t  RxVrefEndPatDfe1; // Byte offset 0xce, CSR Addr 0x58067, Direction=In
                              // Ending VREF Value for Rx Training for DFE1 for Pattern Mode
   uint8_t  RxVrefEndPrbsDfe0; // Byte offset 0xcf, CSR Addr 0x58067, Direction=In
                              // Train2Dmisc[13]= 0,Ending VREF Value for Rx Training for DFE0 for Prbs Mode
                              // Train2Dmisc[13]= 1,Number of points to scan after the si friendly trained vref
   uint8_t  RxVrefEndPrbsDfe1; // Byte offset 0xd0, CSR Addr 0x58068, Direction=In
                              // Train2Dmisc[13]= 0,Ending VREF Value for Rx Training for DFE0 for Prbs Mode
                              // Train2Dmisc[13]= 1,Number of points to scan after the si friendly trained vref
   uint8_t  TxVrefEnd;        // Byte offset 0xd1, CSR Addr 0x58068, Direction=In
                              // Ending VREF Value for Tx Training for Prbs Mode
   uint8_t  RxVrefStepPatDfe0; // Byte offset 0xd2, CSR Addr 0x58069, Direction=In
                              // VREF Step Value for Rx Training for DFE0 for Pattern Mode
   uint8_t  RxVrefStepPatDfe1; // Byte offset 0xd3, CSR Addr 0x58069, Direction=In
                              // VREF Step Value for Rx Training for DFE1 for Pattern Mode
   uint8_t  RxVrefStepPrbsDfe0; // Byte offset 0xd4, CSR Addr 0x5806a, Direction=In
                              // VREF Step Value for Rx Training for DFE0 for Prbs Mode
   uint8_t  RxVrefStepPrbsDfe1; // Byte offset 0xd5, CSR Addr 0x5806a, Direction=In
                              // VREF Step Value for Rx Training for DFE0 for Prbs Mode
   uint8_t  TxVrefStep;       // Byte offset 0xd6, CSR Addr 0x5806b, Direction=In
                              // VREF Step Value for Tx Training for Prbs Mode
   uint8_t  UpperLowerByte;   // Byte offset 0xd7, CSR Addr 0x5806b, Direction=In
                              // UpperLowerByte[3:0] - A value of 0 means partner bytes are not swapped. A value of 1 means partner bytes are swapped.  
                              // [0] : Channel A Rank 0
                              // [1] : Channel A Rank 1
                              // [2] : Channel B Rank 0
                              // [3] : Channel B Rank1
   uint8_t  MRLCalcAdj;       // Byte offset 0xd8, CSR Addr 0x5806c, Direction=In
                              // This field is treated as an int_8 and is added to the intermediate MRL values used in training.
   uint8_t  PPT2OffsetMargin; // Byte offset 0xd9, CSR Addr 0x5806c, Direction=In
                              // When set to 0 disabled, non zero values add that much margin to left and right eye offsets to prevent underflow or overflow.
   uint8_t  ReservedDA;       // Byte offset 0xda, CSR Addr 0x5806d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedDB;       // Byte offset 0xdb, CSR Addr 0x5806d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedDC;       // Byte offset 0xdc, CSR Addr 0x5806e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedDD;       // Byte offset 0xdd, CSR Addr 0x5806e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedDE;       // Byte offset 0xde, CSR Addr 0x5806f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedDF;       // Byte offset 0xdf, CSR Addr 0x5806f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE0;       // Byte offset 0xe0, CSR Addr 0x58070, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE1;       // Byte offset 0xe1, CSR Addr 0x58070, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE2;       // Byte offset 0xe2, CSR Addr 0x58071, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE3;       // Byte offset 0xe3, CSR Addr 0x58071, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE4;       // Byte offset 0xe4, CSR Addr 0x58072, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE5;       // Byte offset 0xe5, CSR Addr 0x58072, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE6;       // Byte offset 0xe6, CSR Addr 0x58073, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE7;       // Byte offset 0xe7, CSR Addr 0x58073, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE8;       // Byte offset 0xe8, CSR Addr 0x58074, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedE9;       // Byte offset 0xe9, CSR Addr 0x58074, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedEA;       // Byte offset 0xea, CSR Addr 0x58075, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedEB;       // Byte offset 0xeb, CSR Addr 0x58075, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedEC;       // Byte offset 0xec, CSR Addr 0x58076, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedED;       // Byte offset 0xed, CSR Addr 0x58076, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedEE;       // Byte offset 0xee, CSR Addr 0x58077, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedEF;       // Byte offset 0xef, CSR Addr 0x58077, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF0;       // Byte offset 0xf0, CSR Addr 0x58078, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF1;       // Byte offset 0xf1, CSR Addr 0x58078, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF2;       // Byte offset 0xf2, CSR Addr 0x58079, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF3;       // Byte offset 0xf3, CSR Addr 0x58079, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF4;       // Byte offset 0xf4, CSR Addr 0x5807a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF5;       // Byte offset 0xf5, CSR Addr 0x5807a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF6;       // Byte offset 0xf6, CSR Addr 0x5807b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF7;       // Byte offset 0xf7, CSR Addr 0x5807b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF8;       // Byte offset 0xf8, CSR Addr 0x5807c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedF9;       // Byte offset 0xf9, CSR Addr 0x5807c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedFA;       // Byte offset 0xfa, CSR Addr 0x5807d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedFB;       // Byte offset 0xfb, CSR Addr 0x5807d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedFC;       // Byte offset 0xfc, CSR Addr 0x5807e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedFD;       // Byte offset 0xfd, CSR Addr 0x5807e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedFE;       // Byte offset 0xfe, CSR Addr 0x5807f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  ReservedFF;       // Byte offset 0xff, CSR Addr 0x5807f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved100;      // Byte offset 0x100, CSR Addr 0x58080, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved101;      // Byte offset 0x101, CSR Addr 0x58080, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved102;      // Byte offset 0x102, CSR Addr 0x58081, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved103;      // Byte offset 0x103, CSR Addr 0x58081, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved104;      // Byte offset 0x104, CSR Addr 0x58082, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved105;      // Byte offset 0x105, CSR Addr 0x58082, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved106;      // Byte offset 0x106, CSR Addr 0x58083, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved107;      // Byte offset 0x107, CSR Addr 0x58083, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved108;      // Byte offset 0x108, CSR Addr 0x58084, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved109;      // Byte offset 0x109, CSR Addr 0x58084, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved10A;      // Byte offset 0x10a, CSR Addr 0x58085, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved10B;      // Byte offset 0x10b, CSR Addr 0x58085, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved10C;      // Byte offset 0x10c, CSR Addr 0x58086, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved10D;      // Byte offset 0x10d, CSR Addr 0x58086, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved10E;      // Byte offset 0x10e, CSR Addr 0x58087, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved10F;      // Byte offset 0x10f, CSR Addr 0x58087, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved110;      // Byte offset 0x110, CSR Addr 0x58088, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved111;      // Byte offset 0x111, CSR Addr 0x58088, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved112;      // Byte offset 0x112, CSR Addr 0x58089, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved113;      // Byte offset 0x113, CSR Addr 0x58089, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved114;      // Byte offset 0x114, CSR Addr 0x5808a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved115;      // Byte offset 0x115, CSR Addr 0x5808a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved116;      // Byte offset 0x116, CSR Addr 0x5808b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved117;      // Byte offset 0x117, CSR Addr 0x5808b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved118;      // Byte offset 0x118, CSR Addr 0x5808c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved119;      // Byte offset 0x119, CSR Addr 0x5808c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved11A;      // Byte offset 0x11a, CSR Addr 0x5808d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved11B;      // Byte offset 0x11b, CSR Addr 0x5808d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved11C;      // Byte offset 0x11c, CSR Addr 0x5808e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved11D;      // Byte offset 0x11d, CSR Addr 0x5808e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved11E;      // Byte offset 0x11e, CSR Addr 0x5808f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved11F;      // Byte offset 0x11f, CSR Addr 0x5808f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved120;      // Byte offset 0x120, CSR Addr 0x58090, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved121;      // Byte offset 0x121, CSR Addr 0x58090, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved122;      // Byte offset 0x122, CSR Addr 0x58091, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved123;      // Byte offset 0x123, CSR Addr 0x58091, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved124;      // Byte offset 0x124, CSR Addr 0x58092, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved125;      // Byte offset 0x125, CSR Addr 0x58092, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved126;      // Byte offset 0x126, CSR Addr 0x58093, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  RxDlyScanShiftRank0Byte0; // Byte offset 0x127, CSR Addr 0x58093, Direction=In
                              // Rx delay scan shift for Rank0 Dbyte0.  Examples:
                              //   0x1 - start scan 1 step earlier
                              //   0xf - start scan 15 steps earlier
                              //   0xff - start scan 1 step later
                              //   0xfe - start scan 2 steps later
   uint8_t  RxDlyScanShiftRank0Byte1; // Byte offset 0x128, CSR Addr 0x58094, Direction=In
                              // Rx delay scan shift for Rank0 Dbyte1
   uint8_t  RxDlyScanShiftRank0Byte2; // Byte offset 0x129, CSR Addr 0x58094, Direction=In
                              // Rx delay scan shift for Rank0 Dbyte2
   uint8_t  RxDlyScanShiftRank0Byte3; // Byte offset 0x12a, CSR Addr 0x58095, Direction=In
                              // Rx delay scan shift for Rank0 Dbyte3
   uint8_t  RxDlyScanShiftRank1Byte0; // Byte offset 0x12b, CSR Addr 0x58095, Direction=In
                              // Rx delay scan shift for Rank1 Dbyte0
   uint8_t  RxDlyScanShiftRank1Byte1; // Byte offset 0x12c, CSR Addr 0x58096, Direction=In
                              // Rx delay scan shift for Rank1 Dbyte1
   uint8_t  RxDlyScanShiftRank1Byte2; // Byte offset 0x12d, CSR Addr 0x58096, Direction=In
                              // Rx delay scan shift for Rank1 Dbyte2
   uint8_t  RxDlyScanShiftRank1Byte3; // Byte offset 0x12e, CSR Addr 0x58097, Direction=In
                              // Rx delay scan shift for Rank1 Dbyte3
   uint8_t  Reserved12F;      // Byte offset 0x12f, CSR Addr 0x58097, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved130;      // Byte offset 0x130, CSR Addr 0x58098, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved131;      // Byte offset 0x131, CSR Addr 0x58098, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved132;      // Byte offset 0x132, CSR Addr 0x58099, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved133;      // Byte offset 0x133, CSR Addr 0x58099, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved134;      // Byte offset 0x134, CSR Addr 0x5809a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved135;      // Byte offset 0x135, CSR Addr 0x5809a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved136;      // Byte offset 0x136, CSR Addr 0x5809b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved137;      // Byte offset 0x137, CSR Addr 0x5809b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved138;      // Byte offset 0x138, CSR Addr 0x5809c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved139;      // Byte offset 0x139, CSR Addr 0x5809c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved13A;      // Byte offset 0x13a, CSR Addr 0x5809d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved13B;      // Byte offset 0x13b, CSR Addr 0x5809d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved13C;      // Byte offset 0x13c, CSR Addr 0x5809e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved13D;      // Byte offset 0x13d, CSR Addr 0x5809e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved13E;      // Byte offset 0x13e, CSR Addr 0x5809f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved13F;      // Byte offset 0x13f, CSR Addr 0x5809f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved140;      // Byte offset 0x140, CSR Addr 0x580a0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved141;      // Byte offset 0x141, CSR Addr 0x580a0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved142;      // Byte offset 0x142, CSR Addr 0x580a1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved143;      // Byte offset 0x143, CSR Addr 0x580a1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved144;      // Byte offset 0x144, CSR Addr 0x580a2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved145;      // Byte offset 0x145, CSR Addr 0x580a2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved146;      // Byte offset 0x146, CSR Addr 0x580a3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved147;      // Byte offset 0x147, CSR Addr 0x580a3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved148;      // Byte offset 0x148, CSR Addr 0x580a4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved149;      // Byte offset 0x149, CSR Addr 0x580a4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved14A;      // Byte offset 0x14a, CSR Addr 0x580a5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved14B;      // Byte offset 0x14b, CSR Addr 0x580a5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved14C;      // Byte offset 0x14c, CSR Addr 0x580a6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved14D;      // Byte offset 0x14d, CSR Addr 0x580a6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved14E;      // Byte offset 0x14e, CSR Addr 0x580a7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved14F;      // Byte offset 0x14f, CSR Addr 0x580a7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved150;      // Byte offset 0x150, CSR Addr 0x580a8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved151;      // Byte offset 0x151, CSR Addr 0x580a8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved152;      // Byte offset 0x152, CSR Addr 0x580a9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved153;      // Byte offset 0x153, CSR Addr 0x580a9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved154;      // Byte offset 0x154, CSR Addr 0x580aa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved155;      // Byte offset 0x155, CSR Addr 0x580aa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved156;      // Byte offset 0x156, CSR Addr 0x580ab, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved157;      // Byte offset 0x157, CSR Addr 0x580ab, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved158;      // Byte offset 0x158, CSR Addr 0x580ac, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved159;      // Byte offset 0x159, CSR Addr 0x580ac, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved15A;      // Byte offset 0x15a, CSR Addr 0x580ad, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved15B;      // Byte offset 0x15b, CSR Addr 0x580ad, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved15C;      // Byte offset 0x15c, CSR Addr 0x580ae, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved15D;      // Byte offset 0x15d, CSR Addr 0x580ae, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved15E;      // Byte offset 0x15e, CSR Addr 0x580af, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved15F;      // Byte offset 0x15f, CSR Addr 0x580af, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved160;      // Byte offset 0x160, CSR Addr 0x580b0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved161;      // Byte offset 0x161, CSR Addr 0x580b0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved162;      // Byte offset 0x162, CSR Addr 0x580b1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved163;      // Byte offset 0x163, CSR Addr 0x580b1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved164;      // Byte offset 0x164, CSR Addr 0x580b2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved165;      // Byte offset 0x165, CSR Addr 0x580b2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved166;      // Byte offset 0x166, CSR Addr 0x580b3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved167;      // Byte offset 0x167, CSR Addr 0x580b3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved168;      // Byte offset 0x168, CSR Addr 0x580b4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved169;      // Byte offset 0x169, CSR Addr 0x580b4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved16A;      // Byte offset 0x16a, CSR Addr 0x580b5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved16B;      // Byte offset 0x16b, CSR Addr 0x580b5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved16C;      // Byte offset 0x16c, CSR Addr 0x580b6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved16D;      // Byte offset 0x16d, CSR Addr 0x580b6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved16E;      // Byte offset 0x16e, CSR Addr 0x580b7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved16F;      // Byte offset 0x16f, CSR Addr 0x580b7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved170;      // Byte offset 0x170, CSR Addr 0x580b8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved171;      // Byte offset 0x171, CSR Addr 0x580b8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved172;      // Byte offset 0x172, CSR Addr 0x580b9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved173;      // Byte offset 0x173, CSR Addr 0x580b9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved174;      // Byte offset 0x174, CSR Addr 0x580ba, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved175;      // Byte offset 0x175, CSR Addr 0x580ba, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved176;      // Byte offset 0x176, CSR Addr 0x580bb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved177;      // Byte offset 0x177, CSR Addr 0x580bb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved178;      // Byte offset 0x178, CSR Addr 0x580bc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved179;      // Byte offset 0x179, CSR Addr 0x580bc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved17A;      // Byte offset 0x17a, CSR Addr 0x580bd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved17B;      // Byte offset 0x17b, CSR Addr 0x580bd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved17C;      // Byte offset 0x17c, CSR Addr 0x580be, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved17D;      // Byte offset 0x17d, CSR Addr 0x580be, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved17E;      // Byte offset 0x17e, CSR Addr 0x580bf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved17F;      // Byte offset 0x17f, CSR Addr 0x580bf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved180;      // Byte offset 0x180, CSR Addr 0x580c0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved181;      // Byte offset 0x181, CSR Addr 0x580c0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved182;      // Byte offset 0x182, CSR Addr 0x580c1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved183;      // Byte offset 0x183, CSR Addr 0x580c1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved184;      // Byte offset 0x184, CSR Addr 0x580c2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved185;      // Byte offset 0x185, CSR Addr 0x580c2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved186;      // Byte offset 0x186, CSR Addr 0x580c3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved187;      // Byte offset 0x187, CSR Addr 0x580c3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved188;      // Byte offset 0x188, CSR Addr 0x580c4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved189;      // Byte offset 0x189, CSR Addr 0x580c4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved18A;      // Byte offset 0x18a, CSR Addr 0x580c5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved18B;      // Byte offset 0x18b, CSR Addr 0x580c5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved18C;      // Byte offset 0x18c, CSR Addr 0x580c6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved18D;      // Byte offset 0x18d, CSR Addr 0x580c6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved18E;      // Byte offset 0x18e, CSR Addr 0x580c7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved18F;      // Byte offset 0x18f, CSR Addr 0x580c7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved190;      // Byte offset 0x190, CSR Addr 0x580c8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved191;      // Byte offset 0x191, CSR Addr 0x580c8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved192;      // Byte offset 0x192, CSR Addr 0x580c9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved193;      // Byte offset 0x193, CSR Addr 0x580c9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved194;      // Byte offset 0x194, CSR Addr 0x580ca, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved195;      // Byte offset 0x195, CSR Addr 0x580ca, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved196;      // Byte offset 0x196, CSR Addr 0x580cb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved197;      // Byte offset 0x197, CSR Addr 0x580cb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved198;      // Byte offset 0x198, CSR Addr 0x580cc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved199;      // Byte offset 0x199, CSR Addr 0x580cc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved19A;      // Byte offset 0x19a, CSR Addr 0x580cd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved19B;      // Byte offset 0x19b, CSR Addr 0x580cd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved19C;      // Byte offset 0x19c, CSR Addr 0x580ce, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved19D;      // Byte offset 0x19d, CSR Addr 0x580ce, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved19E;      // Byte offset 0x19e, CSR Addr 0x580cf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved19F;      // Byte offset 0x19f, CSR Addr 0x580cf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A0;      // Byte offset 0x1a0, CSR Addr 0x580d0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A1;      // Byte offset 0x1a1, CSR Addr 0x580d0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A2;      // Byte offset 0x1a2, CSR Addr 0x580d1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A3;      // Byte offset 0x1a3, CSR Addr 0x580d1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A4;      // Byte offset 0x1a4, CSR Addr 0x580d2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A5;      // Byte offset 0x1a5, CSR Addr 0x580d2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A6;      // Byte offset 0x1a6, CSR Addr 0x580d3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A7;      // Byte offset 0x1a7, CSR Addr 0x580d3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A8;      // Byte offset 0x1a8, CSR Addr 0x580d4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1A9;      // Byte offset 0x1a9, CSR Addr 0x580d4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1AA;      // Byte offset 0x1aa, CSR Addr 0x580d5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1AB;      // Byte offset 0x1ab, CSR Addr 0x580d5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1AC;      // Byte offset 0x1ac, CSR Addr 0x580d6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1AD;      // Byte offset 0x1ad, CSR Addr 0x580d6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1AE;      // Byte offset 0x1ae, CSR Addr 0x580d7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1AF;      // Byte offset 0x1af, CSR Addr 0x580d7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B0;      // Byte offset 0x1b0, CSR Addr 0x580d8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B1;      // Byte offset 0x1b1, CSR Addr 0x580d8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B2;      // Byte offset 0x1b2, CSR Addr 0x580d9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B3;      // Byte offset 0x1b3, CSR Addr 0x580d9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B4;      // Byte offset 0x1b4, CSR Addr 0x580da, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B5;      // Byte offset 0x1b5, CSR Addr 0x580da, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B6;      // Byte offset 0x1b6, CSR Addr 0x580db, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B7;      // Byte offset 0x1b7, CSR Addr 0x580db, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B8;      // Byte offset 0x1b8, CSR Addr 0x580dc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1B9;      // Byte offset 0x1b9, CSR Addr 0x580dc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1BA;      // Byte offset 0x1ba, CSR Addr 0x580dd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1BB;      // Byte offset 0x1bb, CSR Addr 0x580dd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1BC;      // Byte offset 0x1bc, CSR Addr 0x580de, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1BD;      // Byte offset 0x1bd, CSR Addr 0x580de, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1BE;      // Byte offset 0x1be, CSR Addr 0x580df, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1BF;      // Byte offset 0x1bf, CSR Addr 0x580df, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C0;      // Byte offset 0x1c0, CSR Addr 0x580e0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C1;      // Byte offset 0x1c1, CSR Addr 0x580e0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C2;      // Byte offset 0x1c2, CSR Addr 0x580e1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C3;      // Byte offset 0x1c3, CSR Addr 0x580e1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C4;      // Byte offset 0x1c4, CSR Addr 0x580e2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C5;      // Byte offset 0x1c5, CSR Addr 0x580e2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C6;      // Byte offset 0x1c6, CSR Addr 0x580e3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C7;      // Byte offset 0x1c7, CSR Addr 0x580e3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C8;      // Byte offset 0x1c8, CSR Addr 0x580e4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1C9;      // Byte offset 0x1c9, CSR Addr 0x580e4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1CA;      // Byte offset 0x1ca, CSR Addr 0x580e5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1CB;      // Byte offset 0x1cb, CSR Addr 0x580e5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1CC;      // Byte offset 0x1cc, CSR Addr 0x580e6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1CD;      // Byte offset 0x1cd, CSR Addr 0x580e6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1CE;      // Byte offset 0x1ce, CSR Addr 0x580e7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1CF;      // Byte offset 0x1cf, CSR Addr 0x580e7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D0;      // Byte offset 0x1d0, CSR Addr 0x580e8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D1;      // Byte offset 0x1d1, CSR Addr 0x580e8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D2;      // Byte offset 0x1d2, CSR Addr 0x580e9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D3;      // Byte offset 0x1d3, CSR Addr 0x580e9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D4;      // Byte offset 0x1d4, CSR Addr 0x580ea, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D5;      // Byte offset 0x1d5, CSR Addr 0x580ea, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D6;      // Byte offset 0x1d6, CSR Addr 0x580eb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D7;      // Byte offset 0x1d7, CSR Addr 0x580eb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D8;      // Byte offset 0x1d8, CSR Addr 0x580ec, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1D9;      // Byte offset 0x1d9, CSR Addr 0x580ec, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1DA;      // Byte offset 0x1da, CSR Addr 0x580ed, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1DB;      // Byte offset 0x1db, CSR Addr 0x580ed, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1DC;      // Byte offset 0x1dc, CSR Addr 0x580ee, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1DD;      // Byte offset 0x1dd, CSR Addr 0x580ee, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1DE;      // Byte offset 0x1de, CSR Addr 0x580ef, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1DF;      // Byte offset 0x1df, CSR Addr 0x580ef, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E0;      // Byte offset 0x1e0, CSR Addr 0x580f0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E1;      // Byte offset 0x1e1, CSR Addr 0x580f0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E2;      // Byte offset 0x1e2, CSR Addr 0x580f1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E3;      // Byte offset 0x1e3, CSR Addr 0x580f1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E4;      // Byte offset 0x1e4, CSR Addr 0x580f2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E5;      // Byte offset 0x1e5, CSR Addr 0x580f2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E6;      // Byte offset 0x1e6, CSR Addr 0x580f3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E7;      // Byte offset 0x1e7, CSR Addr 0x580f3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E8;      // Byte offset 0x1e8, CSR Addr 0x580f4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1E9;      // Byte offset 0x1e9, CSR Addr 0x580f4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1EA;      // Byte offset 0x1ea, CSR Addr 0x580f5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1EB;      // Byte offset 0x1eb, CSR Addr 0x580f5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1EC;      // Byte offset 0x1ec, CSR Addr 0x580f6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1ED;      // Byte offset 0x1ed, CSR Addr 0x580f6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1EE;      // Byte offset 0x1ee, CSR Addr 0x580f7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1EF;      // Byte offset 0x1ef, CSR Addr 0x580f7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F0;      // Byte offset 0x1f0, CSR Addr 0x580f8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F1;      // Byte offset 0x1f1, CSR Addr 0x580f8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F2;      // Byte offset 0x1f2, CSR Addr 0x580f9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F3;      // Byte offset 0x1f3, CSR Addr 0x580f9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F4;      // Byte offset 0x1f4, CSR Addr 0x580fa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F5;      // Byte offset 0x1f5, CSR Addr 0x580fa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F6;      // Byte offset 0x1f6, CSR Addr 0x580fb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F7;      // Byte offset 0x1f7, CSR Addr 0x580fb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F8;      // Byte offset 0x1f8, CSR Addr 0x580fc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1F9;      // Byte offset 0x1f9, CSR Addr 0x580fc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1FA;      // Byte offset 0x1fa, CSR Addr 0x580fd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1FB;      // Byte offset 0x1fb, CSR Addr 0x580fd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1FC;      // Byte offset 0x1fc, CSR Addr 0x580fe, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1FD;      // Byte offset 0x1fd, CSR Addr 0x580fe, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1FE;      // Byte offset 0x1fe, CSR Addr 0x580ff, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved1FF;      // Byte offset 0x1ff, CSR Addr 0x580ff, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved200;      // Byte offset 0x200, CSR Addr 0x58100, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved201;      // Byte offset 0x201, CSR Addr 0x58100, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved202;      // Byte offset 0x202, CSR Addr 0x58101, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved203;      // Byte offset 0x203, CSR Addr 0x58101, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved204;      // Byte offset 0x204, CSR Addr 0x58102, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved205;      // Byte offset 0x205, CSR Addr 0x58102, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved206;      // Byte offset 0x206, CSR Addr 0x58103, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved207;      // Byte offset 0x207, CSR Addr 0x58103, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved208;      // Byte offset 0x208, CSR Addr 0x58104, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved209;      // Byte offset 0x209, CSR Addr 0x58104, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved20A;      // Byte offset 0x20a, CSR Addr 0x58105, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved20B;      // Byte offset 0x20b, CSR Addr 0x58105, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved20C;      // Byte offset 0x20c, CSR Addr 0x58106, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved20D;      // Byte offset 0x20d, CSR Addr 0x58106, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved20E;      // Byte offset 0x20e, CSR Addr 0x58107, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved20F;      // Byte offset 0x20f, CSR Addr 0x58107, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved210;      // Byte offset 0x210, CSR Addr 0x58108, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved211;      // Byte offset 0x211, CSR Addr 0x58108, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved212;      // Byte offset 0x212, CSR Addr 0x58109, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved213;      // Byte offset 0x213, CSR Addr 0x58109, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved214;      // Byte offset 0x214, CSR Addr 0x5810a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved215;      // Byte offset 0x215, CSR Addr 0x5810a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved216;      // Byte offset 0x216, CSR Addr 0x5810b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved217;      // Byte offset 0x217, CSR Addr 0x5810b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved218;      // Byte offset 0x218, CSR Addr 0x5810c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved219;      // Byte offset 0x219, CSR Addr 0x5810c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved21A;      // Byte offset 0x21a, CSR Addr 0x5810d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved21B;      // Byte offset 0x21b, CSR Addr 0x5810d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved21C;      // Byte offset 0x21c, CSR Addr 0x5810e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved21D;      // Byte offset 0x21d, CSR Addr 0x5810e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved21E;      // Byte offset 0x21e, CSR Addr 0x5810f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved21F;      // Byte offset 0x21f, CSR Addr 0x5810f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved220;      // Byte offset 0x220, CSR Addr 0x58110, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved221;      // Byte offset 0x221, CSR Addr 0x58110, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved222;      // Byte offset 0x222, CSR Addr 0x58111, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved223;      // Byte offset 0x223, CSR Addr 0x58111, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved224;      // Byte offset 0x224, CSR Addr 0x58112, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved225;      // Byte offset 0x225, CSR Addr 0x58112, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved226;      // Byte offset 0x226, CSR Addr 0x58113, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved227;      // Byte offset 0x227, CSR Addr 0x58113, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved228;      // Byte offset 0x228, CSR Addr 0x58114, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved229;      // Byte offset 0x229, CSR Addr 0x58114, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved22A;      // Byte offset 0x22a, CSR Addr 0x58115, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved22B;      // Byte offset 0x22b, CSR Addr 0x58115, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved22C;      // Byte offset 0x22c, CSR Addr 0x58116, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved22D;      // Byte offset 0x22d, CSR Addr 0x58116, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved22E;      // Byte offset 0x22e, CSR Addr 0x58117, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved22F;      // Byte offset 0x22f, CSR Addr 0x58117, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved230;      // Byte offset 0x230, CSR Addr 0x58118, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved231;      // Byte offset 0x231, CSR Addr 0x58118, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved232;      // Byte offset 0x232, CSR Addr 0x58119, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved233;      // Byte offset 0x233, CSR Addr 0x58119, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved234;      // Byte offset 0x234, CSR Addr 0x5811a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved235;      // Byte offset 0x235, CSR Addr 0x5811a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved236;      // Byte offset 0x236, CSR Addr 0x5811b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved237;      // Byte offset 0x237, CSR Addr 0x5811b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved238;      // Byte offset 0x238, CSR Addr 0x5811c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved239;      // Byte offset 0x239, CSR Addr 0x5811c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved23A;      // Byte offset 0x23a, CSR Addr 0x5811d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved23B;      // Byte offset 0x23b, CSR Addr 0x5811d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved23C;      // Byte offset 0x23c, CSR Addr 0x5811e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved23D;      // Byte offset 0x23d, CSR Addr 0x5811e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved23E;      // Byte offset 0x23e, CSR Addr 0x5811f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved23F;      // Byte offset 0x23f, CSR Addr 0x5811f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved240;      // Byte offset 0x240, CSR Addr 0x58120, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved241;      // Byte offset 0x241, CSR Addr 0x58120, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved242;      // Byte offset 0x242, CSR Addr 0x58121, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved243;      // Byte offset 0x243, CSR Addr 0x58121, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved244;      // Byte offset 0x244, CSR Addr 0x58122, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved245;      // Byte offset 0x245, CSR Addr 0x58122, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved246;      // Byte offset 0x246, CSR Addr 0x58123, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved247;      // Byte offset 0x247, CSR Addr 0x58123, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved248;      // Byte offset 0x248, CSR Addr 0x58124, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved249;      // Byte offset 0x249, CSR Addr 0x58124, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved24A;      // Byte offset 0x24a, CSR Addr 0x58125, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved24B;      // Byte offset 0x24b, CSR Addr 0x58125, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved24C;      // Byte offset 0x24c, CSR Addr 0x58126, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved24D;      // Byte offset 0x24d, CSR Addr 0x58126, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved24E;      // Byte offset 0x24e, CSR Addr 0x58127, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved24F;      // Byte offset 0x24f, CSR Addr 0x58127, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved250;      // Byte offset 0x250, CSR Addr 0x58128, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved251;      // Byte offset 0x251, CSR Addr 0x58128, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved252;      // Byte offset 0x252, CSR Addr 0x58129, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved253;      // Byte offset 0x253, CSR Addr 0x58129, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved254;      // Byte offset 0x254, CSR Addr 0x5812a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved255;      // Byte offset 0x255, CSR Addr 0x5812a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved256;      // Byte offset 0x256, CSR Addr 0x5812b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved257;      // Byte offset 0x257, CSR Addr 0x5812b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved258;      // Byte offset 0x258, CSR Addr 0x5812c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved259;      // Byte offset 0x259, CSR Addr 0x5812c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved25A;      // Byte offset 0x25a, CSR Addr 0x5812d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved25B;      // Byte offset 0x25b, CSR Addr 0x5812d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved25C;      // Byte offset 0x25c, CSR Addr 0x5812e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved25D;      // Byte offset 0x25d, CSR Addr 0x5812e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved25E;      // Byte offset 0x25e, CSR Addr 0x5812f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved25F;      // Byte offset 0x25f, CSR Addr 0x5812f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved260;      // Byte offset 0x260, CSR Addr 0x58130, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved261;      // Byte offset 0x261, CSR Addr 0x58130, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved262;      // Byte offset 0x262, CSR Addr 0x58131, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved263;      // Byte offset 0x263, CSR Addr 0x58131, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved264;      // Byte offset 0x264, CSR Addr 0x58132, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved265;      // Byte offset 0x265, CSR Addr 0x58132, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved266;      // Byte offset 0x266, CSR Addr 0x58133, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved267;      // Byte offset 0x267, CSR Addr 0x58133, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved268;      // Byte offset 0x268, CSR Addr 0x58134, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved269;      // Byte offset 0x269, CSR Addr 0x58134, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved26A;      // Byte offset 0x26a, CSR Addr 0x58135, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved26B;      // Byte offset 0x26b, CSR Addr 0x58135, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved26C;      // Byte offset 0x26c, CSR Addr 0x58136, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved26D;      // Byte offset 0x26d, CSR Addr 0x58136, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved26E;      // Byte offset 0x26e, CSR Addr 0x58137, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved26F;      // Byte offset 0x26f, CSR Addr 0x58137, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved270;      // Byte offset 0x270, CSR Addr 0x58138, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved271;      // Byte offset 0x271, CSR Addr 0x58138, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved272;      // Byte offset 0x272, CSR Addr 0x58139, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved273;      // Byte offset 0x273, CSR Addr 0x58139, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved274;      // Byte offset 0x274, CSR Addr 0x5813a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved275;      // Byte offset 0x275, CSR Addr 0x5813a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved276;      // Byte offset 0x276, CSR Addr 0x5813b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved277;      // Byte offset 0x277, CSR Addr 0x5813b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved278;      // Byte offset 0x278, CSR Addr 0x5813c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved279;      // Byte offset 0x279, CSR Addr 0x5813c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved27A;      // Byte offset 0x27a, CSR Addr 0x5813d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved27B;      // Byte offset 0x27b, CSR Addr 0x5813d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved27C;      // Byte offset 0x27c, CSR Addr 0x5813e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved27D;      // Byte offset 0x27d, CSR Addr 0x5813e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved27E;      // Byte offset 0x27e, CSR Addr 0x5813f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved27F;      // Byte offset 0x27f, CSR Addr 0x5813f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved280;      // Byte offset 0x280, CSR Addr 0x58140, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved281;      // Byte offset 0x281, CSR Addr 0x58140, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved282;      // Byte offset 0x282, CSR Addr 0x58141, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved283;      // Byte offset 0x283, CSR Addr 0x58141, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved284;      // Byte offset 0x284, CSR Addr 0x58142, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved285;      // Byte offset 0x285, CSR Addr 0x58142, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved286;      // Byte offset 0x286, CSR Addr 0x58143, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved287;      // Byte offset 0x287, CSR Addr 0x58143, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved288;      // Byte offset 0x288, CSR Addr 0x58144, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved289;      // Byte offset 0x289, CSR Addr 0x58144, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved28A;      // Byte offset 0x28a, CSR Addr 0x58145, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved28B;      // Byte offset 0x28b, CSR Addr 0x58145, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved28C;      // Byte offset 0x28c, CSR Addr 0x58146, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved28D;      // Byte offset 0x28d, CSR Addr 0x58146, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved28E;      // Byte offset 0x28e, CSR Addr 0x58147, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved28F;      // Byte offset 0x28f, CSR Addr 0x58147, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved290;      // Byte offset 0x290, CSR Addr 0x58148, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved291;      // Byte offset 0x291, CSR Addr 0x58148, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved292;      // Byte offset 0x292, CSR Addr 0x58149, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved293;      // Byte offset 0x293, CSR Addr 0x58149, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved294;      // Byte offset 0x294, CSR Addr 0x5814a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved295;      // Byte offset 0x295, CSR Addr 0x5814a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved296;      // Byte offset 0x296, CSR Addr 0x5814b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved297;      // Byte offset 0x297, CSR Addr 0x5814b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved298;      // Byte offset 0x298, CSR Addr 0x5814c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved299;      // Byte offset 0x299, CSR Addr 0x5814c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved29A;      // Byte offset 0x29a, CSR Addr 0x5814d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved29B;      // Byte offset 0x29b, CSR Addr 0x5814d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved29C;      // Byte offset 0x29c, CSR Addr 0x5814e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved29D;      // Byte offset 0x29d, CSR Addr 0x5814e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved29E;      // Byte offset 0x29e, CSR Addr 0x5814f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved29F;      // Byte offset 0x29f, CSR Addr 0x5814f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A0;      // Byte offset 0x2a0, CSR Addr 0x58150, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A1;      // Byte offset 0x2a1, CSR Addr 0x58150, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A2;      // Byte offset 0x2a2, CSR Addr 0x58151, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A3;      // Byte offset 0x2a3, CSR Addr 0x58151, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A4;      // Byte offset 0x2a4, CSR Addr 0x58152, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A5;      // Byte offset 0x2a5, CSR Addr 0x58152, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A6;      // Byte offset 0x2a6, CSR Addr 0x58153, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A7;      // Byte offset 0x2a7, CSR Addr 0x58153, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A8;      // Byte offset 0x2a8, CSR Addr 0x58154, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2A9;      // Byte offset 0x2a9, CSR Addr 0x58154, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2AA;      // Byte offset 0x2aa, CSR Addr 0x58155, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2AB;      // Byte offset 0x2ab, CSR Addr 0x58155, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2AC;      // Byte offset 0x2ac, CSR Addr 0x58156, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2AD;      // Byte offset 0x2ad, CSR Addr 0x58156, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2AE;      // Byte offset 0x2ae, CSR Addr 0x58157, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2AF;      // Byte offset 0x2af, CSR Addr 0x58157, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B0;      // Byte offset 0x2b0, CSR Addr 0x58158, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B1;      // Byte offset 0x2b1, CSR Addr 0x58158, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B2;      // Byte offset 0x2b2, CSR Addr 0x58159, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B3;      // Byte offset 0x2b3, CSR Addr 0x58159, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B4;      // Byte offset 0x2b4, CSR Addr 0x5815a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B5;      // Byte offset 0x2b5, CSR Addr 0x5815a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B6;      // Byte offset 0x2b6, CSR Addr 0x5815b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B7;      // Byte offset 0x2b7, CSR Addr 0x5815b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B8;      // Byte offset 0x2b8, CSR Addr 0x5815c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2B9;      // Byte offset 0x2b9, CSR Addr 0x5815c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2BA;      // Byte offset 0x2ba, CSR Addr 0x5815d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2BB;      // Byte offset 0x2bb, CSR Addr 0x5815d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2BC;      // Byte offset 0x2bc, CSR Addr 0x5815e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2BD;      // Byte offset 0x2bd, CSR Addr 0x5815e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2BE;      // Byte offset 0x2be, CSR Addr 0x5815f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2BF;      // Byte offset 0x2bf, CSR Addr 0x5815f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C0;      // Byte offset 0x2c0, CSR Addr 0x58160, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C1;      // Byte offset 0x2c1, CSR Addr 0x58160, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C2;      // Byte offset 0x2c2, CSR Addr 0x58161, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C3;      // Byte offset 0x2c3, CSR Addr 0x58161, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C4;      // Byte offset 0x2c4, CSR Addr 0x58162, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C5;      // Byte offset 0x2c5, CSR Addr 0x58162, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C6;      // Byte offset 0x2c6, CSR Addr 0x58163, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C7;      // Byte offset 0x2c7, CSR Addr 0x58163, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C8;      // Byte offset 0x2c8, CSR Addr 0x58164, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2C9;      // Byte offset 0x2c9, CSR Addr 0x58164, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2CA;      // Byte offset 0x2ca, CSR Addr 0x58165, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2CB;      // Byte offset 0x2cb, CSR Addr 0x58165, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2CC;      // Byte offset 0x2cc, CSR Addr 0x58166, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2CD;      // Byte offset 0x2cd, CSR Addr 0x58166, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2CE;      // Byte offset 0x2ce, CSR Addr 0x58167, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2CF;      // Byte offset 0x2cf, CSR Addr 0x58167, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D0;      // Byte offset 0x2d0, CSR Addr 0x58168, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D1;      // Byte offset 0x2d1, CSR Addr 0x58168, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D2;      // Byte offset 0x2d2, CSR Addr 0x58169, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D3;      // Byte offset 0x2d3, CSR Addr 0x58169, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D4;      // Byte offset 0x2d4, CSR Addr 0x5816a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D5;      // Byte offset 0x2d5, CSR Addr 0x5816a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D6;      // Byte offset 0x2d6, CSR Addr 0x5816b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D7;      // Byte offset 0x2d7, CSR Addr 0x5816b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D8;      // Byte offset 0x2d8, CSR Addr 0x5816c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2D9;      // Byte offset 0x2d9, CSR Addr 0x5816c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2DA;      // Byte offset 0x2da, CSR Addr 0x5816d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2DB;      // Byte offset 0x2db, CSR Addr 0x5816d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2DC;      // Byte offset 0x2dc, CSR Addr 0x5816e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2DD;      // Byte offset 0x2dd, CSR Addr 0x5816e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2DE;      // Byte offset 0x2de, CSR Addr 0x5816f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2DF;      // Byte offset 0x2df, CSR Addr 0x5816f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E0;      // Byte offset 0x2e0, CSR Addr 0x58170, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E1;      // Byte offset 0x2e1, CSR Addr 0x58170, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E2;      // Byte offset 0x2e2, CSR Addr 0x58171, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E3;      // Byte offset 0x2e3, CSR Addr 0x58171, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E4;      // Byte offset 0x2e4, CSR Addr 0x58172, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E5;      // Byte offset 0x2e5, CSR Addr 0x58172, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E6;      // Byte offset 0x2e6, CSR Addr 0x58173, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E7;      // Byte offset 0x2e7, CSR Addr 0x58173, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E8;      // Byte offset 0x2e8, CSR Addr 0x58174, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2E9;      // Byte offset 0x2e9, CSR Addr 0x58174, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2EA;      // Byte offset 0x2ea, CSR Addr 0x58175, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2EB;      // Byte offset 0x2eb, CSR Addr 0x58175, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2EC;      // Byte offset 0x2ec, CSR Addr 0x58176, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2ED;      // Byte offset 0x2ed, CSR Addr 0x58176, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2EE;      // Byte offset 0x2ee, CSR Addr 0x58177, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2EF;      // Byte offset 0x2ef, CSR Addr 0x58177, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F0;      // Byte offset 0x2f0, CSR Addr 0x58178, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F1;      // Byte offset 0x2f1, CSR Addr 0x58178, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F2;      // Byte offset 0x2f2, CSR Addr 0x58179, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F3;      // Byte offset 0x2f3, CSR Addr 0x58179, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F4;      // Byte offset 0x2f4, CSR Addr 0x5817a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F5;      // Byte offset 0x2f5, CSR Addr 0x5817a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F6;      // Byte offset 0x2f6, CSR Addr 0x5817b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F7;      // Byte offset 0x2f7, CSR Addr 0x5817b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F8;      // Byte offset 0x2f8, CSR Addr 0x5817c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2F9;      // Byte offset 0x2f9, CSR Addr 0x5817c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2FA;      // Byte offset 0x2fa, CSR Addr 0x5817d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2FB;      // Byte offset 0x2fb, CSR Addr 0x5817d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2FC;      // Byte offset 0x2fc, CSR Addr 0x5817e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2FD;      // Byte offset 0x2fd, CSR Addr 0x5817e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2FE;      // Byte offset 0x2fe, CSR Addr 0x5817f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved2FF;      // Byte offset 0x2ff, CSR Addr 0x5817f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved300;      // Byte offset 0x300, CSR Addr 0x58180, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved301;      // Byte offset 0x301, CSR Addr 0x58180, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved302;      // Byte offset 0x302, CSR Addr 0x58181, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved303;      // Byte offset 0x303, CSR Addr 0x58181, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved304;      // Byte offset 0x304, CSR Addr 0x58182, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved305;      // Byte offset 0x305, CSR Addr 0x58182, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved306;      // Byte offset 0x306, CSR Addr 0x58183, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved307;      // Byte offset 0x307, CSR Addr 0x58183, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved308;      // Byte offset 0x308, CSR Addr 0x58184, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved309;      // Byte offset 0x309, CSR Addr 0x58184, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved30A;      // Byte offset 0x30a, CSR Addr 0x58185, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved30B;      // Byte offset 0x30b, CSR Addr 0x58185, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved30C;      // Byte offset 0x30c, CSR Addr 0x58186, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved30D;      // Byte offset 0x30d, CSR Addr 0x58186, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved30E;      // Byte offset 0x30e, CSR Addr 0x58187, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved30F;      // Byte offset 0x30f, CSR Addr 0x58187, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved310;      // Byte offset 0x310, CSR Addr 0x58188, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved311;      // Byte offset 0x311, CSR Addr 0x58188, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved312;      // Byte offset 0x312, CSR Addr 0x58189, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved313;      // Byte offset 0x313, CSR Addr 0x58189, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved314;      // Byte offset 0x314, CSR Addr 0x5818a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved315;      // Byte offset 0x315, CSR Addr 0x5818a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved316;      // Byte offset 0x316, CSR Addr 0x5818b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved317;      // Byte offset 0x317, CSR Addr 0x5818b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved318;      // Byte offset 0x318, CSR Addr 0x5818c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved319;      // Byte offset 0x319, CSR Addr 0x5818c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved31A;      // Byte offset 0x31a, CSR Addr 0x5818d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved31B;      // Byte offset 0x31b, CSR Addr 0x5818d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved31C;      // Byte offset 0x31c, CSR Addr 0x5818e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved31D;      // Byte offset 0x31d, CSR Addr 0x5818e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved31E;      // Byte offset 0x31e, CSR Addr 0x5818f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved31F;      // Byte offset 0x31f, CSR Addr 0x5818f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved320;      // Byte offset 0x320, CSR Addr 0x58190, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved321;      // Byte offset 0x321, CSR Addr 0x58190, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved322;      // Byte offset 0x322, CSR Addr 0x58191, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved323;      // Byte offset 0x323, CSR Addr 0x58191, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved324;      // Byte offset 0x324, CSR Addr 0x58192, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved325;      // Byte offset 0x325, CSR Addr 0x58192, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved326;      // Byte offset 0x326, CSR Addr 0x58193, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved327;      // Byte offset 0x327, CSR Addr 0x58193, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved328;      // Byte offset 0x328, CSR Addr 0x58194, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved329;      // Byte offset 0x329, CSR Addr 0x58194, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved32A;      // Byte offset 0x32a, CSR Addr 0x58195, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved32B;      // Byte offset 0x32b, CSR Addr 0x58195, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved32C;      // Byte offset 0x32c, CSR Addr 0x58196, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved32D;      // Byte offset 0x32d, CSR Addr 0x58196, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved32E;      // Byte offset 0x32e, CSR Addr 0x58197, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved32F;      // Byte offset 0x32f, CSR Addr 0x58197, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved330;      // Byte offset 0x330, CSR Addr 0x58198, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved331;      // Byte offset 0x331, CSR Addr 0x58198, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved332;      // Byte offset 0x332, CSR Addr 0x58199, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved333;      // Byte offset 0x333, CSR Addr 0x58199, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved334;      // Byte offset 0x334, CSR Addr 0x5819a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved335;      // Byte offset 0x335, CSR Addr 0x5819a, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved336;      // Byte offset 0x336, CSR Addr 0x5819b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved337;      // Byte offset 0x337, CSR Addr 0x5819b, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved338;      // Byte offset 0x338, CSR Addr 0x5819c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved339;      // Byte offset 0x339, CSR Addr 0x5819c, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved33A;      // Byte offset 0x33a, CSR Addr 0x5819d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved33B;      // Byte offset 0x33b, CSR Addr 0x5819d, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved33C;      // Byte offset 0x33c, CSR Addr 0x5819e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved33D;      // Byte offset 0x33d, CSR Addr 0x5819e, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved33E;      // Byte offset 0x33e, CSR Addr 0x5819f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved33F;      // Byte offset 0x33f, CSR Addr 0x5819f, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved340;      // Byte offset 0x340, CSR Addr 0x581a0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved341;      // Byte offset 0x341, CSR Addr 0x581a0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved342;      // Byte offset 0x342, CSR Addr 0x581a1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved343;      // Byte offset 0x343, CSR Addr 0x581a1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved344;      // Byte offset 0x344, CSR Addr 0x581a2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved345;      // Byte offset 0x345, CSR Addr 0x581a2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved346;      // Byte offset 0x346, CSR Addr 0x581a3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved347;      // Byte offset 0x347, CSR Addr 0x581a3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved348;      // Byte offset 0x348, CSR Addr 0x581a4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved349;      // Byte offset 0x349, CSR Addr 0x581a4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved34A;      // Byte offset 0x34a, CSR Addr 0x581a5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved34B;      // Byte offset 0x34b, CSR Addr 0x581a5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved34C;      // Byte offset 0x34c, CSR Addr 0x581a6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved34D;      // Byte offset 0x34d, CSR Addr 0x581a6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved34E;      // Byte offset 0x34e, CSR Addr 0x581a7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved34F;      // Byte offset 0x34f, CSR Addr 0x581a7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved350;      // Byte offset 0x350, CSR Addr 0x581a8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved351;      // Byte offset 0x351, CSR Addr 0x581a8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved352;      // Byte offset 0x352, CSR Addr 0x581a9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved353;      // Byte offset 0x353, CSR Addr 0x581a9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved354;      // Byte offset 0x354, CSR Addr 0x581aa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved355;      // Byte offset 0x355, CSR Addr 0x581aa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved356;      // Byte offset 0x356, CSR Addr 0x581ab, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved357;      // Byte offset 0x357, CSR Addr 0x581ab, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved358;      // Byte offset 0x358, CSR Addr 0x581ac, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved359;      // Byte offset 0x359, CSR Addr 0x581ac, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved35A;      // Byte offset 0x35a, CSR Addr 0x581ad, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved35B;      // Byte offset 0x35b, CSR Addr 0x581ad, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved35C;      // Byte offset 0x35c, CSR Addr 0x581ae, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved35D;      // Byte offset 0x35d, CSR Addr 0x581ae, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved35E;      // Byte offset 0x35e, CSR Addr 0x581af, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved35F;      // Byte offset 0x35f, CSR Addr 0x581af, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved360;      // Byte offset 0x360, CSR Addr 0x581b0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved361;      // Byte offset 0x361, CSR Addr 0x581b0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved362;      // Byte offset 0x362, CSR Addr 0x581b1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved363;      // Byte offset 0x363, CSR Addr 0x581b1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved364;      // Byte offset 0x364, CSR Addr 0x581b2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved365;      // Byte offset 0x365, CSR Addr 0x581b2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved366;      // Byte offset 0x366, CSR Addr 0x581b3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved367;      // Byte offset 0x367, CSR Addr 0x581b3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved368;      // Byte offset 0x368, CSR Addr 0x581b4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved369;      // Byte offset 0x369, CSR Addr 0x581b4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved36A;      // Byte offset 0x36a, CSR Addr 0x581b5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved36B;      // Byte offset 0x36b, CSR Addr 0x581b5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved36C;      // Byte offset 0x36c, CSR Addr 0x581b6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved36D;      // Byte offset 0x36d, CSR Addr 0x581b6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved36E;      // Byte offset 0x36e, CSR Addr 0x581b7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved36F;      // Byte offset 0x36f, CSR Addr 0x581b7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved370;      // Byte offset 0x370, CSR Addr 0x581b8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved371;      // Byte offset 0x371, CSR Addr 0x581b8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved372;      // Byte offset 0x372, CSR Addr 0x581b9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved373;      // Byte offset 0x373, CSR Addr 0x581b9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved374;      // Byte offset 0x374, CSR Addr 0x581ba, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved375;      // Byte offset 0x375, CSR Addr 0x581ba, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved376;      // Byte offset 0x376, CSR Addr 0x581bb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved377;      // Byte offset 0x377, CSR Addr 0x581bb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved378;      // Byte offset 0x378, CSR Addr 0x581bc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved379;      // Byte offset 0x379, CSR Addr 0x581bc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved37A;      // Byte offset 0x37a, CSR Addr 0x581bd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved37B;      // Byte offset 0x37b, CSR Addr 0x581bd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved37C;      // Byte offset 0x37c, CSR Addr 0x581be, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved37D;      // Byte offset 0x37d, CSR Addr 0x581be, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved37E;      // Byte offset 0x37e, CSR Addr 0x581bf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved37F;      // Byte offset 0x37f, CSR Addr 0x581bf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved380;      // Byte offset 0x380, CSR Addr 0x581c0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved381;      // Byte offset 0x381, CSR Addr 0x581c0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved382;      // Byte offset 0x382, CSR Addr 0x581c1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved383;      // Byte offset 0x383, CSR Addr 0x581c1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved384;      // Byte offset 0x384, CSR Addr 0x581c2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved385;      // Byte offset 0x385, CSR Addr 0x581c2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved386;      // Byte offset 0x386, CSR Addr 0x581c3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved387;      // Byte offset 0x387, CSR Addr 0x581c3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved388;      // Byte offset 0x388, CSR Addr 0x581c4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved389;      // Byte offset 0x389, CSR Addr 0x581c4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved38A;      // Byte offset 0x38a, CSR Addr 0x581c5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved38B;      // Byte offset 0x38b, CSR Addr 0x581c5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved38C;      // Byte offset 0x38c, CSR Addr 0x581c6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved38D;      // Byte offset 0x38d, CSR Addr 0x581c6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved38E;      // Byte offset 0x38e, CSR Addr 0x581c7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved38F;      // Byte offset 0x38f, CSR Addr 0x581c7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved390;      // Byte offset 0x390, CSR Addr 0x581c8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved391;      // Byte offset 0x391, CSR Addr 0x581c8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved392;      // Byte offset 0x392, CSR Addr 0x581c9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved393;      // Byte offset 0x393, CSR Addr 0x581c9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved394;      // Byte offset 0x394, CSR Addr 0x581ca, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved395;      // Byte offset 0x395, CSR Addr 0x581ca, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved396;      // Byte offset 0x396, CSR Addr 0x581cb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved397;      // Byte offset 0x397, CSR Addr 0x581cb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved398;      // Byte offset 0x398, CSR Addr 0x581cc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved399;      // Byte offset 0x399, CSR Addr 0x581cc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved39A;      // Byte offset 0x39a, CSR Addr 0x581cd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved39B;      // Byte offset 0x39b, CSR Addr 0x581cd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved39C;      // Byte offset 0x39c, CSR Addr 0x581ce, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved39D;      // Byte offset 0x39d, CSR Addr 0x581ce, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved39E;      // Byte offset 0x39e, CSR Addr 0x581cf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved39F;      // Byte offset 0x39f, CSR Addr 0x581cf, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A0;      // Byte offset 0x3a0, CSR Addr 0x581d0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A1;      // Byte offset 0x3a1, CSR Addr 0x581d0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A2;      // Byte offset 0x3a2, CSR Addr 0x581d1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A3;      // Byte offset 0x3a3, CSR Addr 0x581d1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A4;      // Byte offset 0x3a4, CSR Addr 0x581d2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A5;      // Byte offset 0x3a5, CSR Addr 0x581d2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A6;      // Byte offset 0x3a6, CSR Addr 0x581d3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A7;      // Byte offset 0x3a7, CSR Addr 0x581d3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A8;      // Byte offset 0x3a8, CSR Addr 0x581d4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3A9;      // Byte offset 0x3a9, CSR Addr 0x581d4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3AA;      // Byte offset 0x3aa, CSR Addr 0x581d5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3AB;      // Byte offset 0x3ab, CSR Addr 0x581d5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3AC;      // Byte offset 0x3ac, CSR Addr 0x581d6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3AD;      // Byte offset 0x3ad, CSR Addr 0x581d6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3AE;      // Byte offset 0x3ae, CSR Addr 0x581d7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3AF;      // Byte offset 0x3af, CSR Addr 0x581d7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B0;      // Byte offset 0x3b0, CSR Addr 0x581d8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B1;      // Byte offset 0x3b1, CSR Addr 0x581d8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B2;      // Byte offset 0x3b2, CSR Addr 0x581d9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B3;      // Byte offset 0x3b3, CSR Addr 0x581d9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B4;      // Byte offset 0x3b4, CSR Addr 0x581da, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B5;      // Byte offset 0x3b5, CSR Addr 0x581da, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B6;      // Byte offset 0x3b6, CSR Addr 0x581db, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B7;      // Byte offset 0x3b7, CSR Addr 0x581db, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B8;      // Byte offset 0x3b8, CSR Addr 0x581dc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3B9;      // Byte offset 0x3b9, CSR Addr 0x581dc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3BA;      // Byte offset 0x3ba, CSR Addr 0x581dd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3BB;      // Byte offset 0x3bb, CSR Addr 0x581dd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3BC;      // Byte offset 0x3bc, CSR Addr 0x581de, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3BD;      // Byte offset 0x3bd, CSR Addr 0x581de, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3BE;      // Byte offset 0x3be, CSR Addr 0x581df, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3BF;      // Byte offset 0x3bf, CSR Addr 0x581df, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C0;      // Byte offset 0x3c0, CSR Addr 0x581e0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C1;      // Byte offset 0x3c1, CSR Addr 0x581e0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C2;      // Byte offset 0x3c2, CSR Addr 0x581e1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C3;      // Byte offset 0x3c3, CSR Addr 0x581e1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C4;      // Byte offset 0x3c4, CSR Addr 0x581e2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C5;      // Byte offset 0x3c5, CSR Addr 0x581e2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C6;      // Byte offset 0x3c6, CSR Addr 0x581e3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C7;      // Byte offset 0x3c7, CSR Addr 0x581e3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C8;      // Byte offset 0x3c8, CSR Addr 0x581e4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3C9;      // Byte offset 0x3c9, CSR Addr 0x581e4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3CA;      // Byte offset 0x3ca, CSR Addr 0x581e5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3CB;      // Byte offset 0x3cb, CSR Addr 0x581e5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3CC;      // Byte offset 0x3cc, CSR Addr 0x581e6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3CD;      // Byte offset 0x3cd, CSR Addr 0x581e6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3CE;      // Byte offset 0x3ce, CSR Addr 0x581e7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3CF;      // Byte offset 0x3cf, CSR Addr 0x581e7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D0;      // Byte offset 0x3d0, CSR Addr 0x581e8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D1;      // Byte offset 0x3d1, CSR Addr 0x581e8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D2;      // Byte offset 0x3d2, CSR Addr 0x581e9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D3;      // Byte offset 0x3d3, CSR Addr 0x581e9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D4;      // Byte offset 0x3d4, CSR Addr 0x581ea, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D5;      // Byte offset 0x3d5, CSR Addr 0x581ea, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D6;      // Byte offset 0x3d6, CSR Addr 0x581eb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D7;      // Byte offset 0x3d7, CSR Addr 0x581eb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D8;      // Byte offset 0x3d8, CSR Addr 0x581ec, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3D9;      // Byte offset 0x3d9, CSR Addr 0x581ec, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3DA;      // Byte offset 0x3da, CSR Addr 0x581ed, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3DB;      // Byte offset 0x3db, CSR Addr 0x581ed, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3DC;      // Byte offset 0x3dc, CSR Addr 0x581ee, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3DD;      // Byte offset 0x3dd, CSR Addr 0x581ee, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3DE;      // Byte offset 0x3de, CSR Addr 0x581ef, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3DF;      // Byte offset 0x3df, CSR Addr 0x581ef, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E0;      // Byte offset 0x3e0, CSR Addr 0x581f0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E1;      // Byte offset 0x3e1, CSR Addr 0x581f0, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E2;      // Byte offset 0x3e2, CSR Addr 0x581f1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E3;      // Byte offset 0x3e3, CSR Addr 0x581f1, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E4;      // Byte offset 0x3e4, CSR Addr 0x581f2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E5;      // Byte offset 0x3e5, CSR Addr 0x581f2, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E6;      // Byte offset 0x3e6, CSR Addr 0x581f3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E7;      // Byte offset 0x3e7, CSR Addr 0x581f3, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E8;      // Byte offset 0x3e8, CSR Addr 0x581f4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3E9;      // Byte offset 0x3e9, CSR Addr 0x581f4, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3EA;      // Byte offset 0x3ea, CSR Addr 0x581f5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3EB;      // Byte offset 0x3eb, CSR Addr 0x581f5, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3EC;      // Byte offset 0x3ec, CSR Addr 0x581f6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3ED;      // Byte offset 0x3ed, CSR Addr 0x581f6, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3EE;      // Byte offset 0x3ee, CSR Addr 0x581f7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3EF;      // Byte offset 0x3ef, CSR Addr 0x581f7, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F0;      // Byte offset 0x3f0, CSR Addr 0x581f8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F1;      // Byte offset 0x3f1, CSR Addr 0x581f8, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F2;      // Byte offset 0x3f2, CSR Addr 0x581f9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F3;      // Byte offset 0x3f3, CSR Addr 0x581f9, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F4;      // Byte offset 0x3f4, CSR Addr 0x581fa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F5;      // Byte offset 0x3f5, CSR Addr 0x581fa, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F6;      // Byte offset 0x3f6, CSR Addr 0x581fb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F7;      // Byte offset 0x3f7, CSR Addr 0x581fb, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F8;      // Byte offset 0x3f8, CSR Addr 0x581fc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3F9;      // Byte offset 0x3f9, CSR Addr 0x581fc, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3FA;      // Byte offset 0x3fa, CSR Addr 0x581fd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3FB;      // Byte offset 0x3fb, CSR Addr 0x581fd, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3FC;      // Byte offset 0x3fc, CSR Addr 0x581fe, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3FD;      // Byte offset 0x3fd, CSR Addr 0x581fe, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3FE;      // Byte offset 0x3fe, CSR Addr 0x581ff, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
   uint8_t  Reserved3FF;      // Byte offset 0x3ff, CSR Addr 0x581ff, Direction=N/A
                              // This field is reserved and must be programmed to 0x00.
} __attribute__ ((packed)) PMU_SMB_LPDDR4_1D_t;
