/** \file
 * \brief implements Step I of initialization sequence
 *
 * This file contains the implementation of dwc_ddrphy_phyinit_I_initPhyConfig
 * function.
 *
 *  \addtogroup SrcFunc
 *  @{
 */
#include "dwc_ddrphy_phyinit.h"

#define ACSM_START_CSR_ADDR 0x41000	// mapping of ACSM instruction memory on CSR bus
#define ACSM_MRW_START_ADDR (0x2 * 4)	// placed after NOP used for skipMRW

int acsmClkRatio;
uint16_t acsmInstPtr = ACSM_MRW_START_ADDR;

static uint16_t loadAcsmMRW(phyinit_config_t *phyctx, int inPsLoop);
static uint8_t highestDataRatePState(phyinit_config_t *phyctx);

/** \brief Loads registers after training
 *
 * This function programs the PHY Initialization Engine (PIE) instructions and
 * the associated registers.
 * Training hardware registers are also programmed to for mission mode
 * retraining.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 *
 * Detailed list of registers programmed by this function:
 */
void dwc_ddrphy_phyinit_I_loadPIEImage(phyinit_config_t *phyctx)
{
	//user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	uint8_t prog_csr = (pRuntimeConfig->initCtrl & 0x1) >> 0;
	uint8_t skip_pie = (pRuntimeConfig->initCtrl & 0x10) >> 4;
	uint16_t regData;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Start of %s() %d\n", __func__, prog_csr);

	if (skip_pie) {
		dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] skip_pie flag set. Skipping dwc_ddrphy_phyinit_I_loadPIEImage\n");
		return;
	}

	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt(" (I) Load PHY Init Engine Image\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("Load the PHY Initialization Engine memory with the provided initialization sequence.\n");
	dwc_ddrphy_phyinit_cmnt("See PhyInit App Note for detailed description and function usage\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt(" For LPDDR4/LPDDR5, this sequence will include the necessary retraining code.\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");

	dwc_ddrphy_phyinit_cmnt(" Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 0.\n");
	dwc_ddrphy_phyinit_cmnt(" This allows the memory controller unrestricted access to the configuration CSRs.\n");
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x0);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Programming PIE Production Code\n");

	// reset the acsm instruction Ptr (leave room for NOP pair)
	acsmInstPtr = ACSM_MRW_START_ADDR;

	dwc_ddrphy_phyinit_LoadPieProdCode(phyctx);

	// add back the runtime MRW for frequency changes
	loadAcsmMRW(phyctx, 0);

	// reset the acsm pointer after everything is loaded
	acsmInstPtr = ACSM_MRW_START_ADDR;

	/**
     * - Registers: PieCfgVec and PieInitVecSel
     *   - Program PIE initialization start vector
     */

	dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_PieInitVecSel_ADDR), 0x5061);

	regData = 0x8 << csr_PieInitVecSel4_LSB | 0x9 << csr_PieInitVecSel5_LSB | 0x0 << csr_PieInitVecSel6_LSB | 0x0 << csr_PieInitVecSel7_LSB;
	dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_PieInitVecSelB_ADDR), regData);

	regData = 0x0 << csr_PieInitVecSel8_LSB | 0x0 << csr_PieInitVecSel9_LSB | 0x0 << csr_PieInitVecSel10_LSB | 0x0 << csr_PieInitVecSel11_LSB;
	dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_PieInitVecSelC_ADDR), regData);

	dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_PieVecCfg_ADDR), 0xbedc);

	regData = 0xb << csr_PieInitStartVec4_LSB | 0xd << csr_PieInitStartVec5_LSB | 0x0 << csr_PieInitStartVec6_LSB | 0x0 << csr_PieInitStartVec7_LSB;
	dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_PieVecCfg1_ADDR),     regData);

	regData = 0x0 << csr_PieInitStartVec8_LSB | 0x0 << csr_PieInitStartVec9_LSB | 0x0 << csr_PieInitStartVec10_LSB | 0x0 << csr_PieInitStartVec11_LSB;
	dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_PieVecCfg2_ADDR),     regData);

	dwc_ddrphy_phyinit_PieFlags(phyctx, prog_csr);

	/**
     * - Registers: FspSkipList
     *   - Program encoding that don't update FspState
     */
	regData = 0x17 | (0x1f << 5);
	regData |= (0x9 << csr_FspDfiSkip2_LSB);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_FspSkipList_ADDR), regData);

	regData = 0x8 << csr_FspDfiSkip3_LSB | 0x8 << csr_FspDfiSkip4_LSB | 0x8 << csr_FspDfiSkip5_LSB;
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_FspSkipList1_ADDR), regData);

	regData = 0x8 << csr_FspDfiSkip6_LSB | 0x8 << csr_FspDfiSkip7_LSB | 0x8 << csr_FspDfiSkip8_LSB;
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_FspSkipList2_ADDR), regData);


	/**
     * Program Training Hardware Registers for mission mode retraining
     * and DRAM drift compensation algorithm.
     *
     */
	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Programing Training Hardware Registers for mission mode retraining\n");
	if (prog_csr == 0) {
		dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Enabling Phy Master Interface for DRAM drift compensation\n");
		dwc_ddrphy_phyinit_ProgPPT(phyctx);
	}

#if PUB==1
	/// - ACSMOuterLoopRepeatCnt
	dwc_ddrphy_phyinit_io_write16((c0 | tMASTER | csr_ACSMOuterLoopRepeatCnt_ADDR), 0xc);
#endif

	_IF_LPDDR4(
		/// - Register HwtControlOvr, HwtControlVal
		/// @todo 
		regData = csr_HwtCke0Ovr0_MASK;
		user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;

		if (pUserInputBasic->NumRank_dfi0 == 2) {
			regData |= csr_HwtCke1Ovr0_MASK;
		}

		if (pUserInputBasic->NumCh > 1) {
			regData |= csr_HwtCke0Ovr1_MASK;
			if (pUserInputBasic->NumRank_dfi1 == 2) {
				regData |= csr_HwtCke1Ovr1_MASK;
			}
		}

		dwc_ddrphy_phyinit_io_write16((c0 | tMASTER | csr_HwtControlOvr_ADDR), regData);
		dwc_ddrphy_phyinit_io_write16((c0 | tMASTER | csr_HwtControlVal_ADDR), regData);
		/// - Register ACSMCkeControl
		dwc_ddrphy_phyinit_io_write16((c0 | tMASTER | csr_ACSMCkeControl_ADDR), 0x2);
	)

	_IF_LPDDR5(
		regData = csr_HwtCs0Val0_MASK;
		user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;

		if (pUserInputBasic->NumRank_dfi0 == 2) {
			regData |= csr_HwtCs1Val0_MASK;
		}

		if (pUserInputBasic->NumCh > 1) {
			regData |= csr_HwtCs0Val1_MASK;
			if (pUserInputBasic->NumRank_dfi1 == 2) {
				regData |= csr_HwtCs1Val1_MASK;
			}
		}

		dwc_ddrphy_phyinit_io_write16((c0 | tMASTER | csr_HwtControlVal_ADDR), regData);
	)
	/// - FspState
	dwc_ddrphy_phyinit_io_write16((c0 | tMASTER | csr_FspState_ADDR), 0xffff);

