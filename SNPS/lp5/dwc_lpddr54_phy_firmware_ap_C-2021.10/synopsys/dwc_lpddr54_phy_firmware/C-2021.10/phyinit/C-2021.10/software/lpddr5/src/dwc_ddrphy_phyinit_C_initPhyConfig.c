/**
 * \file
 * \brief implements Step C of initialization sequence
 *
 * This file contains the implementation of dwc_ddrphy_phyinit_C_initPhyConfig
 * function.
 *
 * \addtogroup SrcFunc
 * @{
 */
#include <stdlib.h>
#include <math.h>
#include "dwc_ddrphy_phyinit.h"

/** \brief implements Step C of initialization sequence
 *
 * This function programs majority of PHY Non-Pstate configuration registers based
 * on data input into PhyInit data structures.
 *
 * This function programs PHY configuration registers based on information
 * provided in the PhyInit data structures (userInputBasic, userInputAdvanced).
 * The user can overwrite the programming of this function by modifying
 * dwc_ddrphy_phyinit_userCustom_customPreTrain().  Please see
 * dwc_ddrphy_phyinit_struct.h for PhyInit data structure definition.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 *
 * List of registers programmed by this function:
 */
void dwc_ddrphy_phyinit_C_initPhyConfig(phyinit_config_t *phyctx)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;

	PMU_SMB_LPDDR5_1D_t *mb1D = phyctx->mb_LPDDR5_1D;

	dwc_ddrphy_phyinit_cmnt("\n\n");
	dwc_ddrphy_phyinit_cmnt("##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt(" Step (C) Initialize PHY Configuration\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt(" Load the required PHY configuration registers for the appropriate mode and memory configuration\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n\n");

	int achn;
	int c_addr;
	int byte;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Start of %s()\n", __func__);

	// Initialize the register interface
	dwc_ddrphy_phyinit_initReg(phyctx);

	int NumDbyte = pUserInputBasic->NumCh * pUserInputBasic->NumDbytesPerCh;
	int NumAchn = pUserInputBasic->NumCh;


#ifdef _BUILD_LPDDR5
	uint16_t MemResetL = csr_ProtectMemReset_MASK;
#endif
	_IF_LPDDR5(
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming MemResetL to 0x%x\n", MemResetL);
		dwc_ddrphy_phyinit_userCustom_io_write16((tMASTER | csr_MemResetL_ADDR), MemResetL);
	)


#ifdef _BUILD_LPDDR5
	/**
	 * - Program LP5Mode:
	 *   - Dependencies:
	 *     - user_input_basic.DramType
	 */
	uint16_t isLP5Mode = 1;
#endif

	_IF_LPDDR5(
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming LP5Mode to 0x%x\n", isLP5Mode);
		dwc_ddrphy_phyinit_io_write16((tMASTER | csr_LP5Mode_ADDR), isLP5Mode);
	)

	/**
	 * - Program NeverGateAcCsrClock:
	 */
	uint16_t NeverGateAcCsrClock = 0;
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming NeverGateAcCsrClock to 0x%x\n", NeverGateAcCsrClock);
	dwc_ddrphy_phyinit_io_write16((tAPBONLY | csr_NeverGateAcCsrClock_ADDR), NeverGateAcCsrClock);

	/**
	 * - Program PhyPerfCtrEnable:
	 */
	uint16_t PhyPerfCtrEnable = 0xff;
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming PhyPerfCtrEnable to 0x%x\n", PhyPerfCtrEnable);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_PhyPerfCtrEnable_ADDR), PhyPerfCtrEnable);

	/**
	 * - Program ZCalRZN:
	 *   - Fields:
	 *     - ZCalStrenCodePU
	 *     - ZCalStrenCodePD
	 *   - Dependencies:
	 *     - user_input_advanced.ExtCalResVal
	 */
	int ZCalRZN;
	int ZCalStrenCodePU;
	int ZCalStrenCodePD;

	switch (pUserInputAdvanced->ExtCalResVal) {
	case 120:
		ZCalStrenCodePU = 0x8;
		break;
	case 60:
		ZCalStrenCodePU = 0xc;
		break;
	case 40:
		ZCalStrenCodePU = 0xe;
		break;
	case 30:
		ZCalStrenCodePU = 0xf;
		break;
	case 0:
		ZCalStrenCodePU = 0x0;
		break;
	default:
		dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfig] invalid pUserInputAdvanced->ExtCalResVal=%d\n", pUserInputAdvanced->ExtCalResVal);
		break;
	}

#ifdef _BUILD_LPDDR4
	// Look at DRAM MR3-OP[0] from channel A and rank 0 for FirstPstate
	int mr3_op0;
	int higherVOHLp4;
#endif

	_IF_LPDDR4(
		mr3_op0 = mb1D[pUserInputBasic->FirstPState].MR3_A0 & 0x1;
		higherVOHLp4 = (mr3_op0 == 0) ? 1 : 0;
		if (pUserInputBasic->Lp4xMode == 0 && higherVOHLp4 == 1 && pUserInputAdvanced->ExtCalResVal == 120) {
			ZCalStrenCodePU = 0xc;
		}
	)
	ZCalStrenCodePD = ZCalStrenCodePU;
	ZCalRZN = (ZCalStrenCodePD << csr_ZCalStrenCodePD_LSB) | (ZCalStrenCodePU << csr_ZCalStrenCodePU_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalRZN::ZCalStrenCodePU to 0x%x\n", ZCalStrenCodePU);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalRZN::ZCalStrenCodePD to 0x%x\n", ZCalStrenCodePD);

	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_ZCalRZN_ADDR), ZCalRZN);

   /**
	* - Program ZCalRate:
	*   - Fields:
	*     - ZCalInterval
	*     - ZCalOnce
	*   - Dependencies:
	*     - user_input_advanced.CalInterval
	*     - user_input_advanced.CalOnce
	*/

	int ZCalRate;
	int ZCalInterval;
	int ZCalOnce;

	ZCalInterval = pUserInputAdvanced->CalInterval;
	ZCalOnce = pUserInputAdvanced->CalOnce;

	ZCalRate = (ZCalOnce << csr_ZCalOnce_LSB) | (ZCalInterval << csr_ZCalInterval_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalRate::ZCalInterval to 0x%x\n", ZCalInterval);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalRate::ZCalOnce to 0x%x\n", ZCalOnce);

	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_ZCalRate_ADDR), ZCalRate);

	/**
	 * - Program ZCalCompVref
	 *   - Fields:
	 *     - ZCalCompVrefDAC
	 *     - ZCalDACRangeSel
	 *   - Dependencies for LPDDR4
	 *     - user_input_basic.Lp4xMode
	 */

	uint16_t ZCalCompVrefDAC;
	uint16_t ZCalDACRangeSel;

	_IF_LPDDR4(
		if (pUserInputBasic->Lp4xMode == 0) {
			ZCalDACRangeSel = 1;
			ZCalCompVrefDAC = (higherVOHLp4 == 1) ? 0x44 : 0x29;
		} else {
			ZCalDACRangeSel = 0;
			ZCalCompVrefDAC = (higherVOHLp4 == 1) ? 0x5A : 0x26;
		}
	)

	_IF_LPDDR5(
		ZCalDACRangeSel = 0;
		ZCalCompVrefDAC = 0x26;
	)

	uint16_t ZCalCompVref = (ZCalCompVrefDAC << csr_ZCalCompVrefDAC_LSB) | (ZCalDACRangeSel << csr_ZCalDACRangeSel_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalCompVref::ZCalCompVrefDAC to 0x%x\n", ZCalCompVrefDAC);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalCompVref::ZCalDACRangeSel to 0x%x\n", ZCalDACRangeSel);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_ZCalCompVref_ADDR), ZCalCompVref);

	/**
	 * - Program VrefDacRefCtl
	 *   - Fields:
	 *     - DacRefModeCtl
	 *     - DacRefPwrDn
	 *   - Dependencies of LPDDR4
	 *     - user_input_basic.Lp4xMode
	 */
	uint16_t DacRefModeCtl = 0;
	uint16_t DacRefPwrDn = 0;

	_IF_LPDDR4(
		if (pUserInputBasic->Lp4xMode == 0) {
			DacRefModeCtl = 1;
		}
	)
	uint16_t VrefDacRefCtl = (DacRefPwrDn << csr_DacRefPwrDn_LSB) | (DacRefModeCtl << csr_DacRefModeCtl_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming VrefDacRefCtl::DacRefModeCtl to 0x%x\n", DacRefModeCtl);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming VrefDacRefCtl::DacRefPwrDn to 0x%x\n", DacRefPwrDn);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_VrefDacRefCtl_ADDR), VrefDacRefCtl);

	/**
	 * - Program ZCalBaseCtrl
	 *   - Fields:
	 *     - ZCalBasePU
	 *     - ZCalBasePD
	 *     - ZCalTxModeCtl
	 *   - Dependencies of LPDDR4
	 *     - user_input_basic.Lp4xMode
	 */
	uint16_t valZCalBasePU = 0x1;
	uint16_t valZCalBasePD = 0x1;
	uint16_t valTxModeCtl;
	uint16_t valWeakPullDown = 0x0;

	_IF_LPDDR4(
		if ((pUserInputBasic->Lp4xMode == 0) && (higherVOHLp4 == 1)) {
		   valTxModeCtl = (0x1 << 1);
		} else {
		   valTxModeCtl = (0x0 << 1);
		}
	)

	_IF_LPDDR5(
		valTxModeCtl = (0x0 << 1);
	)

	valTxModeCtl |= valWeakPullDown;

	uint16_t valZCalBaseCtrl = (valZCalBasePU << csr_ZCalBasePU_LSB) | (valZCalBasePD << csr_ZCalBasePD_LSB) | (valTxModeCtl << csr_ZCalTxModeCtl_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalBaseCtrl::ZCalBasePU to 0x%x\n", valZCalBasePU);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalBaseCtrl::ZCalBasePD to 0x%x\n", valZCalBasePD);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalBaseCtrl::ZCalTxModeCtl to 0x%x\n", valTxModeCtl);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalBaseCtrl to 0x%x\n", valZCalBaseCtrl);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_ZCalBaseCtrl_ADDR), valZCalBaseCtrl);

	/**
	 * - Program ZCalCompCtrl
	 *   - Fields:
	 *     - ZCalCompGainCurrAdj
	 *     - ZCalCompGainResAdj
	 *   - Dependencies
	 *     - user_input_advanced.CalImpedanceCurrentAdjustment
	 */
	uint16_t valZCalCompGainCurrAdj = pUserInputAdvanced->CalImpedanceCurrentAdjustment;
	uint16_t valZCalCompGainResAdj = 0x0;
	uint16_t valZCalCompCtrl = (valZCalCompGainCurrAdj << csr_ZCalCompGainCurrAdj_LSB) | (valZCalCompGainResAdj << csr_ZCalCompGainResAdj_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalCompCtrl::ZCalCompGainCurrAdj to 0x%x\n", valZCalCompGainCurrAdj);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalCompCtrl::ZCalCompGainResAdj to 0x%x\n", valZCalCompGainResAdj);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ZCalCompCtrl to 0x%x\n", valZCalCompCtrl);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_ZCalCompCtrl_ADDR), valZCalCompCtrl);

	/**
	 * - Program DFIPHYUPD
	 *   - Fields:
	 *     - DFIPHYUPDRESP
	 *     - DFIPHYUPDCNT
	 *   - Dependencies:
	 *     - user_input_advanced.DisablePhyUpdate
	 */
	if (pUserInputAdvanced->DisablePhyUpdate != 0) {
		for (achn = 0; achn < NumAchn; achn++) {
			c_addr = achn << 12;
			dwc_ddrphy_phyinit_io_write16((tAC | c_addr | csr_DFIPHYUPD_ADDR), 0);
		}
	}

	if (pUserInputBasic->NumRank_dfi0 > pUserInputBasic->NumRank || pUserInputBasic->NumRank_dfi1 > pUserInputBasic->NumRank) {
		dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfig] Invalid user inputs: NumRank_dfi0 (%d) and NumRank_dfi1 (%d) cannot exceed NumRank (%d)\n", pUserInputBasic->NumRank_dfi0, pUserInputBasic->NumRank_dfi1, pUserInputBasic->NumRank);
	}

	/**
	 * - Program DfiClkAcLnDis PClkAcLnDis, AcLnDisable (AC)
	 * - Dependencies:
	 *   - user_input_basic.NumCh
	 *   - user_input_basic.NumRank_dfi0
	 *   - user_input_basic.NumRank_dfi1
	 */
	uint16_t data_ch0;
	uint16_t data_ch1;

	_IF_LPDDR4(
		data_ch0 = (pUserInputBasic->NumRank == 2) ? ((pUserInputBasic->NumRank_dfi0 == 1) ? 0x280 : 0x0) : 0x280;
		data_ch1 = (NumAchn == 2) ? (pUserInputBasic->NumRank_dfi1 == 1 ? 0x280 : 0x0) : 0x7ff;
	)

	_IF_LPDDR5(
		data_ch0 = (pUserInputBasic->NumRank == 2) ? (pUserInputBasic->NumRank_dfi0 == 1 ? 0x280 : 0x80) : 0x280;
		data_ch1 = (NumAchn == 2) ? (pUserInputBasic->NumRank_dfi1 == 1 ? 0x280 : 0x80) : 0x7ff;
	)
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming AC%d.DfiClkAcLnDis to 0x%x\n", 0, data_ch0);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming AC%d.PClkAcLnDis to 0x%x\n", 0, data_ch0);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming AC%d.AcLnDisable to 0x%x\n", 0, data_ch0);
	dwc_ddrphy_phyinit_io_write16((c0 | tAC | csr_PClkAcLnDis_ADDR), data_ch0);
	dwc_ddrphy_phyinit_io_write16((c0 | tAC | csr_DfiClkAcLnDis_ADDR), data_ch0);
	dwc_ddrphy_phyinit_io_write16((c0 | tAC | csr_AcLnDisable_ADDR), data_ch0);

	if (NumAchn > 1) {
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming AC%d.DfiClkAcLnDis to 0x%x\n", 1, data_ch1);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming AC%d.PClkAcLnDis to 0x%x\n", 1, data_ch1);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming AC%d.AcLnDisable to 0x%x\n", 1, data_ch1);
		dwc_ddrphy_phyinit_io_write16((c1 | tAC | csr_PClkAcLnDis_ADDR), data_ch1);
		dwc_ddrphy_phyinit_io_write16((c1 | tAC | csr_DfiClkAcLnDis_ADDR), data_ch1);
		dwc_ddrphy_phyinit_io_write16((c1 | tAC | csr_AcLnDisable_ADDR), data_ch1);
	}

	/*
	 * - Program ArcPmuEccCtl (PMU ECC)
	 *   - Dependencies:
	 *     - user_input_advanced.DisablePmuEcc
	 */
	uint16_t disableEcc = pUserInputAdvanced->DisablePmuEcc;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming ArcPmuEccCtl to 0x%x\n", disableEcc);
	dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_ArcPmuEccCtl_ADDR), disableEcc);
	if (disableEcc == 1) {
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming PhyInterruptEnable::PhyEccEn to 0x0\n");
		dwc_ddrphy_phyinit_io_write16((tMASTER | csr_PhyInterruptEnable_ADDR), (0 << csr_PhyEccEn_LSB));
	}

	/**
	 * - Program PptCtlStatic
	 *   - Fields:
	 *     - DOCByteSelTg0/1
	 *     - PptEnRxEnBackOff
	 *   - Dependencies:
	 *     - DramType
	 *     - DramDataWidth
	 *     - DramByteSwap
	 */
	uint16_t regData;

	for (byte = 0; byte < NumDbyte; byte++) { // Each Dbyte could have a different configuration.
		uint16_t PptEnRxEnBackOff;

		_IF_LPDDR4(
			PptEnRxEnBackOff = 0x1;
		)
		_IF_LPDDR5(
			PptEnRxEnBackOff = 0x2;
		)

		uint16_t DOCByteTg0, DOCByteTg1;
		uint16_t ps = pUserInputBasic->FirstPState;

		c_addr = byte * c1;
		if (pUserInputBasic->DramDataWidth == 8) {
			if (mb1D[ps].X8Mode == 0xf) {
				// all ranks are bytemode
				DOCByteTg0 = 0x0;
				DOCByteTg1 = 0x0;
			} else if (mb1D[ps].X8Mode == 0x5 && byte % 2 == 0) {
				// rank0 is byte mode
				DOCByteTg0 = 0x0;
				DOCByteTg1 = 0x0;
			} else if (mb1D[ps].X8Mode == 0x5 && byte % 2 == 1) {
				DOCByteTg0 = 0x0;
				DOCByteTg1 = 0x1;
			} else if (mb1D[ps].X8Mode == 0xa && byte % 2 == 0) {
				// rank1 is byte mode
				DOCByteTg0 = 0x0;
				DOCByteTg1 = 0x0;
			} else if (mb1D[ps].X8Mode == 0xa && byte % 2 == 1) {
				DOCByteTg0 = 0x1;
				DOCByteTg1 = 0x0;
			} else {
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfig] Unexpected value for mb1D[p%d].X8Mode == %d", ps, mb1D[ps].X8Mode);
			}
		} else if (byte % 2 == 0) {
			DOCByteTg0 = 0x1 & (pUserInputAdvanced->DramByteSwap >> byte);
			DOCByteTg1 = 0x1 & (pUserInputAdvanced->DramByteSwap >> byte);
		} else {
			DOCByteTg0 = 0x1 & ~(pUserInputAdvanced->DramByteSwap >> byte);
			DOCByteTg1 = 0x1 & ~(pUserInputAdvanced->DramByteSwap >> byte);
		}

		uint8_t PptRxEnTg0;
		uint8_t PptRxEnTg1;
		uint8_t PptEnTg1;

		PptRxEnTg0 = (pUserInputAdvanced->DisableRetraining) ? 0x0 : 0x1;
		PptRxEnTg1 = (pUserInputAdvanced->DisableRetraining) ? 0x0 : (((pUserInputBasic->NumRank_dfi0 == 2) || (pUserInputBasic->NumRank_dfi1 == 2)) ? 0x1 : 0x0);
		PptEnTg1 = (((pUserInputBasic->NumRank_dfi0 == 2) || (pUserInputBasic->NumRank_dfi1 == 2)) ? 0x1 : 0x0);
		regData = (0x1 << csr_PptEnDqs2DqTg0_LSB |
				   PptEnTg1 << csr_PptEnDqs2DqTg1_LSB |
				   PptRxEnTg0 << csr_PptEnRxEnDlyTg0_LSB |
				   PptRxEnTg1 << csr_PptEnRxEnDlyTg1_LSB |
				   PptEnRxEnBackOff << csr_PptEnRxEnBackOff_LSB | DOCByteTg0 << csr_DOCByteSelTg0_LSB | DOCByteTg1 << csr_DOCByteSelTg1_LSB);

#ifdef _BUILD_LPDDR5
		uint8_t PptEnWck2DqoTg0 = 0x1;
		uint8_t PptEnWck2DqoTg1 = PptEnTg1;
#endif
		_IF_LPDDR5(
			regData |= PptEnWck2DqoTg0 << csr_PptEnWck2DqoTg0_LSB | PptEnWck2DqoTg1 << csr_PptEnWck2DqoTg1_LSB;
		)
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_PptCtlStatic_ADDR), regData);
	}


	for (byte = 0; byte < NumDbyte; byte++) { // for each dbyte
		c_addr = byte * c1;

	   /**
		* - Program RxReplicaUIcalwait based on userInputAdvanced.RxClkTrackWait
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming DBYTE%d.RxReplicaUIcalwait to %d\n", d, pUserInputAdvanced->RxClkTrackWait);
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_RxReplicaUIcalwait_ADDR), pUserInputAdvanced->RxClkTrackWait);
		*/

	   /**
		* - Program RxReplicanextcalwait based on userInputAdvanced.RxClkTrackWaitUI
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming DBYTE%d.RxReplicanextcalwait to %d\n", d, pUserInputAdvanced->RxClkTrackWaitUI);
		dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_RxReplicanextcalwait_ADDR), pUserInputAdvanced->RxClkTrackWaitUI);
		*/
	} // dbyte

	/**
	 * - Program PsDmaRamSize
	 *   - Dependencies:
	 *     - user_input_advanced.PsDmaRamSize

	 */
	if (pUserInputBasic->NumPStates > 2) {
		dwc_ddrphy_phyinit_io_write16((tDRTUB | csr_PsDmaRamSize_ADDR), pUserInputAdvanced->PsDmaRamSize);
	}

	/**
	 * - Program DfiXlat based on Pll Bypass Input
	 *   - Dependencies:
	 *     - user_input_basic.DramType
	 *     - user_input_basic.PllBypass
	 */
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming DfiFreqXlat*\n");

	uint8_t xlat[64] = { 0x0 };
	uint8_t idx;
	
	for (int ps = 0; ps < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; ps++) {
		uint16_t freqThreshold;
		_IF_LPDDR4(
			freqThreshold = 333;
		)

		_IF_LPDDR5(
			freqThreshold = pUserInputBasic->DfiFreqRatio[ps] == 1 ? 166 : 83;
		)

		if ((pUserInputBasic->CfgPStates & (0x1 << ps)) == 0) {
			continue;
		}
		if (pUserInputBasic->NumPStates < 3 && pUserInputBasic->DfiFreqRatio[ps] == 1) {
			if (ps>1) {dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfig] specified ps=%d is out of range (pUserInputBasic->NumPStates=%d)\n", ps, pUserInputBasic->NumPStates);}
			// if 2PS and if 1:2, then need to map P0->P7 or P1->P8
			idx = 32 + ps;
		} else {
			idx = (ps > 6) ? 32 + ps - 7 : ps;
		}
		xlat[idx] = (pUserInputBasic->Frequency[ps] < freqThreshold) ? 0x6 : // force relock only+bypass on slow frequencies.
			((pUserInputBasic->PllBypass[ps]) ? 0x1 : 0x0);	// determine bypass

		_IF_LPDDR5(
			uint16_t NoRDQS = ((mb1D[ps].MR20_A0 & 0x3) == 0x0);
			xlat[idx] += (pUserInputBasic->Frequency[ps] >= freqThreshold && NoRDQS) ? 0x5 : 0x0; // force relock only if NoRDQS by adding 5.
		)

		xlat[8 + idx] = 0x0; // RFU  Note: 8,9 actually used outside loop.
		xlat[16+idx] = (pUserInputAdvanced->RelockOnlyCntrl && pUserInputBasic->PllBypass[ps]) ? 0xa :
		               (pUserInputAdvanced->RelockOnlyCntrl) ? 0x9 :
		               (pUserInputBasic->Frequency[ps] < freqThreshold) ? 0x6 : // force relock only+bypass on slow frequencies.
		               ((pUserInputBasic->PllBypass[ps]) ? 0x6 : 0x5); // determine bypass
		xlat[24 + idx] = 0x2; // No Retrain, No Relock
	}
	xlat[7] = 0x6;				// P14 force relock only+bypass on slow frequencies.
	xlat[ 8] = 0x9;				// LP2 Pll Non-Bypass. 
	xlat[ 9] = 0xa;				// LP2 Bypass.
	xlat[15] = 0x8;				// PPT triggered by PhyMstr
	xlat[23] = 0x4;				// Retrain Only
	xlat[31] = 0xf;				// Enter LP3
	xlat[39] = 0x6;				// P14 force relock only+bypass on slow frequencies.
	xlat[40] = 0x9;				// LP2 Pll Non-Bypass. 
	xlat[41] = 0xa;				// LP2 Bypass.
	xlat[47] = 0x8;				// PPT triggered by PhyMstr
	xlat[55] = 0x4;				// Retrain Only
	xlat[63] = 0xf;				// Enter LP3

	uint16_t loopVector;

	for (loopVector = 0; loopVector < 16; loopVector++) {
		int xlatIdx = loopVector * 4;

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming xlat[%d]=%d\n", xlatIdx, xlat[xlatIdx]);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming xlat[%d]=%d\n", xlatIdx + 1, xlat[xlatIdx + 1]);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming xlat[%d]=%d\n", xlatIdx + 2, xlat[xlatIdx + 2]);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming xlat[%d]=%d\n", xlatIdx + 3, xlat[xlatIdx + 3]);

		regData = (xlat[xlatIdx + 3] << 12) | (xlat[xlatIdx + 2] << 8) | (xlat[xlatIdx + 1] << 4) | (xlat[xlatIdx]);
		if (regData == 0x0) {
			continue;
		}
		dwc_ddrphy_phyinit_io_write16((c0 | tDRTUB | (csr_DfiFreqXlat0_ADDR + loopVector)), regData);
	}
