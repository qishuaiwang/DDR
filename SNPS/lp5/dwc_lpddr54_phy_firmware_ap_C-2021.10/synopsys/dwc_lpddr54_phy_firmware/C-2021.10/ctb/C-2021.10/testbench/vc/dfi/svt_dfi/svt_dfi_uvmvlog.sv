`timescale 1ps/1ps

`ifdef DWC_DDRPHY_NUM_ANIBS_12
  `define DFI_CS_WIDTH 4
`else
  `define DFI_CS_WIDTH 2
`endif


`include "dfi_custom_defines.sv"
`include "dfi_intf_defines.sv"

// Compile the DFI agent and MC agent packages
`include "svt_dfi.uvm.pkg"
`include "svt_dfi_mc.uvm.pkg"

`ifdef LP5_STD
`define DWC_DDRPHY_DFI_ADDRESS_WIDTH  7
`else 
`define DWC_DDRPHY_DFI_ADDRESS_WIDTH  `DWC_DDRPHY_DFI0_ADDRESS_WIDTH
`endif
`define DWC_DDRPHY_DFI_ADDRESS_P0_WIDTH  `DWC_DDRPHY_DFI0_P0_ADDRESS_MSB

module svt_dfi_uvmvlog
#(
parameter pIndex                  = 0
,         pERROR_INFO_WIDTH       = 4
,         pPHYUPD_TYPE_WIDTH      = 2
,         pPHYMSTR_CS_STATE_WIDTH = 2
,         pPHYMSTR_TYPE_WIDTH     = 2
,         pFREQ_WIDTH             = 5
,         pFREQ_RATIO_WIDTH       = 2
,         pFREQ_FSP_WIDTH         = 2
,         pCKE_WIDTH              = 4
,         pCS_WIDTH               = 4
,         pWCK_EN_WIDTH           = 4
,         pWCK_CS_WIDTH           = 4
,         pWCK_TOGGLE_WIDTH       = 4
,         pWRDATA_LINK_ECC_WIDTH  = 16
//`ifndef DWC_DDRPHY_NUM_ANIBS_6
//`ifndef DWC_DDRPHY_NUM_ANIBS_3
//,         pBANK_WIDTH               = 3
//,         pBG_WIDTH                 = 2
//,         pCID_WIDTH                = 3
//`endif
//`endif
,         pADDRESS_WIDTH            = 14      
,         pDFI_WRDATA_WIDTH         = 128
,         pDFI_WRDATA_CS_WIDTH      = 16
,         pDFI_RDDATA_CS_WIDTH      = 16
,         pDFI_WRDATA_EN_WIDTH      = 8
,         pDFI_WRDATA_MASK_WIDTH    = 16
,         pDFI_RDDATA_EN_WIDTH      = 8
,         pDFI_RDDATA_VALID_WIDTH   = 8
,         pDFI_RDDATA_DBI_WIDTH     = 16
,         pDFI_RDDATA_WIDTH         = 128
)
(
input                               clk,
`ifdef LP5_STD
input                               phy_clk,
`endif
input                               pwr_ok,
input                               Reset,
output                              init_start,
input                               init_complete,
input                               ctrlupd_ack,
output                              ctrlupd_req,
input                               phyupd_req,
output                              phyupd_ack,
input                               phymstr_req,
output                              phymstr_ack,
input                               phymstr_state_sel,
input                               lp_ctrl_ack,
input                               lp_data_ack,
input                               error,
input [pERROR_INFO_WIDTH-1:0]       error_info,
input [pPHYUPD_TYPE_WIDTH-1:0]      phyupd_type,
input [pPHYMSTR_CS_STATE_WIDTH-1:0] phymstr_cs_state,
input [pPHYMSTR_TYPE_WIDTH -1:0]    phymstr_type,
output reg                          lp_ctrl_req,
output reg                          lp_data_req,
output reg [4:0]                    lp_data_wakeup,
output reg [4:0]                    lp_ctrl_wakeup,
output reg [0:0]                    dfi_dram_clk_disable_P0, 
output reg [0:0]                    dfi_dram_clk_disable_P1, 
output reg [0:0]                    dfi_dram_clk_disable_P2, 
output reg [0:0]                    dfi_dram_clk_disable_P3, 

output     [pFREQ_WIDTH-1:0]        freq,
output     [pFREQ_RATIO_WIDTH-1:0]  freq_ratio,
output     [pFREQ_FSP_WIDTH-1:0]    freq_fsp,

output  [pCKE_WIDTH-1:0]            cke_P0,
output  [pCKE_WIDTH-1:0]            cke_P1,
output  [pCKE_WIDTH-1:0]            cke_P2,
output  [pCKE_WIDTH-1:0]            cke_P3,
output  [pCS_WIDTH-1:0]             cs_P0,
output  [pCS_WIDTH-1:0]             cs_P1,
output  [pCS_WIDTH-1:0]             cs_P2,
output  [pCS_WIDTH-1:0]             cs_P3,

`ifdef LP5_STD
output  [pWCK_EN_WIDTH-1:0] dfi_wck_en_P0, dfi_wck_en_P1, dfi_wck_en_P2, dfi_wck_en_P3,
output  [pWCK_CS_WIDTH-1:0] dfi_wck_cs_P0, dfi_wck_cs_P1, dfi_wck_cs_P2, dfi_wck_cs_P3,
output  [pWCK_TOGGLE_WIDTH-1:0] dfi_wck_toggle_P0, dfi_wck_toggle_P1, dfi_wck_toggle_P2, dfi_wck_toggle_P3,
output  [pWRDATA_LINK_ECC_WIDTH-1:0] dfi_wrdata_link_ecc_P0, dfi_wrdata_link_ecc_P1, dfi_wrdata_link_ecc_P2, dfi_wrdata_link_ecc_P3,
output  [`DWC_DDRPHY_DFI_ADDRESS_P0_WIDTH:0]          address_P0,
`else
output  [`DWC_DDRPHY_DFI_ADDRESS_P0_WIDTH:0]          address_P0,
`endif
output  [pADDRESS_WIDTH-1:0]          address_P1,
output  [pADDRESS_WIDTH-1:0]          address_P2,
output  [pADDRESS_WIDTH-1:0]          address_P3,

output  [pDFI_WRDATA_WIDTH-1:0]         dfi_wrdata_P0, dfi_wrdata_P1, dfi_wrdata_P2, dfi_wrdata_P3,
output  [pDFI_WRDATA_CS_WIDTH-1:0]    dfi_wrdata_cs_n_P0, dfi_wrdata_cs_n_P1, dfi_wrdata_cs_n_P2, dfi_wrdata_cs_n_P3,
output  [pDFI_RDDATA_CS_WIDTH-1:0]    dfi_rddata_cs_n_P0, dfi_rddata_cs_n_P1, dfi_rddata_cs_n_P2, dfi_rddata_cs_n_P3,
output  [pDFI_WRDATA_EN_WIDTH-1:0]    dfi_wrdata_en_P0,  dfi_wrdata_en_P1,  dfi_wrdata_en_P2, dfi_wrdata_en_P3,
output  [pDFI_WRDATA_MASK_WIDTH-1:0]    dfi_wrdata_mask_P0, dfi_wrdata_mask_P1, dfi_wrdata_mask_P2, dfi_wrdata_mask_P3,
output  [pDFI_RDDATA_EN_WIDTH-1:0]    dfi_rddata_en_P0, dfi_rddata_en_P1, dfi_rddata_en_P2, dfi_rddata_en_P3,
input   [pDFI_RDDATA_VALID_WIDTH-1:0]    dfi_rddata_valid_W0, dfi_rddata_valid_W1, dfi_rddata_valid_W2, dfi_rddata_valid_W3,
input   [pDFI_RDDATA_DBI_WIDTH-1:0]     dfi_rddata_dbi_W0, dfi_rddata_dbi_W1, dfi_rddata_dbi_W2, dfi_rddata_dbi_W3,
input   [pDFI_RDDATA_WIDTH-1:0]         dfi_rddata_W0, dfi_rddata_W1, dfi_rddata_W2, dfi_rddata_W3        
);

// Import UVM
import uvm_pkg::*;

// Import SVT UVM
import svt_uvm_pkg::*;

// Import SVT MEM UVM
import svt_mem_uvm_pkg::*;

// Import the DFI and MC VIPs
import svt_dfi_uvm_pkg::*;
import svt_dfi_mc_uvm_pkg::*;

svt_dfi_1_to_4_ratio_frequency_if   dfi_mc_if();
int                                 compare_error=0;
int                                 read_trans_flag_n=0;

`ifndef DWC_DDRPHY_HWEMUL
//Connect active agent interface
  assign dfi_mc_if.dfi_clk           = clk; 
`ifdef LP5_STD
  assign dfi_mc_if.dfi_phy_clk       = phy_clk;
`endif
  assign dfi_mc_if.dfi_pwr_ok        = pwr_ok;                                                     
  assign dfi_mc_if.Reset             = Reset;  

  assign address_P0                  = dfi_mc_if.dfi_address_p ;
  assign address_P1                  = dfi_mc_if.dfi_address_p1;
  assign address_P2                  = dfi_mc_if.dfi_address_p2;
  assign address_P3                  = dfi_mc_if.dfi_address_p3;

//-------------------------------------------------------------
// update DFI VIP from N-2017.12 to O-2018.06 
//
//  assign cs_P0                       = dfi_mc_if.dfi_cs_n_p ;
//  assign cs_P1                       = dfi_mc_if.dfi_cs_n_p1;
//  assign cs_P2                       = dfi_mc_if.dfi_cs_n_p2;
//  assign cs_P3                       = dfi_mc_if.dfi_cs_n_p3;

  assign cs_P0                       = dfi_mc_if.dfi_cs_p ;
  assign cs_P1                       = dfi_mc_if.dfi_cs_p1;
  assign cs_P2                       = dfi_mc_if.dfi_cs_p2;
  assign cs_P3                       = dfi_mc_if.dfi_cs_p3;
//-------------------------------------------------------------

  assign cke_P0                      = dfi_mc_if.dfi_cke_p ;
  assign cke_P1                      = dfi_mc_if.dfi_cke_p1;
  assign cke_P2                      = dfi_mc_if.dfi_cke_p2;
  assign cke_P3                      = dfi_mc_if.dfi_cke_p3;

  assign dfi_wck_en_P0               = dfi_mc_if.dfi_wck_en_p;
  assign dfi_wck_en_P1               = dfi_mc_if.dfi_wck_en_p1;
  assign dfi_wck_en_P2               = dfi_mc_if.dfi_wck_en_p2;
  assign dfi_wck_en_P3               = dfi_mc_if.dfi_wck_en_p3;

  assign dfi_wck_cs_P0               = dfi_mc_if.dfi_wck_cs_p;
  assign dfi_wck_cs_P1               = dfi_mc_if.dfi_wck_cs_p1;
  assign dfi_wck_cs_P2               = dfi_mc_if.dfi_wck_cs_p2;
  assign dfi_wck_cs_P3               = dfi_mc_if.dfi_wck_cs_p3;

  assign dfi_wck_toggle_P0           = dfi_mc_if.dfi_wck_toggle_p;
  assign dfi_wck_toggle_P1           = dfi_mc_if.dfi_wck_toggle_p1;
  assign dfi_wck_toggle_P2           = dfi_mc_if.dfi_wck_toggle_p2;
  assign dfi_wck_toggle_P3           = dfi_mc_if.dfi_wck_toggle_p3;

  assign dfi_wrdata_en_P0            = dfi_mc_if.dfi_wrdata_en_p ;
  assign dfi_wrdata_en_P1            = dfi_mc_if.dfi_wrdata_en_p1;
  assign dfi_wrdata_en_P2            = dfi_mc_if.dfi_wrdata_en_p2;
  assign dfi_wrdata_en_P3            = dfi_mc_if.dfi_wrdata_en_p3;

