/** \file
 *  \brief routine to save registers for IO retention restore
 *  \addtogroup CustFunc
 *  @{
 */
#include <stdlib.h>
#include <math.h>
#include "dwc_ddrphy_phyinit.h"

/** \brief This function can be used to implement saving of PHY registers to be
 * restored on retention exit.
 *
 * The requirement of this function is to issue register reads and store the
 * value to be recovered on retention exit.  The following is an example
 * implementation and the user may implement alternate methods that suit their
 * specific SoC system needs.
 *
 * In this implementation PhyInit saves register values in an internal C array.
 * During retention exit it restores register values from the array.  The exact
 * list of registers to save and later restore can be seen in the output txt
 * file with an associated calls to dwc_ddrphy_phyinit_usercustom_io_read16().
 *
 * PhyInit provides a register interface and a tracking mechanism to minimize
 * the number registers needing restore. Refer to source code for
 * dwc_ddrphy_phyinit_regInterface() for detailed implementation of tracking
 * mechanism. Tracking is disabled from step D to Step H as these involve
 * loading, executing and checking the state of training firmware execution
 * which are not required to implement the retention exit sequence. The registers
 * specified in firmware training App Note representing training results are
 * also saved in addition to registers written by PhyInit during PHY
 * initialization.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \returns \c void
 */
