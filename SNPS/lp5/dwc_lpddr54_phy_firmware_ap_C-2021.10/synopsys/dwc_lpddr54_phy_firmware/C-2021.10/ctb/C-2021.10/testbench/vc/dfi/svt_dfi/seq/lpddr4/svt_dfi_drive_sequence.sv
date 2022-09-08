//-----------------------------------------------------------------------------
// COPYRIGHT (C) 2015 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// =============================================================================

`ifndef GUARD_SVT_DFI_DRIVE_SEQUENCE_SV
`define GUARD_SVT_DFI_DRIVE_SEQUENCE_SV
  
class svt_dfi_drive_sequence extends uvm_sequence#(svt_dfi_mc_transaction);

  `uvm_object_utils(svt_dfi_drive_sequence)
  `uvm_declare_p_sequencer(svt_dfi_mc_transaction_sequencer)
   
  bit REMAIN_IN_LP2 = 0;
  rand bit [7:0] LP3_OP;
  rand bit [1:0] LP3_RFU;
  rand bit       LP3_AP;
  rand bit       LP3_AB;
  rand bit [7:0] D5_OP;
  rand bit       D5_CW;
  rand bit D5_AP;//auto prechange in LP4
  rand bit D5_WR_PARTIAL;//auto prechange in LP4
  rand bit D5_BC8;
  
  rand bit LP4_AP;//auto prechange in LP4
  rand bit LP4_AB;//auto prechange in LP4
  rand bit [7:0] LP4_OP;

  bit [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0] VLD_DBYTE = {`SVT_DFI_DATA_ENABLE_WIDTH{1'b1}};
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] CKE = {`SVT_DFI_CHIP_SELECT_WIDTH{1'b1}};
  rand bit [4:0] FREQ;
  rand bit [1:0] FSP;
  rand bit [11:0] BL;
  rand bit DRIVE_DFI_RESET_DEASSERT;
  rand bit DRIVE_START_CK;
  rand bit [`SVT_DFI_BANK_WIDTH-1:0] BANK;
  rand bit [`SVT_DFI_BANK_GROUP_WIDTH-1:0] BG;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] CS;
  rand bit [`SVT_DFI_CID_WIDTH-1:0] CID;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] DAT_CS;
  rand bit [`SVT_DFI_CHIP_SELECT_WIDTH-1:0] DEST;
  rand bit [`SVT_DFI_MAX_ADDR_WIDTH-1:0] ADDR;
  rand bit DRIVE_DISABLE_DFI_CTRLUPD_INTERVAL_ASSERTION;
  bit DRIVE_DONT_DRIVE_DATA_SIGS;
  bit GEARDOWN_DISABLE;
  bit DRIVE_DFI_LP_CTRL_ASSERT_REQ;
  bit DRIVE_DFI_LP_CTRL_DEASSERT_REQ;
  bit DRIVE_DFI_CTRLUPD_ASSERT_REQ;
  bit DRIVE_DFI_CTRLUPD_DEASSERT_REQ;
  bit DRIVE_DFI_PHYUPD_ACK_ASSERT;
  bit DRIVE_DFI_LP_DATA_ASSERT_REQ ;
  bit DRIVE_DFI_LP_DATA_DEASSERT_REQ ;
  bit DRIVE_DFI_PHYMSTR_ACK_ASSERT ;
  bit [`DFI_MAX_LP_WAKEUP_WIDTH-1:0] DRIVE_WAKEUP_TIME;
  bit [`DFI_MAX_LP_WAKEUP_WIDTH-1:0] DRIVE_DFI_LP_CTRL_WAKEUP_TIME;
  bit [`DFI_MAX_LP_WAKEUP_WIDTH-1:0] DRIVE_DFI_LP_DATA_WAKEUP_TIME;
  bit DRIVE_DFI_DRAM_CLK_DIS;
  bit DRIVE_DFI_DRAM_CLK_EN;
  bit [1:0] CMD_PHASE;
  rand reg [(`SVT_DFI_DATA_ENABLE_WIDTH * 8 -1) : 0]  DATA[];
  rand reg [(`SVT_DFI_DATA_ENABLE_WIDTH     -1) : 0]  DATA_VALID[]; //this is the dfi_rddata_valid which will be used to process the dfi_rddata
  rand bit [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0]      DM[];
  logic RD_BF_WR;
 rand bit LP4_OTF_BL;//LP4 spec MR1[1:0] == 2

  /**Declaring the handles for svt_dfi_configuration & svt_dfi_host_transaction classes.**/
  svt_dfi_mc_agent_configuration       dfi_mc_config;
  svt_configuration                    get_cfg;
  svt_dfi_mc_transaction               dfi_mc_trans;

  //----------------------------------------------------------------------------
  // Enumerated Types
  //----------------------------------------------------------------------------
  /** Transaction command enum */

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
  } cmd_type;
  
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
    D5LRDIMM,
    D4NVDIMMP
  } ddr_mode_type;
  
  typedef enum {
    DFI_1_1 = 1,
    DFI_1_2 = 2,
    DFI_1_4 = 4
  } dfi_cmd_mode_type;
 typedef enum {
    WR_TWO                     = `SVT_DFI_CAS2_WR_TWO,                        /**< SECOND CYCLE WRITE COMMAND*/
    MWR_TWO                    = `SVT_DFI_CAS2_MWR_TWO,                       /**< SECOND CYCLE MASK WRITE COMMAND*/
    RD_TWO                     = `SVT_DFI_CAS2_RD_TWO,                        /**< SECOND CYCLE READ COMMAND*/
    MRR_TWO                    = `SVT_DFI_CAS2_MRR_TWO,                       /**< SECOND CYCLE MODE REGISTER READ COMMAND*/
    MPC_TWO                    = `SVT_DFI_CAS2_MPC_TWO,                       /**< SECOND CYCLE MULTI PURPOSE COMMAND*/
    INVALID                    = `SVT_DFI_CAS2_INVALID                        /**< INVALID COMMAND set by default for single cycle command or non cas2 command*/
    } cas2_cmd_type; 
  
  typedef enum {
    FIRST_CYCLE,
    SECOND_CYCLE
  } d5_cmd_cyc_type;

  rand cmd_type          COMMAND;
  rand ddr_mode_type     DDR_MODE_COMMAND;
  rand dfi_cmd_mode_type DFI_MODE_COMMAND;
  cas2_cmd_type     CAS_TWO_COMMAND = INVALID;
  d5_cmd_cyc_type   D5_COMMAND   = FIRST_CYCLE;

  extern function new(string name = "svt_dfi_drive_sequence");

  virtual task body();
    `svt_trace("svt_dfi_drive_sequence","Starting of the sequence:svt_dfi_drive_sequence");
    p_sequencer.get_cfg(get_cfg);
    if (!$cast(dfi_mc_config, get_cfg)) begin
      `svt_fatal("svt_dfi_drive_sequence", "Unable to $cast the configuration to a svt_dfi_mc_agent_configuration class");
    end

    `uvm_create(dfi_mc_trans);
    /**Mapping the COMMAND assigned from the wrapper sequence onto the sequence_item's/host transaction item's cmd_e**/
    if(!$cast(dfi_mc_trans.cmd_e, COMMAND)) begin
      `svt_error("svt_dfi_drive_sequence",$psprintf("[cmd_e] Cast failed during base_seq command %s assigning to transaction's item", COMMAND));
    end
