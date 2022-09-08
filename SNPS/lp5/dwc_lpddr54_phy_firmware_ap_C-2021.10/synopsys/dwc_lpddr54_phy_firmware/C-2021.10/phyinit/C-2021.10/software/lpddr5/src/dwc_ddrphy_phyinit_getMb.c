/** \file */

#include <string.h>
#include "dwc_ddrphy_phyinit.h"

/**  \addtogroup SrcFunc
 *   @{
 */

/** @brief API to read the messageBlock structure in PhyInit.
 *
 *  This function can be used to read training firmware 1D/2D messageBlock fields
 *  for a given PState in the PhyInit Data structure.  As an example, to read MsgMsic to 0x4 for PState 3,
 *  for 1D Training :
 *  @code{.c}
 *  dwc_ddrphy_phyinit_setMB(3, "MsgMisc", 0x4, 0);
 *  @endcode
 *
 *  \note This functions doesn't read the DMEM address in SRAM. It returns
 *  what is programed in the PhyInit messageBlock structure which is used
 *  to write to the SRAM once dwc_ddrphy_phyinit_F_loadDMEM() is called in
 *  dwc_ddrphy_phyinit_sequence().
 *
 * @param[in]   phyctx  PhyInit context
 * @param[in]   ps      integer between 0-3. Specifies the PState for which the
 * messageBlock field should be set.
 * @param[in]   field   A string representing the messageBlock field to be
 * programed. refer to the messageBlock data structure for definition of fields
 * applicable to each protocol.
 * @param[in]   Train2D determined if the field should be set on 2D or 1D
 * messageBlock.
 * @return field value on success. Returns following values based on
 * error:
 * - -1 : messageBlock field specified by the input \c field string is not
 * found in the messageBlock data structure.
 * - -2 : when DramType does not support 2D training but a 2D training field is
 * programmed.
 * - -3 : Train2D inputs is neither 1 or 0.
 */
