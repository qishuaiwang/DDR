Copyright 2021 Synopsys, Inc.
This Synopsys IP and all associated documentation are proprietary to
Synopsys, Inc. and may only be used pursuant to the terms and conditions
of a written license agreement with Synopsys, Inc. All other use,
reproduction, modification, or distribution of the Synopsys IP or the
associated documentation is strictly prohibited.
------------------------------------------------------------------
Release Notes - LPDDR54 PHY PHYINIT
------------------------------------------------------------------------------ 

The PHYINIT software is a utility intended to provide usability assistance and 
guidance to customers for PHY initialization, in the form of overall procedure 
and CSR writes/configurations. The PHYINIT is intended to be a supplement to 
be used in conjunction with all PHY related documentation (PUB/PHY Databooks, 
Application Notes, Stars on the Web, and others). The user must follow the 
procedures and CSR writes/configurations as outlined in the documentation, and 
must not solely rely on the PHYINIT utility to guarantee correct operation for 
their configuration, platform, SoC and other implementation specific 
considerations.  


------------------------------------------------------------------------------ 
Version C-2021.10
-----------------
October 21, 2021

Changes from version C-2021.06
(mandatory)

This version of PHYINIT supports:

Bug fixes:
----------
- STAR 3711508: Update phyinit html documentation for correct PLL setting on CSR PllCtrl1, PllCtrl4 and PllUPllProg0/1/2/3
- STAR 3768093: Add DFIPHYUPD csr to retention restore list
- STAR 3740916: Update "TxStrenCode" when LP4X mode and higher VOH are both selected (it is correct in all other cases)
- STAR 3863091: Update the assertion to check maximum range of CK frequency 

Enhancements:
-------------
- Update default HardMacroVer to "1" for the "B" family in "dwc_ddrphy_phyinit_struct.h" file
- Remove redundant code inside Phyinit Step C which is not required 
- In LP4 mode, set csr HclkEn to 0 to reduce power at the end of saveRetRegs()
- Add assertion that when write ecc is enabled, read ecc is also enabled 
- Update Comments for the "pUserInputBasic->Frequency" parameter in "setDefault.c" to explain both dfi frequency ratio 1:2 mode and 1:4 mode 

Input Changes:
--------------
- None

Limitations:
------------
- The minimum supported size of the PState SRAM is 1024 entries per PState
- The only supported value of NumDbytesPerCh is 2
- PUB2.x Incremental retraining (PPT2) works with the following restriction:
  + The Maximum Runtime of 500ns is valid only when all pstates use only WL(setA) definition, not WL(setB) definition


Compiler Version:
-----------------
Compiler version used during the QA testing of this release
- gcc 4.7.2

Current Compatible Versions 
------------------------- 
- PUB:  1.x and 2.x
- Firmware: C-2021.10
- CTB:      C-2021.10


------------------------------------------------------------------------------ 
Version C-2021.06
-----------------
June 01, 2021

Changes from version C-2021.03
(mandatory)

This version of PHYINIT supports:

Enhancements:
-------------
- Remove the programming of the LP5 specific CSR RxModeCtlDIFF1 in LPDDR4 mode (LPDDR4)
- Update example code in "_userCustom_" files to use correct function input parameters
- Add a checker to enforce the supported user input "NumDbytesPerCh" value
- Add "set default" access to firmware Message block fields "MR21", "MR51" to support new JEDEC LPDDR4X spec "JESD209-4-1A" (LPDDR4)
- Remove obsolete CSR PllTestMode reference in HTML Application Note
- Update code to comply with MISRA-C 2012 coding guidelines

Bug fixes:
----------
- STAR 3673470: Initialize CSR TxDcaMode to "0" before Training Firmware is run
- STAR 3671235: Assert RESET until Training Firmware starts toggling CK_t/c
- STAR 3716315: Fix I/O PAD goes 'X' in RDQS strobe-less mode (LPDDR5, PUB=1.x)
- STAR 3673078: Add "set default" access to firmware Message block field "Misc" (LPDDR5)

Input Changes:
--------------
- None

Limitations:
------------
- The minimum supported size of the PState SRAM is 1024 entries per PState
- The only supported value of NumDbytesPerCh is 2
- PUB2.x Incremental retraining (PPT2) works with the following restriction:
  + The Maximum Runtime of 500ns is valid only when all pstates use only WL(setA) definition, not WL(setB) definition

