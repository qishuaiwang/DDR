/** \file
 *  \brief function to implement step B of PUB databook initialization step.
 *  \addtogroup CustFunc
 *  @{
 */

#include "dwc_ddrphy_phyinit_userCustom.h"

/** \brief The user can use this function to initiate the clocks and reset the
 * PHY.
 *
 * The default behavior of this function is to print comments relating to this
 * process. A function call of the same name will be printed in the output text
 * file. The user can choose to leave this function as is, or implement
 * mechanism within this function to trigger start clock and reset events in
 * simulation.
 *
 * Following is one possible sequence to reset the PHY. Other sequences are also
 * possible. See section "Clocks, Reset, Initialization" of the PUB for other
 * possible reset sequences.
 *
 * -# Drive PwrOkIn to 0. Note: Reset, DfiClk, and APBCLK can be X.
 * -# Start DfiClk and APBCLK
 * -# Drive Reset to 1 and PRESETn_APB to 0.
 *    Note: The combination of PwrOkIn=0 and Reset=1 signals a cold reset to the PHY.
 * -# Wait a minimum of 8 cycles.
 * -# Drive PwrOkIn to 1. Once the PwrOkIn is asserted (and Reset is still asserted),
 *    DfiClk synchronously switches to any legal input frequency.
 * -# Wait a minimum of 64 cycles. Note: This is the reset period for the PHY.
 * -# Drive Reset to 0. Note: All DFI and APB inputs must be driven at valid
 *    reset states before the de-assertion of Reset.
 * -# Wait a minimum of 1 Cycle.
 * -# Drive PRESETn_APB to 1 to de-assert reset on the ABP bus.
 * -# The PHY is now in the reset state and is ready to accept APB transactions.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 */
void dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy(phyinit_config_t *phyctx)
{
	dwc_ddrphy_phyinit_cmnt("[%s] Start of %s()\n", __func__, __func__);
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// Step (B) Start Clocks and Reset the PHY\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// See PhyInit App Note for detailed description and function usage\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_print("%s (phyctx);\n\n", __func__);
	dwc_ddrphy_phyinit_cmnt("[%s] End of %s()\n", __func__, __func__);
}

/** @} */
