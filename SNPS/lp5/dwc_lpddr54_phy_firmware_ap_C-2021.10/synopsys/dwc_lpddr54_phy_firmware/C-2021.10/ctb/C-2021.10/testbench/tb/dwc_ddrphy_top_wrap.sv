// reuse-pragma process_ifdef standard
`timescale 1ps/1ps

module dwc_ddrphy_top_wrap (

 input dfi_reset_n,
 input [141:0] atpg_PllCtrlBus,
 input         atpg_Asst_Clken,
 output        atpg_Asst_Clk,
 input         atpg_UcClk,

`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
input  [`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH-1:0] dfi0_wrdata_mask_P0,
output [`DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH-1 :0] dfi0_rddata_dbi_W0,
input  [`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH-1:0] dfi0_wrdata_mask_P1,
output [`DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH-1 :0] dfi0_rddata_dbi_W1,
input  [`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH-1:0] dfi0_wrdata_mask_P2,
output [`DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH-1 :0] dfi0_rddata_dbi_W2,
input  [`DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH-1:0] dfi0_wrdata_mask_P3,
output [`DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH-1 :0] dfi0_rddata_dbi_W3,
`endif //  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED

`ifdef DWC_DDRPHY_LPDDR5_ENABLED
input [`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH-1:0] dfi0_wck_write_P0,
input [`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH-1:0] dfi0_wck_write_P1,
input [`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH-1:0] dfi0_wck_write_P2,
input [`DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH-1:0] dfi0_wck_write_P3,
input [`DWC_DDRPHY_DFI0_WCK_EN_WIDTH-1:0] dfi0_wck_en_P0,
input [`DWC_DDRPHY_DFI0_WCK_EN_WIDTH-1:0] dfi0_wck_en_P1,
input [`DWC_DDRPHY_DFI0_WCK_EN_WIDTH-1:0] dfi0_wck_en_P2,
input [`DWC_DDRPHY_DFI0_WCK_EN_WIDTH-1:0] dfi0_wck_en_P3,
input [`DWC_DDRPHY_DFI0_WCK_CS_WIDTH-1:0] dfi0_wck_cs_P0,
input [`DWC_DDRPHY_DFI0_WCK_CS_WIDTH-1:0] dfi0_wck_cs_P1,
input [`DWC_DDRPHY_DFI0_WCK_CS_WIDTH-1:0] dfi0_wck_cs_P2,
input [`DWC_DDRPHY_DFI0_WCK_CS_WIDTH-1:0] dfi0_wck_cs_P3,
input [`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH-1:0] dfi0_wck_toggle_P0,
input [`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH-1:0] dfi0_wck_toggle_P1,
input [`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH-1:0] dfi0_wck_toggle_P2,
input [`DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH-1:0] dfi0_wck_toggle_P3,
input [`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH-1:0] dfi0_wrdata_link_ecc_P0,
input [`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH-1:0] dfi0_wrdata_link_ecc_P1,
input [`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH-1:0] dfi0_wrdata_link_ecc_P2,
input [`DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH-1:0] dfi0_wrdata_link_ecc_P3,
`endif //  `ifdef DWC_DDRPHY_LPDDR5_ENABLED
                       
input [`DWC_DDRPHY_DFI0_P0_ADDRESS_MSB:0]  dfi0_address_P0,   //14 bit wide P0 for LP5.
input [`DWC_DDRPHY_DFI0_ADDRESS_WIDTH-1:0] dfi0_address_P1,
input [`DWC_DDRPHY_DFI0_ADDRESS_WIDTH-1:0] dfi0_address_P2,
input [`DWC_DDRPHY_DFI0_ADDRESS_WIDTH-1:0] dfi0_address_P3,

input [`DWC_DDRPHY_DFI0_WRDATA_WIDTH-1:0] dfi0_wrdata_P0,
input [`DWC_DDRPHY_DFI0_WRDATA_WIDTH-1:0] dfi0_wrdata_P1,
input [`DWC_DDRPHY_DFI0_WRDATA_WIDTH-1:0] dfi0_wrdata_P2,
input [`DWC_DDRPHY_DFI0_WRDATA_WIDTH-1:0] dfi0_wrdata_P3,
input [`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH-1:0] dfi0_wrdata_cs_P0,
input [`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH-1:0] dfi0_wrdata_cs_P1,
input [`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH-1:0] dfi0_wrdata_cs_P2,
input [`DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH-1:0] dfi0_wrdata_cs_P3,
input [`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH-1:0] dfi0_wrdata_en_P0,
input [`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH-1:0] dfi0_wrdata_en_P1,
input [`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH-1:0] dfi0_wrdata_en_P2,
input [`DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH-1:0] dfi0_wrdata_en_P3,
output [`DWC_DDRPHY_DFI0_RDDATA_WIDTH-1:0] dfi0_rddata_W0,
output [`DWC_DDRPHY_DFI0_RDDATA_WIDTH-1:0] dfi0_rddata_W1,
output [`DWC_DDRPHY_DFI0_RDDATA_WIDTH-1:0] dfi0_rddata_W2,
output [`DWC_DDRPHY_DFI0_RDDATA_WIDTH-1:0] dfi0_rddata_W3,
input [`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH-1:0] dfi0_rddata_cs_P0,
input [`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH-1:0] dfi0_rddata_cs_P1,
input [`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH-1:0] dfi0_rddata_cs_P2,
input [`DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH-1:0] dfi0_rddata_cs_P3,
input [`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH-1:0] dfi0_rddata_en_P0,
input [`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH-1:0] dfi0_rddata_en_P1,
input [`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH-1:0] dfi0_rddata_en_P2,
input [`DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH-1:0] dfi0_rddata_en_P3,
output [`DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH-1:0] dfi0_rddata_valid_W0,
output [`DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH-1:0] dfi0_rddata_valid_W1,
output [`DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH-1:0] dfi0_rddata_valid_W2,
output [`DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH-1:0] dfi0_rddata_valid_W3,
output wire [`DWC_DDRPHY_DFI0_CTRLUPD_ACK_WIDTH-1:0] dfi0_ctrlupd_ack,
input  [`DWC_DDRPHY_DFI0_CTRLUPD_REQ_WIDTH-1:0] dfi0_ctrlupd_req,
`ifndef PUB_VERSION_LE_0200 //RID < 02003
input  [`DWC_DDRPHY_DFI0_CTRLUPD_TYPE_WIDTH-1:0] dfi0_ctrlupd_type,
`endif
input  [`DWC_DDRPHY_DFI0_PHYUPD_ACK_WIDTH-1:0] dfi0_phyupd_ack,
output wire [`DWC_DDRPHY_DFI0_PHYUPD_REQ_WIDTH-1:0] dfi0_phyupd_req,
output wire [`DWC_DDRPHY_DFI0_PHYUPD_TYPE_WIDTH-1:0] dfi0_phyupd_type,
input [`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH-1:0] dfi0_dram_clk_disable_P0,
input [`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH-1:0] dfi0_dram_clk_disable_P1,
input [`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH-1:0] dfi0_dram_clk_disable_P2,
input [`DWC_DDRPHY_DFI0_DRAM_CLK_DISABLE_WIDTH-1:0] dfi0_dram_clk_disable_P3,
input  [`DWC_DDRPHY_DFI0_FREQ_FSP_WIDTH-1:0] dfi0_freq_fsp,
input  [`DWC_DDRPHY_DFI0_FREQ_RATIO_WIDTH-1:0] dfi0_freq_ratio,
input  [`DWC_DDRPHY_DFI0_FREQUENCY_WIDTH-1:0] dfi0_frequency,
output wire [`DWC_DDRPHY_DFI0_INIT_COMPLETE_WIDTH-1:0] dfi0_init_complete,
input  [`DWC_DDRPHY_DFI0_INIT_START_WIDTH-1:0] dfi0_init_start,
input  [`DWC_DDRPHY_DFI0_PHYMSTR_ACK_WIDTH-1:0] dfi0_phymstr_ack,
output wire [`DWC_DDRPHY_DFI0_PHYMSTR_CS_STATE_WIDTH-1:0] dfi0_phymstr_cs_state,
output wire [`DWC_DDRPHY_DFI0_PHYMSTR_REQ_WIDTH-1:0] dfi0_phymstr_req,
output wire [`DWC_DDRPHY_DFI0_PHYMSTR_STATE_SEL_WIDTH-1:0] dfi0_phymstr_state_sel,
output wire [`DWC_DDRPHY_DFI0_PHYMSTR_TYPE_WIDTH-1:0] dfi0_phymstr_type,
input [`DWC_DDRPHY_DFI0_CKE_WIDTH-1:0] dfi0_cke_P0,
input [`DWC_DDRPHY_DFI0_CKE_WIDTH-1:0] dfi0_cke_P1,
input [`DWC_DDRPHY_DFI0_CKE_WIDTH-1:0] dfi0_cke_P2,
input [`DWC_DDRPHY_DFI0_CKE_WIDTH-1:0] dfi0_cke_P3,
input [`DWC_DDRPHY_DFI0_CS_WIDTH-1:0] dfi0_cs_P0,
input [`DWC_DDRPHY_DFI0_CS_WIDTH-1:0] dfi0_cs_P1,
input [`DWC_DDRPHY_DFI0_CS_WIDTH-1:0] dfi0_cs_P2,
input [`DWC_DDRPHY_DFI0_CS_WIDTH-1:0] dfi0_cs_P3,
output wire [`DWC_DDRPHY_DFI0_LP_CTRL_ACK_WIDTH-1:0] dfi0_lp_ctrl_ack,
input  [`DWC_DDRPHY_DFI0_LP_CTRL_REQ_WIDTH-1:0] dfi0_lp_ctrl_req,
input  [`DWC_DDRPHY_DFI0_LP_CTRL_WAKEUP_WIDTH-1:0] dfi0_lp_ctrl_wakeup,
output wire [`DWC_DDRPHY_DFI0_LP_DATA_ACK_WIDTH-1:0] dfi0_lp_data_ack,
input  [`DWC_DDRPHY_DFI0_LP_DATA_REQ_WIDTH-1:0] dfi0_lp_data_req,
input  [`DWC_DDRPHY_DFI0_LP_DATA_WAKEUP_WIDTH-1:0] dfi0_lp_data_wakeup,
input  [`DWC_DDRPHY_DFI0_CTRLMSG_WIDTH-1:0] dfi0_ctrlmsg,
output wire [`DWC_DDRPHY_DFI0_CTRLMSG_ACK_WIDTH-1:0] dfi0_ctrlmsg_ack,
input  [`DWC_DDRPHY_DFI0_CTRLMSG_DATA_WIDTH-1:0] dfi0_ctrlmsg_data,
input  [`DWC_DDRPHY_DFI0_CTRLMSG_REQ_WIDTH-1:0] dfi0_ctrlmsg_req,
output wire [`DWC_DDRPHY_DFI0_ERROR_WIDTH-1:0] dfi0_error,
output wire [`DWC_DDRPHY_DFI0_ERROR_INFO_WIDTH-1:0] dfi0_error_info,

`ifdef DWC_DDRPHY_NUM_CHANNELS_2


`ifdef DWC_DDRPHY_LPDDR5_ENABLED
input [`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH-1:0] dfi1_wck_write_P0,
input [`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH-1:0] dfi1_wck_write_P1,
input [`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH-1:0] dfi1_wck_write_P2,
input [`DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH-1:0] dfi1_wck_write_P3,
input [`DWC_DDRPHY_DFI1_WCK_EN_WIDTH-1:0] dfi1_wck_en_P0,
input [`DWC_DDRPHY_DFI1_WCK_EN_WIDTH-1:0] dfi1_wck_en_P1,
input [`DWC_DDRPHY_DFI1_WCK_EN_WIDTH-1:0] dfi1_wck_en_P2,
input [`DWC_DDRPHY_DFI1_WCK_EN_WIDTH-1:0] dfi1_wck_en_P3,
input [`DWC_DDRPHY_DFI1_WCK_CS_WIDTH-1:0] dfi1_wck_cs_P0,
input [`DWC_DDRPHY_DFI1_WCK_CS_WIDTH-1:0] dfi1_wck_cs_P1,
input [`DWC_DDRPHY_DFI1_WCK_CS_WIDTH-1:0] dfi1_wck_cs_P2,
input [`DWC_DDRPHY_DFI1_WCK_CS_WIDTH-1:0] dfi1_wck_cs_P3,
input [`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH-1:0] dfi1_wck_toggle_P0,
input [`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH-1:0] dfi1_wck_toggle_P1,
input [`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH-1:0] dfi1_wck_toggle_P2,
input [`DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH-1:0] dfi1_wck_toggle_P3,
input [`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH-1:0] dfi1_wrdata_link_ecc_P0,
input [`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH-1:0] dfi1_wrdata_link_ecc_P1,
input [`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH-1:0] dfi1_wrdata_link_ecc_P2,
input [`DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH-1:0] dfi1_wrdata_link_ecc_P3,
`endif
input [`DWC_DDRPHY_DFI1_P0_ADDRESS_MSB:0]  dfi1_address_P0,   //14 bit wide P0 for LP5.
input [`DWC_DDRPHY_DFI1_ADDRESS_WIDTH-1:0] dfi1_address_P1,
input [`DWC_DDRPHY_DFI1_ADDRESS_WIDTH-1:0] dfi1_address_P2,
input [`DWC_DDRPHY_DFI1_ADDRESS_WIDTH-1:0] dfi1_address_P3,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
input  [`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH-1:0] dfi1_wrdata_mask_P0,
output [`DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH-1 :0] dfi1_rddata_dbi_W0,
input  [`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH-1:0] dfi1_wrdata_mask_P1,
output [`DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH-1 :0] dfi1_rddata_dbi_W1,
input  [`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH-1:0] dfi1_wrdata_mask_P2,
output [`DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH-1 :0] dfi1_rddata_dbi_W2,
input  [`DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH-1:0] dfi1_wrdata_mask_P3,
output [`DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH-1 :0] dfi1_rddata_dbi_W3,
`endif //  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED

input [`DWC_DDRPHY_DFI1_WRDATA_WIDTH-1:0] dfi1_wrdata_P0,
input [`DWC_DDRPHY_DFI1_WRDATA_WIDTH-1:0] dfi1_wrdata_P1,
input [`DWC_DDRPHY_DFI1_WRDATA_WIDTH-1:0] dfi1_wrdata_P2,
input [`DWC_DDRPHY_DFI1_WRDATA_WIDTH-1:0] dfi1_wrdata_P3,
input [`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH-1:0] dfi1_wrdata_cs_P0,
input [`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH-1:0] dfi1_wrdata_cs_P1,
input [`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH-1:0] dfi1_wrdata_cs_P2,
input [`DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH-1:0] dfi1_wrdata_cs_P3,
input [`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH-1:0] dfi1_wrdata_en_P0,
input [`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH-1:0] dfi1_wrdata_en_P1,
input [`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH-1:0] dfi1_wrdata_en_P2,
input [`DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH-1:0] dfi1_wrdata_en_P3,
output [`DWC_DDRPHY_DFI1_RDDATA_WIDTH-1:0] dfi1_rddata_W0,
output [`DWC_DDRPHY_DFI1_RDDATA_WIDTH-1:0] dfi1_rddata_W1,
output [`DWC_DDRPHY_DFI1_RDDATA_WIDTH-1:0] dfi1_rddata_W2,
output [`DWC_DDRPHY_DFI1_RDDATA_WIDTH-1:0] dfi1_rddata_W3,
input [`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH-1:0] dfi1_rddata_cs_P0,
input [`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH-1:0] dfi1_rddata_cs_P1,
input [`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH-1:0] dfi1_rddata_cs_P2,
input [`DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH-1:0] dfi1_rddata_cs_P3,
input [`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH-1:0] dfi1_rddata_en_P0,
input [`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH-1:0] dfi1_rddata_en_P1,
input [`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH-1:0] dfi1_rddata_en_P2,
input [`DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH-1:0] dfi1_rddata_en_P3,
output [`DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH-1:0] dfi1_rddata_valid_W0,
output [`DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH-1:0] dfi1_rddata_valid_W1,
output [`DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH-1:0] dfi1_rddata_valid_W2,
output [`DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH-1:0] dfi1_rddata_valid_W3,
output wire [`DWC_DDRPHY_DFI1_CTRLUPD_ACK_WIDTH-1:0] dfi1_ctrlupd_ack,
input  [`DWC_DDRPHY_DFI1_CTRLUPD_REQ_WIDTH-1:0] dfi1_ctrlupd_req,
`ifndef PUB_VERSION_LE_0200 //RID < 02003
input  [`DWC_DDRPHY_DFI0_CTRLUPD_TYPE_WIDTH-1:0] dfi1_ctrlupd_type,
`endif
input  [`DWC_DDRPHY_DFI1_PHYUPD_ACK_WIDTH-1:0] dfi1_phyupd_ack,
output wire [`DWC_DDRPHY_DFI1_PHYUPD_REQ_WIDTH-1:0] dfi1_phyupd_req,
output wire [`DWC_DDRPHY_DFI1_PHYUPD_TYPE_WIDTH-1:0] dfi1_phyupd_type,
input [`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH-1:0] dfi1_dram_clk_disable_P0,
input [`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH-1:0] dfi1_dram_clk_disable_P1,
input [`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH-1:0] dfi1_dram_clk_disable_P2,
input [`DWC_DDRPHY_DFI1_DRAM_CLK_DISABLE_WIDTH-1:0] dfi1_dram_clk_disable_P3,
input  [`DWC_DDRPHY_DFI1_FREQ_FSP_WIDTH-1:0] dfi1_freq_fsp,
input  [`DWC_DDRPHY_DFI1_FREQ_RATIO_WIDTH-1:0] dfi1_freq_ratio,
input  [`DWC_DDRPHY_DFI1_FREQUENCY_WIDTH-1:0] dfi1_frequency,
output wire [`DWC_DDRPHY_DFI1_INIT_COMPLETE_WIDTH-1:0] dfi1_init_complete,
input  [`DWC_DDRPHY_DFI1_INIT_START_WIDTH-1:0] dfi1_init_start,
input  [`DWC_DDRPHY_DFI1_PHYMSTR_ACK_WIDTH-1:0] dfi1_phymstr_ack,
output wire [`DWC_DDRPHY_DFI1_PHYMSTR_CS_STATE_WIDTH-1:0] dfi1_phymstr_cs_state,
output wire [`DWC_DDRPHY_DFI1_PHYMSTR_REQ_WIDTH-1:0] dfi1_phymstr_req,
output wire [`DWC_DDRPHY_DFI1_PHYMSTR_STATE_SEL_WIDTH-1:0] dfi1_phymstr_state_sel,
output wire [`DWC_DDRPHY_DFI1_PHYMSTR_TYPE_WIDTH-1:0] dfi1_phymstr_type,
input [`DWC_DDRPHY_DFI1_CKE_WIDTH-1:0] dfi1_cke_P0,
input [`DWC_DDRPHY_DFI1_CKE_WIDTH-1:0] dfi1_cke_P1,
input [`DWC_DDRPHY_DFI1_CKE_WIDTH-1:0] dfi1_cke_P2,
input [`DWC_DDRPHY_DFI1_CKE_WIDTH-1:0] dfi1_cke_P3,
input [`DWC_DDRPHY_DFI1_CS_WIDTH-1:0] dfi1_cs_P0,
input [`DWC_DDRPHY_DFI1_CS_WIDTH-1:0] dfi1_cs_P1,
input [`DWC_DDRPHY_DFI1_CS_WIDTH-1:0] dfi1_cs_P2,
input [`DWC_DDRPHY_DFI1_CS_WIDTH-1:0] dfi1_cs_P3,
output wire [`DWC_DDRPHY_DFI1_LP_CTRL_ACK_WIDTH-1:0] dfi1_lp_ctrl_ack,
input  [`DWC_DDRPHY_DFI1_LP_CTRL_REQ_WIDTH-1:0] dfi1_lp_ctrl_req,
input  [`DWC_DDRPHY_DFI1_LP_CTRL_WAKEUP_WIDTH-1:0] dfi1_lp_ctrl_wakeup,
output wire [`DWC_DDRPHY_DFI1_LP_DATA_ACK_WIDTH-1:0] dfi1_lp_data_ack,
input  [`DWC_DDRPHY_DFI1_LP_DATA_REQ_WIDTH-1:0] dfi1_lp_data_req,
input  [`DWC_DDRPHY_DFI1_LP_DATA_WAKEUP_WIDTH-1:0] dfi1_lp_data_wakeup,
input  [`DWC_DDRPHY_DFI1_CTRLMSG_WIDTH-1:0] dfi1_ctrlmsg,
output wire [`DWC_DDRPHY_DFI1_CTRLMSG_ACK_WIDTH-1:0] dfi1_ctrlmsg_ack,
input  [`DWC_DDRPHY_DFI1_CTRLMSG_DATA_WIDTH-1:0] dfi1_ctrlmsg_data,
input  [`DWC_DDRPHY_DFI1_CTRLMSG_REQ_WIDTH-1:0] dfi1_ctrlmsg_req,
output wire [`DWC_DDRPHY_DFI1_ERROR_WIDTH-1:0] dfi1_error,
output wire [`DWC_DDRPHY_DFI1_ERROR_INFO_WIDTH-1:0] dfi1_error_info,
  `endif



   // Per-Phy Signals for DCT
   input              Reset,         // as per dct interface spec - defined as sync to refclk
   input              Reset_async,         // Async reset for HardIP.
   input              DfiClk,
   input              PllRefClk,
   input              PllBypClk,
   input              BurnIn,
   output             UcClk,
`ifdef DWC_DDRPHY_LBIST_EN
`ifndef PUB_VERSION_GE_0100
   input              DfiClk0_lbist,
`endif
   input              lbist_mode,
   input              LBIST_TYPE,
   input              LBIST_TM0,
   input              LBIST_TM1,
   input              LBIST_EN,
   input              START,
   output wire        STATUS_0,
   output wire        STATUS_1,