Known issues:
-------------
- Analog PLL settings are not final (PllCtrl3: PlForceCal, PllEnCal), no impact on digital simulations

Compiler Version:
-----------------
Compiler version used during the QA testing of this release
- gcc 4.7.2

Current Compatible Versions 
------------------------- 
- PUB:  1.x and 2.x
- Firmware: C-2021.06
- CTB:      C-2021.06


------------------------------------------------------------------------------ 
Version C-2021.03
-----------------
March 12, 2021

Changes from version C-2020.11
(recommended)

This version of PHYINIT supports:

Enhancements:
-------------
- Update PIE code programming to comply with "tWCKSTOP" timing requirement introduced in LPDDR5 JEDEC ballot#1862.12 (LPDDR5)
- Add a checker to enforce correct data rate per RxReplica drift detection and compensation requirement
- Turn off the clock to the ACSM block at LP3 entry to save power (PUB2.x)
- By default set the AC CSR clocks to run only while a CSR write is happening instead of continuously running
- Move the programming of CSR TxDcaMode from PhyInit to Training Firmware (LPDDR5)

Bug fixes:
----------
- STAR 3270520: Fix the programming of CSR RxDiffSeVrefDACDIFF0 in skip training mode
- STAR 3510505: Fix the programming of firmware message block input "Train2DMisc (2D Training Miscellaneous Control)"
- STAR 3549330: Fix PIE code to comply with LPDDR5 JEDEC spec defined "tPDXCSODTON" timing requirement  (LPDDR5)
- STAR 3555336: Enable the simulation feature "skip DMEM loading"
- STAR 3458842: Update the CSR restore list for Retention Exit

Input Changes:
--------------
- None

Limitations:
------------
- The minimum supported size of the PState SRAM is 1024 entries per PState
- The only supported value of NumDbytesPerCh is 2
- PUB2.x Incremental retraining (PPT2) works with the following restriction:
  + The Maximum Runtime of 500ns is valid only when all pstates use only WL(setA) definition, not WL(setB) definition

Known issues:
-------------
- Analog PLL settings are not final (PllCtrl3: PlForceCal, PllEnCal), no impact on digital simulations
- The CalCompVrefDAC[6:0] setting is not final
- In RDQS strobe-less mode, I/O PAD goes 'X' (LPDDR5, PUB=1.x)

Compiler Version:
-----------------
Compiler version used during the QA testing of this release
- gcc 4.7.2

Current Compatible Versions 
------------------------- 
- PUB:  1.x and 2.x
- Firmware: C-2021.03
- CTB:      C-2021.03


------------------------------------------------------------------------------ 
Version C-2020.11
-----------------
November 20, 2020

Changes from version A-2020.09 and B-2020.09
(recommended)

This version of PHYINIT supports:

Enhancements:
-------------
- A single PHYINIT release supports all PUB revisions. Users are required to specify the "PUB=<PHY RTL major revision>" (set PUB=1 for all PUB 1.x revisions, set PUB=2 for all PUB 2.x revisions), along with the "FIRMWARE_PATH" setting.
  For example,    
  + make PUB=1 FIRMWARE_PATH=...
  + make PUB=2 FIRMWARE_PATH=...
- Add a new user custom function dwc_ddrphy_phyinit_userCustom_wait() to help meeting timing requirement for register MicroContMuxSel. Please refer to PUB databook for details.
- Incremental retraining (PPT2) is now available as an experimental feature with the newer PUB RTL revision (PUB 2.10a):
  + Adjust PPT2 MPC_WRITE_FIFO to MPC_READ_FIFO timing. (LPDDR4)
  + Update PPT2 Write Latency and Write-to-Read timing. (LPDDR4)
- Allow different per-rank settings when restoring MR17 (LPDDR5) and MR22 (LPDDR4) during frequency changes.
- Restore different uppper byte and lower byte settings for MR12 in x8 mode, during frequency changes. (LPDDR5)
- Update PLL bypass scheme for 1:2 frequency ratio to allow the fastest data rates using a lower bypass clock frequency. This is aligned with newer PUB databook.
- Set RxReplica Short calibration Range-A and Range-B to equal value to avoid debug feature misfire when doing Re-Lock only and FlashCopy.

