/** \file
 * \brief implementation of APB write
 * \addtogroup CustFunc
 *  @{
 */
#include <dwc_ddrphy_phyinit.h>
extern char *ApbStr;			// Pointer to special string for APB commands. defined in the dwc_ddrphy_phyinit_globals.c
/** \brief function to implement a register write to the PHY
 *
 * The default behvior of dwc_ddrphy_phyinit_userCustom_io_write16() is to print
 * the APB write commands calculated by PhyInit. User can edit this function to
 * print differently, or implement a mechanism to trigger a APB write event in
 * simulation.
 *
 * \param adr 32-bit integer indicating address of CSR to be written
 * \param dat 16-bit integer for the value to be written to the CSR
 * \returns \c void
 */
void dwc_ddrphy_phyinit_userCustom_io_write16(uint32_t adr, uint16_t dat)
{
	// write the apb register write to output txt file
	dwc_ddrphy_phyinit_print("%s", ApbStr);
	dwc_ddrphy_phyinit_print("dwc_ddrphy_apb_wr(32'h%x,16'h%x);\n", adr, dat);
}

/** @} */