#if PUB!=1
	/// - PieTrigCntVal
	dwc_ddrphy_phyinit_io_write16((c0 | tINITENG | csr_PieTrigCntVal_ADDR), 0x2);
#endif

	/// - Register:
	//       - ZCalReset
	//       - ZCalRun
	///   - Prepare the calibration controller for mission mode.
	///     Turn on calibration and hold idle until dfi_init_start is asserted sequence is triggered.
	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Turn on calibration and hold idle until dfi_init_start is asserted sequence is triggered.\n");
	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Programming ZCalReset to 0x%x\n", 0x1);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Programming ZCalRun to 0x%x\n", 0x1);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_ZCalReset_ADDR), 0x1);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_ZCalRun_ADDR), 0x1);

   /**
    * At the end of this function, PHY Clk gating register UcclkHclkEnables is
    * set for mission mode.  Additionally APB access is Isolated by setting
    * MicroContMuxSel.
    */
	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Disabling Ucclk (PMU)\n");
	dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | csr_UcclkHclkEnables_ADDR), csr_HclkEn_MASK);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Writing TDRDisable to %d\n", pUserInputAdvanced->DisableTDRAccess);
	dwc_ddrphy_phyinit_userCustom_io_write16((tAPBONLY | csr_TDRDisable_ADDR), pUserInputAdvanced->DisableTDRAccess);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Isolate the APB access from the internal CSRs by setting the MicroContMuxSel CSR to 1.\n");
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x1);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] End of %s()\n", __func__);
}

/** \brief Loads registers after training
 *
 * This is a helper function to program PPT registers.It is called by dwc_ddrphy_phyinit_I_loloadPIEImage().
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 *int
 * Detailed list of registers programmed by this function:
 */
void dwc_ddrphy_phyinit_ProgPPT(phyinit_config_t *phyctx)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	uint16_t regData;

	/// - Register: DtsmGoodBar
	///   - Dependencies: NumDbyte
	int NumDbyte = pUserInputBasic->NumCh * pUserInputBasic->NumDbytesPerCh;
	unsigned int c_addr;
	unsigned int byte;

	for (byte = 0; byte < NumDbyte; byte++) { // for each chiplet
		c_addr = byte * c1;
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_DtsmGoodBar_ADDR), 0x1); // [15:0] good_bar;
		regData = (csr_DtsmStaticCmpr_MASK | csr_DtsmStaticCmprVal_MASK);
		/// - Register: DtsmByteCtrl1, DtsmErrBar
		///   - Fields:
		///     - DtsmStaticCmpr
		///     - DtsmStaticCmprVal
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_DtsmByteCtrl1_ADDR), regData);
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_DtsmErrBar_ADDR), 0x1); // [15:0] bad_bar;


#if PUB==1
		/// - Register: TrainingParam
		///   - Fields:
		///     - EnDynRateReduction
		///     - RollIntoCoarse
		///     - IncDecRate
		regData = (csr_EnDynRateReduction_MASK | csr_RollIntoCoarse_MASK| (0x3 << csr_IncDecRate_LSB));
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_TrainingParam_ADDR), regData);
#endif

		/// - Register: PptRxEnEvnt
		///   - Fields:
		///     - TrainEnRxEn
		///   - Dependencies:
		///     - user_input_advanced.DisableRetraining
		///     - user_input_advanced.EnRxDqsTracking
		regData = 0;

		if (pUserInputAdvanced->DisableRetraining == 0) {
			// Only allow TrainEnRxEn if EnRxDqsTracking is not enabled
			uint8_t tracking = 0;

			for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
				if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) {
					continue;
				}

				if (pUserInputAdvanced->EnRxDqsTracking[pstate] != 0) {
					tracking = 1;
					break;
				}
			}

			if (tracking == 0) {
#if PUB==1
				regData |= csr_TrainEnRxEn_MASK;
#endif
			}
		}
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_PptRxEnEvnt_ADDR), regData);

		/// - Register: DtsmLaneCtrl0
		///   - Fields:
		///     - DtsmEnb
		regData = (0x1 << csr_DtsmEnb_LSB);
		dwc_ddrphy_phyinit_io_write16((c_addr | i0 | tDBYTE | csr_DtsmLaneCtrl0_ADDR), regData);

	} // for byte

	/**
     * - PPGC programing for PPT2 TxDQ
     *   - program PrbsTapDly0..7
     */
	for (uint8_t i = 0; i < 9; i++) {  // Changed to i < 9 to include DMI pin training
		uint32_t lns = i << 8;

		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly0_ADDR, 0xcccc);	// TX Gen pattern low
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly1_ADDR, 0xcccc);	// TX Gen pattern high
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly2_ADDR, 0xcccc);	// TX Gen pattern low
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly3_ADDR, 0xcccc);	// TX Gen pattern high
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly4_ADDR, 0xcccc);	// TX Gen pattern low
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly5_ADDR, 0xcccc);	// TX Gen pattern high
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly6_ADDR, 0xcccc);	// TX Gen pattern low
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | lns | csr_PrbsTapDly7_ADDR, 0xcccc);	// TX Gen pattern high
	}
	///  - program PrbsGrnCtl1
	dwc_ddrphy_phyinit_io_write16((c0 | tPPGC | csr_PrbsGenCtl1_ADDR), csr_PpgcModeLane_MASK);

	PMU_SMB_LPDDR4X_1D_t *mb1D = phyctx->mb_LPDDR4X_1D;
	///   - program PrbsGenCtl
	uint16_t DMIPinPresent;
	uint8_t first = pUserInputBasic->FirstPState; // for global settings, use FirstPState values

	_IF_LPDDR4(
		DMIPinPresent = (mb1D[first].MR3_A0 & 0x40) >> 6; // DBI-RD
	)
	_IF_LPDDR5(
		DMIPinPresent = ((mb1D[first].MR3_A0 & 0x40) >> 6 & 1) // DBI-RD
		              | ((mb1D[first].MR22_A0 & 0xC0) >> 6 & 1); // RECC
	)

	if (DMIPinPresent) {
		dwc_ddrphy_phyinit_io_write16(c0 | tPPGC | csr_PrbsGenCtl_ADDR, csr_PpgcDmMode_MASK);
	}
} // progPpt

/** \brief Programs PIE group disable flags.
 *
 * This is a helper function to program PIE Group Flag registers.It is called by dwc_ddrphy_phyinit_I_loloadPIEImage().
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 *
 * Detailed list of registers programmed by this function:
 */
void dwc_ddrphy_phyinit_PieFlags(phyinit_config_t *phyctx, int prog_csr)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	uint16_t regData;

	/**
     * - Registers: Seq0BDisableFlag0 Seq0BDisableFlag1 Seq0BDisableFlag2
     *   Seq0BDisableFlag3 Seq0BDisableFlag4 Seq0BDisableFlag5
     *   - Program PIE Instruction Disable Flags
     *   - Dependencies:
     *     - user_input_advanced.DisableRetraining
     *     - prog_csr
     *     - user_input_basic.Frequency
     */
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag0_ADDR), 0x0000);
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag1_ADDR), 0x0777);
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag2_ADDR), 0x0660);
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag3_ADDR), 0x7910);
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag4_ADDR), 0x3556);
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag5_ADDR), 0xCBBD);

    regData = ( pUserInputBasic->NumPStates < 3) ? 0xffff : 0x0710;
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag7_ADDR), regData);

    regData =  ( pUserInputBasic->NumPStates < 3) ? 0x0710 : 0xffff;
    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag8_ADDR), regData);

    dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag9_ADDR), 0xF9FF);

    int freqThreshold;
    uint8_t ps = highestDataRatePState(phyctx);

    _IF_LPDDR4(
        freqThreshold = 333;
	)
    _IF_LPDDR5(
        freqThreshold = pUserInputBasic->DfiFreqRatio[ps] == 1 ? 166 : 83;
    )

