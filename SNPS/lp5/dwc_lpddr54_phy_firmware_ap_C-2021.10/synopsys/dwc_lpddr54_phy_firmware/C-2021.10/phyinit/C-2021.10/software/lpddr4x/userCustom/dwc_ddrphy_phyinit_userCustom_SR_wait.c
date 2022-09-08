/** @file
 *  @brief Waits for Save-Retention firmware to finish.
 *  @addtogroup CustFunc
 *  @{
 */
#include <dwc_ddrphy_phyinit.h>
/**
 * @brief Implements a wait function to Save-Retention firmware to finish.
 *
 * The purpose of this function is to wait for the Save-Retention (SR) Firmware to finish.
 * The number of DfiClk cycles to wait is specific in the
 * dwc_ddrphy_phyinit_print() statements below.
 *
 * The default behavior of dwc_ddrphy_phyinit_userCustom_SR_wait() is to print the comments
 * relating to its functions.
 *
 * User can edit this function to print differently, or implement a mechanism
 * to wait for the SR event to finish in simulation
 *
 *   - Save operation depends on PHY configurations.
 *   - Users may use the following table values as reference
 *
 *     Num of DBYTE |  DDR4  | LPDDR4
 *     ------------ | ------ | ------
 *     1            |  43k   | n/a
 *     4            |  85k   | 62k
 *     8            | 140k   | 96k
 *     9            | 155k   | 104k
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * @returns void
 */
void dwc_ddrphy_phyinit_userCustom_SR_wait(phyinit_config_t *phyctx)
{
	/**
	 * - Wait for a SAVE_NUM_CYCLE of DFI clock cycles
	 */

	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// Wait for a SAVE_NUM_CYCLE of DFI clock cycles\n");
	dwc_ddrphy_phyinit_cmnt("// Save operation depends on PHY configurations.\n");
	dwc_ddrphy_phyinit_cmnt("// Users may use the following table values as reference\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// Num of DBYTE    DDR4     LPDDR4\n");
	dwc_ddrphy_phyinit_cmnt("// 1               43k      n/a\n");
	dwc_ddrphy_phyinit_cmnt("// 4               85k      62k\n");
	dwc_ddrphy_phyinit_cmnt("// 8               140k     96k\n");
	dwc_ddrphy_phyinit_cmnt("// 9               155k     104k\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
}

/** @} */
