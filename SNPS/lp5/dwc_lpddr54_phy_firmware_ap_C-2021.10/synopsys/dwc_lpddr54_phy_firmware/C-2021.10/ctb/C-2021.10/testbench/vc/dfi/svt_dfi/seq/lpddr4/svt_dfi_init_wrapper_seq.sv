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

`ifndef GUARD_SVT_DFI_INIT_WRAPPER_SEQ_SV
`define GUARD_SVT_DFI_INIT_WRAPPER_SEQ_SV

class svt_dfi_init_wrapper_seq extends uvm_sequence#(svt_dfi_mc_transaction);
  
  `uvm_object_utils(svt_dfi_init_wrapper_seq)
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  rand bit [4:0] freq;
  rand bit [1:0] fsp ;
  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;

  function new(string name = "svt_dfi_init_wrapper_seq");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_init_wrapper_seq","Starting of the sequence : svt_dfi_init_wrapper_seq");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_init_wrapper_seq","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_init_wrapper_seq","Starting of the sequence : svt_dfi_init_wrapper_seq");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_init_wrapper_seq","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_init_wrapper_seq","Starting of the sequence : svt_dfi_init_wrapper_seq");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_init_wrapper_seq", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end

    `uvm_do_on_with(drive_seq, p_sequencer.host_transaction_seqr, {COMMAND==DFI_INIT; 
                                                                   FREQ==freq; 
                                                                   FSP==fsp; });
    `svt_trace("svt_dfi_init_wrapper_seq",$psprintf("DFI_INIT command issued with freq=%0d",this.freq));

    `svt_trace("svt_dfi_init_wrapper_seq","Ending of the sequence : svt_dfi_init_wrapper_seq");
   endtask
    
endclass: svt_dfi_init_wrapper_seq
`endif
//-----------END OF LINE -------------------------------------------//
