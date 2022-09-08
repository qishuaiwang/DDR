
/** \file
 * \brief initializes PhyInit input data structures to sane values.
 */
#include <string.h>
#include "dwc_ddrphy_phyinit.h"

/**
 *  \addtogroup SrcFunc
 *  @{
 */

/** @brief  This is used to initialize the PhyInit structures before user defaults and overrides are applied.
 *
 * @return Void
 */
void dwc_ddrphy_phyinit_initStruct(phyinit_config_t *phyctx  /**< phyctx phyinit context */)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	user_input_sim_t *pUserInputSim = &phyctx->userInputSim;

	PMU_SMB_LPDDR4X_1D_t *mb1D = phyctx->mb_LPDDR4X_1D;

	dwc_ddrphy_phyinit_print("// [%s] Start of %s\n", __func__, __func__);

	PMU_SMB_LPDDR4X_1D_t *shdw1D = phyctx->shdw_LPDDR4X_1D;

	memset((void *) pUserInputBasic, 0, sizeof(user_input_basic_t)); // Zero out struct contents
	memset((void *) pUserInputAdvanced, 0, sizeof(user_input_advanced_t)); // Zero out struct contents
	memset((void *) pUserInputSim, 0, sizeof(user_input_sim_t)); // Zero out struct contents

	// ##############################################################
	// userInputBasic - Basic Inputs the user must provide values
	// for detailed descriptions of each field see src/dwc_ddrphy_phyinit_struct.h
	// ##############################################################
	pUserInputBasic->DramType = LPDDR4;
#ifndef _SINGLE_PROTOCOL
	DramType = pUserInputBasic->DramType; // Don't change or remove this instruction