#if PUB==1
    if (prog_csr == 1 || pUserInputAdvanced->DisableRetraining || pUserInputBasic->Frequency[ps] < freqThreshold) {
        dwc_ddrphy_phyinit_cmnt (" [dwc_ddrphy_phyinit_PieFlags] Disabling PMI & DRAM drift compensation. (prog_csr=%d, DisableRetraining=%d, Frequency[%d]=%d) \n",
                prog_csr, pUserInputAdvanced->DisableRetraining, ps, pUserInputBasic->Frequency[ps]);
        dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag6_ADDR), 0xffff);
    } else {
        dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag6_ADDR), 0x2E60);
    }

    // For SW Skip Retrain enhancement.  Require a DisableFlag to indicate when we're doing Relock Only/Skip Retrain
    // PIE sequence execution in order to skip the PIE/PMU sequence interactions.
    if ( pUserInputAdvanced->SkipRetrainEnhancement ) {
        regData = 0xF99F;
        dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag10_ADDR), regData);
    } else {
        regData = 0xFFFF;
        dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag10_ADDR), regData);
    }
#else

	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag10_ADDR), 0xffff); // SkipRetrainEnhancement

	if (prog_csr == 1 || pUserInputAdvanced->DisableRetraining || pUserInputBasic->Frequency[ps] < freqThreshold) {
		dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImage] Disabling PMI & DRAM drift compensation. (prog_csr=%d, DisableRetraining=%d, Frequency[%d]=%d)\n", prog_csr, pUserInputAdvanced->DisableRetraining, ps, pUserInputBasic->Frequency[ps]);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag6_ADDR), 0xffff);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag11_ADDR), 0xffff);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag12_ADDR), 0xffff);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag13_ADDR), 0xffff);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag14_ADDR), 0xffff);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag15_ADDR), 0xffff);
	} else {
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag6_ADDR), 0x2E60);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag11_ADDR), 0x2860); // Free 
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag12_ADDR), 0x2860); // Free
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag13_ADDR), 0x2860);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag14_ADDR), 0x2860);
		dwc_ddrphy_phyinit_io_write16((tINITENG | csr_Seq0BDisableFlag15_ADDR), 0x2860); // Free
	}


	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnModeMask0_ADDR), 0xe400); // PPT1 = 0xE400
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnModeMask1_ADDR), 0xE400); // PPT2 = 0x9400

	//dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask0_ADDR), 0x7700); // RxClk
	//dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask1_ADDR), 0x7b00); // RxEn  7b00 = RxDqsTracking , 7d00 = PPT1 RxEn
	//dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask2_ADDR), 0x1f00); // TxDq
	//dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask3_ADDR), 0xff00); //
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask0_ADDR), 0x0000); // RxClk   : GRP_0 is mainly used, GRP_13 is used for Tg0, GRP_14 is used for Tg1
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask1_ADDR), 0x0000); // RxEn    : GRP_0 is mainly used, GRP_13 is used for Tg0, GRP_14 is used for Tg1
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask2_ADDR), 0x0000); // TxDq    : GRP_0 is mainly used, GRP_13 is used for Tg0, GRP_14 is used for Tg1
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask3_ADDR), 0x0000); // TxRDQSt : GRP_0 is mainly used, GRP_13 is used for Tg0, GRP_14 is used for Tg1

	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask4_ADDR), 0xff00); //
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask5_ADDR), 0xff00); //
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask6_ADDR), 0xff00); //
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSelMask7_ADDR), 0xff00); //

	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RelTgMaskTg0_ADDR), 0x4000); // Tg0
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RelTgMaskTg1_ADDR), 0x2000); // Tg1
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RelTgMaskTg2_ADDR), 0xff00); //
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RelTgMaskTg3_ADDR), 0xff00); // unused

	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnSeqStart_ADDR), 0x0);  //

	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnTgSeqStart_ADDR), 0x0); //
	regData = (pUserInputBasic->NumRank_dfi1 == 2 || pUserInputBasic->NumRank_dfi0 == 2);
	dwc_ddrphy_phyinit_io_write16((tINITENG | csr_RtrnTgSeqStop_ADDR), regData); //
#endif
} // End of dwc_ddrphy_phyinit_PieFlags

/** \brief helper function to write MR instructions
 *
 * This is a helper function to program ACSM runtime instructions.
 *
 * \return void
 *
 * Detailed list of registers programmed by this function:
 */
