/** \file
 * \brief conditionally sets messageBlock variables
 * \addtogroup SrcFunc
 * @{
 */
#include <string.h>
#include "dwc_ddrphy_phyinit.h"

/** @brief Set messageBlock variable only if not set by user
 *
 * this function works same as dwc_ddrphy_phyinit_setMb(). It is used by
 * dwc_ddrphy_phyinit_calcMb() to set calculated messageBlock variables only
 * when the user has not directly programmed them. If
 * dwc_ddrphy_phyinit_setDefault() and
 * dwc_ddrphy_phyinit_userCustom_overrideUserInput() are used to program a
 * particular variable, this function will skip setting the value.
 *
 * @param[in]   phyctx  PhyInit context
 * @param[in]   ps	  integer between 0-3. Specifies the PState for which the messageBlock field should be set.
 * @param[in]   field   A string representing the messageBlock field to be programed.
 * @param[in]   value   filed value
 * @param[in]   Train2D determined if the field should be set on 2D or 1D messageBlock.
 *
 * @return 0 on success or if field was set in dwc_ddrphy_phyinit_setDefault() or
 * dwc_ddrphy_phyinit_userCustom_overrideUserInput(). On error  returns the following values based on
 * error:
 * - -1 : message block field specified by the input \c field string is not
 * found in the message block data structure.
 * - -2 : when DramType does not support 2D training but a 2D training field is
 * programmed.
 * - -3 : Train2D inputs is neither 1 or 0.
 */