#endif
	pUserInputBasic->DimmType = UDIMM;
	pUserInputBasic->HardMacroVer = 1; //default: HardMacro family B

	_IF_LPDDR4(
#ifdef _BUILD_LPDDR4X
		pUserInputBasic->Lp4xMode = 0x0001; // Don't change or remove this instruction
#else
		pUserInputBasic->Lp4xMode = 0x0000; // Don't change or remove this instruction
#endif
    pUserInputBasic->NumDbytesPerCh           = 0x0002;
    pUserInputBasic->NumCh                    = 0x0002;
    pUserInputBasic->NumRank                  = 0x0001;
    pUserInputBasic->NumActiveDbyteDfi0       = 0x0002;
    pUserInputBasic->NumActiveDbyteDfi1       = 0x0002;
    pUserInputBasic->NumRank_dfi0             = 0x0001; // 2 ranks each controlled by dfi0 and dfi1 correspondingly.
    pUserInputBasic->NumRank_dfi1             = 0x0001; //
    pUserInputBasic->NumPStates               = 0x0001; // 1 Pstate
    pUserInputBasic->CfgPStates               = 0x0001; // 1 Pstate
    pUserInputBasic->FirstPState              = 0x0000;

    pUserInputBasic->Frequency[0]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[0]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[0]      = 0x2;
    pUserInputBasic->Frequency[1]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[1]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[1]      = 0x2;
    pUserInputBasic->Frequency[2]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[2]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[2]      = 0x2;
    pUserInputBasic->Frequency[3]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[3]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[3]      = 0x2;
    pUserInputBasic->Frequency[4]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[4]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[4]      = 0x2;
    pUserInputBasic->Frequency[5]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[5]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[5]      = 0x2;
    pUserInputBasic->Frequency[6]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[6]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[6]      = 0x2;
    pUserInputBasic->Frequency[7]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[7]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[7]      = 0x1;
    pUserInputBasic->Frequency[8]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[8]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[8]      = 0x1;
    pUserInputBasic->Frequency[9]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[9]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[9]      = 0x1;
    pUserInputBasic->Frequency[10]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[10]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[10]      = 0x1;
    pUserInputBasic->Frequency[11]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[11]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[11]      = 0x1;
    pUserInputBasic->Frequency[12]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[12]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[12]      = 0x1;
    pUserInputBasic->Frequency[13]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[13]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[13]      = 0x1;
    pUserInputBasic->Frequency[14]         = 1600; // 3200Mbps for both 1:2 and 1:4 mode  
    pUserInputBasic->PllBypass[14]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[14]      = 0x1;
		pUserInputBasic->DramDataWidth = 0x0010; //x16
	)

	_IF_LPDDR5(
		pUserInputBasic->NumDbytesPerCh = 0x0002;
		pUserInputBasic->NumCh = 0x0002;
		pUserInputBasic->NumRank = 0x0001;
		pUserInputBasic->NumActiveDbyteDfi0 = 0x0002;
		pUserInputBasic->NumActiveDbyteDfi1 = 0x0002;
		pUserInputBasic->NumRank_dfi0 = 0x0001; // 2 ranks each controlled by dfi0 and dfi1 correspondingly.
		pUserInputBasic->NumRank_dfi1 = 0x0001; //
		pUserInputBasic->NumPStates = 0x0001; // 1 Pstate
		pUserInputBasic->CfgPStates = 0x0001; // 1 Pstate
		pUserInputBasic->FirstPState = 0x0000;
		pUserInputBasic->DramDataWidth = 0x0010; //x16
		pUserInputBasic->MaxNumZQ = 0x0004;

    pUserInputBasic->Frequency[0]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[0]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[0]      = 0x2;
    pUserInputBasic->Frequency[1]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[1]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[1]      = 0x2;
    pUserInputBasic->Frequency[2]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[2]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[2]      = 0x2;
    pUserInputBasic->Frequency[3]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[3]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[3]      = 0x2;
    pUserInputBasic->Frequency[4]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[4]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[4]      = 0x2;
    pUserInputBasic->Frequency[5]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[5]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[5]      = 0x2;
    pUserInputBasic->Frequency[6]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[6]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[6]      = 0x2;
    pUserInputBasic->Frequency[7]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[7]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[7]      = 0x1;
    pUserInputBasic->Frequency[8]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[8]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[8]      = 0x1;
    pUserInputBasic->Frequency[9]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[9]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[9]      = 0x1;
    pUserInputBasic->Frequency[10]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[10]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[10]      = 0x1;
    pUserInputBasic->Frequency[11]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[11]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[11]      = 0x1;
    pUserInputBasic->Frequency[12]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[12]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[12]      = 0x1;
    pUserInputBasic->Frequency[13]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[13]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[13]      = 0x1;
    pUserInputBasic->Frequency[14]         = 400; // 3200Mbps for 1:4 mode, 1600 Mbps for 1:2 mode
    pUserInputBasic->PllBypass[14]         = 0x0000;
    pUserInputBasic->DfiFreqRatio[14]      = 0x1;

)

    // ##############################################################
    // userInputAdvnaced (Optional)
    // Default values will be used if no input provided
    // ##############################################################

    pUserInputAdvanced->PsDmaRamSize            = 2;
    pUserInputAdvanced->SkipRetrainEnhancement  = 0x0;
    pUserInputAdvanced->RelockOnlyCntrl         = 0x0;

    pUserInputAdvanced->DramByteSwap            = 0x0;
    pUserInputAdvanced->ExtCalResVal            = 120; // 120 Ohm
    pUserInputAdvanced->PhyVrefCode             = 0x14;

    // Pstate 0 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[0]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[0]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[0]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[0]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[0]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[0]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[0]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[0]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[0]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[0]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[0]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[0]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[0]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[0]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[0]        = 60;
    pUserInputAdvanced->TxImpedanceAc[0]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[0]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[0]       = 60;
    pUserInputAdvanced->TxImpedanceCk[0]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[0]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[0]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[0]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[0]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[0]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[0]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[0]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[0]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[0]       = 60;

    // Pstate 1 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[1]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[1]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[1]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[1]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[1]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[1]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[1]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[1]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[1]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[1]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[1]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[1]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[1]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[1]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[1]        = 60;
    pUserInputAdvanced->TxImpedanceAc[1]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[1]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[1]       = 60;
    pUserInputAdvanced->TxImpedanceCk[1]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[1]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[1]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[1]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[1]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[1]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[1]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[1]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[1]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[1]       = 60;

    // Pstate 2 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[2]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[2]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[2]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[2]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[2]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[2]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[2]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[2]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[2]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[2]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[2]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[2]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[2]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[2]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[2]        = 60;
    pUserInputAdvanced->TxImpedanceAc[2]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[2]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[2]       = 60;
    pUserInputAdvanced->TxImpedanceCk[2]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[2]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[2]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[2]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[2]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[2]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[2]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[2]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[2]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[2]       = 60;

    // Pstate 3 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[3]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[3]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[3]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[3]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[3]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[3]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[3]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[3]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[3]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[3]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[3]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[3]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[3]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[3]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[3]        = 60;
    pUserInputAdvanced->TxImpedanceAc[3]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[3]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[3]       = 60;
    pUserInputAdvanced->TxImpedanceCk[3]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[3]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[3]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[3]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[3]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[3]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[3]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[3]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[3]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[3]       = 60;

    // Pstate 4 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[4]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[4]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[4]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[4]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[4]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[4]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[4]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[4]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[4]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[4]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[4]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[4]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[4]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[4]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[4]        = 60;
    pUserInputAdvanced->TxImpedanceAc[4]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[4]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[4]       = 60;
    pUserInputAdvanced->TxImpedanceCk[4]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[4]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[4]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[4]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[4]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[4]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[4]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[4]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[4]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[4]       = 60;

    // Pstate 5 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[5]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[5]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[5]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[5]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[5]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[5]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[5]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[5]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[5]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[5]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[5]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[5]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[5]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[5]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[5]        = 60;
    pUserInputAdvanced->TxImpedanceAc[5]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[5]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[5]       = 60;
    pUserInputAdvanced->TxImpedanceCk[5]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[5]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[5]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[5]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[5]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[5]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[5]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[5]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[5]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[5]       = 60;

    // Pstate 6 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[6]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[6]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[6]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[6]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[6]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[6]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[6]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[6]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[6]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[6]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[6]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[6]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[6]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[6]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[6]        = 60;
    pUserInputAdvanced->TxImpedanceAc[6]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[6]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[6]       = 60;
    pUserInputAdvanced->TxImpedanceCk[6]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[6]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[6]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[6]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[6]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[6]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[6]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[6]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[6]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[6]       = 60;

    // Pstate 7 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[7]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[7]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[7]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[7]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[7]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[7]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[7]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[7]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[7]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[7]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[7]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[7]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[7]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[7]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[7]        = 60;
    pUserInputAdvanced->TxImpedanceAc[7]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[7]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[7]       = 60;
    pUserInputAdvanced->TxImpedanceCk[7]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[7]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[7]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[7]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[7]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[7]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[7]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[7]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[7]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[7]       = 60;

    // Pstate 8 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[8]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[8]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[8]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[8]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[8]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[8]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[8]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[8]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[8]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[8]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[8]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[8]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[8]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[8]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[8]        = 60;
    pUserInputAdvanced->TxImpedanceAc[8]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[8]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[8]       = 60;
    pUserInputAdvanced->TxImpedanceCk[8]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[8]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[8]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[8]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[8]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[8]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[8]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[8]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[8]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[8]       = 60;

    // Pstate 9 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[9]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[9]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[9]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[9]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[9]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[9]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[9]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[9]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[9]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[9]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[9]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[9]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[9]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[9]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[9]        = 60;
    pUserInputAdvanced->TxImpedanceAc[9]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[9]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[9]       = 60;
    pUserInputAdvanced->TxImpedanceCk[9]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[9]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[9]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[9]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[9]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[9]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[9]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[9]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[9]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[9]       = 60;

    // Pstate 10 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[10]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[10]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[10]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[10]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[10]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[10]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[10]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[10]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[10]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[10]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[10]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[10]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[10]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[10]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[10]        = 60;
    pUserInputAdvanced->TxImpedanceAc[10]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[10]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[10]       = 60;
    pUserInputAdvanced->TxImpedanceCk[10]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[10]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[10]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[10]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[10]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[10]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[10]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[10]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[10]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[10]       = 60;

    // Pstate 11 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[11]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[11]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[11]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[11]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[11]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[11]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[11]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[11]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[11]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[11]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[11]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[11]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[11]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[11]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[11]        = 60;
    pUserInputAdvanced->TxImpedanceAc[11]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[11]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[11]       = 60;
    pUserInputAdvanced->TxImpedanceCk[11]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[11]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[11]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[11]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[11]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[11]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[11]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[11]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[11]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[11]       = 60;

    // Pstate 12 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[12]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[12]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[12]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[12]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[12]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[12]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[12]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[12]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[12]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[12]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[12]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[12]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[12]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[12]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[12]        = 60;
    pUserInputAdvanced->TxImpedanceAc[12]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[12]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[12]       = 60;
    pUserInputAdvanced->TxImpedanceCk[12]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[12]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[12]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[12]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[12]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[12]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[12]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[12]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[12]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[12]       = 60;

    // Pstate 13 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[13]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[13]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[13]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[13]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[13]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[13]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[13]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[13]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[13]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[13]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[13]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[13]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[13]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[13]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[13]        = 60;
    pUserInputAdvanced->TxImpedanceAc[13]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[13]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[13]       = 60;
    pUserInputAdvanced->TxImpedanceCk[13]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[13]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[13]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[13]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[13]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[13]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[13]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[13]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[13]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[13]       = 60;

    // Pstate 14 - Analog Settings
    pUserInputAdvanced->SkipFlashCopy[14]        = 0x0;
    pUserInputAdvanced->TxSlewRiseDq[14]         = 0x0;
    pUserInputAdvanced->TxSlewFallDq[14]         = 0x0;
    pUserInputAdvanced->TxSlewRiseDqs[14]        = 0x0;
    pUserInputAdvanced->TxSlewFallDqs[14]        = 0x0;
    pUserInputAdvanced->TxSlewRiseCA[14]         = 0x0;
    pUserInputAdvanced->TxSlewFallCA[14]         = 0x0;