void dwc_ddrphy_mr_inst(uint8_t mrNum,	//!< Which MR number to write to
						uint8_t mrVal,	//!< Data of the MR to write
						uint8_t mrCs,	//!< drives the cs pins
						uint16_t dly)	//!< Command delay
{

	dwc_ddrphy_phyinit_cmnt(" [%s] Storing MRW MA=%d OP=0x%x CS=0x%x at row addr=0x%0x\n", __func__, mrNum, mrVal, mrCs, acsmInstPtr / 4);

	uint16_t addr[8] = { 0 };
	uint16_t cs[8] = { 0 };

	_IF_LPDDR5(
		uint16_t p[4];

		p[0] = 0x58; // MRW-1
		p[1] = mrNum; // MA[6:0]
		p[2] = 0x8 | (mrVal & 0x80) >> 1; // MRW-2 + OP7
		p[3] = mrVal & 0x7F; // OP[6:0]
		addr[0] = (p[1] & 0x7F) << 7 | (p[0] & 0x7F);
		addr[1] = (p[3] & 0x7F) << 7 | (p[2] & 0x7F);
		cs[0] = mrCs & 0x3;
		cs[1] = mrCs & 0x3;
	)

	_IF_LPDDR4(
		if (acsmClkRatio == 2) {
			addr[0] = 0x6 | (mrVal & 0x80) >> 2; // MRW-1 + OP7
			addr[1] = mrNum; // MRW-1 (MA)
			addr[4] = 0x16 | (mrVal & 0x40) >> 1; // MRW-2 + OP6
			addr[5] = mrVal & 0x3f; // MRW-2
			cs[0] = mrCs & 0x3;
			cs[4] = mrCs & 0x3;
		} else {
			addr[0] = 0x6 | (mrVal & 0x80) >> 2; // MRW-1 + OP7
			addr[1] = mrNum; // MRW-1 (MA)
			addr[2] = 0x16 | (mrVal & 0x40) >> 1; // MRW-2 + OP6
			addr[3] = mrVal & 0x3f; // MRW-2
			cs[0] = mrCs & 0x3;
			cs[2] = mrCs & 0x3;
			cs[4] = 0;
			cs[6] = 0;
		}
	)

	//dwc_ddrphy_phyinit_cmnt(" [%s] test2\n", __func__);
	uint16_t acsm_addr = acsmInstPtr;
	uint16_t ac_instr[8] = { 0 };
	uint32_t acsm_addr_mask;
	uint32_t acsm_cs_mask;

	_IF_LPDDR5(
		acsm_addr_mask = 0x3fff;
		acsm_cs_mask = 0x3;
		// even
		ac_instr[0] = ((cs[0] & acsm_cs_mask) << 14) | (addr[0] & acsm_addr_mask);
		ac_instr[1] = 0;
		ac_instr[2] = 0;
		ac_instr[3] = 0;
		// odd
		ac_instr[4] = ((cs[1] & acsm_cs_mask) << 14) | (addr[1] & acsm_addr_mask);
		ac_instr[5] = 0;
		ac_instr[6] = 0;
		ac_instr[7] = 0;
	)
	_IF_LPDDR4(
		acsm_addr_mask = 0x3f;
		acsm_cs_mask = 0x3;
		// even
		ac_instr[0] = ((addr[1] & 0x7) << 13) | ((cs[0] & acsm_cs_mask) << 6) | (addr[0] & acsm_addr_mask);
		ac_instr[1] = ((addr[2] & acsm_addr_mask) << 10) | ((cs[1] & acsm_cs_mask) << 3) | ((addr[1] & 0x38) >> 3);
		ac_instr[2] = ((cs[3] & acsm_cs_mask) << 13) | ((addr[3] & acsm_addr_mask) << 7) | (cs[2] & acsm_cs_mask);
		ac_instr[3] = 0;
		// odd
		ac_instr[4] = ((addr[5] & 0x7) << 13) | ((cs[4] & acsm_cs_mask) << 6) | (addr[4] & acsm_addr_mask);
		ac_instr[5] = ((addr[6] & acsm_addr_mask) << 10) | ((cs[5] & acsm_cs_mask) << 3) | ((addr[5] & 0x38) >> 3);
		ac_instr[6] = ((cs[7] & acsm_cs_mask) << 13) | ((addr[7] & acsm_addr_mask) << 7) | (cs[6] & acsm_cs_mask);
		ac_instr[7] = 0;
	)
	//dwc_ddrphy_phyinit_cmnt(" [%s] test3\n", __func__);
	uint16_t x;

	for (x = 0; x < 8; x++) {
		//dwc_ddrphy_phyinit_cmnt(" [%s] addr=0x%x\n", __func__, acsm_addr);
		//dwc_ddrphy_phyinit_cmnt(" [%s] addr=0x%x\n", __func__, x);
		//dwc_ddrphy_phyinit_cmnt(" [%s] dat=0x%x\n", __func__, ac_instr[x]);
		dwc_ddrphy_phyinit_io_write16((acsm_addr | ACSM_START_CSR_ADDR) + x, ac_instr[x]);
	}

	acsmInstPtr += 8;

	int cnt = dly >> 1;
	dwc_ddrphy_phyinit_cmnt(" [%s] dly = %d cnt = %d\n", __func__, dly, cnt);

	if (dly > 0) {

        for (x = 8; x < 16; x++) {
            if (x == 11 && dly > 2) {
                dwc_ddrphy_phyinit_io_write16((acsm_addr | ACSM_START_CSR_ADDR) + x, (cnt & 0x07) << 12 | 0xb00);
            } else if (x == 15) {
                dwc_ddrphy_phyinit_io_write16((acsm_addr | ACSM_START_CSR_ADDR) + x, (cnt & 0xf8) << 7);
            } else {
                dwc_ddrphy_phyinit_io_write16((acsm_addr | ACSM_START_CSR_ADDR) + x, 0);
            }
        }

        //dwc_ddrphy_phyinit_cmnt(" [%s] test6\n", __func__);
        acsmInstPtr += 8;
	}
}

/** \brief helper function to reserve space for MR instructions
 *
 * This is a helper function to manage ACSM instruction space.
 *
 * \return void
 *
 * Detailed list of registers programmed by this function:
 */
static void dwc_ddrphy_mr_clear(uint8_t mrNum, //!< MR number
								  uint8_t mrVal, //!< value ignored
								  uint8_t mrCs, //!< value ignored
								  uint16_t dly) //!< command delay, uses two additional acsm rows if != 0
{
	dwc_ddrphy_phyinit_cmnt(" [%s] Reserving space for MRW MA=%d at row addr=0x%0x\n", __func__, mrNum, acsmInstPtr / 4);

	uint8_t rows = (dly == 0) ? 2 : 4;

	// Clear this section (write NOPs)
	for (int x = 0; x < (rows * 4); x++) {
      dwc_ddrphy_phyinit_io_write16((acsmInstPtr | ACSM_START_CSR_ADDR) + x, 0x0);
	}

	acsmInstPtr += (rows * 4);
}

/** \brief helper function to skip over allocated space for MR instructions
 *
 * This is a helper function to manage ACSM instruction space.
 *
 * \return void
 *
 * Detailed list of registers programmed by this function:
 */
static void dwc_ddrphy_mr_skip(uint8_t mrNum, //!< MR number
                               uint8_t mrVal, //!< value ignored
                               uint8_t mrCs, //!< value ignored
                               uint16_t dly) //!< command delay, uses two additional acsm rows if != 0
{
	dwc_ddrphy_phyinit_cmnt(" [%s] Skip over space for MRW MA=%d at row addr=0x%0x\n", __func__, mrNum, acsmInstPtr / 4);

	// Skip over this section and rely on FW to program the MRW
	uint8_t rows = (dly == 0) ? 2 : 4;

	// Add these addresses to the save/restore retention list
	for (int x = 0; x < (rows * 4); x++) {
      dwc_ddrphy_phyinit_trackReg((acsmInstPtr | ACSM_START_CSR_ADDR) + x);
	}

	acsmInstPtr += (rows * 4);

	// Reserve space in PS SRAM too, if applicable
	dwc_ddrphy_phyinit_regInterface(reserveRegs, 0, rows * 4);
}

/** \brief helper function that abstracts the loading of MRW instructions
 *
 * This is a helper function to manage ACSM instruction space.
 *
 * \return void
 *
 * Detailed list of registers programmed by this function:
 */
void dwc_ddrphy_mr_load_cond(uint8_t mrNum,  //!< Which MR number to write to
                             uint8_t mrVal,  //!< Data of the MR to write
                             uint8_t mrCs,   //!< drives the cs pins
                             uint16_t dly,   //!< Command delay
                             uint16_t skip)  //!< Nullify the function, if set
{
    if (skip) {
        // Let firmware populate the MRW instruction, just skip over that section of memory
        return dwc_ddrphy_mr_skip(mrNum, mrVal, mrCs, dly);
    } else {
        return dwc_ddrphy_mr_inst(mrNum, mrVal, mrCs, dly);
    }
}

/** \brief returns the slowest tck among all pstates
 */
