#include "dwc_ddrphy_phyinit.h"

void dwc_ddrphy_phyinit_userCustom_customPostTrain (phyinit_config_t* phyctx) {

    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("//##############################################################\n");
    dwc_ddrphy_phyinit_cmnt ("//\n");
    dwc_ddrphy_phyinit_cmnt ("// dwc_ddrphy_phyinit_userCustom_customPostTrain is a user-editable function.\n");
    dwc_ddrphy_phyinit_cmnt ("//\n");
    dwc_ddrphy_phyinit_cmnt ("// See PhyInit App Note for detailed description and function usage\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("//##############################################################\n");
    dwc_ddrphy_phyinit_cmnt ("\n");

    char *printf_header;
    printf_header = "// [dwc_ddrphy_phyinit_userCustom_customPostTrain]";
    dwc_ddrphy_phyinit_print ("dwc_ddrphy_phyinit_userCustom_customPostTrain ();\n\n");


    dwc_ddrphy_phyinit_cmnt ("%s End of dwc_ddrphy_phyinit_userCustom_customPostTrain()\n", printf_header);
}

void dwc_ddrphy_phyinit_userCustom_customPostTrainPsLoop(phyinit_config_t *phyctx, int pstate)
{
    // 1. Enable APB access.
	dwc_ddrphy_phyinit_cmnt(" Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 0.\n");
	dwc_ddrphy_phyinit_cmnt(" This allows the memory controller unrestricted access to the configuration CSRs.\n");
	dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x0);

    // 2. Issue register writes
    // === Example to override value in CSR ACTxDly for both channels, P-state 0
    // === p0, tAC, c0/c1, r0/r1/.../r7, csr_ACTxDly_ADDR make up the full address of the CSR
    // === They are defined in dwc_ddrphy_csr_ALL_cdefines.h included in Phyinit source folder
    // === p0               - p-state 0
    // === tAC              - Address/Command block-type
    // === c0/c1            - channel instance number
    // === r0/r1/.../r7     - address lanes (6CA/2CS/2CKE)
    // === csr_ACTxDly_ADDR - register
    if (pstate == 0) {
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r0 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r1 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r2 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r3 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r4 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r5 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r6 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c0 | r7 | csr_ACTxDly_ADDR), 0x12);

        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r0 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r1 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r2 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r3 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r4 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r5 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r6 | csr_ACTxDly_ADDR), 0x12);
        dwc_ddrphy_phyinit_io_write16((p0 | tAC | c1 | r7 | csr_ACTxDly_ADDR), 0x12);
    }

    // === Example to override value in CSR TxDqsDlyTg0 for DBYTE 0-1, upper and lower 4-bits, and P-state 1
    // === P0, tDBYTE, c0/c1, csr_TxDqsDlyTg0_ADDR make up the full address of the CSR
    // === They are defined in dwc_ddrphy_csr_ALL_cdefines.h included in Phyinit source folder
    // === p1                   - p-state 1
    // === tDBYTE               - DBYTE block-type
    // === c0/c1                - DBYTE instance number
    // === u0/u1                - upper/lower 4-bits
    // === csr_TxDqsDlyTg0_ADDR  - register
    if (pstate == 1) {
        dwc_ddrphy_phyinit_userCustom_io_write16 ((p1 | tDBYTE | c0 | u0 | csr_TxDqsDlyTg0_ADDR), 0x105);
        dwc_ddrphy_phyinit_userCustom_io_write16 ((p1 | tDBYTE | c0 | u1 | csr_TxDqsDlyTg0_ADDR), 0x105);
        dwc_ddrphy_phyinit_userCustom_io_write16 ((p1 | tDBYTE | c1 | u0 | csr_TxDqsDlyTg0_ADDR), 0x105);
        dwc_ddrphy_phyinit_userCustom_io_write16 ((p1 | tDBYTE | c1 | u1 | csr_TxDqsDlyTg0_ADDR), 0x105);
    }

    // 3. Isolate APB access.
    dwc_ddrphy_phyinit_cmnt ("// Isolate the APB access from the internal CSRs by setting the MicroContMuxSel CSR to 1. \n");
    dwc_ddrphy_phyinit_MicroContMuxSel_write16(0x1);
}

