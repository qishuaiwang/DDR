//==================================================================================================//
//-------------------------------------Description--------------------------------------------------//
//==================================================================================================//

//==================================================================================================//

`ifndef GUARD_SVT_DFI_NOP_WRAPPER_SEQ_SV
`define GUARD_SVT_DFI_NOP_WRAPPER_SEQ_SV
`include "svt_dfi_drive_sequence.sv"
`include "svt_dfi_base_wrapper_sequence.sv"

class svt_dfi_nop_wrapper_seq extends svt_dfi_base_wrapper_sequence#(svt_dfi_mc_transaction);
  
  `uvm_object_utils(svt_dfi_nop_wrapper_seq)
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;

  bit ap = 0;
  int col_3bits = 3'b111;
  bit [`SVT_DFI_BANK_WIDTH-1:0]  ba  = $urandom_range(0,15); 
  bit [`SVT_DFI_BANK_GROUP_WIDTH-1:0]    bg  = $urandom_range(0,15); 
  bit [`SVT_DFI_MAX_ADDR_WIDTH-1:0]       row = $urandom_range(0,200);
  bit [`SVT_DFI_MAX_ADDR_WIDTH-1:0]       col = $urandom_range(8,20) & ~col_3bits; 
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0]       cs,cs_1;
  
  constraint cs_c {
    cs inside {`SVT_DFI_CHIP_SELECT_WIDTH'h1,
      `SVT_DFI_CHIP_SELECT_WIDTH'hffff,
      `SVT_DFI_CHIP_SELECT_WIDTH'h2222,
      `SVT_DFI_CHIP_SELECT_WIDTH'h4444,
      `SVT_DFI_CHIP_SELECT_WIDTH'h8888,
      `SVT_DFI_CHIP_SELECT_WIDTH'h1010,
      `SVT_DFI_CHIP_SELECT_WIDTH'h2020,
      `SVT_DFI_CHIP_SELECT_WIDTH'h4040,
      `SVT_DFI_CHIP_SELECT_WIDTH'h8080,
      `SVT_DFI_CHIP_SELECT_WIDTH'hffff
    };
  }

  function new(string name = "svt_dfi_nop_wrapper_seq");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_nop_wrapper_seq","Starting of the sequence : svt_dfi_nop_wrapper_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_nop_wrapper_seq","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_nop_wrapper_seq","Starting of the sequence : svt_dfi_nop_wrapper_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_nop_wrapper_seq","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_nop_wrapper_seq","Starting of the sequence : svt_dfi_nop_wrapper_seq");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_nop_wrapper_seq", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end

    create_phyupd_cmds();
    poll_phyupd(phyupd_req_seen,phyupd_ack_seen);
    if(phyupd_ack_seen) handle_phyupd_req(); 
    cs_1 = ~cs;
    
    //this is the for first command
    //For 1-T mode, send the sequence without any modification 
    //For 2-T mode, send the sequence with CS = 1 (deasserted) & dont_drive_data_sigs = 1
    //FOr Geardown, send the seqeunce with CS = 0 (asserted)   & dont_drive_data_sigs = 1   
    if((dfi_config.two_t_mode == 1) && (dfi_config.geardown_enabled == 0)) begin //not gd mode
      `uvm_do_on_with(drive_seq, p_sequencer.host_transaction_seqr, {COMMAND==NOP;
                                                                     CS=={`SVT_DFI_CHIP_SELECT_WIDTH{1'b1}};
                                                                     BANK==local::ba;
                                                                     ADDR==local::row;
                                                                     BG==local::bg;
                                                                     DRIVE_DFI_LP_DATA_ASSERT_REQ==dfi_lp_data_assert_req;
                                                                     DRIVE_DFI_LP_DATA_DEASSERT_REQ==dfi_lp_data_deassert_req;
                                                                     DRIVE_WAKEUP_TIME==wakeup_time;});
      `svt_trace("svt_dfi_nop_wrapper_seq",$psprintf("Sending NOP command for cs='h1, bank=%0x, addr=%0x, bg=%0x, dfi_lp_data_assert_req=%0x, dfi_lp_data_deassert_req=%0x, wakeup_time=%0x",this.ba,this.row,this.bg,this.dfi_lp_data_assert_req,this.dfi_lp_data_deassert_req,this.wakeup_time));
    end
    else begin
      `uvm_do_on_with(drive_seq, p_sequencer.host_transaction_seqr, {COMMAND==NOP;
                                                                     CS==cs_1;
                                                                     BANK==local::ba;
                                                                     ADDR==local::row;
                                                                     BG==local::bg;
                                                                     DRIVE_DFI_LP_DATA_ASSERT_REQ==dfi_lp_data_assert_req;
                                                                     DRIVE_DFI_LP_DATA_DEASSERT_REQ==dfi_lp_data_deassert_req;
                                                                     DRIVE_WAKEUP_TIME==wakeup_time;});
      `svt_trace("svt_dfi_nop_wrapper_seq",$psprintf("Sending NOP command for ~cs=%0x, bank=%0x, addr=%0x, bg=%0x, dfi_lp_data_assert_req=%0x, dfi_lp_data_deassert_req=%0x, wakeup_time=%0x",this.cs_1,this.ba,this.row,this.bg,this.dfi_lp_data_assert_req,this.dfi_lp_data_deassert_req,this.wakeup_time));
    end
    
    //this is the for second command
    //For 1-T mode, don't send this sequence 
    //For 2-T mode, send the sequence with CS = 0 (asserted)   & dont_drive_data_sigs = 0
    //FOr Geardown, send the seqeunce with CS = 0 (asserted)   & dont_drive_data_sigs = 0   
    if (dfi_config.two_t_mode == 1) begin //note when geardown_enabled = 1, two_t_mode has to be 1 & not vice versa
      `uvm_do_on_with(drive_seq, p_sequencer.host_transaction_seqr, {COMMAND==NOP;
                                                                     CS==local::cs;
                                                                     BANK==local::ba;
                                                                     ADDR==local::row;
                                                                     BG==local::bg;
                                                                     DRIVE_DFI_LP_DATA_ASSERT_REQ==dfi_lp_data_assert_req;
                                                                     DRIVE_DFI_LP_DATA_DEASSERT_REQ==dfi_lp_data_deassert_req;
                                                                     DRIVE_WAKEUP_TIME==wakeup_time;});
      `svt_trace("svt_dfi_nop_wrapper_seq",$psprintf("Sending NOP command for cs='h1, bank=%0x, addr=%0x, bg=%0x, dfi_lp_data_assert_req=%0x, dfi_lp_data_deassert_req=%0x, wakeup_time=%0x",this.ba,this.row,this.bg,this.dfi_lp_data_assert_req,this.dfi_lp_data_deassert_req,this.wakeup_time));
    end
    handle_phyupd_req();
    `svt_trace("svt_dfi_nop_wrapper_seq","Ending of the sequence:svt_dfi_nop_wrapper_seq"); 
  endtask : body 
endclass: svt_dfi_nop_wrapper_seq
`endif
//-----------END OF LINE -------------------------------------------//