//-------------------------------------------------------------
// update DFI VIP from N-2017.12 to O-2018.06 
//
//  assign dfi_wrdata_cs_n_P0          = dfi_mc_if.dfi_wrdata_cs_n_p ;
//  assign dfi_wrdata_cs_n_P1          = dfi_mc_if.dfi_wrdata_cs_n_p1;
//  assign dfi_wrdata_cs_n_P2          = dfi_mc_if.dfi_wrdata_cs_n_p2;
//  assign dfi_wrdata_cs_n_P3          = dfi_mc_if.dfi_wrdata_cs_n_p3;

  assign dfi_wrdata_cs_n_P0          = dfi_mc_if.dfi_wrdata_cs_p ;
  assign dfi_wrdata_cs_n_P1          = dfi_mc_if.dfi_wrdata_cs_p1;
  assign dfi_wrdata_cs_n_P2          = dfi_mc_if.dfi_wrdata_cs_p2;
  assign dfi_wrdata_cs_n_P3          = dfi_mc_if.dfi_wrdata_cs_p3;
//-------------------------------------------------------------

  assign dfi_wrdata_P0               = dfi_mc_if.dfi_wrdata_p ;
  assign dfi_wrdata_P1               = dfi_mc_if.dfi_wrdata_p1;
  assign dfi_wrdata_P2               = dfi_mc_if.dfi_wrdata_p2;
  assign dfi_wrdata_P3               = dfi_mc_if.dfi_wrdata_p3;

  assign dfi_wrdata_mask_P0          = dfi_mc_if.dfi_wrdata_mask_p ;
  assign dfi_wrdata_mask_P1          = dfi_mc_if.dfi_wrdata_mask_p1;
  assign dfi_wrdata_mask_P2          = dfi_mc_if.dfi_wrdata_mask_p2;
  assign dfi_wrdata_mask_P3          = dfi_mc_if.dfi_wrdata_mask_p3;

  assign dfi_rddata_en_P0            = dfi_mc_if.dfi_rddata_en_p ;
  assign dfi_rddata_en_P1            = dfi_mc_if.dfi_rddata_en_p1;
  assign dfi_rddata_en_P2            = dfi_mc_if.dfi_rddata_en_p2;
  assign dfi_rddata_en_P3            = dfi_mc_if.dfi_rddata_en_p3;

//-------------------------------------------------------------
// update DFI VIP from N-2017.12 to O-2018.06 
//
//  assign dfi_rddata_cs_n_P0          = dfi_mc_if.dfi_rddata_cs_n_p ;
//  assign dfi_rddata_cs_n_P1          = dfi_mc_if.dfi_rddata_cs_n_p1;
//  assign dfi_rddata_cs_n_P2          = dfi_mc_if.dfi_rddata_cs_n_p2;
//  assign dfi_rddata_cs_n_P3          = dfi_mc_if.dfi_rddata_cs_n_p3;

  assign dfi_rddata_cs_n_P0          = dfi_mc_if.dfi_rddata_cs_p ;
  assign dfi_rddata_cs_n_P1          = dfi_mc_if.dfi_rddata_cs_p1;
  assign dfi_rddata_cs_n_P2          = dfi_mc_if.dfi_rddata_cs_p2;
  assign dfi_rddata_cs_n_P3          = dfi_mc_if.dfi_rddata_cs_p3;
//-------------------------------------------------------------

  assign dfi_mc_if.dfi_rddata_valid_w   = dfi_rddata_valid_W0;
  assign dfi_mc_if.dfi_rddata_valid_w1  = dfi_rddata_valid_W1;
  assign dfi_mc_if.dfi_rddata_valid_w2  = dfi_rddata_valid_W2; 
  assign dfi_mc_if.dfi_rddata_valid_w3  = dfi_rddata_valid_W3;

  assign dfi_mc_if.dfi_rddata_w         = dfi_rddata_W0;
  assign dfi_mc_if.dfi_rddata_w1        = dfi_rddata_W1;
  assign dfi_mc_if.dfi_rddata_w2        = dfi_rddata_W2;
  assign dfi_mc_if.dfi_rddata_w3        = dfi_rddata_W3;

  assign dfi_mc_if.dfi_rddata_dbi_n_w   = dfi_rddata_dbi_W0;
  assign dfi_mc_if.dfi_rddata_dbi_n_w1  = dfi_rddata_dbi_W1;
  assign dfi_mc_if.dfi_rddata_dbi_n_w2  = dfi_rddata_dbi_W2;
  assign dfi_mc_if.dfi_rddata_dbi_n_w3  = dfi_rddata_dbi_W3;


  //DFI init interface
  assign init_start                     = dfi_mc_if.dfi_init_start;
  assign dfi_mc_if.dfi_init_complete    = init_complete;
  assign freq                           = dfi_mc_if.dfi_frequency;
  assign freq_ratio                     = dfi_mc_if.dfi_freq_ratio;
  assign freq_fsp                       = dfi_mc_if.dfi_freq_fsp;

  //DFI side band interface
  assign ctrlupd_req                    = dfi_mc_if.dfi_ctrlupd_req ;
  assign dfi_mc_if.dfi_ctrlupd_ack      = ctrlupd_ack;
  assign dfi_mc_if.dfi_phyupd_req       = phyupd_req;
  assign phyupd_ack                     = dfi_mc_if.dfi_phyupd_ack ;
  assign lp_ctrl_req               = dfi_mc_if.dfi_lp_ctrl_req ;
  assign dfi_mc_if.dfi_lp_ctrl_ack = lp_ctrl_ack ;
  assign lp_data_req               = dfi_mc_if.dfi_lp_data_req ;
  assign dfi_mc_if.dfi_lp_data_ack = lp_data_ack ;
  `ifndef DFI_SVT_DFI5
  assign lp_ctrl_wakeup       = dfi_mc_if.dfi_lp_wakeup ;
  assign dfi_mc_if.dfi_lp_ack = lp_ctrl_ack;
  `else
  assign lp_ctrl_wakeup = dfi_mc_if.dfi_lp_ctrl_wakeup ;
  assign lp_data_wakeup = dfi_mc_if.dfi_lp_data_wakeup ;
  `endif


  assign dfi_mc_if.dfi_error            = error;  
  assign dfi_mc_if.dfi_error_info       = error_info;
  assign dfi_mc_if.dfi_phymstr_req      = phymstr_req;
  assign phymstr_ack                    = dfi_mc_if.dfi_phymstr_ack;
  assign dfi_mc_if.dfi_phymstr_type     = phyupd_type;
  assign dfi_mc_if.dfi_phymstr_cs_state = phymstr_cs_state;
  assign dfi_mc_if.dfi_phymstr_state_sel = phymstr_state_sel;


  //= dfi_mc_if.dfi_geardown_en;
  //= dfi_mc_if.dfi_data_byte_disable ;
  `ifdef DFI_SVT_DFI5
  assign dfi_dram_clk_disable_P0 = dfi_mc_if.dfi_dram_clk_disable_p  ;
  assign dfi_dram_clk_disable_P1 = dfi_mc_if.dfi_dram_clk_disable_p1 ;
  assign dfi_dram_clk_disable_P2 = dfi_mc_if.dfi_dram_clk_disable_p2 ;
  assign dfi_dram_clk_disable_P3 = dfi_mc_if.dfi_dram_clk_disable_p3 ;

  `else
  assign dfi_dram_clk_disable_P0 = dfi_mc_if.dfi_dram_clk_disable ;
  assign dfi_dram_clk_disable_P1 = dfi_mc_if.dfi_dram_clk_disable ;
  assign dfi_dram_clk_disable_P2 = dfi_mc_if.dfi_dram_clk_disable ;
  assign dfi_dram_clk_disable_P3 = dfi_mc_if.dfi_dram_clk_disable ;
  `endif

  `else
  //elvin add for emulation v2vx
  //Connect active agent interface
  assign  dfi_mc_if.dfi_clk           = clk; 
`ifdef LP5_STD
  assign  dfi_mc_if.dfi_phy_clk       = phy_clk;