Bug fixes:
----------
- STAR 3465182: Fix PLL Bypass frequency threshold to be Frequency Ratio dependent. (LPDDR5)
- STAR 3422413: Fix incorrectly declared array sizes in file "dwc_ddrphy_phyinit_progCsrSkipTrain.c" to avoid buffer overrun issues corrupting the stack.
- STAR 3465195: PHY sends DES instead of NOP after MRWs to comply with JEDEC spec tMRD requirement. (LPDDR5)

Input Changes:
--------------
- Change PHYINIT user input RxClkTrackEn default value to be 0.

Limitations:
------------
- The minimum supported size of the PState SRAM is 1024 entries per PState.
- The only supported value of NumDbytesPerCh is 2.
- tinit_start is out of specified range when restoring the Mode Registers on a PState change.
- Incremental retraining (PPT2) works with the following restriction:
  + The Maximum Runtime of 500ns is valid only when all pstates use only WL(setA) definition, not WL(setB) definition.

Known issues:
-------------
- Analog PLL settings are not final (PllCtrl3: PlForceCal, PllEnCal), no impact on digital simulations.
- The CalCompVrefDAC[6:0] setting is not final.
- In RDQS strobe-less mode, I/O PAD goes 'X' (LPDDR5, PUB=1)

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2

Current Compatible Versions 
------------------------- 
- PHY PUB:  1.x and 2.x
- Firmware: C-2020.11
- CTB:      C-2020.11


------------------------------------------------------------------------------ 
Version A-2020.09
-----------------
September 25, 2020

Changes from version A-2020.06 
(recommended)

This version of PhyInit supports:

Enhancements:
-------------
- Reduce PLL relock time from 10us to 2us
- Update some of the user input descriptions to improve clarity
- Support new dfi_frequency encodings dedicated to enter/exit LP2 state

Bug fixes:
----------
- Fix clock stop behavior to ensure both CK_C and CK_T stop at the same time
- Fix programming of RxDiffSeVrefDACDIFF0 to avoid rounding error that affects Single Ended Mode
- Adjust the RxClk delay setup in SkipTrain to avoid a possible underflow
- Fix CSR write order to DfiClkAcLnDis and PClkAcLnDis to improve power savings
- Move programming of PwrOkDlyCtrl CSR from step C to progCsrSkipTrain to eliminate a race condition
- Fix PPT DQ drift compensation when there is different drift in different ranks and different channels 
- Set the frequency threshold according to the highest data rate for disabling PPT
- Stop CK during ZCAL update to avoid a CK glitch

Input Changes:
--------------
- Added RelockOnlyCntrl advanced input to control the behavior of Relock-Only frequency change
- Added SkipFlashCopy advanced input to skip copy of initial trained data during Relock-Only frequency change
- Change back user input EnRxDqsTracking to be per-PState

Limitations:
------------
- "SkipFlashCopy" feature can only be enabled when operating above 667 Mbps
- New LP2 encoding is only supported if "SkipFlashCopy" feature is enabled and user input "RelockOnlyCntrl" is set to 0
- User input "EnRxDqsTracking" is reserved for future use
- The minimum supported size of the PState SRAM is 1024 entries per PState
- The only supported value of NumDbytesPerCh is 2
- tinit_start is out of specified range when restoring the Mode Registers on a PState change and when using skip_retrain_enhancement=1
- User input "SkipRetrainEnhancement" is reserved

Known issues:
-------------
- In RDQS strobe-less mode, I/O PAD goes 'X' (LPDDR5)
- Analog PLL settings not final (PllCtrl3: PlForceCal, PllEnCal), no impact on digital simulations
- The CalCompVrefDAC[6:0] setting is not final
- The same SoC ODT setting for MR17 (LPDDR5) / MR22 (LPDDR4) is used for both ranks

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2

Current Compatible Versions 
------------------------- 
- PHY PUB:  1.x
- Firmware: A-2020.09
- CTB:      A-2020.09


------------------------------------------------------------------------------
Version A-2020.06
-----------------
June 30, 2020

Changes from version A-2020.03-T-53919
(recommended)

This version of PhyInit supports:

Enhancements:
-------------
- Restore trained Mode Registers during PState change
  + MR12, 14 (LPDDR4)
  + MR12, 14, 15, 24, 30 (LPDDR5)
