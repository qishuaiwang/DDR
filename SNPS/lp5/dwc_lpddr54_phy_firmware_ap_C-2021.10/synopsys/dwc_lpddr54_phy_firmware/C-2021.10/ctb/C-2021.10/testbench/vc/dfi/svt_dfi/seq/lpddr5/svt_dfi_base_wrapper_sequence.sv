// =============================================================================

`ifndef GUARD_SVT_DFI_BASE_WRAPPER_SEQUENCE_SV
`define GUARD_SVT_DFI_BASE_WRAPPER_SEQUENCE_SV
//`include "../env/svt_dfi_drive_sequence.sv"
//`include "../env/svt_dfi_poll_phyupd_req_wrapper_seq.sv"
//`include "../env/svt_dfi_phyupd_ack_assert_wrapper_seq.sv" 
//`include "../env/svt_dfi_lpddr4_phymstr_ack_assert_wrapper_seq.sv" 
//`include "../env/svt_dfi_lpddr4_sre_seq.sv" 
//`include "../env/svt_dfi_lpddr4_srx_seq.sv" 
//`include "../env/svt_dfi_lpddr4_pre_seq.sv" 
//`include "../env/svt_dfi_lpddr4_des_dummy_wrapper_seq.sv" 
//`include "../env/svt_dfi_lpddr4_poll_phymstr_sideband_req_wrapper_seq.sv" 
//`include "../env/svt_dfi_lpddr4_poll_phymstr_sideband_req_wrapper_seq.sv" 
//`include "../env/svt_dfi_poll_ctrlupd_req_wrapper_seq.sv"