int dwc_ddrphy_phyinit_getMb(phyinit_config_t *phyctx, int ps, char *field)
{
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	int Train2D = pRuntimeConfig->Train2D;
	PMU_SMB_LPDDR5_1D_t *mb_LPDDR5_1D = phyctx->mb_LPDDR5_1D;

	if (Train2D == 0) {
		if (strcmp(field, "Reserved00") == 0) {
			return mb_LPDDR5_1D[ps].Reserved00; }
		else if (strcmp(field, "MsgMisc") == 0) {
			return mb_LPDDR5_1D[ps].MsgMisc; }
		else if (strcmp(field, "Pstate") == 0) {
			return mb_LPDDR5_1D[ps].Pstate; }
		else if (strcmp(field, "PllBypassEn") == 0) {
			return mb_LPDDR5_1D[ps].PllBypassEn; }
		else if (strcmp(field, "DRAMFreq") == 0) {
			return mb_LPDDR5_1D[ps].DRAMFreq; }
		else if (strcmp(field, "DfiFreqRatio") == 0) {
			return mb_LPDDR5_1D[ps].DfiFreqRatio; }
		else if (strcmp(field, "BitTimeControl") == 0) {
			return mb_LPDDR5_1D[ps].BitTimeControl; }
		else if (strcmp(field, "Train2DMisc") == 0) {
			return mb_LPDDR5_1D[ps].Train2DMisc; }
		else if (strcmp(field, "Misc") == 0) {
			return mb_LPDDR5_1D[ps].Misc; }
		else if (strcmp(field, "SIFriendlyDlyOffset") == 0) {
			return mb_LPDDR5_1D[ps].SIFriendlyDlyOffset; }
		else if (strcmp(field, "SequenceCtrl") == 0) {
			return mb_LPDDR5_1D[ps].SequenceCtrl; }
		else if (strcmp(field, "HdtCtrl") == 0) {
			return mb_LPDDR5_1D[ps].HdtCtrl; }
		else if (strcmp(field, "Reserved13") == 0) {
			return mb_LPDDR5_1D[ps].Reserved13; }
		else if (strcmp(field, "DFIMRLMargin") == 0) {
			return mb_LPDDR5_1D[ps].DFIMRLMargin; }
		else if (strcmp(field, "TX2D_Delay_Weight") == 0) {
			return mb_LPDDR5_1D[ps].TX2D_Delay_Weight; }
		else if (strcmp(field, "TX2D_Voltage_Weight") == 0) {
			return mb_LPDDR5_1D[ps].TX2D_Voltage_Weight; }
		else if (strcmp(field, "Quickboot") == 0) {
			return mb_LPDDR5_1D[ps].Quickboot; }
		else if (strcmp(field, "Reserved1A") == 0) {
			return mb_LPDDR5_1D[ps].Reserved1A; }
		else if (strcmp(field, "CATrainOpt") == 0) {
			return mb_LPDDR5_1D[ps].CATrainOpt; }
		else if (strcmp(field, "X8Mode") == 0) {
			return mb_LPDDR5_1D[ps].X8Mode; }
		else if (strcmp(field, "RX2D_TrainOpt") == 0) {
			return mb_LPDDR5_1D[ps].RX2D_TrainOpt; }
		else if (strcmp(field, "TX2D_TrainOpt") == 0) {
			return mb_LPDDR5_1D[ps].TX2D_TrainOpt; }
		else if (strcmp(field, "Reserved1F") == 0) {
			return mb_LPDDR5_1D[ps].Reserved1F; }
		else if (strcmp(field, "RX2D_Delay_Weight") == 0) {
			return mb_LPDDR5_1D[ps].RX2D_Delay_Weight; }
		else if (strcmp(field, "RX2D_Voltage_Weight") == 0) {
			return mb_LPDDR5_1D[ps].RX2D_Voltage_Weight; }
		else if (strcmp(field, "PhyConfigOverride") == 0) {
			return mb_LPDDR5_1D[ps].PhyConfigOverride; }
		else if (strcmp(field, "EnabledDQsChA") == 0) {
			return mb_LPDDR5_1D[ps].EnabledDQsChA; }
		else if (strcmp(field, "CsPresentChA") == 0) {
			return mb_LPDDR5_1D[ps].CsPresentChA; }
		else if (strcmp(field, "CATerminatingRankChA") == 0) {
			return mb_LPDDR5_1D[ps].CATerminatingRankChA; }
		else if (strcmp(field, "EnabledDQsChB") == 0) {
			return mb_LPDDR5_1D[ps].EnabledDQsChB; }
		else if (strcmp(field, "CsPresentChB") == 0) {
			return mb_LPDDR5_1D[ps].CsPresentChB; }
		else if (strcmp(field, "CATerminatingRankChB") == 0) {
			return mb_LPDDR5_1D[ps].CATerminatingRankChB; }
		else if (strcmp(field, "MR1_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR1_A0; }
		else if (strcmp(field, "MR1_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR1_A1; }
		else if (strcmp(field, "MR1_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR1_B0; }
		else if (strcmp(field, "MR1_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR1_B1; }
		else if (strcmp(field, "MR2_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR2_A0; }
		else if (strcmp(field, "MR2_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR2_A1; }
		else if (strcmp(field, "MR2_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR2_B0; }
		else if (strcmp(field, "MR2_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR2_B1; }
		else if (strcmp(field, "MR3_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR3_A0; }
		else if (strcmp(field, "MR3_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR3_A1; }
		else if (strcmp(field, "MR3_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR3_B0; }
		else if (strcmp(field, "MR3_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR3_B1; }
		else if (strcmp(field, "MR10_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR10_A0; }
		else if (strcmp(field, "MR10_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR10_A1; }
		else if (strcmp(field, "MR10_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR10_B0; }
		else if (strcmp(field, "MR10_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR10_B1; }
		else if (strcmp(field, "MR11_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR11_A0; }
		else if (strcmp(field, "MR11_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR11_A1; }
		else if (strcmp(field, "MR11_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR11_B0; }
		else if (strcmp(field, "MR11_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR11_B1; }
		else if (strcmp(field, "MR12_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR12_A0; }
		else if (strcmp(field, "MR12_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR12_A1; }
		else if (strcmp(field, "MR12_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR12_B0; }
		else if (strcmp(field, "MR12_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR12_B1; }
		else if (strcmp(field, "MR13_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR13_A0; }
		else if (strcmp(field, "MR13_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR13_A1; }
		else if (strcmp(field, "MR13_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR13_B0; }
		else if (strcmp(field, "MR13_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR13_B1; }
		else if (strcmp(field, "MR14_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR14_A0; }
		else if (strcmp(field, "MR14_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR14_A1; }
		else if (strcmp(field, "MR14_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR14_B0; }
		else if (strcmp(field, "MR14_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR14_B1; }
		else if (strcmp(field, "MR15_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR15_A0; }
		else if (strcmp(field, "MR15_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR15_A1; }
		else if (strcmp(field, "MR15_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR15_B0; }
		else if (strcmp(field, "MR15_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR15_B1; }
		else if (strcmp(field, "MR16_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR16_A0; }
		else if (strcmp(field, "MR16_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR16_A1; }
		else if (strcmp(field, "MR16_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR16_B0; }
		else if (strcmp(field, "MR16_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR16_B1; }
		else if (strcmp(field, "MR17_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR17_A0; }
		else if (strcmp(field, "MR17_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR17_A1; }
		else if (strcmp(field, "MR17_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR17_B0; }
		else if (strcmp(field, "MR17_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR17_B1; }
		else if (strcmp(field, "MR18_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR18_A0; }
		else if (strcmp(field, "MR18_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR18_A1; }
		else if (strcmp(field, "MR18_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR18_B0; }
		else if (strcmp(field, "MR18_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR18_B1; }
		else if (strcmp(field, "MR19_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR19_A0; }
		else if (strcmp(field, "MR19_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR19_A1; }
		else if (strcmp(field, "MR19_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR19_B0; }
		else if (strcmp(field, "MR19_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR19_B1; }
		else if (strcmp(field, "MR20_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR20_A0; }
		else if (strcmp(field, "MR20_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR20_A1; }
		else if (strcmp(field, "MR20_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR20_B0; }
		else if (strcmp(field, "MR20_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR20_B1; }
		else if (strcmp(field, "MR21_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR21_A0; }
		else if (strcmp(field, "MR21_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR21_A1; }
		else if (strcmp(field, "MR21_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR21_B0; }
		else if (strcmp(field, "MR21_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR21_B1; }
		else if (strcmp(field, "MR22_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR22_A0; }
		else if (strcmp(field, "MR22_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR22_A1; }
		else if (strcmp(field, "MR22_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR22_B0; }
		else if (strcmp(field, "MR22_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR22_B1; }
		else if (strcmp(field, "MR24_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR24_A0; }
		else if (strcmp(field, "MR24_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR24_A1; }
		else if (strcmp(field, "MR24_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR24_B0; }
		else if (strcmp(field, "MR24_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR24_B1; }
		else if (strcmp(field, "MR25_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR25_A0; }
		else if (strcmp(field, "MR25_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR25_A1; }
		else if (strcmp(field, "MR25_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR25_B0; }
		else if (strcmp(field, "MR25_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR25_B1; }
		else if (strcmp(field, "MR26_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR26_A0; }
		else if (strcmp(field, "MR26_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR26_A1; }
		else if (strcmp(field, "MR26_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR26_B0; }
		else if (strcmp(field, "MR26_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR26_B1; }
		else if (strcmp(field, "MR27_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR27_A0; }
		else if (strcmp(field, "MR27_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR27_A1; }
		else if (strcmp(field, "MR27_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR27_B0; }
		else if (strcmp(field, "MR27_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR27_B1; }
		else if (strcmp(field, "MR28_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR28_A0; }
		else if (strcmp(field, "MR28_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR28_A1; }
		else if (strcmp(field, "MR28_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR28_B0; }
		else if (strcmp(field, "MR28_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR28_B1; }
		else if (strcmp(field, "MR30_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR30_A0; }
		else if (strcmp(field, "MR30_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR30_A1; }
		else if (strcmp(field, "MR30_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR30_B0; }
		else if (strcmp(field, "MR30_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR30_B1; }
		else if (strcmp(field, "MR31_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR31_A0; }
		else if (strcmp(field, "MR31_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR31_A1; }
		else if (strcmp(field, "MR31_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR31_B0; }
		else if (strcmp(field, "MR31_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR31_B1; }
		else if (strcmp(field, "MR32_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR32_A0; }
		else if (strcmp(field, "MR32_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR32_A1; }
		else if (strcmp(field, "MR32_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR32_B0; }
		else if (strcmp(field, "MR32_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR32_B1; }
		else if (strcmp(field, "MR33_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR33_A0; }
		else if (strcmp(field, "MR33_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR33_A1; }
		else if (strcmp(field, "MR33_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR33_B0; }
		else if (strcmp(field, "MR33_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR33_B1; }
		else if (strcmp(field, "MR34_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR34_A0; }
		else if (strcmp(field, "MR34_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR34_A1; }
		else if (strcmp(field, "MR34_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR34_B0; }
		else if (strcmp(field, "MR34_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR34_B1; }
		else if (strcmp(field, "MR37_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR37_A0; }
		else if (strcmp(field, "MR37_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR37_A1; }
		else if (strcmp(field, "MR37_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR37_B0; }
		else if (strcmp(field, "MR37_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR37_B1; }
		else if (strcmp(field, "MR40_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR40_A0; }
		else if (strcmp(field, "MR40_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR40_A1; }
		else if (strcmp(field, "MR40_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR40_B0; }
		else if (strcmp(field, "MR40_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR40_B1; }
		else if (strcmp(field, "MR41_A0") == 0) {
			return mb_LPDDR5_1D[ps].MR41_A0; }
		else if (strcmp(field, "MR41_A1") == 0) {
			return mb_LPDDR5_1D[ps].MR41_A1; }
		else if (strcmp(field, "MR41_B0") == 0) {
			return mb_LPDDR5_1D[ps].MR41_B0; }
		else if (strcmp(field, "MR41_B1") == 0) {
			return mb_LPDDR5_1D[ps].MR41_B1; }
		else if (strcmp(field, "Disable2D") == 0) {
			return mb_LPDDR5_1D[ps].Disable2D; }
		else if (strcmp(field, "VrefSamples") == 0) {
			return mb_LPDDR5_1D[ps].VrefSamples; }
		else if (strcmp(field, "RdWrPatternA") == 0) {
			return mb_LPDDR5_1D[ps].RdWrPatternA; }
		else if (strcmp(field, "RdWrPatternB") == 0) {
			return mb_LPDDR5_1D[ps].RdWrPatternB; }
		else if (strcmp(field, "RdWrInvert") == 0) {
			return mb_LPDDR5_1D[ps].RdWrInvert; }
		else if (strcmp(field, "LdffMode") == 0) {
			return mb_LPDDR5_1D[ps].LdffMode; }
		else if (strcmp(field, "FCDfi0AcsmStart") == 0) {
			return mb_LPDDR5_1D[ps].FCDfi0AcsmStart; }
		else if (strcmp(field, "FCDfi1AcsmStart") == 0) {
			return mb_LPDDR5_1D[ps].FCDfi1AcsmStart; }
		else if (strcmp(field, "FCDfi0AcsmStartPSY") == 0) {
			return mb_LPDDR5_1D[ps].FCDfi0AcsmStartPSY; }
		else if (strcmp(field, "FCDfi1AcsmStartPSY") == 0) {
			return mb_LPDDR5_1D[ps].FCDfi1AcsmStartPSY; }
		else if (strcmp(field, "FCDMAStartMR") == 0) {
			return mb_LPDDR5_1D[ps].FCDMAStartMR; }
		else if (strcmp(field, "FCDMAStartCsr") == 0) {
			return mb_LPDDR5_1D[ps].FCDMAStartCsr; }
		else if (strcmp(field, "EnCustomSettings") == 0) {
			return mb_LPDDR5_1D[ps].EnCustomSettings; }
		else if (strcmp(field, "LS_TxSlewSE0") == 0) {
			return mb_LPDDR5_1D[ps].LS_TxSlewSE0; }
		else if (strcmp(field, "LS_TxSlewSE1") == 0) {
			return mb_LPDDR5_1D[ps].LS_TxSlewSE1; }
		else if (strcmp(field, "LS_TxSlewDIFF0") == 0) {
			return mb_LPDDR5_1D[ps].LS_TxSlewDIFF0; }
		else if (strcmp(field, "LS_TxImpedanceDIFF0T") == 0) {
			return mb_LPDDR5_1D[ps].LS_TxImpedanceDIFF0T; }
		else if (strcmp(field, "LS_TxImpedanceDIFF0C") == 0) {
			return mb_LPDDR5_1D[ps].LS_TxImpedanceDIFF0C; }
		else if (strcmp(field, "LS_TxImpedanceSE0") == 0) {
			return mb_LPDDR5_1D[ps].LS_TxImpedanceSE0; }
		else if (strcmp(field, "LS_TxImpedanceSE1") == 0) {
			return mb_LPDDR5_1D[ps].LS_TxImpedanceSE1; }
		else if (strcmp(field, "VrefInc") == 0) {
			return mb_LPDDR5_1D[ps].VrefInc; }
		else if (strcmp(field, "UpperLowerByte") == 0) {
			return mb_LPDDR5_1D[ps].UpperLowerByte; }
		else if (strcmp(field, "DisableTrainingLoop") == 0) {
			return mb_LPDDR5_1D[ps].DisableTrainingLoop; }
		else if (strcmp(field, "ALT_RL") == 0) {
			return mb_LPDDR5_1D[ps].ALT_RL; }
		else if (strcmp(field, "MAIN_RL") == 0) {
			return mb_LPDDR5_1D[ps].MAIN_RL; }
		else if (strcmp(field, "CSBACKOFF") == 0) {
			return mb_LPDDR5_1D[ps].CSBACKOFF; }
		else if (strcmp(field, "WrLvlTrainOpt") == 0) {
			return mb_LPDDR5_1D[ps].WrLvlTrainOpt; }
		else if (strcmp(field, "MRLCalcAdj") == 0) {
			return mb_LPDDR5_1D[ps].MRLCalcAdj; }
		else if (strcmp(field, "PPT2OffsetMargin") == 0) {
			return mb_LPDDR5_1D[ps].PPT2OffsetMargin; }
		else if (strcmp(field, "RxVrefStartPatDfe0") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStartPatDfe0; }
		else if (strcmp(field, "RxVrefStartPatDfe1") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStartPatDfe1; }
		else if (strcmp(field, "RxVrefStartPrbsDfe0") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStartPrbsDfe0; }
		else if (strcmp(field, "RxVrefStartPrbsDfe1") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStartPrbsDfe1; }
		else if (strcmp(field, "TxVrefStart") == 0) {
			return mb_LPDDR5_1D[ps].TxVrefStart; }
		else if (strcmp(field, "RxVrefEndPatDfe0") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefEndPatDfe0; }
		else if (strcmp(field, "RxVrefEndPatDfe1") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefEndPatDfe1; }
		else if (strcmp(field, "RxVrefEndPrbsDfe0") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefEndPrbsDfe0; }
		else if (strcmp(field, "RxVrefEndPrbsDfe1") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefEndPrbsDfe1; }
		else if (strcmp(field, "TxVrefEnd") == 0) {
			return mb_LPDDR5_1D[ps].TxVrefEnd; }
		else if (strcmp(field, "RxVrefStepPatDfe0") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStepPatDfe0; }
		else if (strcmp(field, "RxVrefStepPatDfe1") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStepPatDfe1; }
		else if (strcmp(field, "RxVrefStepPrbsDfe0") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStepPrbsDfe0; }
		else if (strcmp(field, "RxVrefStepPrbsDfe1") == 0) {
			return mb_LPDDR5_1D[ps].RxVrefStepPrbsDfe1; }
		else if (strcmp(field, "TxVrefStep") == 0) {
			return mb_LPDDR5_1D[ps].TxVrefStep; }
		else if (strcmp(field, "RxDlyScanShiftRank0Byte0") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank0Byte0; }
		else if (strcmp(field, "RxDlyScanShiftRank0Byte1") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank0Byte1; }
		else if (strcmp(field, "RxDlyScanShiftRank0Byte2") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank0Byte2; }
		else if (strcmp(field, "RxDlyScanShiftRank0Byte3") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank0Byte3; }
		else if (strcmp(field, "RxDlyScanShiftRank1Byte0") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank1Byte0; }
		else if (strcmp(field, "RxDlyScanShiftRank1Byte1") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank1Byte1; }
		else if (strcmp(field, "RxDlyScanShiftRank1Byte2") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank1Byte2; }
		else if (strcmp(field, "RxDlyScanShiftRank1Byte3") == 0) {
			return mb_LPDDR5_1D[ps].RxDlyScanShiftRank1Byte3; }
		else {
			dwc_ddrphy_phyinit_assert(0, " [%s] unknown messageBlock field name '%s', Train2D=%d\n", __func__, field, Train2D);
			return -1;
		}
	} else if (Train2D == 1) {
		/*
		 */
	} else {
		dwc_ddrphy_phyinit_assert(0, "[ %s] invalid value for Train2D=%d\n", __func__, Train2D);
		return -3;
	}

	return 0;
}

/** @} */
