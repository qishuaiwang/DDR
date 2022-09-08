//---------------------------------------------------------------------------------------------------
// COPYRIGHT (C) 2017 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//----------------------------------------------------------------------------------------------------
//==================================================================================================//
//-------------------------------------Description--------------------------------------------------//
//==================================================================================================//

//==================================================================================================//

`ifndef GUARD_SVT_DFI_LPDDR5_CAS_SEQ_SV
`define GUARD_SVT_DFI_LPDDR5_CAS_SEQ_SV

class svt_dfi_lpddr5_cas_seq  extends uvm_sequence#(svt_dfi_mc_lpddr5_transaction);
 
  `uvm_object_utils(svt_dfi_lpddr5_cas_seq )
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] cs;
  bit [2:0] sync_type;

  function new(string name = "svt_dfi_lpddr5_cas_seq ");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_lpddr5_cas_seq ","Starting of the sequence : svt_dfi_lpddr5_cas_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_lpddr5_cas_seq ","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_lpddr5_cas_seq ","Starting of the sequence : svt_dfi_lpddr5_cas_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_lpddr5_cas_seq ","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_lpddr5_cas_seq ","Starting of the sequence : svt_dfi_lpddr5_cas_seq ");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_lpddr5_cas_seq ", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end
     `uvm_create_on(drive_seq,p_sequencer.host_transaction_seqr);
    
    drive_seq.COMMAND =svt_dfi_drive_sequence::CAS;
    //addr[3:0] = 4'h0;
    drive_seq.CS =cs;
    drive_seq.LP5_WS_WR=sync_type[0];
    drive_seq.LP5_WS_RD=sync_type[1];
    drive_seq.LP5_WS_FS=sync_type[2];
    drive_seq.DC = 4'b0;
    drive_seq.B3 = 1'b0;
    //drive_seq.VLD_DBYTE = this.vld_dbyte;
    //case(MRS_BL)
    //0:drive_seq.BL = 16;
    //1:drive_seq.BL = 32;
    //2:begin
    //    drive_seq.BL = lp4_otf_bl?32:16;
    //end
    //endcase
    `uvm_send (drive_seq);
       
     $display("send CAS command , sync_type=%0b",sync_type);
    `svt_trace("svt_dfi_lpddr5_cas_seq ","Ending of the sequence : svt_dfi_lpddr5_cas_seq ");
   endtask
    
endclass: svt_dfi_lpddr5_cas_seq 
`endif
//-----------END OF LINE -------------------------------------------//