void dwc_ddrphy_phyinit_userCustom_saveRetRegs(phyinit_config_t *phyctx)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;

	dwc_ddrphy_phyinit_cmnt(" [%s] start of %s\n", __func__, __func__);
	dwc_ddrphy_phyinit_cmnt("\n\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// Customer Save Retention Registers\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// This function can be used to implement saving of PHY registers to be\n");
	dwc_ddrphy_phyinit_cmnt("// restored on retention exit. the following list of register reads can\n");
	dwc_ddrphy_phyinit_cmnt("// be used to compile the exact list of registers.\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n\n");

	/// In short the implementation of this function performs tasks:

	// --------------------------------------------------------------------------
	/// 1. Enable tracking of training firmware result registers\n
	///    See firmware training App Note section "IO Retention" for reference
	///    table registers that need to be saved.
	///
	///    \note  The tagged registers in this step are in
	///    addition to what is automatically tagged during Steps C to I.
	///
	// --------------------------------------------------------------------------

	// 95% of users should not require to change the code below.
	int pstate;
	int anib;
	int byte;
	int lane;
	int p_addr;
	int c_addr;
	int r_addr;

	int NumDbyte = pUserInputBasic->NumCh * pUserInputBasic->NumDbytesPerCh;

	dwc_ddrphy_phyinit_trackReg(tMASTER | csr_PllCtrl3_ADDR);

	// Non-PState Dbyte Registers
	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_PptCtlStatic_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_TrainingIncDecDtsmEn_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_DtsmByteCtrl0_ADDR);

		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq0LnSel_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq1LnSel_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq2LnSel_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq3LnSel_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq4LnSel_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq5LnSel_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq6LnSel_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_Dq7LnSel_ADDR);

		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_RxClkCntl_ADDR);
		dwc_ddrphy_phyinit_trackReg(tDBYTE | c_addr | csr_RxReplicaUICalWait_ADDR);
	} // c_addr

	// Anib Registers
	for (anib = 0; anib < pUserInputBasic->NumCh; anib++) {
		c_addr = anib << 12;
		dwc_ddrphy_phyinit_trackReg(tAC | c_addr | csr_DFIPHYUPD_ADDR);
	}

	if (pUserInputBasic->NumPStates > 2) {
		// DMA regisers
		for (pstate = 0; pstate < 16; pstate++) {
			dwc_ddrphy_phyinit_trackReg((tDRTUB	|	(csr_PsDmaXlatBase0_ADDR	+	pstate)));
		}
		for (int grp = 0; grp < 4; grp++) {
			dwc_ddrphy_phyinit_trackReg((tDRTUB | (csr_PsDmaXlatOffset0_ADDR + grp)));
			dwc_ddrphy_phyinit_trackReg((tDRTUB | (csr_PsDmaXlatLen0_ADDR + grp)));
		}
	}
	// PState variable registers
	for (pstate = 0; pstate < pUserInputBasic->NumPStates && pUserInputBasic->NumPStates < 3; pstate++) {
		p_addr = pstate << 20;

		// Anib Registers
		for (anib = 0; anib < pUserInputBasic->NumCh; anib++) {
			c_addr = anib << 12;
			dwc_ddrphy_phyinit_trackReg(p_addr | tAC | c_addr | csr_CKTxDly_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tAC | c_addr | csr_TxDcaMode_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tAC | c_addr | csr_TxACDcaCtrl_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tAC | c_addr | csr_TxCKDcaCtrlCKT_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tAC | c_addr | csr_TxCKDcaCtrlCKC_ADDR);

			for (lane = 0; lane < 10; lane++) {
				r_addr = lane << 8;
				dwc_ddrphy_phyinit_trackReg(p_addr | tAC | c_addr | r_addr | csr_ACTxDly_ADDR);
			}
		}

		// Dbyte Registers
		for (byte = 0; byte < NumDbyte; byte++) {
			c_addr = byte << 12;
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_DFIMRL_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaCtl01_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaCtl03_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaCtl04_ADDR);

			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxEnDlyTg0_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxEnDlyTg1_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDqsDlyTg0_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDqsDlyTg1_ADDR);

			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDQDcaCtrlTg0_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDQDcaCtrlTg1_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDQSDcaCtrlTTg0_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDQSDcaCtrlTTg1_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDQSDcaCtrlCTg0_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDQSDcaCtrlCTg1_ADDR);

			_IF_LPDDR5(
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxWckDlyTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxWckDlyTg1_ADDR);

				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxWCKDcaCtrlTTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxWCKDcaCtrlTTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxWCKDcaCtrlCTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxWCKDcaCtrlCTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxWCKDcaCtrlTTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxWCKDcaCtrlTTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxWCKDcaCtrlCTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxWCKDcaCtrlCTg1_ADDR);
			)
			for (lane = r_min; lane <= r_max; lane++) {
				r_addr = lane << 8;
				_IF_LPDDR5(
					dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxDigStrbDlyTg0_ADDR);
					dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxDigStrbDlyTg1_ADDR);
				)
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_TxDqDlyTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_TxDqDlyTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkT2UIDlyTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkT2UIDlyTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkC2UIDlyTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkC2UIDlyTg1_ADDR);
#if PUB!=1
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkTLeftEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkTLeftEyeOffsetTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkTRightEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkTRightEyeOffsetTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkCLeftEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkCLeftEyeOffsetTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkCRightEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_RxClkCRightEyeOffsetTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_TxDqLeftEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_TxDqLeftEyeOffsetTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_TxDqRightEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | r_addr | csr_TxDqRightEyeOffsetTg1_ADDR);
#endif
			} // r_addr
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_PptDqsCntInvTrnTg0_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_PptDqsCntInvTrnTg1_ADDR);
			_IF_LPDDR5(
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_PptWck2DqoCntInvTrnTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_PptWck2DqoCntInvTrnTg1_ADDR);
#if PUB!=1
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDqsLeftEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDqsLeftEyeOffsetTg1_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDqsRightEyeOffsetTg0_ADDR);
				dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_TxDqsRightEyeOffsetTg1_ADDR);