- Restore MR22 on a PState change (LPDDR4).
- Restore trained CSR values from PState SRAM on PState change.
- Move vrefDac initialization to PhyInit.
- Add userControlData structure in PhyInit to allow carrying external configuration data.
- Setting RL, WL, nWR, CKR based on Frequency and DfiFreqRatio. (LPDDR5)
- Make it easier in setDefaults() to set common Mode Register fields differently per PState.
- Remove the 2D training option and output from PhyInit since there is only one Firmware binary.
- Clean up some calls to strcmp() in the calcMb() PhyInit function.
- Update the documentation for technology specific CSRs.
- Enable DFE mode if DFE training step is enabled or MR24 is set.
- Improvements to Tx and Odt impedance support for VOH = VDDQ_DRAM/2.5 mode. (LPDDR4)

Bug fixes:
----------
- Address JEDEC Clock stop violation during TxRdPtrInit Clock Stop Cycle
  + Distinguish between Freq. Change(FC) and LP2 enter/Exit.
  + Add RelockOnlyCntrl user input to allow mapping of LP2 Enter/Exit to 'Relock Only' encoding.
  + New LP2 Enter/Exit sequence where PHY sends PDE command and tristate CK_t/c. (LPDDR5)
- Add missing phyctx in some of the userCustom files.
- Fix bitshift for DFE (MR24) in setDefault. (LPDDR5)
- Fix RxClk delay setup in SkipTrain.
- Fix Vref programming for data lane 8.
- Fix programming of RZN drive strength.

Input Changes:
--------------
- Add RelockOnlyCntrl, to map new LP2 Enter/Exit sequence to Relock-Only encoding.
- Add advanced user input RxDfeMode. 
- Add input to disable JTAG/TDR access to PHY registers in Mission Mode.
- Add advanced user input PhyVrefCode since it is removed from message block.
- Add user input for Deep Sleep Mode support, to meet JEDEC timing requirement "tXDSM_XP". (LPDDR5)
- Change PmuClockDiv user input to be per-PState.
- Add TxImpedanceCs to program TxImpedance SE1 register.
- Align to the Firmware Message Block fields, some were added, removed or renamed.

Limitations:
------------
- The new LP2 Enter/Exit sequence (DFI frequency encoding 0x8/0x9), available using RelockOnlyCntrl=0, are not supported in this release.
- User input EnRxDqsTracking is reserved for future use.
- The minimum supported size of the PState SRAM is 1024 entries per PState.
- tinit_start is out of specified range when restoring the Mode Registers on a PState change and when using skip_retrain_enhancement=1.
- The only supported value of NumDbytesPerCh is 2.

Known issues:
-------------
- Analog PLL settings not final (PllCtrl3: PlForceCal, PllEnCal), no impact on digital simulations
- The CalCompVrefDAC[6:0] setting is under review and may not be final
- The same setting for MR17 is used for both ranks (LPDDR5)

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Current Compatible Versions
-------------------------
- PHY PUB:  1.0xx
- Firmware: A-2020.06
- CTB:      A-2020.06


------------------------------------------------------------------------------
Version A-2020.03-T-53919
-------------------------
March 23, 2020

Preliminary Release:
(recommended)

This version of PhyInit supports:

Enhancements:
-------------
- Update PhyInit API: added phyctx parameter to user custom functions where it was missing
- Update Phyinit API: use struct type instead of void* for phyctx
- Prevent Phyinit from loading an empty INCV firmware file
- Updated the PhyInit examples
- Moved the programming of HwtLpCsEnA/B to step I
- Program TxDcaMode in the DBYTE after training (LPDDR5)

Bug fixes:
----------
- Fixed PIE code to meet tFC_long JEDEC constraint
- Fixed programming of PllX4Mode to be set to the correct value
- Initialize MR24 properly in setDefault()
- Fix programming of RxClkDly CSR in skipTrain()
- Fix the loading of firmware images, to avoid writing the DCCM when loading ICCM
- Fix WCK timing parameters in step C used by Firmware for DBI (LPDDR5)
- Update PHYINT to NOT issue PDE during frequency change, to comply with current JEDEC (LPDDR5)

Input Changes:
--------------
- Align to the Firmware Message Block fields, some were added, removed or renamed

Limitations:
------------
- User input EnRxDqsTracking is reserved for future use
- The minimum supported size of the PState SRAM is 1024 entries per PState
- tinit_start is out of specified range when restoring the Mode Registers on a PState change
- The only supported value of NumDbytesPerCh is 2

