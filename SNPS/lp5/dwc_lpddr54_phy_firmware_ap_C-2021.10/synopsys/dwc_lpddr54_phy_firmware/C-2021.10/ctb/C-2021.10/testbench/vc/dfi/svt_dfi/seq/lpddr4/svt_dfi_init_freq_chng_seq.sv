
`ifndef GUARD_SVT_DFI_INIT_FREQ_CHNG_SEQ_SV
`define GUARD_SVT_DFI_INIT_FREQ_CHNG_SEQ_SV
//`include "../env/svt_dfi_drive_sequence.sv"

class svt_dfi_init_freq_chng_seq  extends uvm_sequence#(svt_dfi_mc_transaction);
  rand bit [`DFI_MAX_ADDRESS_WIDTH-1:0] addr;
  rand bit [`DFI_MAX_BANK_ADDRESS_WIDTH-1:0] bank;
  rand bit [4:0] dfi_freq;
  rand bit [1:0] dfi_fsp ;

  `uvm_object_utils(svt_dfi_init_freq_chng_seq )
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;

  bit ap = 0;
  int col_3bits = 3'b111;
  rand bit partial_rank;
  rand bit [`DFI_MAX_BANK_ADDRESS_WIDTH-1:0]  ba;
  rand bit [`DFI_MAX_BANK_GROUP_WIDTH-1:0]    bg;
  rand bit [`DFI_MAX_ADDRESS_WIDTH-1:0]       row;
  rand bit [`DFI_MAX_ADDRESS_WIDTH-1:0]       col = $urandom_range(8,20) & ~col_3bits; 
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0]            cs;
  
  bit remain_in_lp2 = 0;

  function new(string name = "svt_dfi_init_freq_chng_seq ");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_init_freq_chng_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_init_freq_chng_seq ","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_init_freq_chng_seq ","Starting of the sequence : svt_dfi_act_wrapper_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_init_freq_chng_seq ","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_init_freq_chng_seq ","Starting of the sequence : svt_dfi_init_freq_chng_seq ");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_init_freq_chng_seq ", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end
		 `uvm_create_on(drive_seq,p_sequencer.host_transaction_seqr);
		 drive_seq.FREQ.rand_mode(0);
		 drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_FREQ;
		 drive_seq.FREQ = dfi_freq;
		 drive_seq.FSP = dfi_fsp;
    drive_seq.REMAIN_IN_LP2 = this.remain_in_lp2;
		`uvm_send(drive_seq);
    `svt_trace("svt_dfi_init_freq_chng_seq ",$psprintf("Ending of the sequence : svt_dfi_init_freq_chng_seq with DFI_FREQ=%d",dfi_freq));
   endtask
    
endclass: svt_dfi_init_freq_chng_seq 
`endif
//-----------END OF LINE -------------------------------------------//
