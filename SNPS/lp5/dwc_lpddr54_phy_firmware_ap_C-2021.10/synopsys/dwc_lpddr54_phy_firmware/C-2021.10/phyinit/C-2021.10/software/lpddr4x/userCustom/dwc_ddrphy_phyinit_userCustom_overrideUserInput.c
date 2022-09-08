/** \file
 *  \brief used for overriding setDefault assignments
 *  \addtogroup CustFunc
 *  @{
 */
#include "dwc_ddrphy_phyinit.h"
#include <stdlib.h>

/** @brief overrides any field in PhyInit data structure dynamically.
 *
 * This function can be used to dynamically change PhyInit Data structures set
 * by dwc_ddrphy_setDefault().
 *
 * To override user_input_basic, user_input_advanced and user_input_sim the user
 * can:
 * -# call dwc_ddrphy_phyinit_setUserInput(char *field, int value)
 * -# directly assigning structure instances userInputBasic or userInputAdvanced.
 *
 * To override settings in the message block, users must use
 * dwc_ddrphy_phyinit_setMb().
 *
 * \warning some message bloc fields are set by dwc_ddrphy_phyinit_calcMb(). If
 * these fields are set directly in this function, the override will not take
 * effect. dwc_ddrphy_phyinit_setMb() must be used to keep the override message
 * block values.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * @return void
 */

void dwc_ddrphy_phyinit_userCustom_overrideUserInput(phyinit_config_t *phyctx)
{
	//user_input_basic_t* pUserInputBasic = &phyctx->userInputBasic;
	//user_input_advanced_t* pUserInputAdvanced = &phyctx->userInputAdvanced;
	//int CurrentPhyInst = phyctx->CurrentPhyInst;

	dwc_ddrphy_phyinit_print("\n");
	dwc_ddrphy_phyinit_print("\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("// %s is a user-editable function.\n", __func__);
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// See PhyInit App Note for detailed description and function usage\n");
	dwc_ddrphy_phyinit_print("//\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_print("\n");
	dwc_ddrphy_phyinit_print("%s (phyctx);\n", __func__);
	dwc_ddrphy_phyinit_cmnt("\n");

	// == Definitions for overriding a single PHY system
	// Example Values for testing

	// === Example to override frequency for P-State 0,1,2,3
	// === using dwc_ddrphy_phyinit_setUserInput()
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "Frequency[0]", 1600); // 3200Mbps
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "Frequency[1]", 1200); // 2400Mbps
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "Frequency[2]", 933); // 1866Mbps
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "Frequency[3]", 50); // 100Mbps

	// === Example to override MemAlert related inputs using dwc_ddrphy_phyinit_setUserInput()
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "MemAlertEn", 0x1);
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "MemAlertPUImp", 0x8);
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "MemAlertVrefLevel", 32);
	// dwc_ddrphy_phyinit_setUserInput(phyctx, "MemAlertSyncBypass", 0x1);

	// === Example to override frequency by setting the data structure
	// === directly
	// pUserInputBasic->Frequency[3] = 1600; // 3200Mbps
	// pUserInputBasic->Frequency[2] = 1200; // 2400Mbps
	// pUserInputBasic->Frequency[1] = 933; // 1866Mbps
	// pUserInputBasic->Frequency[0] = 50; // 100Mbps

	// === Example to override MemAlert related inputs by setting the data
	// === structure directly
	// pUserInputAdvanced->MemAlertEn = 0x0000;
	// pUserInputAdvanced->MemAlertPUImp = 0x0005;
	// pUserInputAdvanced->MemAlertVrefLevel = 0x0029;
	// pUserInputAdvanced->MemAlertSyncBypass = 0x0000;

	// === Example to set HdtCtrl to 0xff for 1D for pstates 0,1,2,3
	// === using dwc_ddrphy_phyinit_setMb()
	// dwc_ddrphy_phyinit_setMb(phyctx, 0, "HdtCtrl", 0xff);
	// dwc_ddrphy_phyinit_setMb(phyctx, 1, "HdtCtrl", 0xff);
	// dwc_ddrphy_phyinit_setMb(phyctx, 2, "HdtCtrl", 0xff);
	// dwc_ddrphy_phyinit_setMb(phyctx, 3, "HdtCtrl", 0xff);

	dwc_ddrphy_phyinit_cmnt(" [%s] End of %s()\n", __func__, __func__);
}

/** @} */
