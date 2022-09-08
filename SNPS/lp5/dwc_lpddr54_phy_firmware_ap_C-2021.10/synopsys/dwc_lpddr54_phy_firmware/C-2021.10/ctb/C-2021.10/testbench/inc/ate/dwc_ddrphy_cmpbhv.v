 /******************************************************************************
 *
 *  dwc_ddrphy_cmpbhv
 *
 *****************************************************************************
 * Revision Notes
 * 7/22/2015 	Pouya Ashtiani	    bind file for simulation purpose only.
 *				
 *****************************************************************************/

`ifndef DWC_DDRPHY_HWEMUL
module dwc_ddrphy_cmpbhv ( );

//
// Assertions based on spec for this block.
//

//( start of simulation-only block
// synopsys translate_off
// vrq translate_off
// the tb sould set expected values for the calibration result into these variables.
// This code emulates the comparator behavior with respect to the state of the calibrator.
reg [4:0] expected_resCalNINT;
reg [4:0] expected_resCalPEXT;
reg [7:0] expected_resCalCmpr5;

initial begin 
  expected_resCalNINT = 5'd10;
  expected_resCalPEXT = 5'd12;
  expected_resCalCmpr5 = 8'd11;
`ifndef DWC_DDRPHY_SPICE_CMPA
  disable dwc_ddrphy_cmpana.dwc_ddrphy_cmpana_mxdrv;
`endif
end

// This time paramter depends on the csrCalSlowCmpana
// updated based on Mantis 3115, we sample every 200ns so setting this at 100ns due to syn cell latency.

`ifndef DWC_DDRPHY_SPICE_CMPA
initial begin
  wait(dwc_ddrphy_cmpana.rcfiltsetltime_event.triggered);
  dwc_ddrphy_cmpana.RCFILTSETLTIME = 6000;
end
//always @(dwc_ddrphy_cmpana.dwc_ddrphy_cmpana_bhvtrig) begin : pouya
// For some reason vcs doesnt like dynamic sensitivity list here.
always @(*) begin : dwc_ddrphy_cmpbhv_mxdrv
   ICalMux.IntRegInp[2:0] = 3'hx;
   #(dwc_ddrphy_cmpana.RCFILTSETLTIME);
   disable dwc_ddrphy_cmpana.dwc_ddrphy_cmpana_mxdrv;
   case({dwc_ddrphy_cmpana.CalCmpr_VIO, dwc_ddrphy_cmpana.CalInt_VIO, dwc_ddrphy_cmpana.CalExt_VIO }) 
      3'b001 : begin 
                 // a stronger P will cause the output of the comparator to go 1.   
                 `ifdef DWC_DDRPHY_GATESIM
                   ICalMux.IntRegInp[0] = (test.top.dut.u_DWC_ddrphy_pub.MASTER_dig.dwc_ddrphy_cmp.calDrvPU[4:0] <= expected_resCalPEXT) ? 
                                         u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPu50 :
                                         ~u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPu50 ;
                 `else
                   ICalMux.IntRegInp[0] = (dwc_ddrphy_cmpmeas.calDrvPU[4:0] <= expected_resCalPEXT) ? 
                                         u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPu50 :
                                         ~u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPu50 ;
                 `endif
                 ICalMux.IntRegInp[1] = 1'bx;
                 ICalMux.IntRegInp[2] = 1'bx;
               end
      3'b010 : begin
                 ICalMux.IntRegInp[0] = 1'bx;
                 // a stronger N will cause the output of the comparator to go 0
                 `ifdef DWC_DDRPHY_GATESIM
                   ICalMux.IntRegInp[1] = (test.top.dut.u_DWC_ddrphy_pub.MASTER_dig.dwc_ddrphy_cmp.calDrvPD[4:0] <= expected_resCalNINT) ? 
                                         u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPd50 :
                                         ~u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPd50 ;
                 `else
                   ICalMux.IntRegInp[1] = (dwc_ddrphy_cmpmeas.calDrvPD[4:0] <= expected_resCalNINT) ? 
                                         u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPd50 :
                                         ~u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDrvPd50 ;
                 `endif
                 ICalMux.IntRegInp[2] = 1'bx;
               end
      3'b100 : begin
                 ICalMux.IntRegInp[0] = 1'bx;
                 ICalMux.IntRegInp[1] = 1'bx;
                 ICalMux.IntRegInp[2] = (dwc_ddrphy_cmpmeas.Cmpdig_CalDac <= expected_resCalCmpr5 ) ? 
                                         u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDac50 : 
                                         ~u_DWC_ddrphy_pub.MASTER_dig.csrCmpInvertCalDac50;
               end
      3'b000 : begin
                 ICalMux.IntRegInp[0] = 1'bz;
                 ICalMux.IntRegInp[1] = 1'bz;
                 ICalMux.IntRegInp[2] = 1'bz;
               end
// VCS coverage off
      default: begin
                 ICalMux.IntRegInp[0] = 1'bx;
                 ICalMux.IntRegInp[1] = 1'bx;
                 ICalMux.IntRegInp[2] = 1'bx;
               end
// VCS coverage on
   endcase 
end   

`endif

endmodule

bind dwc_ddrphy_cmpana dwc_ddrphy_cmpbhv dwc_ddrphy_cmpbhv ( );

// vrq translate_on
// synopsys translate_on
// end of simulation-only block )




`endif

