//==================================================================================================//
//-------------------------------------Description--------------------------------------------------//
//==================================================================================================//

//==================================================================================================//

`ifndef GUARD_SVT_DFI_ACT_WRAPPER_SEQ_SV
`define GUARD_SVT_DFI_ACT_WRAPPER_SEQ_SV
`include "svt_dfi_drive_sequence.sv"

class svt_dfi_act_wrapper_seq extends uvm_sequence#(svt_dfi_mc_transaction);
  
  `uvm_object_utils(svt_dfi_act_wrapper_seq)
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;

  bit ap = 0;
  int col_3bits = 3'b111;
  rand bit partial_rank;
  rand bit [`SVT_DFI_BANK_WIDTH-1:0]  ba;
  rand bit [`SVT_DFI_BANK_GROUP_WIDTH-1:0]    bg;
  rand bit [`SVT_DFI_MAX_ADDR_WIDTH-1:0]       row;
  rand bit [`SVT_DFI_MAX_ADDR_WIDTH-1:0]       col = $urandom_range(8,20) & ~col_3bits; 
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0]            cs;
  
  constraint cs_c {
    if(partial_rank) {
      cs inside { `SVT_DFI_CHIP_SELECT_WIDTH'hFCFC, `SVT_DFI_CHIP_SELECT_WIDTH'hF3F3};
    }
    else {
      cs inside {`SVT_DFI_CHIP_SELECT_WIDTH'hFEFE,
      `SVT_DFI_CHIP_SELECT_WIDTH'hFDFD,
      `SVT_DFI_CHIP_SELECT_WIDTH'hFBFB,
      `SVT_DFI_CHIP_SELECT_WIDTH'hF7F7,
      `SVT_DFI_CHIP_SELECT_WIDTH'h7F7F,
      `SVT_DFI_CHIP_SELECT_WIDTH'hEFEF,
      `SVT_DFI_CHIP_SELECT_WIDTH'hBFBF,
      `SVT_DFI_CHIP_SELECT_WIDTH'hDFDF
      };
    }
  }

  function new(string name = "svt_dfi_act_wrapper_seq");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_act_wrapper_seq","Starting of the sequence : svt_dfi_act_wrapper_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_act_wrapper_seq","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_act_wrapper_seq","Starting of the sequence : svt_dfi_act_wrapper_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_act_wrapper_seq","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_act_wrapper_seq","Starting of the sequence : svt_dfi_act_wrapper_seq");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_act_wrapper_seq", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end

    row[13:0] = $urandom_range(900,16384); row[16:14] = $urandom_range(0,7);
    ba  = $urandom_range(0,15);  bg  = $urandom_range(0,15);
    //this is the for first command
    //For 1-T mode, send the sequence without any modification 
    //For 2-T mode, send the sequence with CS = 1 (deasserted) & dont_drive_data_sigs = 1
    //FOr Geardown, send the seqeunce with CS = 0 (asserted)   & dont_drive_data_sigs = 1   
    if ((dfi_config.two_t_mode == 1) && (dfi_config.geardown_enabled == 0)) begin //not gd mode
      `uvm_do_on_with(drive_seq, p_sequencer.host_transaction_seqr, {COMMAND==ACT;
                                                                     CS=={`SVT_DFI_CHIP_SELECT_WIDTH{1'b1}};
                                                                     BANK==ba;
                                                                     ADDR==row;
                                                                     BG==bg;
                                                                     DEST==cs;});
      `svt_trace("svt_dfi_act_wrapper_seq",$psprintf("Sending Activate command for cs=8'h1, bank=%0x, row=%0x, bg=%0x, dest=%0x",this.ba,this.row,this.bg,this.cs));
    end
    else begin
      `uvm_do_on_with(drive_seq, p_sequencer.host_transaction_seqr, {COMMAND==ACT;
                                                                     CS==cs;
                                                                     BANK==ba;
                                                                     ADDR==row;
                                                                     BG==bg;
                                                                     DEST==cs;});
      `svt_trace("svt_dfi_act_wrapper_seq",$psprintf("Sending Activate command for cs=%0x, bank=%0x, row=%0x, bg=%0x, dest=%0x",this.cs,this.ba,this.row,this.bg,this.cs));
    end
     
    //this is the for second command
    //For 1-T mode, don't send this sequence 
    //For 2-T mode, send the sequence with CS = 0 (asserted)   & dont_drive_data_sigs = 0
    //FOr Geardown, send the seqeunce with CS = 0 (asserted)   & dont_drive_data_sigs = 0   
    if (dfi_config.two_t_mode == 1) begin //note when geardown_enabled = 1, two_t_mode has to be 1 & not vice versa
      `uvm_do_on_with(drive_seq, p_sequencer.host_transaction_seqr, {COMMAND==ACT;
                                                                     CS==cs;
                                                                     BANK==ba;
                                                                     ADDR==row;
                                                                     BG==bg;
                                                                     DEST==cs;});
      `svt_trace("svt_dfi_act_wrapper_seq",$psprintf("Sending Activate command for cs=%0x, bank=%0x, row=%0x, bg=%0x, dest=%0x",this.cs,this.ba,this.row,this.bg,this.cs));
    end

    `svt_trace("svt_dfi_act_wrapper_seq","Ending of the sequence : svt_dfi_act_wrapper_seq");
   endtask
    
endclass: svt_dfi_act_wrapper_seq
`endif // GUARD_SVT_DFI_ACT_WRAPPER_SEQ_SV
