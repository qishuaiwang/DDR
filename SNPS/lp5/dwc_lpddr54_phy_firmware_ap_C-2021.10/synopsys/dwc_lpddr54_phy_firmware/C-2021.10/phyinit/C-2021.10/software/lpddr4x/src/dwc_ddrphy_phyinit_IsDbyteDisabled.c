/** \file
 * \brief Helper function to determine dbyte should be disabled.
 * \addtogroup SrcFunc
 * @{
 */
#include <stdlib.h>
#include <math.h>
#include "dwc_ddrphy_phyinit.h"
/** @brief Helper function to determine if a given DByte is Disabled given PhyInit inputs.
 * \param phyctx Data structure to hold user-defined parameters
 * @return 1 if disabled, 0 if enabled.
 */
int dwc_ddrphy_phyinit_IsDbyteDisabled(phyinit_config_t *phyctx, int DbyteNumber)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	PMU_SMB_LPDDR4X_1D_t *mb_LPDDR4X_1D = phyctx->mb_LPDDR4X_1D;

	int DisableDbyte = 0; // default assume Dbyte is Enabled.
	int NumCh = pUserInputBasic->NumCh;
	int NumDbyte = NumCh * pUserInputBasic->NumDbytesPerCh;

	int nad0 = pUserInputBasic->NumActiveDbyteDfi0;
	int nad1 = pUserInputBasic->NumActiveDbyteDfi1;

	if (nad0 + nad1 > NumDbyte) {
		dwc_ddrphy_phyinit_assert(0, " [%s] invalid PHY configuration:NumActiveDbyteDfi0(%d) + NumActiveDbyteDfi1(%d)>NumDbytes(%d).\n", __func__, nad0, nad1, NumDbyte);
	}

	// Implements Section 1.3 of Pub Databook
	if (NumCh == 2) {
		if (pUserInputBasic->NumActiveDbyteDfi1 == 0) {	// only dfi0 (ChA) is enabled, dfi1 (ChB) disabled
			DisableDbyte = (DbyteNumber > pUserInputBasic->NumActiveDbyteDfi0 - 1) ? 1 : 0;
		} else { // DFI1 enabled
			DisableDbyte = ((pUserInputBasic->NumActiveDbyteDfi0 - 1 < DbyteNumber) && (DbyteNumber < (floor(NumDbyte / 2)))) ? 1 : (DbyteNumber > (floor(NumDbyte / 2) + pUserInputBasic->NumActiveDbyteDfi1 - 1)) ? 1 : 0;
		}
	} else if (NumCh == 1) {
		DisableDbyte = (DbyteNumber > pUserInputBasic->NumActiveDbyteDfi0 - 1) ? 1 : 0;
	} else {
		dwc_ddrphy_phyinit_assert(0, " [%s] invalid PHY configuration:NumCh is neither 1 or 2.\n", __func__);
	}

	// Qualify results against MessageBlock
	if (NumCh == 1 && (mb_LPDDR4X_1D[0].EnabledDQsChA < 1 || mb_LPDDR4X_1D[0].EnabledDQsChA > 8 * pUserInputBasic->NumActiveDbyteDfi0)) {
		dwc_ddrphy_phyinit_assert(0, " [%s] EnabledDQsChA(%d). Value must be 0 < EnabledDQsChA < pUserInputBasic->NumActiveDbyteDfi0*8 when NumCh is 1.\n", __func__, mb_LPDDR4X_1D[0].EnabledDQsChA);
	}

	if (NumCh == 2 && pUserInputBasic->NumActiveDbyteDfi1 > 0 && (mb_LPDDR4X_1D[0].EnabledDQsChB > 8 * pUserInputBasic->NumActiveDbyteDfi1)) {
		dwc_ddrphy_phyinit_assert(0, " [%s] EnabledDQsChB(%d). Value must be 0 <= EnabledDQsChB < pUserInputBasic->NumActiveDbyteDfi1*8.\n", __func__, mb_LPDDR4X_1D[0].EnabledDQsChB);
	}

	return DisableDbyte;
}

/** @} */
