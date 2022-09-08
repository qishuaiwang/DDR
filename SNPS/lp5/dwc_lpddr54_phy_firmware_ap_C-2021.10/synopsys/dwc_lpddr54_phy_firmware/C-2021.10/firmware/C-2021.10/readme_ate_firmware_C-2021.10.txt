Copyright 2021 Synopsys, Inc.
This Synopsys IP and all associated documentation are proprietary to
Synopsys, Inc. and may only be used pursuant to the terms and conditions
of a written license agreement with Synopsys, Inc. All other use,
reproduction, modification, or distribution of the Synopsys IP or the
associated documentation is strictly prohibited.
------------------------------------------------------------------
LPDDR54 PHY ATE FIRMWARE

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

------------------------------------------------------------------

Version C-2021.06
June 7, 2021

Changes from Version C-2021.03
(recommended)

Bug Fixes
----------
- STAR 3631312: Loopback Tests Interfere With Burn-In Test - Refer to ATE-FW APP-Note section 4.11.

Enhancements
-------------
- ATE FW Revision Code: 2021_0600
- PLL-Lock test infinite slow MemClk generation now continues after ARC halts. Refer to ATE-FW APP-Note section 4.4.4.
- Added csrPUBREV override message block input (PubRev), which must be set to 0x0 unless otherwise directed by Synopsys.

Limitations
------------
- None

Supported Versions
-------------------------
   - PUB: 1.x, 2.x

------------------------------------------------------------------

Version C-2021.03
March 25, 2021

Changes from Version C-2020.11
(mandatory)

Bug Fixes
----------
- STAR 3456121: Data-loopback-2D fails if data-loopback-1D runs before it.
- STAR 3598788: ATE firmware does not support ucclkFull = 1.

Enhancements
-------------
- ATE FW Revision Code: 2021_0300
- Improved DCA-loopback test to better handle VT drift.

Limitations
------------
- STAR 3631312: Loopback Tests Interfere With Burn-In Test.

Supported Versions
-------------------------
   - PUB: 1.x, 2.x

------------------------------------------------------------------

Version C-2020.11
November 20, 2020

Changes from Version A-2020.09
(mandatory)

Bug Fixes
----------
- STAR 3410226: AC Loopback stuck-at failures should result in the AC Loopback test reporting a fail
- STAR 3410286: AC Loopback run with AcLoopMinLoopPwr=1 on a dual-channel single-rank PHY was not performing stuck-at testing on SeSlice=0 in Channel=1
- STAR 3461101: In data-loopback-1D/2D, ensure that for data-rates above 4276Mbps, the TX/RX FIFOs are not corrupted

Enhancements
-------------
- ATE FW Revision Code: 2020_1100
- Added support for PUB 2.10a
- If the Impedance Calibration test is run with ContinuousCal=1, subsequent tests will issue a ZQUpdate just before they drive traffic, which ensures the drivers have the updated codes.
- In LCDL Linearity test, changing LcdlPassPercent by +/-1 now corresponds to an error bar change of +/-0.05%, instead of the previous +/-1%.
- LCDL Linearity now gracefully handles the situation where the ring oscillators fail to terminate within the expected time.
- RxReplica Calibration test now saves the RxReplica path-phases and RxReplica LCDL 1UI lock codes to the results section of the message block.
- During AC-Loopback testing, if an illegal argument error occurs, all outputs are now initialized with 0xA5.
- During AC Loopback, the SEC and DIFF slices are no longer simultaneously active during testing.
- Improved the quality of the WCK slice EYEs (during Data Loopback 1D and DCA Loopback) by using only the TxWck LCDL to sweep the tested delays. Previously, a combination of the TxWck LCDL and the receive strobe were used.
- The DCA Loopback test now only sweeps the full delay range for the first tested DCA fine/coarse setting. All subsequently tested DCA fine/coarse settings only sweep a 3UI window around the passing region.
- During the DCA Loopback test, ensure WCK DCA outputs don't glitch when stopping WCK traffic.
- Burn-In test now configures the CSRs AcVrefDac[0..3] based on the message block input 'AcVrefDac'. Previously, user had to manually program these CSRs.

