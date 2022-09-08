

/** \file
 * \brief structures and enumeration definitions
 */

#include <stdint.h>
/*! \def DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE
 * \brief Max number of allowed PStates for this product.
 */
#define DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE 15
#include <dwc_ddrphy_phyinit_struct.h>

//-------------------------------------------------------------
// Defines for PState Mode Registers stored in ACSM SRAM
//-------------------------------------------------------------
/*! \def DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4
 * \brief Number of rows for broadcasted Mode Registers restored on a PState change.
 */
#define DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4    28
/*! \def DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5
 * \brief Number of rows for broadcasted Mode Registers restored on a PState change.
 */
#define DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5    44
/*! \def DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP4
 * \brief Number of rows for trained Mode Registers restored on a PState change.
 */
#define DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP4   10
/*! \def DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP5
 * \brief Number of rows for trained Mode Registers restored on a PState change.
 */
#define DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP5   34

//-------------------------------------------------------------
// Defines for Firmware Images
// - point to IMEM/DMEM incv files,
// - indicate IMEM/DMEM size (bytes)
//-------------------------------------------------------------
/*! \def FW_FILES_LOC
 * \brief set the location of training firmware uncompressed path.
 *
 * PhyInit will use this path to load the imem and dmem incv files of the
 * firmware image.
 */
/*! \def IMEM_INCV_FILENAME
 * \brief firmware instruction memory (imem) filename for 1D training
 */
/*! \def DMEM_INCV_FILENAME
 * \brief firmware instruction memory (imem) filename for 1D training.
 */
/*! \def IMEM_SIZE
 * \brief max size of instruction memory.
 */
/*! \def DMEM_SIZE
 * \brief max size of data memory.
 */
/*! \def DMEM_ST_ADDR
 * \brief start of DMEM address in memory.
 */
#ifndef FW_FILES_LOC
#define FW_FILES_LOC "./fw"
#endif
#define IMEM_INCV_FILENAME FW_FILES_LOC"/lpddr5/lpddr5_pmu_train_imem.incv"
#define DMEM_INCV_FILENAME FW_FILES_LOC"/lpddr5/lpddr5_pmu_train_dmem.incv"

#define IMEM_SIZE 65536 // 64KB (32 bits x 16K words)
#define DMEM_SIZE 65536 // 64KB (32 bits x 16K words)
#define DMEM_ST_ADDR 0x58000

///> Added for multiple PHY interface.
#ifndef DWC_DDRPHY_NUM_PHY
#define DWC_DDRPHY_NUM_PHY (1)
#endif
//-------------------------------------------------------------
// Defines for SR Firmware Images
// - point to IMEM incv files,
// - indicate IMEM size (bytes)
//-------------------------------------------------------------
/*! \def SR_FW_FILES_LOC
 * \brief location of optional retention save restore firmware image.
 */
/*! \def SR_IMEM_SIZE
 * \brief max IMEM size of retention save/restore firmware.
 */
/*! \def SR_IMEM_INCV_FILENAME
 * \brief file name of retention save/restore IMEM image.
 */
#ifndef SR_FW_FILES_LOC
#define SR_FW_FILES_LOC FW_FILES_LOC"/save_restore"
#endif

#define SR_IMEM_SIZE 16384
#define SR_IMEM_INCV_FILENAME       SR_FW_FILES_LOC"/dwc_ddrphy_io_retention_save_restore_imem.incv"

// Message Block Structure Definitions.
#include "mnPmuSramMsgBlock_lpddr5.h"

//------------------
// Type definitions
//------------------

/// A structure that can be used to control Phyinit
typedef struct {
  /*
   *  User defined control data goes here
   */
} user_control_t;
         
/// A structure used to SRAM memory address space.
typedef enum { return_offset, return_lastaddr } return_offset_lastaddr_t;

/// enumeration of instructions for PhyInit Register Interface
typedef enum {
	startTrack,					///< start register tracking
	stopTrack,					///< stop register tracking
	saveRegs,					///< save(read) tracked register values
	restoreRegs,				///< restore (write) saved register values
	dumpRegs,					///< write register address,value pairs to file
	importRegs,					///< import register address,value pairs to file
	setGroup,					///< change DMA register group
	startPsLoop,				///< signals start of PState loop in Sequence
	stopPsLoop,					///< signals stop PState loop in Sequence
	endPsLoop,					///< Signals End of the Ps Loop to the register IF.
	resumePsLoop,				///< Signals to resume DMA writes after stopPsLoop.
	reserveRegs,				///< reserve space for registers in the current DMA group
} regInstr;

