Copyright 2021 Synopsys, Inc.
This Synopsys IP and all associated documentation are proprietary to
Synopsys, Inc. and may only be used pursuant to the terms and conditions
of a written license agreement with Synopsys, Inc. All other use,
reproduction, modification, or distribution of the Synopsys IP or the
associated documentation is strictly prohibited.
------------------------------------------------------------------
LPDDR54 Customer Testbench

The Customer Testbench is a simulation demonstration
environment intended to provide a Verilog example testbench.
------------------------------------------------------------------
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

------------------------------------------------------------------
Version C-2021.06
June 9, 2021

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.

- The DCA circuit is only available in PUB version 1.02a and above.
- The DCA test is not supported for LP4-only PHYs.

- Quickboot is only supported in PUB version 1.02a and above.

- This testbench requires the following Verification IP (VIP):
  - dfi_svt_R-2021.03
  - lpddr_svt_R-2021.03

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
VCS:             Q-2020.12-SP1
Verdi:           Q-2020.12-SP1
vip:dfi_svt      R-2021.03
vip:lpddr_svt    R-2021.03
gcc:             4.7.2-el6
python:          python-3.7.0

Required Versions
--------------------
- Phyinit   : rel_vC-2021.06
- Firmware  : rel_vC-2021.06
- PUB       : rel_v2.20a / rel_v2.10a / rel_v2.00a_tc /
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
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v2.20a                    hard_macro_family_b/rev0_75b
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v2.10a                    hard_macro_family_b/rev0_75b
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v2.00a_tc                 hard_macro_family_b/rev0_75a_patch1
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v2.00a_<--->              hard_macro_family_b/rev0_75a_patch1
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v1.05b                    hard_macro_family_b/rev0_74a_patch2_sp2        
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v1.05b                    hard_macro_family_b/rev0_75a_patch1            
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v1.04a_<--->              hard_macro_family_b/rev0_74a
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v1.02a_patch3             hard_macro_family_b/rev0_74a_patch2_sp2             
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v1.02a_patch2             hard_macro_family_b/rev0_74a_patch1_sp1             
rel_vC-2021.06  rel_vC-2021.06  rel_vC-2021.06  rel_v1.01a                    hard_macro_family_a/rev0_71a_patch2

------------------------------------------------------------------
Version C-2021.03
April 2, 2021

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.

- The DCA circuit is only available in PUB version 1.02a and above.
- The DCA test is not supported for LP4-only PHYs.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_Q-2020.06
  - lpddr_svt_Q-2020.06

- Update to support both Coretool and Pub design for upf test cases.

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
  Support ATE tests
  Support prefix in coretool flow

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
VCS:             Q-2020.03-SP2
Verdi:           Q-2020.03-SP2
vip:dfi_svt      Q-2020.06
vip:lpddr_svt    Q-2020.06
gcc              4.7.2-el6

Required Versions
--------------------
- Phyinit   : rel_vC-2021.03
- Firmware  : rel_vC-2021.03
- PUB       : rel_v2.20a / rel_v2.10a / rel_v2.00a_tc /
              rel_v2.00a_<---> / rel_v1.05b / 
              rel_v1.04a_<---> /
              rel_v1.02a_patch3/ rel_v1.02a_patch2 /
              rel_v1.01a 
- CoreKit   : rel_v2.20a / rel_v2.10a / rel_v1.10a / rel_v1.05b / 
              rel_v1.01a
- Hard Macros Family: Type B
                      Type A for PUB 1.01a

Supported combination of soft-components:
--------------------

CTB             Phyinit         Firmware        PUB                           HardMacro type/version
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v2.20a                    hard_macro_family_b/rev0_75b
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v2.10a                    hard_macro_family_b/rev0_75b
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v2.00a_tc                 hard_macro_family_b/rev0_75a_patch1
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v2.00a_<--->              hard_macro_family_b/rev0_75a_patch1
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v1.05b                    hard_macro_family_b/rev0_74a_patch2_sp2        
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v1.05b                    hard_macro_family_b/rev0_75a_patch1            
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v1.04a_<--->              hard_macro_family_b/rev0_74a              
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v1.02a_patch2             hard_macro_family_b/rev0_74a_patch1_sp1             
rel_vC-2021.03  rel_vC-2021.03  rel_vC-2021.03  rel_v1.01a                    hard_macro_family_a/rev0_71a_patch2