//typedef class svt_dfi_des_wrapper_seq;
//typedef class svt_dfi_non_data_wrapper_seq;
/*==============================================================================================================================*/
//---------------------------------------virtual class svt_dfi_base_wrapper_sequence -------------------------------------------//
/*==============================================================================================================================*/
virtual class svt_dfi_base_wrapper_sequence #(type REQ=uvm_sequence_item, type RSP=REQ) extends uvm_sequence #(REQ,RSP);
  `uvm_field_utils_begin(svt_dfi_base_wrapper_sequence)
  `uvm_field_utils_end

  //`uvm_declare_p_sequencer(svt_dfi_mc_transaction_sequencer)
  bit enable_phymstr_handling=1;//decalring static as I need to share its value across different objects
  bit dfi_phymstr_ack_assert=0;//decalring static as I need to share its value across different objects
  bit dfi_phyupd_ack_assert=0;//decalring static as I need to share its value across different objects
  bit dfi_lp_ctrl_assert_req=0 ;
  bit dfi_lp_data_assert_req=0 ;
  bit dfi_lp_ctrl_deassert_req=0 ;
  bit dfi_lp_data_deassert_req=0 ;
  bit dfi_ctrlupd_assert_req=0 ;
  bit dfi_ctrlupd_deassert_req=0 ;
  //rand bit disable_dfi_ctrlupd_interval_assertion ;
  bit [3:0] wakeup_time;
  bit [10:0] dfi_ctrlupd_cnt;
  bit dfi_ctrlupd_ack_received ;
  bit  phyupd_req_seen;
  bit phyupd_ack_seen;
  bit ctrlupd_ack_seen;
  bit ctrlupd_req_seen;
  bit [63:0] writeloops;
  bit[5:0] cmd2sre_delay =40 ;

  svt_dfi_drive_sequence                 drive_seq;
  svt_dfi_mc_configuration               dfi_config;
  svt_configuration                      get_cfg;
  //svt_dfi_poll_phyupd_req_wrapper_seq    poll_phyupd_req_seq;
  //svt_dfi_lpddr4_poll_phymstr_sideband_req_wrapper_seq    poll_phymstr_sideband_req_seq;
  //svt_dfi_lpddr4_phymstr_ack_assert_wrapper_seq phymstr_ack_assert_seq;
  //svt_dfi_lpddr5_sre_seq dfi_lpddr5_sre_seq;
  //svt_dfi_lpddr5_srx_seq dfi_lpddr5_srx_seq;
  //svt_dfi_lpddr4_pre_seq dfi_lpddr4_pre_seq;
  //svt_dfi_lpddr4_des_dummy_wrapper_seq dfi_lpddr4_des_dummy_seq;
  //svt_dfi_phyupd_ack_assert_wrapper_seq  phyupd_ack_assert_seq;
  //svt_dfi_poll_ctrlupd_req_wrapper_seq   poll_ctrlupd_req_seq;
  //svt_dfi_des_wrapper_seq                des_wrapper_seq;
  //svt_dfi_non_data_wrapper_seq           non_data_wrapper_seq;

  typedef enum { 
    DES,
    NOP,
    MRS,
    ACT,
    RD,
    RDS_FOUR,
    RDS_EIGHT,
    RDA,
    RDAS_FOUR,
    RDAS_EIGHT,
    WR,
    WRS_FOUR,
    WRS_EIGHT,
    WRA,
    WRAS_FOUR,
    WRAS_EIGHT,
    WR_MRS,
    PRE,
    PREALL,
    REF,
    PDE_ZERO,
    PDE_ONE,
    PDX_ZERO,
    PDX_ONE,
    SRE,
    SRX,
    SRX_ZERO,
    SRX_ONE,
    NOP_CKE_ONE,
    NOP_CKE_ZERO,
    ZQCL,
    ZQCS,
    MRW,
    MRR,
    REFALL,
    NOP_ONE,
    DPDM_ONE,
    DPDM,
    DPDE,
    PDE,
    PDX,
    DES_CKE_ZERO,
    START_CK,
    STOP_CK,
    DFI_INIT,
    DFI_FREQ,
    DFI_DRAM_CLK_DIS,
    DFI_DRAM_CLK_EN,
    DFI_LP_CTRL_ASSERT_REQ,
    DFI_LP_DATA_ASSERT_REQ,
    DFI_LP_CTRL_DEASSERT_REQ,
    DFI_LP_DATA_DEASSERT_REQ,
    DFI_LP_CTRL_DATA_DEASSERT_REQ,
    DFI_CTRLUPD_REQ_ASSERT,
    DFI_CTRLUPD_REQ_DEASSERT,
    DFI_PHY_INITIATED_UPDATE,
    DFI_RESET_ASSERT,
    DFI_RESET_DEASSERT,
    DFI_PHYUPD_ACK_ASSERT, 
    DFI_PHYMSTR_ACK_ASSERT, 
    POLL_PHYUPD_REQ,
    POLL_CTRLUPD_REQ,
    POLL_PHYMSTR_SIDEBAND,
    POLL_SIDEBANDS,
    POLL_DFI_ERROR,
    SPL_OPCODE_1,
    SPL_OPCODE_2,
    SPL_OPCODE_3,
    GEARDOWN_SYNC,
    GEARDOWN_EN,
    GEARDOWN_DIS,
    MRW_ONE,
    MRW_TWO,
    MRR_ONE,
    ACT_ONE,
    ACT_TWO,
    WR_ONE,
    RD_ONE,
    CAS_TWO,
    MWR_ONE,
    MPC_ONE,
    MPC,
    RFU,
    SPL_OPCODE_ABYTE,
    NOPH,
    MN_PD_SR_DPD_NOP,
    MN_PD_SR_DPD,
    MISC_CMD,
    GEN_PHYMASTER_REQ,
    PDX_SRX_DPDX,
    UPDATE_FREQ_RATIO,
    PRESB,
    REFSB,
    WRP,
    ECS,
    MN_SR,
    MN_PD,
    XADR,
    XWRITE,
    PWRITE,
    SEND_STATUS,
    SREAD,
    XREAD,
    FLUSH,
    IOP
  } cmd;


  typedef enum {
    DDR4,
    DDR3,
    LPDDR4,
    LPDDR3,
    D4RDIMM,
    D3RDIMM,
    D4LRDIMM,
    DDR5,
    D5RDIMM,
    D5LRDIMM
  } ddr_mode_e;

  typedef enum {
    DFI_1_1 = 1,
    DFI_1_2 = 2,
    DFI_1_4 = 4
  } dfi_cmd_mode;

  typedef enum {
    WR_TWO,
    MWR_TWO,
    RD_TWO,
    MRR_TWO,
    MPC_TWO,
    INVALID
  } cas2_cmd;

  typedef enum {
    FIRST_CYCLE,
    SECOND_CYCLE
  } d5_cmd_cyc;

  bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] chip_sel;
  
  function new(string name = "svt_dfi_base_wrapper_sequence");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    uvm_phase phase;
    super.pre_body();
    `svt_trace("svt_dfi_base_wrapper_sequence","Starting of the sequence : svt_dfi_wr_rd_basic_wrapper_seq_1");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.raise_objection(this);
      `svt_debug("svt_dfi_base_wrapper_sequence","Raised all objections");
    end
  endtask: pre_body

  virtual task post_body();
    uvm_phase phase;
    super.post_body();
    `svt_trace("svt_dfi_base_wrapper_sequence","Starting of the sequence : svt_dfi_wr_rd_basic_wrapper_seq_2");
    `ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
    `else
       phase = starting_phase;
    `endif
    if (phase!=null) begin
      phase.drop_objection(this);
      `svt_debug("svt_dfi_base_wrapper_sequence","Dropped all objections");
    end
  endtask: post_body
  
  // ================================
  // Task : poll_phyupd 
  // ================================
  //task automatic poll_phyupd(output bit  req_seen, output bit ack_seen);
  //  `uvm_do(poll_phyupd_req_seq);
  //  req_seen = poll_phyupd_req_seq.REQ_SEEN;
  //  ack_seen = poll_phyupd_req_seq.ACK_SEEN;
  //endtask : poll_phyupd

  // ================================
  // Task : create_phyupd_cmds 
  // ================================
  //task automatic create_phyupd_cmds();
  //  `uvm_create(phyupd_ack_assert_seq);
  //  `uvm_create(poll_phyupd_req_seq);
  //  `uvm_create(poll_ctrlupd_req_seq);
  //endtask : create_phyupd_cmds
  
  //task automatic create_phymstr_sideband_cmds_lp4();
  //  `uvm_create(poll_phymstr_sideband_req_seq)
  //  `uvm_create(dfi_lpddr4_sre_seq)
  //  `uvm_create(dfi_lpddr4_srx_seq)
  //  `uvm_create(phymstr_ack_assert_seq)
  //  `uvm_create(dfi_lpddr4_des_dummy_seq)
  //  `uvm_create(dfi_lpddr4_pre_seq)
  //endtask : create_phymstr_sideband_cmds_lp4
  // ================================
  // Task : poll_ctrlupd 
  // ================================
  //task automatic poll_ctrlupd(output bit  req_seen, output bit ack_seen);
  //  `uvm_do(poll_ctrlupd_req_seq);
  //  req_seen = poll_ctrlupd_req_seq.REQ_SEEN;
  //  ack_seen = 0; 
  //endtask : poll_ctrlupd

  // ================================
  // Task : assert_phyupd_ack 
  // ================================
  //task automatic assert_phyupd_ack();
  //  if(dfi_config.assert_sideband_with_des == 1'b1) begin
  //    `uvm_do_with (des_wrapper_seq, {dfi_phyupd_ack_assert==1;});
  //  end 
  //  else begin
  //    `uvm_do(phyupd_ack_assert_seq);
  //  end
  //endtask : assert_phyupd_ack

  // ================================
  // Task : handle_phyupd_req 
  // ================================ 
  //task automatic handle_phyupd_req();
  //  poll_phyupd(phyupd_req_seen,phyupd_ack_seen);
  //  if(phyupd_req_seen) begin
  //    while((phyupd_req_seen) && !(dfi_config.is_warm_reset_asserted)) begin
  //      `uvm_do(non_data_wrapper_seq);
  //      poll_phyupd(phyupd_req_seen,phyupd_ack_seen);
  //    end
  //    repeat(1) begin
  //      `uvm_do(non_data_wrapper_seq);
  //      poll_phyupd(phyupd_req_seen,phyupd_ack_seen);
  //    end
  //  end
  //endtask : handle_phyupd_req

  
  // ================================
  // Task : poll_phymstr 
  // ================================
  //task automatic poll_phymstr_sband_lp4(output svt_dfi_driver_response_class driver_rsp );
  //  `uvm_do (poll_phymstr_sideband_req_seq)
  //  driver_rsp = poll_phymstr_sideband_req_seq.drv_rsp;
  //endtask : poll_phymstr_sband_lp4

  // ================================
  // Task : handle_phyupd_req 
  // ================================ 
  /*task automatic handle_phymstr_req_lp4();
    svt_dfi_driver_response_class local_drv_rsp;
    int tmp_addr=0;
    //if( !dfi_config.ignore_phymstr_req) begin
      poll_phymstr_sband_lp4(local_drv_rsp);
      if(local_drv_rsp.DFI_PHYMSTR_REQ && !local_drv_rsp.DFI_PHYMSTR_ACK && !local_drv_rsp.DFI_LP_CTRL_REQ && !local_drv_rsp.DFI_LP_DATA_REQ && !local_drv_rsp.DFI_CTRLUPD_REQ ) begin
        case(local_drv_rsp.DFI_PHYMSTR_STATE_SEL)
          1'b0 : begin   //put active DRAM ranks in IDLE state
        end
        
        1'b1 : begin   //put active DRAM ranks in self refresh state 
          repeat(60) begin
            `uvm_do(dfi_lpddr4_des_dummy_seq);
          end
            `uvm_do_with (dfi_lpddr4_pre_seq, {lp4_ab==1;
      cs == {`SVT_DFI_CHIP_SELECT_WIDTH{1'b1}} ;});

            //seqr.dfi_cfg.all_banks_closed = 1;
            tmp_addr = 0;
            //repeat(60) begin //BOZO Veera :Fix it later
              //VG cfg absent if(dfi_config.traffic_around_sideband == 1)
              //VG cfg absent   tmp_addr= tmp_addr +1;
              //VG cfg absent   `uvm_do_with (dfi_lpddr4_des_dummy_seq, {addr == tmp_addr;});
            //  end
            for(int i = 0;i<`SVT_DFI_CHIP_SELECT_WIDTH;i++) begin
              if(!local_drv_rsp.DFI_PHYMSTR_CS_STATE[i])   begin
                chip_sel[i] = 1'b1;
              end
           end
          `uvm_do_with (dfi_lpddr4_pre_seq, {
      cs == chip_sel ;});
          tmp_addr = 0;
          // VG cfg absent if(dfi_config.traffic_around_sideband == 1) begin
          // VG cfg absent   repeat(12) begin
          // VG cfg absent     tmp_addr= tmp_addr +1;
          // VG cfg absent     `uvm_do_with (dfi_lpddr4_des_dummy_seq, {addr == tmp_addr;});
          // VG cfg absent   end
          // VG cfg absent end
          // VG cfg absent else begin
            repeat(12) begin //adding DES to ensure SRE is completed before giving ack      
            `uvm_do_with (dfi_lpddr4_des_dummy_seq, {addr == tmp_addr;});
            end
          //VG end
        end
      endcase
      if(dfi_config.assert_sideband_with_des == 1'b1) begin
        `uvm_do_with (dfi_lpddr4_des_dummy_seq, {addr == 0;
        local_dfi_phymstr_ack_assert ==1'b1;});
        repeat(4) `uvm_do_with (dfi_lpddr4_des_dummy_seq, {
        local_dfi_phymstr_ack_assert ==1'b1;});
      end
      else begin
        `uvm_do(phymstr_ack_assert_seq);
      end
      case(local_drv_rsp.DFI_PHYMSTR_STATE_SEL)
        1'b0 : begin   //put active DRAM ranks in IDLE state
        end
        
        1'b1 : begin
          `uvm_do_with (dfi_lpddr4_srx_seq, {cs== 'h0404;});
           repeat(10) begin //adding DES to ensure SRE is completed before giving ack
             `uvm_do(dfi_lpddr4_des_dummy_seq);
          end
        end
        
      endcase 
      end
    //end
  endtask :handle_phymstr_req_lp4 */
endclass 

`endif
//-----------END OF LINE -------------------------------------------//

