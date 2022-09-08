// Library ARCv2EM-4.0.28
//----------------------------------------------------------------------------
//
// Copyright 2010-2015 Synopsys, Inc. All rights reserved.
//
/// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary 
// work of Synopsys, Inc., and is fully protected under copyright and 
// trade secret laws. You may not view, use, disclose, copy, or distribute 
// this file or any information contained herein except pursuant to a 
// valid written license from Synopsys, Inc.
//
// Certain materials incorporated herein are copyright (C) 2010 - 2011, The
// University Court of the University of Edinburgh. All Rights Reserved.
//
// The entire notice above must be reproduced on all authorized copies.
//
//----------------------------------------------------------------------------
//
//  
// 
// 
// dwc_ddrphy_pmu_srams
// 
// 
//  
//
// ===========================================================================
//
// @f:rams
//
// Description:
// @p
//  The |dwc_ddrphy_pmu_srams| module instantiates the all memories in the design.
// @e
//
//  This .vpp source file must be pre-processed with the Verilog Pre-Processor
//  (VPP) to produce the equivalent .v file using a command such as:
//
//   vpp +q +o dwc_ddrphy_pmu_srams.vpp
//
// ===========================================================================

// Configuration-dependent macro definitions
//
`include "dwc_ddrphy_pmu_defines.v"

// Set simulation timescale
//
`include "dwc_ddrphy_pmu_const.def"

module dwc_ddrphy_pmu_srams (
// ICCM0
  input                       iccm_data_ce,
  input  [`DWC_DDRPHY_PMU_ICCM_WRD_MSB_CTB:`DWC_DDRPHY_PMU_ICCM_WRD_LSB_CTB]    iccm_data_addr,
  input  [`DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB:0]   iccm_data_din,
  output [`DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB:0]   iccm_data_dout,
  input                       iccm_data_we,
// DCCM
  input                       dccm_data_ce,
  input  [`DWC_DDRPHY_PMU_DCCM_WRD_MSB_CTB:`DWC_DDRPHY_PMU_DCCM_WRD_LSB_CTB]    dccm_data_addr,
  input                       dccm_data_we,
  output [`DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB:0]   dccm_data_dout,
  input  [`DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB:0]   dccm_data_din,
// leda NTL_CON13C off
// LMD: non driving port
// LJ: [EM 3.0] low power signals ls are not used in RTL
//              dwc_ddrphy_pmu_core gated clock signal clk may not be used in some configures
// light sleep & clock
  input                       ls,
  input                       clk
// leda NTL_CON13C on

  );

// Allows ability to configure mux to bypass memory



// ICCM0 RAM bypass


   







//////////////////////////////////////////////////////////////////////////////
// Module instantiation - ICCM RAM wrappers                                 //
//////////////////////////////////////////////////////////////////////////////

dwc_ddrphy_pmu_iccm_ram #(
  .par_data_msb (`DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB   ),
  .par_addr_msb (`DWC_DDRPHY_PMU_ICCM_WRD_MSB_CTB    ),
  .par_addr_lsb (`DWC_DDRPHY_PMU_ICCM_WRD_LSB_CTB    )
)
  u_iccm_ram0 (
    .ls               (ls            ), 
    .clk              (clk           ),
    .din              (iccm_data_din ),
    .dout             (iccm_data_dout),
    .addr             (iccm_data_addr),
    .cs               (iccm_data_ce  ),
    .we               (iccm_data_we  )
  );





//////////////////////////////////////////////////////////////////////////////
// Module instantiation - DCCM RAM wrappers                                 //
//////////////////////////////////////////////////////////////////////////////

dwc_ddrphy_pmu_dccm_ram #(
 .par_data_msb (`DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB   ) ,
 .par_addr_msb (`DWC_DDRPHY_PMU_DCCM_WRD_MSB_CTB    ) ,
 .par_addr_lsb (`DWC_DDRPHY_PMU_DCCM_WRD_LSB_CTB    )

)
  u_dccm_ram0 (
    .ls               (ls            ), 
    .clk              (clk           ),
    .din              (dccm_data_din ),
    .dout             (dccm_data_dout),
    .addr             (dccm_data_addr),
    .cs               (dccm_data_ce  ),
    .we               (dccm_data_we  )
  );





endmodule // dwc_ddrphy_pmu_srams   
