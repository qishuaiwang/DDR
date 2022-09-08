/** \file
 *  \brief user customizations after training
 *  \addtogroup CustFunc
 *  @{
 */

#include "dwc_ddrphy_phyinit.h"

/** \brief used for customer register programing after PState loop
 *
 * This function is called after the execution of training firmware is
 * complete. The user can use this function to override any CSR value programmed
 * by PhyInit or training firmware.
 *
 * The purpose of this function is to override any register values programmed
 * by the training firmware or dwc_ddrphy_phyinit_progCsrSkipTrain() when
 * skip_train is used. This function is executed after training firmware has
 * completed.
 *
 * \note **Warning!**
 * This function must not override any values in userInputBasic,
 * userInputAdvanced or message block data structures.  Only PHY register values
 * are to be modified with this function. To override PHY register values
 * programmed by PhyInit, users must use
 * dwc_ddrphy_phyinit_userCustom_io_write16() function calls placed within this
 * function.
 *
 * Sequence of Events in this function must be:
 * -# Enable APB access
 * -# Issue register writes
 * -# Isolate APB access
 *
 *  @param[in]  phyctx  PhyInit configuration context
 *
 * A \ref examples/simple/dwc_ddrphy_phyinit_userCustom_customPostTrain.c example of this function
 *
 * \return void
 *
 */
void dwc_ddrphy_phyinit_userCustom_customPostTrain(phyinit_config_t *phyctx)
{
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// %s is a user-editable function.\n", __func__);
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// See PhyInit App Note for detailed description and function usage\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_print("%s (phyctx);\n\n", __func__);
	dwc_ddrphy_phyinit_cmnt(" [%s] End of %s()\n", __func__, __func__);
}

/** \brief used for custom register programming after initial training, within the PState Loop.
 *
 * This function is called after the execution of training firmware is
 * complete. The user can use this function to override any CSR value programmed
 * by PhyInit or training firmware.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 */
void dwc_ddrphy_phyinit_userCustom_customPostTrainPsLoop(phyinit_config_t *phyctx, int pstate)
{

}

/** @} */