`endif                          
                       
// PHY JTAG TDR interface
   input              WSI,                  // Seriel Data Input: Launch on Fall Capture on Rise
   input              TDRCLK,                 // JTAG Clock
   input              WRSTN,                // JTAG Async Reset. Active LOW
// JTAG TDR interface to DrTub
   input              DdrPhyCsrCmdTdrShiftEn,    // TDR Shift Enable: Launch on Rise, Capture On Rise
   input              DdrPhyCsrCmdTdrCaptureEn,  // TDR Capture Enable: Launch on Rise, Capture On Rise
   input              DdrPhyCsrCmdTdrUpdateEn,   // TDR Update Enable: Launch on Fall, Capture On Rise
   output wire        DdrPhyCsrCmdTdr_Tdo,       // TDR Serial Data Output: Launch on Fall, Capture on Rise 
   input              DdrPhyCsrRdDataTdrShiftEn,    // TDR Shift Enable: Launch on Rise, Capture On Rise
   input              DdrPhyCsrRdDataTdrCaptureEn,  // TDR Capture Enable: Launch on Rise, Capture On Rise
   input              DdrPhyCsrRdDataTdrUpdateEn,   // TDR Update Enable: Launch on Fall, Capture On Rise
   output wire        DdrPhyCsrRdDataTdr_Tdo,       // TDR Serial Data Output: Launch on Fall, Capture on Rise 

   output wire [15:0] PhyInt_n, // Interrupt

   output wire [5:0] PhyInt_fault,

  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy0_snoop_en_P0,
  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy0_snoop_en_P1,
  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy0_snoop_en_P2,
  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy0_snoop_en_P3,
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy1_snoop_en_P0,
  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy1_snoop_en_P1,
  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy1_snoop_en_P2,
  input wire [(4*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)-1:0] dwc_ddrphy1_snoop_en_P3,
`endif

   // scan controls
   input         [`DWC_DDRPHY_ATPG_SE_WIDTH-1:0]          atpg_se,
   input         [`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS - 1:0]  atpg_si,
   output wire   [`DWC_DDRPHY_NUM_TOP_SCAN_CHAINS - 1:0]  atpg_so,
   input             atpg_mode,
    
   // ATPG Clocks/Controls
   input             atpg_RDQSClk,
   input             atpg_PClk,
   input             atpg_TxDllClk,
   input             atpg_DlyTestClk,

   // External AHB-Lite Interface

   output wire [13:0]     haddr_ahb,
   output wire [2:0]      hburst_ahb,     // tied to 3'b0
   output wire            hmastlock_ahb,  // tied to 1'b0
   output wire [3:0]      hprot_ahb,      // tied to 4'b0011
   output wire [2:0]      hsize_ahb,      // tied to 3'b010
   output wire [1:0]      htrans_ahb,
   output wire [31:0]     hwdata_ahb, 
   output wire            hwrite_ahb,
   output wire            hclk_ahb,
   output wire            hresetn_ahb,

   input wire [31:0]      hrdata_ahb,
   input wire             hresp_ahb,          // error signal; unused
   input wire             hreadyout_ahb,
   

   input                           APBCLK,                       
   input [31:0]     PADDR_APB,
   input                           PWRITE_APB,
   input                           PRESETn_APB,
   input                           PSELx_APB,
   input                           PENABLE_APB,
   input [15:0]    PWDATA_APB,
   input [1:0]     PSTRB_APB,

   input [2:0]     PPROT_APB,
                
   output wire                        PREADY_APB,
   output wire [15:0] PRDATA_APB,
   output wire                        PSLVERR_APB,
                                                   
   input [2:0]        PPROT_PIN,


   // Interface to the ICCM RAM macros
   input   [`DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB:0]                               iccm_data_dout,
   output  [`DWC_DDRPHY_PMU_ICCM_DRAM_MSB_CTB:0]                               iccm_data_din,
   output  [`DWC_DDRPHY_PMU_ICCM_WRD_MSB_CTB:`DWC_DDRPHY_PMU_ICCM_WRD_LSB_CTB] iccm_data_addr,
   output                                                                      iccm_data_ce,
   output                                                                      iccm_data_we,

   // Interface to the DCCM RAM macros
   input   [`DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB:0]                               dccm_data_dout,
   output  [`DWC_DDRPHY_PMU_DCCM_DRAM_MSB_CTB:0]                               dccm_data_din,
   output  [`DWC_DDRPHY_PMU_DCCM_WRD_MSB_CTB:`DWC_DDRPHY_PMU_DCCM_WRD_LSB_CTB] dccm_data_addr,
   output                                                                      dccm_data_ce,
   output                                                                      dccm_data_we,
                                                                              
   // Interface for PS Memory
   input   [59:0]   ps_ram_rddata,    // 7 PAR, 19 ADDR, 2 VALID, 16 DATA, 16 DATA
   output  [59:0]   ps_ram_wrdata,

   output  [13:0]   ps_ram_addr,

   output           ps_ram_ce,
   output           ps_ram_we,

// Interface to External ACSM Memory
   input      [71:0] acsm_data_dout,
   output     [71:0] acsm_data_din,
   output     [9:0]  acsm_data_addr,
   output            acsm_data_ce,                               
   output            acsm_data_we,


   // below signal names as per ".."PhyInterface (TX-side)

   //Async BYPASS interface
  
  input         TxBypassMode_MEMRESET_L,
  input         TxBypassData_MEMRESET_L,

  input         TxBypassMode_DTO,
  input         TxBypassOE_DTO,
  input         TxBypassData_DTO,
  input         RxBypassEn_DTO,
  output wire   RxBypassDataPad_DTO,  


  input         RxTestClk,


   
   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]RxBypassRcvEn_DFI0_CA,
   input                               RxBypassRcvEn_DFI0_CK,
   input  [7:0]                        RxBypassRcvEn_DFI0_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI0_B0_DMI,
`endif
   input                               RxBypassRcvEn_DFI0_B0_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI0_B0_WCK,
`endif
   input  [7:0]                        RxBypassRcvEn_DFI0_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI0_B1_DMI,
`endif
   input                               RxBypassRcvEn_DFI0_B1_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI0_B1_WCK,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassRcvEn_DFI0_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI0_B2_DMI,
`endif
   input                               RxBypassRcvEn_DFI0_B2_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI0_B2_WCK,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassRcvEn_DFI0_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI0_B3_DMI,
`endif
   input                               RxBypassRcvEn_DFI0_B3_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI0_B3_WCK,
`endif
`endif
   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]RxBypassPadEn_DFI0_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  RxBypassPadEn_DFI0_LP4CKE_LP5CS,
   input                               RxBypassPadEn_DFI0_CK,
   input  [7:0]                        RxBypassPadEn_DFI0_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI0_B0_DMI,
`endif
   input                               RxBypassPadEn_DFI0_B0_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI0_B0_WCK,
`endif
   input  [7:0]                        RxBypassPadEn_DFI0_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI0_B1_DMI,
`endif
   input                               RxBypassPadEn_DFI0_B1_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI0_B1_WCK,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassPadEn_DFI0_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI0_B2_DMI,
`endif
   input                               RxBypassPadEn_DFI0_B2_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI0_B2_WCK,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassPadEn_DFI0_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI0_B3_DMI,
`endif
   input                               RxBypassPadEn_DFI0_B3_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI0_B3_WCK,
`endif
`endif
   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]TxBypassMode_DFI0_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  TxBypassMode_DFI0_LP4CKE_LP5CS,
   input                               TxBypassMode_DFI0_CK_T,     
   input                               TxBypassMode_DFI0_CK_C,     
   input  [7:0]                        TxBypassMode_DFI0_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI0_B0_DMI,
`endif
   input                               TxBypassMode_DFI0_B0_DQS_T,     
   input                               TxBypassMode_DFI0_B0_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI0_B0_WCK_T,     
   input                               TxBypassMode_DFI0_B0_WCK_C,     
`endif
   input  [7:0]                        TxBypassMode_DFI0_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI0_B1_DMI,
`endif
   input                               TxBypassMode_DFI0_B1_DQS_T,     
   input                               TxBypassMode_DFI0_B1_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI0_B1_WCK_T,     
   input                               TxBypassMode_DFI0_B1_WCK_C,     
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassMode_DFI0_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI0_B2_DMI,
`endif
   input                               TxBypassMode_DFI0_B2_DQS_T,     
   input                               TxBypassMode_DFI0_B2_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI0_B2_WCK_T,     
   input                               TxBypassMode_DFI0_B2_WCK_C,     
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassMode_DFI0_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI0_B3_DMI,
`endif
   input                               TxBypassMode_DFI0_B3_DQS_T,     
   input                               TxBypassMode_DFI0_B3_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI0_B3_WCK_T,     
   input                               TxBypassMode_DFI0_B3_WCK_C,     
`endif
`endif

                                                    


   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]TxBypassOE_DFI0_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  TxBypassOE_DFI0_LP4CKE_LP5CS,
   input                               TxBypassOE_DFI0_CK_T,
   input                               TxBypassOE_DFI0_CK_C,
   input  [7:0]                        TxBypassOE_DFI0_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI0_B0_DMI,
`endif
   input                               TxBypassOE_DFI0_B0_DQS_T,
   input                               TxBypassOE_DFI0_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI0_B0_WCK_T,
   input                               TxBypassOE_DFI0_B0_WCK_C,
`endif
   input  [7:0]                        TxBypassOE_DFI0_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI0_B1_DMI,
`endif
   input                               TxBypassOE_DFI0_B1_DQS_T,
   input                               TxBypassOE_DFI0_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI0_B1_WCK_T,
   input                               TxBypassOE_DFI0_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassOE_DFI0_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI0_B2_DMI,
`endif
   input                               TxBypassOE_DFI0_B2_DQS_T,
   input                               TxBypassOE_DFI0_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI0_B2_WCK_T,
   input                               TxBypassOE_DFI0_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassOE_DFI0_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI0_B3_DMI,
`endif
   input                               TxBypassOE_DFI0_B3_DQS_T,
   input                               TxBypassOE_DFI0_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI0_B3_WCK_T,
   input                               TxBypassOE_DFI0_B3_WCK_C,
`endif
`endif


   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]TxBypassData_DFI0_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  TxBypassData_DFI0_LP4CKE_LP5CS,
   input                               TxBypassData_DFI0_CK_T,
   input                               TxBypassData_DFI0_CK_C,
   input  [7:0]                        TxBypassData_DFI0_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI0_B0_DMI,
`endif
   input                               TxBypassData_DFI0_B0_DQS_T,
   input                               TxBypassData_DFI0_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI0_B0_WCK_T,
   input                               TxBypassData_DFI0_B0_WCK_C,
`endif
   input  [7:0]                        TxBypassData_DFI0_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI0_B1_DMI,
`endif
   input                               TxBypassData_DFI0_B1_DQS_T,
   input                               TxBypassData_DFI0_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI0_B1_WCK_T,
   input                               TxBypassData_DFI0_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassData_DFI0_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI0_B2_DMI,
`endif
   input                               TxBypassData_DFI0_B2_DQS_T,
   input                               TxBypassData_DFI0_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI0_B2_WCK_T,
   input                               TxBypassData_DFI0_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassData_DFI0_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI0_B3_DMI,
`endif
   input                               TxBypassData_DFI0_B3_DQS_T,
   input                               TxBypassData_DFI0_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI0_B3_WCK_T,
   input                               TxBypassData_DFI0_B3_WCK_C,
`endif
`endif


   output wire  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]RxBypassDataPad_DFI0_CA,
   output wire  [`DWC_DDRPHY_NUM_RANKS-1:0]  RxBypassDataPad_DFI0_LP4CKE_LP5CS,
   output wire                               RxBypassDataPad_DFI0_CK_T,
   output wire                               RxBypassDataPad_DFI0_CK_C,
   output wire  [7:0]                        RxBypassDataPad_DFI0_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI0_B0_DMI,
`endif
   output wire                               RxBypassDataPad_DFI0_B0_DQS_T,
   output wire                               RxBypassDataPad_DFI0_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI0_B0_WCK_T,
   output wire                               RxBypassDataPad_DFI0_B0_WCK_C,
`endif
   output wire  [7:0]                        RxBypassDataPad_DFI0_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI0_B1_DMI,
`endif
   output wire                               RxBypassDataPad_DFI0_B1_DQS_T,
   output wire                               RxBypassDataPad_DFI0_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI0_B1_WCK_T,
   output wire                               RxBypassDataPad_DFI0_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [7:0]                        RxBypassDataPad_DFI0_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI0_B2_DMI,
`endif
   output wire                               RxBypassDataPad_DFI0_B2_DQS_T,
   output wire                               RxBypassDataPad_DFI0_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI0_B2_WCK_T,
   output wire                               RxBypassDataPad_DFI0_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [7:0]                        RxBypassDataPad_DFI0_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI0_B3_DMI,
`endif
   output wire                               RxBypassDataPad_DFI0_B3_DQS_T,
   output wire                               RxBypassDataPad_DFI0_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI0_B3_WCK_T,
   output wire                               RxBypassDataPad_DFI0_B3_WCK_C,
`endif
`endif



   output wire  [3:0]                        RxBypassData_DFI0_CA0,
   output wire  [3:0]                        RxBypassData_DFI0_CA1,
   output wire  [3:0]                        RxBypassData_DFI0_CA2,
   output wire  [3:0]                        RxBypassData_DFI0_CA3,
   output wire  [3:0]                        RxBypassData_DFI0_CA4,
   output wire  [3:0]                        RxBypassData_DFI0_CA5,
   output wire  [3:0]                        RxBypassData_DFI0_CA6,
`ifdef DWC_DDRPHY_NUM_RANKS_2
   output wire  [3:0]                        RxBypassData_DFI0_CA7,
`endif
   output wire                               RxBypassDataRcv_DFI0_CK_T,
   output wire                               RxBypassDataRcv_DFI0_CK_C,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D0,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D1,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D2,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D3,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D4,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D5,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D6,
   output wire  [3:0]                        RxBypassData_DFI0_B0_D7,
   output wire                               RxBypassDataRcv_DFI0_B0_DQS_T,
   output wire                               RxBypassDataRcv_DFI0_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI0_B0_WCK_T,
   output wire                               RxBypassDataRcv_DFI0_B0_WCK_C,
`endif
   output wire  [3:0]                        RxBypassData_DFI0_B1_D0,
   output wire  [3:0]                        RxBypassData_DFI0_B1_D1,
   output wire  [3:0]                        RxBypassData_DFI0_B1_D2,
   output wire  [3:0]                        RxBypassData_DFI0_B1_D3,
   output wire  [3:0]                        RxBypassData_DFI0_B1_D4,
   output wire  [3:0]                        RxBypassData_DFI0_B1_D5,
   output wire  [3:0]                        RxBypassData_DFI0_B1_D6,
   output wire  [3:0]                        RxBypassData_DFI0_B1_D7,
   output wire                               RxBypassDataRcv_DFI0_B1_DQS_T,
   output wire                               RxBypassDataRcv_DFI0_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI0_B1_WCK_T,
   output wire                               RxBypassDataRcv_DFI0_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [3:0]                        RxBypassData_DFI0_B2_D0,
   output wire  [3:0]                        RxBypassData_DFI0_B2_D1,
   output wire  [3:0]                        RxBypassData_DFI0_B2_D2,
   output wire  [3:0]                        RxBypassData_DFI0_B2_D3,
   output wire  [3:0]                        RxBypassData_DFI0_B2_D4,
   output wire  [3:0]                        RxBypassData_DFI0_B2_D5,
   output wire  [3:0]                        RxBypassData_DFI0_B2_D6,
   output wire  [3:0]                        RxBypassData_DFI0_B2_D7,
   output wire                               RxBypassDataRcv_DFI0_B2_DQS_T,
   output wire                               RxBypassDataRcv_DFI0_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI0_B2_WCK_T,
   output wire                               RxBypassDataRcv_DFI0_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [3:0]                        RxBypassData_DFI0_B3_D0,
   output wire  [3:0]                        RxBypassData_DFI0_B3_D1,
   output wire  [3:0]                        RxBypassData_DFI0_B3_D2,
   output wire  [3:0]                        RxBypassData_DFI0_B3_D3,
   output wire  [3:0]                        RxBypassData_DFI0_B3_D4,
   output wire  [3:0]                        RxBypassData_DFI0_B3_D5,
   output wire  [3:0]                        RxBypassData_DFI0_B3_D6,
   output wire  [3:0]                        RxBypassData_DFI0_B3_D7,
   output wire                               RxBypassDataRcv_DFI0_B3_DQS_T,
   output wire                               RxBypassDataRcv_DFI0_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI0_B3_WCK_T,
   output wire                               RxBypassDataRcv_DFI0_B3_WCK_C,
`endif
`endif

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
   
   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]RxBypassRcvEn_DFI1_CA,
   input                               RxBypassRcvEn_DFI1_CK,
   input  [7:0]                        RxBypassRcvEn_DFI1_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI1_B0_DMI,
`endif
   input                               RxBypassRcvEn_DFI1_B0_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI1_B0_WCK,
`endif
   input  [7:0]                        RxBypassRcvEn_DFI1_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI1_B1_DMI,
`endif
   input                               RxBypassRcvEn_DFI1_B1_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI1_B1_WCK,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassRcvEn_DFI1_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI1_B2_DMI,
`endif
   input                               RxBypassRcvEn_DFI1_B2_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI1_B2_WCK,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassRcvEn_DFI1_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassRcvEn_DFI1_B3_DMI,
`endif
   input                               RxBypassRcvEn_DFI1_B3_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassRcvEn_DFI1_B3_WCK,
`endif
`endif
   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]RxBypassPadEn_DFI1_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  RxBypassPadEn_DFI1_LP4CKE_LP5CS,
   input                               RxBypassPadEn_DFI1_CK,
   input  [7:0]                        RxBypassPadEn_DFI1_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI1_B0_DMI,
