/** \file
 * PhyInit Register Interface
 * --------------------------
 *
 * This file provides a group of functions that are used to track PHY register
 * writes by intercepting io_write16 function calls.  Once the registers are
 * tracked, their value can be saved at a given time spot, and restored later
 * as required.  This implementation is useful to capture any PHY register
 * programing in any function during PHY initialization.
 *
 *  \addtogroup SrcFunc
 *  @{
 */

#include <stdint.h>
#include <dwc_ddrphy_phyinit.h>

int NumRegSaved; ///< Current Number of registers saved.
int TrackEn = 1; ///< Enabled tracking of registers
uint8_t regGrp; ///< Register Group Assignment.
uint8_t psLoop; ///< 0: output Pstate Loop 1: inside Pstate Loop
phyinit_config_t *phyctx; ///< pointer to PhyConfig structure
int ramSize;

/// data structure to store register address, value pairs
typedef struct Reg_Addr_Val {
	uint32_t Address;			///< register address
	uint16_t Value;				///< register value
} Reg_Addr_Val_t;

/**  Array of Address/value pairs used to store register values for the purpose
 * of retention restore.
 */
static Reg_Addr_Val_t RetRegList[MAX_NUM_RET_REGS];

#define DWC_DDRPHY_MAX_DMA_SIZE 2048
uint32_t dmaCsrMapAdr[DWC_DDRPHY_MAX_DMA_SIZE] = { 0 }; /// committed dma to csr address mapping
uint16_t dmaCsrMapDat[DWC_DDRPHY_MAX_DMA_SIZE] = { 0 }; /// place holder for even data
uint8_t dmaCsrMapOE[DWC_DDRPHY_MAX_DMA_SIZE] = { 0 }; /// keep track of eve/odd-ness of array data

/** defining fixed PS SRAM group bounds */
#define DWC_DDRPHY_DMA_IDX_G0		0
#define DWC_DDRPHY_DMA_IDX_G1_LPDDR4	((DWC_DDRPHY_DMA_IDX_G0) + (6 + 2 * (DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP4+2*DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP4)))
#define DWC_DDRPHY_DMA_IDX_G2_LPDDR4	((DWC_DDRPHY_DMA_IDX_G1_LPDDR4) + 10)
#define DWC_DDRPHY_DMA_IDX_G1_LPDDR5	((DWC_DDRPHY_DMA_IDX_G0) + (6 + 2 * (DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_COMMON_LP5+2*DWC_DDRPHY_PHYINIT_NUM_PSTATE_MRS_ROWS_TRAINED_LP5)))
#define DWC_DDRPHY_DMA_IDX_G2_LPDDR5	((DWC_DDRPHY_DMA_IDX_G1_LPDDR5) + 10)

uint16_t dmaIdxStrt[4] = { 0, 0, 0, 0 }; ///< DMA start row pointer for each register group.
uint16_t dmaIdxGrp[4] = { 0, 0, 0, 0 }; ///< Pointers to last used DMA row for each DMA register Group
uint16_t dmaIdxMax[4] = { 0, 0, 0, 0 }; ///< Max DMA row index for each register group
uint16_t dmaWords[4] = { 0 }; ///< structure to hold the 4 words of the DMA Row.

/** \brief helper function to get the base index of a pstate given CfgPState.
 *
 * \returns int representing the base offset for PS RAM for given PState based on CfgPState configuration.
 */
uint16_t dwc_ddrphy_phyinit_getPsBase(uint16_t pstate)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	uint16_t accum = 0;

	for (int i = 0; i < 15; i++) {
		if ((pUserInputBasic->CfgPStates & (1 << i)) != 0) {
			accum += 1;
			if (pstate == i) {
				return accum - 1;
			}
		}
	}

	dwc_ddrphy_phyinit_assert(0, " [dwc_ddrphy_phyinit_regInterface:%s] CfgPState or NumPState miss configuration. pstate=%d CfgPStates=%d\n", __func__, pstate, pUserInputBasic->CfgPStates);
	return -1;
}

/** \brief function to implement a register write to the PHY
 *
 * PhyInit io write function in turn calls the customers implemnation of APB write. In addition it
 * called the setReg function that saves the data to the PState RAM enabled during sequence.
 *
 * \param adr 32-bit integer indicating address of CSR to be written
 * \param dat 16-bit integer for the value to be written to the CSR
 * \returns \c void
 */
void dwc_ddrphy_phyinit_io_write16(uint32_t adr, uint16_t dat)
{
	dwc_ddrphy_phyinit_userCustom_io_write16(adr, dat);
	dwc_ddrphy_phyinit_cmnt("phyinit_io_write: 0x%x, 0x%x\n", adr, dat);
	// if address is not in DMA range.
	// trak register write in PhyInit
	if ((adr & tDMA) != tDMA) {
		dwc_ddrphy_phyinit_setReg(adr, dat);
	}
}

/** \brief function to implement a MicroContMuxSel register write, preceding by 40 dficlk delay if the write data is 0
 *
 * PhyInit io write wrapper function for csr MicroContMuxSel  
 * if the write data is 0, the wrapper function first calls the customer's implemnation of Wait function that waits 40 dficlk, then calls the the customers implemnation of APB write.
 * if the write data is not 0, the wrapper function calls the customer's implemnation of APB write without any delay.
 *
 * \param dat 16-bit integer for the value to be written to the MicroContMuxSel CSR
 * \returns \c void
 */
