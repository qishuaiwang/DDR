/** \file
 * \brief implementation of Wait
 * \addtogroup CustFunc
 *  @{
 */
#include <dwc_ddrphy_phyinit.h>
/** \brief function to implement Wait feature
 *
 * The default behvior of dwc_ddrphy_phyinit_userCustom_wait() is to print
 * the wait commands calculated by PhyInit. User can edit this function to
 * print differently, or implement a mechanism to trigger a Wait event in
 * simulation.
 *
 * \param adr 32-bit integer indicating address of CSR to be written
 * \param dat 16-bit integer for the value to be written to the CSR
 * \returns \c void
 */
void dwc_ddrphy_phyinit_userCustom_wait(uint32_t nDfiClks)
{
  char *printf_header;
  printf_header = " [dwc_ddrphy_phyinit_userCustom_wait]";
	// write the Wait Time to output txt file
	dwc_ddrphy_phyinit_cmnt("Calling %s to wait %d DfiClks;\n" , printf_header, nDfiClks);
}

/** @} */