------------------------------------------------------------------
Version C-2020.11-SP1
January 27, 2021

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_Q-2020.06
  - lpddr_svt_Q-2020.06

- Update to support both Coretool and Pub design for upf test cases.

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4        demo_basic(training mode)
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
  Support ATE tests
  Support prefix in coretool flow

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
VCS:             Q-2019.06-SP2
Verdi:           Q-2019.06-SP2
vip:dfi_svt      Q-2020.06
vip:lpddr_svt    Q-2020.06

Required Versions
--------------------
- Phyinit   : rel_vC-2020.11
- Firmware  : rel_vC-2020.11
- PUB       : rel_v2.10a/ rel_v1.10a / rel_v1.05a / rel_v1.05b/
              rel_v1.03a / rel_v1.02a_patch3/ rel_v1.02a_patch2 /
              rel_v1.01a 
- CoreKit   : rel_v2.10a/ rel_v1.10a/ rel_v1.05a / rel_v1.05b / 
              rel_v1.03b / rel_v1.03a / rel_v1.01a 
- Hard Macros Family: Type B 
                      Type A for PUB 1.01a only

Supported combination of soft-components:
--------------------
CTB                   Phyinit         Firmware        PUB                           HardMacro type/version
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v2.10a                    hard_macro_family_b/rev0_75b
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.10a                    hard_macro_family_b/rev0_75b
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.05b                    hard_macro_family_b/rev0_75a        
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.05a                    hard_macro_family_b/rev0_75a      
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.03b                    hard_macro_family_b/rev0_75a        
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.03a                    hard_macro_family_b/rev0_75a  
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.02a_patch3             hard_macro_family_b/rev0_74a_patch1_sp1|rev0_74a_patch2_sp2              
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.02a_patch2             hard_macro_family_b/rev0_74a_patch1_sp1             
rel_vC-2020.11-SP1        rel_vC-2020.11  rel_vC-2020.11  rel_v1.01a                    hard_macro_family_a/rev0_71a_patch2

------------------------------------------------------------------

Version C-2020.11
November 27, 2020

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_Q-2020.06
  - lpddr_svt_Q-2020.06

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4        demo_basic(training mode)
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
  Support ATE tests
  Support prefix in coretool flow

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
VCS:             Q-2019.06-SP2
Verdi:           Q-2019.06-SP2
vip:dfi_svt      Q-2020.06
vip:lpddr_svt    Q-2020.06

Required Versions
--------------------
- Phyinit   : rel_vC-2020.11
- Firmware  : rel_vC-2020.11
- PUB       : rel_v2.10a/ rel_v1.10a / rel_v1.05a / rel_v1.05b/
              rel_v1.03a / rel_v1.02a_patch3/ rel_v1.02a_patch2 /
              rel_v1.01a 
- CoreKit   : rel_v2.10a/ rel_v1.10a/ rel_v1.05a / rel_v1.05b / 
              rel_v1.03b / rel_v1.03a / rel_v1.01a 
- Hard Macros Family: Type B 
                      Type A for PUB 1.01a only

Supported combination of soft-components:
--------------------
CTB             Phyinit         Firmware        PUB                           HardMacro type/version
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v2.10a                    hard_macro_family_b/rev0_75b
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.10a                    hard_macro_family_b/rev0_75b
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.05b                    hard_macro_family_b/rev0_75a        
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.05a                    hard_macro_family_b/rev0_75a      
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.03b                    hard_macro_family_b/rev0_75a        
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.03a                    hard_macro_family_b/rev0_75a  
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.02a_patch3             hard_macro_family_b/rev0_74a_patch1_sp1|rev0_74a_patch2_sp2              
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.02a_patch2             hard_macro_family_b/rev0_74a_patch1_sp1             
rel_vC-2020.11  rel_vC-2020.11  rel_vC-2020.11  rel_v1.01a                    hard_macro_family_a/rev0_71a_patch2