void dwc_ddrphy_phyinit_MicroContMuxSel_write16(uint16_t dat)
{
	if (dat == 0) {
		uint32_t nDfiClks = 40;
		dwc_ddrphy_phyinit_cmnt("Wait %d nDfiClks before clearing csrMicroContMuxSel;\n", nDfiClks);
		dwc_ddrphy_phyinit_userCustom_wait(nDfiClks);
	}
	dwc_ddrphy_phyinit_userCustom_io_write16((tAPBONLY | csr_MicroContMuxSel_ADDR), dat);
	dwc_ddrphy_phyinit_cmnt("phyinit_io_write to csr MicroContMuxSel: 0x%x, 0x%x\n", (tAPBONLY | csr_MicroContMuxSel_ADDR), dat);
}

/** \brief Tags a register if tracking is enabled in the register
 * interface
 *
 * during PhyInit registers writes, keeps track of address
 * for the purpose of restoring the PHY register state during PHY
 * retention exit process.  Tracking can be turned on/off via the
 * dwc_ddrphy_phyinit_regInterface startTrack, stopTrack instructions. By
 * default tracking is always turned on.
 *
 * a register's group assignment is determined on the first time the register is written in the
 * event it's over-writen a second time in the sequence.
 *
 * \return 0: not tracked 1: tracked
 */

int dwc_ddrphy_phyinit_trackReg(uint32_t adr)
{
	//if (!TrackEn) dwc_ddrphy_phyinit_cmnt("called trackReg: 0%x, but skipped\n", adr);
	//else dwc_ddrphy_phyinit_cmnt("called trackReg: 0%x\n", adr);

	// return if tracking is disabled
	if (!TrackEn) {
		return 0;
	}

	// search register array the address,
	int regIndx = 0;

	for (regIndx = 0; regIndx < NumRegSaved; regIndx++) {
		if (RetRegList[regIndx].Address == adr) {
			return 1;
		}
	}

	//dwc_ddrphy_phyinit_cmnt("called trackReg: 1\n");
	if (TrackEn) {	// register not found, so add it.
		//printf("not found so add regIndx:%d\n", regIndx);
		if (NumRegSaved == MAX_NUM_RET_REGS) {
			dwc_ddrphy_phyinit_assert(0, " [dwc_ddrphy_phyinit_regInterface:%s]  Max Number of Restore Registers reached: %d. Please recompile PhyInit with MAX_NUM_RET_REG set to larger value.\n", __func__, NumRegSaved);
			return 0;
		}
		RetRegList[regIndx].Address = adr;
		NumRegSaved++;
		//dwc_ddrphy_phyinit_cmnt("called trackReg: 2\n");
		return 1;
	}
	// should never get here.
	return 0;
}

/** \brief Configures the register interface tracking API.
 *
 * ### Usage
 * Example for retention restore
 * Register tracking is enabled by calling:
 *
 *  \code
 *  dwc_ddrphy_phyinit_regInterface(startTrack,0,0);
 *  \endcode
 *
 * from this point on any call to dwc_ddrphy_phyinit_usercustom_io_write16() in
 * return will be capture by the register interface via a call to
 * dwc_ddrphy_phyinit_trackReg(). Tracking is disabled by calling:
 *
 *  \code
 *  dwc_ddrphy_phyinit_regInterface(stopTrack,0,0);
 *  \endcode
 *
 * On calling this function, register write via
 * dwc_ddrphy_phyinit_usercustom_io_write16 are no longer tracked until a
 * stratTrack call is made.  Once all the register write are complete, saveRegs
 * command can be issue to save register values into the internal data array of
 * the register interface.  Upon retention exit restoreRegs are command can be
 * used to issue register write commands to the PHY based on values stored in
 * the array.
 *  \code
 *   dwc_ddrphy_phyinit_regInterface(saveRegs,0,0);
 *   dwc_ddrphy_phyinit_regInterface(restoreRegs,0,0);
 *  \endcode
 *
 * \return 1 on success.
 *
 * @param [in ] adr : addresss
 * @param [in ] dat : data
 * @param [in ] myRegInstr : instruction. Following are valid instructions and their usage:
 *
 *
 */
