/** \file
 * \brief sets messageBlock variables
 * \addtogroup SrcFunc
 *  @{
 */
#include <string.h>
#include "dwc_ddrphy_phyinit.h"

/** @brief API to program the Message Block
 *
 *  This function can be used to program training firmware 1D/2D message block fields
 *  for a given PState.  as an example, to program MsgMsic to 0x4 for Pstate 3,
 *  for 1D Training :
 *  @code{.c}
 *  dwc_ddrphy_phyinit_setMB(3, "MsgMisc", 0x4, 0);
 *  @endcode
 *
 * refer to the messageBlock data structure for definition of fields
 * applicable to each protocol.
 *
 * @param[in]   phyctx  PhyInit context
 * @param[in]   ps	  integer between 0-3. Specifies the PState for which the
 * messageBlock field should be set.
 * @param[in]   field   A string representing the messageBlock field to be
 * programed.
 * @param[in]   value   filed value
 * @param[in]   Train2D determined if the field should be set on 2D or 1D
 * messageBlock.
 * @return 0 on success. On error  returns the following values based on
 * error:
 * - -1 : message block field specified by the input \c field string is not
 * found in the message block data structure.
 * - -2 : when DramType does not support 2D training but a 2D training field is
 * programmed.
 * - -3 : Train2D inputs is neither 1 or 0.
 */