Known issues:
-------------
- Analog PLL settings not final (PllCtrl3: PlForceCal, PllEnCal), no impact on digital simulations
- The CalCompVrefDAC[6:0] setting is under review and may not be final
- The same setting for MR17 is used for both ranks (LPDDR5)

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Current Compatible Versions
-------------------------
- PHY PUB:  1.01a/1.02a/1.03a
- Firmware: A-2020.03-T-53545
- CTB:      TBD


------------------------------------------------------------------------------
Version A-2020.02-BETA
----------------------
February 13, 2020

Preliminary Release:
(recommended)

This version of PhyInit supports:

Enhancements:
-------------
- Disable unused slices to save power based on user inputs
- Reorganize ACSM program to reduce memory utilization
- Add checking to make sure retraining is disabled in single-ended mode
- Add debugging information about PState SRAM in PhyInit when running out of space
- Removed some of the references to the 2D Training Firmware structures
- Restore more Mode Registers during frequency change (implementation not complete)
- Some minor documentation fixes/updates
- Program DxWrPipeEn and DxRdPipeEn to help with PHY timing closure

Bug fixes:
----------
- Fix retraining sequence to de-assert ACSMRun properly when sending PDX command (LPDDR5)
- Issue PDX before PDE when entering LP2 in case DRAM was already in PDE (LPDDR5)
- Fix retraining sequence to keep WCK toggling in Always On Mode (LPDDR5)
- Fix retraining sequence to extend WCK toggling to cover BL/n_max (LPDDR5)
- Add support for selecting set B for tWCKENL_WR when configuring WCK (LPDDR5)
- Many fixes in Mode Register bit packing for LPDDR5
- RxClk tracking fixes, use wider calibration range during boot
- Force clocks to differential mode during boot before training firmware is executed
- Add, change and properly initialize some of the firmware Message Block defaults
- Bug fix to properly handle the stub firmware incv images (empty files)

Input Changes:
--------------
- Align to the Firmware Message Block fields, some were added, removed or renamed

Limitations:
------------
- User input EnRxDqsTracking is reserved for future use
- The minimum supported size of the PState SRAM is 1024 entries per PState
- tinit_start is out of specified range when restoring the Mode Registers on a PState change
- The only supported value of NumDbytesPerCh is 2

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Minimum Required Versions
-------------------------
- PHY PUB:  1.03a
- Firmware: A-2020.02-BETA
- CTB:      A-2020-02-BETA


------------------------------------------------------------------------------
Version A-2019.08-BETA
----------------------
August 1, 2019

Preliminary Release:
(mandatory)

This version of PHY supports:

Enhancements:
-------------
- Manage PState SRAM usage based on the number of PStates used and on the PsDmaRamSize user input
- Change LPDDR5 Mode Register defaults to make them consistent with other defaults
- PIE writes PorControl CSR when entering LP3 to protect from reset_async
- PHY now waits for de-assertion of dfi_init_start for DFI retrain-only requests
- PHY now issues PDE command during frequency change (LPDDR5)
- Disable PMU clock during restore sequence after all reads are done (LPDDR5)
- Set tWCK2DQO and tWCK2DQI to non-zero default value (LPDDR5)

Bug fixes:
----------
- Fix programming of DxDfiClkDis and DxPClkDis for WCK and DMI lanes
- Fixes to enable S3 restore combined with 15-pstate mode
- Initialize FirstPState, PsDmaRamSize inputs in setDefault
- Fixes to input validation checking
- Remove programming of SingleEndedMode in Step C, handled by progCsrSkipTrain
- PHY will not issue MRW to MR28 during frequency change (LPDDR5)
- Fix retraining sequence to keep WCK toggling until CAS Sync OFF (LPDDR5)
- Update DFIMRL calculation to take into account AcPipeEn in progCsrSkipTrain (LPDDR5)

Input Changes:
--------------

User input field removed:
- DmiDbiEn

Changes to input data structures:
- FirstPState input moved from Advanced to Basic input set

Firmware MessageBlock changes:
- UseBroadcastMR removed
- VrefSamples added
- PhyConfigOverride removed (LPDDR4)
- ALT_RL and MAIN_RL added (LPDDR4)
- Several entries added for DFE and DCA (LPDDR5) 

