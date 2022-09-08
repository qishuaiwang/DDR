Copyright 2021 Synopsys, Inc.
This Synopsys IP and all associated documentation are proprietary to
Synopsys, Inc. and may only be used pursuant to the terms and conditions
of a written license agreement with Synopsys, Inc. All other use,
reproduction, modification, or distribution of the Synopsys IP or the
associated documentation is strictly prohibited.
------------------------------------------------------------------
LPDDR54 FIRMWARE

Version C-2021.10
Oct 20, 2021

Changes from version C-2021.06
(mandatory)

Bug Fixes
---------
  STAR ID  Description                                                                                                            Status
---------  ---------------------------------------------------------------------------------------------------------------------  --------
  3853750  Tx PPT2 initialization training is moved after Tx DCA train                                                            Fixed
  3840376  Impendence related CSRs might not be restored to the correct values during devinit or CA training                      Fixed
  3644390  Read/write training might get sub-optimal result when using 1D training                                                Fixed
  3773263  WCK Sync timing is violated when Write Latency SetB is used                                                            Fixed
  3865003  messageBlock Misc[0] comments might be misleading regarding dfi_reset_n                                                Fixed
  3767102  PPT2 Training for Write Link ECC will fail                                                                             Fixed

Enhancements
------------------------------------------------------------------------------------------------------------------------
- Update pattern used in PPT2 Initialization Training
- Update Disable2D description to avoid unuseful setting
- Improve TxDFE training
- Use independant seed for RxClkT/C during PHY RxDCA training
- Add missing description for Misc[6]
- [TO BE REVIEWED]Add new field "PPT2OffsetMargin" to avoid delay csr overflow/underflow when PPT2 is enabled
------------------------------------------------------------------------------------------------------------------------
Training Firmware:
 - PMU Revision : 0x210A

Known Issues
-----------------
- None

Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: C-2021.10
- CTB:  C-2021.10

---------------------------------------------------

Version C-2021.06
May 30, 2021

Changes from version C-2021.03
(mandatory)

Bug Fixes
---------
  STAR ID  Description                                                             Status
---------  ----------------------------------------------------------------------  -----------
  3701653  MRL Training may fail when Pre-computed RxClk Delay feature is enabled  Fixed
  3692661  tCSH issue in devinit                                                   Fixed
  3675136  TxDCAMode CSR missing from 15Pstate save/restore.                       Fixed
  3667776  Remove NOP commands from WCK Leveling                                   Fixed
  3638539  LPDDR54 Firmware Training::(Write training) LPDDR5 rounding error       Fixed
  3627562  Illegal CAS in DCM Sequence                                             Fixed
  3610866  LP5 TxWCK Average incorrect for partially populated ChA                 Fixed

Enhancements
---------------------------------------------------
- Update patterns used in MRL Training as per 5.13.1.1 in Training Firmware Appnote
- Train2DMisc for LP4X mode training time reduction
- Add CsPresent check in WrLvl average

Training Firmware:
 - PMU Revision : 0x2106

Known Issues
-----------------
- None

Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: C-2021.06
- CTB:  C-2021.06

---------------------------------------------------

Version C-2021.03
March 30, 2021

Changes from version C-2020.11
(mandatory)

Bug Fixes
---------
  STAR ID  Description                                           Status
---------  ----------------------------------------------------  --------
  3592935  tINIT3 timing incorrect                               Fixed
  3567075  LPDDR5 - CS toggle during clock stop                  Fixed
  3556018  LPDDR5 : missing MRW (MR11, 17) in CA-training        Validating
  3533027  LPDDR5 phy firmware tZQLAT is violated                Fixed
  3528451  Uninitialized data used in DRAM DFE training          Fixed
  3512881  TXDQ delay margins inaccurate                         Fixed
  3473074  enabling PhyRxDCA causes training failures            Fixed
-------------------------
*Validating - Issue is expected to be fixed. Validation efforts are on-going.

Enhancements
------------
- STAR: 3561316 - CAS to DCM Start timing adjustment 
- STAR: 3533537 - LPDDR5 phy firmware prefer DES during tXSR         
- Document WriteLevel Averaging Feature in Message Block     
- FW Add MRL calculation offset               
- Enhance LP5 DRAM ZQ_CAL implementation     
- Training runtime optimization 
- PMU Revision : 0x2103              

Known Issues
-----------------
  STAR ID  Description                                
---------  -------------------------------------------------------
  3610866  LP5 TxWCK Average incorrect for partially populated ChA

Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: C-2021.03
- CTB:  C-2021.03

----------------------------------------

Version C-2020.11
November 30, 2020

