

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
#define IMEM_INCV_FILENAME FW_FILES_LOC"/lpddr4x/lpddr4x_pmu_train_imem.incv"
#define DMEM_INCV_FILENAME FW_FILES_LOC"/lpddr4x/lpddr4x_pmu_train_dmem.incv"

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
#include "mnPmuSramMsgBlock_lpddr4x.h"

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
	_PhyMstrTrainInterval_0_, // 11
	_PhyMstrTrainInterval_1_, // 12
	_PhyMstrTrainInterval_2_, // 13
	_PhyMstrTrainInterval_3_, // 14
	_PhyMstrTrainInterval_4_, // 15
	_PhyMstrTrainInterval_5_, // 16
	_PhyMstrTrainInterval_6_, // 17
	_PhyMstrTrainInterval_7_, // 18
	_PhyMstrTrainInterval_8_, // 19
	_PhyMstrTrainInterval_9_, // 20
	_PhyMstrTrainInterval_10_, // 21
	_PhyMstrTrainInterval_11_, // 22
	_PhyMstrTrainInterval_12_, // 23
	_PhyMstrTrainInterval_13_, // 24
	_PhyMstrTrainInterval_14_, // 25
	_RxDfeMode_0_, // 26
	_RxDfeMode_1_, // 27
	_RxDfeMode_2_, // 28
	_RxDfeMode_3_, // 29
	_RxDfeMode_4_, // 30
	_RxDfeMode_5_, // 31
	_RxDfeMode_6_, // 32
	_RxDfeMode_7_, // 33
	_RxDfeMode_8_, // 34
	_RxDfeMode_9_, // 35
	_RxDfeMode_10_, // 36
	_RxDfeMode_11_, // 37
	_RxDfeMode_12_, // 38
	_RxDfeMode_13_, // 39
	_RxDfeMode_14_, // 40
	_TxSlewFallDq_0_, // 41
	_TxSlewFallDq_1_, // 42
	_TxSlewFallDq_2_, // 43
	_TxSlewFallDq_3_, // 44
	_TxSlewFallDq_4_, // 45
	_TxSlewFallDq_5_, // 46
	_TxSlewFallDq_6_, // 47
	_TxSlewFallDq_7_, // 48
	_TxSlewFallDq_8_, // 49
	_TxSlewFallDq_9_, // 50
	_TxSlewFallDq_10_, // 51
	_TxSlewFallDq_11_, // 52
	_TxSlewFallDq_12_, // 53
	_TxSlewFallDq_13_, // 54
	_TxSlewFallDq_14_, // 55
	_RxBiasCurrentControlRxReplica_0_, // 56
	_RxBiasCurrentControlRxReplica_1_, // 57
	_RxBiasCurrentControlRxReplica_2_, // 58
	_RxBiasCurrentControlRxReplica_3_, // 59
	_RxBiasCurrentControlRxReplica_4_, // 60
	_RxBiasCurrentControlRxReplica_5_, // 61
	_RxBiasCurrentControlRxReplica_6_, // 62
	_RxBiasCurrentControlRxReplica_7_, // 63
	_RxBiasCurrentControlRxReplica_8_, // 64
	_RxBiasCurrentControlRxReplica_9_, // 65
	_RxBiasCurrentControlRxReplica_10_, // 66
	_RxBiasCurrentControlRxReplica_11_, // 67
	_RxBiasCurrentControlRxReplica_12_, // 68
	_RxBiasCurrentControlRxReplica_13_, // 69
	_RxBiasCurrentControlRxReplica_14_, // 70
	_TxSlewRiseCS_0_, // 71
	_TxSlewRiseCS_1_, // 72
	_TxSlewRiseCS_2_, // 73
	_TxSlewRiseCS_3_, // 74
	_TxSlewRiseCS_4_, // 75
	_TxSlewRiseCS_5_, // 76
	_TxSlewRiseCS_6_, // 77
	_TxSlewRiseCS_7_, // 78
	_TxSlewRiseCS_8_, // 79
	_TxSlewRiseCS_9_, // 80
	_TxSlewRiseCS_10_, // 81
	_TxSlewRiseCS_11_, // 82
	_TxSlewRiseCS_12_, // 83
	_TxSlewRiseCS_13_, // 84
	_TxSlewRiseCS_14_, // 85
	_OdtImpedanceCa_0_, // 86
	_OdtImpedanceCa_1_, // 87
	_OdtImpedanceCa_2_, // 88
	_OdtImpedanceCa_3_, // 89
	_OdtImpedanceCa_4_, // 90
	_OdtImpedanceCa_5_, // 91
	_OdtImpedanceCa_6_, // 92
	_OdtImpedanceCa_7_, // 93
	_OdtImpedanceCa_8_, // 94
	_OdtImpedanceCa_9_, // 95
	_OdtImpedanceCa_10_, // 96
	_OdtImpedanceCa_11_, // 97
	_OdtImpedanceCa_12_, // 98
	_OdtImpedanceCa_13_, // 99
	_OdtImpedanceCa_14_, // 100
	_RxModeBoostVDD_0_, // 101
	_RxModeBoostVDD_1_, // 102
	_RxModeBoostVDD_2_, // 103
	_RxModeBoostVDD_3_, // 104
	_RxModeBoostVDD_4_, // 105
	_RxModeBoostVDD_5_, // 106
	_RxModeBoostVDD_6_, // 107
	_RxModeBoostVDD_7_, // 108
	_RxModeBoostVDD_8_, // 109
	_RxModeBoostVDD_9_, // 110
	_RxModeBoostVDD_10_, // 111
	_RxModeBoostVDD_11_, // 112
	_RxModeBoostVDD_12_, // 113
	_RxModeBoostVDD_13_, // 114
	_RxModeBoostVDD_14_, // 115
	_PhyVrefCode_, // 116
	_OdtImpedanceCs_0_, // 117
	_OdtImpedanceCs_1_, // 118
	_OdtImpedanceCs_2_, // 119
	_OdtImpedanceCs_3_, // 120
	_OdtImpedanceCs_4_, // 121
	_OdtImpedanceCs_5_, // 122
	_OdtImpedanceCs_6_, // 123
	_OdtImpedanceCs_7_, // 124
	_OdtImpedanceCs_8_, // 125
	_OdtImpedanceCs_9_, // 126
	_OdtImpedanceCs_10_, // 127
	_OdtImpedanceCs_11_, // 128
	_OdtImpedanceCs_12_, // 129
	_OdtImpedanceCs_13_, // 130
	_OdtImpedanceCs_14_, // 131
	_CkDisVal_0_, // 132
	_CkDisVal_1_, // 133
	_CkDisVal_2_, // 134
	_CkDisVal_3_, // 135
	_CkDisVal_4_, // 136
	_CkDisVal_5_, // 137
	_CkDisVal_6_, // 138
	_CkDisVal_7_, // 139
	_CkDisVal_8_, // 140
	_CkDisVal_9_, // 141
	_CkDisVal_10_, // 142
	_CkDisVal_11_, // 143
	_CkDisVal_12_, // 144
	_CkDisVal_13_, // 145
	_CkDisVal_14_, // 146
	_OdtImpedanceDqs_0_, // 147
	_OdtImpedanceDqs_1_, // 148
	_OdtImpedanceDqs_2_, // 149
	_OdtImpedanceDqs_3_, // 150
	_OdtImpedanceDqs_4_, // 151
	_OdtImpedanceDqs_5_, // 152
	_OdtImpedanceDqs_6_, // 153
	_OdtImpedanceDqs_7_, // 154
	_OdtImpedanceDqs_8_, // 155
	_OdtImpedanceDqs_9_, // 156
	_OdtImpedanceDqs_10_, // 157
	_OdtImpedanceDqs_11_, // 158
	_OdtImpedanceDqs_12_, // 159
	_OdtImpedanceDqs_13_, // 160
	_OdtImpedanceDqs_14_, // 161
	_PmuClockDiv_0_, // 162
	_PmuClockDiv_1_, // 163
	_PmuClockDiv_2_, // 164
	_PmuClockDiv_3_, // 165
	_PmuClockDiv_4_, // 166
	_PmuClockDiv_5_, // 167
	_PmuClockDiv_6_, // 168
	_PmuClockDiv_7_, // 169
	_PmuClockDiv_8_, // 170
	_PmuClockDiv_9_, // 171
	_PmuClockDiv_10_, // 172
	_PmuClockDiv_11_, // 173
	_PmuClockDiv_12_, // 174
	_PmuClockDiv_13_, // 175
	_PmuClockDiv_14_, // 176
	_OnlyRestoreNonPsRegs_, // 177
	_TxSlewFallCS_0_, // 178
	_TxSlewFallCS_1_, // 179
	_TxSlewFallCS_2_, // 180
	_TxSlewFallCS_3_, // 181
	_TxSlewFallCS_4_, // 182
	_TxSlewFallCS_5_, // 183
	_TxSlewFallCS_6_, // 184
	_TxSlewFallCS_7_, // 185
	_TxSlewFallCS_8_, // 186
	_TxSlewFallCS_9_, // 187
	_TxSlewFallCS_10_, // 188
	_TxSlewFallCS_11_, // 189
	_TxSlewFallCS_12_, // 190
	_TxSlewFallCS_13_, // 191
	_TxSlewFallCS_14_, // 192
	_TxSlewFallCA_0_, // 193
	_TxSlewFallCA_1_, // 194
	_TxSlewFallCA_2_, // 195
	_TxSlewFallCA_3_, // 196
	_TxSlewFallCA_4_, // 197
	_TxSlewFallCA_5_, // 198
	_TxSlewFallCA_6_, // 199
	_TxSlewFallCA_7_, // 200
	_TxSlewFallCA_8_, // 201
	_TxSlewFallCA_9_, // 202
	_TxSlewFallCA_10_, // 203
	_TxSlewFallCA_11_, // 204
	_TxSlewFallCA_12_, // 205
	_TxSlewFallCA_13_, // 206
	_TxSlewFallCA_14_, // 207
	_TxSlewRiseCK_0_, // 208
	_TxSlewRiseCK_1_, // 209
	_TxSlewRiseCK_2_, // 210
	_TxSlewRiseCK_3_, // 211
	_TxSlewRiseCK_4_, // 212
	_TxSlewRiseCK_5_, // 213
	_TxSlewRiseCK_6_, // 214
	_TxSlewRiseCK_7_, // 215
	_TxSlewRiseCK_8_, // 216
	_TxSlewRiseCK_9_, // 217
	_TxSlewRiseCK_10_, // 218
	_TxSlewRiseCK_11_, // 219
	_TxSlewRiseCK_12_, // 220
	_TxSlewRiseCK_13_, // 221
	_TxSlewRiseCK_14_, // 222
	_RetrainMode_0_, // 223
	_RetrainMode_1_, // 224
	_RetrainMode_2_, // 225
	_RetrainMode_3_, // 226
	_RetrainMode_4_, // 227
	_RetrainMode_5_, // 228
	_RetrainMode_6_, // 229
	_RetrainMode_7_, // 230
	_RetrainMode_8_, // 231
	_RetrainMode_9_, // 232
	_RetrainMode_10_, // 233
	_RetrainMode_11_, // 234
	_RetrainMode_12_, // 235
	_RetrainMode_13_, // 236
	_RetrainMode_14_, // 237
	_TrainSequenceCtrl_, // 238
	_TxSlewRiseDq_0_, // 239
	_TxSlewRiseDq_1_, // 240
	_TxSlewRiseDq_2_, // 241
	_TxSlewRiseDq_3_, // 242
	_TxSlewRiseDq_4_, // 243
	_TxSlewRiseDq_5_, // 244
	_TxSlewRiseDq_6_, // 245
	_TxSlewRiseDq_7_, // 246
	_TxSlewRiseDq_8_, // 247
	_TxSlewRiseDq_9_, // 248
	_TxSlewRiseDq_10_, // 249
	_TxSlewRiseDq_11_, // 250
	_TxSlewRiseDq_12_, // 251
	_TxSlewRiseDq_13_, // 252
	_TxSlewRiseDq_14_, // 253
	_TxImpedanceDTO_0_, // 254
	_TxImpedanceDTO_1_, // 255
	_TxImpedanceDTO_2_, // 256
	_TxImpedanceDTO_3_, // 257
	_TxImpedanceDTO_4_, // 258
	_TxImpedanceDTO_5_, // 259
	_TxImpedanceDTO_6_, // 260
	_TxImpedanceDTO_7_, // 261
	_TxImpedanceDTO_8_, // 262
	_TxImpedanceDTO_9_, // 263
	_TxImpedanceDTO_10_, // 264
	_TxImpedanceDTO_11_, // 265
	_TxImpedanceDTO_12_, // 266
	_TxImpedanceDTO_13_, // 267
	_TxImpedanceDTO_14_, // 268
	_SkipFlashCopy_0_, // 269
	_SkipFlashCopy_1_, // 270
	_SkipFlashCopy_2_, // 271
	_SkipFlashCopy_3_, // 272
	_SkipFlashCopy_4_, // 273
	_SkipFlashCopy_5_, // 274
	_SkipFlashCopy_6_, // 275
	_SkipFlashCopy_7_, // 276
	_SkipFlashCopy_8_, // 277
	_SkipFlashCopy_9_, // 278
	_SkipFlashCopy_10_, // 279
	_SkipFlashCopy_11_, // 280
	_SkipFlashCopy_12_, // 281
	_SkipFlashCopy_13_, // 282
	_SkipFlashCopy_14_, // 283
	_RxClkTrackWait_, // 284
	_TxSlewRiseCA_0_, // 285
	_TxSlewRiseCA_1_, // 286
	_TxSlewRiseCA_2_, // 287
	_TxSlewRiseCA_3_, // 288
	_TxSlewRiseCA_4_, // 289
	_TxSlewRiseCA_5_, // 290
	_TxSlewRiseCA_6_, // 291
	_TxSlewRiseCA_7_, // 292
	_TxSlewRiseCA_8_, // 293
	_TxSlewRiseCA_9_, // 294
	_TxSlewRiseCA_10_, // 295
	_TxSlewRiseCA_11_, // 296
	_TxSlewRiseCA_12_, // 297
	_TxSlewRiseCA_13_, // 298
	_TxSlewRiseCA_14_, // 299
	_TxImpedanceCs_0_, // 300
	_TxImpedanceCs_1_, // 301
	_TxImpedanceCs_2_, // 302
	_TxImpedanceCs_3_, // 303
	_TxImpedanceCs_4_, // 304
	_TxImpedanceCs_5_, // 305
	_TxImpedanceCs_6_, // 306
	_TxImpedanceCs_7_, // 307
	_TxImpedanceCs_8_, // 308
	_TxImpedanceCs_9_, // 309
	_TxImpedanceCs_10_, // 310
	_TxImpedanceCs_11_, // 311
	_TxImpedanceCs_12_, // 312
	_TxImpedanceCs_13_, // 313
	_TxImpedanceCs_14_, // 314
	_DramByteSwap_, // 315
	_PhyMstrCtrlMode_0_, // 316
	_PhyMstrCtrlMode_1_, // 317
	_PhyMstrCtrlMode_2_, // 318
	_PhyMstrCtrlMode_3_, // 319
	_PhyMstrCtrlMode_4_, // 320
	_PhyMstrCtrlMode_5_, // 321
	_PhyMstrCtrlMode_6_, // 322
	_PhyMstrCtrlMode_7_, // 323
	_PhyMstrCtrlMode_8_, // 324
	_PhyMstrCtrlMode_9_, // 325
	_PhyMstrCtrlMode_10_, // 326
	_PhyMstrCtrlMode_11_, // 327
	_PhyMstrCtrlMode_12_, // 328
	_PhyMstrCtrlMode_13_, // 329
	_PhyMstrCtrlMode_14_, // 330
	_TxImpedanceDqs_0_, // 331
	_TxImpedanceDqs_1_, // 332
	_TxImpedanceDqs_2_, // 333
	_TxImpedanceDqs_3_, // 334
	_TxImpedanceDqs_4_, // 335
	_TxImpedanceDqs_5_, // 336
	_TxImpedanceDqs_6_, // 337
	_TxImpedanceDqs_7_, // 338
	_TxImpedanceDqs_8_, // 339
	_TxImpedanceDqs_9_, // 340
	_TxImpedanceDqs_10_, // 341
	_TxImpedanceDqs_11_, // 342
	_TxImpedanceDqs_12_, // 343
	_TxImpedanceDqs_13_, // 344
	_TxImpedanceDqs_14_, // 345
	_DqsOscRunTimeSel_0_, // 346
	_DqsOscRunTimeSel_1_, // 347
	_DqsOscRunTimeSel_2_, // 348
	_DqsOscRunTimeSel_3_, // 349
	_DqsOscRunTimeSel_4_, // 350
	_DqsOscRunTimeSel_5_, // 351
	_DqsOscRunTimeSel_6_, // 352
	_DqsOscRunTimeSel_7_, // 353
	_DqsOscRunTimeSel_8_, // 354
	_DqsOscRunTimeSel_9_, // 355
	_DqsOscRunTimeSel_10_, // 356
	_DqsOscRunTimeSel_11_, // 357
	_DqsOscRunTimeSel_12_, // 358
	_DqsOscRunTimeSel_13_, // 359
	_DqsOscRunTimeSel_14_, // 360
	_RxClkTrackEn_0_, // 361
	_RxClkTrackEn_1_, // 362
	_RxClkTrackEn_2_, // 363
	_RxClkTrackEn_3_, // 364
	_RxClkTrackEn_4_, // 365
	_RxClkTrackEn_5_, // 366
	_RxClkTrackEn_6_, // 367
	_RxClkTrackEn_7_, // 368
	_RxClkTrackEn_8_, // 369
	_RxClkTrackEn_9_, // 370
	_RxClkTrackEn_10_, // 371
	_RxClkTrackEn_11_, // 372
	_RxClkTrackEn_12_, // 373
	_RxClkTrackEn_13_, // 374
	_RxClkTrackEn_14_, // 375
	_DisablePhyUpdate_, // 376
	_TxSlewRiseDqs_0_, // 377
	_TxSlewRiseDqs_1_, // 378
	_TxSlewRiseDqs_2_, // 379
	_TxSlewRiseDqs_3_, // 380
	_TxSlewRiseDqs_4_, // 381
	_TxSlewRiseDqs_5_, // 382
	_TxSlewRiseDqs_6_, // 383
	_TxSlewRiseDqs_7_, // 384
	_TxSlewRiseDqs_8_, // 385
	_TxSlewRiseDqs_9_, // 386
	_TxSlewRiseDqs_10_, // 387
	_TxSlewRiseDqs_11_, // 388
	_TxSlewRiseDqs_12_, // 389
	_TxSlewRiseDqs_13_, // 390
	_TxSlewRiseDqs_14_, // 391
	_DisableFspOp_, // 392
	_ExtCalResVal_, // 393
	_TxImpedanceCKE_0_, // 394
	_TxImpedanceCKE_1_, // 395
	_TxImpedanceCKE_2_, // 396
	_TxImpedanceCKE_3_, // 397
	_TxImpedanceCKE_4_, // 398
	_TxImpedanceCKE_5_, // 399
	_TxImpedanceCKE_6_, // 400
	_TxImpedanceCKE_7_, // 401
	_TxImpedanceCKE_8_, // 402
	_TxImpedanceCKE_9_, // 403
	_TxImpedanceCKE_10_, // 404
	_TxImpedanceCKE_11_, // 405
	_TxImpedanceCKE_12_, // 406
	_TxImpedanceCKE_13_, // 407
	_TxImpedanceCKE_14_, // 408
	_TxSlewFallDqs_0_, // 409
	_TxSlewFallDqs_1_, // 410
	_TxSlewFallDqs_2_, // 411
	_TxSlewFallDqs_3_, // 412
	_TxSlewFallDqs_4_, // 413
	_TxSlewFallDqs_5_, // 414
	_TxSlewFallDqs_6_, // 415
	_TxSlewFallDqs_7_, // 416
	_TxSlewFallDqs_8_, // 417
	_TxSlewFallDqs_9_, // 418
	_TxSlewFallDqs_10_, // 419
	_TxSlewFallDqs_11_, // 420
	_TxSlewFallDqs_12_, // 421
	_TxSlewFallDqs_13_, // 422
	_TxSlewFallDqs_14_, // 423
	_TxSlewFallCK_0_, // 424
	_TxSlewFallCK_1_, // 425
	_TxSlewFallCK_2_, // 426
	_TxSlewFallCK_3_, // 427
	_TxSlewFallCK_4_, // 428
	_TxSlewFallCK_5_, // 429
	_TxSlewFallCK_6_, // 430
	_TxSlewFallCK_7_, // 431
	_TxSlewFallCK_8_, // 432
	_TxSlewFallCK_9_, // 433
	_TxSlewFallCK_10_, // 434
	_TxSlewFallCK_11_, // 435
	_TxSlewFallCK_12_, // 436
	_TxSlewFallCK_13_, // 437
	_TxSlewFallCK_14_, // 438
	_RxBiasCurrentControlDqs_0_, // 439
	_RxBiasCurrentControlDqs_1_, // 440
	_RxBiasCurrentControlDqs_2_, // 441
	_RxBiasCurrentControlDqs_3_, // 442
	_RxBiasCurrentControlDqs_4_, // 443
	_RxBiasCurrentControlDqs_5_, // 444
	_RxBiasCurrentControlDqs_6_, // 445
	_RxBiasCurrentControlDqs_7_, // 446
	_RxBiasCurrentControlDqs_8_, // 447
	_RxBiasCurrentControlDqs_9_, // 448
	_RxBiasCurrentControlDqs_10_, // 449
	_RxBiasCurrentControlDqs_11_, // 450
	_RxBiasCurrentControlDqs_12_, // 451
	_RxBiasCurrentControlDqs_13_, // 452
	_RxBiasCurrentControlDqs_14_, // 453
	_RxClkTrackWaitUI_, // 454
	_CalImpedanceCurrentAdjustment_, // 455
	_WDQSExt_, // 456
	_RxVrefKickbackNoiseCancellation_0_, // 457
	_RxVrefKickbackNoiseCancellation_1_, // 458
	_RxVrefKickbackNoiseCancellation_2_, // 459
	_RxVrefKickbackNoiseCancellation_3_, // 460
	_RxVrefKickbackNoiseCancellation_4_, // 461
	_RxVrefKickbackNoiseCancellation_5_, // 462
	_RxVrefKickbackNoiseCancellation_6_, // 463
	_RxVrefKickbackNoiseCancellation_7_, // 464
	_RxVrefKickbackNoiseCancellation_8_, // 465
	_RxVrefKickbackNoiseCancellation_9_, // 466
	_RxVrefKickbackNoiseCancellation_10_, // 467
	_RxVrefKickbackNoiseCancellation_11_, // 468
	_RxVrefKickbackNoiseCancellation_12_, // 469
	_RxVrefKickbackNoiseCancellation_13_, // 470
	_RxVrefKickbackNoiseCancellation_14_, // 471
	_EnRxDqsTracking_0_, // 472
	_EnRxDqsTracking_1_, // 473
	_EnRxDqsTracking_2_, // 474
	_EnRxDqsTracking_3_, // 475
	_EnRxDqsTracking_4_, // 476
	_EnRxDqsTracking_5_, // 477
	_EnRxDqsTracking_6_, // 478
	_EnRxDqsTracking_7_, // 479
	_EnRxDqsTracking_8_, // 480
	_EnRxDqsTracking_9_, // 481
	_EnRxDqsTracking_10_, // 482
	_EnRxDqsTracking_11_, // 483
	_EnRxDqsTracking_12_, // 484
	_EnRxDqsTracking_13_, // 485
	_EnRxDqsTracking_14_, // 486
	_TxImpedanceAc_0_, // 487
	_TxImpedanceAc_1_, // 488
	_TxImpedanceAc_2_, // 489
	_TxImpedanceAc_3_, // 490
	_TxImpedanceAc_4_, // 491
	_TxImpedanceAc_5_, // 492
	_TxImpedanceAc_6_, // 493
	_TxImpedanceAc_7_, // 494
	_TxImpedanceAc_8_, // 495
	_TxImpedanceAc_9_, // 496
	_TxImpedanceAc_10_, // 497
	_TxImpedanceAc_11_, // 498
	_TxImpedanceAc_12_, // 499
	_TxImpedanceAc_13_, // 500
	_TxImpedanceAc_14_, // 501
	_SkipRetrainEnhancement_, // 502
	_DisableRetraining_, // 503
	_TxImpedanceCk_0_, // 504
	_TxImpedanceCk_1_, // 505
	_TxImpedanceCk_2_, // 506
	_TxImpedanceCk_3_, // 507
	_TxImpedanceCk_4_, // 508
	_TxImpedanceCk_5_, // 509
	_TxImpedanceCk_6_, // 510
	_TxImpedanceCk_7_, // 511
	_TxImpedanceCk_8_, // 512
	_TxImpedanceCk_9_, // 513
	_TxImpedanceCk_10_, // 514
	_TxImpedanceCk_11_, // 515
	_TxImpedanceCk_12_, // 516
	_TxImpedanceCk_13_, // 517
	_TxImpedanceCk_14_, // 518
	_DisableTDRAccess_, // 519
	_OdtImpedanceDq_0_, // 520
	_OdtImpedanceDq_1_, // 521
	_OdtImpedanceDq_2_, // 522
	_OdtImpedanceDq_3_, // 523
	_OdtImpedanceDq_4_, // 524
	_OdtImpedanceDq_5_, // 525
	_OdtImpedanceDq_6_, // 526
	_OdtImpedanceDq_7_, // 527
	_OdtImpedanceDq_8_, // 528
	_OdtImpedanceDq_9_, // 529
	_OdtImpedanceDq_10_, // 530
	_OdtImpedanceDq_11_, // 531
	_OdtImpedanceDq_12_, // 532
	_OdtImpedanceDq_13_, // 533
	_OdtImpedanceDq_14_, // 534
	_RxDqsTrackingThreshold_0_, // 535
	_RxDqsTrackingThreshold_1_, // 536
	_RxDqsTrackingThreshold_2_, // 537
	_RxDqsTrackingThreshold_3_, // 538
	_RxDqsTrackingThreshold_4_, // 539
	_RxDqsTrackingThreshold_5_, // 540
	_RxDqsTrackingThreshold_6_, // 541
	_RxDqsTrackingThreshold_7_, // 542
	_RxDqsTrackingThreshold_8_, // 543
	_RxDqsTrackingThreshold_9_, // 544
	_RxDqsTrackingThreshold_10_, // 545
	_RxDqsTrackingThreshold_11_, // 546
	_RxDqsTrackingThreshold_12_, // 547
	_RxDqsTrackingThreshold_13_, // 548
	_RxDqsTrackingThreshold_14_, // 549
	_CalOnce_, // 550
	_TxImpedanceDq_0_, // 551
	_TxImpedanceDq_1_, // 552
	_TxImpedanceDq_2_, // 553
	_TxImpedanceDq_3_, // 554
	_TxImpedanceDq_4_, // 555
	_TxImpedanceDq_5_, // 556
	_TxImpedanceDq_6_, // 557
	_TxImpedanceDq_7_, // 558
	_TxImpedanceDq_8_, // 559
	_TxImpedanceDq_9_, // 560
	_TxImpedanceDq_10_, // 561
	_TxImpedanceDq_11_, // 562
	_TxImpedanceDq_12_, // 563
	_TxImpedanceDq_13_, // 564
	_TxImpedanceDq_14_, // 565
	_RxVrefDACEnable_0_, // 566
	_RxVrefDACEnable_1_, // 567
	_RxVrefDACEnable_2_, // 568
	_RxVrefDACEnable_3_, // 569
	_RxVrefDACEnable_4_, // 570
	_RxVrefDACEnable_5_, // 571
	_RxVrefDACEnable_6_, // 572
	_RxVrefDACEnable_7_, // 573
	_RxVrefDACEnable_8_, // 574
	_RxVrefDACEnable_9_, // 575
	_RxVrefDACEnable_10_, // 576
	_RxVrefDACEnable_11_, // 577
	_RxVrefDACEnable_12_, // 578
	_RxVrefDACEnable_13_, // 579
	_RxVrefDACEnable_14_, // 580
	_PhyMstrMaxReqToAck_0_, // 581
	_PhyMstrMaxReqToAck_1_, // 582
	_PhyMstrMaxReqToAck_2_, // 583
	_PhyMstrMaxReqToAck_3_, // 584
	_PhyMstrMaxReqToAck_4_, // 585
	_PhyMstrMaxReqToAck_5_, // 586
	_PhyMstrMaxReqToAck_6_, // 587
	_PhyMstrMaxReqToAck_7_, // 588
	_PhyMstrMaxReqToAck_8_, // 589
	_PhyMstrMaxReqToAck_9_, // 590
	_PhyMstrMaxReqToAck_10_, // 591
	_PhyMstrMaxReqToAck_11_, // 592
	_PhyMstrMaxReqToAck_12_, // 593
	_PhyMstrMaxReqToAck_13_, // 594
	_PhyMstrMaxReqToAck_14_, // 595
	_PsDmaRamSize_, // 596
	_DisablePmuEcc_, // 597
	_CalInterval_, // 598
	_DisableUnusedAddrLns_, // 599
	_OdtImpedanceCk_0_, // 600
	_OdtImpedanceCk_1_, // 601
	_OdtImpedanceCk_2_, // 602
	_OdtImpedanceCk_3_, // 603
	_OdtImpedanceCk_4_, // 604
	_OdtImpedanceCk_5_, // 605
	_OdtImpedanceCk_6_, // 606
	_OdtImpedanceCk_7_, // 607
	_OdtImpedanceCk_8_, // 608
	_OdtImpedanceCk_9_, // 609
	_OdtImpedanceCk_10_, // 610
	_OdtImpedanceCk_11_, // 611
	_OdtImpedanceCk_12_, // 612
	_OdtImpedanceCk_13_, // 613
	_OdtImpedanceCk_14_, // 614
	_RelockOnlyCntrl_, // 615
	_RxBiasCurrentControlCk_0_, // 616
	_RxBiasCurrentControlCk_1_, // 617
	_RxBiasCurrentControlCk_2_, // 618
	_RxBiasCurrentControlCk_3_, // 619
	_RxBiasCurrentControlCk_4_, // 620
	_RxBiasCurrentControlCk_5_, // 621
	_RxBiasCurrentControlCk_6_, // 622
	_RxBiasCurrentControlCk_7_, // 623
	_RxBiasCurrentControlCk_8_, // 624
	_RxBiasCurrentControlCk_9_, // 625
	_RxBiasCurrentControlCk_10_, // 626
	_RxBiasCurrentControlCk_11_, // 627
	_RxBiasCurrentControlCk_12_, // 628
	_RxBiasCurrentControlCk_13_, // 629
	_RxBiasCurrentControlCk_14_, // 630
	// pUserInputBasic Fields:
	_CfgPStates_, // 631
	_NumRank_dfi0_, // 632
	_Lp4xMode_, // 633
	_NumCh_, // 634
	_DimmType_, // 635
	_DramType_, // 636
	_HardMacroVer_, // 637
	_Frequency_0_, // 638
	_Frequency_1_, // 639
	_Frequency_2_, // 640
	_Frequency_3_, // 641
	_Frequency_4_, // 642
	_Frequency_5_, // 643
	_Frequency_6_, // 644
	_Frequency_7_, // 645
	_Frequency_8_, // 646
	_Frequency_9_, // 647
	_Frequency_10_, // 648
	_Frequency_11_, // 649
	_Frequency_12_, // 650
	_Frequency_13_, // 651
	_Frequency_14_, // 652
	_NumActiveDbyteDfi1_, // 653
	_NumRank_, // 654
	_DramDataWidth_, // 655
	_FirstPState_, // 656
	_PllBypass_0_, // 657
	_PllBypass_1_, // 658
	_PllBypass_2_, // 659
	_PllBypass_3_, // 660
	_PllBypass_4_, // 661
	_PllBypass_5_, // 662
	_PllBypass_6_, // 663
	_PllBypass_7_, // 664
	_PllBypass_8_, // 665
	_PllBypass_9_, // 666
	_PllBypass_10_, // 667
	_PllBypass_11_, // 668
	_PllBypass_12_, // 669
	_PllBypass_13_, // 670
	_PllBypass_14_, // 671
	_DfiFreqRatio_0_, // 672
	_DfiFreqRatio_1_, // 673
	_DfiFreqRatio_2_, // 674
	_DfiFreqRatio_3_, // 675
	_DfiFreqRatio_4_, // 676
	_DfiFreqRatio_5_, // 677
	_DfiFreqRatio_6_, // 678
	_DfiFreqRatio_7_, // 679
	_DfiFreqRatio_8_, // 680
	_DfiFreqRatio_9_, // 681
	_DfiFreqRatio_10_, // 682
	_DfiFreqRatio_11_, // 683
	_DfiFreqRatio_12_, // 684
	_DfiFreqRatio_13_, // 685
	_DfiFreqRatio_14_, // 686
	_NumRank_dfi1_, // 687
	_NumDbytesPerCh_, // 688
	_NumPStates_, // 689
	_NumActiveDbyteDfi0_, // 690
	// pUserInputSim Fields:
	_PHY_tDQS2DQ_, // 691
	_tDQSCK_, // 692
	_tDQS2DQ_, // 693
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
	PMU_SMB_LPDDR4X_1D_t mb_LPDDR4X_1D[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];
	/// Shadow of 1D message block. Used by PhyInit to track user changes to the data structure.
	PMU_SMB_LPDDR4X_1D_t shdw_LPDDR4X_1D[DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE];

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