#if PUB!=1
	/// - program Seq0BFixedAddrBits
	dwc_ddrphy_phyinit_io_write16(c0 | tINITENG | (csr_Seq0BFixedAddrBits_ADDR), 0xf);
#endif

	/**
	 * - Program DbyteMiscMode
	 *   - Fields:
	 *     - DByteDisable
	 *   - see function dwc_ddrphy_phyinit_IsDbyteDisabled() to determine
	 *     which DBytes are turned off completely based on PHY configuration.
	 *   - Dependencies:
	 *     - user_input_basic.NumCh
	 *     - user_input_basic.NumDbytesPerCh
	 */
	for (byte = 0; byte < NumDbyte; byte++) { // for each dbyte
		c_addr = byte * c1;

		if (dwc_ddrphy_phyinit_IsDbyteDisabled(phyctx, byte)) {
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming DBYTE%d.DbyteMiscMode to disable Dbyte\n", byte);
			dwc_ddrphy_phyinit_io_write16((c_addr | tDBYTE | csr_DbyteMiscMode_ADDR), 0x1 << csr_DByteDisable_LSB);
		}
	} // for each dbyte


	/**
	 * - Program DfiMode:
	 *   - Dependencies:
	 *     - user_input_basic.DramType
	 *     - user_input_basic.NumActiveDbyteDfi0
	 *     - user_input_basic.NumActiveDbyteDfi1
	 */
	uint16_t DfiMode = 0x0;

	if (pUserInputBasic->NumActiveDbyteDfi0 != 0) {
		DfiMode |= csr_Dfi0Enable_MASK;
	}
	if (pUserInputBasic->NumActiveDbyteDfi1 != 0) {
		DfiMode |= csr_Dfi1Enable_MASK;
	}

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] Programming DfiMode to 0x%x\n", DfiMode);
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_DfiMode_ADDR), DfiMode);


	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfig] End of %s()\n", __func__);
}
// End of dwc_ddrphy_phyinit_C_initPhyConfig()

/** \brief implements Step C in Pstate Loop of initialization sequence
 *
 * This function programs majority of PHY Pstate configuration registers based
 * on data input into PhyInit data structures.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 *
 * List of registers programmed by this function:
 */
void dwc_ddrphy_phyinit_C_initPhyConfigPsLoop(phyinit_config_t *phyctx)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	SliceName_t SliceName = DQ;

	PMU_SMB_LPDDR5_1D_t *mb1D = phyctx->mb_LPDDR5_1D;

	uint8_t pstate = pRuntimeConfig->curPState;
	uint32_t p_addr = pUserInputBasic->NumPStates < 3 ? pstate << 20 : p0;
	uint16_t freq = pUserInputBasic->Frequency[pstate];
	uint16_t ratio = 1 << pUserInputBasic->DfiFreqRatio[pstate];
	uint8_t NumDbyte = pUserInputBasic->NumCh * pUserInputBasic->NumDbytesPerCh;
	uint8_t NumAchn = pUserInputBasic->NumCh;

	uint8_t lane;
	uint8_t byte;
	uint8_t achn;
	uint32_t r_addr;
	uint32_t c_addr;
	uint16_t regData;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Start of %s()\n", __func__);

	/**
	 * ### Following registers are saved as Group 1 ###
	 */
	dwc_ddrphy_phyinit_regInterface(setGroup, 0, 1);

	/**
	 *  - program csrPstate GPR in 2 PState case
	 */
	regData = (pstate == 0 && pUserInputBasic->NumPStates < 3) ? 0x1 : 0x0;
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BGPR2_ADDR), regData);

	// Program PLL (PllCtrl5 and PllCtrl6)
	dwc_ddrphy_phyinit_programPLL(phyctx, 0, "[phyinit_C_initPhyConfigPsLoop]");

	/**
	 * - Registers: Seq0BDLY0, Seq0BDLY1, Seq0BDLY2, Seq0BDLY3, Seq0BDLY4, Seq0BDLY5, Seq0BDLY6, Seq0BDLY7
	 *   - Program PIE instruction delays
	 *   - Dependencies:
	 *     - user_input_basic.Frequency
	 */
	// Need delays for 0.5us, 1us, 10us, DLL Lock and more.
	uint16_t psCount[8];

	// Calculate the counts to obtain the correct delay for each frequency
	// Need to divide by 4 since the delay value are specified in units of
	// 4 clocks.
	uint32_t DfiFrq, dllLock;

	_IF_LPDDR4(
		DfiFrq = freq >> pUserInputBasic->DfiFreqRatio[pstate];
	)
	_IF_LPDDR5(
		DfiFrq = freq;
	)
	psCount[0] = (int)((0.5 * 0.25 * DfiFrq));

	uint16_t tZQCal;
	_IF_LPDDR4(
		tZQCal = (int)((1.0 * 0.25 * DfiFrq));
	)

#ifdef _BUILD_LPDDR5
	uint16_t nZQ;
#endif
	_IF_LPDDR5(
		nZQ = pUserInputBasic->MaxNumZQ;
		tZQCal = 0;
		if (nZQ > 0 && nZQ <= 4) {
			tZQCal = (int)((1.5 * 0.25 * DfiFrq));
		} else if (nZQ <= 8) {
			tZQCal = (int)((3.0 * 0.25 * DfiFrq));
		} else if (nZQ <= 16) {
			tZQCal = (int)((6.0 * 0.25 * DfiFrq));
		} else {
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid user input MaxNumZQ: %d\n", nZQ);
		}

	)
	psCount[1] = tZQCal; // tZQCAL or tZQCAL4/8/16

	psCount[2] = (int)((1.0 * 0.25 * DfiFrq));

	if (DfiFrq > 266) {
		dllLock = 176;
	} else if (DfiFrq <= 266 && DfiFrq > 200) {
		dllLock = 132;
	} else {
		dllLock = 128;
	}

	if (pUserInputBasic->DfiFreqRatio[pstate] == 0x2) {
		dllLock *= 2;
	}

	psCount[3] = (int)(0.25 * dllLock);
	psCount[4] = (int)((0.1 * 0.25 * DfiFrq));

	uint8_t RxReplicaShortRangeA = 16;
	uint8_t RxReplicaShortRangeB = 16;
	int16_t RxRepCalWait = 8 * RxReplicaShortRangeA + 40;

	_IF_LPDDR4(
		RxRepCalWait -= (pUserInputBasic->NumRank == 1) ? 84 : 147;
		RxRepCalWait -= (pUserInputBasic->DfiFreqRatio[pstate] == 0x1) ? (pUserInputBasic->NumRank == 1) ? 78 : 137 : 0;
	)
	_IF_LPDDR5(
		RxRepCalWait -= (pUserInputBasic->NumRank == 1) ? 161 : 305;
		RxRepCalWait -= (pUserInputBasic->DfiFreqRatio[pstate] == 0x1) ? 14 * pUserInputBasic->NumRank : 0;
	)
	psCount[5] = (RxRepCalWait < 0) ? 0 : RxRepCalWait;

	int16_t OscWait;

	_IF_LPDDR4(
		OscWait = (pUserInputBasic->DfiFreqRatio[pstate] == 0x2) ? 0x2 : 0x3d; // Base Delay
		OscWait += (pUserInputBasic->NumRank == 1) ? ((pUserInputBasic->DfiFreqRatio[pstate] == 0x2) ? 0x46 : 0x4e) : 0x0;
		OscWait = (pUserInputBasic->DfiFreqRatio[pstate] == 0x2) ? OscWait / 2 : OscWait;
	)
	_IF_LPDDR5(
		OscWait = pUserInputBasic->DfiFreqRatio[pstate] == 0x2 ? 180 : 145;
		if (pUserInputBasic->NumRank == 1) {
			OscWait += (pUserInputBasic->DfiFreqRatio[pstate] == 0x2) ? 152 : 168;
		}
	)
	OscWait -= 4; // 16 DFI clocks for RxClk LCDL update delay
	OscWait -= psCount[5]; // Subtrack the RxRepCalWait.
	psCount[6] = (OscWait < 0) ? 0 : OscWait;

	psCount[7] = 0x0;

#ifdef _BUILD_LPDDR5
	uint16_t tXDSM_XP;
#endif

	_IF_LPDDR5(
		tXDSM_XP = (uint16_t)((190.0 * 0.25 * DfiFrq));
		psCount[7] = pUserInputAdvanced->Lp3DramState[pstate] == 1 ? tXDSM_XP : 0;
	)

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY0 to 0x%x\n", pstate, freq, psCount[0]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY0_ADDR), psCount[0]);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY1 to 0x%x\n", pstate, freq, psCount[1]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY1_ADDR), psCount[1]);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY2 to 0x%x\n", pstate, freq, psCount[2]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY2_ADDR), psCount[2]);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY3 to 0x%x\n", pstate, freq, psCount[3]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY3_ADDR), psCount[3]);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY4 to 0x%x\n", pstate, freq, psCount[4]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY4_ADDR), psCount[4]);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY5 to 0x%x\n", pstate, freq, psCount[5]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY5_ADDR), psCount[5]);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY6 to 0x%x\n", pstate, freq, psCount[6]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY6_ADDR), psCount[6]);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d,  Memclk=%dMHz, Programming Seq0BDLY7 to 0x%x\n", pstate, freq, psCount[7]);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BDLY7_ADDR), psCount[7]);

	/**
	 * - Program PclkPtrInitVal:
	 *   - The values programmed here assume ideal properties of DfiClk and Pclk including:
	 *     - DfiClk skew
	 *     - DfiClk jitter
	 *     - DfiClk PVT variations
	 *     - Pclk skew
	 *     - Pclk jitter
	 *
	 * The PclkPtrInitVal register controls the hase offset between read and write pointers of master command FIFO.
	 * A small value my be prone to causing underflow and a large value will increase the PHY latency.
	 * The units of this register are in UI. Please see PUB databook for detailed programming information.
	 *
	 */

	// We update the struct field here as the dwc_ddrphy_phyinit_progCsrSkipTrain() function
	// needs the value and would otherwise require a PHY read register implementation.
	phyctx->PclkPtrInitVal[pstate] = 2;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming PclkPtrInitVal to 0x%x\n", pstate, freq, phyctx->PclkPtrInitVal[pstate]);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_PclkPtrInitVal_ADDR), phyctx->PclkPtrInitVal[pstate]);

#if PUB==1
    uint16_t RxStandbyExtnd;
    RxStandbyExtnd = 0x2;
    dwc_ddrphy_phyinit_cmnt (" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming RxStandbyExtnd to 0x%x\n", pstate, freq, RxStandbyExtnd);
    dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_RxStandbyExtnd_ADDR), RxStandbyExtnd);
#endif

	/**
	 * - Program DfiFreqRatio,
	 *   - Dependencies:
	 *     - user_input_basic.DfiFreqRatio
	 */
	int DfiFreqRatio = pUserInputBasic->DfiFreqRatio[pstate];

	_IF_LPDDR5(
		uint16_t CKR = (mb1D[pstate].MR18_A0 & 0x80) >> 7;

		if ((CKR == 1 && DfiFreqRatio != 1) || (CKR == 0 && DfiFreqRatio != 2)) {
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Inconsistent clock ratio set with MR18 CKR (%d) and pUserInputBasic->DfiFreqRatio (0x%x) for pstate %d\n", CKR, DfiFreqRatio, pstate);
		}
	)

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DfiFreqRatio to 0x%x\n", pstate, freq, DfiFreqRatio);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_DfiFreqRatio_ADDR), DfiFreqRatio);

	_IF_LPDDR4(
		/// - ACSMStaticCtrl
		regData = (DfiFreqRatio == 1) ? csr_ACSMPhaseControl_MASK : 0x0;
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AcsmStaticCtrl to 0x%x\n", pstate, freq, regData);
		dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BGPR1_ADDR), regData);
	)
	/**
	 * ### Following registers are saved as Group 2 ###
	 */
	dwc_ddrphy_phyinit_regInterface(setGroup, 0, 2);

	/**
	 * - Program DbyteRxDqsModeCntrl:
	 *   - RxPostambleMode
	 *   - RxPreambleMode
	 * - Program DqsPreambleControl:
	 *   - Fields:
	 *     - LP4PostambleExt  (Tx)
	 *   - Dependencies:
	 *      - user_input_basic.DramType
	 *      - user_input_advanced.WDQSExt (only applies to LPDDR4 protocol)
	 * - Program RxDigStrbEn and DxDigStrobeMode for RDQS disabled mode (strobe-less read mode) (only applies to LPDDR5 protocol)
	 */
	int DqsPreambleControl;
	int LP4PostambleExt = 0;
	int WDQSEXTENSION = 0;
	int RxPostambleMode = 0;
	int RxPreambleMode = 0;
	int LPDDR5RdqsEn = 0;
	int LPDDR5RdqsPre = 0;
	int LPDDR5RdqsPst = 0;
	int DqPreOeExt = 0;
	int DqPstOeExt = 0;
	int DbyteRxDqsModeCntrl;

#ifdef _BUILD_LPDDR5
	uint16_t pst;
	uint16_t RxDigStrbEn;
	uint16_t DxDigStrobeMode;
#endif

	_IF_LPDDR5(
		pst = (mb1D[pstate].MR10_A0 & 0xC0) >> 6;
		WDQSEXTENSION = pUserInputAdvanced->WDQSExt;
		LPDDR5RdqsEn = 0x1;
		LPDDR5RdqsPre = 0x1; // JEDEC MR10.OP[5:4]=1 Static 2*tWCK, Toggle 2*tWCK
		LPDDR5RdqsPst = pst; // JEDEC MR10.OP[7:6]=1 2.5*tWCK or =2 4.5*tWCK
		RxDigStrbEn = 0;
		DxDigStrobeMode = 0;
		// Case where RDQS is disabled and data rate is equal or less than 1600 Mbps;
		if (((mb1D[pstate].MR20_A0 & 0x3) == 0x0) && (freq * ratio * 2 <= 1600)) {
			LPDDR5RdqsEn = 0x0;
			RxPreambleMode = 0x1;
			RxPostambleMode = 0x1;
			RxDigStrbEn = 0xF;
			DxDigStrobeMode = 0x2;
		}

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming RxDigStrbEn to 0x%x\n", pstate, freq, RxDigStrbEn);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DxDigStrobeMode to 0x%x\n", pstate, freq, DxDigStrobeMode);
		for (byte = 0; byte < NumDbyte; byte++) {
			c_addr = byte << 12;
			dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxDigStrbEn_ADDR), RxDigStrbEn);
			dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_DxDigStrobeMode_ADDR), DxDigStrobeMode);
		}

	  // Enable PHY DFE mode  if DFE training step is enabled or MR24 is set
    if (((mb1D[pstate].MR24_A0) != 0) || ((mb1D[pstate].SequenceCtrl & 0x400) != 0)) {
			DqPreOeExt = 1;
    }
	)

	_IF_LPDDR4(
		RxPostambleMode = 0x1; // JEDEC MR1.OP[7]=1 1.5tCK
		RxPreambleMode = 0x1; // JEDEC MR1.OP[3]=1 toggle
		LP4PostambleExt = (mb1D[pstate].MR3_A0 & 0x2) >> 1; // WrPst
		WDQSEXTENSION = pUserInputAdvanced->WDQSExt;
	)
	DqsPreambleControl = (WDQSEXTENSION << csr_WDQSEXTENSION_LSB)
						| (LP4PostambleExt << csr_LP4PostambleExt_LSB)
						| (DqPreOeExt << csr_DqPreOeExt_LSB)
						| (DqPstOeExt << csr_DqPstOeExt_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DqsPreambleControl::LP4PostambleExt to 0x%x\n", pstate, freq, LP4PostambleExt);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DqsPreambleControl::DqPreOeExt to 0x%x\n", pstate, freq, DqPreOeExt);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DqsPreambleControl to 0x%x\n", pstate, freq, DqsPreambleControl);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_DqsPreambleControl_ADDR), DqsPreambleControl);

	DbyteRxDqsModeCntrl = (RxPreambleMode << csr_RxPreambleMode_LSB) | (RxPostambleMode << csr_RxPostambleMode_LSB)
							| (LPDDR5RdqsEn << csr_LPDDR5RdqsEn_LSB) | (LPDDR5RdqsPre << csr_LPDDR5RdqsPre_LSB) | (LPDDR5RdqsPst << csr_LPDDR5RdqsPst_LSB);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DbyteRxDqsModeCntrl::RxPreambleMode to 0x%x\n", pstate, freq, RxPreambleMode);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DbyteRxDqsModeCntrl::RxPostambleMode to 0x%x\n", pstate, freq, RxPostambleMode);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DbyteRxDqsModeCntrl::LPDDR5RdqsEn to 0x%x\n", pstate, freq, LPDDR5RdqsEn);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DbyteRxDqsModeCntrl::LPDDR5RdqsPre to 0x%x\n", pstate, freq, LPDDR5RdqsPre);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DbyteRxDqsModeCntrl::LPDDR5RdqsPst to 0x%x\n", pstate, freq, LPDDR5RdqsPst);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DbyteRxDqsModeCntrl to 0x%x\n", pstate, freq, DbyteRxDqsModeCntrl);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_DbyteRxDqsModeCntrl_ADDR), DbyteRxDqsModeCntrl);

	/**
	 * - Program RxModeCtlDIFF0, RxModeCtlDIFF1, RxModeCtlSE0 and RxModeCtlSE1
	 */
	uint16_t csrRxModeCtlSE = ((pUserInputAdvanced->RxVrefDACEnable[pstate]) << 1) | ((pUserInputAdvanced->RxVrefKickbackNoiseCancellation[pstate]) << 0);
	uint16_t csrRxModeCtlDIFF = (pUserInputAdvanced->RxModeBoostVDD[pstate] == 1) ? 0x0 : 0x3;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming csrRxModeCtlSE0 to 0x%x\n", pstate, freq, csrRxModeCtlSE);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming csrRxModeCtlSE1 to 0x%x\n", pstate, freq, csrRxModeCtlSE);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming csrRxModeCtlDIFF0 to 0x%x\n", pstate, freq, csrRxModeCtlDIFF);

	for (achn = 0; achn < NumAchn; achn++) {
		c_addr = achn << 12;
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_RxModeCtlSE0_ADDR), csrRxModeCtlSE);
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_RxModeCtlSE1_ADDR), csrRxModeCtlSE);
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_RxModeCtlDIFF0_ADDR), csrRxModeCtlDIFF);
	}

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxModeCtlSE0_ADDR), csrRxModeCtlSE);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxModeCtlDIFF0_ADDR), csrRxModeCtlDIFF);
	}

	_IF_LPDDR5(
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming csrRxModeCtlDIFF1 to 0x%x\n", pstate, freq, csrRxModeCtlDIFF);
		for (byte = 0; byte < NumDbyte; byte++) {
			c_addr = byte << 12;
			dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxModeCtlDIFF1_ADDR), csrRxModeCtlDIFF);
		}
	)

	/**
	 * - Program RxDfeModeCfg and RxVrefCtl in the DBYTE
	 *   - Dependencies:
	 *     - user_input_advanced.RxDfeMode
	 */
	uint16_t RxDfeMode = pUserInputAdvanced->RxDfeMode[pstate];
	uint16_t RxDfeGap = 0;
	uint16_t RxDfeModeCfg = RxDfeGap << csr_RxDfeGap_LSB | (RxDfeMode & csr_RxDfeMode_MASK);
	uint16_t RxVrefCtl = RxDfeMode == 0 ? 0 : 1;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE RxDfeModeCfg to 0x%x\n", pstate, freq, RxDfeModeCfg);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE RxVrefCtl to 0x%x\n", pstate, freq, RxVrefCtl);

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxDfeModeCfg_ADDR), RxDfeModeCfg);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxVrefCtl_ADDR), RxVrefCtl);
	}

	/**
	 * - Program DxDfiClkDis and DxPClkDis
	 *   - Dependencies:
	 *     - user_input_basic.DramType
	 */
	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;

		uint16_t DxDfiClkDis = 0x0;
		uint16_t DxPClkDis = 0x0;

		_IF_LPDDR4(
			// Disable input clocks to WCK DIFF slice
			DxDfiClkDis |= csr_DfiClkWckDis_MASK;
			DxPClkDis |= csr_PClkWckDis_MASK;
		)

	  _IF_LPDDR5(
			if (((mb1D[pstate].MR20_A0 & 0x3) == 0x0) && (freq * ratio * 2 <= 1600)) {
				DxDfiClkDis = 0x200;
				DxPClkDis = 0x200;
			}
		)

		if (dwc_ddrphy_phyinit_IsDbyteDisabled(phyctx, byte)) {
				DxDfiClkDis = 0x7ff;
				DxPClkDis = 0x7ff;
		}

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE%d.DxPClkDis to 0x%x\n", pstate, freq, byte, DxPClkDis);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE%d.DxDfiClkDis to 0x%x\n", pstate, freq, byte, DxDfiClkDis);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_DxPClkDis_ADDR), DxPClkDis);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_DxDfiClkDis_ADDR), DxDfiClkDis);
	}

	/**
	 * - Program ZCalClkInfo:
	 *   - Fields:
	 *     - ZCalDfiClkTicksPer1uS
	 *   - Dependencies:
	 *     - user_input_basic.NumPStates
	 *     - user_input_basic.DfiFreqRatio (only applies for LPDDR4 protocol)
	 */

	int ZCalDfiClkTicksPer1uS[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	// Number of DfiClk cycles per 1usi
	_IF_LPDDR4(
		ZCalDfiClkTicksPer1uS[pstate] = (freq + ratio - 1) / ratio;	// divide and round up
	)
	_IF_LPDDR5(
		ZCalDfiClkTicksPer1uS[pstate] = freq;
	)
	if (ZCalDfiClkTicksPer1uS[pstate] < 24) {
		ZCalDfiClkTicksPer1uS[pstate] = 24;	// Minimum value of ZCalDfiClkTicksPer1uS = 24
	}

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ZCalClkInfo::ZCalDfiClkTicksPer1uS to 0x%x\n", pstate, freq, ZCalDfiClkTicksPer1uS[pstate]);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ZCalClkInfo_ADDR), ZCalDfiClkTicksPer1uS[pstate]);

	/**
	 * - Program VrefDAC series of registers
	 */
	uint16_t valVrefDAC = pUserInputAdvanced->PhyVrefCode & 0x7f;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC VrefDAC[0-3] to 0x%x\n", pstate, freq, valVrefDAC);

	for (achn = 0; achn < NumAchn; achn++) {
		c_addr = achn << 12;
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_AcVrefDAC0_ADDR), valVrefDAC);
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_AcVrefDAC1_ADDR), valVrefDAC);
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_AcVrefDAC2_ADDR), valVrefDAC);
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_AcVrefDAC3_ADDR), valVrefDAC);
	}

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE VrefDAC[0-3] to 0x%x\n", pstate, freq, valVrefDAC);

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;
		for (lane = 0; lane < 9; lane++) {
			r_addr = lane << 8;
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | r_addr | csr_VrefDAC0_ADDR), valVrefDAC);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | r_addr | csr_VrefDAC1_ADDR), valVrefDAC);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | r_addr | csr_VrefDAC2_ADDR), valVrefDAC);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | r_addr | csr_VrefDAC3_ADDR), valVrefDAC);
		}
	}

	/**
	 * - Program TxModeCtlSE0, TxModeCtlSE1, TxModeCtlDIFF0, TxModeCtlDIFF1
	 *   - Dependencies of LPDDR4:
	 *     - user_input_basic.Lp4xMode
	 */
	uint16_t valTxModeCtl;
	uint16_t valWeakPullDown = 0x0;

	_IF_LPDDR4(
		if ((pUserInputBasic->Lp4xMode == 0) && ((mb1D[pstate].MR3_A0 & 0x1) == 0)) {
			valTxModeCtl = (0x1 << 1);
		} else {
			valTxModeCtl = (0x0 << 1);
		}
	)
	_IF_LPDDR5(
		valTxModeCtl = (0x0 << 1);
	)
	valTxModeCtl |= valWeakPullDown;

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TxModeCtlSE0 to 0x%x\n", pstate, freq, valTxModeCtl);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TxModeCtlSE1 to 0x%x\n", pstate, freq, valTxModeCtl);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TxModeCtlDIFF0 to 0x%x\n", pstate, freq, valTxModeCtl);

	_IF_LPDDR5(
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TxModeCtlDIFF1 to 0x%x\n", pstate, freq, valTxModeCtl);
	)

	for (achn = 0; achn < NumAchn; achn++) {
		c_addr = achn << 12;

		// *** AC SE CA0-CA5 *** //
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxModeCtlSE0_ADDR), valTxModeCtl);

		// *** AC SE CA6 and CA7 *** //
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxModeCtlSE1_ADDR), valTxModeCtl);

		// *** AC DIFF CK *** //
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxModeCtlDIFF0_ADDR), valTxModeCtl);
	}

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;

		// *** DBYTE SE DQ and DMI *** //
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_TxModeCtlSE0_ADDR), valTxModeCtl);

		// *** DBYTE DIFF DQS *** //
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_TxModeCtlDIFF0_ADDR), valTxModeCtl);

		_IF_LPDDR5(
			// *** DBYTE DIFF WCK *** //
			dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_TxModeCtlDIFF1_ADDR), valTxModeCtl);
		)
	}

	/**
	 * - Program RxGainCurrAdjDIFF0
	 *           and RxGainCurrAdjDIFF1 (only applies for LPDDR5 protocol)
	 *           and RxGainCurrAdjRxReplica
	 *
	 */
	uint16_t valRxGainCurrAdjCk = pUserInputAdvanced->RxBiasCurrentControlCk[pstate];
	uint16_t valRxGainCurrAdjDqs = pUserInputAdvanced->RxBiasCurrentControlDqs[pstate];

