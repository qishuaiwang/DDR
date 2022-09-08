/** \file
 *  \addtogroup SrcFunc
 *  @{
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "dwc_ddrphy_phyinit.h"

static uint16_t mem[DMEM_SIZE/sizeof(uint16_t)];

/** \brief This function loads the training firmware DMEM image and write the
 *  Message Block parameters for the training firmware into the SRAM.
 *
 *  This function performs the following tasks:
 *
 *  -# Load the firmware DMEM segment to initialize the data structures from the
 *  DMEM incv file provided in the training firmware package.
 *  -# Write the Firmware Message Block with the required contents detailing the training parameters.
 *
 * \param phyctx Data structure to hold user-defined parameters
 *
 * \return void
 */
void dwc_ddrphy_phyinit_F_loadDMEM(phyinit_config_t *phyctx)
{
	runtime_config_t *pRuntimeConfig = &phyctx->runtimeConfig;
	uint8_t pstate = pRuntimeConfig->curPState;
	uint8_t Train2D = pRuntimeConfig->curD;
	user_input_basic_t *pUserInputBasic = &phyctx->userInputBasic;

	dwc_ddrphy_phyinit_cmnt(" [%s%s] Start of %s (pstate=%d, Train2D=%d)\n", __func__, Train2D ? "2D" : "1D", __func__, pstate, Train2D);

	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// (F) Load the %dD DMEM image and write the %dD Message Block parameters for the training firmware\n",
							Train2D + 1, Train2D + 1);
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("// See PhyInit App Note for detailed description and function usage\n");
	dwc_ddrphy_phyinit_cmnt("//\n");
	dwc_ddrphy_phyinit_cmnt("//##############################################################\n");
	dwc_ddrphy_phyinit_cmnt("\n");

	// set a pointer to the message block.
	PMU_SMB_LPDDR4X_1D_t *msgBlkPtr;

	msgBlkPtr = &phyctx->mb_LPDDR4X_1D[pstate];

	// Some basic checks on MessgeBlock
	if (msgBlkPtr->EnabledDQsChA % 8 != 0 || msgBlkPtr->EnabledDQsChB % 8 != 0) {
		dwc_ddrphy_phyinit_assert(0, " [%s%s] Lp3/Lp4 - Number of Dq's Enabled per Channel much be multipe of 8\n", __func__, Train2D ? "2D" : "1D");
	}

	if ((msgBlkPtr->EnabledDQsChA > 8 * (pUserInputBasic->NumActiveDbyteDfi0)) ||
		(msgBlkPtr->EnabledDQsChB > 8 * (pUserInputBasic->NumActiveDbyteDfi1)) || (msgBlkPtr->EnabledDQsChA == 0 && msgBlkPtr->EnabledDQsChB == 0)) {
		dwc_ddrphy_phyinit_assert(0, " [%s%s] EnabledDqsChA/B are not set correctly./1\n", __func__, Train2D ? "2D" : "1D");
	}

	uint32_t last_addr = 0, sizeOfMsgBlk;
	return_offset_lastaddr_t return_type = return_lastaddr;

	// initialize the dmem structure
	memset(mem, 0, sizeof(mem));

	// 1-D
	last_addr = dwc_ddrphy_phyinit_storeIncvFile(DMEM_INCV_FILENAME, mem, return_type);
	sizeOfMsgBlk = sizeof(PMU_SMB_LPDDR4X_1D_t);
	dwc_ddrphy_phyinit_storeMsgBlk(msgBlkPtr, sizeOfMsgBlk, mem);

	// Write local dmem array
	if (0 != (last_addr & 1)) {	//Always write an even number of words so no 32bit quantity is uninitialized
		last_addr++;
	}
	dwc_ddrphy_phyinit_cmnt(" 1.	Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 0.\n");
	dwc_ddrphy_phyinit_cmnt("       This allows the memory controller unrestricted access to the configuration CSRs.\n");
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x0);

	if (last_addr == 0) {
		dwc_ddrphy_phyinit_cmnt(" 2.	write out DMEM: skipping since incv file is empty.\n");
	} else {
		dwc_ddrphy_phyinit_cmnt(" 2.	write out DMEM.\n");
		dwc_ddrphy_phyinit_WriteOutMem(mem, DMEM_ST_ADDR, (last_addr - DMEM_ST_ADDR));
	}

	dwc_ddrphy_phyinit_cmnt(" 3.	Isolate the APB access from the internal CSRs by setting the MicroContMuxSel CSR to 1.\n");
	dwc_ddrphy_phyinit_cmnt("      This allows the firmware unrestricted access to the configuration CSRs.\n");
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x1);

	dwc_ddrphy_phyinit_cmnt(" [%s%s] End of %s\n", __func__, Train2D ? "2D" : "1D", __func__);
}

/** @} */
