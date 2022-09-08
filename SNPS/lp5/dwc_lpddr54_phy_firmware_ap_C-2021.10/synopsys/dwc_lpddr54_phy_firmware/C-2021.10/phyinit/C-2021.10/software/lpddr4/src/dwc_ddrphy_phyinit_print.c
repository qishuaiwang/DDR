/** \file
 * \brief prints string to output file.
 */
#include <stdio.h>
#include <stdarg.h>
#include "dwc_ddrphy_phyinit.h"

extern FILE * outFilePtr;		// defined in the dwc_ddrphy_phyinit_globals.c

/**  \addtogroup SrcFunc
 *  @{
 */

/** @brief Wrapper to printf
 *
 * This function is called by PhyInit to print information to output. The user
 * may have a different implementation as required by their \ref useModel.  In This
 * implementation, input string fmt is printed fort the output file handle
 * determined by \ref outFilePtr.
 *
 * @param[in] fmt Input
 *
 * @returns void
 */
void dwc_ddrphy_phyinit_print(const char *fmt, ...)
{
	va_list argptr;

	va_start(argptr, fmt);
	vfprintf(outFilePtr, fmt, argptr);
	va_end(argptr);
}

/** @} */
