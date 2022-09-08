/**
 * \file
 * \brief store the message block into the bottom of the local DMEM array
 *
 * \addtogroup SrcFunc
 * @{
 */
#include "dwc_ddrphy_phyinit.h"

/** \brief store the message block into the bottom of the local DMEM array
 *
 * \return void
 */
void dwc_ddrphy_phyinit_storeMsgBlk(void *msgBlkPtr, int sizeOfMsgBlk, uint16_t mem[])
{
	// Local variables
	int loop;
	uint16_t *dataArray;

	// Recast the structure pointer as a pointer to an array of 16-bit values
	dataArray = (uint16_t *) msgBlkPtr;

	// Loop over the structure 16 bits at a time and load dmem
	for (loop = 0; loop < (sizeOfMsgBlk / sizeof(uint16_t)); loop++) {
		// The data is the data in the structure at the loop offset
		mem[loop] = dataArray[loop];
	}
}

/** @} */
