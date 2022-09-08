LPDDR54 PHY FIRMWARE PRODUCT

Version C-2021.10
Nov 22, 2021
	

Controller Compatibility Testing
================================================================================

This release has NOT be verified to interoperate with the Synopsys DWC_ddrctl_lpddr54 Controller.
Please contact Synopsys for the latest Interoperability information.

PUB/PHY Compatibility 
================================================================================
The PHYINT and FIRMWARE components are compatible with all PHY releases with PUB 1.xx & 2.xx versions.

CTB                 Phyinit         Firmware        PUB                           HardMacro type/version
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v2.20a                    hard_macro_family_b/rev0_75b
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v2.10a                    hard_macro_family_b/rev0_75b
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v2.00a_tc                 hard_macro_family_b/rev0_75a_patch1
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v2.00a_<--->              hard_macro_family_b/rev0_75a_patch1
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v1.05b                    hard_macro_family_b/rev0_74a_patch2_sp2        
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v1.05b                    hard_macro_family_b/rev0_75a_patch1            
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v1.04a_<--->              hard_macro_family_b/rev0_74a
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v1.02a_patch3             hard_macro_family_b/rev0_74a_patch2_sp2             
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v1.02a_patch2             hard_macro_family_b/rev0_74a_patch1_sp1             
rel_vC-2021.06-SP1  rel_vC-2021.06  rel_vC-2021.06  rel_v1.01a                    hard_macro_family_a/rev0_71a_patch2

Firmware Product Use Statement
================================================================================
It is not possible to mix components from different Firmware Product releases. The Firmware,
PHYINIT and CTB components in this release must be used as a set.

Installation Instructions
================================================================================
This Firmware Product is designed to be overlaid on an existing DDR PHY installation.  

--------------------------------------------------------------------------------

FIRMWARE TRAINING

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

-------------------------------------------------------------------------------- 

ATE FIRMWARE   

Version C-2021.10
October 18, 2021

Changes from Version C-2021.06
(recommended)

Bug Fixes
----------
- STAR 3732645: Updated ATE firmware documentation to avoid ZCal calibration failure in GLS - Refer to ATE-FW APP-Note section 4.3.

Enhancements
-------------
- ATE FW Revision Code: 2021_1000
- DCA Loopback - Add bitmap starting delay to message block. Refer to "Dca_Delay" in Message block.
- AC  Loopback - Add coarse delay settings for SEC/DIFF bitmaps to message block. Refer to "AcLoopbackCoarseSec" and "AcLoopbackCoarseDiff" in Message block.
- 1D Data Loopback - Add coarse delay settings for WCK/DQS bitmaps to message block. Refer to "DatLoopbackWckCoarse" and "DatLoopbackDqsCoarse" in Message block.
- 2D Data Loopback - Add per Lane Error Flags to message block. Refer to "DatLoop2dDbyteBitFail" in Message block.
- 2D Data Loopback - Improve 2D Data Loopback bitmap formatting.

Limitations
------------
- None

Supported Versions
-------------------------
   - PUB: 1.x, 2.x
   
   
--------------------------------------------------------------------------------

DIAGNOSITC FIRMWARE

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


--------------------------------------------------------------------------------

QUICKBOOT FIRMWARE  

Version C-2021.10
Oct 20, 2021

Changes from version C-2021.06
(mandatory)

Bug Fixes
---------
  STAR ID  Description                      Status
---------  -------------------------------  --------
  3714071  CK to MemReset timing violation  Fixed

Enhancements
------------
 - Remove DlyTestCntRingOscDblcdlDq from Quickboot FW restore list

Quickboot Firmware:
 - PMU Revision : 0x210A

Known Issues
-----------------
- None

Current Compatible Versions
-------------------------
- PUB: 1.x/2.x
- Phyinit: C-2021.10
- CTB:  C-2021.10


--------------------------------------------------------------------------------

PHYINIT

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


--------------------------------------------------------------------------------

CTB

Version C-2021.10
October 22, 2021

Changes from version C-2021.06
(optional)

Bug Fixes
-------------
 - STAR: 3883665 - CTB - Quickboot simulation does not finish normally 
 - STAR: 3859147 - CTB - Deprecate VCS option '+memcbk' when "runtc dump=VPD" is used
 
Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified
- The DCA circuit is only available in PUB version 1.02a and above
- The DCA test is not supported for LP4-only PHYs.
- Quickboot is only supported in PUB version 1.02a and above.
- For Quickboot simulations, the clk cycles  value in common_test_inc.sv line2378 
  may need to be adjusted to ensure enought time for firmware simulation to complete
- It is recommended that Quickboot be run >= 3200M data rate

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4/LPDDR5 demo_lp(DFI low power)
  LPDDR4/LPDDR5 demo_lp(frequency change)
  LPDDR4/LPDDR5 demo_lp(I/O retention)
  LPDDR4/LPDDR5 demo_ate
- Supported features
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:2/1:4 CK:WCK mode up to LPDDR5-6400 
  Support DM/DBI
  Support LPDDR4 training FW
  Support LPDDR5 training FW
  Support LPDDR4 quickboot
  Support LPDDR5 quickboot
  Support ATE tests
  Support prefix in coretool flow

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
VCS:             2020.12-SP2
Verdi:           2020.12-SP2
vip:dfi_svt      S-2021.06
vip:lpddr_svt    S-2021.06
gcc:             4.7.2-el6
python:          python-3.7.0

Required Versions
--------------------
- Phyinit   : rel_vC-2021.10
- Firmware  : rel_vC-2021.10
- PUB       : rel_v2.20a / rel_v2.10a /
              rel_v2.00a_<---> / rel_v1.05b / 
              rel_v1.04a_<---> /
              rel_v1.02a_patch3 / rel_v1.02a_patch2 /
              rel_v1.01a 
- CoreKit   : rel_v2.20a / rel_v2.10a / rel_v1.10a / rel_v1.05b / 
              rel_v1.01a
- Hard Macros Family: Type B
                      Type A for PUB 1.01a

Supported combination of soft-components:
--------------------
CTB             Phyinit         Firmware        PUB                           HardMacro type/version
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v2.20a                    hard_macro_family_b/rev0_75b
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v2.20a                    hard_macro_family_b/rev0_74b_patch2_sp2
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v2.10a                    hard_macro_family_b/rev0_75b
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v2.00a_<--->              hard_macro_family_b/rev0_74a_patch1
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v1.05b                    hard_macro_family_b/rev0_74a_patch1_sp1        
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v1.05b                    hard_macro_family_b/rev0_75a_patch1            
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v1.04a_<--->              hard_macro_family_b/rev0_74a
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v1.02a_patch3             hard_macro_family_b/rev0_74a_patch2_sp2             
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v1.02a_patch2             hard_macro_family_b/rev0_74a_patch1_sp1             
rel_vC-2021.10  rel_vC-2021.10  rel_vC-2021.10  rel_v1.01a                    hard_macro_family_a/rev0_71a_patch2


--------------------------------------------------------------------------------

Package Contents
----------------

doc                 - Documentation

firmware            - pub firmware images for supported SDRAM types

phyinit
software            - PHY initialization C code

ctb
gatesim_script      - Example functional gate level simulation scripts
sim                 - Example simulation run script
testbench           - Behavioral model simulation test environment
upf                 - PG mapping files