int dwc_ddrphy_phyinit_regInterface(regInstr myRegInstr, uint32_t adr, uint16_t dat)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;

	if (myRegInstr == saveRegs) {
		/**
		 *  - saveRegs:
		 *    go through all the tracked registers, issue a register read and place
		 *    the result in the data structure for future recovery.
		 */
		int regIndx = 0;
		uint16_t data;

		for (regIndx = 0; regIndx < NumRegSaved; regIndx++) {
			data = dwc_ddrphy_phyinit_userCustom_io_read16(RetRegList[regIndx].Address);
			dwc_ddrphy_phyinit_cmnt(" [%s] adr: 0x%x dat: 0x%x\n", __func__, RetRegList[regIndx].Address, data);
			RetRegList[regIndx].Value = data;
		}

		return 1;
	} else if (myRegInstr == restoreRegs) {
		/**
		 *  - restoreRegs:
		 *    write PHY registers based on Address, Data value pairs stores in
		 *    RetRegList
		 */
		int regIndx = 0;

		for (regIndx = 0; regIndx < NumRegSaved; regIndx++) {
		    dwc_ddrphy_phyinit_userCustom_io_write16(RetRegList[regIndx].Address, RetRegList[regIndx].Value);
		}
		return 1;
	} else if (myRegInstr == startTrack) { //Enable tracking
		/**
		 *  - startTrack:
		 *    Enable Tracking for subsequent register writes.
		 */
		TrackEn = 1;
		return 1;
	} else if (myRegInstr == stopTrack)	{ // Disable tracking
		/**
		 *  - stopTrack:
		 *    Disable Tracking for subsequent register writes.
		 */
		TrackEn = 0;
		return 1;
	} else if (myRegInstr == dumpRegs) { // Dump restore state to file.
		// TBD
		return 1;
	} else if (myRegInstr == importRegs) { // import register state from file.
		// TBD
		return 1;
	} else if (myRegInstr == setGroup) { // set the DMA Group
		/**
		 *  - setGroup:
		 *    set the DMA group of to dat for subsequent register writes.
		 */
		dwc_ddrphy_phyinit_cmnt(" [%s] DMA setGroup called\n", __func__);
		dwc_ddrphy_phyinit_writeDmaRow();	// write any pending registers.
		dwc_ddrphy_phyinit_cmnt(" [%s] set DMA group to %d\n", __func__, dat);
		regGrp = dat;
		return 1;
	} else if (myRegInstr == startPsLoop) { // set the DMA Group
		/**
		 *  - startPsLoop:
		 *    indicates the start of PS loop to the API.  this call resets internal pointers and counters
		 *    necessary for the API to function correctly.
		 */
		dwc_ddrphy_phyinit_cmnt(" [%s] DMA startPsLoop called\n", __func__);

		if (pUserInputBasic->NumPStates < 3) {
			TrackEn = 1;
			return 1;
		}

		dmaIdxGrp[0] = dmaIdxStrt[0];
		dmaIdxGrp[1] = dmaIdxStrt[1];
		dmaIdxGrp[2] = dmaIdxStrt[2];
		dmaIdxGrp[3] = dmaIdxStrt[3];
		for (int i = 0; i < DWC_DDRPHY_MAX_DMA_SIZE; i++) {
			dmaCsrMapAdr[i] = 0;
			dmaCsrMapDat[i] = 0;
			dmaCsrMapOE[i] = 0;
		}
		dmaWords[0] = 0;
		dmaWords[1] = 0;
		dmaWords[2] = 0;
		dmaWords[3] = 0;
		psLoop = 1;
		return 1;
	} else if (myRegInstr == resumePsLoop) { // resume tracking writes to DMA
		/**
		 *  - resumePsLoop:
		 *    during PS state loop, pause register tracking while in the middle of Ps Loop for subsequent
		 *    APB writes. Tracking may be resumed later.  Example use case : read state of training
		 *    firmware.
		 */
		if (pUserInputBasic->NumPStates > 2) {
			dwc_ddrphy_phyinit_writeDmaRow(); // one last time.
		}

		psLoop = 1;
		return 1;
	} else if (myRegInstr == stopPsLoop) { // stop tracking writes to DMA
		/**
		 *  - stopPsLoop:
		 *    indicated to API that sequence is outside the PS loop. Can also be used in conjuction with
		 *    resumePsLoop to stop register tracking while in PS loop.
		 */
		if (pUserInputBasic->NumPStates > 2) {
			dwc_ddrphy_phyinit_writeDmaRow(); // one last time.
		}

		psLoop = 0;
		return 1;
	} else if (myRegInstr == endPsLoop)	{ // write the length and start registers for DMA
		/**
		 *  - endPsLoop:
		 *    Indicates the end of PS loop to the API. The API populated certain registers at this stage
		 *    and performs checks to ensure PS SRAM is populated correctly.
		 */

		if (pUserInputBasic->NumPStates < 3) {
			return 1;
		}

		dwc_ddrphy_phyinit_cmnt(" [%s]commit last pending outstanding DMA memory writes.\n", __func__);
		dwc_ddrphy_phyinit_writeDmaRow(); // one last time.

		psLoop = 0;
		dwc_ddrphy_phyinit_cmnt(" [%s] write DMA Base, Len, Offset registers\n", __func__);
		runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;

		uint8_t prog_csr = (pRuntimeConfig->initCtrl & 0x1) >> 0;
		uint16_t skipGrp3 = (prog_csr == 0) ? 1: 0;

		uint16_t pstate = (pRuntimeConfig->curPState);
		uint16_t base = dwc_ddrphy_phyinit_getPsBase(pstate);

		int extra = pstate > 6 ? 1 : 0;

		dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | (csr_PsDmaXlatBase0_ADDR + pstate + extra)), base);

		// this should really be the same across PStates.
		// FIXME: add check to set to Max from all PStates.
		int nRow[4];

		for (int grp = 0; grp < 4; grp++) {
			if (grp == 1) {
				// add length of group2 here.
				uint32_t addr = (tDRTUB | csr_PsDmaXlatLen2_ADDR);
				uint32_t faddr = (addr & (~p1)) >> 1; // drop the PState portion of address.
				uint16_t oddeven = (addr & 0x1) + 0x1; // 2: odd, 1: even
				uint16_t gdat = dmaIdxGrp[2] - dmaIdxStrt[2];

				dmaWords[0] = gdat;
				dmaWords[1] = gdat;
				dmaWords[2] = faddr;
				dmaWords[3] = (faddr >> 16) | oddeven << 3;

				regGrp = grp;

				// write struct row;
				dwc_ddrphy_phyinit_writeDmaRow();

				dwc_ddrphy_phyinit_cmnt(" [%s] writing PsDmaXlatLen2 to %d - grp1 idx=%d\n", __func__, gdat, dmaIdxGrp[grp]);
			}
			nRow[grp] = dmaIdxGrp[grp] - dmaIdxStrt[grp];
			uint16_t len = dmaIdxGrp[grp] - dmaIdxStrt[grp];

			if (len == 2048) {
				len = 0; // 0 means 2048.
			}

			dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | (csr_PsDmaXlatOffset0_ADDR + grp)), dmaIdxStrt[grp]);

			if (grp == 3 && skipGrp3 == 1) {
				dwc_ddrphy_phyinit_cmnt(" [%s] DMA pstate=%d group 3 length is managed by Firmware\n", __func__, pstate);
			} else {
				dwc_ddrphy_phyinit_userCustom_io_write16((tDRTUB | (csr_PsDmaXlatLen0_ADDR + grp)), len);
				dwc_ddrphy_phyinit_cmnt(" [%s] DMA pstate=%d delta%d = %d-%d=%d\n", __func__, pstate, grp, dmaIdxGrp[grp], dmaIdxStrt[grp], dmaIdxGrp[grp] - dmaIdxStrt[grp]);
			}
		}
		dwc_ddrphy_phyinit_cmnt(" [%s] DMA pstate=%d nRowG0=%d nRowG1=%d nRowG2=%d nRowG3=%d\n", __func__, pstate, nRow[0], nRow[1], nRow[2], nRow[3]);
		return 1;
	} else if (myRegInstr == reserveRegs) { // reserve space for registers in the current DMA group
		/**
		 *  - reserveRegs:
		 *    Used to skip over a section of the PS SRAM to reserve space for a number of registers, specified by dat.
		 *    This is used to leave some sections untouched for Firmware to populate.
		 *    When outside of the PState loop, this has no effect.
		 */
		if (pUserInputBasic->NumPStates < 3 || psLoop == 0) {
			return 1;
		}

		dwc_ddrphy_phyinit_writeDmaRow(); // purge remaining data, if any

		uint16_t rowsToSkip = (dat + 1) >> 1;
		uint16_t NxtRow = dmaIdxGrp[regGrp] + rowsToSkip;

		dwc_ddrphy_phyinit_cmnt(" [%s] Skipping %d rows to reserve space in DMA group %d: [%d to %d]\n", __func__, rowsToSkip, regGrp, dmaIdxGrp[regGrp], NxtRow-1);

		// don't exceed DMA size
		if (NxtRow >= dmaIdxMax[regGrp]) {
			dwc_ddrphy_phyinit_assert(0, "No space to reserve %d DMA registers: Reg Group= %d dma Row = %d Allowed max Row for Group = %d", dat, regGrp, dmaIdxGrp[regGrp], dmaIdxMax[regGrp]);
		}

		// increment the row index
		dmaIdxGrp[regGrp] += rowsToSkip;
		return 1;
	}
	// future instructions.
	return 0;
}