#ifdef _BUILD_LPDDR5
	uint16_t valRxGainCurrAdjWck;
#endif

	_IF_LPDDR5(
		valRxGainCurrAdjWck = pUserInputAdvanced->RxBiasCurrentControlWck[pstate];
	)
	uint16_t valRxGainCurrAdjR = pUserInputAdvanced->RxBiasCurrentControlRxReplica[pstate];

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC RxGainCurrAdjDIFF0 to 0x%x\n", pstate, freq, valRxGainCurrAdjCk);

	for (achn = 0; achn < NumAchn; achn++) {
		c_addr = achn << 12;

		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_RxGainCurrAdjDIFF0_ADDR), valRxGainCurrAdjCk);
	}

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE RxGainCurrAdjRxReplica to 0x%x\n", pstate, freq, valRxGainCurrAdjR);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE RxGainCurrAdjDIFF0 to 0x%x\n", pstate, freq, valRxGainCurrAdjDqs);

	_IF_LPDDR5(
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE RxGainCurrAdjDIFF1 to 0x%x\n", pstate, freq, valRxGainCurrAdjWck);
	)

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;

		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxGainCurrAdjDIFF0_ADDR), valRxGainCurrAdjDqs);
		_IF_LPDDR5(
			dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxGainCurrAdjDIFF1_ADDR), valRxGainCurrAdjWck);
		)
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_RxGainCurrAdjRxReplica_ADDR), valRxGainCurrAdjR);
	}

	/**
	 * - Program CmdFifoWrModeMaster:
	 *   - Dependencies:
	 *     - user_input_basic.DfiFreqRatio
	 *     - user_input_basic.PllBypass
	 */
	uint16_t CmdFifoWrModeMaster;
	uint16_t bypass = pUserInputBasic->PllBypass[pstate] != 0 ? 1 : 0;

	if (bypass) {
		CmdFifoWrModeMaster = (DfiFreqRatio == 1) ? 0x0 : 0x1;
	} else {
		_IF_LPDDR4(
			CmdFifoWrModeMaster = (DfiFreqRatio == 1 && freq >= 1600) ? 0x0 : 0x1;
		)
		_IF_LPDDR5(
			CmdFifoWrModeMaster = 0x1;
		)
	}
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_CmdFifoWrModeMaster_ADDR), CmdFifoWrModeMaster);

	_IF_LPDDR4(
		/**
		 * - Program DxPipeEn[1:0] to 1 if in LPDDR4 Mode, DfiFreqRatio = 1 and DataRate > 3200Mbps i.e tck > 1600MHz i.e DfiClk > 800MHz
		 *   - Dependencies:
		 *     - user_input_basic.DfiFreqRatio
		 *     - Frequency
		 *     - DRAM Typte
		 */
		uint16_t DxPipeEn = (DfiFreqRatio == 1 && freq > 1600) ? 0x3 /* 1:2 Mode */ : 0x0;

		for (byte = 0; byte < NumDbyte; byte++)	{// for each dbyte
			c_addr = byte * c1;
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_DxPipeEn_ADDR), DxPipeEn);
		}
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DxPipeEn to 0x%x\n", pstate, freq, DxPipeEn);
	)

	/**
	 * - Program PclkDivCa0, PclkDivCa1, PclkDivDq0, PclkDivDq1
	 *   - Dependencies:
	 *     - user_input_basic.DfiFreqRatio
	 *     - user_input_basic.PllBypass
	 *     - user_input_basic.DramType
	 */

	uint16_t PclkDivCa0 = 0, PclkDivCa1 = 0;
	uint16_t PclkDivDq0 = 0, PclkDivDq1 = 0;

	_IF_LPDDR5(
		if (DfiFreqRatio == 2) { // 1:4 Mode
			PclkDivCa0 = 2;
			PclkDivCa1 = 2;
			PclkDivDq0 = 1;
			PclkDivDq1 = 1;
		} else if (bypass) { // 1:2 Mode with bypass
			PclkDivCa0 = 1;
			PclkDivCa1 = 1;
			PclkDivDq0 = 1;
			PclkDivDq1 = 1;
		} else { // 1:2 Mode with PLL
			PclkDivCa0 = 2;
			PclkDivCa1 = 2;
			PclkDivDq0 = 2;
			PclkDivDq1 = 2;
		}
	)

	_IF_LPDDR4(
		if (DfiFreqRatio == 1) { // 1:2 Mode
			if (freq >= 1600 || bypass) { // PLL x4 or bypass mode
				PclkDivCa0 = 1;
				PclkDivCa1 = 1;
				PclkDivDq0 = 1;
				PclkDivDq1 = 1;
			} else { // PLL x8
				PclkDivCa0 = 2;
				PclkDivCa1 = 2;
				PclkDivDq0 = 2;
				PclkDivDq1 = 2;
			}
		} else { // 1:4 Mode
			PclkDivCa0 = 1;
			PclkDivCa1 = 1;
			PclkDivDq0 = 1;
			PclkDivDq1 = 1;
		}
	)
	uint16_t PclkDivRatio = ((PclkDivCa0 << csr_PclkDivCa0_LSB) & csr_PclkDivCa0_MASK)
							| ((PclkDivCa1 << csr_PclkDivCa1_LSB) & csr_PclkDivCa1_MASK)
							| ((PclkDivDq0 << csr_PclkDivDq0_LSB) & csr_PclkDivDq0_MASK)
							| ((PclkDivDq1 << csr_PclkDivDq1_LSB) & csr_PclkDivDq1_MASK);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, PLL bypass = %d, Programming PclkDivRatio to 0x%x\n", pstate, freq, bypass, PclkDivRatio);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_PclkDivRatio_ADDR), PclkDivRatio);

	/**
	 * - Program CkDisVal
	 *   - Fields:
	 *     - CkDisVal
	 *   - Dependencies:
	 *     - user_input_advanced.CkDisVal
	 */
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming CkDisVal:: to 0x%x\n", pstate, freq, pUserInputAdvanced->CkDisVal[pstate]);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_CkDisVal_ADDR), (pUserInputAdvanced->CkDisVal[pstate]) << csr_CkDisVal_LSB);

	/**
	 * - Program DMIPinPresent based on DramType and Read-DBI enable
	 *   - Fields:
	 *     - RdDbiEnabled
	 *   - Dependencies:
	 *     - user_input_basic.DramDataWidth
	 *     - MR3_A0
	 */
	uint16_t DMIPinPresent;

	_IF_LPDDR4(
		DMIPinPresent = (mb1D[pstate].MR3_A0 & 0x40) >> 6;	// DBI-RD
	)
	_IF_LPDDR5(
		DMIPinPresent = ((mb1D[pstate].MR3_A0 & 0x40) >> 6 & 1)	// DBI-RD
						| ((mb1D[pstate].MR22_A0 & 0xC0) >> 6 & 1);	// RECC
	)
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DMIPinPresent::RdDbiEnabled to 0x%x\n", pstate, freq, DMIPinPresent);

	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_DMIPinPresent_ADDR), DMIPinPresent);

	/**
	 * - Program the TrackingModeCntrl CSR for Read DQS Tracking
	 *   - Dependencies:
	 *     - user_input_advanced.EnRxDqsTracking
	 */

	uint16_t EnWck2DqoSnoopTracking;
	uint16_t Twck2dqoTrackingLimit;

	_IF_LPDDR4(
		EnWck2DqoSnoopTracking = 0;
		Twck2dqoTrackingLimit = 0;
	)
	_IF_LPDDR5(
		EnWck2DqoSnoopTracking = pUserInputAdvanced->EnWck2DqoTracking[pstate] == 1 ? 1 : 0;
		Twck2dqoTrackingLimit = 0;	// no limit (default)
	)
#if PUB==1
	uint16_t EnRxDqsTracking = pUserInputAdvanced->EnRxDqsTracking[pstate];
	uint16_t EnDqsSampNegRxEn = EnRxDqsTracking ? 1 : 0;
#else
	// Only enable the tracking during PPT2 training
	uint16_t EnRxDqsTracking = 0;
	uint16_t EnDqsSampNegRxEn = 0;
#endif
	uint16_t RxDqsTrackingThreshold = pUserInputAdvanced->RxDqsTrackingThreshold[pstate];
	uint16_t DqsOscRunTimeSel = pUserInputAdvanced->DqsOscRunTimeSel[pstate];
	uint16_t Tdqs2dqTrackingLimit = 0; // no limit (default)

	uint16_t TrackingModeCntrl = (EnWck2DqoSnoopTracking << csr_EnWck2DqoSnoopTracking_LSB)
								| (Twck2dqoTrackingLimit << csr_Twck2dqoTrackingLimit_LSB)
#if PUB==1
								| (EnRxDqsTracking << csr_EnRxDqsTracking_LSB)
#endif
								| (Tdqs2dqTrackingLimit << csr_Tdqs2dqTrackingLimit_LSB)
								| (DqsOscRunTimeSel << csr_DqsOscRunTimeSel_LSB)
								| (RxDqsTrackingThreshold << csr_RxDqsTrackingThreshold_LSB)
								| (EnDqsSampNegRxEn << csr_EnDqsSampNegRxEn_LSB);

#if PUB!=1
	uint16_t gpr10 = (0x0 << csr_EnWck2DqoSnoopTracking_LSB)
								| (Twck2dqoTrackingLimit << csr_Twck2dqoTrackingLimit_LSB)
								| (Tdqs2dqTrackingLimit << csr_Tdqs2dqTrackingLimit_LSB)
								| (DqsOscRunTimeSel << csr_DqsOscRunTimeSel_LSB)
								| (RxDqsTrackingThreshold << csr_RxDqsTrackingThreshold_LSB)
								| (0x0 << csr_EnDqsSampNegRxEn_LSB);
#endif

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TrackingModeCntrl::EnRxDqsTracking to 0x%x\n", pstate, freq, EnRxDqsTracking);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TrackingModeCntrl::EnDqsSampNegRxEn to 0x%x\n", pstate, freq, EnDqsSampNegRxEn);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TrackingModeCntrl::RxDqsTrackingThreshold to 0x%x\n", pstate, freq, RxDqsTrackingThreshold);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TrackingModeCntrl::DqsOscRunTimeSel to 0x%x\n", pstate, freq, DqsOscRunTimeSel);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming TrackingModeCntrl to 0x%x\n", pstate, freq, TrackingModeCntrl);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_TrackingModeCntrl_ADDR), TrackingModeCntrl);
#if PUB!=1
	dwc_ddrphy_phyinit_io_write16((tMASTER | csr_EnRxDqsTracking_ADDR), EnRxDqsTracking << csr_EnRxDqsTracking_LSB);
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BGPR10_ADDR), gpr10);
#endif
	/**
	 * - Program  TxImpedanceSE0, TxImpedanceSE1
	 *            TxImpedanceDIFF0T, TxImpedanceDIFF0C
	 *            TxImpedanceDIFF1T, TxImpedanceDIFF1C
	 *            TxImpedanceCMOS0,  TxImpedanceCMOS1
	 *   - Dependencies: pUserInputAdvanced->TxImpedanceDq,
	 *                                       TxImpedanceAc,
	 *                                       TxImpedanceCs,
	 *                                       TxImpedanceCk,
	 *                                       TxImpedanceDqs,
	 *                                       TxImpedanceWCK,
	 *                                       TxImpedanceCKE,
	 *                                       TxImpedanceDTO
	 */
	int TxImpedanceSE0;
	int TxStrenCodePUSE0;
	int TxStrenCodePDSE0;

	int TxImpedanceSE1;
	int TxStrenCodePUSE1;
	int TxStrenCodePDSE1;

	int TxImpedanceDIFF0;
	int TxStrenCodePUDIFF0;
	int TxStrenCodePDDIFF0;

	int TxImpedanceCMOS0;
	int TxStrenCodePUCMOS0;
	int TxStrenCodePDCMOS0;

	int TxImpedanceCMOS1;
	int TxStrenCodePUCMOS1;
	int TxStrenCodePDCMOS1;

#ifdef _BUILD_LPDDR4
	int mr3_op0;
	int higherVOHLp4;
