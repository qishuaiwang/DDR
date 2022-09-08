/** \file
 *  \brief function to implement step H of PUB databook initialization step.
 *  \addtogroup CustFunc
 *  @{
 */
#include "dwc_ddrphy_phyinit.h"

/** \brief reads training results
 *
 * Read the Firmware Message Block via APB read commands to the DMEM address to
 * obtain training results.
 *
 * The default behavior of this function is to print comments relating to this
 * process. An example pseudo code for implementing this function is as follows:
 *
 * @code{.c}
 * if (Train2D) {
 *   _read_2d_message_block_outputs_
 * } else {
 *   _read_1d_message_block_outputs_
 * }
 * @endcode
 *
 * A function call of the same name will be printed in the output text file.
 * User can choose to leave this function as is, or implement mechanism to
 * trigger message block read events in simulation.
 *
 * \param phyctx Data structure to hold user-defined parameters
 * \param Train2D 1 if doing 2D training, 0 otherwise
 *
 * \return void
 */
void dwc_ddrphy_phyinit_userCustom_H_readMsgBlock(phyinit_config_t *phyctx, int Train2D)
{
	dwc_ddrphy_phyinit_cmnt(" [%s] Start of %s()\n", __func__, __func__);
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("2. Read the Firmware Message Block to obtain the results from the training.\n");
	dwc_ddrphy_phyinit_cmnt("This can be accomplished by issuing APB read commands to the DMEM addresses.\n");
	dwc_ddrphy_phyinit_cmnt("Example:\n");
	dwc_ddrphy_phyinit_cmnt("if (Train2D) {\n");
	dwc_ddrphy_phyinit_cmnt("	_read_2d_message_block_outputs_\n");
	dwc_ddrphy_phyinit_cmnt("} else {\n");
	dwc_ddrphy_phyinit_cmnt("	_read_1d_message_block_outputs_\n");
	dwc_ddrphy_phyinit_cmnt("}\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_print("%s (phyctx, %d);\n\n", __func__, Train2D);
	dwc_ddrphy_phyinit_cmnt(" [%s] End of %s ()\n", __func__, __func__);
}

/** @} */
