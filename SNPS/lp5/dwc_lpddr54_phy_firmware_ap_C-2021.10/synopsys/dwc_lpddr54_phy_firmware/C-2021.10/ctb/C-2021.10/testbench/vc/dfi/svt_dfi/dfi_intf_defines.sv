  // Defines for DFI MC
`define DFI_MAX_ADDRESS_WIDTH 20
`define DFI_MAX_BANK_ADDRESS_WIDTH 4
`define DFI_MAX_BANK_GROUP_WIDTH 3
`define DFI_MAX_CHIP_ID_WDITH 4
`define DFI_MAX_CS_WIDTH 8
`define DFI_MAX_DEST_WIDTH 3
`define DFI_MAX_NUM_DBYTE 10
`define DFI_MAX_PHY_UPDATE_WIDTH 2
`define DFI_MAX_FREQ_RATIO_WIDTH 2
`define DFI_FREQUENCY_WIDTH 5
`ifdef LPDDR5
`define DFI_MAX_BL 32
`else
`define DFI_MAX_BL 16
`endif
`define DFI_MAX_TIMING_GROUP 4
`define DFI_MAX_LP_WAKEUP_WIDTH 4
`define DFI_MAX_FREQ_WIDTH 5
`define DFI_MAX_FREQ_RATIO 4 
`define DFI_NUM_DATA_UI_PER_PHASE 2
`define DFI_MAX_PARITY_WIDTH 2
`define DFI_MAX_RDDATA_AUX_WIDTH 4
`define DFI_MAX_RSP_LANES 4
`define DFI_MAX_RESP_WIDTH 4

`define LP4_ACT1(dfi_cs_n,dfi_address,tr,tr_prev)\
tr.set_cmd_act1();\
tr.addr[15:0] = 'h0;\
tr.addr[15:12] = dfi_address[5:2];\
tr.cs = dfi_cs_n[1:0];\
$cast (tr_prev, tr.clone());
//`uvm_info(get_type_name(),$psprintf("Got an Activate command ACT1: dfi_address[5:0] is %0x tr_prev.addr = %0x and tr.addr = %0x ",dfi_address[5:0],tr_prev.addr,tr.addr),UVM_DEBUG)

`define LP4_ACT2(dfi_cs_n,dfi_address,tr,tr_prev)\
tr.set_cmd_act2();\
tr.addr[15:0] = 'h0;\
tr.addr[15:6] = {tr_prev.addr[15:10],dfi_address[5:2]};\
tr.cs = dfi_cs_n[1:0];\
tr.bank[2:0] = tr_prev.bank[2:0];\
if(tr.cs !== tr_prev.cs && cfg.DFI_ASSERT_EN )\
//`svt_error(get_type_name(), $psprintf("ACT2 chip select not matching ACT1 chip select"))\
`uvm_error(get_type_name(), $psprintf("ACT2 chip select not matching ACT1 chip select"))\
$cast (tr_prev, tr.clone());
//`svt_trace(get_type_name(),$psprintf("Got an Activate command ACT2: dfi_address[5:0] is %0x tr_prev.addr = %0x and tr.addr: %0x prev_cmd is %s",dfi_address[5:0],tr_prev.addr, tr.addr, tr_prev.cmd_e))
//`uvm_info(get_type_name(),$psprintf("Got an Activate command ACT2: dfi_address[5:0] is %0x tr_prev.addr = %0x and tr.addr = %0x prev_cmd is %s ",dfi_address[5:0],tr_prev.addr,tr.addr,tr_prev.cmd_e),UVM_DEBUG)

`define LP4_WR1(dfi_cs_n,dfi_address,tr,tr_prev)\
tr.set_cmd_write1();\
tr.addr = 'h0;\
if(cfg.mrs_bl == 0)\
tr.bl = 16;\
if(cfg.mrs_bl == 1)\
tr.bl = 32;\
if(cfg.mrs_bl == 2)\
tr.bl = dfi_address[5] ? 32 : 16;\
tr.cs = dfi_cs_n[1:0];\
tr.dat_cs = 0;\
$cast (tr_prev, tr.clone());

`define LP4_MWR1(dfi_cs_n,dfi_address,tr,tr_prev)\
tr.set_cmd_mask_write1();\
tr.addr = 'h0;\
if(cfg.mrs_bl == 0)\
tr.bl = 16;\
if(cfg.mrs_bl == 1)\
tr.bl = 32;\
if(cfg.mrs_bl == 2)\
tr.bl = dfi_address[5] ? 32 : 16;\
tr.cs = dfi_cs_n[1:0];\
tr.dat_cs = 0;\
$cast (tr_prev, tr.clone());

