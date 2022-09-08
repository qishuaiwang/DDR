

/** \file dwc_ddrphy_phyinit_protocols.h
 *  \brief This file defines which protocol(s) to support in PhyInit
 */

#ifndef _DWC_DDRPHY_PHYINIT_PROTOCOLS_H_
#define _DWC_DDRPHY_PHYINIT_PROTOCOLS_H_

#if defined(_BUILD_LPDDR4X) && !defined(_BUILD_LPDDR4)
#define _BUILD_LPDDR4
#endif

#if !defined(_BUILD_LPDDR4) && !defined(_BUILD_LPDDR5)
#error "You must define at least one protocol (LPDDR4 or LPDDR5)"
#endif

#define _SINGLE_PROTOCOL (_BUILD_LPDDR4 ^ _BUILD_LPDDR5)

#ifndef _SINGLE_PROTOCOL
DramType_t DramType;
#endif

#if !defined(_SINGLE_PROTOCOL) && defined(_BUILD_LPDDR4)
#define _IF_LPDDR4(input) if (DramType == LPDDR4) { input}
#elif defined(_BUILD_LPDDR4)
#define _IF_LPDDR4(input) input
#else
#define _IF_LPDDR4(input)
#endif

#if !defined(_SINGLE_PROTOCOL) && defined(_BUILD_LPDDR5)
#define _IF_LPDDR5(input) if (DramType == LPDDR5) { input}
#elif defined(_BUILD_LPDDR5)
#define _IF_LPDDR5(input) input
#else
#define _IF_LPDDR5(input)
#endif

#endif
