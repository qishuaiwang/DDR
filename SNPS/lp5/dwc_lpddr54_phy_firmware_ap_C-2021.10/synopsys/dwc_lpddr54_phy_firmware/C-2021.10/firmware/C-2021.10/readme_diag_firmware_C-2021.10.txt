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
- None

Enhancements
------------
- None

Diag Firmware:
 - PMU Revision : 0x210A

Known Issues
------------
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
  STAR ID  Description                                                Status
---------  ---------------------------------------------------------  --------
  3696098  Invalid Command REFRESH_ALL_BANK                           Fixed
  3674746  Rx eye test fails to map lane 8 with Read DQ Calibration   Fixed
  3648191  WCK duty cycle inadvertently changes during always on mode Fixed
  3648104  DIAGS self_refresh_exit_to_valid_command_delay_txsr_check  Fixed

Enhancements
---------------------------------------
- Preserve MR14 VDDQ Range
- DiagMisc4 add Preserve Coarse Feature

Diag Firmware:
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
  STAR ID  Description                                                          Status
---------  -------------------------------------------------------------------  -----------
  3581413  DIAGS RX_EYE incorrect dqs filtering                                 Validating*
  3574349  EnableWriteLinkEcc missing PState                                    Fixed
  3483196  LP5 is not send to power down mode at the end of Diag test           Fixed
  3477464  DFE incorrectly disabled during RXEYE diag                           Fixed
  3457267  FWTB DIAGS wck_stop_toggling_during_free_running_mode_check failing  Fixed

*Validating - Issue is expected to be fixed. Validation efforts are on-going.

Enhancements
------------
- None
- PMU Revision : 0x2103

Known Issues
-----------------
- None

Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: C-2021.03  
- CTB:C-2021.03

--------------------------------------------

Version C-2020.11
November 30, 2020

=====================================================
Diagnostic Firmware C-2020.11 Release Notes:
=====================================================

Changes from version A-2020.09
(mandatory)

Bug Fixes
---------
 
Enhancements
------------
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
Diagnostic Firmware A-2020.09 Release Notes:
=====================================================

Changes from version A-2020.06
(optional)

Bug Fixes
---------
 - N/A

Enhancements
------------
Diagnostic Firmware:
 - PMU Revision : 0x2009

Known Restrictions
-----------------
 - None

Known Issues
-----------------
 - None


Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Training Firmware: A-2020.06
- Phyinit: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06
- CTB: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06

----------------------------------------

Version A-2020.06
June 30, 2020

=====================================================
Diagnostic Firmware A-2020.06 Release Notes:
=====================================================

Changes from version A-2020.04-T-47331
(required)

Bug Fixes
---------
 - N/A

Enhancements
------------
Diagnostic Firmware:
 - PMU Revision : 0x2006

 - Diags: Enable WECC testing
 - Diags: Add VREFDAC control
 - Diags: Tx VREF scanning restore fix


Known Restrictions
-----------------
 - None

Known Issues
-----------------
 - None


Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Training Firmware: A-2020.06
- Phyinit: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06
- CTB: 
   o For PUB 1.x: rel_vA-2020.06
   o For PUB 2.x: rel_vB-2020.06

----------------------------------------

Version A-2020.04-T-47331
Apr 30, 2020

=====================================================
Diagnostic Firmware A-2020.04-T-47331 Release Notes:
=====================================================

Bug Fixes
---------
 - N/A

Enhancements
------------
Diagnostic Firmware:
 - PMU Revision : 0x2014
 - First release: see application notes for details

Known Restrictions
-----------------
Diagnostic Firmware:
  - DiagMisc1 must be set to 0 for all tests.
  - TXEYE ( test #5 ) is not yet supported for LPDDR5.
  - pUserInputAdvanced->DisableRetraining must be set to 1 when running diags.

Current Compatible Versions
-------------------------
- PUB: pub 1.01a/2.0x
- Training Firmware: A-2020.03-T-53545-1
- Phyinit: 
   o For PUB 1.x: rel_vA-2020.03-T-53919-1
   o For PUB 2.x: rel_vB-2020.04-T-52791