//    /**Mapping the DDR_MODE_COMMAND assigned from the wrapper sequence onto the sequence_item's/host transaction item's cmd_type**/
//    if(!$cast(dfi_mc_trans.cmd_e, DDR_MODE_COMMAND)) begin
//      `svt_error("svt_dfi_drive_sequence",$psprintf("Cast failed during base_seq command %s assigning to transaction's item", DDR_MODE_COMMAND));
//    end
//    /**Mapping the cmd_type assigned from the wrapper sequence onto the sequence_item's/host transaction item's cmd_type**/
//    if(!$cast(dfi_mc_trans.cmd_e, DFI_MODE_COMMAND)) begin
//      `svt_error("svt_dfi_drive_sequence",$psprintf("Cast failed during base_seq command %s assigning to transaction's item", COMMAND));
//    end
    /**Mapping the CAS_TWO_COMMAND assigned from the wrapper sequence onto the sequence_item's/host transaction item's cas2_cmd_e**/
    if(!$cast(dfi_mc_trans.cas2_cmd_e, CAS_TWO_COMMAND)) begin
      `svt_error("svt_dfi_drive_sequence",$psprintf("[cas2_cmd_e] Cast failed during base_seq command %s assigning to transaction's item", CAS_TWO_COMMAND));
    end
    /**Mapping the D5_COMMAND assigned from the wrapper sequence onto the sequence_item's/host transaction item's d5_cmd_cyc_e**/
    if(!$cast(dfi_mc_trans.d5_cmd_cyc_e, D5_COMMAND)) begin
      `svt_error("svt_dfi_drive_sequence",$psprintf("[d5_cmd_cyc_e] Cast failed during base_seq command %s assigning to transaction's item", D5_COMMAND));
    end
    `svt_trace("svt_dfi_drive_sequence",$psprintf("The requested command COMMAND %s mapped onto the transaction item's command type %s", COMMAND, dfi_mc_trans.cmd_e));
    dfi_mc_trans.freq=this.FREQ;
    dfi_mc_trans.dfi_freq_fsp=this.FSP;
    dfi_mc_trans.dfi_reset_deassert=this.DRIVE_DFI_RESET_DEASSERT;
    dfi_mc_trans.start_ck=this.DRIVE_START_CK;
    dfi_mc_trans.bank=this.BANK;
    dfi_mc_trans.addr=this.ADDR;
    dfi_mc_trans.bl=this.BL;
    dfi_mc_trans.bg=this.BG;
    dfi_mc_trans.cs=this.CS;
    dfi_mc_trans.dat_cs=this.DAT_CS;
    dfi_mc_trans.cid=this.CID;
    dfi_mc_trans.dest=this.DEST;
    dfi_mc_trans.cke=this.CKE;
    dfi_mc_trans.rd_bf_wr=this.RD_BF_WR;
    dfi_mc_trans.dfi_lp_ctrl_assert_req = this.DRIVE_DFI_LP_CTRL_ASSERT_REQ;
    dfi_mc_trans.dfi_lp_ctrl_deassert_req = this.DRIVE_DFI_LP_CTRL_DEASSERT_REQ;
  `ifdef DFI_SVT_DFI5
    dfi_mc_trans.dfi_lp_ctrl_wakeup = this.DRIVE_DFI_LP_CTRL_WAKEUP_TIME;
    dfi_mc_trans.dfi_lp_data_wakeup = this.DRIVE_DFI_LP_DATA_WAKEUP_TIME;
  `else
    dfi_mc_trans.dfi_lp_wakeup = this.DRIVE_WAKEUP_TIME;
  `endif
    dfi_mc_trans.dfi_ctrlupd_assert_req = this.DRIVE_DFI_CTRLUPD_ASSERT_REQ;
    dfi_mc_trans.dfi_ctrlupd_deassert_req = this.DRIVE_DFI_CTRLUPD_DEASSERT_REQ;
    dfi_mc_trans.dfi_phyupd_ack_assert = this.DRIVE_DFI_PHYUPD_ACK_ASSERT;
    dfi_mc_trans.disable_dfi_ctrlupd_interval_assertion = this.DRIVE_DISABLE_DFI_CTRLUPD_INTERVAL_ASSERTION;
    dfi_mc_trans.dfi_lp_data_assert_req = this.DRIVE_DFI_LP_DATA_ASSERT_REQ;
    dfi_mc_trans.dfi_lp_data_deassert_req = this.DRIVE_DFI_LP_DATA_DEASSERT_REQ;
    dfi_mc_trans.dfi_phymstr_ack_assert = this.DRIVE_DFI_PHYMSTR_ACK_ASSERT;
    dfi_mc_trans.dont_drive_data_sigs = this.DRIVE_DONT_DRIVE_DATA_SIGS;
    dfi_mc_trans.geardown_dis= this.GEARDOWN_DISABLE;
    dfi_mc_trans.dfi_dram_clk_disable= this.DRIVE_DFI_DRAM_CLK_DIS;
    dfi_mc_trans.cmd_phase = this.CMD_PHASE;
    dfi_mc_trans.dfi_dram_clk_en= this.DRIVE_DFI_DRAM_CLK_EN;
    `ifdef LPDDR4
    dfi_mc_trans.data = new[dfi_mc_trans.bl];
    dfi_mc_trans.dm= new[dfi_mc_trans.bl];
    dfi_mc_trans.lp4_op= this.LP4_OP;
    `else
    dfi_mc_trans.data = new[`DFI_MAX_BL];
    dfi_mc_trans.dm= new[`DFI_MAX_BL];
    `endif
    if((COMMAND == WR) || (COMMAND == WRA) || (COMMAND == WRS_FOUR) || (COMMAND == WRAS_FOUR) || (COMMAND == WRS_EIGHT) || (COMMAND == WRAS_EIGHT) || (COMMAND == WR_ONE) || (COMMAND == MWR_ONE) || (COMMAND == CAS_TWO && (CAS_TWO_COMMAND == WR_TWO || CAS_TWO_COMMAND == MWR_TWO ))) begin
      foreach (dfi_mc_trans.data[i]) begin
      dfi_mc_trans.data[i] = this.DATA[i];
      dfi_mc_trans.dm[i] = this.DM[i];
      end
end
    dfi_mc_trans.lp4_ap = this.LP4_AP;
    dfi_mc_trans.lp4_ab = this.LP4_AB;
    dfi_mc_trans.lp4_op = this.LP4_OP;
    dfi_mc_trans.lp4_otf_bl = this.LP4_OTF_BL;
    dfi_mc_trans.lp3_ap = this.LP3_AP;
    dfi_mc_trans.lp3_ab = this.LP3_AB;
    dfi_mc_trans.lp3_op = this.LP3_OP;
    dfi_mc_trans.lp3_rfu = this.LP3_RFU;
    dfi_mc_trans.remain_in_lp2= this.REMAIN_IN_LP2;

    `svt_trace("svt_dfi_drive_sequence", $sformatf("Following Transaction Ready to go onto the sequencer\n%s", dfi_mc_trans.sprint()));
    `uvm_send(dfi_mc_trans);
    //dfi_mc_trans.print(); //Debug for transaction configuration
    if(dfi_mc_trans.cmd_e.name != "DES") begin
      $display("[%0t]: <%m>, send command in driver: %s, cs=%0b",$time,dfi_mc_trans.cmd_e.name,dfi_mc_trans.cs);
    end

    `svt_trace("svt_dfi_drive_sequence","Ending of the sequence:svt_dfi_drive_sequence");
  endtask : body

endclass:svt_dfi_drive_sequence
   
function svt_dfi_drive_sequence::new(string name="svt_dfi_drive_sequence");
  super.new(name);
endfunction:new
`endif
//-----------END OF LINE -------------------------------------------//