`define LP4_RD1(dfi_cs_n,dfi_address,tr,tr_prev)\
tr.set_cmd_read1();\
tr.addr = 'h0;\
if(cfg.mrs_bl == 0)\
tr.bl = 16;\
if(cfg.mrs_bl == 1)\
tr.bl = 32;\
if(cfg.mrs_bl == 2)\
tr.bl = dfi_address[5] ? 32 : 16;\
tr.cs = dfi_cs_n[1:0];\
tr.dat_cs = 0;\
$cast (tr_prev, tr.clone());

`define LP4_CAS2(dfi_cs_n,dfi_address,tr,tr_prev)\
tr.cs = dfi_cs_n[1:0];\
if(tr.cs !== tr_prev.cs && cfg.DFI_ASSERT_EN )\
//`svt_error(get_type_name(), $psprintf("CAS2 chip select not matching previous chip select"))\
`uvm_error(get_type_name(), $psprintf("CAS2 chip select not matching previous chip select"))\
tr.set_cmd_cas2();\
if(tr_prev.cmd_e == dfi_intf_tr::WR1) \
tr.cas2_cmd_e = dfi_intf_tr::WR2;\
if(tr_prev.cmd_e == dfi_intf_tr::MWR1) \
tr.cas2_cmd_e = dfi_intf_tr::MWR2;\
if(tr_prev.cmd_e == dfi_intf_tr::RD1) \
tr.cas2_cmd_e = dfi_intf_tr::RD2;\
tr.bl = tr_prev.bl;\
tr.bank = tr_prev.bank;\
tr.addr = tr_prev.addr;\
tr.addr[8] = dfi_address[5];\
tr.dat_cs = 0;\
$cast (tr_prev, tr.clone());


`define lp4_cmd2(tr_prev,tr,dfi_cs_n,dfi_address)\
if(tr_prev.cmd_e == dfi_intf_tr::CAS2) begin \
  tr.bl = tr_prev.bl; \
  tr.bank = tr_prev.bank; \
  tr.addr = tr_prev.addr; \
  tr.addr[7:2] = dfi_address[5:0]; \
  tr.set_cmd_cas2();       \
  tr.cas2_cmd_e = tr_prev.cas2_cmd_e; \
  tr.cs = 0; \
  tr.dat_cs = tr_prev.cs; \
  tr_prev.cmd_e = dfi_intf_tr::RFU; \
end \
if(tr_prev.cmd_e == dfi_intf_tr::WR1) begin \
  tr.set_cmd_write1(); \
  tr.addr = 'h0; \
  tr.bl = tr_prev.bl; \
  tr.cs = tr_prev.cs; \
  tr.bank = dfi_address[2:0]; \
  tr.addr[9] = dfi_address[4]; \
  tr.dat_cs = 0; \
  $cast (tr_prev, tr.clone()); \
end \
if(tr_prev.cmd_e == dfi_intf_tr::MWR1) begin \
  tr.set_cmd_mask_write1(); \
  tr.addr = 'h0; \
  tr.bl = tr_prev.bl; \
  tr.cs = tr_prev.cs; \
  tr.bank = dfi_address[2:0]; \
  tr.addr[9] = dfi_address[4]; \
  tr.dat_cs = 0; \
  $cast (tr_prev, tr.clone()); \
