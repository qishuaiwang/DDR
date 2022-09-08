/** \file
 * \brief API used to change PhyInit fields.
 * \addtogroup SrcFunc
 * @{
 */

#include <string.h>
#include "dwc_ddrphy_phyinit.h"

char *dwc_ddrphy_phyinit_setUserInput_enumDecode(userInputFields field)
{
	static char *field_enum_decode[] = {
		"lastTrainedPState",
"skip_train",
"initCtrl",
"ZQCalCodePD_saved",
"Train2D",
"firstTrainedPState",
"debug",
"ZQCalCodePU_saved",
"curD",
"RetEn",
"curPState",
"RxDfeMode[0]",
"RxDfeMode[1]",
"RxDfeMode[2]",
"RxDfeMode[3]",
"RxDfeMode[4]",
"RxDfeMode[5]",
"RxDfeMode[6]",
"RxDfeMode[7]",
"RxDfeMode[8]",
"RxDfeMode[9]",
"RxDfeMode[10]",
"RxDfeMode[11]",
"RxDfeMode[12]",
"RxDfeMode[13]",
"RxDfeMode[14]",
"DramByteSwap",
"TxSlewRiseDq[0]",
"TxSlewRiseDq[1]",
"TxSlewRiseDq[2]",
"TxSlewRiseDq[3]",
"TxSlewRiseDq[4]",
"TxSlewRiseDq[5]",
"TxSlewRiseDq[6]",
"TxSlewRiseDq[7]",
"TxSlewRiseDq[8]",
"TxSlewRiseDq[9]",
"TxSlewRiseDq[10]",
"TxSlewRiseDq[11]",
"TxSlewRiseDq[12]",
"TxSlewRiseDq[13]",
"TxSlewRiseDq[14]",
"RxBiasCurrentControlRxReplica[0]",
"RxBiasCurrentControlRxReplica[1]",
"RxBiasCurrentControlRxReplica[2]",
"RxBiasCurrentControlRxReplica[3]",
"RxBiasCurrentControlRxReplica[4]",
"RxBiasCurrentControlRxReplica[5]",
"RxBiasCurrentControlRxReplica[6]",
"RxBiasCurrentControlRxReplica[7]",
"RxBiasCurrentControlRxReplica[8]",
"RxBiasCurrentControlRxReplica[9]",
"RxBiasCurrentControlRxReplica[10]",
"RxBiasCurrentControlRxReplica[11]",
"RxBiasCurrentControlRxReplica[12]",
"RxBiasCurrentControlRxReplica[13]",
"RxBiasCurrentControlRxReplica[14]",
"TxSlewFallCA[0]",
"TxSlewFallCA[1]",
"TxSlewFallCA[2]",
"TxSlewFallCA[3]",
"TxSlewFallCA[4]",
"TxSlewFallCA[5]",
"TxSlewFallCA[6]",
"TxSlewFallCA[7]",
"TxSlewFallCA[8]",
"TxSlewFallCA[9]",
"TxSlewFallCA[10]",
"TxSlewFallCA[11]",
"TxSlewFallCA[12]",
"TxSlewFallCA[13]",
"TxSlewFallCA[14]",
"OdtImpedanceDqs[0]",
"OdtImpedanceDqs[1]",
"OdtImpedanceDqs[2]",
"OdtImpedanceDqs[3]",
"OdtImpedanceDqs[4]",
"OdtImpedanceDqs[5]",
"OdtImpedanceDqs[6]",
"OdtImpedanceDqs[7]",
"OdtImpedanceDqs[8]",
"OdtImpedanceDqs[9]",
"OdtImpedanceDqs[10]",
"OdtImpedanceDqs[11]",
"OdtImpedanceDqs[12]",
"OdtImpedanceDqs[13]",
"OdtImpedanceDqs[14]",
"RxModeBoostVDD[0]",
"RxModeBoostVDD[1]",
"RxModeBoostVDD[2]",
"RxModeBoostVDD[3]",
"RxModeBoostVDD[4]",
"RxModeBoostVDD[5]",
"RxModeBoostVDD[6]",
"RxModeBoostVDD[7]",
"RxModeBoostVDD[8]",
"RxModeBoostVDD[9]",
"RxModeBoostVDD[10]",
"RxModeBoostVDD[11]",
"RxModeBoostVDD[12]",
"RxModeBoostVDD[13]",
"RxModeBoostVDD[14]",
"PhyVrefCode",
"OdtImpedanceWCK[0]",
"OdtImpedanceWCK[1]",
"OdtImpedanceWCK[2]",
"OdtImpedanceWCK[3]",
"OdtImpedanceWCK[4]",
"OdtImpedanceWCK[5]",
"OdtImpedanceWCK[6]",
"OdtImpedanceWCK[7]",
"OdtImpedanceWCK[8]",
"OdtImpedanceWCK[9]",
"OdtImpedanceWCK[10]",
"OdtImpedanceWCK[11]",
"OdtImpedanceWCK[12]",
"OdtImpedanceWCK[13]",
"OdtImpedanceWCK[14]",
"TxSlewFallWCK[0]",
"TxSlewFallWCK[1]",
"TxSlewFallWCK[2]",
"TxSlewFallWCK[3]",
"TxSlewFallWCK[4]",
"TxSlewFallWCK[5]",
"TxSlewFallWCK[6]",
"TxSlewFallWCK[7]",
"TxSlewFallWCK[8]",
"TxSlewFallWCK[9]",
"TxSlewFallWCK[10]",
"TxSlewFallWCK[11]",
"TxSlewFallWCK[12]",
"TxSlewFallWCK[13]",
"TxSlewFallWCK[14]",
"OdtImpedanceDq[0]",
"OdtImpedanceDq[1]",
"OdtImpedanceDq[2]",
"OdtImpedanceDq[3]",
"OdtImpedanceDq[4]",
"OdtImpedanceDq[5]",
"OdtImpedanceDq[6]",
"OdtImpedanceDq[7]",
"OdtImpedanceDq[8]",
"OdtImpedanceDq[9]",
"OdtImpedanceDq[10]",
"OdtImpedanceDq[11]",
"OdtImpedanceDq[12]",
"OdtImpedanceDq[13]",
"OdtImpedanceDq[14]",
"DisableUnusedAddrLns",
"EnWck2DqoTracking[0]",
"EnWck2DqoTracking[1]",
"EnWck2DqoTracking[2]",
"EnWck2DqoTracking[3]",
"EnWck2DqoTracking[4]",
"EnWck2DqoTracking[5]",
"EnWck2DqoTracking[6]",
"EnWck2DqoTracking[7]",
"EnWck2DqoTracking[8]",
"EnWck2DqoTracking[9]",
"EnWck2DqoTracking[10]",
"EnWck2DqoTracking[11]",
"EnWck2DqoTracking[12]",
"EnWck2DqoTracking[13]",
"EnWck2DqoTracking[14]",
"TxSlewRiseCK[0]",
"TxSlewRiseCK[1]",
"TxSlewRiseCK[2]",
"TxSlewRiseCK[3]",
"TxSlewRiseCK[4]",
"TxSlewRiseCK[5]",
"TxSlewRiseCK[6]",
"TxSlewRiseCK[7]",
"TxSlewRiseCK[8]",
"TxSlewRiseCK[9]",
"TxSlewRiseCK[10]",
"TxSlewRiseCK[11]",
"TxSlewRiseCK[12]",
"TxSlewRiseCK[13]",
"TxSlewRiseCK[14]",
"TxSlewRiseCA[0]",
"TxSlewRiseCA[1]",
"TxSlewRiseCA[2]",
"TxSlewRiseCA[3]",
"TxSlewRiseCA[4]",
"TxSlewRiseCA[5]",
"TxSlewRiseCA[6]",
"TxSlewRiseCA[7]",
"TxSlewRiseCA[8]",
"TxSlewRiseCA[9]",
"TxSlewRiseCA[10]",
"TxSlewRiseCA[11]",
"TxSlewRiseCA[12]",
"TxSlewRiseCA[13]",
"TxSlewRiseCA[14]",
"TxSlewFallCK[0]",
"TxSlewFallCK[1]",
"TxSlewFallCK[2]",
"TxSlewFallCK[3]",
"TxSlewFallCK[4]",
"TxSlewFallCK[5]",
"TxSlewFallCK[6]",
"TxSlewFallCK[7]",
"TxSlewFallCK[8]",
"TxSlewFallCK[9]",
"TxSlewFallCK[10]",
"TxSlewFallCK[11]",
"TxSlewFallCK[12]",
"TxSlewFallCK[13]",
"TxSlewFallCK[14]",
"RelockOnlyCntrl",
"CalImpedanceCurrentAdjustment",
"SkipRetrainEnhancement",
"OdtImpedanceCk[0]",
"OdtImpedanceCk[1]",
"OdtImpedanceCk[2]",
"OdtImpedanceCk[3]",
"OdtImpedanceCk[4]",
"OdtImpedanceCk[5]",
"OdtImpedanceCk[6]",
"OdtImpedanceCk[7]",
"OdtImpedanceCk[8]",
"OdtImpedanceCk[9]",
"OdtImpedanceCk[10]",
"OdtImpedanceCk[11]",
"OdtImpedanceCk[12]",
"OdtImpedanceCk[13]",
"OdtImpedanceCk[14]",
"TxImpedanceCKE[0]",
"TxImpedanceCKE[1]",
"TxImpedanceCKE[2]",
"TxImpedanceCKE[3]",
"TxImpedanceCKE[4]",
"TxImpedanceCKE[5]",
"TxImpedanceCKE[6]",
"TxImpedanceCKE[7]",
"TxImpedanceCKE[8]",
"TxImpedanceCKE[9]",
"TxImpedanceCKE[10]",
"TxImpedanceCKE[11]",
"TxImpedanceCKE[12]",
"TxImpedanceCKE[13]",
"TxImpedanceCKE[14]",
"PsDmaRamSize",
"RxClkTrackEn[0]",
"RxClkTrackEn[1]",
"RxClkTrackEn[2]",
"RxClkTrackEn[3]",
"RxClkTrackEn[4]",
"RxClkTrackEn[5]",
"RxClkTrackEn[6]",
"RxClkTrackEn[7]",
"RxClkTrackEn[8]",
"RxClkTrackEn[9]",
"RxClkTrackEn[10]",
"RxClkTrackEn[11]",
"RxClkTrackEn[12]",
"RxClkTrackEn[13]",
"RxClkTrackEn[14]",
"TxSlewFallDqs[0]",
"TxSlewFallDqs[1]",
"TxSlewFallDqs[2]",
"TxSlewFallDqs[3]",
"TxSlewFallDqs[4]",
"TxSlewFallDqs[5]",
"TxSlewFallDqs[6]",
"TxSlewFallDqs[7]",
"TxSlewFallDqs[8]",
"TxSlewFallDqs[9]",
"TxSlewFallDqs[10]",
"TxSlewFallDqs[11]",
"TxSlewFallDqs[12]",
"TxSlewFallDqs[13]",
"TxSlewFallDqs[14]",
"TxImpedanceAc[0]",
"TxImpedanceAc[1]",
"TxImpedanceAc[2]",
"TxImpedanceAc[3]",
"TxImpedanceAc[4]",
"TxImpedanceAc[5]",
"TxImpedanceAc[6]",
"TxImpedanceAc[7]",
"TxImpedanceAc[8]",
"TxImpedanceAc[9]",
"TxImpedanceAc[10]",
"TxImpedanceAc[11]",
"TxImpedanceAc[12]",
"TxImpedanceAc[13]",
"TxImpedanceAc[14]",
"CkDisVal[0]",
"CkDisVal[1]",
"CkDisVal[2]",
"CkDisVal[3]",
"CkDisVal[4]",
"CkDisVal[5]",
"CkDisVal[6]",
"CkDisVal[7]",
"CkDisVal[8]",
"CkDisVal[9]",
"CkDisVal[10]",
"CkDisVal[11]",
"CkDisVal[12]",
"CkDisVal[13]",
"CkDisVal[14]",
"PhyMstrMaxReqToAck[0]",
"PhyMstrMaxReqToAck[1]",
"PhyMstrMaxReqToAck[2]",
"PhyMstrMaxReqToAck[3]",
"PhyMstrMaxReqToAck[4]",
"PhyMstrMaxReqToAck[5]",
"PhyMstrMaxReqToAck[6]",
"PhyMstrMaxReqToAck[7]",
"PhyMstrMaxReqToAck[8]",
"PhyMstrMaxReqToAck[9]",
"PhyMstrMaxReqToAck[10]",
"PhyMstrMaxReqToAck[11]",
"PhyMstrMaxReqToAck[12]",
"PhyMstrMaxReqToAck[13]",
"PhyMstrMaxReqToAck[14]",
"TxImpedanceDqs[0]",
"TxImpedanceDqs[1]",
"TxImpedanceDqs[2]",
"TxImpedanceDqs[3]",
"TxImpedanceDqs[4]",
"TxImpedanceDqs[5]",
"TxImpedanceDqs[6]",
"TxImpedanceDqs[7]",
"TxImpedanceDqs[8]",
"TxImpedanceDqs[9]",
"TxImpedanceDqs[10]",
"TxImpedanceDqs[11]",
"TxImpedanceDqs[12]",
"TxImpedanceDqs[13]",
"TxImpedanceDqs[14]",
"RxDqsTrackingThreshold[0]",
"RxDqsTrackingThreshold[1]",
"RxDqsTrackingThreshold[2]",
"RxDqsTrackingThreshold[3]",
"RxDqsTrackingThreshold[4]",
"RxDqsTrackingThreshold[5]",
"RxDqsTrackingThreshold[6]",
"RxDqsTrackingThreshold[7]",
"RxDqsTrackingThreshold[8]",
"RxDqsTrackingThreshold[9]",
"RxDqsTrackingThreshold[10]",
"RxDqsTrackingThreshold[11]",
"RxDqsTrackingThreshold[12]",
"RxDqsTrackingThreshold[13]",
"RxDqsTrackingThreshold[14]",
"DisableTDRAccess",
"DisableRetraining",
"TxSlewFallDq[0]",
"TxSlewFallDq[1]",
"TxSlewFallDq[2]",
"TxSlewFallDq[3]",
"TxSlewFallDq[4]",
"TxSlewFallDq[5]",
"TxSlewFallDq[6]",
"TxSlewFallDq[7]",
"TxSlewFallDq[8]",
"TxSlewFallDq[9]",
"TxSlewFallDq[10]",
"TxSlewFallDq[11]",
"TxSlewFallDq[12]",
"TxSlewFallDq[13]",
"TxSlewFallDq[14]",
"DisablePmuEcc",
"ExtCalResVal",
"TxImpedanceWCK[0]",
"TxImpedanceWCK[1]",
"TxImpedanceWCK[2]",
"TxImpedanceWCK[3]",
"TxImpedanceWCK[4]",
"TxImpedanceWCK[5]",
"TxImpedanceWCK[6]",
"TxImpedanceWCK[7]",
"TxImpedanceWCK[8]",
"TxImpedanceWCK[9]",
"TxImpedanceWCK[10]",
"TxImpedanceWCK[11]",
"TxImpedanceWCK[12]",
"TxImpedanceWCK[13]",
"TxImpedanceWCK[14]",
"TxSlewRiseDqs[0]",
"TxSlewRiseDqs[1]",
"TxSlewRiseDqs[2]",
"TxSlewRiseDqs[3]",
"TxSlewRiseDqs[4]",
"TxSlewRiseDqs[5]",
"TxSlewRiseDqs[6]",
"TxSlewRiseDqs[7]",
"TxSlewRiseDqs[8]",
"TxSlewRiseDqs[9]",
"TxSlewRiseDqs[10]",
"TxSlewRiseDqs[11]",
"TxSlewRiseDqs[12]",
"TxSlewRiseDqs[13]",
"TxSlewRiseDqs[14]",
"TxSlewRiseWCK[0]",
"TxSlewRiseWCK[1]",
"TxSlewRiseWCK[2]",
"TxSlewRiseWCK[3]",
"TxSlewRiseWCK[4]",
"TxSlewRiseWCK[5]",
"TxSlewRiseWCK[6]",
"TxSlewRiseWCK[7]",
"TxSlewRiseWCK[8]",
"TxSlewRiseWCK[9]",
"TxSlewRiseWCK[10]",
"TxSlewRiseWCK[11]",
"TxSlewRiseWCK[12]",
"TxSlewRiseWCK[13]",
"TxSlewRiseWCK[14]",
"RxBiasCurrentControlDqs[0]",
"RxBiasCurrentControlDqs[1]",
"RxBiasCurrentControlDqs[2]",
"RxBiasCurrentControlDqs[3]",
"RxBiasCurrentControlDqs[4]",
"RxBiasCurrentControlDqs[5]",
"RxBiasCurrentControlDqs[6]",
"RxBiasCurrentControlDqs[7]",
"RxBiasCurrentControlDqs[8]",
"RxBiasCurrentControlDqs[9]",
"RxBiasCurrentControlDqs[10]",
"RxBiasCurrentControlDqs[11]",
"RxBiasCurrentControlDqs[12]",
"RxBiasCurrentControlDqs[13]",
"RxBiasCurrentControlDqs[14]",
"RxClkTrackWait",
"CalOnce",
"PhyMstrCtrlMode[0]",
"PhyMstrCtrlMode[1]",
"PhyMstrCtrlMode[2]",
"PhyMstrCtrlMode[3]",
"PhyMstrCtrlMode[4]",
"PhyMstrCtrlMode[5]",
"PhyMstrCtrlMode[6]",
"PhyMstrCtrlMode[7]",
"PhyMstrCtrlMode[8]",
"PhyMstrCtrlMode[9]",
"PhyMstrCtrlMode[10]",
"PhyMstrCtrlMode[11]",
"PhyMstrCtrlMode[12]",
"PhyMstrCtrlMode[13]",
"PhyMstrCtrlMode[14]",
"RxVrefKickbackNoiseCancellation[0]",
"RxVrefKickbackNoiseCancellation[1]",
"RxVrefKickbackNoiseCancellation[2]",
"RxVrefKickbackNoiseCancellation[3]",
"RxVrefKickbackNoiseCancellation[4]",
"RxVrefKickbackNoiseCancellation[5]",
"RxVrefKickbackNoiseCancellation[6]",
"RxVrefKickbackNoiseCancellation[7]",
"RxVrefKickbackNoiseCancellation[8]",
"RxVrefKickbackNoiseCancellation[9]",
"RxVrefKickbackNoiseCancellation[10]",
"RxVrefKickbackNoiseCancellation[11]",
"RxVrefKickbackNoiseCancellation[12]",
"RxVrefKickbackNoiseCancellation[13]",
"RxVrefKickbackNoiseCancellation[14]",
"RxClkTrackWaitUI",
"TxImpedanceDq[0]",
"TxImpedanceDq[1]",
"TxImpedanceDq[2]",
"TxImpedanceDq[3]",
"TxImpedanceDq[4]",
"TxImpedanceDq[5]",
"TxImpedanceDq[6]",
"TxImpedanceDq[7]",
"TxImpedanceDq[8]",
"TxImpedanceDq[9]",
"TxImpedanceDq[10]",
"TxImpedanceDq[11]",
"TxImpedanceDq[12]",
"TxImpedanceDq[13]",
"TxImpedanceDq[14]",
"OnlyRestoreNonPsRegs",
"TrainSequenceCtrl",
"TxImpedanceCk[0]",
"TxImpedanceCk[1]",
"TxImpedanceCk[2]",
"TxImpedanceCk[3]",
"TxImpedanceCk[4]",
"TxImpedanceCk[5]",
"TxImpedanceCk[6]",
"TxImpedanceCk[7]",
"TxImpedanceCk[8]",
"TxImpedanceCk[9]",
"TxImpedanceCk[10]",
"TxImpedanceCk[11]",
"TxImpedanceCk[12]",
"TxImpedanceCk[13]",
"TxImpedanceCk[14]",
"DisableFspOp",
"TxImpedanceDTO[0]",
"TxImpedanceDTO[1]",
"TxImpedanceDTO[2]",
"TxImpedanceDTO[3]",
"TxImpedanceDTO[4]",
"TxImpedanceDTO[5]",
"TxImpedanceDTO[6]",
"TxImpedanceDTO[7]",
"TxImpedanceDTO[8]",
"TxImpedanceDTO[9]",
"TxImpedanceDTO[10]",
"TxImpedanceDTO[11]",
"TxImpedanceDTO[12]",
"TxImpedanceDTO[13]",
"TxImpedanceDTO[14]",
"EnRxDqsTracking[0]",
"EnRxDqsTracking[1]",
"EnRxDqsTracking[2]",
"EnRxDqsTracking[3]",
"EnRxDqsTracking[4]",
"EnRxDqsTracking[5]",
"EnRxDqsTracking[6]",
"EnRxDqsTracking[7]",
"EnRxDqsTracking[8]",
"EnRxDqsTracking[9]",
"EnRxDqsTracking[10]",
"EnRxDqsTracking[11]",
"EnRxDqsTracking[12]",
"EnRxDqsTracking[13]",
"EnRxDqsTracking[14]",
"CalInterval",
"RxBiasCurrentControlWck[0]",
"RxBiasCurrentControlWck[1]",
"RxBiasCurrentControlWck[2]",
"RxBiasCurrentControlWck[3]",
"RxBiasCurrentControlWck[4]",
"RxBiasCurrentControlWck[5]",
"RxBiasCurrentControlWck[6]",
"RxBiasCurrentControlWck[7]",
"RxBiasCurrentControlWck[8]",
"RxBiasCurrentControlWck[9]",
"RxBiasCurrentControlWck[10]",
"RxBiasCurrentControlWck[11]",
"RxBiasCurrentControlWck[12]",
"RxBiasCurrentControlWck[13]",
"RxBiasCurrentControlWck[14]",
"RetrainMode[0]",
"RetrainMode[1]",
"RetrainMode[2]",
"RetrainMode[3]",
"RetrainMode[4]",
"RetrainMode[5]",
"RetrainMode[6]",
"RetrainMode[7]",
"RetrainMode[8]",
"RetrainMode[9]",
"RetrainMode[10]",
"RetrainMode[11]",
"RetrainMode[12]",
"RetrainMode[13]",
"RetrainMode[14]",
"RxVrefDACEnable[0]",
"RxVrefDACEnable[1]",
"RxVrefDACEnable[2]",
"RxVrefDACEnable[3]",
"RxVrefDACEnable[4]",
"RxVrefDACEnable[5]",
"RxVrefDACEnable[6]",
"RxVrefDACEnable[7]",
"RxVrefDACEnable[8]",
"RxVrefDACEnable[9]",
"RxVrefDACEnable[10]",
"RxVrefDACEnable[11]",
"RxVrefDACEnable[12]",
"RxVrefDACEnable[13]",
"RxVrefDACEnable[14]",
"PhyMstrTrainInterval[0]",
"PhyMstrTrainInterval[1]",
"PhyMstrTrainInterval[2]",
"PhyMstrTrainInterval[3]",
"PhyMstrTrainInterval[4]",
"PhyMstrTrainInterval[5]",
"PhyMstrTrainInterval[6]",
"PhyMstrTrainInterval[7]",
"PhyMstrTrainInterval[8]",
"PhyMstrTrainInterval[9]",
"PhyMstrTrainInterval[10]",
"PhyMstrTrainInterval[11]",
"PhyMstrTrainInterval[12]",
"PhyMstrTrainInterval[13]",
"PhyMstrTrainInterval[14]",
"Lp3DramState[0]",
"Lp3DramState[1]",
"Lp3DramState[2]",
"Lp3DramState[3]",
"Lp3DramState[4]",
"Lp3DramState[5]",
"Lp3DramState[6]",
"Lp3DramState[7]",
"Lp3DramState[8]",
"Lp3DramState[9]",
"Lp3DramState[10]",
"Lp3DramState[11]",
"Lp3DramState[12]",
"Lp3DramState[13]",
"Lp3DramState[14]",
"PmuClockDiv[0]",
"PmuClockDiv[1]",
"PmuClockDiv[2]",
"PmuClockDiv[3]",
"PmuClockDiv[4]",
"PmuClockDiv[5]",
"PmuClockDiv[6]",
"PmuClockDiv[7]",
"PmuClockDiv[8]",
"PmuClockDiv[9]",
"PmuClockDiv[10]",
"PmuClockDiv[11]",
"PmuClockDiv[12]",
"PmuClockDiv[13]",
"PmuClockDiv[14]",
"WDQSExt",
"DisablePhyUpdate",
"OdtImpedanceCa[0]",
"OdtImpedanceCa[1]",
"OdtImpedanceCa[2]",
"OdtImpedanceCa[3]",
"OdtImpedanceCa[4]",
"OdtImpedanceCa[5]",
"OdtImpedanceCa[6]",
"OdtImpedanceCa[7]",
"OdtImpedanceCa[8]",
"OdtImpedanceCa[9]",
"OdtImpedanceCa[10]",
"OdtImpedanceCa[11]",
"OdtImpedanceCa[12]",
"OdtImpedanceCa[13]",
"OdtImpedanceCa[14]",
"SkipFlashCopy[0]",
"SkipFlashCopy[1]",
"SkipFlashCopy[2]",
"SkipFlashCopy[3]",
"SkipFlashCopy[4]",
"SkipFlashCopy[5]",
"SkipFlashCopy[6]",
"SkipFlashCopy[7]",
"SkipFlashCopy[8]",
"SkipFlashCopy[9]",
"SkipFlashCopy[10]",
"SkipFlashCopy[11]",
"SkipFlashCopy[12]",
"SkipFlashCopy[13]",
"SkipFlashCopy[14]",
"DqsOscRunTimeSel[0]",
"DqsOscRunTimeSel[1]",
"DqsOscRunTimeSel[2]",
"DqsOscRunTimeSel[3]",
"DqsOscRunTimeSel[4]",
"DqsOscRunTimeSel[5]",
"DqsOscRunTimeSel[6]",
"DqsOscRunTimeSel[7]",
"DqsOscRunTimeSel[8]",
"DqsOscRunTimeSel[9]",
"DqsOscRunTimeSel[10]",
"DqsOscRunTimeSel[11]",
"DqsOscRunTimeSel[12]",
"DqsOscRunTimeSel[13]",
"DqsOscRunTimeSel[14]",
"RxBiasCurrentControlCk[0]",
"RxBiasCurrentControlCk[1]",
"RxBiasCurrentControlCk[2]",
"RxBiasCurrentControlCk[3]",
"RxBiasCurrentControlCk[4]",
"RxBiasCurrentControlCk[5]",
"RxBiasCurrentControlCk[6]",
"RxBiasCurrentControlCk[7]",
"RxBiasCurrentControlCk[8]",
"RxBiasCurrentControlCk[9]",
"RxBiasCurrentControlCk[10]",
"RxBiasCurrentControlCk[11]",
"RxBiasCurrentControlCk[12]",
"RxBiasCurrentControlCk[13]",
"RxBiasCurrentControlCk[14]",
"NumPStates",
"NumRank_dfi0",
"HardMacroVer",
"NumCh",
"DimmType",
"DramType",
"DfiFreqRatio[0]",
"DfiFreqRatio[1]",
"DfiFreqRatio[2]",
"DfiFreqRatio[3]",
"DfiFreqRatio[4]",
"DfiFreqRatio[5]",
"DfiFreqRatio[6]",
"DfiFreqRatio[7]",
"DfiFreqRatio[8]",
"DfiFreqRatio[9]",
"DfiFreqRatio[10]",
"DfiFreqRatio[11]",
"DfiFreqRatio[12]",
"DfiFreqRatio[13]",
"DfiFreqRatio[14]",
"FirstPState",
"NumActiveDbyteDfi1",
"NumRank",
"DramDataWidth",
"CfgPStates",
"Frequency[0]",
"Frequency[1]",
"Frequency[2]",
"Frequency[3]",
"Frequency[4]",
"Frequency[5]",
"Frequency[6]",
"Frequency[7]",
"Frequency[8]",
"Frequency[9]",
"Frequency[10]",
"Frequency[11]",
"Frequency[12]",
"Frequency[13]",
"Frequency[14]",
"PllBypass[0]",
"PllBypass[1]",
"PllBypass[2]",
"PllBypass[3]",
"PllBypass[4]",
"PllBypass[5]",
"PllBypass[6]",
"PllBypass[7]",
"PllBypass[8]",
"PllBypass[9]",
"PllBypass[10]",
"PllBypass[11]",
"PllBypass[12]",
"PllBypass[13]",
"PllBypass[14]",
"NumRank_dfi1",
"NumDbytesPerCh",
"MaxNumZQ",
"NumActiveDbyteDfi0",
"tWCK2DQO",
"tWCK2DQI",
"tWCK2CK",
"PHY_tDQS2DQ",
	};

	if (field < 0 || field >= 740) {
		return "Enum out of range";
	} else {
		return field_enum_decode[field];
	}
}