#endif
	int calPD240 = 0;

	_IF_LPDDR4(
		// Look at DRAM MR3-OP[0] from channel A and rank 0
		mr3_op0 = mb1D[pstate].MR3_A0 & 0x1;
		higherVOHLp4 = (mr3_op0 == 0) ? 1 : 0;

		if (higherVOHLp4 == 1 && pUserInputBasic->Lp4xMode == 0) {
			calPD240 = 1;
		}
	)
	// ********* Start TX Impedance for DBYTE ********* //
	for (byte = 0; byte < NumDbyte; byte++) { // for each dbyte
		c_addr = byte * c1;
		// *** DBYTE SE *** //
		SliceName = DQ;
		_IF_LPDDR5(
			TxStrenCodePUSE0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, 0, "[phyinit_C_initPhyConfigPsLoop]");
		)
		_IF_LPDDR4(
			TxStrenCodePUSE0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, higherVOHLp4, "[phyinit_C_initPhyConfigPsLoop]");
		)

		TxStrenCodePDSE0 = TxStrenCodePUSE0;
		TxImpedanceSE0 = (TxStrenCodePUSE0 << csr_TxStrenCodePUSE0_LSB) | (TxStrenCodePDSE0 << csr_TxStrenCodePDSE0_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceSE0::TxStrenCodePUSE0 to 0x%x\n", pstate, freq, TxStrenCodePUSE0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceSE0::TxStrenCodePDSE0 to 0x%x\n", pstate, freq, TxStrenCodePDSE0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceSE0_ADDR), TxImpedanceSE0);

		// *** DBYTE DQS *** //
		SliceName = DQS;
		_IF_LPDDR5(
			TxStrenCodePUDIFF0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, 0, "[phyinit_C_initPhyConfigPsLoop]");
		)
		_IF_LPDDR4(
			TxStrenCodePUDIFF0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, higherVOHLp4, "[phyinit_C_initPhyConfigPsLoop]");
		)

		TxStrenCodePDDIFF0 = TxStrenCodePUDIFF0;
		TxImpedanceDIFF0 = (TxStrenCodePUDIFF0 << csr_TxStrenCodePUDIFF0T_LSB) | (TxStrenCodePDDIFF0 << csr_TxStrenCodePDDIFF0T_LSB);
		_IF_LPDDR5(
			if (((mb1D[pstate].MR20_A0 & 0x3) == 0x0) && (freq * ratio * 2 <= 1600)) {
				dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF0T_ADDR), 0);
				dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF0C_ADDR), 0);
				dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BGPR13_ADDR), 0x200);
			} else {
				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0T::TxStrenCodePUDIFF0T to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0T::TxStrenCodePDDIFF0T to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
				dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF0T_ADDR), TxImpedanceDIFF0);
		
				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0C::TxStrenCodePUDIFF0C to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0C::TxStrenCodePDDIFF0C to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
				dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF0C_ADDR), TxImpedanceDIFF0);
				dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BGPR13_ADDR), 0);
			}
		)
		_IF_LPDDR4(
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0T::TxStrenCodePUDIFF0T to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0T::TxStrenCodePDDIFF0T to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF0T_ADDR), TxImpedanceDIFF0);
		
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0C::TxStrenCodePUDIFF0C to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF0C::TxStrenCodePDDIFF0C to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF0C_ADDR), TxImpedanceDIFF0);
		)
		_IF_LPDDR5(
			// *** DBYTE WCK *** //
			SliceName = WCK;
			TxStrenCodePUDIFF0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, 0, "[phyinit_C_initPhyConfigPsLoop]");

			TxStrenCodePDDIFF0 = TxStrenCodePUDIFF0;
			TxImpedanceDIFF0 = (TxStrenCodePUDIFF0 << csr_TxStrenCodePUDIFF0T_LSB) | (TxStrenCodePDDIFF0 << csr_TxStrenCodePDDIFF0T_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF1T::TxStrenCodePUDIFF1T to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF1T::TxStrenCodePDDIFF1T to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF1T_ADDR), TxImpedanceDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF1C::TxStrenCodePUDIFF1C to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxImpedanceDIFF1C::TxStrenCodePDDIFF1C to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxImpedanceDIFF1C_ADDR), TxImpedanceDIFF0);
		)
	} // foreach dbyte
	// ********* End TX Impedance for DBYTE ********* //

	// ********* Start TX Impedance for AC ********* //
	for (achn = 0; achn < NumAchn; achn++) { // for each AC Channel
		c_addr = achn << 12;

		// *** AC SE0 *** //
		SliceName = AC;
		_IF_LPDDR5(
			TxStrenCodePUSE0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, 0, "[phyinit_C_initPhyConfigPsLoop]");
		)
		_IF_LPDDR4(
			TxStrenCodePUSE0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, higherVOHLp4, "[phyinit_C_initPhyConfigPsLoop]");
		)

		TxStrenCodePDSE0 = TxStrenCodePUSE0;
		TxImpedanceSE0 = (TxStrenCodePUSE0 << csr_TxStrenCodePUSE0_LSB) | (TxStrenCodePDSE0 << csr_TxStrenCodePDSE0_LSB);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceSE0::TxStrenCodePUSE0 to 0x%x\n", pstate, freq, TxStrenCodePUSE0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceSE0::TxStrenCodePDSE0 to 0x%x\n", pstate, freq, TxStrenCodePDSE0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_TxImpedanceSE0_ADDR), TxImpedanceSE0);

		// *** AC SE1 *** //
		_IF_LPDDR4(
			SliceName = CS;
			TxStrenCodePUSE1 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, higherVOHLp4, "[phyinit_C_initPhyConfigPsLoop]");
			TxStrenCodePDSE1 = TxStrenCodePUSE1;
		)

		_IF_LPDDR5(
			TxStrenCodePDSE1 = TxStrenCodePDSE0;
			TxStrenCodePUSE1 = TxStrenCodePUSE0;
		)
		TxImpedanceSE1 = (TxStrenCodePUSE1 << csr_TxStrenCodePUSE1_LSB) | (TxStrenCodePDSE1 << csr_TxStrenCodePDSE1_LSB);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceSE1::TxStrenCodePUSE1 to 0x%x\n", pstate, freq, TxStrenCodePUSE1);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceSE1::TxStrenCodePDSE1 to 0x%x\n", pstate, freq, TxStrenCodePDSE1);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_TxImpedanceSE1_ADDR), TxImpedanceSE1);

		// *** AC CK *** //
		SliceName = CK;
		_IF_LPDDR5(
			TxStrenCodePUDIFF0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, 0, "[phyinit_C_initPhyConfigPsLoop]");
		)
		_IF_LPDDR4(
			TxStrenCodePUDIFF0 = dwc_ddrphy_phyinit_programTxStren(phyctx, SliceName, higherVOHLp4, "[phyinit_C_initPhyConfigPsLoop]");
		)
		TxStrenCodePDDIFF0 = TxStrenCodePUDIFF0;

		TxImpedanceDIFF0 = (TxStrenCodePUDIFF0 << csr_TxStrenCodePUDIFF0T_LSB) | (TxStrenCodePDDIFF0 << csr_TxStrenCodePDDIFF0T_LSB);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceDIFF0T::TxStrenCodePUDIFF0T to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceDIFF0T::TxStrenCodePDDIFF0T to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_TxImpedanceDIFF0T_ADDR), TxImpedanceDIFF0);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceDIFF0C::TxStrenCodePUDIFF0C to 0x%x\n", pstate, freq, TxStrenCodePUDIFF0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceDIFF0C::TxStrenCodePDDIFF0C to 0x%x\n", pstate, freq, TxStrenCodePDDIFF0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_TxImpedanceDIFF0C_ADDR), TxImpedanceDIFF0);


		// *** AC CKE *** //
		switch (pUserInputAdvanced->TxImpedanceCKE[pstate]) {
		case 400:
			TxStrenCodePUCMOS0 = 0x0;
			break;
		case 100:
			TxStrenCodePUCMOS0 = 0x1;
			break;
		case 67:
			TxStrenCodePUCMOS0 = 0x2;
			break;
		case 50:
			TxStrenCodePUCMOS0 = 0x3;
			break;
		default:
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->TxImpedanceCKE[%d]=%d\n", pstate, pUserInputAdvanced->TxImpedanceCKE[pstate]);
			break;
		}
		TxStrenCodePDCMOS0 = TxStrenCodePUCMOS0;

		TxImpedanceCMOS0 = (TxStrenCodePUCMOS0 << csr_TxStrenCodePUCMOS0_LSB) | (TxStrenCodePDCMOS0 << csr_TxStrenCodePDCMOS0_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceCMOS0::TxStrenCodePUCMOS0 to 0x%x\n", pstate, freq, TxStrenCodePUCMOS0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceCMOS0::TxStrenCodePDCMOS0 to 0x%x\n", pstate, freq, TxStrenCodePDCMOS0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_TxImpedanceCMOS0_ADDR), TxImpedanceCMOS0);

	} // foreach AC channel
	// ********* End TX Impedance for AC ********* //

	// *** MASTER DTO *** //
	switch (pUserInputAdvanced->TxImpedanceDTO[pstate]) {
	case 400:
		TxStrenCodePUCMOS1 = 0x0;
		break;
	case 100:
		TxStrenCodePUCMOS1 = 0x1;
		break;
	case 67:
		TxStrenCodePUCMOS1 = 0x2;
		break;
	case 50:
		TxStrenCodePUCMOS1 = 0x3;
		break;
	default:
		dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->TxImpedanceDTO[%d]=%d\n", pstate, pUserInputAdvanced->TxImpedanceDTO[pstate]);
		break;
	}
	TxStrenCodePDCMOS1 = TxStrenCodePUCMOS1;

	TxImpedanceCMOS1 = (TxStrenCodePUCMOS1 << csr_TxStrenCodePUCMOS1_LSB) | (TxStrenCodePDCMOS1 << csr_TxStrenCodePDCMOS1_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceCMOS1::TxStrenCodePUCMOS1 to 0x%x\n", pstate, freq, TxStrenCodePUCMOS1);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxImpedanceCMOS1::TxStrenCodePDCMOS1 to 0x%x\n", pstate, freq, TxStrenCodePDCMOS1);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_TxImpedanceCMOS1_ADDR), TxImpedanceCMOS1);

	/**
	 * - Program  OdtImpedanceSE0, OdtImpedanceSE1
	 *            OdtImpedanceDIFF0T, OdtImpedanceDIFF0C
	 *            OdtImpedanceDIFF1T, OdtImpedanceDIFF1C (only applies to LPDDR5 protocol)
	 *
	 *   - Dependencies
	 *     - UserInputAdvanced.OdtImpedanceDq
	 *     - UserInputAdvanced.OdtImpedanceCa
	 *     - UserInputAdvanced.OdtImpedanceCk
	 *     - UserInputAdvanced.OdtImpedanceDqs
	 *     - UserInputAdvanced.OdtImpedanceWCK
	 *     - UserInputAdvanced.OdtImpedanceCs
	 *     - mb1D[pstate].MR51_A0
	 */

	// ********* Start ODT Impedance for DBYTE ********* //
	for (byte = 0; byte < NumDbyte; byte++) { // for each dbyte
		c_addr = byte * c1;

		int OdtImpedanceSE0 = 0;
		int OdtStrenCodePUSE0 = 0;
		int OdtStrenCodePDSE0 = 0;

		int OdtImpedanceDIFF0 = 0;
		int OdtStrenCodePUDIFF0 = 0;
		int OdtStrenCodePDDIFF0 = 0;

		int OdtImpedanceDq = pUserInputAdvanced->OdtImpedanceDq[pstate] >> calPD240;
		int OdtImpedanceDqs = pUserInputAdvanced->OdtImpedanceDqs[pstate] >> calPD240;

#ifdef _BUILD_LPDDR5
		int OdtImpedanceWCK;

		int OdtImpedanceDIFF1;
		int OdtStrenCodePUDIFF1;
		int OdtStrenCodePDDIFF1;
#endif

		_IF_LPDDR5(
			OdtImpedanceWCK = pUserInputAdvanced->OdtImpedanceWCK[pstate];

			OdtImpedanceDIFF1 = 0;
			OdtStrenCodePUDIFF1 = 0;
			OdtStrenCodePDDIFF1 = 0;
		)
		// *** DBYTE SE *** //
		switch (OdtImpedanceDq) {
		case 120:
			OdtStrenCodePDSE0 = 0x8;
			break;
		case 60:
			OdtStrenCodePDSE0 = 0xc;
			break;
		case 40:
			OdtStrenCodePDSE0 = 0xe;
			break;
		case 30:
			OdtStrenCodePDSE0 = 0xf;
			break;
		case 0:
			OdtStrenCodePDSE0 = 0x0;
			break;
		default:
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->OdtImpedanceDq[%d]=%d\n", pstate, pUserInputAdvanced->OdtImpedanceDq[pstate]);
			break;
		}

		OdtImpedanceSE0 = (OdtStrenCodePUSE0 << csr_OdtStrenCodePUSE0_LSB) | (OdtStrenCodePDSE0 << csr_OdtStrenCodePDSE0_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceSE0::OdtStrenCodePUSE0 to 0x%x\n", pstate, freq, OdtStrenCodePUSE0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceSE0::OdtStrenCodePDSE0 to 0x%x\n", pstate, freq, OdtStrenCodePDSE0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_OdtImpedanceSE0_ADDR), OdtImpedanceSE0);

		// *** DBYTE DQS *** //
		switch (OdtImpedanceDqs) {
		case 120:
			OdtStrenCodePDDIFF0 = 0x8;
			break;
		case 60:
			OdtStrenCodePDDIFF0 = 0xc;
			break;
		case 40:
			OdtStrenCodePDDIFF0 = 0xe;
			break;
		case 30:
			OdtStrenCodePDDIFF0 = 0xf;
			break;
		case 0:
			OdtStrenCodePDDIFF0 = 0x0;
			break;
		default:
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->OdtImpedanceDqs[%d]=%d\n", pstate, pUserInputAdvanced->OdtImpedanceDqs[pstate]);
			break;
		}

#if PUB==1
		_IF_LPDDR5(
			if (LPDDR5RdqsEn==0) {
				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, LPDDR5RdqsEn=0, Programming DBYTE OdtStrenCodePDDIFF0=0, OdtStrenCodePUDIFF0=0;\n", pstate, freq );
				OdtStrenCodePDDIFF0=0;
				OdtStrenCodePUDIFF0=0;
			} 
		)