//
//uint32_t getFastestCk(phyinit_config_t *phyctx)
//{
//	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
//	uint32_t ret = 0;
//	uint32_t maxFreq = 10000;
//
//	for (int i = 0; i <= (pUserInputBasic->NumPStates); i++)
//		maxFreq = (pUserInputBasic->Frequency[i] > maxFreq ) ? pUserInputBasic->Frequency[i] : maxFreq;
//
//	ret = 1000000 / maxFreq;
//	return ret;
//}

/** \brief Programs required initialization registers after trianing firmware execution.
 */
void dwc_ddrphy_phyinit_I_loadPIEImagePsLoop(phyinit_config_t *phyctx)
{
	dwc_ddrphy_phyinit_cmnt(" [%s] Start of %s()\n", __func__, __func__);

	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	//uint8_t prog_csr = (pRuntimeConfig->initCtrl & 0x1) >> 0;
	uint8_t skip_pie = (pRuntimeConfig->initCtrl & 0x10) >> 4;

	if (skip_pie) {
		dwc_ddrphy_phyinit_cmnt(" [phyinit_I_loadPIEImagePsLoop] skip_pie flag set. Skipping dwc_ddrphy_phyinit_I_loadPIEImagePsLoop\n");
		return;
	}

	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	uint32_t pstate = pRuntimeConfig->curPState;
	uint32_t p = (pUserInputBasic->NumPStates < 3 && pstate == 1) ? p1 : p0;

#ifdef _BUILD_LPDDR5
	PMU_SMB_LPDDR4X_1D_t *mb1D;
#endif

	uint8_t NumDbyte = pUserInputBasic->NumCh * pUserInputBasic->NumDbytesPerCh;
	uint8_t byte;
	uint32_t c_addr;
#ifdef _BUILD_LPDDR5
	uint16_t regData;
#endif

	dwc_ddrphy_phyinit_regInterface(setGroup, 0, 0);

	/// - Program ACSM runtime MRW instructions.
	uint16_t mrwDly = loadAcsmMRW(phyctx, 1);

	dwc_ddrphy_phyinit_regInterface(setGroup, 0, 2);

	// Program PLL (PllCtrl5 and PllCtrl6) for mission mode (fast relock)
	dwc_ddrphy_phyinit_programPLL(phyctx, 1, "[phyinit_I_loadPIEImagePsLoop]");

	_IF_LPDDR5(
		mb1D = phyctx->mb_LPDDR4X_1D;

		/*
		 * - Program ACSMWckFreeRunMode
		 *   - Dependencies:
		 *     - mb1D[pstate].MR18_A0
		 */
		regData = (mb1D[pstate].MR18_A0 & 0x10) ? 0x1 : 0x0;
		dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d, Programming ACSMWckFreeRunMode to 0x%x\n", __func__, pstate, regData);
		dwc_ddrphy_phyinit_io_write16((p | tMASTER | csr_ACSMWckFreeRunMode_ADDR), regData);
		/*
		 * - Program ACSMRptCntDbl
		 *   - Dependencies:
		 *     - user_input_basic.Frequency[]
		 */
		uint16_t CKR = mb1D[pstate].MR18_A0 & 0x80 >> 7;

		regData = (CKR == 0x0) ? 0x1 : 0x0;
		dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d, Programming ACSMRptCntDbl to 0x%x\n", __func__, pstate, regData);
		// currently unused.
		dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_Seq0BGPR2_ADDR), regData);
	)
	/*
	 * - Program ACSMRptCntOverride
	 *   - Dependencies:
	 *     - user_input_basic.Frequency[]
	 */
	dwc_ddrphy_phyinit_io_write16 ((p | tMASTER | csr_ACSMRptCntOverride_ADDR), mrwDly>>1);
	/*
	 * - Program RxClkCntl1
	 *   - Fields
	 *     - EnRxClkCor
	 *   - Dependencies:
	 *     - user_input_advanced.RxClkTrackEn
	 */
	uint16_t RxReplicaTrackEn = (pUserInputAdvanced->RxClkTrackEn[pstate] == 1) ? 1 : 0;
	int DisableRetraining = pUserInputAdvanced->DisableRetraining;
	int rxClkThreshold;

	_IF_LPDDR4(
		rxClkThreshold = 800;
	)
	_IF_LPDDR5(
		rxClkThreshold = pUserInputBasic->DfiFreqRatio[pstate] == 1 ? 400 : 200;
	)

	if      (pUserInputBasic->Frequency[pstate] == rxClkThreshold && RxReplicaTrackEn == 1) {
		dwc_ddrphy_phyinit_assert(1, " [%s] Pstate=%d RxClk tracking cannot be enabled for data rates <= 1600 Mbps, CK frequency = %d\n", __func__, pstate, pUserInputBasic->Frequency[pstate]);
	} else if (pUserInputBasic->Frequency[pstate] <  rxClkThreshold && RxReplicaTrackEn == 1) {
		dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d RxClk tracking cannot be enabled for data rates <= 1600 Mbps, CK frequency = %d\n", __func__, pstate, pUserInputBasic->Frequency[pstate]);
	}


	if (DisableRetraining != 0 && RxReplicaTrackEn == 1) {
		dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d RxClk tracking cannot be enabled when retraining is disabled (DisableRetraining = %d)\n", __func__, pstate, DisableRetraining);
	}

	_IF_LPDDR5(
		if ((mb1D[pstate].MR20_A0 & 0x3) == 0x0 && RxReplicaTrackEn == 1) {
			dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d RxClk tracking cannot be enabled in strobe-less read mode\n", __func__, pstate);
		}
	)

	dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d, Programming RxClkCntl1 to 0x%x\n", __func__, pstate, RxReplicaTrackEn);
	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = c1 * byte;
		dwc_ddrphy_phyinit_io_write16((p | c_addr | tDBYTE | csr_RxClkCntl1_ADDR), RxReplicaTrackEn);
	}

	/// - RxReplicaCtl04
#if PUB!=1
	uint16_t freq = pUserInputBasic->Frequency[pstate];
	uint16_t RxRepl_recovery;
	_IF_LPDDR5(
		RxRepl_recovery = (2*freq) / 100;
	)
	_IF_LPDDR4(
		RxRepl_recovery = (2*freq) / (100 << pUserInputBasic->DfiFreqRatio[pstate]);
	)
#endif
	uint16_t RxReplicaCtl = (RxReplicaTrackEn << csr_RxReplicaTrackEn_LSB)
							| (0 << csr_RxReplicaLongCal_LSB)	// switch to short cal during mission mode
							| (1 << csr_RxReplicaStride_LSB) // Keep the default value of 1 step
#if PUB!=1
							| (1 << csr_RxReplicaPDenFSM_LSB) // RxReplica Receiver Powerdown save power
							| (RxRepl_recovery << csr_RxReplicaPDRecoverytime_LSB); //20ns(in DfiClk) required for RxReplica powerdown recovery
#else
							;
#endif
	dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d, Programming RxReplicaCtl04 to 0x%x\n", __func__, pstate, RxReplicaCtl);