/// enumeration of user input fields of PhyInit
typedef enum {
	// pRuntimeConfig Fields:
	_lastTrainedPState_, // 0
	_skip_train_, // 1
	_initCtrl_, // 2
	_ZQCalCodePD_saved_, // 3
	_Train2D_, // 4
	_firstTrainedPState_, // 5
	_debug_, // 6
	_ZQCalCodePU_saved_, // 7
	_curD_, // 8
	_RetEn_, // 9
	_curPState_, // 10
	// pUserInputAdvanced Fields:
	_RxDfeMode_0_, // 11
	_RxDfeMode_1_, // 12
	_RxDfeMode_2_, // 13
	_RxDfeMode_3_, // 14
	_RxDfeMode_4_, // 15
	_RxDfeMode_5_, // 16
	_RxDfeMode_6_, // 17
	_RxDfeMode_7_, // 18
	_RxDfeMode_8_, // 19
	_RxDfeMode_9_, // 20
	_RxDfeMode_10_, // 21
	_RxDfeMode_11_, // 22
	_RxDfeMode_12_, // 23
	_RxDfeMode_13_, // 24
	_RxDfeMode_14_, // 25
	_DramByteSwap_, // 26
	_TxSlewRiseDq_0_, // 27
	_TxSlewRiseDq_1_, // 28
	_TxSlewRiseDq_2_, // 29
	_TxSlewRiseDq_3_, // 30
	_TxSlewRiseDq_4_, // 31
	_TxSlewRiseDq_5_, // 32
	_TxSlewRiseDq_6_, // 33
	_TxSlewRiseDq_7_, // 34
	_TxSlewRiseDq_8_, // 35
	_TxSlewRiseDq_9_, // 36
	_TxSlewRiseDq_10_, // 37
	_TxSlewRiseDq_11_, // 38
	_TxSlewRiseDq_12_, // 39
	_TxSlewRiseDq_13_, // 40
	_TxSlewRiseDq_14_, // 41
	_RxBiasCurrentControlRxReplica_0_, // 42
	_RxBiasCurrentControlRxReplica_1_, // 43
	_RxBiasCurrentControlRxReplica_2_, // 44
	_RxBiasCurrentControlRxReplica_3_, // 45
	_RxBiasCurrentControlRxReplica_4_, // 46
	_RxBiasCurrentControlRxReplica_5_, // 47
	_RxBiasCurrentControlRxReplica_6_, // 48
	_RxBiasCurrentControlRxReplica_7_, // 49
	_RxBiasCurrentControlRxReplica_8_, // 50
	_RxBiasCurrentControlRxReplica_9_, // 51
	_RxBiasCurrentControlRxReplica_10_, // 52
	_RxBiasCurrentControlRxReplica_11_, // 53
	_RxBiasCurrentControlRxReplica_12_, // 54
	_RxBiasCurrentControlRxReplica_13_, // 55
	_RxBiasCurrentControlRxReplica_14_, // 56
	_TxSlewFallCA_0_, // 57
	_TxSlewFallCA_1_, // 58
	_TxSlewFallCA_2_, // 59
	_TxSlewFallCA_3_, // 60
	_TxSlewFallCA_4_, // 61
	_TxSlewFallCA_5_, // 62
	_TxSlewFallCA_6_, // 63
	_TxSlewFallCA_7_, // 64
	_TxSlewFallCA_8_, // 65
	_TxSlewFallCA_9_, // 66
	_TxSlewFallCA_10_, // 67
	_TxSlewFallCA_11_, // 68
	_TxSlewFallCA_12_, // 69
	_TxSlewFallCA_13_, // 70
	_TxSlewFallCA_14_, // 71
	_OdtImpedanceDqs_0_, // 72
	_OdtImpedanceDqs_1_, // 73
	_OdtImpedanceDqs_2_, // 74
	_OdtImpedanceDqs_3_, // 75
	_OdtImpedanceDqs_4_, // 76
	_OdtImpedanceDqs_5_, // 77
	_OdtImpedanceDqs_6_, // 78
	_OdtImpedanceDqs_7_, // 79
	_OdtImpedanceDqs_8_, // 80
	_OdtImpedanceDqs_9_, // 81
	_OdtImpedanceDqs_10_, // 82
	_OdtImpedanceDqs_11_, // 83
	_OdtImpedanceDqs_12_, // 84
	_OdtImpedanceDqs_13_, // 85
	_OdtImpedanceDqs_14_, // 86
	_RxModeBoostVDD_0_, // 87
	_RxModeBoostVDD_1_, // 88
	_RxModeBoostVDD_2_, // 89
	_RxModeBoostVDD_3_, // 90
	_RxModeBoostVDD_4_, // 91
	_RxModeBoostVDD_5_, // 92
	_RxModeBoostVDD_6_, // 93
	_RxModeBoostVDD_7_, // 94
	_RxModeBoostVDD_8_, // 95
	_RxModeBoostVDD_9_, // 96
	_RxModeBoostVDD_10_, // 97
	_RxModeBoostVDD_11_, // 98
	_RxModeBoostVDD_12_, // 99
	_RxModeBoostVDD_13_, // 100
	_RxModeBoostVDD_14_, // 101
	_PhyVrefCode_, // 102
	_OdtImpedanceWCK_0_, // 103
	_OdtImpedanceWCK_1_, // 104
	_OdtImpedanceWCK_2_, // 105
	_OdtImpedanceWCK_3_, // 106
	_OdtImpedanceWCK_4_, // 107
	_OdtImpedanceWCK_5_, // 108
	_OdtImpedanceWCK_6_, // 109
	_OdtImpedanceWCK_7_, // 110
	_OdtImpedanceWCK_8_, // 111
	_OdtImpedanceWCK_9_, // 112
	_OdtImpedanceWCK_10_, // 113
	_OdtImpedanceWCK_11_, // 114
	_OdtImpedanceWCK_12_, // 115
	_OdtImpedanceWCK_13_, // 116
	_OdtImpedanceWCK_14_, // 117
	_TxSlewFallWCK_0_, // 118
	_TxSlewFallWCK_1_, // 119
	_TxSlewFallWCK_2_, // 120
	_TxSlewFallWCK_3_, // 121
	_TxSlewFallWCK_4_, // 122
	_TxSlewFallWCK_5_, // 123
	_TxSlewFallWCK_6_, // 124
	_TxSlewFallWCK_7_, // 125
	_TxSlewFallWCK_8_, // 126
	_TxSlewFallWCK_9_, // 127
	_TxSlewFallWCK_10_, // 128
	_TxSlewFallWCK_11_, // 129
	_TxSlewFallWCK_12_, // 130
	_TxSlewFallWCK_13_, // 131
	_TxSlewFallWCK_14_, // 132
	_OdtImpedanceDq_0_, // 133
	_OdtImpedanceDq_1_, // 134
	_OdtImpedanceDq_2_, // 135
	_OdtImpedanceDq_3_, // 136
	_OdtImpedanceDq_4_, // 137
	_OdtImpedanceDq_5_, // 138
	_OdtImpedanceDq_6_, // 139
	_OdtImpedanceDq_7_, // 140
	_OdtImpedanceDq_8_, // 141
	_OdtImpedanceDq_9_, // 142
	_OdtImpedanceDq_10_, // 143
	_OdtImpedanceDq_11_, // 144
	_OdtImpedanceDq_12_, // 145
	_OdtImpedanceDq_13_, // 146
	_OdtImpedanceDq_14_, // 147
	_DisableUnusedAddrLns_, // 148
	_EnWck2DqoTracking_0_, // 149
	_EnWck2DqoTracking_1_, // 150
	_EnWck2DqoTracking_2_, // 151
	_EnWck2DqoTracking_3_, // 152
	_EnWck2DqoTracking_4_, // 153
	_EnWck2DqoTracking_5_, // 154
	_EnWck2DqoTracking_6_, // 155
	_EnWck2DqoTracking_7_, // 156
	_EnWck2DqoTracking_8_, // 157
	_EnWck2DqoTracking_9_, // 158
	_EnWck2DqoTracking_10_, // 159
	_EnWck2DqoTracking_11_, // 160
	_EnWck2DqoTracking_12_, // 161
	_EnWck2DqoTracking_13_, // 162
	_EnWck2DqoTracking_14_, // 163
	_TxSlewRiseCK_0_, // 164
	_TxSlewRiseCK_1_, // 165
	_TxSlewRiseCK_2_, // 166
	_TxSlewRiseCK_3_, // 167
	_TxSlewRiseCK_4_, // 168
	_TxSlewRiseCK_5_, // 169
	_TxSlewRiseCK_6_, // 170
	_TxSlewRiseCK_7_, // 171
	_TxSlewRiseCK_8_, // 172
	_TxSlewRiseCK_9_, // 173
	_TxSlewRiseCK_10_, // 174
	_TxSlewRiseCK_11_, // 175
	_TxSlewRiseCK_12_, // 176
	_TxSlewRiseCK_13_, // 177
	_TxSlewRiseCK_14_, // 178
	_TxSlewRiseCA_0_, // 179
	_TxSlewRiseCA_1_, // 180
	_TxSlewRiseCA_2_, // 181
	_TxSlewRiseCA_3_, // 182
	_TxSlewRiseCA_4_, // 183
	_TxSlewRiseCA_5_, // 184
	_TxSlewRiseCA_6_, // 185
	_TxSlewRiseCA_7_, // 186
	_TxSlewRiseCA_8_, // 187
	_TxSlewRiseCA_9_, // 188
	_TxSlewRiseCA_10_, // 189
	_TxSlewRiseCA_11_, // 190
	_TxSlewRiseCA_12_, // 191
	_TxSlewRiseCA_13_, // 192
	_TxSlewRiseCA_14_, // 193
	_TxSlewFallCK_0_, // 194
	_TxSlewFallCK_1_, // 195
	_TxSlewFallCK_2_, // 196
	_TxSlewFallCK_3_, // 197
	_TxSlewFallCK_4_, // 198
	_TxSlewFallCK_5_, // 199
	_TxSlewFallCK_6_, // 200
	_TxSlewFallCK_7_, // 201
	_TxSlewFallCK_8_, // 202
	_TxSlewFallCK_9_, // 203
	_TxSlewFallCK_10_, // 204
	_TxSlewFallCK_11_, // 205
	_TxSlewFallCK_12_, // 206
	_TxSlewFallCK_13_, // 207
	_TxSlewFallCK_14_, // 208
	_RelockOnlyCntrl_, // 209
	_CalImpedanceCurrentAdjustment_, // 210
	_SkipRetrainEnhancement_, // 211
	_OdtImpedanceCk_0_, // 212
	_OdtImpedanceCk_1_, // 213
	_OdtImpedanceCk_2_, // 214
	_OdtImpedanceCk_3_, // 215
	_OdtImpedanceCk_4_, // 216
	_OdtImpedanceCk_5_, // 217
	_OdtImpedanceCk_6_, // 218
	_OdtImpedanceCk_7_, // 219
	_OdtImpedanceCk_8_, // 220
	_OdtImpedanceCk_9_, // 221
	_OdtImpedanceCk_10_, // 222
	_OdtImpedanceCk_11_, // 223
	_OdtImpedanceCk_12_, // 224
	_OdtImpedanceCk_13_, // 225
	_OdtImpedanceCk_14_, // 226
	_TxImpedanceCKE_0_, // 227
	_TxImpedanceCKE_1_, // 228
	_TxImpedanceCKE_2_, // 229
	_TxImpedanceCKE_3_, // 230
	_TxImpedanceCKE_4_, // 231
	_TxImpedanceCKE_5_, // 232
	_TxImpedanceCKE_6_, // 233
	_TxImpedanceCKE_7_, // 234
	_TxImpedanceCKE_8_, // 235
	_TxImpedanceCKE_9_, // 236
	_TxImpedanceCKE_10_, // 237
	_TxImpedanceCKE_11_, // 238
	_TxImpedanceCKE_12_, // 239
	_TxImpedanceCKE_13_, // 240
	_TxImpedanceCKE_14_, // 241
	_PsDmaRamSize_, // 242
	_RxClkTrackEn_0_, // 243
	_RxClkTrackEn_1_, // 244
	_RxClkTrackEn_2_, // 245
	_RxClkTrackEn_3_, // 246
	_RxClkTrackEn_4_, // 247
	_RxClkTrackEn_5_, // 248
	_RxClkTrackEn_6_, // 249
	_RxClkTrackEn_7_, // 250
	_RxClkTrackEn_8_, // 251
	_RxClkTrackEn_9_, // 252
	_RxClkTrackEn_10_, // 253
	_RxClkTrackEn_11_, // 254
	_RxClkTrackEn_12_, // 255
	_RxClkTrackEn_13_, // 256
	_RxClkTrackEn_14_, // 257
	_TxSlewFallDqs_0_, // 258
	_TxSlewFallDqs_1_, // 259
	_TxSlewFallDqs_2_, // 260
	_TxSlewFallDqs_3_, // 261
	_TxSlewFallDqs_4_, // 262
	_TxSlewFallDqs_5_, // 263
	_TxSlewFallDqs_6_, // 264
	_TxSlewFallDqs_7_, // 265
	_TxSlewFallDqs_8_, // 266
	_TxSlewFallDqs_9_, // 267
	_TxSlewFallDqs_10_, // 268
	_TxSlewFallDqs_11_, // 269
	_TxSlewFallDqs_12_, // 270
	_TxSlewFallDqs_13_, // 271
	_TxSlewFallDqs_14_, // 272
	_TxImpedanceAc_0_, // 273
	_TxImpedanceAc_1_, // 274
	_TxImpedanceAc_2_, // 275
	_TxImpedanceAc_3_, // 276
	_TxImpedanceAc_4_, // 277
	_TxImpedanceAc_5_, // 278
	_TxImpedanceAc_6_, // 279
	_TxImpedanceAc_7_, // 280
	_TxImpedanceAc_8_, // 281
	_TxImpedanceAc_9_, // 282
	_TxImpedanceAc_10_, // 283
	_TxImpedanceAc_11_, // 284
	_TxImpedanceAc_12_, // 285
	_TxImpedanceAc_13_, // 286
	_TxImpedanceAc_14_, // 287
	_CkDisVal_0_, // 288
	_CkDisVal_1_, // 289
	_CkDisVal_2_, // 290
	_CkDisVal_3_, // 291
	_CkDisVal_4_, // 292
	_CkDisVal_5_, // 293
	_CkDisVal_6_, // 294
	_CkDisVal_7_, // 295
	_CkDisVal_8_, // 296
	_CkDisVal_9_, // 297
	_CkDisVal_10_, // 298
	_CkDisVal_11_, // 299
	_CkDisVal_12_, // 300
	_CkDisVal_13_, // 301
	_CkDisVal_14_, // 302
	_PhyMstrMaxReqToAck_0_, // 303
	_PhyMstrMaxReqToAck_1_, // 304
	_PhyMstrMaxReqToAck_2_, // 305
	_PhyMstrMaxReqToAck_3_, // 306
	_PhyMstrMaxReqToAck_4_, // 307
	_PhyMstrMaxReqToAck_5_, // 308
	_PhyMstrMaxReqToAck_6_, // 309
	_PhyMstrMaxReqToAck_7_, // 310
	_PhyMstrMaxReqToAck_8_, // 311
	_PhyMstrMaxReqToAck_9_, // 312
	_PhyMstrMaxReqToAck_10_, // 313
	_PhyMstrMaxReqToAck_11_, // 314
	_PhyMstrMaxReqToAck_12_, // 315
	_PhyMstrMaxReqToAck_13_, // 316
	_PhyMstrMaxReqToAck_14_, // 317
	_TxImpedanceDqs_0_, // 318
	_TxImpedanceDqs_1_, // 319
	_TxImpedanceDqs_2_, // 320
	_TxImpedanceDqs_3_, // 321
	_TxImpedanceDqs_4_, // 322
	_TxImpedanceDqs_5_, // 323
	_TxImpedanceDqs_6_, // 324
	_TxImpedanceDqs_7_, // 325
	_TxImpedanceDqs_8_, // 326
	_TxImpedanceDqs_9_, // 327
	_TxImpedanceDqs_10_, // 328
	_TxImpedanceDqs_11_, // 329
	_TxImpedanceDqs_12_, // 330
	_TxImpedanceDqs_13_, // 331
	_TxImpedanceDqs_14_, // 332
	_RxDqsTrackingThreshold_0_, // 333
	_RxDqsTrackingThreshold_1_, // 334
	_RxDqsTrackingThreshold_2_, // 335
	_RxDqsTrackingThreshold_3_, // 336
	_RxDqsTrackingThreshold_4_, // 337
	_RxDqsTrackingThreshold_5_, // 338
	_RxDqsTrackingThreshold_6_, // 339
	_RxDqsTrackingThreshold_7_, // 340
	_RxDqsTrackingThreshold_8_, // 341
	_RxDqsTrackingThreshold_9_, // 342
	_RxDqsTrackingThreshold_10_, // 343
	_RxDqsTrackingThreshold_11_, // 344
	_RxDqsTrackingThreshold_12_, // 345
	_RxDqsTrackingThreshold_13_, // 346
	_RxDqsTrackingThreshold_14_, // 347
	_DisableTDRAccess_, // 348
	_DisableRetraining_, // 349
	_TxSlewFallDq_0_, // 350
	_TxSlewFallDq_1_, // 351
	_TxSlewFallDq_2_, // 352
	_TxSlewFallDq_3_, // 353
	_TxSlewFallDq_4_, // 354
	_TxSlewFallDq_5_, // 355
	_TxSlewFallDq_6_, // 356
	_TxSlewFallDq_7_, // 357
	_TxSlewFallDq_8_, // 358
	_TxSlewFallDq_9_, // 359
	_TxSlewFallDq_10_, // 360
	_TxSlewFallDq_11_, // 361
	_TxSlewFallDq_12_, // 362
	_TxSlewFallDq_13_, // 363
	_TxSlewFallDq_14_, // 364
	_DisablePmuEcc_, // 365
	_ExtCalResVal_, // 366
	_TxImpedanceWCK_0_, // 367
	_TxImpedanceWCK_1_, // 368
	_TxImpedanceWCK_2_, // 369
	_TxImpedanceWCK_3_, // 370
	_TxImpedanceWCK_4_, // 371
	_TxImpedanceWCK_5_, // 372
	_TxImpedanceWCK_6_, // 373
	_TxImpedanceWCK_7_, // 374
	_TxImpedanceWCK_8_, // 375
	_TxImpedanceWCK_9_, // 376
	_TxImpedanceWCK_10_, // 377
	_TxImpedanceWCK_11_, // 378
	_TxImpedanceWCK_12_, // 379
	_TxImpedanceWCK_13_, // 380
	_TxImpedanceWCK_14_, // 381
	_TxSlewRiseDqs_0_, // 382
	_TxSlewRiseDqs_1_, // 383
	_TxSlewRiseDqs_2_, // 384
	_TxSlewRiseDqs_3_, // 385
	_TxSlewRiseDqs_4_, // 386
	_TxSlewRiseDqs_5_, // 387
	_TxSlewRiseDqs_6_, // 388
	_TxSlewRiseDqs_7_, // 389
	_TxSlewRiseDqs_8_, // 390
	_TxSlewRiseDqs_9_, // 391
	_TxSlewRiseDqs_10_, // 392
	_TxSlewRiseDqs_11_, // 393
	_TxSlewRiseDqs_12_, // 394
	_TxSlewRiseDqs_13_, // 395
	_TxSlewRiseDqs_14_, // 396
	_TxSlewRiseWCK_0_, // 397
	_TxSlewRiseWCK_1_, // 398
	_TxSlewRiseWCK_2_, // 399
	_TxSlewRiseWCK_3_, // 400
	_TxSlewRiseWCK_4_, // 401
	_TxSlewRiseWCK_5_, // 402
	_TxSlewRiseWCK_6_, // 403
	_TxSlewRiseWCK_7_, // 404
	_TxSlewRiseWCK_8_, // 405
	_TxSlewRiseWCK_9_, // 406
	_TxSlewRiseWCK_10_, // 407
	_TxSlewRiseWCK_11_, // 408
	_TxSlewRiseWCK_12_, // 409
	_TxSlewRiseWCK_13_, // 410
	_TxSlewRiseWCK_14_, // 411
	_RxBiasCurrentControlDqs_0_, // 412
	_RxBiasCurrentControlDqs_1_, // 413
	_RxBiasCurrentControlDqs_2_, // 414
	_RxBiasCurrentControlDqs_3_, // 415
	_RxBiasCurrentControlDqs_4_, // 416
	_RxBiasCurrentControlDqs_5_, // 417
	_RxBiasCurrentControlDqs_6_, // 418
	_RxBiasCurrentControlDqs_7_, // 419
	_RxBiasCurrentControlDqs_8_, // 420
	_RxBiasCurrentControlDqs_9_, // 421
	_RxBiasCurrentControlDqs_10_, // 422
	_RxBiasCurrentControlDqs_11_, // 423
	_RxBiasCurrentControlDqs_12_, // 424
	_RxBiasCurrentControlDqs_13_, // 425
	_RxBiasCurrentControlDqs_14_, // 426
	_RxClkTrackWait_, // 427
	_CalOnce_, // 428
	_PhyMstrCtrlMode_0_, // 429
	_PhyMstrCtrlMode_1_, // 430
	_PhyMstrCtrlMode_2_, // 431
	_PhyMstrCtrlMode_3_, // 432
	_PhyMstrCtrlMode_4_, // 433
	_PhyMstrCtrlMode_5_, // 434
	_PhyMstrCtrlMode_6_, // 435
	_PhyMstrCtrlMode_7_, // 436
	_PhyMstrCtrlMode_8_, // 437
	_PhyMstrCtrlMode_9_, // 438
	_PhyMstrCtrlMode_10_, // 439
	_PhyMstrCtrlMode_11_, // 440
	_PhyMstrCtrlMode_12_, // 441
	_PhyMstrCtrlMode_13_, // 442
	_PhyMstrCtrlMode_14_, // 443
	_RxVrefKickbackNoiseCancellation_0_, // 444
	_RxVrefKickbackNoiseCancellation_1_, // 445
	_RxVrefKickbackNoiseCancellation_2_, // 446
	_RxVrefKickbackNoiseCancellation_3_, // 447
	_RxVrefKickbackNoiseCancellation_4_, // 448
	_RxVrefKickbackNoiseCancellation_5_, // 449
	_RxVrefKickbackNoiseCancellation_6_, // 450
	_RxVrefKickbackNoiseCancellation_7_, // 451
	_RxVrefKickbackNoiseCancellation_8_, // 452
	_RxVrefKickbackNoiseCancellation_9_, // 453
	_RxVrefKickbackNoiseCancellation_10_, // 454
	_RxVrefKickbackNoiseCancellation_11_, // 455
	_RxVrefKickbackNoiseCancellation_12_, // 456
	_RxVrefKickbackNoiseCancellation_13_, // 457
	_RxVrefKickbackNoiseCancellation_14_, // 458
	_RxClkTrackWaitUI_, // 459
	_TxImpedanceDq_0_, // 460
	_TxImpedanceDq_1_, // 461
	_TxImpedanceDq_2_, // 462
	_TxImpedanceDq_3_, // 463
	_TxImpedanceDq_4_, // 464
	_TxImpedanceDq_5_, // 465
	_TxImpedanceDq_6_, // 466
	_TxImpedanceDq_7_, // 467
	_TxImpedanceDq_8_, // 468
	_TxImpedanceDq_9_, // 469
	_TxImpedanceDq_10_, // 470
	_TxImpedanceDq_11_, // 471
	_TxImpedanceDq_12_, // 472
	_TxImpedanceDq_13_, // 473
	_TxImpedanceDq_14_, // 474
	_OnlyRestoreNonPsRegs_, // 475
	_TrainSequenceCtrl_, // 476
	_TxImpedanceCk_0_, // 477
	_TxImpedanceCk_1_, // 478
	_TxImpedanceCk_2_, // 479
	_TxImpedanceCk_3_, // 480
	_TxImpedanceCk_4_, // 481
	_TxImpedanceCk_5_, // 482
	_TxImpedanceCk_6_, // 483
	_TxImpedanceCk_7_, // 484
	_TxImpedanceCk_8_, // 485
	_TxImpedanceCk_9_, // 486
	_TxImpedanceCk_10_, // 487
	_TxImpedanceCk_11_, // 488
	_TxImpedanceCk_12_, // 489
	_TxImpedanceCk_13_, // 490
	_TxImpedanceCk_14_, // 491
	_DisableFspOp_, // 492
	_TxImpedanceDTO_0_, // 493
	_TxImpedanceDTO_1_, // 494
	_TxImpedanceDTO_2_, // 495
	_TxImpedanceDTO_3_, // 496
	_TxImpedanceDTO_4_, // 497
	_TxImpedanceDTO_5_, // 498
	_TxImpedanceDTO_6_, // 499
	_TxImpedanceDTO_7_, // 500
	_TxImpedanceDTO_8_, // 501
	_TxImpedanceDTO_9_, // 502
	_TxImpedanceDTO_10_, // 503
	_TxImpedanceDTO_11_, // 504
	_TxImpedanceDTO_12_, // 505
	_TxImpedanceDTO_13_, // 506
	_TxImpedanceDTO_14_, // 507
	_EnRxDqsTracking_0_, // 508
	_EnRxDqsTracking_1_, // 509
	_EnRxDqsTracking_2_, // 510
	_EnRxDqsTracking_3_, // 511
	_EnRxDqsTracking_4_, // 512
	_EnRxDqsTracking_5_, // 513
	_EnRxDqsTracking_6_, // 514
	_EnRxDqsTracking_7_, // 515
	_EnRxDqsTracking_8_, // 516
	_EnRxDqsTracking_9_, // 517
	_EnRxDqsTracking_10_, // 518
	_EnRxDqsTracking_11_, // 519
	_EnRxDqsTracking_12_, // 520
	_EnRxDqsTracking_13_, // 521
	_EnRxDqsTracking_14_, // 522
	_CalInterval_, // 523
	_RxBiasCurrentControlWck_0_, // 524
	_RxBiasCurrentControlWck_1_, // 525
	_RxBiasCurrentControlWck_2_, // 526
	_RxBiasCurrentControlWck_3_, // 527
	_RxBiasCurrentControlWck_4_, // 528
	_RxBiasCurrentControlWck_5_, // 529
	_RxBiasCurrentControlWck_6_, // 530
	_RxBiasCurrentControlWck_7_, // 531
	_RxBiasCurrentControlWck_8_, // 532
	_RxBiasCurrentControlWck_9_, // 533
	_RxBiasCurrentControlWck_10_, // 534
	_RxBiasCurrentControlWck_11_, // 535
	_RxBiasCurrentControlWck_12_, // 536
	_RxBiasCurrentControlWck_13_, // 537
	_RxBiasCurrentControlWck_14_, // 538
	_RetrainMode_0_, // 539
	_RetrainMode_1_, // 540
	_RetrainMode_2_, // 541
	_RetrainMode_3_, // 542
	_RetrainMode_4_, // 543
	_RetrainMode_5_, // 544
	_RetrainMode_6_, // 545
	_RetrainMode_7_, // 546
	_RetrainMode_8_, // 547
	_RetrainMode_9_, // 548
	_RetrainMode_10_, // 549
	_RetrainMode_11_, // 550
	_RetrainMode_12_, // 551
	_RetrainMode_13_, // 552
	_RetrainMode_14_, // 553
	_RxVrefDACEnable_0_, // 554
	_RxVrefDACEnable_1_, // 555
	_RxVrefDACEnable_2_, // 556
	_RxVrefDACEnable_3_, // 557
	_RxVrefDACEnable_4_, // 558
	_RxVrefDACEnable_5_, // 559
	_RxVrefDACEnable_6_, // 560
	_RxVrefDACEnable_7_, // 561
	_RxVrefDACEnable_8_, // 562
	_RxVrefDACEnable_9_, // 563
	_RxVrefDACEnable_10_, // 564
	_RxVrefDACEnable_11_, // 565
	_RxVrefDACEnable_12_, // 566
	_RxVrefDACEnable_13_, // 567
	_RxVrefDACEnable_14_, // 568
	_PhyMstrTrainInterval_0_, // 569
	_PhyMstrTrainInterval_1_, // 570
	_PhyMstrTrainInterval_2_, // 571
	_PhyMstrTrainInterval_3_, // 572
	_PhyMstrTrainInterval_4_, // 573
	_PhyMstrTrainInterval_5_, // 574
	_PhyMstrTrainInterval_6_, // 575
	_PhyMstrTrainInterval_7_, // 576
	_PhyMstrTrainInterval_8_, // 577
	_PhyMstrTrainInterval_9_, // 578
	_PhyMstrTrainInterval_10_, // 579
	_PhyMstrTrainInterval_11_, // 580
	_PhyMstrTrainInterval_12_, // 581
	_PhyMstrTrainInterval_13_, // 582
	_PhyMstrTrainInterval_14_, // 583
	_Lp3DramState_0_, // 584
	_Lp3DramState_1_, // 585
	_Lp3DramState_2_, // 586
	_Lp3DramState_3_, // 587
	_Lp3DramState_4_, // 588
	_Lp3DramState_5_, // 589
	_Lp3DramState_6_, // 590
	_Lp3DramState_7_, // 591
	_Lp3DramState_8_, // 592
	_Lp3DramState_9_, // 593
	_Lp3DramState_10_, // 594
	_Lp3DramState_11_, // 595
	_Lp3DramState_12_, // 596
	_Lp3DramState_13_, // 597
	_Lp3DramState_14_, // 598
	_PmuClockDiv_0_, // 599
	_PmuClockDiv_1_, // 600
	_PmuClockDiv_2_, // 601
	_PmuClockDiv_3_, // 602
	_PmuClockDiv_4_, // 603
	_PmuClockDiv_5_, // 604
	_PmuClockDiv_6_, // 605
	_PmuClockDiv_7_, // 606
	_PmuClockDiv_8_, // 607
	_PmuClockDiv_9_, // 608
	_PmuClockDiv_10_, // 609
	_PmuClockDiv_11_, // 610
	_PmuClockDiv_12_, // 611
	_PmuClockDiv_13_, // 612
	_PmuClockDiv_14_, // 613
	_WDQSExt_, // 614
	_DisablePhyUpdate_, // 615
	_OdtImpedanceCa_0_, // 616
	_OdtImpedanceCa_1_, // 617
	_OdtImpedanceCa_2_, // 618
	_OdtImpedanceCa_3_, // 619
	_OdtImpedanceCa_4_, // 620
	_OdtImpedanceCa_5_, // 621
	_OdtImpedanceCa_6_, // 622
	_OdtImpedanceCa_7_, // 623
	_OdtImpedanceCa_8_, // 624
	_OdtImpedanceCa_9_, // 625
	_OdtImpedanceCa_10_, // 626
	_OdtImpedanceCa_11_, // 627
	_OdtImpedanceCa_12_, // 628
	_OdtImpedanceCa_13_, // 629
	_OdtImpedanceCa_14_, // 630
	_SkipFlashCopy_0_, // 631
	_SkipFlashCopy_1_, // 632
	_SkipFlashCopy_2_, // 633
	_SkipFlashCopy_3_, // 634
	_SkipFlashCopy_4_, // 635
	_SkipFlashCopy_5_, // 636
	_SkipFlashCopy_6_, // 637
	_SkipFlashCopy_7_, // 638
	_SkipFlashCopy_8_, // 639
	_SkipFlashCopy_9_, // 640
	_SkipFlashCopy_10_, // 641
	_SkipFlashCopy_11_, // 642
	_SkipFlashCopy_12_, // 643
	_SkipFlashCopy_13_, // 644
	_SkipFlashCopy_14_, // 645
	_DqsOscRunTimeSel_0_, // 646
	_DqsOscRunTimeSel_1_, // 647
	_DqsOscRunTimeSel_2_, // 648
	_DqsOscRunTimeSel_3_, // 649
	_DqsOscRunTimeSel_4_, // 650
	_DqsOscRunTimeSel_5_, // 651
	_DqsOscRunTimeSel_6_, // 652
	_DqsOscRunTimeSel_7_, // 653
	_DqsOscRunTimeSel_8_, // 654
	_DqsOscRunTimeSel_9_, // 655
	_DqsOscRunTimeSel_10_, // 656
	_DqsOscRunTimeSel_11_, // 657
	_DqsOscRunTimeSel_12_, // 658
	_DqsOscRunTimeSel_13_, // 659
	_DqsOscRunTimeSel_14_, // 660
	_RxBiasCurrentControlCk_0_, // 661
	_RxBiasCurrentControlCk_1_, // 662
	_RxBiasCurrentControlCk_2_, // 663
	_RxBiasCurrentControlCk_3_, // 664
	_RxBiasCurrentControlCk_4_, // 665
	_RxBiasCurrentControlCk_5_, // 666
	_RxBiasCurrentControlCk_6_, // 667
	_RxBiasCurrentControlCk_7_, // 668
	_RxBiasCurrentControlCk_8_, // 669
	_RxBiasCurrentControlCk_9_, // 670
	_RxBiasCurrentControlCk_10_, // 671
	_RxBiasCurrentControlCk_11_, // 672
	_RxBiasCurrentControlCk_12_, // 673
	_RxBiasCurrentControlCk_13_, // 674
	_RxBiasCurrentControlCk_14_, // 675
	// pUserInputBasic Fields:
	_NumPStates_, // 676
	_NumRank_dfi0_, // 677
	_HardMacroVer_, // 678
	_NumCh_, // 679
	_DimmType_, // 680
	_DramType_, // 681
	_DfiFreqRatio_0_, // 682
	_DfiFreqRatio_1_, // 683
	_DfiFreqRatio_2_, // 684
	_DfiFreqRatio_3_, // 685
	_DfiFreqRatio_4_, // 686
	_DfiFreqRatio_5_, // 687
	_DfiFreqRatio_6_, // 688
	_DfiFreqRatio_7_, // 689
	_DfiFreqRatio_8_, // 690
	_DfiFreqRatio_9_, // 691
	_DfiFreqRatio_10_, // 692
	_DfiFreqRatio_11_, // 693
	_DfiFreqRatio_12_, // 694
	_DfiFreqRatio_13_, // 695
	_DfiFreqRatio_14_, // 696
	_FirstPState_, // 697
	_NumActiveDbyteDfi1_, // 698
	_NumRank_, // 699
	_DramDataWidth_, // 700
	_CfgPStates_, // 701
	_Frequency_0_, // 702
	_Frequency_1_, // 703
	_Frequency_2_, // 704
	_Frequency_3_, // 705
	_Frequency_4_, // 706
	_Frequency_5_, // 707
	_Frequency_6_, // 708
	_Frequency_7_, // 709
	_Frequency_8_, // 710
	_Frequency_9_, // 711
	_Frequency_10_, // 712
	_Frequency_11_, // 713
	_Frequency_12_, // 714
	_Frequency_13_, // 715
	_Frequency_14_, // 716
	_PllBypass_0_, // 717
	_PllBypass_1_, // 718
	_PllBypass_2_, // 719
	_PllBypass_3_, // 720
	_PllBypass_4_, // 721
	_PllBypass_5_, // 722
	_PllBypass_6_, // 723
	_PllBypass_7_, // 724
	_PllBypass_8_, // 725
	_PllBypass_9_, // 726
	_PllBypass_10_, // 727
	_PllBypass_11_, // 728
	_PllBypass_12_, // 729
	_PllBypass_13_, // 730
	_PllBypass_14_, // 731
	_NumRank_dfi1_, // 732
	_NumDbytesPerCh_, // 733
	_MaxNumZQ_, // 734
	_NumActiveDbyteDfi0_, // 735
	// pUserInputSim Fields:
	_tWCK2DQO_, // 736
	_tWCK2DQI_, // 737
	_tWCK2CK_, // 738
	_PHY_tDQS2DQ_, // 739
} userInputFields;