#endif


		OdtImpedanceDIFF0 = (OdtStrenCodePUDIFF0 << csr_OdtStrenCodePUDIFF0T_LSB) | (OdtStrenCodePDDIFF0 << csr_OdtStrenCodePDDIFF0T_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF0T::OdtStrenCodePUDIFF0T to 0x%x\n", pstate, freq, OdtStrenCodePUDIFF0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF0T::OdtStrenCodePDDIFF0T to 0x%x\n", pstate, freq, OdtStrenCodePDDIFF0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_OdtImpedanceDIFF0T_ADDR), OdtImpedanceDIFF0);

		OdtImpedanceDIFF0 = (OdtStrenCodePUDIFF0 << csr_OdtStrenCodePUDIFF0C_LSB) | (OdtStrenCodePDDIFF0 << csr_OdtStrenCodePDDIFF0C_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF0C::OdtStrenCodePUDIFF0C to 0x%x\n", pstate, freq, OdtStrenCodePUDIFF0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF0C::OdtStrenCodePDDIFF0C to 0x%x\n", pstate, freq, OdtStrenCodePDDIFF0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_OdtImpedanceDIFF0C_ADDR), OdtImpedanceDIFF0);

		_IF_LPDDR5(
			// *** DBYTE WCK *** //
			switch (OdtImpedanceWCK) {
			case 120:
				OdtStrenCodePDDIFF1 = 0x8;
				break;
			case 60:
				OdtStrenCodePDDIFF1 = 0xc;
				break;
			case 40:
				OdtStrenCodePDDIFF1 = 0xe;
				break;
			case 30:
				OdtStrenCodePDDIFF1 = 0xf;
				break;
			case 0:
				OdtStrenCodePDDIFF1 = 0x0;
				break;
			default:
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->OdtImpedanceWCK[%d]=%d\n", pstate, pUserInputAdvanced->OdtImpedanceWCK[pstate]);
				break;
			}

			OdtImpedanceDIFF1 = (OdtStrenCodePUDIFF1 << csr_OdtStrenCodePUDIFF1T_LSB) | (OdtStrenCodePDDIFF1 << csr_OdtStrenCodePDDIFF1T_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF1T::OdtStrenCodePUDIFF1T to 0x%x\n", pstate, freq, OdtStrenCodePUDIFF1);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF1T::OdtStrenCodePDDIFF1T to 0x%x\n", pstate, freq, OdtStrenCodePDDIFF1);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_OdtImpedanceDIFF1T_ADDR), OdtImpedanceDIFF1);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF1C::OdtStrenCodePUDIFF1C to 0x%x\n", pstate, freq, OdtStrenCodePUDIFF1);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE OdtImpedanceDIFF1C::OdtStrenCodePDDIFF1C to 0x%x\n", pstate, freq, OdtStrenCodePDDIFF1);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_OdtImpedanceDIFF1C_ADDR), OdtImpedanceDIFF1);
		)
	} // foreach dbyte
	// ********* End ODT Impedance for DBYTE ********* //

	// ********* Start ODT Impedance for AC ********* //
	for (achn = 0; achn < NumAchn; achn++) { // for each AC channel
		c_addr = achn * c1;

		int OdtImpedanceSE0 = 0;
		int OdtStrenCodePUSE0 = 0;
		int OdtStrenCodePDSE0 = 0;

		int OdtImpedanceSE1 = 0;
		int OdtStrenCodePUSE1 = 0;
		int OdtStrenCodePDSE1 = 0;

		int OdtImpedanceDIFF0 = 0;
		int OdtStrenCodePUDIFF0 = 0;
		int OdtStrenCodePDDIFF0 = 0;

		int OdtImpedanceCa = pUserInputAdvanced->OdtImpedanceCa[pstate] >> calPD240;
		int OdtImpedanceCk = pUserInputAdvanced->OdtImpedanceCk[pstate] >> calPD240;

#ifdef _BUILD_LPDDR4
		int OdtImpedanceCs;
#endif

		_IF_LPDDR4(
			OdtImpedanceCs = pUserInputAdvanced->OdtImpedanceCs[pstate] >> calPD240;
        )

		// *** AC SE *** //
		switch (OdtImpedanceCa) {
		case 120:
			OdtStrenCodePDSE0 = 0x8;
			break;
		case 60:
			OdtStrenCodePDSE0 = 0xc;
			break;
		case 40:
			OdtStrenCodePDSE0 = 0xe;
			break;
		case 30:
			OdtStrenCodePDSE0 = 0xf;
			break;
		case 0:
			OdtStrenCodePDSE0 = 0x0;
			break;
		default:
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->OdtImpedanceCa[%d]=%d\n", pstate, pUserInputAdvanced->OdtImpedanceCa[pstate]);
			break;
		}

		OdtImpedanceSE0 = (OdtStrenCodePUSE0 << csr_OdtStrenCodePUSE0_LSB) | (OdtStrenCodePDSE0 << csr_OdtStrenCodePDSE0_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceSE0::OdtStrenCodePUSE0 to 0x%x\n", pstate, freq, OdtStrenCodePUSE0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceSE0::OdtStrenCodePDSE0 to 0x%x\n", pstate, freq, OdtStrenCodePDSE0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_OdtImpedanceSE0_ADDR), OdtImpedanceSE0);

		_IF_LPDDR5(
			OdtStrenCodePUSE1 = OdtStrenCodePUSE0;
			OdtStrenCodePDSE1 = OdtStrenCodePDSE0;
			OdtImpedanceSE1 = (OdtStrenCodePUSE1 << csr_OdtStrenCodePUSE1_LSB) | (OdtStrenCodePDSE1 << csr_OdtStrenCodePDSE1_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceSE1::OdtStrenCodePUSE1 to 0x%x\n", pstate, freq, OdtStrenCodePUSE1);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceSE1::OdtStrenCodePDSE1 to 0x%x\n", pstate, freq, OdtStrenCodePDSE1);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_OdtImpedanceSE1_ADDR), OdtImpedanceSE1);
		)

		_IF_LPDDR4(
			switch (OdtImpedanceCs) {
			case 120:
				OdtStrenCodePDSE1 = 0x8;
				break;
			case 60:
				OdtStrenCodePDSE1 = 0xc;
				break;
			case 40:
				OdtStrenCodePDSE1 = 0xe;
				break;
			case 30:
				OdtStrenCodePDSE1 = 0xf;
				break;
			case 0:
				OdtStrenCodePDSE1 = 0x0;
				break;
			default:
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->OdtImpedanceCs[%d]=%d\n", pstate, pUserInputAdvanced->OdtImpedanceCs[pstate]);
				break;
			}

			OdtImpedanceSE1 = (OdtStrenCodePUSE1 << csr_OdtStrenCodePUSE1_LSB) | (OdtStrenCodePDSE1 << csr_OdtStrenCodePDSE1_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceSE1::OdtStrenCodePUSE1 to 0x%x\n", pstate, freq, OdtStrenCodePUSE1);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceSE1::OdtStrenCodePDSE1 to 0x%x\n", pstate, freq, OdtStrenCodePDSE1);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_OdtImpedanceSE1_ADDR), OdtImpedanceSE1);
		)
		// *** AC DIFF *** //
		switch (OdtImpedanceCk) {
		case 120:
			OdtStrenCodePDDIFF0 = 0x8;
			break;
		case 60:
			OdtStrenCodePDDIFF0 = 0xc;
			break;
		case 40:
			OdtStrenCodePDDIFF0 = 0xe;
			break;
		case 30:
			OdtStrenCodePDDIFF0 = 0xf;
			break;
		case 0:
			OdtStrenCodePDDIFF0 = 0x0;
			break;
		default:
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid pUserInputAdvanced->OdtImpedanceCk[%d]=%d\n", pstate, pUserInputAdvanced->OdtImpedanceCk[pstate]);
			break;
		}

		OdtImpedanceDIFF0 = (OdtStrenCodePUDIFF0 << csr_OdtStrenCodePUDIFF0T_LSB) | (OdtStrenCodePDDIFF0 << csr_OdtStrenCodePDDIFF0T_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceDIFF0T::OdtStrenCodePUDIFF0T to 0x%x\n", pstate, freq, OdtStrenCodePUDIFF0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceDIFF0T::OdtStrenCodePDDIFF0T to 0x%x\n", pstate, freq, OdtStrenCodePDDIFF0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_OdtImpedanceDIFF0T_ADDR), OdtImpedanceDIFF0);

		OdtImpedanceDIFF0 = (OdtStrenCodePUDIFF0 << csr_OdtStrenCodePUDIFF0C_LSB) | (OdtStrenCodePDDIFF0 << csr_OdtStrenCodePDDIFF0C_LSB);

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceDIFF0C::OdtStrenCodePUDIFF0C to 0x%x\n", pstate, freq, OdtStrenCodePUDIFF0);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC OdtImpedanceDIFF0C::OdtStrenCodePDDIFF0C to 0x%x\n", pstate, freq, OdtStrenCodePDDIFF0);
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tAC | csr_OdtImpedanceDIFF0C_ADDR), OdtImpedanceDIFF0);
	}
	// ********* End ODT Impedance for AC ********* //

	/*
	 * - Program Tx Slew Rate Control registers TxSlewSE0, TxSlewSE1, TxSlewDIFF0, TxSlewDIFF1
	 *   - Dependencies:
	 *     - user_input_advanced.TxSlewRiseDq
	 *     - user_input_advanced.TxSlewFallDq
	 *     - user_input_advanced.TxSlewRiseDqs
	 *     - user_input_advanced.TxSlewFallDqs
	 *     - user_input_advanced.TxSlewRiseCA
	 *     - user_input_advanced.TxSlewFallCA
	 *     - user_input_advanced.TxSlewRiseCS (only applies to LPDDR4 protocol)
	 *     - user_input_advanced.TxSlewFallCS (only applies to LPDDR4 protocol)
	 *     - user_input_advanced.TxSlewRiseCK
	 *     - user_input_advanced.TxSlewFallCK
	 *     - user_input_advanced.TxSlewRiseWCK (only applies to LPDDR5 protocol)
	 *     - user_input_advanced.TxSlewFallWCK (only applies to LPDDR5 protocol)
	 */
	uint16_t valTxSlewPU;
	uint16_t valTxSlewPD;
	uint16_t valTxSlew;

	for (achn = 0; achn < NumAchn; achn++) {
		c_addr = achn << 12;

		_IF_LPDDR4(
			// *** AC SE CA0-CA5 *** //
			valTxSlewPU = pUserInputAdvanced->TxSlewRiseCA[pstate];
			valTxSlewPD = pUserInputAdvanced->TxSlewFallCA[pstate];
			valTxSlew = (valTxSlewPU << csr_TxSlewPUSE0_LSB) | (valTxSlewPD << csr_TxSlewPDSE0_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE0::TxSlewPUSE0 to 0x%x\n", pstate, freq, valTxSlewPU);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE0::TxSlewPDSE0 to 0x%x\n", pstate, freq, valTxSlewPD);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE0 to 0x%x\n", pstate, freq, valTxSlew);
			dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxSlewSE0_ADDR), valTxSlew);
			// *** AC SE CS (CA6 and CA7) *** //
			valTxSlewPU = pUserInputAdvanced->TxSlewRiseCS[pstate];
			valTxSlewPD = pUserInputAdvanced->TxSlewFallCS[pstate];
			valTxSlew = (valTxSlewPU << csr_TxSlewPUSE1_LSB) | (valTxSlewPD << csr_TxSlewPDSE1_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE1::TxSlewPUSE1 to 0x%x\n", pstate, freq, valTxSlewPU);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE1::TxSlewPDSE1 to 0x%x\n", pstate, freq, valTxSlewPD);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE1 to 0x%x\n", pstate, freq, valTxSlew);
			dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxSlewSE1_ADDR), valTxSlew);
		)
		_IF_LPDDR5(
			// *** AC SE CA0-CA6 *** //
			valTxSlewPU = pUserInputAdvanced->TxSlewRiseCA[pstate];
			valTxSlewPD = pUserInputAdvanced->TxSlewFallCA[pstate];
			valTxSlew = (valTxSlewPU << csr_TxSlewPUSE0_LSB) | (valTxSlewPD << csr_TxSlewPDSE0_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE0::TxSlewPUSE0 to 0x%x\n", pstate, freq, valTxSlewPU);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE0::TxSlewPDSE0 to 0x%x\n", pstate, freq, valTxSlewPD);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE0 to 0x%x\n", pstate, freq, valTxSlew);
			dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxSlewSE0_ADDR), valTxSlew);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE1::TxSlewPUSE1 to 0x%x\n", pstate, freq, valTxSlewPU);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE1::TxSlewPDSE1 to 0x%x\n", pstate, freq, valTxSlewPD);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewSE1 to 0x%x\n", pstate, freq, valTxSlew);
			dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxSlewSE1_ADDR), valTxSlew);
		)
		// *** AC DIFF CK *** //
		valTxSlewPU = pUserInputAdvanced->TxSlewRiseCK[pstate];
		valTxSlewPD = pUserInputAdvanced->TxSlewFallCK[pstate];
		valTxSlew = (valTxSlewPU << csr_TxSlewPUDIFF0_LSB) | (valTxSlewPD << csr_TxSlewPDDIFF0_LSB);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewDIFF0::TxSlewPUDIFF0 to 0x%x\n", pstate, freq, valTxSlewPU);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewDIFF0::TxSlewPDDIFF0 to 0x%x\n", pstate, freq, valTxSlewPD);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AC TxSlewDIFF0 to 0x%x\n", pstate, freq, valTxSlew);
		dwc_ddrphy_phyinit_io_write16((p_addr | tAC | c_addr | csr_TxSlewDIFF0_ADDR), valTxSlew);
	} // achn

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte << 12;

		// *** DBYTE SE DQ and DMI *** //
		valTxSlewPU = pUserInputAdvanced->TxSlewRiseDq[pstate];
		valTxSlewPD = pUserInputAdvanced->TxSlewFallDq[pstate];
		valTxSlew = (valTxSlewPU << csr_TxSlewPUSE0_LSB) | (valTxSlewPD << csr_TxSlewPDSE0_LSB);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewSE0::TxSlewPUSE0 to 0x%x\n", pstate, freq, valTxSlewPU);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewSE0::TxSlewPDSE0 to 0x%x\n", pstate, freq, valTxSlewPD);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewSE0 to 0x%x\n", pstate, freq, valTxSlew);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_TxSlewSE0_ADDR), valTxSlew);

		// *** DBYTE DIFF DQS *** //
		valTxSlewPU = pUserInputAdvanced->TxSlewRiseDqs[pstate];
		valTxSlewPD = pUserInputAdvanced->TxSlewFallDqs[pstate];
		valTxSlew = (valTxSlewPU << csr_TxSlewPUDIFF0_LSB) | (valTxSlewPD << csr_TxSlewPDDIFF0_LSB);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewDIFF0::TxSlewPUDIFF0 to 0x%x\n", pstate, freq, valTxSlewPU);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewDIFF0::TxSlewPDDIFF0 to 0x%x\n", pstate, freq, valTxSlewPD);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewDIFF0 to 0x%x\n", pstate, freq, valTxSlew);
		dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_TxSlewDIFF0_ADDR), valTxSlew);

		_IF_LPDDR5(
			// *** DBYTE DIFF WCK *** //
			valTxSlewPU = pUserInputAdvanced->TxSlewRiseWCK[pstate];
			valTxSlewPD = pUserInputAdvanced->TxSlewFallWCK[pstate];
			valTxSlew = (valTxSlewPU << csr_TxSlewPUDIFF1_LSB) | (valTxSlewPD << csr_TxSlewPDDIFF1_LSB);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewDIFF1::TxSlewPUDIFF1 to 0x%x\n", pstate, freq, valTxSlewPU);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewDIFF1::TxSlewPDDIFF1 to 0x%x\n", pstate, freq, valTxSlewPD);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming DBYTE TxSlewDIFF1 to 0x%x\n", pstate, freq, valTxSlew);
			dwc_ddrphy_phyinit_io_write16((p_addr | tDBYTE | c_addr | csr_TxSlewDIFF1_ADDR), valTxSlew);
		)
	}

	/**
	 *
	 * - Program SingleEndedMode
	 */
	dwc_ddrphy_phyinit_userCustom_io_write16((p_addr | tMASTER | csr_SingleEndedMode_ADDR), 0);

	/**
	 *
	 * - Program RxDiffSeDIFF0, RxDiffSeCtlDIFF0, RxDiffSeVrefDACEnDIFF0, RxDiffSeVrefDACDIFF0 if required.
	 *   - mb1D[pstate].MR12_A0 (only applies to LPDDR4 protocol)
	 *   - mb1D[pstate].MR51_A0 (only applies to LPDDR4 protocol)
	 *   - mb1D[pstate].MR14_A0 (only applies to LPDDR5 protocol)
	 *   - mb1D[pstate].MR15_A0 (only applies to LPDDR5 protocol)
	 *   - mb1D[pstate].MR20_A0 (only applies to LPDDR5 protocol)
	 *
	 */
	_IF_LPDDR4(
		if (pUserInputBasic->Lp4xMode == 1) {
			for (byte = 0; byte < NumDbyte; byte++) { // for each dbyte
				c_addr = byte * c1;
				// Set the singleEndedModeRDQS variable based off the Mode Register input.
				uint16_t singleEndedModeRDQS = (mb1D[pstate].MR51_A0 & 0x2) >> 1;
				uint16_t RxDiffSeCtlDIFF0 = 0x0;
				uint16_t RxDiffSeVrefDACEnDIFF0 = 0x0;
				uint16_t RxDiffSeVrefDACDIFF0 = pUserInputAdvanced->PhyVrefCode & 0x7f;

				// Check if DQS is in Single-ended mode
				switch (singleEndedModeRDQS) {
				case 0:
					break;
				case 1:
					RxDiffSeCtlDIFF0 = 0x1;
					RxDiffSeVrefDACEnDIFF0 = 0x1;
					break;
				default:
					dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid singleEndedModeRDQS = %d, pstate = %d\n", singleEndedModeRDQS, pstate);
					break;
				}

				uint16_t RxDiffSeDIFF0 = (((RxDiffSeCtlDIFF0 << csr_RxDiffSeCtlDIFF0_LSB) & csr_RxDiffSeCtlDIFF0_MASK) | ((RxDiffSeVrefDACEnDIFF0 << csr_RxDiffSeVrefDACEnDIFF0_LSB) & csr_RxDiffSeVrefDACEnDIFF0_MASK));

				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming DBYTE%d.RxDiffSeDIFF0::RxDiffSeCtlDIFF0 to 0x%x\n", pstate, byte, RxDiffSeCtlDIFF0);
				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming DBYTE%d.RxDiffSeDIFF0::RxDiffSeVrefDACEnDIFF0 to 0x%x\n", pstate, byte, RxDiffSeVrefDACEnDIFF0);
				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming DBYTE%d.RxDiffSeDIFF0 to 0x%x\n", pstate, byte, RxDiffSeDIFF0);
				dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_RxDiffSeDIFF0_ADDR), RxDiffSeDIFF0);

				dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, DBYTE=%d Programming RxDiffSeVrefDACDIFF0 to 0x%x\n", pstate, byte, RxDiffSeVrefDACDIFF0);
				dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_RxDiffSeVrefDACDIFF0_ADDR), RxDiffSeVrefDACDIFF0);
			} // dbyte
		} // Lp4x
	)
	_IF_LPDDR5(
		for (byte = 0; byte < NumDbyte; byte++) { // for each dbyte
			c_addr = byte * c1;
			// Set the singleEndedModeRDQS variable based off the Mode Register input.
			uint16_t singleEndedModeRDQS = (mb1D[pstate].MR20_A0 & 0x3);
			uint16_t RxDiffSeCtlDIFF0 = 0x0;
			uint16_t RxDiffSeVrefDACEnDIFF0 = 0x0;
			uint16_t RxDiffSeVrefDACDIFF0 = pUserInputAdvanced->PhyVrefCode & 0x7f;

			// Check if DQS is in Single-ended mode
			switch (singleEndedModeRDQS) {
			case 0:
				break; // Strobless mode
			case 1: // DQS_t used
				RxDiffSeCtlDIFF0 = 0x1;
				RxDiffSeVrefDACEnDIFF0 = 0x1;
				break;
			case 2: // differential
				RxDiffSeCtlDIFF0 = 0x0;
				RxDiffSeVrefDACEnDIFF0 = 0x0;
				break;
			case 3: // DQS_c used
				RxDiffSeCtlDIFF0 = 0x2;
				RxDiffSeVrefDACEnDIFF0 = 0x1;
				break;
			default:
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Invalid singleEndedModeRDQS = %d, pstate = %d\n", singleEndedModeRDQS, pstate);
				break;
			}

			uint16_t RxDiffSeDIFF0 = (((RxDiffSeCtlDIFF0 << csr_RxDiffSeCtlDIFF0_LSB) & csr_RxDiffSeCtlDIFF0_MASK) | ((RxDiffSeVrefDACEnDIFF0 << csr_RxDiffSeVrefDACEnDIFF0_LSB) & csr_RxDiffSeVrefDACEnDIFF0_MASK));

			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming DBYTE%d.RxDiffSeDIFF0::RxDiffSeCtlDIFF0 to 0x%x\n", pstate, byte, RxDiffSeCtlDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming DBYTE%d.RxDiffSeDIFF0::RxDiffSeVrefDACEnDIFF0 to 0x%x\n", pstate, byte, RxDiffSeVrefDACEnDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming DBYTE%d.RxDiffSeDIFF0 to 0x%x\n", pstate, byte, RxDiffSeDIFF0);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_RxDiffSeDIFF0_ADDR), RxDiffSeDIFF0);
			dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, DBYTE=%d Programming RxDiffSeVrefDACDIFF0 to 0x%x\n", pstate, byte, RxDiffSeVrefDACDIFF0);
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_RxDiffSeVrefDACDIFF0_ADDR), RxDiffSeVrefDACDIFF0);
		} // dbyte
	)
	_IF_LPDDR5(
		/*
		 * - Program WriteLinkEcc
		 *   - Dependencies:
		 *     - mb1D[pstate].MR22_A0
		 */
		regData = ((mb1D[pstate].MR22_A0 & 0x30) == 0x10) ? 0x1 : 0x0;
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Programming WriteLinkEcc to %d\n", regData);
		for (byte = 0; byte < NumDbyte; byte++) { // for each dbyte
			c_addr = byte * c1;
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_EnableWriteLinkEcc_ADDR), regData);
		}
	)

	/**
	 * - Program initial values for DllGainCtl, DxDllLockParam and AcDllLockParam
	 *   and also RxReplicaDllGainCtl, RxReplicaDllLockParam.
	 *
	 */
	uint16_t AcDllGainIV = 0x1;
	uint16_t AcDllGainTV = 0xa;
	uint16_t DxDllGainIV = 0x1;
	uint16_t DxDllGainTV = 0xa;
	uint16_t RxDllGainIV = 0x1;
	uint16_t RxDllGainTV = 0xa;
	uint16_t wdDxDllLockParam = 0x40;
	uint16_t wdAcDllLockParam = 0x40;
	uint16_t RxRpDllLockParam = 0x40;

	uint16_t wdDllGainCtl = (csr_AcDllGainTV_MASK & (AcDllGainTV << csr_AcDllGainTV_LSB))
							| (csr_AcDllGainIV_MASK & (AcDllGainIV << csr_AcDllGainIV_LSB))
							| (csr_DxDllGainTV_MASK & (DxDllGainTV << csr_DxDllGainTV_LSB))
							| (csr_DxDllGainIV_MASK & (DxDllGainIV << csr_DxDllGainIV_LSB));

	uint16_t RxReplicaDllGainCtl = (csr_RxReplicaDllGainTV_MASK & (RxDllGainTV << csr_RxReplicaDllGainTV_LSB)) | (csr_RxReplicaDllGainIV_MASK & (RxDllGainIV << csr_RxReplicaDllGainIV_LSB));

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming DllGainCtl to 0x%x\n", pstate, wdDllGainCtl);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_DllGainCtl_ADDR), wdDllGainCtl);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, DX Programming DxDllLockParam to 0x%x\n", pstate, wdDxDllLockParam);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_DxDllLockParam_ADDR), wdDxDllLockParam << csr_DxLcdlSeed0_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, AC Programming AcDllLockParam to 0x%x\n", pstate, wdAcDllLockParam);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_AcDllLockParam_ADDR), wdAcDllLockParam << csr_AcLcdlSeed0_LSB);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming RxReplicaDllGainCtl to 0x%x\n", pstate, RxReplicaDllGainCtl);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_RxReplicaDllGainCtl_ADDR), RxReplicaDllGainCtl);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, DX Programming RxReplicaDllLockParam to 0x%x\n", pstate, RxRpDllLockParam);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_RxReplicaDllLockParam_ADDR), RxRpDllLockParam << csr_RxReplicaLcdlSeed_LSB);

	/**
	 * - Registers: PPTTrainSetup and PPTTrainSetup2
	 *   - Related to DFI PHY Master Interface (PMI). See Register description in PUB.
	 *   - Enable DFI PMI if training firmware was run
	 *   - Fields:
	 *     - PhyMstrTrainInterval
	 *     - PhyMstrMaxReqToAck
	 *     - PhyMstrFreqOverride
	 *     - PhyMstrCtrlMode
	 *   - Dependencies:
	 *     - skip_training
	 *     - user_input_basic.Frequency
	 *     - user_input_advanced.PhyMstrTrainInterval
	 *     - user_input_advanced.PhyMstrMaxReqToAck
	 *     - user_input_advanced.PhyMstrCtrlMode
	 */
	int freqThreshold;

	_IF_LPDDR4(
		freqThreshold = 333;
	)
	_IF_LPDDR5(
		freqThreshold = pUserInputBasic->DfiFreqRatio[pstate] == 1 ? 166 : 83;
	)
	uint16_t PhyMstrFreqOverride;
	uint16_t PPTTrainSetup;

	if (freq >= freqThreshold) {
		PPTTrainSetup = (pUserInputAdvanced->PhyMstrTrainInterval[pstate] << csr_PhyMstrTrainInterval_LSB) |
						(pUserInputAdvanced->PhyMstrMaxReqToAck[pstate] << csr_PhyMstrMaxReqToAck_LSB) |
						(pUserInputAdvanced->PhyMstrCtrlMode[pstate] << csr_PhyMstrCtrlMode_LSB);
		PhyMstrFreqOverride = 0xf;
	} else {
		PhyMstrFreqOverride = 0x0;
		PPTTrainSetup = 0x0;
	}

	_IF_LPDDR5(
		uint8_t rdqsMode = mb1D[pstate].MR20_A0 & 0x3;

		if (rdqsMode == 0 && pUserInputAdvanced->PhyMstrTrainInterval[pstate] != 0) {
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] Pstate=%d RDQS cannot be disabled when PHY Master Interface is enabled (PhyMstrTrainInterval=%d)\n", pstate, pUserInputAdvanced->PhyMstrTrainInterval[pstate]);
		}
	)
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming PPTTrainSetup::PhyMstrTrainInterval to 0x%x\n", pstate, freq, pUserInputAdvanced->PhyMstrTrainInterval[pstate]);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming PPTTrainSetup::PhyMstrMaxReqToAck to 0x%x\n", pstate, freq, pUserInputAdvanced->PhyMstrMaxReqToAck[pstate]);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming PPTTrainSetup::PhyMstrCtrlMode to 0x%x\n", pstate, freq, pUserInputAdvanced->PhyMstrCtrlMode[pstate]);
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_PPTTrainSetup_ADDR), PPTTrainSetup);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming PPTTrainSetup2::PhyMstrFreqOverride to 0x%x\n", pstate, freq, PhyMstrFreqOverride);
#if PUB==1
	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_PPTTrainSetup2_ADDR), PhyMstrFreqOverride);
#else
	/**
	 * - program TxPptMode
	 */
	uint16_t TxPptMode = (pUserInputAdvanced->RetrainMode[pstate] == 2) || (pUserInputAdvanced->RetrainMode[pstate] == 4) ? 1 : 0;
	uint16_t RxClkPptMode = (pUserInputAdvanced->RetrainMode[pstate] == 2) || (pUserInputAdvanced->RetrainMode[pstate] == 4) ? 1 : 0;

	dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_PPTTrainSetup2_ADDR), PhyMstrFreqOverride | (TxPptMode << csr_TxPptMode_LSB) | (RxClkPptMode << csr_RxClkPptMode_LSB));
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BGPR11_ADDR), PhyMstrFreqOverride | (TxPptMode << csr_TxPptMode_LSB) );                                         // GPR11 = PPTTrainSetup2 setting for PPT1 (RxClkPptMode = 0)
	dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tINITENG | csr_Seq0BGPR12_ADDR), PhyMstrFreqOverride | (TxPptMode << csr_TxPptMode_LSB) | (RxClkPptMode << csr_RxClkPptMode_LSB)); // GPR12 = PPTTrainSetup2 setting for PPT2 (RxClkPptMode = 1)
#endif
	/**
	 * - Register: RxTrainPattern8BitMode
	 *   - Dependencies:
	 *    - user_input_basic.DfiFreqRatio
	 */
	for (byte = 0; byte < NumDbyte; byte++) { // for each chiplet
		c_addr = byte * c1;
		uint16_t RxTrnPtrn = (pUserInputBasic->DfiFreqRatio[pstate] == 0x2) ? 0x1 : 0x0;

		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_RxTrainPattern8BitMode_ADDR), RxTrnPtrn);
	}

	/**
	 * - Program RxReplicaRangeVal
	 *   - Fields
	 *     - RxReplicaShortCalRangeA
	 *     - RxReplicaShortCalRangeB
	 */
	uint16_t RxReplicaShortRange = ((RxReplicaShortRangeA << csr_RxReplicaShortCalRangeA_LSB) & csr_RxReplicaShortCalRangeA_MASK)
									| ((RxReplicaShortRangeB << csr_RxReplicaShortCalRangeB_LSB) & csr_RxReplicaShortCalRangeB_MASK);
	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Programming RxReplicaRangeVal 0x%x\n", pstate, RxReplicaShortRange);

	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = byte * c1;
		dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_RxReplicaRangeVal_ADDR), RxReplicaShortRange);
	}

	/**
	 * - Program RxReplicaCtl04
	 *   - Fields
	 *     - RxReplicaTrackEn
	 *     - RxReplicaLongCal
	 *     - RxReplicaStride
	 */
#if PUB!=1
	uint16_t RxRepl_recovery;
	_IF_LPDDR5(
		RxRepl_recovery = (2*freq) / 100;
	)
	_IF_LPDDR4(
		RxRepl_recovery = (2*freq) / (100 << pUserInputBasic->DfiFreqRatio[pstate]);
	)
#endif
	uint16_t RxReplicaCtl = (0 << csr_RxReplicaTrackEn_LSB) // disable RxClk tracking before training
							| (1 << csr_RxReplicaLongCal_LSB) // long cal during boot
							| (1 << csr_RxReplicaStride_LSB) // Keep the default value of 1 step
#if PUB!=1
							| (1 << csr_RxReplicaPDenFSM_LSB) // RxReplica Receiver Powerdown save power
							| (RxRepl_recovery << csr_RxReplicaPDRecoverytime_LSB); //20ns(in DfiClk) required for RxReplica powerdown recovery
#else
							;
#endif
	// Programming RxReplicaCtl04 without register tracking. We later program the same CSR in step I.
	for (byte = 0; byte < NumDbyte; byte++) {
		c_addr = c1 * byte;
		dwc_ddrphy_phyinit_userCustom_io_write16((p_addr | c_addr | tDBYTE | csr_RxReplicaCtl04_ADDR), RxReplicaCtl);
	}