`endif
   input                               RxBypassPadEn_DFI1_B0_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI1_B0_WCK,
`endif
   input  [7:0]                        RxBypassPadEn_DFI1_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI1_B1_DMI,
`endif
   input                               RxBypassPadEn_DFI1_B1_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI1_B1_WCK,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassPadEn_DFI1_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI1_B2_DMI,
`endif
   input                               RxBypassPadEn_DFI1_B2_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI1_B2_WCK,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        RxBypassPadEn_DFI1_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               RxBypassPadEn_DFI1_B3_DMI,
`endif
   input                               RxBypassPadEn_DFI1_B3_DQS,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               RxBypassPadEn_DFI1_B3_WCK,
`endif
`endif
   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]TxBypassMode_DFI1_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  TxBypassMode_DFI1_LP4CKE_LP5CS,
   input                               TxBypassMode_DFI1_CK_T,     
   input                               TxBypassMode_DFI1_CK_C,     
   input  [7:0]                        TxBypassMode_DFI1_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI1_B0_DMI,
`endif
   input                               TxBypassMode_DFI1_B0_DQS_T,     
   input                               TxBypassMode_DFI1_B0_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI1_B0_WCK_T,     
   input                               TxBypassMode_DFI1_B0_WCK_C,     
`endif
   input  [7:0]                        TxBypassMode_DFI1_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI1_B1_DMI,
`endif
   input                               TxBypassMode_DFI1_B1_DQS_T,     
   input                               TxBypassMode_DFI1_B1_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI1_B1_WCK_T,     
   input                               TxBypassMode_DFI1_B1_WCK_C,     
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassMode_DFI1_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI1_B2_DMI,
`endif
   input                               TxBypassMode_DFI1_B2_DQS_T,     
   input                               TxBypassMode_DFI1_B2_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI1_B2_WCK_T,     
   input                               TxBypassMode_DFI1_B2_WCK_C,     
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassMode_DFI1_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassMode_DFI1_B3_DMI,
`endif
   input                               TxBypassMode_DFI1_B3_DQS_T,     
   input                               TxBypassMode_DFI1_B3_DQS_C,     
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassMode_DFI1_B3_WCK_T,     
   input                               TxBypassMode_DFI1_B3_WCK_C,     
`endif
`endif

                                                    


   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]TxBypassOE_DFI1_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  TxBypassOE_DFI1_LP4CKE_LP5CS,
   input                               TxBypassOE_DFI1_CK_T,
   input                               TxBypassOE_DFI1_CK_C,
   input  [7:0]                        TxBypassOE_DFI1_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI1_B0_DMI,
`endif
   input                               TxBypassOE_DFI1_B0_DQS_T,
   input                               TxBypassOE_DFI1_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI1_B0_WCK_T,
   input                               TxBypassOE_DFI1_B0_WCK_C,
`endif
   input  [7:0]                        TxBypassOE_DFI1_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI1_B1_DMI,
`endif
   input                               TxBypassOE_DFI1_B1_DQS_T,
   input                               TxBypassOE_DFI1_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI1_B1_WCK_T,
   input                               TxBypassOE_DFI1_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassOE_DFI1_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI1_B2_DMI,
`endif
   input                               TxBypassOE_DFI1_B2_DQS_T,
   input                               TxBypassOE_DFI1_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI1_B2_WCK_T,
   input                               TxBypassOE_DFI1_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassOE_DFI1_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassOE_DFI1_B3_DMI,
`endif
   input                               TxBypassOE_DFI1_B3_DQS_T,
   input                               TxBypassOE_DFI1_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassOE_DFI1_B3_WCK_T,
   input                               TxBypassOE_DFI1_B3_WCK_C,
`endif
`endif


   input  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]TxBypassData_DFI1_CA,
   input  [`DWC_DDRPHY_NUM_RANKS-1:0]  TxBypassData_DFI1_LP4CKE_LP5CS,
   input                               TxBypassData_DFI1_CK_T,
   input                               TxBypassData_DFI1_CK_C,
   input  [7:0]                        TxBypassData_DFI1_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI1_B0_DMI,
`endif
   input                               TxBypassData_DFI1_B0_DQS_T,
   input                               TxBypassData_DFI1_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI1_B0_WCK_T,
   input                               TxBypassData_DFI1_B0_WCK_C,
`endif
   input  [7:0]                        TxBypassData_DFI1_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI1_B1_DMI,
`endif
   input                               TxBypassData_DFI1_B1_DQS_T,
   input                               TxBypassData_DFI1_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI1_B1_WCK_T,
   input                               TxBypassData_DFI1_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassData_DFI1_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI1_B2_DMI,
`endif
   input                               TxBypassData_DFI1_B2_DQS_T,
   input                               TxBypassData_DFI1_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI1_B2_WCK_T,
   input                               TxBypassData_DFI1_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   input  [7:0]                        TxBypassData_DFI1_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   input                               TxBypassData_DFI1_B3_DMI,
`endif
   input                               TxBypassData_DFI1_B3_DQS_T,
   input                               TxBypassData_DFI1_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   input                               TxBypassData_DFI1_B3_WCK_T,
   input                               TxBypassData_DFI1_B3_WCK_C,
`endif
`endif


   output wire  [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]RxBypassDataPad_DFI1_CA,
   output wire  [`DWC_DDRPHY_NUM_RANKS-1:0]  RxBypassDataPad_DFI1_LP4CKE_LP5CS,
   output wire                               RxBypassDataPad_DFI1_CK_T,
   output wire                               RxBypassDataPad_DFI1_CK_C,
   output wire  [7:0]                        RxBypassDataPad_DFI1_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI1_B0_DMI,
`endif
   output wire                               RxBypassDataPad_DFI1_B0_DQS_T,
   output wire                               RxBypassDataPad_DFI1_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI1_B0_WCK_T,
   output wire                               RxBypassDataPad_DFI1_B0_WCK_C,
`endif
   output wire  [7:0]                        RxBypassDataPad_DFI1_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI1_B1_DMI,
`endif
   output wire                               RxBypassDataPad_DFI1_B1_DQS_T,
   output wire                               RxBypassDataPad_DFI1_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI1_B1_WCK_T,
   output wire                               RxBypassDataPad_DFI1_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [7:0]                        RxBypassDataPad_DFI1_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI1_B2_DMI,
`endif
   output wire                               RxBypassDataPad_DFI1_B2_DQS_T,
   output wire                               RxBypassDataPad_DFI1_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI1_B2_WCK_T,
   output wire                               RxBypassDataPad_DFI1_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [7:0]                        RxBypassDataPad_DFI1_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire                               RxBypassDataPad_DFI1_B3_DMI,
`endif
   output wire                               RxBypassDataPad_DFI1_B3_DQS_T,
   output wire                               RxBypassDataPad_DFI1_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataPad_DFI1_B3_WCK_T,
   output wire                               RxBypassDataPad_DFI1_B3_WCK_C,
`endif
`endif



   output wire  [3:0]                        RxBypassData_DFI1_CA0,
   output wire  [3:0]                        RxBypassData_DFI1_CA1,
   output wire  [3:0]                        RxBypassData_DFI1_CA2,
   output wire  [3:0]                        RxBypassData_DFI1_CA3,
   output wire  [3:0]                        RxBypassData_DFI1_CA4,
   output wire  [3:0]                        RxBypassData_DFI1_CA5,
   output wire  [3:0]                        RxBypassData_DFI1_CA6,
`ifdef DWC_DDRPHY_NUM_RANKS_2
   output wire  [3:0]                        RxBypassData_DFI1_CA7,
`endif
   output wire                               RxBypassDataRcv_DFI1_CK_T,
   output wire                               RxBypassDataRcv_DFI1_CK_C,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D0,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D1,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D2,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D3,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D4,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D5,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D6,
   output wire  [3:0]                        RxBypassData_DFI1_B0_D7,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire  [3:0]                        RxBypassData_DFI1_B0_DMI,
`endif
   output wire                               RxBypassDataRcv_DFI1_B0_DQS_T,
   output wire                               RxBypassDataRcv_DFI1_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI1_B0_WCK_T,
   output wire                               RxBypassDataRcv_DFI1_B0_WCK_C,
`endif
   output wire  [3:0]                        RxBypassData_DFI1_B1_D0,
   output wire  [3:0]                        RxBypassData_DFI1_B1_D1,
   output wire  [3:0]                        RxBypassData_DFI1_B1_D2,
   output wire  [3:0]                        RxBypassData_DFI1_B1_D3,
   output wire  [3:0]                        RxBypassData_DFI1_B1_D4,
   output wire  [3:0]                        RxBypassData_DFI1_B1_D5,
   output wire  [3:0]                        RxBypassData_DFI1_B1_D6,
   output wire  [3:0]                        RxBypassData_DFI1_B1_D7,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   output wire  [3:0]                        RxBypassData_DFI1_B1_DMI,
`endif
   output wire                               RxBypassDataRcv_DFI1_B1_DQS_T,
   output wire                               RxBypassDataRcv_DFI1_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI1_B1_WCK_T,
   output wire                               RxBypassDataRcv_DFI1_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [3:0]                        RxBypassData_DFI1_B2_D0,
   output wire  [3:0]                        RxBypassData_DFI1_B2_D1,
   output wire  [3:0]                        RxBypassData_DFI1_B2_D2,
   output wire  [3:0]                        RxBypassData_DFI1_B2_D3,
   output wire  [3:0]                        RxBypassData_DFI1_B2_D4,
   output wire  [3:0]                        RxBypassData_DFI1_B2_D5,
   output wire  [3:0]                        RxBypassData_DFI1_B2_D6,
   output wire  [3:0]                        RxBypassData_DFI1_B2_D7,
   output wire                               RxBypassDataRcv_DFI1_B2_DQS_T,
   output wire                               RxBypassDataRcv_DFI1_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI1_B2_WCK_T,
   output wire                               RxBypassDataRcv_DFI1_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   output wire  [3:0]                        RxBypassData_DFI1_B3_D0,
   output wire  [3:0]                        RxBypassData_DFI1_B3_D1,
   output wire  [3:0]                        RxBypassData_DFI1_B3_D2,
   output wire  [3:0]                        RxBypassData_DFI1_B3_D3,
   output wire  [3:0]                        RxBypassData_DFI1_B3_D4,
   output wire  [3:0]                        RxBypassData_DFI1_B3_D5,
   output wire  [3:0]                        RxBypassData_DFI1_B3_D6,
   output wire  [3:0]                        RxBypassData_DFI1_B3_D7,
   output wire                               RxBypassDataRcv_DFI1_B3_DQS_T,
   output wire                               RxBypassDataRcv_DFI1_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   output wire                               RxBypassDataRcv_DFI1_B3_WCK_T,
   output wire                               RxBypassDataRcv_DFI1_B3_WCK_C,
`endif
`endif

`endif

//ZCAL
   input        ZCAL_SENSE,
   output wire  ZCAL_INT,
                       

//  DRAM BUMPS              
   inout wire [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]BP_DFI0_CA,
   inout wire [`DWC_DDRPHY_NUM_RANKS-1:0]  BP_DFI0_LP4CKE_LP5CS,
   inout wire                              BP_DFI0_CK_T,
   inout wire                              BP_DFI0_CK_C,
   inout wire [7:0]                        BP_DFI0_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI0_B0_DMI,
`endif
   inout wire                              BP_DFI0_B0_DQS_T,
   inout wire                              BP_DFI0_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI0_B0_WCK_T,
   inout wire                              BP_DFI0_B0_WCK_C,
`endif
   inout wire [7:0]                        BP_DFI0_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI0_B1_DMI,
`endif
   inout wire                              BP_DFI0_B1_DQS_T,
   inout wire                              BP_DFI0_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI0_B1_WCK_T,
   inout wire                              BP_DFI0_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   inout wire [7:0]                        BP_DFI0_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI0_B2_DMI,
`endif
   inout wire                              BP_DFI0_B2_DQS_T,
   inout wire                              BP_DFI0_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI0_B2_WCK_T,
   inout wire                              BP_DFI0_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   inout wire [7:0]                        BP_DFI0_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI0_B3_DMI,
`endif
   inout wire                              BP_DFI0_B3_DQS_T,
   inout wire                              BP_DFI0_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI0_B3_WCK_T,
   inout wire                              BP_DFI0_B3_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
   inout wire [(6+`DWC_DDRPHY_NUM_RANKS)-1:0]BP_DFI1_CA,
   inout wire [`DWC_DDRPHY_NUM_RANKS-1:0]  BP_DFI1_LP4CKE_LP5CS,
   inout wire                              BP_DFI1_CK_T,
   inout wire                              BP_DFI1_CK_C,
   inout wire [7:0]                        BP_DFI1_B0_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI1_B0_DMI,
`endif
   inout wire                              BP_DFI1_B0_DQS_T,
   inout wire                              BP_DFI1_B0_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI1_B0_WCK_T,
   inout wire                              BP_DFI1_B0_WCK_C,
`endif
   inout wire [7:0]                        BP_DFI1_B1_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI1_B1_DMI,
`endif
   inout wire                              BP_DFI1_B1_DQS_T,
   inout wire                              BP_DFI1_B1_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI1_B1_WCK_T,
   inout wire                              BP_DFI1_B1_WCK_C,
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   inout wire [7:0]                        BP_DFI1_B2_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI1_B2_DMI,
`endif
   inout wire                              BP_DFI1_B2_DQS_T,
   inout wire                              BP_DFI1_B2_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI1_B2_WCK_T,
   inout wire                              BP_DFI1_B2_WCK_C,
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
   inout wire [7:0]                        BP_DFI1_B3_D,
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
   inout wire                              BP_DFI1_B3_DMI,
`endif
   inout wire                              BP_DFI1_B3_DQS_T,
   inout wire                              BP_DFI1_B3_DQS_C,
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
   inout wire                              BP_DFI1_B3_WCK_T,
   inout wire                              BP_DFI1_B3_WCK_C,
`endif
`endif
`endif

                       

//---------------change by jianwen for upf------------------
//`ifdef DWC_DDRPHY_TOP_PG_PINS
//   input              VDD ,
//   input              VDDQ,
//   input              VDD2H,              
//   input              VAA_VDD2H,              
//   input              VSS,
//`endif

   input  wire      BP_PWROK,                                 
   output wire      BP_MEMRESET_L,
   inout  wire      BP_DTO,
   output wire      BP_ATO,   
   inout  wire      BP_ZN  
               
   );

  `ifndef PREFIX_OPT_ENABLE
       dwc_ddrphy_top pac4a (
  `else
       `dwc_ddrphy_top pac4a (
  `endif
          //`include "prefix_dwc_ddrphy_upf_top.sv"

 // ----------DFI Interface  ------------------------------
.DfiClk                 ( DfiClk                  ),
.dfi_reset_n				( dfi_reset_n                     ),
.dfi0_address_P0			( dfi0_address_P0                 ), 
.dfi0_address_P1			( dfi0_address_P1                 ),
.dfi0_address_P2			( dfi0_address_P2                 ),
.dfi0_address_P3			( dfi0_address_P3                 ),

.dfi0_cke_P0				( dfi0_cke_P0                     ),
.dfi0_cke_P1			   ( dfi0_cke_P1                     ),
.dfi0_cke_P2				( dfi0_cke_P2                     ),
.dfi0_cke_P3			        ( dfi0_cke_P3                     ),