`endif
  assign  dfi_mc_if.dfi_pwr_ok        = pwr_ok;                                                     
  assign  dfi_mc_if.Reset             = Reset;  

  assign #1 address_P0                  = dfi_mc_if.dfi_address_p ;
  assign #1 address_P1                  = dfi_mc_if.dfi_address_p1;
  assign #1 address_P2                  = dfi_mc_if.dfi_address_p2;
  assign #1 address_P3                  = dfi_mc_if.dfi_address_p3;

//-------------------------------------------------------------
// update DFI VIP from N-2017.12 to O-2018.06 
//
//  assign cs_P0                       = dfi_mc_if.dfi_cs_n_p ;
//  assign cs_P1                       = dfi_mc_if.dfi_cs_n_p1;
//  assign cs_P2                       = dfi_mc_if.dfi_cs_n_p2;
//  assign cs_P3                       = dfi_mc_if.dfi_cs_n_p3;

  assign #1 cs_P0                       = dfi_mc_if.dfi_cs_p ;
  assign #1 cs_P1                       = dfi_mc_if.dfi_cs_p1;
  assign #1 cs_P2                       = dfi_mc_if.dfi_cs_p2;
  assign #1 cs_P3                       = dfi_mc_if.dfi_cs_p3;
//-------------------------------------------------------------

  assign #1 cke_P0                      = dfi_mc_if.dfi_cke_p ;
  assign #1 cke_P1                      = dfi_mc_if.dfi_cke_p1;
  assign #1 cke_P2                      = dfi_mc_if.dfi_cke_p2;
  assign #1 cke_P3                      = dfi_mc_if.dfi_cke_p3;

  assign #1 dfi_wck_en_P0               = dfi_mc_if.dfi_wck_en_p;
  assign #1 dfi_wck_en_P1               = dfi_mc_if.dfi_wck_en_p1;
  assign #1 dfi_wck_en_P2               = dfi_mc_if.dfi_wck_en_p2;
  assign #1 dfi_wck_en_P3               = dfi_mc_if.dfi_wck_en_p3;

  assign #1 dfi_wck_cs_P0               = dfi_mc_if.dfi_wck_cs_p;
  assign #1 dfi_wck_cs_P1               = dfi_mc_if.dfi_wck_cs_p1;
  assign #1 dfi_wck_cs_P2               = dfi_mc_if.dfi_wck_cs_p2;
  assign #1 dfi_wck_cs_P3               = dfi_mc_if.dfi_wck_cs_p3;

  assign #1 dfi_wck_toggle_P0           = dfi_mc_if.dfi_wck_toggle_p;
  assign #1 dfi_wck_toggle_P1           = dfi_mc_if.dfi_wck_toggle_p1;
  assign #1 dfi_wck_toggle_P2           = dfi_mc_if.dfi_wck_toggle_p2;
  assign #1 dfi_wck_toggle_P3           = dfi_mc_if.dfi_wck_toggle_p3;
  
  assign #1 dfi_wrdata_en_P0            = dfi_mc_if.dfi_wrdata_en_p ;
  assign #1 dfi_wrdata_en_P1            = dfi_mc_if.dfi_wrdata_en_p1;
  assign #1 dfi_wrdata_en_P2            = dfi_mc_if.dfi_wrdata_en_p2;
  assign #1 dfi_wrdata_en_P3            = dfi_mc_if.dfi_wrdata_en_p3;

//-------------------------------------------------------------
// update DFI VIP from N-2017.12 to O-2018.06 
//
//  assign dfi_wrdata_cs_n_P0          = dfi_mc_if.dfi_wrdata_cs_n_p ;
//  assign dfi_wrdata_cs_n_P1          = dfi_mc_if.dfi_wrdata_cs_n_p1;
//  assign dfi_wrdata_cs_n_P2          = dfi_mc_if.dfi_wrdata_cs_n_p2;
//  assign dfi_wrdata_cs_n_P3          = dfi_mc_if.dfi_wrdata_cs_n_p3;

  assign #1 dfi_wrdata_cs_n_P0          = dfi_mc_if.dfi_wrdata_cs_p ;
  assign #1 dfi_wrdata_cs_n_P1          = dfi_mc_if.dfi_wrdata_cs_p1;
  assign #1 dfi_wrdata_cs_n_P2          = dfi_mc_if.dfi_wrdata_cs_p2;
  assign #1 dfi_wrdata_cs_n_P3          = dfi_mc_if.dfi_wrdata_cs_p3;
//-------------------------------------------------------------

  assign #1 dfi_wrdata_P0               = dfi_mc_if.dfi_wrdata_p ;
  assign #1 dfi_wrdata_P1               = dfi_mc_if.dfi_wrdata_p1;
  assign #1 dfi_wrdata_P2               = dfi_mc_if.dfi_wrdata_p2;
  assign #1 dfi_wrdata_P3               = dfi_mc_if.dfi_wrdata_p3;

  assign #1 dfi_wrdata_mask_P0          = dfi_mc_if.dfi_wrdata_mask_p ;
  assign #1 dfi_wrdata_mask_P1          = dfi_mc_if.dfi_wrdata_mask_p1;
  assign #1 dfi_wrdata_mask_P2          = dfi_mc_if.dfi_wrdata_mask_p2;
  assign #1 dfi_wrdata_mask_P3          = dfi_mc_if.dfi_wrdata_mask_p3;

  assign #1 dfi_rddata_en_P0            = dfi_mc_if.dfi_rddata_en_p ;
  assign #1 dfi_rddata_en_P1            = dfi_mc_if.dfi_rddata_en_p1;
  assign #1 dfi_rddata_en_P2            = dfi_mc_if.dfi_rddata_en_p2;
  assign #1 dfi_rddata_en_P3            = dfi_mc_if.dfi_rddata_en_p3;

//-------------------------------------------------------------
// update DFI VIP from N-2017.12 to O-2018.06 
//
//  assign dfi_rddata_cs_n_P0          = dfi_mc_if.dfi_rddata_cs_n_p ;
//  assign dfi_rddata_cs_n_P1          = dfi_mc_if.dfi_rddata_cs_n_p1;
//  assign dfi_rddata_cs_n_P2          = dfi_mc_if.dfi_rddata_cs_n_p2;
//  assign dfi_rddata_cs_n_P3          = dfi_mc_if.dfi_rddata_cs_n_p3;

  assign #1 dfi_rddata_cs_n_P0          = dfi_mc_if.dfi_rddata_cs_p ;
  assign #1 dfi_rddata_cs_n_P1          = dfi_mc_if.dfi_rddata_cs_p1;
  assign #1 dfi_rddata_cs_n_P2          = dfi_mc_if.dfi_rddata_cs_p2;
  assign #1 dfi_rddata_cs_n_P3          = dfi_mc_if.dfi_rddata_cs_p3;
//-------------------------------------------------------------

  assign  dfi_mc_if.dfi_rddata_valid_w   = dfi_rddata_valid_W0;
  assign  dfi_mc_if.dfi_rddata_valid_w1  = dfi_rddata_valid_W1;
  assign  dfi_mc_if.dfi_rddata_valid_w2  = dfi_rddata_valid_W2; 
  assign  dfi_mc_if.dfi_rddata_valid_w3  = dfi_rddata_valid_W3;

  assign  dfi_mc_if.dfi_rddata_w         = dfi_rddata_W0;
  assign  dfi_mc_if.dfi_rddata_w1        = dfi_rddata_W1;
  assign  dfi_mc_if.dfi_rddata_w2        = dfi_rddata_W2;
  assign  dfi_mc_if.dfi_rddata_w3        = dfi_rddata_W3;

  assign  dfi_mc_if.dfi_rddata_dbi_n_w   = dfi_rddata_dbi_W0;
  assign  dfi_mc_if.dfi_rddata_dbi_n_w1  = dfi_rddata_dbi_W1;
  assign  dfi_mc_if.dfi_rddata_dbi_n_w2  = dfi_rddata_dbi_W2;
  assign  dfi_mc_if.dfi_rddata_dbi_n_w3  = dfi_rddata_dbi_W3;


  //DFI init interface
  assign #1 init_start                     = dfi_mc_if.dfi_init_start;
  assign  dfi_mc_if.dfi_init_complete    = init_complete;
  assign #1 freq                           = dfi_mc_if.dfi_frequency;
  assign #1 freq_ratio                     = dfi_mc_if.dfi_freq_ratio;
  assign #1 freq_fsp                       = dfi_mc_if.dfi_freq_fsp;

  //DFI side band interface
  assign #1 ctrlupd_req                    = dfi_mc_if.dfi_ctrlupd_req ;
  assign  dfi_mc_if.dfi_ctrlupd_ack        = ctrlupd_ack;
  assign  dfi_mc_if.dfi_phyupd_req         = phyupd_req;
  assign #1 phyupd_ack                     = dfi_mc_if.dfi_phyupd_ack ;
  assign #1 lp_ctrl_req                    = dfi_mc_if.dfi_lp_ctrl_req ;
  assign  dfi_mc_if.dfi_lp_ctrl_ack        = lp_ctrl_ack ;
  assign #1 lp_data_req                    = dfi_mc_if.dfi_lp_data_req ;
  assign  dfi_mc_if.dfi_lp_data_ack        = lp_data_ack ;
  `ifndef DFI_SVT_DFI5
  assign #1 lp_ctrl_wakeup                 = dfi_mc_if.dfi_lp_wakeup ;
  assign  dfi_mc_if.dfi_lp_ack = lp_ctrl_ack;
  `else
  assign #1 lp_ctrl_wakeup                 = dfi_mc_if.dfi_lp_ctrl_wakeup ;
  assign #1 lp_data_wakeup                 = dfi_mc_if.dfi_lp_data_wakeup ;
  `endif


  assign dfi_mc_if.dfi_error            = error;  
  assign dfi_mc_if.dfi_error_info       = error_info;
  assign dfi_mc_if.dfi_phymstr_req      = phymstr_req;
  assign #1 phymstr_ack                    = dfi_mc_if.dfi_phymstr_ack;
  assign dfi_mc_if.dfi_phymstr_type     = phyupd_type;
  assign dfi_mc_if.dfi_phymstr_cs_state = phymstr_cs_state;
  assign dfi_mc_if.dfi_phymstr_state_sel = phymstr_state_sel;


  //= dfi_mc_if.dfi_geardown_en;
  //= dfi_mc_if.dfi_data_byte_disable ;
  `ifdef DFI_SVT_DFI5
  assign #1 dfi_dram_clk_disable_P0 = dfi_mc_if.dfi_dram_clk_disable_p  ;
  assign #1 dfi_dram_clk_disable_P1 = dfi_mc_if.dfi_dram_clk_disable_p1 ;
  assign #1 dfi_dram_clk_disable_P2 = dfi_mc_if.dfi_dram_clk_disable_p2 ;
  assign #1 dfi_dram_clk_disable_P3 = dfi_mc_if.dfi_dram_clk_disable_p3 ;

  `else
  assign #1 dfi_dram_clk_disable_P0 = dfi_mc_if.dfi_dram_clk_disable ;
  assign #1 dfi_dram_clk_disable_P1 = dfi_mc_if.dfi_dram_clk_disable ;
  assign #1 dfi_dram_clk_disable_P2 = dfi_mc_if.dfi_dram_clk_disable ;
  assign #1 dfi_dram_clk_disable_P3 = dfi_mc_if.dfi_dram_clk_disable ;
  `endif

`endif