------------------------------------------------------------------
Version A-2020.09
September 30, 2020

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_Q-2020.06
  - lpddr_svt_Q-2020.06

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4        demo_basic(training mode)
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
  Support ATE tests

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2019.06-SP2
    Synopsys Verdi (Verilog HW Debug)
        - 2019.06-SP2
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_Q-2020.06
            lpddr_svt_Q-2020.06

Required Versions
--------------------
- Phyinit   : rel_vA-2020.09
- Firmware  : rel_vA-2020.09
- PUB       : rel_v1.10a/ rel_v1.05a / rel_v1.05b/ rel_v1.02a_patch3/ rel_v1.02a_patch2
- CoreKit   : rel_v1.10a/ rel_v1.05a / rel_v1.05b
- Hard Macros Family: Type B

Supported combination of soft-components:
--------------------
CTB             Phyinit         Firmware        PUB                HardMacro type/version
rel_vA-2020.09  rel_vA-2020.09  rel_vA-2020.09  rel_v1.10a         hard_macro_family_b/rev0_75b_patch1
rel_vA-2020.09  rel_vA-2020.09  rel_vA-2020.09  rel_v1.05b         hard_macro_family_b/rev0_75a        
rel_vA-2020.09  rel_vA-2020.09  rel_vA-2020.09  rel_v1.05a         hard_macro_family_b/rev0_75a         
rel_vA-2020.09  rel_vA-2020.09  rel_vA-2020.09  rel_v1.02a_patch3  hard_macro_family_b/rev0_74a_patch1_sp1|rev0_74a_patch2_sp2              
rel_vA-2020.09  rel_vA-2020.09  rel_vA-2020.09  rel_v1.02a_patch2  hard_macro_family_b/rev0_74a_patch1_sp1        

------------------------------------------------------------------
Version A-2020.06-SP1
Aug 27th 2020

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_Q-2020.06
  - lpddr_svt_Q-2020.06

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4        demo_basic(training mode)
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
  Support ATE tests

Known Issues
-------------
LPDDR4 devinit and training need to disable RxClkTrack in PUB 1.02a_patch3 because of training FW limitation.

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2019.06-SP2
    Synopsys Verdi (Verilog HW Debug)
        - 2019.06-SP2
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_Q-2020.06
            lpddr_svt_Q-2020.06

Required Versions
--------------------
- Phyinit   : rel_vA-2020.06
- Firmware  : rel_vA-2020.06
- PUB       : rel_v1.05a / rel_v1.05b/ rel_v1.02a_patch3
- CoreKit   : rel_v1.05a / rel_v1.05b
- Hard Macros Family: Type B

------------------------------------------------------------------
Version A-2020.06
July 3th 2020

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2019.06
  - lpddr_svt_O-2019.06

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4        demo_basic(training mode)
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
  Support ATE tests
- Not supported
  LPDDR5 training FW

Known Issues
-------------
LPDDR4 devinit and training need to disable RxClkTrack in PUB 1.02a_patch3 because of training FW limitation.

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2019.06-SP2
    Synopsys Verdi (Verilog HW Debug)
        - 2019.06-SP2
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2019.06
            lpddr_svt_O-2019.06

Minimum Required Versions
---------------------------
- Phyinit   : rel_vA-2020.06
- Firmware  : rel_vA-2020.06
- PUB       : rel_v1.05a / rel_v1.02a_patch3
- CoreKit   : rel_v1.05a
- Hard Macros Family: Type B

------------------------------------------------------------------
Version A-2020.02-BETA-SP1
March 3, 2020

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_P-2019.06
  - lpddr_svt_P-2019.06

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4/LPDDR5 demo_lp(DFI low power)
  LPDDR4/LPDDR5 demo_lp(frequency change)
  LPDDR4/LPDDR5 demo_lp(I/O retention)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:2/1:4 CK:WCK mode up to LPDDR5-6400 
  Support DM/DBI

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        -  2019.06-SP2
    Synopsys Verdi (Verilog HW Debug)
        -  2019.06-SP2 
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_P-2019.06
            lpddr_svt_P-2019.06
    Synopsys CoreTools (Verilog PUB Cfg)
        -  2019.06-SP4 
 