Limitations:
------------
- User input EnRxDqsTracking is reserved for future use

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Minimum Required Versions
-------------------------
- PHY PUB:  1.02a
- Firmware: A-2019.08-BETA


------------------------------------------------------------------------------
Version A-2019.06-BETA
----------------------
June 20, 2019

Preliminary Release: (mandatory)

This version of PHY supports:
-----------------------------

Enhancements:
- LPDDR5 support for DRAM in Deep Sleep Mode on retention entry/exit
- LPDDR5 support for different configurations of NZQ (for tZQCAL)
- Support for memory controller to hand over DRAM in Self-Refresh for phymstr & DFI requests
- Provide P14 p-state transition from P[0..6] and P[7..13]
- Changes related to reset, protect reset pin during boot
- Fixed programming of CkDisVal
- Fixes related to RxClk tracking
- Fixes to some PHY-initiated commands
- Fixes to support DVFS-C and DVFS-Q (LPDDR5)
- Program RxStandbyExnt instead of using reset value

Input Changes:
- User input fields added:
    - MaxNumZQ (LPDDR5)
- Message block fields added:
    - Disable2d
    - LP4XMode (LPDDR4X)
    - X8Mode (LPDDR5)

Changes to input data structures:
- Change default values for tDQS2DQ and tDQSCK (for SkipTrain simulation only)

Limitations:
------------
- User input EnRxDqsTracking is reserved for future use
- Only support PS SRAM size of 1024

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Minimum Required Versions
-------------------------
- PHY PUB:  1.01a
- Firmware: A-2019.06-BETA


------------------------------------------------------------------------------
Version A-2019.04-BETA
----------------------
May 2, 2019

Preliminary Release: (mandatory)

This version of PHY supports:
-----------------------------

Enhancements:
- Added support for 15 PStates
- Added Support LPDDR5 WCK Free Running Mode with retraining
- Added Support LPDDR5 Strobe-less Read mode
- RxClk tracking and correction, now enabled by default
- Make sure HwtLpCsEnA and HwtLpCsEnB are programmed in LP5
- Simplified function arguments to use pointers to single global structure

Input Changes:
- User input fields added:
    - OdtImpedanceCa
    - OdtImpedanceCs
    - OdtImpedanceCk
    - EnWck2DqoTracking (LPDDR5), enable Snoop Interface
    - CfgPState
    - FirstPState
- User input fields removed:
    - PclkPtrInitVal
- Changes in input data structures:
    - DramByteSwap input changed from user_input_sim_t to user_input_advanced_t
    - OdtImpedanceDq defaults to 60 Ohms instead of 30

Limitations:
------------
- User input EnRxDqsTracking is reserved for future use
- Only support PS SRAM size of 1024

Compiler Version:
-----------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Minimum Required Versions
-------------------------
- PHY PUB:  1.00a
- Firmware: A-2019.04-BETA


------------------------------------------------------------------------------
Version A-2019.02-BETA
----------------------
February 22, 2019

Preliminary Release: (recommended)

This version of PHY supports:
-----------------------------

General features:
- 2 Pstate PM Transition
- x8, x16 and mixed mode supported
- RXClk tracking is supported
- Single Ended Mode is supported
- Read DQS Tracking is supported
- ASST Feature is supported
- On the fly frequency ratio switching
- DFE feature is supported
- Periodic Phase Training Support added for LPDDR4
- Periodic Phase Training Support added in non-free running WCK mode for LPDDR5

PhyInit input changes
- User input fields added:
    - FirstPState
    - PmuClockDiv
- User input fields removed (use the LPDDR4 mode register settings instead):
    - Lp4PostambleExt
    - Lp4RL
    - Lp4WL
    - Lp4WLS
    - Lp4DbiRd
    - Lp4DbiWr
    - Lp4nWR

Limitations to PhyInit:
-----------------------
- Snoop feature is not supported by PhyInit
- LPDDR5 strobe-less read mode not supported by PhyInit
- LPDDR5 Periodic Phase Training does not support WCK Free Running mode

Compiler Version Used:
---------------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Minimum Required Versions
-------------------------
- PHY PUB:  0.60a
- Firmware: A-2019.02-BETA


------------------------------------------------------------------------------
Version A-2018.12-BETA
----------------------
December 21, 2018

Preliminary Release: (recommended)

This version of PHY supports:
-----------------------------

General features:
- DFT features:
    - Bypass(flyover) feature is supported
    - LCDL linearity feature is supported
    - TRD feature for CSR write/read is supported
