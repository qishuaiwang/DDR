/** \file
 *  \addtogroup SrcFunc
 *  @{
 */
#include "dwc_ddrphy_phyinit.h"

/** \brief this function implements the flow of PhyInit software to initialize the PHY.
 *
 * The execution sequence follows the overview figure provided in the PhyInit App Note.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \returns 0 on completion of the sequence, EXIT_FAILURE on error.
 * \callgraph
 */
int dwc_ddrphy_phyinit_sequence(phyinit_config_t *phyctx)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	int debug = pRuntimeConfig->debug;
	int pstate;
	int prevPState;

	dwc_ddrphy_phyinit_cmnt(" [%s] Start of %s\n", __func__, __func__);
#ifdef PUB
	dwc_ddrphy_phyinit_cmnt(" [%s] Using PUB=%d in PhyInit\n", __func__, (int) PUB);
#else
	dwc_ddrphy_phyinit_assert(0, " [%s] The PUB version is not defined.\n", __func__);
#endif
	// registering function inputs
	//pRuntimeConfig->curIMEM = 0xffff; // Reset state of IMEM in PhyInit
	pRuntimeConfig->curPState = 0;	// Reset state of IMEM in PhyInit

	// Initialize structures
	dwc_ddrphy_phyinit_initStruct(phyctx);

	// Enter user input
	dwc_ddrphy_phyinit_setDefault(phyctx);

	// User-editable function to override any user input set in dwc_ddrphy_phyinit_enterUserInput()
	dwc_ddrphy_phyinit_userCustom_overrideUserInput(phyctx);

	// Re-calculate Firmware Message Block input based on final user input
	dwc_ddrphy_phyinit_calcMb(phyctx);

	// check basic inputs
	dwc_ddrphy_phyinit_chkInputs(phyctx);

	// Printing values of user input
	if (debug != 0) {
		dwc_ddrphy_phyinit_print_dat(phyctx);
	}

	// (A) Bring up VDD, VDDQ, and VAA
	dwc_ddrphy_phyinit_userCustom_A_bringupPower(phyctx);

	// (B) Start Clocks and Reset the PHY
	dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy(phyctx);

	// (C) Initialize PHY Configuration
	dwc_ddrphy_phyinit_C_initPhyConfig(phyctx);

	// Customize any register write desired; This can include any CSR not covered by PhyInit or if
	// user wish to override values calculated in step C
	dwc_ddrphy_phyinit_userCustom_customPreTrain(phyctx);

	// Stop retention register tracking for training firmware related registers
	// Pstate Loop registers will be tracked in DMA
	dwc_ddrphy_phyinit_regInterface(stopTrack, 0, 0);

	dwc_ddrphy_phyinit_cmnt(" [%s] initCtrl = %d\n", __func__, pRuntimeConfig->initCtrl);
	// Load Training Firmware image
	uint8_t skip_imem = (pRuntimeConfig->initCtrl & 0x04) >> 2;

	if (!skip_imem) {
		dwc_ddrphy_phyinit_D_loadIMEM(phyctx);
	}

	// Train all Pstates except FirstPstate.
	prevPState = pRuntimeConfig->curPState;
	pRuntimeConfig->firstTrainedPState = 1;
	pRuntimeConfig->lastTrainedPState = 0;
	for (pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
		if (pstate == pUserInputBasic->FirstPState) {
			continue;
		} else if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) {
			continue;
		}
		else {
			pRuntimeConfig->curPState = pstate;
			dwc_ddrphy_phyinit_sequencePsLoop(phyctx);
			pRuntimeConfig->firstTrainedPState = 0;
		}
	} // pstate

	// Train First PState last.
	dwc_ddrphy_phyinit_cmnt(" [%s] Training first mission mode PState\n", __func__);
	pRuntimeConfig->curPState = pUserInputBasic->FirstPState;
	pRuntimeConfig->lastTrainedPState = 1;
	dwc_ddrphy_phyinit_sequencePsLoop(phyctx);
	pRuntimeConfig->curPState = prevPState;

	// Start retention register tracking for training firmware related registers
	dwc_ddrphy_phyinit_regInterface(startTrack, 0, 0);

	// (I) Load PHY Init Engine Image / non-Pstate
	dwc_ddrphy_phyinit_I_loadPIEImage(phyctx);

	// Customize any CSR write desired to override values programmed by firmware or dwc_ddrphy_phyinit_I_loadPIEImage()
	// Non-Pstate only.
	dwc_ddrphy_phyinit_userCustom_customPostTrain(phyctx);

	if (pRuntimeConfig->RetEn) {
		// Save value of tracked registers for retention restore sequence.
		dwc_ddrphy_phyinit_userCustom_saveRetRegs(phyctx);
	}