#if PUB==1
    /*
     * Program GPR's for SkipRetrainEnhancement:
     *   - Depedencies:
     *     - user_input_advancded.SkipRetrainEnhancement
     *     - user_input_advanced.PmuClockDiv[pstate]
     *   - GPR7:
     *     - Calculate the UcclkHclkEnables CSR value to start the PMU from the PIE with or without UcclkFull enabled (PMU clock divider).
     *   - GPR8:
     *     - Calculate the UcclkHclkEnables CSR value to stop the PMU from the PIE with or without UcclkFul Enabled (PMU clock divier).
     */
     if (pUserInputAdvanced->SkipRetrainEnhancement == 1) {
         // Variable for UcclkHclkEnables
         uint16_t UcclkHclkEnables = 0x0000;

         // GPR7: start PMU with configurable PmuClockDiv[pstate].
         UcclkHclkEnables = ((pUserInputAdvanced->PmuClockDiv[pstate] == 0)<<csr_UcclkFull_LSB | csr_HclkEn_MASK | csr_UcclkEn_MASK);
         dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_Seq0BGPR7_ADDR), UcclkHclkEnables);

         // GPR8: stop PMU with configurable PmuClockDiv[pstate].
         UcclkHclkEnables = ((pUserInputAdvanced->PmuClockDiv[pstate] == 0)<<csr_UcclkFull_LSB | csr_HclkEn_MASK);
         dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_Seq0BGPR8_ADDR), UcclkHclkEnables);
     }
#endif

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = c1 * byte;
		dwc_ddrphy_phyinit_io_write16((p | c_addr | tDBYTE | csr_RxReplicaCtl04_ADDR), RxReplicaCtl);
	}

#if PUB!=1
	/*
	 * - program DtsmByteCtrl0 in GPR3 for TxPPT
     */
	uint16_t csrData;
	csrData = (pUserInputBasic->DfiFreqRatio[pstate] == 1) ? 0x0 : csr_Dtsm8bitMode_MASK;
	dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_Seq0BGPR3_ADDR), csrData);

	/// -program PrbsGenCtrl1 to GRP4 for TxPPT
	csrData = (pUserInputBasic->DfiFreqRatio[pstate] == 1) ? 0x0 : csr_Ppgc8bitMode_MASK;
	dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_Seq0BGPR4_ADDR), csrData | 0x2 ); // For DMI pin training (csrPpgcDmMode = 1)

	/// - TxPPT2 for ACSMOuterLoopRepeatCnt For TxPpt2
	dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_Seq0BGPR5_ADDR), 0x1); // @FIXME

	/// - RtrnMode
	csrData = (pUserInputAdvanced->RetrainMode[pstate] == 2 || pUserInputAdvanced->RetrainMode[pstate] == 4) ? 0x1 : 0x0;
	dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_RtrnMode_ADDR), csrData);

	_IF_LPDDR4(
	    dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_RtrnSeqStop_ADDR),  0x2);  //
	    )
	_IF_LPDDR5(
            csrData = ((mb1D[pstate].MR22_A0 >> 4) & 0x3 )? 0x3 : 0x2 ;                      // MR22 OP[5:4] WECC = b01 : enabled
            dwc_ddrphy_phyinit_io_write16((p | tINITENG | csr_RtrnSeqStop_ADDR),  csrData);  // RtrnSeqStop = 3 When WECC is enabled (TxDQ ppt2 for RDQS_t is executed).
	    )
#endif
	/**
	 * Program HwtLpCsEnA and HwtLpCsEnB based on number of ranks per channel
	 * Applicable only for LPDDR4.
	 *
	 * CSRs to program:
	 *      HwtLpCsEnA
	 *      HwtLpCsEnB
	 *
	 * User input dependencies:
	 *      DramType
	 *      NumCh
	 *      NumRank_dfi0
	 *      NumRank_dfi1
	 *
	 */
	uint16_t HwtLpCsEnA;
	uint16_t HwtLpCsEnB;

	// Channel A - 1'b01 if signal-rank, 2'b11 if dual-rank
	HwtLpCsEnA = pUserInputBasic->NumRank_dfi0 | 0x1;

	// Channel B - 1'b01 if signal-rank, 2'b11 if dual-rank
	// if DFI1 exists but disabled, NumRank_dfi0 is used to program CsEnB
	if (pUserInputBasic->NumCh == 2 && pUserInputBasic->NumActiveDbyteDfi1 == 0) {
		HwtLpCsEnB = pUserInputBasic->NumRank_dfi0 | 0x1;
	} else if (pUserInputBasic->NumCh == 2 && pUserInputBasic->NumActiveDbyteDfi1 > 0) {
		HwtLpCsEnB = pUserInputBasic->NumRank_dfi1 | 0x1;
	} else { // Disable Channel B
		HwtLpCsEnB = 0x0;
	}

	// Save to GPR to restore them during MRW sequence on frequency changes
	dwc_ddrphy_phyinit_cmnt("[%s] Programming HwtLpCsEnA to 0x%x\n", __func__, HwtLpCsEnA);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_HwtLpCsEnA_ADDR), HwtLpCsEnA);
	dwc_ddrphy_phyinit_io_write16((p | c0 | tINITENG | csr_Seq0BGPR14_ADDR),HwtLpCsEnA );
	dwc_ddrphy_phyinit_cmnt("[%s] Programming HwtLpCsEnB to 0x%x\n", __func__, HwtLpCsEnB);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_HwtLpCsEnB_ADDR), HwtLpCsEnB);
	dwc_ddrphy_phyinit_io_write16((p | c0 | tINITENG | csr_Seq0BGPR15_ADDR),HwtLpCsEnB );

} // End of  dwc_ddrphy_phyinit_I_loadPIEImagePsLoop (phyinit_config_t *phyctx)

extern int ramSize; // FIXME
extern uint8_t regGrp; // FIXME
extern uint16_t dmaIdxGrp[4]; // FIXME
uint16_t dwc_ddrphy_phyinit_getPsBase(uint16_t pstate); // FIXME

/** \brief Program the sequence of MRW instructions in the ACSM memory
 *
 * This is a helper function to manage ACSM instruction space.
 *
 * \param phyctx    Data structure to hold user-defined parameters.
 * \param inPsLoop  Flag to indicate if the function is called during the
 *                  PState loop sequence.
 *
 * \return The MRW dly that was used to space out the MRW.
 *
 */