- PMU ECC error feature is supported
- PHY INTERRUPT feature is supported
- PHY board delay range support per PUB databook 
- DFI side-band feature:
    - LP data and LP ctrl is supported for both LP4/5
    - Ctrl/Phy update is supported for both LP4/5
    - Ctrlmsg/Pymst/PPT is supported for LP4 only
    - Snoop feature is supported for LP4 only
    - Pstate transition timing is not finalized yet
- DFI timing parameters: per databook (excluding Pstate transition timing)

LPDDR4: 
- Data rates: 50MT/s to 4267MT/s
- Dficlk and CK ratio as 2:1 and 4:1 are supported
- LPDDR4/4x X8, x16 and mixed mode are supported
- Bye-swap feature is used in x8 mode support
- LPDDR4x single-ended mode is supported, with the restriction that all Pstates must have the same setting
- WDQS extension is supported
- AC/DBYTE Swizzle is supported
- Periodic Phase Training is not supported

LPDDR5: 
- Data rates:  
    - CK:WCK 1:2 ratio: 48MT/s to 32000MT/s
    - CK:WCK 1:4 ratio: 176MT/s to 6400MT/s
- LPDDR5 x16 is supported
- LPDDR5 single-ended mode is supported, with the restriction that all Pstates must have the same setting
- AC/DBYTE Swizzle is supported
- WCK free running and WCK non-free running modes are supported
- RXClk tracking is not supported
- LPDDR5 x8 and mixed mode is not supported yet
- LPDDR5 strobe-less read mode is not supported yet 
- Periodic Phase Training is not supported

Special Notes
-----------
### Limitations and requirements related to frequency change:
The final LPDDR54 PHY will handle MR programming during Pstate change. The current release does not perform MR programming during Pstate change.
- Current LPDDR54 PHY sends MRW to transition FSP during Pstate transition (MR16).
- Memory controller needs to write other MRS affected by FSP-OP.
- Only 2 Pstates are supported (0 and 1).
- The memory controller must bring LPDDR54 PHY back to previous Pstate after S3 retention.

### MR programming requirement for SkipTrain()

This release supports 2 PStates. In mission mode the training firmware loads the MRs for the trained PSTATE in the DRAM.  
In SkipTrain simulation environment, this step is skipped and the MC/test must backdoor program the DRAM MRs as part of dwc_ddrphy_userCusom_customPost() if DisableFsp=0.   
The DRAM MRs that have FSP copies must be programmed such that FSP0 MRs match PS0 and FSP1 MRs match PS1.   
The following table provides the list of MRs that are replicated for each FSP and must be programmed:

Protocol | MRs to be programmed
---------| --------------------------------------
LPDDR4   | 1,2,3,11,12,14,22
LPDDR4X  | 1,2,3,11,12,14,22,21,51
LPDDR5	 | 1,2,3,10,11,12,14,15,17,18,19,20,30,41

Once the MRs are programmed, the PHY will issue MR13/MR16 writes during tinit_start and tinit_complete following FSP switching scheme in JEDEC.  
In future releases, the PHY will perform above MR programming and this backdoor MR programming will not be required.

Compiler Version Used:
---------------------
Compiler version used during the QA testing of this release.
- gcc 4.7.2
 
Minimum Required Versions
-------------------------
- PHY PUB:  0.50a
- Firmware: A-2018.12-BETA


-----------------------------------------------------------------------------------------------------------
Version A-2018.10-BETA
----------------------
November 8, 2018

Preliminary Release

This version of PHY Supports:
-----------------------------

- All LPDDR4 Transactions with all valid spacings.
- All LPDDR5 Transactions with all valid spacings.
- LPDDR5 support of all JEDEC supported clock ratios.
- LPDDR5 Support for Free Running and Non-Free Running Mode.
- DFI sidebands for LPDDR4 and LPDDR5 :
      - PHYUPD, CTRLUPD
      - DFI_LP
      - DFI_DRAM_CLK_DISABLE
- All the valid Read and Write Pre-amble and Post-amble configurations mentioned in the PUB Databook for LPDDR4 and LPDDR5.

Enhancements Done:
------------------

- LPDDR5 support added.

Minimum Required Versions
-------------------------

- PHY PUB:  0.40a
- Firmware: A-2018.10-BETA