/** \brief writes the register address
 *
 * attempts to extract DMA writes on top of normal register write.
 *
 * @param[dat] reg data
 * @param[adr] register address.

 * \return 0 on success.
 */
int dwc_ddrphy_phyinit_setReg(uint32_t adr, uint16_t dat)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;
	// take care of <2 PState and when DMA is not involved
	if (pUserInputBasic->NumPStates < 3 || psLoop == 0) {
		dwc_ddrphy_phyinit_trackReg(adr);
		return 0;
	}

	uint32_t fadr = (adr & (~p1)) >> 1;	// drop the PState portion of address.
	// FIXME improve this search existing registers.
	uint16_t NxtRow = dmaIdxGrp[regGrp];

	dwc_ddrphy_phyinit_cmnt("setReg:%x Grp=%d PsLoop=%d NxtRow=%d\n", fadr, regGrp, (phyctx->runtimeConfig).curPState, NxtRow);

	// don't exceed DMA size
	if (NxtRow >= dmaIdxMax[regGrp]) {
		uint16_t pstate = phyctx->runtimeConfig.curPState;

		dwc_ddrphy_phyinit_cmnt(" [%s] DMA register group overflow, current PState = %d\n", __func__, pstate);
#ifdef DWC_DDRPHY_PHYINIT_PS_SRAM_CHKR
		dwc_ddrphy_phyinit_report_ps_sram(0x1 << pstate);
#endif
		// write out a summary of allocations
		for (int grp = 0; grp < 4; grp++) {
			dwc_ddrphy_phyinit_cmnt(" [%s] DMA group %d idx ranges from %d to %d\n", __func__, grp, dmaIdxStrt[grp], dmaIdxMax[grp]);
			dwc_ddrphy_phyinit_cmnt(" [%s] DMA delta%d = %d-%d=%d\n", __func__, grp, dmaIdxGrp[grp], dmaIdxStrt[grp], dmaIdxGrp[grp] - dmaIdxStrt[grp]);
			dwc_ddrphy_phyinit_cmnt(" [%s] DMA nRowG%d = %d / %d\n", __func__, grp, dmaIdxGrp[grp] - dmaIdxStrt[grp], dmaIdxMax[grp] - dmaIdxStrt[grp]);
		}
		dwc_ddrphy_phyinit_assert(0, "Num DMA registers exceeds supported bound: Reg Group= %d dma Row = %d Allowed max Row for Group = %d", regGrp, dmaIdxGrp[regGrp], dmaIdxMax[regGrp]);
	}
	/**
	 * Below implements a cheap man's optimization for DMA to CSR address. We compare address of
	 * current csr with the last (or still to be committed entry). If there is a match we utilize
	 * the odd data, if not we use a new row.
	 */

	//uint16_t dat0; //= dmaWords[0];
	//uint16_t dat1; //= dmaWords[1];
	//uint32_t addr; //= ((dmaWords[3]&0x07)<<15) | dmaWords[2];
	uint16_t oddeven; //= ((dmaWords[3]&0x31)>>3 );

	// detect a match in address to the exiting row
	uint8_t adrMtch = (dmaCsrMapAdr[NxtRow] == fadr) ? 1 : 0;
	//if (dmaCsrMapOE[NxtRow] != 0) printf("adrMtch:%d from %x : %x\n", adrMtch, dmaCsrMapAdr[NxtRow],(adr&~p1)>>1);

	//uint8_t adrMtch = (addr == (fadr) ? 1 : 0;
	//if (oddeven != 0) dwc_ddrphy_phyint_cmnt("adrMtch:%d from %x : %x\n", adrMtch, addr,fadr);

	// main if..
	if (dmaCsrMapOE[NxtRow] == 0) { // empty DMA row
		//dwc_ddrphy_phyinit_cmnt("empty dma row\n");
		// populate DMA word
		dmaCsrMapAdr[NxtRow] = fadr;
		dmaCsrMapDat[NxtRow] = dat;
		dmaCsrMapOE[NxtRow] = ((adr & 0x1) == 1) ? 2 /* odd */ : 1 /*even */;

		// pre-emptively populate in case there are no next setReg calls. example: group change.
		oddeven = dmaCsrMapOE[NxtRow];
		dmaWords[0] = ((adr & 0x1) == 0x0) ? dat : 0;
		dmaWords[1] = ((adr & 0x1) == 0x1) ? dat : 0;
		dmaWords[2] = fadr;
		dmaWords[3] = (fadr >> 16) | oddeven << 3;
	} else if (adrMtch && dmaCsrMapOE[NxtRow] == 1 && ((adr & 0x1) == 0x1))	{ // adr match, odd is free, adr is odd
		//dwc_ddrphy_phyinit_cmnt("address match odd %d\n", NxtRow);
		//populate dmaWord odd data.
		oddeven = 3;
		dmaWords[0] = dmaCsrMapDat[NxtRow];
		dmaWords[1] = dat;
		dmaWords[2] = dmaCsrMapAdr[NxtRow];
		dmaWords[3] = (dmaCsrMapAdr[NxtRow] >> 16) | oddeven << 3;

		// write dma row;
		dwc_ddrphy_phyinit_writeDmaRow();
	} else if (adrMtch && dmaCsrMapOE[NxtRow] == 2 && ((adr & 0x1) == 0x0))	{ // adr match, even is free, adr is even
		//dwc_ddrphy_phyinit_cmnt("address match even %d\n", NxtRow);
		//populate dmaWord odd data.
		oddeven = 3;
		dmaWords[0] = dat;
		dmaWords[1] = dmaCsrMapDat[NxtRow];
		dmaWords[2] = dmaCsrMapAdr[NxtRow];
		dmaWords[3] = (dmaCsrMapAdr[NxtRow] >> 16) | oddeven << 3;

		//dwc_ddrphy_phyinit_cmnt("before dma  %d\n", NxtRow);
		// write dma row;
		dwc_ddrphy_phyinit_writeDmaRow();
	} else if (!adrMtch) { // no match
		//dwc_ddrphy_phyinit_cmnt("no match\n");

		// write the current row
		dwc_ddrphy_phyinit_writeDmaRow();

		// Call the function again.
		dwc_ddrphy_phyinit_setReg(adr, dat);
	} else {
		//dwc_ddrphy_phyinit_assert(0, "should not get here. hmmm.\n");
	}
	//printf("here5\n");
	//fflush(stdout);
	return 0;
} // End of dwc_ddrphy_phyinit_setReg()