#ifdef _BUILD_LPDDR5
	/**
	 * - Program WCK pulse registers for ACSM
	 *      - ACSMWckWriteStaticLoPulse
	 *      - ACSMWckWriteStaticHiPulse
	 *      - ACSMWckWriteTogglePulse
	 *      - ACSMWckWriteFastTogglePulse
	 *      - ACSMWckReadStaticLoPulse
	 *      - ACSMWckReadStaticHiPulse
	 *      - ACSMWckReadTogglePulse
	 *      - ACSMWckReadFastTogglePulse
	 *      - ACSMWckFreqSwStaticLoPulse
	 *      - ACSMWckFreqSwStaticHiPulse
	 *      - ACSMWckFreqSwTogglePulse
	 *      - ACSMWckFreqSwFastTogglePulse
	 *   - Dependencies:
	 *     - user_input_basic.Frequency
	 *     - user_input_basic.DfiFreqRatio
	 */
	const uint16_t RD_AC_FREQ_LOWER = 0;
	const uint16_t RD_AC_FREQ_UPPER = 1;
	const uint16_t RD_AC_RL_SETA = 2;
	const uint16_t RD_AC_RL_SETB = 3;
	const uint16_t RD_AC_RL_SETC = 4;
	const uint16_t RD_AC_TWCKENL_RD_SETA = 5;
	const uint16_t RD_AC_TWCKENL_RD_SETB = 6;
	const uint16_t RD_AC_TWCKENL_RD_SETC = 7;
	const uint16_t RD_AC_TWCKENL_RD_ECC_A = 5;
	const uint16_t RD_AC_TWCKENL_RD_ECC_B = 6;
	const uint16_t RD_AC_TWCKEPRE_STATIC = 8;
	const uint16_t RD_AC_TWCKEPRE_TOGGLE_RD = 9;
	const uint16_t FS_AC_TWCKENL_FS = 3;
	const uint16_t WR_AC_WL_SETA = 2;
	const uint16_t WR_AC_WL_SETB = 3;
	const uint16_t WR_AC_TWCKENL_WR_SETA = 4;
	const uint16_t WR_AC_TWCKENL_WR_SETB = 5;
	const uint16_t WR_AC_TWCKEPRE_TOGGLE_WR = 7;

	// DVFSC disabled, Read Link ECC disabled
	static const uint16_t WCK2CK_Sync_RD_lookup_A[2][12][11] = {
		{
			{10, 133, 6, 6, 6, 0, 0, 0, 1, 6, 7},
			{133, 267, 8, 8, 8, 0, 0, 0, 2, 7, 9},
			{267, 400, 10, 10, 12, 1, 1, 3, 2, 8, 10},
			{400, 533, 12, 14, 14, 2, 4, 4, 3, 8, 11},
			{533, 688, 16, 16, 18, 3, 3, 5, 4, 10, 14},
			{688, 800, 18, 20, 20, 5, 7, 7, 4, 10, 14},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
		}, {
			{5, 67, 3, 3, 3, 0, 0, 0, 1, 3, 4},
			{67, 133, 4, 4, 4, 0, 0, 0, 1, 4, 5},
			{133, 200, 5, 5, 6, 1, 1, 2, 1, 4, 5},
			{200, 267, 6, 7, 7, 1, 2, 2, 2, 4, 6},
			{267, 344, 8, 8, 9, 2, 2, 3, 2, 5, 7},
			{344, 400, 9, 10, 10, 3, 4, 4, 2, 5, 7},
			{400, 467, 10, 11, 12, 3, 4, 5, 3, 5, 8},
			{467, 533, 12, 13, 14, 4, 5, 6, 3, 6, 9},
			{533, 600, 13, 14, 15, 5, 6, 7, 3, 6, 9},
			{600, 688, 15, 16, 17, 6, 7, 8, 4, 6, 10},
			{688, 750, 16, 17, 19, 6, 7, 9, 4, 7, 11},
			{750, 800, 17, 18, 20, 7, 8, 10, 4, 7, 11}
		}
	};

	// DVFSC enabled, Read Link ECC disabled
	static const uint16_t WCK2CK_Sync_RD_lookup_B[2][3][11] = {
		{
			{10, 133, 6, 6, 6, 0, 0, 0, 1, 6, 7},
			{133, 267, 8, 10, 10, 0, 2, 2, 2, 7, 9},
			{267, 400, 12, 12, 14, 3, 3, 5, 2, 8, 10}
		}, {
			{5, 67, 3, 3, 3, 0, 0, 0, 1, 3, 4},
			{67, 133, 4, 5, 5, 0, 1, 1, 1, 4, 5},
			{133, 200, 6, 6, 7, 2, 2, 3, 1, 4, 5}
		}
	};

	// DVFSC disabled, Read Link ECC enabled
	static const uint16_t WCK2CK_Sync_RD_lookup_C[1][6][11] = {
		{
			{400, 467, 12, 13, 0, 5, 6, 0, 3, 5, 8},
			{467, 533, 13, 14, 0, 5, 6, 0, 3, 6, 9},
			{533, 600, 15, 16, 0, 7, 8, 0, 3, 6, 9},
			{600, 688, 17, 18, 0, 8, 9, 0, 4, 6, 10},
			{688, 750, 18, 20, 0, 8, 10, 0, 4, 7, 11},
			{750, 800, 19, 21, 0, 9, 11, 0, 4, 7, 11}
		}
	};

	static const uint16_t WCK2CK_Sync_WR_lookup[2][12][9] = {
		{
			{10, 133, 4, 4, 1, 1, 1, 3, 4},
			{133, 267, 4, 6, 0, 2, 2, 3, 5},
			{267, 400, 6, 8, 1, 3, 2, 4, 6},
			{400, 533, 8, 10, 2, 4, 3, 4, 7},
			{533, 688, 8, 14, 1, 7, 4, 4, 8},
			{688, 800, 10, 16, 3, 9, 4, 4, 8},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0}
		}, {
			{5, 67, 2, 2, 0, 0, 1, 2, 3},
			{67, 133, 2, 3, 0, 1, 1, 2, 3},
			{133, 200, 3, 4, 1, 2, 1, 2, 3},
			{200, 267, 4, 5, 1, 2, 2, 2, 4},
			{267, 344, 4, 7, 1, 4, 2, 2, 4},
			{344, 400, 5, 8, 2, 5, 2, 2, 4},
			{400, 467, 6, 9, 2, 5, 3, 2, 5},
			{467, 533, 6, 11, 2, 7, 3, 2, 5},
			{533, 600, 7, 12, 3, 8, 3, 2, 5},
			{600, 688, 8, 14, 3, 9, 4, 2, 6},
			{688, 750, 9, 15, 4, 10, 4, 2, 6},
			{750, 800, 9, 16, 4, 11, 4, 2, 6}
		}
	};

	static const uint16_t WCK2CK_Sync_FS_lookup[2][12][5] = {
		{
			{10, 133, 0x0, 0, 1},
			{133, 267, 0x1, 0, 2},
			{267, 400, 0x2, 1, 2},
			{400, 533, 0x3, 1, 3},
			{533, 688, 0x4, 1, 4},
			{688, 800, 0x5, 2, 4},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0}
		}, {
			{5, 67, 0x0, 0, 1},
			{67, 133, 0x1, 0, 1},
			{133, 200, 0x2, 1, 1},
			{200, 267, 0x3, 1, 2},
			{267, 344, 0x4, 1, 2},
			{344, 400, 0x5, 1, 2},
			{400, 467, 0x6, 1, 3},
			{467, 533, 0x7, 1, 3},
			{533, 600, 0x8, 2, 3},
			{600, 688, 0x9, 2, 4},
			{688, 750, 0xa, 2, 4},
			{750, 800, 0xb, 2, 4}
		}
	};