static uint16_t loadAcsmMRW(phyinit_config_t *phyctx, int inPsLoop)
{
    user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
    runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
    PMU_SMB_LPDDR4X_1D_t *mb1D = phyctx->mb_LPDDR4X_1D;

    uint8_t prog_csr = (pRuntimeConfig->initCtrl & 0x1) >> 0;
    uint16_t skipMr = (prog_csr == 0) ? 1: 0;
    uint8_t cs = (pUserInputBasic->NumRank == 2) ? 0xf : 0x5;	// for 2CK commands
    uint8_t tg0 = 0x5;
    uint8_t tg1 = (pUserInputBasic->NumRank == 2) ? 0xa : 0x0;
	uint16_t dly = 4;

    uint8_t fspMrwSections[2] = { pUserInputBasic->FirstPState, -1 };
    
    // In the PState loop, configure current PState
    if (inPsLoop) {
        fspMrwSections[0] = pRuntimeConfig->curPState;
    } else {
        // After PState loop, configure ACSM memory with both PStates
        if (pUserInputBasic->NumPStates == 2) {
            if (pUserInputBasic->FirstPState == 1) {
                fspMrwSections[0] = 0;
                fspMrwSections[1] = 1;
            } else {
                fspMrwSections[0] = 1;
                fspMrwSections[1] = 0;
            }
        }
    }

    for (int fsp=0; fsp<2; fsp++) {

        uint8_t trgtPs = fspMrwSections[fsp];
        if (trgtPs > 14) { break; }

        if (pUserInputBasic->NumPStates > 2) {
            acsmInstPtr = ACSM_MRW_START_ADDR;
        }

        uint16_t start = (pUserInputBasic->NumPStates < 3) ? acsmInstPtr / 4 : ACSM_MRW_START_ADDR / 4;
        uint16_t startSectionA, startSectionB;
        uint16_t dmaStartMR;
		//uint8_t trgtPs = (pUserInputBasic->NumPStates < 3 && pstate == 1) ? 0 : (pUserInputBasic->NumPStates < 3 && pstate == 0) ? 1 : pstate;
		uint8_t pstate = trgtPs;
		uint16_t tck_ps = 1000000ul / pUserInputBasic->Frequency[pstate];	//getSlowestCK(phyctx);
		dly = 10000 / tck_ps + 1;	// 10ns in counts


        _IF_LPDDR5(
            if (tck_ps <= 1670) {
                dly = 4;
            } else {
                dly = 3;
            }
        )

        _IF_LPDDR4(
            if (pUserInputBasic->NumPStates < 3) {
                //acsmClkRatio = 1 << pUserInputBasic->DfiFreqRatio[pstate];
                acsmClkRatio = 4; // 1 << pUserInputBasic->DfiFreqRatio[pstate];
            } else {
            acsmClkRatio = 4;	// 1 << pUserInputBasic->DfiFreqRatio[pstate];
            }
        
            dly = 3;
        )

        if (dly > 100) {
            dwc_ddrphy_phyinit_assert(0, " [%s] Unexpected dly value. dly=%d\n", __func__, dly);
        }

#ifdef _BUILD_LPDDR5
         uint8_t vbsMask[4];
#endif

        _IF_LPDDR5(
            // For X16 devices, send MR12 twice.
            // For X8  devices, send MR12 for VBS = 0 and 1
            for (int rank = 0; rank < 4; rank++) {
                vbsMask[rank] = mb1D[trgtPs].X8Mode & (1 << rank) ? 0x80 : 0x00;
            }

            dwc_ddrphy_phyinit_cmnt(" [%s] MR1=0x%x\n", __func__, mb1D[trgtPs].MR1_A0);
            dwc_ddrphy_mr_inst(19, mb1D[trgtPs].MR19_A0,  cs, dly);	// 
            dwc_ddrphy_mr_inst(18, mb1D[trgtPs].MR18_A0,  cs, dly);
            dwc_ddrphy_mr_inst(1,  mb1D[trgtPs].MR1_A0,   cs, dly);
            dwc_ddrphy_mr_inst(2,  mb1D[trgtPs].MR2_A0,   cs, dly);
            dwc_ddrphy_mr_inst(3,  mb1D[trgtPs].MR3_A0,   cs, dly);
            dwc_ddrphy_mr_inst(10, mb1D[trgtPs].MR10_A0,  cs, dly);
            dwc_ddrphy_mr_inst(11, mb1D[trgtPs].MR11_A0,  cs, dly);
            dwc_ddrphy_mr_inst(17, mb1D[trgtPs].MR17_A0, tg0,   0); // MR17_A0 for MR17_B0 as well
            dwc_ddrphy_mr_inst(17, mb1D[trgtPs].MR17_A1, tg1, dly); // MR17_A1 for MR17_B1 as well
            dwc_ddrphy_mr_inst(20, mb1D[trgtPs].MR20_A0,  cs, dly);
            dwc_ddrphy_mr_inst(22, mb1D[trgtPs].MR22_A0,  cs, dly);
            dwc_ddrphy_mr_inst(41, mb1D[trgtPs].MR41_A0,  cs,   0);

            startSectionA = (acsmInstPtr / 4);
            dwc_ddrphy_phyinit_regInterface(setGroup, 0, 0); // flush writes to DMA memory
            dmaStartMR = dmaIdxGrp[regGrp];

            // Trained Mode Registers: per rank, per channel
            // Channel A
            dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_A0 & (~vbsMask[0]), tg0,   0, skipMr);	// Vref CA (lower byte for x8)
            dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_A1 & (~vbsMask[1]), tg1, dly, skipMr);
            dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_A0 | ( vbsMask[0]), tg0,   0, skipMr);	// Vref CA upper byte for x8 (use same value for lower/upper in skipTrain)
            dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_A1 | ( vbsMask[1]), tg1, dly, skipMr);
            dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_A0, tg0,   0, skipMr);	// Vref DQ [7:0]
            dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_A1, tg1, dly, skipMr);
            dwc_ddrphy_mr_load_cond(15, mb1D[trgtPs].MR15_A0, tg0,   0, skipMr);	// Vref DQ [15:8]
            dwc_ddrphy_mr_load_cond(15, mb1D[trgtPs].MR15_A1, tg1, dly, skipMr);
            dwc_ddrphy_mr_load_cond(24, mb1D[trgtPs].MR24_A0, tg0,   0, skipMr);	// DFE
            dwc_ddrphy_mr_load_cond(24, mb1D[trgtPs].MR24_A1, tg1, dly, skipMr);
            dwc_ddrphy_mr_load_cond(30, mb1D[trgtPs].MR30_A0, tg0,   0, skipMr);	// DCA
            dwc_ddrphy_mr_load_cond(30, mb1D[trgtPs].MR30_A1, tg1,   0, skipMr);

            startSectionB = (acsmInstPtr / 4);

            // Channel B
            if (pUserInputBasic->NumCh == 2 && pUserInputBasic->NumActiveDbyteDfi1 != 0) {
                dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_B0 & (~vbsMask[2]), tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_B1 & (~vbsMask[3]), tg1, dly, skipMr);
                dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_B0 | ( vbsMask[2]), tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_B1 | ( vbsMask[3]), tg1, dly, skipMr);
                dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_B0, tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_B1, tg1, dly, skipMr);
                dwc_ddrphy_mr_load_cond(15, mb1D[trgtPs].MR15_B0, tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(15, mb1D[trgtPs].MR15_B1, tg1, dly, skipMr);
                dwc_ddrphy_mr_load_cond(24, mb1D[trgtPs].MR24_B0, tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(24, mb1D[trgtPs].MR24_B1, tg1, dly, skipMr);
                dwc_ddrphy_mr_load_cond(30, mb1D[trgtPs].MR30_B0, tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(30, mb1D[trgtPs].MR30_B1, tg1,   0, skipMr);
            } else {
                dwc_ddrphy_mr_clear(12, mb1D[trgtPs].MR12_B0 & (~vbsMask[2]), tg0,   0);
                dwc_ddrphy_mr_clear(12, mb1D[trgtPs].MR12_B1 & (~vbsMask[3]), tg1, dly);
                dwc_ddrphy_mr_clear(12, mb1D[trgtPs].MR12_B0 | ( vbsMask[2]), tg0,   0);
                dwc_ddrphy_mr_clear(12, mb1D[trgtPs].MR12_B1 | ( vbsMask[3]), tg1, dly);
                dwc_ddrphy_mr_clear(14, mb1D[trgtPs].MR14_B0, tg0,   0);
                dwc_ddrphy_mr_clear(14, mb1D[trgtPs].MR14_B1, tg1, dly);
                dwc_ddrphy_mr_clear(15, mb1D[trgtPs].MR15_B0, tg0,   0);
                dwc_ddrphy_mr_clear(15, mb1D[trgtPs].MR15_B1, tg1, dly);
                dwc_ddrphy_mr_clear(24, mb1D[trgtPs].MR24_B0, tg0,   0);
                dwc_ddrphy_mr_clear(24, mb1D[trgtPs].MR24_B1, tg1, dly);
                dwc_ddrphy_mr_clear(30, mb1D[trgtPs].MR30_B0, tg0,   0);
                dwc_ddrphy_mr_clear(30, mb1D[trgtPs].MR30_B1, tg1,   0);
            }
        )
        _IF_LPDDR4(
            dwc_ddrphy_mr_inst(1,  mb1D[trgtPs].MR1_A0,   cs, dly);
            dwc_ddrphy_mr_inst(2,  mb1D[trgtPs].MR2_A0,   cs, dly);
            dwc_ddrphy_mr_inst(3,  mb1D[trgtPs].MR3_A0,   cs, dly);
            dwc_ddrphy_mr_inst(11, mb1D[trgtPs].MR11_A0,  cs, dly);
            dwc_ddrphy_mr_inst(22, mb1D[trgtPs].MR22_A0, tg0,   0); // MR22_A0 for MR22_B0 as well
            dwc_ddrphy_mr_inst(22, mb1D[trgtPs].MR22_A1, tg1, dly); // MR22_A1 for MR22_B1 as well

            if (pUserInputBasic->Lp4xMode) {
                dwc_ddrphy_mr_inst(21, mb1D[trgtPs].MR21_A0, cs, dly);
                dwc_ddrphy_mr_inst(51, mb1D[trgtPs].MR51_A0, cs,   0);
            } else {
                // Reserve space if not programming them
                dwc_ddrphy_mr_clear(21, mb1D[trgtPs].MR21_A0, cs, dly);
                dwc_ddrphy_mr_clear(51, mb1D[trgtPs].MR51_A0, cs,   0);
            }

            startSectionA = (acsmInstPtr / 4);
            dwc_ddrphy_phyinit_regInterface(setGroup, 0, 0); // flush writes to DMA memory
            dmaStartMR = dmaIdxGrp[regGrp];

            // Trained Mode Registers: per rank, per channel
            // Channel A
            dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_A0, tg0,   0, skipMr);	// Vref CA
            dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_A1, tg1, dly, skipMr);
            dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_A0, tg0,   0, skipMr);	// Vref DQ
            dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_A1, tg1,   0, skipMr);

            startSectionB = (acsmInstPtr / 4);

            if (pUserInputBasic->NumCh == 2 && pUserInputBasic->NumActiveDbyteDfi1 != 0) {
                // Channel B
                dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_B0, tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(12, mb1D[trgtPs].MR12_B1, tg1, dly, skipMr);
                dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_B0, tg0,   0, skipMr);
                dwc_ddrphy_mr_load_cond(14, mb1D[trgtPs].MR14_B1, tg1,   0, skipMr);
            } else {
                dwc_ddrphy_mr_clear(12, mb1D[trgtPs].MR12_B0, tg0,   0);
                dwc_ddrphy_mr_clear(12, mb1D[trgtPs].MR12_B1, tg1, dly);
                dwc_ddrphy_mr_clear(14, mb1D[trgtPs].MR14_B0, tg0,   0);
                dwc_ddrphy_mr_clear(14, mb1D[trgtPs].MR14_B1, tg1,   0);
            }
        )

        uint16_t stop = (acsmInstPtr / 4) - 1;	// acsmInstPtr tracks current position

        if (inPsLoop) {
            dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d Using MRW start address 0x%x.\n", __func__, pstate, start);
            dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d Using MRW Ch A address 0x%x.\n", __func__, pstate, startSectionA);
            dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d Using MRW Ch B address 0x%x.\n", __func__, pstate, startSectionB);
            dwc_ddrphy_phyinit_cmnt(" [%s] Pstate=%d Using MRW stop address 0x%x.\n", __func__, pstate, stop);

            // Check ACSM message block field values that were passed down to firmware earlier
            if (pUserInputBasic->NumPStates == 2 && pUserInputBasic->FirstPState != pstate) {

                if (mb1D[pstate].FCDfi0AcsmStartPSY != startSectionA) {
                    dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d Mismatch for FCDfi0AcsmStartPSY 0x%x vs ACSM Ch0 addr 0x%x\n",
                            __func__, pstate, mb1D[pstate].FCDfi0AcsmStartPSY, startSectionA);
                }

                if (mb1D[pstate].FCDfi1AcsmStartPSY != startSectionB) {
                    dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d Mismatch for FCDfi1AcsmStartPSY 0x%x vs ACSM Ch1 addr 0x%x\n", 
                            __func__, pstate, mb1D[pstate].FCDfi1AcsmStartPSY, startSectionB);
                }
            } else {

                if (mb1D[pstate].FCDfi0AcsmStart != startSectionA) {
                    dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d Mismatch for FCDfi0AcsmStart 0x%x vs ACSM Ch0 addr 0x%x\n",
                            __func__, pstate, mb1D[pstate].FCDfi0AcsmStart, startSectionA);
                }

                if (mb1D[pstate].FCDfi1AcsmStart != startSectionB) {
                    dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d Mismatch for FCDfi1AcsmStart 0x%x vs ACSM Ch1 addr 0x%x\n", 
                            __func__, pstate, mb1D[pstate].FCDfi1AcsmStart, startSectionB);
                }
            }

            // Check PS SRAM message block field value that was passed down to firmware earlier
            if (pUserInputBasic->NumPStates > 2) {
                uint16_t pstateDmaEntrySize = (uint16_t)ramSize;
                uint16_t pstateDmaAddr = dwc_ddrphy_phyinit_getPsBase(pstate) * pstateDmaEntrySize;
                uint16_t fcDmaStartMR = mb1D[pstate].FCDMAStartMR;

                // 4 ACSM rows per MR, 2 DMA entries
                if ((startSectionA - start) * 2 != (fcDmaStartMR - pstateDmaAddr) || (dmaStartMR != fcDmaStartMR - pstateDmaAddr)) {
                    dwc_ddrphy_phyinit_assert(0, " [%s] Pstate=%d Mismatch for FCDMAStartMR 0x%x, ACSM Ch0 row offset 0x%x\n", 
                            __func__, pstate, fcDmaStartMR, startSectionA - start);
                }
            }
        }
    }

    return dly;
}

static uint8_t highestDataRatePState(phyinit_config_t *phyctx)
{
    user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
    uint8_t ps = 0;
    uint16_t rate = 0;

	for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
		if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) {
			continue;
		}
 
		if ((pUserInputBasic->Frequency[pstate] << pUserInputBasic->DfiFreqRatio[pstate]) > rate) {
			rate = pUserInputBasic->Frequency[pstate] << pUserInputBasic->DfiFreqRatio[pstate];
			ps = pstate;
		}
	}

    return ps;
}

/** @} */
