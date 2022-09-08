#include "dwc_ddrphy_phyinit.h"
#include <stdlib.h>

void dwc_ddrphy_phyinit_userCustom_overrideUserInput (phyinit_config_t* phyctx) {

    user_input_basic_t* pUserInputBasic = &phyctx->userInputBasic;
    user_input_advanced_t* pUserInputAdvanced = &phyctx->userInputAdvanced;

    char *printf_header;

    printf_header = " [dwc_ddrphy_phyinit_userCustom_overrideUserInput]";
    dwc_ddrphy_phyinit_print ("\n");
    dwc_ddrphy_phyinit_print ("\n");
    dwc_ddrphy_phyinit_cmnt ("//##############################################################\n");
    dwc_ddrphy_phyinit_cmnt ("\n");
    dwc_ddrphy_phyinit_cmnt ("// dwc_ddrphy_phyinit_userCustom_overrideUserInput is a user-editable function.\n");
    dwc_ddrphy_phyinit_cmnt ("//\n");
    dwc_ddrphy_phyinit_cmnt ("// See PhyInit App Note for detailed description and function usage\n");
    dwc_ddrphy_phyinit_print ("//\n");
    dwc_ddrphy_phyinit_cmnt ("//##############################################################\n");
    dwc_ddrphy_phyinit_print ("\n");
    dwc_ddrphy_phyinit_print ("dwc_ddrphy_phyinit_userCustom_overrideUserInput ();\n");
    dwc_ddrphy_phyinit_cmnt ("\n");

    // == Definitions for overriding a single PHY system 
    // Example Values for testing
    dwc_ddrphy_phyinit_setUserInput (phyctx, "NumPStates", 2);     // define 2 pstates
    dwc_ddrphy_phyinit_setUserInput (phyctx, "CfgPStates", 0x3);   // pstates 0 and 1 : bits 0 and 1

    // === Example to override frequency for P-State 0,1
    // === using dwc_ddrphy_phyinit_setUserInput()
    dwc_ddrphy_phyinit_setUserInput (phyctx, "Frequency[0]", 1600); // 3200Mbps 
    dwc_ddrphy_phyinit_setUserInput (phyctx, "Frequency[1]", 50);   // 100Mbps
    
    
    // === Example to override DisablePmuEcc input using dwc_ddrphy_phyinit_setUserInput()
    dwc_ddrphy_phyinit_setUserInput (phyctx, "DisablePmuEccn", 0x1);
    
    // === Example to override frequency by setting the data structure
    // === directly
    pUserInputBasic->Frequency[0]  = 1600;  // 3200Mbps 
    pUserInputBasic->Frequency[1]  = 50;    // 100Mbps
    
    // === Example to override DisablePmuEcc input by setting the data
    // === structure directly
    pUserInputAdvanced->DisablePmuEcc = 0x1;

    // === Example to set HdtCtrl to 0xff for 1D for pstates 0,1
    // === using dwc_ddrphy_phyinit_setMb()
    dwc_ddrphy_phyinit_setMb (phyctx, 0, "HdtCtrl", 0xff);
    dwc_ddrphy_phyinit_setMb (phyctx, 1, "HdtCtrl", 0xff);

    dwc_ddrphy_phyinit_cmnt ("%s End of dwc_ddrphy_phyinit_userCustom_overrideUserInput()\n", printf_header);

}

