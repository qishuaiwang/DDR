/** \file
 * \brief calculates messageBlock header based on user_input_basic and user_input_advanced.
 */
#include <stdlib.h>
#include "dwc_ddrphy_phyinit.h"

/**
 *  \addtogroup SrcFunc
 *  @{
 */

/** \brief check's users invalid programming.
 *
 * This function does some general checking on user configuration for invalid combinations of
 * settings.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 */
void dwc_ddrphy_phyinit_chkInputs(phyinit_config_t *phyctx)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
#ifdef _BUILD_LPDDR4
	PMU_SMB_LPDDR4X_1D_t *mb1D = phyctx->mb_LPDDR4X_1D;
#endif

	if (2 != pUserInputBasic->NumDbytesPerCh) {
		dwc_ddrphy_phyinit_assert(0, " [%s] NumDbytesPerCh=%d does not match RTL define DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2.\n", __func__,  pUserInputBasic->NumDbytesPerCh);
	}

	uint8_t pstate;

	for (pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE && pUserInputBasic->NumPStates > 2 && pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
		if (pUserInputBasic->DfiFreqRatio[pstate] != 2 && pstate < 7) {
			dwc_ddrphy_phyinit_assert(0, " [%s] DfiFreqRatio[%d]=%d. Pstates < 7 must have DfiFreqRatio=2.\n", __func__, pstate,
									  pUserInputBasic->DfiFreqRatio[pstate]);
		}

		if (pUserInputBasic->DfiFreqRatio[pstate] != 1 && pstate >= 7) {
			dwc_ddrphy_phyinit_assert(0, " [%s] DfiFreqRatio[%d]=%d. 7 <= Pstates < 14 must have DfiFreqRatio=1.\n", __func__, pstate,
									  pUserInputBasic->DfiFreqRatio[pstate]);
		}
	}
	//for (pstate = 7; pstate < 14 && pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE && pUserInputBasic->NumPStates > 2; pstate++) {
	//	if (pUserInputBasic->PllBypass[pstate] != pUserInputBasic->PllBypass[pstate - 7])
	//		dwc_ddrphy_phyinit_assert(0, " [%s] pUserInputBasic->PllBypass[%d] != pUserInputBasic->PllBypass[%d]. "
	//									 "Sister PStates must have the same PllBypass Setting.\n", __func__, pstate,pstate - 7);
	//}
	uint16_t val = pUserInputBasic->CfgPStates;
	uint16_t count = 0;

	for (pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
		count += (val & 0x1) ? 1 : 0;
		val = val >> 1;
	}
	if (count != pUserInputBasic->NumPStates) {
		dwc_ddrphy_phyinit_assert(0, " [%s] count of 1's in CfgPState(=%d) must match NumPStates(=%d) .\n", __func__, count, pUserInputBasic->NumPStates);
	}
    
	for (pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {

		if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) { continue; }

		if (pUserInputAdvanced->RetrainMode[pstate] > 1 && PUB==1) {
			dwc_ddrphy_phyinit_assert(0, " [%s] RetrainMode is not yet available for PUB 1.x\n", __func__);
		}
	}

	uint8_t skip_train = (pRuntimeConfig->initCtrl & 0x02) >> 1;
	uint8_t skip_imem = (pRuntimeConfig->initCtrl & 0x04) >> 2;
	uint8_t skip_dmem = (pRuntimeConfig->initCtrl & 0x08) >> 3;

	if (skip_train && ((!skip_imem) || (!skip_dmem))) {
		dwc_ddrphy_phyinit_assert(1, " [%s]  if skip_train ==1 then its optimal to set skip_imem and skip_dmem\n", __func__);
	}

	if (pUserInputAdvanced->RelockOnlyCntrl != 0 && PUB !=1) { 
		dwc_ddrphy_phyinit_assert(1, " [%s] RelockOnlyCntrl only available for PUB 1.0x\n", __func__);
	}

	if (pUserInputAdvanced->SkipRetrainEnhancement != 0 && PUB !=1) { 
		dwc_ddrphy_phyinit_assert(1, " [%s] SkipRetrainEnhancement only available for PUB 1.0x\n", __func__);
	}

#ifdef _BUILD_LPDDR4
	uint8_t LowSpeedCAbuffer    = 0;
	uint8_t singleEndedModeCK   = 0;
	uint8_t singleEndedModeWDQS = 0;
	uint8_t singleEndedModeRDQS = 0;
#endif
	_IF_LPDDR4(
		if (pUserInputBasic->Lp4xMode == 1) {
			for (pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
				LowSpeedCAbuffer = (mb1D[pstate].MR21_A0 & 0x20) >> 5;
				if (LowSpeedCAbuffer && pUserInputBasic->Frequency[pstate] > 800) {
				dwc_ddrphy_phyinit_assert(0, " [%s] The maximum clock speed for 'Low speed CA buffer' mode is vendor-specific, but is not above 800 MHz, LowSpeedCAbuffer=1 with Frequency=%d at pstate=%d \n", __func__, pUserInputBasic->Frequency[pstate], pstate);
				}
			}
		} else {
			for (pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
				LowSpeedCAbuffer    = (mb1D[pstate].MR21_A0 & 0x20) >> 5;
				singleEndedModeCK   = (mb1D[pstate].MR51_A0 & 0x8)  >> 3;
				singleEndedModeWDQS = (mb1D[pstate].MR51_A0 & 0x4)  >> 2;
				singleEndedModeRDQS = (mb1D[pstate].MR51_A0 & 0x2)  >> 1;
				if (singleEndedModeRDQS || singleEndedModeWDQS || singleEndedModeCK) {
					dwc_ddrphy_phyinit_assert(1, " [%s] inconsistent PHY programming. singleEndedMode is used for Pstate %d, but Lp4xMode!=0x1 \n", __func__, pstate);
				}
				if (LowSpeedCAbuffer) {
					dwc_ddrphy_phyinit_assert(1, " [%s] inconsistent PHY programming. Low Speed CA buffer feature is enabled for Pstate %d, but Lp4xMode!=0x1 \n", __func__, pstate);
				}
			}
		}
	)
}

/** @} */