Minimum Required Versions
---------------------------
- Phyinit   : A-2020-02-BETA
- Firmware  : A-2020-02-BETA
- CoreKit   : 1.03b
- Hard Macros Family: Type B

------------------------------------------------------------------
Version A-2020.02-BETA
February 14, 2020

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2018.12
  - lpddr_svt_O-2018.12

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4/LPDDR5 demo_lp(DFI low power)
  LPDDR4/LPDDR5 demo_lp(frequency change)
  LPDDR4/LPDDR5 demo_lp(I/O retention)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:2/1:4 CK:WCK mode up to LPDDR5-6400 
  Support DM/DBI

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        -  2018.09-SP1
    Synopsys Verdi (Verilog HW Debug)
        -  2018.09-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2018.12
            lpddr_svt_O-2018.12

Minimum Required Versions
---------------------------
- Phyinit   : A-2020-02-BETA
- Firmware  : A-2020-02-BETA
- PUB       : 1.03a
- Hard Macros Family: Type B

------------------------------------------------------------------
Version A-2019.08-BETA
July 26, 2019

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2018.12
  - lpddr_svt_O-2018.12

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4/LPDDR5 demo_lp(DFI low power)
  LPDDR4/LPDDR5 demo_lp(frequency change)
  LPDDR4/LPDDR5 demo_lp(I/O retention)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:2/1:4 CK:WCK mode up to LPDDR5-6400 
  Support DM/DBI

Known Issues
-------------
The CTB testcases  pass but with UVM timing violations errors. These errors are invalid. They are due to an issues with the testbench, which will be fixed in the next release

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2018.09-SP1
    Synopsys Verdi (Verilog HW Debug)
        - 2018.09-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2018.12
            lpddr_svt_O-2018.12

Minimum Required Versions
---------------------------
- Phyinit   : A-2019.08-BETA
- Firmware  : A-2019.08-BETA
- PUB       : 1.02a
- CoreTools : 1.01a
- Hard Macros Family: Type A/B

------------------------------------------------------------------
Version A-2019.06-BETA
June 20, 2019

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2018.09
  - lpddr_svt_O-2018.09

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4/LPDDR5 demo_lp(DFI low power)
  LPDDR4/LPDDR5 demo_lp(frequency change)
  LPDDR4/LPDDR5 demo_lp(I/O retention)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:2/1:4 CK:WCK mode up to LPDDR5-6400 
  Support DM/DBI

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2018.09-SP1
    Synopsys Verdi (Verilog HW Debug)
        - 2018.09-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2018.09
            lpddr_svt_O-2018.09

Minimum Required Versions
---------------------------
- Phyinit:  A-2019.06-BETA
- Firmware: A-2019.06-BETA
- PUB:      1.01a
- Hard Macros Family: Type A/B

------------------------------------------------------------------

LPDDR54 Customer Testbench

The Customer Testbench is a simulation demonstration
environment intended to provide a Verilog example testbench.

------------------------------------------------------------------
Version A-2019.04-BETA
Apr 24, 2019

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2018.09
  - lpddr_svt_O-2018.09

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4/LPDDR5 demo_lp(DFI low power)
  LPDDR4/LPDDR5 demo_lp(frequency change)
  LPDDR4/LPDDR5 demo_lp(I/O retention)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:2/1:4 CK:WCK mode up to LPDDR5-6400 
  Support DM/DBI

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2018.09-SP1
    Synopsys Verdi (Verilog HW Debug)
        - 2018.09-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2018.09
            lpddr_svt_O-2018.09

Minimum Required Versions
---------------------------
- Phyinit:  A-2019.04-BETA
- Firmware: A-2019.04-BETA
- PUB:      1.00a
- Hard Macros Family: Type A/B


------------------------------------------------------------------
Version A-2019.02-BETA
Feb 20, 2019

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2018.09
  - lpddr_svt_O-2018.09

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4/LPDDR5 demo_basic(mission mode write/read)
  LPDDR4/LPDDR5 demo_lp(DFI low power)
  LPDDR4/LPDDR5 demo_lp(frequency change)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:4 CK:WCK mode up to LPDDR5-6400 

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2017.12-SP1
    Synopsys Verdi (Verilog HW Debug)
        - 2017.12-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2018.09
            lpddr_svt_O-2018.09

