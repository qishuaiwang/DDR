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

`ifndef GUARD_SVT_DFI_LPDDR5_RD_SEQ_SV
`define GUARD_SVT_DFI_LPDDR5_RD_SEQ_SV

class svt_dfi_lpddr5_rd_seq  extends uvm_sequence#(svt_dfi_mc_lpddr5_transaction);
 
  `uvm_object_utils(svt_dfi_lpddr5_rd_seq )
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;
  rand bit [`DFI_MAX_ADDRESS_WIDTH-1:0] addr;
  rand bit [`DFI_MAX_BANK_ADDRESS_WIDTH-1:0] bank;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] cs;
  bit [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0] vld_dbyte = {`SVT_DFI_DATA_ENABLE_WIDTH{1'b1}};
  bit CRC_EN;
  bit [2:0] MRS_BL;
  bit lp5_ap = 1; //Default RDA
  bit [1:0] bg;
  int bl;


  function new(string name = "svt_dfi_lpddr5_rd_seq ");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_lpddr5_rd_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_lpddr5_rd_seq ","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_lpddr5_rd_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_lpddr5_rd_seq ","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_lpddr5_rd_seq ","Starting of the sequence : svt_dfi_lpddr5_rd_seq ");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_lpddr5_rd_seq ", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end
    CRC_EN       = dfi_config.crc_en;
    MRS_BL       = dfi_config.mrs_bl;
     `uvm_create_on(drive_seq,p_sequencer.host_transaction_seqr);
    
    //drive_seq.COMMAND =svt_dfi_drive_sequence::RD_ZERO;
    //drive_seq.COMMAND =`SVT_DFI_MC_READ;
    drive_seq.COMMAND = svt_dfi_drive_sequence::RD;
    //addr[3:0] = 4'h0;
    drive_seq.ADDR = addr;
    drive_seq.CS =cs;
    drive_seq.DAT_CS = ~cs;
    drive_seq.BANK =bank;
    drive_seq.BG = bg;
    drive_seq.LP5_AP = lp5_ap;
    drive_seq.BL = bl;
    `uvm_send (drive_seq);
       
    `svt_trace("svt_dfi_lpddr5_rd_seq ","Ending of the sequence : svt_dfi_lpddr5_rd_seq ");
   endtask
    
endclass: svt_dfi_lpddr5_rd_seq 
`endif
//-----------END OF LINE -------------------------------------------//