typedef enum {
	DQ,
	DQS,
	WCK,
	AC,
	CK,
	CS
} SliceName_t;


/// A structure to store the sequence function runtime input variables.
typedef struct runtime_config {
	int Train2D;				///< train2d input parameter (deprecated, training is always 2D)

	uint8_t initCtrl;			///< Enable skipping certain initializations steps of for debug and simulation speedup.
	///< Bit   | Name        | Control Setting
	///< ----- | ----        | ---
	///<     0 | progCsrSkip | When bit is set progCsrSkipTrain() function is called to program PHY registers in lieu of training firmware.
	///<     1 | skip_fw     | When bit is set skip execution of training firmware entirely  including skipping imem and dmem loads.
	///<     2 | skip_imem   | When bit is set only skip imem load
	///<     3 | skip_dmem   | When bit is set only skip dmem load
	///<     4 | skip_pie    | When bit is set skip loading PIE image.
	///<     5 | devinit     | When bit is set forces SequenceCtrl in messageBlock to devinit

	int skip_train;				///< skip_train input parameter

	///<  - if set to 0 firmware training is executed.
	///<  - if set to 1 training is skipped and registers are programed to work with
	///<    zero board delay.
	///<  - if set to 2 training is skipped but firmware is executed to
	///<    initialize the DRAM state while registers are programed to work with zero
	///<    board delay.

	int debug;					///< print debug messages
	int RetEn;					///< Retention Enable input parameter, instructs phyinit to \n
	///< issue register reads during initialization to retention registers.

	uint8_t curPState;			///< Internal variable representing current PState of PhyInit as it loops through
	///< all PStates. used by various functions.

	uint8_t firstTrainedPState;			///< Internal variable set to 1 for the first trained PState.

	uint8_t lastTrainedPState;			///< Internal variable set to 1 for the last trained PState.

	int curD;					///< Represents the Current dimension of Training 1D vs 2D.

	uint8_t ZQCalCodePU_saved;			///< Internal variable to store the csr_ZQCalCodePU value for s3 exit restoration.
	uint8_t ZQCalCodePD_saved;			///< Internal variable to store the csr_ZQCalCodePD value for s3 exit restoration.

} runtime_config_t;

