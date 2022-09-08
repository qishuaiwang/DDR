/** \file
 * \brief calculates messageBlock header based on user_input_basic and user_input_advanced.
 */

#include <stdlib.h>
#include "dwc_ddrphy_phyinit.h"

/**
 *  \addtogroup SrcFunc
 *  @{
 */

/** \brief reads PhyInit inputs structures and sets relevant message bloc
 * parameters.
 *
 * This function sets Message Block parameters based on user_input_basic and
 * user_input_advanced. Parameters are only set if not programed by
 * dwc_ddrphy_phyinit_userCustom_overrideUserInput() or
 * dwc_ddrphy_phyinit_setDefault(). user changes in these files takes precedence
 * over this function call.
 *
 * MessageBlock fields set ::
 *
 *  - DramType
 *  - Pstate
 *  - DRAMFreq
 *  - PllBypassEn
 *  - DfiFreqRatio
 *  - PhyOdtImpedance
 *  - PhyDrvImpedance
 *  - BPZNResVal
 *  - EnabledDQsChA (only applies to LPDDR4 protocol)
 *  - CsPresentChA (only applies to LPDDR4 protocol)
 *  - EnabledDQsChB (only applies to LPDDR4 protocol)
 *  - CsPresentChB (only applies to LPDDR4 protocol)
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 */
void dwc_ddrphy_phyinit_calcMb(phyinit_config_t *phyctx)
{

	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;

	pUserInputAdvanced = pUserInputAdvanced;	// to avoid warning in case it would not be used
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	int Train2D = pRuntimeConfig->Train2D;

	PMU_SMB_LPDDR4X_1D_t *mb1D = phyctx->mb_LPDDR4X_1D;

	dwc_ddrphy_phyinit_cmnt("[%s] Start of %s()\n", __func__, __func__);

	if (pUserInputBasic->NumPStates == 2) {
		pUserInputBasic->CfgPStates = 0x3;
	}
	int NumCh = pUserInputBasic->NumCh;
	int NumDbyte = NumCh * pUserInputBasic->NumDbytesPerCh;
	int nad0 = pUserInputBasic->NumActiveDbyteDfi0;
	int nad1 = pUserInputBasic->NumActiveDbyteDfi1;

	// a few checks to make sure valid programing.
	if (nad0 < 0 || nad1 < 0 || (nad0 + nad1 <= 0) || (nad0 == 0 && NumCh == 1) || NumDbyte <= 0) {
		dwc_ddrphy_phyinit_assert(0, "[%s] NumActiveDbyteDfi0, NumActiveDbyteDfi0, NumByte out of range.\n", __func__);
	}

	if ((nad0 + nad1) > NumDbyte) {
		dwc_ddrphy_phyinit_assert(0, "[%s] NumActiveDbyteDfi0+NumActiveDbyteDfi1 is larger than NumDbyteDfi0\n", __func__);
	}

	if (NumCh == 1 && nad1 != 0) {
		dwc_ddrphy_phyinit_assert(0, "[%s] NumCh==1 but NumActiveDbyteDfi1 != 0\n", __func__);
	}

	if (pUserInputBasic->NumRank_dfi1 != 0 && pUserInputBasic->NumRank_dfi1 != pUserInputBasic->NumRank_dfi0) {
		dwc_ddrphy_phyinit_assert(0,
								  "[%s] In a two channel system, PHY does not support different number of DQ's across ranks. NumRank_dfi0 must equal NumRank_dfi1 if NumRank_df1 !=0.\n",
								  __func__);
	}

#ifdef _BUILD_LPDDR4X
	_IF_LPDDR4(
		if (pUserInputBasic->Lp4xMode != 1) {
			dwc_ddrphy_phyinit_assert(0, "[%s] When DRAM type is LPDDR4X, Lp4xMode should be set to 1.\n", __func__);
		}
	)
#endif

	uint8_t myps;
	// 1D message block defaults
	pRuntimeConfig->Train2D = 0;

	for (myps = 0; myps < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; myps++) {
		if ((pUserInputBasic->CfgPStates & 0x1 << myps) == 0) {
			continue;
		}
		if (pUserInputBasic->DramDataWidth == 8 && mb1D[myps].X8Mode == 0x0) {
			dwc_ddrphy_phyinit_assert(0, "[%s] LPDDR DramDataWidth == 8 but no X8 devices programmed in mb1D[%d].X8Mode!\n", __func__, myps);
		}

		if (pUserInputBasic->NumPStates == 2) {
			_IF_LPDDR4(
				mb1D[myps].FCDfi0AcsmStartPSY = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4;
				mb1D[myps].FCDfi1AcsmStartPSY = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4   + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP4;
				mb1D[myps].FCDfi0AcsmStart    = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4*2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP4*2;
				mb1D[myps].FCDfi1AcsmStart    = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4*2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP4*3;
			)
			_IF_LPDDR5(
				mb1D[myps].FCDfi0AcsmStartPSY = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5;
				mb1D[myps].FCDfi1AcsmStartPSY = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5   + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP5;
				mb1D[myps].FCDfi0AcsmStart    = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5*2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP5*2;
				mb1D[myps].FCDfi1AcsmStart    = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5*2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP5*3;
			)
		} else {
			_IF_LPDDR4(
				mb1D[myps].FCDfi0AcsmStart = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4;
				mb1D[myps].FCDfi1AcsmStart = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP4;
			)
			_IF_LPDDR5(
				mb1D[myps].FCDfi0AcsmStart = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5;
				mb1D[myps].FCDfi1AcsmStart = 2 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5 + DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP5;
			)
		}

		_IF_LPDDR5(
			mb1D[myps].DRAMFreq = pUserInputBasic->Frequency[myps] * (pUserInputBasic->DfiFreqRatio[myps] * 2) * 2;
		)
		_IF_LPDDR4(
			mb1D[myps].DRAMFreq = pUserInputBasic->Frequency[myps] * 2;
		)
		mb1D[myps].PllBypassEn = pUserInputBasic->PllBypass[myps];
		mb1D[myps].DfiFreqRatio = pUserInputBasic->DfiFreqRatio[myps] == 0 ? 1 : (pUserInputBasic->DfiFreqRatio[myps] == 1 ? 2 : 4);
		//dwc_ddrphy_phyinit_softSetMb(phyctx, myps, "PhyOdtImpedance", 0);
		//dwc_ddrphy_phyinit_softSetMb(phyctx, myps, "PhyDrvImpedance", 0);
		//dwc_ddrphy_phyinit_softSetMb(phyctx, myps, "BPZNResVal", 0);

		//dwc_ddrphy_phyinit_softSetMb(phyctx, myps,"EnabledDQsChA",nad0 * 8);
		//dwc_ddrphy_phyinit_softSetMb(phyctx, myps,"CsPresentChA",(2 == pUserInputBasic->NumRank_dfi0) ? 0x3 : pUserInputBasic->NumRank_dfi0);
		//dwc_ddrphy_phyinit_softSetMb(phyctx, myps,"EnabledDQsChB",nad1 * 8);
		//dwc_ddrphy_phyinit_softSetMb(phyctx, myps,"CsPresentChB",(2 == pUserInputBasic->NumRank_dfi1) ? 0x3 : pUserInputBasic->NumRank_dfi1);
		if ((mb1D[myps].EnabledDQsChA == 0 && NumCh == 1) || (mb1D[myps].EnabledDQsChA == 0 && mb1D[myps].EnabledDQsChB == 0 && NumCh == 2)) {
			dwc_ddrphy_phyinit_assert(0, "[%s] NumActiveDbyteDfi0, NumActiveDbyteDfi0, NumByte out of range.\n", __func__);
		}
		mb1D[myps].UpperLowerByte = pUserInputAdvanced->DramByteSwap; 	
	} // myps
	pRuntimeConfig->Train2D = Train2D;

	dwc_ddrphy_phyinit_cmnt("[%s] End of %s()\n", __func__, __func__);
}

/** @} */