/** \brief write the DMA Registers based on internal data structure
 *
 * writes DMA CSR's at based on content of dmaWord[] array. Once written reset dmaWord to all zero
 * and increments the row index.
 *
 * \return 0
 */
void dwc_ddrphy_phyinit_writeDmaRow(void)
{
	// If there is nothing to write, return.
	if (dmaWords[0] == 0 && dmaWords[1] == 0 && dmaWords[2] == 0 && dmaWords[3] == 0) {
		return;
	}

	// write register to DMA
	uint16_t NxtRow = dmaIdxGrp[regGrp];
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	uint8_t pstate = pRuntimeConfig->curPState;
	uint16_t dmaPsOffset = ramSize * dwc_ddrphy_phyinit_getPsBase(pstate);
	uint16_t row = dmaPsOffset + NxtRow;
	uint32_t blkType = tDMA;

	// Upper range is mapped to a different CSR slave
	if (row >= 16384) {
		blkType = tDMA_UPPER;
	}

	//dwc_ddrphy_phyinit_cmnt(" PsOffset=%d NxtRow=%d\n",  dmaPsOffset, NxtRow );
	dwc_ddrphy_phyinit_cmnt("Writing DMA row %d: 0x%4x_%4x_%4x_%4x\n", row, dmaWords[3], dmaWords[2], dmaWords[1], dmaWords[0]);
	// write previous if no odd match
	dwc_ddrphy_phyinit_userCustom_io_write16(blkType | ((row & 0x3fff) << 2) | 0x0, dmaWords[0]);
	dwc_ddrphy_phyinit_userCustom_io_write16(blkType | ((row & 0x3fff) << 2) | 0x1, dmaWords[1]);
	dwc_ddrphy_phyinit_userCustom_io_write16(blkType | ((row & 0x3fff) << 2) | 0x2, dmaWords[2]);
	dwc_ddrphy_phyinit_userCustom_io_write16(blkType | ((row & 0x3fff) << 2) | 0x3, dmaWords[3]);

#ifdef DWC_DDRPHY_PHYINIT_PS_SRAM_CHKR
	dwc_ddrphy_phyinit_setRegChkr(dmaWords, row);
#endif
	// increment the row index
	dmaIdxGrp[regGrp]++;
	//printf("c1\n");

	// clear the current dmaWords & internal data.
	dmaWords[0] = 0;
	dmaWords[1] = 0;
	dmaWords[2] = 0;
	dmaWords[3] = 0;
	//printf("c2\n");
}