.dfi0_cs_P0                             ( dfi0_cs_P0                      ),
.dfi0_cs_P1                             ( dfi0_cs_P1                      ),
.dfi0_cs_P2                             ( dfi0_cs_P2                      ),
.dfi0_cs_P3                             ( dfi0_cs_P3                      ),

`ifdef DWC_DDRPHY_LPDDR5_ENABLED
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
`endif

.dfi0_ctrlupd_ack			( dfi0_ctrlupd_ack ),
.dfi0_ctrlupd_req			( dfi0_ctrlupd_req ),
`ifndef PUB_VERSION_LE_0200 //RID < 02003
.dfi0_ctrlupd_type	  (dfi0_ctrlupd_type ),
`endif

.dfi0_dram_clk_disable_P0		( dfi0_dram_clk_disable_P0        ),	
.dfi0_dram_clk_disable_P1		( dfi0_dram_clk_disable_P1        ),
.dfi0_dram_clk_disable_P2		( dfi0_dram_clk_disable_P2        ),	
.dfi0_dram_clk_disable_P3		( dfi0_dram_clk_disable_P3        ),

.dfi0_error				( dfi0_error                      ),
.dfi0_error_info			( dfi0_error_info                 ),
.dfi0_frequency		                ( dfi0_frequency                  ),
.dfi0_freq_ratio			( dfi0_freq_ratio                 ),
.dfi0_init_complete			( dfi0_init_complete              ),		
.dfi0_init_start			( dfi0_init_start                 ),
//.dfi0_phy_info_ack                      ( dfi0_phy_info_ack               ),
//.dfi0_phy_info_req                      ( dfi0_phy_info_req               ),
//.dfi0_phy_info_cmd                      ( dfi0_phy_info_cmd               ),
//.dfi0_phy_info_data                     ( dfi0_phy_info_data              ),
.dfi0_lp_ctrl_ack	                ( dfi0_lp_ctrl_ack                ),
.dfi0_lp_data_ack                       ( dfi0_lp_data_ack                ),
.dfi0_lp_ctrl_req			( dfi0_lp_ctrl_req                ),
.dfi0_lp_data_req			( dfi0_lp_data_req                ),
.dfi0_freq_fsp                          ( dfi0_freq_fsp                            ),
.dfi0_lp_ctrl_wakeup                    ( dfi0_lp_ctrl_wakeup             ),
.dfi0_lp_data_wakeup                    ( dfi0_lp_data_wakeup             ),
.dfi0_phymstr_ack			( dfi0_phymstr_ack ),		
.dfi0_phymstr_cs_state		        ( dfi0_phymstr_cs_state           ),		
.dfi0_phymstr_req			( dfi0_phymstr_req                ),	
.dfi0_phymstr_state_sel		        ( dfi0_phymstr_state_sel          ),		
.dfi0_phymstr_type			( dfi0_phymstr_type               ),
.dfi0_phyupd_ack			( dfi0_phyupd_ack  ),		
.dfi0_phyupd_req			( dfi0_phyupd_req                 ),		
.dfi0_phyupd_type			( dfi0_phyupd_type                ),
.dfi0_rddata_W0                         ( dfi0_rddata_W0                  ),
.dfi0_rddata_W1                         ( dfi0_rddata_W1                  ),
.dfi0_rddata_W2                         ( dfi0_rddata_W2                  ),
.dfi0_rddata_W3                         ( dfi0_rddata_W3                  ),
.dfi0_rddata_cs_P0			( dfi0_rddata_cs_P0               ),
.dfi0_rddata_cs_P1			( dfi0_rddata_cs_P1               ),
.dfi0_rddata_cs_P2			( dfi0_rddata_cs_P2               ),
.dfi0_rddata_cs_P3		        ( dfi0_rddata_cs_P3               ),
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
.dfi1_address_P0			( dfi1_address_P0             ), 
.dfi1_address_P1			( dfi1_address_P1             ),
.dfi1_address_P2			( dfi1_address_P2                 ),
.dfi1_address_P3			( dfi1_address_P3                 ),

.dfi1_cke_P0				( dfi1_cke_P0                 ),
.dfi1_cke_P1			        ( dfi1_cke_P1                 ),
.dfi1_cke_P2				( dfi1_cke_P2                     ),
.dfi1_cke_P3			        ( dfi1_cke_P3                     ),

.dfi1_cs_P0                             ( dfi1_cs_P0                  ),
.dfi1_cs_P1                             ( dfi1_cs_P1                  ),
.dfi1_cs_P2                             ( dfi1_cs_P2                      ),
.dfi1_cs_P3                             ( dfi1_cs_P3                      ),

`ifdef DWC_DDRPHY_LPDDR5_ENABLED
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
`endif

.dfi1_ctrlupd_ack			( dfi1_ctrlupd_ack ),
.dfi1_ctrlupd_req			( dfi1_ctrlupd_req ),
`ifndef PUB_VERSION_LE_0200 //RID < 02003
.dfi1_ctrlupd_type	  (dfi1_ctrlupd_type ),
`endif

.dfi1_dram_clk_disable_P0		( dfi1_dram_clk_disable_P0        ),	
.dfi1_dram_clk_disable_P1		( dfi1_dram_clk_disable_P1        ),
.dfi1_dram_clk_disable_P2		( dfi1_dram_clk_disable_P2        ),	
.dfi1_dram_clk_disable_P3		( dfi1_dram_clk_disable_P3        ),

.dfi1_error				( dfi1_error                      ),
.dfi1_error_info			( dfi1_error_info                 ),
.dfi1_frequency		                ( dfi1_frequency              ),
.dfi1_freq_ratio			( dfi1_freq_ratio             ),
.dfi1_init_complete			( dfi1_init_complete              ),		
.dfi1_init_start			( dfi1_init_start             ),
//.dfi1_phy_info_ack                      ( dfi1_phy_info_ack               ),
//.dfi1_phy_info_req                      ( dfi1_phy_info_req               ),
//.dfi1_phy_info_cmd                      ( dfi1_phy_info_cmd               ),
//.dfi1_phy_info_data                     ( dfi1_phy_info_data              ),
.dfi1_lp_ctrl_ack	                ( dfi1_lp_ctrl_ack                ),
.dfi1_lp_data_ack                       ( dfi1_lp_data_ack                ),
.dfi1_lp_ctrl_req			( dfi1_lp_ctrl_req                ),
.dfi1_lp_data_req			( dfi1_lp_data_req                ),
.dfi1_freq_fsp                          ( dfi1_freq_fsp                            ),
.dfi1_lp_ctrl_wakeup                    ( dfi1_lp_ctrl_wakeup             ),
.dfi1_lp_data_wakeup                    ( dfi1_lp_data_wakeup             ),
.dfi1_phymstr_ack			( dfi1_phymstr_ack ),		
.dfi1_phymstr_cs_state		        ( dfi1_phymstr_cs_state           ),		
.dfi1_phymstr_req			( dfi1_phymstr_req                ),	
.dfi1_phymstr_state_sel		        ( dfi1_phymstr_state_sel          ),		
.dfi1_phymstr_type			( dfi1_phymstr_type               ),
.dfi1_phyupd_ack			( dfi1_phyupd_ack  ),		
.dfi1_phyupd_req			( dfi1_phyupd_req                 ),		
.dfi1_phyupd_type			( dfi1_phyupd_type                ),
.dfi1_rddata_W0                         ( dfi1_rddata_W0                  ),
.dfi1_rddata_W1                         ( dfi1_rddata_W1                  ),
.dfi1_rddata_W2                         ( dfi1_rddata_W2                  ),
.dfi1_rddata_W3                         ( dfi1_rddata_W3                  ),
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
//---------------change by jianwen for upf------------------
`ifdef DWC_DDRPHY_TOP_PG_PINS
//.VDD					( VDD                             ),
//.VDDQ                                   ( VDDQ                            ), 
//.VSS					( VSS                            ),
//.VDD2H					( VDD2H                             ),
//.VAA_VDD2H			        ( VAA_VDD2H                             ),
`endif

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
.APBCLK			                ( APBCLK                         ),                       
.PADDR_APB				( PADDR_APB                           ),
.PWRITE_APB				( PWRITE_APB                          ),
.PRESETn_APB				( PRESETn_APB                         ),
.PSELx_APB				( PSELx_APB                            ),
.PENABLE_APB				( PENABLE_APB                         ),
.PWDATA_APB				( PWDATA_APB                          ),
.PSTRB_APB				( PSTRB_APB                            ),

.PPROT_APB				( PPROT_APB                           ),

.PREADY_APB				( PREADY_APB                          ),
.PRDATA_APB				( PRDATA_APB                          ),
.PSLVERR_APB				( PSLVERR_APB                         ),
                             
.PPROT_PIN				( PPROT_PIN                          ),

