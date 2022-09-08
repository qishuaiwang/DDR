/** \file */

#include "dwc_ddrphy_phyinit_userCustom.h"

/*! \def DWC_DDRPHY_PHYINIT_RID
 * cdefine for a PhyInit Revision ID
 */
#define DWC_DDRPHY_PHYINIT_RID 20211021

// Function definitions
int dwc_ddrphy_phyinit_setMb(phyinit_config_t *phyctx, int ps, char *field, int value);
int dwc_ddrphy_phyinit_softSetMb(phyinit_config_t *phyctx, int ps, char *field, int value);
void dwc_ddrphy_phyinit_initStruct(phyinit_config_t *phyctx);