/** \brief initializes the register tracker.
 *
 * attempts to extract DMA writes on top of normal register write.
 *
 * @param[phyctx] pointer to PhyInit config structure.
 * \return 0 on success.
 */
void dwc_ddrphy_phyinit_initReg(phyinit_config_t *ptr)
{
	phyctx = ptr;

	user_input_advanced_t *pUserInputAdvanced = &phyctx->userInputAdvanced;

	ramSize = (pUserInputAdvanced->PsDmaRamSize == 0) ? 0 : (pUserInputAdvanced->PsDmaRamSize == 1) ? 512 : (pUserInputAdvanced->PsDmaRamSize == 2) ? 1024 : (pUserInputAdvanced->PsDmaRamSize == 3) ? 2048 : 0;
	if (ramSize == 0) {
		dwc_ddrphy_phyinit_assert(0, "invalid setting for PsDmaRamSize=%d\n.", pUserInputAdvanced->PsDmaRamSize);
	}

	uint16_t grp3 = ramSize;

	dmaIdxStrt[0] = DWC_DDRPHY_DMA_IDX_G0;
	dmaIdxGrp[0] = DWC_DDRPHY_DMA_IDX_G0;
	_IF_LPDDR4(
		dmaIdxStrt[1] = DWC_DDRPHY_DMA_IDX_G1_LPDDR4;
		dmaIdxStrt[2] = DWC_DDRPHY_DMA_IDX_G2_LPDDR4;
		dmaIdxGrp[1] = DWC_DDRPHY_DMA_IDX_G1_LPDDR4;
		dmaIdxGrp[2] = DWC_DDRPHY_DMA_IDX_G2_LPDDR4;
		dmaIdxMax[0] = DWC_DDRPHY_DMA_IDX_G1_LPDDR4;
		dmaIdxMax[1] = DWC_DDRPHY_DMA_IDX_G2_LPDDR4;
		grp3 -= DWC_DDRPHY_DMA_IDX_G2_LPDDR4;
	)
	_IF_LPDDR5(
		dmaIdxStrt[1] = DWC_DDRPHY_DMA_IDX_G1_LPDDR5;
		dmaIdxStrt[2] = DWC_DDRPHY_DMA_IDX_G2_LPDDR5;
		dmaIdxGrp[1] = DWC_DDRPHY_DMA_IDX_G1_LPDDR5;
		dmaIdxGrp[2] = DWC_DDRPHY_DMA_IDX_G2_LPDDR5;
		dmaIdxMax[0] = DWC_DDRPHY_DMA_IDX_G1_LPDDR5;
		dmaIdxMax[1] = DWC_DDRPHY_DMA_IDX_G2_LPDDR5;
		grp3 -= DWC_DDRPHY_DMA_IDX_G2_LPDDR5;
	)
	grp3 *= 0.52;

	_IF_LPDDR4(
		grp3 += DWC_DDRPHY_DMA_IDX_G2_LPDDR4;
	)
	_IF_LPDDR5(
		grp3 += DWC_DDRPHY_DMA_IDX_G2_LPDDR5;
	)

	dwc_ddrphy_phyinit_cmnt("%s:grp3 boundary = %d, ramSize=%d\n", __func__, grp3, ramSize);
	dmaIdxStrt[3] = grp3;
	dmaIdxGrp[3] = grp3;
	dmaIdxMax[2] = grp3;
	dmaIdxMax[3] = ramSize;

#ifdef DWC_DDRPHY_PHYINIT_PS_SRAM_CHKR
	user_input_basic_t *pUserInputBasic = &ptr->userInputBasic;

	if (pUserInputBasic->NumPStates > 2) {
		dwc_ddrphy_phyinit_ps_sram_init();
	}
#endif
} // End of dwc_ddrphy_phyinit_initReg()

#ifdef DWC_DDRPHY_PHYINIT_PS_SRAM_CHKR