end \
if(tr_prev.cmd_e == dfi_intf_tr::RD1) begin \
  tr.set_cmd_read1(); \
  tr.addr = 'h0; \
  tr.bl = tr_prev.bl; \
  tr.cs = tr_prev.cs; \
  tr.bank = dfi_address[2:0]; \
  tr.addr[9] = dfi_address[4]; \
  tr.dat_cs = 0; \
  $cast (tr_prev, tr.clone()); \
end       \
if(tr_prev.cmd_e == dfi_intf_tr::ACT1) begin \
  tr.set_cmd_act1(); \
  tr.addr[15:0] = 'h0; \
  tr.addr[15:10] = {tr_prev.addr[15:12],dfi_address[5:4]}; \
  tr.bank[2:0]   = dfi_address[2:0]; \
  tr.cs = tr_prev.cs; \
  //uvm_info(get_type_name(),$psprintf("Got second command for ACT1: dfi_address[5:0] is %0x  tr_prev.addr = %0x and tr.addr = %0x prev_cmd is %s",dfi_address[5:0],tr_prev.addr,tr.addr,tr_prev.cmd_e),UVM_DEBUG) \
  $cast (tr_prev, tr.clone()); \
end \
if(tr_prev.cmd_e == dfi_intf_tr::ACT2) begin \
  tr.set_cmd_act2(); \
  tr.addr[15:0] = 'h0; \
  tr.addr[15:0] = {tr_prev.addr[15:6],dfi_address[5:0]}; \
  tr.bank[2:0]   = tr_prev.bank[2:0]; \
  tr.cs = tr_prev.cs; \
  //`svt_trace(get_type_name(),$psprintf("Got second command for ACT2: dfi_address[5:0] is %0x tr_prev.addr = %0x and tr.addr: %0x prev_cmd is %s",dfi_address[5:0],tr_prev.addr, tr.addr, tr_prev.cmd_e))\
  //`uvm_info(get_type_name(),$psprintf("Got second command for ACT2:  dfi_address[5:0] is %0x tr_prev.addr = %0x and tr.addr = %0x prev_cmd is %s ",dfi_address[5:0],tr_prev.addr,tr.addr,tr_prev.cmd_e),UVM_DEBUG) \
  row_addr = tr.addr; \
  row_addr[`DFI_MAX_ADDRESS_WIDTH] = 1; \
  open_row_array[tr.dest][0][tr.bank] = row_addr; \
  tr_prev.cmd_e = dfi_intf_tr::RFU; \
  //`uvm_info(get_type_name(),$psprintf("Got an Activate command for row: %0x",row_addr),UVM_DEBUG) \
end


`define D5_ACT(dfi_cs_n,dfi_address,tr,tr_prev_d5) \
tr.set_cmd_act(); \
tr.addr[18:0] = 0; \
tr.addr[16:12] = dfi_address[5:1]; \
tr.cs = dfi_cs_n[3:0]; \
tr.cid[2:0] = dfi_address[13:11]; \
tr.bl = 0; \
tr.bank = dfi_address[7:6]; \
tr.bg = dfi_address[10:8]; \
tr.d5_cmd_cyc_e = dfi_intf_tr::FIRST_CYCLE; \
$cast (tr_prev_d5, tr.clone()); 
//`svt_trace(get_type_name(),$psprintf("Got an Activate command ACT: dfi_address[13:0] is %0x tr_prev.addr = %0x and tr.addr: %0x",dfi_address[13:0],tr_prev_d5.addr, tr.addr))
//`uvm_info(get_type_name(),$psprintf("Got an Activate command ACT: dfi_address[13:0] is %0x tr_prev_d5.addr = %0x and tr.addr = %0x ",dfi_address[13:0],tr_prev_d5.addr,tr.addr),UVM_DEBUG) 

`define D5_WR(dfi_cs_n,dfi_address,tr,tr_prev_d5)\
tr.set_cmd_write();\
tr.addr[18:0] = 0;\
tr.cs = dfi_cs_n[3:0];\
tr.cid[2:0] = dfi_address[13:11];\
tr.bl = cfg.d5_wr_crc_en ? 18 : 16;\
tr.bank = dfi_address[7:6];\
tr.bg = dfi_address[10:8];\
tr.d5_cmd_cyc_e = dfi_intf_tr::FIRST_CYCLE; \
$cast (tr_prev_d5, tr.clone());
//`svt_trace(get_type_name(),$psprintf("Got a Write command WR: dfi_address[13:0] is %0x tr_prev.addr = %0x and tr.addr: %0x",dfi_address[13:0],tr_prev_d5.addr, tr.addr))
//`uvm_info(get_type_name(),$psprintf("Got a Write command WR: dfi_address[13:0] is %0x tr_prev_d5.addr = %0x and tr.addr = %0x ",dfi_address[13:0],tr_prev_d5.addr,tr.addr),UVM_DEBUG)