int dwc_ddrphy_phyinit_setUserInput_enum(phyinit_config_t *phyctx, userInputFields field, int value)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;
	user_input_sim_t *pUserInputSim = &phyctx->userInputSim;
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	int result = 0;

	switch (field) {
	case 0:
		pRuntimeConfig->lastTrainedPState = value;
		break;
	case 1:
		pRuntimeConfig->skip_train = value;
		break;
	case 2:
		pRuntimeConfig->initCtrl = value;
		break;
	case 3:
		pRuntimeConfig->ZQCalCodePD_saved = value;
		break;
	case 4:
		pRuntimeConfig->Train2D = value;
		break;
	case 5:
		pRuntimeConfig->firstTrainedPState = value;
		break;
	case 6:
		pRuntimeConfig->debug = value;
		break;
	case 7:
		pRuntimeConfig->ZQCalCodePU_saved = value;
		break;
	case 8:
		pRuntimeConfig->curD = value;
		break;
	case 9:
		pRuntimeConfig->RetEn = value;
		break;
	case 10:
		pRuntimeConfig->curPState = value;
		break;
	case 11:
		pUserInputAdvanced->RxDfeMode[0] = value;
		break;
	case 12:
		pUserInputAdvanced->RxDfeMode[1] = value;
		break;
	case 13:
		pUserInputAdvanced->RxDfeMode[2] = value;
		break;
	case 14:
		pUserInputAdvanced->RxDfeMode[3] = value;
		break;
	case 15:
		pUserInputAdvanced->RxDfeMode[4] = value;
		break;
	case 16:
		pUserInputAdvanced->RxDfeMode[5] = value;
		break;
	case 17:
		pUserInputAdvanced->RxDfeMode[6] = value;
		break;
	case 18:
		pUserInputAdvanced->RxDfeMode[7] = value;
		break;
	case 19:
		pUserInputAdvanced->RxDfeMode[8] = value;
		break;
	case 20:
		pUserInputAdvanced->RxDfeMode[9] = value;
		break;
	case 21:
		pUserInputAdvanced->RxDfeMode[10] = value;
		break;
	case 22:
		pUserInputAdvanced->RxDfeMode[11] = value;
		break;
	case 23:
		pUserInputAdvanced->RxDfeMode[12] = value;
		break;
	case 24:
		pUserInputAdvanced->RxDfeMode[13] = value;
		break;
	case 25:
		pUserInputAdvanced->RxDfeMode[14] = value;
		break;
	case 26:
		pUserInputAdvanced->DramByteSwap = value;
		break;
	case 27:
		pUserInputAdvanced->TxSlewRiseDq[0] = value;
		break;
	case 28:
		pUserInputAdvanced->TxSlewRiseDq[1] = value;
		break;
	case 29:
		pUserInputAdvanced->TxSlewRiseDq[2] = value;
		break;
	case 30:
		pUserInputAdvanced->TxSlewRiseDq[3] = value;
		break;
	case 31:
		pUserInputAdvanced->TxSlewRiseDq[4] = value;
		break;
	case 32:
		pUserInputAdvanced->TxSlewRiseDq[5] = value;
		break;
	case 33:
		pUserInputAdvanced->TxSlewRiseDq[6] = value;
		break;
	case 34:
		pUserInputAdvanced->TxSlewRiseDq[7] = value;
		break;
	case 35:
		pUserInputAdvanced->TxSlewRiseDq[8] = value;
		break;
	case 36:
		pUserInputAdvanced->TxSlewRiseDq[9] = value;
		break;
	case 37:
		pUserInputAdvanced->TxSlewRiseDq[10] = value;
		break;
	case 38:
		pUserInputAdvanced->TxSlewRiseDq[11] = value;
		break;
	case 39:
		pUserInputAdvanced->TxSlewRiseDq[12] = value;
		break;
	case 40:
		pUserInputAdvanced->TxSlewRiseDq[13] = value;
		break;
	case 41:
		pUserInputAdvanced->TxSlewRiseDq[14] = value;
		break;
	case 42:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[0] = value;
		break;
	case 43:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[1] = value;
		break;
	case 44:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[2] = value;
		break;
	case 45:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[3] = value;
		break;
	case 46:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[4] = value;
		break;
	case 47:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[5] = value;
		break;
	case 48:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[6] = value;
		break;
	case 49:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[7] = value;
		break;
	case 50:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[8] = value;
		break;
	case 51:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[9] = value;
		break;
	case 52:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[10] = value;
		break;
	case 53:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[11] = value;
		break;
	case 54:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[12] = value;
		break;
	case 55:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[13] = value;
		break;
	case 56:
		pUserInputAdvanced->RxBiasCurrentControlRxReplica[14] = value;
		break;
	case 57:
		pUserInputAdvanced->TxSlewFallCA[0] = value;
		break;
	case 58:
		pUserInputAdvanced->TxSlewFallCA[1] = value;
		break;
	case 59:
		pUserInputAdvanced->TxSlewFallCA[2] = value;
		break;
	case 60:
		pUserInputAdvanced->TxSlewFallCA[3] = value;
		break;
	case 61:
		pUserInputAdvanced->TxSlewFallCA[4] = value;
		break;
	case 62:
		pUserInputAdvanced->TxSlewFallCA[5] = value;
		break;
	case 63:
		pUserInputAdvanced->TxSlewFallCA[6] = value;
		break;
	case 64:
		pUserInputAdvanced->TxSlewFallCA[7] = value;
		break;
	case 65:
		pUserInputAdvanced->TxSlewFallCA[8] = value;
		break;
	case 66:
		pUserInputAdvanced->TxSlewFallCA[9] = value;
		break;
	case 67:
		pUserInputAdvanced->TxSlewFallCA[10] = value;
		break;
	case 68:
		pUserInputAdvanced->TxSlewFallCA[11] = value;
		break;
	case 69:
		pUserInputAdvanced->TxSlewFallCA[12] = value;
		break;
	case 70:
		pUserInputAdvanced->TxSlewFallCA[13] = value;
		break;
	case 71:
		pUserInputAdvanced->TxSlewFallCA[14] = value;
		break;
	case 72:
		pUserInputAdvanced->OdtImpedanceDqs[0] = value;
		break;
	case 73:
		pUserInputAdvanced->OdtImpedanceDqs[1] = value;
		break;
	case 74:
		pUserInputAdvanced->OdtImpedanceDqs[2] = value;
		break;
	case 75:
		pUserInputAdvanced->OdtImpedanceDqs[3] = value;
		break;
	case 76:
		pUserInputAdvanced->OdtImpedanceDqs[4] = value;
		break;
	case 77:
		pUserInputAdvanced->OdtImpedanceDqs[5] = value;
		break;
	case 78:
		pUserInputAdvanced->OdtImpedanceDqs[6] = value;
		break;
	case 79:
		pUserInputAdvanced->OdtImpedanceDqs[7] = value;
		break;
	case 80:
		pUserInputAdvanced->OdtImpedanceDqs[8] = value;
		break;
	case 81:
		pUserInputAdvanced->OdtImpedanceDqs[9] = value;
		break;
	case 82:
		pUserInputAdvanced->OdtImpedanceDqs[10] = value;
		break;
	case 83:
		pUserInputAdvanced->OdtImpedanceDqs[11] = value;
		break;
	case 84:
		pUserInputAdvanced->OdtImpedanceDqs[12] = value;
		break;
	case 85:
		pUserInputAdvanced->OdtImpedanceDqs[13] = value;
		break;
	case 86:
		pUserInputAdvanced->OdtImpedanceDqs[14] = value;
		break;
	case 87:
		pUserInputAdvanced->RxModeBoostVDD[0] = value;
		break;
	case 88:
		pUserInputAdvanced->RxModeBoostVDD[1] = value;
		break;
	case 89:
		pUserInputAdvanced->RxModeBoostVDD[2] = value;
		break;
	case 90:
		pUserInputAdvanced->RxModeBoostVDD[3] = value;
		break;
	case 91:
		pUserInputAdvanced->RxModeBoostVDD[4] = value;
		break;
	case 92:
		pUserInputAdvanced->RxModeBoostVDD[5] = value;
		break;
	case 93:
		pUserInputAdvanced->RxModeBoostVDD[6] = value;
		break;
	case 94:
		pUserInputAdvanced->RxModeBoostVDD[7] = value;
		break;
	case 95:
		pUserInputAdvanced->RxModeBoostVDD[8] = value;
		break;
	case 96:
		pUserInputAdvanced->RxModeBoostVDD[9] = value;
		break;
	case 97:
		pUserInputAdvanced->RxModeBoostVDD[10] = value;
		break;
	case 98:
		pUserInputAdvanced->RxModeBoostVDD[11] = value;
		break;
	case 99:
		pUserInputAdvanced->RxModeBoostVDD[12] = value;
		break;
	case 100:
		pUserInputAdvanced->RxModeBoostVDD[13] = value;
		break;
	case 101:
		pUserInputAdvanced->RxModeBoostVDD[14] = value;
		break;
	case 102:
		pUserInputAdvanced->PhyVrefCode = value;
		break;
	case 103:
		pUserInputAdvanced->OdtImpedanceWCK[0] = value;
		break;
	case 104:
		pUserInputAdvanced->OdtImpedanceWCK[1] = value;
		break;
	case 105:
		pUserInputAdvanced->OdtImpedanceWCK[2] = value;
		break;
	case 106:
		pUserInputAdvanced->OdtImpedanceWCK[3] = value;
		break;
	case 107:
		pUserInputAdvanced->OdtImpedanceWCK[4] = value;
		break;
	case 108:
		pUserInputAdvanced->OdtImpedanceWCK[5] = value;
		break;
	case 109:
		pUserInputAdvanced->OdtImpedanceWCK[6] = value;
		break;
	case 110:
		pUserInputAdvanced->OdtImpedanceWCK[7] = value;
		break;
	case 111:
		pUserInputAdvanced->OdtImpedanceWCK[8] = value;
		break;
	case 112:
		pUserInputAdvanced->OdtImpedanceWCK[9] = value;
		break;
	case 113:
		pUserInputAdvanced->OdtImpedanceWCK[10] = value;
		break;
	case 114:
		pUserInputAdvanced->OdtImpedanceWCK[11] = value;
		break;
	case 115:
		pUserInputAdvanced->OdtImpedanceWCK[12] = value;
		break;
	case 116:
		pUserInputAdvanced->OdtImpedanceWCK[13] = value;
		break;
	case 117:
		pUserInputAdvanced->OdtImpedanceWCK[14] = value;
		break;
	case 118:
		pUserInputAdvanced->TxSlewFallWCK[0] = value;
		break;
	case 119:
		pUserInputAdvanced->TxSlewFallWCK[1] = value;
		break;
	case 120:
		pUserInputAdvanced->TxSlewFallWCK[2] = value;
		break;
	case 121:
		pUserInputAdvanced->TxSlewFallWCK[3] = value;
		break;
	case 122:
		pUserInputAdvanced->TxSlewFallWCK[4] = value;
		break;
	case 123:
		pUserInputAdvanced->TxSlewFallWCK[5] = value;
		break;
	case 124:
		pUserInputAdvanced->TxSlewFallWCK[6] = value;
		break;
	case 125:
		pUserInputAdvanced->TxSlewFallWCK[7] = value;
		break;
	case 126:
		pUserInputAdvanced->TxSlewFallWCK[8] = value;
		break;
	case 127:
		pUserInputAdvanced->TxSlewFallWCK[9] = value;
		break;
	case 128:
		pUserInputAdvanced->TxSlewFallWCK[10] = value;
		break;
	case 129:
		pUserInputAdvanced->TxSlewFallWCK[11] = value;
		break;
	case 130:
		pUserInputAdvanced->TxSlewFallWCK[12] = value;
		break;
	case 131:
		pUserInputAdvanced->TxSlewFallWCK[13] = value;
		break;
	case 132:
		pUserInputAdvanced->TxSlewFallWCK[14] = value;
		break;
	case 133:
		pUserInputAdvanced->OdtImpedanceDq[0] = value;
		break;
	case 134:
		pUserInputAdvanced->OdtImpedanceDq[1] = value;
		break;
	case 135:
		pUserInputAdvanced->OdtImpedanceDq[2] = value;
		break;
	case 136:
		pUserInputAdvanced->OdtImpedanceDq[3] = value;
		break;
	case 137:
		pUserInputAdvanced->OdtImpedanceDq[4] = value;
		break;
	case 138:
		pUserInputAdvanced->OdtImpedanceDq[5] = value;
		break;
	case 139:
		pUserInputAdvanced->OdtImpedanceDq[6] = value;
		break;
	case 140:
		pUserInputAdvanced->OdtImpedanceDq[7] = value;
		break;
	case 141:
		pUserInputAdvanced->OdtImpedanceDq[8] = value;
		break;
	case 142:
		pUserInputAdvanced->OdtImpedanceDq[9] = value;
		break;
	case 143:
		pUserInputAdvanced->OdtImpedanceDq[10] = value;
		break;
	case 144:
		pUserInputAdvanced->OdtImpedanceDq[11] = value;
		break;
	case 145:
		pUserInputAdvanced->OdtImpedanceDq[12] = value;
		break;
	case 146:
		pUserInputAdvanced->OdtImpedanceDq[13] = value;
		break;
	case 147:
		pUserInputAdvanced->OdtImpedanceDq[14] = value;
		break;
	case 148:
		pUserInputAdvanced->DisableUnusedAddrLns = value;
		break;
	case 149:
		pUserInputAdvanced->EnWck2DqoTracking[0] = value;
		break;
	case 150:
		pUserInputAdvanced->EnWck2DqoTracking[1] = value;
		break;
	case 151:
		pUserInputAdvanced->EnWck2DqoTracking[2] = value;
		break;
	case 152:
		pUserInputAdvanced->EnWck2DqoTracking[3] = value;
		break;
	case 153:
		pUserInputAdvanced->EnWck2DqoTracking[4] = value;
		break;
	case 154:
		pUserInputAdvanced->EnWck2DqoTracking[5] = value;
		break;
	case 155:
		pUserInputAdvanced->EnWck2DqoTracking[6] = value;
		break;
	case 156:
		pUserInputAdvanced->EnWck2DqoTracking[7] = value;
		break;
	case 157:
		pUserInputAdvanced->EnWck2DqoTracking[8] = value;
		break;
	case 158:
		pUserInputAdvanced->EnWck2DqoTracking[9] = value;
		break;
	case 159:
		pUserInputAdvanced->EnWck2DqoTracking[10] = value;
		break;
	case 160:
		pUserInputAdvanced->EnWck2DqoTracking[11] = value;
		break;
	case 161:
		pUserInputAdvanced->EnWck2DqoTracking[12] = value;
		break;
	case 162:
		pUserInputAdvanced->EnWck2DqoTracking[13] = value;
		break;
	case 163:
		pUserInputAdvanced->EnWck2DqoTracking[14] = value;
		break;
	case 164:
		pUserInputAdvanced->TxSlewRiseCK[0] = value;
		break;
	case 165:
		pUserInputAdvanced->TxSlewRiseCK[1] = value;
		break;
	case 166:
		pUserInputAdvanced->TxSlewRiseCK[2] = value;
		break;
	case 167:
		pUserInputAdvanced->TxSlewRiseCK[3] = value;
		break;
	case 168:
		pUserInputAdvanced->TxSlewRiseCK[4] = value;
		break;
	case 169:
		pUserInputAdvanced->TxSlewRiseCK[5] = value;
		break;
	case 170:
		pUserInputAdvanced->TxSlewRiseCK[6] = value;
		break;
	case 171:
		pUserInputAdvanced->TxSlewRiseCK[7] = value;
		break;
	case 172:
		pUserInputAdvanced->TxSlewRiseCK[8] = value;
		break;
	case 173:
		pUserInputAdvanced->TxSlewRiseCK[9] = value;
		break;
	case 174:
		pUserInputAdvanced->TxSlewRiseCK[10] = value;
		break;
	case 175:
		pUserInputAdvanced->TxSlewRiseCK[11] = value;
		break;
	case 176:
		pUserInputAdvanced->TxSlewRiseCK[12] = value;
		break;
	case 177:
		pUserInputAdvanced->TxSlewRiseCK[13] = value;
		break;
	case 178:
		pUserInputAdvanced->TxSlewRiseCK[14] = value;
		break;
	case 179:
		pUserInputAdvanced->TxSlewRiseCA[0] = value;
		break;
	case 180:
		pUserInputAdvanced->TxSlewRiseCA[1] = value;
		break;
	case 181:
		pUserInputAdvanced->TxSlewRiseCA[2] = value;
		break;
	case 182:
		pUserInputAdvanced->TxSlewRiseCA[3] = value;
		break;
	case 183:
		pUserInputAdvanced->TxSlewRiseCA[4] = value;
		break;
	case 184:
		pUserInputAdvanced->TxSlewRiseCA[5] = value;
		break;
	case 185:
		pUserInputAdvanced->TxSlewRiseCA[6] = value;
		break;
	case 186:
		pUserInputAdvanced->TxSlewRiseCA[7] = value;
		break;
	case 187:
		pUserInputAdvanced->TxSlewRiseCA[8] = value;
		break;
	case 188:
		pUserInputAdvanced->TxSlewRiseCA[9] = value;
		break;
	case 189:
		pUserInputAdvanced->TxSlewRiseCA[10] = value;
		break;
	case 190:
		pUserInputAdvanced->TxSlewRiseCA[11] = value;
		break;
	case 191:
		pUserInputAdvanced->TxSlewRiseCA[12] = value;
		break;
	case 192:
		pUserInputAdvanced->TxSlewRiseCA[13] = value;
		break;
	case 193:
		pUserInputAdvanced->TxSlewRiseCA[14] = value;
		break;
	case 194:
		pUserInputAdvanced->TxSlewFallCK[0] = value;
		break;
	case 195:
		pUserInputAdvanced->TxSlewFallCK[1] = value;
		break;
	case 196:
		pUserInputAdvanced->TxSlewFallCK[2] = value;
		break;
	case 197:
		pUserInputAdvanced->TxSlewFallCK[3] = value;
		break;
	case 198:
		pUserInputAdvanced->TxSlewFallCK[4] = value;
		break;
	case 199:
		pUserInputAdvanced->TxSlewFallCK[5] = value;
		break;
	case 200:
		pUserInputAdvanced->TxSlewFallCK[6] = value;
		break;
	case 201:
		pUserInputAdvanced->TxSlewFallCK[7] = value;
		break;
	case 202:
		pUserInputAdvanced->TxSlewFallCK[8] = value;
		break;
	case 203:
		pUserInputAdvanced->TxSlewFallCK[9] = value;
		break;
	case 204:
		pUserInputAdvanced->TxSlewFallCK[10] = value;
		break;
	case 205:
		pUserInputAdvanced->TxSlewFallCK[11] = value;
		break;
	case 206:
		pUserInputAdvanced->TxSlewFallCK[12] = value;
		break;
	case 207:
		pUserInputAdvanced->TxSlewFallCK[13] = value;
		break;
	case 208:
		pUserInputAdvanced->TxSlewFallCK[14] = value;
		break;
	case 209:
		pUserInputAdvanced->RelockOnlyCntrl = value;
		break;
	case 210:
		pUserInputAdvanced->CalImpedanceCurrentAdjustment = value;
		break;
	case 211:
		pUserInputAdvanced->SkipRetrainEnhancement = value;
		break;
	case 212:
		pUserInputAdvanced->OdtImpedanceCk[0] = value;
		break;
	case 213:
		pUserInputAdvanced->OdtImpedanceCk[1] = value;
		break;
	case 214:
		pUserInputAdvanced->OdtImpedanceCk[2] = value;
		break;
	case 215:
		pUserInputAdvanced->OdtImpedanceCk[3] = value;
		break;
	case 216:
		pUserInputAdvanced->OdtImpedanceCk[4] = value;
		break;
	case 217:
		pUserInputAdvanced->OdtImpedanceCk[5] = value;
		break;
	case 218:
		pUserInputAdvanced->OdtImpedanceCk[6] = value;
		break;
	case 219:
		pUserInputAdvanced->OdtImpedanceCk[7] = value;
		break;
	case 220:
		pUserInputAdvanced->OdtImpedanceCk[8] = value;
		break;
	case 221:
		pUserInputAdvanced->OdtImpedanceCk[9] = value;
		break;
	case 222:
		pUserInputAdvanced->OdtImpedanceCk[10] = value;
		break;
	case 223:
		pUserInputAdvanced->OdtImpedanceCk[11] = value;
		break;
	case 224:
		pUserInputAdvanced->OdtImpedanceCk[12] = value;
		break;
	case 225:
		pUserInputAdvanced->OdtImpedanceCk[13] = value;
		break;
	case 226:
		pUserInputAdvanced->OdtImpedanceCk[14] = value;
		break;
	case 227:
		pUserInputAdvanced->TxImpedanceCKE[0] = value;
		break;
	case 228:
		pUserInputAdvanced->TxImpedanceCKE[1] = value;
		break;
	case 229:
		pUserInputAdvanced->TxImpedanceCKE[2] = value;
		break;
	case 230:
		pUserInputAdvanced->TxImpedanceCKE[3] = value;
		break;
	case 231:
		pUserInputAdvanced->TxImpedanceCKE[4] = value;
		break;
	case 232:
		pUserInputAdvanced->TxImpedanceCKE[5] = value;
		break;
	case 233:
		pUserInputAdvanced->TxImpedanceCKE[6] = value;
		break;
	case 234:
		pUserInputAdvanced->TxImpedanceCKE[7] = value;
		break;
	case 235:
		pUserInputAdvanced->TxImpedanceCKE[8] = value;
		break;
	case 236:
		pUserInputAdvanced->TxImpedanceCKE[9] = value;
		break;
	case 237:
		pUserInputAdvanced->TxImpedanceCKE[10] = value;
		break;
	case 238:
		pUserInputAdvanced->TxImpedanceCKE[11] = value;
		break;
	case 239:
		pUserInputAdvanced->TxImpedanceCKE[12] = value;
		break;
	case 240:
		pUserInputAdvanced->TxImpedanceCKE[13] = value;
		break;
	case 241:
		pUserInputAdvanced->TxImpedanceCKE[14] = value;
		break;
	case 242:
		pUserInputAdvanced->PsDmaRamSize = value;
		break;
	case 243:
		pUserInputAdvanced->RxClkTrackEn[0] = value;
		break;
	case 244:
		pUserInputAdvanced->RxClkTrackEn[1] = value;
		break;
	case 245:
		pUserInputAdvanced->RxClkTrackEn[2] = value;
		break;
	case 246:
		pUserInputAdvanced->RxClkTrackEn[3] = value;
		break;
	case 247:
		pUserInputAdvanced->RxClkTrackEn[4] = value;
		break;
	case 248:
		pUserInputAdvanced->RxClkTrackEn[5] = value;
		break;
	case 249:
		pUserInputAdvanced->RxClkTrackEn[6] = value;
		break;
	case 250:
		pUserInputAdvanced->RxClkTrackEn[7] = value;
		break;
	case 251:
		pUserInputAdvanced->RxClkTrackEn[8] = value;
		break;
	case 252:
		pUserInputAdvanced->RxClkTrackEn[9] = value;
		break;
	case 253:
		pUserInputAdvanced->RxClkTrackEn[10] = value;
		break;
	case 254:
		pUserInputAdvanced->RxClkTrackEn[11] = value;
		break;
	case 255:
		pUserInputAdvanced->RxClkTrackEn[12] = value;
		break;
	case 256:
		pUserInputAdvanced->RxClkTrackEn[13] = value;
		break;
	case 257:
		pUserInputAdvanced->RxClkTrackEn[14] = value;
		break;
	case 258:
		pUserInputAdvanced->TxSlewFallDqs[0] = value;
		break;
	case 259:
		pUserInputAdvanced->TxSlewFallDqs[1] = value;
		break;
	case 260:
		pUserInputAdvanced->TxSlewFallDqs[2] = value;
		break;
	case 261:
		pUserInputAdvanced->TxSlewFallDqs[3] = value;
		break;
	case 262:
		pUserInputAdvanced->TxSlewFallDqs[4] = value;
		break;
	case 263:
		pUserInputAdvanced->TxSlewFallDqs[5] = value;
		break;
	case 264:
		pUserInputAdvanced->TxSlewFallDqs[6] = value;
		break;
	case 265:
		pUserInputAdvanced->TxSlewFallDqs[7] = value;
		break;
	case 266:
		pUserInputAdvanced->TxSlewFallDqs[8] = value;
		break;
	case 267:
		pUserInputAdvanced->TxSlewFallDqs[9] = value;
		break;
	case 268:
		pUserInputAdvanced->TxSlewFallDqs[10] = value;
		break;
	case 269:
		pUserInputAdvanced->TxSlewFallDqs[11] = value;
		break;
	case 270:
		pUserInputAdvanced->TxSlewFallDqs[12] = value;
		break;
	case 271:
		pUserInputAdvanced->TxSlewFallDqs[13] = value;
		break;
	case 272:
		pUserInputAdvanced->TxSlewFallDqs[14] = value;
		break;
	case 273:
		pUserInputAdvanced->TxImpedanceAc[0] = value;
		break;
	case 274:
		pUserInputAdvanced->TxImpedanceAc[1] = value;
		break;
	case 275:
		pUserInputAdvanced->TxImpedanceAc[2] = value;
		break;
	case 276:
		pUserInputAdvanced->TxImpedanceAc[3] = value;
		break;
	case 277:
		pUserInputAdvanced->TxImpedanceAc[4] = value;
		break;
	case 278:
		pUserInputAdvanced->TxImpedanceAc[5] = value;
		break;
	case 279:
		pUserInputAdvanced->TxImpedanceAc[6] = value;
		break;
	case 280:
		pUserInputAdvanced->TxImpedanceAc[7] = value;
		break;
	case 281:
		pUserInputAdvanced->TxImpedanceAc[8] = value;
		break;
	case 282:
		pUserInputAdvanced->TxImpedanceAc[9] = value;
		break;
	case 283:
		pUserInputAdvanced->TxImpedanceAc[10] = value;
		break;
	case 284:
		pUserInputAdvanced->TxImpedanceAc[11] = value;
		break;
	case 285:
		pUserInputAdvanced->TxImpedanceAc[12] = value;
		break;
	case 286:
		pUserInputAdvanced->TxImpedanceAc[13] = value;
		break;
	case 287:
		pUserInputAdvanced->TxImpedanceAc[14] = value;
		break;
	case 288:
		pUserInputAdvanced->CkDisVal[0] = value;
		break;
	case 289:
		pUserInputAdvanced->CkDisVal[1] = value;
		break;
	case 290:
		pUserInputAdvanced->CkDisVal[2] = value;
		break;
	case 291:
		pUserInputAdvanced->CkDisVal[3] = value;
		break;
	case 292:
		pUserInputAdvanced->CkDisVal[4] = value;
		break;
	case 293:
		pUserInputAdvanced->CkDisVal[5] = value;
		break;
	case 294:
		pUserInputAdvanced->CkDisVal[6] = value;
		break;
	case 295:
		pUserInputAdvanced->CkDisVal[7] = value;
		break;
	case 296:
		pUserInputAdvanced->CkDisVal[8] = value;
		break;
	case 297:
		pUserInputAdvanced->CkDisVal[9] = value;
		break;
	case 298:
		pUserInputAdvanced->CkDisVal[10] = value;
		break;
	case 299:
		pUserInputAdvanced->CkDisVal[11] = value;
		break;
	case 300:
		pUserInputAdvanced->CkDisVal[12] = value;
		break;
	case 301:
		pUserInputAdvanced->CkDisVal[13] = value;
		break;
	case 302:
		pUserInputAdvanced->CkDisVal[14] = value;
		break;
	case 303:
		pUserInputAdvanced->PhyMstrMaxReqToAck[0] = value;
		break;
	case 304:
		pUserInputAdvanced->PhyMstrMaxReqToAck[1] = value;
		break;
	case 305:
		pUserInputAdvanced->PhyMstrMaxReqToAck[2] = value;
		break;
	case 306:
		pUserInputAdvanced->PhyMstrMaxReqToAck[3] = value;
		break;
	case 307:
		pUserInputAdvanced->PhyMstrMaxReqToAck[4] = value;
		break;
	case 308:
		pUserInputAdvanced->PhyMstrMaxReqToAck[5] = value;
		break;
	case 309:
		pUserInputAdvanced->PhyMstrMaxReqToAck[6] = value;
		break;
	case 310:
		pUserInputAdvanced->PhyMstrMaxReqToAck[7] = value;
		break;
	case 311:
		pUserInputAdvanced->PhyMstrMaxReqToAck[8] = value;
		break;
	case 312:
		pUserInputAdvanced->PhyMstrMaxReqToAck[9] = value;
		break;
	case 313:
		pUserInputAdvanced->PhyMstrMaxReqToAck[10] = value;
		break;
	case 314:
		pUserInputAdvanced->PhyMstrMaxReqToAck[11] = value;
		break;
	case 315:
		pUserInputAdvanced->PhyMstrMaxReqToAck[12] = value;
		break;
	case 316:
		pUserInputAdvanced->PhyMstrMaxReqToAck[13] = value;
		break;
	case 317:
		pUserInputAdvanced->PhyMstrMaxReqToAck[14] = value;
		break;
	case 318:
		pUserInputAdvanced->TxImpedanceDqs[0] = value;
		break;
	case 319:
		pUserInputAdvanced->TxImpedanceDqs[1] = value;
		break;
	case 320:
		pUserInputAdvanced->TxImpedanceDqs[2] = value;
		break;
	case 321:
		pUserInputAdvanced->TxImpedanceDqs[3] = value;
		break;
	case 322:
		pUserInputAdvanced->TxImpedanceDqs[4] = value;
		break;
	case 323:
		pUserInputAdvanced->TxImpedanceDqs[5] = value;
		break;
	case 324:
		pUserInputAdvanced->TxImpedanceDqs[6] = value;
		break;
	case 325:
		pUserInputAdvanced->TxImpedanceDqs[7] = value;
		break;
	case 326:
		pUserInputAdvanced->TxImpedanceDqs[8] = value;
		break;
	case 327:
		pUserInputAdvanced->TxImpedanceDqs[9] = value;
		break;
	case 328:
		pUserInputAdvanced->TxImpedanceDqs[10] = value;
		break;
	case 329:
		pUserInputAdvanced->TxImpedanceDqs[11] = value;
		break;
	case 330:
		pUserInputAdvanced->TxImpedanceDqs[12] = value;
		break;
	case 331:
		pUserInputAdvanced->TxImpedanceDqs[13] = value;
		break;
	case 332:
		pUserInputAdvanced->TxImpedanceDqs[14] = value;
		break;
	case 333:
		pUserInputAdvanced->RxDqsTrackingThreshold[0] = value;
		break;
	case 334:
		pUserInputAdvanced->RxDqsTrackingThreshold[1] = value;
		break;
	case 335:
		pUserInputAdvanced->RxDqsTrackingThreshold[2] = value;
		break;
	case 336:
		pUserInputAdvanced->RxDqsTrackingThreshold[3] = value;
		break;
	case 337:
		pUserInputAdvanced->RxDqsTrackingThreshold[4] = value;
		break;
	case 338:
		pUserInputAdvanced->RxDqsTrackingThreshold[5] = value;
		break;
	case 339:
		pUserInputAdvanced->RxDqsTrackingThreshold[6] = value;
		break;
	case 340:
		pUserInputAdvanced->RxDqsTrackingThreshold[7] = value;
		break;
	case 341:
		pUserInputAdvanced->RxDqsTrackingThreshold[8] = value;
		break;
	case 342:
		pUserInputAdvanced->RxDqsTrackingThreshold[9] = value;
		break;
	case 343:
		pUserInputAdvanced->RxDqsTrackingThreshold[10] = value;
		break;
	case 344:
		pUserInputAdvanced->RxDqsTrackingThreshold[11] = value;
		break;
	case 345:
		pUserInputAdvanced->RxDqsTrackingThreshold[12] = value;
		break;
	case 346:
		pUserInputAdvanced->RxDqsTrackingThreshold[13] = value;
		break;
	case 347:
		pUserInputAdvanced->RxDqsTrackingThreshold[14] = value;
		break;
	case 348:
		pUserInputAdvanced->DisableTDRAccess = value;
		break;
	case 349:
		pUserInputAdvanced->DisableRetraining = value;
		break;
	case 350:
		pUserInputAdvanced->TxSlewFallDq[0] = value;
		break;
	case 351:
		pUserInputAdvanced->TxSlewFallDq[1] = value;
		break;
	case 352:
		pUserInputAdvanced->TxSlewFallDq[2] = value;
		break;
	case 353:
		pUserInputAdvanced->TxSlewFallDq[3] = value;
		break;
	case 354:
		pUserInputAdvanced->TxSlewFallDq[4] = value;
		break;
	case 355:
		pUserInputAdvanced->TxSlewFallDq[5] = value;
		break;
	case 356:
		pUserInputAdvanced->TxSlewFallDq[6] = value;
		break;
	case 357:
		pUserInputAdvanced->TxSlewFallDq[7] = value;
		break;
	case 358:
		pUserInputAdvanced->TxSlewFallDq[8] = value;
		break;
	case 359:
		pUserInputAdvanced->TxSlewFallDq[9] = value;
		break;
	case 360:
		pUserInputAdvanced->TxSlewFallDq[10] = value;
		break;
	case 361:
		pUserInputAdvanced->TxSlewFallDq[11] = value;
		break;
	case 362:
		pUserInputAdvanced->TxSlewFallDq[12] = value;
		break;
	case 363:
		pUserInputAdvanced->TxSlewFallDq[13] = value;
		break;
	case 364:
		pUserInputAdvanced->TxSlewFallDq[14] = value;
		break;
	case 365:
		pUserInputAdvanced->DisablePmuEcc = value;
		break;
	case 366:
		pUserInputAdvanced->ExtCalResVal = value;
		break;
	case 367:
		pUserInputAdvanced->TxImpedanceWCK[0] = value;
		break;
	case 368:
		pUserInputAdvanced->TxImpedanceWCK[1] = value;
		break;
	case 369:
		pUserInputAdvanced->TxImpedanceWCK[2] = value;
		break;
	case 370:
		pUserInputAdvanced->TxImpedanceWCK[3] = value;
		break;
	case 371:
		pUserInputAdvanced->TxImpedanceWCK[4] = value;
		break;
	case 372:
		pUserInputAdvanced->TxImpedanceWCK[5] = value;
		break;
	case 373:
		pUserInputAdvanced->TxImpedanceWCK[6] = value;
		break;
	case 374:
		pUserInputAdvanced->TxImpedanceWCK[7] = value;
		break;
	case 375:
		pUserInputAdvanced->TxImpedanceWCK[8] = value;
		break;
	case 376:
		pUserInputAdvanced->TxImpedanceWCK[9] = value;
		break;
	case 377:
		pUserInputAdvanced->TxImpedanceWCK[10] = value;
		break;
	case 378:
		pUserInputAdvanced->TxImpedanceWCK[11] = value;
		break;
	case 379:
		pUserInputAdvanced->TxImpedanceWCK[12] = value;
		break;
	case 380:
		pUserInputAdvanced->TxImpedanceWCK[13] = value;
		break;
	case 381:
		pUserInputAdvanced->TxImpedanceWCK[14] = value;
		break;
	case 382:
		pUserInputAdvanced->TxSlewRiseDqs[0] = value;
		break;
	case 383:
		pUserInputAdvanced->TxSlewRiseDqs[1] = value;
		break;
	case 384:
		pUserInputAdvanced->TxSlewRiseDqs[2] = value;
		break;
	case 385:
		pUserInputAdvanced->TxSlewRiseDqs[3] = value;
		break;
	case 386:
		pUserInputAdvanced->TxSlewRiseDqs[4] = value;
		break;
	case 387:
		pUserInputAdvanced->TxSlewRiseDqs[5] = value;
		break;
	case 388:
		pUserInputAdvanced->TxSlewRiseDqs[6] = value;
		break;
	case 389:
		pUserInputAdvanced->TxSlewRiseDqs[7] = value;
		break;
	case 390:
		pUserInputAdvanced->TxSlewRiseDqs[8] = value;
		break;
	case 391:
		pUserInputAdvanced->TxSlewRiseDqs[9] = value;
		break;
	case 392:
		pUserInputAdvanced->TxSlewRiseDqs[10] = value;
		break;
	case 393:
		pUserInputAdvanced->TxSlewRiseDqs[11] = value;
		break;
	case 394:
		pUserInputAdvanced->TxSlewRiseDqs[12] = value;
		break;
	case 395:
		pUserInputAdvanced->TxSlewRiseDqs[13] = value;
		break;
	case 396:
		pUserInputAdvanced->TxSlewRiseDqs[14] = value;
		break;
	case 397:
		pUserInputAdvanced->TxSlewRiseWCK[0] = value;
		break;
	case 398:
		pUserInputAdvanced->TxSlewRiseWCK[1] = value;
		break;
	case 399:
		pUserInputAdvanced->TxSlewRiseWCK[2] = value;
		break;
	case 400:
		pUserInputAdvanced->TxSlewRiseWCK[3] = value;
		break;
	case 401:
		pUserInputAdvanced->TxSlewRiseWCK[4] = value;
		break;
	case 402:
		pUserInputAdvanced->TxSlewRiseWCK[5] = value;
		break;
	case 403:
		pUserInputAdvanced->TxSlewRiseWCK[6] = value;
		break;
	case 404:
		pUserInputAdvanced->TxSlewRiseWCK[7] = value;
		break;
	case 405:
		pUserInputAdvanced->TxSlewRiseWCK[8] = value;
		break;
	case 406:
		pUserInputAdvanced->TxSlewRiseWCK[9] = value;
		break;
	case 407:
		pUserInputAdvanced->TxSlewRiseWCK[10] = value;
		break;
	case 408:
		pUserInputAdvanced->TxSlewRiseWCK[11] = value;
		break;
	case 409:
		pUserInputAdvanced->TxSlewRiseWCK[12] = value;
		break;
	case 410:
		pUserInputAdvanced->TxSlewRiseWCK[13] = value;
		break;
	case 411:
		pUserInputAdvanced->TxSlewRiseWCK[14] = value;
		break;
	case 412:
		pUserInputAdvanced->RxBiasCurrentControlDqs[0] = value;
		break;
	case 413:
		pUserInputAdvanced->RxBiasCurrentControlDqs[1] = value;
		break;
	case 414:
		pUserInputAdvanced->RxBiasCurrentControlDqs[2] = value;
		break;
	case 415:
		pUserInputAdvanced->RxBiasCurrentControlDqs[3] = value;
		break;
	case 416:
		pUserInputAdvanced->RxBiasCurrentControlDqs[4] = value;
		break;
	case 417:
		pUserInputAdvanced->RxBiasCurrentControlDqs[5] = value;
		break;
	case 418:
		pUserInputAdvanced->RxBiasCurrentControlDqs[6] = value;
		break;
	case 419:
		pUserInputAdvanced->RxBiasCurrentControlDqs[7] = value;
		break;
	case 420:
		pUserInputAdvanced->RxBiasCurrentControlDqs[8] = value;
		break;
	case 421:
		pUserInputAdvanced->RxBiasCurrentControlDqs[9] = value;
		break;
	case 422:
		pUserInputAdvanced->RxBiasCurrentControlDqs[10] = value;
		break;
	case 423:
		pUserInputAdvanced->RxBiasCurrentControlDqs[11] = value;
		break;
	case 424:
		pUserInputAdvanced->RxBiasCurrentControlDqs[12] = value;
		break;
	case 425:
		pUserInputAdvanced->RxBiasCurrentControlDqs[13] = value;
		break;
	case 426:
		pUserInputAdvanced->RxBiasCurrentControlDqs[14] = value;
		break;
	case 427:
		pUserInputAdvanced->RxClkTrackWait = value;
		break;
	case 428:
		pUserInputAdvanced->CalOnce = value;
		break;
	case 429:
		pUserInputAdvanced->PhyMstrCtrlMode[0] = value;
		break;
	case 430:
		pUserInputAdvanced->PhyMstrCtrlMode[1] = value;
		break;
	case 431:
		pUserInputAdvanced->PhyMstrCtrlMode[2] = value;
		break;
	case 432:
		pUserInputAdvanced->PhyMstrCtrlMode[3] = value;
		break;
	case 433:
		pUserInputAdvanced->PhyMstrCtrlMode[4] = value;
		break;
	case 434:
		pUserInputAdvanced->PhyMstrCtrlMode[5] = value;
		break;
	case 435:
		pUserInputAdvanced->PhyMstrCtrlMode[6] = value;
		break;
	case 436:
		pUserInputAdvanced->PhyMstrCtrlMode[7] = value;
		break;
	case 437:
		pUserInputAdvanced->PhyMstrCtrlMode[8] = value;
		break;
	case 438:
		pUserInputAdvanced->PhyMstrCtrlMode[9] = value;
		break;
	case 439:
		pUserInputAdvanced->PhyMstrCtrlMode[10] = value;
		break;
	case 440:
		pUserInputAdvanced->PhyMstrCtrlMode[11] = value;
		break;
	case 441:
		pUserInputAdvanced->PhyMstrCtrlMode[12] = value;
		break;
	case 442:
		pUserInputAdvanced->PhyMstrCtrlMode[13] = value;
		break;
	case 443:
		pUserInputAdvanced->PhyMstrCtrlMode[14] = value;
		break;
	case 444:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[0] = value;
		break;
	case 445:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[1] = value;
		break;
	case 446:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[2] = value;
		break;
	case 447:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[3] = value;
		break;
	case 448:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[4] = value;
		break;
	case 449:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[5] = value;
		break;
	case 450:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[6] = value;
		break;
	case 451:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[7] = value;
		break;
	case 452:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[8] = value;
		break;
	case 453:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[9] = value;
		break;
	case 454:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[10] = value;
		break;
	case 455:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[11] = value;
		break;
	case 456:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[12] = value;
		break;
	case 457:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[13] = value;
		break;
	case 458:
		pUserInputAdvanced->RxVrefKickbackNoiseCancellation[14] = value;
		break;
	case 459:
		pUserInputAdvanced->RxClkTrackWaitUI = value;
		break;
	case 460:
		pUserInputAdvanced->TxImpedanceDq[0] = value;
		break;
	case 461:
		pUserInputAdvanced->TxImpedanceDq[1] = value;
		break;
	case 462:
		pUserInputAdvanced->TxImpedanceDq[2] = value;
		break;
	case 463:
		pUserInputAdvanced->TxImpedanceDq[3] = value;
		break;
	case 464:
		pUserInputAdvanced->TxImpedanceDq[4] = value;
		break;
	case 465:
		pUserInputAdvanced->TxImpedanceDq[5] = value;
		break;
	case 466:
		pUserInputAdvanced->TxImpedanceDq[6] = value;
		break;
	case 467:
		pUserInputAdvanced->TxImpedanceDq[7] = value;
		break;
	case 468:
		pUserInputAdvanced->TxImpedanceDq[8] = value;
		break;
	case 469:
		pUserInputAdvanced->TxImpedanceDq[9] = value;
		break;
	case 470:
		pUserInputAdvanced->TxImpedanceDq[10] = value;
		break;
	case 471:
		pUserInputAdvanced->TxImpedanceDq[11] = value;
		break;
	case 472:
		pUserInputAdvanced->TxImpedanceDq[12] = value;
		break;
	case 473:
		pUserInputAdvanced->TxImpedanceDq[13] = value;
		break;
	case 474:
		pUserInputAdvanced->TxImpedanceDq[14] = value;
		break;
	case 475:
		pUserInputAdvanced->OnlyRestoreNonPsRegs = value;
		break;
	case 476:
		pUserInputAdvanced->TrainSequenceCtrl = value;
		break;
	case 477:
		pUserInputAdvanced->TxImpedanceCk[0] = value;
		break;
	case 478:
		pUserInputAdvanced->TxImpedanceCk[1] = value;
		break;
	case 479:
		pUserInputAdvanced->TxImpedanceCk[2] = value;
		break;
	case 480:
		pUserInputAdvanced->TxImpedanceCk[3] = value;
		break;
	case 481:
		pUserInputAdvanced->TxImpedanceCk[4] = value;
		break;
	case 482:
		pUserInputAdvanced->TxImpedanceCk[5] = value;
		break;
	case 483:
		pUserInputAdvanced->TxImpedanceCk[6] = value;
		break;
	case 484:
		pUserInputAdvanced->TxImpedanceCk[7] = value;
		break;
	case 485:
		pUserInputAdvanced->TxImpedanceCk[8] = value;
		break;
	case 486:
		pUserInputAdvanced->TxImpedanceCk[9] = value;
		break;
	case 487:
		pUserInputAdvanced->TxImpedanceCk[10] = value;
		break;
	case 488:
		pUserInputAdvanced->TxImpedanceCk[11] = value;
		break;
	case 489:
		pUserInputAdvanced->TxImpedanceCk[12] = value;
		break;
	case 490:
		pUserInputAdvanced->TxImpedanceCk[13] = value;
		break;
	case 491:
		pUserInputAdvanced->TxImpedanceCk[14] = value;
		break;
	case 492:
		pUserInputAdvanced->DisableFspOp = value;
		break;
	case 493:
		pUserInputAdvanced->TxImpedanceDTO[0] = value;
		break;
	case 494:
		pUserInputAdvanced->TxImpedanceDTO[1] = value;
		break;
	case 495:
		pUserInputAdvanced->TxImpedanceDTO[2] = value;
		break;
	case 496:
		pUserInputAdvanced->TxImpedanceDTO[3] = value;
		break;
	case 497:
		pUserInputAdvanced->TxImpedanceDTO[4] = value;
		break;
	case 498:
		pUserInputAdvanced->TxImpedanceDTO[5] = value;
		break;
	case 499:
		pUserInputAdvanced->TxImpedanceDTO[6] = value;
		break;
	case 500:
		pUserInputAdvanced->TxImpedanceDTO[7] = value;
		break;
	case 501:
		pUserInputAdvanced->TxImpedanceDTO[8] = value;
		break;
	case 502:
		pUserInputAdvanced->TxImpedanceDTO[9] = value;
		break;
	case 503:
		pUserInputAdvanced->TxImpedanceDTO[10] = value;
		break;
	case 504:
		pUserInputAdvanced->TxImpedanceDTO[11] = value;
		break;
	case 505:
		pUserInputAdvanced->TxImpedanceDTO[12] = value;
		break;
	case 506:
		pUserInputAdvanced->TxImpedanceDTO[13] = value;
		break;
	case 507:
		pUserInputAdvanced->TxImpedanceDTO[14] = value;
		break;
	case 508:
		pUserInputAdvanced->EnRxDqsTracking[0] = value;
		break;
	case 509:
		pUserInputAdvanced->EnRxDqsTracking[1] = value;
		break;
	case 510:
		pUserInputAdvanced->EnRxDqsTracking[2] = value;
		break;
	case 511:
		pUserInputAdvanced->EnRxDqsTracking[3] = value;
		break;
	case 512:
		pUserInputAdvanced->EnRxDqsTracking[4] = value;
		break;
	case 513:
		pUserInputAdvanced->EnRxDqsTracking[5] = value;
		break;
	case 514:
		pUserInputAdvanced->EnRxDqsTracking[6] = value;
		break;
	case 515:
		pUserInputAdvanced->EnRxDqsTracking[7] = value;
		break;
	case 516:
		pUserInputAdvanced->EnRxDqsTracking[8] = value;
		break;
	case 517:
		pUserInputAdvanced->EnRxDqsTracking[9] = value;
		break;
	case 518:
		pUserInputAdvanced->EnRxDqsTracking[10] = value;
		break;
	case 519:
		pUserInputAdvanced->EnRxDqsTracking[11] = value;
		break;
	case 520:
		pUserInputAdvanced->EnRxDqsTracking[12] = value;
		break;
	case 521:
		pUserInputAdvanced->EnRxDqsTracking[13] = value;
		break;
	case 522:
		pUserInputAdvanced->EnRxDqsTracking[14] = value;
		break;
	case 523:
		pUserInputAdvanced->CalInterval = value;
		break;
	case 524:
		pUserInputAdvanced->RxBiasCurrentControlWck[0] = value;
		break;
	case 525:
		pUserInputAdvanced->RxBiasCurrentControlWck[1] = value;
		break;
	case 526:
		pUserInputAdvanced->RxBiasCurrentControlWck[2] = value;
		break;
	case 527:
		pUserInputAdvanced->RxBiasCurrentControlWck[3] = value;
		break;
	case 528:
		pUserInputAdvanced->RxBiasCurrentControlWck[4] = value;
		break;
	case 529:
		pUserInputAdvanced->RxBiasCurrentControlWck[5] = value;
		break;
	case 530:
		pUserInputAdvanced->RxBiasCurrentControlWck[6] = value;
		break;
	case 531:
		pUserInputAdvanced->RxBiasCurrentControlWck[7] = value;
		break;
	case 532:
		pUserInputAdvanced->RxBiasCurrentControlWck[8] = value;
		break;
	case 533:
		pUserInputAdvanced->RxBiasCurrentControlWck[9] = value;
		break;
	case 534:
		pUserInputAdvanced->RxBiasCurrentControlWck[10] = value;
		break;
	case 535:
		pUserInputAdvanced->RxBiasCurrentControlWck[11] = value;
		break;
	case 536:
		pUserInputAdvanced->RxBiasCurrentControlWck[12] = value;
		break;
	case 537:
		pUserInputAdvanced->RxBiasCurrentControlWck[13] = value;
		break;
	case 538:
		pUserInputAdvanced->RxBiasCurrentControlWck[14] = value;
		break;
	case 539:
		pUserInputAdvanced->RetrainMode[0] = value;
		break;
	case 540:
		pUserInputAdvanced->RetrainMode[1] = value;
		break;
	case 541:
		pUserInputAdvanced->RetrainMode[2] = value;
		break;
	case 542:
		pUserInputAdvanced->RetrainMode[3] = value;
		break;
	case 543:
		pUserInputAdvanced->RetrainMode[4] = value;
		break;
	case 544:
		pUserInputAdvanced->RetrainMode[5] = value;
		break;
	case 545:
		pUserInputAdvanced->RetrainMode[6] = value;
		break;
	case 546:
		pUserInputAdvanced->RetrainMode[7] = value;
		break;
	case 547:
		pUserInputAdvanced->RetrainMode[8] = value;
		break;
	case 548:
		pUserInputAdvanced->RetrainMode[9] = value;
		break;
	case 549:
		pUserInputAdvanced->RetrainMode[10] = value;
		break;
	case 550:
		pUserInputAdvanced->RetrainMode[11] = value;
		break;
	case 551:
		pUserInputAdvanced->RetrainMode[12] = value;
		break;
	case 552:
		pUserInputAdvanced->RetrainMode[13] = value;
		break;
	case 553:
		pUserInputAdvanced->RetrainMode[14] = value;
		break;
	case 554:
		pUserInputAdvanced->RxVrefDACEnable[0] = value;
		break;
	case 555:
		pUserInputAdvanced->RxVrefDACEnable[1] = value;
		break;
	case 556:
		pUserInputAdvanced->RxVrefDACEnable[2] = value;
		break;
	case 557:
		pUserInputAdvanced->RxVrefDACEnable[3] = value;
		break;
	case 558:
		pUserInputAdvanced->RxVrefDACEnable[4] = value;
		break;
	case 559:
		pUserInputAdvanced->RxVrefDACEnable[5] = value;
		break;
	case 560:
		pUserInputAdvanced->RxVrefDACEnable[6] = value;
		break;
	case 561:
		pUserInputAdvanced->RxVrefDACEnable[7] = value;
		break;
	case 562:
		pUserInputAdvanced->RxVrefDACEnable[8] = value;
		break;
	case 563:
		pUserInputAdvanced->RxVrefDACEnable[9] = value;
		break;
	case 564:
		pUserInputAdvanced->RxVrefDACEnable[10] = value;
		break;
	case 565:
		pUserInputAdvanced->RxVrefDACEnable[11] = value;
		break;
	case 566:
		pUserInputAdvanced->RxVrefDACEnable[12] = value;
		break;
	case 567:
		pUserInputAdvanced->RxVrefDACEnable[13] = value;
		break;
	case 568:
		pUserInputAdvanced->RxVrefDACEnable[14] = value;
		break;
	case 569:
		pUserInputAdvanced->PhyMstrTrainInterval[0] = value;
		break;
	case 570:
		pUserInputAdvanced->PhyMstrTrainInterval[1] = value;
		break;
	case 571:
		pUserInputAdvanced->PhyMstrTrainInterval[2] = value;
		break;
	case 572:
		pUserInputAdvanced->PhyMstrTrainInterval[3] = value;
		break;
	case 573:
		pUserInputAdvanced->PhyMstrTrainInterval[4] = value;
		break;
	case 574:
		pUserInputAdvanced->PhyMstrTrainInterval[5] = value;
		break;
	case 575:
		pUserInputAdvanced->PhyMstrTrainInterval[6] = value;
		break;
	case 576:
		pUserInputAdvanced->PhyMstrTrainInterval[7] = value;
		break;
	case 577:
		pUserInputAdvanced->PhyMstrTrainInterval[8] = value;
		break;
	case 578:
		pUserInputAdvanced->PhyMstrTrainInterval[9] = value;
		break;
	case 579:
		pUserInputAdvanced->PhyMstrTrainInterval[10] = value;
		break;
	case 580:
		pUserInputAdvanced->PhyMstrTrainInterval[11] = value;
		break;
	case 581:
		pUserInputAdvanced->PhyMstrTrainInterval[12] = value;
		break;
	case 582:
		pUserInputAdvanced->PhyMstrTrainInterval[13] = value;
		break;
	case 583:
		pUserInputAdvanced->PhyMstrTrainInterval[14] = value;
		break;
	case 584:
		pUserInputAdvanced->Lp3DramState[0] = value;
		break;
	case 585:
		pUserInputAdvanced->Lp3DramState[1] = value;
		break;
	case 586:
		pUserInputAdvanced->Lp3DramState[2] = value;
		break;
	case 587:
		pUserInputAdvanced->Lp3DramState[3] = value;
		break;
	case 588:
		pUserInputAdvanced->Lp3DramState[4] = value;
		break;
	case 589:
		pUserInputAdvanced->Lp3DramState[5] = value;
		break;
	case 590:
		pUserInputAdvanced->Lp3DramState[6] = value;
		break;
	case 591:
		pUserInputAdvanced->Lp3DramState[7] = value;
		break;
	case 592:
		pUserInputAdvanced->Lp3DramState[8] = value;
		break;
	case 593:
		pUserInputAdvanced->Lp3DramState[9] = value;
		break;
	case 594:
		pUserInputAdvanced->Lp3DramState[10] = value;
		break;
	case 595:
		pUserInputAdvanced->Lp3DramState[11] = value;
		break;
	case 596:
		pUserInputAdvanced->Lp3DramState[12] = value;
		break;
	case 597:
		pUserInputAdvanced->Lp3DramState[13] = value;
		break;
	case 598:
		pUserInputAdvanced->Lp3DramState[14] = value;
		break;
	case 599:
		pUserInputAdvanced->PmuClockDiv[0] = value;
		break;
	case 600:
		pUserInputAdvanced->PmuClockDiv[1] = value;
		break;
	case 601:
		pUserInputAdvanced->PmuClockDiv[2] = value;
		break;
	case 602:
		pUserInputAdvanced->PmuClockDiv[3] = value;
		break;
	case 603:
		pUserInputAdvanced->PmuClockDiv[4] = value;
		break;
	case 604:
		pUserInputAdvanced->PmuClockDiv[5] = value;
		break;
	case 605:
		pUserInputAdvanced->PmuClockDiv[6] = value;
		break;
	case 606:
		pUserInputAdvanced->PmuClockDiv[7] = value;
		break;
	case 607:
		pUserInputAdvanced->PmuClockDiv[8] = value;
		break;
	case 608:
		pUserInputAdvanced->PmuClockDiv[9] = value;
		break;
	case 609:
		pUserInputAdvanced->PmuClockDiv[10] = value;
		break;
	case 610:
		pUserInputAdvanced->PmuClockDiv[11] = value;
		break;
	case 611:
		pUserInputAdvanced->PmuClockDiv[12] = value;
		break;
	case 612:
		pUserInputAdvanced->PmuClockDiv[13] = value;
		break;
	case 613:
		pUserInputAdvanced->PmuClockDiv[14] = value;
		break;
	case 614:
		pUserInputAdvanced->WDQSExt = value;
		break;
	case 615:
		pUserInputAdvanced->DisablePhyUpdate = value;
		break;
	case 616:
		pUserInputAdvanced->OdtImpedanceCa[0] = value;
		break;
	case 617:
		pUserInputAdvanced->OdtImpedanceCa[1] = value;
		break;
	case 618:
		pUserInputAdvanced->OdtImpedanceCa[2] = value;
		break;
	case 619:
		pUserInputAdvanced->OdtImpedanceCa[3] = value;
		break;
	case 620:
		pUserInputAdvanced->OdtImpedanceCa[4] = value;
		break;
	case 621:
		pUserInputAdvanced->OdtImpedanceCa[5] = value;
		break;
	case 622:
		pUserInputAdvanced->OdtImpedanceCa[6] = value;
		break;
	case 623:
		pUserInputAdvanced->OdtImpedanceCa[7] = value;
		break;
	case 624:
		pUserInputAdvanced->OdtImpedanceCa[8] = value;
		break;
	case 625:
		pUserInputAdvanced->OdtImpedanceCa[9] = value;
		break;
	case 626:
		pUserInputAdvanced->OdtImpedanceCa[10] = value;
		break;
	case 627:
		pUserInputAdvanced->OdtImpedanceCa[11] = value;
		break;
	case 628:
		pUserInputAdvanced->OdtImpedanceCa[12] = value;
		break;
	case 629:
		pUserInputAdvanced->OdtImpedanceCa[13] = value;
		break;
	case 630:
		pUserInputAdvanced->OdtImpedanceCa[14] = value;
		break;
	case 631:
		pUserInputAdvanced->SkipFlashCopy[0] = value;
		break;
	case 632:
		pUserInputAdvanced->SkipFlashCopy[1] = value;
		break;
	case 633:
		pUserInputAdvanced->SkipFlashCopy[2] = value;
		break;
	case 634:
		pUserInputAdvanced->SkipFlashCopy[3] = value;
		break;
	case 635:
		pUserInputAdvanced->SkipFlashCopy[4] = value;
		break;
	case 636:
		pUserInputAdvanced->SkipFlashCopy[5] = value;
		break;
	case 637:
		pUserInputAdvanced->SkipFlashCopy[6] = value;
		break;
	case 638:
		pUserInputAdvanced->SkipFlashCopy[7] = value;
		break;
	case 639:
		pUserInputAdvanced->SkipFlashCopy[8] = value;
		break;
	case 640:
		pUserInputAdvanced->SkipFlashCopy[9] = value;
		break;
	case 641:
		pUserInputAdvanced->SkipFlashCopy[10] = value;
		break;
	case 642:
		pUserInputAdvanced->SkipFlashCopy[11] = value;
		break;
	case 643:
		pUserInputAdvanced->SkipFlashCopy[12] = value;
		break;
	case 644:
		pUserInputAdvanced->SkipFlashCopy[13] = value;
		break;
	case 645:
		pUserInputAdvanced->SkipFlashCopy[14] = value;
		break;
	case 646:
		pUserInputAdvanced->DqsOscRunTimeSel[0] = value;
		break;
	case 647:
		pUserInputAdvanced->DqsOscRunTimeSel[1] = value;
		break;
	case 648:
		pUserInputAdvanced->DqsOscRunTimeSel[2] = value;
		break;
	case 649:
		pUserInputAdvanced->DqsOscRunTimeSel[3] = value;
		break;
	case 650:
		pUserInputAdvanced->DqsOscRunTimeSel[4] = value;
		break;
	case 651:
		pUserInputAdvanced->DqsOscRunTimeSel[5] = value;
		break;
	case 652:
		pUserInputAdvanced->DqsOscRunTimeSel[6] = value;
		break;
	case 653:
		pUserInputAdvanced->DqsOscRunTimeSel[7] = value;
		break;
	case 654:
		pUserInputAdvanced->DqsOscRunTimeSel[8] = value;
		break;
	case 655:
		pUserInputAdvanced->DqsOscRunTimeSel[9] = value;
		break;
	case 656:
		pUserInputAdvanced->DqsOscRunTimeSel[10] = value;
		break;
	case 657:
		pUserInputAdvanced->DqsOscRunTimeSel[11] = value;
		break;
	case 658:
		pUserInputAdvanced->DqsOscRunTimeSel[12] = value;
		break;
	case 659:
		pUserInputAdvanced->DqsOscRunTimeSel[13] = value;
		break;
	case 660:
		pUserInputAdvanced->DqsOscRunTimeSel[14] = value;
		break;
	case 661:
		pUserInputAdvanced->RxBiasCurrentControlCk[0] = value;
		break;
	case 662:
		pUserInputAdvanced->RxBiasCurrentControlCk[1] = value;
		break;
	case 663:
		pUserInputAdvanced->RxBiasCurrentControlCk[2] = value;
		break;
	case 664:
		pUserInputAdvanced->RxBiasCurrentControlCk[3] = value;
		break;
	case 665:
		pUserInputAdvanced->RxBiasCurrentControlCk[4] = value;
		break;
	case 666:
		pUserInputAdvanced->RxBiasCurrentControlCk[5] = value;
		break;
	case 667:
		pUserInputAdvanced->RxBiasCurrentControlCk[6] = value;
		break;
	case 668:
		pUserInputAdvanced->RxBiasCurrentControlCk[7] = value;
		break;
	case 669:
		pUserInputAdvanced->RxBiasCurrentControlCk[8] = value;
		break;
	case 670:
		pUserInputAdvanced->RxBiasCurrentControlCk[9] = value;
		break;
	case 671:
		pUserInputAdvanced->RxBiasCurrentControlCk[10] = value;
		break;
	case 672:
		pUserInputAdvanced->RxBiasCurrentControlCk[11] = value;
		break;
	case 673:
		pUserInputAdvanced->RxBiasCurrentControlCk[12] = value;
		break;
	case 674:
		pUserInputAdvanced->RxBiasCurrentControlCk[13] = value;
		break;
	case 675:
		pUserInputAdvanced->RxBiasCurrentControlCk[14] = value;
		break;
	case 676:
		pUserInputBasic->NumPStates = value;
		break;
	case 677:
		pUserInputBasic->NumRank_dfi0 = value;
		break;
	case 678:
		pUserInputBasic->HardMacroVer = value;
		break;
	case 679:
		pUserInputBasic->NumCh = value;
		break;
	case 680:
		pUserInputBasic->DimmType = value;
		break;
	case 681:
		pUserInputBasic->DramType = value;
		break;
	case 682:
		pUserInputBasic->DfiFreqRatio[0] = value;
		break;
	case 683:
		pUserInputBasic->DfiFreqRatio[1] = value;
		break;
	case 684:
		pUserInputBasic->DfiFreqRatio[2] = value;
		break;
	case 685:
		pUserInputBasic->DfiFreqRatio[3] = value;
		break;
	case 686:
		pUserInputBasic->DfiFreqRatio[4] = value;
		break;
	case 687:
		pUserInputBasic->DfiFreqRatio[5] = value;
		break;
	case 688:
		pUserInputBasic->DfiFreqRatio[6] = value;
		break;
	case 689:
		pUserInputBasic->DfiFreqRatio[7] = value;
		break;
	case 690:
		pUserInputBasic->DfiFreqRatio[8] = value;
		break;
	case 691:
		pUserInputBasic->DfiFreqRatio[9] = value;
		break;
	case 692:
		pUserInputBasic->DfiFreqRatio[10] = value;
		break;
	case 693:
		pUserInputBasic->DfiFreqRatio[11] = value;
		break;
	case 694:
		pUserInputBasic->DfiFreqRatio[12] = value;
		break;
	case 695:
		pUserInputBasic->DfiFreqRatio[13] = value;
		break;
	case 696:
		pUserInputBasic->DfiFreqRatio[14] = value;
		break;
	case 697:
		pUserInputBasic->FirstPState = value;
		break;
	case 698:
		pUserInputBasic->NumActiveDbyteDfi1 = value;
		break;
	case 699:
		pUserInputBasic->NumRank = value;
		break;
	case 700:
		pUserInputBasic->DramDataWidth = value;
		break;
	case 701:
		pUserInputBasic->CfgPStates = value;
		break;
	case 702:
		pUserInputBasic->Frequency[0] = value;
		break;
	case 703:
		pUserInputBasic->Frequency[1] = value;
		break;
	case 704:
		pUserInputBasic->Frequency[2] = value;
		break;
	case 705:
		pUserInputBasic->Frequency[3] = value;
		break;
	case 706:
		pUserInputBasic->Frequency[4] = value;
		break;
	case 707:
		pUserInputBasic->Frequency[5] = value;
		break;
	case 708:
		pUserInputBasic->Frequency[6] = value;
		break;
	case 709:
		pUserInputBasic->Frequency[7] = value;
		break;
	case 710:
		pUserInputBasic->Frequency[8] = value;
		break;
	case 711:
		pUserInputBasic->Frequency[9] = value;
		break;
	case 712:
		pUserInputBasic->Frequency[10] = value;
		break;
	case 713:
		pUserInputBasic->Frequency[11] = value;
		break;
	case 714:
		pUserInputBasic->Frequency[12] = value;
		break;
	case 715:
		pUserInputBasic->Frequency[13] = value;
		break;
	case 716:
		pUserInputBasic->Frequency[14] = value;
		break;
	case 717:
		pUserInputBasic->PllBypass[0] = value;
		break;
	case 718:
		pUserInputBasic->PllBypass[1] = value;
		break;
	case 719:
		pUserInputBasic->PllBypass[2] = value;
		break;
	case 720:
		pUserInputBasic->PllBypass[3] = value;
		break;
	case 721:
		pUserInputBasic->PllBypass[4] = value;
		break;
	case 722:
		pUserInputBasic->PllBypass[5] = value;
		break;
	case 723:
		pUserInputBasic->PllBypass[6] = value;
		break;
	case 724:
		pUserInputBasic->PllBypass[7] = value;
		break;
	case 725:
		pUserInputBasic->PllBypass[8] = value;
		break;
	case 726:
		pUserInputBasic->PllBypass[9] = value;
		break;
	case 727:
		pUserInputBasic->PllBypass[10] = value;
		break;
	case 728:
		pUserInputBasic->PllBypass[11] = value;
		break;
	case 729:
		pUserInputBasic->PllBypass[12] = value;
		break;
	case 730:
		pUserInputBasic->PllBypass[13] = value;
		break;
	case 731:
		pUserInputBasic->PllBypass[14] = value;
		break;
	case 732:
		pUserInputBasic->NumRank_dfi1 = value;
		break;
	case 733:
		pUserInputBasic->NumDbytesPerCh = value;
		break;
	case 734:
		pUserInputBasic->MaxNumZQ = value;
		break;
	case 735:
		pUserInputBasic->NumActiveDbyteDfi0 = value;
		break;
	case 736:
		pUserInputSim->tWCK2DQO = value;
		break;
	case 737:
		pUserInputSim->tWCK2DQI = value;
		break;
	case 738:
		pUserInputSim->tWCK2CK = value;
		break;
	case 739:
		pUserInputSim->PHY_tDQS2DQ = value;
		break;
	default:
		dwc_ddrphy_phyinit_assert(0, " [%s] unknown PhyInit field: '%s' (enum: %d)\n", __func__, dwc_ddrphy_phyinit_setUserInput_enumDecode(field), field);
		result = -1;
		break;
	}
	if (result == 0) {
		dwc_ddrphy_phyinit_cmnt(" [%s] Setting PHYINIT field '%s' (enum: %d) to 0x%x\n", __func__, dwc_ddrphy_phyinit_setUserInput_enumDecode(field), field, value);
	}
	return result;
}