#include  <stdlib.h>
#include  <stdio.h>
/** register checkers
 *
 * these structures and functions keep track of regsiter writes between PStates to make sure
 * if a register is written to the DMA for one PState, it is also written for all.  This
 * requirement ensure the content of PHY registers remains correct for each PState when values
 * are restored from the PS DMA SRAM.
 *
 * The PS SRAM checker can help user ensure all userCustom Register programming is consistent
 * across PSTATE. These set of functions and structures should only be used during simulations.
 */

typedef struct _PS_SRAM_ROW {
	uint32_t adr;
	uint16_t dat0, dat1;
	uint8_t evenodd;
} psrow;

psrow *psram;

/** @brief allocated memory representing PS SRAM */
void dwc_ddrphy_phyinit_ps_sram_init(void)
{
	setbuf(stdout, NULL);
	//user_input_basic_t* pUserInputBasic = &phyctx->userInputBasic;
	//dwc_ddrphy_phyinit_cmnt("ps_sram:sram init called\n");
	psram = (psrow *) calloc(ramSize * DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE, sizeof(psrow));

	if (psram == NULL) {
		dwc_ddrphy_phyinit_assert(0, "ps_sram: malloc failure!\n.");
	}

	//dwc_ddrphy_phyinit_cmnt("ps_sram:sram done init\n");
}

/** @brief free memory allocated for PS SRAM */
void dwc_ddrphy_phyinit_ps_sram_free(void)
{
	//dwc_ddrphy_phyinit_cmnt("ps_sram:sram free called\n");
	free(psram);
}

/** populates the PS SRAM checker with register data
 *
 *  This function is called everytime a register is written to populate the psram data structure.
 */
void dwc_ddrphy_phyinit_setRegChkr(uint16_t *dmaWords_local, uint16_t row)
{
	dwc_ddrphy_phyinit_cmnt("ps_sram:chk row %d: 0x%4x_%4x_%4x_%4x\n", row, dmaWords_local[3], dmaWords_local[2], dmaWords_local[1], dmaWords_local[0]);

	psrow *rptr = &psram[row];
	//dwc_ddrphy_phyinit_cmnt("ps_sram:rptr=%p &psram[row]=%p\n", rptr, &psram[row]);

	psram[row].dat0 = dmaWords_local[0];
	//dwc_ddrphy_phyinit_cmnt("ps_sram:test\n");
	rptr->dat1 = dmaWords_local[1];
	rptr->adr = ((uint32_t) dmaWords_local[2]) | (((uint32_t) (dmaWords_local[3] & 0x7)) << 16);
	rptr->evenodd = (dmaWords[3] >> 3) & 0x3;

	//dwc_ddrphy_phyinit_cmnt("ps_sram:rptr->adr=0x%x\n", rptr->adr);
}

/** Check the PS SRAM data to ensure it is populated correctly.*/
void dwc_ddrphy_phyinit_check_ps_sram(void)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;

	for (int row = 0; row < ramSize; row++) {

		if (!((dmaIdxStrt[0] <= row && row < dmaIdxGrp[0]) || // G0
			  (dmaIdxStrt[1] <= row && row < dmaIdxGrp[1]) || // G1
			  (dmaIdxStrt[2] <= row && row < dmaIdxGrp[2]) || // G2
			  (dmaIdxStrt[3] <= row && row < dmaIdxGrp[3]))	// G3
			)
		{ continue; }

		dwc_ddrphy_phyinit_cmnt("ps_sram: checking row%d\n", row);

		psrow *ref_rptr = NULL;
		int flag = 0;
		int ref_ps = 0;

		for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {
			if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) {
				continue;
			}

			uint16_t dmaPsOffset = ramSize * dwc_ddrphy_phyinit_getPsBase(pstate);

			if (flag == 0) {
				ref_ps = pstate;
				ref_rptr = &psram[dmaPsOffset + row];
				flag = 1;
				continue;
			}
			//dwc_ddrphy_phyinit_cmnt("ps_sram: checking ps%d\n",pstate);
			psrow *rptr = &psram[dmaPsOffset + row];

			if ((rptr->adr != ref_rptr->adr) || (rptr->evenodd != ref_rptr->evenodd)) {
				dwc_ddrphy_phyinit_assert(0, " [dwc_ddrphy_phyinit_check_ps_sram: Check Failed. Register address values do not match across PState.\n \
				(PState %d, Row %d).adr     = 0x%x while (PState %d, Row %d).adr     = 0x%x.\n\
				(PState %d, Row %d).evenodd = 0x%x while (PState %d, Row %d).evenodd = 0x%x.\n", ref_ps, row, ref_rptr->adr, pstate, dmaPsOffset + row, rptr->adr, ref_ps, row, ref_rptr->evenodd, pstate, dmaPsOffset + row, rptr->evenodd);
			}
		}
	}
}

/** Report the PS SRAM data to help understanding how it is packed.
 *
 *  @param[in] pstate_mask   The PState bitmask to dump. Use 0xf to dump all.
 *
 */