_IF_LPDDR4(
    pUserInputAdvanced->TxSlewRiseCS[14]         = 0x0;
    pUserInputAdvanced->TxSlewFallCS[14]         = 0x0;
)
    pUserInputAdvanced->TxSlewRiseCK[14]         = 0x0;
    pUserInputAdvanced->TxSlewFallCK[14]         = 0x0;
_IF_LPDDR5(
    pUserInputAdvanced->TxSlewRiseWCK[14]        = 0x0;
    pUserInputAdvanced->TxSlewFallWCK[14]        = 0x0;
)
    pUserInputAdvanced->CkDisVal[14]             = 0x0000;
    pUserInputAdvanced->TxImpedanceDq[14]        = 60;
    pUserInputAdvanced->TxImpedanceAc[14]        = 60;
_IF_LPDDR4(
    pUserInputAdvanced->TxImpedanceCs[14]        = 60;
)
    pUserInputAdvanced->TxImpedanceDqs[14]       = 60;
    pUserInputAdvanced->TxImpedanceCk[14]        = 60;
    pUserInputAdvanced->TxImpedanceCKE[14]       = 50;
    pUserInputAdvanced->TxImpedanceDTO[14]       = 50;
_IF_LPDDR5(
    pUserInputAdvanced->TxImpedanceWCK[14]       = 60;
    pUserInputAdvanced->OdtImpedanceWCK[14]      = 60;
)
_IF_LPDDR4(
    pUserInputAdvanced->OdtImpedanceCs[14]       = 60;
)
    pUserInputAdvanced->OdtImpedanceDq[14]       = 60;
    pUserInputAdvanced->OdtImpedanceDqs[14]      = 60;
    pUserInputAdvanced->OdtImpedanceCa[14]       = 60;
    pUserInputAdvanced->OdtImpedanceCk[14]       = 60;


    pUserInputAdvanced->DisableRetraining       = 0x0;
    pUserInputAdvanced->DisableFspOp            = 0x0;

    pUserInputAdvanced->CalInterval             = 0x0009;
    pUserInputAdvanced->CalOnce                 = 0x0000;
    pUserInputAdvanced->CalImpedanceCurrentAdjustment = 0x0000;

    pUserInputAdvanced->DisablePmuEcc           = 0x0;
    pUserInputAdvanced->DisableTDRAccess        = 0x0;
    pUserInputAdvanced->WDQSExt                 = 0x0000;

    for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
        pUserInputAdvanced->EnRxDqsTracking[pstate]       = 0;
        pUserInputAdvanced->RxDfeMode[pstate]             = 0x0000;
        pUserInputAdvanced->PmuClockDiv[pstate]           = 0x1;
        pUserInputAdvanced->PhyMstrTrainInterval[pstate]  = 0x000a;
        pUserInputAdvanced->PhyMstrMaxReqToAck[pstate]    = 0x0005;
        pUserInputAdvanced->PhyMstrCtrlMode[pstate]       = 0x0001;
        pUserInputAdvanced->RxClkTrackEn[pstate]          = 0;
        pUserInputAdvanced->RxDqsTrackingThreshold[pstate]= 0x1;
        pUserInputAdvanced->DqsOscRunTimeSel[pstate]      = 0x3;
        pUserInputAdvanced->RxBiasCurrentControlCk[pstate] = 0x5;
        pUserInputAdvanced->RxBiasCurrentControlDqs[pstate] = 0x5;
        pUserInputAdvanced->RxBiasCurrentControlRxReplica[pstate] = 0x5;
        pUserInputAdvanced->RxModeBoostVDD[pstate]      = 0;
        pUserInputAdvanced->RxVrefDACEnable[pstate]     = 1;
        pUserInputAdvanced->RxVrefKickbackNoiseCancellation[pstate] = 1;
