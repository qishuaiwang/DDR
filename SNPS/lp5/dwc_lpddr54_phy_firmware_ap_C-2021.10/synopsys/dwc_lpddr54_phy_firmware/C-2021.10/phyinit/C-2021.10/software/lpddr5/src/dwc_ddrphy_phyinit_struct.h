
/** \file dwc_ddrphy_phyinit_struct.h
 *  \brief This file defines the internal data structures used in PhyInit to store user configuration.
 *
 *  Please see \ref docref to obtain necessary information for program variables
 *  correctly for your PHY variant and process technology.
 */

/**  \addtogroup structDef
 *  @{
 */

/** Enumerator for DRAM Type */
typedef enum DramTypes {
	DDR4,						/*!< DDR4 */
	DDR3,						/*!< DDR3 */
	LPDDR4,						/*!< LPDDR4 */
	LPDDR3,						/*!< LPDDR3 */
	LPDDR5						/*!< LPDDR5 */
} DramType_t;

/** Enumerator for DIMM Type */
typedef enum DimmTypes {
	UDIMM,						/*!< UDIMM */
	SODIMM,						/*!< SODIMM */
	RDIMM,						/*!< RDIMM (DDR3/DDR4 only) */
	LRDIMM,						/*!< LRDIMM (DDR4 only) */
	NODIMM						/*!< No DIMM (Soldered-on) */
} DimmType_t;

#include "dwc_ddrphy_phyinit_protocols.h"

/** \brief Structure for basic (mandatory) user inputs
 *
 * The following basic data structure must be set and completed correctly so
 * that the PhyInit software package can accurately program PHY registers.
 */
