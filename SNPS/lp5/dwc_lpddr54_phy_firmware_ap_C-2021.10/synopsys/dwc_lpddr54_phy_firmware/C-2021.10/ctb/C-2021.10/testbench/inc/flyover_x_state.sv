`ifdef FLYOVER_TEST
initial begin
force  test.top.dut.dfi_reset_n=1'bx;
force  test.top.dut.atpg_PllCtrlBus=142'bx;
force  test.top.dut.atpg_Asst_Clken=1'bx;
force  test.top.dut.atpg_UcClk=1'bx;

`ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
force  test.top.dut.dfi0_wrdata_mask_P0=8'bx;
force  test.top.dut.dfi0_wrdata_mask_P1=8'bx;
force  test.top.dut.dfi0_wrdata_mask_P2=8'bx;
force  test.top.dut.dfi0_wrdata_mask_P3=8'bx;
`endif 

`ifdef DWC_DDRPHY_LPDDR5_ENABLED
force test.top.dut.dfi0_wck_en_P0=4'bx;
force test.top.dut.dfi0_wck_en_P1=4'bx;
force test.top.dut.dfi0_wck_en_P2=4'bx;
force test.top.dut.dfi0_wck_en_P3=4'bx;
force test.top.dut.dfi0_wck_cs_P0=8'bx;
force test.top.dut.dfi0_wck_cs_P1=8'bx;
force test.top.dut.dfi0_wck_cs_P2=8'bx;
force test.top.dut.dfi0_wck_cs_P3=8'bx;
force test.top.dut.dfi0_wck_toggle_P0=8'bx;
force test.top.dut.dfi0_wck_toggle_P1=8'bx;
force test.top.dut.dfi0_wck_toggle_P2=8'bx;
force test.top.dut.dfi0_wck_toggle_P3=8'bx;
force test.top.dut.dfi0_wrdata_link_ecc_P0=8'bx;
force test.top.dut.dfi0_wrdata_link_ecc_P1=8'bx;
force test.top.dut.dfi0_wrdata_link_ecc_P2=8'bx;
force test.top.dut.dfi0_wrdata_link_ecc_P3=8'bx;

force test.top.dut.dfi0_address_P0=14'bx;   
force test.top.dut.dfi0_address_P1=6'bx;
force test.top.dut.dfi0_address_P2=6'bx;
force test.top.dut.dfi0_address_P3=6'bx;
`else                       
force test.top.dut.dfi0_address_P0=6'bx;   
force test.top.dut.dfi0_address_P1=6'bx;
force test.top.dut.dfi0_address_P2=6'bx;
force test.top.dut.dfi0_address_P3=6'bx;
`endif

