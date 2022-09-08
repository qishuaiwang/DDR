/**
 * \file
 * \brief Start of the Micro-Controller based Save/Restore function.
 *
 *  \addtogroup SrcFunc
 *  @{
 */
#include "dwc_ddrphy_phyinit.h"

/** \brief Start of the Micro Controller based Save/Restore function
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * Start of SR function.
 * Load Universal Resident Retention FW image and kick off Micro Controller,
 * Wait for save operation to be completed. The exact steps of the functions
 * are:
 */
void dwc_ddrphy_phyinit_SR_start_function(phyinit_config_t *phyctx)
{
	dwc_ddrphy_phyinit_cmnt("\n\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// 4.3 Initialize PHY Configuration\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// Optional step (SR) - Save Start\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// About to save required PHY registers to DMEM for later IO retention exit restore performed by firmware\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n\n");

	dwc_ddrphy_phyinit_cmnt(" [%s] Start of %s\n", __func__, __func__);

	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
  user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	/**
	 * - Program MicroContMuxSel to gain control of the APB bus
	 * - Program UcclkHclkEnables to have PHY micro controller and training
	 *   hardware clocks enabled
	 */

	dwc_ddrphy_phyinit_cmnt("// Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 0.\n");
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x0);

	dwc_ddrphy_phyinit_cmnt("// Enable Ucclk (PMU) and Hclk (training hardware)\n");
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
	dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | csr_UcclkHclkEnables_ADDR), pmuClkEnables);

	/**
	 * - To load IMEM and DMEM with universal resident retention FW image by
	 *   calling dwc_ddrphy_phyinit_load_SR_FW().
	 */
	dwc_ddrphy_phyinit_load_SR_FW();

	/**
	 * - Program MicroContMuxSel:
	 *   - To give micro controller control of the APB bus
	 * - Program MicroReset:
	 *   - To execute universal resident retention FW image
	 */

	dwc_ddrphy_phyinit_cmnt("// Allow Micro Controller to gain control of the APB bus by setting the MicroContMuxSel CSR to 1.\n");
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x1);

	dwc_ddrphy_phyinit_cmnt("// Halt and reset Micro Controller.\n");
	dwc_ddrphy_phyinit_userCustom_io_write16((tAPBONLY | csr_MicroReset_ADDR), 0x9);
	dwc_ddrphy_phyinit_cmnt("// Halt Micro Controller.\n");
	dwc_ddrphy_phyinit_userCustom_io_write16((tAPBONLY | csr_MicroReset_ADDR), 0x1);
	dwc_ddrphy_phyinit_cmnt("// Kick off Micro Controller and execute universal resident retention FW.\n");
	dwc_ddrphy_phyinit_userCustom_io_write16((tAPBONLY | csr_MicroReset_ADDR), 0x0);

	/**
	 * - Wait for a SAVE_NUM_CYCLE of DFI clock cycles by calling
	 *   dwc_ddrphy_phyinit_userCustom_SR_wait().
	 */
	dwc_ddrphy_phyinit_userCustom_SR_wait(phyctx);

	dwc_ddrphy_phyinit_cmnt(" [%s] End of %s\n", __func__, __func__);
}

/** @} */