`define D5_RD(dfi_cs_n,dfi_address,tr,tr_prev_d5)\
tr.set_cmd_read();\
tr.addr[18:0] = 0;\
tr.cs = dfi_cs_n[3:0];\
tr.cid[2:0] = dfi_address[13:11];\
tr.bl = cfg.d5_rd_crc_en ? 18 : 16;\
tr.bank = dfi_address[7:6];\
tr.bg = dfi_address[10:8];\
tr.d5_cmd_cyc_e = dfi_intf_tr::FIRST_CYCLE; \
$cast (tr_prev_d5, tr.clone());
//`svt_trace(get_type_name(),$psprintf("Got a READ command RD: dfi_address[13:0] is %0x tr_prev.addr = %0x and tr.addr: %0x",dfi_address[13:0],tr_prev_d5.addr, tr.addr))
//`uvm_info(get_type_name(),$psprintf("Got a Write command RD: dfi_address[13:0] is %0x tr_prev_d5.addr = %0x and tr.addr = %0x ",dfi_address[13:0],tr_prev_d5.addr,tr.addr),UVM_DEBUG)

`define D5_MRR(dfi_cs_n,dfi_address,tr,tr_prev_d5)\
tr.set_cmd_read();\
tr.addr[18:0] = dfi_address[12:5];\
tr.cs = dfi_cs_n[3:0];\
tr.cid[2:0] = 0;\
tr.bl = 16;\
tr.bank = 0;\
tr.bg = 0;\
tr.d5_cmd_cyc_e = dfi_intf_tr::FIRST_CYCLE; \
$cast (tr_prev_d5, tr.clone());\
`uvm_info(get_type_name(),$psprintf("Got a Write command MRR: dfi_address[13:0] is %0x tr_prev_d5.addr = %0x and tr.addr = %0x ",dfi_address[13:0],tr_prev_d5.addr,tr.addr),UVM_DEBUG)

`define d5_act2(tr_prev_d5,tr,dfi_cs_n,dfi_address)\
tr.set_cmd_act();\
tr.cs = dfi_cs_n;\
tr.bg = tr_prev_d5.bg;\
tr.bank = tr_prev.bank;\
tr.cid[3:0] = {dfi_address[13],tr_prev_d5.cid[2:0]};\
tr.dest = tr_prev_d5.dest;\
tr.addr = {dfi_address[17],tr_prev_d5.addr[16:12],dfi_address[11:0]};\
tr.d5_cmd_cyc_e = dfi_intf_tr::SECOND_CYCLE; \
row_addr = tr.addr; \
row_addr[`DFI_MAX_ADDRESS_WIDTH] = 1; \
open_row_array[tr.dest][tr.bg][tr.bank] = row_addr; 
//`svt_trace(get_type_name(),$psprintf("Got an Activate command for row: %0x",row_addr))
//`uvm_info(get_type_name(),$psprintf("Got an Activate command for row: %0x",row_addr),UVM_DEBUG)

`define d5_wr2(tr_prev_d5,tr,dfi_cs_n,dfi_address)\
tr.set_cmd_write();\
tr.cs = dfi_cs_n;\
tr.bg = tr_prev_d5.bg;\
tr.bank = tr_prev.bank;\
tr.cid[3:0] = {dfi_address[13],tr_prev_d5.cid[2:0]};\
tr.dest = tr_prev_d5.dest;\
tr.bl = tr_prev_d5.bl;\
tr.d5_ap = dfi_address[10];\
tr.addr = {dfi_address[8:5],dfi_address[3:1],3'b0};\
tr.d5_cmd_cyc_e = dfi_intf_tr::SECOND_CYCLE; 
//`svt_trace(get_type_name(),$psprintf("Got a WRITE command for col: %0x", tr.addr))
//`uvm_info(get_type_name(),$psprintf("Got a WRITE command for col: %0x",tr.addr),UVM_DEBUG)