_IF_LPDDR5(
        pUserInputAdvanced->EnWck2DqoTracking[pstate]     = 0;
        pUserInputAdvanced->RxBiasCurrentControlWck[pstate] = 0x5;
)
    }

    pUserInputAdvanced->DisablePhyUpdate         = 0x0000;

	uint16_t RL[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint16_t WL[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint16_t nWR[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#ifdef _BUILD_LPDDR5
	uint16_t CKR[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint16_t WckFm[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint16_t Wck2DqFm[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif

_IF_LPDDR4(
    for (int pstate=0; pstate<DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE;pstate++) {

        if ( pUserInputBasic->Frequency[pstate] <= 266 ) {
            RL[pstate]         = 0x0000;
            WL[pstate]         = 0x0000;
            nWR[pstate]        = 0x0000;
        }
        else if ( pUserInputBasic->Frequency[pstate] <= 533) {
            RL[pstate]         = 0x0001;
            WL[pstate]         = 0x0001;
            nWR[pstate]        = 0x0001;
        }
        else if ( pUserInputBasic->Frequency[pstate] <= 800) {
            RL[pstate]         = 0x0002;
            WL[pstate]         = 0x0002;
            nWR[pstate]        = 0x0002;
        }
        else if ( pUserInputBasic->Frequency[pstate] <= 1066) {
            RL[pstate]         = 0x0003;
            WL[pstate]         = 0x0003;
            nWR[pstate]        = 0x0003;
        }
        else if ( pUserInputBasic->Frequency[pstate] <= 1333) {
            RL[pstate]         = 0x0004;
            WL[pstate]         = 0x0004;
            nWR[pstate]        = 0x0004;
        }
        else if ( pUserInputBasic->Frequency[pstate] <= 1600) {
            RL[pstate]         = 0x0005;
            WL[pstate]         = 0x0005;
            nWR[pstate]        = 0x0005;
        }
        else if ( pUserInputBasic->Frequency[pstate] <= 1866) {
            RL[pstate]         = 0x0006;
            WL[pstate]         = 0x0006;
            nWR[pstate]        = 0x0006;
        }
        else {
            RL[pstate]         = 0x0007;
            WL[pstate]         = 0x0007;
            nWR[pstate]        = 0x0007;
        }
    }
)

_IF_LPDDR5(
    for (int pstate=0; pstate<DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE;pstate++) {

        if ( pUserInputBasic->DfiFreqRatio[pstate] == 0x1 ) {
            CKR[pstate] = 1;

            if ( pUserInputBasic->Frequency[pstate] <= 133 ) {
                RL[pstate]         = 0x0000;
                WL[pstate]         = 0x0000;
                nWR[pstate]        = 0x0000;
            } else if ( pUserInputBasic->Frequency[pstate] <= 267) {
                RL[pstate]         = 0x0001;
                WL[pstate]         = 0x0001;
                nWR[pstate]        = 0x0001;
            } else if ( pUserInputBasic->Frequency[pstate] <= 400) {
                RL[pstate]         = 0x0002;
                WL[pstate]         = 0x0002;
                nWR[pstate]        = 0x0002;
            } else if ( pUserInputBasic->Frequency[pstate] <= 533) {
                RL[pstate]         = 0x0003;
                WL[pstate]         = 0x0003;
                nWR[pstate]        = 0x0003;
            } else if ( pUserInputBasic->Frequency[pstate] <= 688) {
                RL[pstate]         = 0x0004;
                WL[pstate]         = 0x0004;
                nWR[pstate]        = 0x0004;
            } else {
                RL[pstate]         = 0x0005;
                WL[pstate]         = 0x0005;
                nWR[pstate]        = 0x0005;
            }
        } else {
            CKR[pstate] = 0;

            if ( pUserInputBasic->Frequency[pstate] <= 67 ) {
                RL[pstate]         = 0x0000;
                WL[pstate]         = 0x0000;
                nWR[pstate]        = 0x0000;
            } else if ( pUserInputBasic->Frequency[pstate] <= 133) {
                RL[pstate]         = 0x0001;
                WL[pstate]         = 0x0001;
                nWR[pstate]        = 0x0001;
            } else if ( pUserInputBasic->Frequency[pstate] <= 200) {
                RL[pstate]         = 0x0002;
                WL[pstate]         = 0x0002;
                nWR[pstate]        = 0x0002;
            } else if ( pUserInputBasic->Frequency[pstate] <= 267) {
                RL[pstate]         = 0x0003;
                WL[pstate]         = 0x0003;
                nWR[pstate]        = 0x0003;
            } else if ( pUserInputBasic->Frequency[pstate] <= 344) {
                RL[pstate]         = 0x0004;
                WL[pstate]         = 0x0004;
                nWR[pstate]        = 0x0004;
            } else if ( pUserInputBasic->Frequency[pstate] <= 400) {
                RL[pstate]         = 0x0005;
                WL[pstate]         = 0x0005;
                nWR[pstate]        = 0x0005;
            } else if ( pUserInputBasic->Frequency[pstate] <= 467) {
                RL[pstate]         = 0x0006;
                WL[pstate]         = 0x0006;
                nWR[pstate]        = 0x0006;
            } else if ( pUserInputBasic->Frequency[pstate] <= 533) {
                RL[pstate]         = 0x0007;
                WL[pstate]         = 0x0007;
                nWR[pstate]        = 0x0007;
            } else if ( pUserInputBasic->Frequency[pstate] <= 600) {
                RL[pstate]         = 0x0008;
                WL[pstate]         = 0x0008;
                nWR[pstate]        = 0x0008;
            } else if ( pUserInputBasic->Frequency[pstate] <= 688) {
                RL[pstate]         = 0x0009;
                WL[pstate]         = 0x0009;
                nWR[pstate]        = 0x0009;
            } else if ( pUserInputBasic->Frequency[pstate] <= 750) {
                RL[pstate]         = 0x000a;
                WL[pstate]         = 0x000a;
                nWR[pstate]        = 0x000a;
            } else {
                RL[pstate]         = 0x000b;
                WL[pstate]         = 0x000b;
                nWR[pstate]        = 0x000b;
            }

        }

        if ( (pUserInputBasic->Frequency[pstate] << pUserInputBasic->DfiFreqRatio[pstate]) < 1600 ) {
            WckFm[pstate] = 0;
            Wck2DqFm[pstate] = 0;
        } else {
            WckFm[pstate] = 1;
            Wck2DqFm[pstate] = 1;
        }

    }
)

    pUserInputAdvanced->OnlyRestoreNonPsRegs = (pUserInputBasic->NumPStates >2) ? 1 : 0;
    pUserInputAdvanced->RetrainMode[0]  = 1;
    pUserInputAdvanced->RetrainMode[1]  = 1;
    pUserInputAdvanced->RetrainMode[2]  = 1;
    pUserInputAdvanced->RetrainMode[3]  = 1;
    pUserInputAdvanced->RetrainMode[4]  = 1;
    pUserInputAdvanced->RetrainMode[5]  = 1;
    pUserInputAdvanced->RetrainMode[6]  = 1;
    pUserInputAdvanced->RetrainMode[7]  = 1;
    pUserInputAdvanced->RetrainMode[8]  = 1;
    pUserInputAdvanced->RetrainMode[9]  = 1;
    pUserInputAdvanced->RetrainMode[10] = 1;
    pUserInputAdvanced->RetrainMode[11] = 1;
    pUserInputAdvanced->RetrainMode[12] = 1;
    pUserInputAdvanced->RetrainMode[13] = 1;
    pUserInputAdvanced->RetrainMode[14] = 1;

	// ##############################################################
	// Basic Message Block Variables
	// ##############################################################

	uint8_t myps;

	// ##############################################################
	// These are typically invariant across Pstate
	// ##############################################################
	uint8_t Misc = 0x00;
	uint8_t MsgMisc = 0x06; //For fast simulation
	uint8_t Reserved00 = 0x0;	// Set Reserved00[7]   = 1 (If using T28 attenuated receivers)
								// Set Reserved00[6:0] = 0 (Reserved; must be programmed to 0)

	// 2D Training Miscellaneous Control
	// Train2DMisc[0]: Print Verbose 2D Eye Contour
	//   0 = Do Not Print Verbose Eye Contour  (default behavior)
	// Train2DMisc[1]: Print Verbose Eye Optimization Output
	//   0 = Do Not Print Verbose Eye Optimization Output  (default behavior)
	// Train2DMisc[5:2]: Iteration Count for Optimization Algorithm
	// Iteration count = Train2DMisc[5:2] << 1
	// iteration count == 2 early termination
	// Train2DMisc[7:6]: Number of Seeds for Optimization Algorithm
	// 0 = 2 seeds, left and right of center, default behavior
	// Train2DMisc[8]: Print Eye Contours prior to optimization
	// 0 = Do Not Print Eye Contours prior to optimization (default behavior)
	// Train2DMisc[9]: Print full eye contours (instead of half)
	// 0 = Print Half Eye Contours (default behavior)
	// Train2DMisc[10]: Use weighted mean algorithm for optimization of RX compounded eyes with DFE
	// 0 = Use largest empty circle hill climb (default behavior)
	// Train2DMisc[12:11]: Weighted mean algorithm bias function.
	// 0 = Use regular weighted mean
	uint16_t Train2DMisc = (0x0001 << 2); // Early Termination

	uint8_t HdtCtrl = 0xff;
	uint8_t DFIMRLMargin = 0x02;
	uint8_t CATerminatingRankChA = 0x00; //Usually Rank0 is terminating rank
	uint8_t CATerminatingRankChB = 0x00; //Usually Rank0 is terminating rank
#ifdef _BUILD_LPDDR4
	uint8_t PuCal = 0x01;
#endif
	// ##############################################################
	// These typically change across Pstate
	// ##############################################################

	uint16_t SequenceCtrl[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	uint8_t mr1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr2[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr3[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#ifdef _BUILD_LPDDR4
	uint8_t mr4[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
#ifdef _BUILD_LPDDR5
	uint8_t mr10[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
	uint8_t mr11[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr12[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr13[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr14[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#ifdef _BUILD_LPDDR5
	uint8_t mr15[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
	uint8_t mr16[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#ifdef _BUILD_LPDDR4
	uint8_t mr17[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
#ifdef _BUILD_LPDDR5
	uint8_t mr17_rank0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr17_rank1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
#ifdef _BUILD_LPDDR5
	uint8_t mr18[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr19[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr20[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
	uint8_t mr21[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#ifdef _BUILD_LPDDR4
	uint8_t mr22_rank0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr22_rank1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
#ifdef _BUILD_LPDDR5
	uint8_t mr22[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
	uint8_t mr24[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#ifdef _BUILD_LPDDR5
	uint8_t mr28[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	uint8_t mr41[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif
#ifdef _BUILD_LPDDR4
	uint8_t mr51[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif

	for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
		SequenceCtrl[pstate] = 0x131f; // Training steps to run in PState 0
	}

	uint16_t WLS[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t DbiRd[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t DbiWr[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t PDDS[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6 };
	uint16_t DqOdt[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4 };
	uint16_t CaOdt[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6, 0x6 };
	uint16_t CaOdtDis_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t CaOdtDis_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t x8OdtL_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t x8OdtL_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t x8OdtU_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t x8OdtU_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
#ifdef _BUILD_LPDDR4
	uint16_t WrPst[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t VrefCa[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd, 0xd };
	uint16_t VrefCaRange[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t VrefDq[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf, 0xf };
	uint16_t VrefDqRange[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t SocOdt_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4 };
	uint16_t SocOdt_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, 0x4 };
	uint16_t CkOdtEn_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t CkOdtEn_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t CsOdtEn_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t CsOdtEn_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t LowSpeedCAbuffer[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 }; //Lp4xMode
	uint16_t SingleEndedClock[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 }; //Lp4xMode
	uint16_t SingleEndedWDQS[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 }; //Lp4xMode
	uint16_t SingleEndedRDQS[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 }; //Lp4xMode
#endif
#ifdef _BUILD_LPDDR5
	uint16_t VrefCa[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50 };
	uint16_t VrefDqL[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50 };
	uint16_t VrefDqU[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50 };
	uint16_t VDLC[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t CkMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t WckMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t RpstMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t WckPst[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t RdqsPre[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t RdqsPst[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t RdqsMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2 };
	uint16_t ZqMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t BKBG[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t SocOdt_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t SocOdt_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t WckOdt[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t NtDqOdt[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3 };
	uint16_t CkOdtDis_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t CkOdtDis_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1 };
	uint16_t CsOdtDis_r0[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t CsOdtDis_r1[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t WckOn[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t DvfsC[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t DvfsQ[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t WdcfeDis[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t RdcfeDis[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t WxfeDis[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t WECC[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t RECC[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t DFES[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t DFEQL[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t DFEQU[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
	uint16_t PPRE[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
#endif

    // 2D Training firmware Variables
    //uint8_t  SequenceCtrl2D[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
    //for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
    //    SequenceCtrl2D[pstate] = 0x0061; // 2D Training Sequince. 2DTX, 2DRX, DevInit
    //}

    // ##############################################################
    // These are per-pstate Control Words for RCD
    // Please enter the correct values for your configuration
    // ##############################################################

    // ##############################################################
    // 95% of users will not need to edit below
    // ##############################################################

_IF_LPDDR5(
    // MR bit packing for LPDDR5
    for ( myps = 0; myps < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE ; myps++) {
        mr1[myps] =
            ( (CkMode[myps]                              << 3) & 0x08) | // CK mode
            ( (WL[myps]                                  << 4) & 0xF0) ; // WL

        mr2[myps] =
            ( (RL[myps]                                  << 0) & 0x0F) | // RL and nRTP
            ( (nWR[myps]                                 << 4) & 0xF0) ; // nWR

        mr3[myps] =
            ( (PDDS[myps]                                << 0) & 0x07) | // PDDS
            ( (BKBG[myps]                                << 3) & 0x18) | // BK/BG
            ( (WLS[myps]                                 << 5) & 0x20) | // WLS
            ( (DbiRd[myps]                               << 6) & 0x40) | // DBI-RD
            ( (DbiWr[myps]                               << 7) & 0x80) ; // DBI-WR

        mr10[myps] =
            ( (RpstMode[myps]                            << 0) & 0x01) | // RPST Mode
            ( (WckPst[myps]                              << 2) & 0x0C) | // WCK PST
            ( (RdqsPre[myps]                             << 4) & 0x30) | // RDQS PRE
            ( (RdqsPst[myps]                             << 6) & 0xC0) ; // RDQS PST

        mr11[myps] =
            ( (DqOdt[myps]                               << 0) & 0x07) | // DQ ODT
            ( (CaOdt[myps]                               << 4) & 0x70) ; // CA ODT

        mr12[myps] =
            ( (VrefCa[myps]                              << 0) & 0x7F) | // VREF CA
            ( (0x0                                       << 7) & 0x80) ; // VBS

        mr13[myps] =
            ( (0x0                                       << 0) & 0x03) | // Thermal Offset
            ( (0x0                                       << 2) & 0x04) | // VRO
            ( (0x0                                       << 5) & 0x20) | // DMD
            ( (0x0                                       << 6) & 0x40) | // CBT Mode
            ( (0x0                                       << 7) & 0x80) ; // Dual VDD2

        mr14[myps] =
            ( (VrefDqL[myps]                             << 0) & 0x7F) | // VREF DQ 7:0
            ( (VDLC[myps]                                << 7) & 0x80) ; // VDLC

        mr15[myps] =
            ( (VrefDqU[myps]                             << 0) & 0x7F) ; // VREF DQ 15:8

        mr16[myps] =
            ( (0x0                                       << 0) & 0x03) | // FSP-WR
            ( (0x0                                       << 2) & 0x0C) | // FSP-OP
            ( (0x0                                       << 4) & 0x30) | // CBT
            ( (0x0                                       << 6) & 0x40) | // VRCG
            ( (0x0                                       << 7) & 0x80) ; // CBT-Phase

        mr17_rank0[myps] =
            ( (SocOdt_r0[myps]                           << 0) & 0x07) | // SOC ODT
            ( (CkOdtDis_r0[myps]                         << 3) & 0x08) | // ODTD-CK
            ( (CsOdtDis_r0[myps]                         << 4) & 0x10) | // ODTD-CS
            ( (CaOdtDis_r0[myps]                         << 5) & 0x20) | // ODTD-CA
            ( (x8OdtL_r0[myps]                           << 6) & 0x40) | // x8ODTD Lower
            ( (x8OdtU_r0[myps]                           << 7) & 0x80) ; // x8ODTD Upper

        mr17_rank1[myps] =
            ( (SocOdt_r1[myps]                           << 0) & 0x07) | // SOC ODT
            ( (CkOdtDis_r1[myps]                         << 3) & 0x08) | // ODTD-CK
            ( (CsOdtDis_r1[myps]                         << 4) & 0x10) | // ODTD-CS
            ( (CaOdtDis_r1[myps]                         << 5) & 0x20) | // ODTD-CA
            ( (x8OdtL_r1[myps]                           << 6) & 0x40) | // x8ODTD Lower
            ( (x8OdtU_r1[myps]                           << 7) & 0x80) ; // x8ODTD Upper

        mr18[myps] =
            ( (WckOdt[myps]                              << 0) & 0x07) | // WCK ODT
            ( (WckFm[myps]                               << 3) & 0x08) | // WCK FM
            ( (WckOn[myps]                               << 4) & 0x10) | // WCK ON
            ( (0x0                                       << 6) & 0x40) | // WCK2CK Leveling
            ( (CKR[myps]                                 << 7) & 0x80) ; // CKR

        mr19[myps] =
            ( (DvfsC[myps]                               << 0) & 0x03) | // DVFSC
            ( (DvfsQ[myps]                               << 2) & 0x0C) | // DVFSQ
            ( (Wck2DqFm[myps]                            << 4) & 0x10) ; // WCK2DQ OSC FM

        mr20[myps] =
            ( (RdqsMode[myps]                            << 0) & 0x03) | // RDQS
            ( (WckMode[myps]                             << 2) & 0x0C) | // WCK mode
            ( (0x0                                       << 4) & 0x10) | // MRWDU
            ( (0x0                                       << 5) & 0x20) | // MRWDL
            ( (0x0                                       << 6) & 0x40) | // RDC DMI mode
            ( (0x0                                       << 7) & 0x80) ; // RDC DQ mode

        mr21[myps] =
            ( (WdcfeDis[myps]                            << 4) & 0x10) | // WDCFE
            ( (RdcfeDis[myps]                            << 5) & 0x20) | // RDCFE
            ( (WxfeDis[myps]                             << 6) & 0x40) ; // WXFE

        mr22[myps] =
            ( (WECC[myps]                                << 4) & 0x30) | // WECC
            ( (RECC[myps]                                << 6) & 0xC0) ; // RECC

        mr24[myps] =
            ( (DFEQL[myps]                               << 0) & 0x07) | // DFEQL
            ( (DFEQU[myps]                               << 4) & 0x70) | // DFEQU
            ( (DFES[myps]                                << 7) & 0x80) ; // DFES

        mr28[myps] =
            ( (0x0                                       << 0) & 0x01) | // ZQ Reset
            ( (0x0                                       << 1) & 0x02) | // ZQ Stop
            ( (0x1                                       << 2) & 0x0C) | // ZQ Interval
            ( (ZqMode[myps]                              << 5) & 0x20) ; // ZQ Mode

        mr41[myps] =
            ( (PPRE[myps]                                << 4) & 0x10) | // PPRE
            ( (NtDqOdt[myps]                             << 5) & 0xE0) ; // NT DQ ODT
    }
)

_IF_LPDDR4(
    // MR bit packing for LPDDR4
    for ( myps = 0; myps < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE ; myps++) {
        mr1[myps] =
            ( (0x0       << 0) & 0x03) |
            ( (0x1       << 2) & 0x04) |
            ( (0x1       << 3) & 0x08) |
            ( (0x1       << 7) & 0x80) |
            ( (nWR[myps] << 4) & 0x70) ;

        mr2[myps] =
            ( (RL[myps]                   << 0) & 0x07) |
            ( (WL[myps]                   << 3) & 0x38) |
            ( (WLS[myps]                  << 6) & 0x40) |
            ( (0x0                        << 7) & 0x80) ;

        mr3[myps] =
            ( (PuCal             << 0) & 0x01) |
            ( (WrPst[myps]       << 1) & 0x02) |
            ( (0x0               << 2) & 0x04) |
            ( (PDDS[myps]        << 3) & 0x38) |
            ( (DbiRd[myps]       << 6) & 0x40) |
            ( (DbiWr[myps]       << 7) & 0x80) ;

        mr4[myps] = 0x0;

        mr11[myps] =
            ( (DqOdt[myps]       << 0) & 0x07) |
            ( (CaOdt[myps]       << 4) & 0x70) ;

        mr12[myps] =
            ( (VrefCa[myps]      << 0) & 0x3f) |
            ( (VrefCaRange[myps] << 6) & 0x40) ;

        mr13[myps] =
            ( (0x0 << 0) & 0x01) | // CBT
            ( (0x0 << 1) & 0x02) | // RPT
            ( (0x0 << 2) & 0x04) | // VRO
            ( (0x1 << 3) & 0x08) | // VRCG
            ( (0x0 << 4) & 0x10) | // RRO
            ( (0x1 << 5) & 0x20) | // DMD
            ( (0x0 << 6) & 0x40) | // FSP-WR
            ( (0x0 << 7) & 0x80) ; // FSP-OP

        mr14[myps] =
            ( (VrefDq[myps]      << 0) & 0x3f) |
            ( (VrefDqRange[myps] << 6) & 0x40) ;

        mr16[myps] = 0x0;
        mr17[myps] = 0x0;

        mr21[myps] = 
            ( pUserInputBasic->Lp4xMode == 0x1)      ? 
            ( (LowSpeedCAbuffer[myps]  << 5) & 0x20) :
            0x0 ;

        mr22_rank0[myps] =
            ( (SocOdt_r0[myps]   << 0) & 0x07) |
            ( (CkOdtEn_r0[myps]  << 3) & 0x08) |
            ( (CsOdtEn_r0[myps]  << 4) & 0x10) |
            ( (CaOdtDis_r0[myps] << 5) & 0x20) |
            ( (x8OdtL_r0[myps]   << 6) & 0x40) |
            ( (x8OdtU_r0[myps]   << 7) & 0x80) ;

        mr22_rank1[myps] =
            ( (SocOdt_r1[myps]   << 0) & 0x07) |
            ( (CkOdtEn_r1[myps]  << 3) & 0x08) |
            ( (CsOdtEn_r1[myps]  << 4) & 0x10) |
            ( (CaOdtDis_r1[myps] << 5) & 0x20) |
            ( (x8OdtL_r1[myps]   << 6) & 0x40) |
            ( (x8OdtU_r1[myps]   << 7) & 0x80) ;

        mr24[myps] = 0x0;

        mr51[myps] =
            ( pUserInputBasic->Lp4xMode == 0x1)    ? (
            ( (SingleEndedClock[myps] << 3) & 0x8) |
            ( (SingleEndedWDQS[myps]  << 2) & 0x4) |
            ( (SingleEndedRDQS[myps]  << 1) & 0x2) ) : 
            0x0;

    } // myps
)



    // 1D message block defaults
    for (myps=0; myps<DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; myps++) {
      // -- Pstate is a derived input set in calcMb
      //mb1D[myps].Pstate               = (pUserInputBasic->NumPStates>2)<<7 | myps;
      mb1D[myps].SequenceCtrl         = SequenceCtrl[myps];
      mb1D[myps].HdtCtrl              = HdtCtrl;
      mb1D[myps].Misc                 = Misc;
      mb1D[myps].MsgMisc              = MsgMisc;
      mb1D[myps].Train2DMisc          = Train2DMisc;
      mb1D[myps].Reserved00           = Reserved00;
      mb1D[myps].DFIMRLMargin         = DFIMRLMargin;

      mb1D[myps].Disable2D            = 0x0000;

      mb1D[myps].EnabledDQsChA        = pUserInputBasic->NumActiveDbyteDfi0 * 8;
      mb1D[myps].CsPresentChA         = (2==pUserInputBasic->NumRank_dfi0) ? 0x3 : pUserInputBasic->NumRank_dfi0;
      mb1D[myps].EnabledDQsChB        = pUserInputBasic->NumActiveDbyteDfi1 * 8;
      mb1D[myps].CsPresentChB         = (2==pUserInputBasic->NumRank_dfi1) ? 0x3 : pUserInputBasic->NumRank_dfi1;

      mb1D[myps].X8Mode               = 0x0000;
   	  mb1D[myps].VrefInc              = 0x1;


_IF_LPDDR5(
      mb1D[myps].CATrainOpt           = 0x0000;

      mb1D[myps].CATerminatingRankChA = CATerminatingRankChA;
      mb1D[myps].CATerminatingRankChB = CATerminatingRankChB;
      mb1D[myps].MR1_A0               = mr1[myps];
      mb1D[myps].MR1_A1               = mr1[myps];
      mb1D[myps].MR1_B0               = mr1[myps];
      mb1D[myps].MR1_B1               = mr1[myps];
      mb1D[myps].MR2_A0               = mr2[myps];
      mb1D[myps].MR2_A1               = mr2[myps];
      mb1D[myps].MR2_B0               = mr2[myps];
      mb1D[myps].MR2_B1               = mr2[myps];
      mb1D[myps].MR3_A0               = mr3[myps];
      mb1D[myps].MR3_A1               = mr3[myps];
      mb1D[myps].MR3_B0               = mr3[myps];
      mb1D[myps].MR3_B1               = mr3[myps];
      mb1D[myps].MR10_A0              = mr10[myps];
      mb1D[myps].MR10_A1              = mr10[myps];
      mb1D[myps].MR10_B0              = mr10[myps];
      mb1D[myps].MR10_B1              = mr10[myps];
      mb1D[myps].MR11_A0              = mr11[myps];
      mb1D[myps].MR11_A1              = mr11[myps];
      mb1D[myps].MR11_B0              = mr11[myps];
      mb1D[myps].MR11_B1              = mr11[myps];
      mb1D[myps].MR12_A0              = mr12[myps];
      mb1D[myps].MR12_A1              = mr12[myps];
      mb1D[myps].MR12_B0              = mr12[myps];
      mb1D[myps].MR12_B1              = mr12[myps];
      mb1D[myps].MR13_A0              = mr13[myps];
      mb1D[myps].MR13_A1              = mr13[myps];
      mb1D[myps].MR13_B0              = mr13[myps];
      mb1D[myps].MR13_B1              = mr13[myps];
      mb1D[myps].MR14_A0              = mr14[myps];
      mb1D[myps].MR14_A1              = mr14[myps];
      mb1D[myps].MR14_B0              = mr14[myps];
      mb1D[myps].MR14_B1              = mr14[myps];
      mb1D[myps].MR15_A0              = mr15[myps];
      mb1D[myps].MR15_A1              = mr15[myps];
      mb1D[myps].MR15_B0              = mr15[myps];
      mb1D[myps].MR15_B1              = mr15[myps];
      mb1D[myps].MR16_A0              = mr16[myps];
      mb1D[myps].MR16_A1              = mr16[myps];
      mb1D[myps].MR16_B0              = mr16[myps];
      mb1D[myps].MR16_B1              = mr16[myps];
      mb1D[myps].MR17_A0              = mr17_rank0[myps];
      mb1D[myps].MR17_A1              = mr17_rank1[myps];
      mb1D[myps].MR17_B0              = mr17_rank0[myps];
      mb1D[myps].MR17_B1              = mr17_rank1[myps];
      mb1D[myps].MR18_A0              = mr18[myps];
      mb1D[myps].MR18_A1              = mr18[myps];
      mb1D[myps].MR18_B0              = mr18[myps];
      mb1D[myps].MR18_B1              = mr18[myps];
      mb1D[myps].MR19_A0              = mr19[myps];
      mb1D[myps].MR19_A1              = mr19[myps];
      mb1D[myps].MR19_B0              = mr19[myps];
      mb1D[myps].MR19_B1              = mr19[myps];
      mb1D[myps].MR20_A0              = mr20[myps];
      mb1D[myps].MR20_A1              = mr20[myps];
      mb1D[myps].MR20_B0              = mr20[myps];
      mb1D[myps].MR20_B1              = mr20[myps];
      mb1D[myps].MR21_A0              = mr21[myps];
      mb1D[myps].MR21_A1              = mr21[myps];
      mb1D[myps].MR21_B0              = mr21[myps];
      mb1D[myps].MR21_B1              = mr21[myps];
      mb1D[myps].MR22_A0              = mr22[myps];
      mb1D[myps].MR22_A1              = mr22[myps];
      mb1D[myps].MR22_B0              = mr22[myps];
      mb1D[myps].MR22_B1              = mr22[myps];
      mb1D[myps].MR24_A0              = mr24[myps];
      mb1D[myps].MR24_A1              = mr24[myps];
      mb1D[myps].MR24_B0              = mr24[myps];
      mb1D[myps].MR24_B1              = mr24[myps];
      mb1D[myps].MR28_A0              = mr28[myps];
      mb1D[myps].MR28_A1              = mr28[myps];
      mb1D[myps].MR28_B0              = mr28[myps];
      mb1D[myps].MR28_B1              = mr28[myps];
      mb1D[myps].MR41_A0              = mr41[myps];
      mb1D[myps].MR41_A1              = mr41[myps];
      mb1D[myps].MR41_B0              = mr41[myps];
      mb1D[myps].MR41_B1              = mr41[myps];
      mb1D[myps].DisableTrainingLoop  = 0x0;
)
_IF_LPDDR4(
#ifdef _BUILD_LPDDR4X
      mb1D[myps].LP4XMode             = 0x0001; // Don't change or remove this instruction
#else
      mb1D[myps].LP4XMode             = 0x0000; // Don't change or remove this instruction
#endif
			mb1D[myps].CATerminatingRankChA = CATerminatingRankChA;
			mb1D[myps].CATerminatingRankChB = CATerminatingRankChB;
			mb1D[myps].Quickboot = 0x0000;
			mb1D[myps].CATrainOpt = 0x0000;
			mb1D[myps].MR1_A0 = mr1[myps];
			mb1D[myps].MR2_A0 = mr2[myps];
			mb1D[myps].MR3_A0 = mr3[myps];
			mb1D[myps].MR4_A0 = mr4[myps];
			mb1D[myps].MR11_A0 = mr11[myps];
			mb1D[myps].MR12_A0 = mr12[myps];
			mb1D[myps].MR13_A0 = mr13[myps];
			mb1D[myps].MR14_A0 = mr14[myps];
			mb1D[myps].MR16_A0 = mr16[myps];
			mb1D[myps].MR17_A0 = mr17[myps];
			mb1D[myps].MR21_A0 = mr21[myps];
			mb1D[myps].MR22_A0 = mr22_rank0[myps];
			mb1D[myps].MR24_A0 = mr24[myps];
			mb1D[myps].MR51_A0 = mr51[myps];
			mb1D[myps].MR1_A1 = mr1[myps];
			mb1D[myps].MR2_A1 = mr2[myps];
			mb1D[myps].MR3_A1 = mr3[myps];
			mb1D[myps].MR4_A1 = mr4[myps];
			mb1D[myps].MR11_A1 = mr11[myps];
			mb1D[myps].MR12_A1 = mr12[myps];
			mb1D[myps].MR13_A1 = mr13[myps];
			mb1D[myps].MR14_A1 = mr14[myps];
			mb1D[myps].MR16_A1 = mr16[myps];
			mb1D[myps].MR17_A1 = mr17[myps];
			mb1D[myps].MR21_A1 = mr21[myps];
			mb1D[myps].MR22_A1 = mr22_rank1[myps];
			mb1D[myps].MR24_A1 = mr24[myps];
			mb1D[myps].MR51_A1 = mr51[myps];
			mb1D[myps].MR1_B0 = mr1[myps];
			mb1D[myps].MR2_B0 = mr2[myps];
			mb1D[myps].MR3_B0 = mr3[myps];
			mb1D[myps].MR4_B0 = mr4[myps];
			mb1D[myps].MR11_B0 = mr11[myps];
			mb1D[myps].MR12_B0 = mr12[myps];
			mb1D[myps].MR13_B0 = mr13[myps];
			mb1D[myps].MR14_B0 = mr14[myps];
			mb1D[myps].MR16_B0 = mr16[myps];
			mb1D[myps].MR17_B0 = mr17[myps];
			mb1D[myps].MR21_B0 = mr21[myps];
			mb1D[myps].MR22_B0 = mr22_rank0[myps];
			mb1D[myps].MR24_B0 = mr24[myps];
			mb1D[myps].MR51_B0 = mr51[myps];
			mb1D[myps].MR1_B1 = mr1[myps];
			mb1D[myps].MR2_B1 = mr2[myps];
			mb1D[myps].MR3_B1 = mr3[myps];
			mb1D[myps].MR4_B1 = mr4[myps];
			mb1D[myps].MR11_B1 = mr11[myps];
			mb1D[myps].MR12_B1 = mr12[myps];
			mb1D[myps].MR13_B1 = mr13[myps];
			mb1D[myps].MR14_B1 = mr14[myps];
			mb1D[myps].MR16_B1 = mr16[myps];
			mb1D[myps].MR17_B1 = mr17[myps];
			mb1D[myps].MR21_B1 = mr21[myps];
			mb1D[myps].MR22_B1 = mr22_rank1[myps];
			mb1D[myps].MR24_B1 = mr24[myps];
			mb1D[myps].MR51_B1 = mr51[myps];
		)
		memset((void *) &shdw1D[myps], 0, sizeof(PMU_SMB_LPDDR4X_1D_t)); // Zero out struct contents
		} // myps

	// ##############################################################
	// userInputSim - Dram/Dimm Timing Parameters the user must
	// provide value if applicable
	// ##############################################################
	_IF_LPDDR4(
		pUserInputSim->tDQS2DQ = 200;
		pUserInputSim->tDQSCK = 1500;
	)
	_IF_LPDDR5(
		pUserInputSim->tWCK2DQO = 1000;
		pUserInputSim->tWCK2DQI = 500;
		pUserInputSim->tWCK2CK = 0;
	)
	// ##############################################################
	// Set to be compatible with maximum design frequency
	// ##############################################################
	pUserInputSim->PHY_tDQS2DQ = 312; // 2*UImin , =312 if LPDDR4-6400 is max design frequency, not to be confused with dram tdqs2dq
	dwc_ddrphy_phyinit_print("// [%s] End of %s\n", __func__, __func__);
}

/** @} */