////------------------------ Bypass interface ------------------
`ifdef FLYOVER_TEST
  .RxTestClk  (RxTestClk),
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI0_B0_D                   (RxBypassRcvEn_DFI0_B0_D       ), 
  .RxBypassRcvEn_DFI0_B1_D                   (RxBypassRcvEn_DFI0_B1_D       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI0_B2_D                   (RxBypassRcvEn_DFI0_B2_D       ),
  .RxBypassRcvEn_DFI0_B3_D                   (RxBypassRcvEn_DFI0_B3_D       ),
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
  .RxBypassPadEn_DFI0_B0_D                   (RxBypassPadEn_DFI0_B0_D       ),
  .RxBypassPadEn_DFI0_B1_D                   (RxBypassPadEn_DFI0_B1_D       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI0_B2_D                   (RxBypassPadEn_DFI0_B2_D       ),
  .RxBypassPadEn_DFI0_B3_D                   (RxBypassPadEn_DFI0_B3_D       ),
`endif                                                                     
  .RxBypassDataPad_DFI0_B0_D                 (RxBypassDataPad_DFI0_B0_D          ),
  .RxBypassDataPad_DFI0_B1_D                 (RxBypassDataPad_DFI0_B1_D          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI0_B2_D                 (RxBypassDataPad_DFI0_B2_D          ),
  .RxBypassDataPad_DFI0_B3_D                 (RxBypassDataPad_DFI0_B3_D          ),
`endif                                                                   
  .TxBypassMode_DFI0_B0_D                    (TxBypassMode_DFI0_B0_D        ),
  .TxBypassMode_DFI0_B1_D                    (TxBypassMode_DFI0_B1_D        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassMode_DFI0_B2_D                    (TxBypassMode_DFI0_B2_D        ),
  .TxBypassMode_DFI0_B3_D                    (TxBypassMode_DFI0_B3_D        ),
`endif                                      
  .TxBypassOE_DFI0_B0_D                      (TxBypassOE_DFI0_B0_D        ),
  .TxBypassOE_DFI0_B1_D                      (TxBypassOE_DFI0_B1_D        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassOE_DFI0_B2_D                      (TxBypassOE_DFI0_B2_D        ),
  .TxBypassOE_DFI0_B3_D                      (TxBypassOE_DFI0_B3_D        ),
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
  //.TxBypassMode_DFI0_B2_DMI                  (TxBypassMode_DFI0_B2_DMI           ),
  //.TxBypassMode_DFI0_B3_DMI                  (TxBypassMode_DFI0_B3_DMI           ),
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
                                                                                
  .RxBypassRcvEn_DFI0_CA                     (RxBypassRcvEn_DFI0_CA ),
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
  .RxBypassPadEn_DFI0_CA                     (RxBypassPadEn_DFI0_CA),
  .RxBypassDataPad_DFI0_CA                   (RxBypassDataPad_DFI0_CA            ),
  .TxBypassMode_DFI0_CA                      (TxBypassMode_DFI0_CA ),
  .TxBypassOE_DFI0_CA                        (TxBypassOE_DFI0_CA ),
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
  .TxBypassMode_DFI0_B0_DQS                  (TxBypassMode_DFI0_B0_DQS           ),
  .TxBypassMode_DFI0_B1_DQS                  (TxBypassMode_DFI0_B1_DQS           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassMode_DFI0_B2_DQS                  (TxBypassMode_DFI0_B2_DQS           ),
  .TxBypassMode_DFI0_B3_DQS                  (TxBypassMode_DFI0_B3_DQS           ),
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
  .TxBypassMode_DFI0_B0_WCK                  (TxBypassMode_DFI0_B0_WCK           ),
  .TxBypassMode_DFI0_B1_WCK                  (TxBypassMode_DFI0_B1_WCK           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassMode_DFI0_B2_WCK                  (TxBypassMode_DFI0_B2_WCK           ),
  .TxBypassMode_DFI0_B3_WCK                  (TxBypassMode_DFI0_B3_WCK           ),
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
  .TxBypassMode_DFI0_CK                      (TxBypassMode_DFI0_CK               ),
  .TxBypassOE_DFI0_CK_T                      (TxBypassOE_DFI0_CK_T               ),
  .TxBypassOE_DFI0_CK_C                      (TxBypassOE_DFI0_CK_C               ),
  .TxBypassData_DFI0_CK_T                    (TxBypassData_DFI0_CK_T             ),
  .TxBypassData_DFI0_CK_C                    (TxBypassData_DFI0_CK_C             ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI0_LP4CKE_LP5CS           (RxBypassPadEn_DFI0_LP4CKE_LP5CS), 
  .RxBypassDataPad_DFI0_LP4CKE_LP5CS         (RxBypassDataPad_DFI0_LP4CKE_LP5CS  ),
  .TxBypassMode_DFI0_LP4CKE_LP5CS            (TxBypassMode_DFI0_LP4CKE_LP5CS ),
  .TxBypassOE_DFI0_LP4CKE_LP5CS              (TxBypassOE_DFI0_LP4CKE_LP5CS),
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
  .RxBypassRcvEn_DFI1_B0_D                   (RxBypassRcvEn_DFI1_B0_D       ), 
  .RxBypassRcvEn_DFI1_B1_D                   (RxBypassRcvEn_DFI1_B1_D      ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .RxBypassRcvEn_DFI1_B2_D                   (RxBypassRcvEn_DFI1_B2_D       ),
  .RxBypassRcvEn_DFI1_B3_D                   (RxBypassRcvEn_DFI1_B3_D       ),
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
  .RxBypassPadEn_DFI1_B0_D                   (RxBypassPadEn_DFI1_B0_D       ),
  .RxBypassPadEn_DFI1_B1_D                   (RxBypassPadEn_DFI1_B1_D       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
  .RxBypassPadEn_DFI1_B2_D                   (RxBypassPadEn_DFI1_B2_D       ),
  .RxBypassPadEn_DFI1_B3_D                   (RxBypassPadEn_DFI1_B3_D       ),
`endif                                                                     
  .RxBypassDataPad_DFI1_B0_D                 (RxBypassDataPad_DFI1_B0_D          ),
  .RxBypassDataPad_DFI1_B1_D                 (RxBypassDataPad_DFI1_B1_D          ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                
  .RxBypassDataPad_DFI1_B2_D                 (RxBypassDataPad_DFI1_B2_D          ),
  .RxBypassDataPad_DFI1_B3_D                 (RxBypassDataPad_DFI1_B3_D          ),
`endif                                                                   
  .TxBypassMode_DFI1_B0_D                    (TxBypassMode_DFI1_B0_D        ),
  .TxBypassMode_DFI1_B1_D                    (TxBypassMode_DFI1_B1_D        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4   
  .TxBypassMode_DFI1_B2_D                    (TxBypassMode_DFI1_B2_D        ),
  .TxBypassMode_DFI1_B3_D                    (TxBypassMode_DFI1_B3_D        ),
`endif                                      
  .TxBypassOE_DFI1_B0_D                      (TxBypassOE_DFI1_B0_D        ),
  .TxBypassOE_DFI1_B1_D                      (TxBypassOE_DFI1_B1_D        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4 
  .TxBypassOE_DFI1_B2_D                      (TxBypassOE_DFI1_B2_D        ),
  .TxBypassOE_DFI1_B3_D                      (TxBypassOE_DFI1_B3_D        ),
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
                                                                                
  .RxBypassRcvEn_DFI1_CA                     (RxBypassRcvEn_DFI1_CA ),
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
  .RxBypassPadEn_DFI1_CA                     (RxBypassPadEn_DFI1_CA ),
  .RxBypassDataPad_DFI1_CA                   (RxBypassDataPad_DFI1_CA            ),
  .TxBypassMode_DFI1_CA                      (TxBypassMode_DFI1_CA ),
  .TxBypassOE_DFI1_CA                        (TxBypassOE_DFI1_CA),
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
  .TxBypassMode_DFI1_B0_DQS                  (TxBypassMode_DFI1_B0_DQS           ),
  .TxBypassMode_DFI1_B1_DQS                  (TxBypassMode_DFI1_B1_DQS           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassMode_DFI1_B2_DQS                  (TxBypassMode_DFI1_B2_DQS           ),
  .TxBypassMode_DFI1_B3_DQS                  (TxBypassMode_DFI1_B3_DQS           ),
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
  .TxBypassMode_DFI1_B0_WCK                  (TxBypassMode_DFI1_B0_WCK           ),
  .TxBypassMode_DFI1_B1_WCK                  (TxBypassMode_DFI1_B1_WCK           ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                                       
  .TxBypassMode_DFI1_B2_WCK                  (TxBypassMode_DFI1_B2_WCK           ),
  .TxBypassMode_DFI1_B3_WCK                  (TxBypassMode_DFI1_B3_WCK           ),
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
  .TxBypassMode_DFI1_CK                      (TxBypassMode_DFI1_CK               ),
  .TxBypassOE_DFI1_CK_T                      (TxBypassOE_DFI1_CK_T               ),
  .TxBypassOE_DFI1_CK_C                      (TxBypassOE_DFI1_CK_C               ),
  .TxBypassData_DFI1_CK_T                    (TxBypassData_DFI1_CK_T             ),
  .TxBypassData_DFI1_CK_C                    (TxBypassData_DFI1_CK_C             ),

//************************* SEC ********************************//
  .RxBypassPadEn_DFI1_LP4CKE_LP5CS           (RxBypassPadEn_DFI1_LP4CKE_LP5CS ), 
  .RxBypassDataPad_DFI1_LP4CKE_LP5CS         (RxBypassDataPad_DFI1_LP4CKE_LP5CS  ),
  .TxBypassMode_DFI1_LP4CKE_LP5CS            (TxBypassMode_DFI1_LP4CKE_LP5CS ),
  .TxBypassOE_DFI1_LP4CKE_LP5CS              (TxBypassOE_DFI1_LP4CKE_LP5CS ),
  .TxBypassData_DFI1_LP4CKE_LP5CS            (TxBypassData_DFI1_LP4CKE_LP5CS     ),
`endif
`else
//.RxBypassDataPad_DFI0_CA		            ( RxBypassDataPad_DFI0_CA         ),
//.RxBypassDataPad_DFI0_LP4CKE_LP5CS 	   ( RxBypassDataPad_DFI0_LP4CKE_LP5CS),
//.RxBypassDataPad_DFI0_CK_T              ( RxBypassDataPad_DFI0_CK_T       ),
//.RxBypassDataPad_DFI0_CK_C              ( RxBypassDataPad_DFI0_CK_C       ),
//.RxBypassDataPad_DFI0_B0_D              ( RxBypassDataPad_DFI0_B0_D       ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassDataPad_DFI0_B0_DMI            ( RxBypassDataPad_DFI0_B0_DMI     ),
//`endif
//.RxBypassDataPad_DFI0_B0_DQS_T          ( RxBypassDataPad_DFI0_B0_DQS_T   ), 
//.RxBypassDataPad_DFI0_B0_DQS_C          ( RxBypassDataPad_DFI0_B0_DQS_C   ),
//.RxBypassDataPad_DFI0_B1_D              ( RxBypassDataPad_DFI0_B1_D       ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassDataPad_DFI0_B1_DMI            ( RxBypassDataPad_DFI0_B1_DMI     ),
//`endif
//.RxBypassDataPad_DFI0_B1_DQS_T          ( RxBypassDataPad_DFI0_B1_DQS_T   ), 
//.RxBypassDataPad_DFI0_B1_DQS_C          ( RxBypassDataPad_DFI0_B1_DQS_C   ),
//.RxBypassDataPad_DFI0_B2_D              ( RxBypassDataPad_DFI0_B2_D       ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassDataPad_DFI0_B2_DMI            ( RxBypassDataPad_DFI0_B2_DMI     ),
//`endif
//.RxBypassDataPad_DFI0_B2_DQS_T          ( RxBypassDataPad_DFI0_B2_DQS_T   ), 
//.RxBypassDataPad_DFI0_B2_DQS_C          ( RxBypassDataPad_DFI0_B2_DQS_C   ),
//.RxBypassDataPad_DFI0_B3_D              ( RxBypassDataPad_DFI0_B3_D       ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassDataPad_DFI0_B3_DMI            ( RxBypassDataPad_DFI0_B3_DMI     ),
//`endif
//.RxBypassDataPad_DFI0_B3_DQS_T          ( RxBypassDataPad_DFI0_B3_DQS_T   ), 
//.RxBypassDataPad_DFI0_B3_DQS_C          ( RxBypassDataPad_DFI0_B3_DQS_C   ),
//
//.RxBypassData_DFI0_CA		        ( RxBypassData_DFI0_CA            ),
//.RxBypassDataRcv_DFI0_CK_T              ( RxBypassDataRcv_DFI0_CK_T       ),
//.RxBypassDataRcv_DFI0_CK_C              ( RxBypassDataRcv_DFI0_CK_C       ),
//.RxBypassData_DFI0_B0_D                 ( RxBypassData_DFI0_B0_D          ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassData_DFI0_B0_DMI               ( RxBypassData_DFI0_B0_DMI        ),
//`endif
//.RxBypassDataRcv_DFI0_B0_DQS_T          ( RxBypassDataRcv_DFI0_B0_DQS_T   ), 
//.RxBypassDataRcv_DFI0_B0_DQS_C          ( RxBypassDataRcv_DFI0_B0_DQS_C   ),
//.RxBypassData_DFI0_B1_D                 ( RxBypassData_DFI0_B1_D          ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassData_DFI0_B1_DMI               ( RxBypassData_DFI0_B1_DMI        ),
//`endif
//.RxBypassDataRcv_DFI0_B1_DQS_T          ( RxBypassDataRcv_DFI0_B1_DQS_T   ), 
//.RxBypassDataRcv_DFI0_B1_DQS_C          ( RxBypassDataRcv_DFI0_B1_DQS_C   ),
//.RxBypassData_DFI0_B2_D                 ( RxBypassData_DFI0_B2_D          ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassData_DFI0_B2_DMI               ( RxBypassData_DFI0_B2_DMI        ),
//`endif
//.RxBypassDataRcv_DFI0_B2_DQS_T          ( RxBypassDataRcv_DFI0_B2_DQS_T   ), 
//.RxBypassDataRcv_DFI0_B2_DQS_C          ( RxBypassDataRcv_DFI0_B2_DQS_C   ),
//.RxBypassData_DFI0_B3_D                 ( RxBypassData_DFI0_B3_D          ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassData_DFI0_B3_DMI               ( RxBypassData_DFI0_B3_DMI        ),
//`endif
//.RxBypassDataRcv_DFI0_B3_DQS_T          ( RxBypassDataRcv_DFI0_B3_DQS_T   ), 
//.RxBypassDataRcv_DFI0_B3_DQS_C          ( RxBypassDataRcv_DFI0_B3_DQS_C   ),
//
//.RxTestClk_DFI0_CA                      ( RxTestClk_DFI0_CA               ),
//.RxTestClk_DFI0_B0_D                    ( RxTestClk_DFI0_B0_D             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxTestClk_DFI0_B0_DMI                  ( RxTestClk_DFI0_B0_DMI           ),
//`endif
//.RxTestClk_DFI0_B1_D                    ( RxTestClk_DFI0_B1_D             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxTestClk_DFI0_B1_DMI                  ( RxTestClk_DFI0_B1_DMI           ),
//`endif
//.RxTestClk_DFI0_B2_D                    ( RxTestClk_DFI0_B2_D             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxTestClk_DFI0_B2_DMI                  ( RxTestClk_DFI0_B2_DMI           ),
//`endif
//.RxTestClk_DFI0_B3_D                    ( RxTestClk_DFI0_B3_D             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxTestClk_DFI0_B3_DMI                  ( RxTestClk_DFI0_B3_DMI           ),
//`endif
//
//
//
//.RxBypassDataPad_DTO                    ( RxBypassDataPad_DTO             ),
//.RxBypassDataSel                        ( RxBypassDataSel                 ),
//.RxBypassEn_DFI0_CA                     ( RxBypassEn_DFI0_CA              ),
//.RxBypassEn_DFI0_LP4CKE_LP5CS           ( RxBypassEn_DFI0_LP4CKE_LP5CS    ),
//.RxBypassEn_DFI0_CK                     ( RxBypassEn_DFI0_CK              ),
//.RxBypassEn_DTO                         ( RxBypassEn_DTO                  ),
//.RxBypassEn_DFI0_B0_D                   ( RxBypassEn_DFI0_B0_D            ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassEn_DFI0_B0_DMI                 ( RxBypassEn_DFI0_B0_DMI          ),
//`endif
//.RxBypassEn_DFI0_B0_DQS                 ( RxBypassEn_DFI0_B0_DQS          ),
//.RxBypassEn_DFI0_B1_D                   ( RxBypassEn_DFI0_B1_D            ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassEn_DFI0_B1_DMI                 ( RxBypassEn_DFI0_B1_DMI          ),
//`endif
//.RxBypassEn_DFI0_B1_DQS                 ( RxBypassEn_DFI0_B1_DQS          ),
//.RxBypassEn_DFI0_B2_D                   ( RxBypassEn_DFI0_B2_D            ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassEn_DFI0_B2_DMI                 ( RxBypassEn_DFI0_B2_DMI          ),
//`endif
//.RxBypassEn_DFI0_B2_DQS                 ( RxBypassEn_DFI0_B2_DQS          ),
//.RxBypassEn_DFI0_B3_D                   ( RxBypassEn_DFI0_B3_D            ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassEn_DFI0_B3_DMI                 ( RxBypassEn_DFI0_B3_DMI          ),
//`endif
//.RxBypassEn_DFI0_B3_DQS                 ( RxBypassEn_DFI0_B3_DQS          ),

//.RxBypassRcvEn_DFI0_CA                    ( {(6+`DWC_DDRPHY_NUM_RANKS){1'b0}}),
//.RxBypassRcvEn_DFI0_CK                    ( 1'b0                             ),
//.RxBypassRcvEn_DFI0_B0_D                  ( 8'b0                             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassRcvEn_DFI0_B0_DMI                ( 1'b0                             ),
//`endif
//.RxBypassRcvEn_DFI0_B0_DQS                ( 1'b0                             ),
//`ifdef DWC_DDRPHY_LPDDR5_ENABLED
//.RxBypassRcvEn_DFI0_B0_WCK                ( 1'b0                             ), 
//`endif
//.RxBypassRcvEn_DFI0_B1_D                  ( 8'b0                             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassRcvEn_DFI0_B1_DMI                ( 1'b0                             ),
//`endif
//.RxBypassRcvEn_DFI0_B1_DQS                ( 1'b0                             ),
//`ifdef DWC_DDRPHY_LPDDR5_ENABLED
//.RxBypassRcvEn_DFI0_B1_WCK                ( 1'b0                             ), 
//`endif
//.RxBypassRcvEn_DFI0_B2_D                  ( 8'b0                             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassRcvEn_DFI0_B2_DMI                ( 1'b0                             ),
//`endif
//.RxBypassRcvEn_DFI0_B2_DQS                ( 1'b0                             ),
//`ifdef DWC_DDRPHY_LPDDR5_ENABLED
//.RxBypassRcvEn_DFI0_B2_WCK                ( 1'b0                             ), 
//`endif
//.RxBypassRcvEn_DFI0_B3_D                  ( 8'b0                             ),
//`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
//.RxBypassRcvEn_DFI0_B3_DMI                ( 1'b0                             ),
//`endif
//.RxBypassRcvEn_DFI0_B3_DQS                ( 1'b0                             ),
//`ifdef DWC_DDRPHY_LPDDR5_ENABLED
//.RxBypassRcvEn_DFI0_B3_WCK                ( 1'b0                             ), 
//`endif             

//.TxBypassMode_DFI0_CA                     ( TxBypassMode_DFI0_CA),
//.TxBypassMode_DFI0_LP4CKE_LP5CS           ( TxBypassMode_DFI0_LP4CKE_LP5CS    ),
.TxBypassMode_DFI0_CK_T                   ( TxBypassMode_DFI0_CK_T            ),
.TxBypassMode_DFI0_CK_C                   ( TxBypassMode_DFI0_CK_C            ),
.TxBypassData_DFI0_CK_T                   ( TxBypassData_DFI0_CK_T            ),
.TxBypassData_DFI0_CK_C                   ( TxBypassData_DFI0_CK_C            ),
//.TxBypassMode_DFI0_B0_D                   ( TxBypassMode_DFI0_B0_D            ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
.TxBypassMode_DFI0_B0_DMI                 ( TxBypassMode_DFI0_B0_DMI                             ), 
`endif
.TxBypassMode_DFI0_B0_DQS_T               ( TxBypassMode_DFI0_B0_DQS_T                                      ),
.TxBypassMode_DFI0_B0_DQS_C               ( TxBypassMode_DFI0_B0_DQS_C                                      ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.TxBypassMode_DFI0_B0_WCK_T               ( TxBypassMode_DFI0_B0_WCK_T                             ),
.TxBypassMode_DFI0_B0_WCK_C               ( TxBypassMode_DFI0_B0_WCK_C                             ),
`endif                                      
//.TxBypassMode_DFI0_B1_D                   ( TxBypassMode_DFI0_B1_D                                 ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED         
.TxBypassMode_DFI0_B1_DMI                 ( TxBypassMode_DFI0_B1_DMI                               ), 
`endif                                      
.TxBypassMode_DFI0_B1_DQS_T               ( TxBypassMode_DFI0_B1_DQS_T                             ),
.TxBypassMode_DFI0_B1_DQS_C               ( TxBypassMode_DFI0_B1_DQS_C                             ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED            
.TxBypassMode_DFI0_B1_WCK_T               ( TxBypassMode_DFI0_B1_WCK_T                             ),
.TxBypassMode_DFI0_B1_WCK_C               ( TxBypassMode_DFI0_B1_WCK_C                             ),
`endif                                      
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
//.TxBypassMode_DFI0_B2_D                   ( TxBypassMode_DFI0_B2_D                                 ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED         
.TxBypassMode_DFI0_B2_DMI                 ( TxBypassMode_DFI0_B2_DMI                               ), 
`endif                                      
.TxBypassMode_DFI0_B2_DQS_T               ( TxBypassMode_DFI0_B2_DQS_T                             ),
.TxBypassMode_DFI0_B2_DQS_C               ( TxBypassMode_DFI0_B2_DQS_C                             ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED            
.TxBypassMode_DFI0_B2_WCK_T               ( TxBypassMode_DFI0_B2_WCK_T                                      ),
.TxBypassMode_DFI0_B2_WCK_C               ( TxBypassMode_DFI0_B2_WCK_C                                      ),
`endif                                      
//.TxBypassMode_DFI0_B3_D                   ( TxBypassMode_DFI0_B3_D                                          ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED        
.TxBypassMode_DFI0_B3_DMI                 ( TxBypassMode_DFI0_B3_DMI                                        ), 
`endif                                      
.TxBypassMode_DFI0_B3_DQS_T               ( TxBypassMode_DFI0_B3_DQS_T                                      ),
.TxBypassMode_DFI0_B3_DQS_C               ( TxBypassMode_DFI0_B3_DQS_C                                      ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED            
.TxBypassMode_DFI0_B3_WCK_T               ( TxBypassMode_DFI0_B3_WCK_T                                      ),
.TxBypassMode_DFI0_B3_WCK_C               ( TxBypassMode_DFI0_B3_WCK_C                                      ),
`endif                                      
`endif                                      
                                                                               
`ifdef DWC_DDRPHY_NUM_CHANNELS_2            
.TxBypassMode_DFI1_CA                     ( TxBypassMode_DFI1_CA               ),
.TxBypassMode_DFI1_LP4CKE_LP5CS           ( TxBypassMode_DFI1_LP4CKE_LP5CS     ),
.TxBypassMode_DFI1_CK_T                   ( TxBypassMode_DFI1_CK_T               ),
.TxBypassMode_DFI1_CK_C                   ( TxBypassMode_DFI1_CK_C               ),
.TxBypassData_DFI1_CK_T                   ( TxBypassData_DFI1_CK_T             ),
.TxBypassData_DFI1_CK_C                   ( TxBypassData_DFI1_CK_C             ),
.TxBypassMode_DFI1_B0_D                   ( TxBypassMode_DFI1_B0_D             ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED         
.TxBypassMode_DFI1_B0_DMI                 ( TxBypassMode_DFI1_B0_DMI           ), 
`endif                                      
.TxBypassMode_DFI1_B0_DQS_T               ( TxBypassMode_DFI1_B0_DQS_T         ),
.TxBypassMode_DFI1_B0_DQS_C               ( TxBypassMode_DFI1_B0_DQS_C         ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED           
.TxBypassMode_DFI1_B0_WCK_T               ( TxBypassMode_DFI1_B0_WCK_T         ),
.TxBypassMode_DFI1_B0_WCK_C               ( TxBypassMode_DFI1_B0_WCK_C         ),
`endif
.TxBypassMode_DFI1_B1_D                   ( TxBypassMode_DFI1_B1_D                                ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED         
.TxBypassMode_DFI1_B1_DMI                 ( TxBypassMode_DFI1_B1_DMI                              ), 
`endif                                      
.TxBypassMode_DFI1_B1_DQS_T               ( TxBypassMode_DFI1_B1_DQS_T                            ),
.TxBypassMode_DFI1_B1_DQS_C               ( TxBypassMode_DFI1_B1_DQS_C                            ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED            
.TxBypassMode_DFI1_B1_WCK_T               ( TxBypassMode_DFI1_B1_WCK_T                            ),
.TxBypassMode_DFI1_B1_WCK_C               ( TxBypassMode_DFI1_B1_WCK_C                            ),
`endif                                      
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  
.TxBypassMode_DFI1_B2_D                   ( TxBypassMode_DFI1_B2_D                                ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED         
.TxBypassMode_DFI1_B2_DMI                 ( TxBypassMode_DFI1_B2_DMI                              ), 
`endif                                      
.TxBypassMode_DFI1_B2_DQS_T               ( TxBypassMode_DFI1_B2_DQS_T                            ),
.TxBypassMode_DFI1_B2_DQS_C               ( TxBypassMode_DFI1_B2_DQS_C                            ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED            
.TxBypassMode_DFI1_B2_WCK_T               ( TxBypassMode_DFI1_B2_WCK_T                            ),
.TxBypassMode_DFI1_B2_WCK_C               ( TxBypassMode_DFI1_B2_WCK_C                            ),
`endif                                      
.TxBypassMode_DFI1_B3_D                   ( TxBypassMode_DFI1_B3_D                                ),
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED         
.TxBypassMode_DFI1_B3_DMI                 ( TxBypassMode_DFI1_B3_DMI                              ), 
`endif                                      
.TxBypassMode_DFI1_B3_DQS_T               ( TxBypassMode_DFI1_B3_DQS_T                            ),
.TxBypassMode_DFI1_B3_DQS_C               ( TxBypassMode_DFI1_B3_DQS_C                            ),
`ifdef DWC_DDRPHY_LPDDR5_ENABLED            
.TxBypassMode_DFI1_B3_WCK_T               ( TxBypassMode_DFI1_B3_WCK_T                            ),
.TxBypassMode_DFI1_B3_WCK_C               ( TxBypassMode_DFI1_B3_WCK_C                            ),
`endif                                      
`endif                                      
`endif                                      
                                                                      
.TxBypassMode_MEMRESET_L                   (TxBypassMode_MEMRESET_L                                ),
.TxBypassData_MEMRESET_L                   (TxBypassData_MEMRESET_L                                ),
`endif  //FLYOVER_TEST
////////////////////////////////////////////////////////////////////////////////
// TOP LEVEL I/Os: RESETs/CLKs
////////////////////////////////////////////////////////////////////////////////

 //.PwrOkIn                               ( PwrOkIn                         ),
 .BP_PWROK                              ( BP_PWROK                         ),
`ifdef FLYOVER_TEST
 .Reset                                 (Reset),
 .Reset_async                           (Reset_async),
`else
 .Reset                                 ( Reset                           ),
 .Reset_async                           ( Reset_async                           ),
`endif
 //.BypassPclk                            ( bypass_clk                      ),
 .BurnIn                                ( BurnIn                            ),
 .PllRefClk                             (PllRefClk               ), 
 .PllBypClk                             (PllBypClk                       ),       
////////////////////////////////////////////////////////////////////////////////
// TOP LEVEL I/Os: ATPG/JTAG
////////////////////////////////////////////////////////////////////////////////
`ifdef FLYOVER_TEST
   .atpg_se						(atpg_se),
   .atpg_si						(atpg_si),
   .atpg_so						(atpg_so),
   .atpg_mode				   (atpg_mode),
`else
.atpg_mode                              ( atpg_mode                           ),
.atpg_se                                (atpg_se),
.atpg_si                                (atpg_si),
.atpg_so                                ( atpg_so                        ),
`endif
//.atpg_lu_ctrl                           ( {6{1'b1}}                      ),
.atpg_RDQSClk                           ( atpg_RDQSClk                           ),
//.atpg_Pclk                              ( 1'b0                           ),
.atpg_TxDllClk                          ( atpg_TxDllClk                           ),

`ifdef DWC_DDRPHY_LBIST_EN
`ifndef PUB_VERSION_GE_0100
 .DfiClk0_lbist      (DfiClk0_lbist),
`endif
 .lbist_mode         (lbist_mode),
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
.atpg_PllCtrlBus                        ( atpg_PllCtrlBus        ), 
.atpg_Asst_Clken                        ( atpg_Asst_Clken        ), 
.atpg_Asst_Clk                          ( atpg_Asst_Clk          ), 
.atpg_UcClk                             ( atpg_UcClk             ),

.dfi0_ctrlmsg                           ( dfi0_ctrlmsg        ),
.dfi0_ctrlmsg_ack                       ( dfi0_ctrlmsg_ack    ),
.dfi0_ctrlmsg_data                      ( dfi0_ctrlmsg_data   ),
.dfi0_ctrlmsg_req                       ( dfi0_ctrlmsg_req    ),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dfi1_ctrlmsg                           ( dfi1_ctrlmsg        ),
.dfi1_ctrlmsg_ack                       (  dfi1_ctrlmsg_ack                  ),
.dfi1_ctrlmsg_data                      ( dfi1_ctrlmsg_data    ),
.dfi1_ctrlmsg_req                       ( dfi1_ctrlmsg_req    ),
`endif
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
.dfi0_wck_write_P0          (dfi0_wck_write_P0),   
.dfi0_wck_write_P1          (dfi0_wck_write_P1),
.dfi0_wck_write_P2          (dfi0_wck_write_P2),
.dfi0_wck_write_P3          (dfi0_wck_write_P3),
.dfi0_wrdata_link_ecc_P0                ( dfi0_wrdata_link_ecc_P0 ),
.dfi0_wrdata_link_ecc_P1                ( dfi0_wrdata_link_ecc_P1 ),
.dfi0_wrdata_link_ecc_P2                ( dfi0_wrdata_link_ecc_P2 ),
.dfi0_wrdata_link_ecc_P3                ( dfi0_wrdata_link_ecc_P3 ),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dfi1_wck_write_P0                      (dfi1_wck_write_P0),   
.dfi1_wck_write_P1                      (dfi1_wck_write_P1),
.dfi1_wck_write_P2                      (dfi1_wck_write_P2),
.dfi1_wck_write_P3                      (dfi1_wck_write_P3),

.dfi1_wrdata_link_ecc_P0                ( dfi1_wrdata_link_ecc_P0 ),
.dfi1_wrdata_link_ecc_P1                ( dfi1_wrdata_link_ecc_P1 ),
.dfi1_wrdata_link_ecc_P2                ( dfi1_wrdata_link_ecc_P2 ),
.dfi1_wrdata_link_ecc_P3                ( dfi1_wrdata_link_ecc_P3 ),
`endif
`endif
.UcClk                                  ( UcClk                  ), 
.PhyInt_n                               ( PhyInt_n               ), 
.PhyInt_fault                           ( PhyInt_fault           ), 
.dwc_ddrphy0_snoop_en_P0                ( dwc_ddrphy0_snoop_en_P0 ),
.dwc_ddrphy0_snoop_en_P1                ( dwc_ddrphy0_snoop_en_P1 ),
.dwc_ddrphy0_snoop_en_P2                ( dwc_ddrphy0_snoop_en_P2 ),
.dwc_ddrphy0_snoop_en_P3                ( dwc_ddrphy0_snoop_en_P3 ),
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
.dwc_ddrphy1_snoop_en_P0                ( dwc_ddrphy1_snoop_en_P0 ),
.dwc_ddrphy1_snoop_en_P1                ( dwc_ddrphy1_snoop_en_P1 ),
.dwc_ddrphy1_snoop_en_P2                ( dwc_ddrphy1_snoop_en_P2 ),
.dwc_ddrphy1_snoop_en_P3                ( dwc_ddrphy1_snoop_en_P3 ),
`endif
.atpg_PClk                              ( atpg_PClk                              ),
.atpg_DlyTestClk                        ( atpg_DlyTestClk                        ),
.haddr_ahb                              ( haddr_ahb                              ),
.hburst_ahb                             ( hburst_ahb                             ),
.hmastlock_ahb                          ( hmastlock_ahb                          ),
.hprot_ahb                              ( hprot_ahb                              ),
.hsize_ahb                              ( hsize_ahb                              ),
.htrans_ahb                             ( htrans_ahb                             ),
.hwdata_ahb                             ( hwdata_ahb                             ),
.hwrite_ahb                             ( hwrite_ahb                             ),
.hclk_ahb                               ( hclk_ahb                               ),
.hresetn_ahb                            ( hresetn_ahb                            ),
.hrdata_ahb                             ( hrdata_ahb                             ),
.hresp_ahb                              ( hresp_ahb                              ),
.hreadyout_ahb                          ( hreadyout_ahb                          ),
.ps_ram_rddata                          ( ps_ram_rddata                          ),
.ps_ram_wrdata                          ( ps_ram_wrdata                          ),
.ps_ram_addr                            ( ps_ram_addr                            ),
.ps_ram_ce                              ( ps_ram_ce                              ),
.ps_ram_we                              ( ps_ram_we                              ),
  .RxTestClk                                 (RxTestClk),
//***********************SE: DQ/DMI/CA******************************//
  .RxBypassRcvEn_DFI0_B0_D                   (RxBypassRcvEn_DFI0_B0_D          ),                 
  .RxBypassRcvEn_DFI0_B1_D                   (RxBypassRcvEn_DFI0_B1_D    ),       
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI0_B2_D                   (RxBypassRcvEn_DFI0_B2_D    ), 
  .RxBypassRcvEn_DFI0_B3_D                   (RxBypassRcvEn_DFI0_B3_D    ),
`endif                                                            
  .RxBypassData_DFI0_B0_D0                   (RxBypassData_DFI0_B0_D0    ),
  .RxBypassData_DFI0_B0_D1                   (RxBypassData_DFI0_B0_D1    ),
  .RxBypassData_DFI0_B0_D2                   (RxBypassData_DFI0_B0_D2    ),
  .RxBypassData_DFI0_B0_D3                   (RxBypassData_DFI0_B0_D3    ),
  .RxBypassData_DFI0_B0_D4                   (RxBypassData_DFI0_B0_D4    ),
  .RxBypassData_DFI0_B0_D5                   (RxBypassData_DFI0_B0_D5    ),
  .RxBypassData_DFI0_B0_D6                   (RxBypassData_DFI0_B0_D6    ),
  .RxBypassData_DFI0_B0_D7                   (RxBypassData_DFI0_B0_D7    ),
  .RxBypassData_DFI0_B1_D0                   (RxBypassData_DFI0_B1_D0    ),
  .RxBypassData_DFI0_B1_D1                   (RxBypassData_DFI0_B1_D1    ),
  .RxBypassData_DFI0_B1_D2                   (RxBypassData_DFI0_B1_D2    ),
  .RxBypassData_DFI0_B1_D3                   (RxBypassData_DFI0_B1_D3    ),
  .RxBypassData_DFI0_B1_D4                   (RxBypassData_DFI0_B1_D4    ),
  .RxBypassData_DFI0_B1_D5                   (RxBypassData_DFI0_B1_D5    ),
  .RxBypassData_DFI0_B1_D6                   (RxBypassData_DFI0_B1_D6    ),
  .RxBypassData_DFI0_B1_D7                   (RxBypassData_DFI0_B1_D7    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassData_DFI0_B2_D0                   (RxBypassData_DFI0_B2_D0    ),
  .RxBypassData_DFI0_B2_D1                   (RxBypassData_DFI0_B2_D1    ),
  .RxBypassData_DFI0_B2_D2                   (RxBypassData_DFI0_B2_D2    ),
  .RxBypassData_DFI0_B2_D3                   (RxBypassData_DFI0_B2_D3    ),
  .RxBypassData_DFI0_B2_D4                   (RxBypassData_DFI0_B2_D4    ),
  .RxBypassData_DFI0_B2_D5                   (RxBypassData_DFI0_B2_D5    ),
  .RxBypassData_DFI0_B2_D6                   (RxBypassData_DFI0_B2_D6    ),
  .RxBypassData_DFI0_B2_D7                   (RxBypassData_DFI0_B2_D7    ),
  .RxBypassData_DFI0_B3_D0                   (RxBypassData_DFI0_B3_D0    ),
  .RxBypassData_DFI0_B3_D1                   (RxBypassData_DFI0_B3_D1    ),
  .RxBypassData_DFI0_B3_D2                   (RxBypassData_DFI0_B3_D2    ),
  .RxBypassData_DFI0_B3_D3                   (RxBypassData_DFI0_B3_D3    ),
  .RxBypassData_DFI0_B3_D4                   (RxBypassData_DFI0_B3_D4    ),
  .RxBypassData_DFI0_B3_D5                   (RxBypassData_DFI0_B3_D5    ),
  .RxBypassData_DFI0_B3_D6                   (RxBypassData_DFI0_B3_D6    ),
  .RxBypassData_DFI0_B3_D7                   (RxBypassData_DFI0_B3_D7    ),
`endif                                                                
  .RxBypassPadEn_DFI0_B0_D                   (RxBypassPadEn_DFI0_B0_D    ),
  .RxBypassPadEn_DFI0_B1_D                   (RxBypassPadEn_DFI0_B1_D    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI0_B2_D                   (RxBypassPadEn_DFI0_B2_D    ),
  .RxBypassPadEn_DFI0_B3_D                   (RxBypassPadEn_DFI0_B3_D    ),
`endif                                                                
  .RxBypassDataPad_DFI0_B0_D                 (RxBypassDataPad_DFI0_B0_D  ),
  .RxBypassDataPad_DFI0_B1_D                 (RxBypassDataPad_DFI0_B1_D  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI0_B2_D                 (RxBypassDataPad_DFI0_B2_D  ),
  .RxBypassDataPad_DFI0_B3_D                 (RxBypassDataPad_DFI0_B3_D  ),
`endif                                                                
  .TxBypassMode_DFI0_B0_D                    (TxBypassMode_DFI0_B0_D     ),
  .TxBypassMode_DFI0_B1_D                    (TxBypassMode_DFI0_B1_D     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassMode_DFI0_B2_D                    (TxBypassMode_DFI0_B2_D     ),
  .TxBypassMode_DFI0_B3_D                    (TxBypassMode_DFI0_B3_D     ),
`endif                                                                
  .TxBypassOE_DFI0_B0_D                      (TxBypassOE_DFI0_B0_D       ),
  .TxBypassOE_DFI0_B1_D                      (TxBypassOE_DFI0_B1_D       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI0_B2_D                      (TxBypassOE_DFI0_B2_D       ),
  .TxBypassOE_DFI0_B3_D                      (TxBypassOE_DFI0_B3_D       ),
`endif                                                                
  .TxBypassData_DFI0_B0_D                    (TxBypassData_DFI0_B0_D     ),
  .TxBypassData_DFI0_B1_D                    (TxBypassData_DFI0_B1_D     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI0_B2_D                    (TxBypassData_DFI0_B2_D     ),
  .TxBypassData_DFI0_B3_D                    (TxBypassData_DFI0_B3_D     ),
`endif                                                                
                                                                         
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED           
  .RxBypassRcvEn_DFI0_B0_DMI                 (RxBypassRcvEn_DFI0_B0_DMI  ),
  .RxBypassRcvEn_DFI0_B1_DMI                 (RxBypassRcvEn_DFI0_B1_DMI  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI0_B2_DMI                 (RxBypassRcvEn_DFI0_B2_DMI  ),
  .RxBypassRcvEn_DFI0_B3_DMI                 (RxBypassRcvEn_DFI0_B3_DMI  ),
`endif                                                                
  .RxBypassData_DFI0_B0_DMI                  (RxBypassData_DFI0_B0_DMI   ),
  .RxBypassData_DFI0_B1_DMI                  (RxBypassData_DFI0_B1_DMI   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassData_DFI0_B2_DMI                  (RxBypassData_DFI0_B2_DMI   ),
  .RxBypassData_DFI0_B3_DMI                  (RxBypassData_DFI0_B3_DMI   ),
`endif                                                               
  .RxBypassPadEn_DFI0_B0_DMI                 (RxBypassPadEn_DFI0_B0_DMI  ),
  .RxBypassPadEn_DFI0_B1_DMI                 (RxBypassPadEn_DFI0_B1_DMI  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI0_B2_DMI                 (RxBypassPadEn_DFI0_B2_DMI  ),
  .RxBypassPadEn_DFI0_B3_DMI                 (RxBypassPadEn_DFI0_B3_DMI  ),
`endif                                                                
  .RxBypassDataPad_DFI0_B0_DMI               (RxBypassDataPad_DFI0_B0_DMI),
  .RxBypassDataPad_DFI0_B1_DMI               (RxBypassDataPad_DFI0_B1_DMI),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI0_B2_DMI               (RxBypassDataPad_DFI0_B2_DMI),
  .RxBypassDataPad_DFI0_B3_DMI               (RxBypassDataPad_DFI0_B3_DMI),
`endif                                                                
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  //.TxBypassMode_DFI0_B2_DMI                  (TxBypassMode_DFI0_B2_DMI   ),
  //.TxBypassMode_DFI0_B3_DMI                  (TxBypassMode_DFI0_B3_DMI   ),
`endif                                                                
  .TxBypassOE_DFI0_B0_DMI                    (TxBypassOE_DFI0_B0_DMI     ),
  .TxBypassOE_DFI0_B1_DMI                    (TxBypassOE_DFI0_B1_DMI     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI0_B2_DMI                    (TxBypassOE_DFI0_B2_DMI     ),
  .TxBypassOE_DFI0_B3_DMI                    (TxBypassOE_DFI0_B3_DMI     ),
`endif                                                                
  .TxBypassData_DFI0_B0_DMI                  (TxBypassData_DFI0_B0_DMI   ),
  .TxBypassData_DFI0_B1_DMI                  (TxBypassData_DFI0_B1_DMI   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI0_B2_DMI                  (TxBypassData_DFI0_B2_DMI   ),
  .TxBypassData_DFI0_B3_DMI                  (TxBypassData_DFI0_B3_DMI   ),
`endif                                                                
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED      
                                                                         
  .RxBypassRcvEn_DFI0_CA                     (RxBypassRcvEn_DFI0_CA      ),
  .RxBypassData_DFI0_CA0                     (RxBypassData_DFI0_CA0      ),
  .RxBypassData_DFI0_CA1                     (RxBypassData_DFI0_CA1      ),
  .RxBypassData_DFI0_CA2                     (RxBypassData_DFI0_CA2      ),
  .RxBypassData_DFI0_CA3                     (RxBypassData_DFI0_CA3      ),
  .RxBypassData_DFI0_CA4                     (RxBypassData_DFI0_CA4      ),
  .RxBypassData_DFI0_CA5                     (RxBypassData_DFI0_CA5        ),  
  .RxBypassData_DFI0_CA6                     (RxBypassData_DFI0_CA6        ),  
`ifdef DWC_DDRPHY_NUM_RANKS_2                 
  .RxBypassData_DFI0_CA7                     (RxBypassData_DFI0_CA7        ),  
`endif                                                                
  .RxBypassPadEn_DFI0_CA                     (RxBypassPadEn_DFI0_CA        ),  
  .RxBypassDataPad_DFI0_CA                   (RxBypassDataPad_DFI0_CA      ),  
  .TxBypassMode_DFI0_CA                      (TxBypassMode_DFI0_CA         ),  
  .TxBypassOE_DFI0_CA                        (TxBypassOE_DFI0_CA           ),  
  .TxBypassData_DFI0_CA                      (TxBypassData_DFI0_CA         ),  
  
//*********************DIFF: DQS/WCK/CK*******
  .RxBypassRcvEn_DFI0_B0_DQS                 (RxBypassRcvEn_DFI0_B0_DQS    ), 
  .RxBypassRcvEn_DFI0_B1_DQS                 (RxBypassRcvEn_DFI0_B1_DQS    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI0_B2_DQS                 (RxBypassRcvEn_DFI0_B2_DQS    ),
  .RxBypassRcvEn_DFI0_B3_DQS                 (RxBypassRcvEn_DFI0_B3_DQS    ),
`endif                                                                  
  .RxBypassDataRcv_DFI0_B0_DQS_T             (RxBypassDataRcv_DFI0_B0_DQS_T),
  .RxBypassDataRcv_DFI0_B0_DQS_C             (RxBypassDataRcv_DFI0_B0_DQS_C),
  .RxBypassDataRcv_DFI0_B1_DQS_T             (RxBypassDataRcv_DFI0_B1_DQS_T),
  .RxBypassDataRcv_DFI0_B1_DQS_C             (RxBypassDataRcv_DFI0_B1_DQS_C),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataRcv_DFI0_B2_DQS_T             (RxBypassDataRcv_DFI0_B2_DQS_T),
  .RxBypassDataRcv_DFI0_B2_DQS_C             (RxBypassDataRcv_DFI0_B2_DQS_C),
  .RxBypassDataRcv_DFI0_B3_DQS_T             (RxBypassDataRcv_DFI0_B3_DQS_T),
  .RxBypassDataRcv_DFI0_B3_DQS_C             (RxBypassDataRcv_DFI0_B3_DQS_C),
`endif                                                                  
  .RxBypassPadEn_DFI0_B0_DQS                 (RxBypassPadEn_DFI0_B0_DQS    ),
  .RxBypassPadEn_DFI0_B1_DQS                 (RxBypassPadEn_DFI0_B1_DQS    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI0_B2_DQS                 (RxBypassPadEn_DFI0_B2_DQS    ),
  .RxBypassPadEn_DFI0_B3_DQS                 (RxBypassPadEn_DFI0_B3_DQS    ),
`endif                                                                  
  .RxBypassDataPad_DFI0_B0_DQS_T             (RxBypassDataPad_DFI0_B0_DQS_T),
  .RxBypassDataPad_DFI0_B0_DQS_C             (RxBypassDataPad_DFI0_B0_DQS_C),
  .RxBypassDataPad_DFI0_B1_DQS_T             (RxBypassDataPad_DFI0_B1_DQS_T),
  .RxBypassDataPad_DFI0_B1_DQS_C             (RxBypassDataPad_DFI0_B1_DQS_C),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI0_B2_DQS_T             (RxBypassDataPad_DFI0_B2_DQS_T),
  .RxBypassDataPad_DFI0_B2_DQS_C             (RxBypassDataPad_DFI0_B2_DQS_C),
  .RxBypassDataPad_DFI0_B3_DQS_T             (RxBypassDataPad_DFI0_B3_DQS_T),
  .RxBypassDataPad_DFI0_B3_DQS_C             (RxBypassDataPad_DFI0_B3_DQS_C),
`endif                                                                  
//  .TxBypassMode_DFI0_B0_DQS                  .TxBypassMode_DFI0_B0_DQS   ),  ),),
//  .TxBypassMode_DFI0_B1_DQS                  .TxBypassMode_DFI0_B1_DQS   ),  ),),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  ifdef DWC_DDRPHY_NUM_DBYTES_P),  
//  .TxBypassMode_DFI0_B2_DQS                  .TxBypassMode_DFI0_B2_DQS   ),  ),),
//  .TxBypassMode_DFI0_B3_DQS                  .TxBypassMode_DFI0_B3_DQS   ),  ),),
//`endif                                      endif                        ), 
  .TxBypassOE_DFI0_B0_DQS_T                  (TxBypassOE_DFI0_B0_DQS_T     ),
  .TxBypassOE_DFI0_B0_DQS_C                  (TxBypassOE_DFI0_B0_DQS_C     ),
  .TxBypassOE_DFI0_B1_DQS_T                  (TxBypassOE_DFI0_B1_DQS_T     ),
  .TxBypassOE_DFI0_B1_DQS_C                  (TxBypassOE_DFI0_B1_DQS_C     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI0_B2_DQS_T                  (TxBypassOE_DFI0_B2_DQS_T     ),
  .TxBypassOE_DFI0_B2_DQS_C                  (TxBypassOE_DFI0_B2_DQS_C     ),
  .TxBypassOE_DFI0_B3_DQS_T                  (TxBypassOE_DFI0_B3_DQS_T     ),
  .TxBypassOE_DFI0_B3_DQS_C                  (TxBypassOE_DFI0_B3_DQS_C     ),
`endif                                                                  
  .TxBypassData_DFI0_B0_DQS_T                (TxBypassData_DFI0_B0_DQS_T   ),
  .TxBypassData_DFI0_B0_DQS_C                (TxBypassData_DFI0_B0_DQS_C   ),
  .TxBypassData_DFI0_B1_DQS_T                (TxBypassData_DFI0_B1_DQS_T   ),
  .TxBypassData_DFI0_B1_DQS_C                (TxBypassData_DFI0_B1_DQS_C   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI0_B2_DQS_T                (TxBypassData_DFI0_B2_DQS_T   ),
  .TxBypassData_DFI0_B2_DQS_C                (TxBypassData_DFI0_B2_DQS_C   ),
  .TxBypassData_DFI0_B3_DQS_T                (TxBypassData_DFI0_B3_DQS_T   ),
  .TxBypassData_DFI0_B3_DQS_C                (TxBypassData_DFI0_B3_DQS_C   ),
`endif                                                                  
                                                                           
`ifdef DWC_DDRPHY_LPDDR5_ENABLED              
  .RxBypassRcvEn_DFI0_B0_WCK                 (RxBypassRcvEn_DFI0_B0_WCK    ),
  .RxBypassRcvEn_DFI0_B1_WCK                 (RxBypassRcvEn_DFI0_B1_WCK    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI0_B2_WCK                 (RxBypassRcvEn_DFI0_B2_WCK    ),
  .RxBypassRcvEn_DFI0_B3_WCK                 (RxBypassRcvEn_DFI0_B3_WCK    ),
`endif                                                                  
  .RxBypassDataRcv_DFI0_B0_WCK_T             (RxBypassDataRcv_DFI0_B0_WCK_T),
  .RxBypassDataRcv_DFI0_B0_WCK_C             (RxBypassDataRcv_DFI0_B0_WCK_C),
  .RxBypassDataRcv_DFI0_B1_WCK_T             (RxBypassDataRcv_DFI0_B1_WCK_T),
  .RxBypassDataRcv_DFI0_B1_WCK_C             (RxBypassDataRcv_DFI0_B1_WCK_C),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataRcv_DFI0_B2_WCK_T             (RxBypassDataRcv_DFI0_B2_WCK_T),
  .RxBypassDataRcv_DFI0_B2_WCK_C             (RxBypassDataRcv_DFI0_B2_WCK_C),
  .RxBypassDataRcv_DFI0_B3_WCK_T             (RxBypassDataRcv_DFI0_B3_WCK_T),
  .RxBypassDataRcv_DFI0_B3_WCK_C             (RxBypassDataRcv_DFI0_B3_WCK_C),
`endif                                                                  
  .RxBypassPadEn_DFI0_B0_WCK                 (RxBypassPadEn_DFI0_B0_WCK    ),
  .RxBypassPadEn_DFI0_B1_WCK                 (RxBypassPadEn_DFI0_B1_WCK    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI0_B2_WCK                 (RxBypassPadEn_DFI0_B2_WCK    ),
  .RxBypassPadEn_DFI0_B3_WCK                 (RxBypassPadEn_DFI0_B3_WCK    ),
`endif                                                                  
  .RxBypassDataPad_DFI0_B0_WCK_T             (RxBypassDataPad_DFI0_B0_WCK_T),
  .RxBypassDataPad_DFI0_B0_WCK_C             (RxBypassDataPad_DFI0_B0_WCK_C),
  .RxBypassDataPad_DFI0_B1_WCK_T             (RxBypassDataPad_DFI0_B1_WCK_T),
  .RxBypassDataPad_DFI0_B1_WCK_C             (RxBypassDataPad_DFI0_B1_WCK_C),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI0_B2_WCK_T             (RxBypassDataPad_DFI0_B2_WCK_T),
  .RxBypassDataPad_DFI0_B2_WCK_C             (RxBypassDataPad_DFI0_B2_WCK_C),
  .RxBypassDataPad_DFI0_B3_WCK_T             (RxBypassDataPad_DFI0_B3_WCK_T),
  .RxBypassDataPad_DFI0_B3_WCK_C             (RxBypassDataPad_DFI0_B3_WCK_C),
`endif                                                                  
//  .TxBypassMode_DFI0_B0_WCK                  .TxBypassMode_DFI0_B0_WCK   ),  ),),
//  .TxBypassMode_DFI0_B1_WCK                  .TxBypassMode_DFI0_B1_WCK   ),  ),),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  ifdef DWC_DDRPHY_NUM_DBYTES_P),  
//  .TxBypassMode_DFI0_B2_WCK                  .TxBypassMode_DFI0_B2_WCK   ),  ),),
//  .TxBypassMode_DFI0_B3_WCK                  .TxBypassMode_DFI0_B3_WCK   ),  ),),
//`endif                                      endif                        ),  
  .TxBypassOE_DFI0_B0_WCK_T                  (TxBypassOE_DFI0_B0_WCK_T     ),
  .TxBypassOE_DFI0_B0_WCK_C                  (TxBypassOE_DFI0_B0_WCK_C     ),
  .TxBypassOE_DFI0_B1_WCK_T                  (TxBypassOE_DFI0_B1_WCK_T     ),
  .TxBypassOE_DFI0_B1_WCK_C                  (TxBypassOE_DFI0_B1_WCK_C     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI0_B2_WCK_T                  (TxBypassOE_DFI0_B2_WCK_T     ),
  .TxBypassOE_DFI0_B2_WCK_C                  (TxBypassOE_DFI0_B2_WCK_C     ),
  .TxBypassOE_DFI0_B3_WCK_T                  (TxBypassOE_DFI0_B3_WCK_T     ),
  .TxBypassOE_DFI0_B3_WCK_C                  (TxBypassOE_DFI0_B3_WCK_C     ),
`endif                                                                  
  .TxBypassData_DFI0_B0_WCK_T                (TxBypassData_DFI0_B0_WCK_T   ),
  .TxBypassData_DFI0_B0_WCK_C                (TxBypassData_DFI0_B0_WCK_C   ),
  .TxBypassData_DFI0_B1_WCK_T                (TxBypassData_DFI0_B1_WCK_T   ),
  .TxBypassData_DFI0_B1_WCK_C                (TxBypassData_DFI0_B1_WCK_C   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI0_B2_WCK_T                (TxBypassData_DFI0_B2_WCK_T   ),
  .TxBypassData_DFI0_B2_WCK_C                (TxBypassData_DFI0_B2_WCK_C   ),
  .TxBypassData_DFI0_B3_WCK_T                (TxBypassData_DFI0_B3_WCK_T   ),
  .TxBypassData_DFI0_B3_WCK_C                (TxBypassData_DFI0_B3_WCK_C   ),
`endif                                        
`endif   //DWC_DDRPHY_LPDDR5_ENABLED          
                                                                           
  .RxBypassRcvEn_DFI0_CK                     (RxBypassRcvEn_DFI0_CK        ),
  .RxBypassDataRcv_DFI0_CK_T                 (RxBypassDataRcv_DFI0_CK_T    ),
  .RxBypassDataRcv_DFI0_CK_C                 (RxBypassDataRcv_DFI0_CK_C    ),
  .RxBypassPadEn_DFI0_CK                     (RxBypassPadEn_DFI0_CK        ),
  .RxBypassDataPad_DFI0_CK_T                 (RxBypassDataPad_DFI0_CK_T    ),
  .RxBypassDataPad_DFI0_CK_C                 (RxBypassDataPad_DFI0_CK_C    ),
  //.TxBypassMode_DFI0_CK                     /.TxBypassMode_DFI0_CK       ),  ),),
  .TxBypassOE_DFI0_CK_T                      (TxBypassOE_DFI0_CK_T         ),
  .TxBypassOE_DFI0_CK_C                      (TxBypassOE_DFI0_CK_C         ),

//************************* SEC **************
  .RxBypassPadEn_DFI0_LP4CKE_LP5CS           (RxBypassPadEn_DFI0_LP4CKE_LP5CS  ), 
  .RxBypassDataPad_DFI0_LP4CKE_LP5CS         (RxBypassDataPad_DFI0_LP4CKE_LP5CS),
  .TxBypassMode_DFI0_LP4CKE_LP5CS            (TxBypassMode_DFI0_LP4CKE_LP5CS   ),
  .TxBypassOE_DFI0_LP4CKE_LP5CS              (TxBypassOE_DFI0_LP4CKE_LP5CS     ),
  .TxBypassData_DFI0_LP4CKE_LP5CS            (TxBypassData_DFI0_LP4CKE_LP5CS   ),
                                                                               
  .TxBypassMode_DTO                          (TxBypassMode_DTO                 ),
  .TxBypassOE_DTO                            (TxBypassOE_DTO                   ),
  .TxBypassData_DTO                          (TxBypassData_DTO                 ),
  .RxBypassEn_DTO                            (RxBypassEn_DTO                   ),
  .RxBypassDataPad_DTO                       (RxBypassDataPad_DTO              ),

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
//***********************SE: DQ/DMI/CA********
  .RxBypassRcvEn_DFI1_B0_D                   (RxBypassRcvEn_DFI1_B0_D ),     
  .RxBypassRcvEn_DFI1_B1_D                   (RxBypassRcvEn_DFI1_B1_D ),   
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI1_B2_D                   (RxBypassRcvEn_DFI1_B2_D ),   
  .RxBypassRcvEn_DFI1_B3_D                   (RxBypassRcvEn_DFI1_B3_D ),   
`endif                                                                
  .RxBypassData_DFI1_B0_D0                   (RxBypassData_DFI1_B0_D0 ),   
  .RxBypassData_DFI1_B0_D1                   (RxBypassData_DFI1_B0_D1 ),   
  .RxBypassData_DFI1_B0_D2                   (RxBypassData_DFI1_B0_D2 ),   
  .RxBypassData_DFI1_B0_D3                   (RxBypassData_DFI1_B0_D3 ),   
  .RxBypassData_DFI1_B0_D4                   (RxBypassData_DFI1_B0_D4 ),   
  .RxBypassData_DFI1_B0_D5                   (RxBypassData_DFI1_B0_D5 ),   
  .RxBypassData_DFI1_B0_D6                   (RxBypassData_DFI1_B0_D6 ),   
  .RxBypassData_DFI1_B0_D7                   (RxBypassData_DFI1_B0_D7 ),   
  .RxBypassData_DFI1_B1_D0                   (RxBypassData_DFI1_B1_D0 ),   
  .RxBypassData_DFI1_B1_D1                   (RxBypassData_DFI1_B1_D1 ),   
  .RxBypassData_DFI1_B1_D2                   (RxBypassData_DFI1_B1_D2 ),   
  .RxBypassData_DFI1_B1_D3                   (RxBypassData_DFI1_B1_D3 ),   
  .RxBypassData_DFI1_B1_D4                   (RxBypassData_DFI1_B1_D4 ),   
  .RxBypassData_DFI1_B1_D5                   (RxBypassData_DFI1_B1_D5 ),   
  .RxBypassData_DFI1_B1_D6                   (RxBypassData_DFI1_B1_D6 ),   
  .RxBypassData_DFI1_B1_D7                   (RxBypassData_DFI1_B1_D7 ),   
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassData_DFI1_B2_D0                   (RxBypassData_DFI1_B2_D0 ),   
  .RxBypassData_DFI1_B2_D1                   (RxBypassData_DFI1_B2_D1 ),   
  .RxBypassData_DFI1_B2_D2                   (RxBypassData_DFI1_B2_D2 ),   
  .RxBypassData_DFI1_B2_D3                   (RxBypassData_DFI1_B2_D3 ),   
  .RxBypassData_DFI1_B2_D4                   (RxBypassData_DFI1_B2_D4 ),   
  .RxBypassData_DFI1_B2_D5                   (RxBypassData_DFI1_B2_D5 ),   
  .RxBypassData_DFI1_B2_D6                   (RxBypassData_DFI1_B2_D6 ),   
  .RxBypassData_DFI1_B2_D7                   (RxBypassData_DFI1_B2_D7 ),   
  .RxBypassData_DFI1_B3_D0                   (RxBypassData_DFI1_B3_D0 ),   
  .RxBypassData_DFI1_B3_D1                   (RxBypassData_DFI1_B3_D1 ),   
  .RxBypassData_DFI1_B3_D2                   (RxBypassData_DFI1_B3_D2 ),   
  .RxBypassData_DFI1_B3_D3                   (RxBypassData_DFI1_B3_D3 ),   
  .RxBypassData_DFI1_B3_D4                   (RxBypassData_DFI1_B3_D4 ),   
  .RxBypassData_DFI1_B3_D5                   (RxBypassData_DFI1_B3_D5 ),   
  .RxBypassData_DFI1_B3_D6                   (RxBypassData_DFI1_B3_D6 ),   
  .RxBypassData_DFI1_B3_D7                   (RxBypassData_DFI1_B3_D7 ),   
`endif                                                                
  .RxBypassPadEn_DFI1_B0_D                   (RxBypassPadEn_DFI1_B0_D ),   
  .RxBypassPadEn_DFI1_B1_D                   (RxBypassPadEn_DFI1_B1_D ),   
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI1_B2_D                   (RxBypassPadEn_DFI1_B2_D ),   
  .RxBypassPadEn_DFI1_B3_D                   (RxBypassPadEn_DFI1_B3_D ),   
`endif                                                                
  .RxBypassDataPad_DFI1_B0_D                 (RxBypassDataPad_DFI1_B0_D  ),                 
  .RxBypassDataPad_DFI1_B1_D                 (RxBypassDataPad_DFI1_B1_D  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI1_B2_D                 (RxBypassDataPad_DFI1_B2_D  ),
  .RxBypassDataPad_DFI1_B3_D                 (RxBypassDataPad_DFI1_B3_D  ),
`endif                                                                
  //.TxBypassMode_DFI1_B0_D                    (TxBypassMode_DFI1_B0_D     ),
  //.TxBypassMode_DFI1_B1_D                    (TxBypassMode_DFI1_B1_D     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  //.TxBypassMode_DFI1_B2_D                    (TxBypassMode_DFI1_B2_D     ),
 // .TxBypassMode_DFI1_B3_D                    (TxBypassMode_DFI1_B3_D     ),
`endif                                                               
  .TxBypassOE_DFI1_B0_D                      (TxBypassOE_DFI1_B0_D       ),
  .TxBypassOE_DFI1_B1_D                      (TxBypassOE_DFI1_B1_D       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI1_B2_D                      (TxBypassOE_DFI1_B2_D       ),
  .TxBypassOE_DFI1_B3_D                      (TxBypassOE_DFI1_B3_D       ),
`endif                                                                
  .TxBypassData_DFI1_B0_D                    (TxBypassData_DFI1_B0_D     ),
  .TxBypassData_DFI1_B1_D                    (TxBypassData_DFI1_B1_D     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI1_B2_D                    (TxBypassData_DFI1_B2_D     ),
  .TxBypassData_DFI1_B3_D                    (TxBypassData_DFI1_B3_D     ),
`endif                                                                
                                                                         
`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED           
  .RxBypassRcvEn_DFI1_B0_DMI                 (RxBypassRcvEn_DFI1_B0_DMI  ),
  .RxBypassRcvEn_DFI1_B1_DMI                 (RxBypassRcvEn_DFI1_B1_DMI  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI1_B2_DMI                 (RxBypassRcvEn_DFI1_B2_DMI  ),
  .RxBypassRcvEn_DFI1_B3_DMI                 (RxBypassRcvEn_DFI1_B3_DMI  ),
`endif                                                                
  .RxBypassData_DFI1_B0_DMI                  (RxBypassData_DFI1_B0_DMI   ),
  .RxBypassData_DFI1_B1_DMI                  (RxBypassData_DFI1_B1_DMI   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassData_DFI1_B2_DMI                  (RxBypassData_DFI1_B2_DMI   ),
  .RxBypassData_DFI1_B3_DMI                  (RxBypassData_DFI1_B3_DMI   ),
`endif                                                                
  .RxBypassPadEn_DFI1_B0_DMI                 (RxBypassPadEn_DFI1_B0_DMI  ),
  .RxBypassPadEn_DFI1_B1_DMI                 (RxBypassPadEn_DFI1_B1_DMI  ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI1_B2_DMI                 (RxBypassPadEn_DFI1_B2_DMI  ),
  .RxBypassPadEn_DFI1_B3_DMI                 (RxBypassPadEn_DFI1_B3_DMI  ),
`endif                                                                
  .RxBypassDataPad_DFI1_B0_DMI               (RxBypassDataPad_DFI1_B0_DMI),
  .RxBypassDataPad_DFI1_B1_DMI               (RxBypassDataPad_DFI1_B1_DMI),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI1_B2_DMI               (RxBypassDataPad_DFI1_B2_DMI),
  .RxBypassDataPad_DFI1_B3_DMI               (RxBypassDataPad_DFI1_B3_DMI),
`endif                                                                
  //.TxBypassMode_DFI1_B0_DMI                  (TxBypassMode_DFI1_B0_DMI   ),
  //.TxBypassMode_DFI1_B1_DMI                  (TxBypassMode_DFI1_B1_DMI   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  //.TxBypassMode_DFI1_B2_DMI                  (TxBypassMode_DFI1_B2_DMI   ),
  //.TxBypassMode_DFI1_B3_DMI                  (TxBypassMode_DFI1_B3_DMI   ),
`endif                                                                
  .TxBypassOE_DFI1_B0_DMI                    (TxBypassOE_DFI1_B0_DMI     ),
  .TxBypassOE_DFI1_B1_DMI                    (TxBypassOE_DFI1_B1_DMI     ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI1_B2_DMI                    (TxBypassOE_DFI1_B2_DMI     ),
  .TxBypassOE_DFI1_B3_DMI                    (TxBypassOE_DFI1_B3_DMI     ),
`endif                                                                
  .TxBypassData_DFI1_B0_DMI                  (TxBypassData_DFI1_B0_DMI   ),
  .TxBypassData_DFI1_B1_DMI                  (TxBypassData_DFI1_B1_DMI   ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI1_B2_DMI                  (TxBypassData_DFI1_B2_DMI   ),
  .TxBypassData_DFI1_B3_DMI                  (TxBypassData_DFI1_B3_DMI   ),
`endif                                                                
`endif    //DWC_DDRPHY_DBYTE_DMI_ENABLED      dif    //DWC_DDRPHY_DBYTE_D),
                                                                         
  .RxBypassRcvEn_DFI1_CA                     (RxBypassRcvEn_DFI1_CA      ),
  .RxBypassData_DFI1_CA0                     (RxBypassData_DFI1_CA0      ),
  .RxBypassData_DFI1_CA1                     (RxBypassData_DFI1_CA1      ),
  .RxBypassData_DFI1_CA2                     (RxBypassData_DFI1_CA2      ),
  .RxBypassData_DFI1_CA3                     (RxBypassData_DFI1_CA3      ),
  .RxBypassData_DFI1_CA4                     (RxBypassData_DFI1_CA4      ),
  .RxBypassData_DFI1_CA5                     (RxBypassData_DFI1_CA5      ),
  .RxBypassData_DFI1_CA6                     (RxBypassData_DFI1_CA6      ),
`ifdef DWC_DDRPHY_NUM_RANKS_2                  
  .RxBypassData_DFI1_CA7                     (RxBypassData_DFI1_CA7      ),
`endif                                                                
  .RxBypassPadEn_DFI1_CA                     (RxBypassPadEn_DFI1_CA      ),
  .RxBypassDataPad_DFI1_CA                   (RxBypassDataPad_DFI1_CA    ),
  //.TxBypassMode_DFI1_CA                      (TxBypassMode_DFI1_CA       ),
  .TxBypassOE_DFI1_CA                        (TxBypassOE_DFI1_CA         ),
  .TxBypassData_DFI1_CA                      (TxBypassData_DFI1_CA       ),
  
//*********************DIFF: DQS/WCK/CK*******
  .RxBypassRcvEn_DFI1_B0_DQS                 (RxBypassRcvEn_DFI1_B0_DQS        ), 
  .RxBypassRcvEn_DFI1_B1_DQS                 (RxBypassRcvEn_DFI1_B1_DQS        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI1_B2_DQS                 (RxBypassRcvEn_DFI1_B2_DQS        ),
  .RxBypassRcvEn_DFI1_B3_DQS                 (RxBypassRcvEn_DFI1_B3_DQS        ),
`endif                                                                      
  .RxBypassDataRcv_DFI1_B0_DQS_T             (RxBypassDataRcv_DFI1_B0_DQS_T    ),
  .RxBypassDataRcv_DFI1_B0_DQS_C             (RxBypassDataRcv_DFI1_B0_DQS_C    ),
  .RxBypassDataRcv_DFI1_B1_DQS_T             (RxBypassDataRcv_DFI1_B1_DQS_T    ),
  .RxBypassDataRcv_DFI1_B1_DQS_C             (RxBypassDataRcv_DFI1_B1_DQS_C    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataRcv_DFI1_B2_DQS_T             (RxBypassDataRcv_DFI1_B2_DQS_T    ),
  .RxBypassDataRcv_DFI1_B2_DQS_C             (RxBypassDataRcv_DFI1_B2_DQS_C    ),
  .RxBypassDataRcv_DFI1_B3_DQS_T             (RxBypassDataRcv_DFI1_B3_DQS_T    ),
  .RxBypassDataRcv_DFI1_B3_DQS_C             (RxBypassDataRcv_DFI1_B3_DQS_C    ),
`endif                                                                      
  .RxBypassPadEn_DFI1_B0_DQS                 (RxBypassPadEn_DFI1_B0_DQS        ),
  .RxBypassPadEn_DFI1_B1_DQS                 (RxBypassPadEn_DFI1_B1_DQS        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI1_B2_DQS                 (RxBypassPadEn_DFI1_B2_DQS        ),
  .RxBypassPadEn_DFI1_B3_DQS                 (RxBypassPadEn_DFI1_B3_DQS        ),
`endif                                                                      
  .RxBypassDataPad_DFI1_B0_DQS_T             (RxBypassDataPad_DFI1_B0_DQS_T    ),
  .RxBypassDataPad_DFI1_B0_DQS_C             (RxBypassDataPad_DFI1_B0_DQS_C    ),
  .RxBypassDataPad_DFI1_B1_DQS_T             (RxBypassDataPad_DFI1_B1_DQS_T    ),
  .RxBypassDataPad_DFI1_B1_DQS_C             (RxBypassDataPad_DFI1_B1_DQS_C    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI1_B2_DQS_T             (RxBypassDataPad_DFI1_B2_DQS_T    ),
  .RxBypassDataPad_DFI1_B2_DQS_C             (RxBypassDataPad_DFI1_B2_DQS_C    ),
  .RxBypassDataPad_DFI1_B3_DQS_T             (RxBypassDataPad_DFI1_B3_DQS_T    ),
  .RxBypassDataPad_DFI1_B3_DQS_C             (RxBypassDataPad_DFI1_B3_DQS_C    ),
`endif                                                                      
//  .TxBypassMode_DFI1_B0_DQS                  .TxBypassMode_DFI1_B0_DQS       ),  ),
//  .TxBypassMode_DFI1_B1_DQS                  .TxBypassMode_DFI1_B1_DQS       ),  ),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  ifdef DWC_DDRPHY_NUM_DBYTES_PER_C),  
//  .TxBypassMode_DFI1_B2_DQS                  .TxBypassMode_DFI1_B2_DQS       ),  ),
//  .TxBypassMode_DFI1_B3_DQS                  .TxBypassMode_DFI1_B3_DQS       ),  ),
//`endif                                      endif                            ), 
  .TxBypassOE_DFI1_B0_DQS_T                  (TxBypassOE_DFI1_B0_DQS_T         ),
  .TxBypassOE_DFI1_B0_DQS_C                  (TxBypassOE_DFI1_B0_DQS_C         ),
  .TxBypassOE_DFI1_B1_DQS_T                  (TxBypassOE_DFI1_B1_DQS_T         ),
  .TxBypassOE_DFI1_B1_DQS_C                  (TxBypassOE_DFI1_B1_DQS_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI1_B2_DQS_T                  (TxBypassOE_DFI1_B2_DQS_T         ),
  .TxBypassOE_DFI1_B2_DQS_C                  (TxBypassOE_DFI1_B2_DQS_C         ),
  .TxBypassOE_DFI1_B3_DQS_T                  (TxBypassOE_DFI1_B3_DQS_T         ),
  .TxBypassOE_DFI1_B3_DQS_C                  (TxBypassOE_DFI1_B3_DQS_C         ),
`endif                                                                      
  .TxBypassData_DFI1_B0_DQS_T                (TxBypassData_DFI1_B0_DQS_T       ),
  .TxBypassData_DFI1_B0_DQS_C                (TxBypassData_DFI1_B0_DQS_C       ),
  .TxBypassData_DFI1_B1_DQS_T                (TxBypassData_DFI1_B1_DQS_T       ),
  .TxBypassData_DFI1_B1_DQS_C                (TxBypassData_DFI1_B1_DQS_C       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI1_B2_DQS_T                (TxBypassData_DFI1_B2_DQS_T       ),
  .TxBypassData_DFI1_B2_DQS_C                (TxBypassData_DFI1_B2_DQS_C       ),
  .TxBypassData_DFI1_B3_DQS_T                (TxBypassData_DFI1_B3_DQS_T       ),
  .TxBypassData_DFI1_B3_DQS_C                (TxBypassData_DFI1_B3_DQS_C       ),
`endif                                                                     
                                                                               
`ifdef DWC_DDRPHY_LPDDR5_ENABLED                  
  .RxBypassRcvEn_DFI1_B0_WCK                 (RxBypassRcvEn_DFI1_B0_WCK        ),
  .RxBypassRcvEn_DFI1_B1_WCK                 (RxBypassRcvEn_DFI1_B1_WCK        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassRcvEn_DFI1_B2_WCK                 (RxBypassRcvEn_DFI1_B2_WCK        ),
  .RxBypassRcvEn_DFI1_B3_WCK                 (RxBypassRcvEn_DFI1_B3_WCK        ),
`endif                                                                      
  .RxBypassDataRcv_DFI1_B0_WCK_T             (RxBypassDataRcv_DFI1_B0_WCK_T    ),
  .RxBypassDataRcv_DFI1_B0_WCK_C             (RxBypassDataRcv_DFI1_B0_WCK_C    ),
  .RxBypassDataRcv_DFI1_B1_WCK_T             (RxBypassDataRcv_DFI1_B1_WCK_T    ),
  .RxBypassDataRcv_DFI1_B1_WCK_C             (RxBypassDataRcv_DFI1_B1_WCK_C    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataRcv_DFI1_B2_WCK_T             (RxBypassDataRcv_DFI1_B2_WCK_T    ),
  .RxBypassDataRcv_DFI1_B2_WCK_C             (RxBypassDataRcv_DFI1_B2_WCK_C    ),
  .RxBypassDataRcv_DFI1_B3_WCK_T             (RxBypassDataRcv_DFI1_B3_WCK_T    ),
  .RxBypassDataRcv_DFI1_B3_WCK_C             (RxBypassDataRcv_DFI1_B3_WCK_C    ),
`endif                                                                      
  .RxBypassPadEn_DFI1_B0_WCK                 (RxBypassPadEn_DFI1_B0_WCK        ),
  .RxBypassPadEn_DFI1_B1_WCK                 (RxBypassPadEn_DFI1_B1_WCK        ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassPadEn_DFI1_B2_WCK                 (RxBypassPadEn_DFI1_B2_WCK        ),
  .RxBypassPadEn_DFI1_B3_WCK                 (RxBypassPadEn_DFI1_B3_WCK        ),
`endif                                                                      
  .RxBypassDataPad_DFI1_B0_WCK_T             (RxBypassDataPad_DFI1_B0_WCK_T    ),
  .RxBypassDataPad_DFI1_B0_WCK_C             (RxBypassDataPad_DFI1_B0_WCK_C    ),
  .RxBypassDataPad_DFI1_B1_WCK_T             (RxBypassDataPad_DFI1_B1_WCK_T    ),
  .RxBypassDataPad_DFI1_B1_WCK_C             (RxBypassDataPad_DFI1_B1_WCK_C    ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .RxBypassDataPad_DFI1_B2_WCK_T             (RxBypassDataPad_DFI1_B2_WCK_T    ),
  .RxBypassDataPad_DFI1_B2_WCK_C             (RxBypassDataPad_DFI1_B2_WCK_C    ),
  .RxBypassDataPad_DFI1_B3_WCK_T             (RxBypassDataPad_DFI1_B3_WCK_T    ),
  .RxBypassDataPad_DFI1_B3_WCK_C             (RxBypassDataPad_DFI1_B3_WCK_C    ),
`endif                                                                      
//  .TxBypassMode_DFI1_B0_WCK                  .TxBypassMode_DFI1_B0_WCK       ),  ),
//  .TxBypassMode_DFI1_B1_WCK                  .TxBypassMode_DFI1_B1_WCK       ),  ),
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4  ifdef DWC_DDRPHY_NUM_DBYTES_PER_C),  
//  .TxBypassMode_DFI1_B2_WCK                  .TxBypassMode_DFI1_B2_WCK       ),  ),
//  .TxBypassMode_DFI1_B3_WCK                  .TxBypassMode_DFI1_B3_WCK       ),  ),
//`endif                                      endif                            ),  
  .TxBypassOE_DFI1_B0_WCK_T                  (TxBypassOE_DFI1_B0_WCK_T         ),
  .TxBypassOE_DFI1_B0_WCK_C                  (TxBypassOE_DFI1_B0_WCK_C         ),
  .TxBypassOE_DFI1_B1_WCK_T                  (TxBypassOE_DFI1_B1_WCK_T         ),
  .TxBypassOE_DFI1_B1_WCK_C                  (TxBypassOE_DFI1_B1_WCK_C         ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassOE_DFI1_B2_WCK_T                  (TxBypassOE_DFI1_B2_WCK_T         ),
  .TxBypassOE_DFI1_B2_WCK_C                  (TxBypassOE_DFI1_B2_WCK_C         ),
  .TxBypassOE_DFI1_B3_WCK_T                  (TxBypassOE_DFI1_B3_WCK_T         ),
  .TxBypassOE_DFI1_B3_WCK_C                  (TxBypassOE_DFI1_B3_WCK_C         ),
`endif                                                                      
  .TxBypassData_DFI1_B0_WCK_T                (TxBypassData_DFI1_B0_WCK_T       ),
  .TxBypassData_DFI1_B0_WCK_C                (TxBypassData_DFI1_B0_WCK_C       ),
  .TxBypassData_DFI1_B1_WCK_T                (TxBypassData_DFI1_B1_WCK_T       ),
  .TxBypassData_DFI1_B1_WCK_C                (TxBypassData_DFI1_B1_WCK_C       ),
`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4    
  .TxBypassData_DFI1_B2_WCK_T                (TxBypassData_DFI1_B2_WCK_T       ),
  .TxBypassData_DFI1_B2_WCK_C                (TxBypassData_DFI1_B2_WCK_C       ),
  .TxBypassData_DFI1_B3_WCK_T                (TxBypassData_DFI1_B3_WCK_T       ),
  .TxBypassData_DFI1_B3_WCK_C                (TxBypassData_DFI1_B3_WCK_C       ),
`endif                                        
`endif   //DWC_DDRPHY_LPDDR5_ENABLED          dif   //DWC_DDRPHY_LPDDR5_ENABLED),
                                                                              
  .RxBypassRcvEn_DFI1_CK                     (RxBypassRcvEn_DFI1_CK            ),
  .RxBypassDataRcv_DFI1_CK_T                 (RxBypassDataRcv_DFI1_CK_T        ),
  .RxBypassDataRcv_DFI1_CK_C                 (RxBypassDataRcv_DFI1_CK_C        ),
  .RxBypassPadEn_DFI1_CK                     (RxBypassPadEn_DFI1_CK            ),
  .RxBypassDataPad_DFI1_CK_T                 (RxBypassDataPad_DFI1_CK_T        ),
  .RxBypassDataPad_DFI1_CK_C                 (RxBypassDataPad_DFI1_CK_C        ),
  //.TxBypassMode_DFI1_CK                     /.TxBypassMode_DFI1_CK           ),  ),
  .TxBypassOE_DFI1_CK_T                      (TxBypassOE_DFI1_CK_T             ),
  .TxBypassOE_DFI1_CK_C                      (TxBypassOE_DFI1_CK_C             ),
  //.TxBypassData_DFI1_CK_T                    (TxBypassData_DFI1_CK_T           ),
  //.TxBypassData_DFI1_CK_C                    (TxBypassData_DFI1_CK_C           ),
                                                                               
//************************* SEC ************************************** SEC ****),
  .RxBypassPadEn_DFI1_LP4CKE_LP5CS           (RxBypassPadEn_DFI1_LP4CKE_LP5CS  ),
  .RxBypassDataPad_DFI1_LP4CKE_LP5CS         (RxBypassDataPad_DFI1_LP4CKE_LP5CS),
  //.TxBypassMode_DFI1_LP4CKE_LP5CS            (TxBypassMode_DFI1_LP4CKE_LP5CS   ),
  .TxBypassOE_DFI1_LP4CKE_LP5CS              (TxBypassOE_DFI1_LP4CKE_LP5CS     ),
  .TxBypassData_DFI1_LP4CKE_LP5CS            (TxBypassData_DFI1_LP4CKE_LP5CS   ),
`endif //DWC_DDRPHY_NUM_CHANNELS_2

.ZCAL_SENSE                             ( ZCAL_SENSE                             ),
.ZCAL_INT                               ( ZCAL_INT                               )

);
endmodule
