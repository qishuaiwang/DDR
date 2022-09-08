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
  rand bit LP4_AB;//all bank in LP4
  rand bit [7:0] LP4_OP;

  rand bit LP5_AP;//auto prechange in LP5
  rand bit LP5_AB;//all bank in LP5
  rand bit LP5_PD;//sre with pd  
  rand bit LP5_DSM;//sre with dsm  
  rand bit [7:0] LP5_OP;
  rand bit LP5_WS_WR;
  rand bit LP5_WS_RD;
  rand bit LP5_WS_FS;
  rand bit [3:0] DC;
  rand bit B3;


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
  rand reg [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0]      DM[];
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
    DES                          = `SVT_DFI_MC_DES,                             /**< Device deselect command  for DDR2, DDR3 , DDR4 , LPDDR4 , LPDDR5 and DDR5 */
    NOP                          = `SVT_DFI_MC_NOP,                             /**< NOP Command */
    MRS                          = `SVT_DFI_MC_MRS,                             /**< Mode Register Set command for DDR2, DDR3 and DDR4*/
    ACT                          = `SVT_DFI_MC_ACTIVE,                          /**< ACTIVE Command */
    RD_ZERO                      = `SVT_DFI_MC_READ0,                           /**< READ Command*/                         
    RDS_FOUR                     = `SVT_DFI_MC_READ4,                           /**< READ Command with burst length 4 */
    RDS_EIGHT                    = `SVT_DFI_MC_READ8,                           /**< READ Command with burst length 8 */
    RDA                          = `SVT_DFI_MC_READ_AP,                         /**< READ Command with Auto Precharge */
    RDAS_FOUR                    = `SVT_DFI_MC_READ_AP4,                        /**< READ Command With burst length 4 and with auto precharge */
    RDAS_EIGHT                   = `SVT_DFI_MC_READ_AP8,                        /**< READ Command with burst length 8 with auto precharge */
    RDS_THIRTY_TWO               = `SVT_DFI_MC_READ32,                          /**< READ Command with burst length 16 in LPDDR5*/
    RDS_SIXTEEN                  = `SVT_DFI_MC_READ16,                          /**< READ Command with burst length 32 in LPDDR5 */
    WR                           = `SVT_DFI_MC_WRITE,                           /**< WRITE Command */
    WRS_FOUR                     = `SVT_DFI_MC_WRITE4,                          /**< WRITE Command with burst length 4  */
    WRS_EIGHT                    = `SVT_DFI_MC_WRITE8,                          /**< WRITE Command with burst length 8 */
    WRA                          = `SVT_DFI_MC_WRITE_AP,                        /**< WRITE Command with Auto Precharge */
    WRAS_FOUR                    = `SVT_DFI_MC_WRITE_AP4,                       /**< WRITE Command With bust length 4 and with auto precharge*/
    WRAS_EIGHT                   = `SVT_DFI_MC_WRITE_AP8,                       /**< WRITE Command with burst length 8 with auto precharge*/
    WRS_THIRTY_TWO               = `SVT_DFI_MC_WRITE16,                         /**< WRITE Command with burst length 16 in LPDDR5*/
    WRS_SIXTEEN                  = `SVT_DFI_MC_WRITE32,                         /**< WRITE Command with burst length 32 in LPDDR5*/
    WR_MRS                       = `SVT_DFI_MC_WR_MRS,                          /**< MODE Register Write for DDR4*/
    PRE                          = `SVT_DFI_MC_PRECHARGE,                       /**< PRECHARGE Command for activated bank */
    PREALL                       = `SVT_DFI_MC_PRECHARGE_ALL,                   /**< PRECHARGE Command  for all banks */
    REF                          = `SVT_DFI_MC_REFRESH_PER_BANK,                /**< REFRESH Command for per bank */
    PDE_ZERO                     = `SVT_DFI_MC_POWER_DOWN_ENTRY0,               /**< POWER DOWN Entry with cke value 0 */
    PDE_ONE                      = `SVT_DFI_MC_POWER_DOWN_ENTRY1,               /**< POWER DOWN Entry with cke value 1 */
    PDX_ZERO                     = `SVT_DFI_MC_POWER_DOWN_EXIT0,                /**< POWER DOWN Exit with cke value 0 */
    PDX_ONE                      = `SVT_DFI_MC_POWER_DOWN_EXIT1,                /**< POWER DOWN Exit with cke value 1 */
    SRE                          = `SVT_DFI_MC_SELF_REFRESH_ENTRY,              /**< SELF_REFRESH_ENTRY Command for DDR3,DDR4,DDR5,LPDDR2 and LPDDR3,LPDDR4,LPDDR5 */
    SRX                          = `SVT_DFI_MC_SELF_REFRESH_EXIT,               /**< SELF REFRESH EXIT*/
    SRX_ZERO                     = `SVT_DFI_MC_SELF_REFRESH_EXIT0,              /**< SELF REFRESH EXIT with cke 0*/
    SRX_ONE                      = `SVT_DFI_MC_SELF_REFRESH_EXIT1,              /**< SELF REFRESH EXIT with cke 1*/
    NOP_CKE_ONE                  = `SVT_DFI_MC_NOP_CKE1,                        /**< NOP_CKE1 command*/
    NOP_CKE_ZERO                 = `SVT_DFI_MC_NOP_CKE0,                        /**< NOP_CKE0 command*/
    ZQCL                         = `SVT_DFI_MC_ZQCL,                            /**< ZQ calibration long command for DDR2, DDR3 and DDR4 */
    ZQCS                         = `SVT_DFI_MC_ZQCS,                            /**< ZQ calibration short command for DDR2, DDR3 and DDR4 */
    MRW                          = `SVT_DFI_MC_MRW,                             /**< Mode Register Write Command for DDR5,LPDDR2 and LPDDR3 */                          
    MRR                          = `SVT_DFI_MC_MRR,                             /**< Mode Register Read Command for DDR5,LPDDR2,LPDDR3 and LPDDR5*/ 
    REFALL                       = `SVT_DFI_MC_REFRESH_ALL_BANK,                /**< REFRESH Command for all banks */                      
    NOP_ONE                      = `SVT_DFI_MC_NOP1,                            /**< NOP1*/             
    DPDM_ONE                     = `SVT_DFI_MC_DEEP_POWER_DOWN1,                /**< DEEP POWER DOWN LPDDR2 related cmd */
    DPDM                         = `SVT_DFI_MC_DEEP_POWER_DOWN,                 /**< DEEP POWER DOWN LPDDR2 related cmd */
    DPDE                         = `SVT_DFI_MC_DEEP_POWER_DOWN_ENTRY,           /**< DEEP POWER DOWN ENTRY*/
    PDE                          = `SVT_DFI_MC_POWER_DOWN_ENTRY,                /**< POWER_DOWN_ENTRY Command for DDR3,DDR4,DDR5,LPDDR2,LPDDR3,LPDDR4 and LPDDR5*/ 
    PDX                          = `SVT_DFI_MC_POWER_DOWN_EXIT,                 /**< POWER_DOWN_EXIT Command for DDR3,DDR4,DDR5,LPDDR2,LPDDR3 and LPDDR4 */
    DES_CKE_ZERO                 = `SVT_DFI_MC_DES_CKE0,                        /**< Deselect with cke value 0 for DDR3,DDR4,DDR5,LPDDR2,LPDDR3,LPDDR4 and LPDDR5*/                
    START_CK                     = `SVT_DFI_MC_START_CK,                        /**< DFI SPECIFIC COMMANDS Memory Active controller will assert dfi_cke_p signals on control interface.*/                    
    STOP_CK                      = `SVT_DFI_MC_STOP_CK,                         /**< DFI SPECIFIC COMMANDS Memory Active controller will assert dfi_cke_p signals on control interface.*/ 
    DFI_XIFY                     = `SVT_DFI_MC_DFI_XIFY,                         /**< DFI SPECIFIC COMMANDS (for HBM) memory Active controller will drive its output signals 'x*/                     
    DFI_INIT                     = `SVT_DFI_MC_DFI_INIT,                        /**< DFI SPECIFIC COMMANDS Memory Active controller will initiate the dfi initialization process by asserting dfi_init_start on status interface and will wait for phy to assert dfi_init_complete.*/    
    DFI_SETUP                    = `SVT_DFI_MC_DFI_SETUP,                       /**< DFI SPECIFIC COMMANDS (for HBM) memory Active controller will drive dram_clk_disable,deassert reset, deassert init_start*/
    DFI_FREQ                     = `SVT_DFI_MC_DFI_FREQ,                        /**< DFI SPECIFIC COMMANDS This command is used to change the dfi_frequency value on status interface. Memory Active Controller will deassert the dfi_init_start signal to change the dfi_frequency value and again will assert dfi_init_start signal*/    
    DFI_DRAM_CLK_DIS             = `SVT_DFI_MC_DFI_DRAM_CLK_DIS,                /**< DFI SPECIFIC COMMANDS Memory Active controller drives dfi_dram_clk_disable signal on status interface with the value set in the configuration parameter  dfi_dram_ckdisable_val.*/                           
    DFI_DRAM_CLK_EN              = `SVT_DFI_MC_DFI_DRAM_CLK_EN,                 /**< DFI SPECIFIC COMMANDS Memory Active controller drives dfi_dram_clk_disable signal on status interface with '0 value*/               
    DFI_LP_CTRL_ASSERT_REQ       = `SVT_DFI_MC_DFI_LP_CTRL_ASSERT_REQ,          /**< DFI SPECIFIC COMMANDS Memory Active Controller asserts dfi_lp_ctrl_req signal on low power interface and updateds dfi_lp_wakeup  signal with the value of transaction class item "dfi_lp_wakeup*/   
    DFI_LP_DATA_ASSERT_REQ       = `SVT_DFI_MC_DFI_LP_DATA_ASSERT_REQ,          /**< DFI SPECIFIC COMMANDS Memory Active Controller asserts dfi_lp_data_req signal on low power interface and updateds dfi_lp_wakeup  signal with the value of transaction class item "dfi_lp_wakeup*/     
    DFI_LP_CTRL_DEASSERT_REQ     = `SVI_DFI_MC_DFI_LP_CTRL_DEASSERT_REQ,        /**< DFI SPECIFIC COMMANDS Memory Active Controller deasserts dfi_lp_ctrl_req signal on low power interface and updates dfi_lp_wakeup with value x */ 
    DFI_LP_DATA_DEASSERT_REQ     = `SVI_DFI_MC_DFI_LP_DATA_DEASSERT_REQ,        /**< DFI SPECIFIC COMMANDS Memory Active Controller deasserts dfi_lp_data_req signal on low power interface and updates dfi_lp_wakeup with value x */
    DFI_LP_CTRL_DATA_DEASSERT_REQ= `SVI_DFI_MC_DFI_LP_CTRL_DATA_DEASSERT_REQ,   /**< DFI SPECIFIC COMMANDS Memory Active Controller deasserts dfi_lp_data_req and dfi_lp_ctrl_req signal on low power interface and updates dfi_lp_wakeup with value x */ 
    DFI_CTRLUPD_REQ_ASSERT       = `SVI_DFI_MC_DFI_CTRLUPD_REQ_ASSERT,          /**< DFI SPECIFIC COMMANDS Memory Active controller asserts dfi_ctrlupd_req signal on update interface if dfi_phyupd_ack is not asserted.*/ 
    DFI_CTRLUPD_REQ_DEASSERT     = `SVI_DFI_MC_DFI_CTRLUPD_REQ_DEASSERT,        /**< DFI SPECIFIC COMMANDS Memory Active controller deasserts dfi_ctrlupd_req signal on update interface. */ 
    DFI_PHY_INITIATED_UPDATE     = `SVI_DFI_MC_DFI_PHY_INITIATED_UPDATE,        /**< DFI SPECIFIC COMMANDS used by phy driver to initiate phy update req*/ 
    DFI_RESET_ASSERT             = `SVI_DFI_MC_DFI_RESET_ASSERT,                /**< DFI SPECIFIC COMMANDS Memory Active controller deasserts dfi_reset_n_p signal on control interface*/ 
    DFI_RESET_DEASSERT           = `SVI_DFI_MC_DFI_RESET_DEASSERT,              /**< DFI SPECIFIC COMMANDS Memory Active controller asserts dfi_phyupd_ack on update interface if dfi_phyupd_req is asserted  */ 
    DFI_PHYUPD_ACK_ASSERT        = `SVI_DFI_MC_DFI_PHYUPD_ACK_ASSERT,           /**< DFI SPECIFIC COMMANDS Memory Active controller asserts dfi_phymstr_ack on update interface if dfi_phymstr_req is asserted*/ 
    DFI_PHYMSTR_ACK_ASSERT       = `SVI_DFI_MC_DFI_PHYMSTR_ACK_ASSERT,          /**< DFI SPECIFIC COMMANDS This command is used for handshaking between MC Sequencer and driver. MC Driver sends the response back in term of response class signal "DFI_PHYUPD_REQ_SEEN/ DFI_PHYUPD_ACK_SEEN", if dfi_phylupd_req/dfi_phyupd_ack is detected high on updated interface*/  
    POLL_PHYUPD_REQ              = `SVI_DFI_MC_POLL_PHYUPD_REQ,                 /**< DFI SPECIFIC COMMANDS This command is used for handshaking between MC Sequencer and driver. MC Driver sends the response back in term of response class signal "DFI_CTRLUPD_REQ_SEEN", if dfi_ctrlupd_req is detected high on updated interface*/ 
    POLL_CTRLUPD_REQ             = `SVI_DFI_MC_POLL_CTRLUPD_REQ,                /**< DFI SPECIFIC COMMANDS This command is used for handshaking between MC Sequencer and driver. MC Driver stores the Status of sideband interface (e.g DFI_PHYMSTR_REQ, DFI_PHYMSTR_ACK, DFI_PHYMSTR_TYPE, DFI_PHYMSTR_STATE_SEL, DFI_PHYMSTR_CS_STATE, DFI_CTRLUPD_REQ, DFI_LP_CTRL_REQ, DFI_LP_DATA_REQ) in sequence item so that it can be read back through a sequence*/ 
    POLL_CTRLMSG_REQ             = `SVI_DFI_MC_POLL_CTRLMSG_REQ,                /**< DFI SPECIFIC COMMANDS This command is used for handshaking between MC Sequencer and driver. MC Driver stores the Status of sideband interface (e.g DFI_PHYMSTR_REQ, DFI_PHYMSTR_ACK, DFI_PHYMSTR_TYPE, DFI_PHYMSTR_STATE_SEL, DFI_PHYMSTR_CS_STATE, DFI_CTRLUPD_REQ, DFI_LP_CTRL_REQ, DFI_LP_DATA_REQ) in sequence item so that it can be read back through a sequence*/ 
    POLL_PHYMSTR_SIDEBAND        = `SVI_DFI_MC_POLL_PHYMSTR_SIDEBAND,           /**< DFI SPECIFIC COMMANDS This command is used for handshaking between MC Sequencer and driver. MC Driver stores the Status of sideband interface (e.g DFI_PHYMSTR_REQ, DFI_PHYMSTR_ACK, DFI_PHYMSTR_TYPE, DFI_PHYMSTR_STATE_SEL, DFI_PHYMSTR_CS_STATE, DFI_CTRLUPD_REQ, DFI_LP_CTRL_REQ, DFI_LP_DATA_REQ, DFI_CTRLUPD_ACK, DFI_LP_ACK) in sequence item so that it can be read back through a sequence */ 
    POLL_SIDEBANDS               = `SVI_DFI_MC_POLL_SIDEBANDS,                  /**< DFI SPECIFIC COMMANDS This command is used for handshaking between MC Sequencer and driver. MC Driver stores the Status of sideband interface (e.g DFI_PHYMSTR_REQ, DFI_PHYMSTR_ACK, DFI_PHYMSTR_TYPE, DFI_PHYMSTR_STATE_SEL, DFI_PHYMSTR_CS_STATE, DFI_CTRLUPD_REQ, DFI_LP_CTRL_REQ, DFI_LP_DATA_REQ, DFI_CTRLUPD_ACK, DFI_LP_ACK) in sequence item so that it can be read back through a sequence */ 
    POLL_DFI_ERROR               = `SVI_DFI_MC_POLL_DFI_ERROR,                  /**< DFI SPECIFIC COMMANDS This command is used for handshaking between MC Sequencer and driver. MC Driver sends the response back in term of response class signal "DFI_ERROR_SEEN", if dfi_error is detected high on error interface*/ 
    SPL_OPCODE_1                 = `SVI_DFI_MC_SPL_OPCODE_1,                    /**< DFI SPECIFIC COMMANDS*/ 
    SPL_OPCODE_2                 = `SVI_DFI_MC_SPL_OPCODE_2,                    /**< DFI SPECIFIC COMMANDS*/ 
    SPL_OPCODE_3                 = `SVI_DFI_MC_SPL_OPCODE_3,                    /**< DFI SPECIFIC COMMANDS*/ 
    SPL_OPCODE_4                 = `SVI_DFI_MC_SPL_OPCODE_4,                    /**< DFI SPECIFIC COMMANDS*/ 
    GEARDOWN_SYNC                = `SVI_DFI_MC_GEARDOWN_SYNC,                   /**< DFI SPECIFIC COMMANDS This command is used to send geardown sync command to phy side before gear down enable mode*/ 
    GEARDOWN_EN                  = `SVI_DFI_MC_GEARDOWN_EN,                     /**< DFI SPECIFIC COMMANDS Memory Active Controller drives dfi_geardown_en signal with value 1 on status interface  */ 
    GEARDOWN_DIS                 = `SVI_DFI_MC_GEARDOWN_DIS,                    /**< DFI SPECIFIC COMMANDS Memory Active Controller drives dfi_geardown_en signal with value 0 on status interface */    
    MRW_ONE                      = `SVT_DFI_MC_MRW_1,                           /**< Mode Register Write 1 Command (for LPDDR4/5 only). */                     
    MRW_TWO                      = `SVT_DFI_MC_MRW_2,                           /**< Mode Register Write 2 Command (for LPDDR4/5 only). */                                     
    MRR_ONE                      = `SVT_DFI_MC_MRR_1,                           /**< Mode Register Read Command (for LPDDR4 only). */      
    ACT_ONE                      = `SVT_DFI_MC_ACTIVE_1,                        /**< ACTIVE 1 Command (for LPDDR4/5 only). */
    ACT_TWO                      = `SVT_DFI_MC_ACTIVE_2,                        /**< ACTIVE 2 Command (for LPDDR4/5 only). */
    WR_ONE                       = `SVT_DFI_MC_WR1,                             /**< WRITE COMMANDS(for LPDDR4/5 only)*/ 
    RD_ONE                       = `SVT_DFI_MC_RD1,                             /**< READ COMMANDS(for LPDDR4/5 only)*/             
    CAS_TWO                      = `SVT_DFI_MC_CAS_2,                           /**< CAS 2 Command (for LPDDR4 only). */
    CAS                          = `SVT_DFI_MC_CAS,                             /**< CAS Command (for LPDDR5 only). */
    MWR_ONE                      = `SVT_DFI_MC_MWR1,                            /**< MASK WRITE ONE FOR LPDDR4/5 */ 
    MPC_ONE                      = `SVT_DFI_MC_MPC1,                            /**< MULTIPURPOSE COMMAND ONE for LPDDR4*/ 
    MPC                          = `SVT_DFI_MC_MPC,                             /**< MULTIPURPOSE COMMAND for LPDDR5*/ 
    RFU                          = `SVT_DFI_MC_RFU,                             /**< RFU FOR LPDDR4*/ 
    SPL_OPCODE_ABYTE             = `SVT_DFI_MC_SPL_OPCODE_ABYTE,                /**< DFI SPECIFIC COMMAND */ 
    NOPH                         = `SVT_DFI_MC_NOPH,                            /**< LPDDR3 SPECIFIC COMMAND*/ 
    MN_PD_SR_DPD_NOP             = `SVT_DFI_MC_MN_PD_SR_DPD_NOP,                /**< LPDDR3 SPECIFIC COMMAND*/ 
    MN_PD_SR_DPD                 = `SVT_DFI_MC_MN_PD_SR_DPD,                    /**< LPDDR3 SPECIFIC COMMAND*/ 
    MISC_CMD                     = `SVT_DFI_MC_MISC_CMD,                        /**< DFI SPECIFIC COMMAND This command is used under enhanced_vip_architecture configuration parameter. Following commands comes under MISC CMD for reusability.(START_CK, STOP_CK, DFI_RESET_ASSERT, DFI_RESET_DEASSERT, DFI_DRAM_CLK_DIS, DFI_DRAM_CLK_EN, GEARDOWN_DIS, GEARDOWN_EN) */ 
    GEN_PHYMASTER_REQ            = `SVT_DFI_MC_GEN_PHYMASTER_REQ,               /**< DFI SPECIFIC COMMAND USED in Phy SIDE TO Asset req*/ 
    PDX_SRX_DPDX                 = `SVT_DFI_MC_PDX_SRX_DPDX,                    /**< DFI SPECIFIC COMMAND used in LPDDR3*/ 
    UPDATE_FREQ_RATIO            = `SVT_DFI_MC_UPDATE_FREQ_RATIO,               /**< DFI SPECIFIC COMMAND This command Updates the dfi_freq_ratio signal on the stauts interface with the value set in configuration parameter freq_ratio*/ 
    PRESB                        = `SVT_DFI_MC_PRESB,                           /**< DDR5 SPECIFI COMMAND*/ 
    REFSB                        = `SVT_DFI_MC_REFSB,                           /**< DDR5 SPECIFIC COMMAND*/ 
    WRP                          = `SVT_DFI_MC_WRP,                             /**< DDR5 SPECIFIC COMMAND*/ 
    ECS                          = `SVT_DFI_MC_ECS,                             /**< DDR5 SPECIFIC COMMAND*/ 
    MN_SR                        = `SVT_DFI_MC_MN_SR,                           /**< DDR5 SPECIFIC COMMAND*/ 
    MN_PD                        = `SVT_DFI_MC_MN_PD,                           /**< DDR5 SPECIFIC COMMAND*/ 
    XADR                         = `SVT_DFI_MC_XADR,                            /**< NPDIMMP SPECIFIC COMMAND*/ 
    XWRITE                       = `SVT_DFI_MC_XWRITE,                          /**< NPDIMMP SPECIFIC COMMAND*/ 
    PWRITE                       = `SVT_DFI_MC_PWRITE,                          /**< NPDIMMP SPECIFIC COMMAND*/ 
    SEND_STATUS                  = `SVT_DFI_MC_SEND_STATUS,                     /**< NPDIMMP SPECIFIC COMMAND*/ 
    SREAD                        = `SVT_DFI_MC_SREAD,                           /**< NPDIMMP SPECIFIC COMMAND*/ 
    XREAD                        = `SVT_DFI_MC_XREAD,                           /**< NPDIMMP SPECIFIC COMMAND*/ 
    FLUSH                        = `SVT_DFI_MC_FLUSH,                           /**< NPDIMMP SPECIFIC COMMAND*/ 
    IOP                          = `SVT_DFI_MC_IOP,                             /**< NPDIMMP SPECIFIC COMMAND*/ 
    POLL_RESP                    = `SVT_DFI_MC_POLL_RESP,                       /**< NPDIMMP SPECIFIC COMMAND*/
    FLUSH_DFI_QUEUES             = `SVT_DFI_MC_FLUSH_DFI_QUEUES,                /**< DDR5 SPECIFIC COMMAND*/
    RNOP                         = `SVT_DFI_MC_ROW_NO_OPERATION,                /**< HBM ROW NO OPERATION COMMAND*/
    CNOP                         = `SVT_DFI_MC_COLUMN_NO_OPERATION,             /**< HBM COLUMN NO OPERATION*/
    DFI_CTRLMSG_REQ_ASSERT       = `SVT_DFI_MC_CTRLMSG_REQ_ASSERT,              /**< DFI SPECIFIC COMMANDS Memory Active controller asserts dfi_ctrlmsg_req signal on message interface. */
    DFI_CTRLMSG_REQ_DEASSERT     = `SVT_DFI_MC_CTRLMSG_REQ_DEASSERT,            /**< DFI SPECIFIC COMMANDS Memory Active controller deasserts dfi_ctrlmsg_req signal on message interface.*/
    RD                           = `SVT_DFI_MC_READ,                            /**< READ Command (for LPDDR5 only) */
    MWR                          = `SVT_DFI_MC_MWR,                             /**< MASKED WRITING Command (for LPDDR5 only).*/
    DFI_HBM_IEEE_1500_TEST_MODE  = `SVT_DFI_HBM_IEEE_1500_TEST_MODE             /**< HBM IEEE 1500 STD test mode command*/  
    //DES,
    //NOP,
    //MRS,
    //ACT,
    //RD_ZERO,
    //RDS_FOUR,
    //RDS_EIGHT,
    //RDA,
    //RDAS_FOUR,
    //RDAS_EIGHT,
    //RDS_THIRTY_TWO,
    //RDS_SIXTEEN,
    //WR,
    //WRS_FOUR,
    //WRS_EIGHT,
    //WRA,
    //WRAS_FOUR,
    //WRAS_EIGHT,
    //WRS_THIRTY_TWO,
    //WRS_SIXTEEN,
    //WR_MRS,
    //PRE,
    //PREALL,
    //REF,
    //PDE_ZERO,
    //PDE_ONE,
    //PDX_ZERO,
    //PDX_ONE,
    //SRE,
    //SRX,
    //SRX_ZERO,
    //SRX_ONE,
    //NOP_CKE_ONE,
    //NOP_CKE_ZERO,
    //ZQCL,
    //ZQCS,
    //MRW,
    //MRR,
    //REFALL,
    //NOP_ONE,
    //DPDM_ONE,
    //DPDM,
    //DPDE,
    //PDE,
    //PDX,
    //DES_CKE_ZERO,
    //START_CK,
    //STOP_CK,
    //DFI_XIFY,
    //DFI_INIT,
    //DFI_SETUP,
    //DFI_FREQ,
    //DFI_DRAM_CLK_DIS,
    //DFI_DRAM_CLK_EN,
    //DFI_LP_CTRL_ASSERT_REQ,
    //DFI_LP_DATA_ASSERT_REQ,
    //DFI_LP_CTRL_DEASSERT_REQ,
    //DFI_LP_DATA_DEASSERT_REQ,
    //DFI_LP_CTRL_DATA_DEASSERT_REQ,
    //DFI_CTRLUPD_REQ_ASSERT,
    //DFI_CTRLUPD_REQ_DEASSERT,
    //DFI_PHY_INITIATED_UPDATE,
    //DFI_RESET_ASSERT,
    //DFI_RESET_DEASSERT,
    //DFI_PHYUPD_ACK_ASSERT, 
    //DFI_PHYMSTR_ACK_ASSERT, 
    //POLL_PHYUPD_REQ,
    //POLL_CTRLUPD_REQ,
    //POLL_CTRLMSG_REQ,
    //POLL_PHYMSTR_SIDEBAND,
    //POLL_SIDEBANDS,
    //POLL_DFI_ERROR,
    //SPL_OPCODE_1,
    //SPL_OPCODE_2,
    //SPL_OPCODE_3,
    //SPL_OPCODE_4,
    //GEARDOWN_SYNC,
    //GEARDOWN_EN,
    //GEARDOWN_DIS,
    //MRW_ONE,
    //MRW_TWO,
    //MRR_ONE,
    //ACT_ONE,
    //ACT_TWO,
    //WR_ONE,
    //RD_ONE,
    //CAS_TWO,
    //CAS,
    //MWR_ONE,
    //MPC_ONE,
    //MPC,
    //RFU,
    //SPL_OPCODE_ABYTE,
    //NOPH,
    //MN_PD_SR_DPD_NOP,
    //MN_PD_SR_DPD,
    //MISC_CMD,
    //GEN_PHYMASTER_REQ,
    //PDX_SRX_DPDX,
    //UPDATE_FREQ_RATIO,
    //PRESB,
    //REFSB,
    //WRP,
    //ECS,
    //MN_SR,
    //MN_PD,
    //XADR,
    //XWRITE,
    //PWRITE,
    //SEND_STATUS,
    //SREAD,
    //XREAD,
    //FLUSH,
    //IOP,
    //POLL_RESP,
    //FLUSH_DFI_QUEUES,
    //RNOP,
    //CNOP,
    //DFI_CTRLMSG_REQ_ASSERT,
    //DFI_CTRLMSG_REQ_DEASSERT,
    //RD,
    //MWR
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
    dfi_mc_trans.cfg=new();//For solving P-2019.06 vip compatibility problem
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
    //`ifdef LPDDR4
    dfi_mc_trans.data = new[dfi_mc_trans.bl];
    dfi_mc_trans.dm= new[dfi_mc_trans.bl];
    //dfi_mc_trans.lp4_op= this.LP4_OP;
    //`else
    //dfi_mc_trans.data = new[`DFI_MAX_BL];
    //dfi_mc_trans.dm= new[`DFI_MAX_BL];
    //`endif
    if((COMMAND == WR) || (COMMAND == MWR) || (COMMAND == WRA) || (COMMAND == WRS_FOUR) || (COMMAND == WRAS_FOUR) || (COMMAND == WRS_EIGHT) || (COMMAND == WRAS_EIGHT) || (COMMAND == WR_ONE) || (COMMAND == CAS_TWO && (CAS_TWO_COMMAND == WR_TWO || CAS_TWO_COMMAND == MWR_TWO ))) begin
      foreach (dfi_mc_trans.data[i]) begin
      //foreach (this.DATA[i]) begin
      dfi_mc_trans.data[i] = this.DATA[i];
      dfi_mc_trans.dm[i] = this.DM[i];
      end
    end
    dfi_mc_trans.lp5_pd = this.LP5_PD; 
    dfi_mc_trans.lp5_dsm = this.LP5_DSM; 
    dfi_mc_trans.lp5_ap = this.LP5_AP;
    dfi_mc_trans.lp5_ab = this.LP5_AB;
    dfi_mc_trans.lp5_op = this.LP5_OP;
    dfi_mc_trans.lp5_ws_wr = this.LP5_WS_WR;
    dfi_mc_trans.lp5_ws_rd = this.LP5_WS_RD;
    dfi_mc_trans.lp5_ws_fs = this.LP5_WS_FS;
    dfi_mc_trans.dc = this.DC;
    dfi_mc_trans.b3 =this.B3;
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
    if(dfi_mc_trans.cmd_e.name != "DES") begin
      $display("[%0t]: <%m>, send command in driver: %s, cs=%0b",$time,dfi_mc_trans.cmd_e.name,dfi_mc_trans.cs);
    end
    //dfi_mc_trans.print(); //Debug for transaction configuration

    `svt_trace("svt_dfi_drive_sequence","Ending of the sequence:svt_dfi_drive_sequence");
  endtask : body

endclass:svt_dfi_drive_sequence
   
function svt_dfi_drive_sequence::new(string name="svt_dfi_drive_sequence");
  super.new(name);
endfunction:new
`endif
//-----------END OF LINE -------------------------------------------//

