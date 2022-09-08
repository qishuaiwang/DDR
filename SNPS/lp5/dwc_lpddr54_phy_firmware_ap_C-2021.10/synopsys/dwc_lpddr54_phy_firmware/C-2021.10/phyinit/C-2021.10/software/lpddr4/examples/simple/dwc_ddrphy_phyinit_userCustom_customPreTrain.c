#include <stdio.h>
#include <stdlib.h>
#include "dwc_ddrphy_phyinit.h"

void dwc_ddrphy_phyinit_userCustom_customPreTrain (phyinit_config_t* phyctx) {

    char *printf_header;
    printf_header = " [phyinit_userCustom_customPreTrain]";

    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("-----------------------------------------------------\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt (" dwc_ddrphy_phyihunit_userCustom_customPreTrain is a user-editable function.\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt (" See PhyInit App Note for detailed description and function usage\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("-----------------------------------------------------\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("%s Start of dwc_ddrphy_phyinit_userCustom_customPreTrain()\n", printf_header);


    dwc_ddrphy_phyinit_cmnt ("%s End of dwc_ddrphy_phyinit_userCustom_customPreTrain()\n", printf_header);
}

void dwc_ddrphy_phyinit_userCustom_customPreTrainPsLoop (phyinit_config_t* phyctx, int pstate) {

    char *printf_header;
    printf_header = " [phyinit_userCustom_customPreTrainPsLoop]";

    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("-----------------------------------------------------\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt (" dwc_ddrphy_phyihunit_userCustom_customPreTrainPsLoop is a user-editable function.\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt (" See PhyInit App Note for detailed description and function usage\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("-----------------------------------------------------\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("%s Start of dwc_ddrphy_phyinit_userCustom_customPreTrainPsLoop()\n", printf_header);

    /**
      * \note  When PState SRAM is nor present and only two PStates are used, register programming
      * for each pstate can be performed by directly writing to each PState. If more that 2 PStates
      * are used, the values must be written to PHY FSP-0 and PhyInit register interface will store
      * the results additionally in the PSTATE SRAM.
      *
      * See Examples code provided in PhyInit for reference implementation.
      */
    user_input_basic_t* pUserInputBasic = &phyctx->userInputBasic;
	PMU_SMB_LPDDR5_1D_t *mb1D = phyctx->mb_LPDDR5_1D;

    uint32_t paddr;
    paddr = ( pUserInputBasic->NumPStates > 2 ) ? p0 : pstate;

    if ( pstate == 0 )
      {
        /** Example to override SequenceCtrl in message block for each p-state
         *  using dwc_ddrphy_phyinit_setMb(phyinit_config_t *phyctx, int ps, char *field, int value)
         */
        dwc_ddrphy_phyinit_setMb (phyctx, 0, "SequenceCtrl", 0x131f); // p-state 0

        /** Example to override SequenceCtrl in message block for each p-state
         *  by assigning the data structure sub-fields directly
         */
        mb1D[0].SequenceCtrl = 0x131f; // p-state 0

        /**  Example to override value in CSR PclkPtrInitVal for p-0
         *  paddr, tMASTER, csr_PclkPtrInitVal_ADDR make up the full address of the CSR
         *  They are defined in dwc_ddrphy_csr_ALL_cdefines.h included in Phyinit source folder
         *   - tMASTER :: MASTER block-type
         *   - csr_PclkPtrInitVal_ADDR :: register address
         */
        dwc_ddrphy_phyinit_io_write16 ((paddr | tMASTER | csr_PclkPtrInitVal_ADDR), 0x3);
      }
    else if (pstate == 1)
      {
        mb1D[1].SequenceCtrl = 0x131f;  // p-state 1
        /// A different PclkPtrInitVal setting for PS1
        dwc_ddrphy_phyinit_io_write16 ((paddr | tMASTER | csr_PclkPtrInitVal_ADDR), 0x2);
      }
    else if (pstate == 2)
      {
        /// A different PclkPtrInitVal setting for PS2
        dwc_ddrphy_phyinit_io_write16 ((paddr | tMASTER | csr_PclkPtrInitVal_ADDR), 0x3);
      }
    else // all other PStates
      {
        /// A different PclkPtrInitVal setting for PS1
        dwc_ddrphy_phyinit_io_write16 ((paddr | tMASTER | csr_PclkPtrInitVal_ADDR), 0x3);
      }

    dwc_ddrphy_phyinit_cmnt ("%s End of dwc_ddrphy_phyinit_userCustom_customPreTrainPsLoop()\n", printf_header);

}
