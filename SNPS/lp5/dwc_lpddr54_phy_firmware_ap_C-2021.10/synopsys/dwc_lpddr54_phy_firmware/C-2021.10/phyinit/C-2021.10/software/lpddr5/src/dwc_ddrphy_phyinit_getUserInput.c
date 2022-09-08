/** \file */
#include <string.h>
#include "dwc_ddrphy_phyinit.h"

/** \addtogroup SrcFunc
 *  @{
 */

/** @brief API to read PhyInit data structures
 *
 *  This function can be used to read user_input_basic, user_input_advanced and
 *  user_input_sim data structures.
 *
 *  Some fields are defined as arrays in the data structure. Example to set
 *  PllBypass for Pstate 3:
 *
 *  @code{.c}
 *  dwc_ddrphy_phyinit_getUserInput("PllBypass[3]", 0x1);
 *  @endcode
 *
 *  \note field strings do not overlap between PhyInit structures.
 *
 *  @param[in]   phyctx  PhyInit context
 *
 *  @param[in]   field   A string representing the field to read. bracket
 *  notation can be used to set array fields. example  string: "PllBypass[0]"
 *  set the field UserInputBasic.PllBypass[0].
 *  fields is an array,
 *
 *  @return field value on success. -1 when string does not match fields in any oh PhyInit
 *  data structures.
 */
