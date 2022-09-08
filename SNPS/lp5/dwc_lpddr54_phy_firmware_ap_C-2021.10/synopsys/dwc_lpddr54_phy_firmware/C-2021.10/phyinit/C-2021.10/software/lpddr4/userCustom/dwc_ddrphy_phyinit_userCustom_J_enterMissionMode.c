/** \file
 *  \brief function to implement step J of PUB databook initialization step.
 *  \addtogroup CustFunc
 *  @{
 */

#include "dwc_ddrphy_phyinit_userCustom.h"
/** \brief Initialize the PHY to Mission Mode through DFI Initialization
 *
 * The default behavior of this function is to print comments relating to this
 * process. User can choose to leave this function as is, or implement mechanism
 * to trigger DFI Initialization in simulation.
 *
 * Initialize the PHY to mission mode as follows:
 * -# Set the PHY input clocks to the desired frequency.
 * -# Initialize the PHY to mission mode by performing DFI Initialization. See
 * PUB Databook section on "DFI Frequency Change" for details on this step.
 *
 * \note to ensure DRAM MR state matches the destination frequency, the first
 * dfi_freq[4:0] must be to a PState matching the last trained PState.  For
 * Example 1) if 3 PStates are used and only 1D training is run, the first
 * dfi_freq[4:0] must be 0x3 on the first dfi_init_start transaction.
 * PState selected via dfi_freq[4:0] must match the
 * Example 2) if 3 PStates are used with 2D training enabled, the first
 * dfi_freq[4:0] must be 0x0 on the first dfi_init_start transaction.
 *
 * \note The PHY training firmware initializes the DRAM state. if skip
 * training is used, the DRAM state is not initialized.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \returns void
 */
void dwc_ddrphy_phyinit_userCustom_J_enterMissionMode(phyinit_config_t *phyctx)
{
	dwc_ddrphy_phyinit_cmnt(" [%s] Start of %s()\n", __func__, __func__);
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// (J) Initialize the PHY to Mission Mode through DFI Initialization\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// Initialize the PHY to mission mode as follows:\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// 1. Set the PHY input clocks to the desired frequency.\n");
	dwc_ddrphy_phyinit_cmnt("// 2. Initialize the PHY to mission mode by performing DFI Initialization.\n");
	dwc_ddrphy_phyinit_cmnt("//    Please see the DFI specification for more information. See the DFI frequency bus encoding in section <XXX>.\n");
	dwc_ddrphy_phyinit_cmnt("// Note: The PHY training firmware initializes the DRAM state. if skip\n");
	dwc_ddrphy_phyinit_cmnt("// training is used, the DRAM state is not initialized.\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_print("%s (phyctx);\n\n", __func__);
	dwc_ddrphy_phyinit_cmnt(" [%s] End of %s()\n", __func__, __func__);
}

/** @} */