/// PhyInit meta structure that holds other structures
typedef struct phyinit_config {

	/// PHY Identifier when using multiple PHY's
	int CurrentPhyInst;

	///< Represent the value stored in Step C into the register with the same name.
	int PclkPtrInitVal[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

	///< Updated count values for marked ACSM instructions.
	uint16_t AcsmMrkrCnt[16];

	// === Global Struct Defines === //
	/// instance of runtime objects
	runtime_config_t runtimeConfig;
	/// instance of useInputBasic
	user_input_basic_t userInputBasic;
	/// instance of userInputAdvanced
	user_input_advanced_t userInputAdvanced;
	/// instance of userInputSim
	user_input_sim_t userInputSim;
        /// Data passed by the user to control phyinit. 
        user_control_t userControlData; 

	// === Firmware Message Block Structs === //
	/// 1D message block instance
	PMU_SMB_LPDDR5_1D_t mb_LPDDR5_1D[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	/// Shadow of 1D message block. Used by PhyInit to track user changes to the data structure.
	PMU_SMB_LPDDR5_1D_t shdw_LPDDR5_1D[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

} phyinit_config_t;

//-------------------------------
// Global variables - defined in dwc_ddrphy_phyinit_globals.c
//-------------------------------

/*! \def MAX_NUM_RET_REGS
 *  \brief default Max number of retention registers
 *
 * This define is only used by the PhyInit Register interface to define the max
 * amount of registered that can be saved. The user may increase this variable
 * as desired if a larger number of registers need to be restored.
 */
#define MAX_NUM_RET_REGS 10000


//-------------------------------------------------------------
// Fixed Function prototypes
//-------------------------------------------------------------
int dwc_ddrphy_phyinit_sequence(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_sequencePsLoop(phyinit_config_t *phyctx);
int dwc_ddrphy_phyinit_restore_sequence(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_C_initPhyConfig(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_C_initPhyConfigPsLoop(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_D_loadIMEM(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_progCsrSkipTrain(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_progCsrSkipTrainPsLoop(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_F_loadDMEM(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_G_execFW(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_H_readMsgBlock(phyinit_config_t *phyctx, int Train2D);
void dwc_ddrphy_phyinit_I_loadPIEImage(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_I_loadPIEImagePsLoop(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_assert(int Svrty, const char *fmt, ...);
void dwc_ddrphy_phyinit_cmnt(const char *fmt, ...);
void dwc_ddrphy_phyinit_print(const char *fmt, ...);
void dwc_ddrphy_phyinit_print_dat(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_LoadPieProdCode(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_setDefault(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_calcMb(phyinit_config_t *phyctx);
int dwc_ddrphy_phyinit_storeIncvFile(char *incv_file_name, uint16_t mem[], return_offset_lastaddr_t return_type);
void dwc_ddrphy_phyinit_storeMsgBlk(void *msgBlkPtr, int sizeOfMsgBlk, uint16_t mem[]);
void dwc_ddrphy_phyinit_WriteOutMem(uint16_t mem[], int mem_offset, int mem_size);
int dwc_ddrphy_phyinit_IsDbyteDisabled(phyinit_config_t *phyctx, int DbyteNumber);
int dwc_ddrphy_phyinit_getUserInput(phyinit_config_t *phyctx, char *field);
int dwc_ddrphy_phyinit_getMb(phyinit_config_t *phyctx, int ps, char *field);
int dwc_ddrphy_phyinit_setUserInput_enum(phyinit_config_t *phyctx, userInputFields field, int value);
int dwc_ddrphy_phyinit_setUserInput(phyinit_config_t *phyctx, char *field, int value);
int dwc_ddrphy_phyinit_trackReg(uint32_t adr);
int dwc_ddrphy_phyinit_regInterface(regInstr myRegInstr, uint32_t adr, uint16_t dat);
void dwc_ddrphy_phyinit_chkInputs(phyinit_config_t *phyctx);

extern void dwc_ddrphy_phyinit_userCustom_overrideUserInput(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_A_bringupPower(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_customPreTrain(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_customPreTrainPsLoop(phyinit_config_t *phyctx, int pstate);
extern void dwc_ddrphy_phyinit_userCustom_customPostTrain(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_customPostTrainPsLoop(phyinit_config_t *phyctx, int pstate);
extern int dwc_ddrphy_phyinit_userCustom_E_setDfiClk(phyinit_config_t *phyctx, int pstate);
extern void dwc_ddrphy_phyinit_userCustom_G_waitFwDone(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_H_readMsgBlock(phyinit_config_t *phyctx, int Train2D);
extern void dwc_ddrphy_phyinit_userCustom_J_enterMissionMode(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_io_write16(uint32_t adr, uint16_t dat);
void dwc_ddrphy_phyinit_io_write16(uint32_t adr, uint16_t dat);
extern uint16_t dwc_ddrphy_phyinit_userCustom_io_read16(uint32_t adr);
extern void dwc_ddrphy_phyinit_userCustom_saveRetRegs(phyinit_config_t *phyctx);
extern void dwc_ddrphy_phyinit_userCustom_wait(uint32_t nDfiClks);
void dwc_ddrphy_phyinit_MicroContMuxSel_write16 (uint16_t dat);
void dwc_ddrphy_phyinit_ProgPPT(phyinit_config_t *phyctx);
void dwc_ddrphy_phyinit_PieFlags(phyinit_config_t *phyctx, int prog_csr);
int dwc_ddrphy_phyinit_setReg(uint32_t adr, uint16_t dat);
void dwc_ddrphy_phyinit_initReg(phyinit_config_t *ptr);
void dwc_ddrphy_phyinit_writeDmaRow(void);
void dwc_ddrphy_phyinit_programPLL(phyinit_config_t *phyctx, int mode, const char* print_header);
int dwc_ddrphy_phyinit_programTxStren(phyinit_config_t *phyctx, SliceName_t SliceName, int higherVOHLp4, const char* print_header);

int dwc_ddrphy_phyinit_setStruct(phyinit_config_t *phyctx, const void *userStruct, int structType);
phyinit_config_t* dwc_ddrphy_phyinit_configAlloc(int skip_train, int Train2D, int debug);
void dwc_ddrphy_phyinit_configFree(phyinit_config_t *ptr);

void dwc_ddrphy_phyinit_ps_sram_init(void);
void dwc_ddrphy_phyinit_ps_sram_free(void);
void dwc_ddrphy_phyinit_setRegChkr(uint16_t *dmaWords_local, uint16_t row);
void dwc_ddrphy_phyinit_check_ps_sram(void);
void dwc_ddrphy_phyinit_report_ps_sram(int pstate_mask);

#if PUB==1
#include "pub1/dwc_ddrphy_csr_ALL_cdefines.h"
#else
#include "dwc_ddrphy_csr_ALL_cdefines.h"
#endif

