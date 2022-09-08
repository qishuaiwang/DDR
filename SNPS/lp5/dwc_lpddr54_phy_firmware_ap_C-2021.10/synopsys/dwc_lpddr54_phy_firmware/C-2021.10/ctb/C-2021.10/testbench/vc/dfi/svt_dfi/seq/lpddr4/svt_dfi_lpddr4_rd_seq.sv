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

`ifndef GUARD_SVT_DFI_LPDDR4_RD_SEQ_SV
`define GUARD_SVT_DFI_LPDDR4_RD_SEQ_SV

class svt_dfi_lpddr4_rd_seq  extends uvm_sequence#(svt_dfi_mc_lpddr4_transaction);
 
  `uvm_object_utils(svt_dfi_lpddr4_rd_seq )
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;
  rand bit [`DFI_MAX_ADDRESS_WIDTH-1:0] addr;
  rand bit [`DFI_MAX_BANK_ADDRESS_WIDTH-1:0] bank;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] cs;
  rand bit lp4_otf_bl;//LP4 spec MR1[1:0] == 2
  bit [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0] vld_dbyte = {`SVT_DFI_DATA_ENABLE_WIDTH{1'b1}};
  bit CRC_EN;
  bit [2:0] MRS_BL;
  //rand bit lp4_ap;
  bit lp4_ap = 1;// Default RDA

  function new(string name = "svt_dfi_lpddr4_rd_seq ");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_lpddr4_rd_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_lpddr4_rd_seq ","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_lpddr4_rd_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_lpddr4_rd_seq ","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_lpddr4_rd_seq ","Starting of the sequence : svt_dfi_lpddr4_rd_seq ");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_lpddr4_rd_seq ", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end
    CRC_EN       = dfi_config.crc_en;
    MRS_BL       = dfi_config.mrs_bl;
     `uvm_create_on(drive_seq,p_sequencer.host_transaction_seqr);
    
    drive_seq.COMMAND =svt_dfi_drive_sequence::RD_ONE;
    //addr[3:0] = 4'h0;
    drive_seq.ADDR = addr;
    drive_seq.CS =cs;
    drive_seq.DAT_CS = ~cs;
    drive_seq.BANK =bank;
    drive_seq.LP4_OTF_BL = lp4_otf_bl;
    drive_seq.LP4_AP = lp4_ap;
    drive_seq.VLD_DBYTE = this.vld_dbyte;
    case(MRS_BL)
      0:drive_seq.BL = 16;
      1:drive_seq.BL = 32;
      2:begin
          drive_seq.BL = lp4_otf_bl?32:16;
      end
    endcase
    `uvm_send (drive_seq);
    //drive_seq.COMMAND =svt_dfi_drive_sequence::RD_ONE;
    drive_seq.CS = {`SVT_DFI_CHIP_SELECT_WIDTH{1'b0}};
    drive_seq.DAT_CS = ~cs;
    `uvm_send (drive_seq);
    drive_seq.DATA = new[drive_seq.BL];
    drive_seq.COMMAND =svt_dfi_drive_sequence::CAS_TWO;
    drive_seq.CAS_TWO_COMMAND=svt_dfi_drive_sequence::RD_TWO;
    drive_seq.CS =cs;
    drive_seq.DAT_CS = ~cs;
    `uvm_send (drive_seq);
   // drive_seq.COMMAND =svt_dfi_drive_sequence::CAS_TWO;
   // drive_seq.CAS_TWO_COMMAND=svt_dfi_drive_sequence::RD_TWO;
    drive_seq.CS={`SVT_DFI_CHIP_SELECT_WIDTH{1'b0}};
    drive_seq.DAT_CS = ~cs;
    `uvm_send (drive_seq);
    // TODO `uvm_send (dfi_lp4_rd_seq)
    // TODO create_phymstr_sideband_cmds_lp4(this.seqr);
    // TODO if(enable_phymstr_handling) begin
    // TODO   handle_phymstr_req_lp4(this.seqr,rollover_tr);
    // TODO 
    // TODO //handle_phymstr_req();
    
    `svt_trace("svt_dfi_lpddr4_rd_seq ","Ending of the sequence : svt_dfi_lpddr4_rd_seq ");
   endtask
    
endclass: svt_dfi_lpddr4_rd_seq 
`endif
//-----------END OF LINE -------------------------------------------//