`define d5_rd2(tr_prev_d5,tr,dfi_cs_n,dfi_address)\
tr.set_cmd_read();\
tr.cs = dfi_cs_n;\
tr.bg = tr_prev_d5.bg;\
tr.bank = tr_prev.bank;\
tr.cid[3:0] = {dfi_address[13],tr_prev_d5.cid[2:0]};\
tr.dest = tr_prev_d5.dest;\
tr.bl = tr_prev_d5.bl;\
tr.d5_ap = dfi_address[10];\
tr.d5_cmd_cyc_e = dfi_intf_tr::SECOND_CYCLE; \
tr.addr = {dfi_address[8:5],dfi_address[3:1],3'b0};
//`svt_trace(get_type_name(),$psprintf("Got a WRITE command for col: %0x", tr.addr))
//`uvm_info(get_type_name(),$psprintf("Got a WRITE command for col: %0x",tr.addr),UVM_DEBUG)
//
`define d5_mrr2(tr_prev_d5,tr,dfi_cs_n,dfi_address)\
tr.set_cmd_mrr();\
tr.cs = dfi_cs_n;\
tr.bg = 0;\
tr.bank = 0;\
tr.cid[3:0] = 0;\
tr.dest = tr_prev_d5.dest;\
tr.bl = tr_prev_d5.bl;\
tr.d5_ap = 0;\
tr.d5_cmd_cyc_e = dfi_intf_tr::SECOND_CYCLE; \
tr.addr = 0;\
tr_prev_d5.d5_cmd_cyc_e = dfi_intf_tr::SECOND_CYCLE; \
`uvm_info(get_type_name(),$psprintf("Got a MRR command for col: %0x",tr.addr),UVM_DEBUG)