force test.top.dut.dfi0_wrdata_P0=64'bx;
force test.top.dut.dfi0_wrdata_P1=64'bx;
force test.top.dut.dfi0_wrdata_P2=64'bx;
force test.top.dut.dfi0_wrdata_P3=64'bx;
force test.top.dut.dfi0_wrdata_cs_P0=8'bx;
force test.top.dut.dfi0_wrdata_cs_P1=8'bx;
force test.top.dut.dfi0_wrdata_cs_P2=8'bx;
force test.top.dut.dfi0_wrdata_cs_P3=8'bx;
force test.top.dut.dfi0_wrdata_en_P0=4'bx;
force test.top.dut.dfi0_wrdata_en_P1=4'bx;
force test.top.dut.dfi0_wrdata_en_P2=4'bx;
force test.top.dut.dfi0_wrdata_en_P3=4'bx;
force test.top.dut.dfi0_rddata_cs_P0=8'bx;
force test.top.dut.dfi0_rddata_cs_P1=8'bx;
force test.top.dut.dfi0_rddata_cs_P2=8'bx;
force test.top.dut.dfi0_rddata_cs_P3=8'bx;
force test.top.dut.dfi0_rddata_en_P0=4'bx;
force test.top.dut.dfi0_rddata_en_P1=4'bx;
force test.top.dut.dfi0_rddata_en_P2=4'bx;
force test.top.dut.dfi0_rddata_en_P3=4'bx;
force test.top.dut.dfi0_ctrlupd_req=1'bx ;
//force test.top.dut.dfi0_ctrlupd_type=2'bx ;
force test.top.dut.dfi0_phyupd_ack=1'bx ;
force test.top.dut.dfi0_dram_clk_disable_P0=1'bx;
force test.top.dut.dfi0_dram_clk_disable_P1=1'bx;
force test.top.dut.dfi0_dram_clk_disable_P2=1'bx;
force test.top.dut.dfi0_dram_clk_disable_P3=1'bx;
force test.top.dut.dfi0_freq_fsp=2'bx;
force test.top.dut.dfi0_freq_ratio=2'bx;
force test.top.dut.dfi0_frequency=5'bx;
force test.top.dut.dfi0_init_start=1'bx;
force test.top.dut.dfi0_phymstr_ack=1'bx;
force  test.top.dut.dfi0_cke_P0 = 2'bx;
force  test.top.dut.dfi0_cke_P1 = 2'bx;
force  test.top.dut.dfi0_cke_P2 = 2'bx;
force  test.top.dut.dfi0_cke_P3 = 2'bx;
force  test.top.dut.dfi0_cs_P0 =2'bx;
force  test.top.dut.dfi0_cs_P1 =2'bx;
force  test.top.dut.dfi0_cs_P2 =2'bx;
force  test.top.dut.dfi0_cs_P3 =2'bx;
force  test.top.dut.dfi0_lp_ctrl_req = 1'bx ;
force  test.top.dut.dfi0_lp_ctrl_wakeup = 1'bx ;
force  test.top.dut.dfi0_lp_data_req = 1'bx ;
force  test.top.dut.dfi0_lp_data_wakeup = 1'bx ;
force  test.top.dut.dfi0_ctrlmsg=8'bx ;
force  test.top.dut.dfi0_ctrlmsg_data=16'bx ;
force  test.top.dut.dfi0_ctrlmsg_req=1'bx ;
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
`ifdef DWC_DDRPHY_LPDDR5_ENABLED
force test.top.dut.dfi1_wck_en_P0=4'bx;
force test.top.dut.dfi1_wck_en_P1=4'bx;
force test.top.dut.dfi1_wck_en_P2=4'bx;
force test.top.dut.dfi1_wck_en_P3=4'bx;
force test.top.dut.dfi1_wck_cs_P0=8'bx;
force test.top.dut.dfi1_wck_cs_P1=8'bx;
force test.top.dut.dfi1_wck_cs_P2=8'bx;
force test.top.dut.dfi1_wck_cs_P3=8'bx;
force test.top.dut.dfi1_wck_toggle_P0=8'bx;
force test.top.dut.dfi1_wck_toggle_P1=8'bx;
force test.top.dut.dfi1_wck_toggle_P2=8'bx;
force test.top.dut.dfi1_wck_toggle_P3=8'bx;
force test.top.dut.dfi1_wrdata_link_ecc_P0=8'bx;
force test.top.dut.dfi1_wrdata_link_ecc_P1=8'bx;
force test.top.dut.dfi1_wrdata_link_ecc_P2=8'bx;
force test.top.dut.dfi1_wrdata_link_ecc_P3=8'bx;

force test.top.dut.dfi1_address_P0=14'bx;   
force test.top.dut.dfi1_address_P1=6'bx;
force test.top.dut.dfi1_address_P2=6'bx;
force test.top.dut.dfi1_address_P3=6'bx;
`else                       
force test.top.dut.dfi1_address_P0=6'bx;   
force test.top.dut.dfi1_address_P1=6'bx;
force test.top.dut.dfi1_address_P2=6'bx;
force test.top.dut.dfi1_address_P3=6'bx;
`endif

force test.top.dut.dfi1_wrdata_P0=64'bx;
force test.top.dut.dfi1_wrdata_P1=64'bx;
force test.top.dut.dfi1_wrdata_P2=64'bx;
force test.top.dut.dfi1_wrdata_P3=64'bx;
force test.top.dut.dfi1_wrdata_cs_P0=8'bx;
force test.top.dut.dfi1_wrdata_cs_P1=8'bx;
force test.top.dut.dfi1_wrdata_cs_P2=8'bx;
force test.top.dut.dfi1_wrdata_cs_P3=8'bx;
force test.top.dut.dfi1_wrdata_en_P0=4'bx;
force test.top.dut.dfi1_wrdata_en_P1=4'bx;
force test.top.dut.dfi1_wrdata_en_P2=4'bx;
force test.top.dut.dfi1_wrdata_en_P3=4'bx;
force test.top.dut.dfi1_rddata_cs_P0=8'bx;
force test.top.dut.dfi1_rddata_cs_P1=8'bx;
force test.top.dut.dfi1_rddata_cs_P2=8'bx;
force test.top.dut.dfi1_rddata_cs_P3=8'bx;
force test.top.dut.dfi1_rddata_en_P0=4'bx;
force test.top.dut.dfi1_rddata_en_P1=4'bx;
force test.top.dut.dfi1_rddata_en_P2=4'bx;
force test.top.dut.dfi1_rddata_en_P3=4'bx;
force test.top.dut.dfi1_ctrlupd_req=1'bx ;
//force test.top.dut.dfi1_ctrlupd_type=2'bx ;
force test.top.dut.dfi1_phyupd_ack=1'bx ;
force test.top.dut.dfi1_dram_clk_disable_P0=1'bx;
force test.top.dut.dfi1_dram_clk_disable_P1=1'bx;
force test.top.dut.dfi1_dram_clk_disable_P2=1'bx;
force test.top.dut.dfi1_dram_clk_disable_P3=1'bx;
force test.top.dut.dfi1_freq_fsp=2'bx;
force test.top.dut.dfi1_freq_ratio=2'bx;
force test.top.dut.dfi1_frequency=5'bx;
force test.top.dut.dfi1_init_start=1'bx;
force test.top.dut.dfi1_phymstr_ack=1'bx;
force test.top.dut.dfi1_cke_P0 = 2'bx;
force test.top.dut.dfi1_cke_P1 = 2'bx;
force test.top.dut.dfi1_cke_P2 = 2'bx;
force test.top.dut.dfi1_cke_P3 = 2'bx;
force test.top.dut.dfi1_cs_P0 =2'bx;
force test.top.dut.dfi1_cs_P1 =2'bx;
force test.top.dut.dfi1_cs_P2 =2'bx;
force test.top.dut.dfi1_cs_P3 =2'bx;
force test.top.dut.dfi1_lp_ctrl_req = 1'bx ;
force test.top.dut.dfi1_lp_ctrl_wakeup = 1'bx ;
force test.top.dut.dfi1_lp_data_req = 1'bx ;
force test.top.dut.dfi1_lp_data_wakeup = 1'bx ;
force test.top.dut.dfi1_ctrlmsg=8'bx ;
force test.top.dut.dfi1_ctrlmsg_data=16'bx ;
force test.top.dut.dfi1_ctrlmsg_req=1'bx ;
`endif   //DWC_DDRPHY_NUM_CHANNELS_2
force test.top.dut.DfiClk=1'bx ;
force test.top.dut.PllRefClk=1'bx ;
force test.top.dut.PllBypClk=1'bx ;
force test.top.dut.BurnIn=1'bx ;
`ifdef DWC_DDRPHY_LBIST_EN
`ifndef PUB_VERSION_GE_0100
force test.top.dut.DfiClk0_lbist=1'bx ;
`endif                          
force test.top.dut.lbist_mode=1'bx ;
force test.top.dut.LBIST_TYPE=1'bx ;
force test.top.dut.LBIST_TM0=1'bx ;
force test.top.dut.LBIST_TM1=1'bx ;
force test.top.dut.LBIST_EN=1'bx ;
force test.top.dut.START=1'bx ;
`endif                          
force test.top.dut.WSI=1'bx ;                  
force test.top.dut.TDRCLK=1'bx ;                 
force test.top.dut.WRSTN=1'bx ;                
force test.top.dut.DdrPhyCsrCmdTdrShiftEn=1'bx ;    
force test.top.dut.DdrPhyCsrCmdTdrCaptureEn=1'bx ;  
force test.top.dut.DdrPhyCsrCmdTdrUpdateEn=1'bx ;   
force test.top.dut.DdrPhyCsrRdDataTdrShiftEn=1'bx ;    
force test.top.dut.DdrPhyCsrRdDataTdrCaptureEn=1'bx ;  
force test.top.dut.DdrPhyCsrRdDataTdrUpdateEn=1'bx ;   
force test.top.dut.dwc_ddrphy0_snoop_en_P0=16'bx;
force test.top.dut.dwc_ddrphy0_snoop_en_P1=16'bx;
force test.top.dut.dwc_ddrphy0_snoop_en_P2=16'bx;
force test.top.dut.dwc_ddrphy0_snoop_en_P3=16'bx;
`ifdef DWC_DDRPHY_NUM_CHANNELS_2
force test.top.dut.dwc_ddrphy1_snoop_en_P0=16'bx;
force test.top.dut.dwc_ddrphy1_snoop_en_P1=16'bx;
force test.top.dut.dwc_ddrphy1_snoop_en_P2=16'bx;
force test.top.dut.dwc_ddrphy1_snoop_en_P3=16'bx;
`endif
force test.top.dut.atpg_RDQSClk=1'bx ;
force test.top.dut.atpg_PClk=1'bx ;
force test.top.dut.atpg_TxDllClk=1'bx ;
force test.top.dut.atpg_DlyTestClk=1'bx ;
force test.top.dut.hresp_ahb=1'bx ;          
force test.top.dut.hreadyout_ahb=1'bx ;
force test.top.dut.APBCLK=1'bx ;                       
force test.top.dut.hrdata_ahb=32'bx;
force test.top.dut.PADDR_APB=32'bx;
force test.top.dut.PWRITE_APB=1'bx ;
force test.top.dut.PRESETn_APB=1'bx ;
force test.top.dut.PSELx_APB=1'bx ;
force test.top.dut.PENABLE_APB=1'bx ;
force test.top.dut.PWDATA_APB=16'bx;
force test.top.dut.PSTRB_APB=2'bx;
force test.top.dut.PPROT_APB=3'bx;
force test.top.dut.PPROT_PIN=3'bx;
force test.top.dut.iccm_data_dout=39'bx;
force test.top.dut.dccm_data_dout=39'bx;
force test.top.dut.ps_ram_rddata=60'bx;    
force test.top.dut.acsm_data_dout=72'bx;
end
`endif //FLYOVER_TEST
