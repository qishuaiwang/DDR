/** \file
 * \brief implements an assert function
 *
 *  \addtogroup SrcFunc
 *  @{
 */
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

/** @brief Assertion handler used by PhyInit
 *
 * This function is called by PhyInit when errors or warnings need to be issued
 * based on user programing. The user if free to change this function to their
 * needs depending on their usage model and environment. The implementation
 * provided here is for \ref useModel only. The function prints the
 * input string fmt prepended with "[Error]" or [Warning]" depending on Svrty
 * level. if Svrty ==0 it exits the program due to Error.  if Svrty != 0 it
 * returns void.
 *
 * \note Error/warning messages are displayed to stdout in this implementation.
 *
 * @param[in] Svrty Severity Flag. 0=Fatal Error, other values are Warnings.
 * @param[in] fmt Input string to displayed output.
 *
 * @returns if Svrty==0 exits with EXIT_FAILURE otherwise returns void
 */
void dwc_ddrphy_phyinit_assert(int Svrty, const char *fmt, ...)
{
	char *PreStr;
	va_list argptr;

	PreStr = (Svrty == 0) ? "[Error]" : "[Warning]";

	va_start(argptr, fmt);
	vprintf(PreStr, argptr);
	vprintf(fmt, argptr);
	va_end(argptr);

	if (Svrty == 0) {
		exit(EXIT_FAILURE);
	} else {
		return;
	}
}

/** @} */