typedef enum { 
  DES                          ,//= `SVT_DFI_MC_DES,                             /**< Device deselect command  for DDR2, DDR3 and DDR4 */
  NOP                          ,//= `SVT_DFI_MC_NOP,                             /**< NOP Command */
  MRS                          ,//= `SVT_DFI_MC_MRS,                             /**< Mode Register Set command for DDR2, DDR3 and DDR4 */
  ACT                          ,//= `SVT_DFI_MC_ACTIVE,                          /**< ACTIVE Command */
  RD_ZERO                      ,//= `SVT_DFI_MC_READ0,                           /**< READ Command*/                         
  RDS_FOUR                     ,//= `SVT_DFI_MC_READ4,                           /**< READ Command with burst length 4 */
  RDS_EIGHT                    ,//= `SVT_DFI_MC_READ8,                           /**< READ Command with burst length 8 */
  RDA                          ,//= `SVT_DFI_MC_READ_AP,                         /**< READ Command with Auto Precharge */
  RDAS_FOUR                    ,//= `SVT_DFI_MC_READ_AP4,                        /**< READ Command With bust length 4 and with auto precharge */
  RDAS_EIGHT                   ,//= `SVT_DFI_MC_READ_AP8,                        /**< READ Command with burst length 8 with auto precharge */
  WR                           ,//= `SVT_DFI_MC_WRITE,                           /**< WRITE Command */
  WRS_FOUR                     ,//= `SVT_DFI_MC_WRITE4,                          /**< WRITE Command with burst length 4  */
  WRS_EIGHT                    ,//     = `SVT_DFI_MC_WRITE8,                          /**< WRITE Command with burst length 8 */
  WRA                          ,//= `SVT_DFI_MC_WRITE_AP,                        /**< WRITE Command with Auto Precharge */
  WRAS_FOUR                    ,//   = `SVT_DFI_MC_WRITE_AP4,                       /**< WRITE Command With bust length 4 and with auto precharge*/
  WRAS_EIGHT                   ,//    = `SVT_DFI_MC_WRITE_AP8,                       /**< WRITE Command with burst length 8 with auto precharge*/
  WR_MRS                       ,//= `SVT_DFI_MC_WR_MRS,                          /**< MODE Register Write*/
  PRE                          ,//= `SVT_DFI_MC_PRECHARGE,                       /**< PRECHARGE Command for activated bank */
  PREALL                       ,//= `SVT_DFI_MC_PRECHARGE_ALL,                   /**< PRECHARGE Command  for all banks */
  REF                          ,//= `SVT_DFI_MC_REFRESH_PER_BANK,                /**< REFRESH Command for per bank */
  PDE_ZERO                     ,//    = `SVT_DFI_MC_POWER_DOWN_ENTRY0,               /**< POWER DOWN Entry with cke value 0 */
  PDE_ONE                      ,//   = `SVT_DFI_MC_POWER_DOWN_ENTRY1,               /**< POWER DOWN Entry with cke value 1 */
  PDX_ZERO                     ,//    = `SVT_DFI_MC_POWER_DOWN_EXIT0,                /**< POWER DOWN Exit with cke value 0 */
  PDX_ONE                      ,//   = `SVT_DFI_MC_POWER_DOWN_EXIT1,                /**< POWER DOWN Exit with cke value 1 */
  SRE                          ,//= `SVT_DFI_MC_SELF_REFRESH_ENTRY,              /**< SELF_REFRESH_ENTRY Command for DDR3,DDR4,LPDDR2 and LPDDR3 */
  SRX                          ,//= `SVT_DFI_MC_SELF_REFRESH_EXIT,               /**< SELF REFRESH EXIT*/
  SRX_ZERO                     ,//    = `SVT_DFI_MC_SELF_REFRESH_EXIT0,              /**< SELF REFRESH EXIT with cke 0*/
  SRX_ONE                      ,//   = `SVT_DFI_MC_SELF_REFRESH_EXIT1,              /**< SELF REFRESH EXIT with cke 1*/
  NOP_CKE_ONE                  ,//   = `SVT_DFI_MC_NOP_CKE1,                        /**< NOP_CKE1 command*/
  NOP_CKE_ZERO                 ,//    = `SVT_DFI_MC_NOP_CKE0,                        /**< NOP_CKE0 command*/
  ZQCL                         ,//= `SVT_DFI_MC_ZQCL,                            /**< ZQ calibration long command for DDR2, DDR3 and DDR4 */
  ZQCS                         ,//= `SVT_DFI_MC_ZQCS,                            /**< ZQ calibration short command for DDR2, DDR3 and DDR4 */
  MRW                          ,//= `SVT_DFI_MC_MRW,                             /**< Mode Register Write Command for LPDDR2 and LPDDR3 */                          
  MRR                          ,//= `SVT_DFI_MC_MRR,                             /**< Mode Register Read Command for LPDDR2 and LPDDR3 */ 
  REFALL                       ,//= `SVT_DFI_MC_REFRESH_ALL_BANK,                /**< REFRESH Command for all banks */                      
  NOP_ONE                      ,//  = `SVT_DFI_MC_NOP1,                            /**< NOP1*/             
  DPDM_ONE                     ,//   = `SVT_DFI_MC_DEEP_POWER_DOWN1,                /**< DEEP POWER DOWN Lpddr2 related cmd */
  DPDM                         ,//= `SVT_DFI_MC_DEEP_POWER_DOWN,                 /**< DEEP POWER DOWN Lpddr2 related cmd */
  DPDE                         ,//= `SVT_DFI_MC_DEEP_POWER_DOWN_ENTRY,           /**< DEEP POWER DOWN ENTRY*/
  PDE                          ,//= `SVT_DFI_MC_POWER_DOWN_ENTRY,                /**< POWER_DOWN_ENTRY Command for DDR3,DDR4,LPDDR2 and LPDDR3*/ 
  PDX                          ,//= `SVT_DFI_MC_POWER_DOWN_EXIT,                 /**< POWER_DOWN_EXIT Command for DDR3,DDR4,LPDDR2 and LPDDR3 */
  DES_CKE_ZERO                 ,//    = `SVT_DFI_MC_DES_CKE0,                        /**< DFI SPECIFIC COMMANDS*/                
  START_CK                     ,//= `SVT_DFI_MC_START_CK,                        /**< DFI SPECIFIC COMMANDS*/                    
  STOP_CK                      ,//= `SVT_DFI_MC_STOP_CK,                         /**< DFI SPECIFIC COMMANDS*/                      
  DFI_INIT                     ,//= `SVT_DFI_MC_DFI_INIT,                        /**< DFI SPECIFIC COMMANDS*/                        
  DFI_FREQ                     ,//= `SVT_DFI_MC_DFI_FREQ,                        /**< DFI SPECIFIC COMMANDS*/                       
  DFI_DRAM_CLK_DIS             ,//= `SVT_DFI_MC_DFI_DRAM_CLK_DIS,                /**< DFI SPECIFIC COMMANDS*/                           
  DFI_DRAM_CLK_EN              ,//= `SVT_DFI_MC_DFI_DRAM_CLK_EN,                 /**< DFI SPECIFIC COMMANDS*/               
  DFI_LP_CTRL_ASSERT_REQ       ,//= `SVT_DFI_MC_DFI_LP_CTRL_ASSERT_REQ,          /**< DFI SPECIFIC COMMANDS*/   
  DFI_LP_DATA_ASSERT_REQ       ,//= `SVT_DFI_MC_DFI_LP_DATA_ASSERT_REQ,          /**< DFI SPECIFIC COMMANDS*/     
  DFI_LP_CTRL_DEASSERT_REQ     ,//= `SVI_DFI_MC_DFI_LP_CTRL_DEASSERT_REQ,        /**< DFI SPECIFIC COMMANDS*/ 
  DFI_LP_DATA_DEASSERT_REQ     ,//= `SVI_DFI_MC_DFI_LP_DATA_DEASSERT_REQ,        /**< DFI SPECIFIC COMMANDS*/ 
  DFI_LP_CTRL_DATA_DEASSERT_REQ,//= `SVI_DFI_MC_DFI_LP_CTRL_DATA_DEASSERT_REQ,   /**< DFI SPECIFIC COMMANDS*/ 
  DFI_CTRLUPD_REQ_ASSERT       ,//= `SVI_DFI_MC_DFI_CTRLUPD_REQ_ASSERT,          /**< DFI SPECIFIC COMMANDS*/ 
  DFI_CTRLUPD_REQ_DEASSERT     ,//= `SVI_DFI_MC_DFI_CTRLUPD_REQ_DEASSERT,        /**< DFI SPECIFIC COMMANDS*/ 
  DFI_PHY_INITIATED_UPDATE     ,//= `SVI_DFI_MC_DFI_PHY_INITIATED_UPDATE,        /**< DFI SPECIFIC COMMANDS*/ 
  DFI_RESET_ASSERT             ,//= `SVI_DFI_MC_DFI_RESET_ASSERT,                /**< DFI SPECIFIC COMMANDS*/ 
  DFI_RESET_DEASSERT           ,//= `SVI_DFI_MC_DFI_RESET_DEASSERT,              /**< DFI SPECIFIC COMMANDS*/ 
  DFI_PHYUPD_ACK_ASSERT        ,//= `SVI_DFI_MC_DFI_PHYUPD_ACK_ASSERT,           /**< DFI SPECIFIC COMMANDS*/ 
  DFI_PHYMSTR_ACK_ASSERT       ,//= `SVI_DFI_MC_DFI_PHYMSTR_ACK_ASSERT,          /**< DFI SPECIFIC COMMANDS*/  
  POLL_PHYUPD_REQ              ,//= `SVI_DFI_MC_POLL_PHYUPD_REQ,                 /**< DFI SPECIFIC COMMANDS*/ 
  POLL_CTRLUPD_REQ             ,//= `SVI_DFI_MC_POLL_CTRLUPD_REQ,                /**< DFI SPECIFIC COMMANDS*/ 
  POLL_PHYMSTR_SIDEBAND        ,//= `SVI_DFI_MC_POLL_PHYMSTR_SIDEBAND,           /**< DFI SPECIFIC COMMANDS*/ 
  POLL_SIDEBANDS               ,//= `SVI_DFI_MC_POLL_SIDEBANDS,                  /**< DFI SPECIFIC COMMANDS*/ 
  POLL_DFI_ERROR               ,//= `SVI_DFI_MC_POLL_DFI_ERROR,                  /**< DFI SPECIFIC COMMANDS*/ 
  SPL_OPCODE_1                 ,//= `SVI_DFI_MC_SPL_OPCODE_1,                    /**< DFI SPECIFIC COMMANDS*/ 
  SPL_OPCODE_2                 ,//= `SVI_DFI_MC_SPL_OPCODE_2,                    /**< DFI SPECIFIC COMMANDS*/ 
  SPL_OPCODE_3                 ,//= `SVI_DFI_MC_SPL_OPCODE_3,                    /**< DFI SPECIFIC COMMANDS*/ 
  GEARDOWN_SYNC                ,//= `SVI_DFI_MC_GEARDOWN_SYNC,                   /**< DFI SPECIFIC COMMANDS*/ 
  GEARDOWN_EN                  ,//= `SVI_DFI_MC_GEARDOWN_EN,                     /**< DFI SPECIFIC COMMANDS*/ 
  GEARDOWN_DIS                 ,//= `SVI_DFI_MC_GEARDOWN_DIS,                    /**< DFI SPECIFIC COMMANDS*/    
  MRW_ONE                      ,//   = `SVT_DFI_MC_MRW_1,                              /**< Mode Register Write 1 Command (for LPDDR4 only). */                     
  MRW_TWO                      ,// = `SVT_DFI_MC_MRW_2,                              /**< Mode Register Write 2 Command (for LPDDR4 only). */                                     
  MRR_ONE                      ,//   = `SVT_DFI_MC_MRR_1,                              /**< Mode Register Read Command (for LPDDR4 only). */      
  ACT_ONE                      ,//   = `SVT_DFI_MC_ACTIVE_1,                           /**< ACTIVE 1 Command (for LPDDR4 only). */
  ACT_TWO                      ,//   = `SVT_DFI_MC_ACTIVE_2,                           /**< ACTIVE 2 Command (for LPDDR4 only). */
  WR_ONE                       ,//   = `SVT_DFI_MC_WR1,                             /**< WRITE COMMANDS*/ 
  RD_ONE                       ,//   = `SVT_DFI_MC_RD1,                             /**< READ COMMANDS*/             
  CAS_TWO                      ,//   = `SVT_DFI_MC_CAS_2,                              /**< CAS 2 Command (for LPDDR4 only). */
  MWR_ONE                      ,//   = `SVT_DFI_MC_MWR1,                            /**< */ 
  MPC_ONE                      ,//   = `SVT_DFI_MC_MPC1,                            /**< */ 
  MPC                          ,//= `SVT_DFI_MC_MPC,                             /**< */ 
  RFU                          ,//= `SVT_DFI_MC_RFU,                             /**< */ 
  SPL_OPCODE_ABYTE             ,//= `SVT_DFI_MC_SPL_OPCODE_ABYTE,                /**< */ 
  NOPH                         ,//= `SVT_DFI_MC_NOPH,                            /**< */ 
  MN_PD_SR_DPD_NOP             ,//= `SVT_DFI_MC_MN_PD_SR_DPD_NOP,                /**< */ 
  MN_PD_SR_DPD                 ,//= `SVT_DFI_MC_MN_PD_SR_DPD,                    /**< */ 
  MISC_CMD                     ,//= `SVT_DFI_MC_MISC_CMD,                        /**< */ 
  GEN_PHYMASTER_REQ            ,//= `SVT_DFI_MC_GEN_PHYMASTER_REQ,               /**< */ 
  PDX_SRX_DPDX                 ,//= `SVT_DFI_MC_PDX_SRX_DPDX,                    /**< */ 
  UPDATE_FREQ_RATIO            ,//= `SVT_DFI_MC_UPDATE_FREQ_RATIO,               /**< */ 
  PRESB                        ,//= `SVT_DFI_MC_PRESB,                           /**< */ 
  REFSB                        ,//= `SVT_DFI_MC_REFSB,                           /**< */ 
  WRP                          ,//= `SVT_DFI_MC_WRP,                             /**< */ 
  ECS                          ,//= `SVT_DFI_MC_ECS,                             /**< */ 
  MN_SR                        ,//= `SVT_DFI_MC_MN_SR,                           /**< */ 
  MN_PD                        ,//= `SVT_DFI_MC_MN_PD,                           /**< */ 
  XADR                         ,//= `SVT_DFI_MC_XADR,                            /**< */ 
  XWRITE                       ,//= `SVT_DFI_MC_XWRITE,                          /**< */ 
  PWRITE                       ,//= `SVT_DFI_MC_PWRITE,                          /**< */ 
  SEND_STATUS                  ,//= `SVT_DFI_MC_SEND_STATUS,                     /**< */ 
  SREAD                        ,//= `SVT_DFI_MC_SREAD,                           /**< */ 
  XREAD                        ,//= `SVT_DFI_MC_XREAD,                           /**< */ 
  FLUSH                        ,//= `SVT_DFI_MC_FLUSH,                           /**< */ 
  IOP                         //= `SVT_DFI_MC_IOP                              /**< */ 
  } cmd_en;