void dwc_ddrphy_phyinit_report_ps_sram(int pstate_mask)
{
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;

	dwc_ddrphy_phyinit_cmnt("%s() Dumping PState SRAM start...\n", __func__);
	dwc_ddrphy_phyinit_cmnt("ps_sram_report: PState,Group,Row,Even,EvenAddr,Odd,OddrAddr,Both\n");

	for (int pstate = 0; pstate < DWC_DDRPHY_PHYINIT_MAX_NUM_PSTATE; pstate++) {

		if ((pUserInputBasic->CfgPStates & (0x1 << pstate)) == 0) {
			continue;
		}

		if ((pstate_mask & (0x1 << pstate)) == 0) {
			continue;
		}

		uint16_t dmaPsOffset = ramSize * dwc_ddrphy_phyinit_getPsBase(pstate);
		uint16_t nbRows[4] = { 0, 0, 0, 0 };
		uint16_t nbEvenCsrs[4] = { 0, 0, 0, 0 };
		uint16_t nbOddCsrs[4] = { 0, 0, 0, 0 };
		uint16_t nbBothCsrs[4] = { 0, 0, 0, 0 };

		for (int g = 0; g < 4; g++) {
			nbRows[g] = 0;
			nbEvenCsrs[g] = 0;
			nbOddCsrs[g] = 0;
			nbBothCsrs[g] = 0;
		}

		for (int row = 0; row < ramSize; row++) {

			psrow *rptr = &psram[dmaPsOffset + row];
			uint8_t even = (rptr->evenodd & 0x1) ? 1 : 0;
			uint8_t odd = (rptr->evenodd & 0x2) ? 1 : 0;
			uint8_t both = (even && odd) ? 1 : 0;
			uint32_t eaddr = rptr->adr << 1;
			uint32_t oaddr = eaddr | 0x1;
			uint8_t group;

			if (dmaIdxStrt[0] <= row && row < dmaIdxGrp[0]) {
				group = 0;
			} else if (dmaIdxStrt[1] <= row && row < dmaIdxGrp[1]) {
				group = 1;
			} else if (dmaIdxStrt[2] <= row && row < dmaIdxGrp[2]) {
				group = 2;
			} else if (dmaIdxStrt[3] <= row && row < dmaIdxGrp[3]) {
				group = 3;
			} else {
				continue;
			}

			dwc_ddrphy_phyinit_cmnt("ps_sram_report: %d,%d,%d,%d,0x%08x,%d,0x%08x,%d\n", pstate, group, row, even, eaddr, odd, oaddr, both);

			nbRows[group]++;
			if (even) {
				nbEvenCsrs[group]++;
			}
			if (odd) {
				nbOddCsrs[group]++;
			}
			if (both) {
				nbBothCsrs[group]++;
			}
		}

		dwc_ddrphy_phyinit_cmnt("ps_sram_stats: SRAM usage for PState %d\n", pstate);

		for (int g = 0; g < 4; g++) {
			uint16_t groupSize = dmaIdxMax[g] - dmaIdxStrt[g];
			uint16_t nbCsrsAvail = groupSize * 2;
			uint16_t nbCsrsUsed = nbEvenCsrs[g] + nbOddCsrs[g];

			dwc_ddrphy_phyinit_cmnt("ps_sram_stats: - group %d %s\n", g, groupSize - nbRows[g] ? nbRows[g] ? "" : "empty" : "FULL");
			dwc_ddrphy_phyinit_cmnt("ps_sram_stats:   - size = %d rows, used = %d rows (%d/%d  %.1f%%)\n", groupSize, nbRows[g], nbRows[g], groupSize, groupSize ? 100.0f * nbRows[g] / groupSize : 0.0);
			dwc_ddrphy_phyinit_cmnt("ps_sram_stats:   - size = %d CSRs, used = %d CSRs (%d/%d  %.1f%%)\n", nbCsrsAvail, nbCsrsUsed, nbCsrsUsed, nbCsrsAvail, nbCsrsAvail ? 100.0f * nbCsrsUsed / nbCsrsAvail : 0.0);
			dwc_ddrphy_phyinit_cmnt("ps_sram_stats:   - entries: even = %d, odd = %d, both = %d (%d/%d  %.1f%%)\n", nbEvenCsrs[g], nbOddCsrs[g], nbBothCsrs[g], nbBothCsrs[g], groupSize, groupSize ? 100.0f * nbBothCsrs[g] / groupSize : 0.0);
		}
	}

	dwc_ddrphy_phyinit_cmnt("%s() Dumping PState SRAM done.\n", __func__);
}

/** returns the row associated with register
 *
 *  @param[in] adr register address. not the p portion of the address is ignored.
 *  @returns integer row. returns -1 if not found.
 */
int dwc_ddrphy_phyinit_getRow(uint32_t adr)
{
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;

	uint16_t pstate = (pRuntimeConfig->curPState);
	uint16_t dmaPsOffset = ramSize * dwc_ddrphy_phyinit_getPsBase(pstate);
	uint32_t fadr = (adr & (~p1)) >> 1;	// drop the PState portion of address.
	int row;

	for (row = 0; row < ramSize; row++) {
		psrow *rptr = &psram[dmaPsOffset + row];

		if (rptr == NULL) {
			dwc_ddrphy_phyinit_assert(0, " [%s: NULL Row Pointer Error\n", __func__);
		}

		if (((adr & 0x1) == 0x0) && (fadr == rptr->adr) && ((rptr->evenodd & 0x1) == 0x1)) {
			break; // even address
		}

		if (((adr & 0x1) == 0x1) && (fadr == rptr->adr) && ((rptr->evenodd & 0x2) == 0x2)) {
			break; // odd address
		}
	}

	if (row == ramSize) {
		return -1;
	} else {
		return row + dmaPsOffset;
	}
}
#endif
/** @} */
