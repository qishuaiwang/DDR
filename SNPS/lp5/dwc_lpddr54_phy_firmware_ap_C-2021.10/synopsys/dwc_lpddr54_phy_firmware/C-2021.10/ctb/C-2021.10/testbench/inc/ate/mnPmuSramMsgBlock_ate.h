#ifndef _MNPMUSRAMMSGBLOCK_ATE_H
#define _MNPMUSRAMMSGBLOCK_ATE_H 1

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// General defines
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// Basic type typedefs

#include <stdint.h>
#include <stdbool.h>

// ATE firmware revision

#define PMU_ATE_INTERNAL_REV0 0x0600u
#define PMU_ATE_INTERNAL_REV1 0x2021u


//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Message block related defines
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// TestsToRun encoding

#define REVISION_CHECK_TEST   0x0001u
#define IMPEDANCE_CAL_TEST    0x0002u
#define PLL_LOCK_TEST         0x0004u
#define LCDL_LINEARITY_TEST   0x0008u
#define AC_LOOPBACK_TEST      0x0010u
#define DAT_1D_LOOPBACK_TEST  0x0020u
#define DAT_2D_LOOPBACK_TEST  0x0040u
#define BURN_IN_TEST          0x0080u
#define RXREPLICA_TEST        0x0100u
#define DAT_DCA_LOOPBACK_TEST 0x0200u

// TestOptions encoding

#define TEST_OPTION_PLL_LOCK_INCREASE  0x0001u
#define TEST_OPTION_PLL_RESET_INCREASE 0x0002u
#define TEST_OPTION_PWR_SAVE_DISABLE   0x0004u
#define TEST_OPTION_AC_PINS_PRBS       0x0008u
#define TEST_OPTION_SKIP_SAVE_RESTORE  0x8000u


//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Message Block definition for the ATE firmware
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