Minimum Required Versions
---------------------------
- Phyinit:  A-2019.02-BETA
- Firmware: A-2019.02-BETA
- PUB:      0.60a
- Hard Macros Family: Type A


------------------------------------------------------------------

Version A-2018.12-BETA
Dec 20, 2018

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2018.09
  - lpddr_svt_O-2018.09

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4 demo_basic(mission mode write/read)
  LPDDR4 demo_lp(DFI low power)
  LPDDR4 demo_lp(frequency change)
  LPDDR5 demo_basic(mission mode write/read)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:4 CK:WCK mode up to LPDDR5-6400 

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2017.12-SP1
    Synopsys Verdi (Verilog HW Debug)
        - 2017.12-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2018.09
            lpddr_svt_O-2018.09

Minimum Required Versions
---------------------------
- Phyinit:  A-2018.12-BETA
- Firmware: A-2018.12-BETA
- PUB:      0.50a
- Hard Macros Family: Type A


------------------------------------------------------------------

Version A-2018.10-BETA
Nov 2, 2018

Preliminary Release

Note: This is a preliminary release.  This release MUST NOT be used for final production release.

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.
  
- This testbench requires the following Verification IP (VIP):
  - dfi_svt_O-2018.09
  - lpddr_svt_O-2018.06

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4 demo_basic(mission mode write/read)
  LPDDR4 demo_lp(DFI low power)
  LPDDR4 demo_lp(frequency change)
  LPDDR5 demo_basic(mission mode write/read)
- Supported features
  Support 32 legal build of RTL defines files for LPDDR4 tests
  Support 16 legal build of RTL defines files for LPDDR5 tests
  Support x16 device for LPDDR4/LPDDR5 
  Support for LPDDR4 in 1:2/1:4 ratio up to LPDDR4-4267
  Support for LPDDR5 in 1:4 CK:WCK mode up to LPDDR5-6400 

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2017.03-SP1
    Synopsys Verdi (Verilog HW Debug)
        - 2017.03-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version 
            dfi_svt_O-2018.06-1-T-20180725_wck_en_patch
            lpddr_svt_O-2018.06-2

Minimum Required Versions
---------------------------
- Phyinit:  A-2018.10-BETA
- Firmware: A-2018.10-BETA
- PUB:      0.40a
- Hard Macros Family: Type A

Please refer to the Customer Testbench Application Note(Chapter 3 in Implementation Guide) in the
<release>/doc directory.

------------------------------------------------------------------

Version A-2018.06
June 15, 2018

Initial version (under continued Beta Testing)

Special Notes
--------------
- This testbench has been validated with tool versions and PHY component versions
  listed below. The testbench may not operate properly if used with versions other
  than identified.

Supported test cases and features
-------------
- Supported test cases(skip-train)
  LPDDR4 demo_basic(mission mode write/read)
  LPDDR4 demo_lp(DFI low power)
  LPDDR4 demo_lp(frequency change)
  LPDDR4 demo_lp(LP3/IO retention)
- Supported features
  Support 32 legal build of RTL defines files
  Support x16 device
  Support 1:2 ratio with SDRAM Clock(ck) frequency 333MHz to 2133MHz

EDA Support
-------------
This section lists the EDA tools and versions used during the QA testing of
this release.
    Synopsys VCS (Verilog Simulation)
        - 2017.03-SP1
    Synopsys Verdi (Verilog HW Debug)
        - 2017.03-SP1
    Synopsys DesignWare (VIP Models)
        - # Using svt version lpddr_svt_M-2017.06

Minimum Required Versions
---------------------------
- Phyinit:  A-2018.06
- Firmware: A-2018.06
- PUB:      0.20a
- Hard Macros Family: Type A


Please refer to the Customer Testbench Application Note(Chapter 3 in Implementation Guide) in the
<release>/doc directory.

------------------------------------------------------------------