#ifdef DWC_DDRPHY_PHYINIT_PS_SRAM_CHKR
	// Check ps sram content if > 2 PStates are used.
	if (pUserInputBasic->NumPStates > 2) {
		dwc_ddrphy_phyinit_check_ps_sram();

		// Dump out debug info on the PS SRAM usage.
		dwc_ddrphy_phyinit_report_ps_sram(0x1 << pUserInputBasic->FirstPState);

		dwc_ddrphy_phyinit_ps_sram_free();        
	}
#endif
	// (J) Initialize the PHY to Mission Mode through DFI Initialization
	dwc_ddrphy_phyinit_userCustom_J_enterMissionMode(phyctx);

	dwc_ddrphy_phyinit_cmnt(" [%s] End of %s\n", __func__, __func__);

	return 0;
}

extern int ramSize; // FIXME
extern uint16_t dmaIdxStrt[4]; // FIXME
uint16_t dwc_ddrphy_phyinit_getPsBase(uint16_t pstate); // FIXME

/** \brief this function implements the PState Loop portion of initialization sequence.
 *
 * \param phyctx Data structure to hold user-defined parameters
 * \returns void
 * \callgraph
 */
void dwc_ddrphy_phyinit_sequencePsLoop(phyinit_config_t *phyctx)
{
	user_input_basic_t* pUserInputBasic = &phyctx->userInputBasic;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	uint8_t pstate = pRuntimeConfig->curPState;
	uint8_t pstateCtrl = pRuntimeConfig->curPState & 0xf;
	uint16_t pstateDmaEntrySize = (uint16_t)ramSize;
	uint16_t pstateDmaAddr;

	PMU_SMB_LPDDR4X_1D_t *mb1D = phyctx->mb_LPDDR4X_1D;

	uint8_t prog_csr = (pRuntimeConfig->initCtrl & 0x01) >> 0;
	uint8_t skip_fw = (pRuntimeConfig->initCtrl & 0x02) >> 1;
	//uint8_t skip_imem = (pRuntimeConfig->initCtrl & 0x04) >> 2;
	uint8_t skip_dmem = (pRuntimeConfig->initCtrl & 0x08) >> 3;
	uint8_t devinit = (pRuntimeConfig->initCtrl & 0x20) >> 5;

	// Indicate the start of the Pstate Loop to register interface
	dwc_ddrphy_phyinit_regInterface(startPsLoop, 0, 0);

	// Pstatable Step C
	dwc_ddrphy_phyinit_C_initPhyConfigPsLoop(phyctx);

	// customPre Pstatable
	dwc_ddrphy_phyinit_userCustom_customPreTrainPsLoop(phyctx, pstate);

	if (prog_csr) {
		dwc_ddrphy_phyinit_regInterface(stopPsLoop, 0, 0);

		if (pRuntimeConfig->firstTrainedPState) {
			// Skip running training firmware entirely
			dwc_ddrphy_phyinit_progCsrSkipTrain(phyctx);
		}
		// set Register group to 3 for Firmware trained results.
		dwc_ddrphy_phyinit_regInterface(resumePsLoop, 0, 0);
		dwc_ddrphy_phyinit_regInterface(setGroup, 0, 3);

		// Skip running training firmware entirely
		dwc_ddrphy_phyinit_progCsrSkipTrainPsLoop(phyctx);

		// 2D execution should be turned off since progSkipTrain will do the programming
		pRuntimeConfig->Train2D = 0;

		// revert to group 2 for the rest of registers
		dwc_ddrphy_phyinit_regInterface(setGroup, 0, 2);
	}
	// Training firmware will populate the DMA on its own
	dwc_ddrphy_phyinit_regInterface(stopPsLoop, 0, 0);

	if (devinit) {
		// Only execute training firmware to initialize the DRAM and
		// skip all training steps.
		pRuntimeConfig->curD = 0;
		// Set sequence Ctrl to 0x1 to only do device initialization.
		mb1D[pstate].SequenceCtrl = 0x1;
	}

	// Set message block fields to communicate addresses with Firmware
	pstateCtrl |= (pRuntimeConfig->firstTrainedPState == 1) << 4;
	pstateCtrl |= (pRuntimeConfig->lastTrainedPState  == 1) << 5;
	pstateCtrl |= (pUserInputBasic->NumPStates > 2) << 7;
	mb1D[pstate].Pstate = pstateCtrl;
	dwc_ddrphy_phyinit_cmnt(" [%s] pstate %d pstateCtrl = %d\n", __func__, pstate, mb1D[pstate].Pstate);

	if (pUserInputBasic->NumPStates > 2) {
		pstateDmaAddr = dwc_ddrphy_phyinit_getPsBase(pstate) * pstateDmaEntrySize;
		_IF_LPDDR4(
			mb1D[pstate].FCDMAStartMR = pstateDmaAddr + (2*(DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4));
		)
		_IF_LPDDR5(
			mb1D[pstate].FCDMAStartMR = pstateDmaAddr + (2*(DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5));
		)
		mb1D[pstate].FCDMAStartCsr = pstateDmaAddr + dmaIdxStrt[3];
	} else {
		mb1D[pstate].FCDMAStartMR = 0;
		mb1D[pstate].FCDMAStartCsr = 0;
	}
	dwc_ddrphy_phyinit_cmnt(" [%s] pstate %d FCDMAStartMR = %d\n", __func__, pstate, mb1D[pstate].FCDMAStartMR);
	dwc_ddrphy_phyinit_cmnt(" [%s] pstate %d FCDMAStartCsr = %d\n", __func__, pstate, mb1D[pstate].FCDMAStartCsr);

	if (!skip_fw) {
		pRuntimeConfig->curD = 0;	// 1D

		// (E) Set the PHY input clocks to the desired frequency
		dwc_ddrphy_phyinit_userCustom_E_setDfiClk(phyctx, pstate);
		// Note: this routine implies other items such as DfiFreqRatio, DfiCtlClk are also set properly.
		// Because the clocks are controlled in the SOC, external to the software and PHY, this step intended to be
		// replaced by the user with the necessary SOC operations to achieve the new input frequency to the PHY.

		if (!skip_dmem){
			// (F) Write the Message Block parameters for the training firmware
			dwc_ddrphy_phyinit_F_loadDMEM(phyctx);
		}

		// (G) Execute the Training Firmware
		dwc_ddrphy_phyinit_G_execFW(phyctx);

		// (H) Read the Message Block results
		dwc_ddrphy_phyinit_H_readMsgBlock(phyctx, 0);

		// Now optionally perform 2D training for protocols that allow it
		if (pRuntimeConfig->Train2D == 1) {
			pRuntimeConfig->curD = 1; // 2D

			// 2D-F, cont.  Write the Message Block parameters for the training firmware
			dwc_ddrphy_phyinit_F_loadDMEM(phyctx);

			// 2D-G Execute the Training Firmware
			dwc_ddrphy_phyinit_G_execFW(phyctx);

			// 2D-H Read the Message Block results
			dwc_ddrphy_phyinit_H_readMsgBlock(phyctx, 1);
		} // 2D
	} else { // ! skipfw
		// @todo: function entry point for customer to do backdoor DRAM init.
	}

	//dwc_ddrphy_phyinit_cmnt(" debug 1\n" );

	dwc_ddrphy_phyinit_regInterface(resumePsLoop, 0, 0);

	//printf("End of fw Exec\n");
	// (I) Load PHY Init Engine Image / Pstate
	dwc_ddrphy_phyinit_I_loadPIEImagePsLoop(phyctx);

	// custom post pstate
	dwc_ddrphy_phyinit_userCustom_customPostTrainPsLoop(phyctx, pstate);

	// DMA Copy
	dwc_ddrphy_phyinit_regInterface(endPsLoop, 0, 0);
}

/** @} */