Limitations
------------
- STAR 3456121: Selecting data-loopback-1D and data-loopback-2D in TestsToRun at the same time will result in data-loopback-2D failing. A fix is in development.
                  - Workaround: only select one data-loopback test type to run at a time.


Supported Versions
-------------------------
   - PUB: 1.x, 2.x

------------------------------------------------------------------

Version A-2020.09
August 28, 2020

Changes from Version A-2020.06
(mandatory)


Bug Fixes
----------
- The CSRs DxPipeEn and RxDigStrbDly are set by ATE-FW
- LCDL Linearity test fix which prevents X-Prop when simulating with 'DWC_DDRPHY_PLL_ACCURATE_MODEL' enabled
- RxReplica 1UI code checking has been aligned with training-fw
- The configuration of the PLL config CSR PllLockPhSel has been aligned with training-fw

Enhancements
-------------
- ATE FW Revision Code: 2020_0900
- Introduction of 'DCA Loopback' test, which exercises the WCK DCA (Duty-Cycle Adjustment) circuitry
   - NOTE: Only PUBs 1.02a and above include DCA support
- Addition of AC-Loopback and Data-Loopback infinite-traffic mode, which is enabled by setting ClksToRun to 0
- Data-loopback RXEN training improved to support hunting for the first DQS pulse within an 8UI window (instead of only 4UI)
- Burn-In settings updated to be consistent with requirements from circuit team
- Burn-In test now supports core-loopback mode
- During AC Loopback single-ended CK_T testing, drive unused CK_C to 0x1
- Added support for PUB 1.10a

Limitations
------------
- At data-rates above 4276Mbps, the TX DQS FIFO may become corrupted, and result in 1D/2D data loopback failing. A fix is in development.
- During Burn-In, the user will need to program the CSRs AcVrefDAC[0..3] (if the default value is not appropriate). This will be fixed a future release.
   - Only ACs in PSTATE 0 need to be written.


Supported Versions
-------------------------
   - PUB: 1.x, 2.x

------------------------------------------------------------------

Version A-2020.06
June 30, 2020

Changes from version A-2020.04-T-47332 Pre-Release
(required)

Bug Fixes
----------
 - PLL Lock test check should ignore PLL_LOCK pulses mid locking-procedure
 - AC Loopback SEC slice test pattern was updated to use a data-rate that is within spec. Consequently, it now has it's own 'MinEyeWidth' message block input
 - SEC slice pin should not be terminated for pad-side loopback

Enhancements
-------------
 - ATE FW Revision Code: 2020_0600
 - Data loopback 1D dedicated DQS testing (enabled by default in core-loopback mode, optional in pad-loopback mode)
 - Optional single-ended testing available for AC and DBYTE DIFF slices
 - Added serial-testing option for AC and Data-Loopback (1D/2D)
 - Tests can be run back-to-back without reloading the IMEM and DMEM
 
Limitations
------------
 - User must program the DBYTE CSR DxPipeEn based on choice of clocking mode, DFICLK frequency, frequency ratio
   - Refer to PUB databook for field encoding
   - Only DBYTES in PSTATE 0 must be written
   - If the CSR DxPipeEn is enabled, and the user is running data-loopback 1D or 2D in core-loopback mode, the message block input 'RxDigStrbDly' must be set to 0x13F

Supported Versions
-------------------------
   - PUB: 1.x, 2.x

------------------------------------------------------------------

Version A-2020.04-T-47332
Apr 30, 2020

ATE FW Revision Code: 2020_0400

Initial release of ATE FW - NOT to be used for production

NOTE: The A-2020.04-T-47332 message block has changed and is NOT compatible with the previous release B-2019.10-BETA-PRE-20191025_0046992.

The following tests have been verified:
   - Revision Check
   - Impedance Calibration
   - PLL Lock / LCDL Calibration
   - LCDL Linearity
   - AC Loopback
   - 1D Data Loopback
   - 2D Data Loopback

The following test(s) have been included in this release, but have not been fully verified:
   - Burn-In

Required Versions
-------------------------
 - PUB: 1.01a
