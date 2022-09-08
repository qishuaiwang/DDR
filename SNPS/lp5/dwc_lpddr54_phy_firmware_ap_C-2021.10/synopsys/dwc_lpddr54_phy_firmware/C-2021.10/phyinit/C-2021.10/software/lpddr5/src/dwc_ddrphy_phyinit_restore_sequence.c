/** \file
 *  \addtogroup SrcFunc
 *  @{
 */

#include "dwc_ddrphy_phyinit.h"

/** \brief This function implements the register restore portion of S3/IO
 * retention sequence.
 *
 * \note This function requires the runtime_config.Reten=1 to enable PhyInit exit retention feature.  This variable can be set as in
 * \param phyctx Data structure to hold user-defined parameters
 * \returns 0 on completion of the sequence, EXIT_FAILURE on error.
 */
int dwc_ddrphy_phyinit_restore_sequence(phyinit_config_t *phyctx)
{
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	uint16_t reg_data;				///< register value

	if (!pRuntimeConfig->RetEn) {
		dwc_ddrphy_phyinit_assert(0, "[%s] retention restore sequence function is called but register save process was not executed during initialization sequence (pRuntimeConfig->RetEn != 0)\n", __func__);
	}

	dwc_ddrphy_phyinit_cmnt("[%s] Start of %s", __func__, __func__);
	
	///Before you call this functions perform the following:
	///  --------------------------------------------------------------------------
	///  -# Bring up VDD, VDDQ should already be up
	///  -# Since the CKE* and MEMRESET pin state must be protected, special care
	///    must be taken to ensure that the following signals
	///     - atpg_mode = 1'b0
	///     - PwrOkIn = 1'b0
	///
	///  -# The {BypassModeEn*, WRSTN} signals may be defined at VDD power-on, but
	///    must be driven to ZERO at least 10ns prior to the asserting edge of
	///    PwrOkIn.
	///
	///  -# Start Clocks and Reset the PHY
	///    This step is identical to dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy()
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("  Before you call this functions perform the following:\n");
	dwc_ddrphy_phyinit_cmnt("  --------------------------------------------------------------------------\n");
	dwc_ddrphy_phyinit_cmnt("  -# Bring up VDD, VDDQ should already be up\n");
	dwc_ddrphy_phyinit_cmnt("  -# Since the CKE* and MEMRESET pin state must be protected, special care\n");
	dwc_ddrphy_phyinit_cmnt("    must be taken to ensure that the following signals\n");
	dwc_ddrphy_phyinit_cmnt("     - atpg_mode = 1'b0\n");
	dwc_ddrphy_phyinit_cmnt("     - PwrOkIn = 1'b0\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("  -# The {BypassModeEn*, WRSTN} signals may be defined at VDD power-on, but\n");
	dwc_ddrphy_phyinit_cmnt("    must be driven to ZERO at least 10ns prior to the asserting edge of\n");
	dwc_ddrphy_phyinit_cmnt("    PwrOkIn.\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("  -# Start Clocks and Reset the PHY\n");
	dwc_ddrphy_phyinit_cmnt("    This step is identical to dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy()");

	/// This function performs the following in sequence
	/// --------------------------------------------------------------------------

	/// -# Write the MicroContMuxSel CSR to 0x0 to allow access to the internal CSRs
	dwc_ddrphy_phyinit_cmnt("[%s] Write the MicroContMuxSel CSR to 0x0 to allow access to the internal CSRs\n", __func__);
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x0);

	/// -# Write the UcclkHclkEnables CSR to enable all the clocks so the reads can complete
	uint16_t pmuClkEnables = csr_HclkEn_MASK | csr_UcclkEn_MASK;
    uint8_t lowest = 0;

	for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
		if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) {
			continue;
		}
 
		lowest = pstate;
		break;
	}

	if (pUserInputAdvanced->PmuClockDiv[lowest] == 0) {
		pmuClkEnables |= (uint16_t) csr_UcclkFull_MASK;
	}
	dwc_ddrphy_phyinit_cmnt("[%s] Write csr_UcclkHclkEnables = 0x%x to enable all the clocks so the reads can complete\n", __func__, pmuClkEnables);
	dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | csr_UcclkHclkEnables_ADDR), pmuClkEnables);

	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt(" --------------------------------------------------\n");
	dwc_ddrphy_phyinit_cmnt(" Steps to restore Impedance Calibration values.\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt(" - Restore Pull-up impedance calibration code by overriding csr_ZQCalCodeOvrPU with saved initial value.\n");
	dwc_ddrphy_phyinit_cmnt(" - The following printed ZQCalCodeOvrPU value is only a placeholder.\n");
	dwc_ddrphy_phyinit_cmnt(" - user must replace Subfield: ZQCalCodeOvrEnPU 0:0 with 0x1,\n");
	dwc_ddrphy_phyinit_cmnt(" - user must replace Subfield: ReservedZQCalCodeOvrEnPU 7:1 with 0x0,\n");
	dwc_ddrphy_phyinit_cmnt(" - user must replace Subfield: ZQCalCodeOvrValPU 15:8 with the actual saved initial ZQCalCodePU value,\n");
	dwc_ddrphy_phyinit_cmnt(" - user should read and save the initial ZQCalCodePU value in [dwc_ddrphy_phyinit_userCustom_customPostTrain].\n");
	reg_data = (pRuntimeConfig->ZQCalCodePU_saved << csr_ZQCalCodeOvrValPU_LSB) | (csr_ZQCalCodeOvrEnPU_MASK);
	dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_ZQCalCodeOvrPU_ADDR), reg_data);

	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt(" - Restore Pull-down impedance calibration code by overriding csr_ZQCalCodeOvrPD with saved initial value.\n");
	dwc_ddrphy_phyinit_cmnt(" - The following printed ZQCalCodeOvrPD value is only a placeholder.\n");
	dwc_ddrphy_phyinit_cmnt(" - user must replace Subfield: ZQCalCodeOvrEnPD 0:0 with 0x1,\n");
	dwc_ddrphy_phyinit_cmnt(" - user must replace Subfield: ReservedZQCalCodeOvrEnPD 7:1 with 0x0,\n");
	dwc_ddrphy_phyinit_cmnt(" - user must replace Subfield: ZQCalCodeOvrValPD 15:8 with the actual saved initial ZQCalCodePD value,\n");
	dwc_ddrphy_phyinit_cmnt(" - user should read and save the initial ZQCalCodePD value in [dwc_ddrphy_phyinit_userCustom_customPostTrain].\n");
	reg_data = (pRuntimeConfig->ZQCalCodePD_saved << csr_ZQCalCodeOvrValPD_LSB) | (csr_ZQCalCodeOvrEnPD_MASK);
	dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_ZQCalCodeOvrPD_ADDR), reg_data);
	//dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_ZQCalCodeOvrPU_ADDR), 0xaa01);
	//dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_ZQCalCodeOvrPD_ADDR), 0x5501);

	/// -# Assert ZCalReset to force impedance calibration FSM to idle.
	///    de-asserted as part of dfi_init_start/complete handshake
	///    by the PIE when DfiClk is valid.
	dwc_ddrphy_phyinit_cmnt(" - Assert ZCalReset to force impedance calibration FSM to idle.\n");
	dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_ZCalReset_ADDR), 0x1);
        
	dwc_ddrphy_phyinit_cmnt(" - Clear ZQCalCodeOvrPU with 0x0.\n");
	dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_ZQCalCodeOvrPU_ADDR), 0x0000);
	dwc_ddrphy_phyinit_cmnt(" - Clear ZQCalCodeOvrPD with 0x0.\n");
	dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_ZQCalCodeOvrPD_ADDR), 0x0000);
	dwc_ddrphy_phyinit_cmnt(" --------------------------------------------------\n");
	dwc_ddrphy_phyinit_cmnt("\n");

	/// -# Issue register writes to restore registers values.
	dwc_ddrphy_phyinit_cmnt(" Issue register writes to restore registers values.\n");
	dwc_ddrphy_phyinit_cmnt(" --------------------------------------------------\n");
	dwc_ddrphy_phyinit_cmnt(" - IMPORTANT -\n");
	dwc_ddrphy_phyinit_cmnt(" - The register values printed in this txt file are always 0x0. The\n");
	dwc_ddrphy_phyinit_cmnt(" - user must replace them with actual registers values from the save sequence. The\n");
	dwc_ddrphy_phyinit_cmnt(" - save sequence can be found in the output.txt file associated with the particular init sequence.\n");
	dwc_ddrphy_phyinit_cmnt(" - The save sequence issues APB read commands to read and save register values.\n");
	dwc_ddrphy_phyinit_cmnt(" - refer to the init sequence output file for details.\n");
	dwc_ddrphy_phyinit_cmnt(" --------------------------------------------------------------------------------\n");
	dwc_ddrphy_phyinit_regInterface(restoreRegs, 0, 0);

	/// -# Write the UcclkHclkEnables CSR to disable the appropriate clocks after all reads done.
	dwc_ddrphy_phyinit_cmnt("[%s] Write csr_UcclkHclkEnables to disable the appropriate clocks after all reads done.\n", __func__);
	dwc_ddrphy_phyinit_cmnt("[%s] Disabling Ucclk (PMU) and Hclk (training hardware)\n", __func__);
	dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | csr_UcclkHclkEnables_ADDR), 0);

	/// -# Write the MicroContMuxSel CSR to 0x1 to isolate the internal CSRs during mission mode
	dwc_ddrphy_phyinit_cmnt("[%s] Write the MicroContMuxSel CSR to 0x1 to isolate the internal CSRs during mission mode\n", __func__);
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x1);
	
	///After Function Call
	///  --------------------------------------------------------------------------
	///  To complete the Retention Exit sequence:
	///
	///  -# Initialize the PHY to Mission Mode through DFI Initialization
	///    You may use the same sequence implemented in
	///    dwc_ddrphy_phyinit_userCustom_J_enterMissionMode()
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("  After Function Call\n");
	dwc_ddrphy_phyinit_cmnt("  --------------------------------------------------------------------------\n");
	dwc_ddrphy_phyinit_cmnt("  To complete the Retention Exit sequence:\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("  -# Initialize the PHY to Mission Mode through DFI Initialization\n");
	dwc_ddrphy_phyinit_cmnt("    You may use the same sequence implemented in\n");
	dwc_ddrphy_phyinit_cmnt("    dwc_ddrphy_phyinit_userCustom_J_enterMissionMode()\n");
	dwc_ddrphy_phyinit_cmnt("[%s] End of %s\n", __func__, __func__);
	return 0;
}

/** @} */