typedef struct user_input_basic {
	/**
    * @brief DRAM Module Type
    * - Choose the DDR protocol
    * - Values:
    *   Value | Description
    *   ----- | -----
    *     0x2 | LPDDR4
    *     0x4 | LPDDR5
    * - Default: 0x4
    */
	DramType_t DramType;

	/**
    * @brief DIMM type specification
    * - Choose the Dimm type
    * - Values:
    *   Value | Description
    *   ----- | -----
    *     0x0 | UDIMM
    *     0x1 | SODIMM
    *     0x2 | RDIMM
    *     0x3 | LRDIMM
    *     0x4 | NODIMM (Soldered-on)
    * - Default: 0x4
    */
	DimmType_t DimmType;

	/**
    * @brief Number of channels supported by PHY
    * - Must match RTL define DWC_DDRPHY_NUM_CHANNELS_1 and DWC_DDRPHY_NUM_CHANNELS_2
    * - Values: 1, 2
    * - Default: 1
    */
	int NumCh;

	/**
    * @brief Number of ranks supported by PHY
    * - Must match RTL define DWC_DDRPHY_NUM_RANKS_1 and DWC_DDRPHY_NUM_RANKS_2
    * - Values: 1, 2
    * - Default: 1
    */
	int NumRank;

	/**
    * @brief Number of DBYTEs per channel supported by PHY
    * - Must match RTL define DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    * - The option of DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 is not supported
    * - Values: 2
    * - Default: 2
    */
	int NumDbytesPerCh;

	/**
    * @brief Number of active DBYTEs to be controlled by DFI0
    * - See PUB databook section "Supported System Configurations" for valid settings.
    * - Values: 2
    * - Default: 2
    */
	int NumActiveDbyteDfi0;

	/**
    * @brief Number of active DBYTEs to be controlled by DFI1
    * - See PUB databook section "Supported System Configurations" for valid settings.
    * - Values: 0, 2
    * - Default: 2
    */
	int NumActiveDbyteDfi1;

	/**
    * @brief Number of active ranks in DFI0 channel
    * - See PUB databook section "Supported System Configurations" for valid settings.
    * - Values: 1, 2
    * - Default: 1
    */
	int NumRank_dfi0;

	/**
    * @brief Number of active ranks in DFI1 channel
    * - See PUB databook section "Supported System Configurations" for valid settings.
    * - Values: 0, 1, 2
    * - Default: 0
    */
	int NumRank_dfi1;

	/**
    * @brief DRAM chip data bus width
    * - See PUB databook section "Supported System Configurations" for DRAM width options supported by your PHY product.
    * @note: For mixed x8 and x16 width devices, set variable to x8.
    * - Values: 8, 16
    * - Default: 16
    */
	int DramDataWidth;

#ifdef _BUILD_LPDDR5
	/**
    * @brief Number of DRAM devices (die) sharing a ZQ resistor(LPDDR5 only).
    * - Specifies the maximum number of DRAM die within a package that can share a common external ZQ resistor.
    * - This value is used to derive the ZQ calibration time (tZQCAL).
    * - Values:
    *  - Min: 1
    *  - Max: 16
    * - Default: 4
    */
	int MaxNumZQ;
#endif

	/**
    * @brief Number of p-states used
    * - Number of p-states used, must be decimal integer between 1 and 15
    * - Values:
    *  - Min: 1
    *  - Max: 15
    * - Default: 1
    */
	int NumPStates;

	/**
    * @brief Defines which Pstates are valid
    * - Each bit position defines if the corresponding PState slot is valid.
    * - Used only when>2 Pstates are used. Number of 1's must match NumPState entry.
    * - Example: For 3 PStates used and mapped to Pstate 0,1 and 7, CfgPStates = 0x83, NumPStates=3.
    *  - Values:
    *  - Min: 0x1
    *  - Max: 0x7fff
    *
    * - Default: 0x01
    */
	int CfgPStates;

	/**
     * @brief First PState on Retention Exit and Cold Boot.
     * - In order to ensure correct state of DRAM, the initialization sequence needs to match the last
     *   trained PState with the first PState entered in Step J, ie the first
     *   set of dfi_frequency, dfi_freq_ratio and dfi_freq_fsp on cold boot must select this PState.
     * - Any valid PState can be specified.
     * - Values:
     *     Value | Description
     *     ----- | ------
     *       0x0 | PState 0
     *       0x1 | PState 1
     *       0x2 | PState 2
     *       0x3 | PState 3
     *       0x4 | PState 4
     *       0x5 | PState 5
     *       0x6 | PState 6
     *       0x7 | PState 7
     *       0x8 | PState 8
     *       0x9 | PState 9
     *       0xa | PState 10
     *       0xb | PState 11
     *       0xc | PState 12
     *       0xd | PState 13
     *       0xe | PState 14
     * - Default: 0x0
     */
	int FirstPState;

	 /**
    * @brief DRAM CK frequency
    * - Frequency of CK_t in MHz round up to next highest integer. Enter 334 for 333.333, etc.
    * - Values:
    *   - Min: 6
    *   - Max: 2133
    * - Default: 800
    */
	int Frequency[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Enable PLL Bypass
    * - Indicates if PLL should be in Bypass mode.
    * - See PUB Databook section "PLL Bypass Mode" under "Clocking and Timing" for requirements.
    * - At data rates below 667 Mbps, PLL must be in Bypass Mode.
    * - Must be set as hex.
    * - Values:
    *   Value | Description
    *   ----- | -----
    *     0x0 | Disabled
    *     0x1 | Enabled
    * - Default: 0x1
    */
	int PllBypass[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Selected dfi frequency ratio
    * - Used to program the DfiFreqRatio register. This register controls how dfi_freq_ratio
    *   input pin should be driven inaccordance with DFI Spec.
    * - For LPDDR4: this is the ratio between the DFI clock and the memory clock CK.
    * - For LPDDR5: this is the ratio between the DFI Clock and WCK. (The DFI Clock to CK clock is always a 1:1 ratio for LPDDR5.)
    * - See PUB databook section "DfiClk" for details on how to set the value.
    * - Values:
    *   Value | Description
    *   ----- | -----
    *     0x1 | 1:2
    *     0x2 | 1:4
    * - Default: 0x1
    */
	int DfiFreqRatio[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Hard Macro Family version in use
    * - Please see technology specific PHY Databook for "Hard Macro Family" version. The variable is used to fine tune analog register value settings.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | hardmacro family A
    *       1 | hardmacro family B
    *       2 | hardmacro family C
    *       3 | hardmacro family D
    *       4 | hardmacro family E
    * - Default: 0
    */
	int HardMacroVer;

#ifdef _BUILD_LPDDR4
	/**
    * @brief Indicates LPDDR4X mode support (LPDDR4 only)
    * - Indicates LPDDR4X mode support
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | LPDDR4  mode
    *     0x1 | LPDDR4X mode
    * - Default: 0x0
    */
	int Lp4xMode;
#endif

} user_input_basic_t;

/** \brief Structure for advanced (optional) user inputs
 *
 *  if user does not enter a value for these parameters, a default recommended or
 *  default value will be used
 */
typedef struct user_input_advanced {
	/**
    * @brief External impedance calibration pull-down resistor value (in ohms)
    * - Indicates value of impedance calibration pull-down resistor connected to BP_ZN pin of the PHY.
    * - Only the default option is fully verified and should not be changed without consulting Synopsys.
    * - See Section "Impedance Calibrator" section in the PUB Databook for details
    * - on PHY impedance engine and the ZN requirements for the reference external resistor.
    * - Note: setting a value of 0 tri-states the replica driver.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     120 | 120 ohm
    *      60 | 60 ohm
    *      40 | 40 ohm
    *      30 | 30 ohm
    *       0 | Hi-Z (Tristate replica driver)
    * - Default: 120
    */
	int ExtCalResVal;

	/**
	* @brief Value programmed in the PHY VrefDAC registers
	* - Sets the VREF DAC 7-bit codes in the AC and DBYTE registers directly. 
	* - Please refer to the PUB Databook for the register description.
	* - Values:
	*   - Min: 0
	*   - Max: 0x7f
	* - Default: 0x14
	*/
	int PhyVrefCode;

	/**
    * @brief Controls the current for Rx differential I/Os according to boost/non-boost VDD
    * - Controls the current for Rx differential I/Os according to boost/non-boost VDD
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | Default non-boost VDD mode
    *     0x1 | boost VDD
    * - Default: 0x0
    */
	int RxModeBoostVDD[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Enable Vref Kickback noise cancellation for Rx single-ended I/Os
    * - Enable Vref Kickback noise cancellation for Rx single-ended I/Os
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | Disable Vref kickback noise cancellation
    *     0x1 | Enable Vref kickback noise cancellation
    * - Default: 1
    */
	int RxVrefKickbackNoiseCancellation[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Enable vref DAC for CA single-ended I/Os
    * - Enable vref DAC for CA single-ended I/Os
    *   Value | Description
    *    ---- | ------
    *     0x0 | Disable Vref DAC
    *     0x1 | Enable Vref DAC
    * - Default: 1
    */
	int RxVrefDACEnable[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Receiver bias current control for CK lanes
    * - Used for programming RxGainCurrAdjDIFF0 registers.
    * - Please Refer to technology specific PHY Databook for supported values.
    * - Values:
    *   - Min: 0
    *   - Max: 0xf
    * - Default: 0x5
    */
	int RxBiasCurrentControlCk[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Receiver bias current control for DQS lanes
    * - Used for programming RxGainCurrAdjDIFF0 registers.
    * - Please Refer to technology specific PHY Databook for supported values.
    * - Values:
    *   - Min: 0
    *   - Max: 0xf
    * - Default: 0x5
    */
	int RxBiasCurrentControlDqs[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Receiver bias current control for the DQS RxReplica circuits
    * - Used for programming RxGainCurrAdjDIFF1 registers.
    * - Please Refer to technology specific PHY Databook for supported values.
    * - Values:
    *   - Min: 0
    *   - Max: 0xf
    * - Default: 0x5
    */
	int RxBiasCurrentControlRxReplica[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#ifdef _BUILD_LPDDR5
	/**
    * @brief Receiver bias current control for WCK (LPDDR5 only)
    * - Used for programming RxGainCurrAdjRxReplica registers.
    * - Please Refer to technology specific PHY Databook for supported values.
    * - Values:
    *   - Min: 0
    *   - Max: 0xf
    * - Default: 0x5
    */
	int RxBiasCurrentControlWck[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#endif

	/**
    * @brief Tx drive impedance for DQ bit slices (in ohms)
    * - Does not apply to WCK_t/c, DQS_t/c
    * - Used for programming TxImpedanceSE0 and TxImpedanceSE1 registers.
    * - See "Electrical Parameters" in PHY Databook for supported impedance
    *   range given your Hard Macro Family. Set based on typical values from
    *   "Output driver pull-down impedance: SE_IO, DIFF_IO" in "Common DC Output Parameters"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI analysis and DRAM modules, select from supported values in the PHY Databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int TxImpedanceDq[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Tx drive impedance for CA bit slices (in ohms)
    * - Does not apply to CKE(LPDDR4), CS(LPDDR5), CK_t/c
    * - Used for programming TxImpedanceSE0 (and TxImpedanceSE1 in LPDDR5) registers.
    * - See "Electrical Parameters" in PHY Databook for supported impedance
    *   range given your Hard Macro Family. Set based on typical values from
    *   "Output driver pull-down impedance: SE_IO, DIFF_IO" in "Common DC Output Parameters"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int TxImpedanceAc[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#ifdef _BUILD_LPDDR4
	/**
    * @brief Tx Drive Impedance for CS bit slices (in ohms) (LPDDR4 only)
    * - Used for programming TxImpedanceSE1 register.
    * - See "Electrical Parameters" in PHY Databook for supported impedance
    *   range given your Hard Macro Family. Set based on typical values from
    *   "Output driver pull-down impedance: SE_IO, DIFF_IO" in "Common DC Output Parameters"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY Databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int TxImpedanceCs[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#endif
	/**
    * @brief Tx drive impedance for DQS_t/c (in ohms)
    * - Used for programming TxImpedanceDIFF0T, TxImpedanceDIFF0C registers.
    * - See "Electrical Parameters" in PHY Databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "Output driver pull-down impedance: SE_IO, DIFF_IO" in "Common DC Output Parameters"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int TxImpedanceDqs[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Tx drive impedance for CK_t/c (in ohms)
    * - Used for programming TxImpedanceDIFF0T, TxImpedanceDIFF0C registers.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "Output driver pull-down impedance: SE_IO, DIFF_IO" in "Common DC Output Parameters"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int TxImpedanceCk[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#ifdef _BUILD_LPDDR5
	/**
    * @brief Tx drive impedance for WCK_t/c (in ohms) (LPDDR5 only)
    * - Used for programming TxImpedanceDIFF1T, TxImpedanceDIFF1C registers.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "Output driver pull-down impedance: SE_IO, DIFF_IO" in "Common DC Output Parameters"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     120 | 120 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int TxImpedanceWCK[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif

	/**
    * @brief Tx drive impedance for CKE(LPDDR4) or CS(LPDDR5) (in ohms)
    * - Used for programming TxImpedanceCMOS0.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "Output driver pull-up impedance: SEC_IO" in "Common DC Output Parameters"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     400 | 400 ohms
    *     100 | 100 ohms
    *      67 | 67 ohms
    *      50 | 50 ohms
    * - Default: 50
    */
	int TxImpedanceCKE[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Tx drive impedance for DTO (Digital Test Output) (in ohms)
    * - Used for programming TxImpedanceCMOS1.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     400 | 400 ohms
    *     100 | 100 ohms
    *      67 | 67 ohms
    *      50 | 50 ohms
    * - Default: 50
    */
	int TxImpedanceDTO[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief ODT impedance for DQ bit slices (in ohms)
    * - Does not apply to DQS_t/c
    * - Used for programming OdtImpedanceSE0 and OdtImpedanceSE1 registers.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "On-die termination (ODT) programmable resistances (RTT)" in "DC Input Conditions"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | Hi-Z
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int OdtImpedanceDq[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief ODT impedance for DQS_t/c (in ohms)
    * - Used for programming OdtImpedanceDIFF0T, OdtImpedanceDIFF0C registers.
    * - See "Electrical Parameters" in PHY Databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "On-die termination (ODT) programmable resistances (RTT)" in "DC Input Conditions"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | Hi-Z
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int OdtImpedanceDqs[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#ifdef _BUILD_LPDDR5
	/**
    * @brief ODT impedance for WCK_t/c (in ohms) (LPDDR5 only)
    *
    * - Used for programming OdtImpedanceDIFF1T, OdtImpedanceDIFF1C registers.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "On-die termination (ODT) programmable resistances (RTT)" in "DC Input Conditions"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | Hi-Z
    *     120 | 120 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int OdtImpedanceWCK[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif

	/**
    * @brief ODT impedance for CA bit slices (in ohms)
    * - Used for programming OdtImpedanceSE0 (and OdtImpedanceSE1 for LPDDR5) registers.
	* - See "Electrical Parameters" in PHY databook for supported impedance
	*   range given your Hard Macro Family.  Set based on typical values from
	*   "On-die termination (ODT) programmable resistances (RTT)" in "DC Input Conditions"
	*   table for each protocol. See table foot notes for more details.
	* - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
	*   Only values in the PHY databook are supported.
	* - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | Hi-Z
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int OdtImpedanceCa[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#ifdef _BUILD_LPDDR4
	/**
    * @brief ODT impedance for CS bit slices (in ohms) (LPDDR4 only)
    * - Used for programming OdtImpedanceSE1 (for LPDDR4) registers.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "On-die termination (ODT) programmable resistances (RTT)" in "DC Input Conditions"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | Hi-Z
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int OdtImpedanceCs[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#endif
	/**
    * @brief ODT impedance for CK_t/c (in ohms)
    * - Used for programming OdtImpedanceDIFF0T, OdtImpedanceDIFF0C registers.
    * - See "Electrical Parameters" in PHY databook for supported impedance
    *   range given your Hard Macro Family.  Set based on typical values from
    *   "On-die termination (ODT) programmable resistances (RTT)" in "DC Input Conditions"
    *   table for each protocol. See table foot notes for more details.
    * - Based on SI Analysis and DRAM modules, select from supported values in the PHY databook.
    *   Only values in the PHY databook are supported.
    * - Must be decimal integer.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | Hi-Z
    *     240 | 240 ohms
    *     120 | 120 ohms
    *      80 | 80 ohms
    *      60 | 60 ohms
    *      40 | 40 ohms
    *      30 | 30 ohms
    * - Default: 60
    */
	int OdtImpedanceCk[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-up slew rate control for DQ and DMI
    * - Value specified here will be written to register TxSlewSE0.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewRiseDq[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-down slew rate control for DQ and DMI
    * - Value specified here will be written to TxSlewSE0.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewFallDq[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-up slew rate control for DQS_t/c
    * - Value specified here will be written to register TxSlewDIFF0.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewRiseDqs[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-down slew rate control for DQS_t/c
    * - Value specified here will be written to TxSlewDIFF0.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewFallDqs[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-up slew rate control for CA lanes
    * - Value specified here will be written to TxSlewSE0/1.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewRiseCA[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-down slew rate control for CA lanes
    * - Value specified here will be written to TxSlewSE0/1.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewFallCA[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#ifdef _BUILD_LPDDR4
	/**
    * @brief Pull-up slew rate control for CS lanes (LPDDR4 only)
    * - Value specified here will be written to TxSlewSE1.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewRiseCS[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-down slew rate control for CS lanes (LPDDR4 only)
    * - Value specified here will be written to TxSlewSE1.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewFallCS[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#endif
	/**
    * @brief Pull-up slew rate control for CK
    * - Value specified here will be written to TxSlewDIFF0.
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewRiseCK[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-down slew rate control for CK
    * - Value specified here will be written to TxSlewDIFF1
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewFallCK[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#ifdef _BUILD_LPDDR5
	/**
    * @brief Pull-up slew rate control for WCK (LPDDR5 only)
    * - Value specified here will be written to TxSlewDIFF1
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewRiseWCK[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Pull-down slew rate control for WCK (LPDDR5 only)
    * - Value specified here will be written to TxSlewDIFF1
	*   See register description for more information.
	* - Only the default are currently recommended.
    * - Values:
    *   - Min: 0
    *   - Max: 0xff
    * - Default: 0
    */
	int TxSlewFallWCK[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

#endif
	/**
    * @brief Control the stopped MEMCLK state
    * - When the toggling of memory clock CK_t is disabled with dfi_dram_clk_disable =1, the memory clock CK_t is driven with Register CkDisVal.
    * - Value specified here will be directly written to register CkDisVal.
    *   See register description for more information.
    * - Values: 0, 1
    * - Default: 0
    */
	int CkDisVal[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief DRAM oscillator count source mapping
    * - The PHY supports swapping of DRAM oscillator count values between paired DBYTEs for the purpose of tDQSDQ DRAM Drift Compensation(DDC).
	* - Each DBYTE has a register bit to control the source of the oscillator count value used to perform tDQSDQ drift compensation.
	*   The training firmware will not determine the DBYTE swap, it will rely on PptCtlStatic register to select oscillator count source.
	*   This input is used to program such CSR and is required depending on the configuration.
	* - The default hardware configuration is for odd DBYTE instance n to use oscillator count values from its paired DBYTE instance n-1.
	*   So DBYTE1 will use the oscillator count values from DBYTE0, DBYTE3 will use DBYTE2 and so on.  This is required for DRAM Data width =16.
	* - Each bit of this field corresponds to a DBYTE:
	*   - bit-0 = setting for DBYTE0
	*   - bit-1 = setting for DBYTE1
	*   - bit-2 = setting for DBYTE2
	*   - . . .
	*   - bit-n = setting for DBYTEn
	* - By setting the associated bit for each DBYTE to 1, PHY will use non-default source for count value.
	*   - for even DBYTEs, non-default source is to use the odd pair count value.
	*   - for odd DBYTEs, no-default source to use data received directly from the DRAM.
	* - Byte swapping must be the same across different ranks.
	* - must be set as hex
	* - if Byte mode devices are indicated via the X8Mode messageBlock parameter, this variable is ignored as PHY only supports
	*   a limited configuration set based on Byte mode configuration..
	* Example:
	*   DramByteSwap = 0x03 - DBYTE0: use count values from DBYTE1, DBYTE1 uses count values received directly received from DRAM.
	*   Rest of DBYTEs have default source for DRAM oscilator count.
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 0
    */
	int DramByteSwap;

	/**
	* @brief Selects the Rx DFE mode
	* - Selects the Rx DFE mode and sets the Rx Vref control accordingly. 
	* - The RxDfeModeCfg and RxVrefCtl registers get programmed from this input.
	* - Values:
	*    Value | Description
	*    ----- | ------
	*      0x0 | Static VREF using only DFE0 Path
	*      0x1 | Static VREF using only DFE1 Path
	*      0x2 | Per Rank Static VREF (Rank 0 uses DFE0 Path, Rank1 uses DFE1 Path)
	*      0x4 | DFE enabled with 1 previous bit lookup
	* - Default: 0
	*/
	int RxDfeMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief PHY MASTER request interval
    * - Specify how frequently dfi_phymstr_req is issued by PHY.
   	* - Based on SI analysis determine how frequently DRAM drift compensation and
	*   re-training is required.
	* - Determine if Memory controller supports DFI PHY Master Interface.
    * - See PUB databook section "DFI Master Interface" and DFI 
	*   spec for details of DFI PHY Master Interface.
	* - This value will be used to Program PPTTrainSetup.PhyMstrTrainInterval register.
	*   See register description in PUB databook for translation table
	*   of values to MEMCLKs.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | Disable PHY Master Interface
    *    0x03 | 2097152 MEMCLKs
    *    0x0a | 268435456 MEMCLKs
    * - Default: 0x0a
    */
	int PhyMstrTrainInterval[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Max time from dfi_phymstr_req asserted to dfi_phymstr_ack asserted
    * - Based on your Memory Controller's (MC) specification determine how long the PHY
	*   should wait for the assertion of dfi_phymstr_ack once dfi_phymstr_req has
	*   been issued by the PHY. If the MC does not ack the PHY's request, PHY may issue
	*   dfi_error.
	* - See PUB databook section "DFI Master Interface" and DFI
	*   spec for details of DFI PHY Master interface.
	* - This value will be used to program PPTTrainSetup.PhyMstrMaxReqToAck register.
	*   See detailed register description in PUB databook.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | Disable PHY Master Interface
    *     0x3 | 2048 MEMCLKs
    *     0x5 | 8192 MEMCLKs
    * - Default: 0x5
    */
	int PhyMstrMaxReqToAck[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Determine if memory controller supports DFI PHY Master Interface
    * - If set to 1, a PHY Master transaction can be initiated only by a dfi_ctrlmsg transaction;
    * - If set to 0, a PHY Master transaction can be initiated only by timer function.
	* - Program based on desired setting for PPTTrainSetup.PhyMstrCtrlMode register.
    * - Values: 0x0, 0x1
    * - Default: 0x1
    */
	int PhyMstrCtrlMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Enable Write DQS Extension (LPDDR4 Only)
    * - See App Note "DesignWare Cores LPDDR4 MultiPHY : WDQS Extension Application Note"
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | Disable Write DQS Extension feature
    *     0x1 | Enable Write DQS Extension feature
    * - Default: 0x0
    */
	int WDQSExt;

	/**
    * @brief The interval between successive PHY impedance calibrations
    * - See PUB databook section "Impedance Calibrator" to learn about PHY impedance
	*   calibration FSM. Based on feedback from SI analysis, determine desired
	*   calibration interval for your System.
	* - Program variable based on desired setting for ZCalRate.ZCalInterval register.
	*   See detailed register description in PUB databook.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *    0x0  | 0 (continuous)
    *    0x3  | 1 ms
    *    0x4  | 2 ms
    *    0x8  | 10 ms
    * - Default: 0x8
    */
	int CalInterval;

	/**
    * @brief This setting changes the behavior of ZCalRun register
    * - If set to 1, the 0->1 transition of CSR ZCalRun causes a single iteration of the calibration sequence to occur;
    * - If set to 0, calibration will proceed at the rate determined by ZCalInterval.
    * - This field should only be changed while the calibrator is idle i.e. when csr ZCalRun=0 and ZCalBusy=0, or ZCalReset=1.
    * - See PUB databook section "Impedance Calibrator" to learn about PHY impedance
	*   calibration FSM. 
	* - Program variable based on desired setting for ZCalRate.ZCalOnce register.
	*   See detailed register description in PUB databook.
    * - Values: 0x0, 0x1
    * - Default: 0x0
    */
	int CalOnce;

	/**
    * @brief Adjustment to bias current in the Impedance Calibration Control Circuit
    * - It is not recommended to change the default value of this parameter.
    * - Values:
    *   - Min: 0x0
    *   - Max: (TODO)
    * - Default: 0x0
    */
	int CalImpedanceCurrentAdjustment;

	/**
    * @brief Firmware Training Sequence Control
    * - This input is used to program SequenceCtrl in messageBlock.
	*   It controls the training stages executed by firmware.
	*   Consult the training firmware App Note section "1D Training Steps" for details on training stages.
	* - For production silicon Synopsys recommends to use default value programmed by PhyInit.
	* - If running simulation for the first time, program value according to "Initial interactions with the firmware" section in Training firmware App Note.
    * - Values: (TODO)
    * - Default: (TODO)
    */
	int TrainSequenceCtrl;

    /**
    * @brief Disable PHY DRAM drift compensation re-training
    * - Disable PHY re-training during DFI frequency change requests.
	* - See Firmware Training App Note section "DRAM Drift Compensation" for details of steps in re-training.
	* - The purpose of retraining is to compensate for drift in the DRAM.
	*   Determined based on SI analysis and DRAM datasheet if retraining can be disabled.
    * - Values:
    *    Value | Description
    *    ----- | ---
    *      0x1 | Disable retraining
    *      0x0 | Enable retraining
    * - Default: 0x0
    */
    int DisableRetraining;

	/**
    * @brief Disable DFI PHY Update
    * - Disable DFI PHY Update feature. If set to 1, PHY will not assert dfi_phyupd_req.
	*   See DFI specification for DFI PHY Update Interface.  See PUB databook section
	*   "PHY Update" for details of the DFI PHY Update Interface implementation.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x1 | Disable DFI PHY Update
    *     0x0 | Enable DFI PHY Update
    * - Default: 0x0
    */
	int DisablePhyUpdate;

	/**
    * @brief Turn off or tristate Address Lanes when possible
    * - When enabled, PHY will tristate unused address lanes to save power when possible
	*   by using Acx4AnibDis and AForceTriCont registers.
	* - This feature is only implemented for the default PHY Address bump mapping and
	*   Ranks must be populated in order. ie Rank1 cannot be used if Rank0 is unpopulated.
	* - For alternative bump mapping follow the following guideline to achieve maximum power savings:
	* - For each unused BP_A bump program AForceTriCont[4:0] bits based on register description.
	* - if all lanes of an Anib are unused _AND_ ANIB is not the first or last instance
	*    set bit associated with the instance in Acs4AnibDis registers. see register
	*    description for details.

	* @note This feature is BETA and untested. Future PhyInit version will fully enable this feature.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x1 | Enable
    *     0x0 | Disable
    * - Default: 0x0
    */
	int DisableUnusedAddrLns;

	/**
    * @brief Controls the frequency of the PMU clock
    * - Controls the frequency of the PMU clock
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | DfiClk frequency
    *     0x1 | 1/2 of DfiClk frequency
    * - Default: 0x1
    */
	int PmuClockDiv[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Disables PHY Microcontroller ECC
    * - Disable PHY Microcontroller ECC
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | ECC enabled
    *     0x1 | ECC disabled
    * - Default: 0
    */
	int DisablePmuEcc;

	/**
    * @brief Prevent the PHY from setting FSP-OP based on dfi_fsp input
    * - If set to 0, the PHY will set MR13.FSP-OP(LPDDR4) or MR16.FSP-OP(LPDDR5) based on dfi_fsp input;
    * - If set to 1, the PHY will not set MR13.FSP-OP(LPDDR4) or MR16.FSP-OP(LPDDR5) based on dfi_fsp input.
	* - Refer to PUB datatbook section "DFI Frequency Change".
    * - Values: 0, 1
    * - Default: 0
    */
	int DisableFspOp;

	/**
	* @brief Disable JTAG/TDR access to PHY registers before mission mode
	* - Value programmed directly in TDRDisable register.
	* - Values:
	*   Value | Description
	*    ---- | ------
	*     0x0 | TDR access enabled
	*     0x1 | TDR access disabled
	* - Default: 0
	*/
	int DisableTDRAccess;

    /**
    * @brief Enable PHY RxClk drift tracking
	* - In the future, this will be deprecated in favor of RetrainMode.
    * - Refer to PUB databook for details of this PHY feature.
    * - Enable RxClkTrackEn=1 when PPT is enabled only.
    * - At data rates below DDR667 the RxClk tracking must be disabled.
    * - Values:
    *   Value | Description
    *   ----- | ------
    *     0x0 | disabled
    *     0x1 | enabled
    * - Default: 1
    */
	int RxClkTrackEn[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Time to wait between RxClk drift tracking runs
    * - Value programmed directly in RxReplicanextcalwait register.
	*   See register description for details for valid values to program.
	* - must be programed as hex.
	* - Only used when RerainMode=1.
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 0x1200
    */
	int RxClkTrackWait;

	/**
    * @brief Time to wait between RxClk LCDL UI calibrartion
    * - Value programmed directly in RxReplicaUIcalwait register.
	*   See register description for details for valid values to program.
	* - Only used when RerainMode=1.
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 0x80
    */
	int RxClkTrackWaitUI;

	/**
	* @brief Reserved for Future Use
	* - Only default value is supported.
	* - Default: 0x0
	*/
	int EnRxDqsTracking[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Read DQS drift tracking threshold
	* - When tracking is enabled (EnRxDqsTracking = 1), this input is used to set the tracking threshold.
    * - The value specified here is programmed directly in the RxDqsTrackingThreshold register.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *       0 | threshold value of 3
    *       1 | threshold value of 5
    *       2 | threshold value of 9
    *       3 | threshold value of 15
    *       4 | threshold value of 31
    * - Default: 1
    */
	int RxDqsTrackingThreshold[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Informs the PHY of the DQS oscillator runtime or the runtime used by the controller
    * - Informs the PHY of the DQS oscillator runtime configured in the DRAMs or the runtime used by the controller. 
    *   That time must agree with the configuration of this CSR.
	* - The value specified here is programmed directly in the DqsOscRunTimeSel register.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | 256 MEMCLKs
    *     0x1 | 512 MEMCLKs
    *     0x2 | 1024 MEMCLKs
    *     0x3 | 2048 MEMCLKs
    *     0x4 | 4096 MEMCLKs
    *     0x5 | 8192 MEMCLKs
    * - Default: 3
    */
	int DqsOscRunTimeSel[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#ifdef _BUILD_LPDDR5

	/**
    * @brief Enable Snoop Interface to modify the RxEn timing (LPDDR5 only)
    * - The value specified here is programmed directly into the EnWck2DqoSnoopTracking register.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | disabled
    *     0x1 | enabled
    * - Default: 0x0
    */
	int EnWck2DqoTracking[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
    * @brief Enable support for Deep Sleep Mode during LP3 (LPDDR5 only)
    * - Specifies the state of the DRAM when entering LP3. 
    * - When Deep Sleep Mode is selected, the PHY will wait longer to satisfy tXDSM_XP during LP3 exit sequence.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | Self-Refresh + Power Down Mode
    *     0x1 | Deep Sleep Mode
    * - Default: 0x0
    */
	int Lp3DramState[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
#endif

	/**
    * @brief Controls the behavior of Relock-Only frequency change
    * - Controls the behavior of Relock-Only encoding during frequency change.
    * - Values:
    *   Value | Description
    *   ----- | -----------
    *     0x0 | default Relock-Only behavior
    *     0x1 | Relock-Only frequency change mapped to LP2 Enter/Exit. If set, Relock-Only can only be used for P0->P0, P1->P1, etc. transitions.
    * - Default: 0
    */
    int RelockOnlyCntrl;

	/**
    * @brief Restore only non-PStateable registers during retention save/restore process.
    * - In order to speed up retention exit, the Pstate SRAM can be left powered on during retention.
    * - When this option is enabled, only non-Pstateable registers are included in the retention save/restore sequence.
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x0 | disabled
    *     0x1 | enabled
    * - Default: 0
    */
	int OnlyRestoreNonPsRegs;

	/**
    * @brief Size of the PState SRAM, in terms of number of entries per PState
    * - See PUB Databook section "PState SRAM" and description of csrPsDmaRamSize
	* - Only used in NumPStates >2
    * - Values:
    *   Value | Description
    *    ---- | ------
    *     0x1 | RAM is 8k deep; 512 entries per Pstate
    *     0x2 | RAM is 16k deep; 1024 entries per Pstate
    *     0x3 | RAM is 32k deep; 2048 entries per Pstate (not supported)
    * - Default: 0x2
    */
	int PsDmaRamSize;

	/**
     * @brief Select Retraining Mode.
     * - See TBD pub databook for details.
     * - RetrainMode values > 1 are currently only supported with PUB 2.x revisions.
     * - Values:
     *   Value | Description
     *   ----- | ------
     *     0x0 | No Retraining
     *     0x1 | PPT1
     *     0x2 | PPT2 Serial (Currently Not Supported)
     *     0x3 | LPDDR5 Strobless mode. @TODO need an assertion. (Currently Not Supported)
     *     0x4 | Interleaved Retraining
     * - Default: 1
     */
	int RetrainMode[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	/**
	 * @brief Skip Retrain enhancement to maintain drift compensated values during Skip Retrain (i.e. Relock Only) frequency change
	 * - Supported only with PUB 1.x revisions. Please contact Synopsys before using this feature.
	 */
	int SkipRetrainEnhancement;

	/**
	 * @brief Skip Copy of initial trained data during Skip Retrain (i.e. Relock Only) frequency change
	 * - This feature is not supported in all PUB revisions. Consult Synopsys for exact availability.
	 * - Restrictions to enable this option:
	 * - Relock-Only frequency change encoding must always be to current PState and cannot be used to change frequency.
	 * - PHY does not support frequency change to Pstates with Data Rates <667.
	 * - Supported sequence: 
	 * 	     P0 (retrain+relock)  -->  P0(skip_retrain)  -->  P1(retrain+relock)  -->  P1(skip_retrain)  -->  P0 (retrain+relock) 
	 *         (retrain T1@P0)         (use T1 Results)            (T2@P1)             (use T2 results)            (T3@P0)
	 *       P0 (retrain+relock)  -->  P0(skip_retrain)  -->  P0(retrain+relock)  -->  P0(skip_retrain)
	 *         (retrain T1@P0)         (use T1 Results)            (T2@P0)             (use T2 Results) 
	 * - When enabled, the following is not supported (results in P1 using P0 timing data):
	 * 	     P0 (retrain+relock)  -->  P1 (skip_retrain)
	 * 	     P0 (retrain+relock)  -->  P0 (skip_train)  -->  P1 (skip_retrain)
	 * - Values:
	 *   Value | Description
	 *   ----- | ------
	 *     0x0 | Relock-Only frequency change flash copies initial trained data. (default)
	 *     0x1 | Relock-Only frequency change will not copy target Pstate initial training data into PHY registers, no change to PHY timing registers.
	 */
	int SkipFlashCopy[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

} user_input_advanced_t;

/** \brief Structure for user input simulation options (Optional)
 *
 * This structure can be programed with DRAM timing parameters for strict use
 * of the SkipTrain or SkipTrain + DevInit initialization method.  If executing
 * training firmware, this structure is not used.
 *
 */
typedef struct user_input_sim {

#ifdef _BUILD_LPDDR4
	/**
    * @brief The value of tDQS2DQ in ps (LPDDR4 only)
    * - Manually enter the DRAM DQS delay (tDQS2DQ, in integer number of ps) to apply in simulation.
    * - Values are vendor-specific - ensure that the entered value aligns with that described for the connected DRAM model.
    * - Refer to discussions regarding the tDQS2DQ variable in the LPDDR4 JEDEC spec for more information.
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 200
    */
	int tDQS2DQ;

	/**
    * @brief The value of tDQSCK in ps (LPDDR4 only)
    * - Manually enter the DRAM DQS delay (tDQSCK, in integer number of ps) to apply in simulation.
    * - Applies when training is disabled. Value consumed when DLL mode is off.
    * - Apply when DLL mode is off (e.g., in LPDDRx mode, or when PLL is bypassed).
    * - Values are vendor-specific - ensure that the entered value aligns with that described for the connected DRAM model.
    * - Refer to discussions regarding the tDQSCK variable in the JEDEC specs for more information.
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 1500
    */
	int tDQSCK;

#endif
#ifdef _BUILD_LPDDR5
	/**
    * @brief The value of tWCK2CK in ps (LPDDR5 only)
    * - Enter the value of tWCK2CK in integer number of ps
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 0
    */
	int tWCK2CK;

	/**
    * @brief The value of tWCK2DQI in ps (LPDDR5 only)
    * - Enter the value of tWCK2DQI in integer number of ps
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 500
    */
	int tWCK2DQI;

	/**
    * @brief The value of tWCK2DQO in ps (LPDDR5 only)
    * - Enter the value of tWCK2DQO in integer number of ps
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 1000
    */
	int tWCK2DQO;

#endif
	/**
    * @brief The internal PHY tDQS2DQ in ps
    * - The delay value (ps) specified here is used in simulations when the training firmware is skipped, and
    * - must match the delay from BP_DQS_T,_C in DIFF to _lcdl_rxclk in SE including the lcdl zerodelay.
    * - This delay must match what is programmed in the RTL logic model or annotated in gate level simulation.
    * - Enter the value of PHY_tDQS2DQ in integer number of ps
    * - Values:
    *   - Min: 0
    *   - Max: (TODO)
    * - Default: 312
    */
	int PHY_tDQS2DQ;


} user_input_sim_t;
/** @} */
