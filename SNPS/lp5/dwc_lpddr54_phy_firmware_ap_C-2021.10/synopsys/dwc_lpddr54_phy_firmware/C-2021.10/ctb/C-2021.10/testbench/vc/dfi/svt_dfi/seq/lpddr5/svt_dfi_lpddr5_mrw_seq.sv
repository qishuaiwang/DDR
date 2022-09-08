//==================================================================================================//
//-------------------------------------Description--------------------------------------------------//
//==================================================================================================//

//==================================================================================================//

`ifndef GUARD_SVT_DFI_LPDDR5_MRW_SEQ_SV
`define GUARD_SVT_DFI_LPDDR5_MRW_SEQ_SV

class svt_dfi_lpddr5_mrw_seq  extends uvm_sequence#(svt_dfi_mc_lpddr5_transaction);
 
  `uvm_object_utils(svt_dfi_lpddr5_mrw_seq )
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;
  rand bit [`DFI_MAX_ADDRESS_WIDTH-1:0] addr;
  rand bit [`DFI_MAX_BANK_ADDRESS_WIDTH-1:0] bank;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] cs;
  rand bit [5:0] ma;
  rand bit [7:0] lpddr5_op;
  bit [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0] vld_dbyte = {`SVT_DFI_DATA_ENABLE_WIDTH{1'b1}};
  bit CRC_EN;
  bit [2:0] MRS_BL;
  rand bit lp5_ap;
  bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] cke = {`SVT_DFI_CHIP_SELECT_WIDTH{1'b1}};

  function new(string name = "svt_dfi_lpddr5_mrw_seq ");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_lpddr5_mrw_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_lpddr5_mrw_seq ","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_lpddr5_mrw_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_lpddr5_mrw_seq ","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_lpddr5_mrw_seq ","Starting of the sequence : svt_dfi_lpddr5_mrw_seq ");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_lpddr5_mrw_seq ", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end
    CRC_EN       = dfi_config.crc_en;
    MRS_BL       = dfi_config.mrs_bl;
     `uvm_create_on(drive_seq,p_sequencer.host_transaction_seqr);
    
    drive_seq.COMMAND =svt_dfi_drive_sequence::MRW_ONE;
    drive_seq.ADDR = addr;
    drive_seq.LP5_OP = lpddr5_op ;
    drive_seq.CS = cs;
    //drive_seq.CKE = cke;
    // case(MRS_BL)
    //0:drive_seq.BL = 16;
    //1:drive_seq.BL = 32;
    //2:begin
    //    drive_seq.BL = lp4_otf_bl?32:16;
    //end
    //endcase
    //drive_seq.DATA = new[drive_seq.BL];
    //drive_seq.DM = new[drive_seq.BL];
    ////if(!DATA.size()) begin
    //  for(int i = 0; i<`DFI_MAX_NUM_DBYTE; i++) begin
    //    for(int brst=0; brst<drive_seq.BL; brst++) begin
    //      drive_seq.DATA[brst][((i+1)*8-1)-:8] = $urandom_range(1,63); 
    //      `svt_debug("svt_dfi_write_wrapper_seq",$psprintf("setting data for write = %0x for byte %0d and burst %0d cmd is %s",drive_seq.DATA[brst][((i+1)*8-1)-:8],i,brst,drive_seq.COMMAND.name));
    //    end
    //  end
   // end else begin
   //     for(int brst=0; brst<`DFI_MAX_BL; brst++) begin
   //       drive_seq.DATA[brst] = DATA[brst]); 
   //     end
   // end

    `uvm_send (drive_seq);
    //drive_seq.ADDR = {addr[6],{'b10110}};
    drive_seq.COMMAND =svt_dfi_drive_sequence::MRW_TWO;
    drive_seq.CAS_TWO_COMMAND =svt_dfi_drive_sequence::WR_TWO;
    drive_seq.CS= cs;
    `uvm_send (drive_seq);
    
    `svt_trace("svt_dfi_lpddr5_mrw_seq ","Ending of the sequence : svt_dfi_lpddr5_mrw_seq ");
   endtask
    
endclass: svt_dfi_lpddr5_mrw_seq 
`endif
//-----------END OF LINE -------------------------------------------//