int disable_data_compare = 0;

  int wr_data_id = 0;
  int max_data_num_to_compare=17000; 
  int data_cmp_id = 0;
  int tCK_ps;
  reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] DATA[17000];

  reg [`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_wrdata_mask_pN[17000];
  bit W_DM,W_DBI,R_DBI;

svt_dfi_mc_agent                    dfi_mc_agent;
svt_dfi_mc_agent_configuration      dfi_mc_cfg;
uvm_factory                         uvm_factory_h;
string mc_agent_name;
string mc_cfg_name;

task set_default;
  dfi_mc_cfg.freq_ratio = 4;
  dfi_mc_cfg.cs_polarity = 1;
endtask

task update_cfg(bit[1:0] PState=cfg.PState);
  int sub_lat = 5;
  int tDQSS = 1;
  int low_freq_support = 0;
  int tWCKSTOP;
  int tWCKPST;
  int twckdis_final = 0;
  cfg.PState=PState;
  $display("[%0t] <%m> svt_dfi_uvmlog: update_cfg.", $time);
  tCK_ps  = (1_000_000.0/cfg.Frequency[cfg.PState]);//cycle
  $display("[%0t] <%m> tCK_ps = %0d , Pstate = %0d, Frequency = %0d .", $time, tCK_ps, cfg.PState, cfg.Frequency[cfg.PState]);
  //dfi_mc_cfg : dram_type, freq_ratio ...
  dfi_mc_cfg.dfi_frequency_ratio = cfg.DfiFreqRatio[PState];
  //dfi_mc_cfg.dfi_ddr_ratio =2**cfg.DfiFreqRatio[PState];
  if(cfg.DfiFreqRatio[PState]==0)begin
     dfi_mc_cfg.dfi_ddr_ratio =dfi_mc_cfg.DFI_1_1;
  end else if(cfg.DfiFreqRatio[PState]==1)begin
     dfi_mc_cfg.dfi_ddr_ratio =dfi_mc_cfg.DFI_1_2;
  end else if(cfg.DfiFreqRatio[PState]==2)begin
     dfi_mc_cfg.dfi_ddr_ratio =dfi_mc_cfg.DFI_1_4;
  end else begin
    $finish;
  end
  dfi_mc_cfg.freq_ratio = 2**cfg.DfiFreqRatio[PState];
  dfi_mc_cfg.num_phase = 4;
  //Free running mode
  `ifdef LP5_STD
    if(cfg.PState == 0) begin
      `ifdef POWERSIM_WCK_FREE
        dfi_mc_cfg.enable_free_running_mode = 1;
        dfi_mc_cfg.free_running_mode_through_mrw = 0;
      `endif
      `ifdef POWERSIM_WCK_OFF
        dfi_mc_cfg.free_running_mode_through_mrw = 1;
      `endif
    end
    else begin
      `ifdef POWERSIM_WCK_FREE1
        dfi_mc_cfg.enable_free_running_mode = 1;
        dfi_mc_cfg.free_running_mode_through_mrw = 0;
      `endif
      `ifdef POWERSIM_WCK_OFF1
        dfi_mc_cfg.free_running_mode_through_mrw = 1;
      `endif
    end
  `endif
  //dif timing
  `ifdef LP5_STD
    if(cfg.DfiFreqRatio[PState]==1 && cfg.Frequency[PState]<=688 && cfg.Frequency[PState]>267)begin
      low_freq_support = 2;
    end
    else if(cfg.DfiFreqRatio[PState]==1 && cfg.Frequency[PState]<=267)begin
      low_freq_support = 4;
    end
    else if(cfg.DfiFreqRatio[PState]==2 && cfg.Frequency[PState]<=133) begin
      low_freq_support = 4;
    end
    else begin 
      low_freq_support = 0;
    end
    $display("svt_dfi_uvmlog: low_freq_support = %d", low_freq_support);
  `endif

  `ifdef LP5_STD
  //dfi_mc_cfg.timing_cfg.tphy_wrlat_phy_ck = (cfg.CWL[PState]+cfg.parity_latency[PState])*2*cfg.DfiFreqRatio[PState] - sub_lat;
  dfi_mc_cfg.timing_cfg.tphy_wrlat_phy_ck = (cfg.CWL[PState]+0)*2*cfg.DfiFreqRatio[PState] - sub_lat +low_freq_support;
  dfi_mc_cfg.timing_cfg.tphy_wrcslat_phy_ck = dfi_mc_cfg.timing_cfg.tphy_wrlat_phy_ck; //command to wrdata_cs_n delay
  dfi_mc_cfg.timing_cfg.tphy_wrdata_phy_ck = 2; //wrdata_en to wrdata delay
  //dfi_mc_cfg.timing_cfg.trddata_en_phy_ck = (cfg.CWL[PState]+cfg.parity_latency[PState])*2*cfg.DfiFreqRatio[PState] - sub_lat;
  dfi_mc_cfg.timing_cfg.trddata_en_phy_ck = (cfg.CL[PState]+0)*2*cfg.DfiFreqRatio[PState] - sub_lat +low_freq_support;
  dfi_mc_cfg.timing_cfg.tphy_rdcslat_phy_ck = dfi_mc_cfg.timing_cfg.trddata_en_phy_ck ;//command to rddata_cs_n delay
  `else
  dfi_mc_cfg.timing_cfg.tcmd_lat_phy_ck = 0;
  dfi_mc_cfg.timing_cfg.tphy_wrlat_phy_ck = cfg.CWL[PState] - sub_lat + tDQSS - ((cfg.Frequency[PState] > 1600 & cfg.DfiFreqRatio[PState] == 1) ? 2 : 0); //command to wrdata_en delay  15,3
  dfi_mc_cfg.timing_cfg.tphy_wrcslat_phy_ck = dfi_mc_cfg.timing_cfg.tphy_wrlat_phy_ck; //command to wrdata_cs_n delay
  dfi_mc_cfg.timing_cfg.tphy_wrdata_phy_ck = 2; //wrdata_en to wrdata delay
  dfi_mc_cfg.timing_cfg.trddata_en_phy_ck = cfg.CL[PState] - sub_lat;//command to rddata_en delay
  dfi_mc_cfg.timing_cfg.tphy_rdcslat_phy_ck = dfi_mc_cfg.timing_cfg.trddata_en_phy_ck ;//command to rddata_cs_n delay
  `endif

  //truth table v=0
  //dfi_mc_cfg.drive_x_ca_v_fields = 1'b0;
  //`ifdef DDRPHY_POWERSIM_VIP_201906
  `ifdef LP5_STD 
  dfi_mc_cfg.nop_as_des = 1; //svt_dfi_mc_active_common:drive_dfi_control, if not enable this flay, DES address can not be controlled
  `endif
  //`endif
  dfi_mc_cfg.drive_rand_bit_ca_v_fields = 1'b0;
  dfi_mc_cfg.drive_user_defined_ca_v_fileds = 1'b0; 

  dfi_mc_cfg.deassert_dfi_init_start = 1'b1;  //deassert dfi_init_start after initial done. 
  `ifdef DDRPHY_POWERSIM
  dfi_mc_cfg.lp2_duration = 1000; //lp2 holding time 
  `else
  dfi_mc_cfg.lp2_duration = 150; //lp2 holding time 
  `endif
  //enable dfi_mc_monitor
  dfi_mc_cfg.enable_dfi_mc_monitor = 1;
  dfi_mc_cfg.enable_dfi_mc_chk = 1;
  dfi_mc_cfg.enable_dfi_mc_cov = 5'b11111;

  `ifdef LP5_STD 
  //dfi_mc_cfg.tphy_wrcslat= 23;
  //dfi_mc_cfg.tphy_wrlat= 23;
  if(cfg.MR10[PState][3:2] == 0) begin
    tWCKPST = 2.5;
  end else if (cfg.MR10[PState][3:2] == 1) begin
    tWCKPST = 4.5;
  end else if (cfg.MR10[PState][3:2] == 2) begin
    tWCKPST = 6.5;
  end else begin
    $display("svt_dfi_uvmlog: In valid WCK PST !!!");
    $finish;
  end  
    $display("svt_dfi_uvmlog: tWCKPST=%0d.",tWCKPST);
  tWCKSTOP=(((tCK_ps*2) > 6000) ? 2  : ((6000/tCK_ps)+1) ) * 2*cfg.DfiFreqRatio[cfg.PState];
  //dfi_mc_cfg.timing_cfg.tphy_wck_dis = 2*cfg.DfiFreqRatio[PState] + low_freq_support;// twckpst issue with Freq 267
  twckdis_final = ( ($ceil(tWCKPST)>tWCKSTOP) ? $ceil(tWCKPST) : tWCKSTOP) - 4 + low_freq_support;
  //twckdis_final =  $ceil(tWCKPST) - 4 + low_freq_support;
    if (twckdis_final < 0) dfi_mc_cfg.timing_cfg.tphy_wck_dis       = 0 ;
    else                   dfi_mc_cfg.timing_cfg.tphy_wck_dis       =  twckdis_final ;
    $display("[%0t] <%m> tphy_wck_dis = %d, twckdis_final = %0d, tWCKPST = %0d, tWCKSTOP = %0d .", $time, dfi_mc_cfg.timing_cfg.tphy_wck_dis, twckdis_final, tWCKPST, tWCKSTOP);
  dfi_mc_cfg.timing_cfg.tphy_wck_toggle_cs = 2*cfg.DfiFreqRatio[PState];
  dfi_mc_cfg.timing_cfg.tphy_wck_toggle_post = tWCKPST + 1;//cfg.tWCKPST[PState]+1;  MR10[3:2]
  dfi_mc_cfg.timing_cfg.tphy_wck_en_rd = (cfg.CL[PState]-cfg.tWCKPRE_total_RD[PState]+1)*2*cfg.DfiFreqRatio[PState] -4 +low_freq_support;
  dfi_mc_cfg.timing_cfg.tphy_wck_en_wr = (cfg.CWL[PState]-cfg.tWCKPRE_total_WR[PState]+1)*2*cfg.DfiFreqRatio[PState] -4 +low_freq_support;
  dfi_mc_cfg.timing_cfg.tphy_wck_en_fs = cfg.tWCKENL_FS[PState]*2*cfg.DfiFreqRatio[PState] -4 +low_freq_support;
  dfi_mc_cfg.timing_cfg.tphy_wck_toggle = cfg.tWCKPRE_Static[PState]*2*cfg.DfiFreqRatio[PState];
  dfi_mc_cfg.timing_cfg.tphy_wck_toggle_rd = (cfg.CL[PState]-cfg.tWCKPRE_RFR[PState])*2*cfg.DfiFreqRatio[PState];
  dfi_mc_cfg.timing_cfg.tphy_wck_toggle_wr = (cfg.CWL[PState]-cfg.tWCKPRE_WFR[PState])*2*cfg.DfiFreqRatio[PState];
  dfi_mc_cfg.timing_cfg.tphy_wck_fast_toggle = 4;
  `endif
  wait(dfi_mc_agent.mc_driver != null);
  dfi_mc_agent.mc_driver.reconfigure(dfi_mc_cfg);
  $display("[%0t] <%m> svt_dfi_uvmlog: dfi_mc_cfg.print()", $time);
  dfi_mc_cfg.print();
endtask

initial begin
  if(`EMUL_BUBBLE == 0) max_data_num_to_compare=512; //Because row number doesn't change when bubble is not enabled, and max data number is 512 in one row.
  $display("[%0t] <%m> svt_dfi_uvmlog: initial begin", $time);
  uvm_factory_h = uvm_factory::get();
  `ifdef LP5_STD
  uvm_factory_h.set_type_override_by_type(svt_dfi_mc_transaction::get_type(), svt_dfi_mc_lpddr5_transaction::get_type());
  `else
  uvm_factory_h.set_type_override_by_type(svt_dfi_mc_transaction::get_type(), svt_dfi_mc_lpddr4_transaction::get_type());
  `endif

  mc_agent_name = $psprintf("dfi_mc_agent%0d",pIndex);
  mc_cfg_name = $psprintf("dfi_mc_cfg%0d",pIndex);
  dfi_mc_agent = svt_dfi_mc_agent::type_id::create(mc_agent_name,uvm_root::get());
  dfi_mc_agent.is_active = `SVT_XVM(active_passive_enum)'(1);
  dfi_mc_cfg = svt_dfi_mc_agent_configuration::type_id::create(mc_cfg_name);
  dfi_mc_cfg.is_active = 1;
  `ifdef LP5_STD
  dfi_mc_cfg.dram_type = svt_dfi_types::LPDDR5;
  dfi_mc_cfg.cs_polarity = 1'b1;
  `else
  dfi_mc_cfg.dram_type = svt_dfi_types::LPDDR4;
  dfi_mc_cfg.assert_sideband_with_des = 1'b1; //dfi_cs is made 1 when send dfi_lowpower_control_req.  
  `endif
  dfi_mc_cfg.drive_x_ca_v_fields = 0;
  dfi_mc_cfg.drive_valid_sr = 1;  
  //dfi_init_start_timing for O-2018.12 VIP 
  dfi_mc_cfg.dfi_init_start_deassertion_cycle=900;  //For O_2018.12 vip, used in svt_dfi_mc_active_common::dfi_freq_change
  
  uvm_config_db#(svt_dfi_1_to_4_ratio_frequency_vif)::set(uvm_root::get(), mc_agent_name, "vif", dfi_mc_if);
  svt_config_object_db#(svt_dfi_mc_agent_configuration)::set(uvm_root::get(), mc_agent_name, "cfg", dfi_mc_cfg);
  update_cfg();   //dfi signal(*[pstate]) inital value *[1],*[2],*[3] will not be assigned if pstate_num>1, and dfi_mc_cfg not update.
  $display("SVT_DFI_CHIP_SELECT_WIDTH = %0d",`SVT_DFI_CHIP_SELECT_WIDTH);   //CS width
  $display("SVT_DFI_MAX_DATA_WIDTH = %0d",`SVT_DFI_MAX_DATA_WIDTH);         //16*DBYTE number
  $display("SVT_DFI_DATA_ENABLE_WIDTH = %0d",`SVT_DFI_DATA_ENABLE_WIDTH);   //DBYTE number
  $display("DFI_MAX_ADDRESS_WIDTH = %0d",`DFI_MAX_ADDRESS_WIDTH);   

  $display(">>>>>>>>>>>>>>>>>>>>>>>   DFI VIP Configure Done   <<<<<<<<<<<<<<<<<<<<<<<<<<<");
  fork 
    sample_rddata();
  join
  $display("[%0t] <%m> svt_dfi_uvmlog: initial end", $time);
end

`include "svt_dfi_drive_sequence.sv"
`include "svt_dfi_init_wrapper_seq.sv"
`include "svt_dfi_init_freq_chng_seq.sv"
`include "svt_dfi_ctrlupd_req_assert_seq.sv"
`include "svt_dfi_ctrlupd_req_deassert_seq.sv"
`include "svt_dfi_phymstr_ack_assert_seq.sv"
`include "svt_dfi_phyupd_ack_assert_seq.sv"
`ifdef LP4_STD
`include "svt_dfi_lpddr4_pde_seq.sv"
`include "svt_dfi_lpddr4_pdx_seq.sv"
`include "svt_dfi_lpddr4_srx_seq.sv"
`include "svt_dfi_lpddr4_sre_seq.sv"
`include "svt_dfi_lpddr4_pre_seq.sv"
`include "svt_dfi_dram_clk_disable_seq.sv"
`include "svt_dfi_dram_clk_enable_seq.sv"
//`include "svt_dfi_lpddr4_nop_seq.sv"
`include "svt_dfi_lpddr4_act_seq.sv"
`include "svt_dfi_lpddr4_wr_seq.sv"
`include "svt_dfi_lpddr4_rd_seq.sv"
`include "svt_dfi_lpddr4_refresh_seq.sv"
//`include "svt_dfi_lpddr4_precharge_seq.sv"
`include "svt_dfi_lpddr4_mrw_seq.sv"
`include "svt_dfi_lpddr4_pre_seq.sv"
`include "svt_dfi_lpddr4_w2w_seq.sv"
`include "svt_dfi_lpddr4_des_seq.sv"
`include "svt_dfi_lpddr4_lp_assert_seq.sv"
`endif
`ifdef LP5_STD
`include "svt_dfi_lpddr5_des_seq.sv"
`include "svt_dfi_lpddr5_srx_seq.sv"
`include "svt_dfi_lpddr5_sre_seq.sv"
`include "svt_dfi_lpddr5_pde_seq.sv"
`include "svt_dfi_lpddr5_pdx_seq.sv"
`include "svt_dfi_dram_clk_disable_seq.sv"
`include "svt_dfi_dram_clk_enable_seq.sv"
`include "svt_dfi_lpddr5_mrw_seq.sv"
`include "svt_dfi_lpddr5_act_seq.sv"
`include "svt_dfi_lpddr5_wr_seq.sv"
`include "svt_dfi_lpddr5_rd_seq.sv"
`include "svt_dfi_lpddr5_refresh_seq.sv"
`include "svt_dfi_lpddr5_refall_seq.sv"
`include "svt_dfi_lpddr5_cas_seq.sv"
`include "svt_dfi_lpddr5_pre_seq.sv"
`include "svt_dfi_lpddr5_lp_assert_seq.sv"
`endif


task dfi0_ctrlupd(int t_ctrlupd_max=0);
begin
  svt_dfi_ctrlupd_req_assert_seq   dfi_ctrlupd_req_assert_seq;
  svt_dfi_ctrlupd_req_deassert_seq dfi_ctrlupd_req_deassert_seq;

  dfi_ctrlupd_req_assert_seq   = svt_dfi_ctrlupd_req_assert_seq::type_id::create("dfi_ctrlupd_req_assert_seq");
  dfi_ctrlupd_req_deassert_seq = svt_dfi_ctrlupd_req_deassert_seq::type_id::create("dfi_ctrlupd_req_deassert_seq");

  @(posedge clk);
  dfi_ctrlupd_req_assert_seq.start(dfi_mc_agent.virt_seqr);
  fork
    begin
      while(ctrlupd_ack == 1'b0) begin
          des();
      end
      while(ctrlupd_ack == 1'b1)
      begin
          des();
      end
      dfi_ctrlupd_req_deassert_seq.start(dfi_mc_agent.virt_seqr);
      $display("[%0t] <%m> Update ctrlupd handshake success", $time);
    end

    begin
      repeat(t_ctrlupd_max) @(clk);
      @(posedge clk);
      dfi_ctrlupd_req_deassert_seq.start(dfi_mc_agent.virt_seqr);
      $display("[%0t] <%m> ctrlupd timeout error", $time); 
    end  
  join_any
  disable fork; 
end
endtask

task dfi0_phyupd;
begin
  svt_dfi_phyupd_ack_assert_seq  dfi_phyupd_ack_assert_seq;

  dfi_phyupd_ack_assert_seq  = svt_dfi_phyupd_ack_assert_seq::type_id::create("dfi_phyupd_ack_assert_seq");

  while(phyupd_req == 1'b0)
  begin
      des();
  end
  @(posedge clk);   
  dfi_phyupd_ack_assert_seq.start(dfi_mc_agent.virt_seqr);
  @(posedge clk); 
  $display("[%0t] <%m> Update phyupd handshake success", $time);  
end  
endtask

task dfi0_phymstr;
begin
  svt_dfi_phymstr_ack_assert_seq  dfi_phymstr_ack_assert_seq;

  dfi_phymstr_ack_assert_seq  = svt_dfi_phymstr_ack_assert_seq::type_id::create("dfi_phymstr_ack_assert_seq");

  @(posedge phymstr_req);  
  @(posedge clk);   
  dfi_phymstr_ack_assert_seq.start(dfi_mc_agent.virt_seqr);
  @(posedge clk); 
  $display("[%0t] <%m> PHY Master handshake success", $time); 
end  
endtask

task start_init;
  svt_dfi_init_wrapper_seq init_wrapper_seq;
  $display("[%0t] <%m> DFI start init.", $time);
  
  init_wrapper_seq = svt_dfi_init_wrapper_seq::type_id::create("init_wrapper_seq");
  update_cfg();   // when Pstate_num >1, before dfi_init, the pub Pstate=cfg.NumPStates - 1, so, we need update the related parameter in dfi_mc_cfg. 
  $display("[%0t] <%m> init_wrapper_seq start.", $time);
  init_wrapper_seq.freq = cfg.NumPStates-1;
  init_wrapper_seq.fsp = cfg.NumPStates-1;
  init_wrapper_seq.start(dfi_mc_agent.virt_seqr);

  //init_wrapper_seq = svt_dfi_init_wrapper_seq::type_id::create("init_wrapper_seq");
  //init_wrapper_seq.randomize with{init_wrapper_seq.freq == cfg.NumPStates - 1;};
  //init_wrapper_seq.start(dfi_mc_agent.virt_seqr);
endtask: start_init

task dram_clk_disable(bit enable);
  svt_dfi_dram_clk_disable_seq  clk_dis_seq;
  svt_dfi_dram_clk_enable_seq   clk_en_seq;
  clk_dis_seq = svt_dfi_dram_clk_disable_seq::type_id::create("clk_dis_seq");
  clk_en_seq  = svt_dfi_dram_clk_enable_seq::type_id::create("clk_en_seq");

  if (enable)
    clk_dis_seq.start(dfi_mc_agent.virt_seqr);
  else
    clk_en_seq.start(dfi_mc_agent.virt_seqr);
  
endtask

task freq_change(bit [4:0] next_freq);
  svt_dfi_init_freq_chng_seq freq_chng_seq;

  freq_chng_seq = svt_dfi_init_freq_chng_seq::type_id::create("freq_chng_seq");
 
  if((next_freq!=5'h1f) && (cfg.DfiFreqRatio[next_freq[1:0]]==2'b00))begin
    dfi_mc_cfg.freq_ratio= 3'b001;
  end
  else if ((next_freq!=5'h1f) && (cfg.DfiFreqRatio[next_freq[1:0]]==2'b01))begin
    dfi_mc_cfg.freq_ratio= 3'b010;
  end
  else if ((next_freq!=5'h1f) && (cfg.DfiFreqRatio[next_freq[1:0]]==2'b10))begin
    dfi_mc_cfg.freq_ratio= 3'b100;
  end
  else
    $finish;
  
  //Update frequency and frequency_set_point.     
  //dfi_mc_cfg.fsp_through_mrw_command = 1'b1; //configure hte fsp through mrw command
  if(next_freq!=5'h1f) cfg.PState = next_freq[1:0];
  dfi_mc_agent.mc_driver.reconfigure(dfi_mc_cfg);
  freq_chng_seq.dfi_freq = next_freq;
//`ifdef LP4_STD
  if(next_freq[1:0] == 2'b1) begin
    freq_chng_seq.dfi_fsp=2'b1;
  end else begin
    freq_chng_seq.dfi_fsp=2'b0;
  end
//`endif
  //freq_chng_seq.addr = 7'd13;
  freq_chng_seq.start(dfi_mc_agent.virt_seqr);
  $display("in freq_change: next_freq= %0b", next_freq);

//  if(next_freq!=5'h1f) cfg.PState = next_freq[1:0];
//  dfi_mc_agent.mc_driver.reconfigure(dfi_mc_cfg);
//  freq_chng_seq.randomize with{freq_chng_seq.dfi_freq == next_freq;};
//  freq_chng_seq.start(dfi_mc_agent.virt_seqr);
//  $display("in freq_change: next_freq= %0b", next_freq);

endtask

//------------------------------------------
task freq_change_LP3(bit [4:0] next_freq);
  svt_dfi_init_freq_chng_seq freq_chng_seq;

  freq_chng_seq = svt_dfi_init_freq_chng_seq::type_id::create("freq_chng_seq");
  $display("[%0t] <%m> start_dfi_frq_init complete = %b", $time,dfi_mc_if.dfi_init_complete);
  dfi_mc_agent.mc_driver.reconfigure(dfi_mc_cfg);
  freq_chng_seq.randomize with{freq_chng_seq.dfi_freq == next_freq;};
  freq_chng_seq.start(dfi_mc_agent.virt_seqr);
  $display("in freq_change: next_freq= %0b", next_freq);
  $display("[%0t] <%m> end dfi_frq_init complate = %b", $time,dfi_mc_if.dfi_init_complete);

endtask

`ifdef LP4_STD
task lpddr4_pde (bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr4_pde_seq pde_seq;

  pde_seq = svt_dfi_lpddr4_pde_seq::type_id::create("pdx_seq");
  pde_seq.cs = ~rank;
  pde_seq.start(dfi_mc_agent.virt_seqr);
endtask

task lpddr4_sre(bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr4_sre_seq              sre_seq;

  sre_seq = svt_dfi_lpddr4_sre_seq::type_id::create("sre_seq");
  sre_seq.randomize with{sre_seq.cs == ~rank;};
  sre_seq.start(dfi_mc_agent.virt_seqr);
endtask


task lpddr4_srx(bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr4_srx_seq              srx_seq;

  srx_seq = svt_dfi_lpddr4_srx_seq::type_id::create("srx_seq");
  srx_seq.randomize with{srx_seq.cs == ~rank;};
  srx_seq.start(dfi_mc_agent.virt_seqr);
endtask


task lpddr4_refa (bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr4_refresh_seq ref_seq;
  ref_seq = svt_dfi_lpddr4_refresh_seq::type_id::create("ref_seq");
  ref_seq.randomize with{ref_seq.cs == ~rank;};

  ref_seq.start(dfi_mc_agent.virt_seqr);

endtask

task lpddr4_pre(bit [pCS_WIDTH - 1:0] rank, bit[2:0] bank);
  svt_dfi_lpddr4_pre_seq pre_seq;
  pre_seq = svt_dfi_lpddr4_pre_seq::type_id::create("pre_seq");
  pre_seq.randomize with{pre_seq.cs == ~rank;
                         pre_seq.bank == bank;
                         pre_seq.lp4_ab == 1'b0;};

  pre_seq.start(dfi_mc_agent.virt_seqr);

endtask

task lpddr4_precharge_all(bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr4_pre_seq pre_seq;
  pre_seq = svt_dfi_lpddr4_pre_seq::type_id::create("pre_seq");
  pre_seq.randomize with{pre_seq.cs == ~rank;
                         pre_seq.lp4_ab == 1'b1;};

  pre_seq.start(dfi_mc_agent.virt_seqr);

endtask

task lpddr4_mrs(bit [pCS_WIDTH-1:0] rank,bit[6:0] addr, bit[7:0]op);
  svt_dfi_lpddr4_mrw_seq lp4_mrw;
  
  lp4_mrw = svt_dfi_lpddr4_mrw_seq::type_id::create("lp4_mrw");
  lp4_mrw.cs = ~rank;
  lp4_mrw.lpddr4_op = op;
  lp4_mrw.addr = addr;
  lp4_mrw.MRS_BL= dfi_mc_cfg.mrs_bl;
  lp4_mrw.start(dfi_mc_agent.virt_seqr);
endtask

task lpddr4_dev_init(bit freq_change, bit[1:0] PState);
 bit [1:0] pstate ;
 bit [2:0] rank   ;
 bit [15:0] mr13  ;

 if (freq_change) begin
   pstate=PState;
 end else begin
   pstate=cfg.PState;
 end
 rank='b1110;
for( int i=0;i< cfg.NumRank_dfi0;i++)begin
  lpddr4_mrs(rank,'h0d,cfg.MR13[pstate]); //mr13 for fsp_wr, fsp_op and vrcg
  beat_time(.Time(200_000), .pstate(cfg.PState));//tVRCG_ENABLE=200ns
  beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck

  lpddr4_mrs(rank,'h02,cfg.MR2[pstate]); //mr2
  if(cfg.Frequency[cfg.PState] < 1000) begin//tRPab=max(10ns 10nCK), cfg.PState updates during freq_change step.
    des(10);
  end else begin
    beat_time(.Time(10_000), .pstate(cfg.PState));
  end

  lpddr4_mrs(rank,'h01,cfg.MR1[pstate]); //mr1
  if(cfg.Frequency[cfg.PState] < 1000) begin//tRPab=max(10ns 10nCK), cfg.PState updates during freq_change step.
    des(10);
  end else begin
    beat_time(.Time(10_000), .pstate(cfg.PState));
  end

  lpddr4_mrs(rank,'h03,cfg.MR3[pstate]); //mr3
  max_time(10_000,10);//tRPab=max(10ns 10nCK), cfg.PState updates during freq_change step.

    mr13 = 16'b1011_0111 & cfg.MR13[pstate];//VRCG=0, fsp_wr=0.
    $display("Reset fsp_wr and VRCG, cfg.MR13[pstate] = %0b , mr13 = %0b .",cfg.MR13[pstate],mr13);
    lpddr4_mrs(rank,'hd,mr13); //mr13 for fsp_wr and fsp_op
    beat_time(.Time(150_000), .pstate(cfg.PState)); //tVRCG_ENABLE = 150 ns
    beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck

 rank = {rank[2:0],1'b1};
end
endtask

task lpddr4_des(bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr={`DWC_DDRPHY_DFI_ADDRESS_WIDTH{1'b0}});
  svt_dfi_lpddr4_des_seq dfi_des_s;
  dfi_des_s = svt_dfi_lpddr4_des_seq::type_id::create("des_seq");
  
  dfi_des_s.addr=Addr;
  
  dfi_des_s.start(dfi_mc_agent.virt_seqr);
  //$display("in lpddr4_des: Addr= %0h",dfi_des_s.addr);
endtask

task lpddr4_activate(bit [pCS_WIDTH - 1:0] rank, bit[2:0] my_ba, bit[16:0] my_row);
  svt_dfi_lpddr4_act_seq act_wrapper_seq;
  act_wrapper_seq = svt_dfi_lpddr4_act_seq::type_id::create("act_wrapper_seq");

  act_wrapper_seq.randomize with{act_wrapper_seq.addr == my_row;
                                 act_wrapper_seq.bank == my_ba;
                                 act_wrapper_seq.cs == ~rank;};
    
  act_wrapper_seq.start(dfi_mc_agent.virt_seqr);

endtask

task lpddr4_wrs16(bit [pCS_WIDTH-1 :0] rank, bit [2:0] my_ba, bit [9:0] my_col, reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[16],reg [`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_wrdata_mask_wrs16[16]);

  svt_dfi_lpddr4_wr_seq dfi_wr_s;
  dfi_wr_s = svt_dfi_lpddr4_wr_seq::type_id::create("wr_s");

  dfi_wr_s.randomize with {dfi_wr_s.bank == my_ba;
                           dfi_wr_s.cs == ~rank;
                           dfi_wr_s.addr == my_col;
                           dfi_wr_s.MRS_BL== dfi_mc_cfg.mrs_bl; //fixed BL 16
                           dfi_wr_s.lp4_otf_bl ==0;
                           foreach(dfi_wr_s.dfi_wrdata_mask[i]){dfi_wr_s.dfi_wrdata_mask[i] == dfi_wrdata_mask_wrs16[i]};
                           //foreach(dfi_wr_s.data[i]){dfi_wr_s.data[i] == DATA[i];}
                           foreach(dfi_wr_s.data[i]){dfi_wr_s.data[i] == Data[i];}
                           };
  foreach(dfi_wr_s.data[i]) $display("in lpddr4_wrs16:dfi_wr_s.data[i]=%0b", dfi_wr_s.data[i]);
  $display("in lpddr4_wrs16: ~rank= %0b, dfi_wr_s.cs = %0b, dfi_wr_s.addr=%0h", ~rank,dfi_wr_s.cs, dfi_wr_s.addr);
  dfi_wr_s.start(dfi_mc_agent.virt_seqr);
  $display("in lpddr4_wrs16: ~rank= %0b, dfi_wr_s.cs = %0b, dfi_wr_s.addr=%0h", ~rank,dfi_wr_s.cs, dfi_wr_s.addr);
  for (int i=0; i<16; i++) begin
    if((`EMUL_BUBBLE == 0) && (wr_data_id>=max_data_num_to_compare))  begin
      wr_data_id=0;
      $display("[%0t] <%m> Update wr_data_id=%0d. Because row number doesn't change when bubble is not enabled, and max data number is 512 in one row.", $time, wr_data_id);
    end
    DATA[wr_data_id] = Data[i];
    dfi_wrdata_mask_pN[wr_data_id] = dfi_wrdata_mask_wrs16[i];
    wr_data_id++;
    $display("passed in DATA[%0d]=%h dfi_wrdata_mask_pN[%0d]=%b , @ %0t",i,Data[i],i,dfi_wrdata_mask_pN[i], $time);
  end
endtask

task lpddr4_rds16(bit [pCS_WIDTH-1 :0] rank, bit [2:0] my_ba, bit [9:0] my_col, bit ap = 1);
  svt_dfi_lpddr4_rd_seq dfi_rd_s;
  dfi_rd_s = svt_dfi_lpddr4_rd_seq::type_id::create("rd_s");

  dfi_rd_s.bank       = my_ba;
  dfi_rd_s.cs         = ~rank;
  dfi_rd_s.addr       = my_col;
  dfi_rd_s.lp4_ap     = ap;
  dfi_rd_s.MRS_BL     = dfi_mc_cfg.mrs_bl; //fixed BL 16
  dfi_rd_s.lp4_otf_bl = 0;
  $display("in lpddr4_rds16: ~rank= %0b, dfi_rd_s.cs = %0b; my_col=%0h, dfi_rd_s.addr=%0h", ~rank, dfi_rd_s.cs, my_col,dfi_rd_s.addr);
    dfi_rd_s.start(dfi_mc_agent.virt_seqr);
  $display("in lpddr4_rds16: rank= %0b, dfi_rd_s.cs = %0b; my_col=%0h, dfi_rd_s.addr=%0h", rank, dfi_rd_s.cs, my_col,dfi_rd_s.addr);
endtask

task lpddr4_w2w (bit [pCS_WIDTH-1 :0] rank0, bit [2:0] my_ba0, bit [9:0] my_col0,bit [pCS_WIDTH-1 :0] rank1, bit [2:0] my_ba1, bit [9:0] my_col1,int Bubble, reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[16], reg[`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr_des[16]);
  svt_dfi_lpddr4_w2w_seq dfi_w2w_s;
  dfi_w2w_s = svt_dfi_lpddr4_w2w_seq::type_id::create("w2w_s");
  dfi_w2w_s.randomize with {dfi_w2w_s.bank0 == my_ba0;
                            dfi_w2w_s.bank1 == my_ba1;
                            dfi_w2w_s.cs_wr0 == ~rank0;
                            dfi_w2w_s.cs_wr1 == ~rank1;
                            dfi_w2w_s.addr_wr0 == my_col0;
                            dfi_w2w_s.addr_wr1 == my_col1;
                            foreach(dfi_w2w_s.addr_des[i]){dfi_w2w_s.addr_des[i] == Addr_des[i];}
                            dfi_w2w_s.MRS_BL== dfi_mc_cfg.mrs_bl; //fixed BL 16
                            dfi_w2w_s.lp4_otf_bl ==0;
                            foreach(dfi_w2w_s.data[i]){dfi_w2w_s.data[i] == Data[i];}
                            dfi_w2w_s.bubble == Bubble;
                            };
  dfi_w2w_s.start(dfi_mc_agent.virt_seqr);
  $display("in lpddr4_w2w: rank0= %0b, my_ba0=%0h, addr0=%0h,rank1= %0b, my_ba1=%0h, addr1=%0h, bubble=%d", rank0,my_ba0,my_col0,rank1,my_ba1,my_col1,Bubble);
  $display("in lpddr4_w2w: dfi_w2w_s.cs_wr[0]= %0b,dfi_w2w_s.bank[0] =%0h,dfi_w2w_s.addr_wr0=%h,dfi_w2w_s.cs_wr[1]= %0b,dfi_w2w_s.bank[1]=%0h,dfi_w2w_s.addr_wr1=%h", dfi_w2w_s.cs_wr0,dfi_w2w_s.bank0,dfi_w2w_s.addr_wr0,dfi_w2w_s.cs_wr1,dfi_w2w_s.bank1,dfi_w2w_s.addr_wr1);
endtask 

task lpddr4_wr_b2b (bit [3:0] rank[4], bit [2:0] my_ba[8], bit [9:0] my_col[4],int b2b_num,bit [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[16],bit [`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_wrdata_mask_wr_b2b[16],bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr_des[16],int bubble);
  for(int i=0; i<b2b_num; i++)begin
    lpddr4_wrs16(rank[i%4],my_ba[i%4],my_col[i%4],Data,dfi_wrdata_mask_wr_b2b);
    if(i!=b2b_num)begin
    for(int j=0; j<bubble; j++)begin
      //lpddr4_des(Addr_des[(i*bubble+j)%16]);
      lpddr4_des(Addr_des[(i*bubble+j)%4]);
    end
    end
  end
endtask 

task lpddr4_rd_b2b (bit [3:0] rank[4], bit [2:0] my_ba[8], bit [9:0] my_col[4],int b2b_num,bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr_des[16],int bubble);
  for(int i=0; i<b2b_num; i++)begin
    lpddr4_rds16(rank[i%4],my_ba[i%4],my_col[i%4],0);
    if(i!=b2b_num)begin
    for(int j=0; j<bubble; j++)begin
      //lpddr4_des(Addr_des[(i*bubble+j)%16]);
      lpddr4_des(Addr_des[(i*bubble+j)%4]);
    end
    end
  end
endtask 

`endif  //LP4_STD

task dfi_lp(int lp_mode = 4, bit assert_en = 0, bit [3:0] dfi_lp_wakeup= 4'b0);

int freq_ratio;
`ifdef LP4_STD
  svt_dfi_lpddr4_lp_assert_seq  dfi_lp_assert_seq;
  dfi_lp_assert_seq = svt_dfi_lpddr4_lp_assert_seq::type_id::create("dfi_lp_assert_seq");
`endif  //LP4_STD

`ifdef LP5_STD
  svt_dfi_lpddr5_lp_assert_seq  dfi_lp_assert_seq;
  dfi_lp_assert_seq = svt_dfi_lpddr5_lp_assert_seq::type_id::create("dfi_lp_assert_seq");
`endif  //LP5_STD

  if(cfg.DfiFreqRatio[0] == 2) begin
    freq_ratio = 4;
  end else begin
    freq_ratio = cfg.DfiFreqRatio[0] + 1;
  end

  //dfi_lp_assert_seq.randomize();
  dfi_lp_assert_seq.freq_ratio = freq_ratio;
  dfi_lp_assert_seq.lp_mode = lp_mode;
  dfi_lp_assert_seq.assert_en = assert_en;
  //dfi_lp_assert_seq.dfi_lp_wakeup = dfi_lp_wakeup;
  //dfi_lp_assert_seq.dfi_dram_clk_dis = 4'b0;

  dfi_lp_assert_seq.start(dfi_mc_agent.virt_seqr);
endtask

task pdx(bit [pCS_WIDTH - 1:0] rank);
  `ifdef LP5_STD
    svt_dfi_lpddr5_pdx_seq pdx_seq;
    pdx_seq = svt_dfi_lpddr5_pdx_seq::type_id::create("pdx_seq");
  `else
    svt_dfi_lpddr4_pdx_seq pdx_seq;
    pdx_seq = svt_dfi_lpddr4_pdx_seq::type_id::create("pdx_seq");
  `endif

  pdx_seq.cs = ~rank;
  pdx_seq.start(dfi_mc_agent.virt_seqr);
endtask

task dfi_refresh (int ab, bit [pCS_WIDTH - 1:0] rank, bit[3:0] my_ba, bit[1:0] my_bg);
`ifdef LP5_STD
  svt_dfi_lpddr5_refresh_seq ref_seq;
  ref_seq = svt_dfi_lpddr5_refresh_seq::type_id::create("ref_seq");
  ref_seq.lp5_ab = ab;
`else
  svt_dfi_lpddr4_refresh_seq ref_seq;
  ref_seq = svt_dfi_lpddr4_refresh_seq::type_id::create("ref_seq");
  ref_seq.lp4_ab = ab;
`endif
  ref_seq.cs = ~rank;
  ref_seq.bank = my_ba;
  ref_seq.bg = my_bg;
  ref_seq.start(dfi_mc_agent.virt_seqr);
endtask

`ifdef LP5_STD
task lpddr5_mrs(bit [pCS_WIDTH-1:0] rank,bit[6:0] addr, bit[7:0]op);
  svt_dfi_lpddr5_mrw_seq lp5_mrw;
  
  lp5_mrw = svt_dfi_lpddr5_mrw_seq::type_id::create("lp5_mrw");
  lp5_mrw.cs = ~rank;
  lp5_mrw.lpddr5_op = op;
  lp5_mrw.addr = addr;
  lp5_mrw.start(dfi_mc_agent.virt_seqr);
endtask

`ifdef DDRPHY_POWERSIM
task lpddr5_des(bit [(`DWC_DDRPHY_DFI_ADDRESS_WIDTH*2-1):0] Addr={(`DWC_DDRPHY_DFI_ADDRESS_WIDTH*2){1'b0}});
`else
task lpddr5_des(bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr={`DWC_DDRPHY_DFI_ADDRESS_WIDTH{1'b0}});
`endif
svt_dfi_lpddr5_des_seq lp5_des;

  lp5_des = svt_dfi_lpddr5_des_seq::type_id::create("lp5_des");
  lp5_des.addr = Addr;
  lp5_des.start(dfi_mc_agent.virt_seqr);
endtask

task lpddr5_dev_init(bit freq_change, bit[1:0] PState);
 bit [1:0] pstate;
 bit [2:0] rank;
 bit [15:0] mr16;

 if (freq_change) begin
   pstate=PState;
 end
 else begin
   pstate=cfg.PState;
 end
 rank='b1110;
for( int i=0;i< cfg.NumRank_dfi0;i++)begin
  lpddr5_mrs(rank,'h10,cfg.MR16[pstate]); //mr16 for fsp_wr and fsp_op
  beat_time(.Time(150_000), .pstate(cfg.PState)); //tVRCG_ENABLE = 150 ns
  beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck

  lpddr5_mrs(rank,'h3,cfg.MR3[pstate]);
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  lpddr5_mrs(rank,'h14,cfg.MR20[pstate]);          //mr20
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  lpddr5_mrs(rank,'h13,cfg.MR19[pstate]);       //mr19
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  //if(cfg.DfiFreqRatio[pstate]==2'b10)
  lpddr5_mrs(rank,'h12,cfg.MR18[pstate]);         //mr18
  //else
  //lpddr5_mrs(rank,'h12,'h96);
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  lpddr5_mrs(rank,'h2,cfg.MR2[pstate]);
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  lpddr5_mrs(rank,'h1,cfg.MR1[pstate]);
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  lpddr5_mrs(rank,'h0a,cfg.MR10[pstate]);
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  lpddr5_mrs(rank,'h16,cfg.MR22[pstate]);   //mr22
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end
  lpddr5_mrs(rank,'h0d,cfg.MR13[pstate]);
  for(int i=0; i<50;i++)begin
  lpddr5_des();
  end

    mr16 = 16'b10111100 &cfg.MR16[pstate];//VRCG=0, fsp_wr=0.
    lpddr5_mrs(rank,'h10,mr16); //mr16 for fsp_wr and fsp_op
    beat_time(.Time(150_000), .pstate(cfg.PState)); //tVRCG_ENABLE = 150 ns
    beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck

  rank = {rank[2:0],1'b1};
end
endtask

task lpddr5_refa (bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr5_refall_seq ref_seq;
  ref_seq = svt_dfi_lpddr5_refall_seq::type_id::create("ref_seq");
  ref_seq.randomize with{ref_seq.cs == ~rank;};

  ref_seq.start(dfi_mc_agent.virt_seqr);

endtask

task lpddr5_sre (bit [pCS_WIDTH - 1:0] rank,int pd, int dsm); //SRE + PDE option
  svt_dfi_lpddr5_sre_seq lp5_sre;
  lp5_sre = svt_dfi_lpddr5_sre_seq::type_id::create("lp5_sre");
  lp5_sre.cs = ~rank;
  lp5_sre.lp5_pd = pd;  
  lp5_sre.lp5_dsm = dsm;  
  lp5_sre.start(dfi_mc_agent.virt_seqr);
endtask 

task lpddr5_srx (bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr5_srx_seq lp5_srx;
  lp5_srx = svt_dfi_lpddr5_srx_seq::type_id::create("lp5_srx");
  lp5_srx.cs = ~rank;
  lp5_srx.start(dfi_mc_agent.virt_seqr);
endtask

task lpddr5_pde (bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr5_pde_seq lp5_pde;
  lp5_pde = svt_dfi_lpddr5_pde_seq::type_id::create("lp5_pde");
  lp5_pde.cs = ~rank;
  lp5_pde.start(dfi_mc_agent.virt_seqr);
endtask 

task lpddr5_pre(bit [pCS_WIDTH - 1:0] rank, bit[2:0] bank);
  svt_dfi_lpddr5_pre_seq lp5_pre;
  lp5_pre = svt_dfi_lpddr5_pre_seq::type_id::create("lp5_pre");
  lp5_pre.cs = ~rank;
  lp5_pre.lp5_ab = 1'b0;
  lp5_pre.bank = bank ;
  lp5_pre.start(dfi_mc_agent.virt_seqr);

endtask

task lpddr5_precharge_all(bit [pCS_WIDTH - 1:0] rank);
  svt_dfi_lpddr5_pre_seq lp5_prea;
  lp5_prea = svt_dfi_lpddr5_pre_seq::type_id::create("lp5_prea");
  lp5_prea.cs = ~rank;
  lp5_prea.lp5_ab = 1'b1;
  $display("in lpddr5_precharge_all: rank0= %0b", ~rank);
  lp5_prea.start(dfi_mc_agent.virt_seqr);
endtask

task check_datamask_for_pstate(bit [pCS_WIDTH-1 :0] rank);
  case(cfg.PState)
    0: 
       `ifdef WRITE_DM0
         lpddr5_mrs(rank,'h0d,cfg.MR13[cfg.PState]);
       `else ;
       `endif
    1: 
       `ifdef WRITE_DM1
         lpddr5_mrs(rank,'h0d,cfg.MR13[cfg.PState]);
       `else ;
       `endif
    2: 
       `ifdef WRITE_DM2
         lpddr5_mrs(rank,'h0d,cfg.MR13[cfg.PState]);
       `else ;
       `endif
    3: 
       `ifdef WRITE_DM3
         lpddr5_mrs(rank,'h0d,cfg.MR13[cfg.PState]);
       `else ;
       `endif
    default:
      ;
  endcase

  for(int i=0; i<50;i++)begin
   lpddr5_des();
  end  

endtask

task lpddr5_activate (bit [pCS_WIDTH - 1:0] rank, bit[3:0] my_ba, bit[1:0] my_bg, bit[17:0] my_row);
  svt_dfi_lpddr5_act_seq  lp5_act;
  lp5_act = svt_dfi_lpddr5_act_seq::type_id::create("lp5_act");
  lp5_act.bg = my_bg;
  lp5_act.bank = my_ba;
  lp5_act.addr = my_row;
  lp5_act.cs = ~rank;
  lp5_act.start(dfi_mc_agent.virt_seqr);
endtask

task lpddr5_cas (bit [pCS_WIDTH-1 :0] rank, bit [2:0] sync_type = 3'h0);
  svt_dfi_lpddr5_cas_seq lp5_cas;
  lp5_cas = svt_dfi_lpddr5_cas_seq::type_id::create("lp5_cas");
  lp5_cas.cs = ~rank;
  lp5_cas.sync_type = sync_type;
  $display("DFI send CAS command , lp5_cas.sync_type=%0b",lp5_cas.sync_type);
  lp5_cas.start(dfi_mc_agent.virt_seqr);
endtask

task lpddr5_wrs(bit [pCS_WIDTH-1 :0] rank, bit [1:0] my_bg,bit [3:0] my_ba, bit [5:0] my_col,reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[32],reg [`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_wrdata_mask_wrs[32]);
  svt_dfi_lpddr5_wr_seq lp5_wr;
  lp5_wr = svt_dfi_lpddr5_wr_seq::type_id::create("lp5_wr");
  lp5_wr.cs = ~rank;
  lp5_wr.bank = my_ba;
  lp5_wr.bg = my_bg;
  lp5_wr.addr =  my_col;
  lp5_wr.bl = 32;
  for(int i=0; i<32; i++)begin
    lp5_wr.data[i] = Data[i];
    lp5_wr.dfi_wrdata_mask[i] = dfi_wrdata_mask_wrs[i];
  end
$display("in lp5_wrs: rank= %0b, dfi_wr_s.cs = %0b, dfi_wr_s.bg=%0h, dfi_wr_s.ba=%0h, dfi_wr_s.col=%b, dfi_max_address_width=%0h", rank,lp5_wr.cs,lp5_wr.bg, lp5_wr.bank,lp5_wr.addr,`DFI_MAX_ADDRESS_WIDTH);
  lp5_wr.start(dfi_mc_agent.virt_seqr);
  for (int i=0; i<32; i++) begin
    if((`EMUL_BUBBLE == 0) && (wr_data_id>=max_data_num_to_compare))  begin
      wr_data_id=0;
      $display("[%0t] <%m> Update wr_data_id=%0d. Because row number doesn't change when bubble is not enabled, and max data number is 512 in one row.", $time, wr_data_id);
    end
    DATA[wr_data_id] = Data[i];
    dfi_wrdata_mask_pN[wr_data_id] = dfi_wrdata_mask_wrs[i];    
    wr_data_id++;
    $display("passed in DATA[%0d]=%b dfi_wrdata_mask_pN[%0d]=%b, @ %0t",i,DATA[i],i,dfi_wrdata_mask_pN[i], $time);
  end
endtask

task lpddr5_rds(bit [pCS_WIDTH-1 :0] rank, bit [1:0] my_bg,bit [3:0] my_ba, bit [5:0] my_col, bit ap = 1);
  svt_dfi_lpddr5_rd_seq lp5_rd;
  lp5_rd = svt_dfi_lpddr5_rd_seq::type_id::create("lp5_rd");
  lp5_rd.cs = ~rank;
  lp5_rd.bank = my_ba;
  lp5_rd.bg = my_bg;
  lp5_rd.addr =  my_col;
  lp5_rd.bl = 32;
  lp5_rd.lp5_ap = ap;
$display("in lp5_rds: rank= %0b, dfi_rd_s.cs = %0b, dfi_rd_s.bg=%0h, dfi_rd_s.ba=%0h, dfi_rd_s.col=%0h", rank,lp5_rd.cs,lp5_rd.bg, lp5_rd.bank,lp5_rd.addr);
  lp5_rd.start(dfi_mc_agent.virt_seqr);
endtask

task lpddr5_wr_b2b (bit [3:0] rank[4], bit[2:0] my_bg[4], bit [2:0] my_ba[8], bit [9:0] my_col[4],int b2b_num,bit [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[32],bit [`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_wrdata_mask_wr_b2b[32],bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr_des[16],int bubble);
  for(int i=0; i<b2b_num; i++)begin
    lpddr5_wrs(rank[i%4],my_bg[i%4],my_ba[i%4],my_col[i%4][5:0],Data,dfi_wrdata_mask_wr_b2b);
    for(int j=0; j<bubble; j++)begin
      lpddr5_des({Addr_des[j*2+1],Addr_des[j*2]}); //lpddr5 sample at CK rise and fall
    end
  end
endtask 

task lpddr5_rd_b2b (bit [3:0] rank[4], bit[2:0] my_bg[4], bit [2:0] my_ba[8], bit [9:0] my_col[4],int b2b_num,bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr_des[16],int bubble);
  for(int i=0; i<b2b_num; i++)begin
    lpddr5_rds(rank[i%4],my_bg[i%4],my_ba[i%4],my_col[i%4][5:0],0);
    for(int j=0; j<bubble; j++)begin
      lpddr5_des({Addr_des[j*2+1],Addr_des[j*2]}); //lpddr5 sample at CK rise and fall
    end
  end
endtask
`endif  //LP5_STD

//-------------------this function is used to translate dfi_wrdata_mask into DM_W,or translate dfi_rddata_dbi_wN into DM_M
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
function reg [8*`DWC_DDRPHY_NUM_DBYTES/2-1:0] DM_DBI_trans(reg [`DWC_DDRPHY_NUM_DBYTES/2-1:0] rddata_dm_wP);
  for(int i=0;i<`DWC_DDRPHY_NUM_DBYTES/2;i++)
`else
function reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] DM_DBI_trans(reg [`DWC_DDRPHY_NUM_DBYTES-1:0] rddata_dm_wP);
  for(int i=0;i<`DWC_DDRPHY_NUM_DBYTES;i++)
`endif
    for(int j=0;j<8;j++)
      DM_DBI_trans[i*8+j] = (~rddata_dm_wP[i]);
endfunction
//--------------------this function is used to diplay check information
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
function data_in_check_data_out(bit chec,int i,bit display_dbi,reg [8*`DWC_DDRPHY_NUM_DBYTES/2-1:0]rddata,reg [8*`DWC_DDRPHY_NUM_DBYTES/2-1:0]DATA,reg[`DWC_DDRPHY_NUM_DBYTES/2-1:0] dfi_wrdata_mask,reg[`DWC_DDRPHY_NUM_DBYTES/2-1:0] dfi_rddata_dbi );
`else
function data_in_check_data_out(bit chec,int i,bit display_dbi,reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0]rddata,reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0]DATA,reg[`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_wrdata_mask,reg[`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_rddata_dbi );
`endif
case(display_dbi)
  1'b1:
    if(chec)
     begin $display("Wrong rddata[%0d]=%h, DATA[%0d]=%h, dfi_wrdata_mask[%0d]=%b, dfi_rddata_dbi[%0d]=%b, @ %0t",i,rddata,i,DATA,i,dfi_wrdata_mask,i,dfi_rddata_dbi ,$time); compare_error = 1;end
    else  begin
     $display("Right rddata[%0d]=%h, DATA[%0d]=%h, @ %0t",i,rddata,i,DATA ,$time);
    end

  default:
    if(chec)
     begin $display("Wrong rddata[%0d]=%h, DATA[%0d]=%h, default@ %0t",i,rddata,i,DATA ,$time); compare_error = 1;end
    else begin
     $display("Right rddata[%0d]=%h, DATA[%0d]=%h, default@ %0t",i,rddata,i,DATA ,$time);
     //`ifdef DWC_DDRPHY_HWEMUL
     //     compare_error = 0;
     //`endif 
    end
endcase
endfunction

task sample_rddata();
int flag = 0;
int index = 0;
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
reg [8*`DWC_DDRPHY_NUM_DBYTES/2-1:0] rddata[17000:0];
reg [8*`DWC_DDRPHY_NUM_DBYTES/2-1:0] DATA_compare[17000:0];
reg [8*`DWC_DDRPHY_NUM_DBYTES/2-1:0] DM_R[17000:0],DM_W[17000:0];
reg [`DWC_DDRPHY_NUM_DBYTES/2-1:0] dfi_rddata_dbi_wN[17000:0];
`else
reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] rddata[17000:0];
reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] DATA_compare[17000:0];
reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] DM_R[17000:0],DM_W[17000:0];
reg [`DWC_DDRPHY_NUM_DBYTES-1:0] dfi_rddata_dbi_wN[17000:0];
`endif

forever begin
  @(posedge clk);
  if(dfi_rddata_valid_W0) begin
    {rddata[index + 1],rddata[index]} = dfi_rddata_W0;
    {dfi_rddata_dbi_wN[index + 1],dfi_rddata_dbi_wN[index]} = dfi_rddata_dbi_W0;
    index = index + 2;
    flag = 1;
  end else begin
    `ifdef DATA_CMPR_DIS
       disable_data_compare = 1;
    `elsif DDRPHY_B2B
       disable_data_compare = 1;
    `endif
    if (flag == 1 && (!disable_data_compare)) begin
//        $display("debug : {W_DM,W_DBI,R_DBI}=%h",{W_DM,W_DBI,R_DBI});
        for(int i=0;i< index;i++)
          begin
            DATA_compare[i] = DATA[data_cmp_id%max_data_num_to_compare];
            DM_W[i] = DM_DBI_trans(dfi_wrdata_mask_pN[data_cmp_id]);
            DM_R[i] = DM_DBI_trans(dfi_rddata_dbi_wN[i]);
          case({W_DM,W_DBI,R_DBI})
            3'b100:
               if (rddata[i] !== (DATA_compare[i] & DM_W[i]))
                   data_in_check_data_out(1'b1,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
               else
                   data_in_check_data_out(1'b0,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
            3'b010:
                if (rddata[i] !== (DATA_compare[i] ~^ DM_W[i]))
                   data_in_check_data_out(1'b1,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
                else
                   data_in_check_data_out(1'b0,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
            3'b001:
                if ((rddata[i] ~^ DM_R[i]) !== DATA_compare[i])
                    data_in_check_data_out(1'b1,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
                else
                    data_in_check_data_out(1'b0,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
            3'b011:
                if ((rddata[i] ~^ DM_R[i]) !== (DATA_compare[i] ~^ DM_W[i]))
                    data_in_check_data_out(1'b1,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
                else
                    data_in_check_data_out(1'b0,i,1'b1,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
            default:
                if (rddata[i] !== DATA_compare[i])
                    data_in_check_data_out(1'b1,i,1'b0,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
                else
                    data_in_check_data_out(1'b0,i,1'b0,rddata[i],DATA_compare[i],dfi_wrdata_mask_pN[i],dfi_rddata_dbi_wN[i]);
          endcase
          data_cmp_id++;
        end
      flag = 0;
      index = 0;
    end
  end
  if(cfg.DfiFreqRatio[cfg.PState] > 0) begin
    if (dfi_rddata_valid_W1) begin
      {rddata[index + 1],rddata[index]} = dfi_rddata_W1;
      {dfi_rddata_dbi_wN[index + 1],dfi_rddata_dbi_wN[index]} = dfi_rddata_dbi_W1;
      index = index + 2;
    end
    if(cfg.DfiFreqRatio[cfg.PState] > 1) begin
      if(dfi_rddata_valid_W2) begin
        {rddata[index + 1],rddata[index]} = dfi_rddata_W2;
        {dfi_rddata_dbi_wN[index + 1],dfi_rddata_dbi_wN[index]} = dfi_rddata_dbi_W2;
        index = index + 2;
        {rddata[index + 1],rddata[index]} = dfi_rddata_W3;
        {dfi_rddata_dbi_wN[index + 1],dfi_rddata_dbi_wN[index]} = dfi_rddata_dbi_W3;
        index = index + 2;
      end   
    end
  end
end  

endtask : sample_rddata

endmodule

