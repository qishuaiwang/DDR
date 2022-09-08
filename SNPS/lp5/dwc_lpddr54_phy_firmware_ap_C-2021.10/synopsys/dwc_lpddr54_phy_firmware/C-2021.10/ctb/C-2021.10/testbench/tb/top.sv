// Following code will enable Portable Functional Coverage VIP and will collect functional coverage data
`ifdef DWC_DDRPHY_COVERAGE_EN
`include "dwc_ddrphy_cov_top.sv"
`endif
//`define DWC_DDRPHY_PMU_WDT_CNT_RANGE_CTB       15:0      
`ifdef DISABLE_SRAM_ECC_PORTS
  `define DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB       31
  `define DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB       31
`else
  `define DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB       38
  `define DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB       38
`endif
`define DWC_DDRPHY_PMU_ICCM_WRD_LSB_CTB         2
`define DWC_DDRPHY_PMU_ICCM_WRD_MSB_CTB         15
//`define DWC_DDRPHY_PMU_ICCM_ADR_RANGE_CTB      15:2

`define DWC_DDRPHY_PMU_DCCM_WRD_LSB_CTB        2
`define DWC_DDRPHY_PMU_DCCM_WRD_MSB_CTB         15
//`define DWC_DDRPHY_PMU_DCCM_ADR_RANGE_CTB       15:2
`ifdef PREFIX_OPT_ENABLE
  `include "dfi_prefix_define.sv"
`endif
module top ();

//-----------------------------------------------------------------
// DUT instantiation
//-----------------------------------------------------------------
wire dfi_ctl_clk;
wire dfi_ctl_clk_assign;
wire dfi_reset_n;
`ifdef LP5_STD
wire [`DWC_DDRPHY_DFI0_WCK_EN_WIDTH-1:0] dfi0_wck_en_P0, dfi0_wck_en_P1, dfi0_wck_en_P2, dfi0_wck_en_P3;
wire [`DWC_DDRPHY_DFI0_WCK_CS_WIDTH-1:0] dfi0_wck_cs_P0, dfi0_wck_cs_P1, dfi0_wck_cs_P2, dfi0_wck_cs_P3;
wire [`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH-1:0] dfi0_wck_toggle_P0, dfi0_wck_toggle_P1, dfi0_wck_toggle_P2, dfi0_wck_toggle_P3;
wire [`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH-1:0] dfi0_wrdata_link_ecc_P0, dfi0_wrdata_link_ecc_P1, dfi0_wrdata_link_ecc_P2, dfi0_wrdata_link_ecc_P3;
wire [`DWC_DDRPHY_DFI0_P0_ADDRESS_MSB:0] dfi0_address_P0;
wire [`DWC_DDRPHY_DFI0_ADDRESS_WIDTH-1:0] dfi0_address_P1, dfi0_address_P2, dfi0_address_P3;
`else
wire [`DWC_DDRPHY_DFI0_P0_ADDRESS_MSB:0] dfi0_address_P0;
wire [`DWC_DDRPHY_DFI0_ADDRESS_WIDTH-1:0]  dfi0_address_P1, dfi0_address_P2, dfi0_address_P3;
`endif
wire [`DWC_DDRPHY_DFI0_CKE_WIDTH-1:0]  dfi0_cke_P0, dfi0_cke_P1, dfi0_cke_P2, dfi0_cke_P3;
wire [`DWC_DDRPHY_DFI0_CS_WIDTH-1:0]  dfi0_cs_P0, dfi0_cs_P1, dfi0_cs_P2, dfi0_cs_P3;
wire [`DWC_DDRPHY_DFI0_PHYUPD_ACK_WIDTH-1:0] dfi0_ctrlupd_ack;
wire [`DWC_DDRPHY_DFI0_CTRLUPD_REQ_WIDTH-1:0] dfi0_ctrlupd_req;
wire [`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH-1:0] dfi0_dram_clk_disable_P0,dfi0_dram_clk_disable_P1,dfi0_dram_clk_disable_P2,dfi0_dram_clk_disable_P3;
wire [`DWC_DDRPHY_DFI0_ERROR_WIDTH-1:0] dfi0_error;
wire [`DWC_DDRPHY_DFI0_ERROR_INFO_WIDTH-1:0] dfi0_error_info;
wire [`DWC_DDRPHY_DFI0_FREQUENCY_WIDTH-1  : 0] dfi0_frequency  ;
wire [`DWC_DDRPHY_DFI0_FREQ_RATIO_WIDTH-1 : 0] dfi0_freq_ratio ;
wire [`DWC_DDRPHY_DFI0_FREQ_FSP_WIDTH-1   : 0 ] dfi0_freq_fsp  ;
wire [`DWC_DDRPHY_DFI0_INIT_START_WIDTH-1:0] dfi0_init_start; 
wire [`DWC_DDRPHY_DFI0_INIT_COMPLETE_WIDTH-1:0] dfi0_init_complete;
//wire [`DFI0_PHY_INFO_ACK_WIDTH-1:0] dfi0_phy_info_ack;
//wire [`DFI0_PHY_INFO_REQ_WIDTH-1:0] dfi0_phy_info_req;
//wire [`DFI0_PHY_INFO_CMD_WIDTH-1:0] dfi0_phy_info_cmd;
//wire [`DFI0_PHY_INFO_DATA_WIDTH-1:0] dfi0_phy_info_data;
wire [`DWC_DDRPHY_DFI0_LP_CTRL_ACK_WIDTH-1:0] dfi0_lp_ctrl_ack;
wire [`DWC_DDRPHY_DFI0_LP_DATA_ACK_WIDTH-1:0] dfi0_lp_data_ack;
wire [`DWC_DDRPHY_DFI0_LP_CTRL_REQ_WIDTH-1:0] dfi0_lp_ctrl_req;
wire [`DWC_DDRPHY_DFI0_LP_DATA_REQ_WIDTH-1:0] dfi0_lp_data_req;
wire [`DWC_DDRPHY_DFI0_LP_CTRL_WAKEUP_WIDTH-1:0] dfi0_lp_ctrl_wakeup;
wire [`DWC_DDRPHY_DFI0_LP_DATA_WAKEUP_WIDTH-1:0] dfi0_lp_data_wakeup;
wire [`DWC_DDRPHY_DFI0_PHYMSTR_ACK_WIDTH-1:0] dfi0_phymstr_ack;
wire [`DWC_DDRPHY_DFI0_PHYMSTR_CS_STATE_WIDTH-1:0] dfi0_phymstr_cs_state;
wire [`DWC_DDRPHY_DFI0_PHYMSTR_REQ_WIDTH-1:0] dfi0_phymstr_req;
wire [`DWC_DDRPHY_DFI0_PHYMSTR_STATE_SEL_WIDTH-1:0] dfi0_phymstr_state_sel;
wire [`DWC_DDRPHY_DFI0_PHYMSTR_TYPE_WIDTH-1:0] dfi0_phymstr_type;
wire [`DWC_DDRPHY_DFI0_PHYUPD_ACK_WIDTH-1:0] dfi0_phyupd_ack;
wire [`DWC_DDRPHY_DFI0_PHYUPD_REQ_WIDTH-1:0] dfi0_phyupd_req;
wire [`DWC_DDRPHY_DFI0_PHYMSTR_TYPE_WIDTH-1:0] dfi0_phyupd_type;
wire [`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH-1:0]  dfi0_rddata_cs_P0, dfi0_rddata_cs_P1, dfi0_rddata_cs_P2, dfi0_rddata_cs_P3;
wire [`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH-1:0]    dfi0_rddata_en_P0, dfi0_rddata_en_P1, dfi0_rddata_en_P2, dfi0_rddata_en_P3;
wire [`DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH-1:0] dfi0_rddata_valid_W0, dfi0_rddata_valid_W1, dfi0_rddata_valid_W2, dfi0_rddata_valid_W3;
wire [`DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH-1:0]   dfi0_rddata_dbi_W0, dfi0_rddata_dbi_W1, dfi0_rddata_dbi_W2, dfi0_rddata_dbi_W3;
wire [`DWC_DDRPHY_DFI0_RDDATA_WIDTH-1:0]       dfi0_rddata_W0, dfi0_rddata_W1, dfi0_rddata_W2, dfi0_rddata_W3;
wire [`DWC_DDRPHY_DFI0_WRDATA_WIDTH-1:0]       dfi0_wrdata_P0, dfi0_wrdata_P1, dfi0_wrdata_P2, dfi0_wrdata_P3;
wire [`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH-1:0]  dfi0_wrdata_cs_P0, dfi0_wrdata_cs_P1, dfi0_wrdata_cs_P2, dfi0_wrdata_cs_P3;
wire [`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH-1:0]    dfi0_wrdata_en_P0,  dfi0_wrdata_en_P1,  dfi0_wrdata_en_P2, dfi0_wrdata_en_P3;
wire [`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH-1:0]  dfi0_wrdata_mask_P0, dfi0_wrdata_mask_P1, dfi0_wrdata_mask_P2, dfi0_wrdata_mask_P3;

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
`ifdef LP5_STD
wire [`DWC_DDRPHY_DFI0_WCK_EN_WIDTH-1:0] dfi1_wck_en_P0, dfi1_wck_en_P1, dfi1_wck_en_P2, dfi1_wck_en_P3;
wire [`DWC_DDRPHY_DFI0_WCK_CS_WIDTH-1:0] dfi1_wck_cs_P0, dfi1_wck_cs_P1, dfi1_wck_cs_P2, dfi1_wck_cs_P3;
wire [`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH-1:0] dfi1_wck_toggle_P0, dfi1_wck_toggle_P1, dfi1_wck_toggle_P2, dfi1_wck_toggle_P3;
wire [`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH-1:0] dfi1_wrdata_link_ecc_P0, dfi1_wrdata_link_ecc_P1, dfi1_wrdata_link_ecc_P2, dfi1_wrdata_link_ecc_P3;
wire [`DWC_DDRPHY_DFI1_P0_ADDRESS_MSB:0] dfi1_address_P0;
wire [`DWC_DDRPHY_DFI1_ADDRESS_WIDTH-1:0] dfi1_address_P1, dfi1_address_P2, dfi1_address_P3;
`else
wire [`DWC_DDRPHY_DFI1_P0_ADDRESS_MSB:0] dfi1_address_P0;
wire [`DWC_DDRPHY_DFI1_ADDRESS_WIDTH-1:0]  dfi1_address_P1, dfi1_address_P2, dfi1_address_P3;
`endif
wire [`DWC_DDRPHY_DFI1_CKE_WIDTH-1:0]  dfi1_cke_P0, dfi1_cke_P1, dfi1_cke_P2, dfi1_cke_P3;
wire [`DWC_DDRPHY_DFI1_CS_WIDTH-1:0]  dfi1_cs_P0, dfi1_cs_P1, dfi1_cs_P2, dfi1_cs_P3;
wire [`DWC_DDRPHY_DFI1_PHYUPD_ACK_WIDTH-1:0] dfi1_ctrlupd_ack;
wire [`DWC_DDRPHY_DFI1_CTRLUPD_REQ_WIDTH-1:0] dfi1_ctrlupd_req;
wire [`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH-1:0] dfi1_dram_clk_disable_P0,dfi1_dram_clk_disable_P1,dfi1_dram_clk_disable_P2,dfi1_dram_clk_disable_P3;
wire [`DWC_DDRPHY_DFI1_ERROR_WIDTH-1:0] dfi1_error;
wire [`DWC_DDRPHY_DFI1_ERROR_INFO_WIDTH-1:0] dfi1_error_info;
wire [`DWC_DDRPHY_DFI1_FREQUENCY_WIDTH-1  : 0] dfi1_frequency  ;
wire [`DWC_DDRPHY_DFI1_FREQ_RATIO_WIDTH-1 : 0] dfi1_freq_ratio ;
wire [`DWC_DDRPHY_DFI1_FREQ_FSP_WIDTH-1   : 0 ] dfi1_freq_fsp  ;
wire [`DWC_DDRPHY_DFI1_INIT_START_WIDTH-1:0] dfi1_init_start; 
wire [`DWC_DDRPHY_DFI1_INIT_COMPLETE_WIDTH-1:0] dfi1_init_complete;
//wire [`DFI1_PHY_INFO_ACK_WIDTH-1:0] dfi1_phy_info_ack;
//wire [`DFI1_PHY_INFO_REQ_WIDTH-1:0] dfi1_phy_info_req;
//wire [`DFI1_PHY_INFO_CMD_WIDTH-1:0] dfi1_phy_info_cmd;
//wire [`DFI1_PHY_INFO_DATA_WIDTH-1:0] dfi1_phy_info_data;
wire [`DWC_DDRPHY_DFI1_LP_CTRL_ACK_WIDTH-1:0] dfi1_lp_ctrl_ack;
wire [`DWC_DDRPHY_DFI1_LP_DATA_ACK_WIDTH-1:0] dfi1_lp_data_ack;
wire [`DWC_DDRPHY_DFI1_LP_CTRL_REQ_WIDTH-1:0] dfi1_lp_ctrl_req;
wire [`DWC_DDRPHY_DFI1_LP_DATA_REQ_WIDTH-1:0] dfi1_lp_data_req;
wire [`DWC_DDRPHY_DFI1_LP_CTRL_WAKEUP_WIDTH-1:0] dfi1_lp_ctrl_wakeup;
wire [`DWC_DDRPHY_DFI1_LP_DATA_WAKEUP_WIDTH-1:0] dfi1_lp_data_wakeup;
wire [`DWC_DDRPHY_DFI1_PHYMSTR_ACK_WIDTH-1:0] dfi1_phymstr_ack;
wire [`DWC_DDRPHY_DFI1_PHYMSTR_CS_STATE_WIDTH-1:0] dfi1_phymstr_cs_state;
wire [`DWC_DDRPHY_DFI1_PHYMSTR_REQ_WIDTH-1:0] dfi1_phymstr_req;
wire [`DWC_DDRPHY_DFI1_PHYMSTR_STATE_SEL_WIDTH-1:0] dfi1_phymstr_state_sel;
wire [`DWC_DDRPHY_DFI1_PHYMSTR_TYPE_WIDTH-1:0] dfi1_phymstr_type;
wire [`DWC_DDRPHY_DFI1_PHYUPD_ACK_WIDTH-1:0] dfi1_phyupd_ack;
wire [`DWC_DDRPHY_DFI1_PHYUPD_REQ_WIDTH-1:0] dfi1_phyupd_req;
wire [`DWC_DDRPHY_DFI1_PHYMSTR_TYPE_WIDTH-1:0] dfi1_phyupd_type;

wire [`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH-1:0]  dfi1_rddata_cs_P0, dfi1_rddata_cs_P1, dfi1_rddata_cs_P2, dfi1_rddata_cs_P3;
wire [`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH-1:0]    dfi1_rddata_en_P0, dfi1_rddata_en_P1, dfi1_rddata_en_P2, dfi1_rddata_en_P3;
wire [`DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH-1:0] dfi1_rddata_valid_W0, dfi1_rddata_valid_W1, dfi1_rddata_valid_W2, dfi1_rddata_valid_W3;
wire [`DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH-1:0]   dfi1_rddata_dbi_W0, dfi1_rddata_dbi_W1, dfi1_rddata_dbi_W2, dfi1_rddata_dbi_W3;
wire [`DWC_DDRPHY_DFI1_RDDATA_WIDTH-1:0]       dfi1_rddata_W0, dfi1_rddata_W1, dfi1_rddata_W2, dfi1_rddata_W3;
wire [`DWC_DDRPHY_DFI1_WRDATA_WIDTH-1:0]       dfi1_wrdata_P0, dfi1_wrdata_P1, dfi1_wrdata_P2, dfi1_wrdata_P3;
wire [`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH-1:0]  dfi1_wrdata_cs_P0, dfi1_wrdata_cs_P1, dfi1_wrdata_cs_P2, dfi1_wrdata_cs_P3;
wire [`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH-1:0]    dfi1_wrdata_en_P0,  dfi1_wrdata_en_P1,  dfi1_wrdata_en_P2, dfi1_wrdata_en_P3;
wire [`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH-1:0]  dfi1_wrdata_mask_P0, dfi1_wrdata_mask_P1, dfi1_wrdata_mask_P2, dfi1_wrdata_mask_P3;
`endif

// Per-Phy Signals for DCT
wire              Reset;         // as per dct interface spec - defined as sync to refclk
wire              PwrOkIn;       //BOZO LP54 - to be removed
wire              dfi_clk;
wire              BypassPclk;
wire              BurnIn;
wire              UcClk;
reg               lbist_mode_set=0;
`ifdef DWC_DDRPHY_LBIST_EN
`ifndef PUB_VERSION_GE_0100
wire              DfiClk0_lbist;
`endif
wire              lbist_mode;
wire              LBIST_TYPE;
wire              LBIST_TM0;
wire              LBIST_TM1;
wire              LBIST_EN;
wire              START;
wire              STATUS_0;
wire              STATUS_1;
assign LBIST_MODE = lbist_mode_set ? lbist_mode : 1'b0;
`endif   

// PHY JTAG TDR interface
wire              WSI;                  // Seriel Data Input: Launch on Fall Capture on Rise
wire              TDRCLK;                 // JTAG Clock
wire              WRSTN;                // JTAG Async Reset. Active LOW
// JTAG TDR interface to DrTub
wire            DdrPhyCsrCmdTdrShiftEn;    // TDR Shift Enable: Launch on Rise, Capture On Rise
wire            DdrPhyCsrCmdTdrCaptureEn;  // TDR Capture Enable: Launch on Rise, Capture On Rise
wire            DdrPhyCsrCmdTdrUpdateEn;   // TDR Update Enable: Launch on Fall, Capture On Rise
wire            DdrPhyCsrCmdTdr_Tdo;      // TDR Serial Data Output: Launch on Fall, Capture on Rise 
wire            DdrPhyCsrRdDataTdrShiftEn;    // TDR Shift Enable: Launch on Rise, Capture On Rise
wire            DdrPhyCsrRdDataTdrCaptureEn;  // TDR Capture Enable: Launch on Rise, Capture On Rise
wire            DdrPhyCsrRdDataTdrUpdateEn;   // TDR Update Enable: Launch on Fall, Capture On Rise
wire            DdrPhyCsrRdDataTdr_Tdo;       // TDR Serial Data Output: Launch on Fall, Capture on Rise 

wire            dwc_ddrphy_int_n; // Interrupt

// scan controls
wire [`DWC_DDRPHY_ATPG_SE_WIDTH-1:0]          atpg_se;
wire [`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS - 1:0]  atpg_si;
//spyglass disable_block W241
//spyglass disable_block UndrivenOutPort-ML
wire [`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS - 1:0]  atpg_so;
//spyglass enable_block UndrivenOutPort-ML
//spyglass enable_block W241
wire             atpg_mode;
wire [5:0]       atpg_lu_ctrl;

// ATPG Clocks/Controls
wire             atpg_RDQSClk;
wire             atpg_Pclk;
wire             atpg_TxDllClk;
wire             APBCLK;                       
wire [1:0]       PSTRB_APB;
wire [2:0]       PPROT_APB;
       
                                          
wire [2:0]       PPROT_PIN;

// APB Interface 
wire [31:0] paddr;
wire [15:0] pwdata, prdata;
wire apb_clk, pwrite, psel, presetn, penable, pready, palverr;



// Interface to the ICCM RAM macros
wire [`DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB:0]                                iccm_data_dout;
wire [`DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB:0]                                iccm_data_din;
wire [`DWC_DDRPHY_PMU_ICCM_WRD_MSB_CTB:`DWC_DDRPHY_PMU_ICCM_WRD_LSB_CTB]  iccm_data_addr;
wire                                                                      iccm_data_ce;
wire                                                                      iccm_data_we;

// Interface to the DCCM RAM macros
wire [`DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB:0]                                dccm_data_dout;
wire [`DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB:0]                                dccm_data_din;
wire [`DWC_DDRPHY_PMU_DCCM_WRD_MSB_CTB:`DWC_DDRPHY_PMU_DCCM_WRD_LSB_CTB]  dccm_data_addr;
wire                                                                      dccm_data_ce;
wire                                                                      dccm_data_we;
wire                                                                      pmu_sram_clken;

// Interface to External ACSM Memory
wire [71:0]      acsm_data_dout;
wire [71:0]      acsm_data_din;
wire [9:0]       acsm_data_addr;
wire             acsm_data_ce;                               
wire             acsm_data_we;


//  DRAM BUMPS              
wire [6+`DWC_DDRPHY_NUM_RANKS-1:0]BP_DFI0_CA;
wire [`DWC_DDRPHY_NUM_RANKS-1:0]  BP_DFI0_LP4CKE_LP5CS;
wire                              BP_DFI0_CK_T;
wire                              BP_DFI0_CK_C;
wire [7:0]                        BP_DFI0_B0_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI0_B0_DMI;
`endif
wire                              BP_DFI0_B0_DQS_T;
wire                              BP_DFI0_B0_DQS_C;
wire [7:0]                        BP_DFI0_B1_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI0_B1_DMI;
`endif
wire                              BP_DFI0_B1_DQS_T;
wire                              BP_DFI0_B1_DQS_C;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
wire [7:0]                        BP_DFI0_B2_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI0_B2_DMI;
`endif
wire                              BP_DFI0_B2_DQS_T;
wire                              BP_DFI0_B2_DQS_C;
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
wire [7:0]                        BP_DFI0_B3_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI0_B3_DMI;
`endif
wire                              BP_DFI0_B3_DQS_T;
wire                              BP_DFI0_B3_DQS_C;
`endif
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
wire [6+`DWC_DDRPHY_NUM_RANKS-1:0]BP_DFI1_CA;
wire [`DWC_DDRPHY_NUM_RANKS-1:0]  BP_DFI1_LP4CKE_LP5CS;
wire                              BP_DFI1_CK_T;
wire                              BP_DFI1_CK_C;
wire [7:0]                        BP_DFI1_B0_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI1_B0_DMI;
`endif
wire                              BP_DFI1_B0_DQS_T;
wire                              BP_DFI1_B0_DQS_C;
wire [7:0]                        BP_DFI1_B1_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI1_B1_DMI;
`endif
wire                              BP_DFI1_B1_DQS_T;
wire                              BP_DFI1_B1_DQS_C;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
wire [7:0]                        BP_DFI1_B2_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI1_B2_DMI;
`endif
wire                              BP_DFI1_B2_DQS_T;
wire                              BP_DFI1_B2_DQS_C;
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
wire [7:0]                        BP_DFI1_B3_D;
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
wire                              BP_DFI1_B3_DMI;
`endif
wire                              BP_DFI1_B3_DQS_T;
wire                              BP_DFI1_B3_DQS_C;
`endif
`endif

`ifdef DWC_DDRPHY_TOP_PG_PINS
   //POWER PORTS
wire              VDD ;
wire              VDDQ;
wire              VDD2H;
wire              VAA_VDD2H;
wire              VSS;
//`endif
`else
wire      dwc_PwrOkIn_XDriver;
wire      dwc_PwrOkIn_X;
`endif

   //MASTER BUMPS         
//wire      BP_RET;                                 
wire      BP_PWROK;
wire      BP_MEMRESET_L;
wire      BP_DTO;
wire      BP_ATO;   
wire      BP_ZN; 

`ifdef FLYOVER_TEST
reg       ATPG_MODE;
reg       RESET;
reg       bp_pwrok;
reg [5:0] ATPG_SE;
reg       ATPG_SI;
reg       mission_mode;
`endif
////------------------------ Bypass interface ------------------
`ifdef FLYOVER_TEST
  reg       RxTestClk ;
//***********************SE: DQ/DMI/CA******************************//
  reg [7:0] RxBypassRcvEn_DFI0_B0_D                   ;
  reg [7:0] RxBypassRcvEn_DFI0_B1_D                   ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] RxBypassRcvEn_DFI0_B2_D                   ;
  reg [7:0] RxBypassRcvEn_DFI0_B3_D                   ;
`endif                                       
  reg [3:0] RxBypassData_DFI0_B0_D0                   ;
  reg [3:0] RxBypassData_DFI0_B0_D1                   ;
  reg [3:0] RxBypassData_DFI0_B0_D2                   ;
  reg [3:0] RxBypassData_DFI0_B0_D3                   ;
  reg [3:0] RxBypassData_DFI0_B0_D4                   ;
  reg [3:0] RxBypassData_DFI0_B0_D5                   ;
  reg [3:0] RxBypassData_DFI0_B0_D6                   ;
  reg [3:0] RxBypassData_DFI0_B0_D7                   ;
  reg [3:0] RxBypassData_DFI0_B1_D0                   ;
  reg [3:0] RxBypassData_DFI0_B1_D1                   ;
  reg [3:0] RxBypassData_DFI0_B1_D2                   ;
  reg [3:0] RxBypassData_DFI0_B1_D3                   ;
  reg [3:0] RxBypassData_DFI0_B1_D4                   ;
  reg [3:0] RxBypassData_DFI0_B1_D5                   ;
  reg [3:0] RxBypassData_DFI0_B1_D6                   ;
  reg [3:0] RxBypassData_DFI0_B1_D7                   ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [3:0] RxBypassData_DFI0_B2_D0                   ;
  reg [3:0] RxBypassData_DFI0_B2_D1                   ;
  reg [3:0] RxBypassData_DFI0_B2_D2                   ;
  reg [3:0] RxBypassData_DFI0_B2_D3                   ;
  reg [3:0] RxBypassData_DFI0_B2_D4                   ;
  reg [3:0] RxBypassData_DFI0_B2_D5                   ;
  reg [3:0] RxBypassData_DFI0_B2_D6                   ;
  reg [3:0] RxBypassData_DFI0_B2_D7                   ;
  reg [3:0] RxBypassData_DFI0_B3_D0                   ;
  reg [3:0] RxBypassData_DFI0_B3_D1                   ;
  reg [3:0] RxBypassData_DFI0_B3_D2                   ;
  reg [3:0] RxBypassData_DFI0_B3_D3                   ;
  reg [3:0] RxBypassData_DFI0_B3_D4                   ;
  reg [3:0] RxBypassData_DFI0_B3_D5                   ;
  reg [3:0] RxBypassData_DFI0_B3_D6                   ;
  reg [3:0] RxBypassData_DFI0_B3_D7                   ;
`endif                                       
  reg [7:0] RxBypassPadEn_DFI0_B0_D                   ;
  reg [7:0] RxBypassPadEn_DFI0_B1_D                   ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] RxBypassPadEn_DFI0_B2_D                   ;
  reg [7:0] RxBypassPadEn_DFI0_B3_D                   ;
`endif                                       
  reg [7:0] RxBypassDataPad_DFI0_B0_D                 ;
  reg [7:0] RxBypassDataPad_DFI0_B1_D                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] RxBypassDataPad_DFI0_B2_D                 ;
  reg [7:0] RxBypassDataPad_DFI0_B3_D                 ;
`endif                                       
  reg [7:0]     TxBypassMode_DFI0_B0_D                    ;
  reg [7:0]     TxBypassMode_DFI0_B1_D                    ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0]     TxBypassMode_DFI0_B2_D                    ;
  reg [7:0]     TxBypassMode_DFI0_B3_D                    ;
`endif                                       
  reg [7:0]     TxBypassOE_DFI0_B0_D                      ;
  reg [7:0]     TxBypassOE_DFI0_B1_D                      ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0]     TxBypassOE_DFI0_B2_D                      ;
  reg [7:0]     TxBypassOE_DFI0_B3_D                      ;
`endif                                       
  reg [7:0] TxBypassData_DFI0_B0_D                    ;
  reg [7:0] TxBypassData_DFI0_B1_D                    ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] TxBypassData_DFI0_B2_D                    ;
  reg [7:0] TxBypassData_DFI0_B3_D                    ;
`endif                                       
                                             
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED          
  reg       RxBypassRcvEn_DFI0_B0_DMI                 ;
  reg       RxBypassRcvEn_DFI0_B1_DMI                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassRcvEn_DFI0_B2_DMI                 ;
  reg       RxBypassRcvEn_DFI0_B3_DMI                 ;
`endif                                       
  reg [3:0] RxBypassData_DFI0_B0_DMI                  ;
  reg [3:0] RxBypassData_DFI0_B1_DMI                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [3:0] RxBypassData_DFI0_B2_DMI                  ;
  reg [3:0] RxBypassData_DFI0_B3_DMI                  ;
`endif                                       
  reg       RxBypassPadEn_DFI0_B0_DMI                 ;
  reg       RxBypassPadEn_DFI0_B1_DMI                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassPadEn_DFI0_B2_DMI                 ;
  reg       RxBypassPadEn_DFI0_B3_DMI                 ;
`endif                                       
  reg       RxBypassDataPad_DFI0_B0_DMI               ;
  reg       RxBypassDataPad_DFI0_B1_DMI               ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataPad_DFI0_B2_DMI               ;
  reg       RxBypassDataPad_DFI0_B3_DMI               ;
`endif                                       
  reg       TxBypassMode_DFI0_B0_DMI                  ;
  reg       TxBypassMode_DFI0_B1_DMI                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassMode_DFI0_B2_DMI                  ;
  reg       TxBypassMode_DFI0_B3_DMI                  ;
`endif                                       
  reg       TxBypassOE_DFI0_B0_DMI                    ;
  reg       TxBypassOE_DFI0_B1_DMI                    ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassOE_DFI0_B2_DMI                    ;
  reg       TxBypassOE_DFI0_B3_DMI                    ;
`endif                                       
  reg       TxBypassData_DFI0_B0_DMI                  ;
  reg       TxBypassData_DFI0_B1_DMI                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassData_DFI0_B2_DMI                  ;
  reg       TxBypassData_DFI0_B3_DMI                  ;
`endif                                       
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED     
                                             
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] RxBypassRcvEn_DFI0_CA ;
  reg [3:0] RxBypassData_DFI0_CA0                     ;
  reg [3:0] RxBypassData_DFI0_CA1                     ;
  reg [3:0] RxBypassData_DFI0_CA2                     ;
  reg [3:0] RxBypassData_DFI0_CA3                     ;
  reg [3:0] RxBypassData_DFI0_CA4                     ;
  reg [3:0] RxBypassData_DFI0_CA5                     ;
  reg [3:0] RxBypassData_DFI0_CA6                     ;
`ifdef DWC_DDRPHY_NUM_RANKS_2                
  reg [3:0] RxBypassData_DFI0_CA7                     ;
`endif                                       
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] RxBypassPadEn_DFI0_CA;
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] RxBypassDataPad_DFI0_CA; 
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] TxBypassMode_DFI0_CA                      ;
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] TxBypassOE_DFI0_CA                        ;
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] TxBypassData_DFI0_CA ;
  ;
//*********************DIFF: DQS/WCK/CK******;
  reg       RxBypassRcvEn_DFI0_B0_DQS                 ;
  reg       RxBypassRcvEn_DFI0_B1_DQS                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassRcvEn_DFI0_B2_DQS                 ;
  reg       RxBypassRcvEn_DFI0_B3_DQS                 ;
`endif                                       
  reg       RxBypassDataRcv_DFI0_B0_DQS_T             ;
  reg       RxBypassDataRcv_DFI0_B0_DQS_C             ;
  reg       RxBypassDataRcv_DFI0_B1_DQS_T             ;
  reg       RxBypassDataRcv_DFI0_B1_DQS_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataRcv_DFI0_B2_DQS_T             ;
  reg       RxBypassDataRcv_DFI0_B2_DQS_C             ;
  reg       RxBypassDataRcv_DFI0_B3_DQS_T             ;
  reg       RxBypassDataRcv_DFI0_B3_DQS_C             ;
`endif                                       
  reg       RxBypassPadEn_DFI0_B0_DQS                 ;
  reg       RxBypassPadEn_DFI0_B1_DQS                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassPadEn_DFI0_B2_DQS                 ;
  reg       RxBypassPadEn_DFI0_B3_DQS                 ;
`endif                                      
  reg       RxBypassDataPad_DFI0_B0_DQS_T             ;
  reg       RxBypassDataPad_DFI0_B0_DQS_C             ;
  reg       RxBypassDataPad_DFI0_B1_DQS_T             ;
  reg       RxBypassDataPad_DFI0_B1_DQS_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataPad_DFI0_B2_DQS_T             ;
  reg       RxBypassDataPad_DFI0_B2_DQS_C             ;
  reg       RxBypassDataPad_DFI0_B3_DQS_T             ;
  reg       RxBypassDataPad_DFI0_B3_DQS_C             ;
`endif                                       
  reg       TxBypassMode_DFI0_B0_DQS_T                  ;
  reg       TxBypassMode_DFI0_B0_DQS_C                  ;
  reg       TxBypassMode_DFI0_B1_DQS_T                  ;
  reg       TxBypassMode_DFI0_B1_DQS_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassMode_DFI0_B2_DQS_T                  ;
  reg       TxBypassMode_DFI0_B2_DQS_C                  ;
  reg       TxBypassMode_DFI0_B3_DQS_T                  ;
  reg       TxBypassMode_DFI0_B3_DQS_C                  ;
`endif                                       
  reg       TxBypassOE_DFI0_B0_DQS_T                  ;
  reg       TxBypassOE_DFI0_B0_DQS_C                  ;
  reg       TxBypassOE_DFI0_B1_DQS_T                  ;
  reg       TxBypassOE_DFI0_B1_DQS_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassOE_DFI0_B2_DQS_T                  ;
  reg       TxBypassOE_DFI0_B2_DQS_C                  ;
  reg       TxBypassOE_DFI0_B3_DQS_T                  ;
  reg       TxBypassOE_DFI0_B3_DQS_C                  ;
`endif                                       
  reg       TxBypassData_DFI0_B0_DQS_T                ;
  reg       TxBypassData_DFI0_B0_DQS_C                ;
  reg       TxBypassData_DFI0_B1_DQS_T                ;
  reg       TxBypassData_DFI0_B1_DQS_C                ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassData_DFI0_B2_DQS_T                ;
  reg       TxBypassData_DFI0_B2_DQS_C                ;
  reg       TxBypassData_DFI0_B3_DQS_T                ;
  reg       TxBypassData_DFI0_B3_DQS_C                ;
`endif                                       
                                             
`ifdef DWC_DDRPHY_LPDDR5_ENABLED             
  reg       RxBypassRcvEn_DFI0_B0_WCK                 ;
  reg       RxBypassRcvEn_DFI0_B1_WCK                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassRcvEn_DFI0_B2_WCK                 ;
  reg       RxBypassRcvEn_DFI0_B3_WCK                 ;
`endif                                       
  reg       RxBypassDataRcv_DFI0_B0_WCK_T             ;
  reg       RxBypassDataRcv_DFI0_B0_WCK_C             ;
  reg       RxBypassDataRcv_DFI0_B1_WCK_T             ;
  reg       RxBypassDataRcv_DFI0_B1_WCK_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataRcv_DFI0_B2_WCK_T             ;
  reg       RxBypassDataRcv_DFI0_B2_WCK_C             ;
  reg       RxBypassDataRcv_DFI0_B3_WCK_T             ;
  reg       RxBypassDataRcv_DFI0_B3_WCK_C             ;
`endif                                       
  reg       RxBypassPadEn_DFI0_B0_WCK                 ;
  reg       RxBypassPadEn_DFI0_B1_WCK                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassPadEn_DFI0_B2_WCK                 ;
  reg       RxBypassPadEn_DFI0_B3_WCK                 ;
`endif                                       
  reg       RxBypassDataPad_DFI0_B0_WCK_T             ;
  reg       RxBypassDataPad_DFI0_B0_WCK_C             ;
  reg       RxBypassDataPad_DFI0_B1_WCK_T             ;
  reg       RxBypassDataPad_DFI0_B1_WCK_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataPad_DFI0_B2_WCK_T             ;
  reg       RxBypassDataPad_DFI0_B2_WCK_C             ;
  reg       RxBypassDataPad_DFI0_B3_WCK_T             ;
  reg       RxBypassDataPad_DFI0_B3_WCK_C             ;
`endif                                       
  reg       TxBypassMode_DFI0_B0_WCK_T                  ;
  reg       TxBypassMode_DFI0_B0_WCK_C                  ;
  reg       TxBypassMode_DFI0_B1_WCK_T                  ;
  reg       TxBypassMode_DFI0_B1_WCK_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassMode_DFI0_B2_WCK_T                  ;
  reg       TxBypassMode_DFI0_B2_WCK_C                  ;
  reg       TxBypassMode_DFI0_B3_WCK_T                  ;
  reg       TxBypassMode_DFI0_B3_WCK_C                  ;
`endif                                       
  reg       TxBypassOE_DFI0_B0_WCK_T                  ;
  reg       TxBypassOE_DFI0_B0_WCK_C                  ;
  reg       TxBypassOE_DFI0_B1_WCK_T                  ;
  reg       TxBypassOE_DFI0_B1_WCK_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassOE_DFI0_B2_WCK_T                  ;
  reg       TxBypassOE_DFI0_B2_WCK_C                  ;
  reg       TxBypassOE_DFI0_B3_WCK_T                  ;
  reg       TxBypassOE_DFI0_B3_WCK_C                  ;
`endif                                       
  reg       TxBypassData_DFI0_B0_WCK_T                ;
  reg       TxBypassData_DFI0_B0_WCK_C                ;
  reg       TxBypassData_DFI0_B1_WCK_T                ;
  reg       TxBypassData_DFI0_B1_WCK_C                ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassData_DFI0_B2_WCK_T                ;
  reg       TxBypassData_DFI0_B2_WCK_C                ;
  reg       TxBypassData_DFI0_B3_WCK_T                ;
  reg       TxBypassData_DFI0_B3_WCK_C                ;
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED;

  reg       RxBypassRcvEn_DFI0_CK                     ;
  reg       RxBypassDataRcv_DFI0_CK_T                 ;
  reg       RxBypassDataRcv_DFI0_CK_C                 ;
  reg       RxBypassPadEn_DFI0_CK                     ;
  reg       RxBypassDataPad_DFI0_CK_T                 ;
  reg       RxBypassDataPad_DFI0_CK_C                 ;
  reg       TxBypassMode_DFI0_CK_T                      ;
  reg       TxBypassMode_DFI0_CK_C                      ;
  reg       TxBypassOE_DFI0_CK_T                      ;
  reg       TxBypassOE_DFI0_CK_C                      ;
  reg       TxBypassData_DFI0_CK_T                    ;
  reg       TxBypassData_DFI0_CK_C                    ;
//************************* SEC *************
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] RxBypassPadEn_DFI0_LP4CKE_LP5CS;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] RxBypassDataPad_DFI0_LP4CKE_LP5CS ;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] TxBypassMode_DFI0_LP4CKE_LP5CS            ;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] TxBypassOE_DFI0_LP4CKE_LP5CS              ;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] TxBypassData_DFI0_LP4CKE_LP5CS    ;
                
  reg       TxBypassMode_MEMRESET_L                   ;
  reg       TxBypassData_MEMRESET_L                   ;
                 
  reg       TxBypassMode_DTO                          ;
  reg       TxBypassOE_DTO                            ;
  reg       TxBypassData_DTO                          ;
  reg       RxBypassEn_DTO                            ;
  reg       RxBypassDataPad_DTO                       ;
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
//***********************SE: DQ/DMI/CA******************************//
  reg [7:0] RxBypassRcvEn_DFI1_B0_D                   ;
  reg [7:0] RxBypassRcvEn_DFI1_B1_D                   ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] RxBypassRcvEn_DFI1_B2_D                   ;
  reg [7:0] RxBypassRcvEn_DFI1_B3_D                   ;
`endif                                       
  reg [3:0] RxBypassData_DFI1_B0_D0                   ;
  reg [3:0] RxBypassData_DFI1_B0_D1                   ;
  reg [3:0] RxBypassData_DFI1_B0_D2                   ;
  reg [3:0] RxBypassData_DFI1_B0_D3                   ;
  reg [3:0] RxBypassData_DFI1_B0_D4                   ;
  reg [3:0] RxBypassData_DFI1_B0_D5                   ;
  reg [3:0] RxBypassData_DFI1_B0_D6                   ;
  reg [3:0] RxBypassData_DFI1_B0_D7                   ;
  reg [3:0] RxBypassData_DFI1_B1_D0                   ;
  reg [3:0] RxBypassData_DFI1_B1_D1                   ;
  reg [3:0] RxBypassData_DFI1_B1_D2                   ;
  reg [3:0] RxBypassData_DFI1_B1_D3                   ;
  reg [3:0] RxBypassData_DFI1_B1_D4                   ;
  reg [3:0] RxBypassData_DFI1_B1_D5                   ;
  reg [3:0] RxBypassData_DFI1_B1_D6                   ;
  reg [3:0] RxBypassData_DFI1_B1_D7                   ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [3:0] RxBypassData_DFI1_B2_D0                   ;
  reg [3:0] RxBypassData_DFI1_B2_D1                   ;
  reg [3:0] RxBypassData_DFI1_B2_D2                   ;
  reg [3:0] RxBypassData_DFI1_B2_D3                   ;
  reg [3:0] RxBypassData_DFI1_B2_D4                   ;
  reg [3:0] RxBypassData_DFI1_B2_D5                   ;
  reg [3:0] RxBypassData_DFI1_B2_D6                   ;
  reg [3:0] RxBypassData_DFI1_B2_D7                   ;
  reg [3:0] RxBypassData_DFI1_B3_D0                   ;
  reg [3:0] RxBypassData_DFI1_B3_D1                   ;
  reg [3:0] RxBypassData_DFI1_B3_D2                   ;
  reg [3:0] RxBypassData_DFI1_B3_D3                   ;
  reg [3:0] RxBypassData_DFI1_B3_D4                   ;
  reg [3:0] RxBypassData_DFI1_B3_D5                   ;
  reg [3:0] RxBypassData_DFI1_B3_D6                   ;
  reg [3:0] RxBypassData_DFI1_B3_D7                   ;
`endif                                       
  reg [7:0] RxBypassPadEn_DFI1_B0_D                   ;
  reg [7:0] RxBypassPadEn_DFI1_B1_D                   ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] RxBypassPadEn_DFI1_B2_D                   ;
  reg [7:0] RxBypassPadEn_DFI1_B3_D                   ;
`endif                                       
  reg [7:0] RxBypassDataPad_DFI1_B0_D                 ;
  reg [7:0] RxBypassDataPad_DFI1_B1_D                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] RxBypassDataPad_DFI1_B2_D                 ;
  reg [7:0] RxBypassDataPad_DFI1_B3_D                 ;
`endif                                       
  reg [7:0]     TxBypassMode_DFI1_B0_D                    ;
  reg [7:0]     TxBypassMode_DFI1_B1_D                    ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0]     TxBypassMode_DFI1_B2_D                    ;
  reg [7:0]     TxBypassMode_DFI1_B3_D                    ;
`endif                                       
  reg [7:0]     TxBypassOE_DFI1_B0_D                      ;
  reg [7:0]     TxBypassOE_DFI1_B1_D                      ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0]     TxBypassOE_DFI1_B2_D                      ;
  reg [7:0]     TxBypassOE_DFI1_B3_D                      ;
`endif                                       
  reg [7:0] TxBypassData_DFI1_B0_D                    ;
  reg [7:0] TxBypassData_DFI1_B1_D                    ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [7:0] TxBypassData_DFI1_B2_D                    ;
  reg [7:0] TxBypassData_DFI1_B3_D                    ;
`endif                                       
                                             
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED          
  reg       RxBypassRcvEn_DFI1_B0_DMI                 ;
  reg       RxBypassRcvEn_DFI1_B1_DMI                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassRcvEn_DFI1_B2_DMI                 ;
  reg       RxBypassRcvEn_DFI1_B3_DMI                 ;
`endif                                       
  reg [3:0] RxBypassData_DFI1_B0_DMI                  ;
  reg [3:0] RxBypassData_DFI1_B1_DMI                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg [3:0] RxBypassData_DFI1_B2_DMI                  ;
  reg [3:0] RxBypassData_DFI1_B3_DMI                  ;
`endif                                       
  reg       RxBypassPadEn_DFI1_B0_DMI                 ;
  reg       RxBypassPadEn_DFI1_B1_DMI                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassPadEn_DFI1_B2_DMI                 ;
  reg       RxBypassPadEn_DFI1_B3_DMI                 ;
`endif                                       
  reg       RxBypassDataPad_DFI1_B0_DMI               ;
  reg       RxBypassDataPad_DFI1_B1_DMI               ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataPad_DFI1_B2_DMI               ;
  reg       RxBypassDataPad_DFI1_B3_DMI               ;
`endif                                       
  reg       TxBypassMode_DFI1_B0_DMI                  ;
  reg       TxBypassMode_DFI1_B1_DMI                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassMode_DFI1_B2_DMI                  ;
  reg       TxBypassMode_DFI1_B3_DMI                  ;
`endif                                       
  reg       TxBypassOE_DFI1_B0_DMI                    ;
  reg       TxBypassOE_DFI1_B1_DMI                    ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassOE_DFI1_B2_DMI                    ;
  reg       TxBypassOE_DFI1_B3_DMI                    ;
`endif                                       
  reg       TxBypassData_DFI1_B0_DMI                  ;
  reg       TxBypassData_DFI1_B1_DMI                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassData_DFI1_B2_DMI                  ;
  reg       TxBypassData_DFI1_B3_DMI                  ;
`endif                                       
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED     
                                             
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] RxBypassRcvEn_DFI1_CA;
  reg [3:0] RxBypassData_DFI1_CA0                     ;
  reg [3:0] RxBypassData_DFI1_CA1                     ;
  reg [3:0] RxBypassData_DFI1_CA2                     ;
  reg [3:0] RxBypassData_DFI1_CA3                     ;
  reg [3:0] RxBypassData_DFI1_CA4                     ;
  reg [3:0] RxBypassData_DFI1_CA5                     ;
  reg [3:0] RxBypassData_DFI1_CA6                     ;
`ifdef DWC_DDRPHY_NUM_RANKS_2                
  reg [3:0] RxBypassData_DFI1_CA7                     ;
`endif                                       
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] RxBypassPadEn_DFI1_CA;
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] RxBypassDataPad_DFI1_CA; 
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] TxBypassMode_DFI1_CA                      ;
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] TxBypassOE_DFI1_CA                        ;
  reg [5+`DWC_DDRPHY_NUM_RANKS:0] TxBypassData_DFI1_CA ;
  ;
//*********************DIFF: DQS/WCK/CK******;
  reg       RxBypassRcvEn_DFI1_B0_DQS                 ;
  reg       RxBypassRcvEn_DFI1_B1_DQS                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassRcvEn_DFI1_B2_DQS                 ;
  reg       RxBypassRcvEn_DFI1_B3_DQS                 ;
`endif                                       
  reg       RxBypassDataRcv_DFI1_B0_DQS_T             ;
  reg       RxBypassDataRcv_DFI1_B0_DQS_C             ;
  reg       RxBypassDataRcv_DFI1_B1_DQS_T             ;
  reg       RxBypassDataRcv_DFI1_B1_DQS_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataRcv_DFI1_B2_DQS_T             ;
  reg       RxBypassDataRcv_DFI1_B2_DQS_C             ;
  reg       RxBypassDataRcv_DFI1_B3_DQS_T             ;
  reg       RxBypassDataRcv_DFI1_B3_DQS_C             ;
`endif                                       
  reg       RxBypassPadEn_DFI1_B0_DQS                 ;
  reg       RxBypassPadEn_DFI1_B1_DQS                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassPadEn_DFI1_B2_DQS                 ;
  reg       RxBypassPadEn_DFI1_B3_DQS                 ;
`endif                                      
  reg       RxBypassDataPad_DFI1_B0_DQS_T             ;
  reg       RxBypassDataPad_DFI1_B0_DQS_C             ;
  reg       RxBypassDataPad_DFI1_B1_DQS_T             ;
  reg       RxBypassDataPad_DFI1_B1_DQS_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataPad_DFI1_B2_DQS_T             ;
  reg       RxBypassDataPad_DFI1_B2_DQS_C             ;
  reg       RxBypassDataPad_DFI1_B3_DQS_T             ;
  reg       RxBypassDataPad_DFI1_B3_DQS_C             ;
`endif                                       
  reg       TxBypassMode_DFI1_B0_DQS_T                  ;
  reg       TxBypassMode_DFI1_B0_DQS_C                  ;
  reg       TxBypassMode_DFI1_B1_DQS_T                  ;
  reg       TxBypassMode_DFI1_B1_DQS_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassMode_DFI1_B2_DQS_T                  ;
  reg       TxBypassMode_DFI1_B2_DQS_C                  ;
  reg       TxBypassMode_DFI1_B3_DQS_T                  ;
  reg       TxBypassMode_DFI1_B3_DQS_C                  ;
`endif                                       
  reg       TxBypassOE_DFI1_B0_DQS_T                  ;
  reg       TxBypassOE_DFI1_B0_DQS_C                  ;
  reg       TxBypassOE_DFI1_B1_DQS_T                  ;
  reg       TxBypassOE_DFI1_B1_DQS_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassOE_DFI1_B2_DQS_T                  ;
  reg       TxBypassOE_DFI1_B2_DQS_C                  ;
  reg       TxBypassOE_DFI1_B3_DQS_T                  ;
  reg       TxBypassOE_DFI1_B3_DQS_C                  ;
`endif                                       
  reg       TxBypassData_DFI1_B0_DQS_T                ;
  reg       TxBypassData_DFI1_B0_DQS_C                ;
  reg       TxBypassData_DFI1_B1_DQS_T                ;
  reg       TxBypassData_DFI1_B1_DQS_C                ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassData_DFI1_B2_DQS_T                ;
  reg       TxBypassData_DFI1_B2_DQS_C                ;
  reg       TxBypassData_DFI1_B3_DQS_T                ;
  reg       TxBypassData_DFI1_B3_DQS_C                ;
`endif                                       
                                             
`ifdef DWC_DDRPHY_LPDDR5_ENABLED             
  reg       RxBypassRcvEn_DFI1_B0_WCK                 ;
  reg       RxBypassRcvEn_DFI1_B1_WCK                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassRcvEn_DFI1_B2_WCK                 ;
  reg       RxBypassRcvEn_DFI1_B3_WCK                 ;
`endif                                       
  reg       RxBypassDataRcv_DFI1_B0_WCK_T             ;
  reg       RxBypassDataRcv_DFI1_B0_WCK_C             ;
  reg       RxBypassDataRcv_DFI1_B1_WCK_T             ;
  reg       RxBypassDataRcv_DFI1_B1_WCK_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataRcv_DFI1_B2_WCK_T             ;
  reg       RxBypassDataRcv_DFI1_B2_WCK_C             ;
  reg       RxBypassDataRcv_DFI1_B3_WCK_T             ;
  reg       RxBypassDataRcv_DFI1_B3_WCK_C             ;
`endif                                       
  reg       RxBypassPadEn_DFI1_B0_WCK                 ;
  reg       RxBypassPadEn_DFI1_B1_WCK                 ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassPadEn_DFI1_B2_WCK                 ;
  reg       RxBypassPadEn_DFI1_B3_WCK                 ;
`endif                                       
  reg       RxBypassDataPad_DFI1_B0_WCK_T             ;
  reg       RxBypassDataPad_DFI1_B0_WCK_C             ;
  reg       RxBypassDataPad_DFI1_B1_WCK_T             ;
  reg       RxBypassDataPad_DFI1_B1_WCK_C             ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       RxBypassDataPad_DFI1_B2_WCK_T             ;
  reg       RxBypassDataPad_DFI1_B2_WCK_C             ;
  reg       RxBypassDataPad_DFI1_B3_WCK_T             ;
  reg       RxBypassDataPad_DFI1_B3_WCK_C             ;
`endif                                       
  reg       TxBypassMode_DFI1_B0_WCK_T                  ;
  reg       TxBypassMode_DFI1_B0_WCK_C                  ;
  reg       TxBypassMode_DFI1_B1_WCK_T                  ;
  reg       TxBypassMode_DFI1_B1_WCK_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassMode_DFI1_B2_WCK_T                  ;
  reg       TxBypassMode_DFI1_B2_WCK_C                  ;
  reg       TxBypassMode_DFI1_B3_WCK_T                  ;
  reg       TxBypassMode_DFI1_B3_WCK_C                  ;
`endif                                       
  reg       TxBypassOE_DFI1_B0_WCK_T                  ;
  reg       TxBypassOE_DFI1_B0_WCK_C                  ;
  reg       TxBypassOE_DFI1_B1_WCK_T                  ;
  reg       TxBypassOE_DFI1_B1_WCK_C                  ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassOE_DFI1_B2_WCK_T                  ;
  reg       TxBypassOE_DFI1_B2_WCK_C                  ;
  reg       TxBypassOE_DFI1_B3_WCK_T                  ;
  reg       TxBypassOE_DFI1_B3_WCK_C                  ;
`endif                                       
  reg       TxBypassData_DFI1_B0_WCK_T                ;
  reg       TxBypassData_DFI1_B0_WCK_C                ;
  reg       TxBypassData_DFI1_B1_WCK_T                ;
  reg       TxBypassData_DFI1_B1_WCK_C                ;
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  reg       TxBypassData_DFI1_B2_WCK_T                ;
  reg       TxBypassData_DFI1_B2_WCK_C                ;
  reg       TxBypassData_DFI1_B3_WCK_T                ;
  reg       TxBypassData_DFI1_B3_WCK_C                ;
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED;

  reg       RxBypassRcvEn_DFI1_CK                     ;
  reg       RxBypassDataRcv_DFI1_CK_T                 ;
  reg       RxBypassDataRcv_DFI1_CK_C                 ;
  reg       RxBypassPadEn_DFI1_CK                     ;
  reg       RxBypassDataPad_DFI1_CK_T                 ;
  reg       RxBypassDataPad_DFI1_CK_C                 ;
  reg       TxBypassMode_DFI1_CK_T                      ;
  reg       TxBypassMode_DFI1_CK_C                      ;
  reg       TxBypassOE_DFI1_CK_T                      ;
  reg       TxBypassOE_DFI1_CK_C                      ;
  reg       TxBypassData_DFI1_CK_T                    ;
  reg       TxBypassData_DFI1_CK_C                    ;
//************************* SEC *************
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] RxBypassPadEn_DFI1_LP4CKE_LP5CS           ;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] RxBypassDataPad_DFI1_LP4CKE_LP5CS         ;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] TxBypassMode_DFI1_LP4CKE_LP5CS            ;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] TxBypassOE_DFI1_LP4CKE_LP5CS              ;
  reg [`DWC_DDRPHY_NUM_RANKS-1:0] TxBypassData_DFI1_LP4CKE_LP5CS            ;
`endif // DWC_DDRPHY_NUM_CHANNELS_2
`endif  //FLYOVER_TEST

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
wire [`DWC_DDRPHY_DFI1_CKE_WIDTH-1:0] dwc_dfi1_cke_P0, dwc_dfi1_cke_P1, dwc_dfi1_cke_P2, dwc_dfi1_cke_P3;
wire [`DWC_DDRPHY_DFI1_CS_WIDTH-1:0] dwc_dfi1_cs_P0, dwc_dfi1_cs_P1, dwc_dfi1_cs_P2, dwc_dfi1_cs_P3;
`ifdef LP5_STD
wire [`DWC_DDRPHY_DFI1_P0_ADDRESS_MSB:0] dwc_dfi1_address_P0;
wire [`DWC_DDRPHY_DFI1_ADDRESS_WIDTH-1:0] dwc_dfi1_address_P1, dwc_dfi1_address_P2, dwc_dfi1_address_P3;
`else
wire [`DWC_DDRPHY_DFI1_P0_ADDRESS_MSB:0] dwc_dfi1_address_P0;
wire [`DWC_DDRPHY_DFI1_ADDRESS_WIDTH-1:0] dwc_dfi1_address_P1, dwc_dfi1_address_P2, dwc_dfi1_address_P3;
`endif
wire [`DWC_DDRPHY_DFI1_FREQUENCY_WIDTH-1  : 0 ] dwc_dfi1_frequency  ;
wire [`DWC_DDRPHY_DFI1_FREQ_RATIO_WIDTH-1 : 0 ] dwc_dfi1_freq_ratio ;
wire [`DWC_DDRPHY_DFI1_FREQ_FSP_WIDTH-1   : 0 ] dwc_dfi1_freq_fsp   ;
wire [`DWC_DDRPHY_DFI1_INIT_START_WIDTH-1:0] dwc_dfi1_init_start;
//wire [`DFI0_INIT_COMPLETE_WIDTH-1:0] dwc_dfi1_init_complete;
// if dfi_mode = 3
`ifdef DFI_MODE5
assign dwc_dfi1_cke_P0 = {`DWC_DDRPHY_DFI1_CKE_WIDTH{1'b0}};
assign dwc_dfi1_cke_P1 = {`DWC_DDRPHY_DFI1_CKE_WIDTH{1'b0}};
assign dwc_dfi1_cke_P2 = {`DWC_DDRPHY_DFI1_CKE_WIDTH{1'b0}};
assign dwc_dfi1_cke_P3 = {`DWC_DDRPHY_DFI1_CKE_WIDTH{1'b0}};
assign dwc_dfi1_cs_P0  = {`DWC_DDRPHY_DFI1_CS_WIDTH{1'b1}};
assign dwc_dfi1_cs_P1  = {`DWC_DDRPHY_DFI1_CS_WIDTH{1'b1}};
assign dwc_dfi1_cs_P2  = {`DWC_DDRPHY_DFI1_CS_WIDTH{1'b1}};
assign dwc_dfi1_cs_P3  = {`DWC_DDRPHY_DFI1_CS_WIDTH{1'b1}};
assign dwc_dfi1_address_P0 = {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'b0}};
assign dwc_dfi1_address_P1 = {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'b0}};
assign dwc_dfi1_address_P2 = {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'b0}};
assign dwc_dfi1_address_P3 = {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'b0}};
assign dwc_dfi1_frequency   = {`DWC_DDRPHY_DFI1_FREQUENCY_WIDTH{1'b0}};
assign dwc_dfi1_freq_ratio = dfi0_freq_ratio;
assign dwc_dfi1_freq_fsp   = dfi0_freq_fsp;

assign dwc_dfi1_init_start = {`DWC_DDRPHY_DFI1_INIT_START_WIDTH{1'b0}};

assign dwc_dfi1_init_complete = dfi0_init_complete;  //dfi1_init_complete is always 0, and dfi_data is call by dfi_drv, however dfi_drv1 is waiting dfi1_init_complete during inital task.
`else
assign dwc_dfi1_cke_P0 = dfi1_cke_P0;
assign dwc_dfi1_cke_P1 = dfi1_cke_P1;
assign dwc_dfi1_cke_P2 = dfi1_cke_P2;
assign dwc_dfi1_cke_P3 = dfi1_cke_P3;
assign dwc_dfi1_cs_P0  = dfi1_cs_P0;
assign dwc_dfi1_cs_P1  = dfi1_cs_P1;
assign dwc_dfi1_cs_P2  = dfi1_cs_P2;
assign dwc_dfi1_cs_P3  = dfi1_cs_P3;
assign dwc_dfi1_address_P0 = dfi1_address_P0;
assign dwc_dfi1_address_P1 = dfi1_address_P1;
assign dwc_dfi1_address_P2 = dfi1_address_P2;
assign dwc_dfi1_address_P3 = dfi1_address_P3;
assign dwc_dfi1_frequency  = dfi1_frequency  ;
assign dwc_dfi1_freq_ratio = dfi1_freq_ratio ;
assign dwc_dfi1_freq_fsp   = dfi1_freq_fsp   ;

assign dwc_dfi1_init_start = dfi1_init_start;
assign dwc_dfi1_init_complete = dfi1_init_complete;
`endif
`endif   
`ifndef DWC_DDRPHY_TOP_PG_PINS
//assign dwc_PwrOkIn_XDriver = ~((~top.vdd) | (~top.vddq) | (~top.dut.VAA_VDD2H) | (~top.dut.VDD2H));
assign dwc_PwrOkIn_XDriver = ~((~top.vdd) | (~top.vddq) | (~top.vaa));
assign dwc_PwrOkIn_X = ~((~top.vdd)  | (~top.vaa));
`endif
assign dfi_ctl_clk_assign = dfi_ctl_clk;
// upf and control xprop enable signal
reg dis_upf_xprop;
reg dis_upf_xprop_1;


`ifdef DWC_DDRPHY_TOP_PG_PINS
  `ifndef PREFIX_OPT_ENABLE
     dwc_ddrphy_top dut (
  `else
    `dwc_ddrphy_top dut (
  `endif

// ----------DFI Interface  ------------------------------
.DfiClk                                 ( dfi_ctl_clk_assign                  ),
.dfi_reset_n				( dfi_reset_n                     ),
.dfi0_address_P0			( dfi0_address_P0                 ), 
.dfi0_address_P1			( dfi0_address_P1                 ),
.dfi0_address_P2			( dfi0_address_P2                 ),
.dfi0_address_P3			( dfi0_address_P3                 ),

.dfi0_cke_P0				( dfi0_cke_P0                     ),
.dfi0_cke_P1			        ( dfi0_cke_P1                     ),
.dfi0_cke_P2				( dfi0_cke_P2                     ),
.dfi0_cke_P3			        ( dfi0_cke_P3                     ),

.dfi0_cs_P0                             ( dfi0_cs_P0                      ),
.dfi0_cs_P1                             ( dfi0_cs_P1                      ),
.dfi0_cs_P2                             ( dfi0_cs_P2                      ),
.dfi0_cs_P3                             ( dfi0_cs_P3                      ),

`ifdef DWC_DDRPHY_LPDDR5_ENABLED
`ifdef LP5_STD
.dfi0_wck_en_P0                         ( dfi0_wck_en_P0                  ),
.dfi0_wck_en_P1                         ( dfi0_wck_en_P1                  ),
.dfi0_wck_en_P2                         ( dfi0_wck_en_P2                  ),
.dfi0_wck_en_P3                         ( dfi0_wck_en_P3                  ),

.dfi0_wck_cs_P0                         ( dfi0_wck_cs_P0                  ),
.dfi0_wck_cs_P1                         ( dfi0_wck_cs_P1                  ),
.dfi0_wck_cs_P2                         ( dfi0_wck_cs_P2                  ),
.dfi0_wck_cs_P3                         ( dfi0_wck_cs_P3                  ),

.dfi0_wck_toggle_P0                     ( dfi0_wck_toggle_P0              ),
.dfi0_wck_toggle_P1                     ( dfi0_wck_toggle_P1              ),
.dfi0_wck_toggle_P2                     ( dfi0_wck_toggle_P2              ),
.dfi0_wck_toggle_P3                     ( dfi0_wck_toggle_P3              ),

//.dfi0_wrdata_link_ecc_P0                ( dfi0_wrdata_link_ecc_P1         ),
//.dfi0_wrdata_link_ecc_P1                ( dfi0_wrdata_link_ecc_P2         ),
//.dfi0_wrdata_link_ecc_P2                ( dfi0_wrdata_link_ecc_P3         ),
//.dfi0_wrdata_link_ecc_P3                ( dfi0_wrdata_link_ecc_P4         ),
`else
.dfi0_wck_write_P0                      ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),   
.dfi0_wck_write_P1                      ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_write_P2                      ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_write_P3                      ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_en_P0                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_en_P1                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_en_P2                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_en_P3                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_cs_P0                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),
.dfi0_wck_cs_P1                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),
.dfi0_wck_cs_P2                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),
.dfi0_wck_cs_P3                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),

.dfi0_wck_toggle_P0                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi0_wck_toggle_P1                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi0_wck_toggle_P2                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi0_wck_toggle_P3                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),

.dfi0_wrdata_link_ecc_P0                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P1                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P2                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P3                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
`endif
`endif

.dfi0_ctrlupd_ack			( dfi0_ctrlupd_ack                ),
.dfi0_ctrlupd_req			( dfi0_ctrlupd_req                ),
`ifndef PUB_VERSION_LE_0200 //RID < 0200
.dfi0_ctrlupd_type	( 2'b00 ),
`endif

.dfi0_dram_clk_disable_P0		( dfi0_dram_clk_disable_P0        ),	
.dfi0_dram_clk_disable_P1		( dfi0_dram_clk_disable_P1        ),
.dfi0_dram_clk_disable_P2		( dfi0_dram_clk_disable_P2        ),	
.dfi0_dram_clk_disable_P3		( dfi0_dram_clk_disable_P3        ),

.dfi0_error         ( dfi0_error                      ),
.dfi0_error_info    ( dfi0_error_info                 ),
.dfi0_frequency     ( dfi0_frequency                  ),
.dfi0_freq_ratio    ( dfi0_freq_ratio                 ),
.dfi0_init_complete ( dfi0_init_complete              ),
.dfi0_init_start    ( dfi0_init_start                 ),
//.dfi0_phy_info_ack                      ( dfi0_phy_info_ack               ),
//.dfi0_phy_info_req                      ( dfi0_phy_info_req               ),
//.dfi0_phy_info_cmd                      ( dfi0_phy_info_cmd               ),
//.dfi0_phy_info_data                     ( dfi0_phy_info_data              ),
.dfi0_lp_ctrl_ack    ( dfi0_lp_ctrl_ack    ) ,
.dfi0_lp_data_ack    ( dfi0_lp_data_ack    ) ,
.dfi0_lp_ctrl_req    ( dfi0_lp_ctrl_req    ) ,
.dfi0_lp_data_req    ( dfi0_lp_data_req    ) ,
.dfi0_freq_fsp       ( dfi0_freq_fsp       ) ,
.dfi0_lp_ctrl_wakeup ( dfi0_lp_ctrl_wakeup ) ,
.dfi0_lp_data_wakeup ( dfi0_lp_data_wakeup ) ,

.dfi0_phymstr_ack       ( dfi0_phymstr_ack                           ) ,
.dfi0_phymstr_cs_state  ( dfi0_phymstr_cs_state                      ) ,
.dfi0_phymstr_req       ( dfi0_phymstr_req                           ) ,
.dfi0_phymstr_state_sel ( dfi0_phymstr_state_sel                     ) ,
.dfi0_phymstr_type      ( dfi0_phymstr_type                          ) ,
.dfi0_phyupd_ack        ( dfi0_phyupd_ack                            ) ,
.dfi0_phyupd_req        ( dfi0_phyupd_req                            ) ,
.dfi0_phyupd_type       ( dfi0_phyupd_type                           ) ,
.dfi0_rddata_W0         ( dfi0_rddata_W0                  ),
.dfi0_rddata_W1         ( dfi0_rddata_W1                  ),
.dfi0_rddata_W2         ( dfi0_rddata_W2                  ),
.dfi0_rddata_W3         ( dfi0_rddata_W3                  ),
.dfi0_rddata_cs_P0      ( dfi0_rddata_cs_P0               ),
.dfi0_rddata_cs_P1      ( dfi0_rddata_cs_P1               ),
.dfi0_rddata_cs_P2      ( dfi0_rddata_cs_P2               ),
.dfi0_rddata_cs_P3      ( dfi0_rddata_cs_P3               ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi0_rddata_dbi_W0			( dfi0_rddata_dbi_W0              ),
.dfi0_rddata_dbi_W1			( dfi0_rddata_dbi_W1              ),
.dfi0_rddata_dbi_W2			( dfi0_rddata_dbi_W2              ),
.dfi0_rddata_dbi_W3			( dfi0_rddata_dbi_W3              ),
`endif
.dfi0_rddata_en_P0			( dfi0_rddata_en_P0               ),
.dfi0_rddata_en_P1			( dfi0_rddata_en_P1               ),
.dfi0_rddata_en_P2			( dfi0_rddata_en_P2               ),
.dfi0_rddata_en_P3			( dfi0_rddata_en_P3               ),
.dfi0_rddata_valid_W0			( dfi0_rddata_valid_W0            ),
.dfi0_rddata_valid_W1			( dfi0_rddata_valid_W1            ),
.dfi0_rddata_valid_W2			( dfi0_rddata_valid_W2            ),
.dfi0_rddata_valid_W3			( dfi0_rddata_valid_W3            ),
.dfi0_wrdata_P0			        ( dfi0_wrdata_P0                  ),
.dfi0_wrdata_P1			        ( dfi0_wrdata_P1                  ),
.dfi0_wrdata_P2			        ( dfi0_wrdata_P2                  ),
.dfi0_wrdata_P3			        ( dfi0_wrdata_P3                  ),
.dfi0_wrdata_cs_P0			( dfi0_wrdata_cs_P0               ),
.dfi0_wrdata_cs_P1			( dfi0_wrdata_cs_P1               ),
.dfi0_wrdata_cs_P2			( dfi0_wrdata_cs_P2               ),
.dfi0_wrdata_cs_P3			( dfi0_wrdata_cs_P3               ),
.dfi0_wrdata_en_P0			( dfi0_wrdata_en_P0               ),
.dfi0_wrdata_en_P1			( dfi0_wrdata_en_P1               ),
.dfi0_wrdata_en_P2			( dfi0_wrdata_en_P2               ),
.dfi0_wrdata_en_P3			( dfi0_wrdata_en_P3               ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi0_wrdata_mask_P0			( dfi0_wrdata_mask_P0             ),
.dfi0_wrdata_mask_P1			( dfi0_wrdata_mask_P1             ),
.dfi0_wrdata_mask_P2			( dfi0_wrdata_mask_P2             ),
.dfi0_wrdata_mask_P3			( dfi0_wrdata_mask_P3             ),	
`endif
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dfi1_address_P0			( dwc_dfi1_address_P0             ), 
.dfi1_address_P1			( dwc_dfi1_address_P1             ),
.dfi1_address_P2			( dfi1_address_P2                 ),
.dfi1_address_P3			( dfi1_address_P3                 ),

.dfi1_cke_P0				( dwc_dfi1_cke_P0                 ),
.dfi1_cke_P1			        ( dwc_dfi1_cke_P1                 ),
.dfi1_cke_P2				( dfi1_cke_P2                     ),
.dfi1_cke_P3			        ( dfi1_cke_P3                     ),

.dfi1_cs_P0                             ( dwc_dfi1_cs_P0                  ),
.dfi1_cs_P1                             ( dwc_dfi1_cs_P1                  ),
.dfi1_cs_P2                             ( dfi1_cs_P2                      ),
.dfi1_cs_P3                             ( dfi1_cs_P3                      ),

`ifdef DWC_DDRPHY_LPDDR5_ENABLED
`ifdef LP5_STD
.dfi1_wck_en_P0                         ( dfi1_wck_en_P0                  ),
.dfi1_wck_en_P1                         ( dfi1_wck_en_P1                  ),
.dfi1_wck_en_P2                         ( dfi1_wck_en_P2                  ),
.dfi1_wck_en_P3                         ( dfi1_wck_en_P3                  ),

.dfi1_wck_cs_P0                         ( dfi1_wck_cs_P0                  ),
.dfi1_wck_cs_P1                         ( dfi1_wck_cs_P1                  ),
.dfi1_wck_cs_P2                         ( dfi1_wck_cs_P2                  ),
.dfi1_wck_cs_P3                         ( dfi1_wck_cs_P3                  ),

.dfi1_wck_toggle_P0                     ( dfi1_wck_toggle_P0              ),
.dfi1_wck_toggle_P1                     ( dfi1_wck_toggle_P1              ),
.dfi1_wck_toggle_P2                     ( dfi1_wck_toggle_P2              ),
.dfi1_wck_toggle_P3                     ( dfi1_wck_toggle_P3              ),
//.dfi1_wrdata_link_ecc_P0                ( dfi1_wrdata_link_ecc_P1         ),
//.dfi1_wrdata_link_ecc_P1                ( dfi1_wrdata_link_ecc_P2         ),
//.dfi1_wrdata_link_ecc_P2                ( dfi1_wrdata_link_ecc_P3         ),
//.dfi1_wrdata_link_ecc_P3                ( dfi1_wrdata_link_ecc_P4         ),
`else
.dfi1_wck_write_P0                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),   
.dfi1_wck_write_P1                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_write_P2                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_write_P3                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_en_P0                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_en_P1                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_en_P2                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_en_P3                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_cs_P0                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),
.dfi1_wck_cs_P1                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),
.dfi1_wck_cs_P2                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),
.dfi1_wck_cs_P3                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),

.dfi1_wck_toggle_P0                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi1_wck_toggle_P1                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi1_wck_toggle_P2                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi1_wck_toggle_P3                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),

.dfi1_wrdata_link_ecc_P0                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P1                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P2                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P3                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
`endif
`endif

.dfi1_ctrlupd_ack         ( dfi1_ctrlupd_ack                ),
.dfi1_ctrlupd_req         ( {`DWC_DDRPHY_DFI1_CTRLUPD_REQ_WIDTH{1'b0}} ),
`ifndef PUB_VERSION_LE_0200 //RID < 0200
.dfi1_ctrlupd_type	( 2'b00 ),
`endif


.dfi1_dram_clk_disable_P0 ( dfi1_dram_clk_disable_P0        ),
.dfi1_dram_clk_disable_P1 ( dfi1_dram_clk_disable_P1        ),
.dfi1_dram_clk_disable_P2 ( dfi1_dram_clk_disable_P2        ),
.dfi1_dram_clk_disable_P3 ( dfi1_dram_clk_disable_P3        ),

.dfi1_error               ( dfi1_error                      ),
.dfi1_error_info          ( dfi1_error_info                 ),
.dfi1_frequency           ( dwc_dfi1_frequency              ),
.dfi1_freq_ratio          ( dwc_dfi1_freq_ratio             ),
.dfi1_init_complete       ( dfi1_init_complete              ),
.dfi1_init_start          ( dwc_dfi1_init_start             ),
//.dfi1_phy_info_ack      ( dfi1_phy_info_ack               ),
//.dfi1_phy_info_req      ( dfi1_phy_info_req               ),
//.dfi1_phy_info_cmd      ( dfi1_phy_info_cmd               ),
//.dfi1_phy_info_data     ( dfi1_phy_info_data              ),
.dfi1_lp_ctrl_ack         ( dfi1_lp_ctrl_ack                ),
.dfi1_lp_data_ack         ( dfi1_lp_data_ack                ),
.dfi1_lp_ctrl_req         ( dfi1_lp_ctrl_req                ),
.dfi1_lp_data_req         ( dfi1_lp_data_req                ),
.dfi1_freq_fsp            ( dwc_dfi1_freq_fsp               ),
.dfi1_lp_ctrl_wakeup      ( dfi1_lp_ctrl_wakeup             ),
.dfi1_lp_data_wakeup      ( dfi1_lp_data_wakeup             ),
.dfi1_phymstr_ack         ( {`DWC_DDRPHY_DFI1_PHYMSTR_ACK_WIDTH{1'b0}} ),
.dfi1_phymstr_cs_state    ( dfi1_phymstr_cs_state           ),
.dfi1_phymstr_req         ( dfi1_phymstr_req                ),
.dfi1_phymstr_state_sel   ( dfi1_phymstr_state_sel          ),
.dfi1_phymstr_type        ( dfi1_phymstr_type               ),
.dfi1_phyupd_ack          ( {`DWC_DDRPHY_DFI1_PHYUPD_ACK_WIDTH{1'b0}}  ),
.dfi1_phyupd_req          ( dfi1_phyupd_req                 ),
.dfi1_phyupd_type         ( dfi1_phyupd_type                ),
.dfi1_rddata_W0           ( dfi1_rddata_W0                  ),
.dfi1_rddata_W1           ( dfi1_rddata_W1                  ),
.dfi1_rddata_W2           ( dfi1_rddata_W2                  ),
.dfi1_rddata_W3           ( dfi1_rddata_W3                  ),
.dfi1_rddata_cs_P0			( dfi1_rddata_cs_P0               ),
.dfi1_rddata_cs_P1			( dfi1_rddata_cs_P1               ),
.dfi1_rddata_cs_P2			( dfi1_rddata_cs_P2               ),
.dfi1_rddata_cs_P3			( dfi1_rddata_cs_P3               ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi1_rddata_dbi_W0			( dfi1_rddata_dbi_W0              ),
.dfi1_rddata_dbi_W1			( dfi1_rddata_dbi_W1              ),
.dfi1_rddata_dbi_W2			( dfi1_rddata_dbi_W2              ),
.dfi1_rddata_dbi_W3			( dfi1_rddata_dbi_W3              ),
`endif
.dfi1_rddata_en_P0			( dfi1_rddata_en_P0               ),
.dfi1_rddata_en_P1			( dfi1_rddata_en_P1               ),
.dfi1_rddata_en_P2			( dfi1_rddata_en_P2               ),
.dfi1_rddata_en_P3			( dfi1_rddata_en_P3               ),
.dfi1_rddata_valid_W0			( dfi1_rddata_valid_W0            ),
.dfi1_rddata_valid_W1			( dfi1_rddata_valid_W1            ),
.dfi1_rddata_valid_W2			( dfi1_rddata_valid_W2            ),
.dfi1_rddata_valid_W3			( dfi1_rddata_valid_W3            ),
.dfi1_wrdata_P0			        ( dfi1_wrdata_P0                  ),
.dfi1_wrdata_P1			        ( dfi1_wrdata_P1                  ),
.dfi1_wrdata_P2			        ( dfi1_wrdata_P2                  ),
.dfi1_wrdata_P3			        ( dfi1_wrdata_P3                  ),
.dfi1_wrdata_cs_P0			( dfi1_wrdata_cs_P0               ),
.dfi1_wrdata_cs_P1			( dfi1_wrdata_cs_P1               ),
.dfi1_wrdata_cs_P2			( dfi1_wrdata_cs_P2               ),
.dfi1_wrdata_cs_P3			( dfi1_wrdata_cs_P3               ),
.dfi1_wrdata_en_P0			( dfi1_wrdata_en_P0               ),
.dfi1_wrdata_en_P1			( dfi1_wrdata_en_P1               ),
.dfi1_wrdata_en_P2			( dfi1_wrdata_en_P2               ),
.dfi1_wrdata_en_P3			( dfi1_wrdata_en_P3               ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi1_wrdata_mask_P0			( dfi1_wrdata_mask_P0             ),
.dfi1_wrdata_mask_P1			( dfi1_wrdata_mask_P1             ),
.dfi1_wrdata_mask_P2			( dfi1_wrdata_mask_P2             ),
.dfi1_wrdata_mask_P3			( dfi1_wrdata_mask_P3             ),
`endif   
`endif

// ----------PHY Pin Interface  ------------------------------
//------------------------ SRAM interface for ICCM ---------
.iccm_data_dout                         ( iccm_data_dout                  ),
.iccm_data_din                          ( iccm_data_din                   ),
.iccm_data_addr                         ( iccm_data_addr                  ),
.iccm_data_ce                           ( iccm_data_ce                    ),
.iccm_data_we                           ( iccm_data_we                    ),

//------------------------ SRAM interface for DCCM ---------
.dccm_data_dout                         ( dccm_data_dout                  ),
.dccm_data_din                          ( dccm_data_din                   ),
.dccm_data_addr                         ( dccm_data_addr                  ),
.dccm_data_ce                           ( dccm_data_ce                    ),
.dccm_data_we                           ( dccm_data_we                    ),
// SRAM interface CLK //////////////////////////////////////////////////////////
//.pmu_sram_clken                         ( pmu_sram_clken                  ),

//------------------------ Interface to External ACSM Memory ---------
.acsm_data_dout                         ( acsm_data_dout                  ),
.acsm_data_din                          ( acsm_data_din                   ),
.acsm_data_addr                         ( acsm_data_addr                  ),
.acsm_data_ce                           ( acsm_data_ce                    ),
.acsm_data_we                           ( acsm_data_we                    ),

//.RxBypassDataSel                        ( 2'h0 ),

`ifdef PUB_103A_PLUS
  `ifdef DWC_DDRPHY_EXISTS_DB0
    .VDDQ_DB0                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB1
    .VDDQ_DB1                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB2
    .VDDQ_DB2                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB3
    .VDDQ_DB3                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB4
    .VDDQ_DB4                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB5
    .VDDQ_DB5                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB6
    .VDDQ_DB6                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB7
    .VDDQ_DB7                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_AC0
    .VDD2H_AC0                   ( vaa  ) ,
    .VDDQ_AC0                    ( vddq ) ,
  `endif
  `ifdef DWC_DDRPHY_EXISTS_AC1
    .VDD2H_AC1                   ( vaa  ) ,
    .VDDQ_AC1                    ( vddq ) ,
  `endif

  .VDDQ_MASTER                 ( vddq ) ,
  .VDD2H_MASTER                ( vaa  ) ,
`else
  .VDDQ                 ( vddq ) ,
  .VDD2H                ( vaa  ) ,
`endif

.VDD                         ( vdd  ) ,
.VSS                         ( 1'b0 ) ,
.VAA_VDD2H                   ( vaa  ) ,

//.BP_RET                                 ( BP_RET                          ),
.BP_MEMRESET_L                          ( BP_MEMRESET_L                   ),
.BP_DTO                                 ( BP_DTO                          ),
.BP_ATO                                 ( BP_ATO                          ),
.BP_ZN                                  ( BP_ZN                           ),

.BP_DFI0_CA                             ( BP_DFI0_CA                      ),
.BP_DFI0_LP4CKE_LP5CS                   ( BP_DFI0_LP4CKE_LP5CS            ),
.BP_DFI0_CK_T                           ( BP_DFI0_CK_T                    ),
.BP_DFI0_CK_C                           ( BP_DFI0_CK_C                    ),
.BP_DFI0_B0_D                           ( BP_DFI0_B0_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B0_DMI                         ( BP_DFI0_B0_DMI                  ),
`endif
.BP_DFI0_B0_DQS_T                       ( BP_DFI0_B0_DQS_T                ),
.BP_DFI0_B0_DQS_C                       ( BP_DFI0_B0_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B0_WCK_T                       ( BP_DFI0_B0_WCK_T                ),
.BP_DFI0_B0_WCK_C                       ( BP_DFI0_B0_WCK_C                ),
`endif
.BP_DFI0_B1_D                           ( BP_DFI0_B1_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B1_DMI                         ( BP_DFI0_B1_DMI                  ),
`endif
.BP_DFI0_B1_DQS_T                       ( BP_DFI0_B1_DQS_T                ),
.BP_DFI0_B1_DQS_C                       ( BP_DFI0_B1_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B1_WCK_T                       ( BP_DFI0_B1_WCK_T                ),
.BP_DFI0_B1_WCK_C                       ( BP_DFI0_B1_WCK_C                ),
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
.BP_DFI0_B2_D                           ( BP_DFI0_B2_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B2_DMI                         ( BP_DFI0_B2_DMI                  ),
`endif
.BP_DFI0_B2_DQS_T                       ( BP_DFI0_B2_DQS_T                ),
.BP_DFI0_B2_DQS_C                       ( BP_DFI0_B2_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B2_WCK_T                       ( BP_DFI0_B2_WCK_T                ),
.BP_DFI0_B2_WCK_C                       ( BP_DFI0_B2_WCK_C                ),
`endif
.BP_DFI0_B3_D                           ( BP_DFI0_B3_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B3_DMI                         ( BP_DFI0_B3_DMI                  ),
`endif
.BP_DFI0_B3_DQS_T                       ( BP_DFI0_B3_DQS_T                ),
.BP_DFI0_B3_DQS_C                       ( BP_DFI0_B3_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B3_WCK_T                       ( BP_DFI0_B3_WCK_T                ),
.BP_DFI0_B3_WCK_C                       ( BP_DFI0_B3_WCK_C                ),
`endif
`endif

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.BP_DFI1_CA                             ( BP_DFI1_CA                      ),
.BP_DFI1_LP4CKE_LP5CS                   ( BP_DFI1_LP4CKE_LP5CS            ),
.BP_DFI1_CK_T                           ( BP_DFI1_CK_T                    ),
.BP_DFI1_CK_C                           ( BP_DFI1_CK_C                    ),
.BP_DFI1_B0_D                           ( BP_DFI1_B0_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B0_DMI                         ( BP_DFI1_B0_DMI                  ),
`endif
.BP_DFI1_B0_DQS_T                       ( BP_DFI1_B0_DQS_T                ),
.BP_DFI1_B0_DQS_C                       ( BP_DFI1_B0_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B0_WCK_T                       ( BP_DFI1_B0_WCK_T                ),
.BP_DFI1_B0_WCK_C                       ( BP_DFI1_B0_WCK_C                ),
`endif
.BP_DFI1_B1_D                           ( BP_DFI1_B1_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B1_DMI                         ( BP_DFI1_B1_DMI                  ),
`endif
.BP_DFI1_B1_DQS_T                       ( BP_DFI1_B1_DQS_T                ),
.BP_DFI1_B1_DQS_C                       ( BP_DFI1_B1_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B1_WCK_T                       ( BP_DFI1_B1_WCK_T                ),
.BP_DFI1_B1_WCK_C                       ( BP_DFI1_B1_WCK_C                ),
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
.BP_DFI1_B2_D                           ( BP_DFI1_B2_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B2_DMI                         ( BP_DFI1_B2_DMI                  ),
`endif
.BP_DFI1_B2_DQS_T                       ( BP_DFI1_B2_DQS_T                ),
.BP_DFI1_B2_DQS_C                       ( BP_DFI1_B2_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B2_WCK_T                       ( BP_DFI1_B2_WCK_T                ),
.BP_DFI1_B2_WCK_C                       ( BP_DFI1_B2_WCK_C                ),
`endif
.BP_DFI1_B3_D                           ( BP_DFI1_B3_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B3_DMI                         ( BP_DFI1_B3_DMI                  ),
`endif
.BP_DFI1_B3_DQS_T                       ( BP_DFI1_B3_DQS_T                ),
.BP_DFI1_B3_DQS_C                       ( BP_DFI1_B3_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B3_WCK_T                       ( BP_DFI1_B3_WCK_T                ),
.BP_DFI1_B3_WCK_C                       ( BP_DFI1_B3_WCK_C                ),
`endif
`endif
`endif
//------------------------ APB Pins ------------------
.APBCLK			                ( apb_clk                         ),                       
.PADDR_APB				( paddr                           ),
.PWRITE_APB				( pwrite                          ),
.PRESETn_APB				( presetn                         ),
.PSELx_APB				( psel                            ),
.PENABLE_APB				( penable                         ),
.PWDATA_APB				( pwdata                          ),
.PSTRB_APB				( 2'b0                            ),

.PPROT_APB				( 3'b10                           ),

.PREADY_APB				( pready                          ),
.PRDATA_APB				( prdata                          ),
.PSLVERR_APB				( pslverr                         ),
                             
.PPROT_PIN				( 3'b010                          ),

////------------------------ Bypass interface ------------------
`ifdef FLYOVER_TEST
  .RxTestClk  (RxTestClk),
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI0_B0_D                   (RxBypassRcvEn_DFI0_B0_D            ), //8bit 
  .RxBypassRcvEn_DFI0_B1_D                   (RxBypassRcvEn_DFI0_B1_D            ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI0_B2_D                   (RxBypassRcvEn_DFI0_B2_D            ),
  .RxBypassRcvEn_DFI0_B3_D                   (RxBypassRcvEn_DFI0_B3_D            ),
`endif                                                                         
  .RxBypassData_DFI0_B0_D0                   (RxBypassData_DFI0_B0_D0            ), //4bit
  .RxBypassData_DFI0_B0_D1                   (RxBypassData_DFI0_B0_D1            ), //4bit
  .RxBypassData_DFI0_B0_D2                   (RxBypassData_DFI0_B0_D2            ), //4bit
  .RxBypassData_DFI0_B0_D3                   (RxBypassData_DFI0_B0_D3            ), //4bit
  .RxBypassData_DFI0_B0_D4                   (RxBypassData_DFI0_B0_D4            ), //4bit
  .RxBypassData_DFI0_B0_D5                   (RxBypassData_DFI0_B0_D5            ), //4bit
  .RxBypassData_DFI0_B0_D6                   (RxBypassData_DFI0_B0_D6            ), //4bit
  .RxBypassData_DFI0_B0_D7                   (RxBypassData_DFI0_B0_D7            ), //4bit
  .RxBypassData_DFI0_B1_D0                   (RxBypassData_DFI0_B1_D0            ), //4bit
  .RxBypassData_DFI0_B1_D1                   (RxBypassData_DFI0_B1_D1            ), //4bit
  .RxBypassData_DFI0_B1_D2                   (RxBypassData_DFI0_B1_D2            ), //4bit
  .RxBypassData_DFI0_B1_D3                   (RxBypassData_DFI0_B1_D3            ), //4bit
  .RxBypassData_DFI0_B1_D4                   (RxBypassData_DFI0_B1_D4            ), //4bit
  .RxBypassData_DFI0_B1_D5                   (RxBypassData_DFI0_B1_D5            ), //4bit
  .RxBypassData_DFI0_B1_D6                   (RxBypassData_DFI0_B1_D6            ), //4bit
  .RxBypassData_DFI0_B1_D7                   (RxBypassData_DFI0_B1_D7            ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassData_DFI0_B2_D0                   (RxBypassData_DFI0_B2_D0            ), //4bit
  .RxBypassData_DFI0_B2_D1                   (RxBypassData_DFI0_B2_D1            ), //4bit
  .RxBypassData_DFI0_B2_D2                   (RxBypassData_DFI0_B2_D2            ), //4bit
  .RxBypassData_DFI0_B2_D3                   (RxBypassData_DFI0_B2_D3            ), //4bit
  .RxBypassData_DFI0_B2_D4                   (RxBypassData_DFI0_B2_D4            ), //4bit
  .RxBypassData_DFI0_B2_D5                   (RxBypassData_DFI0_B2_D5            ), //4bit
  .RxBypassData_DFI0_B2_D6                   (RxBypassData_DFI0_B2_D6            ), //4bit
  .RxBypassData_DFI0_B2_D7                   (RxBypassData_DFI0_B2_D7            ), //4bit
  .RxBypassData_DFI0_B3_D0                   (RxBypassData_DFI0_B3_D0            ), //4bit
  .RxBypassData_DFI0_B3_D1                   (RxBypassData_DFI0_B3_D1            ), //4bit
  .RxBypassData_DFI0_B3_D2                   (RxBypassData_DFI0_B3_D2            ), //4bit
  .RxBypassData_DFI0_B3_D3                   (RxBypassData_DFI0_B3_D3            ), //4bit
  .RxBypassData_DFI0_B3_D4                   (RxBypassData_DFI0_B3_D4            ), //4bit
  .RxBypassData_DFI0_B3_D5                   (RxBypassData_DFI0_B3_D5            ), //4bit
  .RxBypassData_DFI0_B3_D6                   (RxBypassData_DFI0_B3_D6            ), //4bit
  .RxBypassData_DFI0_B3_D7                   (RxBypassData_DFI0_B3_D7            ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI0_B0_D                   (RxBypassPadEn_DFI0_B0_D            ), //8bit
  .RxBypassPadEn_DFI0_B1_D                   (RxBypassPadEn_DFI0_B1_D            ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI0_B2_D                   (RxBypassPadEn_DFI0_B2_D            ),
  .RxBypassPadEn_DFI0_B3_D                   (RxBypassPadEn_DFI0_B3_D            ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_D                 (RxBypassDataPad_DFI0_B0_D          ),
  .RxBypassDataPad_DFI0_B1_D                 (RxBypassDataPad_DFI0_B1_D          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI0_B2_D                 (RxBypassDataPad_DFI0_B2_D          ),
  .RxBypassDataPad_DFI0_B3_D                 (RxBypassDataPad_DFI0_B3_D          ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_D                    (TxBypassMode_DFI0_B0_D             ), //8bit
  .TxBypassMode_DFI0_B1_D                    (TxBypassMode_DFI0_B1_D             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassMode_DFI0_B2_D                    (TxBypassMode_DFI0_B2_D             ),
  .TxBypassMode_DFI0_B3_D                    (TxBypassMode_DFI0_B3_D             ),
`endif                                      
  .TxBypassOE_DFI0_B0_D                      (TxBypassOE_DFI0_B0_D               ), //8bit
  .TxBypassOE_DFI0_B1_D                      (TxBypassOE_DFI0_B1_D               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassOE_DFI0_B2_D                      (TxBypassOE_DFI0_B2_D               ),
  .TxBypassOE_DFI0_B3_D                      (TxBypassOE_DFI0_B3_D               ),
`endif                                                               
  .TxBypassData_DFI0_B0_D                    (TxBypassData_DFI0_B0_D             ),
  .TxBypassData_DFI0_B1_D                    (TxBypassData_DFI0_B1_D             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassData_DFI0_B2_D                    (TxBypassData_DFI0_B2_D             ),
  .TxBypassData_DFI0_B3_D                    (TxBypassData_DFI0_B3_D             ),
`endif                                                                           
                                                                                 
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                              
  .RxBypassRcvEn_DFI0_B0_DMI                 (RxBypassRcvEn_DFI0_B0_DMI          ),
  .RxBypassRcvEn_DFI0_B1_DMI                 (RxBypassRcvEn_DFI0_B1_DMI          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassRcvEn_DFI0_B2_DMI                 (RxBypassRcvEn_DFI0_B2_DMI          ),
  .RxBypassRcvEn_DFI0_B3_DMI                 (RxBypassRcvEn_DFI0_B3_DMI          ),
`endif                                                                         
  .RxBypassData_DFI0_B0_DMI                  (RxBypassData_DFI0_B0_DMI           ),   //4bit
  .RxBypassData_DFI0_B1_DMI                  (RxBypassData_DFI0_B1_DMI           ),   //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassData_DFI0_B2_DMI                  (RxBypassData_DFI0_B2_DMI           ),   //4bit
  .RxBypassData_DFI0_B3_DMI                  (RxBypassData_DFI0_B3_DMI           ),   //4bit
`endif                                                                       
  .RxBypassPadEn_DFI0_B0_DMI                 (RxBypassPadEn_DFI0_B0_DMI          ),
  .RxBypassPadEn_DFI0_B1_DMI                 (RxBypassPadEn_DFI0_B1_DMI          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                  
  .RxBypassPadEn_DFI0_B2_DMI                 (RxBypassPadEn_DFI0_B2_DMI          ),
  .RxBypassPadEn_DFI0_B3_DMI                 (RxBypassPadEn_DFI0_B3_DMI          ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_DMI               (RxBypassDataPad_DFI0_B0_DMI        ),
  .RxBypassDataPad_DFI0_B1_DMI               (RxBypassDataPad_DFI0_B1_DMI        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI0_B2_DMI               (RxBypassDataPad_DFI0_B2_DMI        ),
  .RxBypassDataPad_DFI0_B3_DMI               (RxBypassDataPad_DFI0_B3_DMI        ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_DMI                  (TxBypassMode_DFI0_B0_DMI           ),
  .TxBypassMode_DFI0_B1_DMI                  (TxBypassMode_DFI0_B1_DMI           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                              
  .TxBypassMode_DFI0_B2_DMI                  (TxBypassMode_DFI0_B2_DMI           ),
  .TxBypassMode_DFI0_B3_DMI                  (TxBypassMode_DFI0_B3_DMI           ),
`endif                                                                 
  .TxBypassOE_DFI0_B0_DMI                    (TxBypassOE_DFI0_B0_DMI             ),
  .TxBypassOE_DFI0_B1_DMI                    (TxBypassOE_DFI0_B1_DMI             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                            
  .TxBypassOE_DFI0_B2_DMI                    (TxBypassOE_DFI0_B2_DMI             ),
  .TxBypassOE_DFI0_B3_DMI                    (TxBypassOE_DFI0_B3_DMI             ),
`endif                                                               
  .TxBypassData_DFI0_B0_DMI                  (TxBypassData_DFI0_B0_DMI           ),
  .TxBypassData_DFI0_B1_DMI                  (TxBypassData_DFI0_B1_DMI           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassData_DFI0_B2_DMI                  (TxBypassData_DFI0_B2_DMI           ),
  .TxBypassData_DFI0_B3_DMI                  (TxBypassData_DFI0_B3_DMI           ),
`endif                                                                           
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                         
                                                                                
  .RxBypassRcvEn_DFI0_CA                     (RxBypassRcvEn_DFI0_CA              ),   //6+`DWC_DDRPHY_NUM_RANKS
  .RxBypassData_DFI0_CA0                     (RxBypassData_DFI0_CA0              ),   //4bit
  .RxBypassData_DFI0_CA1                     (RxBypassData_DFI0_CA1              ),   //4bit
  .RxBypassData_DFI0_CA2                     (RxBypassData_DFI0_CA2              ),   //4bit
  .RxBypassData_DFI0_CA3                     (RxBypassData_DFI0_CA3              ),   //4bit
  .RxBypassData_DFI0_CA4                     (RxBypassData_DFI0_CA4              ),   //4bit
  .RxBypassData_DFI0_CA5                     (RxBypassData_DFI0_CA5              ),   //4bit
  .RxBypassData_DFI0_CA6                     (RxBypassData_DFI0_CA6              ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                                                    
  .RxBypassData_DFI0_CA7                     (RxBypassData_DFI0_CA7              ),   //4bit
`endif                                                                          
  .RxBypassPadEn_DFI0_CA                     (RxBypassPadEn_DFI0_CA              ),   //6+`DWC_DDRPHY_NUM_RANKS
  .RxBypassDataPad_DFI0_CA                   (RxBypassDataPad_DFI0_CA            ),
  .TxBypassMode_DFI0_CA                      (TxBypassMode_DFI0_CA               ),
  .TxBypassOE_DFI0_CA                        (TxBypassOE_DFI0_CA                 ),
  .TxBypassData_DFI0_CA                      (TxBypassData_DFI0_CA               ),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI0_B0_DQS                 (RxBypassRcvEn_DFI0_B0_DQS          ),
  .RxBypassRcvEn_DFI0_B1_DQS                 (RxBypassRcvEn_DFI0_B1_DQS          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassRcvEn_DFI0_B2_DQS                 (RxBypassRcvEn_DFI0_B2_DQS          ),
  .RxBypassRcvEn_DFI0_B3_DQS                 (RxBypassRcvEn_DFI0_B3_DQS          ),
`endif                                                                          
  .RxBypassDataRcv_DFI0_B0_DQS_T             (RxBypassDataRcv_DFI0_B0_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B0_DQS_C             (RxBypassDataRcv_DFI0_B0_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_T             (RxBypassDataRcv_DFI0_B1_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_C             (RxBypassDataRcv_DFI0_B1_DQS_C      ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataRcv_DFI0_B2_DQS_T             (RxBypassDataRcv_DFI0_B2_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B2_DQS_C             (RxBypassDataRcv_DFI0_B2_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_T             (RxBypassDataRcv_DFI0_B3_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_C             (RxBypassDataRcv_DFI0_B3_DQS_C      ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI0_B0_DQS                 (RxBypassPadEn_DFI0_B0_DQS          ),
  .RxBypassPadEn_DFI0_B1_DQS                 (RxBypassPadEn_DFI0_B1_DQS          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                   
  .RxBypassPadEn_DFI0_B2_DQS                 (RxBypassPadEn_DFI0_B2_DQS          ),
  .RxBypassPadEn_DFI0_B3_DQS                 (RxBypassPadEn_DFI0_B3_DQS          ),
`endif                                                                      
  .RxBypassDataPad_DFI0_B0_DQS_T             (RxBypassDataPad_DFI0_B0_DQS_T      ),
  .RxBypassDataPad_DFI0_B0_DQS_C             (RxBypassDataPad_DFI0_B0_DQS_C      ),
  .RxBypassDataPad_DFI0_B1_DQS_T             (RxBypassDataPad_DFI0_B1_DQS_T      ),
  .RxBypassDataPad_DFI0_B1_DQS_C             (RxBypassDataPad_DFI0_B1_DQS_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassDataPad_DFI0_B2_DQS_T             (RxBypassDataPad_DFI0_B2_DQS_T      ),
  .RxBypassDataPad_DFI0_B2_DQS_C             (RxBypassDataPad_DFI0_B2_DQS_C      ),
  .RxBypassDataPad_DFI0_B3_DQS_T             (RxBypassDataPad_DFI0_B3_DQS_T      ),
  .RxBypassDataPad_DFI0_B3_DQS_C             (RxBypassDataPad_DFI0_B3_DQS_C      ),
`endif                                                                          
  .TxBypassMode_DFI0_B0_DQS_T                (TxBypassMode_DFI0_B0_DQS_T         ),
  .TxBypassMode_DFI0_B0_DQS_C                (TxBypassMode_DFI0_B0_DQS_C         ),
  .TxBypassMode_DFI0_B1_DQS_T                (TxBypassMode_DFI0_B1_DQS_T         ),
  .TxBypassMode_DFI0_B1_DQS_C                (TxBypassMode_DFI0_B1_DQS_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassMode_DFI0_B2_DQS_T                (TxBypassMode_DFI0_B2_DQS_T         ),
  .TxBypassMode_DFI0_B2_DQS_C                (TxBypassMode_DFI0_B2_DQS_C         ),
  .TxBypassMode_DFI0_B3_DQS_T                (TxBypassMode_DFI0_B3_DQS_T         ),
  .TxBypassMode_DFI0_B3_DQS_C                (TxBypassMode_DFI0_B3_DQS_C         ),
`endif                                                                          
  .TxBypassOE_DFI0_B0_DQS_T                  (TxBypassOE_DFI0_B0_DQS_T           ),
  .TxBypassOE_DFI0_B0_DQS_C                  (TxBypassOE_DFI0_B0_DQS_C           ),
  .TxBypassOE_DFI0_B1_DQS_T                  (TxBypassOE_DFI0_B1_DQS_T           ),
  .TxBypassOE_DFI0_B1_DQS_C                  (TxBypassOE_DFI0_B1_DQS_C           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassOE_DFI0_B2_DQS_T                  (TxBypassOE_DFI0_B2_DQS_T           ),
  .TxBypassOE_DFI0_B2_DQS_C                  (TxBypassOE_DFI0_B2_DQS_C           ),
  .TxBypassOE_DFI0_B3_DQS_T                  (TxBypassOE_DFI0_B3_DQS_T           ),
  .TxBypassOE_DFI0_B3_DQS_C                  (TxBypassOE_DFI0_B3_DQS_C           ),
`endif                                                                        
  .TxBypassData_DFI0_B0_DQS_T                (TxBypassData_DFI0_B0_DQS_T         ),
  .TxBypassData_DFI0_B0_DQS_C                (TxBypassData_DFI0_B0_DQS_C         ),
  .TxBypassData_DFI0_B1_DQS_T                (TxBypassData_DFI0_B1_DQS_T         ),
  .TxBypassData_DFI0_B1_DQS_C                (TxBypassData_DFI0_B1_DQS_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassData_DFI0_B2_DQS_T                (TxBypassData_DFI0_B2_DQS_T         ),
  .TxBypassData_DFI0_B2_DQS_C                (TxBypassData_DFI0_B2_DQS_C         ),
  .TxBypassData_DFI0_B3_DQS_T                (TxBypassData_DFI0_B3_DQS_T         ),
  .TxBypassData_DFI0_B3_DQS_C                (TxBypassData_DFI0_B3_DQS_C         ),
`endif                                                                        
                                                                                
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                                 
  .RxBypassRcvEn_DFI0_B0_WCK                 (RxBypassRcvEn_DFI0_B0_WCK          ),
  .RxBypassRcvEn_DFI0_B1_WCK                 (RxBypassRcvEn_DFI0_B1_WCK          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassRcvEn_DFI0_B2_WCK                 (RxBypassRcvEn_DFI0_B2_WCK          ),
  .RxBypassRcvEn_DFI0_B3_WCK                 (RxBypassRcvEn_DFI0_B3_WCK          ),
`endif                                                                           
  .RxBypassDataRcv_DFI0_B0_WCK_T             (RxBypassDataRcv_DFI0_B0_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B0_WCK_C             (RxBypassDataRcv_DFI0_B0_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_T             (RxBypassDataRcv_DFI0_B1_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_C             (RxBypassDataRcv_DFI0_B1_WCK_C      ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassDataRcv_DFI0_B2_WCK_T             (RxBypassDataRcv_DFI0_B2_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B2_WCK_C             (RxBypassDataRcv_DFI0_B2_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_T             (RxBypassDataRcv_DFI0_B3_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_C             (RxBypassDataRcv_DFI0_B3_WCK_C      ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI0_B0_WCK                 (RxBypassPadEn_DFI0_B0_WCK          ),
  .RxBypassPadEn_DFI0_B1_WCK                 (RxBypassPadEn_DFI0_B1_WCK          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassPadEn_DFI0_B2_WCK                 (RxBypassPadEn_DFI0_B2_WCK          ),
  .RxBypassPadEn_DFI0_B3_WCK                 (RxBypassPadEn_DFI0_B3_WCK          ),
`endif                                                                           
  .RxBypassDataPad_DFI0_B0_WCK_T             (RxBypassDataPad_DFI0_B0_WCK_T      ),
  .RxBypassDataPad_DFI0_B0_WCK_C             (RxBypassDataPad_DFI0_B0_WCK_C      ),
  .RxBypassDataPad_DFI0_B1_WCK_T             (RxBypassDataPad_DFI0_B1_WCK_T      ),
  .RxBypassDataPad_DFI0_B1_WCK_C             (RxBypassDataPad_DFI0_B1_WCK_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassDataPad_DFI0_B2_WCK_T             (RxBypassDataPad_DFI0_B2_WCK_T      ),
  .RxBypassDataPad_DFI0_B2_WCK_C             (RxBypassDataPad_DFI0_B2_WCK_C      ),
  .RxBypassDataPad_DFI0_B3_WCK_T             (RxBypassDataPad_DFI0_B3_WCK_T      ),
  .RxBypassDataPad_DFI0_B3_WCK_C             (RxBypassDataPad_DFI0_B3_WCK_C      ),
`endif                                                                           
  .TxBypassMode_DFI0_B0_WCK_T                  (TxBypassMode_DFI0_B0_WCK_T           ),
  .TxBypassMode_DFI0_B0_WCK_C                  (TxBypassMode_DFI0_B0_WCK_C           ),
  .TxBypassMode_DFI0_B1_WCK_T                  (TxBypassMode_DFI0_B1_WCK_T           ),
  .TxBypassMode_DFI0_B1_WCK_C                  (TxBypassMode_DFI0_B1_WCK_C           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassMode_DFI0_B2_WCK_T                  (TxBypassMode_DFI0_B2_WCK_T           ),
  .TxBypassMode_DFI0_B2_WCK_C                  (TxBypassMode_DFI0_B2_WCK_C           ),
  .TxBypassMode_DFI0_B3_WCK_T                  (TxBypassMode_DFI0_B3_WCK_T           ),
  .TxBypassMode_DFI0_B3_WCK_C                  (TxBypassMode_DFI0_B3_WCK_C           ),
`endif                                                                           
  .TxBypassOE_DFI0_B0_WCK_T                  (TxBypassOE_DFI0_B0_WCK_T           ),
  .TxBypassOE_DFI0_B0_WCK_C                  (TxBypassOE_DFI0_B0_WCK_C           ),
  .TxBypassOE_DFI0_B1_WCK_T                  (TxBypassOE_DFI0_B1_WCK_T           ),
  .TxBypassOE_DFI0_B1_WCK_C                  (TxBypassOE_DFI0_B1_WCK_C           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassOE_DFI0_B2_WCK_T                  (TxBypassOE_DFI0_B2_WCK_T           ),
  .TxBypassOE_DFI0_B2_WCK_C                  (TxBypassOE_DFI0_B2_WCK_C           ),
  .TxBypassOE_DFI0_B3_WCK_T                  (TxBypassOE_DFI0_B3_WCK_T           ),
  .TxBypassOE_DFI0_B3_WCK_C                  (TxBypassOE_DFI0_B3_WCK_C           ),
`endif                                                                           
  .TxBypassData_DFI0_B0_WCK_T                (TxBypassData_DFI0_B0_WCK_T         ),
  .TxBypassData_DFI0_B0_WCK_C                (TxBypassData_DFI0_B0_WCK_C         ),
  .TxBypassData_DFI0_B1_WCK_T                (TxBypassData_DFI0_B1_WCK_T         ),
  .TxBypassData_DFI0_B1_WCK_C                (TxBypassData_DFI0_B1_WCK_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassData_DFI0_B2_WCK_T                (TxBypassData_DFI0_B2_WCK_T         ),
  .TxBypassData_DFI0_B2_WCK_C                (TxBypassData_DFI0_B2_WCK_C         ),
  .TxBypassData_DFI0_B3_WCK_T                (TxBypassData_DFI0_B3_WCK_T         ),
  .TxBypassData_DFI0_B3_WCK_C                (TxBypassData_DFI0_B3_WCK_C         ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI0_CK                     (RxBypassRcvEn_DFI0_CK              ),
  .RxBypassDataRcv_DFI0_CK_T                 (RxBypassDataRcv_DFI0_CK_T          ),
  .RxBypassDataRcv_DFI0_CK_C                 (RxBypassDataRcv_DFI0_CK_C          ),
  .RxBypassPadEn_DFI0_CK                     (RxBypassPadEn_DFI0_CK              ),
  .RxBypassDataPad_DFI0_CK_T                 (RxBypassDataPad_DFI0_CK_T          ),
  .RxBypassDataPad_DFI0_CK_C                 (RxBypassDataPad_DFI0_CK_C          ),
  .TxBypassMode_DFI0_CK_T                    (TxBypassMode_DFI0_CK_T             ),
  .TxBypassMode_DFI0_CK_C                    (TxBypassMode_DFI0_CK_C             ),
  .TxBypassOE_DFI0_CK_T                      (TxBypassOE_DFI0_CK_T               ),
  .TxBypassOE_DFI0_CK_C                      (TxBypassOE_DFI0_CK_C               ),
  .TxBypassData_DFI0_CK_T                    (TxBypassData_DFI0_CK_T             ),
  .TxBypassData_DFI0_CK_C                    (TxBypassData_DFI0_CK_C             ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI0_LP4CKE_LP5CS           (RxBypassPadEn_DFI0_LP4CKE_LP5CS    ), 
  .RxBypassDataPad_DFI0_LP4CKE_LP5CS         (RxBypassDataPad_DFI0_LP4CKE_LP5CS  ),
  .TxBypassMode_DFI0_LP4CKE_LP5CS            (TxBypassMode_DFI0_LP4CKE_LP5CS     ),
  .TxBypassOE_DFI0_LP4CKE_LP5CS              (TxBypassOE_DFI0_LP4CKE_LP5CS       ),
  .TxBypassData_DFI0_LP4CKE_LP5CS            (TxBypassData_DFI0_LP4CKE_LP5CS     ),
                                                                                 
  .TxBypassMode_MEMRESET_L                   (TxBypassMode_MEMRESET_L            ),
  .TxBypassData_MEMRESET_L                   (TxBypassData_MEMRESET_L            ),
                                                                                 
  .TxBypassMode_DTO                          (TxBypassMode_DTO                   ),
  .TxBypassOE_DTO                            (TxBypassOE_DTO                     ),
  .TxBypassData_DTO                          (TxBypassData_DTO                   ),
  .RxBypassEn_DTO                            (RxBypassEn_DTO                     ),
  .RxBypassDataPad_DTO                       (RxBypassDataPad_DTO                ),

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI1_B0_D                   (RxBypassRcvEn_DFI1_B0_D            ), 
  .RxBypassRcvEn_DFI1_B1_D                   (RxBypassRcvEn_DFI1_B1_D            ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI1_B2_D                   (RxBypassRcvEn_DFI1_B2_D            ),
  .RxBypassRcvEn_DFI1_B3_D                   (RxBypassRcvEn_DFI1_B3_D            ),
`endif                                                                         
  .RxBypassData_DFI1_B0_D0                   (RxBypassData_DFI1_B0_D0            ), //4bit
  .RxBypassData_DFI1_B0_D1                   (RxBypassData_DFI1_B0_D1            ), //4bit
  .RxBypassData_DFI1_B0_D2                   (RxBypassData_DFI1_B0_D2            ), //4bit
  .RxBypassData_DFI1_B0_D3                   (RxBypassData_DFI1_B0_D3            ), //4bit
  .RxBypassData_DFI1_B0_D4                   (RxBypassData_DFI1_B0_D4            ), //4bit
  .RxBypassData_DFI1_B0_D5                   (RxBypassData_DFI1_B0_D5            ), //4bit
  .RxBypassData_DFI1_B0_D6                   (RxBypassData_DFI1_B0_D6            ), //4bit
  .RxBypassData_DFI1_B0_D7                   (RxBypassData_DFI1_B0_D7            ), //4bit
  .RxBypassData_DFI1_B1_D0                   (RxBypassData_DFI1_B1_D0            ), //4bit
  .RxBypassData_DFI1_B1_D1                   (RxBypassData_DFI1_B1_D1            ), //4bit
  .RxBypassData_DFI1_B1_D2                   (RxBypassData_DFI1_B1_D2            ), //4bit
  .RxBypassData_DFI1_B1_D3                   (RxBypassData_DFI1_B1_D3            ), //4bit
  .RxBypassData_DFI1_B1_D4                   (RxBypassData_DFI1_B1_D4            ), //4bit
  .RxBypassData_DFI1_B1_D5                   (RxBypassData_DFI1_B1_D5            ), //4bit
  .RxBypassData_DFI1_B1_D6                   (RxBypassData_DFI1_B1_D6            ), //4bit
  .RxBypassData_DFI1_B1_D7                   (RxBypassData_DFI1_B1_D7            ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassData_DFI1_B2_D0                   (RxBypassData_DFI1_B2_D0            ), //4bit
  .RxBypassData_DFI1_B2_D1                   (RxBypassData_DFI1_B2_D1            ), //4bit
  .RxBypassData_DFI1_B2_D2                   (RxBypassData_DFI1_B2_D2            ), //4bit
  .RxBypassData_DFI1_B2_D3                   (RxBypassData_DFI1_B2_D3            ), //4bit
  .RxBypassData_DFI1_B2_D4                   (RxBypassData_DFI1_B2_D4            ), //4bit
  .RxBypassData_DFI1_B2_D5                   (RxBypassData_DFI1_B2_D5            ), //4bit
  .RxBypassData_DFI1_B2_D6                   (RxBypassData_DFI1_B2_D6            ), //4bit
  .RxBypassData_DFI1_B2_D7                   (RxBypassData_DFI1_B2_D7            ), //4bit
  .RxBypassData_DFI1_B3_D0                   (RxBypassData_DFI1_B3_D0            ), //4bit
  .RxBypassData_DFI1_B3_D1                   (RxBypassData_DFI1_B3_D1            ), //4bit
  .RxBypassData_DFI1_B3_D2                   (RxBypassData_DFI1_B3_D2            ), //4bit
  .RxBypassData_DFI1_B3_D3                   (RxBypassData_DFI1_B3_D3            ), //4bit
  .RxBypassData_DFI1_B3_D4                   (RxBypassData_DFI1_B3_D4            ), //4bit
  .RxBypassData_DFI1_B3_D5                   (RxBypassData_DFI1_B3_D5            ), //4bit
  .RxBypassData_DFI1_B3_D6                   (RxBypassData_DFI1_B3_D6            ), //4bit
  .RxBypassData_DFI1_B3_D7                   (RxBypassData_DFI1_B3_D7            ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI1_B0_D                   (RxBypassPadEn_DFI1_B0_D            ),
  .RxBypassPadEn_DFI1_B1_D                   (RxBypassPadEn_DFI1_B1_D            ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI1_B2_D                   (RxBypassPadEn_DFI1_B2_D            ),
  .RxBypassPadEn_DFI1_B3_D                   (RxBypassPadEn_DFI1_B3_D            ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_D                 (RxBypassDataPad_DFI1_B0_D          ),
  .RxBypassDataPad_DFI1_B1_D                 (RxBypassDataPad_DFI1_B1_D          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI1_B2_D                 (RxBypassDataPad_DFI1_B2_D          ),
  .RxBypassDataPad_DFI1_B3_D                 (RxBypassDataPad_DFI1_B3_D          ),
`endif                                                                   
  .TxBypassMode_DFI1_B0_D                    (TxBypassMode_DFI1_B0_D             ),
  .TxBypassMode_DFI1_B1_D                    (TxBypassMode_DFI1_B1_D             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassMode_DFI1_B2_D                    (TxBypassMode_DFI1_B2_D             ),
  .TxBypassMode_DFI1_B3_D                    (TxBypassMode_DFI1_B3_D             ),
`endif                                      
  .TxBypassOE_DFI1_B0_D                      (TxBypassOE_DFI1_B0_D               ),
  .TxBypassOE_DFI1_B1_D                      (TxBypassOE_DFI1_B1_D               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassOE_DFI1_B2_D                      (TxBypassOE_DFI1_B2_D               ),
  .TxBypassOE_DFI1_B3_D                      (TxBypassOE_DFI1_B3_D               ),
`endif                                                               
  .TxBypassData_DFI1_B0_D                    (TxBypassData_DFI1_B0_D             ),
  .TxBypassData_DFI1_B1_D                    (TxBypassData_DFI1_B1_D             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassData_DFI1_B2_D                    (TxBypassData_DFI1_B2_D             ),
  .TxBypassData_DFI1_B3_D                    (TxBypassData_DFI1_B3_D             ),
`endif                                                                           
                                                                                 
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                              
  .RxBypassRcvEn_DFI1_B0_DMI                 (RxBypassRcvEn_DFI1_B0_DMI          ),
  .RxBypassRcvEn_DFI1_B1_DMI                 (RxBypassRcvEn_DFI1_B1_DMI          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassRcvEn_DFI1_B2_DMI                 (RxBypassRcvEn_DFI1_B2_DMI          ),
  .RxBypassRcvEn_DFI1_B3_DMI                 (RxBypassRcvEn_DFI1_B3_DMI          ),
`endif                                                                         
  .RxBypassData_DFI1_B0_DMI                  (RxBypassData_DFI1_B0_DMI           ),   //4bit
  .RxBypassData_DFI1_B1_DMI                  (RxBypassData_DFI1_B1_DMI           ),   //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassData_DFI1_B2_DMI                  (RxBypassData_DFI1_B2_DMI           ),   //4bit
  .RxBypassData_DFI1_B3_DMI                  (RxBypassData_DFI1_B3_DMI           ),   //4bit
`endif                                                                       
  .RxBypassPadEn_DFI1_B0_DMI                 (RxBypassPadEn_DFI1_B0_DMI          ),
  .RxBypassPadEn_DFI1_B1_DMI                 (RxBypassPadEn_DFI1_B1_DMI          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                  
  .RxBypassPadEn_DFI1_B2_DMI                 (RxBypassPadEn_DFI1_B2_DMI          ),
  .RxBypassPadEn_DFI1_B3_DMI                 (RxBypassPadEn_DFI1_B3_DMI          ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_DMI               (RxBypassDataPad_DFI1_B0_DMI        ),
  .RxBypassDataPad_DFI1_B1_DMI               (RxBypassDataPad_DFI1_B1_DMI        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI1_B2_DMI               (RxBypassDataPad_DFI1_B2_DMI        ),
  .RxBypassDataPad_DFI1_B3_DMI               (RxBypassDataPad_DFI1_B3_DMI        ),
`endif                                                                   
  .TxBypassMode_DFI1_B0_DMI                  (TxBypassMode_DFI1_B0_DMI           ),
  .TxBypassMode_DFI1_B1_DMI                  (TxBypassMode_DFI1_B1_DMI           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                              
  .TxBypassMode_DFI1_B2_DMI                  (TxBypassMode_DFI1_B2_DMI           ),
  .TxBypassMode_DFI1_B3_DMI                  (TxBypassMode_DFI1_B3_DMI           ),
`endif                                                                 
  .TxBypassOE_DFI1_B0_DMI                    (TxBypassOE_DFI1_B0_DMI             ),
  .TxBypassOE_DFI1_B1_DMI                    (TxBypassOE_DFI1_B1_DMI             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                            
  .TxBypassOE_DFI1_B2_DMI                    (TxBypassOE_DFI1_B2_DMI             ),
  .TxBypassOE_DFI1_B3_DMI                    (TxBypassOE_DFI1_B3_DMI             ),
`endif                                                               
  .TxBypassData_DFI1_B0_DMI                  (TxBypassData_DFI1_B0_DMI           ),
  .TxBypassData_DFI1_B1_DMI                  (TxBypassData_DFI1_B1_DMI           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassData_DFI1_B2_DMI                  (TxBypassData_DFI1_B2_DMI           ),
  .TxBypassData_DFI1_B3_DMI                  (TxBypassData_DFI1_B3_DMI           ),
`endif                                                                           
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                         
                                                                                
  .RxBypassRcvEn_DFI1_CA                     (RxBypassRcvEn_DFI1_CA              ),
  .RxBypassData_DFI1_CA0                     (RxBypassData_DFI1_CA0              ),   //4bit
  .RxBypassData_DFI1_CA1                     (RxBypassData_DFI1_CA1              ),   //4bit
  .RxBypassData_DFI1_CA2                     (RxBypassData_DFI1_CA2              ),   //4bit
  .RxBypassData_DFI1_CA3                     (RxBypassData_DFI1_CA3              ),   //4bit
  .RxBypassData_DFI1_CA4                     (RxBypassData_DFI1_CA4              ),   //4bit
  .RxBypassData_DFI1_CA5                     (RxBypassData_DFI1_CA5              ),   //4bit
  .RxBypassData_DFI1_CA6                     (RxBypassData_DFI1_CA6              ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                                                    
  .RxBypassData_DFI1_CA7                     (RxBypassData_DFI1_CA7              ),   //4bit
`endif                                                                          
  .RxBypassPadEn_DFI1_CA                     (RxBypassPadEn_DFI1_CA              ),
  .RxBypassDataPad_DFI1_CA                   (RxBypassDataPad_DFI1_CA            ),
  .TxBypassMode_DFI1_CA                      (TxBypassMode_DFI1_CA               ),
  .TxBypassOE_DFI1_CA                        (TxBypassOE_DFI1_CA                 ),
  .TxBypassData_DFI1_CA                      (TxBypassData_DFI1_CA               ),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI1_B0_DQS                 (RxBypassRcvEn_DFI1_B0_DQS          ),
  .RxBypassRcvEn_DFI1_B1_DQS                 (RxBypassRcvEn_DFI1_B1_DQS          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassRcvEn_DFI1_B2_DQS                 (RxBypassRcvEn_DFI1_B2_DQS          ),
  .RxBypassRcvEn_DFI1_B3_DQS                 (RxBypassRcvEn_DFI1_B3_DQS          ),
`endif                                                                          
  .RxBypassDataRcv_DFI1_B0_DQS_T             (RxBypassDataRcv_DFI1_B0_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B0_DQS_C             (RxBypassDataRcv_DFI1_B0_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_T             (RxBypassDataRcv_DFI1_B1_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_C             (RxBypassDataRcv_DFI1_B1_DQS_C      ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataRcv_DFI1_B2_DQS_T             (RxBypassDataRcv_DFI1_B2_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B2_DQS_C             (RxBypassDataRcv_DFI1_B2_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_T             (RxBypassDataRcv_DFI1_B3_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_C             (RxBypassDataRcv_DFI1_B3_DQS_C      ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI1_B0_DQS                 (RxBypassPadEn_DFI1_B0_DQS          ),
  .RxBypassPadEn_DFI1_B1_DQS                 (RxBypassPadEn_DFI1_B1_DQS          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                   
  .RxBypassPadEn_DFI1_B2_DQS                 (RxBypassPadEn_DFI1_B2_DQS          ),
  .RxBypassPadEn_DFI1_B3_DQS                 (RxBypassPadEn_DFI1_B3_DQS          ),
`endif                                                                      
  .RxBypassDataPad_DFI1_B0_DQS_T             (RxBypassDataPad_DFI1_B0_DQS_T      ),
  .RxBypassDataPad_DFI1_B0_DQS_C             (RxBypassDataPad_DFI1_B0_DQS_C      ),
  .RxBypassDataPad_DFI1_B1_DQS_T             (RxBypassDataPad_DFI1_B1_DQS_T      ),
  .RxBypassDataPad_DFI1_B1_DQS_C             (RxBypassDataPad_DFI1_B1_DQS_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassDataPad_DFI1_B2_DQS_T             (RxBypassDataPad_DFI1_B2_DQS_T      ),
  .RxBypassDataPad_DFI1_B2_DQS_C             (RxBypassDataPad_DFI1_B2_DQS_C      ),
  .RxBypassDataPad_DFI1_B3_DQS_T             (RxBypassDataPad_DFI1_B3_DQS_T      ),
  .RxBypassDataPad_DFI1_B3_DQS_C             (RxBypassDataPad_DFI1_B3_DQS_C      ),
`endif                                                                          
  .TxBypassMode_DFI1_B0_DQS_T                (TxBypassMode_DFI1_B0_DQS_T         ),
  .TxBypassMode_DFI1_B0_DQS_C                (TxBypassMode_DFI1_B0_DQS_C         ),
  .TxBypassMode_DFI1_B1_DQS_T                (TxBypassMode_DFI1_B1_DQS_T         ),
  .TxBypassMode_DFI1_B1_DQS_C                (TxBypassMode_DFI1_B1_DQS_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassMode_DFI1_B2_DQS_T                (TxBypassMode_DFI1_B2_DQS_T         ),
  .TxBypassMode_DFI1_B2_DQS_C                (TxBypassMode_DFI1_B2_DQS_C         ),
  .TxBypassMode_DFI1_B3_DQS_T                (TxBypassMode_DFI1_B3_DQS_T         ),
  .TxBypassMode_DFI1_B3_DQS_C                (TxBypassMode_DFI1_B3_DQS_C         ),
`endif                                                                          
  .TxBypassOE_DFI1_B0_DQS_T                  (TxBypassOE_DFI1_B0_DQS_T           ),
  .TxBypassOE_DFI1_B0_DQS_C                  (TxBypassOE_DFI1_B0_DQS_C           ),
  .TxBypassOE_DFI1_B1_DQS_T                  (TxBypassOE_DFI1_B1_DQS_T           ),
  .TxBypassOE_DFI1_B1_DQS_C                  (TxBypassOE_DFI1_B1_DQS_C           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassOE_DFI1_B2_DQS_T                  (TxBypassOE_DFI1_B2_DQS_T           ),
  .TxBypassOE_DFI1_B2_DQS_C                  (TxBypassOE_DFI1_B2_DQS_C           ),
  .TxBypassOE_DFI1_B3_DQS_T                  (TxBypassOE_DFI1_B3_DQS_T           ),
  .TxBypassOE_DFI1_B3_DQS_C                  (TxBypassOE_DFI1_B3_DQS_C           ),
`endif                                                                        
  .TxBypassData_DFI1_B0_DQS_T                (TxBypassData_DFI1_B0_DQS_T         ),
  .TxBypassData_DFI1_B0_DQS_C                (TxBypassData_DFI1_B0_DQS_C         ),
  .TxBypassData_DFI1_B1_DQS_T                (TxBypassData_DFI1_B1_DQS_T         ),
  .TxBypassData_DFI1_B1_DQS_C                (TxBypassData_DFI1_B1_DQS_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassData_DFI1_B2_DQS_T                (TxBypassData_DFI1_B2_DQS_T         ),
  .TxBypassData_DFI1_B2_DQS_C                (TxBypassData_DFI1_B2_DQS_C         ),
  .TxBypassData_DFI1_B3_DQS_T                (TxBypassData_DFI1_B3_DQS_T         ),
  .TxBypassData_DFI1_B3_DQS_C                (TxBypassData_DFI1_B3_DQS_C         ),
`endif                                                                        
                                                                                
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                                 
  .RxBypassRcvEn_DFI1_B0_WCK                 (RxBypassRcvEn_DFI1_B0_WCK          ),
  .RxBypassRcvEn_DFI1_B1_WCK                 (RxBypassRcvEn_DFI1_B1_WCK          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassRcvEn_DFI1_B2_WCK                 (RxBypassRcvEn_DFI1_B2_WCK          ),
  .RxBypassRcvEn_DFI1_B3_WCK                 (RxBypassRcvEn_DFI1_B3_WCK          ),
`endif                                                                           
  .RxBypassDataRcv_DFI1_B0_WCK_T             (RxBypassDataRcv_DFI1_B0_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B0_WCK_C             (RxBypassDataRcv_DFI1_B0_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_T             (RxBypassDataRcv_DFI1_B1_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_C             (RxBypassDataRcv_DFI1_B1_WCK_C      ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassDataRcv_DFI1_B2_WCK_T             (RxBypassDataRcv_DFI1_B2_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B2_WCK_C             (RxBypassDataRcv_DFI1_B2_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_T             (RxBypassDataRcv_DFI1_B3_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_C             (RxBypassDataRcv_DFI1_B3_WCK_C      ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI1_B0_WCK                 (RxBypassPadEn_DFI1_B0_WCK          ),
  .RxBypassPadEn_DFI1_B1_WCK                 (RxBypassPadEn_DFI1_B1_WCK          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassPadEn_DFI1_B2_WCK                 (RxBypassPadEn_DFI1_B2_WCK          ),
  .RxBypassPadEn_DFI1_B3_WCK                 (RxBypassPadEn_DFI1_B3_WCK          ),
`endif                                                                           
  .RxBypassDataPad_DFI1_B0_WCK_T             (RxBypassDataPad_DFI1_B0_WCK_T      ),
  .RxBypassDataPad_DFI1_B0_WCK_C             (RxBypassDataPad_DFI1_B0_WCK_C      ),
  .RxBypassDataPad_DFI1_B1_WCK_T             (RxBypassDataPad_DFI1_B1_WCK_T      ),
  .RxBypassDataPad_DFI1_B1_WCK_C             (RxBypassDataPad_DFI1_B1_WCK_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassDataPad_DFI1_B2_WCK_T             (RxBypassDataPad_DFI1_B2_WCK_T      ),
  .RxBypassDataPad_DFI1_B2_WCK_C             (RxBypassDataPad_DFI1_B2_WCK_C      ),
  .RxBypassDataPad_DFI1_B3_WCK_T             (RxBypassDataPad_DFI1_B3_WCK_T      ),
  .RxBypassDataPad_DFI1_B3_WCK_C             (RxBypassDataPad_DFI1_B3_WCK_C      ),
`endif                                                                           
  .TxBypassMode_DFI1_B0_WCK_T                (TxBypassMode_DFI1_B0_WCK_T         ),
  .TxBypassMode_DFI1_B0_WCK_C                (TxBypassMode_DFI1_B0_WCK_C         ),
  .TxBypassMode_DFI1_B1_WCK_T                (TxBypassMode_DFI1_B1_WCK_T         ),
  .TxBypassMode_DFI1_B1_WCK_C                (TxBypassMode_DFI1_B1_WCK_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassMode_DFI1_B2_WCK_T                (TxBypassMode_DFI1_B2_WCK_T         ),
  .TxBypassMode_DFI1_B2_WCK_C                (TxBypassMode_DFI1_B2_WCK_C         ),
  .TxBypassMode_DFI1_B3_WCK_T                (TxBypassMode_DFI1_B3_WCK_T         ),
  .TxBypassMode_DFI1_B3_WCK_C                (TxBypassMode_DFI1_B3_WCK_C         ),
`endif                                                                           
  .TxBypassOE_DFI1_B0_WCK_T                  (TxBypassOE_DFI1_B0_WCK_T           ),
  .TxBypassOE_DFI1_B0_WCK_C                  (TxBypassOE_DFI1_B0_WCK_C           ),
  .TxBypassOE_DFI1_B1_WCK_T                  (TxBypassOE_DFI1_B1_WCK_T           ),
  .TxBypassOE_DFI1_B1_WCK_C                  (TxBypassOE_DFI1_B1_WCK_C           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassOE_DFI1_B2_WCK_T                  (TxBypassOE_DFI1_B2_WCK_T           ),
  .TxBypassOE_DFI1_B2_WCK_C                  (TxBypassOE_DFI1_B2_WCK_C           ),
  .TxBypassOE_DFI1_B3_WCK_T                  (TxBypassOE_DFI1_B3_WCK_T           ),
  .TxBypassOE_DFI1_B3_WCK_C                  (TxBypassOE_DFI1_B3_WCK_C           ),
`endif                                                                           
  .TxBypassData_DFI1_B0_WCK_T                (TxBypassData_DFI1_B0_WCK_T         ),
  .TxBypassData_DFI1_B0_WCK_C                (TxBypassData_DFI1_B0_WCK_C         ),
  .TxBypassData_DFI1_B1_WCK_T                (TxBypassData_DFI1_B1_WCK_T         ),
  .TxBypassData_DFI1_B1_WCK_C                (TxBypassData_DFI1_B1_WCK_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassData_DFI1_B2_WCK_T                (TxBypassData_DFI1_B2_WCK_T         ),
  .TxBypassData_DFI1_B2_WCK_C                (TxBypassData_DFI1_B2_WCK_C         ),
  .TxBypassData_DFI1_B3_WCK_T                (TxBypassData_DFI1_B3_WCK_T         ),
  .TxBypassData_DFI1_B3_WCK_C                (TxBypassData_DFI1_B3_WCK_C         ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI1_CK                     (RxBypassRcvEn_DFI1_CK              ),
  .RxBypassDataRcv_DFI1_CK_T                 (RxBypassDataRcv_DFI1_CK_T          ),
  .RxBypassDataRcv_DFI1_CK_C                 (RxBypassDataRcv_DFI1_CK_C          ),
  .RxBypassPadEn_DFI1_CK                     (RxBypassPadEn_DFI1_CK              ),
  .RxBypassDataPad_DFI1_CK_T                 (RxBypassDataPad_DFI1_CK_T          ),
  .RxBypassDataPad_DFI1_CK_C                 (RxBypassDataPad_DFI1_CK_C          ),
  .TxBypassMode_DFI1_CK_T                    (TxBypassMode_DFI1_CK_T             ),
  .TxBypassMode_DFI1_CK_C                    (TxBypassMode_DFI1_CK_C             ),
  .TxBypassOE_DFI1_CK_T                      (TxBypassOE_DFI1_CK_T               ),
  .TxBypassOE_DFI1_CK_C                      (TxBypassOE_DFI1_CK_C               ),
  .TxBypassData_DFI1_CK_T                    (TxBypassData_DFI1_CK_T             ),
  .TxBypassData_DFI1_CK_C                    (TxBypassData_DFI1_CK_C             ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI1_LP4CKE_LP5CS           (RxBypassPadEn_DFI1_LP4CKE_LP5CS    ), 
  .RxBypassDataPad_DFI1_LP4CKE_LP5CS         (RxBypassDataPad_DFI1_LP4CKE_LP5CS  ),
  .TxBypassMode_DFI1_LP4CKE_LP5CS            (TxBypassMode_DFI1_LP4CKE_LP5CS     ),
  .TxBypassOE_DFI1_LP4CKE_LP5CS              (TxBypassOE_DFI1_LP4CKE_LP5CS       ),
  .TxBypassData_DFI1_LP4CKE_LP5CS            (TxBypassData_DFI1_LP4CKE_LP5CS     ),
`endif  //DWC_DDRPHY_NUM_CHANNELS_2
`else   //FLYOVER_TEST  
  .RxTestClk                                 (1'b0                               ),
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI0_B0_D                   (8'b0                               ), //8bit 
  .RxBypassRcvEn_DFI0_B1_D                   (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                     
  .RxBypassRcvEn_DFI0_B2_D                   (8'b0                               ),
  .RxBypassRcvEn_DFI0_B3_D                   (8'b0                               ),
`endif                                                                         
  .RxBypassData_DFI0_B0_D0                   (                                   ), //4bit
  .RxBypassData_DFI0_B0_D1                   (                                   ), //4bit
  .RxBypassData_DFI0_B0_D2                   (                                   ), //4bit
  .RxBypassData_DFI0_B0_D3                   (                                   ), //4bit
  .RxBypassData_DFI0_B0_D4                   (                                   ), //4bit
  .RxBypassData_DFI0_B0_D5                   (                                   ), //4bit
  .RxBypassData_DFI0_B0_D6                   (                                   ), //4bit
  .RxBypassData_DFI0_B0_D7                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D0                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D1                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D2                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D3                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D4                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D5                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D6                   (                                   ), //4bit
  .RxBypassData_DFI0_B1_D7                   (                                   ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassData_DFI0_B2_D0                   (                                   ), //4bit
  .RxBypassData_DFI0_B2_D1                   (                                   ), //4bit
  .RxBypassData_DFI0_B2_D2                   (                                   ), //4bit
  .RxBypassData_DFI0_B2_D3                   (                                   ), //4bit
  .RxBypassData_DFI0_B2_D4                   (                                   ), //4bit
  .RxBypassData_DFI0_B2_D5                   (                                   ), //4bit
  .RxBypassData_DFI0_B2_D6                   (                                   ), //4bit
  .RxBypassData_DFI0_B2_D7                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D0                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D1                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D2                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D3                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D4                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D5                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D6                   (                                   ), //4bit
  .RxBypassData_DFI0_B3_D7                   (                                   ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI0_B0_D                   (8'b0                               ), //8bit
  .RxBypassPadEn_DFI0_B1_D                   (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI0_B2_D                   (8'b0                               ),
  .RxBypassPadEn_DFI0_B3_D                   (8'b0                               ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_D                 (                                   ),
  .RxBypassDataPad_DFI0_B1_D                 (                                   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI0_B2_D                 (                                   ),
  .RxBypassDataPad_DFI0_B3_D                 (                                   ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_D                    (8'b0                               ), //8bit
  .TxBypassMode_DFI0_B1_D                    (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassMode_DFI0_B2_D                    (8'b0                               ),
  .TxBypassMode_DFI0_B3_D                    (8'b0                               ),
`endif                                      
  .TxBypassOE_DFI0_B0_D                      (8'b0                               ), //8bit
  .TxBypassOE_DFI0_B1_D                      (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassOE_DFI0_B2_D                      (8'b0                               ),
  .TxBypassOE_DFI0_B3_D                      (8'b0                               ),
`endif                                                               
  .TxBypassData_DFI0_B0_D                    (8'b0                               ),
  .TxBypassData_DFI0_B1_D                    (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                     
  .TxBypassData_DFI0_B2_D                    (8'b0                               ),
  .TxBypassData_DFI0_B3_D                    (8'b0                               ),
`endif                                                                           
                                                                                 
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                              
  .RxBypassRcvEn_DFI0_B0_DMI                 (1'b0                               ),
  .RxBypassRcvEn_DFI0_B1_DMI                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassRcvEn_DFI0_B2_DMI                 (1'b0                               ),
  .RxBypassRcvEn_DFI0_B3_DMI                 (1'b0                               ),
`endif                                                                         
  .RxBypassData_DFI0_B0_DMI                  (                                 ),   //4bit
  .RxBypassData_DFI0_B1_DMI                  (                                 ),   //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                  
  .RxBypassData_DFI0_B2_DMI                  (                                 ),   //4bit
  .RxBypassData_DFI0_B3_DMI                  (                                 ),   //4bit
`endif                                                                       
  .RxBypassPadEn_DFI0_B0_DMI                 (1'b0                               ),
  .RxBypassPadEn_DFI0_B1_DMI                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                            
  .RxBypassPadEn_DFI0_B2_DMI                 (1'b0                               ),
  .RxBypassPadEn_DFI0_B3_DMI                 (1'b0                               ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_DMI               (                                   ),
  .RxBypassDataPad_DFI0_B1_DMI               (                                   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassDataPad_DFI0_B2_DMI               (                                   ),
  .RxBypassDataPad_DFI0_B3_DMI               (                                   ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_DMI                  (1'b0                               ),
  .TxBypassMode_DFI0_B1_DMI                  (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassMode_DFI0_B2_DMI                  (1'b0                               ),
  .TxBypassMode_DFI0_B3_DMI                  (1'b0                               ),
`endif                                                              
  .TxBypassOE_DFI0_B0_DMI                    (1'b0                               ),
  .TxBypassOE_DFI0_B1_DMI                    (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassOE_DFI0_B2_DMI                    (1'b0                               ),
  .TxBypassOE_DFI0_B3_DMI                    (1'b0                               ),
`endif                                                              
  .TxBypassData_DFI0_B0_DMI                  (1'b0                               ),
  .TxBypassData_DFI0_B1_DMI                  (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassData_DFI0_B2_DMI                  (1'b0                               ),
  .TxBypassData_DFI0_B3_DMI                  (1'b0                               ),
`endif                                                                           
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                         
                                                                                
  .RxBypassRcvEn_DFI0_CA                     ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}   ),   //6+`DWC_DDRPHY_NUM_RANKS
  .RxBypassData_DFI0_CA0                     (                                  ),   //4bit
  .RxBypassData_DFI0_CA1                     (                                  ),   //4bit
  .RxBypassData_DFI0_CA2                     (                                  ),   //4bit
  .RxBypassData_DFI0_CA3                     (                                  ),   //4bit
  .RxBypassData_DFI0_CA4                     (                                  ),   //4bit
  .RxBypassData_DFI0_CA5                     (                                  ),   //4bit
  .RxBypassData_DFI0_CA6                     (                                  ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                                                   
  .RxBypassData_DFI0_CA7                     (                                  ),   //4bit
`endif                                                                          
  .RxBypassPadEn_DFI0_CA                     ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),   //6+`DWC_DDRPHY_NUM_RANKS
  .RxBypassDataPad_DFI0_CA                   (                                   ),
  .TxBypassMode_DFI0_CA                      ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),
  .TxBypassOE_DFI0_CA                        ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),
  .TxBypassData_DFI0_CA                      ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI0_B0_DQS                 (1'b0                               ),
  .RxBypassRcvEn_DFI0_B1_DQS                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                   
  .RxBypassRcvEn_DFI0_B2_DQS                 (1'b0                               ),
  .RxBypassRcvEn_DFI0_B3_DQS                 (1'b0                               ),
`endif                                                                          
  .RxBypassDataRcv_DFI0_B0_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI0_B0_DQS_C             (                                   ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_C             (                                   ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataRcv_DFI0_B2_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI0_B2_DQS_C             (                                   ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_C             (                                   ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI0_B0_DQS                 (1'b0                               ),
  .RxBypassPadEn_DFI0_B1_DQS                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                              
  .RxBypassPadEn_DFI0_B2_DQS                 (1'b0                               ),
  .RxBypassPadEn_DFI0_B3_DQS                 (1'b0                               ),
`endif                                                                      
  .RxBypassDataPad_DFI0_B0_DQS_T             (                                   ),
  .RxBypassDataPad_DFI0_B0_DQS_C             (                                   ),
  .RxBypassDataPad_DFI0_B1_DQS_T             (                                   ),
  .RxBypassDataPad_DFI0_B1_DQS_C             (                                   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassDataPad_DFI0_B2_DQS_T             (                                   ),
  .RxBypassDataPad_DFI0_B2_DQS_C             (                                   ),
  .RxBypassDataPad_DFI0_B3_DQS_T             (                                   ),
  .RxBypassDataPad_DFI0_B3_DQS_C             (                                   ),
`endif                                                                          
  .TxBypassMode_DFI0_B0_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI0_B0_DQS_C                (1'b0                               ),
  .TxBypassMode_DFI0_B1_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI0_B1_DQS_C                (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassMode_DFI0_B2_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI0_B2_DQS_C                (1'b0                               ),
  .TxBypassMode_DFI0_B3_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI0_B3_DQS_C                (1'b0                               ),
`endif                                       
  .TxBypassOE_DFI0_B0_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI0_B0_DQS_C                  (1'b0                               ),
  .TxBypassOE_DFI0_B1_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI0_B1_DQS_C                  (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .TxBypassOE_DFI0_B2_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI0_B2_DQS_C                  (1'b0                               ),
  .TxBypassOE_DFI0_B3_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI0_B3_DQS_C                  (1'b0                               ),
`endif                                     
  .TxBypassData_DFI0_B0_DQS_T                (1'b0                               ),
  .TxBypassData_DFI0_B0_DQS_C                (1'b0                               ),
  .TxBypassData_DFI0_B1_DQS_T                (1'b0                               ),
  .TxBypassData_DFI0_B1_DQS_C                (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassData_DFI0_B2_DQS_T                (1'b0                               ),
  .TxBypassData_DFI0_B2_DQS_C                (1'b0                               ),
  .TxBypassData_DFI0_B3_DQS_T                (1'b0                               ),
  .TxBypassData_DFI0_B3_DQS_C                (1'b0                               ),
`endif                                                                    
                                                                            
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                             
  .RxBypassRcvEn_DFI0_B0_WCK                 (1'b0                               ),
  .RxBypassRcvEn_DFI0_B1_WCK                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI0_B2_WCK                 (1'b0                               ),
  .RxBypassRcvEn_DFI0_B3_WCK                 (1'b0                               ),
`endif                                                                           
  .RxBypassDataRcv_DFI0_B0_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI0_B0_WCK_C             (                                  ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_C             (                                  ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassDataRcv_DFI0_B2_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI0_B2_WCK_C             (                                  ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_C             (                                  ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI0_B0_WCK                 (1'b0                              ),
  .RxBypassPadEn_DFI0_B1_WCK                 (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI0_B2_WCK                 (1'b0                              ),
  .RxBypassPadEn_DFI0_B3_WCK                 (1'b0                              ),
`endif                                                                           
  .RxBypassDataPad_DFI0_B0_WCK_T             (                                  ),
  .RxBypassDataPad_DFI0_B0_WCK_C             (                                  ),
  .RxBypassDataPad_DFI0_B1_WCK_T             (                                  ),
  .RxBypassDataPad_DFI0_B1_WCK_C             (                                  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataPad_DFI0_B2_WCK_T             (                                  ),
  .RxBypassDataPad_DFI0_B2_WCK_C             (                                  ),
  .RxBypassDataPad_DFI0_B3_WCK_T             (                                  ),
  .RxBypassDataPad_DFI0_B3_WCK_C             (                                  ),
`endif                                                                           
  .TxBypassMode_DFI0_B0_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI0_B0_WCK_C                (1'b0                              ),
  .TxBypassMode_DFI0_B1_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI0_B1_WCK_C                (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassMode_DFI0_B2_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI0_B2_WCK_C                (1'b0                              ),
  .TxBypassMode_DFI0_B3_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI0_B3_WCK_C                (1'b0                              ),
`endif                                                                           
  .TxBypassOE_DFI0_B0_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI0_B0_WCK_C                  (1'b0                              ),
  .TxBypassOE_DFI0_B1_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI0_B1_WCK_C                  (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassOE_DFI0_B2_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI0_B2_WCK_C                  (1'b0                              ),
  .TxBypassOE_DFI0_B3_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI0_B3_WCK_C                  (1'b0                              ),
`endif                                       
  .TxBypassData_DFI0_B0_WCK_T                (1'b0                              ),
  .TxBypassData_DFI0_B0_WCK_C                (1'b0                              ),
  .TxBypassData_DFI0_B1_WCK_T                (1'b0                              ),
  .TxBypassData_DFI0_B1_WCK_C                (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .TxBypassData_DFI0_B2_WCK_T                (1'b0                              ),
  .TxBypassData_DFI0_B2_WCK_C                (1'b0                              ),
  .TxBypassData_DFI0_B3_WCK_T                (1'b0                              ),
  .TxBypassData_DFI0_B3_WCK_C                (1'b0                              ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI0_CK                     (1'b0                              ),
  .RxBypassDataRcv_DFI0_CK_T                 (1'b0                              ),
  .RxBypassDataRcv_DFI0_CK_C                 (1'b0                              ),
  .RxBypassPadEn_DFI0_CK                     (1'b0                              ),
  .RxBypassDataPad_DFI0_CK_T                 (1'b0                              ),
  .RxBypassDataPad_DFI0_CK_C                 (1'b0                              ),
  .TxBypassMode_DFI0_CK_T                    (1'b0                              ),
  .TxBypassMode_DFI0_CK_C                    (1'b0                              ),
  .TxBypassOE_DFI0_CK_T                      (1'b0                              ),
  .TxBypassOE_DFI0_CK_C                      (1'b0                              ),
  .TxBypassData_DFI0_CK_T                    (1'b0                              ),
  .TxBypassData_DFI0_CK_C                    (1'b0                              ),

//************************* SEC **************
  .RxBypassPadEn_DFI0_LP4CKE_LP5CS           (1'b0                              ), 
  .RxBypassDataPad_DFI0_LP4CKE_LP5CS         (1'b0                              ),
  .TxBypassMode_DFI0_LP4CKE_LP5CS            (1'b0                              ),
  .TxBypassOE_DFI0_LP4CKE_LP5CS              (1'b0                              ),
  .TxBypassData_DFI0_LP4CKE_LP5CS            (1'b0                              ),
                                             
  .TxBypassMode_MEMRESET_L                   (1'b0                              ),
  .TxBypassData_MEMRESET_L                   (1'b0                              ),
                                            
  .TxBypassMode_DTO                          (1'b0                              ),
  .TxBypassOE_DTO                            (1'b0                              ),
  .TxBypassData_DTO                          (1'b0                              ),
  .RxBypassEn_DTO                            (1'b0                              ),
  .RxBypassDataPad_DTO                       (1'b0                              ),

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI1_B0_D                   (8'b0                               ), //8bit 
  .RxBypassRcvEn_DFI1_B1_D                   (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                     
  .RxBypassRcvEn_DFI1_B2_D                   (8'b0                               ),
  .RxBypassRcvEn_DFI1_B3_D                   (8'b0                               ),
`endif                                                                         
  .RxBypassData_DFI1_B0_D0                   (                                   ), //4bit
  .RxBypassData_DFI1_B0_D1                   (                                   ), //4bit
  .RxBypassData_DFI1_B0_D2                   (                                   ), //4bit
  .RxBypassData_DFI1_B0_D3                   (                                   ), //4bit
  .RxBypassData_DFI1_B0_D4                   (                                   ), //4bit
  .RxBypassData_DFI1_B0_D5                   (                                   ), //4bit
  .RxBypassData_DFI1_B0_D6                   (                                   ), //4bit
  .RxBypassData_DFI1_B0_D7                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D0                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D1                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D2                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D3                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D4                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D5                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D6                   (                                   ), //4bit
  .RxBypassData_DFI1_B1_D7                   (                                   ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassData_DFI1_B2_D0                   (                                   ), //4bit
  .RxBypassData_DFI1_B2_D1                   (                                   ), //4bit
  .RxBypassData_DFI1_B2_D2                   (                                   ), //4bit
  .RxBypassData_DFI1_B2_D3                   (                                   ), //4bit
  .RxBypassData_DFI1_B2_D4                   (                                   ), //4bit
  .RxBypassData_DFI1_B2_D5                   (                                   ), //4bit
  .RxBypassData_DFI1_B2_D6                   (                                   ), //4bit
  .RxBypassData_DFI1_B2_D7                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D0                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D1                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D2                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D3                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D4                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D5                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D6                   (                                   ), //4bit
  .RxBypassData_DFI1_B3_D7                   (                                   ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI1_B0_D                   (8'b0                               ), //8bit
  .RxBypassPadEn_DFI1_B1_D                   (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI1_B2_D                   (8'b0                               ),
  .RxBypassPadEn_DFI1_B3_D                   (8'b0                               ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_D                 (                                   ),
  .RxBypassDataPad_DFI1_B1_D                 (                                   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI1_B2_D                 (                                   ),
  .RxBypassDataPad_DFI1_B3_D                 (                                   ),
`endif                                                                   
  .TxBypassMode_DFI1_B0_D                    (8'b0                               ), //8bit
  .TxBypassMode_DFI1_B1_D                    (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassMode_DFI1_B2_D                    (8'b0                               ),
  .TxBypassMode_DFI1_B3_D                    (8'b0                               ),
`endif                                      
  .TxBypassOE_DFI1_B0_D                      (8'b0                               ), //8bit
  .TxBypassOE_DFI1_B1_D                      (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassOE_DFI1_B2_D                      (8'b0                               ),
  .TxBypassOE_DFI1_B3_D                      (8'b0                               ),
`endif                                                               
  .TxBypassData_DFI1_B0_D                    (8'b0                               ),
  .TxBypassData_DFI1_B1_D                    (8'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                     
  .TxBypassData_DFI1_B2_D                    (8'b0                               ),
  .TxBypassData_DFI1_B3_D                    (8'b0                               ),
`endif                                                                           
                                                                                 
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                              
  .RxBypassRcvEn_DFI1_B0_DMI                 (1'b0                               ),
  .RxBypassRcvEn_DFI1_B1_DMI                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassRcvEn_DFI1_B2_DMI                 (1'b0                               ),
  .RxBypassRcvEn_DFI1_B3_DMI                 (1'b0                               ),
`endif                                                                         
  .RxBypassData_DFI1_B0_DMI                  (                                 ),   //4bit
  .RxBypassData_DFI1_B1_DMI                  (                                 ),   //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                  
  .RxBypassData_DFI1_B2_DMI                  (                                 ),   //4bit
  .RxBypassData_DFI1_B3_DMI                  (                                 ),   //4bit
`endif                                                                       
  .RxBypassPadEn_DFI1_B0_DMI                 (1'b0                               ),
  .RxBypassPadEn_DFI1_B1_DMI                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                            
  .RxBypassPadEn_DFI1_B2_DMI                 (1'b0                               ),
  .RxBypassPadEn_DFI1_B3_DMI                 (1'b0                               ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_DMI               (                                   ),
  .RxBypassDataPad_DFI1_B1_DMI               (                                   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassDataPad_DFI1_B2_DMI               (                                   ),
  .RxBypassDataPad_DFI1_B3_DMI               (                                   ),
`endif                                                                   
  .TxBypassMode_DFI1_B0_DMI                  (1'b0                               ),
  .TxBypassMode_DFI1_B1_DMI                  (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassMode_DFI1_B2_DMI                  (1'b0                               ),
  .TxBypassMode_DFI1_B3_DMI                  (1'b0                               ),
`endif                                                              
  .TxBypassOE_DFI1_B0_DMI                    (1'b0                               ),
  .TxBypassOE_DFI1_B1_DMI                    (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassOE_DFI1_B2_DMI                    (1'b0                               ),
  .TxBypassOE_DFI1_B3_DMI                    (1'b0                               ),
`endif                                                              
  .TxBypassData_DFI1_B0_DMI                  (1'b0                               ),
  .TxBypassData_DFI1_B1_DMI                  (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                          
  .TxBypassData_DFI1_B2_DMI                  (1'b0                               ),
  .TxBypassData_DFI1_B3_DMI                  (1'b0                               ),
`endif                                                                           
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                         
                                                                                
  .RxBypassRcvEn_DFI1_CA                     ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}   ),   //6+`DWC_DDRPHY_NUM_RANKS
  .RxBypassData_DFI1_CA0                     (                                  ),   //4bit
  .RxBypassData_DFI1_CA1                     (                                  ),   //4bit
  .RxBypassData_DFI1_CA2                     (                                  ),   //4bit
  .RxBypassData_DFI1_CA3                     (                                  ),   //4bit
  .RxBypassData_DFI1_CA4                     (                                  ),   //4bit
  .RxBypassData_DFI1_CA5                     (                                  ),   //4bit
  .RxBypassData_DFI1_CA6                     (                                  ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                                                   
  .RxBypassData_DFI1_CA7                     (                                  ),   //4bit
`endif                                                                          
  .RxBypassPadEn_DFI1_CA                     ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),   //6+`DWC_DDRPHY_NUM_RANKS
  .RxBypassDataPad_DFI1_CA                   (                                   ),
  .TxBypassMode_DFI1_CA                      ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),
  .TxBypassOE_DFI1_CA                        ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),
  .TxBypassData_DFI1_CA                      ({6+`DWC_DDRPHY_NUM_RANKS{1'b0}}    ),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI1_B0_DQS                 (1'b0                               ),
  .RxBypassRcvEn_DFI1_B1_DQS                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                   
  .RxBypassRcvEn_DFI1_B2_DQS                 (1'b0                               ),
  .RxBypassRcvEn_DFI1_B3_DQS                 (1'b0                               ),
`endif                                                                          
  .RxBypassDataRcv_DFI1_B0_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI1_B0_DQS_C             (                                   ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_C             (                                   ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataRcv_DFI1_B2_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI1_B2_DQS_C             (                                   ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_T             (                                   ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_C             (                                   ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI1_B0_DQS                 (1'b0                               ),
  .RxBypassPadEn_DFI1_B1_DQS                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                              
  .RxBypassPadEn_DFI1_B2_DQS                 (1'b0                               ),
  .RxBypassPadEn_DFI1_B3_DQS                 (1'b0                               ),
`endif                                                                      
  .RxBypassDataPad_DFI1_B0_DQS_T             (                                   ),
  .RxBypassDataPad_DFI1_B0_DQS_C             (                                   ),
  .RxBypassDataPad_DFI1_B1_DQS_T             (                                   ),
  .RxBypassDataPad_DFI1_B1_DQS_C             (                                   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassDataPad_DFI1_B2_DQS_T             (                                   ),
  .RxBypassDataPad_DFI1_B2_DQS_C             (                                   ),
  .RxBypassDataPad_DFI1_B3_DQS_T             (                                   ),
  .RxBypassDataPad_DFI1_B3_DQS_C             (                                   ),
`endif                                                                          
  .TxBypassMode_DFI1_B0_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI1_B0_DQS_C                (1'b0                               ),
  .TxBypassMode_DFI1_B1_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI1_B1_DQS_C                (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassMode_DFI1_B2_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI1_B2_DQS_C                (1'b0                               ),
  .TxBypassMode_DFI1_B3_DQS_T                (1'b0                               ),
  .TxBypassMode_DFI1_B3_DQS_C                (1'b0                               ),
`endif                                       
  .TxBypassOE_DFI1_B0_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI1_B0_DQS_C                  (1'b0                               ),
  .TxBypassOE_DFI1_B1_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI1_B1_DQS_C                  (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .TxBypassOE_DFI1_B2_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI1_B2_DQS_C                  (1'b0                               ),
  .TxBypassOE_DFI1_B3_DQS_T                  (1'b0                               ),
  .TxBypassOE_DFI1_B3_DQS_C                  (1'b0                               ),
`endif                                     
  .TxBypassData_DFI1_B0_DQS_T                (1'b0                               ),
  .TxBypassData_DFI1_B0_DQS_C                (1'b0                               ),
  .TxBypassData_DFI1_B1_DQS_T                (1'b0                               ),
  .TxBypassData_DFI1_B1_DQS_C                (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassData_DFI1_B2_DQS_T                (1'b0                               ),
  .TxBypassData_DFI1_B2_DQS_C                (1'b0                               ),
  .TxBypassData_DFI1_B3_DQS_T                (1'b0                               ),
  .TxBypassData_DFI1_B3_DQS_C                (1'b0                               ),
`endif                                                                    
                                                                            
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                             
  .RxBypassRcvEn_DFI1_B0_WCK                 (1'b0                               ),
  .RxBypassRcvEn_DFI1_B1_WCK                 (1'b0                               ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI1_B2_WCK                 (1'b0                               ),
  .RxBypassRcvEn_DFI1_B3_WCK                 (1'b0                               ),
`endif                                                                           
  .RxBypassDataRcv_DFI1_B0_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI1_B0_WCK_C             (                                  ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_C             (                                  ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassDataRcv_DFI1_B2_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI1_B2_WCK_C             (                                  ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_T             (                                  ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_C             (                                  ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI1_B0_WCK                 (1'b0                              ),
  .RxBypassPadEn_DFI1_B1_WCK                 (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI1_B2_WCK                 (1'b0                              ),
  .RxBypassPadEn_DFI1_B3_WCK                 (1'b0                              ),
`endif                                                                           
  .RxBypassDataPad_DFI1_B0_WCK_T             (                                  ),
  .RxBypassDataPad_DFI1_B0_WCK_C             (                                  ),
  .RxBypassDataPad_DFI1_B1_WCK_T             (                                  ),
  .RxBypassDataPad_DFI1_B1_WCK_C             (                                  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataPad_DFI1_B2_WCK_T             (                                  ),
  .RxBypassDataPad_DFI1_B2_WCK_C             (                                  ),
  .RxBypassDataPad_DFI1_B3_WCK_T             (                                  ),
  .RxBypassDataPad_DFI1_B3_WCK_C             (                                  ),
`endif                                                                           
  .TxBypassMode_DFI1_B0_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI1_B0_WCK_C                (1'b0                              ),
  .TxBypassMode_DFI1_B1_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI1_B1_WCK_C                (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassMode_DFI1_B2_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI1_B2_WCK_C                (1'b0                              ),
  .TxBypassMode_DFI1_B3_WCK_T                (1'b0                              ),
  .TxBypassMode_DFI1_B3_WCK_C                (1'b0                              ),
`endif                                                                           
  .TxBypassOE_DFI1_B0_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI1_B0_WCK_C                  (1'b0                              ),
  .TxBypassOE_DFI1_B1_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI1_B1_WCK_C                  (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassOE_DFI1_B2_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI1_B2_WCK_C                  (1'b0                              ),
  .TxBypassOE_DFI1_B3_WCK_T                  (1'b0                              ),
  .TxBypassOE_DFI1_B3_WCK_C                  (1'b0                              ),
`endif                                       
  .TxBypassData_DFI1_B0_WCK_T                (1'b0                              ),
  .TxBypassData_DFI1_B0_WCK_C                (1'b0                              ),
  .TxBypassData_DFI1_B1_WCK_T                (1'b0                              ),
  .TxBypassData_DFI1_B1_WCK_C                (1'b0                              ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .TxBypassData_DFI1_B2_WCK_T                (1'b0                              ),
  .TxBypassData_DFI1_B2_WCK_C                (1'b0                              ),
  .TxBypassData_DFI1_B3_WCK_T                (1'b0                              ),
  .TxBypassData_DFI1_B3_WCK_C                (1'b0                              ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI1_CK                     (1'b0                              ),
  .RxBypassDataRcv_DFI1_CK_T                 (1'b0                              ),
  .RxBypassDataRcv_DFI1_CK_C                 (1'b0                              ),
  .RxBypassPadEn_DFI1_CK                     (1'b0                              ),
  .RxBypassDataPad_DFI1_CK_T                 (1'b0                              ),
  .RxBypassDataPad_DFI1_CK_C                 (1'b0                              ),
  .TxBypassMode_DFI1_CK_T                    (1'b0                              ),
  .TxBypassMode_DFI1_CK_C                    (1'b0                              ),
  .TxBypassOE_DFI1_CK_T                      (1'b0                              ),
  .TxBypassOE_DFI1_CK_C                      (1'b0                              ),
  .TxBypassData_DFI1_CK_T                    (1'b0                              ),
  .TxBypassData_DFI1_CK_C                    (1'b0                              ),

//************************* SEC **************
  .RxBypassPadEn_DFI1_LP4CKE_LP5CS           (1'b0                              ), 
  .RxBypassDataPad_DFI1_LP4CKE_LP5CS         (1'b0                              ),
  .TxBypassMode_DFI1_LP4CKE_LP5CS            (1'b0                              ),
  .TxBypassOE_DFI1_LP4CKE_LP5CS              (1'b0                              ),
  .TxBypassData_DFI1_LP4CKE_LP5CS            (1'b0                              ),
`endif  //DWC_DDRPHY_NUM_CHANNELS_2
`endif  //FLYOVER_TEST
////////////////////////////////////////////////////////////////////////////////
// TOP LEVEL I/Os: RESETs/CLKs
////////////////////////////////////////////////////////////////////////////////

 //.PwrOkIn                               ( PwrOkIn                         ),
`ifdef FLYOVER_TEST
 .BP_PWROK                              ( (!mission_mode&bp_pwrok) | (PwrOkIn&mission_mode)                         ),
 .Reset                                 ( (!mission_mode&RESET) | (Reset&mission_mode) ),
`else
 .BP_PWROK                              ( PwrOkIn                         ),
 .Reset                                 ( Reset                           ),
`endif
 .Reset_async                           ( Reset                           ),
 //.BypassPclk                            ( bypass_clk                      ),
 .BurnIn                                ( 1'b0                            ),
 .PllRefClk                             (dfi_ctl_clk_assign               ), 
 .PllBypClk                             (bypass_clk                       ),       
 .UcClk                                 (UcClk                            ),
////////////////////////////////////////////////////////////////////////////////
// TOP LEVEL I/Os: ATPG/JTAG
////////////////////////////////////////////////////////////////////////////////
`ifdef FLYOVER_TEST
   .atpg_se						(ATPG_SE),
   .atpg_si						({`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS{ATPG_SI}}),
   .atpg_so						(),
   .atpg_mode				   (ATPG_MODE),
`else
.atpg_mode                              ( 1'b0                           ),
.atpg_se                                ({`DWC_DDRPHY_ATPG_SE_WIDTH{1'b0}}),
.atpg_si                                ({`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS{1'b0}}),
.atpg_so                                ( atpg_so                        ),
`endif
//.atpg_lu_ctrl                           ( {6{1'b1}}                      ),
.atpg_RDQSClk                           ( 1'b0                           ),
//.atpg_Pclk                              ( 1'b0                           ),
.atpg_TxDllClk                          ( 1'b0                           ),

`ifdef DWC_DDRPHY_LBIST_EN
`ifndef PUB_VERSION_GE_0100
 .DfiClk0_lbist      (DfiClk0_lbist),
 `endif
 .lbist_mode         (LBIST_MODE),
 .LBIST_TM0          (LBIST_TM0),
 .LBIST_TM1          (LBIST_TM1),
 .LBIST_EN           (LBIST_EN),
 .START              (START),
 .STATUS_0           (STATUS_0),
 .STATUS_1           (STATUS_1),
`endif  

.TDRCLK                                 ( TDRCLK                         ),   // TDR Clock
.WRSTN                                  ( WRSTN                          ),    // TDR low active async reset
.WSI                                    ( WSI                            ),      // TDR Serial Input
.DdrPhyCsrCmdTdrShiftEn                 ( DdrPhyCsrCmdTdrShiftEn         ),
.DdrPhyCsrCmdTdrCaptureEn               ( DdrPhyCsrCmdTdrCaptureEn       ),
.DdrPhyCsrCmdTdrUpdateEn                ( DdrPhyCsrCmdTdrUpdateEn        ),
.DdrPhyCsrCmdTdr_Tdo                    ( DdrPhyCsrCmdTdr_Tdo            ),
.DdrPhyCsrRdDataTdrShiftEn              ( DdrPhyCsrRdDataTdrShiftEn      ),
.DdrPhyCsrRdDataTdrCaptureEn            ( DdrPhyCsrRdDataTdrCaptureEn    ),
.DdrPhyCsrRdDataTdrUpdateEn             ( DdrPhyCsrRdDataTdrUpdateEn     ),
.DdrPhyCsrRdDataTdr_Tdo                 ( DdrPhyCsrRdDataTdr_Tdo         ),

//.dwc_ddrphy_int_n                       ( dwc_ddrphy_int_n               )

//-----------------------------------------not use port addd by elvin-------------------------------------//
.atpg_PllCtrlBus                        ( 142'h0            ),               
.atpg_Asst_Clken                        ( 1'b0              ),  
.atpg_Asst_Clk                          (                   ),
.atpg_UcClk                             (                   ),

.dfi0_ctrlmsg                           ( {`DWC_DDRPHY_DFI0_CTRLMSG_WIDTH{1'b0}}         ),
.dfi0_ctrlmsg_ack                       (                    ),
.dfi0_ctrlmsg_data                      ( {`DWC_DDRPHY_DFI0_CTRLMSG_DATA_WIDTH{1'b0}}    ),
.dfi0_ctrlmsg_req                       ( {`DWC_DDRPHY_DFI0_CTRLMSG_REQ_WIDTH{1'b0} }    ),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dfi1_ctrlmsg                           ( {`DWC_DDRPHY_DFI1_CTRLMSG_WIDTH{1'b0}}         ),
.dfi1_ctrlmsg_ack                       (                    ),
.dfi1_ctrlmsg_data                      ( {`DWC_DDRPHY_DFI1_CTRLMSG_DATA_WIDTH{1'b0}}    ),
.dfi1_ctrlmsg_req                       ( {`DWC_DDRPHY_DFI1_CTRLMSG_REQ_WIDTH{1'b0} }    ),
`endif
`ifdef LP5_STD
.dfi0_wck_write_P0          ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),   
.dfi0_wck_write_P1          ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_write_P2          ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_write_P3          ({`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wrdata_link_ecc_P0                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P1                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P2                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P3                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
`endif
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
`ifdef LP5_STD
.dfi1_wck_write_P0                      ({`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),   
.dfi1_wck_write_P1                      ({`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_write_P2                      ({`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_write_P3                      ({`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),

.dfi1_wrdata_link_ecc_P0                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P1                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P2                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P3                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
`endif
`endif
.PhyInt_n                               (                    ),
.PhyInt_fault                           (                    ),
.dwc_ddrphy0_snoop_en_P0                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
.dwc_ddrphy0_snoop_en_P1                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
.dwc_ddrphy0_snoop_en_P2                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
.dwc_ddrphy0_snoop_en_P3                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dwc_ddrphy1_snoop_en_P0                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
.dwc_ddrphy1_snoop_en_P1                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
.dwc_ddrphy1_snoop_en_P2                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
.dwc_ddrphy1_snoop_en_P3                ( {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}}),
`endif

.atpg_PClk                              (  1'b0                             ),
.atpg_DlyTestClk                        (  1'b0                             ),
.haddr_ahb                              (                                   ),
.hburst_ahb                             (                                   ),
.hmastlock_ahb                          (                                   ),
.hprot_ahb                              (                                   ),
.hsize_ahb                              (                                   ),
.htrans_ahb                             (                                   ),
.hwdata_ahb                             (                                   ),
.hwrite_ahb                             (                                   ),
.hclk_ahb                               (                                   ),
.hresetn_ahb                            (                                   ),
.hrdata_ahb                             ( 32'h0                             ),
.hresp_ahb                              ( 1'b0                              ),
.hreadyout_ahb                          ( 1'b0                              ),
.ps_ram_rddata                          ( 60'h0                             ),
.ps_ram_wrdata                          (                                   ),
.ps_ram_addr                            (                                   ),
.ps_ram_ce                              (                                   ),
.ps_ram_we                              (                                   ),
.ZCAL_SENSE                             (  1'b0                             ),
.ZCAL_INT                               (                                   )


);

`else
//-----------------------UPF XPROP ------------------------//
//====================add by elvin=========================//
dwc_ddrphy_top_wrap dut (


 // ----------DFI Interface  ------------------------------
.DfiClk                     ( dis_upf_xprop ? dfi_ctl_clk_assign : ( (~dwc_PwrOkIn_XDriver ) ? 1'bx : dfi_ctl_clk_assign) ),
.dfi_reset_n			       ( dis_upf_xprop ? dfi_reset_n     : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : dfi_reset_n) ),
.dfi0_address_P0		       ( dis_upf_xprop ? dfi0_address_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_ADDRESS_WIDTH{1'bx}} : dfi0_address_P0 ) ), 
.dfi0_address_P1		       ( dis_upf_xprop ? dfi0_address_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_ADDRESS_WIDTH{1'bx}} : dfi0_address_P1 ) ),
.dfi0_address_P2		       ( dis_upf_xprop ? dfi0_address_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_ADDRESS_WIDTH{1'bx}} : dfi0_address_P2 ) ),
.dfi0_address_P3		       ( dis_upf_xprop ? dfi0_address_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_ADDRESS_WIDTH{1'bx}} : dfi0_address_P3 ) ),

.dfi0_cke_P0			       ( dis_upf_xprop ? dfi0_cke_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi0_cke_P0 ) ),
.dfi0_cke_P1			       ( dis_upf_xprop ? dfi0_cke_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi0_cke_P1 ) ),
.dfi0_cke_P2			       ( dis_upf_xprop ? dfi0_cke_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi0_cke_P2 ) ),
.dfi0_cke_P3			       ( dis_upf_xprop ? dfi0_cke_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi0_cke_P3 ) ),

.dfi0_cs_P0                 ( dis_upf_xprop ? dfi0_cs_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CS_WIDTH{1'bx}} : dfi0_cs_P0 ) ),
.dfi0_cs_P1                 ( dis_upf_xprop ? dfi0_cs_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CS_WIDTH{1'bx}} : dfi0_cs_P1 ) ),
.dfi0_cs_P2                 ( dis_upf_xprop ? dfi0_cs_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CS_WIDTH{1'bx}} : dfi0_cs_P2 ) ),
.dfi0_cs_P3                 ( dis_upf_xprop ? dfi0_cs_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CS_WIDTH{1'bx}} : dfi0_cs_P3 ) ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
`ifdef LP5_STD
.dfi0_wck_en_P0             ( dis_upf_xprop ? dfi0_wck_en_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'bx}} : dfi0_wck_en_P0 ) ),
.dfi0_wck_en_P1             ( dis_upf_xprop ? dfi0_wck_en_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'bx}} : dfi0_wck_en_P1 ) ),
.dfi0_wck_en_P2             ( dis_upf_xprop ? dfi0_wck_en_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'bx}} : dfi0_wck_en_P2 ) ),
.dfi0_wck_en_P3             ( dis_upf_xprop ? dfi0_wck_en_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'bx}} : dfi0_wck_en_P3 ) ),

.dfi0_wck_cs_P0             ( dis_upf_xprop ? dfi0_wck_cs_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'bx}} : dfi0_wck_cs_P0 ) ),
.dfi0_wck_cs_P1             ( dis_upf_xprop ? dfi0_wck_cs_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'bx}} : dfi0_wck_cs_P1 ) ),
.dfi0_wck_cs_P2             ( dis_upf_xprop ? dfi0_wck_cs_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'bx}} : dfi0_wck_cs_P2 ) ),
.dfi0_wck_cs_P3             ( dis_upf_xprop ? dfi0_wck_cs_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'bx}} : dfi0_wck_cs_P3 ) ),

.dfi0_wck_toggle_P0         ( dis_upf_xprop ? dfi0_wck_toggle_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'bx}} : dfi0_wck_toggle_P0 ) ),
.dfi0_wck_toggle_P1         ( dis_upf_xprop ? dfi0_wck_toggle_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'bx}} : dfi0_wck_toggle_P1 ) ),
.dfi0_wck_toggle_P2         ( dis_upf_xprop ? dfi0_wck_toggle_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'bx}} : dfi0_wck_toggle_P2 ) ),
.dfi0_wck_toggle_P3         ( dis_upf_xprop ? dfi0_wck_toggle_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'bx}} : dfi0_wck_toggle_P3 ) ),
//.dfi0_wrdata_link_ecc_P0                ( dfi0_wrdata_link_ecc_P1         ),
//.dfi0_wrdata_link_ecc_P1                ( dfi0_wrdata_link_ecc_P2         ),
//.dfi0_wrdata_link_ecc_P2                ( dfi0_wrdata_link_ecc_P3         ),
//.dfi0_wrdata_link_ecc_P3                ( dfi0_wrdata_link_ecc_P4         ),
`else
.dfi0_wck_write_P0                      ( {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),   
.dfi0_wck_write_P1                      ( {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_write_P2                      ( {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_write_P3                      ( {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}}),
.dfi0_wck_en_P0                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_en_P1                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_en_P2                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_en_P3                         ( {`DWC_DDRPHY_DFI0_WCK_EN_WIDTH{1'b0}}),
.dfi0_wck_cs_P0                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),
.dfi0_wck_cs_P1                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),
.dfi0_wck_cs_P2                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),
.dfi0_wck_cs_P3                         ( {`DWC_DDRPHY_DFI0_WCK_CS_WIDTH{1'b0}}),

.dfi0_wck_toggle_P0                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi0_wck_toggle_P1                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi0_wck_toggle_P2                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi0_wck_toggle_P3                     ( {`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH{1'b0}}),

.dfi0_wrdata_link_ecc_P0                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P1                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P2                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi0_wrdata_link_ecc_P3                ( {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
`endif
`endif

.dfi0_ctrlupd_ack		       ( dfi0_ctrlupd_ack                ),
.dfi0_ctrlupd_req		       ( dfi0_ctrlupd_req                ),
`ifndef PUB_VERSION_LE_0200 //RID < 0200
.dfi0_ctrlupd_type	( 2'b00 ),
`endif
.dfi0_dram_clk_disable_P0	 ( dis_upf_xprop ? dfi0_dram_clk_disable_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi0_dram_clk_disable_P0 ) ),	
.dfi0_dram_clk_disable_P1	 ( dis_upf_xprop ? dfi0_dram_clk_disable_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi0_dram_clk_disable_P1 ) ),
.dfi0_dram_clk_disable_P2	 ( dis_upf_xprop ? dfi0_dram_clk_disable_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi0_dram_clk_disable_P2 ) ),	
.dfi0_dram_clk_disable_P3	 ( dis_upf_xprop ? dfi0_dram_clk_disable_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi0_dram_clk_disable_P3 ) ),

.dfi0_error				       ( dfi0_error                                                                                                                 ),
.dfi0_error_info			    ( dfi0_error_info                                                                                                            ),
.dfi0_frequency		       ( dis_upf_xprop ? dfi0_frequency  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_FREQUENCY_WIDTH{1'bx}} : dfi0_frequency  )  ),
.dfi0_freq_ratio			    ( dis_upf_xprop ? dfi0_freq_ratio  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_FREQ_RATIO_WIDTH{1'bx}} : dfi0_freq_ratio) ),
.dfi0_init_complete			 ( dfi0_init_complete                                                                                                         ),		
.dfi0_init_start			    ( dis_upf_xprop ? dfi0_init_start  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_INIT_START_WIDTH{1'bx}} : dfi0_init_start) ),

//.dfi0_phy_info_ack                      ( dfi0_phy_info_ack               ),
//.dfi0_phy_info_req                      ( dfi0_phy_info_req               ),
//.dfi0_phy_info_cmd                      ( dfi0_phy_info_cmd               ),
//.dfi0_phy_info_data                     ( dfi0_phy_info_data              ),
.dfi0_lp_ctrl_ack	          ( dfi0_lp_ctrl_ack   ),
.dfi0_lp_data_ack           ( dfi0_lp_data_ack   ),
.dfi0_lp_ctrl_req			    ( dis_upf_xprop ? dfi0_lp_ctrl_req : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_LP_CTRL_REQ_WIDTH{1'bx}} : dfi0_lp_ctrl_req ) ),
.dfi0_lp_data_req			    ( dis_upf_xprop ? dfi0_lp_data_req : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_LP_DATA_REQ_WIDTH{1'bx}} : dfi0_lp_data_req ) ),
.dfi0_freq_fsp              ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_FREQ_FSP_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_FREQ_FSP_WIDTH{1'bx}} :{`DWC_DDRPHY_DFI0_FREQ_FSP_WIDTH{1'b0}})            ),
.dfi0_lp_ctrl_wakeup        ( dis_upf_xprop ? dfi0_lp_ctrl_wakeup  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_LP_CTRL_WAKEUP_WIDTH{1'bx}} : dfi0_lp_ctrl_wakeup  )                                          ),
.dfi0_lp_data_wakeup        ( dis_upf_xprop ? dfi0_lp_data_wakeup  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_LP_DATA_ACK_WIDTH{1'bx}} : dfi0_lp_data_wakeup  )                                             ),
.dfi0_phymstr_ack			    ( dfi0_phymstr_ack ),		
.dfi0_phymstr_cs_state		 ( dfi0_phymstr_cs_state           ),		
.dfi0_phymstr_req	          ( dfi0_phymstr_req                ),	
.dfi0_phymstr_state_sel		 ( dfi0_phymstr_state_sel          ),		
.dfi0_phymstr_type			 ( dfi0_phymstr_type               ),
.dfi0_phyupd_ack		     	 ( dfi0_phyupd_ack  ),		
.dfi0_phyupd_req		     	 ( dfi0_phyupd_req                 ),		
.dfi0_phyupd_type		     	 ( dfi0_phyupd_type                ),
.dfi0_rddata_W0           	 ( dfi0_rddata_W0  ),
.dfi0_rddata_W1           	 ( dfi0_rddata_W1  ),
.dfi0_rddata_W2           	 ( dfi0_rddata_W2  ),
.dfi0_rddata_W3           	 ( dfi0_rddata_W3  ),
.dfi0_rddata_cs_P0		  	 ( dis_upf_xprop ? dfi0_rddata_cs_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH{1'bx}} : dfi0_rddata_cs_P0) ),
.dfi0_rddata_cs_P1		  	 ( dis_upf_xprop ? dfi0_rddata_cs_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH{1'bx}} : dfi0_rddata_cs_P1) ),
.dfi0_rddata_cs_P2		  	 ( dis_upf_xprop ? dfi0_rddata_cs_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH{1'bx}} : dfi0_rddata_cs_P2) ),
.dfi0_rddata_cs_P3		  	 ( dis_upf_xprop ? dfi0_rddata_cs_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH{1'bx}} : dfi0_rddata_cs_P3) ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi0_rddata_dbi_W0			 ( dfi0_rddata_dbi_W0  ),
.dfi0_rddata_dbi_W1			 ( dfi0_rddata_dbi_W1  ),
.dfi0_rddata_dbi_W2			 ( dfi0_rddata_dbi_W2  ),
.dfi0_rddata_dbi_W3			 ( dfi0_rddata_dbi_W3  ),
`endif
.dfi0_rddata_en_P0			 ( dis_upf_xprop ? dfi0_rddata_en_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH{1'bx}} : dfi0_rddata_en_P0) ),
.dfi0_rddata_en_P1			 ( dis_upf_xprop ? dfi0_rddata_en_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH{1'bx}} : dfi0_rddata_en_P1) ),
.dfi0_rddata_en_P2			 ( dis_upf_xprop ? dfi0_rddata_en_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH{1'bx}} : dfi0_rddata_en_P2) ),
.dfi0_rddata_en_P3			 ( dis_upf_xprop ? dfi0_rddata_en_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH{1'bx}} : dfi0_rddata_en_P3) ),
.dfi0_rddata_valid_W0		 ( dfi0_rddata_valid_W0            ),
.dfi0_rddata_valid_W1		 ( dfi0_rddata_valid_W1            ),
.dfi0_rddata_valid_W2		 ( dfi0_rddata_valid_W2            ),
.dfi0_rddata_valid_W3		 ( dfi0_rddata_valid_W3            ),
.dfi0_wrdata_P0				 ( dis_upf_xprop ? dfi0_wrdata_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_WIDTH{1'bx}} : dfi0_wrdata_P0) ),
.dfi0_wrdata_P1				 ( dis_upf_xprop ? dfi0_wrdata_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_WIDTH{1'bx}} : dfi0_wrdata_P1) ),
.dfi0_wrdata_P2				 ( dis_upf_xprop ? dfi0_wrdata_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_WIDTH{1'bx}} : dfi0_wrdata_P2) ),
.dfi0_wrdata_P3				 ( dis_upf_xprop ? dfi0_wrdata_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_WIDTH{1'bx}} : dfi0_wrdata_P3) ),
.dfi0_wrdata_cs_P0			 ( dis_upf_xprop ? dfi0_wrdata_cs_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH{1'bx}} : dfi0_wrdata_cs_P0) ),
.dfi0_wrdata_cs_P1			 ( dis_upf_xprop ? dfi0_wrdata_cs_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH{1'bx}} : dfi0_wrdata_cs_P1) ),
.dfi0_wrdata_cs_P2			 ( dis_upf_xprop ? dfi0_wrdata_cs_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH{1'bx}} : dfi0_wrdata_cs_P2) ),
.dfi0_wrdata_cs_P3			 ( dis_upf_xprop ? dfi0_wrdata_cs_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH{1'bx}} : dfi0_wrdata_cs_P3) ),
.dfi0_wrdata_en_P0			 ( dis_upf_xprop ? dfi0_wrdata_en_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH{1'bx}} : dfi0_wrdata_en_P0) ),
.dfi0_wrdata_en_P1			 ( dis_upf_xprop ? dfi0_wrdata_en_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH{1'bx}} : dfi0_wrdata_en_P1) ),
.dfi0_wrdata_en_P2			 ( dis_upf_xprop ? dfi0_wrdata_en_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH{1'bx}} : dfi0_wrdata_en_P2) ),
.dfi0_wrdata_en_P3			 ( dis_upf_xprop ? dfi0_wrdata_en_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH{1'bx}} : dfi0_wrdata_en_P3) ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi0_wrdata_mask_P0			 ( dis_upf_xprop ? dfi0_wrdata_mask_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH{1'bx}} : dfi0_wrdata_mask_P0) ),
.dfi0_wrdata_mask_P1			 ( dis_upf_xprop ? dfi0_wrdata_mask_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH{1'bx}} : dfi0_wrdata_mask_P1) ),
.dfi0_wrdata_mask_P2			 ( dis_upf_xprop ? dfi0_wrdata_mask_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH{1'bx}} : dfi0_wrdata_mask_P2) ),
.dfi0_wrdata_mask_P3			 ( dis_upf_xprop ? dfi0_wrdata_mask_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH{1'bx}} : dfi0_wrdata_mask_P3) ),	
`endif
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dfi1_address_P0			    ( dis_upf_xprop ? dwc_dfi1_address_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'bx}} : dwc_dfi1_address_P0) ), 
.dfi1_address_P1			    ( dis_upf_xprop ? dwc_dfi1_address_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'bx}} : dwc_dfi1_address_P1) ),
.dfi1_address_P2			    ( dis_upf_xprop ? dfi1_address_P2     : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'bx}} : dfi1_address_P2    ) ),
.dfi1_address_P3			    ( dis_upf_xprop ? dfi1_address_P3     : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_ADDRESS_WIDTH{1'bx}} : dfi1_address_P3    ) ),

.dfi1_cke_P0				    ( dis_upf_xprop ? dfi1_cke_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi1_cke_P0) ),
.dfi1_cke_P1			       ( dis_upf_xprop ? dfi1_cke_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi1_cke_P1) ),
.dfi1_cke_P2				    ( dis_upf_xprop ? dfi1_cke_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi1_cke_P2) ),
.dfi1_cke_P3			       ( dis_upf_xprop ? dfi1_cke_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CKE_WIDTH{1'bx}} : dfi1_cke_P3) ),

.dfi1_cs_P0                 ( dis_upf_xprop ? dwc_dfi1_cs_P0  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_CS_WIDTH{1'bx}} : dwc_dfi1_cs_P0 ) ),
.dfi1_cs_P1                 ( dis_upf_xprop ? dwc_dfi1_cs_P1  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_CS_WIDTH{1'bx}} : dwc_dfi1_cs_P1 ) ),
.dfi1_cs_P2                 ( dis_upf_xprop ? dfi1_cs_P2      : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_CS_WIDTH{1'bx}} : dfi1_cs_P2     ) ),
.dfi1_cs_P3                 ( dis_upf_xprop ? dfi1_cs_P3      : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_CS_WIDTH{1'bx}} : dfi1_cs_P3     ) ),
                                                                                                                                                 
 `ifdef DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                
`ifdef LP5_STD                                                                                                                                   
.dfi1_wck_en_P0             ( dis_upf_xprop ? dfi1_wck_en_P0  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'bx}} : dfi1_wck_en_P0 ) ),
.dfi1_wck_en_P1             ( dis_upf_xprop ? dfi1_wck_en_P1  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'bx}} : dfi1_wck_en_P1 ) ),
.dfi1_wck_en_P2             ( dis_upf_xprop ? dfi1_wck_en_P2  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'bx}} : dfi1_wck_en_P2 ) ),
.dfi1_wck_en_P3             ( dis_upf_xprop ? dfi1_wck_en_P3  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'bx}} : dfi1_wck_en_P3 ) ),
                                                                                                                                                 
.dfi1_wck_cs_P0             ( dis_upf_xprop ? dfi1_wck_cs_P0  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'bx}} : dfi1_wck_cs_P0 ) ),
.dfi1_wck_cs_P1             ( dis_upf_xprop ? dfi1_wck_cs_P1  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'bx}} : dfi1_wck_cs_P1 ) ),
.dfi1_wck_cs_P2             ( dis_upf_xprop ? dfi1_wck_cs_P2  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'bx}} : dfi1_wck_cs_P2 ) ),
.dfi1_wck_cs_P3             ( dis_upf_xprop ? dfi1_wck_cs_P3  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'bx}} : dfi1_wck_cs_P3 ) ),

.dfi1_wck_toggle_P0         ( dis_upf_xprop ? dfi1_wck_toggle_P0  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'bx}} : dfi1_wck_toggle_P0 ) ),
.dfi1_wck_toggle_P1         ( dis_upf_xprop ? dfi1_wck_toggle_P1  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'bx}} : dfi1_wck_toggle_P1 ) ),
.dfi1_wck_toggle_P2         ( dis_upf_xprop ? dfi1_wck_toggle_P2  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'bx}} : dfi1_wck_toggle_P2 ) ),
.dfi1_wck_toggle_P3         ( dis_upf_xprop ? dfi1_wck_toggle_P3  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'bx}} : dfi1_wck_toggle_P3 ) ),
//.dfi1_wrdata_link_ecc_P0  ( dfi1_wrdata_link_ecc_P1         ),
//.dfi1_wrdata_link_ecc_P1  ( dfi1_wrdata_link_ecc_P2         ),
//.dfi1_wrdata_link_ecc_P2  ( dfi1_wrdata_link_ecc_P3         ),
//.dfi1_wrdata_link_ecc_P3  ( dfi1_wrdata_link_ecc_P4         ),
`else
.dfi1_wck_write_P0                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),   
.dfi1_wck_write_P1                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_write_P2                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_write_P3                      ( {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}}),
.dfi1_wck_en_P0                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_en_P1                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_en_P2                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_en_P3                         ( {`DWC_DDRPHY_DFI1_WCK_EN_WIDTH{1'b0}}),
.dfi1_wck_cs_P0                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),
.dfi1_wck_cs_P1                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),
.dfi1_wck_cs_P2                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),
.dfi1_wck_cs_P3                         ( {`DWC_DDRPHY_DFI1_WCK_CS_WIDTH{1'b0}}),

.dfi1_wck_toggle_P0                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi1_wck_toggle_P1                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi1_wck_toggle_P2                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),
.dfi1_wck_toggle_P3                     ( {`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH{1'b0}}),

.dfi1_wrdata_link_ecc_P0                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P1                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P2                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
.dfi1_wrdata_link_ecc_P3                ( {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} ),
`endif
`endif

.dfi1_ctrlupd_ack		   	( dfi1_ctrlupd_ack                ),
.dfi1_ctrlupd_req		   	( {`DWC_DDRPHY_DFI1_CTRLUPD_REQ_WIDTH{1'b0}} ),
`ifndef PUB_VERSION_LE_0200 //RID < 0200
.dfi1_ctrlupd_type	( 2'b00 ),
`endif


.dfi1_dram_clk_disable_P0	( dis_upf_xprop ? dfi1_dram_clk_disable_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi1_dram_clk_disable_P0 ) ),	
.dfi1_dram_clk_disable_P1	( dis_upf_xprop ? dfi1_dram_clk_disable_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi1_dram_clk_disable_P1 ) ),
.dfi1_dram_clk_disable_P2	( dis_upf_xprop ? dfi1_dram_clk_disable_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi1_dram_clk_disable_P2 ) ),	
.dfi1_dram_clk_disable_P3	( dis_upf_xprop ? dfi1_dram_clk_disable_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH{1'bx}} : dfi1_dram_clk_disable_P3 ) ),

.dfi1_error				      ( dfi1_error                      ),
.dfi1_error_info			   ( dfi1_error_info                 ),
.dfi1_frequency		      ( dis_upf_xprop ? dfi1_frequency  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_FREQUENCY_WIDTH{1'bx}} : dfi1_frequency   ) ),
.dfi1_freq_ratio			   ( dis_upf_xprop ? dfi1_freq_ratio  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_FREQ_RATIO_WIDTH{1'bx}} : dfi1_freq_ratio) ),
.dfi1_init_complete			( dfi1_init_complete              ),		
.dfi1_init_start			   ( dis_upf_xprop ? dfi1_init_start  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_INIT_START_WIDTH{1'bx}} : dfi1_init_start) ),
//.dfi1_phy_info_ack       ( dfi1_phy_info_ack               ),
//.dfi1_phy_info_req       ( dfi1_phy_info_req               ),
//.dfi1_phy_info_cmd       ( dfi1_phy_info_cmd               ),
//.dfi1_phy_info_data      ( dfi1_phy_info_data              ),
.dfi1_lp_ctrl_ack	         ( dfi1_lp_ctrl_ack                ),
.dfi1_lp_data_ack          ( dfi1_lp_data_ack                ),
.dfi1_lp_ctrl_req			   ( dis_upf_xprop ? dfi1_lp_ctrl_req : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_LP_CTRL_REQ_WIDTH{1'bx}} : dfi1_lp_ctrl_req)                 ),
.dfi1_lp_data_req			   ( dis_upf_xprop ? dfi1_lp_data_req : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_LP_DATA_REQ_WIDTH{1'bx}} : dfi1_lp_data_req )                ),
.dfi1_freq_fsp             ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_FREQ_FSP_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_FREQ_FSP_WIDTH{1'bx}} :{`DWC_DDRPHY_DFI1_FREQ_FSP_WIDTH{1'b0}})            ),
.dfi1_lp_ctrl_wakeup       ( dis_upf_xprop ? dfi1_lp_ctrl_wakeup  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_LP_CTRL_WAKEUP_WIDTH{1'bx}} : dfi1_lp_ctrl_wakeup  )                                          ),
.dfi1_lp_data_wakeup       ( dis_upf_xprop ? dfi1_lp_data_wakeup  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_LP_DATA_ACK_WIDTH{1'bx}} : dfi1_lp_data_wakeup  )                                             ),
.dfi1_phymstr_ack			   ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_PHYMSTR_ACK_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_PHYMSTR_ACK_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_PHYMSTR_ACK_WIDTH{1'b0}} ) ),		
.dfi1_phymstr_cs_state	   ( dfi1_phymstr_cs_state           ),		
.dfi1_phymstr_req			   ( dfi1_phymstr_req                ),	
.dfi1_phymstr_state_sel	   ( dfi1_phymstr_state_sel          ),		
.dfi1_phymstr_type			( dfi1_phymstr_type               ),
.dfi1_phyupd_ack			   ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_PHYUPD_ACK_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_PHYUPD_ACK_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_PHYUPD_ACK_WIDTH{1'b0}} )    ),		
.dfi1_phyupd_req			   ( dfi1_phyupd_req                 ),		
.dfi1_phyupd_type			   ( dfi1_phyupd_type                ),
.dfi1_rddata_W0            ( dfi1_rddata_W0                  ),
.dfi1_rddata_W1            ( dfi1_rddata_W1                  ),
.dfi1_rddata_W2            ( dfi1_rddata_W2                  ),
.dfi1_rddata_W3            ( dfi1_rddata_W3                  ),
.dfi1_rddata_cs_P0			( dis_upf_xprop ? dfi1_rddata_cs_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH{1'bx}} : dfi1_rddata_cs_P0) ),
.dfi1_rddata_cs_P1			( dis_upf_xprop ? dfi1_rddata_cs_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH{1'bx}} : dfi1_rddata_cs_P1) ),
.dfi1_rddata_cs_P2			( dis_upf_xprop ? dfi1_rddata_cs_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH{1'bx}} : dfi1_rddata_cs_P2) ),
.dfi1_rddata_cs_P3			( dis_upf_xprop ? dfi1_rddata_cs_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH{1'bx}} : dfi1_rddata_cs_P3) ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi1_rddata_dbi_W0			( dfi1_rddata_dbi_W0 ),
.dfi1_rddata_dbi_W1			( dfi1_rddata_dbi_W1 ),
.dfi1_rddata_dbi_W2			( dfi1_rddata_dbi_W2 ),
.dfi1_rddata_dbi_W3			( dfi1_rddata_dbi_W3 ),
`endif
.dfi1_rddata_en_P0			( dis_upf_xprop ? dfi1_rddata_en_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH{1'bx}} : dfi1_rddata_en_P0) ),   
.dfi1_rddata_en_P1			( dis_upf_xprop ? dfi1_rddata_en_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH{1'bx}} : dfi1_rddata_en_P1) ),   
.dfi1_rddata_en_P2			( dis_upf_xprop ? dfi1_rddata_en_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH{1'bx}} : dfi1_rddata_en_P2) ),   
.dfi1_rddata_en_P3			( dis_upf_xprop ? dfi1_rddata_en_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH{1'bx}} : dfi1_rddata_en_P3) ),   
.dfi1_rddata_valid_W0		( dfi1_rddata_valid_W0 ),   
.dfi1_rddata_valid_W1		( dfi1_rddata_valid_W1 ),   
.dfi1_rddata_valid_W2		( dfi1_rddata_valid_W2 ),   
.dfi1_rddata_valid_W3		( dfi1_rddata_valid_W3 ),   
.dfi1_wrdata_P0			   ( dis_upf_xprop ? dfi1_wrdata_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_WIDTH{1'bx}} : dfi1_wrdata_P0)                ),
.dfi1_wrdata_P1			   ( dis_upf_xprop ? dfi1_wrdata_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_WIDTH{1'bx}} : dfi1_wrdata_P1)                ),
.dfi1_wrdata_P2			   ( dis_upf_xprop ? dfi1_wrdata_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_WIDTH{1'bx}} : dfi1_wrdata_P2)                ),
.dfi1_wrdata_P3			   ( dis_upf_xprop ? dfi1_wrdata_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_WIDTH{1'bx}} : dfi1_wrdata_P3)                ),
.dfi1_wrdata_cs_P0			( dis_upf_xprop ? dfi1_wrdata_cs_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH{1'bx}} : dfi1_wrdata_cs_P0)       ),
.dfi1_wrdata_cs_P1			( dis_upf_xprop ? dfi1_wrdata_cs_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH{1'bx}} : dfi1_wrdata_cs_P1)       ),
.dfi1_wrdata_cs_P2			( dis_upf_xprop ? dfi1_wrdata_cs_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH{1'bx}} : dfi1_wrdata_cs_P2)       ),
.dfi1_wrdata_cs_P3			( dis_upf_xprop ? dfi1_wrdata_cs_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH{1'bx}} : dfi1_wrdata_cs_P3)       ),
.dfi1_wrdata_en_P0			( dis_upf_xprop ? dfi1_wrdata_en_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH{1'bx}} : dfi1_wrdata_en_P0)       ),
.dfi1_wrdata_en_P1			( dis_upf_xprop ? dfi1_wrdata_en_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH{1'bx}} : dfi1_wrdata_en_P1)       ),
.dfi1_wrdata_en_P2			( dis_upf_xprop ? dfi1_wrdata_en_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH{1'bx}} : dfi1_wrdata_en_P2)       ),
.dfi1_wrdata_en_P3			( dis_upf_xprop ? dfi1_wrdata_en_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH{1'bx}} : dfi1_wrdata_en_P3)       ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.dfi1_wrdata_mask_P0			( dis_upf_xprop ? dfi1_wrdata_mask_P0 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH{1'bx}} : dfi1_wrdata_mask_P0) ),
.dfi1_wrdata_mask_P1			( dis_upf_xprop ? dfi1_wrdata_mask_P1 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH{1'bx}} : dfi1_wrdata_mask_P1) ),
.dfi1_wrdata_mask_P2			( dis_upf_xprop ? dfi1_wrdata_mask_P2 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH{1'bx}} : dfi1_wrdata_mask_P2) ),
.dfi1_wrdata_mask_P3			( dis_upf_xprop ? dfi1_wrdata_mask_P3 : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH{1'bx}} : dfi1_wrdata_mask_P3) ),
`endif   
`endif

// ----------PHY Pin Interface  ------------------------------
//------------------------ SRAM interface for ICCM ---------
.iccm_data_dout            ( dis_upf_xprop ? iccm_data_dout : ((~dwc_PwrOkIn_XDriver ) ? {39{1'bx}} : iccm_data_dout) ),
.iccm_data_din             ( iccm_data_din                   ),
.iccm_data_addr            ( iccm_data_addr                  ),
.iccm_data_ce              ( iccm_data_ce                    ),
.iccm_data_we              ( iccm_data_we                    ),

//------------------------ SRAM interface for DCCM ---------
.dccm_data_dout            ( dis_upf_xprop ? dccm_data_dout : ((~dwc_PwrOkIn_XDriver ) ? {39{1'bx}} : dccm_data_dout) ),
.dccm_data_din             ( dccm_data_din                   ),
.dccm_data_addr            ( dccm_data_addr                  ),
.dccm_data_ce              ( dccm_data_ce                    ),
.dccm_data_we              ( dccm_data_we                    ),
// SRAM interface CLK //////////////////////////////////////////////////////////
//.pmu_sram_clken                         ( pmu_sram_clken                  ),

//------------------------ Interface to External ACSM Memory ---------
.acsm_data_dout            ( dis_upf_xprop ? acsm_data_dout : ((~dwc_PwrOkIn_XDriver ) ? {72{1'bx}} : acsm_data_dout) ),
.acsm_data_din             ( acsm_data_din                   ),
.acsm_data_addr            ( acsm_data_addr                  ),
.acsm_data_ce              ( acsm_data_ce                    ),
.acsm_data_we              ( acsm_data_we                    ),

//.RxBypassDataSel         ( 2'h0 ),

//.VDD					         ( vdd                             ),
//.VDDQ                      ( vddq                            ), 
//.VSS					         ( 1'b0                            ),
//.VDD2H					      ( vaa                             ),
//.VAA_VDD2H			         ( vaa                             ),

//.BP_RET                                 ( BP_RET                          ),
.BP_MEMRESET_L                          ( BP_MEMRESET_L                   ),
.BP_DTO                                 ( BP_DTO                          ),
.BP_ATO                                 ( BP_ATO                          ),
.BP_ZN                                  ( BP_ZN                           ),

.BP_DFI0_CA                             ( BP_DFI0_CA                      ),
.BP_DFI0_LP4CKE_LP5CS                   ( BP_DFI0_LP4CKE_LP5CS            ),
.BP_DFI0_CK_T                           ( BP_DFI0_CK_T                    ),
.BP_DFI0_CK_C                           ( BP_DFI0_CK_C                    ),
.BP_DFI0_B0_D                           ( BP_DFI0_B0_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B0_DMI                         ( BP_DFI0_B0_DMI                  ),
`endif
.BP_DFI0_B0_DQS_T                       ( BP_DFI0_B0_DQS_T                ),
.BP_DFI0_B0_DQS_C                       ( BP_DFI0_B0_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B0_WCK_T                       ( BP_DFI0_B0_WCK_T                ),
.BP_DFI0_B0_WCK_C                       ( BP_DFI0_B0_WCK_C                ),
`endif
.BP_DFI0_B1_D                           ( BP_DFI0_B1_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B1_DMI                         ( BP_DFI0_B1_DMI                  ),
`endif
.BP_DFI0_B1_DQS_T                       ( BP_DFI0_B1_DQS_T                ),
.BP_DFI0_B1_DQS_C                       ( BP_DFI0_B1_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B1_WCK_T                       ( BP_DFI0_B1_WCK_T                ),
.BP_DFI0_B1_WCK_C                       ( BP_DFI0_B1_WCK_C                ),
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
.BP_DFI0_B2_D                           ( BP_DFI0_B2_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B2_DMI                         ( BP_DFI0_B2_DMI                  ),
`endif
.BP_DFI0_B2_DQS_T                       ( BP_DFI0_B2_DQS_T                ),
.BP_DFI0_B2_DQS_C                       ( BP_DFI0_B2_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B2_WCK_T                       ( BP_DFI0_B2_WCK_T                ),
.BP_DFI0_B2_WCK_C                       ( BP_DFI0_B2_WCK_C                ),
`endif
.BP_DFI0_B3_D                           ( BP_DFI0_B3_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI0_B3_DMI                         ( BP_DFI0_B3_DMI                  ),
`endif
.BP_DFI0_B3_DQS_T                       ( BP_DFI0_B3_DQS_T                ),
.BP_DFI0_B3_DQS_C                       ( BP_DFI0_B3_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI0_B3_WCK_T                       ( BP_DFI0_B3_WCK_T                ),
.BP_DFI0_B3_WCK_C                       ( BP_DFI0_B3_WCK_C                ),
`endif
`endif

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.BP_DFI1_CA                             ( BP_DFI1_CA                      ),
.BP_DFI1_LP4CKE_LP5CS                   ( BP_DFI1_LP4CKE_LP5CS            ),
.BP_DFI1_CK_T                           ( BP_DFI1_CK_T                    ),
.BP_DFI1_CK_C                           ( BP_DFI1_CK_C                    ),
.BP_DFI1_B0_D                           ( BP_DFI1_B0_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B0_DMI                         ( BP_DFI1_B0_DMI                  ),
`endif
.BP_DFI1_B0_DQS_T                       ( BP_DFI1_B0_DQS_T                ),
.BP_DFI1_B0_DQS_C                       ( BP_DFI1_B0_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B0_WCK_T                       ( BP_DFI1_B0_WCK_T                ),
.BP_DFI1_B0_WCK_C                       ( BP_DFI1_B0_WCK_C                ),
`endif
.BP_DFI1_B1_D                           ( BP_DFI1_B1_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B1_DMI                         ( BP_DFI1_B1_DMI                  ),
`endif
.BP_DFI1_B1_DQS_T                       ( BP_DFI1_B1_DQS_T                ),
.BP_DFI1_B1_DQS_C                       ( BP_DFI1_B1_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B1_WCK_T                       ( BP_DFI1_B1_WCK_T                ),
.BP_DFI1_B1_WCK_C                       ( BP_DFI1_B1_WCK_C                ),
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
.BP_DFI1_B2_D                           ( BP_DFI1_B2_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B2_DMI                         ( BP_DFI1_B2_DMI                  ),
`endif
.BP_DFI1_B2_DQS_T                       ( BP_DFI1_B2_DQS_T                ),
.BP_DFI1_B2_DQS_C                       ( BP_DFI1_B2_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B2_WCK_T                       ( BP_DFI1_B2_WCK_T                ),
.BP_DFI1_B2_WCK_C                       ( BP_DFI1_B2_WCK_C                ),
`endif
.BP_DFI1_B3_D                           ( BP_DFI1_B3_D                    ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.BP_DFI1_B3_DMI                         ( BP_DFI1_B3_DMI                  ),
`endif
.BP_DFI1_B3_DQS_T                       ( BP_DFI1_B3_DQS_T                ),
.BP_DFI1_B3_DQS_C                       ( BP_DFI1_B3_DQS_C                ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.BP_DFI1_B3_WCK_T                       ( BP_DFI1_B3_WCK_T                ),
.BP_DFI1_B3_WCK_C                       ( BP_DFI1_B3_WCK_C                ),
`endif
`endif
`endif
//------------------------ APB IF ---------------------------------

.APBCLK						               ( dis_upf_xprop ? apb_clk : ((~dwc_PwrOkIn_XDriver ) ?  1'bx      : apb_clk  ) ),                       
.PADDR_APB					             	( dis_upf_xprop ? paddr   : ((~dwc_PwrOkIn_XDriver ) ? {32{1'bx}} : paddr    ) ),
.PWRITE_APB					             	( dis_upf_xprop ? pwrite  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx       : pwrite   ) ),
.PRESETn_APB				             	( dis_upf_xprop ? presetn : ((~dwc_PwrOkIn_XDriver ) ? 1'bx       : presetn  ) ),
.PSELx_APB					             	( dis_upf_xprop ? psel    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx       : psel     ) ),
.PENABLE_APB				             	( dis_upf_xprop ? penable : ((~dwc_PwrOkIn_XDriver ) ? 1'bx       : penable  ) ),
.PWDATA_APB					             	( dis_upf_xprop ? pwdata  : ((~dwc_PwrOkIn_XDriver ) ? {16{1'bx}} : pwdata   ) ),
.PSTRB_APB					             	( dis_upf_xprop ? 2'b0    : ((~dwc_PwrOkIn_XDriver ) ? {2{1'bx}}  : 2'b0     ) ),

.PPROT_APB					             	( dis_upf_xprop ? 3'b10   : ((~dwc_PwrOkIn_XDriver ) ? {3{1'bx}}  : 3'b10    ) ),

.PREADY_APB					             	( pready ),
.PRDATA_APB					             	( prdata ),
.PSLVERR_APB				             	( pslverr),
                                          
.PPROT_PIN					             	( dis_upf_xprop ? 3'b010 : ((~dwc_PwrOkIn_XDriver ) ? {3{1'bx}} : 3'b010 ) ),
   
////------------------------ Bypass interface ------------------
`ifdef FLYOVER_TEST
  .RxTestClk                                 ( dis_upf_xprop ? RxTestClk  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxTestClk )),
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI0_B0_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI0_B0_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI0_B0_D}} ) ), 
  .RxBypassRcvEn_DFI0_B1_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI0_B1_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI0_B1_D}} ) ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI0_B2_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI0_B2_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI0_B2_D}} ) ),
  .RxBypassRcvEn_DFI0_B3_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI0_B3_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI0_B3_D}} ) ),
`endif                                                                         
  .RxBypassData_DFI0_B0_D0                   ( RxBypassData_DFI0_B0_D0            ), //4bit
  .RxBypassData_DFI0_B0_D1                   ( RxBypassData_DFI0_B0_D1            ), //4bit
  .RxBypassData_DFI0_B0_D2                   ( RxBypassData_DFI0_B0_D2            ), //4bit
  .RxBypassData_DFI0_B0_D3                   ( RxBypassData_DFI0_B0_D3            ), //4bit
  .RxBypassData_DFI0_B0_D4                   ( RxBypassData_DFI0_B0_D4            ), //4bit
  .RxBypassData_DFI0_B0_D5                   ( RxBypassData_DFI0_B0_D5            ), //4bit
  .RxBypassData_DFI0_B0_D6                   ( RxBypassData_DFI0_B0_D6            ), //4bit
  .RxBypassData_DFI0_B0_D7                   ( RxBypassData_DFI0_B0_D7            ), //4bit
  .RxBypassData_DFI0_B1_D0                   ( RxBypassData_DFI0_B1_D0            ), //4bit
  .RxBypassData_DFI0_B1_D1                   ( RxBypassData_DFI0_B1_D1            ), //4bit
  .RxBypassData_DFI0_B1_D2                   ( RxBypassData_DFI0_B1_D2            ), //4bit
  .RxBypassData_DFI0_B1_D3                   ( RxBypassData_DFI0_B1_D3            ), //4bit
  .RxBypassData_DFI0_B1_D4                   ( RxBypassData_DFI0_B1_D4            ), //4bit
  .RxBypassData_DFI0_B1_D5                   ( RxBypassData_DFI0_B1_D5            ), //4bit
  .RxBypassData_DFI0_B1_D6                   ( RxBypassData_DFI0_B1_D6            ), //4bit
  .RxBypassData_DFI0_B1_D7                   ( RxBypassData_DFI0_B1_D7            ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassData_DFI0_B2_D0                   ( RxBypassData_DFI0_B2_D0            ), //4bit
  .RxBypassData_DFI0_B2_D1                   ( RxBypassData_DFI0_B2_D1            ), //4bit
  .RxBypassData_DFI0_B2_D2                   ( RxBypassData_DFI0_B2_D2            ), //4bit
  .RxBypassData_DFI0_B2_D3                   ( RxBypassData_DFI0_B2_D3            ), //4bit
  .RxBypassData_DFI0_B2_D4                   ( RxBypassData_DFI0_B2_D4            ), //4bit
  .RxBypassData_DFI0_B2_D5                   ( RxBypassData_DFI0_B2_D5            ), //4bit
  .RxBypassData_DFI0_B2_D6                   ( RxBypassData_DFI0_B2_D6            ), //4bit
  .RxBypassData_DFI0_B2_D7                   ( RxBypassData_DFI0_B2_D7            ), //4bit
  .RxBypassData_DFI0_B3_D0                   ( RxBypassData_DFI0_B3_D0            ), //4bit
  .RxBypassData_DFI0_B3_D1                   ( RxBypassData_DFI0_B3_D1            ), //4bit
  .RxBypassData_DFI0_B3_D2                   ( RxBypassData_DFI0_B3_D2            ), //4bit
  .RxBypassData_DFI0_B3_D3                   ( RxBypassData_DFI0_B3_D3            ), //4bit
  .RxBypassData_DFI0_B3_D4                   ( RxBypassData_DFI0_B3_D4            ), //4bit
  .RxBypassData_DFI0_B3_D5                   ( RxBypassData_DFI0_B3_D5            ), //4bit
  .RxBypassData_DFI0_B3_D6                   ( RxBypassData_DFI0_B3_D6            ), //4bit
  .RxBypassData_DFI0_B3_D7                   ( RxBypassData_DFI0_B3_D7            ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI0_B0_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI0_B0_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI0_B0_D}} ) ),
  .RxBypassPadEn_DFI0_B1_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI0_B1_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI0_B1_D}} ) ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI0_B2_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI0_B2_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI0_B2_D}} ) ),
  .RxBypassPadEn_DFI0_B3_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI0_B3_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI0_B3_D}} ) ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_D                 ( RxBypassDataPad_DFI0_B0_D          ),
  .RxBypassDataPad_DFI0_B1_D                 ( RxBypassDataPad_DFI0_B1_D          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassDataPad_DFI0_B2_D                 ( RxBypassDataPad_DFI0_B2_D          ),
  .RxBypassDataPad_DFI0_B3_D                 ( RxBypassDataPad_DFI0_B3_D          ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI0_B0_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI0_B0_D}} )   ),
  .TxBypassMode_DFI0_B1_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI0_B1_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI0_B1_D}} )   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                      
  .TxBypassMode_DFI0_B2_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI0_B2_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI0_B2_D}} )   ),
  .TxBypassMode_DFI0_B3_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI0_B3_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI0_B3_D}} )   ),
`endif                                                                                                                                                          
  .TxBypassOE_DFI0_B0_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI0_B0_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI0_B0_D  }} )   ),
  .TxBypassOE_DFI0_B1_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI0_B1_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI0_B1_D  }} )   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                      
  .TxBypassOE_DFI0_B2_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI0_B2_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI0_B2_D  }} )   ),
  .TxBypassOE_DFI0_B3_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI0_B3_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI0_B3_D  }} )   ),
`endif                                                               
  .TxBypassData_DFI0_B0_D                    ( dis_upf_xprop ? TxBypassData_DFI0_B0_D   : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI0_B0_D  ) ),
  .TxBypassData_DFI0_B1_D                    ( dis_upf_xprop ? TxBypassData_DFI0_B1_D   : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI0_B1_D  ) ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                              
  .TxBypassData_DFI0_B2_D                    ( dis_upf_xprop ? TxBypassData_DFI0_B2_D   : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI0_B2_D  ) ),
  .TxBypassData_DFI0_B3_D                    ( dis_upf_xprop ? TxBypassData_DFI0_B3_D   : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI0_B3_D  ) ),
`endif                                                                           
                                                                                 
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                              
  .RxBypassRcvEn_DFI0_B0_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B0_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B0_DMI )  ),
  .RxBypassRcvEn_DFI0_B1_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B1_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B1_DMI )  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                 
  .RxBypassRcvEn_DFI0_B2_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B2_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B2_DMI )  ),
  .RxBypassRcvEn_DFI0_B3_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B3_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B3_DMI )  ),
`endif                                                                         
  .RxBypassPadEn_DFI0_B0_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B0_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B0_DMI ) ),
  .RxBypassPadEn_DFI0_B1_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B1_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B1_DMI ) ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                
  .RxBypassPadEn_DFI0_B2_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B2_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B2_DMI ) ),
  .RxBypassPadEn_DFI0_B3_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B3_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B3_DMI ) ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_DMI               ( RxBypassDataPad_DFI0_B0_DMI        ),
  .RxBypassDataPad_DFI0_B1_DMI               ( RxBypassDataPad_DFI0_B1_DMI        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassDataPad_DFI0_B2_DMI               ( RxBypassDataPad_DFI0_B2_DMI        ),
  .RxBypassDataPad_DFI0_B3_DMI               ( RxBypassDataPad_DFI0_B3_DMI        ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI0_B0_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B0_DMI ) ),
  .TxBypassMode_DFI0_B1_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI0_B1_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B1_DMI ) ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                             
  .TxBypassMode_DFI0_B2_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI0_B2_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B2_DMI ) ),
  .TxBypassMode_DFI0_B3_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI0_B3_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B3_DMI ) ),
`endif                                                                 
  .TxBypassOE_DFI0_B0_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI0_B0_DMI   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B0_DMI  )   ),
  .TxBypassOE_DFI0_B1_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI0_B1_DMI   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B1_DMI  )   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                           
  .TxBypassOE_DFI0_B2_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI0_B2_DMI   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B2_DMI  )   ),
  .TxBypassOE_DFI0_B3_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI0_B3_DMI   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B3_DMI  )   ),
`endif                                                               
  .TxBypassData_DFI0_B0_DMI                  ( dis_upf_xprop ? TxBypassData_DFI0_B0_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B0_DMI ) ),
  .TxBypassData_DFI0_B1_DMI                  ( dis_upf_xprop ? TxBypassData_DFI0_B1_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B1_DMI ) ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                             
  .TxBypassData_DFI0_B2_DMI                  ( dis_upf_xprop ? TxBypassData_DFI0_B2_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B2_DMI ) ),
  .TxBypassData_DFI0_B3_DMI                  ( dis_upf_xprop ? TxBypassData_DFI0_B3_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B3_DMI ) ),
`endif                                                                           
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                         
                                                                                
  .RxBypassRcvEn_DFI0_CA                     ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{RxBypassRcvEn_DFI0_CA}}  : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{RxBypassRcvEn_DFI0_CA}} ) ),
  .RxBypassData_DFI0_CA0                     ( RxBypassData_DFI0_CA0              ),   //4bit
  .RxBypassData_DFI0_CA1                     ( RxBypassData_DFI0_CA1              ),   //4bit
  .RxBypassData_DFI0_CA2                     ( RxBypassData_DFI0_CA2              ),   //4bit
  .RxBypassData_DFI0_CA3                     ( RxBypassData_DFI0_CA3              ),   //4bit
  .RxBypassData_DFI0_CA4                     ( RxBypassData_DFI0_CA4              ),   //4bit
  .RxBypassData_DFI0_CA5                     ( RxBypassData_DFI0_CA5              ),   //4bit
  .RxBypassData_DFI0_CA6                     ( RxBypassData_DFI0_CA6              ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                                                     
  .RxBypassData_DFI0_CA7                     ( RxBypassData_DFI0_CA7              ),   //4bit
`endif                                                                          
  .RxBypassPadEn_DFI0_CA                     ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{RxBypassPadEn_DFI0_CA}}  : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{RxBypassPadEn_DFI0_CA}} )),
  .RxBypassDataPad_DFI0_CA                   ( RxBypassDataPad_DFI0_CA            ),
  .TxBypassMode_DFI0_CA                      ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{TxBypassMode_DFI0_CA}} : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{TxBypassMode_DFI0_CA}} ) ),
  .TxBypassOE_DFI0_CA                        ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{TxBypassOE_DFI0_CA  }} : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'1'bx : {`DWC_DDRPHY_NUM_RANKS+6{TxBypassOE_DFI0_CA  }} )),
  .TxBypassData_DFI0_CA                      ( dis_upf_xprop ? TxBypassData_DFI0_CA                            : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_CA                            )),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI0_B0_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B0_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B0_DQS )        ),
  .RxBypassRcvEn_DFI0_B1_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B1_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B1_DQS )        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                       
  .RxBypassRcvEn_DFI0_B2_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B2_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B2_DQS )        ),
  .RxBypassRcvEn_DFI0_B3_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B3_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B3_DQS )        ),
`endif                                                                          
  .RxBypassDataRcv_DFI0_B0_DQS_T             ( RxBypassDataRcv_DFI0_B0_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B0_DQS_C             ( RxBypassDataRcv_DFI0_B0_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_T             ( RxBypassDataRcv_DFI0_B1_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_C             ( RxBypassDataRcv_DFI0_B1_DQS_C      ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassDataRcv_DFI0_B2_DQS_T             ( RxBypassDataRcv_DFI0_B2_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B2_DQS_C             ( RxBypassDataRcv_DFI0_B2_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_T             ( RxBypassDataRcv_DFI0_B3_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_C             ( RxBypassDataRcv_DFI0_B3_DQS_C      ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI0_B0_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B0_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B0_DQS )        ),
  .RxBypassPadEn_DFI0_B1_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B1_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B1_DQS )        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                   
  .RxBypassPadEn_DFI0_B2_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B2_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B2_DQS )        ),
  .RxBypassPadEn_DFI0_B3_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI0_B3_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_B3_DQS )        ),
`endif                                                                      
  .RxBypassDataPad_DFI0_B0_DQS_T             ( RxBypassDataPad_DFI0_B0_DQS_T      ),
  .RxBypassDataPad_DFI0_B0_DQS_C             ( RxBypassDataPad_DFI0_B0_DQS_C      ),
  .RxBypassDataPad_DFI0_B1_DQS_T             ( RxBypassDataPad_DFI0_B1_DQS_T      ),
  .RxBypassDataPad_DFI0_B1_DQS_C             ( RxBypassDataPad_DFI0_B1_DQS_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataPad_DFI0_B2_DQS_T             ( RxBypassDataPad_DFI0_B2_DQS_T      ),
  .RxBypassDataPad_DFI0_B2_DQS_C             ( RxBypassDataPad_DFI0_B2_DQS_C      ),
  .RxBypassDataPad_DFI0_B3_DQS_T             ( RxBypassDataPad_DFI0_B3_DQS_T      ),
  .RxBypassDataPad_DFI0_B3_DQS_C             ( RxBypassDataPad_DFI0_B3_DQS_C      ),
`endif                                                                           
  .TxBypassMode_DFI0_B0_DQS                  ( TxBypassMode_DFI0_B0_DQS           ),
  .TxBypassMode_DFI0_B1_DQS                  ( TxBypassMode_DFI0_B1_DQS           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                        
  .TxBypassMode_DFI0_B2_DQS                  ( TxBypassMode_DFI0_B2_DQS           ),
  .TxBypassMode_DFI0_B3_DQS                  ( TxBypassMode_DFI0_B3_DQS           ),
`endif                                                                           
  .TxBypassOE_DFI0_B0_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B0_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B0_DQS_T  )        ),
  .TxBypassOE_DFI0_B0_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B0_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B0_DQS_C  )        ),
  .TxBypassOE_DFI0_B1_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B1_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B1_DQS_T  )        ),
  .TxBypassOE_DFI0_B1_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B1_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B1_DQS_C  )        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                              
  .TxBypassOE_DFI0_B2_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B2_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B2_DQS_T  )        ),
  .TxBypassOE_DFI0_B2_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B2_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B2_DQS_C  )        ),
  .TxBypassOE_DFI0_B3_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B3_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B3_DQS_T  )        ),
  .TxBypassOE_DFI0_B3_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B3_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B3_DQS_C  )        ),
`endif                                                                                                                                                  
  .TxBypassData_DFI0_B0_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI0_B0_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B0_DQS_T)      ),
  .TxBypassData_DFI0_B0_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI0_B0_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B0_DQS_C)      ),
  .TxBypassData_DFI0_B1_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI0_B1_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B1_DQS_T)      ),
  .TxBypassData_DFI0_B1_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI0_B1_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B1_DQS_C)      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                   
  .TxBypassData_DFI0_B2_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI0_B2_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B2_DQS_T)      ),
  .TxBypassData_DFI0_B2_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI0_B2_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B2_DQS_C)      ),
  .TxBypassData_DFI0_B3_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI0_B3_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B3_DQS_T)      ),
  .TxBypassData_DFI0_B3_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI0_B3_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B3_DQS_C)      ),
`endif                                                                        
                                                                                
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                                 
  .RxBypassRcvEn_DFI0_B0_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B0_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B0_WCK )       ),
  .RxBypassRcvEn_DFI0_B1_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B1_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B1_WCK )       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                      
  .RxBypassRcvEn_DFI0_B2_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B2_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B2_WCK )       ),
  .RxBypassRcvEn_DFI0_B3_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI0_B3_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_B3_WCK )       ),
`endif                                                                           
  .RxBypassDataRcv_DFI0_B0_WCK_T             ( RxBypassDataRcv_DFI0_B0_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B0_WCK_C             ( RxBypassDataRcv_DFI0_B0_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_T             ( RxBypassDataRcv_DFI0_B1_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_C             ( RxBypassDataRcv_DFI0_B1_WCK_C      ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                        
  .RxBypassDataRcv_DFI0_B2_WCK_T             ( RxBypassDataRcv_DFI0_B2_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B2_WCK_C             ( RxBypassDataRcv_DFI0_B2_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_T             ( RxBypassDataRcv_DFI0_B3_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_C             ( RxBypassDataRcv_DFI0_B3_WCK_C      ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI0_B0_WCK                 ( dis_upf_xprop ? TxBypassMode_DFI0_B0_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B0_WCK )       ),
  .RxBypassPadEn_DFI0_B1_WCK                 ( dis_upf_xprop ? TxBypassMode_DFI0_B1_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B1_WCK )       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                    
  .RxBypassPadEn_DFI0_B2_WCK                 ( dis_upf_xprop ? TxBypassMode_DFI0_B2_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B2_WCK )       ),
  .RxBypassPadEn_DFI0_B3_WCK                 ( dis_upf_xprop ? TxBypassMode_DFI0_B3_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B3_WCK )       ),
`endif                                                                           
  .RxBypassDataPad_DFI0_B0_WCK_T             ( RxBypassDataPad_DFI0_B0_WCK_T      ),
  .RxBypassDataPad_DFI0_B0_WCK_C             ( RxBypassDataPad_DFI0_B0_WCK_C      ),
  .RxBypassDataPad_DFI0_B1_WCK_T             ( RxBypassDataPad_DFI0_B1_WCK_T      ),
  .RxBypassDataPad_DFI0_B1_WCK_C             ( RxBypassDataPad_DFI0_B1_WCK_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassDataPad_DFI0_B2_WCK_T             ( RxBypassDataPad_DFI0_B2_WCK_T      ),
  .RxBypassDataPad_DFI0_B2_WCK_C             ( RxBypassDataPad_DFI0_B2_WCK_C      ),
  .RxBypassDataPad_DFI0_B3_WCK_T             ( RxBypassDataPad_DFI0_B3_WCK_T      ),
  .RxBypassDataPad_DFI0_B3_WCK_C             ( RxBypassDataPad_DFI0_B3_WCK_C      ),
`endif                                                                           
  .TxBypassMode_DFI0_B0_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI0_B0_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B0_WCK )        ),
  .TxBypassMode_DFI0_B1_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI0_B1_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B1_WCK )        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                     
  .TxBypassMode_DFI0_B2_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI0_B2_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B2_WCK )        ),
  .TxBypassMode_DFI0_B3_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI0_B3_WCK  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI0_B3_WCK )        ),
`endif                                                                          
  .TxBypassOE_DFI0_B0_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B0_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B0_WCK_T)        ),
  .TxBypassOE_DFI0_B0_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B0_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B0_WCK_C)        ),
  .TxBypassOE_DFI0_B1_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B1_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B1_WCK_T)        ),
  .TxBypassOE_DFI0_B1_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B1_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B1_WCK_C)        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                          
  .TxBypassOE_DFI0_B2_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B2_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B2_WCK_T)         ),
  .TxBypassOE_DFI0_B2_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B2_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B2_WCK_C)         ),
  .TxBypassOE_DFI0_B3_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI0_B3_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B3_WCK_T)         ),
  .TxBypassOE_DFI0_B3_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI0_B3_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_B3_WCK_C)         ),
`endif                                                                          
  .TxBypassData_DFI0_B0_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI0_B0_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B0_WCK_T)      ),
  .TxBypassData_DFI0_B0_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI0_B0_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B0_WCK_C)      ),
  .TxBypassData_DFI0_B1_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI0_B1_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B1_WCK_T)      ),
  .TxBypassData_DFI0_B1_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI0_B1_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B1_WCK_C)      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                              
  .TxBypassData_DFI0_B2_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI0_B2_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B2_WCK_T)      ),
  .TxBypassData_DFI0_B2_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI0_B2_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B2_WCK_C)      ),
  .TxBypassData_DFI0_B3_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI0_B3_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B3_WCK_T)      ),
  .TxBypassData_DFI0_B3_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI0_B3_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_B3_WCK_C)      ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI0_CK                     ( dis_upf_xprop ? RxBypassRcvEn_DFI0_CK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI0_CK)             ),
  .RxBypassDataRcv_DFI0_CK_T                 ( RxBypassDataRcv_DFI0_CK_T          ),
  .RxBypassDataRcv_DFI0_CK_C                 ( RxBypassDataRcv_DFI0_CK_C          ),
  .RxBypassPadEn_DFI0_CK                     ( dis_upf_xprop ? RxBypassPadEn_DFI0_CK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI0_CK)             ),
  .RxBypassDataPad_DFI0_CK_T                 ( RxBypassDataPad_DFI0_CK_T          ),
  .RxBypassDataPad_DFI0_CK_C                 ( RxBypassDataPad_DFI0_CK_C          ),
  .TxBypassMode_DFI0_CK                      ( TxBypassMode_DFI0_CK               ),
  .TxBypassOE_DFI0_CK_T                      ( dis_upf_xprop ? TxBypassOE_DFI0_CK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_CK_T)               ),
  .TxBypassOE_DFI0_CK_C                      ( dis_upf_xprop ? TxBypassOE_DFI0_CK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI0_CK_C)               ),
  .TxBypassData_DFI0_CK_T                    ( dis_upf_xprop ? TxBypassData_DFI0_CK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_CK_T)           ),
  .TxBypassData_DFI0_CK_C                    ( dis_upf_xprop ? TxBypassData_DFI0_CK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI0_CK_C)           ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI0_LP4CKE_LP5CS           ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS{RxBypassPadEn_DFI0_LP4CKE_LP5CS}} : ((~dwc_PwrOkIn_XDriver ) ?{`DWC_DDRPHY_NUM_RANKS{1'bx}} : {`DWC_DDRPHY_NUM_RANKS{RxBypassPadEn_DFI0_LP4CKE_LP5CS}})), 
  .RxBypassDataPad_DFI0_LP4CKE_LP5CS         ( RxBypassDataPad_DFI0_LP4CKE_LP5CS  ),                                                        
  .TxBypassMode_DFI0_LP4CKE_LP5CS            ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS{TxBypassMode_DFI0_LP4CKE_LP5CS}}  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS{1'bx}} : {`DWC_DDRPHY_NUM_RANKS{TxBypassMode_DFI0_LP4CKE_LP5CS}} )),
  .TxBypassOE_DFI0_LP4CKE_LP5CS              ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS{TxBypassOE_DFI0_LP4CKE_LP5CS  }}  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS{1'bx}} : {`DWC_DDRPHY_NUM_RANKS{TxBypassOE_DFI0_LP4CKE_LP5CS  }} )),
  .TxBypassData_DFI0_LP4CKE_LP5CS            ( dis_upf_xprop ? TxBypassData_DFI0_LP4CKE_LP5CS : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS{1'bx}} : TxBypassData_DFI0_LP4CKE_LP5CS )),
                                                                                 
  .TxBypassMode_MEMRESET_L                   ( dis_upf_xprop ? TxBypassMode_MEMRESET_L  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_MEMRESET_L )          ),
  .TxBypassData_MEMRESET_L                   ( dis_upf_xprop ? TxBypassData_MEMRESET_L  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_MEMRESET_L )          ),
                                                                                 
  .TxBypassMode_DTO                          ( dis_upf_xprop ? TxBypassMode_DTO : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DTO) ),
  .TxBypassOE_DTO                            ( dis_upf_xprop ? TxBypassOE_DTO   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DTO  ) ),
  .TxBypassData_DTO                          ( dis_upf_xprop ? TxBypassData_DTO : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DTO) ),
  .RxBypassEn_DTO                            ( dis_upf_xprop ? RxBypassEn_DTO   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassEn_DTO  ) ),
  .RxBypassDataPad_DTO                       ( RxBypassDataPad_DTO                ),

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI1_B0_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI1_B0_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI1_B0_D}} )     ), 
  .RxBypassRcvEn_DFI1_B1_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI1_B1_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI1_B1_D}} )     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                          
  .RxBypassRcvEn_DFI1_B2_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI1_B2_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI1_B2_D}} )     ),
  .RxBypassRcvEn_DFI1_B3_D                   ( dis_upf_xprop ? {8{RxBypassRcvEn_DFI1_B3_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassRcvEn_DFI1_B3_D}} )     ),
`endif                                                                         
  .RxBypassData_DFI1_B0_D0                   ( RxBypassData_DFI1_B0_D0            ), //4bit
  .RxBypassData_DFI1_B0_D1                   ( RxBypassData_DFI1_B0_D1            ), //4bit
  .RxBypassData_DFI1_B0_D2                   ( RxBypassData_DFI1_B0_D2            ), //4bit
  .RxBypassData_DFI1_B0_D3                   ( RxBypassData_DFI1_B0_D3            ), //4bit
  .RxBypassData_DFI1_B0_D4                   ( RxBypassData_DFI1_B0_D4            ), //4bit
  .RxBypassData_DFI1_B0_D5                   ( RxBypassData_DFI1_B0_D5            ), //4bit
  .RxBypassData_DFI1_B0_D6                   ( RxBypassData_DFI1_B0_D6            ), //4bit
  .RxBypassData_DFI1_B0_D7                   ( RxBypassData_DFI1_B0_D7            ), //4bit
  .RxBypassData_DFI1_B1_D0                   ( RxBypassData_DFI1_B1_D0            ), //4bit
  .RxBypassData_DFI1_B1_D1                   ( RxBypassData_DFI1_B1_D1            ), //4bit
  .RxBypassData_DFI1_B1_D2                   ( RxBypassData_DFI1_B1_D2            ), //4bit
  .RxBypassData_DFI1_B1_D3                   ( RxBypassData_DFI1_B1_D3            ), //4bit
  .RxBypassData_DFI1_B1_D4                   ( RxBypassData_DFI1_B1_D4            ), //4bit
  .RxBypassData_DFI1_B1_D5                   ( RxBypassData_DFI1_B1_D5            ), //4bit
  .RxBypassData_DFI1_B1_D6                   ( RxBypassData_DFI1_B1_D6            ), //4bit
  .RxBypassData_DFI1_B1_D7                   ( RxBypassData_DFI1_B1_D7            ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassData_DFI1_B2_D0                   ( RxBypassData_DFI1_B2_D0            ), //4bit
  .RxBypassData_DFI1_B2_D1                   ( RxBypassData_DFI1_B2_D1            ), //4bit
  .RxBypassData_DFI1_B2_D2                   ( RxBypassData_DFI1_B2_D2            ), //4bit
  .RxBypassData_DFI1_B2_D3                   ( RxBypassData_DFI1_B2_D3            ), //4bit
  .RxBypassData_DFI1_B2_D4                   ( RxBypassData_DFI1_B2_D4            ), //4bit
  .RxBypassData_DFI1_B2_D5                   ( RxBypassData_DFI1_B2_D5            ), //4bit
  .RxBypassData_DFI1_B2_D6                   ( RxBypassData_DFI1_B2_D6            ), //4bit
  .RxBypassData_DFI1_B2_D7                   ( RxBypassData_DFI1_B2_D7            ), //4bit
  .RxBypassData_DFI1_B3_D0                   ( RxBypassData_DFI1_B3_D0            ), //4bit
  .RxBypassData_DFI1_B3_D1                   ( RxBypassData_DFI1_B3_D1            ), //4bit
  .RxBypassData_DFI1_B3_D2                   ( RxBypassData_DFI1_B3_D2            ), //4bit
  .RxBypassData_DFI1_B3_D3                   ( RxBypassData_DFI1_B3_D3            ), //4bit
  .RxBypassData_DFI1_B3_D4                   ( RxBypassData_DFI1_B3_D4            ), //4bit
  .RxBypassData_DFI1_B3_D5                   ( RxBypassData_DFI1_B3_D5            ), //4bit
  .RxBypassData_DFI1_B3_D6                   ( RxBypassData_DFI1_B3_D6            ), //4bit
  .RxBypassData_DFI1_B3_D7                   ( RxBypassData_DFI1_B3_D7            ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI1_B0_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI1_B0_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI1_B0_D}} )     ),
  .RxBypassPadEn_DFI1_B1_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI1_B1_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI1_B1_D}} )     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                          
  .RxBypassPadEn_DFI1_B2_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI1_B2_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI1_B2_D}} )     ),
  .RxBypassPadEn_DFI1_B3_D                   ( dis_upf_xprop ? {8{RxBypassPadEn_DFI1_B3_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{RxBypassPadEn_DFI1_B3_D}} )     ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_D                 ( RxBypassDataPad_DFI1_B0_D          ),
  .RxBypassDataPad_DFI1_B1_D                 ( RxBypassDataPad_DFI1_B1_D          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassDataPad_DFI1_B2_D                 ( RxBypassDataPad_DFI1_B2_D          ),
  .RxBypassDataPad_DFI1_B3_D                 ( RxBypassDataPad_DFI1_B3_D          ),
`endif                                                                   
  .TxBypassMode_DFI1_B0_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI1_B0_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI1_B0_D}} )     ),
  .TxBypassMode_DFI1_B1_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI1_B1_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI1_B1_D}} )     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                      
  .TxBypassMode_DFI1_B2_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI1_B2_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI1_B2_D}} )     ),
  .TxBypassMode_DFI1_B3_D                    ( dis_upf_xprop ? {8{TxBypassMode_DFI1_B3_D}}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassMode_DFI1_B3_D}} )     ),
`endif                                                                                                                                                          
  .TxBypassOE_DFI1_B0_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI1_B0_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI1_B0_D  }} )     ),
  .TxBypassOE_DFI1_B1_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI1_B1_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI1_B1_D  }} )     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                      
  .TxBypassOE_DFI1_B2_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI1_B2_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI1_B2_D  }} )     ),
  .TxBypassOE_DFI1_B3_D                      ( dis_upf_xprop ? {8{TxBypassOE_DFI1_B3_D  }}  : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : {8{TxBypassOE_DFI1_B3_D  }} )     ),
`endif                                                                                                                                                          
  .TxBypassData_DFI1_B0_D                    ( dis_upf_xprop ? TxBypassData_DFI1_B0_D       : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI1_B0_D      )     ),
  .TxBypassData_DFI1_B1_D                    ( dis_upf_xprop ? TxBypassData_DFI1_B1_D       : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI1_B1_D      )     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                      
  .TxBypassData_DFI1_B2_D                    ( dis_upf_xprop ? TxBypassData_DFI1_B2_D       : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI1_B2_D      )     ),
  .TxBypassData_DFI1_B3_D                    ( dis_upf_xprop ? TxBypassData_DFI1_B3_D       : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : TxBypassData_DFI1_B3_D      )     ),
`endif                                                                                                                                                          
                                                                                                                                                                
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                             
  .RxBypassRcvEn_DFI1_B0_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B0_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : RxBypassRcvEn_DFI1_B0_DMI   )      ),
  .RxBypassRcvEn_DFI1_B1_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B1_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : RxBypassRcvEn_DFI1_B1_DMI   )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                             
  .RxBypassRcvEn_DFI1_B2_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B2_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : RxBypassRcvEn_DFI1_B2_DMI   )      ),
  .RxBypassRcvEn_DFI1_B3_DMI                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B3_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : RxBypassRcvEn_DFI1_B3_DMI   )      ),
`endif                                                                         
  .RxBypassData_DFI1_B0_DMI                  ( RxBypassData_DFI1_B0_DMI           ),   //4bit
  .RxBypassData_DFI1_B1_DMI                  ( RxBypassData_DFI1_B1_DMI           ),   //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassData_DFI1_B2_DMI                  ( RxBypassData_DFI1_B2_DMI           ),   //4bit
  .RxBypassData_DFI1_B3_DMI                  ( RxBypassData_DFI1_B3_DMI           ),   //4bit
`endif                                                                        
  .RxBypassPadEn_DFI1_B0_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B0_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B0_DMI )      ),
  .RxBypassPadEn_DFI1_B1_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B1_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B1_DMI )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                
  .RxBypassPadEn_DFI1_B2_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B2_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B2_DMI )      ),
  .RxBypassPadEn_DFI1_B3_DMI                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B3_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B3_DMI )      ),
`endif                                                                      
  .RxBypassDataPad_DFI1_B0_DMI               ( RxBypassDataPad_DFI1_B0_DMI        ),
  .RxBypassDataPad_DFI1_B1_DMI               ( RxBypassDataPad_DFI1_B1_DMI        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                 
  .RxBypassDataPad_DFI1_B2_DMI               ( RxBypassDataPad_DFI1_B2_DMI        ),
  .RxBypassDataPad_DFI1_B3_DMI               ( RxBypassDataPad_DFI1_B3_DMI        ),
`endif                                                                    
  .TxBypassMode_DFI1_B0_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI1_B0_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B0_DMI )     ),
  .TxBypassMode_DFI1_B1_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI1_B1_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B1_DMI )     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                             
  .TxBypassMode_DFI1_B2_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI1_B2_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B2_DMI )     ),
  .TxBypassMode_DFI1_B3_DMI                  ( dis_upf_xprop ? TxBypassMode_DFI1_B3_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B3_DMI )     ),
`endif                                                                                                                                               
  .TxBypassOE_DFI1_B0_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI1_B0_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B0_DMI  )      ),
  .TxBypassOE_DFI1_B1_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI1_B1_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B1_DMI  )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                            
  .TxBypassOE_DFI1_B2_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI1_B2_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B2_DMI  )      ),
  .TxBypassOE_DFI1_B3_DMI                    ( dis_upf_xprop ? TxBypassOE_DFI1_B3_DMI    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B3_DMI  )      ),
`endif                                                                                                                                               
  .TxBypassData_DFI1_B0_DMI                  ( dis_upf_xprop ?TxBypassData_DFI1_B0_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B0_DMI )      ),
  .TxBypassData_DFI1_B1_DMI                  ( dis_upf_xprop ?TxBypassData_DFI1_B1_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B1_DMI )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                            
  .TxBypassData_DFI1_B2_DMI                  ( dis_upf_xprop ?TxBypassData_DFI1_B2_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B2_DMI )      ),
  .TxBypassData_DFI1_B3_DMI                  ( dis_upf_xprop ?TxBypassData_DFI1_B3_DMI  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B3_DMI )      ),
`endif                                                                            
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                          
                                                                                 
  .RxBypassRcvEn_DFI1_CA                     ( dis_upf_xprop ?{`DWC_DDRPHY_NUM_RANKS+6{RxBypassRcvEn_DFI1_CA}}  : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{RxBypassRcvEn_DFI1_CA}} ) ),
  .RxBypassData_DFI1_CA0                     ( RxBypassData_DFI1_CA0              ),   //4bit
  .RxBypassData_DFI1_CA1                     ( RxBypassData_DFI1_CA1              ),   //4bit
  .RxBypassData_DFI1_CA2                     ( RxBypassData_DFI1_CA2              ),   //4bit
  .RxBypassData_DFI1_CA3                     ( RxBypassData_DFI1_CA3              ),   //4bit
  .RxBypassData_DFI1_CA4                     ( RxBypassData_DFI1_CA4              ),   //4bit
  .RxBypassData_DFI1_CA5                     ( RxBypassData_DFI1_CA5              ),   //4bit
  .RxBypassData_DFI1_CA6                     ( RxBypassData_DFI1_CA6              ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                                                     
  .RxBypassData_DFI1_CA7                     ( RxBypassData_DFI1_CA7              ),   //4bit
`endif                                                                           
  .RxBypassPadEn_DFI1_CA                     ( dis_upf_xprop ?{`DWC_DDRPHY_NUM_RANKS+6{RxBypassPadEn_DFI1_CA}}  : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{RxBypassPadEn_DFI1_CA}} ) ),
  .RxBypassDataPad_DFI1_CA                   ( RxBypassDataPad_DFI1_CA            ),
  .TxBypassMode_DFI1_CA                      ( dis_upf_xprop ?{`DWC_DDRPHY_NUM_RANKS+6{TxBypassMode_DFI1_CA}} : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{TxBypassMode_DFI1_CA}} )),
  .TxBypassOE_DFI1_CA                        ( dis_upf_xprop ?{`DWC_DDRPHY_NUM_RANKS+6{TxBypassOE_DFI1_CA  }} : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{TxBypassOE_DFI1_CA  }} )),
  .TxBypassData_DFI1_CA                      ( dis_upf_xprop ?TxBypassData_DFI1_CA                            : ((~dwc_PwrOkIn_XDriver ) ? {(`DWC_DDRPHY_NUM_RANKS+6){1'bx}} : TxBypassData_DFI1_CA                            )),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI1_B0_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B0_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B0_DQS )      ),
  .RxBypassRcvEn_DFI1_B1_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B1_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B1_DQS )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                     
  .RxBypassRcvEn_DFI1_B2_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B2_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B2_DQS )      ),
  .RxBypassRcvEn_DFI1_B3_DQS                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B3_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B3_DQS )      ),
`endif                                                                          
  .RxBypassDataRcv_DFI1_B0_DQS_T             ( RxBypassDataRcv_DFI1_B0_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B0_DQS_C             ( RxBypassDataRcv_DFI1_B0_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_T             ( RxBypassDataRcv_DFI1_B1_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_C             ( RxBypassDataRcv_DFI1_B1_DQS_C      ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                      
  .RxBypassDataRcv_DFI1_B2_DQS_T             ( RxBypassDataRcv_DFI1_B2_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B2_DQS_C             ( RxBypassDataRcv_DFI1_B2_DQS_C      ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_T             ( RxBypassDataRcv_DFI1_B3_DQS_T      ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_C             ( RxBypassDataRcv_DFI1_B3_DQS_C      ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI1_B0_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B0_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B0_DQS  )     ),
  .RxBypassPadEn_DFI1_B1_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B1_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B1_DQS  )     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                 
  .RxBypassPadEn_DFI1_B2_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B2_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B2_DQS  )     ),
  .RxBypassPadEn_DFI1_B3_DQS                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B3_DQS  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B3_DQS  )     ),
`endif                                                                      
  .RxBypassDataPad_DFI1_B0_DQS_T             ( RxBypassDataPad_DFI1_B0_DQS_T      ),
  .RxBypassDataPad_DFI1_B0_DQS_C             ( RxBypassDataPad_DFI1_B0_DQS_C      ),
  .RxBypassDataPad_DFI1_B1_DQS_T             ( RxBypassDataPad_DFI1_B1_DQS_T      ),
  .RxBypassDataPad_DFI1_B1_DQS_C             ( RxBypassDataPad_DFI1_B1_DQS_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .RxBypassDataPad_DFI1_B2_DQS_T             ( RxBypassDataPad_DFI1_B2_DQS_T      ),
  .RxBypassDataPad_DFI1_B2_DQS_C             ( RxBypassDataPad_DFI1_B2_DQS_C      ),
  .RxBypassDataPad_DFI1_B3_DQS_T             ( RxBypassDataPad_DFI1_B3_DQS_T      ),
  .RxBypassDataPad_DFI1_B3_DQS_C             ( RxBypassDataPad_DFI1_B3_DQS_C      ),
`endif                                                                           
  .TxBypassMode_DFI1_B0_DQS                  ( TxBypassMode_DFI1_B0_DQS           ),
  .TxBypassMode_DFI1_B1_DQS                  ( TxBypassMode_DFI1_B1_DQS           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                        
  .TxBypassMode_DFI1_B2_DQS                  ( TxBypassMode_DFI1_B2_DQS           ),
  .TxBypassMode_DFI1_B3_DQS                  ( TxBypassMode_DFI1_B3_DQS           ),
`endif                                                                          
  .TxBypassOE_DFI1_B0_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B0_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B0_DQS_T  )      ),
  .TxBypassOE_DFI1_B0_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B0_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B0_DQS_C  )      ),
  .TxBypassOE_DFI1_B1_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B1_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B1_DQS_T  )      ),
  .TxBypassOE_DFI1_B1_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B1_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B1_DQS_C  )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                   
  .TxBypassOE_DFI1_B2_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B2_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B2_DQS_T  )      ),
  .TxBypassOE_DFI1_B2_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B2_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B2_DQS_C  )      ),
  .TxBypassOE_DFI1_B3_DQS_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B3_DQS_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B3_DQS_T  )      ),
  .TxBypassOE_DFI1_B3_DQS_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B3_DQS_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B3_DQS_C  )      ),
`endif                                                                                                                                                      
  .TxBypassData_DFI1_B0_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI1_B0_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B0_DQS_T)      ),
  .TxBypassData_DFI1_B0_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI1_B0_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B0_DQS_C)      ),
  .TxBypassData_DFI1_B1_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI1_B1_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B1_DQS_T)      ),
  .TxBypassData_DFI1_B1_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI1_B1_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B1_DQS_C)      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                   
  .TxBypassData_DFI1_B2_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI1_B2_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B2_DQS_T)      ),
  .TxBypassData_DFI1_B2_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI1_B2_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B2_DQS_C)      ),
  .TxBypassData_DFI1_B3_DQS_T                ( dis_upf_xprop ? TxBypassData_DFI1_B3_DQS_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B3_DQS_T)      ),
  .TxBypassData_DFI1_B3_DQS_C                ( dis_upf_xprop ? TxBypassData_DFI1_B3_DQS_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B3_DQS_C)      ),
`endif                                                                        
                                                                                
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                                 
  .RxBypassRcvEn_DFI1_B0_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B0_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B0_WCK )      ),
  .RxBypassRcvEn_DFI1_B1_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B1_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B1_WCK )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                    
  .RxBypassRcvEn_DFI1_B2_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B2_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B2_WCK )      ),
  .RxBypassRcvEn_DFI1_B3_WCK                 ( dis_upf_xprop ? RxBypassRcvEn_DFI1_B3_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_B3_WCK )      ),
`endif                                                                           
  .RxBypassDataRcv_DFI1_B0_WCK_T             ( RxBypassDataRcv_DFI1_B0_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B0_WCK_C             ( RxBypassDataRcv_DFI1_B0_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_T             ( RxBypassDataRcv_DFI1_B1_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_C             ( RxBypassDataRcv_DFI1_B1_WCK_C      ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                        
  .RxBypassDataRcv_DFI1_B2_WCK_T             ( RxBypassDataRcv_DFI1_B2_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B2_WCK_C             ( RxBypassDataRcv_DFI1_B2_WCK_C      ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_T             ( RxBypassDataRcv_DFI1_B3_WCK_T      ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_C             ( RxBypassDataRcv_DFI1_B3_WCK_C      ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI1_B0_WCK                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B0_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B0_WCK )      ),
  .RxBypassPadEn_DFI1_B1_WCK                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B1_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B1_WCK )      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                    
  .RxBypassPadEn_DFI1_B2_WCK                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B2_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B2_WCK )      ),
  .RxBypassPadEn_DFI1_B3_WCK                 ( dis_upf_xprop ? RxBypassPadEn_DFI1_B3_WCK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_B3_WCK )      ),
`endif                                                                           
  .RxBypassDataPad_DFI1_B0_WCK_T             ( RxBypassDataPad_DFI1_B0_WCK_T      ),
  .RxBypassDataPad_DFI1_B0_WCK_C             ( RxBypassDataPad_DFI1_B0_WCK_C      ),
  .RxBypassDataPad_DFI1_B1_WCK_T             ( RxBypassDataPad_DFI1_B1_WCK_T      ),
  .RxBypassDataPad_DFI1_B1_WCK_C             ( RxBypassDataPad_DFI1_B1_WCK_C      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .RxBypassDataPad_DFI1_B2_WCK_T             ( RxBypassDataPad_DFI1_B2_WCK_T      ),
  .RxBypassDataPad_DFI1_B2_WCK_C             ( RxBypassDataPad_DFI1_B2_WCK_C      ),
  .RxBypassDataPad_DFI1_B3_WCK_T             ( RxBypassDataPad_DFI1_B3_WCK_T      ),
  .RxBypassDataPad_DFI1_B3_WCK_C             ( RxBypassDataPad_DFI1_B3_WCK_C      ),
`endif                                                                           
  .TxBypassMode_DFI1_B0_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI1_B0_WCK   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B0_WCK  )    ),
  .TxBypassMode_DFI1_B1_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI1_B1_WCK   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B1_WCK  )    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                              )    
  .TxBypassMode_DFI1_B2_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI1_B2_WCK   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B2_WCK  )    ),
  .TxBypassMode_DFI1_B3_WCK                  ( dis_upf_xprop ? TxBypassMode_DFI1_B3_WCK   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassMode_DFI1_B3_WCK  )    ),
`endif                                                                                                                                                  )    
  .TxBypassOE_DFI1_B0_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B0_WCK_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B0_WCK_T  )    ),
  .TxBypassOE_DFI1_B0_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B0_WCK_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B0_WCK_C  )    ),
  .TxBypassOE_DFI1_B1_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B1_WCK_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B1_WCK_T  )    ),
  .TxBypassOE_DFI1_B1_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B1_WCK_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B1_WCK_C  )    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                :                                                             )    
  .TxBypassOE_DFI1_B2_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B2_WCK_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B2_WCK_T  )    ),
  .TxBypassOE_DFI1_B2_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B2_WCK_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B2_WCK_C  )    ),
  .TxBypassOE_DFI1_B3_WCK_T                  ( dis_upf_xprop ? TxBypassOE_DFI1_B3_WCK_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B3_WCK_T  )    ),
  .TxBypassOE_DFI1_B3_WCK_C                  ( dis_upf_xprop ? TxBypassOE_DFI1_B3_WCK_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_B3_WCK_C  )    ),
`endif                                                                                                                                                       
  .TxBypassData_DFI1_B0_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI1_B0_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B0_WCK_T)    ),
  .TxBypassData_DFI1_B0_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI1_B0_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B0_WCK_C)    ),
  .TxBypassData_DFI1_B1_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI1_B1_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B1_WCK_T)    ),
  .TxBypassData_DFI1_B1_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI1_B1_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B1_WCK_C)    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                   
  .TxBypassData_DFI1_B2_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI1_B2_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B2_WCK_T)    ),
  .TxBypassData_DFI1_B2_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI1_B2_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B2_WCK_C)    ),
  .TxBypassData_DFI1_B3_WCK_T                ( dis_upf_xprop ? TxBypassData_DFI1_B3_WCK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B3_WCK_T)    ),
  .TxBypassData_DFI1_B3_WCK_C                ( dis_upf_xprop ? TxBypassData_DFI1_B3_WCK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_B3_WCK_C)    ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI1_CK                     ( dis_upf_xprop ? RxBypassRcvEn_DFI1_CK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassRcvEn_DFI1_CK)     ),
  .RxBypassDataRcv_DFI1_CK_T                 ( RxBypassDataRcv_DFI1_CK_T          ),
  .RxBypassDataRcv_DFI1_CK_C                 ( RxBypassDataRcv_DFI1_CK_C          ),
  .RxBypassPadEn_DFI1_CK                     ( dis_upf_xprop ? RxBypassPadEn_DFI1_CK : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : RxBypassPadEn_DFI1_CK)     ),
  .RxBypassDataPad_DFI1_CK_T                 ( RxBypassDataPad_DFI1_CK_T          ),
  .RxBypassDataPad_DFI1_CK_C                 ( RxBypassDataPad_DFI1_CK_C          ),
  .TxBypassMode_DFI1_CK                      ( TxBypassMode_DFI1_CK               ),
  .TxBypassOE_DFI1_CK_T                      ( dis_upf_xprop ? TxBypassOE_DFI1_CK_T   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_CK_T  )           ),
  .TxBypassOE_DFI1_CK_C                      ( dis_upf_xprop ? TxBypassOE_DFI1_CK_C   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassOE_DFI1_CK_C  )           ),
  .TxBypassData_DFI1_CK_T                    ( dis_upf_xprop ? TxBypassData_DFI1_CK_T : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_CK_T)           ),
  .TxBypassData_DFI1_CK_C                    ( dis_upf_xprop ? TxBypassData_DFI1_CK_C : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TxBypassData_DFI1_CK_C)           ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI1_LP4CKE_LP5CS           ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS{RxBypassPadEn_DFI1_LP4CKE_LP5CS}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS{1'bx}} : {`DWC_DDRPHY_NUM_RANKS{RxBypassPadEn_DFI1_LP4CKE_LP5CS}}) ), 
  .RxBypassDataPad_DFI1_LP4CKE_LP5CS         ( RxBypassDataPad_DFI1_LP4CKE_LP5CS  ),
  .TxBypassMode_DFI1_LP4CKE_LP5CS            ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS{TxBypassMode_DFI1_LP4CKE_LP5CS}} : ((~dwc_PwrOkIn_XDriver ) ?{`DWC_DDRPHY_NUM_RANKS{ 1'bx}} : {`DWC_DDRPHY_NUM_RANKS{TxBypassMode_DFI1_LP4CKE_LP5CS}}) ),
  .TxBypassOE_DFI1_LP4CKE_LP5CS              ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS{TxBypassOE_DFI1_LP4CKE_LP5CS  }} : ((~dwc_PwrOkIn_XDriver ) ?{`DWC_DDRPHY_NUM_RANKS{ 1'bx}} : {`DWC_DDRPHY_NUM_RANKS{TxBypassOE_DFI1_LP4CKE_LP5CS  }}) ),
  .TxBypassData_DFI1_LP4CKE_LP5CS            ( dis_upf_xprop ? TxBypassData_DFI1_LP4CKE_LP5CS                          : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS{1'bx}} : TxBypassData_DFI1_LP4CKE_LP5CS                         ) ),
`endif //DWC_DDRPHY_NUM_CHANNELS_2
`else
.TxBypassMode_DFI0_CK_T                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_CK_C                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassData_DFI0_CK_T                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassData_DFI0_CK_C                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI0_B0_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI0_B0_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B0_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI0_B0_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B0_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                         
//.TxBypassMode_DFI0_B1_D                   ( dis_upf_xprop ? 8'b0 : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : 8'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI0_B1_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI0_B1_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B1_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI0_B1_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B1_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                         
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                                                                                               
//.TxBypassMode_DFI0_B2_D                   ( dis_upf_xprop ? 8'b0 : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : 8'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI0_B2_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI0_B2_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B2_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI0_B2_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B2_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                         
//.TxBypassMode_DFI0_B3_D                   ( dis_upf_xprop ? 8'b0 : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : 8'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI0_B3_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI0_B3_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B3_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI0_B3_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI0_B3_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                                                                                                                 
`endif                                                                                                                                                                                                 
                                                                                                                                                                                                       
`ifdef                                                                                                                                                                                                DWC_DDRPHY_NUM_CHANNELS_2                                                                                                                                                                                                         
.TxBypassMode_DFI1_CA                     ( dis_upf_xprop ? {(6+`DWC_DDRPHY_NUM_RANKS){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(6+`DWC_DDRPHY_NUM_RANKS){1'bx}} : {(6+`DWC_DDRPHY_NUM_RANKS){1'b0}})),
.TxBypassMode_DFI1_LP4CKE_LP5CS           ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS{1'b0}}     : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS{1'bx}} : {`DWC_DDRPHY_NUM_RANKS{1'b0}}    )),
.TxBypassMode_DFI1_CK_T                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_CK_C                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassData_DFI1_CK_T                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassData_DFI1_CK_C                   ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B0_D                   ( dis_upf_xprop ? 8'b0 : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : 8'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI1_B0_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI1_B0_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B0_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI1_B0_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B0_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                         
.TxBypassMode_DFI1_B1_D                   ( dis_upf_xprop ? 8'b0 : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : 8'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI1_B1_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI1_B1_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B1_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI1_B1_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B1_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                         
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                                                                                                                               
.TxBypassMode_DFI1_B2_D                   ( dis_upf_xprop ? 8'b0 : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : 8'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI1_B2_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI1_B2_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B2_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI1_B2_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B2_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                         
.TxBypassMode_DFI1_B3_D                   ( dis_upf_xprop ? 8'b0 : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx}} : 8'b0 )),
`ifdef                                                                                                                                                                                                      DWC_DDRPHY_DBYTE_DMI_ENABLED                                                                                                                                                                                                      
.TxBypassMode_DFI1_B3_DMI                 ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )), 
`endif                                                                                                              
.TxBypassMode_DFI1_B3_DQS_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B3_DQS_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`ifdef                                                                                                                                                                                                           DWC_DDRPHY_LPDDR5_ENABLED                                                                                                                                                                                                         
.TxBypassMode_DFI1_B3_WCK_T               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
.TxBypassMode_DFI1_B3_WCK_C               ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx      : 1'b0 )),
`endif                                                                                                                                     
`endif                                                                                                                                     
`endif                                                                                                                                     
                                                                                                                                           
.TxBypassMode_MEMRESET_L                  ( 1'b0 ),
.TxBypassData_MEMRESET_L                  ( 1'b0 ),
`endif  //FLYOVER_TEST
////////////////////////////////////////////////////////////////////////////////
// TOP LEVEL I/Os: RESETs/CLKs
////////////////////////////////////////////////////////////////////////////////

 //.PwrOkIn                             ( PwrOkIn                         ),
 .BP_PWROK                              ( PwrOkIn ),
`ifdef FLYOVER_TEST
 .Reset                                 ( dis_upf_xprop ? ((!mission_mode&RESET) | (Reset&mission_mode)): ((~dwc_PwrOkIn_XDriver ) ? 1'bx : ((!mission_mode&RESET) | (Reset&mission_mode))) ),
 .Reset_async                           ( dis_upf_xprop ? ((!mission_mode&RESET) | (Reset&mission_mode)): ((~dwc_PwrOkIn_XDriver ) ? 1'bx : ((!mission_mode&RESET) | (Reset&mission_mode))) ),
`else
 .Reset                                 ( dis_upf_xprop ? Reset : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : Reset)),
 .Reset_async                           ( dis_upf_xprop ? Reset : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : Reset)),
`endif
 //.BypassPclk                          ( bypass_clk                      ),
 .BurnIn                                ( dis_upf_xprop ? 1'b0  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0 )),
 .PllRefClk                             ( dis_upf_xprop ? dfi_ctl_clk_assign  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : dfi_ctl_clk_assign )), 
 .PllBypClk                             ( dis_upf_xprop ? bypass_clk  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : bypass_clk )), 
 .UcClk                                 ( UcClk                           ), 
////////////////////////////////////////////////////////////////////////////////
// TOP LEVEL I/Os: ATPG/JTAG
////////////////////////////////////////////////////////////////////////////////
`ifdef FLYOVER_TEST
   .atpg_se						             ( dis_upf_xprop ? ATPG_SE  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : ATPG_SE ) ),
   .atpg_si						             ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS{ATPG_SI}}  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : {`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS{ATPG_SI}} ) ),
   .atpg_so						             (),
   .atpg_mode					             ( dis_upf_xprop ? ATPG_MODE  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : ATPG_MODE ) ),
`else
.atpg_mode                              ( dis_upf_xprop ? 1'b0   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0  )     ),
.atpg_se                                ( dis_upf_xprop ? {`DWC_DDRPHY_ATPG_SE_WIDTH{1'b0}}  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_ATPG_SE_WIDTH{1'bx}} : {`DWC_DDRPHY_ATPG_SE_WIDTH{1'b0}} ) ),
.atpg_si                                ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS{1'b0}}  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS{1'bx}} : {`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS{1'b0}} ) ),
.atpg_so                                ( atpg_so   ),
`endif
//.atpg_lu_ctrl                         ( {6{1'b1}}                                                            ),
.atpg_RDQSClk                           ( dis_upf_xprop ? 1'b0   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0  )   ),
//.atpg_Pclk                            ( 1'b0                                                                 ),
.atpg_TxDllClk                          ( dis_upf_xprop ? 1'b0   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0  )   ),

`ifdef DWC_DDRPHY_LBIST_EN
`ifndef PUB_VERSION_GE_0100
 .DfiClk0_lbist                         ( dis_upf_xprop ? DfiClk0_lbist : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : DfiClk0_lbist) ),
`endif
 .lbist_mode                            ( dis_upf_xprop ? LBIST_MODE    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : LBIST_MODE   ) ),
 .LBIST_TM0                             ( dis_upf_xprop ? LBIST_TM0     : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : LBIST_TM0    ) ),
 .LBIST_TM1                             ( dis_upf_xprop ? LBIST_TM1     : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : LBIST_TM1    ) ),
 .LBIST_EN                              ( dis_upf_xprop ? LBIST_EN      : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : LBIST_EN     ) ),
 .START                                 ( dis_upf_xprop ? START         : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : START        ) ),
 .STATUS_0                              ( STATUS_0                                                                         ),
 .STATUS_1                              ( STATUS_1                                                                         ),
`endif  

.TDRCLK                                 ( dis_upf_xprop ? TDRCLK                      : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : TDRCLK                     )  ),   // TDR Clock
.WRSTN                                  ( dis_upf_xprop ? WRSTN                       : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : WRSTN                      )  ),    // TDR low active async reset
.WSI                                    ( dis_upf_xprop ? WSI                         : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : WSI                        )  ),      // TDR Serial Input
.DdrPhyCsrCmdTdrShiftEn                 ( dis_upf_xprop ? DdrPhyCsrCmdTdrShiftEn      : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : DdrPhyCsrCmdTdrShiftEn     )  ),
.DdrPhyCsrCmdTdrCaptureEn               ( dis_upf_xprop ? DdrPhyCsrCmdTdrCaptureEn    : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : DdrPhyCsrCmdTdrCaptureEn   )  ),
.DdrPhyCsrCmdTdrUpdateEn                ( dis_upf_xprop ? DdrPhyCsrCmdTdrUpdateEn     : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : DdrPhyCsrCmdTdrUpdateEn    )  ),
.DdrPhyCsrCmdTdr_Tdo                    ( DdrPhyCsrCmdTdr_Tdo                                                                                           ),
.DdrPhyCsrRdDataTdrShiftEn              ( dis_upf_xprop ? DdrPhyCsrRdDataTdrShiftEn   : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : DdrPhyCsrRdDataTdrShiftEn  )  ),
.DdrPhyCsrRdDataTdrCaptureEn            ( dis_upf_xprop ? DdrPhyCsrRdDataTdrCaptureEn : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : DdrPhyCsrRdDataTdrCaptureEn)  ),
.DdrPhyCsrRdDataTdrUpdateEn             ( dis_upf_xprop ? DdrPhyCsrRdDataTdrUpdateEn  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : DdrPhyCsrRdDataTdrUpdateEn )  ),
.DdrPhyCsrRdDataTdr_Tdo                 ( DdrPhyCsrRdDataTdr_Tdo                                                                                        ),

//.dwc_ddrphy_int_n                     ( dwc_ddrphy_int_n               )

//-----------------------------------------not use port addd by elvin-------------------------------------//
//-----------------------------------------not use port addd by elvin-------------------------------------//
.atpg_PllCtrlBus                        ( dis_upf_xprop ? 142'h0                      : ((~dwc_PwrOkIn_XDriver ) ? 142'hx : 142'h0)),               
.atpg_Asst_Clken                        ( dis_upf_xprop ? 1'b0                        : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0    )),  
.atpg_Asst_Clk                          (                   ),
.atpg_UcClk                             (                   ),

.dfi0_ctrlmsg                           ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_CTRLMSG_WIDTH{1'b0}}      : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CTRLMSG_WIDTH{1'bx}}      : {`DWC_DDRPHY_DFI0_CTRLMSG_WIDTH{1'b0}}  )   ),
.dfi0_ctrlmsg_ack                       (                    ),
.dfi0_ctrlmsg_data                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_CTRLMSG_DATA_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CTRLMSG_DATA_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_CTRLMSG_DATA_WIDTH{1'b0}})  ),
.dfi0_ctrlmsg_req                       ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_CTRLMSG_REQ_WIDTH{1'b0} } : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_CTRLMSG_REQ_WIDTH{1'bx} } : {`DWC_DDRPHY_DFI0_CTRLMSG_REQ_WIDTH{1'b0} })  ),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dfi1_ctrlmsg                           ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_CTRLMSG_WIDTH{1'b0}}  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_CTRLMSG_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_CTRLMSG_WIDTH{1'b0}} )   ),
.dfi1_ctrlmsg_ack                       (                    ),
.dfi1_ctrlmsg_data                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_CTRLMSG_DATA_WIDTH{1'b0}}  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_CTRLMSG_DATA_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_CTRLMSG_DATA_WIDTH{1'b0}} )   ),
.dfi1_ctrlmsg_req                       ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_CTRLMSG_REQ_WIDTH{1'b0} }  : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_CTRLMSG_REQ_WIDTH{1'bx} } : {`DWC_DDRPHY_DFI1_CTRLMSG_REQ_WIDTH{1'b0} } )   ),
`endif
`ifdef LP5_STD
.dfi0_wck_write_P0                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}})),   
.dfi0_wck_write_P1                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}})),
.dfi0_wck_write_P2                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}})),
.dfi0_wck_write_P3                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH{1'b0}})),
.dfi0_wrdata_link_ecc_P0                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
.dfi0_wrdata_link_ecc_P1                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
.dfi0_wrdata_link_ecc_P2                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
.dfi0_wrdata_link_ecc_P3                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dfi1_wck_write_P0                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}})),   
.dfi1_wck_write_P1                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}})),
.dfi1_wck_write_P2                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}})),
.dfi1_wck_write_P3                      ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH{1'b0}})),

.dfi1_wrdata_link_ecc_P0                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
.dfi1_wrdata_link_ecc_P1                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
.dfi1_wrdata_link_ecc_P2                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
.dfi1_wrdata_link_ecc_P3                ( dis_upf_xprop ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'bx}} : {`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH{1'b0}}) ),
`endif
`endif
.PhyInt_n                               (                    ),
.PhyInt_fault                           (                    ),
.dwc_ddrphy0_snoop_en_P0                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
.dwc_ddrphy0_snoop_en_P1                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
.dwc_ddrphy0_snoop_en_P2                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
.dwc_ddrphy0_snoop_en_P3                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dwc_ddrphy1_snoop_en_P0                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
.dwc_ddrphy1_snoop_en_P1                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
.dwc_ddrphy1_snoop_en_P2                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
.dwc_ddrphy1_snoop_en_P3                ( dis_upf_xprop ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'bx}} : {(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL){1'b0}})),
`endif

.atpg_PClk                              ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)                            ),
.atpg_DlyTestClk                        ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)                            ),
.haddr_ahb                              (                                   ),
.hburst_ahb                             (                                   ),
.hmastlock_ahb                          (                                   ),
.hprot_ahb                              (                                   ),
.hsize_ahb                              (                                   ),
.htrans_ahb                             (                                   ),
.hwdata_ahb                             (                                   ),
.hwrite_ahb                             (                                   ),
.hclk_ahb                               (                                   ),
.hresetn_ahb                            (                                   ),
.hrdata_ahb                             (  dis_upf_xprop ? 32'h0 : ((~dwc_PwrOkIn_XDriver ) ? 32'hx : 32'h0)                            ),
.hresp_ahb                              (  dis_upf_xprop ? 1'b0  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx  : 1'b0 )                            ),
.hreadyout_ahb                          (  dis_upf_xprop ? 1'b0  : ((~dwc_PwrOkIn_XDriver ) ? 1'bx  : 1'b0 )                            ),
.ps_ram_rddata                          (  dis_upf_xprop ? 60'h0 : ((~dwc_PwrOkIn_XDriver ) ? 60'hx : 60'h0)                            ),
.ps_ram_wrdata                          (                                   ),
.ps_ram_addr                            (                                   ),
.ps_ram_ce                              (                                   ),
.ps_ram_we                              (                                   ),
.RxTestClk  (1'b0),
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI0_B0_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ), 
  .RxBypassRcvEn_DFI0_B1_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                       
  .RxBypassRcvEn_DFI0_B2_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
  .RxBypassRcvEn_DFI0_B3_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
`endif                                                                         
  .RxBypassData_DFI0_B0_D0                   (            ), //4bit
  .RxBypassData_DFI0_B0_D1                   (            ), //4bit
  .RxBypassData_DFI0_B0_D2                   (            ), //4bit
  .RxBypassData_DFI0_B0_D3                   (            ), //4bit
  .RxBypassData_DFI0_B0_D4                   (            ), //4bit
  .RxBypassData_DFI0_B0_D5                   (            ), //4bit
  .RxBypassData_DFI0_B0_D6                   (            ), //4bit
  .RxBypassData_DFI0_B0_D7                   (            ), //4bit
  .RxBypassData_DFI0_B1_D0                   (            ), //4bit
  .RxBypassData_DFI0_B1_D1                   (            ), //4bit
  .RxBypassData_DFI0_B1_D2                   (            ), //4bit
  .RxBypassData_DFI0_B1_D3                   (            ), //4bit
  .RxBypassData_DFI0_B1_D4                   (            ), //4bit
  .RxBypassData_DFI0_B1_D5                   (            ), //4bit
  .RxBypassData_DFI0_B1_D6                   (            ), //4bit
  .RxBypassData_DFI0_B1_D7                   (            ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4             
  .RxBypassData_DFI0_B2_D0                   (            ), //4bit
  .RxBypassData_DFI0_B2_D1                   (            ), //4bit
  .RxBypassData_DFI0_B2_D2                   (            ), //4bit
  .RxBypassData_DFI0_B2_D3                   (            ), //4bit
  .RxBypassData_DFI0_B2_D4                   (            ), //4bit
  .RxBypassData_DFI0_B2_D5                   (            ), //4bit
  .RxBypassData_DFI0_B2_D6                   (            ), //4bit
  .RxBypassData_DFI0_B2_D7                   (            ), //4bit
  .RxBypassData_DFI0_B3_D0                   (            ), //4bit
  .RxBypassData_DFI0_B3_D1                   (            ), //4bit
  .RxBypassData_DFI0_B3_D2                   (            ), //4bit
  .RxBypassData_DFI0_B3_D3                   (            ), //4bit
  .RxBypassData_DFI0_B3_D4                   (            ), //4bit
  .RxBypassData_DFI0_B3_D5                   (            ), //4bit
  .RxBypassData_DFI0_B3_D6                   (            ), //4bit
  .RxBypassData_DFI0_B3_D7                   (            ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI0_B0_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
  .RxBypassPadEn_DFI0_B1_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI0_B2_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
  .RxBypassPadEn_DFI0_B3_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_D                 (          ),
  .RxBypassDataPad_DFI0_B1_D                 (          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4       
  .RxBypassDataPad_DFI0_B2_D                 (          ),
  .RxBypassDataPad_DFI0_B3_D                 (          ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
  .TxBypassMode_DFI0_B1_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                       
  .TxBypassMode_DFI0_B2_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
  .TxBypassMode_DFI0_B3_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
`endif                                      
  .TxBypassOE_DFI0_B0_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
  .TxBypassOE_DFI0_B1_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                       
  .TxBypassOE_DFI0_B2_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
  .TxBypassOE_DFI0_B3_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
`endif                                                               
  .TxBypassData_DFI0_B0_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})             ),
  .TxBypassData_DFI0_B1_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                                                                       
  .TxBypassData_DFI0_B2_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})             ),
  .TxBypassData_DFI0_B3_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})             ),
`endif                                                                           
                                                                                 
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                              
  .RxBypassRcvEn_DFI0_B0_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI0_B1_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4             
  .RxBypassRcvEn_DFI0_B2_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI0_B3_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                         
  .RxBypassPadEn_DFI0_B0_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI0_B1_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4             
  .RxBypassPadEn_DFI0_B2_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI0_B3_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_DMI               (        ),
  .RxBypassDataPad_DFI0_B1_DMI               (        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4     
  .RxBypassDataPad_DFI0_B2_DMI               (        ),
  .RxBypassDataPad_DFI0_B3_DMI               (        ),
`endif                                                                   
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4          
  //.TxBypassMode_DFI0_B2_DMI                  (1'b0           ),
  //.TxBypassMode_DFI0_B3_DMI                  (1'b0           ),
`endif                                                                 
  .TxBypassOE_DFI0_B0_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  .TxBypassOE_DFI0_B1_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4          
  .TxBypassOE_DFI0_B2_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  .TxBypassOE_DFI0_B3_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
`endif                                                               
  .TxBypassData_DFI0_B0_DMI                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B1_DMI                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4        
  .TxBypassData_DFI0_B2_DMI                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B3_DMI                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`endif                                                                           
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                         
                                                                                
  .RxBypassRcvEn_DFI0_CA                     ( dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}})),
  .RxBypassData_DFI0_CA0                     (              ),   //4bit
  .RxBypassData_DFI0_CA1                     (              ),   //4bit
  .RxBypassData_DFI0_CA2                     (              ),   //4bit
  .RxBypassData_DFI0_CA3                     (              ),   //4bit
  .RxBypassData_DFI0_CA4                     (              ),   //4bit
  .RxBypassData_DFI0_CA5                     (              ),   //4bit
  .RxBypassData_DFI0_CA6                     (              ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                                                    
  .RxBypassData_DFI0_CA7                     (              ),   //4bit
`endif                                                                          
  .RxBypassPadEn_DFI0_CA                     (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ),
  .RxBypassDataPad_DFI0_CA                   (            ),
  .TxBypassMode_DFI0_CA                      (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ),
  .TxBypassOE_DFI0_CA                        (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ),
  .TxBypassData_DFI0_CA                      (               ),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI0_B0_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI0_B1_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                  
  .RxBypassRcvEn_DFI0_B2_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI0_B3_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                          
  .RxBypassDataRcv_DFI0_B0_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI0_B0_DQS_C             (      ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI0_B1_DQS_C             (      ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4        
  .RxBypassDataRcv_DFI0_B2_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI0_B2_DQS_C             (      ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI0_B3_DQS_C             (      ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI0_B0_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI0_B1_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4              
  .RxBypassPadEn_DFI0_B2_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI0_B3_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                      
  .RxBypassDataPad_DFI0_B0_DQS_T             (      ),
  .RxBypassDataPad_DFI0_B0_DQS_C             (      ),
  .RxBypassDataPad_DFI0_B1_DQS_T             (      ),
  .RxBypassDataPad_DFI0_B1_DQS_C             (      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4       
  .RxBypassDataPad_DFI0_B2_DQS_T             (      ),
  .RxBypassDataPad_DFI0_B2_DQS_C             (      ),
  .RxBypassDataPad_DFI0_B3_DQS_T             (      ),
  .RxBypassDataPad_DFI0_B3_DQS_C             (      ),
`endif                                                                          
//  .TxBypassMode_DFI0_B0_DQS                  (TxBypassMode_DFI0_B0_DQS           ),
//  .TxBypassMode_DFI0_B1_DQS                  (TxBypassMode_DFI0_B1_DQS           ),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
//  .TxBypassMode_DFI0_B2_DQS                  (TxBypassMode_DFI0_B2_DQS           ),
//  .TxBypassMode_DFI0_B3_DQS                  (TxBypassMode_DFI0_B3_DQS           ),
//`endif                                                                          
  .TxBypassOE_DFI0_B0_DQS_T                  ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .TxBypassOE_DFI0_B0_DQS_C                  ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .TxBypassOE_DFI0_B1_DQS_T                  ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .TxBypassOE_DFI0_B1_DQS_C                  ( dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                     
  .TxBypassOE_DFI0_B2_DQS_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B2_DQS_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B3_DQS_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B3_DQS_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
`endif                                                                        
  .TxBypassData_DFI0_B0_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B0_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B1_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B1_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4               
  .TxBypassData_DFI0_B2_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B2_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B3_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B3_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`endif                                                                        
                                                                                
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                                 
  .RxBypassRcvEn_DFI0_B0_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI0_B1_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                  
  .RxBypassRcvEn_DFI0_B2_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI0_B3_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                           
  .RxBypassDataRcv_DFI0_B0_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI0_B0_WCK_C             (      ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI0_B1_WCK_C             (      ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4          
  .RxBypassDataRcv_DFI0_B2_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI0_B2_WCK_C             (      ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI0_B3_WCK_C             (      ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI0_B0_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI0_B1_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                  
  .RxBypassPadEn_DFI0_B2_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI0_B3_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                           
  .RxBypassDataPad_DFI0_B0_WCK_T             (      ),
  .RxBypassDataPad_DFI0_B0_WCK_C             (      ),
  .RxBypassDataPad_DFI0_B1_WCK_T             (      ),
  .RxBypassDataPad_DFI0_B1_WCK_C             (      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4         
  .RxBypassDataPad_DFI0_B2_WCK_T             (      ),
  .RxBypassDataPad_DFI0_B2_WCK_C             (      ),
  .RxBypassDataPad_DFI0_B3_WCK_T             (      ),
  .RxBypassDataPad_DFI0_B3_WCK_C             (      ),
`endif                                                                           
//  .TxBypassMode_DFI0_B0_WCK                  (TxBypassMode_DFI0_B0_WCK           ),
//  .TxBypassMode_DFI0_B1_WCK                  (TxBypassMode_DFI0_B1_WCK           ),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
//  .TxBypassMode_DFI0_B2_WCK                  (TxBypassMode_DFI0_B2_WCK           ),
//  .TxBypassMode_DFI0_B3_WCK                  (TxBypassMode_DFI0_B3_WCK           ),
//`endif                                                                           
  .TxBypassOE_DFI0_B0_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B0_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B1_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B1_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                   
  .TxBypassOE_DFI0_B2_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B2_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B3_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI0_B3_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
`endif                                                                           
  .TxBypassData_DFI0_B0_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B0_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B1_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B1_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                 
  .TxBypassData_DFI0_B2_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B2_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B3_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI0_B3_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI0_CK                     (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)              ),
  .RxBypassDataRcv_DFI0_CK_T                 (          ),
  .RxBypassDataRcv_DFI0_CK_C                 (          ),
  .RxBypassPadEn_DFI0_CK                     (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  .RxBypassDataPad_DFI0_CK_T                 (          ),
  .RxBypassDataPad_DFI0_CK_C                 (          ),
  //.TxBypassMode_DFI0_CK                      (TxBypassMode_DFI0_CK               ),
  .TxBypassOE_DFI0_CK_T                      (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  .TxBypassOE_DFI0_CK_C                      (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI0_LP4CKE_LP5CS           (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ), 
  .RxBypassDataPad_DFI0_LP4CKE_LP5CS         (  ),
  .TxBypassMode_DFI0_LP4CKE_LP5CS            (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}})),
  .TxBypassOE_DFI0_LP4CKE_LP5CS              (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ),
  .TxBypassData_DFI0_LP4CKE_LP5CS            (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)     ),
                                                                                 
  .TxBypassMode_DTO                          (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)                   ),
  .TxBypassOE_DTO                            (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)                   ),
  .TxBypassData_DTO                          (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)                   ),
  .RxBypassEn_DTO                            (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)                   ),
  .RxBypassDataPad_DTO                       (                ),

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI1_B0_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})      ), 
  .RxBypassRcvEn_DFI1_B1_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI1_B2_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
  .RxBypassRcvEn_DFI1_B3_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
`endif                                                                         
  .RxBypassData_DFI1_B0_D0                   (            ), //4bit
  .RxBypassData_DFI1_B0_D1                   (            ), //4bit
  .RxBypassData_DFI1_B0_D2                   (            ), //4bit
  .RxBypassData_DFI1_B0_D3                   (            ), //4bit
  .RxBypassData_DFI1_B0_D4                   (            ), //4bit
  .RxBypassData_DFI1_B0_D5                   (            ), //4bit
  .RxBypassData_DFI1_B0_D6                   (            ), //4bit
  .RxBypassData_DFI1_B0_D7                   (            ), //4bit
  .RxBypassData_DFI1_B1_D0                   (            ), //4bit
  .RxBypassData_DFI1_B1_D1                   (            ), //4bit
  .RxBypassData_DFI1_B1_D2                   (            ), //4bit
  .RxBypassData_DFI1_B1_D3                   (            ), //4bit
  .RxBypassData_DFI1_B1_D4                   (            ), //4bit
  .RxBypassData_DFI1_B1_D5                   (            ), //4bit
  .RxBypassData_DFI1_B1_D6                   (            ), //4bit
  .RxBypassData_DFI1_B1_D7                   (            ), //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                    
  .RxBypassData_DFI1_B2_D0                   (            ), //4bit
  .RxBypassData_DFI1_B2_D1                   (            ), //4bit
  .RxBypassData_DFI1_B2_D2                   (            ), //4bit
  .RxBypassData_DFI1_B2_D3                   (            ), //4bit
  .RxBypassData_DFI1_B2_D4                   (            ), //4bit
  .RxBypassData_DFI1_B2_D5                   (            ), //4bit
  .RxBypassData_DFI1_B2_D6                   (            ), //4bit
  .RxBypassData_DFI1_B2_D7                   (            ), //4bit
  .RxBypassData_DFI1_B3_D0                   (            ), //4bit
  .RxBypassData_DFI1_B3_D1                   (            ), //4bit
  .RxBypassData_DFI1_B3_D2                   (            ), //4bit
  .RxBypassData_DFI1_B3_D3                   (            ), //4bit
  .RxBypassData_DFI1_B3_D4                   (            ), //4bit
  .RxBypassData_DFI1_B3_D5                   (            ), //4bit
  .RxBypassData_DFI1_B3_D6                   (            ), //4bit
  .RxBypassData_DFI1_B3_D7                   (            ), //4bit
`endif                                                                       
  .RxBypassPadEn_DFI1_B0_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
  .RxBypassPadEn_DFI1_B1_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI1_B2_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
  .RxBypassPadEn_DFI1_B3_D                   (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})       ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_D                 (          ),
  .RxBypassDataPad_DFI1_B1_D                 (          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4       
  .RxBypassDataPad_DFI1_B2_D                 (          ),
  .RxBypassDataPad_DFI1_B3_D                 (          ),
`endif                                                                   
  //.TxBypassMode_DFI1_B0_D                    ({8{1'b0}}        ),
  //.TxBypassMode_DFI1_B1_D                    ({8{1'b0}}        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4           
 // .TxBypassMode_DFI1_B2_D                    ({8{1'b0}}        ),
 // .TxBypassMode_DFI1_B3_D                    ({8{1'b0}}        ),
`endif                                      
  .TxBypassOE_DFI1_B0_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
  .TxBypassOE_DFI1_B1_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4           
  .TxBypassOE_DFI1_B2_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
  .TxBypassOE_DFI1_B3_D                      (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})        ),
`endif                                                               
  .TxBypassData_DFI1_B0_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})             ),
  .TxBypassData_DFI1_B1_D                    (dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4           
  .TxBypassData_DFI1_B2_D                    ( dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})            ),
  .TxBypassData_DFI1_B3_D                    ( dis_upf_xprop ? {8{1'b0  }} : ((~dwc_PwrOkIn_XDriver ) ? {8{1'bx  }} : {8{1'b0  }})            ),
`endif                                                                           
                                                                                 
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED                                              
  .RxBypassRcvEn_DFI1_B0_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI1_B1_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                 
  .RxBypassRcvEn_DFI1_B2_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI1_B3_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                         
  .RxBypassData_DFI1_B0_DMI                  (           ),   //4bit
  .RxBypassData_DFI1_B1_DMI                  (           ),   //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4            
  .RxBypassData_DFI1_B2_DMI                  (           ),   //4bit
  .RxBypassData_DFI1_B3_DMI                  (           ),   //4bit
`endif                                                                       
  .RxBypassPadEn_DFI1_B0_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI1_B1_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4             
  .RxBypassPadEn_DFI1_B2_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI1_B3_DMI                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_DMI               (        ),
  .RxBypassDataPad_DFI1_B1_DMI               (        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4     
  .RxBypassDataPad_DFI1_B2_DMI               (        ),
  .RxBypassDataPad_DFI1_B3_DMI               (        ),
`endif                                                                   
  //.TxBypassMode_DFI1_B0_DMI                  (1'b0           ),
  //.TxBypassMode_DFI1_B1_DMI                  (1'b0           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4          
  //.TxBypassMode_DFI1_B2_DMI                  (1'b0           ),
  //.TxBypassMode_DFI1_B3_DMI                  (1'b0           ),
`endif                                                                 
  .TxBypassOE_DFI1_B0_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  .TxBypassOE_DFI1_B1_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4          
  .TxBypassOE_DFI1_B2_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  .TxBypassOE_DFI1_B3_DMI                    (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
`endif                                                               
  .TxBypassData_DFI1_B0_DMI                  (           ),
  .TxBypassData_DFI1_B1_DMI                  (           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI1_B2_DMI                  (           ),
  .TxBypassData_DFI1_B3_DMI                  (           ),
`endif                                                                           
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED                                         
                                                                                
  .RxBypassRcvEn_DFI1_CA                     (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ),
  .RxBypassData_DFI1_CA0                     (              ),   //4bit
  .RxBypassData_DFI1_CA1                     (              ),   //4bit
  .RxBypassData_DFI1_CA2                     (              ),   //4bit
  .RxBypassData_DFI1_CA3                     (              ),   //4bit
  .RxBypassData_DFI1_CA4                     (              ),   //4bit
  .RxBypassData_DFI1_CA5                     (              ),   //4bit
  .RxBypassData_DFI1_CA6                     (              ),   //4bit
`ifdef DWC_DDRPHY_NUM_RANKS_2                               
  .RxBypassData_DFI1_CA7                     (              ),   //4bit
`endif                                                                          
  .RxBypassPadEn_DFI1_CA                     (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ),
  .RxBypassDataPad_DFI1_CA                   (            ),
  //.TxBypassMode_DFI1_CA                      ({`DWC_DDRPHY_NUM_RANKS+6{1'b0}} ),
  .TxBypassOE_DFI1_CA                        (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}})),
  .TxBypassData_DFI1_CA                      (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}})               ),
  
//*********************DIFF: DQS/WCK/CK***************************//
  .RxBypassRcvEn_DFI1_B0_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI1_B1_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                  
  .RxBypassRcvEn_DFI1_B2_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI1_B3_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                          
  .RxBypassDataRcv_DFI1_B0_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI1_B0_DQS_C             (      ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI1_B1_DQS_C             (      ),  //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4        
  .RxBypassDataRcv_DFI1_B2_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI1_B2_DQS_C             (      ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_T             (      ),  //4bit
  .RxBypassDataRcv_DFI1_B3_DQS_C             (      ),  //4bit
`endif                                                                        
  .RxBypassPadEn_DFI1_B0_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI1_B1_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4              
  .RxBypassPadEn_DFI1_B2_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI1_B3_DQS                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                      
  .RxBypassDataPad_DFI1_B0_DQS_T             (      ),
  .RxBypassDataPad_DFI1_B0_DQS_C             (      ),
  .RxBypassDataPad_DFI1_B1_DQS_T             (      ),
  .RxBypassDataPad_DFI1_B1_DQS_C             (      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4       
  .RxBypassDataPad_DFI1_B2_DQS_T             (      ),
  .RxBypassDataPad_DFI1_B2_DQS_C             (      ),
  .RxBypassDataPad_DFI1_B3_DQS_T             (      ),
  .RxBypassDataPad_DFI1_B3_DQS_C             (      ),
`endif                                                                          
//  .TxBypassMode_DFI1_B0_DQS                  (TxBypassMode_DFI1_B0_DQS           ),
//  .TxBypassMode_DFI1_B1_DQS                  (TxBypassMode_DFI1_B1_DQS           ),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
//  .TxBypassMode_DFI1_B2_DQS                  (TxBypassMode_DFI1_B2_DQS           ),
//  .TxBypassMode_DFI1_B3_DQS                  (TxBypassMode_DFI1_B3_DQS           ),
//`endif                                                                          
  .TxBypassOE_DFI1_B0_DQS_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B0_DQS_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B1_DQS_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B1_DQS_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                 
  .TxBypassOE_DFI1_B2_DQS_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B2_DQS_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B3_DQS_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B3_DQS_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
`endif                                                                        
  .TxBypassData_DFI1_B0_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B0_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B1_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B1_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4               
  .TxBypassData_DFI1_B2_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B2_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B3_DQS_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B3_DQS_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`endif                                                                        
                                                                                
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                                                 
  .RxBypassRcvEn_DFI1_B0_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI1_B1_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                  
  .RxBypassRcvEn_DFI1_B2_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassRcvEn_DFI1_B3_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                           
  .RxBypassDataRcv_DFI1_B0_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI1_B0_WCK_C             (      ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI1_B1_WCK_C             (      ),    //4bit
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4          
  .RxBypassDataRcv_DFI1_B2_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI1_B2_WCK_C             (      ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_T             (      ),    //4bit
  .RxBypassDataRcv_DFI1_B3_WCK_C             (      ),    //4bit
`endif                                                                           
  .RxBypassPadEn_DFI1_B0_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI1_B1_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                  
  .RxBypassPadEn_DFI1_B2_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
  .RxBypassPadEn_DFI1_B3_WCK                 (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)          ),
`endif                                                                           
  .RxBypassDataPad_DFI1_B0_WCK_T             (      ),
  .RxBypassDataPad_DFI1_B0_WCK_C             (      ),
  .RxBypassDataPad_DFI1_B1_WCK_T             (      ),
  .RxBypassDataPad_DFI1_B1_WCK_C             (      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4         
  .RxBypassDataPad_DFI1_B2_WCK_T             (      ),
  .RxBypassDataPad_DFI1_B2_WCK_C             (      ),
  .RxBypassDataPad_DFI1_B3_WCK_T             (      ),
  .RxBypassDataPad_DFI1_B3_WCK_C             (      ),
`endif                                                                           
//  .TxBypassMode_DFI1_B0_WCK                  (TxBypassMode_DFI1_B0_WCK           ),
//  .TxBypassMode_DFI1_B1_WCK                  (TxBypassMode_DFI1_B1_WCK           ),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
//  .TxBypassMode_DFI1_B2_WCK                  (TxBypassMode_DFI1_B2_WCK           ),
//  .TxBypassMode_DFI1_B3_WCK                  (TxBypassMode_DFI1_B3_WCK           ),
//`endif                                                                           
  .TxBypassOE_DFI1_B0_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B0_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B1_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B1_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                   
  .TxBypassOE_DFI1_B2_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B2_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B3_WCK_T                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .TxBypassOE_DFI1_B3_WCK_C                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
`endif                                                                           
  .TxBypassData_DFI1_B0_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B0_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B1_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B1_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                 
  .TxBypassData_DFI1_B2_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B2_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B3_WCK_T                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
  .TxBypassData_DFI1_B3_WCK_C                (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)         ),
`endif
`endif   //DWC_DDRPHY_LPDDR5_ENABLED

  .RxBypassRcvEn_DFI1_CK                     (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)               ),
  .RxBypassDataRcv_DFI1_CK_T                 (          ),
  .RxBypassDataRcv_DFI1_CK_C                 (          ),
  .RxBypassPadEn_DFI1_CK                     (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)           ),
  .RxBypassDataPad_DFI1_CK_T                 (              ),
  .RxBypassDataPad_DFI1_CK_C                 (              ),
  //.TxBypassMode_DFI1_CK                      (TxBypassMode_DFI1_CK               ),
  .TxBypassOE_DFI1_CK_T                      (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  .TxBypassOE_DFI1_CK_C                      (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)             ),
  //.TxBypassData_DFI1_CK_T                    (1'b0             ),
  //.TxBypassData_DFI1_CK_C                    (1'b0             ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI1_LP4CKE_LP5CS           (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ), 
  .RxBypassDataPad_DFI1_LP4CKE_LP5CS         (  ),
  //.TxBypassMode_DFI1_LP4CKE_LP5CS            ({`DWC_DDRPHY_NUM_RANKS{1'b0}} ),
  .TxBypassOE_DFI1_LP4CKE_LP5CS              (dis_upf_xprop ? {`DWC_DDRPHY_NUM_RANKS+6{1'b0}} : ((~dwc_PwrOkIn_XDriver ) ? {`DWC_DDRPHY_NUM_RANKS+6{1'bx}} : {`DWC_DDRPHY_NUM_RANKS+6{1'b0}}) ),
  .TxBypassData_DFI1_LP4CKE_LP5CS            (     ),
`endif //DWC_DDRPHY_NUM_CHANNELS_2
.ZCAL_SENSE                                  (dis_upf_xprop ? 1'b0 : ((~dwc_PwrOkIn_XDriver ) ? 1'bx : 1'b0)                              ),
.ZCAL_INT                                    (                                   )



);
`endif

//-----------------------------------------------------------------
// DFI model
//-----------------------------------------------------------------

//-----------------------------------------------------------------
// DFI VIP instantiation
//-----------------------------------------------------------------
`ifdef SVT_DFI
svt_dfi_uvmvlog #(
   .pIndex                  (0)
  ,.pERROR_INFO_WIDTH       (`DWC_DDRPHY_DFI0_ERROR_INFO_WIDTH)
  ,.pPHYUPD_TYPE_WIDTH      (`DWC_DDRPHY_DFI0_PHYUPD_TYPE_WIDTH)
  ,.pPHYMSTR_CS_STATE_WIDTH (`DWC_DDRPHY_DFI0_PHYMSTR_CS_STATE_WIDTH)
  ,.pPHYMSTR_TYPE_WIDTH     (`DWC_DDRPHY_DFI0_PHYMSTR_TYPE_WIDTH)
  ,.pFREQ_WIDTH             (`DWC_DDRPHY_DFI0_FREQUENCY_WIDTH)
  ,.pFREQ_RATIO_WIDTH       (`DWC_DDRPHY_DFI0_FREQ_RATIO_WIDTH)
  ,.pFREQ_FSP_WIDTH         (`DWC_DDRPHY_DFI0_FREQ_FSP_WIDTH         )
  ,.pCKE_WIDTH              (`DWC_DDRPHY_DFI0_CKE_WIDTH)
  ,.pCS_WIDTH               (`DWC_DDRPHY_DFI0_CS_WIDTH)
  `ifdef LP5_STD
  ,.pWCK_EN_WIDTH           (`DWC_DDRPHY_DFI0_WCK_EN_WIDTH)
  ,.pWCK_CS_WIDTH           (`DWC_DDRPHY_DFI0_WCK_CS_WIDTH)
  ,.pWCK_TOGGLE_WIDTH       (`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH)
  ,.pWRDATA_LINK_ECC_WIDTH  (`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH)
  `endif
  ,.pADDRESS_WIDTH          (`DWC_DDRPHY_DFI0_ADDRESS_WIDTH)
  ,.pDFI_WRDATA_WIDTH       (`DWC_DDRPHY_DFI0_WRDATA_WIDTH)
  ,.pDFI_WRDATA_CS_WIDTH    (`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH)
  ,.pDFI_RDDATA_CS_WIDTH    (`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH)
  ,.pDFI_WRDATA_EN_WIDTH    (`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH)
  ,.pDFI_WRDATA_MASK_WIDTH  (`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH)
  ,.pDFI_RDDATA_EN_WIDTH    (`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH)
  ,.pDFI_RDDATA_VALID_WIDTH (`DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH)
  ,.pDFI_RDDATA_DBI_WIDTH   (`DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH) 
  ,.pDFI_RDDATA_WIDTH       (`DWC_DDRPHY_DFI0_RDDATA_WIDTH)
) dfi0(
  .clk             (dfi_ctl_clk),
  `ifdef LP5_STD
  .phy_clk         (dfi_phy_clk),
  `endif
  .pwr_ok          (PwrOkIn),
  .Reset           (Reset),
  .init_start      (dfi0_init_start),
  .init_complete   (dfi0_init_complete),

  .freq            (dfi0_frequency),
  .freq_ratio      (dfi0_freq_ratio),
  .freq_fsp        (dfi0_freq_fsp),
  .cke_P0          (dfi0_cke_P0),
  .cke_P1          (dfi0_cke_P1),
  .cke_P2          (dfi0_cke_P2),
  .cke_P3          (dfi0_cke_P3),

  .cs_P0           (dfi0_cs_P0),
  .cs_P1           (dfi0_cs_P1),
  .cs_P2           (dfi0_cs_P2),
  .cs_P3           (dfi0_cs_P3),

`ifdef LP5_STD
  .dfi_wck_en_P0            ( dfi0_wck_en_P0          ),
  .dfi_wck_en_P1            ( dfi0_wck_en_P1          ),
  .dfi_wck_en_P2            ( dfi0_wck_en_P2          ),
  .dfi_wck_en_P3            ( dfi0_wck_en_P3          ),
  
  .dfi_wck_cs_P0            ( dfi0_wck_cs_P0          ),
  .dfi_wck_cs_P1            ( dfi0_wck_cs_P1          ),
  .dfi_wck_cs_P2            ( dfi0_wck_cs_P2          ),
  .dfi_wck_cs_P3            ( dfi0_wck_cs_P3          ),
  
  .dfi_wck_toggle_P0        ( dfi0_wck_toggle_P0      ),
  .dfi_wck_toggle_P1        ( dfi0_wck_toggle_P1      ),
  .dfi_wck_toggle_P2        ( dfi0_wck_toggle_P2      ),
  .dfi_wck_toggle_P3        ( dfi0_wck_toggle_P3      ),
  
  //.dfi_wrdata_link_ecc_P0   ( dfi0_wrdata_link_ecc_P1 ),
  //.dfi_wrdata_link_ecc_P1   ( dfi0_wrdata_link_ecc_P2 ),
  //.dfi_wrdata_link_ecc_P2   ( dfi0_wrdata_link_ecc_P3 ),
  //.dfi_wrdata_link_ecc_P3   ( dfi0_wrdata_link_ecc_P4 ),
  .dfi_wrdata_link_ecc_P0   (  ),
  .dfi_wrdata_link_ecc_P1   (  ),
  .dfi_wrdata_link_ecc_P2   (  ),
  .dfi_wrdata_link_ecc_P3   (  ),
`endif

  .address_P0      (dfi0_address_P0),
  .address_P1      (dfi0_address_P1),
  .address_P2      (dfi0_address_P2),
  .address_P3      (dfi0_address_P3),

  .ctrlupd_ack     (dfi0_ctrlupd_ack),
  .ctrlupd_req     (dfi0_ctrlupd_req),
  .phyupd_req      (dfi0_phyupd_req),
  .phyupd_ack      (dfi0_phyupd_ack),
  .phyupd_type     (dfi0_phyupd_type),
  .phymstr_req     (dfi0_phymstr_req),
  .phymstr_ack     (dfi0_phymstr_ack),
  .lp_ctrl_ack     (dfi0_lp_ctrl_ack),
  .lp_data_ack     (dfi0_lp_data_ack),
  .lp_ctrl_req     (dfi0_lp_ctrl_req),
  .lp_data_req     (dfi0_lp_data_req),
  .lp_data_wakeup  (dfi0_lp_data_wakeup),
  .lp_ctrl_wakeup  (dfi0_lp_ctrl_wakeup),
  .dfi_dram_clk_disable_P0 (dfi0_dram_clk_disable_P0),
  .dfi_dram_clk_disable_P1 (dfi0_dram_clk_disable_P1),
  .dfi_dram_clk_disable_P2 (dfi0_dram_clk_disable_P2),
  .dfi_dram_clk_disable_P3 (dfi0_dram_clk_disable_P3),
 
  .phymstr_state_sel(dfi0_phymstr_state_sel),
  .phymstr_cs_state (dfi0_phymstr_cs_state),
  .phymstr_type     (dfi0_phymstr_type),

  .error           (dfi0_error),
  .error_info      (dfi0_error_info),
  //DFI VIP - dfi data
  .dfi_wrdata_P0			(dfi0_wrdata_P0     ),
  .dfi_wrdata_P1			(dfi0_wrdata_P1     ),
  .dfi_wrdata_P2			(dfi0_wrdata_P2     ),
  .dfi_wrdata_P3			(dfi0_wrdata_P3     ),
  .dfi_wrdata_cs_n_P0			(dfi0_wrdata_cs_P0),
  .dfi_wrdata_cs_n_P1			(dfi0_wrdata_cs_P1),
  .dfi_wrdata_cs_n_P2			(dfi0_wrdata_cs_P2),
  .dfi_wrdata_cs_n_P3			(dfi0_wrdata_cs_P3),
  .dfi_rddata_cs_n_P0			(dfi0_rddata_cs_P0),
  .dfi_rddata_cs_n_P1			(dfi0_rddata_cs_P1),
  .dfi_rddata_cs_n_P2			(dfi0_rddata_cs_P2),
  .dfi_rddata_cs_n_P3			(dfi0_rddata_cs_P3),
  .dfi_wrdata_en_P0			(dfi0_wrdata_en_P0  ),
  .dfi_wrdata_en_P1			(dfi0_wrdata_en_P1  ),
  .dfi_wrdata_en_P2			(dfi0_wrdata_en_P2  ),
  .dfi_wrdata_en_P3			(dfi0_wrdata_en_P3  ),
  .dfi_wrdata_mask_P0			(dfi0_wrdata_mask_P0),
  .dfi_wrdata_mask_P1			(dfi0_wrdata_mask_P1),
  .dfi_wrdata_mask_P2			(dfi0_wrdata_mask_P2),
  .dfi_wrdata_mask_P3			(dfi0_wrdata_mask_P3),
  .dfi_rddata_en_P0			(dfi0_rddata_en_P0),
  .dfi_rddata_en_P1			(dfi0_rddata_en_P1),
  .dfi_rddata_en_P2			(dfi0_rddata_en_P2),
  .dfi_rddata_en_P3			(dfi0_rddata_en_P3),
  .dfi_rddata_valid_W0			(dfi0_rddata_valid_W0),
  .dfi_rddata_valid_W1			(dfi0_rddata_valid_W1),
  .dfi_rddata_valid_W2			(dfi0_rddata_valid_W2),
  .dfi_rddata_valid_W3			(dfi0_rddata_valid_W3),
  .dfi_rddata_dbi_W0			(dfi0_rddata_dbi_W0),
  .dfi_rddata_dbi_W1			(dfi0_rddata_dbi_W1),
  .dfi_rddata_dbi_W2			(dfi0_rddata_dbi_W2),
  .dfi_rddata_dbi_W3			(dfi0_rddata_dbi_W3),
  .dfi_rddata_W0			(dfi0_rddata_W0),
  .dfi_rddata_W1			(dfi0_rddata_W1),
  .dfi_rddata_W2			(dfi0_rddata_W2),
  .dfi_rddata_W3			(dfi0_rddata_W3)

);

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
svt_dfi_uvmvlog #(
   .pIndex                  (1)
  ,.pERROR_INFO_WIDTH       (`DWC_DDRPHY_DFI1_ERROR_INFO_WIDTH)
  ,.pPHYUPD_TYPE_WIDTH      (`DWC_DDRPHY_DFI1_PHYUPD_TYPE_WIDTH)
  ,.pPHYMSTR_CS_STATE_WIDTH (`DWC_DDRPHY_DFI1_PHYMSTR_CS_STATE_WIDTH)
  ,.pPHYMSTR_TYPE_WIDTH     (`DWC_DDRPHY_DFI1_PHYMSTR_TYPE_WIDTH)
  ,.pFREQ_WIDTH             (`DWC_DDRPHY_DFI1_FREQUENCY_WIDTH)
  ,.pFREQ_RATIO_WIDTH       (`DWC_DDRPHY_DFI1_FREQ_RATIO_WIDTH)
  ,.pFREQ_FSP_WIDTH         (`DWC_DDRPHY_DFI1_FREQ_FSP_WIDTH         )
  ,.pCKE_WIDTH              (`DWC_DDRPHY_DFI1_CKE_WIDTH)
  ,.pCS_WIDTH               (`DWC_DDRPHY_DFI1_CS_WIDTH)
  `ifdef LP5_STD
  ,.pWCK_EN_WIDTH           (`DWC_DDRPHY_DFI1_WCK_EN_WIDTH)
  ,.pWCK_CS_WIDTH           (`DWC_DDRPHY_DFI1_WCK_CS_WIDTH)
  ,.pWCK_TOGGLE_WIDTH       (`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH)
  ,.pWRDATA_LINK_ECC_WIDTH  (`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH)
  `endif
  ,.pADDRESS_WIDTH          (`DWC_DDRPHY_DFI1_ADDRESS_WIDTH)
  ,.pDFI_WRDATA_WIDTH       (`DWC_DDRPHY_DFI1_WRDATA_WIDTH)
  ,.pDFI_WRDATA_CS_WIDTH    (`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH)
  ,.pDFI_RDDATA_CS_WIDTH    (`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH)
  ,.pDFI_WRDATA_EN_WIDTH    (`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH)
  ,.pDFI_WRDATA_MASK_WIDTH  (`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH)
  ,.pDFI_RDDATA_EN_WIDTH    (`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH)
  ,.pDFI_RDDATA_VALID_WIDTH (`DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH)
  ,.pDFI_RDDATA_DBI_WIDTH   (`DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH) 
  ,.pDFI_RDDATA_WIDTH       (`DWC_DDRPHY_DFI1_RDDATA_WIDTH)
) dfi1(
  .clk             (dfi_ctl_clk            ) ,
  `ifdef LP5_STD
  .phy_clk         (dfi_phy_clk            ) ,
  `endif
  .pwr_ok          (PwrOkIn                ) ,
  .Reset           (Reset                  ) ,
  .init_start      (dfi1_init_start        ) ,
  .init_complete   (dwc_dfi1_init_complete ) ,

  .freq            (dfi1_frequency         ) ,
  .freq_ratio      (dfi1_freq_ratio        ) ,
 .freq_fsp         (dfi1_freq_fsp          ) ,
  .cke_P0          (dfi1_cke_P0            ) ,
  .cke_P1          (dfi1_cke_P1            ) ,
  .cke_P2          (dfi1_cke_P2            ) ,
  .cke_P3          (dfi1_cke_P3            ) ,

  .cs_P0           (dfi1_cs_P0),
  .cs_P1           (dfi1_cs_P1),
  .cs_P2           (dfi1_cs_P2),
  .cs_P3           (dfi1_cs_P3),

`ifdef LP5_STD
  .dfi_wck_en_P0            ( dfi1_wck_en_P0         ),
  .dfi_wck_en_P1            ( dfi1_wck_en_P1         ),
  .dfi_wck_en_P2            ( dfi1_wck_en_P2         ),
  .dfi_wck_en_P3            ( dfi1_wck_en_P3         ),
  
  .dfi_wck_cs_P0            ( dfi1_wck_cs_P0         ),
  .dfi_wck_cs_P1            ( dfi1_wck_cs_P1         ),
  .dfi_wck_cs_P2            ( dfi1_wck_cs_P2         ),
  .dfi_wck_cs_P3            ( dfi1_wck_cs_P3         ),
  
  .dfi_wck_toggle_P0        ( dfi1_wck_toggle_P0     ),
  .dfi_wck_toggle_P1        ( dfi1_wck_toggle_P1     ),
  .dfi_wck_toggle_P2        ( dfi1_wck_toggle_P2     ),
  .dfi_wck_toggle_P3        ( dfi1_wck_toggle_P3     ),
  .dfi_wrdata_link_ecc_P0   (  ),
  .dfi_wrdata_link_ecc_P1   (  ),
  .dfi_wrdata_link_ecc_P2   (  ),
  .dfi_wrdata_link_ecc_P3   (  ), 
  //.dfi_wrdata_link_ecc_P0   ( dfi1_wrdata_link_ecc_P1),
  //.dfi_wrdata_link_ecc_P1   ( dfi1_wrdata_link_ecc_P2),
  //.dfi_wrdata_link_ecc_P2   ( dfi1_wrdata_link_ecc_P3),
  //.dfi_wrdata_link_ecc_P3   ( dfi1_wrdata_link_ecc_P4),
`endif

  .address_P0      (dfi1_address_P0),
  .address_P1      (dfi1_address_P1),
  .address_P2      (dfi1_address_P2),
  .address_P3      (dfi1_address_P3),

  .ctrlupd_ack     (dfi1_ctrlupd_ack),
  .ctrlupd_req     (dfi1_ctrlupd_req),
  .phyupd_req      (dfi1_phyupd_req),
  .phyupd_ack      (dfi1_phyupd_ack),
  .phyupd_type     (dfi1_phyupd_type),
  .phymstr_req     (dfi1_phymstr_req),
  .phymstr_ack     (dfi1_phymstr_ack),
  .lp_ctrl_ack     (dfi1_lp_ctrl_ack),
  .lp_data_ack     (dfi1_lp_data_ack),
  .lp_ctrl_req     (dfi1_lp_ctrl_req),
  .lp_data_req     (dfi1_lp_data_req),
  .lp_data_wakeup  (dfi1_lp_data_wakeup),
  .lp_ctrl_wakeup  (dfi1_lp_ctrl_wakeup),
  .dfi_dram_clk_disable_P0 (dfi1_dram_clk_disable_P0),
  .dfi_dram_clk_disable_P1 (dfi1_dram_clk_disable_P1),
  .dfi_dram_clk_disable_P2 (dfi1_dram_clk_disable_P2),
  .dfi_dram_clk_disable_P3 (dfi1_dram_clk_disable_P3),
 
  .phymstr_state_sel(dfi1_phymstr_state_sel),
  .phymstr_cs_state (dfi1_phymstr_cs_state),
  .phymstr_type     (dfi1_phymstr_type),

  .error           (dfi1_error),
  .error_info      (dfi1_error_info),
  //DFI VIP - dfi data
  .dfi_wrdata_P0			(dfi1_wrdata_P0     ),
  .dfi_wrdata_P1			(dfi1_wrdata_P1     ),
  .dfi_wrdata_P2			(dfi1_wrdata_P2     ),
  .dfi_wrdata_P3			(dfi1_wrdata_P3     ),
  .dfi_wrdata_cs_n_P0			(dfi1_wrdata_cs_P0),
  .dfi_wrdata_cs_n_P1			(dfi1_wrdata_cs_P1),
  .dfi_wrdata_cs_n_P2			(dfi1_wrdata_cs_P2),
  .dfi_wrdata_cs_n_P3			(dfi1_wrdata_cs_P3),
  .dfi_rddata_cs_n_P0			(dfi1_rddata_cs_P0),
  .dfi_rddata_cs_n_P1			(dfi1_rddata_cs_P1),
  .dfi_rddata_cs_n_P2			(dfi1_rddata_cs_P2),
  .dfi_rddata_cs_n_P3			(dfi1_rddata_cs_P3),
  .dfi_wrdata_en_P0			(dfi1_wrdata_en_P0  ),
  .dfi_wrdata_en_P1			(dfi1_wrdata_en_P1  ),
  .dfi_wrdata_en_P2			(dfi1_wrdata_en_P2  ),
  .dfi_wrdata_en_P3			(dfi1_wrdata_en_P3  ),
  .dfi_wrdata_mask_P0			(dfi1_wrdata_mask_P0),
  .dfi_wrdata_mask_P1			(dfi1_wrdata_mask_P1),
  .dfi_wrdata_mask_P2			(dfi1_wrdata_mask_P2),
  .dfi_wrdata_mask_P3			(dfi1_wrdata_mask_P3),
  .dfi_rddata_en_P0			(dfi1_rddata_en_P0),
  .dfi_rddata_en_P1			(dfi1_rddata_en_P1),
  .dfi_rddata_en_P2			(dfi1_rddata_en_P2),
  .dfi_rddata_en_P3			(dfi1_rddata_en_P3),
  .dfi_rddata_valid_W0			(dfi1_rddata_valid_W0),
  .dfi_rddata_valid_W1			(dfi1_rddata_valid_W1),
  .dfi_rddata_valid_W2			(dfi1_rddata_valid_W2),
  .dfi_rddata_valid_W3			(dfi1_rddata_valid_W3),
  .dfi_rddata_dbi_W0			(dfi1_rddata_dbi_W0),
  .dfi_rddata_dbi_W1			(dfi1_rddata_dbi_W1),
  .dfi_rddata_dbi_W2			(dfi1_rddata_dbi_W2),
  .dfi_rddata_dbi_W3			(dfi1_rddata_dbi_W3),
  .dfi_rddata_W0			(dfi1_rddata_W0),
  .dfi_rddata_W1			(dfi1_rddata_W1),
  .dfi_rddata_W2			(dfi1_rddata_W2),
  .dfi_rddata_W3			(dfi1_rddata_W3)

);
`endif
`endif


//-----------------------------------------------------------------
// APB model
//-----------------------------------------------------------------
`ifdef SVT_APB
svt_apb_uvmvlog apb (
  .pclk 	(apb_clk),
  .paddr	(paddr),
  .pwrite	(pwrite),
  .psel		(psel),
  .penable	(penable),
  .pwdata	(pwdata),
  .pready	(pready),
  .prdata	(prdata),
  .pslverr      (pslverr)
);
`else
apb_drv apb (
  .pclk 	(apb_clk),
  .paddr	(paddr),
  .pwrite	(pwrite),
  .psel		(psel),
  .penable	(penable),
  .pwdata	(pwdata),
  .pready	(pready),
  .prdata	(prdata),
  .pslverr      (pslverr)
);
`endif

//-----------------------------------------------------------------
// CLK, RST Generator
//-----------------------------------------------------------------
clk_rst_drv      clk_rst_drv (
  .apb_clk       (apb_clk    ),
  .dfi_clk 	 (dfi_clk    ),
  .dfi_phy_clk 	 (dfi_phy_clk),
  .dfi_ctl_clk 	 (dfi_ctl_clk),
  .bypass_clk 	 (bypass_clk ),
  .tdr_clk	 (TDRCLK     ),
  .tdr_reset     (WRSTN      ),
  .pwrok_in 	 (PwrOkIn   ),
  .retention (BP_RET ),
  .reset 	 (Reset      ),
  .presetn 	 (presetn    ),
  .dfi_reset_n   (dfi_reset_n),
  .vddq 	 (vddq       ),
  .vaa 		 (vaa 	     ), 
  .vdd           (vdd        )
);     


//-----------------------------------------------------------------
// JTAG model
//-----------------------------------------------------------------
jtag_drv jtag (
.DdrPhyCsrCmdTdrCaptureEn    (DdrPhyCsrCmdTdrCaptureEn),
.DdrPhyCsrCmdTdrShiftEn      (DdrPhyCsrCmdTdrShiftEn ),
.DdrPhyCsrCmdTdrUpdateEn     (DdrPhyCsrCmdTdrUpdateEn),
.DdrPhyCsrCmdTdr_Tdo         (DdrPhyCsrCmdTdr_Tdo    ),
.DdrPhyCsrRdDataTdrCaptureEn (DdrPhyCsrRdDataTdrCaptureEn ),
.DdrPhyCsrRdDataTdrShiftEn   (DdrPhyCsrRdDataTdrShiftEn   ),
.DdrPhyCsrRdDataTdrUpdateEn  (DdrPhyCsrRdDataTdrUpdateEn  ),
.DdrPhyCsrRdDataTdr_Tdo      (DdrPhyCsrRdDataTdr_Tdo      ),
.TDRCLK                      (TDRCLK  ),
.WRSTN                       (   ),
.WSI                         (WSI     )
);

// ----------------------------------------------------------------------------------
// SRAM Instances
// ----------------------------------------------------------------------------------
// 
dwc_ddrphy_pmu_srams u_srams (
  .iccm_data_ce     (iccm_data_ce  ),
  .iccm_data_addr   (iccm_data_addr),
  .iccm_data_din    (iccm_data_din ),
  .iccm_data_we     (iccm_data_we  ),
  .iccm_data_dout   (iccm_data_dout),

  .dccm_data_ce     (dccm_data_ce  ),
  .dccm_data_addr   (dccm_data_addr),
  .dccm_data_din    (dccm_data_din ),
  .dccm_data_we     (dccm_data_we  ),
  .dccm_data_dout   (dccm_data_dout),

  .ls               (1'b0          ),
  .clk              (UcClk)
);

dwc_ddrphy_pmu_acsm_ram u_srams_acsm_1024X72 (
  .DfiClk (dfi_ctl_clk_assign),
  .addr   (acsm_data_addr ) ,
  .wr     (acsm_data_we   ) ,
  .ce     (acsm_data_ce   ) ,
  .wrdata (acsm_data_din  ) ,
  .rddata (acsm_data_dout ) 
);


// ----------------------------------------------------------------------------------
// SDRAM Instances
// ----------------------------------------------------------------------------------
`ifdef FLYOVER_TEST

`ifdef LP4_STD
  `ifndef DWC_DDRPHY_NUM_CHANNELS_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 (
        .RESET_n (),
      
        .CK_t_a  (1'b0) , // rank0
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,
        .CK_t_b  (  1'b0 ) ,  
        .CK_c_b  (  1'b1 ) ,
        .CKE_b   (  1'b0 ) ,
        .CS_b    (  1'b0 ) ,
        .CA_b    (  6'h0 ) ,
        .ODT_b   (  1'b0 ) ,
        .DQS_t_b (  2'h0 ) ,
        .DQS_c_b (  2'h0 ) ,
        .DQ_b    (       ) ,
        .DMI_b   (       )
      );  
      `ifdef RANK2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (          //rank1
        .RESET_n ( BP_MEMRESET_L ),
        
        .CK_t_a  (1'b0) ,
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,
    
        .CK_t_b  ( 1'b0 ) ,
        .CK_c_b  ( 1'b1 ) ,
        .CKE_b   ( 1'b0 ) ,
        .CS_b    ( 1'b0 ) ,
        .CA_b    ( 6'h0 ) ,
        .ODT_b   ( 1'b0 ) ,
        .DQS_t_b ( 2'h0 ) ,
        .DQS_c_b ( 2'h0 ) ,
        .DQ_b    (      ) ,
        .DMI_b   (      )
      );
      `endif//RANK2 
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
      lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 (        //rank0
        .RESET_n () ,
        .CK_t_a  (1'b0) ,
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,
    
        .CK_t_b  (1'b0) ,
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
      );  
      `ifdef RANK2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (          //rank1
        .RESET_n (),
        
        .CK_t_a  (1'b0) ,
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,
    
        .CK_t_b  (1'b0) ,
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
      );
      `endif//RANK2 
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `else//DWC_DDRPHY_NUM_CHANNELS_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 ( //rank0
        .RESET_n () ,
        .CK_t_a  (1'b0) , //channelA
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,

        .CK_t_b  (1'b0) , //channelB
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
      );
      `ifdef RANK2  
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (  //rank1
        .RESET_n () ,
        .CK_t_a  (1'b0) , //channelA
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,

        .CK_t_b  (1'b0) , //channelB
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
      );
      `endif  //RANK2
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 (          //channelA rank0
        .RESET_n () ,

        .CK_t_a  (1'b0) ,
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,

        .CK_t_b  (1'b0) ,
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
          );  
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (       //channelB rank0
        .RESET_n () ,

        .CK_t_a  (1'b0) ,
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,

        .CK_t_b  (1'b0) ,
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
      );
      `ifdef RANK2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram3") U_lpddr4_dram3 (         //channelA rank1
        .RESET_n () ,

        .CK_t_a  (1'b0) ,
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,

        .CK_t_b  (1'b0) ,
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
      );  
      lpddr4_dram_uvmvlog #("U_lpddr4_dram4") U_lpddr4_dram4 (             //channelB rank1
        .RESET_n () ,

        .CK_t_a  (1'b0) ,
        .CK_c_a  (1'b1) ,
        .CKE_a   () ,
        .CS_a    () ,
        .CA_a    () ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a () ,
        .DQS_c_a () ,
        .DQ_a    () ,
        .DMI_a   () ,

        .CK_t_b  (1'b0) ,
        .CK_c_b  (1'b1) ,
        .CKE_b   () ,
        .CS_b    () ,
        .CA_b    () ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b () ,
        .DQS_c_b () ,
        .DQ_b    () ,
        .DMI_b   ()
      );
      `endif//RANK2
    `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `endif  // DWC_DDRPHY_NUM_CHANNELS_2
`endif //LP4_STD

`ifdef LP5_STD

lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if0"),.idx("0")) lpddr5_svt_if0 (           //channel0 rank0
  .ck_t_a        (1'b0)
  ,.ck_c_a       (1'b1)
  ,.ca_a         ()
  ,.ca_b         ()
  ,.cs_p_a       ()
  ,.wck_t_a      ()
  ,.wck_c_a      ()

  ,.rdqs_t_a     ()
  ,.rdqs_c_a     ()
  ,.rdqs_t_b     ()
  ,.rdqs_c_b     ()
  ,.dq_a         ()
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ()
  `else
  ,.dq_b         (16'b0)
  `endif
  ,.ck_t_b       (1'b0)
  ,.ck_c_b       (1'b1)
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       ()
  `else
  ,.cs_p_b       (1'b0)
  `endif     
  ,.wck_t_b      ()
  ,.wck_c_b      ()
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ()
  ,.dmi_b        ()
`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
  ,.dmi_a        ()
  ,.dmi_b        ()
`endif
  ,.reset_n      ()
  ,.zq           (1'b1)
  );



  lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if1"),.idx("1")) lpddr5_svt_if1 (        //channel0 rank1
  .ck_t_a        (1'b0)
  ,.ck_c_a       (1'b1)
  ,.ca_a         ()
  ,.ca_b         ()
  //,.cs_p_a       (BP_DFI0_LP4CKE_LP5CS[1] &  cs_active[1])
  ,.cs_p_a       ()
  ,.wck_t_a      ()
  ,.wck_c_a      ()
  ,.rdqs_t_a     ()
  ,.rdqs_c_a     ()
  ,.rdqs_t_b     ()
  ,.rdqs_c_b     ()
  ,.dq_a         ()
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ()
  `else
  ,.dq_b         (16'b0)
  `endif
  ,.ck_t_b       (1'b0)
  ,.ck_c_b       (1'b1)
  //,.cs_p_b       ((4/1 == 4) ?   BP_DFI0_LP4CKE_LP5CS[1] &  cs_active[1] : 1'b0)
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       ()
  `else
  ,.cs_p_b       (1'b0)
  `endif
  ,.wck_t_b      ()
  ,.wck_c_b      ()
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ()
  ,.dmi_b        ()
`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
  ,.dmi_a        ()
  ,.dmi_b        ()
`endif
  ,.reset_n      ()
  ,.zq           (1'b1)
  );

  `ifdef DWC_DDRPHY_NUM_CHANNELS_2


  lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if2"),.idx("2")) lpddr5_svt_if2 (           //channel1 rank0
  .ck_t_a        (1'b0) 
  ,.ck_c_a       (1'b1)
  ,.ca_a         ()
  ,.ca_b         ()
  ,.cs_p_a       ()
  ,.wck_t_a      ()
  ,.wck_c_a      ()
  ,.rdqs_t_a     ()
  ,.rdqs_c_a     ()
  ,.rdqs_t_b     ()
  ,.rdqs_c_b     ()
  ,.dq_a         ()
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ()
  `else
  ,.dq_b         (16'b0)
  `endif
  
  ,.ck_t_b       (1'b0)
  ,.ck_c_b       (1'b1)
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       ()
  `else
  ,.cs_p_b       (1'b0)
  `endif
  ,.wck_t_b      ()
  ,.wck_c_b      ()
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ()
  ,.dmi_b        ()
`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
  ,.dmi_a        ()
  ,.dmi_b        ()
`endif
  ,.reset_n      ()
  ,.zq           (1'b1)
  );



  lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if3"),.idx("3")) lpddr5_svt_if3 (          //channel1 rank1
  .ck_t_a        (1'b0)
  ,.ck_c_a       (1'b1)
  ,.ca_a         ()
  ,.ca_b         ()
  ,.cs_p_a       ()
  ,.wck_t_a      ()
  ,.wck_c_a      ()
  ,.rdqs_t_a     ()
  ,.rdqs_c_a     ()
  ,.rdqs_t_b     ()
  ,.rdqs_c_b     ()
  ,.dq_a         ()
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ()
  `else
  ,.dq_b         (16'b0)
  `endif

  ,.ck_t_b       (1'b0)
  ,.ck_c_b       (1'b1)
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       ()
  `else
  ,.cs_p_b       (1'b0)
  `endif
  ,.wck_t_b      ()
  ,.wck_c_b      ()
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ()
  ,.dmi_b        ()
`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
  ,.dmi_a        ()
  ,.dmi_b        ()
`endif
  ,.reset_n      ()
  ,.zq           (1'b1)
  );
  `endif
`endif


`else
   ////////////////////////////////////////////////////////////////////////////NOT flyover
bit [3:0] csAct0;
bit [3:0] csAct1;
bit [1:0] csActDb;
assign csAct0 = cfg.NumRank_dfi0 == 4 ? 4'b1111 : cfg.NumRank_dfi0 == 3 ? 4'b0111 : cfg.NumRank_dfi0 == 2 ? 4'b0011 : 4'b0001;  
assign csAct1 = cfg.NumRank_dfi1 == 4 ? 4'b1111 : cfg.NumRank_dfi1 == 3 ? 4'b0111 : cfg.NumRank_dfi1 == 2 ? 4'b0011 : cfg.NumRank_dfi1 == 1 ? 4'b0001 : 4'b0000; 
//csActDb[0]=1: cha enable; csActDb[1]=1: chb enable
assign csActDb = cfg.NumActiveDbyteDfi0 == 2 ? 2'b01 : 2'b11;

`ifdef LP4_STD
  `ifndef DWC_DDRPHY_NUM_CHANNELS_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 (
        .RESET_n ( BP_MEMRESET_L ),
      
        .CK_t_a  ( BP_DFI0_CK_T                        ) , // rank0
        .CK_c_a  ( BP_DFI0_CK_C                        ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[0]             ) ,
        .CS_a    ( BP_DFI0_CA[6]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,
        .CK_t_b  (  1'b0 ) ,  
        .CK_c_b  (  1'b1 ) ,
        .CKE_b   (  1'b0 ) ,
        .CS_b    (  1'b0 ) ,
        .CA_b    (  6'h0 ) ,
        .ODT_b   (  1'b0 ) ,
        .DQS_t_b (  2'h0 ) ,
        .DQS_c_b (  2'h0 ) ,
        .DQ_b    (       ) ,
        .DMI_b   (       )
      );  
      `ifdef RANK2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (          //rank1
        .RESET_n ( BP_MEMRESET_L ),
        
        .CK_t_a  ( csAct0[1] ? BP_DFI0_CK_T : 1'b0     ) ,
        .CK_c_a  ( csAct0[1] ? BP_DFI0_CK_C : 1'b1     ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[1]             ) ,
        .CS_a    ( BP_DFI0_CA[7]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,
    
        .CK_t_b  ( 1'b0 ) ,
        .CK_c_b  ( 1'b1 ) ,
        .CKE_b   ( 1'b0 ) ,
        .CS_b    ( 1'b0 ) ,
        .CA_b    ( 6'h0 ) ,
        .ODT_b   ( 1'b0 ) ,
        .DQS_t_b ( 2'h0 ) ,
        .DQS_c_b ( 2'h0 ) ,
        .DQ_b    (      ) ,
        .DMI_b   (      )
      );
      `endif//RANK2 
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
      lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 (        //rank0
        .RESET_n ( BP_MEMRESET_L                       ) ,
        .CK_t_a  ( BP_DFI0_CK_T                        ) ,
        .CK_c_a  ( BP_DFI0_CK_C                        ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[0]             ) ,
        .CS_a    ( BP_DFI0_CA[6]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,
    
        .CK_t_b  ( BP_DFI0_CK_T                        ) ,
        .CK_c_b  ( BP_DFI0_CK_C                        ) ,
        .CKE_b   ( BP_DFI0_LP4CKE_LP5CS[0]             ) ,
        .CS_b    ( BP_DFI0_CA[6]                       ) ,
        .CA_b    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI0_B3_DQS_T,BP_DFI0_B2_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI0_B3_DQS_C,BP_DFI0_B2_DQS_C} ) ,
        .DQ_b    ( {BP_DFI0_B3_D,    BP_DFI0_B2_D}     ) ,
        .DMI_b   ( {BP_DFI0_B3_DMI,  BP_DFI0_B2_DMI}   )
      );  
      `ifdef RANK2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (          //rank1
        .RESET_n ( BP_MEMRESET_L ),
        
        .CK_t_a  ( csAct0[1] ? BP_DFI0_CK_T : 1'b0     ) ,
        .CK_c_a  ( csAct0[1] ? BP_DFI0_CK_C : 1'b1     ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[1]             ) ,
        .CS_a    ( BP_DFI0_CA[7]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,
    
        .CK_t_b  ( BP_DFI0_CK_T                        ) ,
        .CK_c_b  ( BP_DFI0_CK_C                        ) ,
        .CKE_b   ( BP_DFI0_LP4CKE_LP5CS[1]             ) ,
        .CS_b    ( BP_DFI0_CA[7]                       ) ,
        .CA_b    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI0_B3_DQS_T,BP_DFI0_B2_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI0_B3_DQS_C,BP_DFI0_B2_DQS_C} ) ,
        .DQ_b    ( {BP_DFI0_B3_D,    BP_DFI0_B2_D}     ) ,
        .DMI_b   ( {BP_DFI0_B3_DMI,  BP_DFI0_B2_DMI}   )
      );
      `endif//RANK2 
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `else//DWC_DDRPHY_NUM_CHANNELS_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 ( //rank0
        .RESET_n ( BP_MEMRESET_L                       ) ,
        .CK_t_a  ( BP_DFI0_CK_T                        ) , //channelA
        .CK_c_a  ( BP_DFI0_CK_C                        ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[0]             ) ,
        .CS_a    ( BP_DFI0_CA[6]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,

        .CK_t_b  ( csAct1[0] ? BP_DFI1_CK_T : 1'b0     ) , //channelB
        .CK_c_b  ( csAct1[0] ? BP_DFI1_CK_C : 1'b1     ) ,
        .CKE_b   ( BP_DFI1_LP4CKE_LP5CS[0]             ) ,
        .CS_b    ( BP_DFI1_CA[6]                       ) ,
        .CA_b    ( BP_DFI1_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI1_B1_DQS_T,BP_DFI1_B0_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI1_B1_DQS_C,BP_DFI1_B0_DQS_C} ) ,
        .DQ_b    ( {BP_DFI1_B1_D,BP_DFI1_B0_D}         ) ,
        .DMI_b   ( {BP_DFI1_B1_DMI,BP_DFI1_B0_DMI}     )
      );
      `ifdef RANK2  
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (  //rank1
        .RESET_n ( BP_MEMRESET_L                       ) ,
        .CK_t_a  ( csAct0[1] ? BP_DFI0_CK_T : 1'b0     ) , //channelA
        .CK_c_a  ( csAct0[1] ? BP_DFI0_CK_C : 1'b1     ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[1]             ) ,
        .CS_a    ( BP_DFI0_CA[7]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,

        .CK_t_b  ( csAct1[1] ? BP_DFI1_CK_T : 1'b0     ) , //channelB
        .CK_c_b  ( csAct1[1] ? BP_DFI1_CK_C : 1'b1     ) ,
        .CKE_b   ( BP_DFI1_LP4CKE_LP5CS[1]             ) ,
        .CS_b    ( BP_DFI1_CA[7]                       ) ,
        .CA_b    ( BP_DFI1_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI1_B1_DQS_T,BP_DFI1_B0_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI1_B1_DQS_C,BP_DFI1_B0_DQS_C} ) ,
        .DQ_b    ( {BP_DFI1_B1_D,BP_DFI1_B0_D}         ) ,
        .DMI_b   ( {BP_DFI1_B1_DMI,BP_DFI1_B0_DMI}     )
      );
      `endif  //RANK2
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    lpddr4_dram_uvmvlog #("U_lpddr4_dram1") U_lpddr4_dram1 (          //channelA rank0
        .RESET_n ( BP_MEMRESET_L                       ) ,

        .CK_t_a  ( BP_DFI0_CK_T                        ) ,
        .CK_c_a  ( BP_DFI0_CK_C                        ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[0]             ) ,
        .CS_a    ( BP_DFI0_CA[6]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,

        .CK_t_b  ( BP_DFI0_CK_T                        ) ,
        .CK_c_b  ( BP_DFI0_CK_C                        ) ,
        .CKE_b   ( BP_DFI0_LP4CKE_LP5CS[0]             ) ,
        .CS_b    ( BP_DFI0_CA[6]                       ) ,
        .CA_b    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI0_B3_DQS_T,BP_DFI0_B2_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI0_B3_DQS_C,BP_DFI0_B2_DQS_C} ) ,
        .DQ_b    ( {BP_DFI0_B3_D,BP_DFI0_B2_D}         ) ,
        .DMI_b   ( {BP_DFI0_B3_DMI,BP_DFI0_B2_DMI}     )
          );  
      lpddr4_dram_uvmvlog #("U_lpddr4_dram2") U_lpddr4_dram2 (       //channelB rank0
        .RESET_n ( BP_MEMRESET_L                       ) ,

        .CK_t_a  ( csAct1[0] ? BP_DFI1_CK_T : 1'b0     ) ,
        .CK_c_a  ( csAct1[0] ? BP_DFI1_CK_C : 1'b1     ) ,
        .CKE_a   ( BP_DFI1_LP4CKE_LP5CS[0]             ) ,
        .CS_a    ( BP_DFI1_CA[6]                       ) ,
        .CA_a    (  BP_DFI1_CA[5:0]                    ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI1_B1_DQS_T,BP_DFI1_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI1_B1_DQS_C,BP_DFI1_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI1_B1_D,BP_DFI1_B0_D}         ) ,
        .DMI_a   ( {BP_DFI1_B1_DMI,BP_DFI1_B0_DMI}     ) ,

        .CK_t_b  ( csAct1[0] ? BP_DFI1_CK_T : 1'b0     ) ,
        .CK_c_b  ( csAct1[0] ? BP_DFI1_CK_C : 1'b1     ) ,
        .CKE_b   ( BP_DFI1_LP4CKE_LP5CS[0]             ) ,
        .CS_b    ( BP_DFI1_CA[6]                       ) ,
        .CA_b    ( BP_DFI1_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI1_B3_DQS_T,BP_DFI1_B2_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI1_B3_DQS_C,BP_DFI1_B2_DQS_C} ) ,
        .DQ_b    ( {BP_DFI1_B3_D,BP_DFI1_B2_D}         ) ,
        .DMI_b   ( {BP_DFI1_B3_DMI,BP_DFI1_B2_DMI}     )
      );
      `ifdef RANK2
      lpddr4_dram_uvmvlog #("U_lpddr4_dram3") U_lpddr4_dram3 (         //channelA rank1
        .RESET_n ( BP_MEMRESET_L                       ) ,

        .CK_t_a  ( csAct0[1] ? BP_DFI0_CK_T : 1'b0     ) ,
        .CK_c_a  ( csAct0[1] ? BP_DFI0_CK_C : 1'b1     ) ,
        .CKE_a   ( BP_DFI0_LP4CKE_LP5CS[1]             ) ,
        .CS_a    ( BP_DFI0_CA[7]                       ) ,
        .CA_a    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI0_B1_D,BP_DFI0_B0_D}         ) ,
        .DMI_a   ( {BP_DFI0_B1_DMI,BP_DFI0_B0_DMI}     ) ,

        .CK_t_b  ( csAct0[1] ? BP_DFI0_CK_T : 1'b0     ) ,
        .CK_c_b  ( csAct0[1] ? BP_DFI0_CK_C : 1'b1     ) ,
        .CKE_b   ( BP_DFI0_LP4CKE_LP5CS[1]             ) ,
        .CS_b    ( BP_DFI0_CA[7]                       ) ,
        .CA_b    ( BP_DFI0_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI0_B3_DQS_T,BP_DFI0_B2_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI0_B3_DQS_C,BP_DFI0_B2_DQS_C} ) ,
        .DQ_b    ( {BP_DFI0_B3_D,BP_DFI0_B2_D}         ) ,
        .DMI_b   ( {BP_DFI0_B3_DMI,BP_DFI0_B2_DMI}     )
      );  
      lpddr4_dram_uvmvlog #("U_lpddr4_dram4") U_lpddr4_dram4 (             //channelB rank1
        .RESET_n ( BP_MEMRESET_L                       ) ,

        .CK_t_a  ( csAct1[1] ? BP_DFI1_CK_T : 1'b0     ) ,
        .CK_c_a  ( csAct1[1] ? BP_DFI1_CK_C : 1'b1     ) ,
        .CKE_a   ( BP_DFI1_LP4CKE_LP5CS[1]             ) ,
        .CS_a    ( BP_DFI1_CA[7]                       ) ,
        .CA_a    (  BP_DFI1_CA[5:0]                    ) ,
        .ODT_a   ( 1'b0                                ) ,
        .DQS_t_a ( {BP_DFI1_B1_DQS_T,BP_DFI1_B0_DQS_T} ) ,
        .DQS_c_a ( {BP_DFI1_B1_DQS_C,BP_DFI1_B0_DQS_C} ) ,
        .DQ_a    ( {BP_DFI1_B1_D,BP_DFI1_B0_D}         ) ,
        .DMI_a   ( {BP_DFI1_B1_DMI,BP_DFI1_B0_DMI}     ) ,

        .CK_t_b  ( csAct1[1] ? BP_DFI1_CK_T : 1'b0     ) ,
        .CK_c_b  ( csAct1[1] ? BP_DFI1_CK_C : 1'b1     ) ,
        .CKE_b   ( BP_DFI1_LP4CKE_LP5CS[1]             ) ,
        .CS_b    ( BP_DFI1_CA[7]                       ) ,
        .CA_b    ( BP_DFI1_CA[5:0]                     ) ,
        .ODT_b   ( 1'b0                                ) ,
        .DQS_t_b ( {BP_DFI1_B3_DQS_T,BP_DFI1_B2_DQS_T} ) ,
        .DQS_c_b ( {BP_DFI1_B3_DQS_C,BP_DFI1_B2_DQS_C} ) ,
        .DQ_b    ( {BP_DFI1_B3_D,BP_DFI1_B2_D}         ) ,
        .DMI_b   ( {BP_DFI1_B3_DMI,BP_DFI1_B2_DMI}     )
      );
      `endif//RANK2
    `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `endif  // DWC_DDRPHY_NUM_CHANNELS_2
`endif //LP4_STD

genvar i;
`ifdef LP5_STD
wire [1:0] if0_dmi_a_in, if0_dmi_b_in;
for(i=0; i<2; i=i+1)begin
  assign if0_dmi_a_in[i] = (test.top.lpddr5_svt_if0.memory_if.channel_a_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if0.memory_if.channel_a_if.dmi_o_en[i]) ? 1'bz : 1'b0;
  assign if0_dmi_b_in[i] = (test.top.lpddr5_svt_if0.memory_if.channel_b_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if0.memory_if.channel_b_if.dmi_o_en[i]) ? 1'bz : 1'b0;
end

lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if0"),.idx("0")) lpddr5_svt_if0 (           //channel0 rank0
  .ck_t_a        (BP_DFI0_CK_T)
  ,.ck_c_a       (BP_DFI0_CK_C)
  ,.ca_a         (BP_DFI0_CA[6:0])
  ,.ca_b         (BP_DFI0_CA[6:0])
  ,.cs_p_a       (BP_DFI0_LP4CKE_LP5CS[0] & csAct0[0])
  ,.wck_t_a      ({BP_DFI0_B1_WCK_T,BP_DFI0_B0_WCK_T})
  ,.wck_c_a      ({BP_DFI0_B1_WCK_C,BP_DFI0_B0_WCK_C})

  ,.rdqs_t_a     ({BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T})
  ,.rdqs_c_a     ({BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C})
  ,.rdqs_t_b     ({BP_DFI0_B3_DQS_T,BP_DFI0_B2_DQS_T})
  ,.rdqs_c_b     ({BP_DFI0_B3_DQS_C,BP_DFI0_B2_DQS_C})
  ,.dq_a         ({BP_DFI0_B1_D,BP_DFI0_B0_D})
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ({BP_DFI0_B3_D,BP_DFI0_B2_D})
  `else
  ,.dq_b         (16'b0)
  `endif
  ,.ck_t_b       (BP_DFI0_CK_T & csActDb[1])
  ,.ck_c_b       (BP_DFI0_CK_C & csActDb[1])
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       (BP_DFI0_LP4CKE_LP5CS[0] & csAct0[0])
  `else
  ,.cs_p_b       (1'b0)
  `endif     
  ,.wck_t_b      ({BP_DFI0_B3_WCK_T,BP_DFI0_B2_WCK_T})
  ,.wck_c_b      ({BP_DFI0_B3_WCK_C,BP_DFI0_B2_WCK_C})
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ({BP_DFI0_B1_DMI,BP_DFI0_B0_DMI})
  ,.dmi_b        ({BP_DFI0_B3_DMI,BP_DFI0_B2_DMI})
//`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
//  ,.dmi_a        (if0_dmi_a_in)
//  ,.dmi_b        (if0_dmi_b_in)
`endif
  ,.reset_n      (BP_MEMRESET_L)
  ,.zq           (1'b1)
  );

wire [1:0] if1_dmi_a_in, if1_dmi_b_in;
for(i=0; i<2; i=i+1)begin
  assign if1_dmi_a_in[i] = (test.top.lpddr5_svt_if1.memory_if.channel_a_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if1.memory_if.channel_a_if.dmi_o_en[i]) ? 1'bz : 1'b0;
  assign if1_dmi_b_in[i] = (test.top.lpddr5_svt_if1.memory_if.channel_b_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if1.memory_if.channel_b_if.dmi_o_en[i]) ? 1'bz : 1'b0;
end

  lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if1"),.idx("1")) lpddr5_svt_if1 (        //channel0 rank1
  .ck_t_a        (BP_DFI0_CK_T & csAct0[1])
  ,.ck_c_a       (BP_DFI0_CK_C & csAct0[1])
  ,.ca_a         (BP_DFI0_CA[6:0])
  ,.ca_b         (BP_DFI0_CA[6:0])
  //,.cs_p_a       (BP_DFI0_LP4CKE_LP5CS[1] &  cs_active[1])
  ,.cs_p_a       (BP_DFI0_LP4CKE_LP5CS[1] & csAct0[1])
  ,.wck_t_a      ({BP_DFI0_B1_WCK_T,BP_DFI0_B0_WCK_T})
  ,.wck_c_a      ({BP_DFI0_B1_WCK_C,BP_DFI0_B0_WCK_C})
  ,.rdqs_t_a     ({BP_DFI0_B1_DQS_T,BP_DFI0_B0_DQS_T})
  ,.rdqs_c_a     ({BP_DFI0_B1_DQS_C,BP_DFI0_B0_DQS_C})
  ,.rdqs_t_b     ({BP_DFI0_B3_DQS_T,BP_DFI0_B2_DQS_T})
  ,.rdqs_c_b     ({BP_DFI0_B3_DQS_C,BP_DFI0_B2_DQS_C})
  ,.dq_a         ({BP_DFI0_B1_D,BP_DFI0_B0_D})
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ({BP_DFI0_B3_D,BP_DFI0_B2_D})
  `else
  ,.dq_b         (16'b0)
  `endif
  ,.ck_t_b       (BP_DFI0_CK_T & csAct0[1] & csActDb[1])
  ,.ck_c_b       (BP_DFI0_CK_C & csAct0[1] & csActDb[1])
  //,.cs_p_b       ((4/1 == 4) ?   BP_DFI0_LP4CKE_LP5CS[1] &  cs_active[1] : 1'b0)
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       (BP_DFI0_LP4CKE_LP5CS[1] & csAct0[1])
  `else
  ,.cs_p_b       (1'b0)
  `endif
  ,.wck_t_b      ({BP_DFI0_B3_WCK_T,BP_DFI0_B2_WCK_T})
  ,.wck_c_b      ({BP_DFI0_B3_WCK_C,BP_DFI0_B2_WCK_C})
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ({BP_DFI0_B1_DMI,BP_DFI0_B0_DMI})
  ,.dmi_b        ({BP_DFI0_B3_DMI,BP_DFI0_B2_DMI})
//`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
//  ,.dmi_a        (if1_dmi_a_in)
//  ,.dmi_b        (if1_dmi_b_in)
`endif
  ,.reset_n      (BP_MEMRESET_L)
  ,.zq           (1'b1)
  );

  `ifdef DWC_DDRPHY_NUM_CHANNELS_2
wire [1:0] if2_dmi_a_in, if2_dmi_b_in;
for(i=0; i<2; i=i+1)begin
  assign if2_dmi_a_in[i] = (test.top.lpddr5_svt_if2.memory_if.channel_a_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if2.memory_if.channel_a_if.dmi_o_en[i]) ? 1'bz : 1'b0;
  assign if2_dmi_b_in[i] = (test.top.lpddr5_svt_if2.memory_if.channel_b_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if2.memory_if.channel_b_if.dmi_o_en[i]) ? 1'bz : 1'b0;
end

  lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if2"),.idx("2")) lpddr5_svt_if2 (           //channel1 rank0
  .ck_t_a        (BP_DFI1_CK_T & csAct1[0]) 
  ,.ck_c_a       (BP_DFI1_CK_C & csAct1[0])
  ,.ca_a         (BP_DFI1_CA[6:0])
  ,.ca_b         (BP_DFI1_CA[6:0])
  ,.cs_p_a       ((BP_DFI1_LP4CKE_LP5CS[0] & csAct1[0]))
  ,.wck_t_a      ({BP_DFI1_B1_WCK_T,BP_DFI1_B0_WCK_T})
  ,.wck_c_a      ({BP_DFI1_B1_WCK_C,BP_DFI1_B0_WCK_C})
  ,.rdqs_t_a     ({BP_DFI1_B1_DQS_T,BP_DFI1_B0_DQS_T})
  ,.rdqs_c_a     ({BP_DFI1_B1_DQS_C,BP_DFI1_B0_DQS_C})
  ,.rdqs_t_b     ({BP_DFI1_B3_DQS_T,BP_DFI1_B2_DQS_T})
  ,.rdqs_c_b     ({BP_DFI1_B3_DQS_C,BP_DFI1_B2_DQS_C})
  ,.dq_a         ({BP_DFI1_B1_D,BP_DFI1_B0_D})
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ({BP_DFI1_B3_D,BP_DFI1_B2_D})
  `else
  ,.dq_b         (16'b0)
  `endif
  
  ,.ck_t_b       (BP_DFI1_CK_T & csAct1[0] & csActDb[1])
  ,.ck_c_b       (BP_DFI1_CK_C & csAct1[0] & csActDb[1])
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       (BP_DFI1_LP4CKE_LP5CS[0] & csAct1[0])
  `else
  ,.cs_p_b       (1'b0)
  `endif
  ,.wck_t_b      ({BP_DFI1_B3_WCK_T,BP_DFI1_B2_WCK_T})
  ,.wck_c_b      ({BP_DFI1_B3_WCK_C,BP_DFI1_B2_WCK_C})
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ({BP_DFI1_B1_DMI,BP_DFI1_B0_DMI})
  ,.dmi_b        ({BP_DFI1_B3_DMI,BP_DFI1_B2_DMI})
//`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
//  ,.dmi_a        (if2_dmi_a_in)
//  ,.dmi_b        (if2_dmi_b_in)
`endif
  ,.reset_n      (BP_MEMRESET_L)
  ,.zq           (1'b1)
  );

wire [1:0] if3_dmi_a_in, if3_dmi_b_in;
for(i=0; i<2; i=i+1)begin
  assign if3_dmi_a_in[i] = (test.top.lpddr5_svt_if3.memory_if.channel_a_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if3.memory_if.channel_a_if.dmi_o_en[i]) ? 1'bz : 1'b0;
  assign if3_dmi_b_in[i] = (test.top.lpddr5_svt_if3.memory_if.channel_b_if.dmi_en[i] & 
                            test.top.lpddr5_svt_if3.memory_if.channel_b_if.dmi_o_en[i]) ? 1'bz : 1'b0;
end

  lpddr5_dual_chan_uvmvlog #(.name("lpddr5_svt_if3"),.idx("3")) lpddr5_svt_if3 (          //channel1 rank1
  .ck_t_a        (BP_DFI1_CK_T & csAct1[1])
  ,.ck_c_a       (BP_DFI1_CK_C & csAct1[1])
  ,.ca_a         (BP_DFI1_CA[6:0])
  ,.ca_b         (BP_DFI1_CA[6:0])
  ,.cs_p_a       (BP_DFI1_LP4CKE_LP5CS[1] & csAct1[1])
  ,.wck_t_a      ({BP_DFI1_B1_WCK_T,BP_DFI1_B0_WCK_T})
  ,.wck_c_a      ({BP_DFI1_B1_WCK_C,BP_DFI1_B0_WCK_C})
  ,.rdqs_t_a     ({BP_DFI1_B1_DQS_T,BP_DFI1_B0_DQS_T})
  ,.rdqs_c_a     ({BP_DFI1_B1_DQS_C,BP_DFI1_B0_DQS_C})
  ,.rdqs_t_b     ({BP_DFI1_B3_DQS_T,BP_DFI1_B2_DQS_T})
  ,.rdqs_c_b     ({BP_DFI1_B3_DQS_C,BP_DFI1_B2_DQS_C})
  ,.dq_a         ({BP_DFI1_B1_D,BP_DFI1_B0_D})
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.dq_b         ({BP_DFI1_B3_D,BP_DFI1_B2_D})
  `else
  ,.dq_b         (16'b0)
  `endif

  ,.ck_t_b       (BP_DFI1_CK_T & csAct1[1] & csActDb[1])
  ,.ck_c_b       (BP_DFI1_CK_C & csAct1[1] & csActDb[1])
  `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  ,.cs_p_b       (BP_DFI1_LP4CKE_LP5CS[1] & csAct1[1])
  `else
  ,.cs_p_b       (1'b0)
  `endif
  ,.wck_t_b      ({BP_DFI1_B3_WCK_T,BP_DFI1_B2_WCK_T})
  ,.wck_c_b      ({BP_DFI1_B3_WCK_C,BP_DFI1_B2_WCK_C})
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
  ,.dmi_a        ({BP_DFI1_B1_DMI,BP_DFI1_B0_DMI})
  ,.dmi_b        ({BP_DFI1_B3_DMI,BP_DFI1_B2_DMI})
//`else //LPDDR5 JEDEC Spec, Section 7.4.10.1 - Valid data input: High or low input is required. These data are not required to have any meaning
//  ,.dmi_a        (if3_dmi_a_in)
//  ,.dmi_b        (if3_dmi_b_in)
`endif
  ,.reset_n      (BP_MEMRESET_L)
  ,.zq           (1'b1)
  );
  `endif
`endif

`endif

`ifdef DWC_DDRPHY_GATESIM_SDF
initial begin
  `ifdef DWC_DDRPHY_EXISTS_AC0
        $sdf_annotate(`AC0_SEC_SDF,  top.dut.u_AC_WRAPPER_0.SEC_0 ,, "ac0_sec0_sdf.log", `spec);
        $sdf_annotate(`AC0_DIFF_SDF, top.dut.u_AC_WRAPPER_0.DIFF_CK ,, "ac0_diff_ck_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_0 ,, "ac0_se0_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_1 ,, "ac0_se1_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_2 ,, "ac0_se2_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_3 ,, "ac0_se3_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_4 ,, "ac0_se4_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_5 ,, "ac0_se5_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_6 ,, "ac0_se6_sdf.log", `spec);
    `ifdef DWC_DDRPHY_NUM_RANKS_2
        $sdf_annotate(`AC0_SEC_SDF,  top.dut.u_AC_WRAPPER_0.SEC_1 ,, "ac0_sec1_sdf.log", `spec);
        $sdf_annotate(`AC0_SE_SDF,   top.dut.u_AC_WRAPPER_0.SE_7 ,, "ac0_se7_sdf.log", `spec);
    `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_AC1
        $sdf_annotate(`AC1_SEC_SDF,  top.dut.u_AC_WRAPPER_1.SEC_0 ,, "ac1_sec0_sdf.log", `spec);
        $sdf_annotate(`AC1_DIFF_SDF, top.dut.u_AC_WRAPPER_1.DIFF_CK ,, "ac1_diff_ck_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_0 ,, "ac1_se0_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_1 ,, "ac1_se1_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_2 ,, "ac1_se2_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_3 ,, "ac1_se3_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_4 ,, "ac1_se4_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_5 ,, "ac1_se5_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_6 ,, "ac1_se6_sdf.log", `spec);
    `ifdef DWC_DDRPHY_NUM_RANKS_2
        $sdf_annotate(`AC1_SEC_SDF,  top.dut.u_AC_WRAPPER_1.SEC_1 ,, "ac1_sec1_sdf.log", `spec);
        $sdf_annotate(`AC1_SE_SDF,   top.dut.u_AC_WRAPPER_1.SE_7 ,, "ac1_se7_sdf.log", `spec);
    `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB0
        $sdf_annotate(`DBYTE0_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS ,, "dbyte0_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK ,, "dbyte0_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_0 ,, "dbyte0_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_1 ,, "dbyte0_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_2 ,, "dbyte0_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_3 ,, "dbyte0_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_4 ,, "dbyte0_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_5 ,, "dbyte0_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_6 ,, "dbyte0_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_7 ,, "dbyte0_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE0_SE_SDF,   top.dut.u_DBYTE_WRAPPER_0.SE_8 ,, "dbyte0_se8_sdf.log", `spec);
        `endif 

  `endif 
  `ifdef DWC_DDRPHY_EXISTS_DB1
        $sdf_annotate(`DBYTE1_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS ,, "dbyte1_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK ,, "dbyte1_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_0 ,, "dbyte1_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_1 ,, "dbyte1_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_2 ,, "dbyte1_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_3 ,, "dbyte1_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_4 ,, "dbyte1_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_5 ,, "dbyte1_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_6 ,, "dbyte1_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_7 ,, "dbyte1_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE1_SE_SDF,   top.dut.u_DBYTE_WRAPPER_1.SE_8 ,, "dbyte1_se8_sdf.log", `spec);
        `endif
  `endif 
  `ifdef DWC_DDRPHY_EXISTS_DB2
        $sdf_annotate(`DBYTE2_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS ,, "dbyte2_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK ,, "dbyte2_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_0 ,, "dbyte2_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_1 ,, "dbyte2_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_2 ,, "dbyte2_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_3 ,, "dbyte2_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_4 ,, "dbyte2_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_5 ,, "dbyte2_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_6 ,, "dbyte2_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_7 ,, "dbyte2_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE2_SE_SDF,   top.dut.u_DBYTE_WRAPPER_2.SE_8 ,, "dbyte2_se8_sdf.log", `spec);
        `endif  
  `endif 
  `ifdef DWC_DDRPHY_EXISTS_DB3
        $sdf_annotate(`DBYTE3_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS ,, "dbyte3_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK ,, "dbyte3_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_0 ,, "dbyte3_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_1 ,, "dbyte3_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_2 ,, "dbyte3_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_3 ,, "dbyte3_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_4 ,, "dbyte3_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_5 ,, "dbyte3_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_6 ,, "dbyte3_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_7 ,, "dbyte3_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE3_SE_SDF,   top.dut.u_DBYTE_WRAPPER_3.SE_8 ,, "dbyte3_se8_sdf.log", `spec);
        `endif 
  `endif 
  `ifdef DWC_DDRPHY_EXISTS_DB4
        $sdf_annotate(`DBYTE4_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS ,, "dbyte4_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK ,, "dbyte4_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_0 ,, "dbyte4_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_1 ,, "dbyte4_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_2 ,, "dbyte4_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_3 ,, "dbyte4_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_4 ,, "dbyte4_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_5 ,, "dbyte4_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_6 ,, "dbyte4_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_7 ,, "dbyte4_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE4_SE_SDF,   top.dut.u_DBYTE_WRAPPER_4.SE_8 ,, "dbyte4_se8_sdf.log", `spec);
        `endif  
  `endif 
  `ifdef DWC_DDRPHY_EXISTS_DB5
        $sdf_annotate(`DBYTE5_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS ,, "dbyte5_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK ,, "dbyte5_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_0 ,, "dbyte5_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_1 ,, "dbyte5_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_2 ,, "dbyte5_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_3 ,, "dbyte5_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_4 ,, "dbyte5_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_5 ,, "dbyte5_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_6 ,, "dbyte5_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_7 ,, "dbyte5_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE5_SE_SDF,   top.dut.u_DBYTE_WRAPPER_5.SE_8 ,, "dbyte5_se8_sdf.log", `spec);
       `endif
  `endif 
  `ifdef DWC_DDRPHY_EXISTS_DB6
        $sdf_annotate(`DBYTE6_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS ,, "dbyte6_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK ,, "dbyte6_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_0 ,, "dbyte6_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_1 ,, "dbyte6_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_2 ,, "dbyte6_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_3 ,, "dbyte6_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_4 ,, "dbyte6_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_5 ,, "dbyte6_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_6 ,, "dbyte6_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_7 ,, "dbyte6_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE6_SE_SDF,   top.dut.u_DBYTE_WRAPPER_6.SE_8 ,, "dbyte6_se8_sdf.log", `spec);
        `endif 
  `endif 
  `ifdef DWC_DDRPHY_EXISTS_DB7
        $sdf_annotate(`DBYTE7_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS ,, "dbyte7_diff_DQS_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_DIFF_SDF, top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK ,, "dbyte7_diff_WCK_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_0 ,, "dbyte7_se0_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_1 ,, "dbyte7_se1_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_2 ,, "dbyte7_se2_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_3 ,, "dbyte7_se3_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_4 ,, "dbyte7_se4_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_5 ,, "dbyte7_se5_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_6 ,, "dbyte7_se6_sdf.log", `spec);
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_7 ,, "dbyte7_se7_sdf.log", `spec);
        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
        $sdf_annotate(`DBYTE7_SE_SDF,   top.dut.u_DBYTE_WRAPPER_7.SE_8 ,, "dbyte7_se8_sdf.log", `spec);
        `endif 
  `endif
  //SDF for master
  $sdf_annotate(`MASTER_SDF, top.dut.u_DWC_DDRPHYMASTER_top ,, "master_sdf.log", `spec);
end
`endif


`ifdef DWC_DDRPHY_GATESIM_SDF
  `include "gatesim_timing_disable_list_update.sv"
  //Mantis54396 could be 150~300 per corner
  `ifdef DWC_DDRPHY_EXISTS_AC0
    defparam test.top.dut.u_AC_WRAPPER_0.SEC_0.SEC_IO.RX.pRxAnalogDly = 0;
   `ifdef DWC_DDRPHY_NUM_RANKS_2
    defparam test.top.dut.u_AC_WRAPPER_0.SEC_1.SEC_IO.RX.pRxAnalogDly = 0;
   `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_AC1
    defparam test.top.dut.u_AC_WRAPPER_1.SEC_0.SEC_IO.RX.pRxAnalogDly = 0;
   `ifdef DWC_DDRPHY_NUM_RANKS_2	
    defparam test.top.dut.u_AC_WRAPPER_1.SEC_1.SEC_IO.RX.pRxAnalogDly = 0;
   `endif
  `endif
`endif
//initial begin 
//#1;
//    `ifdef DWC_DDRPHY_UPF_SIM
//         forever begin
//          @(posedge s3Enter);
//            force dfi_reset_n = 1'bx;
//             $display("[%0t] <%m> [top]  @(posedge s3Enter)", $realtime);
//          @(negedge s3Enter);
//            release dfi_reset_n;
//            $display("[%0t] <%m> [top]  @(posedge s3Enter)", $realtime);
//
//         end
//    `endif
//end

  initial begin
    #1;
    `ifdef DWC_DDRPHY_INJECT_X  
      dis_upf_xprop = 0 ;
      dis_upf_xprop_1 = 1 ;
    `else
      dis_upf_xprop = 1 ;
      dis_upf_xprop_1 = 0 ;
    `endif
  end
 //  initial begin
 //       force test.top.dut.u_DBYTE_WRAPPER_0.SE_0.RxClkTPhase[0] = 1'b0;
 //  end


`ifdef GLITCH_CHECK
  glitch_checker_insts glitch_checker_insts();
`endif

endmodule