=====================================================
Training Firmware C-2020.11 Release Notes:
=====================================================

Changes from version A-2020.09
(mandatory)

Bug Fixes
---------
  STAR ID  Description                                                        Status
---------  -----------------------------------------------------------------  ----------
  3459406  LP5 RxDfe eyes are clipped at 6400 MT/s                            Fixed
  3459402  X8Mode not functional                                              Fixed
  3444708  Eye compounding x-anchor offset is incorrect for DFE history mode  Fixed
  3432652  End of training CSR programming incorrect -- PllBypass             Fixed
  3425812  PRECHARGE not allowed in RDQS_t training mode                      Fixed
  3425264  WECC data is not optimized in 2D algorithm                       Validating*
  3423744  DMI/DBI required to enabled during RDQS_t training                 Fixed
  3423694  Upper byte DCM data collection is missed in ByteMode               Fixed
  3420607  LP5 - nWR not correctly set                                        Fixed
  3420335  JEDEC violation for WCK:CK setting during Write Leveling Training  Fixed
  3418176  PptCtlStatic not restored at end of Diag                           Fixed
  3408594  TrainedVref* message block fields are not being populated          Fixed
  3405021  WCK toggle missing prior to DCM                                    Fixed
  3404919  LP5 - PDE Sent during VRCG High                                    Fixed
  3403164  Devinit clock stop timing violation                                Fixed
  3402851  NOP command sent in tCKFSPX time                                   Fixed
  3402698  NOP command sent in tMRW/tMRD time                                 Fixed
  3402275  ZQ Latch missing from devinit                                      Fixed
  3399886  RxEn misaligned -- Data Rate < 667 Mbps                            Fixed
  3387359  Mission mode instability when command based ZQCal used for LP5     Fixed
  3357116  RxReplicaPathPhase[4:0] missing from PSSram save                   Fixed
-------------------------
*Validating - Issue is expected to be fixed. Validation efforts are on-going.


Enhancements
------------
  - Documentation - Minimum Training Steps
  - Removed TrainedPHY*DCA from MsgBlock
  - Ensure ODT settings are the same in Fine and Coarse WrLvl
  - Write Leveling Coarse done in FSP1 to avoid deadlock
  - PHYDCA algorithm enhancements
  - Remove Activates from LPDDR4 Coarse write leveling [tRAS]

Training Firmware:
 - PMU Revision : 0x200B

Known Issues
-----------------


Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: 
   o rel_vC-2020.11
- CTB: 
   o rel_vC-2020.11

----------------------------------------


Version A-2020.09
September 01, 2020

=====================================================
Training Firmware A-2020.09 Release Notes:
=====================================================

Changes from version A-2020.06
(mandatory)

Bug Fixes
---------
 - RxDfeMode issues identified in previous release has been fixed.
 - PPT issues identified in previous release has been fixed.
 - STAR: 3382392 - MR19 not being sent out during LP5 training fixed
 
Enhancements
------------
Training Firmware:
 - PMU Revision : 0x2009
 - PHYDCA Training Added

Known Issues
-----------------
 - Mission Mode + Tracking issues for NumPStates > 2
 - Byte mode is not supported. 
 - Command ZQCal not supported 

Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06
- CTB: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06

----------------------------------------

Version rel_vA-2020.06
Jun 30, 2020

=====================================================
Training Firmware A-2020.06 Release Notes:
=====================================================

Changes from version A-2020.03-T-53545-1
(required)

Bug Fixes
---------
 - N/A

Enhancements
------------
Training Firmware:
 - PMU Revision : 0x2006

 - Improve Tx Optimization
 - Use correct DRAM termination during CA training
 - Improve RxClk optimization for better drift correction
 - Improve Rx DFE training
 - Add support for fifo retraining
 - Update DMA restore list
 - Update/improve 2D logging
 - Rename BittimeControl message block field
 - Use correct WCK ODT during LPDDR5 coarse write leveling
 - Restore FSP correctly after diags.
 - Reduce DQ noise during lpddr5 RxEn training
 - Rx 2D optimization improvements
 - Report error count in diag write/read test
 - Add lpddr5 CA Vref training
 - Fix patterns for TxDq and RxClk training
 - Enable TxDfe training
 - Ensure default VREF and termination is used during boot frequency
 - Add SiFriendlyOffset option
 - Improve fixed patterns for TxDFE
 - 2D algorithm improvements
 - Fix multiple pstate training.
 - Add options for lpddr5 write leveling (see app note)
 - Performance improvement for ACSM api
 - Improve Lane 8 DBI handling
 - Output WECC results
 - Zcal improvement
 - Improve Phy DCA
 - Add per step VREF control for DQ training
 - Fix read/write fifo timing violations
 - Improve DFIMRL range

