//==================================================================================================//
//-------------------------------------Description--------------------------------------------------//
//==================================================================================================//

//==================================================================================================//

`ifndef GUARD_SVT_DFI_DRAM_CLK_DISABLE_SEQ_SV
`define GUARD_SVT_DFI_DRAM_CLK_DISABLE_SEQ_SV
//`include "../env/svt_dfi_drive_sequence.sv"
`include "svt_dfi_base_wrapper_sequence.sv"

class svt_dfi_dram_clk_disable_seq extends svt_dfi_base_wrapper_sequence#(svt_dfi_mc_transaction);
  
  `uvm_object_utils(svt_dfi_dram_clk_disable_seq)
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;

  int col_3bits = 3'b111;
  bit [`DFI_MAX_BANK_ADDRESS_WIDTH-1:0]  ba  = $urandom_range(0,15); 
  bit [`DFI_MAX_BANK_GROUP_WIDTH-1:0]    bg  = $urandom_range(0,15); 
  bit [`DFI_MAX_ADDRESS_WIDTH-1:0]       row = $urandom_range(0,200);
  bit [`DFI_MAX_ADDRESS_WIDTH-1:0]       col = $urandom_range(8,20) & ~col_3bits; 
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0]       cs;
  
  //constraint cs_c {
  //  cs inside {`SVT_DFI_CHIP_SELECT_WIDTH'h1,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'hffff,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'h2222,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'h4444,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'h8888,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'h1010,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'h2020,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'h4040,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'h8080,
  //    `SVT_DFI_CHIP_SELECT_WIDTH'hffff
  //  };
  //}

  function new(string name = "svt_dfi_dram_clk_disable_seq");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_dram_clk_disable_seq","Starting of the sequence : svt_dfi_dram_clk_disable_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_dram_clk_disable_seq","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_dram_clk_disable_seq","Starting of the sequence : svt_dfi_dram_clk_disable_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_dram_clk_disable_seq","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_dram_clk_disable_seq","Starting of the sequence : svt_dfi_dram_clk_disable_seq");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_dram_clk_disable_seq", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end

    `uvm_create_on(drive_seq, p_sequencer.host_transaction_seqr);
    
    //if(dfi_config.enhanced_vip_arch== 1) begin //not gd mode
    //  $cast(drive_seq.COMMAND, MISC_CMD);
    //end
    //else begin
      $cast(drive_seq.COMMAND, DFI_DRAM_CLK_DIS);
    //end
    
    drive_seq.CS = {`DFI_MAX_CS_WIDTH{1'b1}};
    drive_seq.DRIVE_DFI_DRAM_CLK_DIS = 1;
    `uvm_send (drive_seq);
    
    `svt_trace("svt_dfi_dram_clk_disable_seq","Ending of the sequence:svt_dfi_dram_clk_disable_seq"); 
  endtask : body 
endclass: svt_dfi_dram_clk_disable_seq
`endif
//-----------END OF LINE -------------------------------------------//