#endif
			)
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaPathPhase0_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaPathPhase1_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaPathPhase2_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaPathPhase3_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaPathPhase4_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaCtl01_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaCtl04_ADDR);
			dwc_ddrphy_phyinit_trackReg(p_addr | tDBYTE | c_addr | csr_RxReplicaCtl03_ADDR);
		} // c_addr
		// PIE Registers
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR1_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR2_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR3_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR4_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR5_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR6_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR7_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tINITENG | csr_Seq0BGPR8_ADDR);
		// Master Registers
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_DllGainCtl_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_AcDllLockParam_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_DxDllLockParam_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_PllDacValIn_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_HwtMRL_ADDR);

		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_ACSMRxEnPulse_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_ACSMRxValPulse_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_ACSMRdcsPulse_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_ACSMTxEnPulse_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_ACSMWrcsPulse_ADDR);

		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_RxReplicaDllLockParam_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_RxReplicaDllGainCtl_ADDR);

		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_AcPipeEn_ADDR);
		dwc_ddrphy_phyinit_trackReg(p_addr | tMASTER | csr_SingleEndedMode_ADDR);
	} // p_addr

	// Master Registers
	dwc_ddrphy_phyinit_trackReg(tMASTER | csr_HwtLpCsEnA_ADDR);
	dwc_ddrphy_phyinit_trackReg(tMASTER | csr_HwtLpCsEnB_ADDR);
	dwc_ddrphy_phyinit_trackReg(tMASTER | csr_HwtCtrl_ADDR);
	dwc_ddrphy_phyinit_trackReg(tMASTER | csr_LP5Mode_ADDR);

	// --------------------------------------------------------------------------
	/// 2. Track any additional registers\n
	///    Register writes made using the any of the PhyInit functions are
	///    automatically tracked using the call to dwc_ddrphy_phyinit_trackReg() in
	///    dwc_ddrphy_phyinit_userCustom_io_write16(). Use this section to track
	///     additional registers.
	// --------------------------------------------------------------------------

	/// Example:
	/// dwc_ddrphy_phyinit_trackReg(<addr>);

	// --------------------------------------------------------------------------
	/// 3. Prepare for register reads\n
	///    - Write the MicroContMuxSel CSR to 0x0 to allow access to the internal CSRs
	///    - Write the UcclkHclkEnables CSR to 0x3 to enable all the clocks so the reads can complete
	// --------------------------------------------------------------------------
    uint8_t lowest = 0;

	for (pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
		if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) {
			continue;
		}	
 
		lowest = pstate;
		break;
	}

	uint16_t pmuClkEnables = csr_HclkEn_MASK | csr_UcclkEn_MASK;

	if (pUserInputAdvanced->PmuClockDiv[lowest] == 0) {
		pmuClkEnables |= (uint16_t) csr_UcclkFull_MASK;
	}
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x0);
	dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | csr_UcclkHclkEnables_ADDR), pmuClkEnables);

	// --------------------------------------------------------------------------
	/// 4. Read and save all the registers
	///    - The list of registers differ depending on protocol and 1D or 1D+2D training.
	// --------------------------------------------------------------------------

	pRuntimeConfig->ZQCalCodePU_saved = dwc_ddrphy_phyinit_userCustom_io_read16(tMASTER | csr_ZQCalCodePU_ADDR);
	dwc_ddrphy_phyinit_cmnt(" [%s] Read csr_ZQCalCodePU, adr: 0x%x, and store its dat: 0x%x in runtime_config;\n", __func__, tMASTER | csr_ZQCalCodePU_ADDR, pRuntimeConfig->ZQCalCodePU_saved);

	pRuntimeConfig->ZQCalCodePD_saved = dwc_ddrphy_phyinit_userCustom_io_read16(tMASTER | csr_ZQCalCodePD_ADDR);
	dwc_ddrphy_phyinit_cmnt(" [%s] Read csr_ZQCalCodePD, adr: 0x%x, and store its dat: 0x%x in runtime_config;\n", __func__, tMASTER | csr_ZQCalCodePD_ADDR, pRuntimeConfig->ZQCalCodePD_saved);

	dwc_ddrphy_phyinit_regInterface(saveRegs, 0, 0);

	// --------------------------------------------------------------------------
	/// 5. Prepare for mission mode
	///    - Write the UcclkHclkEnables CSR to disable the appropriate clocks after all reads done.
	///    - Write the MicroContMuxSel CSR to 0x1 to isolate the internal CSRs during mission mode
	// --------------------------------------------------------------------------

	dwc_ddrphy_phyinit_cmnt(" [%s] Disabling Ucclk (PMU) and Hclk (training hardware)\n", __func__);
	dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | csr_UcclkHclkEnables_ADDR), 0x0);

	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x1);

	dwc_ddrphy_phyinit_cmnt(" [%s] End of %s\n", __func__, __func__);
}

/** @} */