/** @brief API to program PhyInit data structures
 *
 *  This function can be used to program user_input_basic, user_input_advanced,
 *  user_input_sim and runtime_config PhyInit data structures.  PhyInit uses the
 *  information in these data structures to program PHY registers.  For details
 *  information about the fields see the data structure documentation.
 *
 *  Some fields are defined as arrays in the data structure. Example to set
 *  PllBypass for Pstate 3:
 *
 *  @code{.c}
 *  dwc_ddrphy_phyinit_setUserInput("PllBypass[3]", 0x1);
 *  @endcode
 *
 *  \note field strings do not overlap between PhyInit structures.
 *
 *  @param[in]   phyctx  PhyInit context
 *
 *  @param[in]   field   A string representing the field to be programed. bracket
 *  notation can be used to set array fields. example  string: "PllBypass[0]"
 *  set the field UserInputBasic.PllBypass[0].
 *  feilds is an array,
 *  @param[in]   value   value to be set on the field.
 *
 *  @return 0 on success. -1 when string does not match fields in any oh PhyInit
 *  data structures.
 */
int dwc_ddrphy_phyinit_setUserInput(phyinit_config_t *phyctx, char *field, int value)
{
	int fieldEnum;

	if (strcmp(field, "lastTrainedPState") == 0) {
		fieldEnum = _lastTrainedPState_;
	} else if (strcmp(field, "skip_train") == 0) {
		fieldEnum = _skip_train_;
	} else if (strcmp(field, "initCtrl") == 0) {
		fieldEnum = _initCtrl_;
	} else if (strcmp(field, "ZQCalCodePD_saved") == 0) {
		fieldEnum = _ZQCalCodePD_saved_;
	} else if (strcmp(field, "Train2D") == 0) {
		fieldEnum = _Train2D_;
	} else if (strcmp(field, "firstTrainedPState") == 0) {
		fieldEnum = _firstTrainedPState_;
	} else if (strcmp(field, "debug") == 0) {
		fieldEnum = _debug_;
	} else if (strcmp(field, "ZQCalCodePU_saved") == 0) {
		fieldEnum = _ZQCalCodePU_saved_;
	} else if (strcmp(field, "curD") == 0) {
		fieldEnum = _curD_;
	} else if (strcmp(field, "RetEn") == 0) {
		fieldEnum = _RetEn_;
	} else if (strcmp(field, "curPState") == 0) {
		fieldEnum = _curPState_;
	} else if (strcmp(field, "RxDfeMode[0]") == 0) {
		fieldEnum = _RxDfeMode_0_;
	} else if (strcmp(field, "RxDfeMode[1]") == 0) {
		fieldEnum = _RxDfeMode_1_;
	} else if (strcmp(field, "RxDfeMode[2]") == 0) {
		fieldEnum = _RxDfeMode_2_;
	} else if (strcmp(field, "RxDfeMode[3]") == 0) {
		fieldEnum = _RxDfeMode_3_;
	} else if (strcmp(field, "RxDfeMode[4]") == 0) {
		fieldEnum = _RxDfeMode_4_;
	} else if (strcmp(field, "RxDfeMode[5]") == 0) {
		fieldEnum = _RxDfeMode_5_;
	} else if (strcmp(field, "RxDfeMode[6]") == 0) {
		fieldEnum = _RxDfeMode_6_;
	} else if (strcmp(field, "RxDfeMode[7]") == 0) {
		fieldEnum = _RxDfeMode_7_;
	} else if (strcmp(field, "RxDfeMode[8]") == 0) {
		fieldEnum = _RxDfeMode_8_;
	} else if (strcmp(field, "RxDfeMode[9]") == 0) {
		fieldEnum = _RxDfeMode_9_;
	} else if (strcmp(field, "RxDfeMode[10]") == 0) {
		fieldEnum = _RxDfeMode_10_;
	} else if (strcmp(field, "RxDfeMode[11]") == 0) {
		fieldEnum = _RxDfeMode_11_;
	} else if (strcmp(field, "RxDfeMode[12]") == 0) {
		fieldEnum = _RxDfeMode_12_;
	} else if (strcmp(field, "RxDfeMode[13]") == 0) {
		fieldEnum = _RxDfeMode_13_;
	} else if (strcmp(field, "RxDfeMode[14]") == 0) {
		fieldEnum = _RxDfeMode_14_;
	} else if (strcmp(field, "DramByteSwap") == 0) {
		fieldEnum = _DramByteSwap_;
	} else if (strcmp(field, "TxSlewRiseDq[0]") == 0) {
		fieldEnum = _TxSlewRiseDq_0_;
	} else if (strcmp(field, "TxSlewRiseDq[1]") == 0) {
		fieldEnum = _TxSlewRiseDq_1_;
	} else if (strcmp(field, "TxSlewRiseDq[2]") == 0) {
		fieldEnum = _TxSlewRiseDq_2_;
	} else if (strcmp(field, "TxSlewRiseDq[3]") == 0) {
		fieldEnum = _TxSlewRiseDq_3_;
	} else if (strcmp(field, "TxSlewRiseDq[4]") == 0) {
		fieldEnum = _TxSlewRiseDq_4_;
	} else if (strcmp(field, "TxSlewRiseDq[5]") == 0) {
		fieldEnum = _TxSlewRiseDq_5_;
	} else if (strcmp(field, "TxSlewRiseDq[6]") == 0) {
		fieldEnum = _TxSlewRiseDq_6_;
	} else if (strcmp(field, "TxSlewRiseDq[7]") == 0) {
		fieldEnum = _TxSlewRiseDq_7_;
	} else if (strcmp(field, "TxSlewRiseDq[8]") == 0) {
		fieldEnum = _TxSlewRiseDq_8_;
	} else if (strcmp(field, "TxSlewRiseDq[9]") == 0) {
		fieldEnum = _TxSlewRiseDq_9_;
	} else if (strcmp(field, "TxSlewRiseDq[10]") == 0) {
		fieldEnum = _TxSlewRiseDq_10_;
	} else if (strcmp(field, "TxSlewRiseDq[11]") == 0) {
		fieldEnum = _TxSlewRiseDq_11_;
	} else if (strcmp(field, "TxSlewRiseDq[12]") == 0) {
		fieldEnum = _TxSlewRiseDq_12_;
	} else if (strcmp(field, "TxSlewRiseDq[13]") == 0) {
		fieldEnum = _TxSlewRiseDq_13_;
	} else if (strcmp(field, "TxSlewRiseDq[14]") == 0) {
		fieldEnum = _TxSlewRiseDq_14_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[0]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_0_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[1]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_1_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[2]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_2_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[3]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_3_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[4]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_4_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[5]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_5_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[6]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_6_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[7]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_7_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[8]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_8_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[9]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_9_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[10]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_10_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[11]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_11_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[12]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_12_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[13]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_13_;
	} else if (strcmp(field, "RxBiasCurrentControlRxReplica[14]") == 0) {
		fieldEnum = _RxBiasCurrentControlRxReplica_14_;
	} else if (strcmp(field, "TxSlewFallCA[0]") == 0) {
		fieldEnum = _TxSlewFallCA_0_;
	} else if (strcmp(field, "TxSlewFallCA[1]") == 0) {
		fieldEnum = _TxSlewFallCA_1_;
	} else if (strcmp(field, "TxSlewFallCA[2]") == 0) {
		fieldEnum = _TxSlewFallCA_2_;
	} else if (strcmp(field, "TxSlewFallCA[3]") == 0) {
		fieldEnum = _TxSlewFallCA_3_;
	} else if (strcmp(field, "TxSlewFallCA[4]") == 0) {
		fieldEnum = _TxSlewFallCA_4_;
	} else if (strcmp(field, "TxSlewFallCA[5]") == 0) {
		fieldEnum = _TxSlewFallCA_5_;
	} else if (strcmp(field, "TxSlewFallCA[6]") == 0) {
		fieldEnum = _TxSlewFallCA_6_;
	} else if (strcmp(field, "TxSlewFallCA[7]") == 0) {
		fieldEnum = _TxSlewFallCA_7_;
	} else if (strcmp(field, "TxSlewFallCA[8]") == 0) {
		fieldEnum = _TxSlewFallCA_8_;
	} else if (strcmp(field, "TxSlewFallCA[9]") == 0) {
		fieldEnum = _TxSlewFallCA_9_;
	} else if (strcmp(field, "TxSlewFallCA[10]") == 0) {
		fieldEnum = _TxSlewFallCA_10_;
	} else if (strcmp(field, "TxSlewFallCA[11]") == 0) {
		fieldEnum = _TxSlewFallCA_11_;
	} else if (strcmp(field, "TxSlewFallCA[12]") == 0) {
		fieldEnum = _TxSlewFallCA_12_;
	} else if (strcmp(field, "TxSlewFallCA[13]") == 0) {
		fieldEnum = _TxSlewFallCA_13_;
	} else if (strcmp(field, "TxSlewFallCA[14]") == 0) {
		fieldEnum = _TxSlewFallCA_14_;
	} else if (strcmp(field, "OdtImpedanceDqs[0]") == 0) {
		fieldEnum = _OdtImpedanceDqs_0_;
	} else if (strcmp(field, "OdtImpedanceDqs[1]") == 0) {
		fieldEnum = _OdtImpedanceDqs_1_;
	} else if (strcmp(field, "OdtImpedanceDqs[2]") == 0) {
		fieldEnum = _OdtImpedanceDqs_2_;
	} else if (strcmp(field, "OdtImpedanceDqs[3]") == 0) {
		fieldEnum = _OdtImpedanceDqs_3_;
	} else if (strcmp(field, "OdtImpedanceDqs[4]") == 0) {
		fieldEnum = _OdtImpedanceDqs_4_;
	} else if (strcmp(field, "OdtImpedanceDqs[5]") == 0) {
		fieldEnum = _OdtImpedanceDqs_5_;
	} else if (strcmp(field, "OdtImpedanceDqs[6]") == 0) {
		fieldEnum = _OdtImpedanceDqs_6_;
	} else if (strcmp(field, "OdtImpedanceDqs[7]") == 0) {
		fieldEnum = _OdtImpedanceDqs_7_;
	} else if (strcmp(field, "OdtImpedanceDqs[8]") == 0) {
		fieldEnum = _OdtImpedanceDqs_8_;
	} else if (strcmp(field, "OdtImpedanceDqs[9]") == 0) {
		fieldEnum = _OdtImpedanceDqs_9_;
	} else if (strcmp(field, "OdtImpedanceDqs[10]") == 0) {
		fieldEnum = _OdtImpedanceDqs_10_;
	} else if (strcmp(field, "OdtImpedanceDqs[11]") == 0) {
		fieldEnum = _OdtImpedanceDqs_11_;
	} else if (strcmp(field, "OdtImpedanceDqs[12]") == 0) {
		fieldEnum = _OdtImpedanceDqs_12_;
	} else if (strcmp(field, "OdtImpedanceDqs[13]") == 0) {
		fieldEnum = _OdtImpedanceDqs_13_;
	} else if (strcmp(field, "OdtImpedanceDqs[14]") == 0) {
		fieldEnum = _OdtImpedanceDqs_14_;
	} else if (strcmp(field, "RxModeBoostVDD[0]") == 0) {
		fieldEnum = _RxModeBoostVDD_0_;
	} else if (strcmp(field, "RxModeBoostVDD[1]") == 0) {
		fieldEnum = _RxModeBoostVDD_1_;
	} else if (strcmp(field, "RxModeBoostVDD[2]") == 0) {
		fieldEnum = _RxModeBoostVDD_2_;
	} else if (strcmp(field, "RxModeBoostVDD[3]") == 0) {
		fieldEnum = _RxModeBoostVDD_3_;
	} else if (strcmp(field, "RxModeBoostVDD[4]") == 0) {
		fieldEnum = _RxModeBoostVDD_4_;
	} else if (strcmp(field, "RxModeBoostVDD[5]") == 0) {
		fieldEnum = _RxModeBoostVDD_5_;
	} else if (strcmp(field, "RxModeBoostVDD[6]") == 0) {
		fieldEnum = _RxModeBoostVDD_6_;
	} else if (strcmp(field, "RxModeBoostVDD[7]") == 0) {
		fieldEnum = _RxModeBoostVDD_7_;
	} else if (strcmp(field, "RxModeBoostVDD[8]") == 0) {
		fieldEnum = _RxModeBoostVDD_8_;
	} else if (strcmp(field, "RxModeBoostVDD[9]") == 0) {
		fieldEnum = _RxModeBoostVDD_9_;
	} else if (strcmp(field, "RxModeBoostVDD[10]") == 0) {
		fieldEnum = _RxModeBoostVDD_10_;
	} else if (strcmp(field, "RxModeBoostVDD[11]") == 0) {
		fieldEnum = _RxModeBoostVDD_11_;
	} else if (strcmp(field, "RxModeBoostVDD[12]") == 0) {
		fieldEnum = _RxModeBoostVDD_12_;
	} else if (strcmp(field, "RxModeBoostVDD[13]") == 0) {
		fieldEnum = _RxModeBoostVDD_13_;
	} else if (strcmp(field, "RxModeBoostVDD[14]") == 0) {
		fieldEnum = _RxModeBoostVDD_14_;
	} else if (strcmp(field, "PhyVrefCode") == 0) {
		fieldEnum = _PhyVrefCode_;
	} else if (strcmp(field, "OdtImpedanceWCK[0]") == 0) {
		fieldEnum = _OdtImpedanceWCK_0_;
	} else if (strcmp(field, "OdtImpedanceWCK[1]") == 0) {
		fieldEnum = _OdtImpedanceWCK_1_;
	} else if (strcmp(field, "OdtImpedanceWCK[2]") == 0) {
		fieldEnum = _OdtImpedanceWCK_2_;
	} else if (strcmp(field, "OdtImpedanceWCK[3]") == 0) {
		fieldEnum = _OdtImpedanceWCK_3_;
	} else if (strcmp(field, "OdtImpedanceWCK[4]") == 0) {
		fieldEnum = _OdtImpedanceWCK_4_;
	} else if (strcmp(field, "OdtImpedanceWCK[5]") == 0) {
		fieldEnum = _OdtImpedanceWCK_5_;
	} else if (strcmp(field, "OdtImpedanceWCK[6]") == 0) {
		fieldEnum = _OdtImpedanceWCK_6_;
	} else if (strcmp(field, "OdtImpedanceWCK[7]") == 0) {
		fieldEnum = _OdtImpedanceWCK_7_;
	} else if (strcmp(field, "OdtImpedanceWCK[8]") == 0) {
		fieldEnum = _OdtImpedanceWCK_8_;
	} else if (strcmp(field, "OdtImpedanceWCK[9]") == 0) {
		fieldEnum = _OdtImpedanceWCK_9_;
	} else if (strcmp(field, "OdtImpedanceWCK[10]") == 0) {
		fieldEnum = _OdtImpedanceWCK_10_;
	} else if (strcmp(field, "OdtImpedanceWCK[11]") == 0) {
		fieldEnum = _OdtImpedanceWCK_11_;
	} else if (strcmp(field, "OdtImpedanceWCK[12]") == 0) {
		fieldEnum = _OdtImpedanceWCK_12_;
	} else if (strcmp(field, "OdtImpedanceWCK[13]") == 0) {
		fieldEnum = _OdtImpedanceWCK_13_;
	} else if (strcmp(field, "OdtImpedanceWCK[14]") == 0) {
		fieldEnum = _OdtImpedanceWCK_14_;
	} else if (strcmp(field, "TxSlewFallWCK[0]") == 0) {
		fieldEnum = _TxSlewFallWCK_0_;
	} else if (strcmp(field, "TxSlewFallWCK[1]") == 0) {
		fieldEnum = _TxSlewFallWCK_1_;
	} else if (strcmp(field, "TxSlewFallWCK[2]") == 0) {
		fieldEnum = _TxSlewFallWCK_2_;
	} else if (strcmp(field, "TxSlewFallWCK[3]") == 0) {
		fieldEnum = _TxSlewFallWCK_3_;
	} else if (strcmp(field, "TxSlewFallWCK[4]") == 0) {
		fieldEnum = _TxSlewFallWCK_4_;
	} else if (strcmp(field, "TxSlewFallWCK[5]") == 0) {
		fieldEnum = _TxSlewFallWCK_5_;
	} else if (strcmp(field, "TxSlewFallWCK[6]") == 0) {
		fieldEnum = _TxSlewFallWCK_6_;
	} else if (strcmp(field, "TxSlewFallWCK[7]") == 0) {
		fieldEnum = _TxSlewFallWCK_7_;
	} else if (strcmp(field, "TxSlewFallWCK[8]") == 0) {
		fieldEnum = _TxSlewFallWCK_8_;
	} else if (strcmp(field, "TxSlewFallWCK[9]") == 0) {
		fieldEnum = _TxSlewFallWCK_9_;
	} else if (strcmp(field, "TxSlewFallWCK[10]") == 0) {
		fieldEnum = _TxSlewFallWCK_10_;
	} else if (strcmp(field, "TxSlewFallWCK[11]") == 0) {
		fieldEnum = _TxSlewFallWCK_11_;
	} else if (strcmp(field, "TxSlewFallWCK[12]") == 0) {
		fieldEnum = _TxSlewFallWCK_12_;
	} else if (strcmp(field, "TxSlewFallWCK[13]") == 0) {
		fieldEnum = _TxSlewFallWCK_13_;
	} else if (strcmp(field, "TxSlewFallWCK[14]") == 0) {
		fieldEnum = _TxSlewFallWCK_14_;
	} else if (strcmp(field, "OdtImpedanceDq[0]") == 0) {
		fieldEnum = _OdtImpedanceDq_0_;
	} else if (strcmp(field, "OdtImpedanceDq[1]") == 0) {
		fieldEnum = _OdtImpedanceDq_1_;
	} else if (strcmp(field, "OdtImpedanceDq[2]") == 0) {
		fieldEnum = _OdtImpedanceDq_2_;
	} else if (strcmp(field, "OdtImpedanceDq[3]") == 0) {
		fieldEnum = _OdtImpedanceDq_3_;
	} else if (strcmp(field, "OdtImpedanceDq[4]") == 0) {
		fieldEnum = _OdtImpedanceDq_4_;
	} else if (strcmp(field, "OdtImpedanceDq[5]") == 0) {
		fieldEnum = _OdtImpedanceDq_5_;
	} else if (strcmp(field, "OdtImpedanceDq[6]") == 0) {
		fieldEnum = _OdtImpedanceDq_6_;
	} else if (strcmp(field, "OdtImpedanceDq[7]") == 0) {
		fieldEnum = _OdtImpedanceDq_7_;
	} else if (strcmp(field, "OdtImpedanceDq[8]") == 0) {
		fieldEnum = _OdtImpedanceDq_8_;
	} else if (strcmp(field, "OdtImpedanceDq[9]") == 0) {
		fieldEnum = _OdtImpedanceDq_9_;
	} else if (strcmp(field, "OdtImpedanceDq[10]") == 0) {
		fieldEnum = _OdtImpedanceDq_10_;
	} else if (strcmp(field, "OdtImpedanceDq[11]") == 0) {
		fieldEnum = _OdtImpedanceDq_11_;
	} else if (strcmp(field, "OdtImpedanceDq[12]") == 0) {
		fieldEnum = _OdtImpedanceDq_12_;
	} else if (strcmp(field, "OdtImpedanceDq[13]") == 0) {
		fieldEnum = _OdtImpedanceDq_13_;
	} else if (strcmp(field, "OdtImpedanceDq[14]") == 0) {
		fieldEnum = _OdtImpedanceDq_14_;
	} else if (strcmp(field, "DisableUnusedAddrLns") == 0) {
		fieldEnum = _DisableUnusedAddrLns_;
	} else if (strcmp(field, "EnWck2DqoTracking[0]") == 0) {
		fieldEnum = _EnWck2DqoTracking_0_;
	} else if (strcmp(field, "EnWck2DqoTracking[1]") == 0) {
		fieldEnum = _EnWck2DqoTracking_1_;
	} else if (strcmp(field, "EnWck2DqoTracking[2]") == 0) {
		fieldEnum = _EnWck2DqoTracking_2_;
	} else if (strcmp(field, "EnWck2DqoTracking[3]") == 0) {
		fieldEnum = _EnWck2DqoTracking_3_;
	} else if (strcmp(field, "EnWck2DqoTracking[4]") == 0) {
		fieldEnum = _EnWck2DqoTracking_4_;
	} else if (strcmp(field, "EnWck2DqoTracking[5]") == 0) {
		fieldEnum = _EnWck2DqoTracking_5_;
	} else if (strcmp(field, "EnWck2DqoTracking[6]") == 0) {
		fieldEnum = _EnWck2DqoTracking_6_;
	} else if (strcmp(field, "EnWck2DqoTracking[7]") == 0) {
		fieldEnum = _EnWck2DqoTracking_7_;
	} else if (strcmp(field, "EnWck2DqoTracking[8]") == 0) {
		fieldEnum = _EnWck2DqoTracking_8_;
	} else if (strcmp(field, "EnWck2DqoTracking[9]") == 0) {
		fieldEnum = _EnWck2DqoTracking_9_;
	} else if (strcmp(field, "EnWck2DqoTracking[10]") == 0) {
		fieldEnum = _EnWck2DqoTracking_10_;
	} else if (strcmp(field, "EnWck2DqoTracking[11]") == 0) {
		fieldEnum = _EnWck2DqoTracking_11_;
	} else if (strcmp(field, "EnWck2DqoTracking[12]") == 0) {
		fieldEnum = _EnWck2DqoTracking_12_;
	} else if (strcmp(field, "EnWck2DqoTracking[13]") == 0) {
		fieldEnum = _EnWck2DqoTracking_13_;
	} else if (strcmp(field, "EnWck2DqoTracking[14]") == 0) {
		fieldEnum = _EnWck2DqoTracking_14_;
	} else if (strcmp(field, "TxSlewRiseCK[0]") == 0) {
		fieldEnum = _TxSlewRiseCK_0_;
	} else if (strcmp(field, "TxSlewRiseCK[1]") == 0) {
		fieldEnum = _TxSlewRiseCK_1_;
	} else if (strcmp(field, "TxSlewRiseCK[2]") == 0) {
		fieldEnum = _TxSlewRiseCK_2_;
	} else if (strcmp(field, "TxSlewRiseCK[3]") == 0) {
		fieldEnum = _TxSlewRiseCK_3_;
	} else if (strcmp(field, "TxSlewRiseCK[4]") == 0) {
		fieldEnum = _TxSlewRiseCK_4_;
	} else if (strcmp(field, "TxSlewRiseCK[5]") == 0) {
		fieldEnum = _TxSlewRiseCK_5_;
	} else if (strcmp(field, "TxSlewRiseCK[6]") == 0) {
		fieldEnum = _TxSlewRiseCK_6_;
	} else if (strcmp(field, "TxSlewRiseCK[7]") == 0) {
		fieldEnum = _TxSlewRiseCK_7_;
	} else if (strcmp(field, "TxSlewRiseCK[8]") == 0) {
		fieldEnum = _TxSlewRiseCK_8_;
	} else if (strcmp(field, "TxSlewRiseCK[9]") == 0) {
		fieldEnum = _TxSlewRiseCK_9_;
	} else if (strcmp(field, "TxSlewRiseCK[10]") == 0) {
		fieldEnum = _TxSlewRiseCK_10_;
	} else if (strcmp(field, "TxSlewRiseCK[11]") == 0) {
		fieldEnum = _TxSlewRiseCK_11_;
	} else if (strcmp(field, "TxSlewRiseCK[12]") == 0) {
		fieldEnum = _TxSlewRiseCK_12_;
	} else if (strcmp(field, "TxSlewRiseCK[13]") == 0) {
		fieldEnum = _TxSlewRiseCK_13_;
	} else if (strcmp(field, "TxSlewRiseCK[14]") == 0) {
		fieldEnum = _TxSlewRiseCK_14_;
	} else if (strcmp(field, "TxSlewRiseCA[0]") == 0) {
		fieldEnum = _TxSlewRiseCA_0_;
	} else if (strcmp(field, "TxSlewRiseCA[1]") == 0) {
		fieldEnum = _TxSlewRiseCA_1_;
	} else if (strcmp(field, "TxSlewRiseCA[2]") == 0) {
		fieldEnum = _TxSlewRiseCA_2_;
	} else if (strcmp(field, "TxSlewRiseCA[3]") == 0) {
		fieldEnum = _TxSlewRiseCA_3_;
	} else if (strcmp(field, "TxSlewRiseCA[4]") == 0) {
		fieldEnum = _TxSlewRiseCA_4_;
	} else if (strcmp(field, "TxSlewRiseCA[5]") == 0) {
		fieldEnum = _TxSlewRiseCA_5_;
	} else if (strcmp(field, "TxSlewRiseCA[6]") == 0) {
		fieldEnum = _TxSlewRiseCA_6_;
	} else if (strcmp(field, "TxSlewRiseCA[7]") == 0) {
		fieldEnum = _TxSlewRiseCA_7_;
	} else if (strcmp(field, "TxSlewRiseCA[8]") == 0) {
		fieldEnum = _TxSlewRiseCA_8_;
	} else if (strcmp(field, "TxSlewRiseCA[9]") == 0) {
		fieldEnum = _TxSlewRiseCA_9_;
	} else if (strcmp(field, "TxSlewRiseCA[10]") == 0) {
		fieldEnum = _TxSlewRiseCA_10_;
	} else if (strcmp(field, "TxSlewRiseCA[11]") == 0) {
		fieldEnum = _TxSlewRiseCA_11_;
	} else if (strcmp(field, "TxSlewRiseCA[12]") == 0) {
		fieldEnum = _TxSlewRiseCA_12_;
	} else if (strcmp(field, "TxSlewRiseCA[13]") == 0) {
		fieldEnum = _TxSlewRiseCA_13_;
	} else if (strcmp(field, "TxSlewRiseCA[14]") == 0) {
		fieldEnum = _TxSlewRiseCA_14_;
	} else if (strcmp(field, "TxSlewFallCK[0]") == 0) {
		fieldEnum = _TxSlewFallCK_0_;
	} else if (strcmp(field, "TxSlewFallCK[1]") == 0) {
		fieldEnum = _TxSlewFallCK_1_;
	} else if (strcmp(field, "TxSlewFallCK[2]") == 0) {
		fieldEnum = _TxSlewFallCK_2_;
	} else if (strcmp(field, "TxSlewFallCK[3]") == 0) {
		fieldEnum = _TxSlewFallCK_3_;
	} else if (strcmp(field, "TxSlewFallCK[4]") == 0) {
		fieldEnum = _TxSlewFallCK_4_;
	} else if (strcmp(field, "TxSlewFallCK[5]") == 0) {
		fieldEnum = _TxSlewFallCK_5_;
	} else if (strcmp(field, "TxSlewFallCK[6]") == 0) {
		fieldEnum = _TxSlewFallCK_6_;
	} else if (strcmp(field, "TxSlewFallCK[7]") == 0) {
		fieldEnum = _TxSlewFallCK_7_;
	} else if (strcmp(field, "TxSlewFallCK[8]") == 0) {
		fieldEnum = _TxSlewFallCK_8_;
	} else if (strcmp(field, "TxSlewFallCK[9]") == 0) {
		fieldEnum = _TxSlewFallCK_9_;
	} else if (strcmp(field, "TxSlewFallCK[10]") == 0) {
		fieldEnum = _TxSlewFallCK_10_;
	} else if (strcmp(field, "TxSlewFallCK[11]") == 0) {
		fieldEnum = _TxSlewFallCK_11_;
	} else if (strcmp(field, "TxSlewFallCK[12]") == 0) {
		fieldEnum = _TxSlewFallCK_12_;
	} else if (strcmp(field, "TxSlewFallCK[13]") == 0) {
		fieldEnum = _TxSlewFallCK_13_;
	} else if (strcmp(field, "TxSlewFallCK[14]") == 0) {
		fieldEnum = _TxSlewFallCK_14_;
	} else if (strcmp(field, "RelockOnlyCntrl") == 0) {
		fieldEnum = _RelockOnlyCntrl_;
	} else if (strcmp(field, "CalImpedanceCurrentAdjustment") == 0) {
		fieldEnum = _CalImpedanceCurrentAdjustment_;
	} else if (strcmp(field, "SkipRetrainEnhancement") == 0) {
		fieldEnum = _SkipRetrainEnhancement_;
	} else if (strcmp(field, "OdtImpedanceCk[0]") == 0) {
		fieldEnum = _OdtImpedanceCk_0_;
	} else if (strcmp(field, "OdtImpedanceCk[1]") == 0) {
		fieldEnum = _OdtImpedanceCk_1_;
	} else if (strcmp(field, "OdtImpedanceCk[2]") == 0) {
		fieldEnum = _OdtImpedanceCk_2_;
	} else if (strcmp(field, "OdtImpedanceCk[3]") == 0) {
		fieldEnum = _OdtImpedanceCk_3_;
	} else if (strcmp(field, "OdtImpedanceCk[4]") == 0) {
		fieldEnum = _OdtImpedanceCk_4_;
	} else if (strcmp(field, "OdtImpedanceCk[5]") == 0) {
		fieldEnum = _OdtImpedanceCk_5_;
	} else if (strcmp(field, "OdtImpedanceCk[6]") == 0) {
		fieldEnum = _OdtImpedanceCk_6_;
	} else if (strcmp(field, "OdtImpedanceCk[7]") == 0) {
		fieldEnum = _OdtImpedanceCk_7_;
	} else if (strcmp(field, "OdtImpedanceCk[8]") == 0) {
		fieldEnum = _OdtImpedanceCk_8_;
	} else if (strcmp(field, "OdtImpedanceCk[9]") == 0) {
		fieldEnum = _OdtImpedanceCk_9_;
	} else if (strcmp(field, "OdtImpedanceCk[10]") == 0) {
		fieldEnum = _OdtImpedanceCk_10_;
	} else if (strcmp(field, "OdtImpedanceCk[11]") == 0) {
		fieldEnum = _OdtImpedanceCk_11_;
	} else if (strcmp(field, "OdtImpedanceCk[12]") == 0) {
		fieldEnum = _OdtImpedanceCk_12_;
	} else if (strcmp(field, "OdtImpedanceCk[13]") == 0) {
		fieldEnum = _OdtImpedanceCk_13_;
	} else if (strcmp(field, "OdtImpedanceCk[14]") == 0) {
		fieldEnum = _OdtImpedanceCk_14_;
	} else if (strcmp(field, "TxImpedanceCKE[0]") == 0) {
		fieldEnum = _TxImpedanceCKE_0_;
	} else if (strcmp(field, "TxImpedanceCKE[1]") == 0) {
		fieldEnum = _TxImpedanceCKE_1_;
	} else if (strcmp(field, "TxImpedanceCKE[2]") == 0) {
		fieldEnum = _TxImpedanceCKE_2_;
	} else if (strcmp(field, "TxImpedanceCKE[3]") == 0) {
		fieldEnum = _TxImpedanceCKE_3_;
	} else if (strcmp(field, "TxImpedanceCKE[4]") == 0) {
		fieldEnum = _TxImpedanceCKE_4_;
	} else if (strcmp(field, "TxImpedanceCKE[5]") == 0) {
		fieldEnum = _TxImpedanceCKE_5_;
	} else if (strcmp(field, "TxImpedanceCKE[6]") == 0) {
		fieldEnum = _TxImpedanceCKE_6_;
	} else if (strcmp(field, "TxImpedanceCKE[7]") == 0) {
		fieldEnum = _TxImpedanceCKE_7_;
	} else if (strcmp(field, "TxImpedanceCKE[8]") == 0) {
		fieldEnum = _TxImpedanceCKE_8_;
	} else if (strcmp(field, "TxImpedanceCKE[9]") == 0) {
		fieldEnum = _TxImpedanceCKE_9_;
	} else if (strcmp(field, "TxImpedanceCKE[10]") == 0) {
		fieldEnum = _TxImpedanceCKE_10_;
	} else if (strcmp(field, "TxImpedanceCKE[11]") == 0) {
		fieldEnum = _TxImpedanceCKE_11_;
	} else if (strcmp(field, "TxImpedanceCKE[12]") == 0) {
		fieldEnum = _TxImpedanceCKE_12_;
	} else if (strcmp(field, "TxImpedanceCKE[13]") == 0) {
		fieldEnum = _TxImpedanceCKE_13_;
	} else if (strcmp(field, "TxImpedanceCKE[14]") == 0) {
		fieldEnum = _TxImpedanceCKE_14_;
	} else if (strcmp(field, "PsDmaRamSize") == 0) {
		fieldEnum = _PsDmaRamSize_;
	} else if (strcmp(field, "RxClkTrackEn[0]") == 0) {
		fieldEnum = _RxClkTrackEn_0_;
	} else if (strcmp(field, "RxClkTrackEn[1]") == 0) {
		fieldEnum = _RxClkTrackEn_1_;
	} else if (strcmp(field, "RxClkTrackEn[2]") == 0) {
		fieldEnum = _RxClkTrackEn_2_;
	} else if (strcmp(field, "RxClkTrackEn[3]") == 0) {
		fieldEnum = _RxClkTrackEn_3_;
	} else if (strcmp(field, "RxClkTrackEn[4]") == 0) {
		fieldEnum = _RxClkTrackEn_4_;
	} else if (strcmp(field, "RxClkTrackEn[5]") == 0) {
		fieldEnum = _RxClkTrackEn_5_;
	} else if (strcmp(field, "RxClkTrackEn[6]") == 0) {
		fieldEnum = _RxClkTrackEn_6_;
	} else if (strcmp(field, "RxClkTrackEn[7]") == 0) {
		fieldEnum = _RxClkTrackEn_7_;
	} else if (strcmp(field, "RxClkTrackEn[8]") == 0) {
		fieldEnum = _RxClkTrackEn_8_;
	} else if (strcmp(field, "RxClkTrackEn[9]") == 0) {
		fieldEnum = _RxClkTrackEn_9_;
	} else if (strcmp(field, "RxClkTrackEn[10]") == 0) {
		fieldEnum = _RxClkTrackEn_10_;
	} else if (strcmp(field, "RxClkTrackEn[11]") == 0) {
		fieldEnum = _RxClkTrackEn_11_;
	} else if (strcmp(field, "RxClkTrackEn[12]") == 0) {
		fieldEnum = _RxClkTrackEn_12_;
	} else if (strcmp(field, "RxClkTrackEn[13]") == 0) {
		fieldEnum = _RxClkTrackEn_13_;
	} else if (strcmp(field, "RxClkTrackEn[14]") == 0) {
		fieldEnum = _RxClkTrackEn_14_;
	} else if (strcmp(field, "TxSlewFallDqs[0]") == 0) {
		fieldEnum = _TxSlewFallDqs_0_;
	} else if (strcmp(field, "TxSlewFallDqs[1]") == 0) {
		fieldEnum = _TxSlewFallDqs_1_;
	} else if (strcmp(field, "TxSlewFallDqs[2]") == 0) {
		fieldEnum = _TxSlewFallDqs_2_;
	} else if (strcmp(field, "TxSlewFallDqs[3]") == 0) {
		fieldEnum = _TxSlewFallDqs_3_;
	} else if (strcmp(field, "TxSlewFallDqs[4]") == 0) {
		fieldEnum = _TxSlewFallDqs_4_;
	} else if (strcmp(field, "TxSlewFallDqs[5]") == 0) {
		fieldEnum = _TxSlewFallDqs_5_;
	} else if (strcmp(field, "TxSlewFallDqs[6]") == 0) {
		fieldEnum = _TxSlewFallDqs_6_;
	} else if (strcmp(field, "TxSlewFallDqs[7]") == 0) {
		fieldEnum = _TxSlewFallDqs_7_;
	} else if (strcmp(field, "TxSlewFallDqs[8]") == 0) {
		fieldEnum = _TxSlewFallDqs_8_;
	} else if (strcmp(field, "TxSlewFallDqs[9]") == 0) {
		fieldEnum = _TxSlewFallDqs_9_;
	} else if (strcmp(field, "TxSlewFallDqs[10]") == 0) {
		fieldEnum = _TxSlewFallDqs_10_;
	} else if (strcmp(field, "TxSlewFallDqs[11]") == 0) {
		fieldEnum = _TxSlewFallDqs_11_;
	} else if (strcmp(field, "TxSlewFallDqs[12]") == 0) {
		fieldEnum = _TxSlewFallDqs_12_;
	} else if (strcmp(field, "TxSlewFallDqs[13]") == 0) {
		fieldEnum = _TxSlewFallDqs_13_;
	} else if (strcmp(field, "TxSlewFallDqs[14]") == 0) {
		fieldEnum = _TxSlewFallDqs_14_;
	} else if (strcmp(field, "TxImpedanceAc[0]") == 0) {
		fieldEnum = _TxImpedanceAc_0_;
	} else if (strcmp(field, "TxImpedanceAc[1]") == 0) {
		fieldEnum = _TxImpedanceAc_1_;
	} else if (strcmp(field, "TxImpedanceAc[2]") == 0) {
		fieldEnum = _TxImpedanceAc_2_;
	} else if (strcmp(field, "TxImpedanceAc[3]") == 0) {
		fieldEnum = _TxImpedanceAc_3_;
	} else if (strcmp(field, "TxImpedanceAc[4]") == 0) {
		fieldEnum = _TxImpedanceAc_4_;
	} else if (strcmp(field, "TxImpedanceAc[5]") == 0) {
		fieldEnum = _TxImpedanceAc_5_;
	} else if (strcmp(field, "TxImpedanceAc[6]") == 0) {
		fieldEnum = _TxImpedanceAc_6_;
	} else if (strcmp(field, "TxImpedanceAc[7]") == 0) {
		fieldEnum = _TxImpedanceAc_7_;
	} else if (strcmp(field, "TxImpedanceAc[8]") == 0) {
		fieldEnum = _TxImpedanceAc_8_;
	} else if (strcmp(field, "TxImpedanceAc[9]") == 0) {
		fieldEnum = _TxImpedanceAc_9_;
	} else if (strcmp(field, "TxImpedanceAc[10]") == 0) {
		fieldEnum = _TxImpedanceAc_10_;
	} else if (strcmp(field, "TxImpedanceAc[11]") == 0) {
		fieldEnum = _TxImpedanceAc_11_;
	} else if (strcmp(field, "TxImpedanceAc[12]") == 0) {
		fieldEnum = _TxImpedanceAc_12_;
	} else if (strcmp(field, "TxImpedanceAc[13]") == 0) {
		fieldEnum = _TxImpedanceAc_13_;
	} else if (strcmp(field, "TxImpedanceAc[14]") == 0) {
		fieldEnum = _TxImpedanceAc_14_;
	} else if (strcmp(field, "CkDisVal[0]") == 0) {
		fieldEnum = _CkDisVal_0_;
	} else if (strcmp(field, "CkDisVal[1]") == 0) {
		fieldEnum = _CkDisVal_1_;
	} else if (strcmp(field, "CkDisVal[2]") == 0) {
		fieldEnum = _CkDisVal_2_;
	} else if (strcmp(field, "CkDisVal[3]") == 0) {
		fieldEnum = _CkDisVal_3_;
	} else if (strcmp(field, "CkDisVal[4]") == 0) {
		fieldEnum = _CkDisVal_4_;
	} else if (strcmp(field, "CkDisVal[5]") == 0) {
		fieldEnum = _CkDisVal_5_;
	} else if (strcmp(field, "CkDisVal[6]") == 0) {
		fieldEnum = _CkDisVal_6_;
	} else if (strcmp(field, "CkDisVal[7]") == 0) {
		fieldEnum = _CkDisVal_7_;
	} else if (strcmp(field, "CkDisVal[8]") == 0) {
		fieldEnum = _CkDisVal_8_;
	} else if (strcmp(field, "CkDisVal[9]") == 0) {
		fieldEnum = _CkDisVal_9_;
	} else if (strcmp(field, "CkDisVal[10]") == 0) {
		fieldEnum = _CkDisVal_10_;
	} else if (strcmp(field, "CkDisVal[11]") == 0) {
		fieldEnum = _CkDisVal_11_;
	} else if (strcmp(field, "CkDisVal[12]") == 0) {
		fieldEnum = _CkDisVal_12_;
	} else if (strcmp(field, "CkDisVal[13]") == 0) {
		fieldEnum = _CkDisVal_13_;
	} else if (strcmp(field, "CkDisVal[14]") == 0) {
		fieldEnum = _CkDisVal_14_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[0]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_0_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[1]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_1_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[2]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_2_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[3]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_3_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[4]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_4_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[5]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_5_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[6]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_6_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[7]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_7_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[8]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_8_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[9]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_9_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[10]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_10_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[11]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_11_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[12]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_12_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[13]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_13_;
	} else if (strcmp(field, "PhyMstrMaxReqToAck[14]") == 0) {
		fieldEnum = _PhyMstrMaxReqToAck_14_;
	} else if (strcmp(field, "TxImpedanceDqs[0]") == 0) {
		fieldEnum = _TxImpedanceDqs_0_;
	} else if (strcmp(field, "TxImpedanceDqs[1]") == 0) {
		fieldEnum = _TxImpedanceDqs_1_;
	} else if (strcmp(field, "TxImpedanceDqs[2]") == 0) {
		fieldEnum = _TxImpedanceDqs_2_;
	} else if (strcmp(field, "TxImpedanceDqs[3]") == 0) {
		fieldEnum = _TxImpedanceDqs_3_;
	} else if (strcmp(field, "TxImpedanceDqs[4]") == 0) {
		fieldEnum = _TxImpedanceDqs_4_;
	} else if (strcmp(field, "TxImpedanceDqs[5]") == 0) {
		fieldEnum = _TxImpedanceDqs_5_;
	} else if (strcmp(field, "TxImpedanceDqs[6]") == 0) {
		fieldEnum = _TxImpedanceDqs_6_;
	} else if (strcmp(field, "TxImpedanceDqs[7]") == 0) {
		fieldEnum = _TxImpedanceDqs_7_;
	} else if (strcmp(field, "TxImpedanceDqs[8]") == 0) {
		fieldEnum = _TxImpedanceDqs_8_;
	} else if (strcmp(field, "TxImpedanceDqs[9]") == 0) {
		fieldEnum = _TxImpedanceDqs_9_;
	} else if (strcmp(field, "TxImpedanceDqs[10]") == 0) {
		fieldEnum = _TxImpedanceDqs_10_;
	} else if (strcmp(field, "TxImpedanceDqs[11]") == 0) {
		fieldEnum = _TxImpedanceDqs_11_;
	} else if (strcmp(field, "TxImpedanceDqs[12]") == 0) {
		fieldEnum = _TxImpedanceDqs_12_;
	} else if (strcmp(field, "TxImpedanceDqs[13]") == 0) {
		fieldEnum = _TxImpedanceDqs_13_;
	} else if (strcmp(field, "TxImpedanceDqs[14]") == 0) {
		fieldEnum = _TxImpedanceDqs_14_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[0]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_0_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[1]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_1_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[2]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_2_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[3]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_3_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[4]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_4_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[5]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_5_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[6]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_6_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[7]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_7_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[8]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_8_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[9]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_9_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[10]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_10_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[11]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_11_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[12]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_12_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[13]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_13_;
	} else if (strcmp(field, "RxDqsTrackingThreshold[14]") == 0) {
		fieldEnum = _RxDqsTrackingThreshold_14_;
	} else if (strcmp(field, "DisableTDRAccess") == 0) {
		fieldEnum = _DisableTDRAccess_;
	} else if (strcmp(field, "DisableRetraining") == 0) {
		fieldEnum = _DisableRetraining_;
	} else if (strcmp(field, "TxSlewFallDq[0]") == 0) {
		fieldEnum = _TxSlewFallDq_0_;
	} else if (strcmp(field, "TxSlewFallDq[1]") == 0) {
		fieldEnum = _TxSlewFallDq_1_;
	} else if (strcmp(field, "TxSlewFallDq[2]") == 0) {
		fieldEnum = _TxSlewFallDq_2_;
	} else if (strcmp(field, "TxSlewFallDq[3]") == 0) {
		fieldEnum = _TxSlewFallDq_3_;
	} else if (strcmp(field, "TxSlewFallDq[4]") == 0) {
		fieldEnum = _TxSlewFallDq_4_;
	} else if (strcmp(field, "TxSlewFallDq[5]") == 0) {
		fieldEnum = _TxSlewFallDq_5_;
	} else if (strcmp(field, "TxSlewFallDq[6]") == 0) {
		fieldEnum = _TxSlewFallDq_6_;
	} else if (strcmp(field, "TxSlewFallDq[7]") == 0) {
		fieldEnum = _TxSlewFallDq_7_;
	} else if (strcmp(field, "TxSlewFallDq[8]") == 0) {
		fieldEnum = _TxSlewFallDq_8_;
	} else if (strcmp(field, "TxSlewFallDq[9]") == 0) {
		fieldEnum = _TxSlewFallDq_9_;
	} else if (strcmp(field, "TxSlewFallDq[10]") == 0) {
		fieldEnum = _TxSlewFallDq_10_;
	} else if (strcmp(field, "TxSlewFallDq[11]") == 0) {
		fieldEnum = _TxSlewFallDq_11_;
	} else if (strcmp(field, "TxSlewFallDq[12]") == 0) {
		fieldEnum = _TxSlewFallDq_12_;
	} else if (strcmp(field, "TxSlewFallDq[13]") == 0) {
		fieldEnum = _TxSlewFallDq_13_;
	} else if (strcmp(field, "TxSlewFallDq[14]") == 0) {
		fieldEnum = _TxSlewFallDq_14_;
	} else if (strcmp(field, "DisablePmuEcc") == 0) {
		fieldEnum = _DisablePmuEcc_;
	} else if (strcmp(field, "ExtCalResVal") == 0) {
		fieldEnum = _ExtCalResVal_;
	} else if (strcmp(field, "TxImpedanceWCK[0]") == 0) {
		fieldEnum = _TxImpedanceWCK_0_;
	} else if (strcmp(field, "TxImpedanceWCK[1]") == 0) {
		fieldEnum = _TxImpedanceWCK_1_;
	} else if (strcmp(field, "TxImpedanceWCK[2]") == 0) {
		fieldEnum = _TxImpedanceWCK_2_;
	} else if (strcmp(field, "TxImpedanceWCK[3]") == 0) {
		fieldEnum = _TxImpedanceWCK_3_;
	} else if (strcmp(field, "TxImpedanceWCK[4]") == 0) {
		fieldEnum = _TxImpedanceWCK_4_;
	} else if (strcmp(field, "TxImpedanceWCK[5]") == 0) {
		fieldEnum = _TxImpedanceWCK_5_;
	} else if (strcmp(field, "TxImpedanceWCK[6]") == 0) {
		fieldEnum = _TxImpedanceWCK_6_;
	} else if (strcmp(field, "TxImpedanceWCK[7]") == 0) {
		fieldEnum = _TxImpedanceWCK_7_;
	} else if (strcmp(field, "TxImpedanceWCK[8]") == 0) {
		fieldEnum = _TxImpedanceWCK_8_;
	} else if (strcmp(field, "TxImpedanceWCK[9]") == 0) {
		fieldEnum = _TxImpedanceWCK_9_;
	} else if (strcmp(field, "TxImpedanceWCK[10]") == 0) {
		fieldEnum = _TxImpedanceWCK_10_;
	} else if (strcmp(field, "TxImpedanceWCK[11]") == 0) {
		fieldEnum = _TxImpedanceWCK_11_;
	} else if (strcmp(field, "TxImpedanceWCK[12]") == 0) {
		fieldEnum = _TxImpedanceWCK_12_;
	} else if (strcmp(field, "TxImpedanceWCK[13]") == 0) {
		fieldEnum = _TxImpedanceWCK_13_;
	} else if (strcmp(field, "TxImpedanceWCK[14]") == 0) {
		fieldEnum = _TxImpedanceWCK_14_;
	} else if (strcmp(field, "TxSlewRiseDqs[0]") == 0) {
		fieldEnum = _TxSlewRiseDqs_0_;
	} else if (strcmp(field, "TxSlewRiseDqs[1]") == 0) {
		fieldEnum = _TxSlewRiseDqs_1_;
	} else if (strcmp(field, "TxSlewRiseDqs[2]") == 0) {
		fieldEnum = _TxSlewRiseDqs_2_;
	} else if (strcmp(field, "TxSlewRiseDqs[3]") == 0) {
		fieldEnum = _TxSlewRiseDqs_3_;
	} else if (strcmp(field, "TxSlewRiseDqs[4]") == 0) {
		fieldEnum = _TxSlewRiseDqs_4_;
	} else if (strcmp(field, "TxSlewRiseDqs[5]") == 0) {
		fieldEnum = _TxSlewRiseDqs_5_;
	} else if (strcmp(field, "TxSlewRiseDqs[6]") == 0) {
		fieldEnum = _TxSlewRiseDqs_6_;
	} else if (strcmp(field, "TxSlewRiseDqs[7]") == 0) {
		fieldEnum = _TxSlewRiseDqs_7_;
	} else if (strcmp(field, "TxSlewRiseDqs[8]") == 0) {
		fieldEnum = _TxSlewRiseDqs_8_;
	} else if (strcmp(field, "TxSlewRiseDqs[9]") == 0) {
		fieldEnum = _TxSlewRiseDqs_9_;
	} else if (strcmp(field, "TxSlewRiseDqs[10]") == 0) {
		fieldEnum = _TxSlewRiseDqs_10_;
	} else if (strcmp(field, "TxSlewRiseDqs[11]") == 0) {
		fieldEnum = _TxSlewRiseDqs_11_;
	} else if (strcmp(field, "TxSlewRiseDqs[12]") == 0) {
		fieldEnum = _TxSlewRiseDqs_12_;
	} else if (strcmp(field, "TxSlewRiseDqs[13]") == 0) {
		fieldEnum = _TxSlewRiseDqs_13_;
	} else if (strcmp(field, "TxSlewRiseDqs[14]") == 0) {
		fieldEnum = _TxSlewRiseDqs_14_;
	} else if (strcmp(field, "TxSlewRiseWCK[0]") == 0) {
		fieldEnum = _TxSlewRiseWCK_0_;
	} else if (strcmp(field, "TxSlewRiseWCK[1]") == 0) {
		fieldEnum = _TxSlewRiseWCK_1_;
	} else if (strcmp(field, "TxSlewRiseWCK[2]") == 0) {
		fieldEnum = _TxSlewRiseWCK_2_;
	} else if (strcmp(field, "TxSlewRiseWCK[3]") == 0) {
		fieldEnum = _TxSlewRiseWCK_3_;
	} else if (strcmp(field, "TxSlewRiseWCK[4]") == 0) {
		fieldEnum = _TxSlewRiseWCK_4_;
	} else if (strcmp(field, "TxSlewRiseWCK[5]") == 0) {
		fieldEnum = _TxSlewRiseWCK_5_;
	} else if (strcmp(field, "TxSlewRiseWCK[6]") == 0) {
		fieldEnum = _TxSlewRiseWCK_6_;
	} else if (strcmp(field, "TxSlewRiseWCK[7]") == 0) {
		fieldEnum = _TxSlewRiseWCK_7_;
	} else if (strcmp(field, "TxSlewRiseWCK[8]") == 0) {
		fieldEnum = _TxSlewRiseWCK_8_;
	} else if (strcmp(field, "TxSlewRiseWCK[9]") == 0) {
		fieldEnum = _TxSlewRiseWCK_9_;
	} else if (strcmp(field, "TxSlewRiseWCK[10]") == 0) {
		fieldEnum = _TxSlewRiseWCK_10_;
	} else if (strcmp(field, "TxSlewRiseWCK[11]") == 0) {
		fieldEnum = _TxSlewRiseWCK_11_;
	} else if (strcmp(field, "TxSlewRiseWCK[12]") == 0) {
		fieldEnum = _TxSlewRiseWCK_12_;
	} else if (strcmp(field, "TxSlewRiseWCK[13]") == 0) {
		fieldEnum = _TxSlewRiseWCK_13_;
	} else if (strcmp(field, "TxSlewRiseWCK[14]") == 0) {
		fieldEnum = _TxSlewRiseWCK_14_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[0]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_0_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[1]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_1_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[2]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_2_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[3]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_3_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[4]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_4_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[5]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_5_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[6]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_6_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[7]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_7_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[8]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_8_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[9]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_9_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[10]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_10_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[11]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_11_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[12]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_12_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[13]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_13_;
	} else if (strcmp(field, "RxBiasCurrentControlDqs[14]") == 0) {
		fieldEnum = _RxBiasCurrentControlDqs_14_;
	} else if (strcmp(field, "RxClkTrackWait") == 0) {
		fieldEnum = _RxClkTrackWait_;
	} else if (strcmp(field, "CalOnce") == 0) {
		fieldEnum = _CalOnce_;
	} else if (strcmp(field, "PhyMstrCtrlMode[0]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_0_;
	} else if (strcmp(field, "PhyMstrCtrlMode[1]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_1_;
	} else if (strcmp(field, "PhyMstrCtrlMode[2]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_2_;
	} else if (strcmp(field, "PhyMstrCtrlMode[3]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_3_;
	} else if (strcmp(field, "PhyMstrCtrlMode[4]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_4_;
	} else if (strcmp(field, "PhyMstrCtrlMode[5]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_5_;
	} else if (strcmp(field, "PhyMstrCtrlMode[6]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_6_;
	} else if (strcmp(field, "PhyMstrCtrlMode[7]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_7_;
	} else if (strcmp(field, "PhyMstrCtrlMode[8]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_8_;
	} else if (strcmp(field, "PhyMstrCtrlMode[9]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_9_;
	} else if (strcmp(field, "PhyMstrCtrlMode[10]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_10_;
	} else if (strcmp(field, "PhyMstrCtrlMode[11]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_11_;
	} else if (strcmp(field, "PhyMstrCtrlMode[12]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_12_;
	} else if (strcmp(field, "PhyMstrCtrlMode[13]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_13_;
	} else if (strcmp(field, "PhyMstrCtrlMode[14]") == 0) {
		fieldEnum = _PhyMstrCtrlMode_14_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[0]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_0_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[1]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_1_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[2]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_2_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[3]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_3_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[4]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_4_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[5]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_5_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[6]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_6_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[7]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_7_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[8]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_8_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[9]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_9_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[10]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_10_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[11]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_11_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[12]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_12_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[13]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_13_;
	} else if (strcmp(field, "RxVrefKickbackNoiseCancellation[14]") == 0) {
		fieldEnum = _RxVrefKickbackNoiseCancellation_14_;
	} else if (strcmp(field, "RxClkTrackWaitUI") == 0) {
		fieldEnum = _RxClkTrackWaitUI_;
	} else if (strcmp(field, "TxImpedanceDq[0]") == 0) {
		fieldEnum = _TxImpedanceDq_0_;
	} else if (strcmp(field, "TxImpedanceDq[1]") == 0) {
		fieldEnum = _TxImpedanceDq_1_;
	} else if (strcmp(field, "TxImpedanceDq[2]") == 0) {
		fieldEnum = _TxImpedanceDq_2_;
	} else if (strcmp(field, "TxImpedanceDq[3]") == 0) {
		fieldEnum = _TxImpedanceDq_3_;
	} else if (strcmp(field, "TxImpedanceDq[4]") == 0) {
		fieldEnum = _TxImpedanceDq_4_;
	} else if (strcmp(field, "TxImpedanceDq[5]") == 0) {
		fieldEnum = _TxImpedanceDq_5_;
	} else if (strcmp(field, "TxImpedanceDq[6]") == 0) {
		fieldEnum = _TxImpedanceDq_6_;
	} else if (strcmp(field, "TxImpedanceDq[7]") == 0) {
		fieldEnum = _TxImpedanceDq_7_;
	} else if (strcmp(field, "TxImpedanceDq[8]") == 0) {
		fieldEnum = _TxImpedanceDq_8_;
	} else if (strcmp(field, "TxImpedanceDq[9]") == 0) {
		fieldEnum = _TxImpedanceDq_9_;
	} else if (strcmp(field, "TxImpedanceDq[10]") == 0) {
		fieldEnum = _TxImpedanceDq_10_;
	} else if (strcmp(field, "TxImpedanceDq[11]") == 0) {
		fieldEnum = _TxImpedanceDq_11_;
	} else if (strcmp(field, "TxImpedanceDq[12]") == 0) {
		fieldEnum = _TxImpedanceDq_12_;
	} else if (strcmp(field, "TxImpedanceDq[13]") == 0) {
		fieldEnum = _TxImpedanceDq_13_;
	} else if (strcmp(field, "TxImpedanceDq[14]") == 0) {
		fieldEnum = _TxImpedanceDq_14_;
	} else if (strcmp(field, "OnlyRestoreNonPsRegs") == 0) {
		fieldEnum = _OnlyRestoreNonPsRegs_;
	} else if (strcmp(field, "TrainSequenceCtrl") == 0) {
		fieldEnum = _TrainSequenceCtrl_;
	} else if (strcmp(field, "TxImpedanceCk[0]") == 0) {
		fieldEnum = _TxImpedanceCk_0_;
	} else if (strcmp(field, "TxImpedanceCk[1]") == 0) {
		fieldEnum = _TxImpedanceCk_1_;
	} else if (strcmp(field, "TxImpedanceCk[2]") == 0) {
		fieldEnum = _TxImpedanceCk_2_;
	} else if (strcmp(field, "TxImpedanceCk[3]") == 0) {
		fieldEnum = _TxImpedanceCk_3_;
	} else if (strcmp(field, "TxImpedanceCk[4]") == 0) {
		fieldEnum = _TxImpedanceCk_4_;
	} else if (strcmp(field, "TxImpedanceCk[5]") == 0) {
		fieldEnum = _TxImpedanceCk_5_;
	} else if (strcmp(field, "TxImpedanceCk[6]") == 0) {
		fieldEnum = _TxImpedanceCk_6_;
	} else if (strcmp(field, "TxImpedanceCk[7]") == 0) {
		fieldEnum = _TxImpedanceCk_7_;
	} else if (strcmp(field, "TxImpedanceCk[8]") == 0) {
		fieldEnum = _TxImpedanceCk_8_;
	} else if (strcmp(field, "TxImpedanceCk[9]") == 0) {
		fieldEnum = _TxImpedanceCk_9_;
	} else if (strcmp(field, "TxImpedanceCk[10]") == 0) {
		fieldEnum = _TxImpedanceCk_10_;
	} else if (strcmp(field, "TxImpedanceCk[11]") == 0) {
		fieldEnum = _TxImpedanceCk_11_;
	} else if (strcmp(field, "TxImpedanceCk[12]") == 0) {
		fieldEnum = _TxImpedanceCk_12_;
	} else if (strcmp(field, "TxImpedanceCk[13]") == 0) {
		fieldEnum = _TxImpedanceCk_13_;
	} else if (strcmp(field, "TxImpedanceCk[14]") == 0) {
		fieldEnum = _TxImpedanceCk_14_;
	} else if (strcmp(field, "DisableFspOp") == 0) {
		fieldEnum = _DisableFspOp_;
	} else if (strcmp(field, "TxImpedanceDTO[0]") == 0) {
		fieldEnum = _TxImpedanceDTO_0_;
	} else if (strcmp(field, "TxImpedanceDTO[1]") == 0) {
		fieldEnum = _TxImpedanceDTO_1_;
	} else if (strcmp(field, "TxImpedanceDTO[2]") == 0) {
		fieldEnum = _TxImpedanceDTO_2_;
	} else if (strcmp(field, "TxImpedanceDTO[3]") == 0) {
		fieldEnum = _TxImpedanceDTO_3_;
	} else if (strcmp(field, "TxImpedanceDTO[4]") == 0) {
		fieldEnum = _TxImpedanceDTO_4_;
	} else if (strcmp(field, "TxImpedanceDTO[5]") == 0) {
		fieldEnum = _TxImpedanceDTO_5_;
	} else if (strcmp(field, "TxImpedanceDTO[6]") == 0) {
		fieldEnum = _TxImpedanceDTO_6_;
	} else if (strcmp(field, "TxImpedanceDTO[7]") == 0) {
		fieldEnum = _TxImpedanceDTO_7_;
	} else if (strcmp(field, "TxImpedanceDTO[8]") == 0) {
		fieldEnum = _TxImpedanceDTO_8_;
	} else if (strcmp(field, "TxImpedanceDTO[9]") == 0) {
		fieldEnum = _TxImpedanceDTO_9_;
	} else if (strcmp(field, "TxImpedanceDTO[10]") == 0) {
		fieldEnum = _TxImpedanceDTO_10_;
	} else if (strcmp(field, "TxImpedanceDTO[11]") == 0) {
		fieldEnum = _TxImpedanceDTO_11_;
	} else if (strcmp(field, "TxImpedanceDTO[12]") == 0) {
		fieldEnum = _TxImpedanceDTO_12_;
	} else if (strcmp(field, "TxImpedanceDTO[13]") == 0) {
		fieldEnum = _TxImpedanceDTO_13_;
	} else if (strcmp(field, "TxImpedanceDTO[14]") == 0) {
		fieldEnum = _TxImpedanceDTO_14_;
	} else if (strcmp(field, "EnRxDqsTracking[0]") == 0) {
		fieldEnum = _EnRxDqsTracking_0_;
	} else if (strcmp(field, "EnRxDqsTracking[1]") == 0) {
		fieldEnum = _EnRxDqsTracking_1_;
	} else if (strcmp(field, "EnRxDqsTracking[2]") == 0) {
		fieldEnum = _EnRxDqsTracking_2_;
	} else if (strcmp(field, "EnRxDqsTracking[3]") == 0) {
		fieldEnum = _EnRxDqsTracking_3_;
	} else if (strcmp(field, "EnRxDqsTracking[4]") == 0) {
		fieldEnum = _EnRxDqsTracking_4_;
	} else if (strcmp(field, "EnRxDqsTracking[5]") == 0) {
		fieldEnum = _EnRxDqsTracking_5_;
	} else if (strcmp(field, "EnRxDqsTracking[6]") == 0) {
		fieldEnum = _EnRxDqsTracking_6_;
	} else if (strcmp(field, "EnRxDqsTracking[7]") == 0) {
		fieldEnum = _EnRxDqsTracking_7_;
	} else if (strcmp(field, "EnRxDqsTracking[8]") == 0) {
		fieldEnum = _EnRxDqsTracking_8_;
	} else if (strcmp(field, "EnRxDqsTracking[9]") == 0) {
		fieldEnum = _EnRxDqsTracking_9_;
	} else if (strcmp(field, "EnRxDqsTracking[10]") == 0) {
		fieldEnum = _EnRxDqsTracking_10_;
	} else if (strcmp(field, "EnRxDqsTracking[11]") == 0) {
		fieldEnum = _EnRxDqsTracking_11_;
	} else if (strcmp(field, "EnRxDqsTracking[12]") == 0) {
		fieldEnum = _EnRxDqsTracking_12_;
	} else if (strcmp(field, "EnRxDqsTracking[13]") == 0) {
		fieldEnum = _EnRxDqsTracking_13_;
	} else if (strcmp(field, "EnRxDqsTracking[14]") == 0) {
		fieldEnum = _EnRxDqsTracking_14_;
	} else if (strcmp(field, "CalInterval") == 0) {
		fieldEnum = _CalInterval_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[0]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_0_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[1]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_1_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[2]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_2_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[3]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_3_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[4]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_4_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[5]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_5_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[6]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_6_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[7]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_7_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[8]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_8_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[9]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_9_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[10]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_10_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[11]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_11_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[12]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_12_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[13]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_13_;
	} else if (strcmp(field, "RxBiasCurrentControlWck[14]") == 0) {
		fieldEnum = _RxBiasCurrentControlWck_14_;
	} else if (strcmp(field, "RetrainMode[0]") == 0) {
		fieldEnum = _RetrainMode_0_;
	} else if (strcmp(field, "RetrainMode[1]") == 0) {
		fieldEnum = _RetrainMode_1_;
	} else if (strcmp(field, "RetrainMode[2]") == 0) {
		fieldEnum = _RetrainMode_2_;
	} else if (strcmp(field, "RetrainMode[3]") == 0) {
		fieldEnum = _RetrainMode_3_;
	} else if (strcmp(field, "RetrainMode[4]") == 0) {
		fieldEnum = _RetrainMode_4_;
	} else if (strcmp(field, "RetrainMode[5]") == 0) {
		fieldEnum = _RetrainMode_5_;
	} else if (strcmp(field, "RetrainMode[6]") == 0) {
		fieldEnum = _RetrainMode_6_;
	} else if (strcmp(field, "RetrainMode[7]") == 0) {
		fieldEnum = _RetrainMode_7_;
	} else if (strcmp(field, "RetrainMode[8]") == 0) {
		fieldEnum = _RetrainMode_8_;
	} else if (strcmp(field, "RetrainMode[9]") == 0) {
		fieldEnum = _RetrainMode_9_;
	} else if (strcmp(field, "RetrainMode[10]") == 0) {
		fieldEnum = _RetrainMode_10_;
	} else if (strcmp(field, "RetrainMode[11]") == 0) {
		fieldEnum = _RetrainMode_11_;
	} else if (strcmp(field, "RetrainMode[12]") == 0) {
		fieldEnum = _RetrainMode_12_;
	} else if (strcmp(field, "RetrainMode[13]") == 0) {
		fieldEnum = _RetrainMode_13_;
	} else if (strcmp(field, "RetrainMode[14]") == 0) {
		fieldEnum = _RetrainMode_14_;
	} else if (strcmp(field, "RxVrefDACEnable[0]") == 0) {
		fieldEnum = _RxVrefDACEnable_0_;
	} else if (strcmp(field, "RxVrefDACEnable[1]") == 0) {
		fieldEnum = _RxVrefDACEnable_1_;
	} else if (strcmp(field, "RxVrefDACEnable[2]") == 0) {
		fieldEnum = _RxVrefDACEnable_2_;
	} else if (strcmp(field, "RxVrefDACEnable[3]") == 0) {
		fieldEnum = _RxVrefDACEnable_3_;
	} else if (strcmp(field, "RxVrefDACEnable[4]") == 0) {
		fieldEnum = _RxVrefDACEnable_4_;
	} else if (strcmp(field, "RxVrefDACEnable[5]") == 0) {
		fieldEnum = _RxVrefDACEnable_5_;
	} else if (strcmp(field, "RxVrefDACEnable[6]") == 0) {
		fieldEnum = _RxVrefDACEnable_6_;
	} else if (strcmp(field, "RxVrefDACEnable[7]") == 0) {
		fieldEnum = _RxVrefDACEnable_7_;
	} else if (strcmp(field, "RxVrefDACEnable[8]") == 0) {
		fieldEnum = _RxVrefDACEnable_8_;
	} else if (strcmp(field, "RxVrefDACEnable[9]") == 0) {
		fieldEnum = _RxVrefDACEnable_9_;
	} else if (strcmp(field, "RxVrefDACEnable[10]") == 0) {
		fieldEnum = _RxVrefDACEnable_10_;
	} else if (strcmp(field, "RxVrefDACEnable[11]") == 0) {
		fieldEnum = _RxVrefDACEnable_11_;
	} else if (strcmp(field, "RxVrefDACEnable[12]") == 0) {
		fieldEnum = _RxVrefDACEnable_12_;
	} else if (strcmp(field, "RxVrefDACEnable[13]") == 0) {
		fieldEnum = _RxVrefDACEnable_13_;
	} else if (strcmp(field, "RxVrefDACEnable[14]") == 0) {
		fieldEnum = _RxVrefDACEnable_14_;
	} else if (strcmp(field, "PhyMstrTrainInterval[0]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_0_;
	} else if (strcmp(field, "PhyMstrTrainInterval[1]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_1_;
	} else if (strcmp(field, "PhyMstrTrainInterval[2]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_2_;
	} else if (strcmp(field, "PhyMstrTrainInterval[3]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_3_;
	} else if (strcmp(field, "PhyMstrTrainInterval[4]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_4_;
	} else if (strcmp(field, "PhyMstrTrainInterval[5]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_5_;
	} else if (strcmp(field, "PhyMstrTrainInterval[6]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_6_;
	} else if (strcmp(field, "PhyMstrTrainInterval[7]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_7_;
	} else if (strcmp(field, "PhyMstrTrainInterval[8]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_8_;
	} else if (strcmp(field, "PhyMstrTrainInterval[9]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_9_;
	} else if (strcmp(field, "PhyMstrTrainInterval[10]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_10_;
	} else if (strcmp(field, "PhyMstrTrainInterval[11]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_11_;
	} else if (strcmp(field, "PhyMstrTrainInterval[12]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_12_;
	} else if (strcmp(field, "PhyMstrTrainInterval[13]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_13_;
	} else if (strcmp(field, "PhyMstrTrainInterval[14]") == 0) {
		fieldEnum = _PhyMstrTrainInterval_14_;
	} else if (strcmp(field, "Lp3DramState[0]") == 0) {
		fieldEnum = _Lp3DramState_0_;
	} else if (strcmp(field, "Lp3DramState[1]") == 0) {
		fieldEnum = _Lp3DramState_1_;
	} else if (strcmp(field, "Lp3DramState[2]") == 0) {
		fieldEnum = _Lp3DramState_2_;
	} else if (strcmp(field, "Lp3DramState[3]") == 0) {
		fieldEnum = _Lp3DramState_3_;
	} else if (strcmp(field, "Lp3DramState[4]") == 0) {
		fieldEnum = _Lp3DramState_4_;
	} else if (strcmp(field, "Lp3DramState[5]") == 0) {
		fieldEnum = _Lp3DramState_5_;
	} else if (strcmp(field, "Lp3DramState[6]") == 0) {
		fieldEnum = _Lp3DramState_6_;
	} else if (strcmp(field, "Lp3DramState[7]") == 0) {
		fieldEnum = _Lp3DramState_7_;
	} else if (strcmp(field, "Lp3DramState[8]") == 0) {
		fieldEnum = _Lp3DramState_8_;
	} else if (strcmp(field, "Lp3DramState[9]") == 0) {
		fieldEnum = _Lp3DramState_9_;
	} else if (strcmp(field, "Lp3DramState[10]") == 0) {
		fieldEnum = _Lp3DramState_10_;
	} else if (strcmp(field, "Lp3DramState[11]") == 0) {
		fieldEnum = _Lp3DramState_11_;
	} else if (strcmp(field, "Lp3DramState[12]") == 0) {
		fieldEnum = _Lp3DramState_12_;
	} else if (strcmp(field, "Lp3DramState[13]") == 0) {
		fieldEnum = _Lp3DramState_13_;
	} else if (strcmp(field, "Lp3DramState[14]") == 0) {
		fieldEnum = _Lp3DramState_14_;
	} else if (strcmp(field, "PmuClockDiv[0]") == 0) {
		fieldEnum = _PmuClockDiv_0_;
	} else if (strcmp(field, "PmuClockDiv[1]") == 0) {
		fieldEnum = _PmuClockDiv_1_;
	} else if (strcmp(field, "PmuClockDiv[2]") == 0) {
		fieldEnum = _PmuClockDiv_2_;
	} else if (strcmp(field, "PmuClockDiv[3]") == 0) {
		fieldEnum = _PmuClockDiv_3_;
	} else if (strcmp(field, "PmuClockDiv[4]") == 0) {
		fieldEnum = _PmuClockDiv_4_;
	} else if (strcmp(field, "PmuClockDiv[5]") == 0) {
		fieldEnum = _PmuClockDiv_5_;
	} else if (strcmp(field, "PmuClockDiv[6]") == 0) {
		fieldEnum = _PmuClockDiv_6_;
	} else if (strcmp(field, "PmuClockDiv[7]") == 0) {
		fieldEnum = _PmuClockDiv_7_;
	} else if (strcmp(field, "PmuClockDiv[8]") == 0) {
		fieldEnum = _PmuClockDiv_8_;
	} else if (strcmp(field, "PmuClockDiv[9]") == 0) {
		fieldEnum = _PmuClockDiv_9_;
	} else if (strcmp(field, "PmuClockDiv[10]") == 0) {
		fieldEnum = _PmuClockDiv_10_;
	} else if (strcmp(field, "PmuClockDiv[11]") == 0) {
		fieldEnum = _PmuClockDiv_11_;
	} else if (strcmp(field, "PmuClockDiv[12]") == 0) {
		fieldEnum = _PmuClockDiv_12_;
	} else if (strcmp(field, "PmuClockDiv[13]") == 0) {
		fieldEnum = _PmuClockDiv_13_;
	} else if (strcmp(field, "PmuClockDiv[14]") == 0) {
		fieldEnum = _PmuClockDiv_14_;
	} else if (strcmp(field, "WDQSExt") == 0) {
		fieldEnum = _WDQSExt_;
	} else if (strcmp(field, "DisablePhyUpdate") == 0) {
		fieldEnum = _DisablePhyUpdate_;
	} else if (strcmp(field, "OdtImpedanceCa[0]") == 0) {
		fieldEnum = _OdtImpedanceCa_0_;
	} else if (strcmp(field, "OdtImpedanceCa[1]") == 0) {
		fieldEnum = _OdtImpedanceCa_1_;
	} else if (strcmp(field, "OdtImpedanceCa[2]") == 0) {
		fieldEnum = _OdtImpedanceCa_2_;
	} else if (strcmp(field, "OdtImpedanceCa[3]") == 0) {
		fieldEnum = _OdtImpedanceCa_3_;
	} else if (strcmp(field, "OdtImpedanceCa[4]") == 0) {
		fieldEnum = _OdtImpedanceCa_4_;
	} else if (strcmp(field, "OdtImpedanceCa[5]") == 0) {
		fieldEnum = _OdtImpedanceCa_5_;
	} else if (strcmp(field, "OdtImpedanceCa[6]") == 0) {
		fieldEnum = _OdtImpedanceCa_6_;
	} else if (strcmp(field, "OdtImpedanceCa[7]") == 0) {
		fieldEnum = _OdtImpedanceCa_7_;
	} else if (strcmp(field, "OdtImpedanceCa[8]") == 0) {
		fieldEnum = _OdtImpedanceCa_8_;
	} else if (strcmp(field, "OdtImpedanceCa[9]") == 0) {
		fieldEnum = _OdtImpedanceCa_9_;
	} else if (strcmp(field, "OdtImpedanceCa[10]") == 0) {
		fieldEnum = _OdtImpedanceCa_10_;
	} else if (strcmp(field, "OdtImpedanceCa[11]") == 0) {
		fieldEnum = _OdtImpedanceCa_11_;
	} else if (strcmp(field, "OdtImpedanceCa[12]") == 0) {
		fieldEnum = _OdtImpedanceCa_12_;
	} else if (strcmp(field, "OdtImpedanceCa[13]") == 0) {
		fieldEnum = _OdtImpedanceCa_13_;
	} else if (strcmp(field, "OdtImpedanceCa[14]") == 0) {
		fieldEnum = _OdtImpedanceCa_14_;
	} else if (strcmp(field, "SkipFlashCopy[0]") == 0) {
		fieldEnum = _SkipFlashCopy_0_;
	} else if (strcmp(field, "SkipFlashCopy[1]") == 0) {
		fieldEnum = _SkipFlashCopy_1_;
	} else if (strcmp(field, "SkipFlashCopy[2]") == 0) {
		fieldEnum = _SkipFlashCopy_2_;
	} else if (strcmp(field, "SkipFlashCopy[3]") == 0) {
		fieldEnum = _SkipFlashCopy_3_;
	} else if (strcmp(field, "SkipFlashCopy[4]") == 0) {
		fieldEnum = _SkipFlashCopy_4_;
	} else if (strcmp(field, "SkipFlashCopy[5]") == 0) {
		fieldEnum = _SkipFlashCopy_5_;
	} else if (strcmp(field, "SkipFlashCopy[6]") == 0) {
		fieldEnum = _SkipFlashCopy_6_;
	} else if (strcmp(field, "SkipFlashCopy[7]") == 0) {
		fieldEnum = _SkipFlashCopy_7_;
	} else if (strcmp(field, "SkipFlashCopy[8]") == 0) {
		fieldEnum = _SkipFlashCopy_8_;
	} else if (strcmp(field, "SkipFlashCopy[9]") == 0) {
		fieldEnum = _SkipFlashCopy_9_;
	} else if (strcmp(field, "SkipFlashCopy[10]") == 0) {
		fieldEnum = _SkipFlashCopy_10_;
	} else if (strcmp(field, "SkipFlashCopy[11]") == 0) {
		fieldEnum = _SkipFlashCopy_11_;
	} else if (strcmp(field, "SkipFlashCopy[12]") == 0) {
		fieldEnum = _SkipFlashCopy_12_;
	} else if (strcmp(field, "SkipFlashCopy[13]") == 0) {
		fieldEnum = _SkipFlashCopy_13_;
	} else if (strcmp(field, "SkipFlashCopy[14]") == 0) {
		fieldEnum = _SkipFlashCopy_14_;
	} else if (strcmp(field, "DqsOscRunTimeSel[0]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_0_;
	} else if (strcmp(field, "DqsOscRunTimeSel[1]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_1_;
	} else if (strcmp(field, "DqsOscRunTimeSel[2]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_2_;
	} else if (strcmp(field, "DqsOscRunTimeSel[3]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_3_;
	} else if (strcmp(field, "DqsOscRunTimeSel[4]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_4_;
	} else if (strcmp(field, "DqsOscRunTimeSel[5]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_5_;
	} else if (strcmp(field, "DqsOscRunTimeSel[6]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_6_;
	} else if (strcmp(field, "DqsOscRunTimeSel[7]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_7_;
	} else if (strcmp(field, "DqsOscRunTimeSel[8]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_8_;
	} else if (strcmp(field, "DqsOscRunTimeSel[9]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_9_;
	} else if (strcmp(field, "DqsOscRunTimeSel[10]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_10_;
	} else if (strcmp(field, "DqsOscRunTimeSel[11]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_11_;
	} else if (strcmp(field, "DqsOscRunTimeSel[12]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_12_;
	} else if (strcmp(field, "DqsOscRunTimeSel[13]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_13_;
	} else if (strcmp(field, "DqsOscRunTimeSel[14]") == 0) {
		fieldEnum = _DqsOscRunTimeSel_14_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[0]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_0_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[1]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_1_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[2]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_2_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[3]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_3_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[4]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_4_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[5]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_5_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[6]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_6_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[7]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_7_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[8]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_8_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[9]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_9_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[10]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_10_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[11]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_11_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[12]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_12_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[13]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_13_;
	} else if (strcmp(field, "RxBiasCurrentControlCk[14]") == 0) {
		fieldEnum = _RxBiasCurrentControlCk_14_;
	} else if (strcmp(field, "NumPStates") == 0) {
		fieldEnum = _NumPStates_;
	} else if (strcmp(field, "NumRank_dfi0") == 0) {
		fieldEnum = _NumRank_dfi0_;
	} else if (strcmp(field, "HardMacroVer") == 0) {
		fieldEnum = _HardMacroVer_;
	} else if (strcmp(field, "NumCh") == 0) {
		fieldEnum = _NumCh_;
	} else if (strcmp(field, "DimmType") == 0) {
		fieldEnum = _DimmType_;
	} else if (strcmp(field, "DramType") == 0) {
		fieldEnum = _DramType_;
	} else if (strcmp(field, "DfiFreqRatio[0]") == 0) {
		fieldEnum = _DfiFreqRatio_0_;
	} else if (strcmp(field, "DfiFreqRatio[1]") == 0) {
		fieldEnum = _DfiFreqRatio_1_;
	} else if (strcmp(field, "DfiFreqRatio[2]") == 0) {
		fieldEnum = _DfiFreqRatio_2_;
	} else if (strcmp(field, "DfiFreqRatio[3]") == 0) {
		fieldEnum = _DfiFreqRatio_3_;
	} else if (strcmp(field, "DfiFreqRatio[4]") == 0) {
		fieldEnum = _DfiFreqRatio_4_;
	} else if (strcmp(field, "DfiFreqRatio[5]") == 0) {
		fieldEnum = _DfiFreqRatio_5_;
	} else if (strcmp(field, "DfiFreqRatio[6]") == 0) {
		fieldEnum = _DfiFreqRatio_6_;
	} else if (strcmp(field, "DfiFreqRatio[7]") == 0) {
		fieldEnum = _DfiFreqRatio_7_;
	} else if (strcmp(field, "DfiFreqRatio[8]") == 0) {
		fieldEnum = _DfiFreqRatio_8_;
	} else if (strcmp(field, "DfiFreqRatio[9]") == 0) {
		fieldEnum = _DfiFreqRatio_9_;
	} else if (strcmp(field, "DfiFreqRatio[10]") == 0) {
		fieldEnum = _DfiFreqRatio_10_;
	} else if (strcmp(field, "DfiFreqRatio[11]") == 0) {
		fieldEnum = _DfiFreqRatio_11_;
	} else if (strcmp(field, "DfiFreqRatio[12]") == 0) {
		fieldEnum = _DfiFreqRatio_12_;
	} else if (strcmp(field, "DfiFreqRatio[13]") == 0) {
		fieldEnum = _DfiFreqRatio_13_;
	} else if (strcmp(field, "DfiFreqRatio[14]") == 0) {
		fieldEnum = _DfiFreqRatio_14_;
	} else if (strcmp(field, "FirstPState") == 0) {
		fieldEnum = _FirstPState_;
	} else if (strcmp(field, "NumActiveDbyteDfi1") == 0) {
		fieldEnum = _NumActiveDbyteDfi1_;
	} else if (strcmp(field, "NumRank") == 0) {
		fieldEnum = _NumRank_;
	} else if (strcmp(field, "DramDataWidth") == 0) {
		fieldEnum = _DramDataWidth_;
	} else if (strcmp(field, "CfgPStates") == 0) {
		fieldEnum = _CfgPStates_;
	} else if (strcmp(field, "Frequency[0]") == 0) {
		fieldEnum = _Frequency_0_;
	} else if (strcmp(field, "Frequency[1]") == 0) {
		fieldEnum = _Frequency_1_;
	} else if (strcmp(field, "Frequency[2]") == 0) {
		fieldEnum = _Frequency_2_;
	} else if (strcmp(field, "Frequency[3]") == 0) {
		fieldEnum = _Frequency_3_;
	} else if (strcmp(field, "Frequency[4]") == 0) {
		fieldEnum = _Frequency_4_;
	} else if (strcmp(field, "Frequency[5]") == 0) {
		fieldEnum = _Frequency_5_;
	} else if (strcmp(field, "Frequency[6]") == 0) {
		fieldEnum = _Frequency_6_;
	} else if (strcmp(field, "Frequency[7]") == 0) {
		fieldEnum = _Frequency_7_;
	} else if (strcmp(field, "Frequency[8]") == 0) {
		fieldEnum = _Frequency_8_;
	} else if (strcmp(field, "Frequency[9]") == 0) {
		fieldEnum = _Frequency_9_;
	} else if (strcmp(field, "Frequency[10]") == 0) {
		fieldEnum = _Frequency_10_;
	} else if (strcmp(field, "Frequency[11]") == 0) {
		fieldEnum = _Frequency_11_;
	} else if (strcmp(field, "Frequency[12]") == 0) {
		fieldEnum = _Frequency_12_;
	} else if (strcmp(field, "Frequency[13]") == 0) {
		fieldEnum = _Frequency_13_;
	} else if (strcmp(field, "Frequency[14]") == 0) {
		fieldEnum = _Frequency_14_;
	} else if (strcmp(field, "PllBypass[0]") == 0) {
		fieldEnum = _PllBypass_0_;
	} else if (strcmp(field, "PllBypass[1]") == 0) {
		fieldEnum = _PllBypass_1_;
	} else if (strcmp(field, "PllBypass[2]") == 0) {
		fieldEnum = _PllBypass_2_;
	} else if (strcmp(field, "PllBypass[3]") == 0) {
		fieldEnum = _PllBypass_3_;
	} else if (strcmp(field, "PllBypass[4]") == 0) {
		fieldEnum = _PllBypass_4_;
	} else if (strcmp(field, "PllBypass[5]") == 0) {
		fieldEnum = _PllBypass_5_;
	} else if (strcmp(field, "PllBypass[6]") == 0) {
		fieldEnum = _PllBypass_6_;
	} else if (strcmp(field, "PllBypass[7]") == 0) {
		fieldEnum = _PllBypass_7_;
	} else if (strcmp(field, "PllBypass[8]") == 0) {
		fieldEnum = _PllBypass_8_;
	} else if (strcmp(field, "PllBypass[9]") == 0) {
		fieldEnum = _PllBypass_9_;
	} else if (strcmp(field, "PllBypass[10]") == 0) {
		fieldEnum = _PllBypass_10_;
	} else if (strcmp(field, "PllBypass[11]") == 0) {
		fieldEnum = _PllBypass_11_;
	} else if (strcmp(field, "PllBypass[12]") == 0) {
		fieldEnum = _PllBypass_12_;
	} else if (strcmp(field, "PllBypass[13]") == 0) {
		fieldEnum = _PllBypass_13_;
	} else if (strcmp(field, "PllBypass[14]") == 0) {
		fieldEnum = _PllBypass_14_;
	} else if (strcmp(field, "NumRank_dfi1") == 0) {
		fieldEnum = _NumRank_dfi1_;
	} else if (strcmp(field, "NumDbytesPerCh") == 0) {
		fieldEnum = _NumDbytesPerCh_;
	} else if (strcmp(field, "MaxNumZQ") == 0) {
		fieldEnum = _MaxNumZQ_;
	} else if (strcmp(field, "NumActiveDbyteDfi0") == 0) {
		fieldEnum = _NumActiveDbyteDfi0_;
	} else if (strcmp(field, "tWCK2DQO") == 0) {
		fieldEnum = _tWCK2DQO_;
	} else if (strcmp(field, "tWCK2DQI") == 0) {
		fieldEnum = _tWCK2DQI_;
	} else if (strcmp(field, "tWCK2CK") == 0) {
		fieldEnum = _tWCK2CK_;
	} else if (strcmp(field, "PHY_tDQS2DQ") == 0) {
		fieldEnum = _PHY_tDQS2DQ_;
	} else {
		fieldEnum = -1;
		dwc_ddrphy_phyinit_assert(0, " [%s] unknown PhyInit field name '%s'\n", __func__, field);
	}
	return dwc_ddrphy_phyinit_setUserInput_enum(phyctx, fieldEnum, value);
}

/** @} */