int dwc_ddrphy_phyinit_setMb(phyinit_config_t *phyctx, int ps, char *field, int value)
{
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	int Train2D = pRuntimeConfig->Train2D;

	PMU_SMB_LPDDR4_1D_t *mb_LPDDR4_1D = phyctx->mb_LPDDR4_1D;
	PMU_SMB_LPDDR4_1D_t *shdw_LPDDR4_1D = phyctx->shdw_LPDDR4_1D;

	if (Train2D == 0) {
		if (strcmp(field, "Reserved00") == 0) {
			mb_LPDDR4_1D[ps].Reserved00 = value;
			shdw_LPDDR4_1D[ps].Reserved00 = 1;
		} else if (strcmp(field, "MsgMisc") == 0) {
			mb_LPDDR4_1D[ps].MsgMisc = value;
			shdw_LPDDR4_1D[ps].MsgMisc = 1;
		} else if (strcmp(field, "Pstate") == 0) {
			mb_LPDDR4_1D[ps].Pstate = value;
			shdw_LPDDR4_1D[ps].Pstate = 1;
		} else if (strcmp(field, "PllBypassEn") == 0) {
			mb_LPDDR4_1D[ps].PllBypassEn = value;
			shdw_LPDDR4_1D[ps].PllBypassEn = 1;
		} else if (strcmp(field, "DRAMFreq") == 0) {
			mb_LPDDR4_1D[ps].DRAMFreq = value;
			shdw_LPDDR4_1D[ps].DRAMFreq = 1;
		} else if (strcmp(field, "DfiFreqRatio") == 0) {
			mb_LPDDR4_1D[ps].DfiFreqRatio = value;
			shdw_LPDDR4_1D[ps].DfiFreqRatio = 1;
		} else if (strcmp(field, "BitTimeControl") == 0) {
			mb_LPDDR4_1D[ps].BitTimeControl = value;
			shdw_LPDDR4_1D[ps].BitTimeControl = 1;
		} else if (strcmp(field, "Train2DMisc") == 0) {
			mb_LPDDR4_1D[ps].Train2DMisc = value;
			shdw_LPDDR4_1D[ps].Train2DMisc = 1;
		} else if (strcmp(field, "reserved") == 0) {
			mb_LPDDR4_1D[ps].reserved = value;
			shdw_LPDDR4_1D[ps].reserved = 1;
		} else if (strcmp(field, "Misc") == 0) {
			mb_LPDDR4_1D[ps].Misc = value;
			shdw_LPDDR4_1D[ps].Misc = 1;
		} else if (strcmp(field, "SIFriendlyDlyOffset") == 0) {
			mb_LPDDR4_1D[ps].SIFriendlyDlyOffset = value;
			shdw_LPDDR4_1D[ps].SIFriendlyDlyOffset = 1;
		} else if (strcmp(field, "SequenceCtrl") == 0) {
			mb_LPDDR4_1D[ps].SequenceCtrl = value;
			shdw_LPDDR4_1D[ps].SequenceCtrl = 1;
		} else if (strcmp(field, "HdtCtrl") == 0) {
			mb_LPDDR4_1D[ps].HdtCtrl = value;
			shdw_LPDDR4_1D[ps].HdtCtrl = 1;
		} else if (strcmp(field, "Reserved13") == 0) {
			mb_LPDDR4_1D[ps].Reserved13 = value;
			shdw_LPDDR4_1D[ps].Reserved13 = 1;
		} else if (strcmp(field, "DFIMRLMargin") == 0) {
			mb_LPDDR4_1D[ps].DFIMRLMargin = value;
			shdw_LPDDR4_1D[ps].DFIMRLMargin = 1;
		} else if (strcmp(field, "TX2D_Delay_Weight") == 0) {
			mb_LPDDR4_1D[ps].TX2D_Delay_Weight = value;
			shdw_LPDDR4_1D[ps].TX2D_Delay_Weight = 1;
		} else if (strcmp(field, "TX2D_Voltage_Weight") == 0) {
			mb_LPDDR4_1D[ps].TX2D_Voltage_Weight = value;
			shdw_LPDDR4_1D[ps].TX2D_Voltage_Weight = 1;
		} else if (strcmp(field, "Quickboot") == 0) {
			mb_LPDDR4_1D[ps].Quickboot = value;
			shdw_LPDDR4_1D[ps].Quickboot = 1;
		} else if (strcmp(field, "Reserved1A") == 0) {
			mb_LPDDR4_1D[ps].Reserved1A = value;
			shdw_LPDDR4_1D[ps].Reserved1A = 1;
		} else if (strcmp(field, "CATrainOpt") == 0) {
			mb_LPDDR4_1D[ps].CATrainOpt = value;
			shdw_LPDDR4_1D[ps].CATrainOpt = 1;
		} else if (strcmp(field, "X8Mode") == 0) {
			mb_LPDDR4_1D[ps].X8Mode = value;
			shdw_LPDDR4_1D[ps].X8Mode = 1;
		} else if (strcmp(field, "RX2D_TrainOpt") == 0) {
			mb_LPDDR4_1D[ps].RX2D_TrainOpt = value;
			shdw_LPDDR4_1D[ps].RX2D_TrainOpt = 1;
		} else if (strcmp(field, "TX2D_TrainOpt") == 0) {
			mb_LPDDR4_1D[ps].TX2D_TrainOpt = value;
			shdw_LPDDR4_1D[ps].TX2D_TrainOpt = 1;
		} else if (strcmp(field, "Reserved1F") == 0) {
			mb_LPDDR4_1D[ps].Reserved1F = value;
			shdw_LPDDR4_1D[ps].Reserved1F = 1;
		} else if (strcmp(field, "RX2D_Delay_Weight") == 0) {
			mb_LPDDR4_1D[ps].RX2D_Delay_Weight = value;
			shdw_LPDDR4_1D[ps].RX2D_Delay_Weight = 1;
		} else if (strcmp(field, "RX2D_Voltage_Weight") == 0) {
			mb_LPDDR4_1D[ps].RX2D_Voltage_Weight = value;
			shdw_LPDDR4_1D[ps].RX2D_Voltage_Weight = 1;
		} else if (strcmp(field, "Reserved22") == 0) {
			mb_LPDDR4_1D[ps].Reserved22 = value;
			shdw_LPDDR4_1D[ps].Reserved22 = 1;
		} else if (strcmp(field, "EnabledDQsChA") == 0) {
			mb_LPDDR4_1D[ps].EnabledDQsChA = value;
			shdw_LPDDR4_1D[ps].EnabledDQsChA = 1;
		} else if (strcmp(field, "CsPresentChA") == 0) {
			mb_LPDDR4_1D[ps].CsPresentChA = value;
			shdw_LPDDR4_1D[ps].CsPresentChA = 1;
		} else if (strcmp(field, "MR1_A0") == 0) {
			mb_LPDDR4_1D[ps].MR1_A0 = value;
			shdw_LPDDR4_1D[ps].MR1_A0 = 1;
		} else if (strcmp(field, "MR2_A0") == 0) {
			mb_LPDDR4_1D[ps].MR2_A0 = value;
			shdw_LPDDR4_1D[ps].MR2_A0 = 1;
		} else if (strcmp(field, "MR3_A0") == 0) {
			mb_LPDDR4_1D[ps].MR3_A0 = value;
			shdw_LPDDR4_1D[ps].MR3_A0 = 1;
		} else if (strcmp(field, "MR4_A0") == 0) {
			mb_LPDDR4_1D[ps].MR4_A0 = value;
			shdw_LPDDR4_1D[ps].MR4_A0 = 1;
		} else if (strcmp(field, "MR11_A0") == 0) {
			mb_LPDDR4_1D[ps].MR11_A0 = value;
			shdw_LPDDR4_1D[ps].MR11_A0 = 1;
		} else if (strcmp(field, "MR12_A0") == 0) {
			mb_LPDDR4_1D[ps].MR12_A0 = value;
			shdw_LPDDR4_1D[ps].MR12_A0 = 1;
		} else if (strcmp(field, "MR13_A0") == 0) {
			mb_LPDDR4_1D[ps].MR13_A0 = value;
			shdw_LPDDR4_1D[ps].MR13_A0 = 1;
		} else if (strcmp(field, "MR14_A0") == 0) {
			mb_LPDDR4_1D[ps].MR14_A0 = value;
			shdw_LPDDR4_1D[ps].MR14_A0 = 1;
		} else if (strcmp(field, "MR16_A0") == 0) {
			mb_LPDDR4_1D[ps].MR16_A0 = value;
			shdw_LPDDR4_1D[ps].MR16_A0 = 1;
		} else if (strcmp(field, "MR17_A0") == 0) {
			mb_LPDDR4_1D[ps].MR17_A0 = value;
			shdw_LPDDR4_1D[ps].MR17_A0 = 1;
		} else if (strcmp(field, "MR22_A0") == 0) {
			mb_LPDDR4_1D[ps].MR22_A0 = value;
			shdw_LPDDR4_1D[ps].MR22_A0 = 1;
		} else if (strcmp(field, "MR24_A0") == 0) {
			mb_LPDDR4_1D[ps].MR24_A0 = value;
			shdw_LPDDR4_1D[ps].MR24_A0 = 1;
		} else if (strcmp(field, "MR1_A1") == 0) {
			mb_LPDDR4_1D[ps].MR1_A1 = value;
			shdw_LPDDR4_1D[ps].MR1_A1 = 1;
		} else if (strcmp(field, "MR2_A1") == 0) {
			mb_LPDDR4_1D[ps].MR2_A1 = value;
			shdw_LPDDR4_1D[ps].MR2_A1 = 1;
		} else if (strcmp(field, "MR3_A1") == 0) {
			mb_LPDDR4_1D[ps].MR3_A1 = value;
			shdw_LPDDR4_1D[ps].MR3_A1 = 1;
		} else if (strcmp(field, "MR4_A1") == 0) {
			mb_LPDDR4_1D[ps].MR4_A1 = value;
			shdw_LPDDR4_1D[ps].MR4_A1 = 1;
		} else if (strcmp(field, "MR11_A1") == 0) {
			mb_LPDDR4_1D[ps].MR11_A1 = value;
			shdw_LPDDR4_1D[ps].MR11_A1 = 1;
		} else if (strcmp(field, "MR12_A1") == 0) {
			mb_LPDDR4_1D[ps].MR12_A1 = value;
			shdw_LPDDR4_1D[ps].MR12_A1 = 1;
		} else if (strcmp(field, "MR13_A1") == 0) {
			mb_LPDDR4_1D[ps].MR13_A1 = value;
			shdw_LPDDR4_1D[ps].MR13_A1 = 1;
		} else if (strcmp(field, "MR14_A1") == 0) {
			mb_LPDDR4_1D[ps].MR14_A1 = value;
			shdw_LPDDR4_1D[ps].MR14_A1 = 1;
		} else if (strcmp(field, "MR16_A1") == 0) {
			mb_LPDDR4_1D[ps].MR16_A1 = value;
			shdw_LPDDR4_1D[ps].MR16_A1 = 1;
		} else if (strcmp(field, "MR17_A1") == 0) {
			mb_LPDDR4_1D[ps].MR17_A1 = value;
			shdw_LPDDR4_1D[ps].MR17_A1 = 1;
		} else if (strcmp(field, "MR22_A1") == 0) {
			mb_LPDDR4_1D[ps].MR22_A1 = value;
			shdw_LPDDR4_1D[ps].MR22_A1 = 1;
		} else if (strcmp(field, "MR24_A1") == 0) {
			mb_LPDDR4_1D[ps].MR24_A1 = value;
			shdw_LPDDR4_1D[ps].MR24_A1 = 1;
		} else if (strcmp(field, "CATerminatingRankChA") == 0) {
			mb_LPDDR4_1D[ps].CATerminatingRankChA = value;
			shdw_LPDDR4_1D[ps].CATerminatingRankChA = 1;
		} else if (strcmp(field, "EnabledDQsChB") == 0) {
			mb_LPDDR4_1D[ps].EnabledDQsChB = value;
			shdw_LPDDR4_1D[ps].EnabledDQsChB = 1;
		} else if (strcmp(field, "CsPresentChB") == 0) {
			mb_LPDDR4_1D[ps].CsPresentChB = value;
			shdw_LPDDR4_1D[ps].CsPresentChB = 1;
		} else if (strcmp(field, "MR1_B0") == 0) {
			mb_LPDDR4_1D[ps].MR1_B0 = value;
			shdw_LPDDR4_1D[ps].MR1_B0 = 1;
		} else if (strcmp(field, "MR2_B0") == 0) {
			mb_LPDDR4_1D[ps].MR2_B0 = value;
			shdw_LPDDR4_1D[ps].MR2_B0 = 1;
		} else if (strcmp(field, "MR3_B0") == 0) {
			mb_LPDDR4_1D[ps].MR3_B0 = value;
			shdw_LPDDR4_1D[ps].MR3_B0 = 1;
		} else if (strcmp(field, "MR4_B0") == 0) {
			mb_LPDDR4_1D[ps].MR4_B0 = value;
			shdw_LPDDR4_1D[ps].MR4_B0 = 1;
		} else if (strcmp(field, "MR11_B0") == 0) {
			mb_LPDDR4_1D[ps].MR11_B0 = value;
			shdw_LPDDR4_1D[ps].MR11_B0 = 1;
		} else if (strcmp(field, "MR12_B0") == 0) {
			mb_LPDDR4_1D[ps].MR12_B0 = value;
			shdw_LPDDR4_1D[ps].MR12_B0 = 1;
		} else if (strcmp(field, "MR13_B0") == 0) {
			mb_LPDDR4_1D[ps].MR13_B0 = value;
			shdw_LPDDR4_1D[ps].MR13_B0 = 1;
		} else if (strcmp(field, "MR14_B0") == 0) {
			mb_LPDDR4_1D[ps].MR14_B0 = value;
			shdw_LPDDR4_1D[ps].MR14_B0 = 1;
		} else if (strcmp(field, "MR16_B0") == 0) {
			mb_LPDDR4_1D[ps].MR16_B0 = value;
			shdw_LPDDR4_1D[ps].MR16_B0 = 1;
		} else if (strcmp(field, "MR17_B0") == 0) {
			mb_LPDDR4_1D[ps].MR17_B0 = value;
			shdw_LPDDR4_1D[ps].MR17_B0 = 1;
		} else if (strcmp(field, "MR22_B0") == 0) {
			mb_LPDDR4_1D[ps].MR22_B0 = value;
			shdw_LPDDR4_1D[ps].MR22_B0 = 1;
		} else if (strcmp(field, "MR24_B0") == 0) {
			mb_LPDDR4_1D[ps].MR24_B0 = value;
			shdw_LPDDR4_1D[ps].MR24_B0 = 1;
		} else if (strcmp(field, "MR1_B1") == 0) {
			mb_LPDDR4_1D[ps].MR1_B1 = value;
			shdw_LPDDR4_1D[ps].MR1_B1 = 1;
		} else if (strcmp(field, "MR2_B1") == 0) {
			mb_LPDDR4_1D[ps].MR2_B1 = value;
			shdw_LPDDR4_1D[ps].MR2_B1 = 1;
		} else if (strcmp(field, "MR3_B1") == 0) {
			mb_LPDDR4_1D[ps].MR3_B1 = value;
			shdw_LPDDR4_1D[ps].MR3_B1 = 1;
		} else if (strcmp(field, "MR4_B1") == 0) {
			mb_LPDDR4_1D[ps].MR4_B1 = value;
			shdw_LPDDR4_1D[ps].MR4_B1 = 1;
		} else if (strcmp(field, "MR11_B1") == 0) {
			mb_LPDDR4_1D[ps].MR11_B1 = value;
			shdw_LPDDR4_1D[ps].MR11_B1 = 1;
		} else if (strcmp(field, "MR12_B1") == 0) {
			mb_LPDDR4_1D[ps].MR12_B1 = value;
			shdw_LPDDR4_1D[ps].MR12_B1 = 1;
		} else if (strcmp(field, "MR13_B1") == 0) {
			mb_LPDDR4_1D[ps].MR13_B1 = value;
			shdw_LPDDR4_1D[ps].MR13_B1 = 1;
		} else if (strcmp(field, "MR14_B1") == 0) {
			mb_LPDDR4_1D[ps].MR14_B1 = value;
			shdw_LPDDR4_1D[ps].MR14_B1 = 1;
		} else if (strcmp(field, "MR16_B1") == 0) {
			mb_LPDDR4_1D[ps].MR16_B1 = value;
			shdw_LPDDR4_1D[ps].MR16_B1 = 1;
		} else if (strcmp(field, "MR17_B1") == 0) {
			mb_LPDDR4_1D[ps].MR17_B1 = value;
			shdw_LPDDR4_1D[ps].MR17_B1 = 1;
		} else if (strcmp(field, "MR22_B1") == 0) {
			mb_LPDDR4_1D[ps].MR22_B1 = value;
			shdw_LPDDR4_1D[ps].MR22_B1 = 1;
		} else if (strcmp(field, "MR24_B1") == 0) {
			mb_LPDDR4_1D[ps].MR24_B1 = value;
			shdw_LPDDR4_1D[ps].MR24_B1 = 1;
		} else if (strcmp(field, "CATerminatingRankChB") == 0) {
			mb_LPDDR4_1D[ps].CATerminatingRankChB = value;
			shdw_LPDDR4_1D[ps].CATerminatingRankChB = 1;
		} else if (strcmp(field, "MR21_A0") == 0) {
			mb_LPDDR4_1D[ps].MR21_A0 = value;
			shdw_LPDDR4_1D[ps].MR21_A0 = 1;
		} else if (strcmp(field, "MR51_A0") == 0) {
			mb_LPDDR4_1D[ps].MR51_A0 = value;
			shdw_LPDDR4_1D[ps].MR51_A0 = 1;
		} else if (strcmp(field, "MR21_A1") == 0) {
			mb_LPDDR4_1D[ps].MR21_A1 = value;
			shdw_LPDDR4_1D[ps].MR21_A1 = 1;
		} else if (strcmp(field, "MR51_A1") == 0) {
			mb_LPDDR4_1D[ps].MR51_A1 = value;
			shdw_LPDDR4_1D[ps].MR51_A1 = 1;
		} else if (strcmp(field, "MR21_B0") == 0) {
			mb_LPDDR4_1D[ps].MR21_B0 = value;
			shdw_LPDDR4_1D[ps].MR21_B0 = 1;
		} else if (strcmp(field, "MR51_B0") == 0) {
			mb_LPDDR4_1D[ps].MR51_B0 = value;
			shdw_LPDDR4_1D[ps].MR51_B0 = 1;
		} else if (strcmp(field, "MR21_B1") == 0) {
			mb_LPDDR4_1D[ps].MR21_B1 = value;
			shdw_LPDDR4_1D[ps].MR21_B1 = 1;
		} else if (strcmp(field, "MR51_B1") == 0) {
			mb_LPDDR4_1D[ps].MR51_B1 = value;
			shdw_LPDDR4_1D[ps].MR51_B1 = 1;
		} else if (strcmp(field, "LP4XMode") == 0) {
			mb_LPDDR4_1D[ps].LP4XMode = value;
			shdw_LPDDR4_1D[ps].LP4XMode = 1;
		} else if (strcmp(field, "Disable2D") == 0) {
			mb_LPDDR4_1D[ps].Disable2D = value;
			shdw_LPDDR4_1D[ps].Disable2D = 1;
		} else if (strcmp(field, "VrefSamples") == 0) {
			mb_LPDDR4_1D[ps].VrefSamples = value;
			shdw_LPDDR4_1D[ps].VrefSamples = 1;
		} else if (strcmp(field, "ALT_RL") == 0) {
			mb_LPDDR4_1D[ps].ALT_RL = value;
			shdw_LPDDR4_1D[ps].ALT_RL = 1;
		} else if (strcmp(field, "MAIN_RL") == 0) {
			mb_LPDDR4_1D[ps].MAIN_RL = value;
			shdw_LPDDR4_1D[ps].MAIN_RL = 1;
		} else if (strcmp(field, "RdWrPatternA") == 0) {
			mb_LPDDR4_1D[ps].RdWrPatternA = value;
			shdw_LPDDR4_1D[ps].RdWrPatternA = 1;
		} else if (strcmp(field, "RdWrPatternB") == 0) {
			mb_LPDDR4_1D[ps].RdWrPatternB = value;
			shdw_LPDDR4_1D[ps].RdWrPatternB = 1;
		} else if (strcmp(field, "RdWrInvert") == 0) {
			mb_LPDDR4_1D[ps].RdWrInvert = value;
			shdw_LPDDR4_1D[ps].RdWrInvert = 1;
		} else if (strcmp(field, "LdffMode") == 0) {
			mb_LPDDR4_1D[ps].LdffMode = value;
			shdw_LPDDR4_1D[ps].LdffMode = 1;
		} else if (strcmp(field, "FCDfi0AcsmStart") == 0) {
			mb_LPDDR4_1D[ps].FCDfi0AcsmStart = value;
			shdw_LPDDR4_1D[ps].FCDfi0AcsmStart = 1;
		} else if (strcmp(field, "FCDfi1AcsmStart") == 0) {
			mb_LPDDR4_1D[ps].FCDfi1AcsmStart = value;
			shdw_LPDDR4_1D[ps].FCDfi1AcsmStart = 1;
		} else if (strcmp(field, "FCDfi0AcsmStartPSY") == 0) {
			mb_LPDDR4_1D[ps].FCDfi0AcsmStartPSY = value;
			shdw_LPDDR4_1D[ps].FCDfi0AcsmStartPSY = 1;
		} else if (strcmp(field, "FCDfi1AcsmStartPSY") == 0) {
			mb_LPDDR4_1D[ps].FCDfi1AcsmStartPSY = value;
			shdw_LPDDR4_1D[ps].FCDfi1AcsmStartPSY = 1;
		} else if (strcmp(field, "FCDMAStartMR") == 0) {
			mb_LPDDR4_1D[ps].FCDMAStartMR = value;
			shdw_LPDDR4_1D[ps].FCDMAStartMR = 1;
		} else if (strcmp(field, "FCDMAStartCsr") == 0) {
			mb_LPDDR4_1D[ps].FCDMAStartCsr = value;
			shdw_LPDDR4_1D[ps].FCDMAStartCsr = 1;
		} else if (strcmp(field, "EnCustomSettings") == 0) {
			mb_LPDDR4_1D[ps].EnCustomSettings = value;
			shdw_LPDDR4_1D[ps].EnCustomSettings = 1;
		} else if (strcmp(field, "LS_TxSlewSE0") == 0) {
			mb_LPDDR4_1D[ps].LS_TxSlewSE0 = value;
			shdw_LPDDR4_1D[ps].LS_TxSlewSE0 = 1;
		} else if (strcmp(field, "LS_TxSlewSE1") == 0) {
			mb_LPDDR4_1D[ps].LS_TxSlewSE1 = value;
			shdw_LPDDR4_1D[ps].LS_TxSlewSE1 = 1;
		} else if (strcmp(field, "LS_TxSlewDIFF0") == 0) {
			mb_LPDDR4_1D[ps].LS_TxSlewDIFF0 = value;
			shdw_LPDDR4_1D[ps].LS_TxSlewDIFF0 = 1;
		} else if (strcmp(field, "LS_TxImpedanceDIFF0T") == 0) {
			mb_LPDDR4_1D[ps].LS_TxImpedanceDIFF0T = value;
			shdw_LPDDR4_1D[ps].LS_TxImpedanceDIFF0T = 1;
		} else if (strcmp(field, "LS_TxImpedanceDIFF0C") == 0) {
			mb_LPDDR4_1D[ps].LS_TxImpedanceDIFF0C = value;
			shdw_LPDDR4_1D[ps].LS_TxImpedanceDIFF0C = 1;
		} else if (strcmp(field, "LS_TxImpedanceSE0") == 0) {
			mb_LPDDR4_1D[ps].LS_TxImpedanceSE0 = value;
			shdw_LPDDR4_1D[ps].LS_TxImpedanceSE0 = 1;
		} else if (strcmp(field, "LS_TxImpedanceSE1") == 0) {
			mb_LPDDR4_1D[ps].LS_TxImpedanceSE1 = value;
			shdw_LPDDR4_1D[ps].LS_TxImpedanceSE1 = 1;
		} else if (strcmp(field, "VrefInc") == 0) {
			mb_LPDDR4_1D[ps].VrefInc = value;
			shdw_LPDDR4_1D[ps].VrefInc = 1;
		} else if (strcmp(field, "WrLvlTrainOpt") == 0) {
			mb_LPDDR4_1D[ps].WrLvlTrainOpt = value;
			shdw_LPDDR4_1D[ps].WrLvlTrainOpt = 1;
		} else if (strcmp(field, "RxVrefStartPatDfe0") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStartPatDfe0 = value;
			shdw_LPDDR4_1D[ps].RxVrefStartPatDfe0 = 1;
		} else if (strcmp(field, "RxVrefStartPatDfe1") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStartPatDfe1 = value;
			shdw_LPDDR4_1D[ps].RxVrefStartPatDfe1 = 1;
		} else if (strcmp(field, "RxVrefStartPrbsDfe0") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStartPrbsDfe0 = value;
			shdw_LPDDR4_1D[ps].RxVrefStartPrbsDfe0 = 1;
		} else if (strcmp(field, "RxVrefStartPrbsDfe1") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStartPrbsDfe1 = value;
			shdw_LPDDR4_1D[ps].RxVrefStartPrbsDfe1 = 1;
		} else if (strcmp(field, "TxVrefStart") == 0) {
			mb_LPDDR4_1D[ps].TxVrefStart = value;
			shdw_LPDDR4_1D[ps].TxVrefStart = 1;
		} else if (strcmp(field, "RxVrefEndPatDfe0") == 0) {
			mb_LPDDR4_1D[ps].RxVrefEndPatDfe0 = value;
			shdw_LPDDR4_1D[ps].RxVrefEndPatDfe0 = 1;
		} else if (strcmp(field, "RxVrefEndPatDfe1") == 0) {
			mb_LPDDR4_1D[ps].RxVrefEndPatDfe1 = value;
			shdw_LPDDR4_1D[ps].RxVrefEndPatDfe1 = 1;
		} else if (strcmp(field, "RxVrefEndPrbsDfe0") == 0) {
			mb_LPDDR4_1D[ps].RxVrefEndPrbsDfe0 = value;
			shdw_LPDDR4_1D[ps].RxVrefEndPrbsDfe0 = 1;
		} else if (strcmp(field, "RxVrefEndPrbsDfe1") == 0) {
			mb_LPDDR4_1D[ps].RxVrefEndPrbsDfe1 = value;
			shdw_LPDDR4_1D[ps].RxVrefEndPrbsDfe1 = 1;
		} else if (strcmp(field, "TxVrefEnd") == 0) {
			mb_LPDDR4_1D[ps].TxVrefEnd = value;
			shdw_LPDDR4_1D[ps].TxVrefEnd = 1;
		} else if (strcmp(field, "RxVrefStepPatDfe0") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStepPatDfe0 = value;
			shdw_LPDDR4_1D[ps].RxVrefStepPatDfe0 = 1;
		} else if (strcmp(field, "RxVrefStepPatDfe1") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStepPatDfe1 = value;
			shdw_LPDDR4_1D[ps].RxVrefStepPatDfe1 = 1;
		} else if (strcmp(field, "RxVrefStepPrbsDfe0") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStepPrbsDfe0 = value;
			shdw_LPDDR4_1D[ps].RxVrefStepPrbsDfe0 = 1;
		} else if (strcmp(field, "RxVrefStepPrbsDfe1") == 0) {
			mb_LPDDR4_1D[ps].RxVrefStepPrbsDfe1 = value;
			shdw_LPDDR4_1D[ps].RxVrefStepPrbsDfe1 = 1;
		} else if (strcmp(field, "TxVrefStep") == 0) {
			mb_LPDDR4_1D[ps].TxVrefStep = value;
			shdw_LPDDR4_1D[ps].TxVrefStep = 1;
		} else if (strcmp(field, "UpperLowerByte") == 0) {
			mb_LPDDR4_1D[ps].UpperLowerByte = value;
			shdw_LPDDR4_1D[ps].UpperLowerByte = 1;
		} else if (strcmp(field, "MRLCalcAdj") == 0) {
			mb_LPDDR4_1D[ps].MRLCalcAdj = value;
			shdw_LPDDR4_1D[ps].MRLCalcAdj = 1;
		} else if (strcmp(field, "PPT2OffsetMargin") == 0) {
			mb_LPDDR4_1D[ps].PPT2OffsetMargin = value;
			shdw_LPDDR4_1D[ps].PPT2OffsetMargin = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte0") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte0 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte0 = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte1") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte1 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte1 = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte2") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte2 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte2 = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank0Byte3") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte3 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank0Byte3 = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte0") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte0 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte0 = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte1") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte1 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte1 = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte2") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte2 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte2 = 1;
		} else if (strcmp(field, "RxDlyScanShiftRank1Byte3") == 0) {
			mb_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte3 = value;
			shdw_LPDDR4_1D[ps].RxDlyScanShiftRank1Byte3 = 1;
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

	dwc_ddrphy_phyinit_cmnt(" [%s] Setting mb_LPDDR4_%dD[%d].%s to 0x%x\n", __func__, Train2D + 1, ps, field, value);
	return 0;
}

/** @} */
