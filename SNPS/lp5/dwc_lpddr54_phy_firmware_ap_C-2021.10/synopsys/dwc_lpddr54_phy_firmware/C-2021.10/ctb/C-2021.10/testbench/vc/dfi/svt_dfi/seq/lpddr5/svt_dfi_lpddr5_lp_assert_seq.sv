//==================================================================================================//
//-------------------------------------Description--------------------------------------------------//
//==================================================================================================//

//==================================================================================================//

`ifndef GUARD_SVT_DFI_LPDDR5_LP_ASSERT_SEQ_SV
`define GUARD_SVT_DFI_LPDDR5_LP_ASSERT_SEQ_SV
//`include "../env/svt_dfi_drive_sequence.sv"
`include "svt_dfi_init_wrapper_seq.sv"

class svt_dfi_lpddr5_lp_assert_seq extends uvm_sequence#(svt_dfi_mc_lpddr5_transaction);
  
  `uvm_object_utils(svt_dfi_lpddr5_lp_assert_seq)
  `uvm_declare_p_sequencer(svt_dfi_virtual_sequencer)

  svt_dfi_drive_sequence        drive_seq;
  svt_dfi_mc_configuration      dfi_config;
  svt_configuration             get_cfg;

  int lp_mode = 4;
  bit assert_en = 0;
  bit [3:0] dfi_lp_wakeup= 4'b0;
  bit [3:0] dfi_dram_clk_dis= 4'b0;
  int freq_ratio;
  
  function new(string name = "svt_dfi_lpddr5_lp_assert_seq");
    super.new(name);
  endfunction: new   

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_lpddr5_lp_assert_seq ","Starting of the sequence : svt_dfi_lpddr5_wr_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_lpddr5_lp_assert_seq ","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_lpddr5_lp_assert_seq ","Starting of the sequence : svt_dfi_lpddr5_wr_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_lpddr5_lp_assert_seq ","Dropped all objections");
    end
  endtask: post_body

  virtual task body();
    `svt_trace("svt_dfi_lpddr5_lp_assert_seq","Starting of the sequence : svt_dfi_lpddr5_lp_assert_seq");
    p_sequencer.get_host_cfg(get_cfg);
    if (!$cast(dfi_config, get_cfg)) begin
      `svt_fatal("svt_dfi_lpddr5_lp_assert_seq", "Unable to $cast the configuration to a svt_host_agent_configuration class");
    end
    `uvm_create_on(drive_seq, p_sequencer.host_transaction_seqr);
    
    if(assert_en) begin
      case(lp_mode)
        1:begin
            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_DATA_ASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_DATA_ASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_DATA_WAKEUP_TIME = 4'h2;
            `uvm_send (drive_seq);
          end
        2:begin
            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_CTRL_ASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_CTRL_ASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_CTRL_WAKEUP_TIME = 4'h4;
            `uvm_send (drive_seq);
          end
        3:begin 
            for (int i = 0 ; i < freq_ratio; i ++ ) begin
              drive_seq.CMD_PHASE = i ;
              drive_seq.DRIVE_DFI_DRAM_CLK_DIS = 1;
              drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_DRAM_CLK_DIS;
              `uvm_send (drive_seq);
              $display ( "Send clk_disable seq !!!");
            end    

            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_CTRL_ASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_CTRL_ASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_CTRL_WAKEUP_TIME = 4'h4;
            //drive_seq.DRIVE_DFI_DRAM_CLK_DIS = 1;
            `uvm_send (drive_seq);

            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_DATA_ASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_DATA_ASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_DATA_WAKEUP_TIME = 4'h2;
            //drive_seq.DRIVE_DFI_DRAM_CLK_DIS = 1;
            `uvm_send (drive_seq);
          end
        default:begin
            `uvm_send (drive_seq);
            $display ( "Invalid lp_mode !!!");
          end
      endcase
    end else begin
      case(lp_mode)
        1:begin
            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_DATA_DEASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_DATA_DEASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_DATA_WAKEUP_TIME = 4'h2;
            `uvm_send (drive_seq);
          end
        2:begin
            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_CTRL_DEASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_CTRL_DEASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_DATA_WAKEUP_TIME = 4'h4;
            `uvm_send (drive_seq);
          end
        3:begin 
            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_DATA_DEASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_DATA_DEASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_DATA_WAKEUP_TIME = 4'h2;
            `uvm_send (drive_seq);

            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_LP_CTRL_DEASSERT_REQ;
            drive_seq.DRIVE_DFI_LP_CTRL_DEASSERT_REQ = 1;
            drive_seq.DRIVE_DFI_LP_CTRL_WAKEUP_TIME = 4'h4;
            `uvm_send (drive_seq);

            repeat(drive_seq.DRIVE_DFI_LP_CTRL_WAKEUP_TIME) @(posedge top.dfi_ctl_clk);
            drive_seq.COMMAND = svt_dfi_drive_sequence::DFI_DRAM_CLK_EN;
            drive_seq.DRIVE_DFI_DRAM_CLK_EN = 1;
            `uvm_send (drive_seq);

          end
        default:$display ( "Invalid lp_mode !!!");
      endcase
    end
    //`svt_error("1111111111111111111111",$psprintf("drive_seq.DRIVE_DFI_LP_DATA_ASSERT_REQ = %d , drive_seq.DRIVE_DFI_LP_CTRL_ASSERT_REQ = %d , drive_seq.COMMAND = %s . ", drive_seq.DRIVE_DFI_LP_DATA_ASSERT_REQ,drive_seq.DRIVE_DFI_LP_CTRL_ASSERT_REQ,drive_seq.COMMAND));
    //`uvm_send (drive_seq);
    
    `svt_trace("svt_dfi_lpddr5_lp_assert_seq","Ending of the sequence:svt_dfi_lpddr5_lp_assert_seq"); 
  endtask : body 
endclass: svt_dfi_lpddr5_lp_assert_seq
`endif
//-----------END OF LINE -------------------------------------------//