typedef struct {

  /////////////////////////////////////////
  // General ATE Firmware Inputs / Outputs
  /////////////////////////////////////////

  uint16_t TestsToRun;  // Byte Offset: 0x0 / CSR Address: 0x58000
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

  uint16_t PassFailResults;  // Byte Offset: 0x2 / CSR Address: 0x58001
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

  uint16_t TestOptions;  // Byte Offset: 0x4 / CSR Address: 0x58002
                         // TestOptions[0]    = PLL lock time increase (must be written to 0 unless directed by Synopsys)
                         // TestOptions[1]    = PLL reset time increase (must be written to 0 unless directed by Synopsys)
                         // TestOptions[2]    = PwrSaveDisable - enable/disable traffic on AC interfaces during data loopback
                         //                     0 = Disable AC slices
                         //                     1 = Enable AC slice traffic during data loopback (further qualified by TestOptions[3])
                         //
                         // TestOptions[3]    = AcPinsPrbs - if TestOptions[2] is 1, selects the type of traffic to drive on the AC pins.
                         //                                  Else, field is ignored
                         //                     0 = Drive mission-mode style traffic on AC pins
                         //                     1 = Drive PRBS on AC pins
                         //
                         // TestOptions[14:4] = Reserved (must be written to 0)
                         // TestOptions[15]   = Skip CSR save / restore operation (must be written to 0 unless directed by Synopsys)

  uint16_t RESERVED_0;  // Byte Offset: 0x6 / CSR Address: 0x58003
                        // Must be written to 0

  uint32_t AteImemRevision;  // Byte Offset: 0x8 / CSR Address: 0x58004
                             // PMU firmware revision ID of the IMEM image
                             // After ATE firmware is run, this address will contain 
                             // the revision ID of the ATE firmware's IMEM image. 
                             // Please reference this revision ID when filing support 
                             // cases with Synopsys.

  uint32_t AteDmemRevision;  // Byte Offset: 0xc / CSR Address: 0x58006
                             // PMU firmware revision ID of the DMEM image
                             // After ATE firmware is run, this address will contain 
                             // the revision ID of the ATE firmware's DMEM image. 
                             // Please reference this revision ID when filing support 
                             // cases with Synopsys.

  uint8_t  UseMsgBlkPhyCfg;  // Byte Offset: 0x10 / CSR Address: 0x58008
                             // Selects whether the ATE FW uses the following 'PhyCfg*'
                             // msgBlock fields to determine how to test the PHY, or if 
                             // the ATE FW will use the CSR 'PhyConfig'
                             //    0x0 = Read the PHY config from the CSR 'PhyConfig'
                             //    0x1 = Use the PHY config from the msgBlock
                             // Others = RESERVED

  uint8_t  PhyCfgNumChan;  // Byte Offset: 0x11 / CSR Address: 0x58008
                           // The number of DFI channels in the PHY
                           //    0x1 = (1) channel
                           //    0x2 = (2) channels
                           // Others = RESERVED

  uint8_t  PhyCfgNumDbPerChan;  // Byte Offset: 0x12 / CSR Address: 0x58009
                                // The number of Dbyte instances per channel
                                //    0x2 = (2) DBs per channel
                                // Others = RESERVED

  uint8_t  PhyCfgDmiEn;  // Byte Offset: 0x13 / CSR Address: 0x58009
                         // Is the DMI interface enabled?
                         //    0x0 = DMI disabled
                         //    0x1 = DMI enabled
                         // Others = RESERVED

  uint8_t  PhyCfgNumRank;  // Byte Offset: 0x14 / CSR Address: 0x5800a
                           // The number of ranks
                           //    0x1 = (1) rank
                           //    0x2 = (2) ranks
                           // Others = RESERVED

  uint8_t  PhyCfgLp5En;  // Byte Offset: 0x15 / CSR Address: 0x5800a
                         // Does the PHY support LP5 mode?
                         //    0x0 = PHY does NOT support LP5
                         //    0x1 = PHY supports LP5
                         // Others = RESERVED


  uint16_t ZCalRZN;  // Byte Offset: 0x16 / CSR Address: 0x5800b
                     // ZCalRZN Value. Refer to CSR of same name for field breakdown.

  uint16_t DfiClkFreq;  // Byte Offset: 0x18 / CSR Address: 0x5800c
                        // DFI Clock frequency in MHz
                        // For example enter 0x0320 for 800MHz.

  uint8_t  DfiClkFreqRatio;  // Byte Offset: 0x1a / CSR Address: 0x5800d
                             // DFI_CLK frequency ratio
                             //    0x1 = 1:2 Mode
                             //    0x2 = 1:4 Mode
                             // Others = RESERVED

  uint8_t  ClockingMode;  // Byte Offset: 0x1b / CSR Address: 0x5800d
                          // Controls the relationships between DFI_CLK, CK, and WCK
                          //      0x0 = LP4 Mode
                          //            CK  = [2,4]xDFI_CLK 
                          //            DQS = [2,4]xDFI_CLK
                          //      0x1 = LP5 Mode
                          //            CK  =       DFI_CLK 
                          //            WCK = [2,4]xDFI_CLK
                          //
                          //   Others = RESERVED

  uint16_t DacRefModeCtl;  // Byte Offset: 0x1c / CSR Address: 0x5800e
                           // Refer to description of CSR 'VrefDacRefCtl' for field description

  uint16_t ZCalCompVref;  // Byte Offset: 0x1e / CSR Address: 0x5800f
                          // Refer to description of CSR 'ZCalCompVref' for field description


  uint16_t AcVrefDac;  // Byte Offset: 0x20 / CSR Address: 0x58010
                       // Refer to description of CSRs 'AcVrefDAC*' for field description

  uint16_t DbVrefDac;  // Byte Offset: 0x22 / CSR Address: 0x58011
                       // Refer to description of CSRs 'VrefDAC*' for field description

  uint16_t DbRxVrefCtl;  // Byte Offset: 0x24 / CSR Address: 0x58012
                         // Refer to description of CSR 'RxVrefCtl' for field description

  uint16_t DbRxDfeModeCfg;  // Byte Offset: 0x26 / CSR Address: 0x58013
                            // Refer to description of CSR 'RxDfeModeCfg' for field description

  uint16_t RESERVED_1;  // Byte Offset: 0x28 / CSR Address: 0x58014
                        // Must be written to 0

  uint16_t AcTxImpedanceSe;  // Byte Offset: 0x2a / CSR Address: 0x58015
                             // Drive-strength used for AC SE slices
                             // Refer to description of CSRs 'TxImpedanceSE*' for field breakdown

  uint16_t AcTxImpedanceDiff;  // Byte Offset: 0x2c / CSR Address: 0x58016
                               // Drive-strength used for AC DIFF slice (T&C)
                               // Refer to description of CSRs 'TxImpedanceDIFF*' for field breakdown

  uint16_t AcTxImpedanceSec;  // Byte Offset: 0x2e / CSR Address: 0x58017
                              // Drive strength used for AC SEC slice(s)
                              // Refer to description of CSRs 'TxImpedanceCMOS*' for field breakdown


  uint16_t DbTxImpedanceSe;  // Byte Offset: 0x30 / CSR Address: 0x58018
                             // Drive strength used for Dbyte SE slice
                             // Refer to description of CSRs 'TxImpedanceSE*' for field breakdown
                                                                                                     
  uint16_t DbTxImpedanceDiff;  // Byte Offset: 0x32 / CSR Address: 0x58019
                               // Drive-strength used for Dbyte DIFF slice (T&C)
                               // Refer to description of CSRs 'TxImpedanceDIFF*' for field breakdown

  uint16_t AcTxSlewSe;  // Byte Offset: 0x34 / CSR Address: 0x5801a
                        // Slew rate used for AC SE slices
                        // Refer to description of CSRs 'TxSlewSE*' for field description

  uint16_t AcTxSlewDiff;  // Byte Offset: 0x36 / CSR Address: 0x5801b
                          // Slew rate used for AC DIFF slice
                          // Refer to description of CSRs 'TxSlewDIFF*' for field description

  uint16_t DbTxSlewSe;  // Byte Offset: 0x38 / CSR Address: 0x5801c
                        // Slew rate used for Dbyte SE slice
                        // Refer to description of CSRs 'TxSlewSE*' for field description

  uint16_t DbTxSlewDiff;  // Byte Offset: 0x3a / CSR Address: 0x5801d
                          // Slew rate used for Dbyte DIFF slice(s) 
                          // Refer to description of CSRs 'TxSlewDIFF*' for field description

  uint16_t PubRev;  // Byte Offset: 0x3c / CSR Address: 0x5801e
                    // Must be written 0 unless directed by Synopsys

  uint16_t RESERVED_2[17];  // Byte Offset: 0x3e / CSR Address: 0x5801f
                            // Must be written to 0


  /////////////////////////////////////////
  // Impedance Calibration
  /////////////////////////////////////////

  uint8_t  ContinuousCal;  // Byte Offset: 0x60 / CSR Address: 0x58030
                           // ZCal continuous calibration enable
                           //    0x0 = Disable continuous calibration
                           //    0x1 = Enable  continuous calibration
                           // others = RESERVED

  uint8_t  CalInterval;  // Byte Offset: 0x61 / CSR Address: 0x58030
                         // Interval between ZCal calibrations when 
                         // continuous calibration is enabled.
                         // Refer to desciption of CSR field 'ZCalInterval' for field description

  uint16_t RESERVED_3[2];  // Byte Offset: 0x62 / CSR Address: 0x58031
                           // Must be written to 0

  /////////////////////////////////////////
  // PLL Lock / LCDL Calibrate Inputs
  /////////////////////////////////////////

  uint16_t MemClkToggle;  // Byte Offset: 0x66 / CSR Address: 0x58033
                          // MEMCLK toggle enable / division ratio
                          //
                          //      0x0 = MEMCLK does not toggle
                          //      0x1 = MEMCLK toggles at MEMCLK
                          //      0x2 = MEMCLK toggles at DFICLK / 2
                          //      0x3 = MEMCLK toggles at DFICLK / 4
                          //      0x4 = MEMCLK toggles at DFICLK / 8
                          //      0x5 = MEMCLK toggles at DFICLK / 16
                          //      0x6 = MEMCLK toggles at DFICLK / 24
                          //
                          //      All other values RESERVED.

  uint16_t MemClkTime;  // Byte Offset: 0x68 / CSR Address: 0x58034
                        // Duration of time (in DFI_CLKS) to generate slow clock.
                        //
                        //    0xFFFF = Infinite slow-clock mode.
                        //             PLL lock test will finish, leaving 
                        //             the slow-clock running.
                        //
                        //    Other Values = Test will wait for the specified number
                        //                   of DFICLKs to elapse, stop the slow
                        //                   clock, then proceed with the test list.
                        //

  uint16_t RESERVED_4[8];  // Byte Offset: 0x6a / CSR Address: 0x58035
                           // Must be written to 0

  /////////////////////////////////////////
  // LCDL Linearity Test Inputs
  /////////////////////////////////////////

  uint16_t LcdlClksToRun;  // Byte Offset: 0x7a / CSR Address: 0x5803d
                           // Clock cycles to run for each measurement

  uint16_t LcdlStartPhase;  // Byte Offset: 0x7c / CSR Address: 0x5803e
                            // Start Phase (0-511 decimal)
                            // RECOMMENDED: 0

  uint16_t LcdlEndPhase;  // Byte Offset: 0x7e / CSR Address: 0x5803f
                          // End Phase (0-511 decimal)
                          // Ideally as large as possible

  uint8_t  LcdlStride;  // Byte Offset: 0x80 / CSR Address: 0x58040
                        // Stride 1 to 100
                        // 0x01-0x64 = Use this value for stride
                        //    others = RESERVED

  uint8_t  LcdlPassPercent;  // Byte Offset: 0x81 / CSR Address: 0x58040
                             // Percentage of spec values to consider pass / fail
                             // 100 (decimal) = 100% = matches spec
                             // Numbers smaller than 100 tighten the tolerance
                             // Numbers larger than 100 loosen the tolerance

  uint16_t LcdlObserveCfg[4];  // Byte Offset: 0x82 / CSR Address: 0x58041
                               // LCDL Linearity Plot - LCDL selection inputs
                               //
                               // The ring-oscillator outputs for 4 LCDLs are saved
                               // to the msgBlock outputs 'LcdlCountValues'.
                               // This field selects which LCDLs to save the edge counts for.
                               //
                               //      LcdlObserveCfg[  15] - LCDL is in AC or Dbyte --- AC: (1), Dbyte: (0)
                               //      LcdlObserveCfg[14:4] - LCDL Index --------------- AC: (0-10), Dbyte: (0-30)
                               //      LcdlObserveCfg[ 3:0] - AC/Dbyte Instance -------- AC: (0-(NUM_AC-1)), Dbyte: (0-(NumDbyte-1))

  uint16_t RESERVED_5[4];  // Byte Offset: 0x8a / CSR Address: 0x58045
                           // Must be written to 0

  /////////////////////////////////////////
  // AC Loopback Test Inputs
  /////////////////////////////////////////

  uint16_t AcLoopLaneMask[2];  // Byte Offset: 0x92 / CSR Address: 0x58049
                               // Bit vector for disabling the checking on particular AC slices.
                               // Setting a bit to (1) disables checking on the cooresponding AC slice.
                               // If a slice instance does not exist, setting the cooresponding
                               // mask bit will have no effect on the outcome of the test.
                               //
                               //   Encoding of bit vector AcLoopLaneMask[AC_INSTANCE]:
                               //        [0..7] - SE0..SE7
                               //           [8] - DIFF
                               //       [9..10] - SEC0,SEC1
                               //      [11..15] - RESERVED
                               //

  uint16_t AcLoopClksToRun;  // Byte Offset: 0x96 / CSR Address: 0x5804b
                             // Clock cycles to run PRBS traffic through AC SE slices.
                             // 
                             //     1-65535: Wait the specified number of DFICLK cycles
                             //
                             //     0: Wait until user causes DctWriteProt to transition from 0 --> 1
                             //        Only supported if AcLoopMinLoopPwr=0x0
                             //

  uint8_t  AcLoopMinLoopPwr;  // Byte Offset: 0x98 / CSR Address: 0x5804c
                              // AC Loopback serial testing enable / disable
                              //
                              //    0x0 = ACs tested in parallel
                              //    0x1 = Only (1) AC active at a time

  uint8_t  AcLoopCoreLoopBk;  // Byte Offset: 0x99 / CSR Address: 0x5804c
                              // Pad / Core loopback
                              //    0x0 = Pad loopback
                              //    0x1 = Core loopback
                              //
                              //    Others RESERVED

  uint8_t  RESERVED_6;  // Byte Offset: 0x9a / CSR Address: 0x5804d
                        // Must be written to 0

  uint8_t  AcLoopIncrement;  // Byte Offset: 0x9b / CSR Address: 0x5804d
                             // Recomended value is 0x1 

  uint8_t  AcMinEyeWidthSe;  // Byte Offset: 0x9c / CSR Address: 0x5804e
                             // Required Eye width for the SE slices, in units of 1/64 UI

  uint8_t  AcMinEyeWidthDiff;  // Byte Offset: 0x9d / CSR Address: 0x5804e
                               // Required Eye width for the DIFF slices, in units of 1/64 UI

  uint8_t  AcLoopDiffTestMode;  // Byte Offset: 0x9e / CSR Address: 0x5804f
                                // AC Diff slice (CK) single-ended loopback testing control
                                // NOTE: If 'AcLoopCoreLoopBk' is (1), single-ended testing is disabled
                                //
                                // AC DIFF slice (CK) single-ended loopback testing control
                                //
                                //    AcLoopDiffTestMode[3:0]
                                //          = 0x0 - No single-ended testing
                                //          = 0x1 - Single-ended testing of CK_T
                                //          = Others RESERVED
                                //

  uint8_t  AcLoopDiffBitmapSel;  // Byte Offset: 0x9f / CSR Address: 0x5804f
                                 // Selects which bitmap results to store in 'AcLoopbackBitmapDiff'
                                 //
                                 //   NOTE: If a DIFF slice's single-ended testing is not enabled,
                                 //   no EYE will be saved.
                                 //
                                 //   AcLoopDiffBitmapSel[0] = CK Bitmap Select
                                 //      = 0x0 - Save differential CK bitmap
                                 //      = 0x1 - Save single-ended CK_T bitmap
                                 //

  uint16_t AcMinEyeWidthSec;  // Byte Offset: 0xa0 / CSR Address: 0x58050
                              // Required Eye width for the SEC slices, in units of 1/64 UI
                              //    1:2 - Ideal EYE width = 2UI
                              //    1:4 - Ideal EYE width = 4UI

  uint16_t RESERVED_7;  // Byte Offset: 0xa2 / CSR Address: 0x58051
                        // Must be written to 0

  /////////////////////////////////////////
  // Data Loopback Test Inputs
  /////////////////////////////////////////

  uint16_t DatLoopClksToRun;  // Byte Offset: 0xa4 / CSR Address: 0x58052
                              // Clock cycles to run PRBS traffic through Dbyte SE slices.
                              //
                              //     1-65535: Wait the specified number of DFICLK cycles
                              //
                              //     0: Wait until user causes DctWriteProt to transition from 0 --> 1
                              //        Only supported if DatLoopMinLoopPwr=0x0
                              //

  uint16_t DatLoopCoreLoopBk;  // Byte Offset: 0xa6 / CSR Address: 0x58053
                               // Pad / Core loopback
                               //    0x0 = Pad loopback
                               //    0x1 = Core loopback
                               //
                               //    Others RESERVED

  uint8_t  DatLoopMinLoopPwr;  // Byte Offset: 0xa8 / CSR Address: 0x58054
                               // Dbyte Loopback serial testing enable / disable
                               //
                               //    0x0 = Dbytes tested in parallel
                               //    0x1 = Only (1) Dbyte active at a time

  uint8_t  RESERVED_8;  // Byte Offset: 0xa9 / CSR Address: 0x58054
                        // Must be set to 0x0 

  uint16_t RESERVED_9;  // Byte Offset: 0xaa / CSR Address: 0x58055
                        // Must be set to 0x0 

  uint16_t TxDqsDly;  // Byte Offset: 0xac / CSR Address: 0x58056
                      // See CSR of the same name for description of contents
                      //     0xFFFF = Use default value

  uint16_t TxWckDly;  // Byte Offset: 0xae / CSR Address: 0x58057
                      // Only applies to LP5 enabled PHYs
                      // See CSR of the same name for description of contents
                      //     0xFFFF = Use default value

  uint16_t RxEnDly;  // Byte Offset: 0xb0 / CSR Address: 0x58058
                     // See CSR of the same name for description of contents
                     //     0xFFFF = Use default value

  uint16_t RxDigStrbDly;  // Byte Offset: 0xb2 / CSR Address: 0x58059
                          // See CSR of the same name for description of contents
                          //     0xFFFF = Use default value

  uint16_t RxClkT2UIDly;  // Byte Offset: 0xb4 / CSR Address: 0x5805a
                          // See CSR of the same name for description of contents
                          //     0xFFFF = Use default value
                          //
  uint16_t RxClkC2UIDly;  // Byte Offset: 0xb6 / CSR Address: 0x5805b
                          // See CSR of the same name for description of contents
                          //     0xFFFF = Use default value

  uint8_t  DatLoopDiffTestMode;  // Byte Offset: 0xb8 / CSR Address: 0x5805c
                                 // Dbyte DIFF slice (WCK + DQS) single-ended loopback testing control
                                 // NOTE: If 'DatLoopCoreLoopBk' is (1), single-ended testing is disabled,
                                 //       and DQS differential testing is run by default.
                                 //
                                 //    DatLoopDiffTestMode[0]   - Enables DQS   differential testing
                                 //    DatLoopDiffTestMode[1]   - Enables DQS_T single-ended testing if = 1
                                 //    DatLoopDiffTestMode[2]   - Enables DQS_C single-ended testing if = 1
                                 //    DatLoopDiffTestMode[3]   - Enables WCK_T single-ended testing if = 1
                                 //    DatLoopDiffTestMode[4]   - Enables WCK_C single-ended testing if = 1
                                 //    DatLoopDiffTestMode[7:5] - RESERVED
                                 //       

  uint8_t  DatLoopDiffBitmapSel;  // Byte Offset: 0xb9 / CSR Address: 0x5805c
                                  //  Selects which bitmap results to store in 
                                  //  'DatLoopbackWckBitmap' and 'DatLoopbackDqsBitmap'
                                  //
                                  //  NOTE: If a DIFF slice's single-ended testing is not enabled,
                                  //  but the bitmap has been selected, the output bitmap will
                                  //  contain all 1's.
                                  //
                                  //  DatLoopDiffBitmapSel[3:0] = DQS Bitmap Select
                                  //     = 0x0 - Save differential DQS bitmap
                                  //     = 0x1 - Save single-ended DQS_T bitmap
                                  //     = 0x2 - Save single-ended DQS_C bitmap
                                  //     Others Reserved
                                  //
                                  //  DatLoopDiffBitmapSel[7:4] = WCK Bitmap Select
                                  //  Ignored if 'DatLoopDiffTestMode[3:2] = 0
                                  //     = 0x0 - Save differential WCK bitmap
                                  //     = 0x1 - Save single-ended WCK_T bitmap
                                  //     = 0x2 - Save single-ended WCK_C bitmap
                                  //     Others Reserved


  uint8_t  DatLoopCoarseStart;  // Byte Offset: 0xba / CSR Address: 0x5805d
                                // Starting coarse value for the Data loopback search

  uint8_t  DatLoopCoarseEnd;  // Byte Offset: 0xbb / CSR Address: 0x5805d
                              // Ending coarse value for the Data loopback search

  uint8_t  DatLoopFineIncr;  // Byte Offset: 0xbc / CSR Address: 0x5805e
                             // Value to increment delay by for the Data loopback search
                             // This value is in fine delay values.

  uint8_t  DatLoopMinEyeWidth;  // Byte Offset: 0xbd / CSR Address: 0x5805e
                                // Minimum Eye width for data loopback tests

  uint8_t  DatLoopByte;  // Byte Offset: 0xbe / CSR Address: 0x5805f
                         // Dbyte instance to test for 2D loopback
                         // Qualifies 'DatLoopBit'
                         //   Legal values: [0:NumDbyte-1]

  uint8_t  DatLoopBit;  // Byte Offset: 0xbf / CSR Address: 0x5805f
                        // Dbyte slice to test for 2D loopback
                        // Qualifies 'DatLoopByte'
                        //    Legal values: [0:NumSeSlices-1]

  uint8_t  DatLoop2dVrefStart;  // Byte Offset: 0xc0 / CSR Address: 0x58060
                                // Initial value of Vref used during the 2D loopback measurement

  uint8_t  DatLoop2dVrefEnd;  // Byte Offset: 0xc1 / CSR Address: 0x58060
                              // Upper bound of Vref used during the 2D loopback measurement

  uint8_t  DatLoop2dVrefIncr;  // Byte Offset: 0xc2 / CSR Address: 0x58061
                               // Vref Increment size (1-63) for 2D loopback measurement

  uint8_t  RESERVED_10;  // Byte Offset: 0xc3 / CSR Address: 0x58061
                         // Must be set to 0x0 

  uint16_t RESERVED_11[5];  // Byte Offset: 0xc4 / CSR Address: 0x58062
                            // Must be written to 0

  /////////////////////////////////////////
  // DCA Loopback Test Inputs
  /////////////////////////////////////////

  uint8_t  DcaLoopMinLoopPwr;  // Byte Offset: 0xce / CSR Address: 0x58067
                               // DCA Loopback serial testing enable / disable
                               // 
                               //     0x0 = All WCK slices tested in parallel
                               //     0x1 = Only (1) WCK slice active at a time

  uint8_t  DcaLoopDelayIncr;  // Byte Offset: 0xcf / CSR Address: 0x58067
                              // When constructing WCK EYEs at a particular DCA
                              // setting, this controls the delay increment


  uint8_t  DcaLoopDcaCoarseSkip;  // Byte Offset: 0xd0 / CSR Address: 0x58068
                                  // By default, all 4 DCA coarse settings are tested
                                  // If Bit[i]=0x1, Coarse=i will be skipped
                                  //
                                  //   Bit[0] = Skip DCA Coarse=0
                                  //   Bit[1] = Skip DCA Coarse=1
                                  //   Bit[2] = Skip DCA Coarse=2
                                  //   Bit[3] = Skip DCA Coarse=3
                                  //
                                  //   Others RESERVED

  uint8_t  DcaLoopDcaFineIncr;  // Byte Offset: 0xd1 / CSR Address: 0x58068
                                // Increment used to sweep the 13 DCA fine settings (0-12).
                                // 
                                //     Valid values = {1,2,3,6}

  uint8_t  DcaLoopBitmapSel;  // Byte Offset: 0xd2 / CSR Address: 0x58069
                              // Selects which DCA WCK bitmaps will be saved
                              // in the output 'DcaLoopBitmap'.
                              //
                              //    Valid values = 0-(NumDbytes-1)

  uint8_t  RESERVED_12;  // Byte Offset: 0xd3 / CSR Address: 0x58069
                         // Must be written to 0

  /////////////////////////////////////////
  // === End of INPUTS ===
  /////////////////////////////////////////

  uint32_t RESERVED_IO_BOUNDARY;  // Byte Offset: 0xd4 / CSR Address: 0x5806a
                                  // Must be set to 0x0

  /////////////////////////////////////////
  // Impedance Calibration Test Results
  /////////////////////////////////////////

  uint8_t  ZCalCodePU;  // Byte Offset: 0xd8 / CSR Address: 0x5806c
                        // Output from Impedance Calibration (PU Code)
                        // See CSR of the same name for description of contents.

  uint8_t  ZCalCodePD;  // Byte Offset: 0xd9 / CSR Address: 0x5806c
                        // Output from Impedance Calibration (PD Code)
                        // See CSR of the same name for description of contents.

  uint8_t  ZCalCompResult;  // Byte Offset: 0xda / CSR Address: 0x5806d
                            // Output from Impedance Calibration (Comp Code)
                            // See CSR of the same name for description of contents.

  uint8_t  RESERVED_13;  // Byte Offset: 0xdb / CSR Address: 0x5806d
                         // Must Be set to 0x0

  uint16_t RESERVED_14[16];  // Byte Offset: 0xdc / CSR Address: 0x5806e
                             // Must be written to 0

  /////////////////////////////////////////
  // PLL / LCDL Test Results
  /////////////////////////////////////////

  uint16_t LcdlResultsAc[2];  // Byte Offset: 0xfc / CSR Address: 0x5807e
                              // Array indexed using AC instance
                              // Bit[LcdlNumAc] will be set to (1) if the 
                              // cooresponding LCDL FAILED the 1UI lock check.
                              // 
                              //    LcdlNumAc Encoding:
                              //
                              //        0 = SE0
                              //        1 = SE1
                              //        2 = SE2
                              //        3 = SE3
                              //        4 = SE4
                              //        5 = SE5
                              //        6 = SE6
                              //        7 = SE7
                              //        8 = SEC0
                              //        9 = SEC1
                              //       10 = DIFF


  uint32_t LcdlResultsDb[4];  // Byte Offset: 0x100 / CSR Address: 0x58080
                              // Array indexed using Dbyte instance 
                              // Bit[LcdlNumDb] will be set if the cooresponding LCDL
                              // failed the 1UI lock check
                              //
                              //    LcdlNumDb Encoding:
                              //
                              //      0 = TxDq_r0
                              //      1 = TxDq_r1
                              //      2 = TxDq_r2
                              //      3 = TxDq_r3
                              //      4 = TxDq_r4
                              //      5 = TxDq_r5
                              //      6 = TxDq_r6
                              //      7 = TxDq_r7
                              //      8 = TxDq_r8
                              //      9 = TxDqs
                              //     10 = RxEn
                              //     11 = RxClkT_r0
                              //     12 = RxClkT_r1
                              //     13 = RxClkT_r2
                              //     14 = RxClkT_r3
                              //     15 = RxClkT_r4
                              //     16 = RxClkT_r5
                              //     17 = RxClkT_r6
                              //     18 = RxClkT_r7
                              //     19 = RxClkT_r8
                              //     20 = RxClkC_r0 
                              //     21 = RxClkC_r1
                              //     22 = RxClkC_r2
                              //     23 = RxClkC_r3
                              //     24 = RxClkC_r4
                              //     25 = RxClkC_r5
                              //     26 = RxClkC_r6
                              //     27 = RxClkC_r7
                              //     28 = RxClkC_r8
                              //     29 = WCK (If Exists)

  uint16_t LcdlResultsRxReplica;  // Byte Offset: 0x110 / CSR Address: 0x58088
                                  // Bit[LcdlNumRxReplica] will be set if the cooresponding RxReplica LCDL
                                  // failed the 1UI lock check.
                                  //
                                  // LcdlNumRxReplica = 0,1..NumDb-1

  uint16_t PLLResults;  // Byte Offset: 0x112 / CSR Address: 0x58089
                        // Indicates status of PLL Locking operation
                        // Bits[3:0] - PLL Lock Results
                        //    0x1 = PLL lock process succeeded
                        //    0x2 = PLL lock process failed
                        // Others = RESERVED
                        //
                        // Bits[15:4] = RESERVED

  uint16_t RESERVED_15[16];  // Byte Offset: 0x114 / CSR Address: 0x5808a
                             // Must be written to 0

  /////////////////////////////////////////
  // LCDL Linearity Test Results
  /////////////////////////////////////////

  uint16_t LcdlErrCntDb[4][31];  // Byte Offset: 0x134 / CSR Address: 0x5809a
                                 //
                                 // Defined as: LcdlErrCntDb[DbyteNum][LcdlNumber]
                                 // Contains how many points failed linearity for each LCDL
                                 //
                                 //  Where LcdlNumber is encoded as:
                                 //
                                 //      0 = TxDq_r0
                                 //      1 = TxDq_r1
                                 //      2 = TxDq_r2
                                 //      3 = TxDq_r3
                                 //      4 = TxDq_r4
                                 //      5 = TxDq_r5
                                 //      6 = TxDq_r6
                                 //      7 = TxDq_r7
                                 //      8 = TxDq_r8
                                 //      9 = TxDqs
                                 //     10 = RxEn
                                 //     11 = RxRep
                                 //     12 = RxClkT_r0
                                 //     13 = RxClkT_r1
                                 //     14 = RxClkT_r2
                                 //     15 = RxClkT_r3
                                 //     16 = RxClkT_r4
                                 //     17 = RxClkT_r5
                                 //     18 = RxClkT_r6
                                 //     19 = RxClkT_r7
                                 //     20 = RxClkT_r8
                                 //     21 = RxClkC_r0 
                                 //     22 = RxClkC_r1
                                 //     23 = RxClkC_r2
                                 //     24 = RxClkC_r3
                                 //     25 = RxClkC_r4
                                 //     26 = RxClkC_r5
                                 //     27 = RxClkC_r6
                                 //     28 = RxClkC_r7
                                 //     29 = RxClkC_r8
                                 //     30 = WCK (If Exists)

  uint16_t LcdlErrCntAc[2][11];  // Byte Offset: 0x22c / CSR Address: 0x58116
                                 // 
                                 // Defined as: LcdlErrCntByAc[AcNum][LcdlNum]
                                 // Contains how many points failed linearity for each LCDL
                                 //
                                 //  Where LcdlNumber is encoded as:
                                 //
                                 //     0 = SE0
                                 //     1 = SE1
                                 //     2 = SE2
                                 //     3 = SE3
                                 //     4 = SE4
                                 //     5 = SE5
                                 //     6 = SE6
                                 //     7 = SE7
                                 //     8 = SEC0
                                 //     9 = SEC1
                                 //    10 = DIFF
                                 //     

  uint16_t LcdlCountValues[4][512];  // Byte Offset: 0x258 / CSR Address: 0x5812c
                                     // LCDL Linearity Plotting  Ring Oscillator Edge Count Values
                                     // Selected using msgBlk inputs 'LcdlObserveCfg'

  /////////////////////////////////////////
  // AC Loopback Test Results
  /////////////////////////////////////////

  uint16_t RESERVED_16;  // Byte Offset: 0x1258 / CSR Address: 0x5892c
                         // Must be written to 0

  uint16_t RESERVED_17;  // Byte Offset: 0x125a / CSR Address: 0x5892d
                         // Must be written to 0

  uint16_t AcLoopbackStuckAtSe[2];  // Byte Offset: 0x125c / CSR Address: 0x5892e
                                    // Defined as: AcLoopbackStuckAtSe[AcNum]
                                    // 
                                    // bit[SeSliceNum]
                                    //    0x0 = AC[AcNum][SeSliceNum] PASSED stuck-at testing
                                    //    0x1 = AC[AcNum][SeSliceNum] FAILED stuck-at testing

  uint64_t AcLoopbackBitmapSe[2][8][2];  // Byte Offset: 0x1260 / CSR Address: 0x58930
                                         // Defined as:  AcLoopbackBitmapSe[AcNum][SeSliceNum][UI0/1]
                                         // Contains 1D EYE for each SE slice
                                         // EYE is 2UI wide

  uint64_t AcLoopbackBitmapSec[2][2][5];  // Byte Offset: 0x1360 / CSR Address: 0x589b0
                                          // Defined as: AcLoopbackBitmapSec[AcNum][SecSliceNum][UI0/1/2/3/4]
                                          // Contains 1D EYE for each AC SEC slice
                                          // Up to 5UI worth of EYE data is saved.
                                          // The exact number of UIs saved is stored in 'AcLoopbackNumUiSec'

  uint64_t AcLoopbackBitmapDiff[2][1][3];  // Byte Offset: 0x1400 / CSR Address: 0x58a00
                                           // Defined as: AcLoopbackBitmapDiff[AcNum][DiffSliceNum][UI0/1/2]
                                           // Contains 1D EYE for each AC DIFF slice
                                           // Up to 3UI worth of EYE data is saved.
                                           // The exact number of UIs saved is stored in 'AcLoopbackNumUiDiff'

  uint8_t  AcLoopbackNumUiSec[2][2];  // Byte Offset: 0x1430 / CSR Address: 0x58a18
                                      // The number of UIs that contained passing regions in 
                                      // the cooresponding AC SEC EYE in 'AcLoopbackBitmapSec'

  uint8_t  AcLoopbackNumUiDiff[2][1];  // Byte Offset: 0x1434 / CSR Address: 0x58a1a
                                       // The number of UIs that contained passing regions in 
                                       // the cooresponding AC DIFF EYE in 'AcLoopbackBitmapDiff'

  uint16_t RESERVED_18;  // Byte Offset: 0x1436 / CSR Address: 0x58a1b
                         // Must be written to 0


  /////////////////////////////////////////
  // Data Loopback 1D Test Results
  /////////////////////////////////////////

  uint8_t  DatLoopbackNumUiWck[4];  // Byte Offset: 0x1438 / CSR Address: 0x58a1c
                                    // The number of UIs that contained passing regions in 
                                    // the cooresponding Dbyte WCK EYE in 'DatLoopbackWckBitmap'

  uint16_t DatLoopbackRxEnbVal[4];  // Byte Offset: 0x143c / CSR Address: 0x58a1e
                                    // Defined as DatLoopbackRxEnbVal[DbyteNum]
                                    // Data loopback RxEnable delay values
                                    // Only populated in pad-side loopback.

  uint8_t  DatLoopbackCoarse[4][9];  // Byte Offset: 0x1444 / CSR Address: 0x58a22
                                     // Defined as DatLoopbackCoarse[DbyteNum][SeSliceNum]
                                     // Data loopback eye bitmap starting coarse value, indexed by Dbyte and Lane 
                                     // DatLoopbackCoarse[DbyteNum][7:0] are DQ[7:0] for DbyteNum
                                     // DatLoopbackCoarse[DbyteNum][8] is DM/DBI for DbyteNum

  uint64_t DatLoopbackBitmap[4][9][2];  // Byte Offset: 0x1468 / CSR Address: 0x58a34
                                        // Defined as DatLoopbackBitmap[DbyteNum][SeSliceNum][UI0/1]
                                        // Data loopback eye bitmap indexed by Dbyte and SE slice 
                                        // DatLoopbackBitmap[DbyteNumber][7:0] are DQ[7:0] for DbyteNumber
                                        // DatLoopbackBitmap[DbyteNumber][8] is DM/DBI for DbyteNumber

  uint64_t DatLoopbackWckBitmap[4][3];  // Byte Offset: 0x16a8 / CSR Address: 0x58b54
                                        // Defined as DatLoopbackWckBitmap[DbyteNum][UI0/1/2]
                                        // Up to 3UI worth of EYE data is saved for the WCK DIFF slice 
                                        // in each Dbyte instance (if it exists).A (0) in a bit position 
                                        // indicates loopback operates correctly at that setting, and (1)
                                        // indicates failure at that setting.
                                        // The exact number of UIs saved is stored in 'DatLoopbackNumUiWck'
                                        // Only valid if WCK slices exist
 
  uint64_t DatLoopbackDqsBitmap[4][2];  // Byte Offset: 0x1708 / CSR Address: 0x58b84
                                        // Defined as DatLoopbackDqsBitmap[DbyteNum][UI0/1]
                                        // Only populated in core-loopback mode or if enabled
                                        // using 'DatLoopDiffTestMode' in pad-loopback mode

  uint8_t  DatLoopbackWckCoarse[4];  // Byte Offset: 0x1748 / CSR Address: 0x58ba4
                                     // Defined as DatLoopbackWckCoarse[DbyteNum]                                                             // WCK Diff slice loopback eye bitmap starting coarse value, 
                                     // indexed by Dbyte 
  uint8_t  DatLoopbackDqsCoarse[4];  // Byte Offset: 0x174c / CSR Address: 0x58ba6
                                     // Defined as DatLoopbackDqsCoarse[DbyteNum]                                                             // DQS Diff slice loopback eye bitmap starting coarse value, 
                                     // indexed by Dbyte

  uint64_t RESERVED_19;  // Byte Offset: 0x1750 / CSR Address: 0x58ba8
                         // Must be written to 0x0

  uint64_t RESERVED_20[15];  // Byte Offset: 0x1758 / CSR Address: 0x58bac
                             // Must be written to 0x0
 
 
  /////////////////////////////////////////
  // Data Loopback 2D Test Results
  /////////////////////////////////////////

  uint8_t  DatLoop2dVrefCoarse[128];  // Byte Offset: 0x17d0 / CSR Address: 0x58be8
                                      // Data Loopback bitmaps coarse starting value per Vref for SE slice
                                      // selected using DatLoopByte / DatLoopBit.
                                      //
                                      // The first roundUp[(VrefEnd-VrefStart)/VrefIncr] entries will be valid.
                                      // The rest will be initialized to 0xFF.

  uint64_t DatLoop2dVrefBitmap[128][2];  // Byte Offset: 0x1850 / CSR Address: 0x58c28
                                         // Data Loopback bitmaps per Vref for the SE slice selected
                                         // using DatLoopByte / DatLoopBit.
                                         //
                                         // The first roundUp[(VrefEnd-VrefStart)/VrefIncr] entries will 
                                         // contain valid 2UI wide 1D EYEs.  
                                         // The rest will be initialized to all 1's.
  uint16_t DatLoop2dDbyteBitFail[4];  // Byte Offset: 0x2050 / CSR Address: 0x59028
                                      // Array indicates if DBYTE bits have failed the 'MinEyeWidth' check at any VREF value.
                                      // Index of array is the DBYTE, and bits [8:0] coorespond to the bits of a particular DBYTE.
                                      // Bits [15:9] are RESERVED.
                                      // If (DatLoop2dDbyteBitFail[DBYTE] & (1 << bit)) equals:
                                      // 0 - The cooresponding DBYTE bit passed all eye width checks accross tested VREFs
                                      // 1 - The cooresponding DBYTE bit failed an eye width check on one or more tested VREFs


  uint64_t RESERVED_21[13];  // Byte Offset: 0x2058 / CSR Address: 0x5902c
                             // Must be written to 0x0
 
  /////////////////////////////////////////
  // DCA Loopback Test Results
  /////////////////////////////////////////

  uint16_t RESERVED_22[4];  // Byte Offset: 0x20c0 / CSR Address: 0x59060
                            // Must be written to 0x0
  uint16_t Dca_Delay[4][2];  // Byte Offset: 0x20c8 / CSR Address: 0x59064
                             // Defined as Dca_Delay[DbyteNum][Dca_Delay0/Dca_Delay1]
                             // Starting delay of the DcaLoopBitmap.
                             // Dca_Delay[DbyteNum][Dca_Delay0] is for DcaCoarse = 0 and DcaFine = 0;
                             // Dca_Delay[DbyteNum][Dca_Delay1] is for all subsequent ones.
               

  uint8_t  DcaLoopMaxEyeWidth[4][4][13];  // Byte Offset: 0x20d8 / CSR Address: 0x5906c
                                          // Defined as DcaLoopMaxEyeWidth[DbyteNum][DcaCoarse][DcaFine]
                                          // The max eye width for each WCK slice at each
                                          // tested DCA coarse and fine setting.
                                          //
                                          // The max EYE width is size of the widest 
                                          // contiugous passing region of the EYE.

  uint64_t DcaLoopBitmap[4][13][3];  // Byte Offset: 0x21a8 / CSR Address: 0x590d4
                                     // Defined as DcaLoopBitmap[DcaCoarse][DcaFine][UI0/1/2]
                                     // The up-to 3UI wide bitmaps found at each tested 
                                     // DCA coarse and fine setting for the WCK 
                                     // slice selected using the input DcaLoopBitmapSel.

  uint8_t  DcaLoopNumUi[4][13];  // Byte Offset: 0x2688 / CSR Address: 0x59344
                                 // Defined as DcaLoopNumUi[DcaCoarse][DcaFine]
                                 // The number of UIs required to capture each EYE 
                                 // in DcaLoopBitmap.

  /////////////////////////////////////////
  // RxReplica Test Results
  /////////////////////////////////////////

  uint16_t RxReplica1UiLockCode[4];  // Byte Offset: 0x26bc / CSR Address: 0x5935e
                                     // Defined as RxReplica1UiLockCode[DbyteNum]
                                     // The 1UI lock code for the LCDL for each RxReplca

  uint16_t RxReplicaPathPhase[4][5];  // Byte Offset: 0x26c4 / CSR Address: 0x59362
                                      // Defined as RxReplicaPathPhase[DbyteNum][PathPhase]
                                      // The (5) path-phase values for each RxReplca 

  /////////////////////////////////////////
  // Ac loopback Test Results -New added
  /////////////////////////////////////////

  uint8_t  AcLoopbackCoarseSec[2][2];  // Byte Offset: 0x26ec / CSR Address: 0x59376
                                       // Defined as AcLoopbackCoarseSec[AcNum][SecSliceNum] 
                                       // AC SEC slice loopback eye bitmap starting coarse value, 
                                       // indexed by AcNum and SecSliceNum
  uint8_t  AcLoopbackCoarseDiff[2][1];  // Byte Offset: 0x26f0 / CSR Address: 0x59378
                                        // Defined as AcLoopbackCoarseDiff[AcNum][DiffSliceNum]    
                                        // AC Diff slice loopback eye bitmap starting coarse value, 
                                        // indexed by AcNum and DiffSliceNum

  uint16_t RESERVED_23;  // Byte Offset: 0x26f2 / CSR Address: 0x59379
                         // Must be written to 0x0

  /////////////////////////////////////////
  // End With Reserved Field
  /////////////////////////////////////////

  uint32_t RESERVED_END;  // Byte Offset: 0x26f4 / CSR Address: 0x5937a
                          // Must be written to 0x0


} __attribute__ ((packed)) PMU_SMB_ATE_t; // Structure size = 9976 bytes

#endif // _MNPMUSRAMMSGBLOCK_ATE_H
