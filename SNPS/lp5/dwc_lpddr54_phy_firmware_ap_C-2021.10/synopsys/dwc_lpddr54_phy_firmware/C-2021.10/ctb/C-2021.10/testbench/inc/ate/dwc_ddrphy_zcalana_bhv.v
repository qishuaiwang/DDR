//============================================================================
// Copyright (c) 2017,2018 by Synopsys, Inc.
//
// This file is protected by Federal Copyright Law, with all rights reserved. 
// No part of this file may be reproduced, stored in a retrieval system,
// translated, transcribed, or transmitted, in any  form, or by any means
// manual, electric, electronic, mechanical, electro-magnetic, chemical,
// optical, or otherwise, without prior explicit written permission from 
// Synopsys, Inc.
//
//============================================================================
//
//============================================================================
// LPDDR54 PHY - Behavioral model for ZCalAna digital simulations
// Module to be binded to dwc_ddrphy_zcalana.v
//============================================================================

`timescale 1ps/1ps


//( start of simulation-only block
// synopsys translate_off
// vrq translate_off

`ifndef DWC_DDRPHY_HWEMUL
module dwc_ddrphy_zcalana_bhv ( );

`ifndef DWC_DDRPHY_SIMPLE_MODEL

////////////////////////////////////////////////////////////////////////////////
// PARAMETERS
////////////////////////////////////////////////////////////////////////////////

parameter pT_RC_SETTLING    = 200000;

////////////////////////////////////////////////////////////////////////////////
// VARIABLES
////////////////////////////////////////////////////////////////////////////////
// the tb sould set expected values for the calibration result into these variables.
// This code emulates the comparator behavior with respect to the state of the calibrator.
reg [7:0] expected_ZCalCompVOHDAC;
reg [7:0] expected_ZCalCodePU;
reg [7:0] expected_ZCalCodePD;

integer   t_rc_settling;


////////////////////////////////////////////////////////////////////////////////
// MODEL
////////////////////////////////////////////////////////////////////////////////

//NOTE that Vref net is being used to model changes in VOH DAC.

initial begin 
  expected_ZCalCompVOHDAC = 7'd64;
  expected_ZCalCodePU     = 8'd128;
  expected_ZCalCodePD     = 8'd32;  
  
  t_rc_settling           = pT_RC_SETTLING;
  
  disable dwc_ddrphy_zcalana.dwc_ddrphy_zcalana_mxdrv;
end

always @(u_DWC_ddrphy_pub.MASTER_dig.csrZCalAnaSettlingTime) begin
  t_rc_settling = $ceil( 1.0*(u_DWC_ddrphy_pub.MASTER_dig.csrZCalAnaSettlingTime)*(15.625E-9)*(1.0E12) );
end


always @* begin: dwc_ddrphy_zcalana_bhv_mxdrv
  dwc_ddrphy_zcalana.Vref_i    = 1'bx;
  dwc_ddrphy_zcalana.PULoad_i  = 1'bx;
  dwc_ddrphy_zcalana.PDLoad_i  = 1'bx; 
  
  #(t_rc_settling);

  disable dwc_ddrphy_zcalana.dwc_ddrphy_zcalana_mxdrv;
 
  case ( dwc_ddrphy_zcalana.Mux_sel )
    3'b000:   begin 
                dwc_ddrphy_zcalana.Vref_i    = 1'bz;
                dwc_ddrphy_zcalana.PULoad_i  = 1'bz;
                dwc_ddrphy_zcalana.PDLoad_i  = 1'bz;  
              end              
    3'b100:   begin 
                dwc_ddrphy_zcalana.Vref_i    =  (u_DWC_DDRPHYMASTER_top.ZCalCompVOHDAC_q  == expected_ZCalCompVOHDAC)  ?  |( {$random} % 2 )                                :
                                                (u_DWC_DDRPHYMASTER_top.ZCalCompVOHDAC_q  <  expected_ZCalCompVOHDAC)  ?  u_DWC_ddrphy_pub.MASTER_dig.csrZCalCompInvertComp :
                                                                                                                          ~u_DWC_ddrphy_pub.MASTER_dig.csrZCalCompInvertComp;
                dwc_ddrphy_zcalana.PULoad_i  = 1'bx;
                dwc_ddrphy_zcalana.PDLoad_i  = 1'bx;  
              end
    3'b001:   begin 
                dwc_ddrphy_zcalana.Vref_i    = 1'bx;
                dwc_ddrphy_zcalana.PULoad_i  =  ( u_DWC_DDRPHYMASTER_top.ZCalCodePU_q[7:0] == expected_ZCalCodePU)  ? |( {$random} % 2 )                                :
                                                ( u_DWC_DDRPHYMASTER_top.ZCalCodePU_q[7:0] <  expected_ZCalCodePU)  ? u_DWC_ddrphy_pub.MASTER_dig.csrZCalCompInvertPU   :
                                                                                                                      ~u_DWC_ddrphy_pub.MASTER_dig.csrZCalCompInvertPU;
                dwc_ddrphy_zcalana.PDLoad_i  = 1'bx;  
              end
    3'b010:   begin 
                dwc_ddrphy_zcalana.Vref_i    = 1'bx;
                dwc_ddrphy_zcalana.PULoad_i  = 1'bx;
                dwc_ddrphy_zcalana.PDLoad_i  =  ( u_DWC_DDRPHYMASTER_top.ZCalCodePD_q[7:0] == expected_ZCalCodePD)  ? |( {$random} % 2 )                                :
                                                ( u_DWC_DDRPHYMASTER_top.ZCalCodePD_q[7:0] <  expected_ZCalCodePD)  ? u_DWC_ddrphy_pub.MASTER_dig.csrZCalCompInvertPD   :
                                                                                                                      ~u_DWC_ddrphy_pub.MASTER_dig.csrZCalCompInvertPD;
              end
    default:  begin 
                dwc_ddrphy_zcalana.Vref_i    = 1'bx;
                dwc_ddrphy_zcalana.PULoad_i  = 1'bx;
                dwc_ddrphy_zcalana.PDLoad_i  = 1'bx;    
              end
  endcase
  
end

`endif

endmodule

bind dwc_ddrphy_zcalana dwc_ddrphy_zcalana_bhv dwc_ddrphy_zcalana_bhv ( );

`endif    // DWC_DDRPHY_HWEMUL

// vrq translate_on
// synopsys translate_on
// end of simulation-only block )