int dwc_ddrphy_phyinit_softSetMb(phyinit_config_t *phyctx, int ps, char *field, int value)
{
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	int Train2D = pRuntimeConfig->Train2D;

	PMU_SMB_LPDDR4_1D_t *mb_LPDDR4_1D = phyctx->mb_LPDDR4_1D;
	PMU_SMB_LPDDR4_1D_t *shdw_LPDDR4_1D = phyctx->shdw_LPDDR4_1D;

	if (Train2D == 0) {
		if (strcmp(field, "Reserved00") == 0) {
			if (shdw_LPDDR4_1D[ps].Reserved00 == 0) {
				mb_LPDDR4_1D[ps].Reserved00 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Reserved00);
			}
		} else if (strcmp(field, "MsgMisc") == 0) {
			if (shdw_LPDDR4_1D[ps].MsgMisc == 0) {
				mb_LPDDR4_1D[ps].MsgMisc = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MsgMisc);
			}
		} else if (strcmp(field, "Pstate") == 0) {
			if (shdw_LPDDR4_1D[ps].Pstate == 0) {
				mb_LPDDR4_1D[ps].Pstate = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Pstate);
			}
		} else if (strcmp(field, "PllBypassEn") == 0) {
			if (shdw_LPDDR4_1D[ps].PllBypassEn == 0) {
				mb_LPDDR4_1D[ps].PllBypassEn = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].PllBypassEn);
			}
		} else if (strcmp(field, "DRAMFreq") == 0) {
			if (shdw_LPDDR4_1D[ps].DRAMFreq == 0) {
				mb_LPDDR4_1D[ps].DRAMFreq = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].DRAMFreq);
			}
		} else if (strcmp(field, "DfiFreqRatio") == 0) {
			if (shdw_LPDDR4_1D[ps].DfiFreqRatio == 0) {
				mb_LPDDR4_1D[ps].DfiFreqRatio = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].DfiFreqRatio);
			}
		} else if (strcmp(field, "BitTimeControl") == 0) {
			if (shdw_LPDDR4_1D[ps].BitTimeControl == 0) {
				mb_LPDDR4_1D[ps].BitTimeControl = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].BitTimeControl);
			}
		} else if (strcmp(field, "Train2DMisc") == 0) {
			if (shdw_LPDDR4_1D[ps].Train2DMisc == 0) {
				mb_LPDDR4_1D[ps].Train2DMisc = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Train2DMisc);
			}
		} else if (strcmp(field, "reserved") == 0) {
			if (shdw_LPDDR4_1D[ps].reserved == 0) {
				mb_LPDDR4_1D[ps].reserved = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].reserved);
			}
		} else if (strcmp(field, "Misc") == 0) {
			if (shdw_LPDDR4_1D[ps].Misc == 0) {
				mb_LPDDR4_1D[ps].Misc = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Misc);
			}
		} else if (strcmp(field, "SIFriendlyDlyOffset") == 0) {
			if (shdw_LPDDR4_1D[ps].SIFriendlyDlyOffset == 0) {
				mb_LPDDR4_1D[ps].SIFriendlyDlyOffset = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].SIFriendlyDlyOffset);
			}
		} else if (strcmp(field, "SequenceCtrl") == 0) {
			if (shdw_LPDDR4_1D[ps].SequenceCtrl == 0) {
				mb_LPDDR4_1D[ps].SequenceCtrl = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].SequenceCtrl);
			}
		} else if (strcmp(field, "HdtCtrl") == 0) {
			if (shdw_LPDDR4_1D[ps].HdtCtrl == 0) {
				mb_LPDDR4_1D[ps].HdtCtrl = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].HdtCtrl);
			}
		} else if (strcmp(field, "Reserved13") == 0) {
			if (shdw_LPDDR4_1D[ps].Reserved13 == 0) {
				mb_LPDDR4_1D[ps].Reserved13 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Reserved13);
			}
		} else if (strcmp(field, "DFIMRLMargin") == 0) {
			if (shdw_LPDDR4_1D[ps].DFIMRLMargin == 0) {
				mb_LPDDR4_1D[ps].DFIMRLMargin = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].DFIMRLMargin);
			}
		} else if (strcmp(field, "TX2D_Delay_Weight") == 0) {
			if (shdw_LPDDR4_1D[ps].TX2D_Delay_Weight == 0) {
				mb_LPDDR4_1D[ps].TX2D_Delay_Weight = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].TX2D_Delay_Weight);
			}
		} else if (strcmp(field, "TX2D_Voltage_Weight") == 0) {
			if (shdw_LPDDR4_1D[ps].TX2D_Voltage_Weight == 0) {
				mb_LPDDR4_1D[ps].TX2D_Voltage_Weight = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].TX2D_Voltage_Weight);
			}
		} else if (strcmp(field, "Quickboot") == 0) {
			if (shdw_LPDDR4_1D[ps].Quickboot == 0) {
				mb_LPDDR4_1D[ps].Quickboot = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Quickboot);
			}
		} else if (strcmp(field, "Reserved1A") == 0) {
			if (shdw_LPDDR4_1D[ps].Reserved1A == 0) {
				mb_LPDDR4_1D[ps].Reserved1A = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Reserved1A);
			}
		} else if (strcmp(field, "CATrainOpt") == 0) {
			if (shdw_LPDDR4_1D[ps].CATrainOpt == 0) {
				mb_LPDDR4_1D[ps].CATrainOpt = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].CATrainOpt);
			}
		} else if (strcmp(field, "X8Mode") == 0) {
			if (shdw_LPDDR4_1D[ps].X8Mode == 0) {
				mb_LPDDR4_1D[ps].X8Mode = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].X8Mode);
			}
		} else if (strcmp(field, "RX2D_TrainOpt") == 0) {
			if (shdw_LPDDR4_1D[ps].RX2D_TrainOpt == 0) {
				mb_LPDDR4_1D[ps].RX2D_TrainOpt = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RX2D_TrainOpt);
			}
		} else if (strcmp(field, "TX2D_TrainOpt") == 0) {
			if (shdw_LPDDR4_1D[ps].TX2D_TrainOpt == 0) {
				mb_LPDDR4_1D[ps].TX2D_TrainOpt = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].TX2D_TrainOpt);
			}
		} else if (strcmp(field, "Reserved1F") == 0) {
			if (shdw_LPDDR4_1D[ps].Reserved1F == 0) {
				mb_LPDDR4_1D[ps].Reserved1F = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Reserved1F);
			}
		} else if (strcmp(field, "RX2D_Delay_Weight") == 0) {
			if (shdw_LPDDR4_1D[ps].RX2D_Delay_Weight == 0) {
				mb_LPDDR4_1D[ps].RX2D_Delay_Weight = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RX2D_Delay_Weight);
			}
		} else if (strcmp(field, "RX2D_Voltage_Weight") == 0) {
			if (shdw_LPDDR4_1D[ps].RX2D_Voltage_Weight == 0) {
				mb_LPDDR4_1D[ps].RX2D_Voltage_Weight = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RX2D_Voltage_Weight);
			}
		} else if (strcmp(field, "Reserved22") == 0) {
			if (shdw_LPDDR4_1D[ps].Reserved22 == 0) {
				mb_LPDDR4_1D[ps].Reserved22 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Reserved22);
			}
		} else if (strcmp(field, "EnabledDQsChA") == 0) {
			if (shdw_LPDDR4_1D[ps].EnabledDQsChA == 0) {
				mb_LPDDR4_1D[ps].EnabledDQsChA = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].EnabledDQsChA);
			}
		} else if (strcmp(field, "CsPresentChA") == 0) {
			if (shdw_LPDDR4_1D[ps].CsPresentChA == 0) {
				mb_LPDDR4_1D[ps].CsPresentChA = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].CsPresentChA);
			}
		} else if (strcmp(field, "MR1_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR1_A0 == 0) {
				mb_LPDDR4_1D[ps].MR1_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR1_A0);
			}
		} else if (strcmp(field, "MR2_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR2_A0 == 0) {
				mb_LPDDR4_1D[ps].MR2_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR2_A0);
			}
		} else if (strcmp(field, "MR3_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR3_A0 == 0) {
				mb_LPDDR4_1D[ps].MR3_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR3_A0);
			}
		} else if (strcmp(field, "MR4_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR4_A0 == 0) {
				mb_LPDDR4_1D[ps].MR4_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR4_A0);
			}
		} else if (strcmp(field, "MR11_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR11_A0 == 0) {
				mb_LPDDR4_1D[ps].MR11_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR11_A0);
			}
		} else if (strcmp(field, "MR12_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR12_A0 == 0) {
				mb_LPDDR4_1D[ps].MR12_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR12_A0);
			}
		} else if (strcmp(field, "MR13_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR13_A0 == 0) {
				mb_LPDDR4_1D[ps].MR13_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR13_A0);
			}
		} else if (strcmp(field, "MR14_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR14_A0 == 0) {
				mb_LPDDR4_1D[ps].MR14_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR14_A0);
			}
		} else if (strcmp(field, "MR16_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR16_A0 == 0) {
				mb_LPDDR4_1D[ps].MR16_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR16_A0);
			}
		} else if (strcmp(field, "MR17_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR17_A0 == 0) {
				mb_LPDDR4_1D[ps].MR17_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR17_A0);
			}
		} else if (strcmp(field, "MR22_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR22_A0 == 0) {
				mb_LPDDR4_1D[ps].MR22_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR22_A0);
			}
		} else if (strcmp(field, "MR24_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR24_A0 == 0) {
				mb_LPDDR4_1D[ps].MR24_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR24_A0);
			}
		} else if (strcmp(field, "MR1_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR1_A1 == 0) {
				mb_LPDDR4_1D[ps].MR1_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR1_A1);
			}
		} else if (strcmp(field, "MR2_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR2_A1 == 0) {
				mb_LPDDR4_1D[ps].MR2_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR2_A1);
			}
		} else if (strcmp(field, "MR3_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR3_A1 == 0) {
				mb_LPDDR4_1D[ps].MR3_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR3_A1);
			}
		} else if (strcmp(field, "MR4_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR4_A1 == 0) {
				mb_LPDDR4_1D[ps].MR4_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR4_A1);
			}
		} else if (strcmp(field, "MR11_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR11_A1 == 0) {
				mb_LPDDR4_1D[ps].MR11_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR11_A1);
			}
		} else if (strcmp(field, "MR12_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR12_A1 == 0) {
				mb_LPDDR4_1D[ps].MR12_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR12_A1);
			}
		} else if (strcmp(field, "MR13_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR13_A1 == 0) {
				mb_LPDDR4_1D[ps].MR13_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR13_A1);
			}
		} else if (strcmp(field, "MR14_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR14_A1 == 0) {
				mb_LPDDR4_1D[ps].MR14_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR14_A1);
			}
		} else if (strcmp(field, "MR16_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR16_A1 == 0) {
				mb_LPDDR4_1D[ps].MR16_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR16_A1);
			}
		} else if (strcmp(field, "MR17_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR17_A1 == 0) {
				mb_LPDDR4_1D[ps].MR17_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR17_A1);
			}
		} else if (strcmp(field, "MR22_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR22_A1 == 0) {
				mb_LPDDR4_1D[ps].MR22_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR22_A1);
			}
		} else if (strcmp(field, "MR24_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR24_A1 == 0) {
				mb_LPDDR4_1D[ps].MR24_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR24_A1);
			}
		} else if (strcmp(field, "CATerminatingRankChA") == 0) {
			if (shdw_LPDDR4_1D[ps].CATerminatingRankChA == 0) {
				mb_LPDDR4_1D[ps].CATerminatingRankChA = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].CATerminatingRankChA);
			}
		} else if (strcmp(field, "EnabledDQsChB") == 0) {
			if (shdw_LPDDR4_1D[ps].EnabledDQsChB == 0) {
				mb_LPDDR4_1D[ps].EnabledDQsChB = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].EnabledDQsChB);
			}
		} else if (strcmp(field, "CsPresentChB") == 0) {
			if (shdw_LPDDR4_1D[ps].CsPresentChB == 0) {
				mb_LPDDR4_1D[ps].CsPresentChB = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].CsPresentChB);
			}
		} else if (strcmp(field, "MR1_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR1_B0 == 0) {
				mb_LPDDR4_1D[ps].MR1_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR1_B0);
			}
		} else if (strcmp(field, "MR2_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR2_B0 == 0) {
				mb_LPDDR4_1D[ps].MR2_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR2_B0);
			}
		} else if (strcmp(field, "MR3_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR3_B0 == 0) {
				mb_LPDDR4_1D[ps].MR3_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR3_B0);
			}
		} else if (strcmp(field, "MR4_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR4_B0 == 0) {
				mb_LPDDR4_1D[ps].MR4_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR4_B0);
			}
		} else if (strcmp(field, "MR11_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR11_B0 == 0) {
				mb_LPDDR4_1D[ps].MR11_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR11_B0);
			}
		} else if (strcmp(field, "MR12_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR12_B0 == 0) {
				mb_LPDDR4_1D[ps].MR12_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR12_B0);
			}
		} else if (strcmp(field, "MR13_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR13_B0 == 0) {
				mb_LPDDR4_1D[ps].MR13_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR13_B0);
			}
		} else if (strcmp(field, "MR14_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR14_B0 == 0) {
				mb_LPDDR4_1D[ps].MR14_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR14_B0);
			}
		} else if (strcmp(field, "MR16_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR16_B0 == 0) {
				mb_LPDDR4_1D[ps].MR16_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR16_B0);
			}
		} else if (strcmp(field, "MR17_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR17_B0 == 0) {
				mb_LPDDR4_1D[ps].MR17_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR17_B0);
			}
		} else if (strcmp(field, "MR22_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR22_B0 == 0) {
				mb_LPDDR4_1D[ps].MR22_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR22_B0);
			}
		} else if (strcmp(field, "MR24_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR24_B0 == 0) {
				mb_LPDDR4_1D[ps].MR24_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR24_B0);
			}
		} else if (strcmp(field, "MR1_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR1_B1 == 0) {
				mb_LPDDR4_1D[ps].MR1_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR1_B1);
			}
		} else if (strcmp(field, "MR2_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR2_B1 == 0) {
				mb_LPDDR4_1D[ps].MR2_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR2_B1);
			}
		} else if (strcmp(field, "MR3_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR3_B1 == 0) {
				mb_LPDDR4_1D[ps].MR3_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR3_B1);
			}
		} else if (strcmp(field, "MR4_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR4_B1 == 0) {
				mb_LPDDR4_1D[ps].MR4_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR4_B1);
			}
		} else if (strcmp(field, "MR11_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR11_B1 == 0) {
				mb_LPDDR4_1D[ps].MR11_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR11_B1);
			}
		} else if (strcmp(field, "MR12_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR12_B1 == 0) {
				mb_LPDDR4_1D[ps].MR12_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR12_B1);
			}
		} else if (strcmp(field, "MR13_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR13_B1 == 0) {
				mb_LPDDR4_1D[ps].MR13_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR13_B1);
			}
		} else if (strcmp(field, "MR14_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR14_B1 == 0) {
				mb_LPDDR4_1D[ps].MR14_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR14_B1);
			}
		} else if (strcmp(field, "MR16_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR16_B1 == 0) {
				mb_LPDDR4_1D[ps].MR16_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR16_B1);
			}
		} else if (strcmp(field, "MR17_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR17_B1 == 0) {
				mb_LPDDR4_1D[ps].MR17_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR17_B1);
			}
		} else if (strcmp(field, "MR22_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR22_B1 == 0) {
				mb_LPDDR4_1D[ps].MR22_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR22_B1);
			}
		} else if (strcmp(field, "MR24_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR24_B1 == 0) {
				mb_LPDDR4_1D[ps].MR24_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR24_B1);
			}
		} else if (strcmp(field, "CATerminatingRankChB") == 0) {
			if (shdw_LPDDR4_1D[ps].CATerminatingRankChB == 0) {
				mb_LPDDR4_1D[ps].CATerminatingRankChB = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].CATerminatingRankChB);
			}
		} else if (strcmp(field, "MR21_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR21_A0 == 0) {
				mb_LPDDR4_1D[ps].MR21_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR21_A0);
			}
		} else if (strcmp(field, "MR51_A0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR51_A0 == 0) {
				mb_LPDDR4_1D[ps].MR51_A0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR51_A0);
			}
		} else if (strcmp(field, "MR21_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR21_A1 == 0) {
				mb_LPDDR4_1D[ps].MR21_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR21_A1);
			}
		} else if (strcmp(field, "MR51_A1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR51_A1 == 0) {
				mb_LPDDR4_1D[ps].MR51_A1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR51_A1);
			}
		} else if (strcmp(field, "MR21_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR21_B0 == 0) {
				mb_LPDDR4_1D[ps].MR21_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR21_B0);
			}
		} else if (strcmp(field, "MR51_B0") == 0) {
			if (shdw_LPDDR4_1D[ps].MR51_B0 == 0) {
				mb_LPDDR4_1D[ps].MR51_B0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR51_B0);
			}
		} else if (strcmp(field, "MR21_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR21_B1 == 0) {
				mb_LPDDR4_1D[ps].MR21_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR21_B1);
			}
		} else if (strcmp(field, "MR51_B1") == 0) {
			if (shdw_LPDDR4_1D[ps].MR51_B1 == 0) {
				mb_LPDDR4_1D[ps].MR51_B1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MR51_B1);
			}
		} else if (strcmp(field, "LP4XMode") == 0) {
			if (shdw_LPDDR4_1D[ps].LP4XMode == 0) {
				mb_LPDDR4_1D[ps].LP4XMode = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LP4XMode);
			}
		} else if (strcmp(field, "Disable2D") == 0) {
			if (shdw_LPDDR4_1D[ps].Disable2D == 0) {
				mb_LPDDR4_1D[ps].Disable2D = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].Disable2D);
			}
		} else if (strcmp(field, "VrefSamples") == 0) {
			if (shdw_LPDDR4_1D[ps].VrefSamples == 0) {
				mb_LPDDR4_1D[ps].VrefSamples = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].VrefSamples);
			}
		} else if (strcmp(field, "ALT_RL") == 0) {
			if (shdw_LPDDR4_1D[ps].ALT_RL == 0) {
				mb_LPDDR4_1D[ps].ALT_RL = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].ALT_RL);
			}
		} else if (strcmp(field, "MAIN_RL") == 0) {
			if (shdw_LPDDR4_1D[ps].MAIN_RL == 0) {
				mb_LPDDR4_1D[ps].MAIN_RL = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MAIN_RL);
			}
		} else if (strcmp(field, "RdWrPatternA") == 0) {
			if (shdw_LPDDR4_1D[ps].RdWrPatternA == 0) {
				mb_LPDDR4_1D[ps].RdWrPatternA = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RdWrPatternA);
			}
		} else if (strcmp(field, "RdWrPatternB") == 0) {
			if (shdw_LPDDR4_1D[ps].RdWrPatternB == 0) {
				mb_LPDDR4_1D[ps].RdWrPatternB = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RdWrPatternB);
			}
		} else if (strcmp(field, "RdWrInvert") == 0) {
			if (shdw_LPDDR4_1D[ps].RdWrInvert == 0) {
				mb_LPDDR4_1D[ps].RdWrInvert = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RdWrInvert);
			}
		} else if (strcmp(field, "LdffMode") == 0) {
			if (shdw_LPDDR4_1D[ps].LdffMode == 0) {
				mb_LPDDR4_1D[ps].LdffMode = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LdffMode);
			}
		} else if (strcmp(field, "FCDfi0AcsmStart") == 0) {
			if (shdw_LPDDR4_1D[ps].FCDfi0AcsmStart == 0) {
				mb_LPDDR4_1D[ps].FCDfi0AcsmStart = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].FCDfi0AcsmStart);
			}
		} else if (strcmp(field, "FCDfi1AcsmStart") == 0) {
			if (shdw_LPDDR4_1D[ps].FCDfi1AcsmStart == 0) {
				mb_LPDDR4_1D[ps].FCDfi1AcsmStart = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].FCDfi1AcsmStart);
			}
		} else if (strcmp(field, "FCDfi0AcsmStartPSY") == 0) {
			if (shdw_LPDDR4_1D[ps].FCDfi0AcsmStartPSY == 0) {
				mb_LPDDR4_1D[ps].FCDfi0AcsmStartPSY = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].FCDfi0AcsmStartPSY);
			}
		} else if (strcmp(field, "FCDfi1AcsmStartPSY") == 0) {
			if (shdw_LPDDR4_1D[ps].FCDfi1AcsmStartPSY == 0) {
				mb_LPDDR4_1D[ps].FCDfi1AcsmStartPSY = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].FCDfi1AcsmStartPSY);
			}
		} else if (strcmp(field, "FCDMAStartMR") == 0) {
			if (shdw_LPDDR4_1D[ps].FCDMAStartMR == 0) {
				mb_LPDDR4_1D[ps].FCDMAStartMR = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].FCDMAStartMR);
			}
		} else if (strcmp(field, "FCDMAStartCsr") == 0) {
			if (shdw_LPDDR4_1D[ps].FCDMAStartCsr == 0) {
				mb_LPDDR4_1D[ps].FCDMAStartCsr = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].FCDMAStartCsr);
			}
		} else if (strcmp(field, "EnCustomSettings") == 0) {
			if (shdw_LPDDR4_1D[ps].EnCustomSettings == 0) {
				mb_LPDDR4_1D[ps].EnCustomSettings = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].EnCustomSettings);
			}
		} else if (strcmp(field, "LS_TxSlewSE0") == 0) {
			if (shdw_LPDDR4_1D[ps].LS_TxSlewSE0 == 0) {
				mb_LPDDR4_1D[ps].LS_TxSlewSE0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LS_TxSlewSE0);
			}
		} else if (strcmp(field, "LS_TxSlewSE1") == 0) {
			if (shdw_LPDDR4_1D[ps].LS_TxSlewSE1 == 0) {
				mb_LPDDR4_1D[ps].LS_TxSlewSE1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LS_TxSlewSE1);
			}
		} else if (strcmp(field, "LS_TxSlewDIFF0") == 0) {
			if (shdw_LPDDR4_1D[ps].LS_TxSlewDIFF0 == 0) {
				mb_LPDDR4_1D[ps].LS_TxSlewDIFF0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LS_TxSlewDIFF0);
			}
		} else if (strcmp(field, "LS_TxImpedanceDIFF0T") == 0) {
			if (shdw_LPDDR4_1D[ps].LS_TxImpedanceDIFF0T == 0) {
				mb_LPDDR4_1D[ps].LS_TxImpedanceDIFF0T = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LS_TxImpedanceDIFF0T);
			}
		} else if (strcmp(field, "LS_TxImpedanceDIFF0C") == 0) {
			if (shdw_LPDDR4_1D[ps].LS_TxImpedanceDIFF0C == 0) {
				mb_LPDDR4_1D[ps].LS_TxImpedanceDIFF0C = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LS_TxImpedanceDIFF0C);
			}
		} else if (strcmp(field, "LS_TxImpedanceSE0") == 0) {
			if (shdw_LPDDR4_1D[ps].LS_TxImpedanceSE0 == 0) {
				mb_LPDDR4_1D[ps].LS_TxImpedanceSE0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LS_TxImpedanceSE0);
			}
		} else if (strcmp(field, "LS_TxImpedanceSE1") == 0) {
			if (shdw_LPDDR4_1D[ps].LS_TxImpedanceSE1 == 0) {
				mb_LPDDR4_1D[ps].LS_TxImpedanceSE1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].LS_TxImpedanceSE1);
			}
		} else if (strcmp(field, "VrefInc") == 0) {
			if (shdw_LPDDR4_1D[ps].VrefInc == 0) {
				mb_LPDDR4_1D[ps].VrefInc = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].VrefInc);
			}
		} else if (strcmp(field, "WrLvlTrainOpt") == 0) {
			if (shdw_LPDDR4_1D[ps].WrLvlTrainOpt == 0) {
				mb_LPDDR4_1D[ps].WrLvlTrainOpt = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].WrLvlTrainOpt);
			}
		} else if (strcmp(field, "RxVrefStartPatDfe0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStartPatDfe0 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStartPatDfe0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStartPatDfe0);
			}
		} else if (strcmp(field, "RxVrefStartPatDfe1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStartPatDfe1 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStartPatDfe1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStartPatDfe1);
			}
		} else if (strcmp(field, "RxVrefStartPrbsDfe0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStartPrbsDfe0 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStartPrbsDfe0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStartPrbsDfe0);
			}
		} else if (strcmp(field, "RxVrefStartPrbsDfe1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStartPrbsDfe1 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStartPrbsDfe1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStartPrbsDfe1);
			}
		} else if (strcmp(field, "TxVrefStart") == 0) {
			if (shdw_LPDDR4_1D[ps].TxVrefStart == 0) {
				mb_LPDDR4_1D[ps].TxVrefStart = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].TxVrefStart);
			}
		} else if (strcmp(field, "RxVrefEndPatDfe0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefEndPatDfe0 == 0) {
				mb_LPDDR4_1D[ps].RxVrefEndPatDfe0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefEndPatDfe0);
			}
		} else if (strcmp(field, "RxVrefEndPatDfe1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefEndPatDfe1 == 0) {
				mb_LPDDR4_1D[ps].RxVrefEndPatDfe1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefEndPatDfe1);
			}
		} else if (strcmp(field, "RxVrefEndPrbsDfe0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefEndPrbsDfe0 == 0) {
				mb_LPDDR4_1D[ps].RxVrefEndPrbsDfe0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefEndPrbsDfe0);
			}
		} else if (strcmp(field, "RxVrefEndPrbsDfe1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefEndPrbsDfe1 == 0) {
				mb_LPDDR4_1D[ps].RxVrefEndPrbsDfe1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefEndPrbsDfe1);
			}
		} else if (strcmp(field, "TxVrefEnd") == 0) {
			if (shdw_LPDDR4_1D[ps].TxVrefEnd == 0) {
				mb_LPDDR4_1D[ps].TxVrefEnd = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].TxVrefEnd);
			}
		} else if (strcmp(field, "RxVrefStepPatDfe0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStepPatDfe0 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStepPatDfe0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStepPatDfe0);
			}
		} else if (strcmp(field, "RxVrefStepPatDfe1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStepPatDfe1 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStepPatDfe1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStepPatDfe1);
			}
		} else if (strcmp(field, "RxVrefStepPrbsDfe0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStepPrbsDfe0 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStepPrbsDfe0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStepPrbsDfe0);
			}
		} else if (strcmp(field, "RxVrefStepPrbsDfe1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxVrefStepPrbsDfe1 == 0) {
				mb_LPDDR4_1D[ps].RxVrefStepPrbsDfe1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxVrefStepPrbsDfe1);
			}
		} else if (strcmp(field, "TxVrefStep") == 0) {
			if (shdw_LPDDR4_1D[ps].TxVrefStep == 0) {
				mb_LPDDR4_1D[ps].TxVrefStep = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].TxVrefStep);
			}
		} else if (strcmp(field, "UpperLowerByte") == 0) {
			if (shdw_LPDDR4_1D[ps].UpperLowerByte == 0) {
				mb_LPDDR4_1D[ps].UpperLowerByte = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].UpperLowerByte);
			}
		} else if (strcmp(field, "MRLCalcAdj") == 0) {
			if (shdw_LPDDR4_1D[ps].MRLCalcAdj == 0) {
				mb_LPDDR4_1D[ps].MRLCalcAdj = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].MRLCalcAdj);
			}
		} else if (strcmp(field, "PPT2OffsetMargin") == 0) {
			if (shdw_LPDDR4_1D[ps].PPT2OffsetMargin == 0) {
				mb_LPDDR4_1D[ps].PPT2OffsetMargin = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].PPT2OffsetMargin);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte0 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte0);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte1 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte1);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte2") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte2 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte2 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte2);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte3") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte3 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte3 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte3);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte0") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte0 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte0 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte0);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte1") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte1 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte1 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte1);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte2") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte2 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte2 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte2);
			}
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte3") == 0) {
			if (shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte3 == 0) {
				mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte3 = value;
				dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, 1, ps, field, value);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [%s] mb_LPDDR4_%dD[%d].%s override to 0x%x\n", __func__, 1, ps, field, mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte3);
			}
		} else {
			dwc_ddrphy_phyinit_assert(0, " [%s] unknown message block field name '%s', Train2D=%d\n", __func__, field, Train2D);
			return -1;
		}
	} else if (Train2D == 1) {
		/*
		 */
	} else {
		dwc_ddrphy_phyinit_assert(0, " [%s] invalid value for Train2D=%d\n", __func__, Train2D);
		return -3;
	}

	return 0;
}

/** @} */