Known Restrictions
-----------------
 - None

Known Issues
-----------------
 - PUB101A -- RxDfeMode == 2 known problematic. Will be fixed in next release.
 - PUB102A -- PPT is not correctly initialized by the training firmware.
              Running PPT will cause data mismatches in mission_mode. Will be fixed in next release.


Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06
- CTB: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06

----------------------------------------

Version rel_vA-2020.03-T-53545-1
Apr 29, 2020

=====================================================
Training Firmware A-2020.03-T-53545-1 Release Notes:
=====================================================

Changes from version A-2020.03-T-53545 
(required)

Bug Fixes
---------
 - N/A

Enhancements
------------
Training Firmware:
 - PMU Revision : 0x2013
 - Diags execution supported after training.

Known Restrictions
-----------------
Same as previous release.

Known Issues
-----------------
Same as previous release.

Current Compatible Versions
-------------------------
- PUB: 1.01a/1.02a/1.03a/2.0x
- Phyinit: 
   o For PUB 1.x: rel_vA-2020.03-T-53919-1
   o For PUB 2.x: rel_vB-2020.04-T-52791
- CTB: TBD

----------------------------------------

Version rel_vA-2020.03-T-53545
Mar 23, 2020

=====================================================
Training Firmware A-2020.03-T-53545 Release Notes:
=====================================================

Changes from version A-2019.12-T-0049558
(required)

Bug Fixes
---------
 - N/A

Enhancements
------------
Training Firmware:
 - PMU Revision : 0x2003
 - Added support for 2D Training
 - Added support for RxDfe Training

Known Restrictions
-----------------
Training Firmware:
  1. To enable RxDfe, the users must set RxDfeModeCfg CSR in userCustom customPreTrain function.
  2. MessageBlock Reserved13 must be set as follows:
       For PUB101: 4
       For PUB102: 0
       For PUB103: 0
  3. For PUB101: The following CSR write must be added to customPreTrain function:
          //Value of csr_RxStandbyExtnd must be 1 or 2, depending on DfiFreqRatio
          dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_RxStandbyExtnd_ADDR | pstate<<20), 1 << (phyctx->userInputBasic.DfiFreqRatio[pstate]==2)
  4. For PUB101: Set PsDmaRamSize = 2, in setDefault.c.
      
Programming limitation will be removed in a future release.

Known Issues
-----------------
  - To enable RxDfe, the users must set RxDfeModeCfg CSR in userCustom customPreTrain function.
  - RxDfeMode == 1 is not supported.

Current Compatible Versions
-------------------------
- PUB: 1.01a/1.02a/1.03a/2.00a
- Phyinit: 
   o For PUB 1.x: rel_vA-2020.03-T-53919
   o For PUB 2.x: rel_vB-2020.04-T-52791
- CTB: TBD

----------------------------------------

Version rel_vA-2019.12-T-0049558
Mar 13, 2020

=====================================================
Training Firmware A-2019.12-T-0049558 Release Notes:
=====================================================

Changes from version A-2019.06-BETA-T-20191031
(required)

Bug Fixes
---------
 - N/A

Enhancements
------------
Training Firmware:
 - PMU Revision : 0x190A
 - Added support for RxEn Training
 - Added support for WrLvl Training
 - Added support for 1D RxClk Training
 - Added support for 1D TxDq Training

Known Restrictions
-----------------
Training Firmware:
  - Reserved13 must equal 0.
  - LPDDR5 MR18[4] (OP4) must = 0.
      
Programming limitation will be removed in next release.

Known Issues
-----------------
  - LPDDR5 ck_t_ck_c_invalid_check protocol check fails.
      During devinit, CK_t/CK_c are undriven in certain cases. 
      This is a violation of the JEDEC spec.
      This will be fixed in the following release.

Minimum Required Versions
-------------------------
- PUB: 2.00a 
- Phyinit: rel_vB-2020.02-T-53817
- CTB: TBD

----------------------------------------

A-2019.06-BETA-T-20191031
October 31, 2019

==========================================
Training Firmware A-2019.06-BETA-T-20191031 Release Notes:
==========================================

Changes from version NULL
(required)

[1] Devinit training step support added.
    All other training steps are not supported.

Limitations:
    Data Rates of less than 1066Mbps are not yet supported.
	This FW is compatible ONLY with PHYINT Version A-2019.06-BETA-T-20191031.

Minimum Required Versions
-------------------------
- PUB: 1.01a
- Phyinit: A-2019.06-BETA-T-20191031
