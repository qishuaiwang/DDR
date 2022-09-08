/** @file
 *  @brief writes local memory content into the SRAM via APB interface.
 *  @addtogroup SrcFunc
 *  @{
 */
#include <stdio.h>
#include "dwc_ddrphy_phyinit.h"

/**
 * @brief writes local memory content into the SRAM via APB interface.
 *
 * This function issued APB writes commands to SRAM address based on values
 * stored in a local PhyInit array that contains consolidated IMEM and DMEM
 * data.
 * @param[in] mem[] Local memory array.
 * @param[in] mem_offset offset index. if provided, skips to the offset index
 * from the local array and issues APB commands from mem_offset to mem_size.
 * @param[in] mem_size size of the memroy (in mem array index)
 * @returns void
 */
void dwc_ddrphy_phyinit_WriteOutMem(uint16_t mem[], int mem_offset, int mem_size)
{
	int index;

	dwc_ddrphy_phyinit_cmnt(" [%s] STARTING. offset 0x%x size 0x%x\n", __func__, mem_offset, mem_size);
	for (index = 0; index < mem_size; index++) {
		//routine call option
		//dwc_ddrphy_phyinit_print("WriteOutMem: Attempting Write: Adr:0x%x Dat: 0x%x\n", index + mem_offset, mem[index]);
		dwc_ddrphy_phyinit_userCustom_io_write16(index + mem_offset, mem[index]);
		fflush(stdout);
	}

	dwc_ddrphy_phyinit_cmnt(" [%s] DONE.  Index 0x%x\n", __func__, index);
	fflush(stdout);
}

/** @} */