#endif

	_IF_LPDDR5(
		const uint16_t *WCK2CK_Sync_RD_lookup;
		uint16_t RD_AC_RL;
		uint16_t WR_AC_WL;
		uint16_t RD_AC_TWCKENL_RD;
		uint16_t WR_AC_TWCKENL_WR;
		uint16_t BLnmax;
		uint16_t tWCKPST;
		uint8_t ratioIndex;
		uint8_t numSpeeds;
		uint8_t RD_AC_RL_DBI;

		uint8_t readLatencyDbi = 0;
		uint16_t BLdiv2 = 8;
		uint16_t readLatency = 3;
		uint16_t writeLatency = 3;
		uint16_t tWCKENL_WR = 0;
		uint16_t tWCKENL_RD = 0;
		uint16_t tWCKENL_FS = 0;
		uint16_t tWCKPRE_static = 2;
		uint16_t tWCKPRE_Toggle_WR = 3;
		uint16_t tWCKPRE_Toggle_RD = 6;
		uint16_t tWCKPRE_Toggle_FS = 3;

		uint8_t dvfsc = mb1D[pstate].MR19_A0 & 0x3;
		uint8_t readLinkEcc = (mb1D[pstate].MR22_A0 >> 6) & 0x3;
		uint8_t writeLinkEcc = (mb1D[pstate].MR22_A0 >> 4) & 0x3;  // MR22 OP[5:4] WECC b00 : disable, b01 : enable
		uint8_t readDbi = (mb1D[pstate].MR3_A0 >> 6) & 1;
		uint8_t readCpy = (mb1D[pstate].MR21_A0 >> 5) & 1;
		uint8_t readEither = (readDbi | readCpy) & 1;
		uint8_t wls = (mb1D[pstate].MR3_A0 >> 5) & 1;
		uint8_t bankOrg = (mb1D[pstate].MR3_A0 >> 3) & 0x3; // MR3  OP[4:3] BK/BG ORG, b00 : BG mode, b10 : 16B mode, b01 8B mode
		uint8_t byteMode = (pUserInputBasic->DramDataWidth == 8) ? 1 : 0;

		if (writeLinkEcc && !readLinkEcc) {
			dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfig] RECC must be enabled if WECC is enabled ! RECC = %d, WECC = %d", readLinkEcc, writeLinkEcc);
		}

		if (dvfsc) {
			ratioIndex = ratio == 2 ? 0 : 1;
			numSpeeds = 3;
			WCK2CK_Sync_RD_lookup = WCK2CK_Sync_RD_lookup_B[ratioIndex][0];
		} else if (readLinkEcc) {
			ratioIndex = 0;
			numSpeeds = 6;
			WCK2CK_Sync_RD_lookup = WCK2CK_Sync_RD_lookup_C[ratioIndex][0];
		} else {
			ratioIndex = ratio == 2 ? 0 : 1;
			numSpeeds = ratioIndex ? 12 : 6;
			WCK2CK_Sync_RD_lookup = WCK2CK_Sync_RD_lookup_A[ratioIndex][0];
		}

		if (readLinkEcc) {
			if (byteMode) {
				RD_AC_RL = RD_AC_RL_SETB;
				RD_AC_TWCKENL_RD = RD_AC_TWCKENL_RD_ECC_B;
				RD_AC_RL_DBI = RD_AC_RL_SETB;
			} else {
				RD_AC_RL = RD_AC_RL_SETA;
				RD_AC_TWCKENL_RD = RD_AC_TWCKENL_RD_ECC_A;
				RD_AC_RL_DBI = RD_AC_RL_SETA;
			}
		} else {
			switch (readEither + byteMode) {
			case 2:
				RD_AC_RL = RD_AC_RL_SETC;
				RD_AC_TWCKENL_RD = RD_AC_TWCKENL_RD_SETC;
				RD_AC_RL_DBI = RD_AC_RL_SETC;
				break;
			case 1:
				RD_AC_RL = RD_AC_RL_SETB;
				RD_AC_TWCKENL_RD = RD_AC_TWCKENL_RD_SETB;
				if (byteMode == 1) {
					RD_AC_RL_DBI = RD_AC_RL_SETC;
				} else {
					RD_AC_RL_DBI = RD_AC_RL_SETB;
				}
				break;
			case 0:
			default:
				RD_AC_RL = RD_AC_RL_SETA;
				RD_AC_TWCKENL_RD = RD_AC_TWCKENL_RD_SETA;
				RD_AC_RL_DBI = RD_AC_RL_SETB;
				break;
			}
		}

		// Write Latency Set
		if (wls) {
			WR_AC_WL = WR_AC_WL_SETB;
			WR_AC_TWCKENL_WR = WR_AC_TWCKENL_WR_SETB;
		} else {
			WR_AC_WL = WR_AC_WL_SETA;
			WR_AC_TWCKENL_WR = WR_AC_TWCKENL_WR_SETA;
		}

		// BL/n_max
		switch (bankOrg) {
		case 2: // 16B Mode
			BLnmax = (ratio == 2) ? 4 : 2;
			break;
		case 1: // 8B Mode
		case 0: // BG Mode
		default:
			BLnmax = (ratio == 2) ? 8 : 4;
			break;
		}

		switch ((mb1D[pstate].MR10_A0 >> 2) & 0x3) {
		case 2: // 6.5*tWCK
			tWCKPST = 6 + 1;
			break;
		case 1: // 4.5*tWCK
			tWCKPST = 4 + 1;
			break;
		case 0: // 2.5*tWCK (default)
		default:
			tWCKPST = 2 + 1;
			break;
		}

		uint16_t lowFreqBuffer = 0;

		// Read parameters
		for (int i = 0; i < numSpeeds; ++i) {
			if ((freq) > WCK2CK_Sync_RD_lookup[i * 11 + RD_AC_FREQ_LOWER] && (freq) <= WCK2CK_Sync_RD_lookup[i * 11 + RD_AC_FREQ_UPPER]) {
				if (freq <= 133 && ratio == 4) {
					lowFreqBuffer = 1;
				} else if (freq <= 267 && ratio == 2) {
					lowFreqBuffer = 2;
				} else if (freq <= 688 && freq >= 267 && ratio == 2) {
					lowFreqBuffer = 1;
				} else {
					lowFreqBuffer = 0;
				}

				readLatency = WCK2CK_Sync_RD_lookup[i * 11 + RD_AC_RL] + lowFreqBuffer;
				readLatencyDbi = WCK2CK_Sync_RD_lookup[i * 11 + RD_AC_RL_DBI] + lowFreqBuffer;
				tWCKENL_RD = WCK2CK_Sync_RD_lookup[i * 11 + RD_AC_TWCKENL_RD] + lowFreqBuffer;
				tWCKPRE_static = WCK2CK_Sync_RD_lookup[i * 11 + RD_AC_TWCKEPRE_STATIC];
				tWCKPRE_Toggle_RD = WCK2CK_Sync_RD_lookup[i * 11 + RD_AC_TWCKEPRE_TOGGLE_RD];
				break;
			}
		}

		// Write and Fast Toggle parameters
		ratioIndex = ratio == 2 ? 0 : 1;
		numSpeeds = ratioIndex ? 12 : 6;
		for (int i = 0; i < numSpeeds; ++i) {
			if ((freq) > WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_LOWER] && (freq) <= WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_UPPER]) {
				writeLatency = WCK2CK_Sync_WR_lookup[ratioIndex][i][WR_AC_WL] + lowFreqBuffer;
				tWCKENL_WR = WCK2CK_Sync_WR_lookup[ratioIndex][i][WR_AC_TWCKENL_WR] + lowFreqBuffer;
				tWCKENL_FS = WCK2CK_Sync_FS_lookup[ratioIndex][i][FS_AC_TWCKENL_FS] + lowFreqBuffer;
				tWCKPRE_Toggle_WR = WCK2CK_Sync_WR_lookup[ratioIndex][i][WR_AC_TWCKEPRE_TOGGLE_WR];
				tWCKPRE_Toggle_FS = WCK2CK_Sync_WR_lookup[ratioIndex][i][WR_AC_TWCKEPRE_TOGGLE_WR];
				break;
			}
		}

		uint16_t wrSdly = (tWCKENL_WR * ratio) - 4;
		uint16_t wrSwd = tWCKPRE_static * ratio;
		uint16_t wrTGdly = ((tWCKENL_WR + tWCKPRE_static) * ratio) - 4;
		uint16_t wrTGwd = 1 * ratio;
		uint16_t wrFTGdly = ((tWCKENL_WR + tWCKPRE_static + 1) * ratio) - 4;
		uint16_t wrFTGwd = ((tWCKPRE_Toggle_WR - 1) * ratio) + (BLnmax * ratio) + tWCKPST;

		uint16_t rdSdly = (tWCKENL_RD * ratio) - 4;
		uint16_t rdSwd = tWCKPRE_static * ratio;
		uint16_t rdTGdly = ((tWCKENL_RD + tWCKPRE_static) * ratio) - 4;
		uint16_t rdTGwd = 1 * ratio;
		uint16_t rdFTGdly = ((tWCKENL_RD + tWCKPRE_static + 1) * ratio) - 4;
		uint16_t rdFTGwd = ((tWCKPRE_Toggle_RD - 1) * ratio) + (BLnmax * ratio) + tWCKPST;

		uint16_t fsSdly = (tWCKENL_FS * ratio) - 4;
		uint16_t fsSwd = tWCKPRE_static * ratio;
		uint16_t fsTGdly = ((tWCKENL_FS + tWCKPRE_static) * ratio) - 4;
		uint16_t fsTGwd = 1 * ratio;
		uint16_t fsFTGdly = ((tWCKENL_FS + tWCKPRE_static + 1) * ratio) - 4;
		uint16_t fsFTGwd = ((tWCKPRE_Toggle_FS - 1) * ratio) + BLdiv2 + tWCKPST;

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckWriteStaticLoPulse::ACSMWckWriteStaticLoWidth to 0x%x, ACSMWckWriteStaticLoPulse::ACSMWckWriteStaticLoDelay to 0x%x\n", pstate, freq, wrSwd, wrSdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckWriteStaticHiPulse::ACSMWckWriteStaticHiWidth to 0x%x, ACSMWckWriteStaticHiPulse::ACSMWckWriteStaticHiDelay to 0x%x\n", pstate, freq, wrSwd, wrSdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckWriteTogglePulse::ACSMWckWriteToggleWidth to 0x%x, ACSMWckWriteTogglePulse::ACSMWckWriteToggleDelay to 0x%x\n", pstate, freq, wrTGwd, wrTGdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckWriteFastTogglePulse::ACSMWckWriteFastToggleWidth to 0x%x, ACSMWckWriteFastTogglePulse::ACSMWckWriteFastToggleDelay to 0x%x\n", pstate, freq, wrFTGwd, wrFTGdly);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckWriteStaticLoPulse_ADDR), (wrSwd << csr_ACSMWckWriteStaticLoWidth_LSB) | (wrSdly << csr_ACSMWckWriteStaticLoDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckWriteStaticHiPulse_ADDR), (wrSwd << csr_ACSMWckWriteStaticHiWidth_LSB) | (wrSdly << csr_ACSMWckWriteStaticHiDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckWriteTogglePulse_ADDR), (wrTGwd << csr_ACSMWckWriteToggleWidth_LSB) | (wrTGdly << csr_ACSMWckWriteToggleDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckWriteFastTogglePulse_ADDR), (wrFTGwd << csr_ACSMWckWriteFastToggleWidth_LSB) | (wrFTGdly << csr_ACSMWckWriteFastToggleDelay_LSB));

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckReadStaticLoPulse::ACSMWckReadStaticLoWidth to 0x%x, ACSMWckReadStaticLoPulse::ACSMWckReadStaticLoDelay to 0x%x\n", pstate, freq, rdSwd, rdSdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckReadStaticHiPulse::ACSMWckReadStaticHiWidth to 0x%x, ACSMWckReadStaticHiPulse::ACSMWckReadStaticHiDelay to 0x%x\n", pstate, freq, rdSwd, rdSdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckReadTogglePulse::ACSMWckReadToggleWidth to 0x%x, ACSMWckReadTogglePulse::ACSMWckReadToggleDelay to 0x%x\n", pstate, freq, rdTGwd, rdTGdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckReadFastTogglePulse::ACSMWckReadFastToggleWidth to 0x%x, ACSMWckReadFastTogglePulse::ACSMWckReadFastToggleDelay to 0x%x\n", pstate, freq, rdFTGwd, rdFTGdly);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckReadStaticLoPulse_ADDR), (rdSwd << csr_ACSMWckReadStaticLoWidth_LSB) | (rdSdly << csr_ACSMWckReadStaticLoDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckReadStaticHiPulse_ADDR), (rdSwd << csr_ACSMWckReadStaticHiWidth_LSB) | (rdSdly << csr_ACSMWckReadStaticHiDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckReadTogglePulse_ADDR), (rdTGwd << csr_ACSMWckReadToggleWidth_LSB) | (rdTGdly << csr_ACSMWckReadToggleDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckReadFastTogglePulse_ADDR), (rdFTGwd << csr_ACSMWckReadFastToggleWidth_LSB) | (rdFTGdly << csr_ACSMWckReadFastToggleDelay_LSB));

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckFreqStaticLoPulse::ACSMWckFreqStaticLoWidth to 0x%x, ACSMWckFreqStaticLoPulse::ACSMWckFreqStaticLoDelay to 0x%x\n", pstate, freq, fsSwd, fsSdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckFreqStaticHiPulse::ACSMWckFreqStaticHiWidth to 0x%x, ACSMWckFreqStaticHiPulse::ACSMWckFreqStaticHiDelay to 0x%x\n", pstate, freq, fsSwd, fsSdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckFreqTogglePulse::ACSMWckFreqToggleWidth to 0x%x, ACSMWckFreqTogglePulse::ACSMWckFreqToggleDelay to 0x%x\n", pstate, freq, fsTGwd, fsTGdly);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWckFreqFastTogglePulse::ACSMWckFreqFastToggleWidth to 0x%x, ACSMWckFreqFastTogglePulse::ACSMWckFreqFastToggleDelay to 0x%x\n", pstate, freq, fsFTGwd, fsFTGdly);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckFreqSwStaticLoPulse_ADDR), (fsSwd << csr_ACSMWckFreqSwStaticLoWidth_LSB) | (fsSdly << csr_ACSMWckFreqSwStaticLoDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckFreqSwStaticHiPulse_ADDR), (fsSwd << csr_ACSMWckFreqSwStaticHiWidth_LSB) | (fsSdly << csr_ACSMWckFreqSwStaticHiDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckFreqSwTogglePulse_ADDR), (fsTGwd << csr_ACSMWckFreqSwToggleWidth_LSB) | (fsTGdly << csr_ACSMWckFreqSwToggleDelay_LSB));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWckFreqSwFastTogglePulse_ADDR), (fsFTGwd << csr_ACSMWckFreqSwFastToggleWidth_LSB) | (fsFTGdly << csr_ACSMWckFreqSwFastToggleDelay_LSB));

		/**
		 * - Program Rx pulse registers for ACSM
		 */
		uint16_t rxPulseDly = (ratio * readLatency) - 5;
		uint16_t rxPulseDlyDbi = (ratio * readLatencyDbi) - 5;	
		uint16_t rxPulseWd = BLdiv2;

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMRxEnPulse::ACSMRxEnDelay to 0x%x, ACSMRxEnPulse::ACSMRxEnWidth to 0x%x\n", pstate, freq, rxPulseDly, rxPulseWd);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMRxValPulse::ACSMRxValDelay to 0x%x, ACSMRxValPulse::ACSMRxValWidth to 0x%x\n", pstate, freq, rxPulseDly, rxPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMRxEnPulse_ADDR), ((rxPulseDly << csr_ACSMRxEnDelay_LSB) & csr_ACSMRxEnDelay_MASK) | ((rxPulseWd << csr_ACSMRxEnWidth_LSB) & csr_ACSMRxEnWidth_MASK));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMRxValPulse_ADDR), ((rxPulseDly << csr_ACSMRxValDelay_LSB) & csr_ACSMRxValDelay_MASK) | ((rxPulseWd << csr_ACSMRxValWidth_LSB) & csr_ACSMRxValWidth_MASK));

		if (pUserInputAdvanced->WDQSExt) {
			rxPulseDly -= 2;
			rxPulseDlyDbi -=2;
			rxPulseWd += 2;
		}

		mb1D[pstate].ALT_RL = rxPulseDlyDbi;
		mb1D[pstate].MAIN_RL = rxPulseDly;


		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMRdcsPulse::ACSMRdcsDelay to 0x%x, ACSMRdcsPulse::ACSMRdcsWidth to 0x%x\n", pstate, freq, rxPulseDly, rxPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMRdcsPulse_ADDR), ((rxPulseDly << csr_ACSMRdcsDelay_LSB) & csr_ACSMRdcsDelay_MASK) | ((rxPulseWd << csr_ACSMRdcsWidth_LSB) & csr_ACSMRdcsWidth_MASK));

		uint16_t txPulseDly = (ratio * writeLatency) - 5;
		uint16_t txPulseWd = BLdiv2;

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMTxEnPulse::ACSMTxEnDelay to 0x%x, ACSMTxEnPulse::ACSMTxEnWidth to 0x%x\n", pstate, freq, txPulseDly, txPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMTxEnPulse_ADDR), ((txPulseDly << csr_ACSMTxEnDelay_LSB) & csr_ACSMTxEnDelay_MASK) | ((txPulseWd << csr_ACSMTxEnWidth_LSB) & csr_ACSMTxEnWidth_MASK));

		/**
		 * - Program Tx pulse registers for ACSM
		 */
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWrcsPulse::ACSMWrcsDelay to 0x%x, ACSMWrcsPulse::ACSMWrcsWidth to 0x%x\n", pstate, freq, txPulseDly, txPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWrcsPulse_ADDR), ((txPulseDly << csr_ACSMWrcsDelay_LSB) & csr_ACSMWrcsDelay_MASK) | ((txPulseWd << csr_ACSMWrcsWidth_LSB) & csr_ACSMWrcsWidth_MASK));

		/**
		 * - Program AcPipeEn.
		 *   - Dependencies:
		 *     - user_input_basic.Frequency
		 *     - user_input_basic.DfiFreqRatio
		 *
		 */
		uint16_t AcPipeEn = ((pUserInputBasic->DfiFreqRatio[pstate] == 1) ? ((freq <= 267) ? 2 : ((freq <= 688) ? 1 : 0)) : ((freq <= 133) ? 1 : 0));

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming AcPipeEn to %d. DFI ratio is %d\n", pstate, freq, AcPipeEn, pUserInputBasic->DfiFreqRatio[pstate]);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_AcPipeEn_ADDR), AcPipeEn);


		
		 uint16_t PptWFIFOcmdDly;
		 uint16_t tWTRcycle;
		 uint16_t tWTRns;
		 uint16_t tck_ps = 1000000/pUserInputBasic->Frequency[pstate];

		 if (byteMode) {  // Byte mode
		     if ((dvfsc == 0) && (writeLinkEcc == 0)) {
		         tWTRns = (bankOrg == 0)?  8250 : 14000 ;  // tWTR_S =  8.25ns@BGmode, tWTR = 14ns@16B, 8B mode
			     } else if ((dvfsc == 0) && (writeLinkEcc == 1)) {
		         tWTRns = (bankOrg == 0)? 12250 : 18000 ;  // tWTR_S = 12.25ns@BGmode, tWTR = 18ns@16B, 8B mode
			     } else {
		         tWTRns = 21000 ;  // tWTR = 21ns@16B, 8B mode
			     }
		  } else {   // x16 mode
		     if ((dvfsc == 0) && (writeLinkEcc == 0)) {
		         tWTRns = (bankOrg == 0)?  6250 : 12000 ;  // tWTR_S =  6.25ns@BGmode, tWTR = 12ns@16B, 8B mode
			     } else if ((dvfsc == 0) && (writeLinkEcc == 1)) {
		         tWTRns = (bankOrg == 0)? 10250 : 16000 ;  // tWTR_S = 10.25ns@BGmode, tWTR = 16ns@16B, 8B mode
			     } else {
		         tWTRns = 19000 ;  // tWTR = 19ns@16B, 8B mode
			     }
		     }

		tWTRcycle = (tWTRns % tck_ps)?  tWTRns/tck_ps + 1 : tWTRns/tck_ps;

		// DfiFreqRatio = b01 : 1:2 DFI Frequency Ratio (default), b10 : 1:4 Ratio
		PptWFIFOcmdDly = (pUserInputBasic->DfiFreqRatio[pstate] == 1) ? writeLatency + 8 + tWTRcycle - 1 : writeLatency + 4 + tWTRcycle - 1 ;  
                // WFF-CAS(WS_off) delay = WL + BL/n_max + RU(tWTR_S/tCK) - 1  [TO DO: Apply new JEDEC spec when approved]
                // 6400Mbps : WL(9)+BL(16)/4+RU(tWTR(12.25ns)/tCK) - 1 = 22tCK 
		// 4267Mbps : WL(6)+BL(16)/4+RU(tWTR(12.25ns)/tCK) - 1 = 16tCK 
		// 3733Mbps : WL(6)+BL(16)/4+RU(tWTR(12.25ns)/tCK) - 1 = 15tCK 
		// 3200Mbps : WL(5)+BL(16)/4+RU(tWTR(8.25ns)/tCK)  - 1 = 12tCK 
		
		uint16_t PptRFIFOcmdDly;
							  
		uint8_t  tHWTMRL = 16;  // Max HWTMRL @6400Mbps
                uint8_t  tHWTMRL_freq ; // Scaled HWTMRL for lower frequency

                tHWTMRL_freq = ( (tHWTMRL * 1250) % tck_ps)?  tHWTMRL * 1250/tck_ps + 1 : tHWTMRL * 1250/tck_ps ;

		PptRFIFOcmdDly = (pUserInputBasic->DfiFreqRatio[pstate] == 1)? readLatency + 8 + tHWTMRL_freq + 2 : readLatency + 4 + tHWTMRL_freq + 2 ;  
                // RFF-CAS(WS_off) delay = RL + BL/n_max + tHWTMRL(scaled based on 16@6400Mbps) + 2 (margin)

		uint8_t WL_pstate_ckr2[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0 };
		uint8_t WL_pstate_ckr4[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0 };

		for (int j = 0; j < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE ; ++j) {
			ratioIndex = (pUserInputBasic->DfiFreqRatio[j] == 1)? 0 : 1;
			numSpeeds = ratioIndex ? 12 : 6;
			WR_AC_WL = ((mb1D[j].MR3_A0 >> 5) & 0x1)?  WR_AC_WL_SETB : WR_AC_WL_SETA ;

			// CKR 2:1
			if ( ((mb1D[j].MR18_A0 >> 7) & 0x1) == 1) {
				for (int i = 0; i < numSpeeds; ++i) {
					if ( (pUserInputBasic->Frequency[j]) > WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_LOWER] && (pUserInputBasic->Frequency[j]) <= WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_UPPER]) {
						WL_pstate_ckr2[j] = WCK2CK_Sync_WR_lookup[ratioIndex][i][WR_AC_WL];
						WL_pstate_ckr2[j] *= ((pUserInputBasic->CfgPStates >> j) & 0x1);
						break;
					}
				}
			}
			// CKR 4:1
			else { 
				for (int i = 0; i < numSpeeds; ++i) {
					if ( ( pUserInputBasic->Frequency[j]) > WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_LOWER] && (pUserInputBasic->Frequency[j]) <= WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_UPPER]) {
						WL_pstate_ckr4[j] = WCK2CK_Sync_WR_lookup[ratioIndex][i][WR_AC_WL];
						WL_pstate_ckr4[j] *= ((pUserInputBasic->CfgPStates >> j) & 0x1);
						break;
					}
				}
			}
		}

		uint8_t WL_pstate_ckr2_max = 0 ;

		for (int j = 0; j < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; ++j) {
			if (WL_pstate_ckr2[j] > WL_pstate_ckr2_max) {
				WL_pstate_ckr2_max = WL_pstate_ckr2[j] ;
			}
		}
		dwc_ddrphy_phyinit_cmnt ("[phyinit_C_initPhyConfigPsLoop] WL(max, CKR2) = %d \n", WL_pstate_ckr2_max);

		uint8_t WL_pstate_ckr4_max = 0 ;

		for (int j = 0; j < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; ++j) {
			if (WL_pstate_ckr4[j] > WL_pstate_ckr4_max) {
				WL_pstate_ckr4_max = WL_pstate_ckr4[j] ;
			}
		}
		dwc_ddrphy_phyinit_cmnt ("[phyinit_C_initPhyConfigPsLoop] WL(max, CKR4) = %d \n", WL_pstate_ckr4_max);

		uint8_t WL_pstate_cur = WCK2CK_Sync_WR_lookup[ratioIndex][0][WR_AC_WL];
		ratioIndex = (pUserInputBasic->DfiFreqRatio[pstate] == 1)? 0 : 1;
		numSpeeds = ratioIndex ? 12 : 6;
		WR_AC_WL = ((mb1D[pstate].MR3_A0 >> 5) & 0x1)?  WR_AC_WL_SETB : WR_AC_WL_SETA ;

		for (int i = 0; i < numSpeeds; ++i) {
			if ((pUserInputBasic->Frequency[pstate]) > WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_LOWER] && (pUserInputBasic->Frequency[pstate]) <= WCK2CK_Sync_WR_lookup[ratioIndex][i][RD_AC_FREQ_UPPER]) {
				WL_pstate_cur = WCK2CK_Sync_WR_lookup[ratioIndex][i][WR_AC_WL];
				break;
			}
		}

		if ((WL_pstate_cur == WL_pstate_ckr2_max) && ((mb1D[pstate].MR18_A0 >> 7) & 0x1) ) {
			// WCK:CK 2:1
			phyctx->AcsmMrkrCnt[0]  = ((PptWFIFOcmdDly)/2)-1; // TxDq/RxClk tg0 WFF
			phyctx->AcsmMrkrCnt[1]  = ((PptRFIFOcmdDly)/2)-1; // TxDq/RxClk tg0 RFF  
			phyctx->AcsmMrkrCnt[2]  = ((PptWFIFOcmdDly)/2)-1; // TxDq/RxClk tg1 WFF  
			phyctx->AcsmMrkrCnt[3]  = ((PptRFIFOcmdDly)/2)-1; // TxDq/RxClk tg1 RFF  
			phyctx->AcsmMrkrCnt[4]  = ((PptWFIFOcmdDly)/2)-1; // Rdqst tg0 WFF
			phyctx->AcsmMrkrCnt[5]  = ((PptRFIFOcmdDly)/2)-1; // Rdqst tg0 RFF
			phyctx->AcsmMrkrCnt[6]  = ((PptWFIFOcmdDly)/2)-1; // Rdqst tg1 WFF
			phyctx->AcsmMrkrCnt[7]  = ((PptRFIFOcmdDly)/2)-1; // Rdqst tg1 RFF
			dwc_ddrphy_phyinit_cmnt ("[phyinit_C_initPhyConfigPsLoop] Pstate=%d, For CKR2:1, PptWFIFOcmdDly=%d, PptRFIFOcmdDly=%d, (WL=%d, tWTRns=%d, tWTRcycle=%d, RL=%d, tHWTMRL_freq=%d) \n",
				pstate, PptWFIFOcmdDly, PptRFIFOcmdDly, writeLatency, tWTRns, tWTRcycle, readLatency, tHWTMRL_freq);
		}
		if ((WL_pstate_cur == WL_pstate_ckr4_max) && !((mb1D[pstate].MR18_A0 >> 7) & 0x1) ) {
			// WCK:CK 4:1
			phyctx->AcsmMrkrCnt[8]  = ((PptWFIFOcmdDly)/2)-1; // TxDq/RxClk tg0 WFF
			phyctx->AcsmMrkrCnt[9]  = ((PptRFIFOcmdDly)/2)-1; // TxDq/RxClk tg0 RFF
			phyctx->AcsmMrkrCnt[10] = ((PptWFIFOcmdDly)/2)-1; // TxDq/RxClk tg1 WFF
			phyctx->AcsmMrkrCnt[11] = ((PptRFIFOcmdDly)/2)-1; // TxDq/RxClk tg1 RFF
			phyctx->AcsmMrkrCnt[12] = ((PptWFIFOcmdDly)/2)-1; // Rdqst tg0 WFF
			phyctx->AcsmMrkrCnt[13] = ((PptRFIFOcmdDly)/2)-1; // Rdqst tg0 RFF
			phyctx->AcsmMrkrCnt[14] = ((PptWFIFOcmdDly)/2)-1; // Rdqst tg1 WFF
			phyctx->AcsmMrkrCnt[15] = ((PptRFIFOcmdDly)/2)-1; // Rdqst tg1 RFF
			dwc_ddrphy_phyinit_cmnt ("[phyinit_C_initPhyConfigPsLoop] Pstate=%d, For CKR4:1, PptWFIFOcmdDly=%d, PptRFIFOcmdDly=%d, (WL=%d, tWTRns=%d, tWTRcycle=%d, RL=%d, tHWTMRL_freq=%d) \n",
				pstate, PptWFIFOcmdDly, PptRFIFOcmdDly, writeLatency, tWTRns, tWTRcycle, readLatency, tHWTMRL_freq);
		}

	
	) // LPDDR5

	_IF_LPDDR4(
		uint8_t byteMode = (pUserInputBasic->DramDataWidth == 8) ? 1 : 0;
		uint8_t rdDbi = ((mb1D[pstate].MR3_A0 >> 6) & 1);
		uint8_t rl_mr = ((mb1D[pstate].MR2_A0) & 0x7);
		uint8_t wl_mr = ((mb1D[pstate].MR2_A0 >> 3) & 0x7);
		uint8_t wls = ((mb1D[pstate].MR2_A0 >> 6) & 1);
		uint16_t BLdiv2 = 8;
		uint16_t readLatency = 6;
		uint16_t writeLatency = 4;
		uint16_t cmd2cas = 3;
		uint16_t DfiClk = freq / ratio;
		uint8_t readLatencyNoDbi;

		if (byteMode) {
			if (rdDbi) {
				switch (rl_mr) {
				case 0:
					readLatency = 6;
					break;
				case 1:
					readLatency = 12;
					break;
				case 2:
					readLatency = 18;
					break;
				case 3:
					readLatency = 24;
					break;
				case 4:
					readLatency = 30;
					break;
				case 5:
					readLatency = 36;
					break;
				case 6:
					readLatency = 40;
					break;
				case 7:
					readLatency = 44;
					break;
				default:
					dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid read latency of %d, X8MODE = %d, DBI-RD = %d\n", rl_mr, byteMode, rdDbi);
					break;
				}
			} else {
				switch (rl_mr) {
				case 0:
					readLatency = 6;
					break;
				case 1:
					readLatency = 10;
					break;
				case 2:
					readLatency = 16;
					break;
				case 3:
					readLatency = 22;
					break;
				case 4:
					readLatency = 26;
					break;
				case 5:
					readLatency = 32;
					break;
				case 6:
					readLatency = 36;
					break;
				case 7:
					readLatency = 40;
					break;
				default:
					dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid read latency of %d, X8MODE = %d, DBI-RD = %d\n", rl_mr, byteMode, rdDbi);
					break;
				}
			}
			switch (rl_mr) {
			case 0:
				readLatencyNoDbi = 6;
				break;
			case 1:
				readLatencyNoDbi = 10;
				break;
			case 2:
				readLatencyNoDbi = 16;
				break;
			case 3:
				readLatencyNoDbi = 22;
				break;
			case 4:
				readLatencyNoDbi = 26;
				break;
			case 5:
				readLatencyNoDbi = 32;
				break;
			case 6:
				readLatencyNoDbi = 36;
				break;
			case 7:
				readLatencyNoDbi = 40;
				break;
			default:
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid read latency of %d, X8MODE = %d, DBI-RD = %d\n", rl_mr, byteMode, rdDbi);
				break;
			}
		} else {
			if (rdDbi) {
				switch (rl_mr) {
				case 0:
					readLatency = 6;
					break;
				case 1:
					readLatency = 12;
					break;
				case 2:
					readLatency = 16;
					break;
				case 3:
					readLatency = 22;
					break;
				case 4:
					readLatency = 28;
					break;
				case 5:
					readLatency = 32;
					break;
				case 6:
					readLatency = 36;
					break;
				case 7:
					readLatency = 40;
					break;
				default:
					dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid read latency of %d, X8MODE = %d, DBI-RD = %d\n", rl_mr, byteMode, rdDbi);
					break;
				}
			} else {
				switch (rl_mr) {
				case 0:
					readLatency = 6;
					break;
				case 1:
					readLatency = 10;
					break;
				case 2:
					readLatency = 14;
					break;
				case 3:
					readLatency = 20;
					break;
				case 4:
					readLatency = 24;
					break;
				case 5:
					readLatency = 28;
					break;
				case 6:
					readLatency = 32;
					break;
				case 7:
					readLatency = 36;
					break;
				default:
					dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid read latency of %d, X8MODE = %d, DBI-RD = %d\n", rl_mr, byteMode, rdDbi);
					break;
				}
			}
			switch (rl_mr) {
			case 0:
				readLatencyNoDbi = 6;
				break;
			case 1:
				readLatencyNoDbi = 10;
				break;
			case 2:
				readLatencyNoDbi = 14;
				break;
			case 3:
				readLatencyNoDbi = 20;
				break;
			case 4:
				readLatencyNoDbi = 24;
				break;
			case 5:
				readLatencyNoDbi = 28;
				break;
			case 6:
				readLatencyNoDbi = 32;
				break;
			case 7:
				readLatencyNoDbi = 36;
				break;
			default:
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid read latency of %d, X8MODE = %d, DBI-RD = %d\n", rl_mr, byteMode, rdDbi);
				break;
			}
		}
		if (wls) {
			switch (wl_mr) {
			case 0:
				writeLatency = 4;
				break;
			case 1:
				writeLatency = 8;
				break;
			case 2:
				writeLatency = 12;
				break;
			case 3:
				writeLatency = 18;
				break;
			case 4:
				writeLatency = 22;
				break;
			case 5:
				writeLatency = 26;
				break;
			case 6:
				writeLatency = 30;
				break;
			case 7:
				writeLatency = 34;
				break;
			default:
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid write latency of %d, X8MODE = %d, WLS = %d\n", wl_mr, byteMode, wls);
				break;
			}
		} else {
			switch (wl_mr) {
			case 0:
				writeLatency = 4;
				break;
			case 1:
				writeLatency = 6;
				break;
			case 2:
				writeLatency = 8;
				break;
			case 3:
				writeLatency = 10;
				break;
			case 4:
				writeLatency = 12;
				break;
			case 5:
				writeLatency = 14;
				break;
			case 6:
				writeLatency = 16;
				break;
			case 7:
				writeLatency = 18;
				break;
			default:
				dwc_ddrphy_phyinit_assert(0, " [phyinit_C_initPhyConfigPsLoop] invalid write latency of %d, X8MODE = %d, WLS = %d\n", wl_mr, byteMode, wls);
				break;
			}
		}

		uint16_t PptWFIFOcmdDly;
		uint16_t tWTRcycle;
		uint16_t tWTRns;
		uint16_t tck_ps = 1000000/pUserInputBasic->Frequency[pstate];
 
		tWTRns      = (byteMode)? 12000 : 10000 ;
		tWTRcycle   = (tWTRns % tck_ps)?  tWTRns/tck_ps + 1 : tWTRns/tck_ps;

                PptWFIFOcmdDly = ((writeLatency + 8 + tWTRcycle + 2) > 23)? writeLatency + 8 + tWTRcycle + 2 : 24 ; // WL + BL/2 + 1 + RU(tWTR/tCK) +1 (margin for rounding error)

		uint16_t PptRFIFOcmdDly;
		uint16_t DRAM_RL;
		uint8_t  tHWTMRL = 16; // Max HWTMRL.

		DRAM_RL = (rdDbi)? readLatencyNoDbi : readLatency ;
		PptRFIFOcmdDly =  DRAM_RL + 8 + tHWTMRL + 8 ; 

		uint8_t WL_pstate[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0 };
		uint16_t tWTRcycle_pstate[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE] = { 0x0 };
		uint16_t tWTRns_pstate;
		uint16_t tck_ps_pstate;

		for (int j = 0; j < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; ++j) {
			// WL(setA)
			if (((mb1D[j].MR2_A0 >> 6) & 0x1) == 0) {
				WL_pstate[j] = (((mb1D[j].MR2_A0 >> 3) & 0x7) == 0)?  4 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 1)?  6 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 2)?  8 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 3)? 10 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 4)? 12 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 5)? 14 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 6)? 16 : 18 ;
				WL_pstate[j] *= ((pUserInputBasic->CfgPStates >> j) & 0x1);
			}
			// WL(setB)
			else {
				WL_pstate[j] = (((mb1D[j].MR2_A0 >> 3) & 0x7) == 0)?  4 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 1)?  8 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 2)? 12 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 3)? 18 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 4)? 22 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 5)? 26 :
					       (((mb1D[j].MR2_A0 >> 3) & 0x7) == 6)? 30 : 34 ;
				WL_pstate[j] *= ((pUserInputBasic->CfgPStates >> j) & 0x1);
			}
			tck_ps_pstate       = 1000000/pUserInputBasic->Frequency[j];
			tWTRns_pstate       = (byteMode)? 12000 : 10000 ;
			tWTRcycle_pstate[j] = (tWTRns_pstate % tck_ps_pstate)?  tWTRns_pstate/tck_ps_pstate + 1 : tWTRns_pstate/tck_ps_pstate;
                        tWTRcycle_pstate[j] *= ((pUserInputBasic->CfgPStates >> j) & 0x1);
		}

		uint8_t WL_pstate_max = 0 ;
		uint8_t tWTRcycle_pstate_max = 0 ;
		uint8_t WL_tWTRcycle_pstate_max = 0 ;

		for (int j = 0; j < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; ++j) {
			if ( (WL_pstate[j] + tWTRcycle_pstate[j] ) > WL_tWTRcycle_pstate_max) {
				WL_tWTRcycle_pstate_max = WL_pstate[j] + tWTRcycle_pstate[j] ;
				WL_pstate_max           = WL_pstate[j] ;
				tWTRcycle_pstate_max    = tWTRcycle_pstate[j] ;
			}
		}
		dwc_ddrphy_phyinit_cmnt ("[phyinit_C_initPhyConfigPsLoop] WL(max)=%d, tWTRcycle(max) =%d \n", WL_pstate_max, tWTRcycle_pstate_max);

		uint8_t WL_pstate_cur ;
		if (((mb1D[pstate].MR2_A0 >> 6) & 0x1) == 0) {
			WL_pstate_cur = (((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 0)?  4 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 1)?  6 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 2)?  8 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 3)? 10 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 4)? 12 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 5)? 14 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 6)? 16 : 18 ;
		}
		// WL(setB)
		else {
			WL_pstate_cur = (((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 0)?  4 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 1)?  8 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 2)? 12 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 3)? 18 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 4)? 22 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 5)? 26 :
				(((mb1D[pstate].MR2_A0 >> 3) & 0x7) == 6)? 30 : 34 ;
		}

		if ((WL_pstate_cur + tWTRcycle) == WL_tWTRcycle_pstate_max) {
			phyctx->AcsmMrkrCnt[0]  = PptWFIFOcmdDly/8-1; // TxDq tg0 WFF
			phyctx->AcsmMrkrCnt[1]  = PptRFIFOcmdDly/8-1; // TxDq tg0 RFF  
			phyctx->AcsmMrkrCnt[2]  = PptWFIFOcmdDly/8-1; // TxDq tg1 WFF  
			phyctx->AcsmMrkrCnt[3]  = PptRFIFOcmdDly/8-1; // TxDq tg1 RFF  

			dwc_ddrphy_phyinit_cmnt ("[phyinit_C_initPhyConfigPsLoop] Pstate=%d, PptWFIFOcmdDly=%d, PptRFIFOcmdDly=%d, (WL=%d, tWTRcycle=%d, RL=%d) \n", pstate, PptWFIFOcmdDly, PptRFIFOcmdDly, writeLatency, tWTRcycle, DRAM_RL);
		}

		uint16_t rxPulseDly;
		uint16_t rxPulseWd = BLdiv2;

		rxPulseDly = readLatency + cmd2cas - 5;
		mb1D[pstate].ALT_RL = readLatencyNoDbi + cmd2cas - 5;
		mb1D[pstate].MAIN_RL = rxPulseDly;
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMRxEnPulse::ACSMRxEnDelay to 0x%x, ACSMRxEnPulse::ACSMRxEnWidth to 0x%x\n", pstate, freq, rxPulseDly, rxPulseWd);
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMRxValPulse::ACSMRxValDelay to 0x%x, ACSMRxValPulse::ACSMRxValWidth to 0x%x\n", pstate, freq, rxPulseDly, rxPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMRxEnPulse_ADDR), ((rxPulseDly << csr_ACSMRxEnDelay_LSB) & csr_ACSMRxEnDelay_MASK) | ((rxPulseWd << csr_ACSMRxEnWidth_LSB) & csr_ACSMRxEnWidth_MASK));
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMRxValPulse_ADDR), ((rxPulseDly << csr_ACSMRxValDelay_LSB) & csr_ACSMRxValDelay_MASK) | ((rxPulseWd << csr_ACSMRxValWidth_LSB) & csr_ACSMRxValWidth_MASK));

		if (pUserInputAdvanced->WDQSExt) {
			rxPulseDly -= 2;
			rxPulseWd += 2;
		}

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMRdcsPulse::ACSMRdcsDelay to 0x%x, ACSMRdcsPulse::ACSMRdcsWidth to 0x%x\n", pstate, freq, rxPulseDly, rxPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMRdcsPulse_ADDR), ((rxPulseDly << csr_ACSMRdcsDelay_LSB) & csr_ACSMRdcsDelay_MASK) | ((rxPulseWd << csr_ACSMRdcsWidth_LSB) & csr_ACSMRdcsWidth_MASK));

		uint16_t txPulseDly;

		if (DfiClk > 800) {
			txPulseDly = (writeLatency + 1) + cmd2cas - 7;
		} else {
			txPulseDly = (writeLatency + 1) + cmd2cas - 5;
		}

		uint16_t txPulseWd = BLdiv2;

		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMTxEnPulse::ACSMTxEnDelay to 0x%x, ACSMTxEnPulse::ACSMTxEnWidth to 0x%x\n", pstate, freq, txPulseDly, txPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMTxEnPulse_ADDR), ((txPulseDly << csr_ACSMTxEnDelay_LSB) & csr_ACSMTxEnDelay_MASK) | ((txPulseWd << csr_ACSMTxEnWidth_LSB) & csr_ACSMTxEnWidth_MASK));

		/**
		 * - Program Tx pulse registers for ACSM
		 */
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming ACSMWrcsPulse::ACSMWrcsDelay to 0x%x, ACSMWrcsPulse::ACSMWrcsWidth to 0x%x\n", pstate, freq, txPulseDly, txPulseWd);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_ACSMWrcsPulse_ADDR), ((txPulseDly << csr_ACSMWrcsDelay_LSB) & csr_ACSMWrcsDelay_MASK) | ((txPulseWd << csr_ACSMWrcsWidth_LSB) & csr_ACSMWrcsWidth_MASK));
	)

		/**
		 * - Program InhibitTxRdPtrInit based on Frequency and SkipFlashCopy
		 *   - Dependencies:
		 *     - user_input_basic.Frequency
		 *     - user_input_advanced.SkipFlashCopy
		 */

		uint16_t DisableRxEnDlyLoad;
		uint16_t DisableTxDqDly;

		DisableRxEnDlyLoad = (pUserInputAdvanced->SkipFlashCopy[pstate]==1) ? ((freq<freqThreshold) ? 0 : 1) : 0;
		DisableTxDqDly     = (pUserInputAdvanced->SkipFlashCopy[pstate]==1) ? ((freq<freqThreshold) ? 0 : 1) : 0;

		regData = ((DisableRxEnDlyLoad << csr_DisableRxEnDlyLoad_LSB) | (DisableTxDqDly << csr_DisableTxDqDly_LSB));
		dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, SkipFlashCopy[%d]=%d, Programming InhibitTxRdPtrInit to 0x%x\n", pstate, freq, pstate, pUserInputAdvanced->SkipFlashCopy[pstate], regData);
		dwc_ddrphy_phyinit_io_write16((p_addr | c0 | tMASTER | csr_InhibitTxRdPtrInit_ADDR), regData);

	_IF_LPDDR5(
		/**
		 * - Program TxDcaMode (initialize per pstate)
		 *
		 */
		for (byte = 0; byte < NumDbyte; byte++) {
			c_addr = c1 * byte;
			dwc_ddrphy_phyinit_io_write16((p_addr | c_addr | tDBYTE | csr_TxDcaMode_ADDR), 0);
		}
	)

	/*
	 * - Program UcclkHclkEnables (PMU and HWT clocks)
	 *   - Dependencies:
	 *     - user_input_advanced.PmuClockDiv
	 */
	uint16_t pmuClkEnables = csr_HclkEn_MASK | csr_UcclkEn_MASK;

	if (pUserInputAdvanced->PmuClockDiv[pstate] == 0) {
		pmuClkEnables |= (uint16_t) csr_UcclkFull_MASK;
	}

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] Pstate=%d, Memclk=%dMHz, Programming UcclkHclkEnables to 0x%x\n", pstate, freq, pmuClkEnables);
	dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | csr_UcclkHclkEnables_ADDR), pmuClkEnables);

	dwc_ddrphy_phyinit_cmnt(" [phyinit_C_initPhyConfigPsLoop] End of %s()\n", __func__);

} // End of dwc_ddrphy_phyinit_C_initPhyConfigPsLoop()


