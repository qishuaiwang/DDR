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

`ifndef GUARD_SVT_DFI_LPDDR5_WR_SEQ_SV
`define GUARD_SVT_DFI_LPDDR5_WR_SEQ_SV

class svt_dfi_lpddr5_wr_seq  extends uvm_sequence#(svt_dfi_mc_lpddr5_transaction);
 
  `uvm_object_utils(svt_dfi_lpddr5_wr_seq )
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;
  rand bit [`DFI_MAX_ADDRESS_WIDTH-1:0] addr;
  rand bit [`DFI_MAX_BANK_ADDRESS_WIDTH-1:0] bank;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] cs;
  rand reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] data[32];
  rand reg [`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_wrdata_mask[32];
  bit [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0] vld_dbyte = {`SVT_DFI_DATA_ENABLE_WIDTH{1'b1}};
  bit CRC_EN;
  bit [2:0] MRS_BL;
  //rand bit lp4_ap;
  bit lp5_ap=0;
  bit [1:0] bg;
  int bl;


  function new(string name = "svt_dfi_lpddr5_wr_seq ");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_lpddr5_wr_seq ","Starting of the sequence : svt_dfi_lpddr5_wr_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_lpddr5_wr_seq ","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_lpddr5_wr_seq ","Starting of the sequence : svt_dfi_lpddr5_wr_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_lpddr5_wr_seq ","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_lpddr5_wr_seq ","Starting of the sequence : svt_dfi_lpddr5_wr_seq ");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_lpddr5_wr_seq ", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end
    CRC_EN       = dfi_config.crc_en;
    MRS_BL       = dfi_config.mrs_bl;
     `uvm_create_on(drive_seq,p_sequencer.host_transaction_seqr);
    case(cfg.PState)
      0: 
         `ifdef WRITE_DM0
         drive_seq.COMMAND =svt_dfi_drive_sequence::MWR;
         `else
         drive_seq.COMMAND =svt_dfi_drive_sequence::WR;
         `endif
      1: 
         `ifdef WRITE_DM1
         drive_seq.COMMAND =svt_dfi_drive_sequence::MWR;
         `else
         drive_seq.COMMAND =svt_dfi_drive_sequence::WR;
         `endif
      2: 
         `ifdef WRITE_DM2
         drive_seq.COMMAND =svt_dfi_drive_sequence::MWR;
         `else
         drive_seq.COMMAND =svt_dfi_drive_sequence::WR;
         `endif
      3: 
         `ifdef WRITE_DM3
         drive_seq.COMMAND =svt_dfi_drive_sequence::MWR;
         `else
         drive_seq.COMMAND =svt_dfi_drive_sequence::WR;
         `endif
      default:
         drive_seq.COMMAND =svt_dfi_drive_sequence::WR;
    endcase
    drive_seq.CS =cs;
    drive_seq.DAT_CS = ~cs;
    drive_seq.BANK =bank;
    drive_seq.BG = bg;
    drive_seq.LP5_AP = lp5_ap;
    drive_seq.VLD_DBYTE = vld_dbyte;
    //case(MRS_BL)
    //0:drive_seq.BL = 16;
    //1:drive_seq.BL = 32;
    //2:begin
    //    drive_seq.BL = lp4_otf_bl?32:16;
    //end
    //endcase
    drive_seq.BL = bl;
    //addr[3:0] = 4'h0;
    //if(drive_seq.BL == 32) begin
    //  addr[4] = 1'b0;
    //end
    drive_seq.ADDR = addr;
    drive_seq.DATA = new[drive_seq.BL];
    drive_seq.DM = new[drive_seq.BL];
    //if(!DATA.size()) begin
      for(int i = 0; i<`DFI_MAX_NUM_DBYTE; i++) begin
        for(int brst=0; brst<drive_seq.BL; brst++) begin
          //drive_seq.DATA[brst][((i+1)*8-1)-:8] = $urandom_range(1,63); 
          drive_seq.DATA[brst][((i+1)*8-1)-:8] = data[brst][((i+1)*8-1)-:8]; 
          `svt_debug("svt_dfi_write_wrapper_seq",$psprintf("setting data for write = %0x for byte %0d and burst %0d cmd is %s",drive_seq.DATA[brst][((i+1)*8-1)-:8],i,brst,drive_seq.COMMAND.name));
          drive_seq.DM[brst][i-:1] =dfi_wrdata_mask[brst][i-:1];
          `svt_debug("svt_dfi_write_wrapper_seq",$psprintf("setting DM data for write = %0x for byte %0d and burst %0d",drive_seq.DM[brst][i-:1],i,brst));
//          $display ("debug for data[%0d]=%h ,dfi_wrdata_mask[%0d]=%b ,drive_seq.DATA[%0d]=%h ,drive_seq.DM[%0d]=%b",brst,data[brst][((i+1)*8-1)-:8],brst,dfi_wrdata_mask[brst][i-:1],brst,drive_seq.DATA[brst][((i+1)*8-1)-:8],brst,drive_seq.DM[brst][i-:1]);
        end
      end
   // end else begin
   //     for(int brst=0; brst<`DFI_MAX_BL; brst++) begin
   //       drive_seq.DATA[brst] = DATA[brst]); 
   //     end
   // end
    `uvm_send (drive_seq);
       
    `svt_trace("svt_dfi_lpddr5_wr_seq ","Ending of the sequence : svt_dfi_lpddr5_wr_seq ");
   endtask
    
endclass: svt_dfi_lpddr5_wr_seq 
`endif
//-----------END OF LINE -------------------------------------------//