int dwc_ddrphy_phyinit_getUserInput(phyinit_config_t *phyctx, char *field)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	user_input_sim_t *pUserInputSim = &phyctx->userInputSim;

	if (strcmp(field, "NumPStates") == 0) {
		return pUserInputBasic->NumPStates; }
	else if (strcmp(field, "NumRank_dfi0") == 0) {
		return pUserInputBasic->NumRank_dfi0; }
	else if (strcmp(field, "HardMacroVer") == 0) {
		return pUserInputBasic->HardMacroVer; }
	else if (strcmp(field, "NumCh") == 0) {
		return pUserInputBasic->NumCh; }
	else if (strcmp(field, "DimmType") == 0) {
		return pUserInputBasic->DimmType; }
	else if (strcmp(field, "DramType") == 0) {
		return pUserInputBasic->DramType; }
	else if (strcmp(field, "DfiFreqRatio[0]") == 0) {
		return pUserInputBasic->DfiFreqRatio[0]; }
	else if (strcmp(field, "DfiFreqRatio[1]") == 0) {
		return pUserInputBasic->DfiFreqRatio[1]; }
	else if (strcmp(field, "DfiFreqRatio[2]") == 0) {
		return pUserInputBasic->DfiFreqRatio[2]; }
	else if (strcmp(field, "DfiFreqRatio[3]") == 0) {
		return pUserInputBasic->DfiFreqRatio[3]; }
	else if (strcmp(field, "DfiFreqRatio[4]") == 0) {
		return pUserInputBasic->DfiFreqRatio[4]; }
	else if (strcmp(field, "DfiFreqRatio[5]") == 0) {
		return pUserInputBasic->DfiFreqRatio[5]; }
	else if (strcmp(field, "DfiFreqRatio[6]") == 0) {
		return pUserInputBasic->DfiFreqRatio[6]; }
	else if (strcmp(field, "DfiFreqRatio[7]") == 0) {
		return pUserInputBasic->DfiFreqRatio[7]; }
	else if (strcmp(field, "DfiFreqRatio[8]") == 0) {
		return pUserInputBasic->DfiFreqRatio[8]; }
	else if (strcmp(field, "DfiFreqRatio[9]") == 0) {
		return pUserInputBasic->DfiFreqRatio[9]; }
	else if (strcmp(field, "DfiFreqRatio[10]") == 0) {
		return pUserInputBasic->DfiFreqRatio[10]; }
	else if (strcmp(field, "DfiFreqRatio[11]") == 0) {
		return pUserInputBasic->DfiFreqRatio[11]; }
	else if (strcmp(field, "DfiFreqRatio[12]") == 0) {
		return pUserInputBasic->DfiFreqRatio[12]; }
	else if (strcmp(field, "DfiFreqRatio[13]") == 0) {
		return pUserInputBasic->DfiFreqRatio[13]; }
	else if (strcmp(field, "DfiFreqRatio[14]") == 0) {
		return pUserInputBasic->DfiFreqRatio[14]; }
	else if (strcmp(field, "FirstPState") == 0) {
		return pUserInputBasic->FirstPState; }
	else if (strcmp(field, "NumActiveDbyteDfi1") == 0) {
		return pUserInputBasic->NumActiveDbyteDfi1; }
	else if (strcmp(field, "NumRank") == 0) {
		return pUserInputBasic->NumRank; }
	else if (strcmp(field, "DramDataWidth") == 0) {
		return pUserInputBasic->DramDataWidth; }
	else if (strcmp(field, "CfgPStates") == 0) {
		return pUserInputBasic->CfgPStates; }
	else if (strcmp(field, "Frequency[0]") == 0) {
		return pUserInputBasic->Frequency[0]; }
	else if (strcmp(field, "Frequency[1]") == 0) {
		return pUserInputBasic->Frequency[1]; }
	else if (strcmp(field, "Frequency[2]") == 0) {
		return pUserInputBasic->Frequency[2]; }
	else if (strcmp(field, "Frequency[3]") == 0) {
		return pUserInputBasic->Frequency[3]; }
	else if (strcmp(field, "Frequency[4]") == 0) {
		return pUserInputBasic->Frequency[4]; }
	else if (strcmp(field, "Frequency[5]") == 0) {
		return pUserInputBasic->Frequency[5]; }
	else if (strcmp(field, "Frequency[6]") == 0) {
		return pUserInputBasic->Frequency[6]; }
	else if (strcmp(field, "Frequency[7]") == 0) {
		return pUserInputBasic->Frequency[7]; }
	else if (strcmp(field, "Frequency[8]") == 0) {
		return pUserInputBasic->Frequency[8]; }
	else if (strcmp(field, "Frequency[9]") == 0) {
		return pUserInputBasic->Frequency[9]; }
	else if (strcmp(field, "Frequency[10]") == 0) {
		return pUserInputBasic->Frequency[10]; }
	else if (strcmp(field, "Frequency[11]") == 0) {
		return pUserInputBasic->Frequency[11]; }
	else if (strcmp(field, "Frequency[12]") == 0) {
		return pUserInputBasic->Frequency[12]; }
	else if (strcmp(field, "Frequency[13]") == 0) {
		return pUserInputBasic->Frequency[13]; }
	else if (strcmp(field, "Frequency[14]") == 0) {
		return pUserInputBasic->Frequency[14]; }
	else if (strcmp(field, "PllBypass[0]") == 0) {
		return pUserInputBasic->PllBypass[0]; }
	else if (strcmp(field, "PllBypass[1]") == 0) {
		return pUserInputBasic->PllBypass[1]; }
	else if (strcmp(field, "PllBypass[2]") == 0) {
		return pUserInputBasic->PllBypass[2]; }
	else if (strcmp(field, "PllBypass[3]") == 0) {
		return pUserInputBasic->PllBypass[3]; }
	else if (strcmp(field, "PllBypass[4]") == 0) {
		return pUserInputBasic->PllBypass[4]; }
	else if (strcmp(field, "PllBypass[5]") == 0) {
		return pUserInputBasic->PllBypass[5]; }
	else if (strcmp(field, "PllBypass[6]") == 0) {
		return pUserInputBasic->PllBypass[6]; }
	else if (strcmp(field, "PllBypass[7]") == 0) {
		return pUserInputBasic->PllBypass[7]; }
	else if (strcmp(field, "PllBypass[8]") == 0) {
		return pUserInputBasic->PllBypass[8]; }
	else if (strcmp(field, "PllBypass[9]") == 0) {
		return pUserInputBasic->PllBypass[9]; }
	else if (strcmp(field, "PllBypass[10]") == 0) {
		return pUserInputBasic->PllBypass[10]; }
	else if (strcmp(field, "PllBypass[11]") == 0) {
		return pUserInputBasic->PllBypass[11]; }
	else if (strcmp(field, "PllBypass[12]") == 0) {
		return pUserInputBasic->PllBypass[12]; }
	else if (strcmp(field, "PllBypass[13]") == 0) {
		return pUserInputBasic->PllBypass[13]; }
	else if (strcmp(field, "PllBypass[14]") == 0) {
		return pUserInputBasic->PllBypass[14]; }
	else if (strcmp(field, "NumRank_dfi1") == 0) {
		return pUserInputBasic->NumRank_dfi1; }
	else if (strcmp(field, "NumDbytesPerCh") == 0) {
		return pUserInputBasic->NumDbytesPerCh; }
	else if (strcmp(field, "MaxNumZQ") == 0) {
		return pUserInputBasic->MaxNumZQ; }
	else if (strcmp(field, "NumActiveDbyteDfi0") == 0) {
		return pUserInputBasic->NumActiveDbyteDfi0; }
	else if (strcmp(field, "RxDfeMode[0]") == 0) {
		return pUserInputAdvanced->RxDfeMode[0]; }
	else if (strcmp(field, "RxDfeMode[1]") == 0) {
		return pUserInputAdvanced->RxDfeMode[1]; }
	else if (strcmp(field, "RxDfeMode[2]") == 0) {
		return pUserInputAdvanced->RxDfeMode[2]; }
	else if (strcmp(field, "RxDfeMode[3]") == 0) {
		return pUserInputAdvanced->RxDfeMode[3]; }
	else if (strcmp(field, "RxDfeMode[4]") == 0) {
		return pUserInputAdvanced->RxDfeMode[4]; }
	else if (strcmp(field, "RxDfeMode[5]") == 0) {
		return pUserInputAdvanced->RxDfeMode[5]; }
	else if (strcmp(field, "RxDfeMode[6]") == 0) {
		return pUserInputAdvanced->RxDfeMode[6]; }
	else if (strcmp(field, "RxDfeMode[7]") == 0) {
		return pUserInputAdvanced->RxDfeMode[7]; }
	else if (strcmp(field, "RxDfeMode[8]") == 0) {
		return pUserInputAdvanced->RxDfeMode[8]; }
	else if (strcmp(field, "RxDfeMode[9]") == 0) {
		return pUserInputAdvanced->RxDfeMode[9]; }
	else if (strcmp(field, "RxDfeMode[10]") == 0) {
		return pUserInputAdvanced->RxDfeMode[10]; }
	else if (strcmp(field, "RxDfeMode[11]") == 0) {
		return pUserInputAdvanced->RxDfeMode[11]; }
	else if (strcmp(field, "RxDfeMode[12]") == 0) {
		return pUserInputAdvanced->RxDfeMode[12]; }
	else if (strcmp(field, "RxDfeMode[13]") == 0) {
		return pUserInputAdvanced->RxDfeMode[13]; }
	else if (strcmp(field, "RxDfeMode[14]") == 0) {
		return pUserInputAdvanced->RxDfeMode[14]; }
	else if (strcmp(field, "DramByteSwap") == 0) {
		return pUserInputAdvanced->DramByteSwap; }
	else if (strcmp(field, "TxSlewRiseDq[0]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[0]; }
	else if (strcmp(field, "TxSlewRiseDq[1]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[1]; }
	else if (strcmp(field, "TxSlewRiseDq[2]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[2]; }
	else if (strcmp(field, "TxSlewRiseDq[3]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[3]; }
	else if (strcmp(field, "TxSlewRiseDq[4]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[4]; }
	else if (strcmp(field, "TxSlewRiseDq[5]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[5]; }
	else if (strcmp(field, "TxSlewRiseDq[6]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[6]; }
	else if (strcmp(field, "TxSlewRiseDq[7]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[7]; }
	else if (strcmp(field, "TxSlewRiseDq[8]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[8]; }
	else if (strcmp(field, "TxSlewRiseDq[9]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[9]; }
	else if (strcmp(field, "TxSlewRiseDq[10]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[10]; }
	else if (strcmp(field, "TxSlewRiseDq[11]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[11]; }
	else if (strcmp(field, "TxSlewRiseDq[12]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[12]; }
	else if (strcmp(field, "TxSlewRiseDq[13]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[13]; }
	else if (strcmp(field, "TxSlewRiseDq[14]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDq[14]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[0]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[0]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[1]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[1]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[2]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[2]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[3]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[3]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[4]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[4]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[5]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[5]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[6]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[6]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[7]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[7]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[8]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[8]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[9]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[9]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[10]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[10]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[11]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[11]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[12]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[12]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[13]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[13]; }
	else if (strcmp(field, "RxBiasCurrentControlRxReplica[14]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlRxReplica[14]; }
	else if (strcmp(field, "TxSlewFallCA[0]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[0]; }
	else if (strcmp(field, "TxSlewFallCA[1]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[1]; }
	else if (strcmp(field, "TxSlewFallCA[2]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[2]; }
	else if (strcmp(field, "TxSlewFallCA[3]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[3]; }
	else if (strcmp(field, "TxSlewFallCA[4]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[4]; }
	else if (strcmp(field, "TxSlewFallCA[5]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[5]; }
	else if (strcmp(field, "TxSlewFallCA[6]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[6]; }
	else if (strcmp(field, "TxSlewFallCA[7]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[7]; }
	else if (strcmp(field, "TxSlewFallCA[8]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[8]; }
	else if (strcmp(field, "TxSlewFallCA[9]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[9]; }
	else if (strcmp(field, "TxSlewFallCA[10]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[10]; }
	else if (strcmp(field, "TxSlewFallCA[11]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[11]; }
	else if (strcmp(field, "TxSlewFallCA[12]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[12]; }
	else if (strcmp(field, "TxSlewFallCA[13]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[13]; }
	else if (strcmp(field, "TxSlewFallCA[14]") == 0) {
		return pUserInputAdvanced->TxSlewFallCA[14]; }
	else if (strcmp(field, "OdtImpedanceDqs[0]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[0]; }
	else if (strcmp(field, "OdtImpedanceDqs[1]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[1]; }
	else if (strcmp(field, "OdtImpedanceDqs[2]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[2]; }
	else if (strcmp(field, "OdtImpedanceDqs[3]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[3]; }
	else if (strcmp(field, "OdtImpedanceDqs[4]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[4]; }
	else if (strcmp(field, "OdtImpedanceDqs[5]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[5]; }
	else if (strcmp(field, "OdtImpedanceDqs[6]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[6]; }
	else if (strcmp(field, "OdtImpedanceDqs[7]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[7]; }
	else if (strcmp(field, "OdtImpedanceDqs[8]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[8]; }
	else if (strcmp(field, "OdtImpedanceDqs[9]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[9]; }
	else if (strcmp(field, "OdtImpedanceDqs[10]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[10]; }
	else if (strcmp(field, "OdtImpedanceDqs[11]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[11]; }
	else if (strcmp(field, "OdtImpedanceDqs[12]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[12]; }
	else if (strcmp(field, "OdtImpedanceDqs[13]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[13]; }
	else if (strcmp(field, "OdtImpedanceDqs[14]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDqs[14]; }
	else if (strcmp(field, "RxModeBoostVDD[0]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[0]; }
	else if (strcmp(field, "RxModeBoostVDD[1]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[1]; }
	else if (strcmp(field, "RxModeBoostVDD[2]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[2]; }
	else if (strcmp(field, "RxModeBoostVDD[3]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[3]; }
	else if (strcmp(field, "RxModeBoostVDD[4]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[4]; }
	else if (strcmp(field, "RxModeBoostVDD[5]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[5]; }
	else if (strcmp(field, "RxModeBoostVDD[6]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[6]; }
	else if (strcmp(field, "RxModeBoostVDD[7]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[7]; }
	else if (strcmp(field, "RxModeBoostVDD[8]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[8]; }
	else if (strcmp(field, "RxModeBoostVDD[9]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[9]; }
	else if (strcmp(field, "RxModeBoostVDD[10]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[10]; }
	else if (strcmp(field, "RxModeBoostVDD[11]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[11]; }
	else if (strcmp(field, "RxModeBoostVDD[12]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[12]; }
	else if (strcmp(field, "RxModeBoostVDD[13]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[13]; }
	else if (strcmp(field, "RxModeBoostVDD[14]") == 0) {
		return pUserInputAdvanced->RxModeBoostVDD[14]; }
	else if (strcmp(field, "PhyVrefCode") == 0) {
		return pUserInputAdvanced->PhyVrefCode; }
	else if (strcmp(field, "OdtImpedanceWCK[0]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[0]; }
	else if (strcmp(field, "OdtImpedanceWCK[1]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[1]; }
	else if (strcmp(field, "OdtImpedanceWCK[2]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[2]; }
	else if (strcmp(field, "OdtImpedanceWCK[3]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[3]; }
	else if (strcmp(field, "OdtImpedanceWCK[4]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[4]; }
	else if (strcmp(field, "OdtImpedanceWCK[5]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[5]; }
	else if (strcmp(field, "OdtImpedanceWCK[6]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[6]; }
	else if (strcmp(field, "OdtImpedanceWCK[7]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[7]; }
	else if (strcmp(field, "OdtImpedanceWCK[8]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[8]; }
	else if (strcmp(field, "OdtImpedanceWCK[9]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[9]; }
	else if (strcmp(field, "OdtImpedanceWCK[10]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[10]; }
	else if (strcmp(field, "OdtImpedanceWCK[11]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[11]; }
	else if (strcmp(field, "OdtImpedanceWCK[12]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[12]; }
	else if (strcmp(field, "OdtImpedanceWCK[13]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[13]; }
	else if (strcmp(field, "OdtImpedanceWCK[14]") == 0) {
		return pUserInputAdvanced->OdtImpedanceWCK[14]; }
	else if (strcmp(field, "TxSlewFallWCK[0]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[0]; }
	else if (strcmp(field, "TxSlewFallWCK[1]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[1]; }
	else if (strcmp(field, "TxSlewFallWCK[2]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[2]; }
	else if (strcmp(field, "TxSlewFallWCK[3]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[3]; }
	else if (strcmp(field, "TxSlewFallWCK[4]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[4]; }
	else if (strcmp(field, "TxSlewFallWCK[5]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[5]; }
	else if (strcmp(field, "TxSlewFallWCK[6]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[6]; }
	else if (strcmp(field, "TxSlewFallWCK[7]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[7]; }
	else if (strcmp(field, "TxSlewFallWCK[8]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[8]; }
	else if (strcmp(field, "TxSlewFallWCK[9]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[9]; }
	else if (strcmp(field, "TxSlewFallWCK[10]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[10]; }
	else if (strcmp(field, "TxSlewFallWCK[11]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[11]; }
	else if (strcmp(field, "TxSlewFallWCK[12]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[12]; }
	else if (strcmp(field, "TxSlewFallWCK[13]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[13]; }
	else if (strcmp(field, "TxSlewFallWCK[14]") == 0) {
		return pUserInputAdvanced->TxSlewFallWCK[14]; }
	else if (strcmp(field, "OdtImpedanceDq[0]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[0]; }
	else if (strcmp(field, "OdtImpedanceDq[1]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[1]; }
	else if (strcmp(field, "OdtImpedanceDq[2]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[2]; }
	else if (strcmp(field, "OdtImpedanceDq[3]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[3]; }
	else if (strcmp(field, "OdtImpedanceDq[4]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[4]; }
	else if (strcmp(field, "OdtImpedanceDq[5]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[5]; }
	else if (strcmp(field, "OdtImpedanceDq[6]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[6]; }
	else if (strcmp(field, "OdtImpedanceDq[7]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[7]; }
	else if (strcmp(field, "OdtImpedanceDq[8]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[8]; }
	else if (strcmp(field, "OdtImpedanceDq[9]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[9]; }
	else if (strcmp(field, "OdtImpedanceDq[10]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[10]; }
	else if (strcmp(field, "OdtImpedanceDq[11]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[11]; }
	else if (strcmp(field, "OdtImpedanceDq[12]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[12]; }
	else if (strcmp(field, "OdtImpedanceDq[13]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[13]; }
	else if (strcmp(field, "OdtImpedanceDq[14]") == 0) {
		return pUserInputAdvanced->OdtImpedanceDq[14]; }
	else if (strcmp(field, "DisableUnusedAddrLns") == 0) {
		return pUserInputAdvanced->DisableUnusedAddrLns; }
	else if (strcmp(field, "EnWck2DqoTracking[0]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[0]; }
	else if (strcmp(field, "EnWck2DqoTracking[1]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[1]; }
	else if (strcmp(field, "EnWck2DqoTracking[2]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[2]; }
	else if (strcmp(field, "EnWck2DqoTracking[3]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[3]; }
	else if (strcmp(field, "EnWck2DqoTracking[4]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[4]; }
	else if (strcmp(field, "EnWck2DqoTracking[5]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[5]; }
	else if (strcmp(field, "EnWck2DqoTracking[6]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[6]; }
	else if (strcmp(field, "EnWck2DqoTracking[7]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[7]; }
	else if (strcmp(field, "EnWck2DqoTracking[8]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[8]; }
	else if (strcmp(field, "EnWck2DqoTracking[9]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[9]; }
	else if (strcmp(field, "EnWck2DqoTracking[10]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[10]; }
	else if (strcmp(field, "EnWck2DqoTracking[11]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[11]; }
	else if (strcmp(field, "EnWck2DqoTracking[12]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[12]; }
	else if (strcmp(field, "EnWck2DqoTracking[13]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[13]; }
	else if (strcmp(field, "EnWck2DqoTracking[14]") == 0) {
		return pUserInputAdvanced->EnWck2DqoTracking[14]; }
	else if (strcmp(field, "TxSlewRiseCK[0]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[0]; }
	else if (strcmp(field, "TxSlewRiseCK[1]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[1]; }
	else if (strcmp(field, "TxSlewRiseCK[2]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[2]; }
	else if (strcmp(field, "TxSlewRiseCK[3]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[3]; }
	else if (strcmp(field, "TxSlewRiseCK[4]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[4]; }
	else if (strcmp(field, "TxSlewRiseCK[5]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[5]; }
	else if (strcmp(field, "TxSlewRiseCK[6]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[6]; }
	else if (strcmp(field, "TxSlewRiseCK[7]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[7]; }
	else if (strcmp(field, "TxSlewRiseCK[8]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[8]; }
	else if (strcmp(field, "TxSlewRiseCK[9]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[9]; }
	else if (strcmp(field, "TxSlewRiseCK[10]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[10]; }
	else if (strcmp(field, "TxSlewRiseCK[11]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[11]; }
	else if (strcmp(field, "TxSlewRiseCK[12]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[12]; }
	else if (strcmp(field, "TxSlewRiseCK[13]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[13]; }
	else if (strcmp(field, "TxSlewRiseCK[14]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCK[14]; }
	else if (strcmp(field, "TxSlewRiseCA[0]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[0]; }
	else if (strcmp(field, "TxSlewRiseCA[1]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[1]; }
	else if (strcmp(field, "TxSlewRiseCA[2]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[2]; }
	else if (strcmp(field, "TxSlewRiseCA[3]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[3]; }
	else if (strcmp(field, "TxSlewRiseCA[4]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[4]; }
	else if (strcmp(field, "TxSlewRiseCA[5]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[5]; }
	else if (strcmp(field, "TxSlewRiseCA[6]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[6]; }
	else if (strcmp(field, "TxSlewRiseCA[7]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[7]; }
	else if (strcmp(field, "TxSlewRiseCA[8]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[8]; }
	else if (strcmp(field, "TxSlewRiseCA[9]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[9]; }
	else if (strcmp(field, "TxSlewRiseCA[10]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[10]; }
	else if (strcmp(field, "TxSlewRiseCA[11]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[11]; }
	else if (strcmp(field, "TxSlewRiseCA[12]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[12]; }
	else if (strcmp(field, "TxSlewRiseCA[13]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[13]; }
	else if (strcmp(field, "TxSlewRiseCA[14]") == 0) {
		return pUserInputAdvanced->TxSlewRiseCA[14]; }
	else if (strcmp(field, "TxSlewFallCK[0]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[0]; }
	else if (strcmp(field, "TxSlewFallCK[1]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[1]; }
	else if (strcmp(field, "TxSlewFallCK[2]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[2]; }
	else if (strcmp(field, "TxSlewFallCK[3]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[3]; }
	else if (strcmp(field, "TxSlewFallCK[4]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[4]; }
	else if (strcmp(field, "TxSlewFallCK[5]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[5]; }
	else if (strcmp(field, "TxSlewFallCK[6]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[6]; }
	else if (strcmp(field, "TxSlewFallCK[7]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[7]; }
	else if (strcmp(field, "TxSlewFallCK[8]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[8]; }
	else if (strcmp(field, "TxSlewFallCK[9]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[9]; }
	else if (strcmp(field, "TxSlewFallCK[10]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[10]; }
	else if (strcmp(field, "TxSlewFallCK[11]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[11]; }
	else if (strcmp(field, "TxSlewFallCK[12]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[12]; }
	else if (strcmp(field, "TxSlewFallCK[13]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[13]; }
	else if (strcmp(field, "TxSlewFallCK[14]") == 0) {
		return pUserInputAdvanced->TxSlewFallCK[14]; }
	else if (strcmp(field, "RelockOnlyCntrl") == 0) {
		return pUserInputAdvanced->RelockOnlyCntrl; }
	else if (strcmp(field, "CalImpedanceCurrentAdjustment") == 0) {
		return pUserInputAdvanced->CalImpedanceCurrentAdjustment; }
	else if (strcmp(field, "SkipRetrainEnhancement") == 0) {
		return pUserInputAdvanced->SkipRetrainEnhancement; }
	else if (strcmp(field, "OdtImpedanceCk[0]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[0]; }
	else if (strcmp(field, "OdtImpedanceCk[1]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[1]; }
	else if (strcmp(field, "OdtImpedanceCk[2]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[2]; }
	else if (strcmp(field, "OdtImpedanceCk[3]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[3]; }
	else if (strcmp(field, "OdtImpedanceCk[4]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[4]; }
	else if (strcmp(field, "OdtImpedanceCk[5]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[5]; }
	else if (strcmp(field, "OdtImpedanceCk[6]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[6]; }
	else if (strcmp(field, "OdtImpedanceCk[7]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[7]; }
	else if (strcmp(field, "OdtImpedanceCk[8]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[8]; }
	else if (strcmp(field, "OdtImpedanceCk[9]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[9]; }
	else if (strcmp(field, "OdtImpedanceCk[10]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[10]; }
	else if (strcmp(field, "OdtImpedanceCk[11]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[11]; }
	else if (strcmp(field, "OdtImpedanceCk[12]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[12]; }
	else if (strcmp(field, "OdtImpedanceCk[13]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[13]; }
	else if (strcmp(field, "OdtImpedanceCk[14]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCk[14]; }
	else if (strcmp(field, "TxImpedanceCKE[0]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[0]; }
	else if (strcmp(field, "TxImpedanceCKE[1]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[1]; }
	else if (strcmp(field, "TxImpedanceCKE[2]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[2]; }
	else if (strcmp(field, "TxImpedanceCKE[3]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[3]; }
	else if (strcmp(field, "TxImpedanceCKE[4]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[4]; }
	else if (strcmp(field, "TxImpedanceCKE[5]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[5]; }
	else if (strcmp(field, "TxImpedanceCKE[6]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[6]; }
	else if (strcmp(field, "TxImpedanceCKE[7]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[7]; }
	else if (strcmp(field, "TxImpedanceCKE[8]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[8]; }
	else if (strcmp(field, "TxImpedanceCKE[9]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[9]; }
	else if (strcmp(field, "TxImpedanceCKE[10]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[10]; }
	else if (strcmp(field, "TxImpedanceCKE[11]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[11]; }
	else if (strcmp(field, "TxImpedanceCKE[12]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[12]; }
	else if (strcmp(field, "TxImpedanceCKE[13]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[13]; }
	else if (strcmp(field, "TxImpedanceCKE[14]") == 0) {
		return pUserInputAdvanced->TxImpedanceCKE[14]; }
	else if (strcmp(field, "PsDmaRamSize") == 0) {
		return pUserInputAdvanced->PsDmaRamSize; }
	else if (strcmp(field, "RxClkTrackEn[0]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[0]; }
	else if (strcmp(field, "RxClkTrackEn[1]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[1]; }
	else if (strcmp(field, "RxClkTrackEn[2]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[2]; }
	else if (strcmp(field, "RxClkTrackEn[3]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[3]; }
	else if (strcmp(field, "RxClkTrackEn[4]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[4]; }
	else if (strcmp(field, "RxClkTrackEn[5]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[5]; }
	else if (strcmp(field, "RxClkTrackEn[6]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[6]; }
	else if (strcmp(field, "RxClkTrackEn[7]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[7]; }
	else if (strcmp(field, "RxClkTrackEn[8]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[8]; }
	else if (strcmp(field, "RxClkTrackEn[9]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[9]; }
	else if (strcmp(field, "RxClkTrackEn[10]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[10]; }
	else if (strcmp(field, "RxClkTrackEn[11]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[11]; }
	else if (strcmp(field, "RxClkTrackEn[12]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[12]; }
	else if (strcmp(field, "RxClkTrackEn[13]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[13]; }
	else if (strcmp(field, "RxClkTrackEn[14]") == 0) {
		return pUserInputAdvanced->RxClkTrackEn[14]; }
	else if (strcmp(field, "TxSlewFallDqs[0]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[0]; }
	else if (strcmp(field, "TxSlewFallDqs[1]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[1]; }
	else if (strcmp(field, "TxSlewFallDqs[2]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[2]; }
	else if (strcmp(field, "TxSlewFallDqs[3]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[3]; }
	else if (strcmp(field, "TxSlewFallDqs[4]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[4]; }
	else if (strcmp(field, "TxSlewFallDqs[5]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[5]; }
	else if (strcmp(field, "TxSlewFallDqs[6]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[6]; }
	else if (strcmp(field, "TxSlewFallDqs[7]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[7]; }
	else if (strcmp(field, "TxSlewFallDqs[8]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[8]; }
	else if (strcmp(field, "TxSlewFallDqs[9]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[9]; }
	else if (strcmp(field, "TxSlewFallDqs[10]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[10]; }
	else if (strcmp(field, "TxSlewFallDqs[11]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[11]; }
	else if (strcmp(field, "TxSlewFallDqs[12]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[12]; }
	else if (strcmp(field, "TxSlewFallDqs[13]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[13]; }
	else if (strcmp(field, "TxSlewFallDqs[14]") == 0) {
		return pUserInputAdvanced->TxSlewFallDqs[14]; }
	else if (strcmp(field, "TxImpedanceAc[0]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[0]; }
	else if (strcmp(field, "TxImpedanceAc[1]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[1]; }
	else if (strcmp(field, "TxImpedanceAc[2]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[2]; }
	else if (strcmp(field, "TxImpedanceAc[3]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[3]; }
	else if (strcmp(field, "TxImpedanceAc[4]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[4]; }
	else if (strcmp(field, "TxImpedanceAc[5]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[5]; }
	else if (strcmp(field, "TxImpedanceAc[6]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[6]; }
	else if (strcmp(field, "TxImpedanceAc[7]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[7]; }
	else if (strcmp(field, "TxImpedanceAc[8]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[8]; }
	else if (strcmp(field, "TxImpedanceAc[9]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[9]; }
	else if (strcmp(field, "TxImpedanceAc[10]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[10]; }
	else if (strcmp(field, "TxImpedanceAc[11]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[11]; }
	else if (strcmp(field, "TxImpedanceAc[12]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[12]; }
	else if (strcmp(field, "TxImpedanceAc[13]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[13]; }
	else if (strcmp(field, "TxImpedanceAc[14]") == 0) {
		return pUserInputAdvanced->TxImpedanceAc[14]; }
	else if (strcmp(field, "CkDisVal[0]") == 0) {
		return pUserInputAdvanced->CkDisVal[0]; }
	else if (strcmp(field, "CkDisVal[1]") == 0) {
		return pUserInputAdvanced->CkDisVal[1]; }
	else if (strcmp(field, "CkDisVal[2]") == 0) {
		return pUserInputAdvanced->CkDisVal[2]; }
	else if (strcmp(field, "CkDisVal[3]") == 0) {
		return pUserInputAdvanced->CkDisVal[3]; }
	else if (strcmp(field, "CkDisVal[4]") == 0) {
		return pUserInputAdvanced->CkDisVal[4]; }
	else if (strcmp(field, "CkDisVal[5]") == 0) {
		return pUserInputAdvanced->CkDisVal[5]; }
	else if (strcmp(field, "CkDisVal[6]") == 0) {
		return pUserInputAdvanced->CkDisVal[6]; }
	else if (strcmp(field, "CkDisVal[7]") == 0) {
		return pUserInputAdvanced->CkDisVal[7]; }
	else if (strcmp(field, "CkDisVal[8]") == 0) {
		return pUserInputAdvanced->CkDisVal[8]; }
	else if (strcmp(field, "CkDisVal[9]") == 0) {
		return pUserInputAdvanced->CkDisVal[9]; }
	else if (strcmp(field, "CkDisVal[10]") == 0) {
		return pUserInputAdvanced->CkDisVal[10]; }
	else if (strcmp(field, "CkDisVal[11]") == 0) {
		return pUserInputAdvanced->CkDisVal[11]; }
	else if (strcmp(field, "CkDisVal[12]") == 0) {
		return pUserInputAdvanced->CkDisVal[12]; }
	else if (strcmp(field, "CkDisVal[13]") == 0) {
		return pUserInputAdvanced->CkDisVal[13]; }
	else if (strcmp(field, "CkDisVal[14]") == 0) {
		return pUserInputAdvanced->CkDisVal[14]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[0]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[0]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[1]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[1]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[2]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[2]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[3]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[3]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[4]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[4]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[5]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[5]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[6]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[6]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[7]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[7]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[8]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[8]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[9]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[9]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[10]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[10]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[11]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[11]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[12]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[12]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[13]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[13]; }
	else if (strcmp(field, "PhyMstrMaxReqToAck[14]") == 0) {
		return pUserInputAdvanced->PhyMstrMaxReqToAck[14]; }
	else if (strcmp(field, "TxImpedanceDqs[0]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[0]; }
	else if (strcmp(field, "TxImpedanceDqs[1]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[1]; }
	else if (strcmp(field, "TxImpedanceDqs[2]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[2]; }
	else if (strcmp(field, "TxImpedanceDqs[3]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[3]; }
	else if (strcmp(field, "TxImpedanceDqs[4]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[4]; }
	else if (strcmp(field, "TxImpedanceDqs[5]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[5]; }
	else if (strcmp(field, "TxImpedanceDqs[6]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[6]; }
	else if (strcmp(field, "TxImpedanceDqs[7]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[7]; }
	else if (strcmp(field, "TxImpedanceDqs[8]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[8]; }
	else if (strcmp(field, "TxImpedanceDqs[9]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[9]; }
	else if (strcmp(field, "TxImpedanceDqs[10]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[10]; }
	else if (strcmp(field, "TxImpedanceDqs[11]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[11]; }
	else if (strcmp(field, "TxImpedanceDqs[12]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[12]; }
	else if (strcmp(field, "TxImpedanceDqs[13]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[13]; }
	else if (strcmp(field, "TxImpedanceDqs[14]") == 0) {
		return pUserInputAdvanced->TxImpedanceDqs[14]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[0]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[0]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[1]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[1]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[2]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[2]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[3]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[3]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[4]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[4]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[5]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[5]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[6]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[6]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[7]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[7]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[8]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[8]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[9]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[9]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[10]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[10]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[11]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[11]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[12]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[12]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[13]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[13]; }
	else if (strcmp(field, "RxDqsTrackingThreshold[14]") == 0) {
		return pUserInputAdvanced->RxDqsTrackingThreshold[14]; }
	else if (strcmp(field, "DisableTDRAccess") == 0) {
		return pUserInputAdvanced->DisableTDRAccess; }
	else if (strcmp(field, "DisableRetraining") == 0) {
		return pUserInputAdvanced->DisableRetraining; }
	else if (strcmp(field, "TxSlewFallDq[0]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[0]; }
	else if (strcmp(field, "TxSlewFallDq[1]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[1]; }
	else if (strcmp(field, "TxSlewFallDq[2]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[2]; }
	else if (strcmp(field, "TxSlewFallDq[3]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[3]; }
	else if (strcmp(field, "TxSlewFallDq[4]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[4]; }
	else if (strcmp(field, "TxSlewFallDq[5]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[5]; }
	else if (strcmp(field, "TxSlewFallDq[6]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[6]; }
	else if (strcmp(field, "TxSlewFallDq[7]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[7]; }
	else if (strcmp(field, "TxSlewFallDq[8]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[8]; }
	else if (strcmp(field, "TxSlewFallDq[9]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[9]; }
	else if (strcmp(field, "TxSlewFallDq[10]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[10]; }
	else if (strcmp(field, "TxSlewFallDq[11]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[11]; }
	else if (strcmp(field, "TxSlewFallDq[12]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[12]; }
	else if (strcmp(field, "TxSlewFallDq[13]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[13]; }
	else if (strcmp(field, "TxSlewFallDq[14]") == 0) {
		return pUserInputAdvanced->TxSlewFallDq[14]; }
	else if (strcmp(field, "DisablePmuEcc") == 0) {
		return pUserInputAdvanced->DisablePmuEcc; }
	else if (strcmp(field, "ExtCalResVal") == 0) {
		return pUserInputAdvanced->ExtCalResVal; }
	else if (strcmp(field, "TxImpedanceWCK[0]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[0]; }
	else if (strcmp(field, "TxImpedanceWCK[1]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[1]; }
	else if (strcmp(field, "TxImpedanceWCK[2]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[2]; }
	else if (strcmp(field, "TxImpedanceWCK[3]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[3]; }
	else if (strcmp(field, "TxImpedanceWCK[4]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[4]; }
	else if (strcmp(field, "TxImpedanceWCK[5]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[5]; }
	else if (strcmp(field, "TxImpedanceWCK[6]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[6]; }
	else if (strcmp(field, "TxImpedanceWCK[7]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[7]; }
	else if (strcmp(field, "TxImpedanceWCK[8]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[8]; }
	else if (strcmp(field, "TxImpedanceWCK[9]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[9]; }
	else if (strcmp(field, "TxImpedanceWCK[10]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[10]; }
	else if (strcmp(field, "TxImpedanceWCK[11]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[11]; }
	else if (strcmp(field, "TxImpedanceWCK[12]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[12]; }
	else if (strcmp(field, "TxImpedanceWCK[13]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[13]; }
	else if (strcmp(field, "TxImpedanceWCK[14]") == 0) {
		return pUserInputAdvanced->TxImpedanceWCK[14]; }
	else if (strcmp(field, "TxSlewRiseDqs[0]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[0]; }
	else if (strcmp(field, "TxSlewRiseDqs[1]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[1]; }
	else if (strcmp(field, "TxSlewRiseDqs[2]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[2]; }
	else if (strcmp(field, "TxSlewRiseDqs[3]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[3]; }
	else if (strcmp(field, "TxSlewRiseDqs[4]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[4]; }
	else if (strcmp(field, "TxSlewRiseDqs[5]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[5]; }
	else if (strcmp(field, "TxSlewRiseDqs[6]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[6]; }
	else if (strcmp(field, "TxSlewRiseDqs[7]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[7]; }
	else if (strcmp(field, "TxSlewRiseDqs[8]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[8]; }
	else if (strcmp(field, "TxSlewRiseDqs[9]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[9]; }
	else if (strcmp(field, "TxSlewRiseDqs[10]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[10]; }
	else if (strcmp(field, "TxSlewRiseDqs[11]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[11]; }
	else if (strcmp(field, "TxSlewRiseDqs[12]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[12]; }
	else if (strcmp(field, "TxSlewRiseDqs[13]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[13]; }
	else if (strcmp(field, "TxSlewRiseDqs[14]") == 0) {
		return pUserInputAdvanced->TxSlewRiseDqs[14]; }
	else if (strcmp(field, "TxSlewRiseWCK[0]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[0]; }
	else if (strcmp(field, "TxSlewRiseWCK[1]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[1]; }
	else if (strcmp(field, "TxSlewRiseWCK[2]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[2]; }
	else if (strcmp(field, "TxSlewRiseWCK[3]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[3]; }
	else if (strcmp(field, "TxSlewRiseWCK[4]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[4]; }
	else if (strcmp(field, "TxSlewRiseWCK[5]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[5]; }
	else if (strcmp(field, "TxSlewRiseWCK[6]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[6]; }
	else if (strcmp(field, "TxSlewRiseWCK[7]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[7]; }
	else if (strcmp(field, "TxSlewRiseWCK[8]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[8]; }
	else if (strcmp(field, "TxSlewRiseWCK[9]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[9]; }
	else if (strcmp(field, "TxSlewRiseWCK[10]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[10]; }
	else if (strcmp(field, "TxSlewRiseWCK[11]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[11]; }
	else if (strcmp(field, "TxSlewRiseWCK[12]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[12]; }
	else if (strcmp(field, "TxSlewRiseWCK[13]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[13]; }
	else if (strcmp(field, "TxSlewRiseWCK[14]") == 0) {
		return pUserInputAdvanced->TxSlewRiseWCK[14]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[0]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[0]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[1]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[1]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[2]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[2]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[3]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[3]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[4]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[4]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[5]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[5]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[6]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[6]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[7]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[7]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[8]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[8]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[9]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[9]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[10]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[10]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[11]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[11]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[12]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[12]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[13]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[13]; }
	else if (strcmp(field, "RxBiasCurrentControlDqs[14]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlDqs[14]; }
	else if (strcmp(field, "RxClkTrackWait") == 0) {
		return pUserInputAdvanced->RxClkTrackWait; }
	else if (strcmp(field, "CalOnce") == 0) {
		return pUserInputAdvanced->CalOnce; }
	else if (strcmp(field, "PhyMstrCtrlMode[0]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[0]; }
	else if (strcmp(field, "PhyMstrCtrlMode[1]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[1]; }
	else if (strcmp(field, "PhyMstrCtrlMode[2]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[2]; }
	else if (strcmp(field, "PhyMstrCtrlMode[3]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[3]; }
	else if (strcmp(field, "PhyMstrCtrlMode[4]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[4]; }
	else if (strcmp(field, "PhyMstrCtrlMode[5]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[5]; }
	else if (strcmp(field, "PhyMstrCtrlMode[6]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[6]; }
	else if (strcmp(field, "PhyMstrCtrlMode[7]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[7]; }
	else if (strcmp(field, "PhyMstrCtrlMode[8]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[8]; }
	else if (strcmp(field, "PhyMstrCtrlMode[9]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[9]; }
	else if (strcmp(field, "PhyMstrCtrlMode[10]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[10]; }
	else if (strcmp(field, "PhyMstrCtrlMode[11]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[11]; }
	else if (strcmp(field, "PhyMstrCtrlMode[12]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[12]; }
	else if (strcmp(field, "PhyMstrCtrlMode[13]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[13]; }
	else if (strcmp(field, "PhyMstrCtrlMode[14]") == 0) {
		return pUserInputAdvanced->PhyMstrCtrlMode[14]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[0]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[0]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[1]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[1]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[2]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[2]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[3]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[3]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[4]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[4]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[5]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[5]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[6]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[6]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[7]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[7]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[8]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[8]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[9]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[9]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[10]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[10]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[11]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[11]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[12]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[12]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[13]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[13]; }
	else if (strcmp(field, "RxVrefKickbackNoiseCancellation[14]") == 0) {
		return pUserInputAdvanced->RxVrefKickbackNoiseCancellation[14]; }
	else if (strcmp(field, "RxClkTrackWaitUI") == 0) {
		return pUserInputAdvanced->RxClkTrackWaitUI; }
	else if (strcmp(field, "TxImpedanceDq[0]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[0]; }
	else if (strcmp(field, "TxImpedanceDq[1]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[1]; }
	else if (strcmp(field, "TxImpedanceDq[2]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[2]; }
	else if (strcmp(field, "TxImpedanceDq[3]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[3]; }
	else if (strcmp(field, "TxImpedanceDq[4]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[4]; }
	else if (strcmp(field, "TxImpedanceDq[5]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[5]; }
	else if (strcmp(field, "TxImpedanceDq[6]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[6]; }
	else if (strcmp(field, "TxImpedanceDq[7]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[7]; }
	else if (strcmp(field, "TxImpedanceDq[8]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[8]; }
	else if (strcmp(field, "TxImpedanceDq[9]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[9]; }
	else if (strcmp(field, "TxImpedanceDq[10]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[10]; }
	else if (strcmp(field, "TxImpedanceDq[11]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[11]; }
	else if (strcmp(field, "TxImpedanceDq[12]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[12]; }
	else if (strcmp(field, "TxImpedanceDq[13]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[13]; }
	else if (strcmp(field, "TxImpedanceDq[14]") == 0) {
		return pUserInputAdvanced->TxImpedanceDq[14]; }
	else if (strcmp(field, "OnlyRestoreNonPsRegs") == 0) {
		return pUserInputAdvanced->OnlyRestoreNonPsRegs; }
	else if (strcmp(field, "TrainSequenceCtrl") == 0) {
		return pUserInputAdvanced->TrainSequenceCtrl; }
	else if (strcmp(field, "TxImpedanceCk[0]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[0]; }
	else if (strcmp(field, "TxImpedanceCk[1]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[1]; }
	else if (strcmp(field, "TxImpedanceCk[2]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[2]; }
	else if (strcmp(field, "TxImpedanceCk[3]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[3]; }
	else if (strcmp(field, "TxImpedanceCk[4]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[4]; }
	else if (strcmp(field, "TxImpedanceCk[5]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[5]; }
	else if (strcmp(field, "TxImpedanceCk[6]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[6]; }
	else if (strcmp(field, "TxImpedanceCk[7]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[7]; }
	else if (strcmp(field, "TxImpedanceCk[8]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[8]; }
	else if (strcmp(field, "TxImpedanceCk[9]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[9]; }
	else if (strcmp(field, "TxImpedanceCk[10]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[10]; }
	else if (strcmp(field, "TxImpedanceCk[11]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[11]; }
	else if (strcmp(field, "TxImpedanceCk[12]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[12]; }
	else if (strcmp(field, "TxImpedanceCk[13]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[13]; }
	else if (strcmp(field, "TxImpedanceCk[14]") == 0) {
		return pUserInputAdvanced->TxImpedanceCk[14]; }
	else if (strcmp(field, "DisableFspOp") == 0) {
		return pUserInputAdvanced->DisableFspOp; }
	else if (strcmp(field, "TxImpedanceDTO[0]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[0]; }
	else if (strcmp(field, "TxImpedanceDTO[1]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[1]; }
	else if (strcmp(field, "TxImpedanceDTO[2]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[2]; }
	else if (strcmp(field, "TxImpedanceDTO[3]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[3]; }
	else if (strcmp(field, "TxImpedanceDTO[4]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[4]; }
	else if (strcmp(field, "TxImpedanceDTO[5]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[5]; }
	else if (strcmp(field, "TxImpedanceDTO[6]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[6]; }
	else if (strcmp(field, "TxImpedanceDTO[7]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[7]; }
	else if (strcmp(field, "TxImpedanceDTO[8]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[8]; }
	else if (strcmp(field, "TxImpedanceDTO[9]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[9]; }
	else if (strcmp(field, "TxImpedanceDTO[10]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[10]; }
	else if (strcmp(field, "TxImpedanceDTO[11]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[11]; }
	else if (strcmp(field, "TxImpedanceDTO[12]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[12]; }
	else if (strcmp(field, "TxImpedanceDTO[13]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[13]; }
	else if (strcmp(field, "TxImpedanceDTO[14]") == 0) {
		return pUserInputAdvanced->TxImpedanceDTO[14]; }
	else if (strcmp(field, "EnRxDqsTracking[0]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[0]; }
	else if (strcmp(field, "EnRxDqsTracking[1]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[1]; }
	else if (strcmp(field, "EnRxDqsTracking[2]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[2]; }
	else if (strcmp(field, "EnRxDqsTracking[3]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[3]; }
	else if (strcmp(field, "EnRxDqsTracking[4]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[4]; }
	else if (strcmp(field, "EnRxDqsTracking[5]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[5]; }
	else if (strcmp(field, "EnRxDqsTracking[6]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[6]; }
	else if (strcmp(field, "EnRxDqsTracking[7]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[7]; }
	else if (strcmp(field, "EnRxDqsTracking[8]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[8]; }
	else if (strcmp(field, "EnRxDqsTracking[9]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[9]; }
	else if (strcmp(field, "EnRxDqsTracking[10]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[10]; }
	else if (strcmp(field, "EnRxDqsTracking[11]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[11]; }
	else if (strcmp(field, "EnRxDqsTracking[12]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[12]; }
	else if (strcmp(field, "EnRxDqsTracking[13]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[13]; }
	else if (strcmp(field, "EnRxDqsTracking[14]") == 0) {
		return pUserInputAdvanced->EnRxDqsTracking[14]; }
	else if (strcmp(field, "CalInterval") == 0) {
		return pUserInputAdvanced->CalInterval; }
	else if (strcmp(field, "RxBiasCurrentControlWck[0]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[0]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[1]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[1]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[2]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[2]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[3]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[3]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[4]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[4]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[5]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[5]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[6]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[6]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[7]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[7]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[8]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[8]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[9]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[9]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[10]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[10]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[11]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[11]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[12]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[12]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[13]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[13]; }
	else if (strcmp(field, "RxBiasCurrentControlWck[14]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlWck[14]; }
	else if (strcmp(field, "RetrainMode[0]") == 0) {
		return pUserInputAdvanced->RetrainMode[0]; }
	else if (strcmp(field, "RetrainMode[1]") == 0) {
		return pUserInputAdvanced->RetrainMode[1]; }
	else if (strcmp(field, "RetrainMode[2]") == 0) {
		return pUserInputAdvanced->RetrainMode[2]; }
	else if (strcmp(field, "RetrainMode[3]") == 0) {
		return pUserInputAdvanced->RetrainMode[3]; }
	else if (strcmp(field, "RetrainMode[4]") == 0) {
		return pUserInputAdvanced->RetrainMode[4]; }
	else if (strcmp(field, "RetrainMode[5]") == 0) {
		return pUserInputAdvanced->RetrainMode[5]; }
	else if (strcmp(field, "RetrainMode[6]") == 0) {
		return pUserInputAdvanced->RetrainMode[6]; }
	else if (strcmp(field, "RetrainMode[7]") == 0) {
		return pUserInputAdvanced->RetrainMode[7]; }
	else if (strcmp(field, "RetrainMode[8]") == 0) {
		return pUserInputAdvanced->RetrainMode[8]; }
	else if (strcmp(field, "RetrainMode[9]") == 0) {
		return pUserInputAdvanced->RetrainMode[9]; }
	else if (strcmp(field, "RetrainMode[10]") == 0) {
		return pUserInputAdvanced->RetrainMode[10]; }
	else if (strcmp(field, "RetrainMode[11]") == 0) {
		return pUserInputAdvanced->RetrainMode[11]; }
	else if (strcmp(field, "RetrainMode[12]") == 0) {
		return pUserInputAdvanced->RetrainMode[12]; }
	else if (strcmp(field, "RetrainMode[13]") == 0) {
		return pUserInputAdvanced->RetrainMode[13]; }
	else if (strcmp(field, "RetrainMode[14]") == 0) {
		return pUserInputAdvanced->RetrainMode[14]; }
	else if (strcmp(field, "RxVrefDACEnable[0]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[0]; }
	else if (strcmp(field, "RxVrefDACEnable[1]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[1]; }
	else if (strcmp(field, "RxVrefDACEnable[2]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[2]; }
	else if (strcmp(field, "RxVrefDACEnable[3]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[3]; }
	else if (strcmp(field, "RxVrefDACEnable[4]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[4]; }
	else if (strcmp(field, "RxVrefDACEnable[5]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[5]; }
	else if (strcmp(field, "RxVrefDACEnable[6]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[6]; }
	else if (strcmp(field, "RxVrefDACEnable[7]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[7]; }
	else if (strcmp(field, "RxVrefDACEnable[8]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[8]; }
	else if (strcmp(field, "RxVrefDACEnable[9]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[9]; }
	else if (strcmp(field, "RxVrefDACEnable[10]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[10]; }
	else if (strcmp(field, "RxVrefDACEnable[11]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[11]; }
	else if (strcmp(field, "RxVrefDACEnable[12]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[12]; }
	else if (strcmp(field, "RxVrefDACEnable[13]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[13]; }
	else if (strcmp(field, "RxVrefDACEnable[14]") == 0) {
		return pUserInputAdvanced->RxVrefDACEnable[14]; }
	else if (strcmp(field, "PhyMstrTrainInterval[0]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[0]; }
	else if (strcmp(field, "PhyMstrTrainInterval[1]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[1]; }
	else if (strcmp(field, "PhyMstrTrainInterval[2]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[2]; }
	else if (strcmp(field, "PhyMstrTrainInterval[3]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[3]; }
	else if (strcmp(field, "PhyMstrTrainInterval[4]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[4]; }
	else if (strcmp(field, "PhyMstrTrainInterval[5]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[5]; }
	else if (strcmp(field, "PhyMstrTrainInterval[6]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[6]; }
	else if (strcmp(field, "PhyMstrTrainInterval[7]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[7]; }
	else if (strcmp(field, "PhyMstrTrainInterval[8]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[8]; }
	else if (strcmp(field, "PhyMstrTrainInterval[9]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[9]; }
	else if (strcmp(field, "PhyMstrTrainInterval[10]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[10]; }
	else if (strcmp(field, "PhyMstrTrainInterval[11]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[11]; }
	else if (strcmp(field, "PhyMstrTrainInterval[12]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[12]; }
	else if (strcmp(field, "PhyMstrTrainInterval[13]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[13]; }
	else if (strcmp(field, "PhyMstrTrainInterval[14]") == 0) {
		return pUserInputAdvanced->PhyMstrTrainInterval[14]; }
	else if (strcmp(field, "Lp3DramState[0]") == 0) {
		return pUserInputAdvanced->Lp3DramState[0]; }
	else if (strcmp(field, "Lp3DramState[1]") == 0) {
		return pUserInputAdvanced->Lp3DramState[1]; }
	else if (strcmp(field, "Lp3DramState[2]") == 0) {
		return pUserInputAdvanced->Lp3DramState[2]; }
	else if (strcmp(field, "Lp3DramState[3]") == 0) {
		return pUserInputAdvanced->Lp3DramState[3]; }
	else if (strcmp(field, "Lp3DramState[4]") == 0) {
		return pUserInputAdvanced->Lp3DramState[4]; }
	else if (strcmp(field, "Lp3DramState[5]") == 0) {
		return pUserInputAdvanced->Lp3DramState[5]; }
	else if (strcmp(field, "Lp3DramState[6]") == 0) {
		return pUserInputAdvanced->Lp3DramState[6]; }
	else if (strcmp(field, "Lp3DramState[7]") == 0) {
		return pUserInputAdvanced->Lp3DramState[7]; }
	else if (strcmp(field, "Lp3DramState[8]") == 0) {
		return pUserInputAdvanced->Lp3DramState[8]; }
	else if (strcmp(field, "Lp3DramState[9]") == 0) {
		return pUserInputAdvanced->Lp3DramState[9]; }
	else if (strcmp(field, "Lp3DramState[10]") == 0) {
		return pUserInputAdvanced->Lp3DramState[10]; }
	else if (strcmp(field, "Lp3DramState[11]") == 0) {
		return pUserInputAdvanced->Lp3DramState[11]; }
	else if (strcmp(field, "Lp3DramState[12]") == 0) {
		return pUserInputAdvanced->Lp3DramState[12]; }
	else if (strcmp(field, "Lp3DramState[13]") == 0) {
		return pUserInputAdvanced->Lp3DramState[13]; }
	else if (strcmp(field, "Lp3DramState[14]") == 0) {
		return pUserInputAdvanced->Lp3DramState[14]; }
	else if (strcmp(field, "PmuClockDiv[0]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[0]; }
	else if (strcmp(field, "PmuClockDiv[1]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[1]; }
	else if (strcmp(field, "PmuClockDiv[2]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[2]; }
	else if (strcmp(field, "PmuClockDiv[3]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[3]; }
	else if (strcmp(field, "PmuClockDiv[4]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[4]; }
	else if (strcmp(field, "PmuClockDiv[5]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[5]; }
	else if (strcmp(field, "PmuClockDiv[6]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[6]; }
	else if (strcmp(field, "PmuClockDiv[7]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[7]; }
	else if (strcmp(field, "PmuClockDiv[8]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[8]; }
	else if (strcmp(field, "PmuClockDiv[9]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[9]; }
	else if (strcmp(field, "PmuClockDiv[10]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[10]; }
	else if (strcmp(field, "PmuClockDiv[11]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[11]; }
	else if (strcmp(field, "PmuClockDiv[12]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[12]; }
	else if (strcmp(field, "PmuClockDiv[13]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[13]; }
	else if (strcmp(field, "PmuClockDiv[14]") == 0) {
		return pUserInputAdvanced->PmuClockDiv[14]; }
	else if (strcmp(field, "WDQSExt") == 0) {
		return pUserInputAdvanced->WDQSExt; }
	else if (strcmp(field, "DisablePhyUpdate") == 0) {
		return pUserInputAdvanced->DisablePhyUpdate; }
	else if (strcmp(field, "OdtImpedanceCa[0]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[0]; }
	else if (strcmp(field, "OdtImpedanceCa[1]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[1]; }
	else if (strcmp(field, "OdtImpedanceCa[2]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[2]; }
	else if (strcmp(field, "OdtImpedanceCa[3]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[3]; }
	else if (strcmp(field, "OdtImpedanceCa[4]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[4]; }
	else if (strcmp(field, "OdtImpedanceCa[5]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[5]; }
	else if (strcmp(field, "OdtImpedanceCa[6]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[6]; }
	else if (strcmp(field, "OdtImpedanceCa[7]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[7]; }
	else if (strcmp(field, "OdtImpedanceCa[8]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[8]; }
	else if (strcmp(field, "OdtImpedanceCa[9]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[9]; }
	else if (strcmp(field, "OdtImpedanceCa[10]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[10]; }
	else if (strcmp(field, "OdtImpedanceCa[11]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[11]; }
	else if (strcmp(field, "OdtImpedanceCa[12]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[12]; }
	else if (strcmp(field, "OdtImpedanceCa[13]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[13]; }
	else if (strcmp(field, "OdtImpedanceCa[14]") == 0) {
		return pUserInputAdvanced->OdtImpedanceCa[14]; }
	else if (strcmp(field, "SkipFlashCopy[0]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[0]; }
	else if (strcmp(field, "SkipFlashCopy[1]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[1]; }
	else if (strcmp(field, "SkipFlashCopy[2]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[2]; }
	else if (strcmp(field, "SkipFlashCopy[3]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[3]; }
	else if (strcmp(field, "SkipFlashCopy[4]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[4]; }
	else if (strcmp(field, "SkipFlashCopy[5]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[5]; }
	else if (strcmp(field, "SkipFlashCopy[6]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[6]; }
	else if (strcmp(field, "SkipFlashCopy[7]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[7]; }
	else if (strcmp(field, "SkipFlashCopy[8]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[8]; }
	else if (strcmp(field, "SkipFlashCopy[9]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[9]; }
	else if (strcmp(field, "SkipFlashCopy[10]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[10]; }
	else if (strcmp(field, "SkipFlashCopy[11]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[11]; }
	else if (strcmp(field, "SkipFlashCopy[12]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[12]; }
	else if (strcmp(field, "SkipFlashCopy[13]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[13]; }
	else if (strcmp(field, "SkipFlashCopy[14]") == 0) {
		return pUserInputAdvanced->SkipFlashCopy[14]; }
	else if (strcmp(field, "DqsOscRunTimeSel[0]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[0]; }
	else if (strcmp(field, "DqsOscRunTimeSel[1]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[1]; }
	else if (strcmp(field, "DqsOscRunTimeSel[2]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[2]; }
	else if (strcmp(field, "DqsOscRunTimeSel[3]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[3]; }
	else if (strcmp(field, "DqsOscRunTimeSel[4]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[4]; }
	else if (strcmp(field, "DqsOscRunTimeSel[5]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[5]; }
	else if (strcmp(field, "DqsOscRunTimeSel[6]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[6]; }
	else if (strcmp(field, "DqsOscRunTimeSel[7]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[7]; }
	else if (strcmp(field, "DqsOscRunTimeSel[8]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[8]; }
	else if (strcmp(field, "DqsOscRunTimeSel[9]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[9]; }
	else if (strcmp(field, "DqsOscRunTimeSel[10]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[10]; }
	else if (strcmp(field, "DqsOscRunTimeSel[11]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[11]; }
	else if (strcmp(field, "DqsOscRunTimeSel[12]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[12]; }
	else if (strcmp(field, "DqsOscRunTimeSel[13]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[13]; }
	else if (strcmp(field, "DqsOscRunTimeSel[14]") == 0) {
		return pUserInputAdvanced->DqsOscRunTimeSel[14]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[0]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[0]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[1]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[1]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[2]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[2]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[3]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[3]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[4]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[4]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[5]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[5]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[6]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[6]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[7]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[7]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[8]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[8]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[9]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[9]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[10]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[10]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[11]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[11]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[12]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[12]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[13]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[13]; }
	else if (strcmp(field, "RxBiasCurrentControlCk[14]") == 0) {
		return pUserInputAdvanced->RxBiasCurrentControlCk[14]; }
	else if (strcmp(field, "tWCK2DQO") == 0) {
		return pUserInputSim->tWCK2DQO; }
	else if (strcmp(field, "tWCK2DQI") == 0) {
		return pUserInputSim->tWCK2DQI; }
	else if (strcmp(field, "tWCK2CK") == 0) {
		return pUserInputSim->tWCK2CK; }
	else if (strcmp(field, "PHY_tDQS2DQ") == 0) {
		return pUserInputSim->PHY_tDQS2DQ; }
	dwc_ddrphy_phyinit_assert(0, " [%s] Invalid field : %s\n", __func__, field);
	return -1;
}

/** @} */