/** \brief Program the Tx drive strength settings for SE IO and DIFF IO
 *
 * \param phyctx               Data structure to hold user-defined parameters
 * \param SliceName            indicate which IO to be programmed: DQ/DQS/WCK/AC/CK/CS
 * \param higherVOHLp4         Higher VOH is selected or not by mr3 in LP4, 0 for lower VOH value, 1 for higher VOH; not applicable in LP5 
 * \param print_header         String used for logging
 *
 * \return int 
 */
int dwc_ddrphy_phyinit_programTxStren(phyinit_config_t *phyctx, SliceName_t SliceName, int higherVOHLp4, const char* print_header)
{

	_IF_LPDDR4(
		user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	)
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;

	uint8_t pstate = pRuntimeConfig->curPState;
	const char* h = print_header;
	int TxStrenCode = 0;
	int TxImpedance = 0;
	int TxImpedance_temp = 0;
	if (SliceName == DQ) {
		TxImpedance = pUserInputAdvanced->TxImpedanceDq[pstate];
	} else if (SliceName == DQS) {
		TxImpedance = pUserInputAdvanced->TxImpedanceDqs[pstate];
	} else if (SliceName == AC) {
		TxImpedance = pUserInputAdvanced->TxImpedanceAc[pstate];
	} else if (SliceName == CK) {
		TxImpedance = pUserInputAdvanced->TxImpedanceCk[pstate];
	} else {
		_IF_LPDDR4(
			if (SliceName == CS) {
				TxImpedance = pUserInputAdvanced->TxImpedanceCs[pstate];
			}
		)
		_IF_LPDDR5(
			if (SliceName == WCK) {
				TxImpedance = pUserInputAdvanced->TxImpedanceWCK[pstate];
			}
		)
	}

	TxImpedance_temp = TxImpedance;

	_IF_LPDDR5(
		switch (TxImpedance_temp) {
		case 120:
			TxStrenCode = 0x8;
			break;
		case 60:
			TxStrenCode = 0xc;
			break;
		case 40:
			TxStrenCode = 0xe;
			break;
		case 30:
			TxStrenCode = 0xf;
			break;
		default:
			if (SliceName == DQ) {
				dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceDq[%d]=%d\n", h, pstate, TxImpedance);
			} else if (SliceName == DQS) {
				dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceDqs[%d]=%d\n", h, pstate, TxImpedance);
			} else if (SliceName == WCK) {
				dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceWCK[%d]=%d\n", h, pstate, TxImpedance);
			} else if (SliceName == AC) {
				dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceAc[%d]=%d\n", h, pstate, TxImpedance);
			} else if (SliceName == CK) {
				dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceCk[%d]=%d\n", h, pstate, TxImpedance);
			} else {
				dwc_ddrphy_phyinit_assert(0, " %s  Invalid slice name for LP5\n", h);
			}
			break;
		}
	)
	_IF_LPDDR4(
		if (pUserInputBasic->Lp4xMode == 0 && higherVOHLp4 == 1) { 
			TxImpedance_temp = TxImpedance / 2;
		}
		if ((pUserInputBasic->Lp4xMode == 1) && (higherVOHLp4 == 1)) { 
			switch (TxImpedance_temp) {
			case 120:
				TxStrenCode = 0x8;
				break;
			case 60:
				TxStrenCode = 0xc;
				break;
			default:
				if (SliceName == DQ) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceDq[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == DQS) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceDqs[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == AC) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceAc[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == CK) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceCk[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == CS) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceCs[%d]=%d\n", h, pstate, TxImpedance);
				} else {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid slice name for LP4\n", h);
				}
				break;
			}
		} else {
			switch (TxImpedance_temp) {
			case 120:
				TxStrenCode = 0x8;
				break;
			case 60:
				TxStrenCode = 0xc;
				break;
			case 40:
				TxStrenCode = 0xe;
				break;
			case 30:
				TxStrenCode = 0xf;
				break;
			default:
				if (SliceName == DQ) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceDq[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == DQS) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceDqs[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == AC) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceAc[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == CK) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceCk[%d]=%d\n", h, pstate, TxImpedance);
				} else if (SliceName == CS) {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid pUserInputAdvanced->TxImpedanceCs[%d]=%d\n", h, pstate, TxImpedance);
				} else {
					dwc_ddrphy_phyinit_assert(0, " %s  Invalid slice name for LP4\n", h);
				}
				break;
	        	} 

		}
	)
        return TxStrenCode;

}

/** \brief Program the PLL settings according to the selected mode setting
 *
 * This function programs PLL control registers PllCtrl5 and PllCtrl6.
 *
 * \param phyctx       Data structure to hold user-defined parameters
 * \param mode         Selected configuration mode, 0 for step C, 1 for step I
 * \param print_header String used for logging
 *
 * \return void
 */
void dwc_ddrphy_phyinit_programPLL(phyinit_config_t *phyctx, int mode, const char* print_header)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;

	uint8_t pstate = pRuntimeConfig->curPState;
	uint32_t p_addr = pUserInputBasic->NumPStates < 3 ? pstate << 20 : p0;
	uint16_t freq = pUserInputBasic->Frequency[pstate];
	const char* h = print_header;

	// PLL normal operation modes, with x4 or x8 ratio settings
	// Note: lookup frequency table(s) below use PllRefClk frequency x 4

	uint16_t pll_x4_mode = 0x0;

#ifdef _BUILD_LPDDR4
	// PLL reference input clock freq: 178.8, 212.0, 260.5, 312.5, 357.6, 424.0, 521.0, 625.0, 715.2, 848.0, 1042.0, 1067.0, 1250.0
	uint16_t pllInMax_normal_x4[] = { 715, 848, 1042, 1250, 1430, 1696, 2084, 2500, 2861, 3392, 4168, 4268, 5000 };
	uint16_t pllDivSel_normal_x4[] = { 0x162, 0x162, 0x162, 0x166, 0x296, 0x296, 0x296, 0x29a, 0x3ca, 0x3ca, 0x3ca, 0x3ce, 0x3ce };
	uint16_t pllV2IMode_normal_x4[] = { 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2 };
	uint16_t pllVCOFreq_normal_x4[] = { 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x0 };
	unsigned int freq_list_len_normal_x4 = 13;

	// PLL reference input clock freq: 178.8, 212.0, 260.5, 312.5, 357.6, 424.0, 521.0, 625.0, 715.2, 848.0, 1042.0, 1067.0, 1250.0
	uint16_t pllInMax_fast_relock_x4[] = { 715, 848, 1042, 1250, 1430, 1696, 2084, 2500, 2861, 3392, 4168, 4268, 5000 };
	uint16_t pllDivSel_fast_relock_x4[] = { 0x22, 0x22, 0x22, 0x26, 0x16, 0x16, 0x16, 0x1a, 0xa, 0xa, 0xa, 0xe, 0xe };
	uint16_t pllV2IMode_fast_relock_x4[] = { 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2 };
	uint16_t pllVCOFreq_fast_relock_x4[] = { 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x0 };
	unsigned int freq_list_len_fast_relock_x4 = 13;
#endif

	// PLL reference input clock freq: 89.4, 106.0, 130.25, 156.25, 178.8, 212.0, 260.5, 312.5, 357.6, 424.0, 521.0, 625.0, 675.0, 822.5
	uint16_t pllInMax_normal_x8[] = { 358, 424, 521, 625, 715, 848, 1042, 1250, 1430, 1696, 2084, 2500, 2700, 3290 };
	uint16_t pllDivSel_normal_x8[] = { 0x23, 0x23, 0x23, 0x27, 0x157, 0x157, 0x157, 0x15b, 0x28b, 0x28b, 0x28b, 0x28f, 0x28f, 0x28f };
	uint16_t pllV2IMode_normal_x8[] = { 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x3, 0x3 };
	uint16_t pllVCOFreq_normal_x8[] = { 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x2, 0x1 };
	unsigned int freq_list_len_normal_x8 = 14;

	// PLL reference input clock freq: 89.4, 106.0, 130.25, 156.25, 178.8, 212.0, 260.5, 312.5, 357.6, 424.0, 521.0, 625.0, 675.0, 822.5
	uint16_t pllInMax_fast_relock_x8[] = { 358, 424, 521, 625, 715, 848, 1042, 1250, 1430, 1696, 2084, 2500, 2700, 3290 };
	uint16_t pllDivSel_fast_relock_x8[] = { 0x23, 0x23, 0x23, 0x27, 0x17, 0x17, 0x17, 0x1b, 0xb, 0xb, 0xb, 0xf, 0xf, 0xf };
	uint16_t pllV2IMode_fast_relock_x8[] = { 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x3, 0x3 };
	uint16_t pllVCOFreq_fast_relock_x8[] = { 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x3, 0x2, 0x1, 0x0, 0x2, 0x1 };
	unsigned int freq_list_len_fast_relock_x8 = 14;

	int lookupFreq; // The frequency table above uses PllRefClk frequency x 4

	uint16_t *pFreqList = pllInMax_normal_x8;
	uint16_t *pPllDivSel = pllDivSel_normal_x8;
	uint16_t *pPllV2IMode = pllV2IMode_normal_x8;
	uint16_t *pPllVcoLowFreq = pllVCOFreq_normal_x8;
	unsigned int freq_list_len = freq_list_len_normal_x8;

	if (mode == 1) {
		pFreqList = pllInMax_fast_relock_x8;
		pPllDivSel = pllDivSel_fast_relock_x8;
		pPllV2IMode = pllV2IMode_fast_relock_x8;
		pPllVcoLowFreq = pllVCOFreq_fast_relock_x8;
		freq_list_len = freq_list_len_fast_relock_x8;
	}

	_IF_LPDDR4(
		switch (1 << pUserInputBasic->DfiFreqRatio[pstate]) {
		case 2: // DFI freq ratio 1:2
			if ((freq >= 1600) && mode == 0) { // use PLL x4 mode for higher freq
				pll_x4_mode = 0x1;
				pFreqList = pllInMax_normal_x4;
				pPllDivSel = pllDivSel_normal_x4;
				pPllV2IMode = pllV2IMode_normal_x4;
				pPllVcoLowFreq = pllVCOFreq_normal_x4;
				freq_list_len = freq_list_len_normal_x4;
			} else if ((freq >= 1600) && mode == 1) {
				pll_x4_mode = 0x1;
				pFreqList = pllInMax_fast_relock_x4;
				pPllDivSel = pllDivSel_fast_relock_x4;
				pPllV2IMode = pllV2IMode_fast_relock_x4;
				pPllVcoLowFreq = pllVCOFreq_fast_relock_x4;
				freq_list_len = freq_list_len_fast_relock_x4;
			}

			lookupFreq = freq << 1;
			break;
		case 4: // DFI freq ratio 1:4
			lookupFreq = freq;
			break;
		default:
			dwc_ddrphy_phyinit_assert(0, " %s invalid pUserInputBasic->DfiFreqRatio[%d] = %d\n", h, pstate, pUserInputBasic->DfiFreqRatio[pstate]);
			break;
		}

		if (freq > 2133) {
			dwc_ddrphy_phyinit_assert(0, " %s specified frequency %d MHz is out of range for Frequency ratio %d (pUserInputBasic->Frequency, pUserInputBasic->DfiFreqRatio, pstate=%d)\n", h, freq, pUserInputBasic->DfiFreqRatio[pstate],pstate);
		}
	)

	_IF_LPDDR5(
		// The frequency table above uses PllRefClk frequency x 4
		lookupFreq = freq << 2;
		if (freq > 800) {
			dwc_ddrphy_phyinit_assert(0, " %s specified frequency %d MHz is out of range (pUserInputBasic->Frequency, pstate=%d)\n", h, freq, pstate);
		}
	)
	// default to max frequency settings
	uint16_t pllDivSel = pPllDivSel[freq_list_len - 1];
	uint16_t pllV2IMode = pPllV2IMode[freq_list_len - 1];
	uint16_t pllVcoLowFreq = pPllVcoLowFreq[freq_list_len - 1];

	for (unsigned int freq_i = 0; freq_i < freq_list_len; freq_i++) {
		if (lookupFreq <= pFreqList[freq_i]) {
			pllDivSel = pPllDivSel[freq_i];
			pllV2IMode = pPllV2IMode[freq_i];
			pllVcoLowFreq = pPllVcoLowFreq[freq_i];
			break;
		}
	}

	/**
	 * - Program PLL configuration CSRs PllCtrl5 and PllCtrl6
	 *   - Fields:
	 *     - PllDivSel
	 *     - PllV2IMode
	 *     - PllVcoLowFreq
	 *     - PllX4Mode
	 *   - Dependencies:
	 *     - user_input_basic.Frequency
	 *     - user_input_basic.DfiFreqRatio
	 */

	uint16_t pllCtrl5 = (pllVcoLowFreq << csr_PllVcoLowFreq_LSB) | (pllV2IMode << csr_PllV2IMode_LSB) | (pllDivSel << csr_PllDivSel_LSB);

	dwc_ddrphy_phyinit_cmnt(" %s Pstate=%d,  Memclk=%dMHz, Programming  PllDivSel to %x.\n", h, pstate, freq, pllDivSel);
	dwc_ddrphy_phyinit_cmnt(" %s Pstate=%d,  Memclk=%dMHz, Programming  PllV2IMode to %x.\n", h, pstate, freq, pllV2IMode);
	dwc_ddrphy_phyinit_cmnt(" %s Pstate=%d,  Memclk=%dMHz, Programming  PllVcoLowFreq to %x.\n", h, pstate, freq, pllVcoLowFreq);

	uint16_t pllCtrl6 = (pll_x4_mode << csr_PllX4Mode_LSB);

	dwc_ddrphy_phyinit_cmnt(" %s Pstate=%d,  Memclk=%dMHz, Programming  PllX4Mode to %x.\n", h, pstate, freq, pll_x4_mode);

	if (mode == 0) {
		// use userCustom_io_write16 to write CSR without tracking in step C
		dwc_ddrphy_phyinit_userCustom_io_write16((p_addr | tMASTER | csr_PllCtrl5_ADDR), pllCtrl5);
		dwc_ddrphy_phyinit_userCustom_io_write16((p_addr | tMASTER | csr_PllCtrl6_ADDR), pllCtrl6);
	} else {
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_PllCtrl5_ADDR), pllCtrl5);
		dwc_ddrphy_phyinit_io_write16((p_addr | tMASTER | csr_PllCtrl6_ADDR), pllCtrl6);
	}

}

/** @} */
