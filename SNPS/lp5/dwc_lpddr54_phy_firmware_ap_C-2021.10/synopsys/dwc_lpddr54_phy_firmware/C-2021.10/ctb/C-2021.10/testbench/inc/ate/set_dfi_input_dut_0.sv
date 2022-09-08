//////////////////
//  This file is applied to set initial data for DFI pin (DFI -> DUT)
//
/////////////////
initial
begin


$deposit(test.top.dut.dfi0_address_P0            ,    0);
$deposit(test.top.dut.dfi0_address_P1            ,    0);
$deposit(test.top.dut.dfi0_address_P2            ,    0);
$deposit(test.top.dut.dfi0_address_P3            ,    0);
$deposit(test.top.dut.dfi0_cke_P0                ,    0);
$deposit(test.top.dut.dfi0_cke_P1                ,    0);
$deposit(test.top.dut.dfi0_cke_P2                ,    0);
$deposit(test.top.dut.dfi0_cke_P3                ,    0);
$deposit(test.top.dut.dfi0_cs_P0                 ,    0);
$deposit(test.top.dut.dfi0_cs_P1                 ,    0);
$deposit(test.top.dut.dfi0_cs_P2                 ,    0);
$deposit(test.top.dut.dfi0_cs_P3                 ,    0);
$deposit(test.top.dut.dfi0_ctrlupd_ack           ,    0);
$deposit(test.top.dut.dfi0_ctrlupd_req           ,    0);
$deposit(test.top.dut.dfi0_dram_clk_disable_P0   ,    0);
$deposit(test.top.dut.dfi0_dram_clk_disable_P1   ,    0);
$deposit(test.top.dut.dfi0_dram_clk_disable_P2   ,    0);
$deposit(test.top.dut.dfi0_dram_clk_disable_P3   ,    0);
$deposit(test.top.dut.dfi0_error                 ,    0);
$deposit(test.top.dut.dfi0_error_info            ,    0);
$deposit(test.top.dut.dfi0_frequency             ,    0);
$deposit(test.top.dut.dfi0_freq_ratio            ,    0);
$deposit(test.top.dut.dfi0_freq_fsp              ,    0);
$deposit(test.top.dut.dfi0_init_start            ,    0);
$deposit(test.top.dut.dfi0_init_complete         ,    0);
$deposit(test.top.dut.dfi0_lp_ctrl_ack           ,    0);
$deposit(test.top.dut.dfi0_lp_data_ack           ,    0);
$deposit(test.top.dut.dfi0_lp_ctrl_req           ,    0);
$deposit(test.top.dut.dfi0_lp_data_req           ,    0);
$deposit(test.top.dut.dfi0_lp_ctrl_wakeup        ,    0);
$deposit(test.top.dut.dfi0_lp_data_wakeup        ,    0);
$deposit(test.top.dut.dfi0_phymstr_ack           ,    0);
$deposit(test.top.dut.dfi0_phymstr_cs_state      ,    0);
$deposit(test.top.dut.dfi0_phymstr_req           ,    0);
$deposit(test.top.dut.dfi0_phymstr_state_sel     ,    0);
$deposit(test.top.dut.dfi0_phymstr_type          ,    0);
$deposit(test.top.dut.dfi0_phyupd_ack            ,    0);
$deposit(test.top.dut.dfi0_phyupd_req            ,    0);
$deposit(test.top.dut.dfi0_phyupd_type           ,    0);
$deposit(test.top.dut.dfi0_rddata_cs_P0          ,    0);
$deposit(test.top.dut.dfi0_rddata_cs_P1          ,    0);
$deposit(test.top.dut.dfi0_rddata_cs_P2          ,    0);
$deposit(test.top.dut.dfi0_rddata_cs_P3          ,    0);
$deposit(test.top.dut.dfi0_rddata_en_P0          ,    0);
$deposit(test.top.dut.dfi0_rddata_en_P1          ,    0);
$deposit(test.top.dut.dfi0_rddata_en_P2          ,    0);
$deposit(test.top.dut.dfi0_rddata_en_P3          ,    0);
$deposit(test.top.dut.dfi0_rddata_valid_W0       ,    0);
$deposit(test.top.dut.dfi0_rddata_valid_W1       ,    0);
$deposit(test.top.dut.dfi0_rddata_valid_W2       ,    0);
$deposit(test.top.dut.dfi0_rddata_valid_W3       ,    0);
$deposit(test.top.dut.dfi0_rddata_dbi_W0         ,    0);
$deposit(test.top.dut.dfi0_rddata_dbi_W1         ,    0);
$deposit(test.top.dut.dfi0_rddata_dbi_W2         ,    0);
$deposit(test.top.dut.dfi0_rddata_dbi_W3         ,    0);
$deposit(test.top.dut.dfi0_rddata_W0             ,    0);
$deposit(test.top.dut.dfi0_rddata_W1             ,    0);
$deposit(test.top.dut.dfi0_rddata_W2             ,    0);
$deposit(test.top.dut.dfi0_rddata_W3             ,    0);
$deposit(test.top.dut.dfi0_wrdata_P0             ,    0);
$deposit(test.top.dut.dfi0_wrdata_P1             ,    0);
$deposit(test.top.dut.dfi0_wrdata_P2             ,    0);
$deposit(test.top.dut.dfi0_wrdata_P3             ,    0);
$deposit(test.top.dut.dfi0_wrdata_cs_P0          ,    0);
$deposit(test.top.dut.dfi0_wrdata_cs_P1          ,    0);
$deposit(test.top.dut.dfi0_wrdata_cs_P2          ,    0);
$deposit(test.top.dut.dfi0_wrdata_cs_P3          ,    0);
$deposit(test.top.dut.dfi0_wrdata_en_P0          ,    0);
$deposit(test.top.dut.dfi0_wrdata_en_P1          ,    0);
$deposit(test.top.dut.dfi0_wrdata_en_P2          ,    0);
$deposit(test.top.dut.dfi0_wrdata_en_P3          ,    0);
$deposit(test.top.dut.dfi0_wrdata_mask_P0        ,    0);
$deposit(test.top.dut.dfi0_wrdata_mask_P1        ,    0);
$deposit(test.top.dut.dfi0_wrdata_mask_P2        ,    0);
$deposit(test.top.dut.dfi0_wrdata_mask_P3        ,    0);


`ifdef DWC_DDRPHY_NUM_CHANNELS_2


$deposit(test.top.dut.dfi1_address_P0             ,   0);
$deposit(test.top.dut.dfi1_address_P1             ,   0);
$deposit(test.top.dut.dfi1_address_P2             ,   0);
$deposit(test.top.dut.dfi1_address_P3             ,   0);
$deposit(test.top.dut.dfi1_cke_P0                 ,   0);
$deposit(test.top.dut.dfi1_cke_P1                 ,   0);
$deposit(test.top.dut.dfi1_cke_P2                 ,   0);
$deposit(test.top.dut.dfi1_cke_P3                 ,   0);
$deposit(test.top.dut.dfi1_cs_P0                  ,   0);
$deposit(test.top.dut.dfi1_cs_P1                  ,   0);
$deposit(test.top.dut.dfi1_cs_P2                  ,   0);
$deposit(test.top.dut.dfi1_cs_P3                  ,   0);
$deposit(test.top.dut.dfi1_ctrlupd_ack            ,   0);
$deposit(test.top.dut.dfi1_ctrlupd_req            ,   0);
$deposit(test.top.dut.dfi1_dram_clk_disable_P0    ,   0);
$deposit(test.top.dut.dfi1_dram_clk_disable_P1    ,   0);
$deposit(test.top.dut.dfi1_dram_clk_disable_P2    ,   0);
$deposit(test.top.dut.dfi1_dram_clk_disable_P3    ,   0);
$deposit(test.top.dut.dfi1_error                  ,   0);
$deposit(test.top.dut.dfi1_error_info             ,   0);
$deposit(test.top.dut.dfi1_frequency              ,   0);
$deposit(test.top.dut.dfi1_freq_ratio             ,   0);
$deposit(test.top.dut.dfi1_freq_fsp               ,   0);
$deposit(test.top.dut.dfi1_init_start             ,   0);
$deposit(test.top.dut.dfi1_init_complete          ,   0);
$deposit(test.top.dut.dfi1_lp_ctrl_ack            ,   0);
$deposit(test.top.dut.dfi1_lp_data_ack            ,   0);
$deposit(test.top.dut.dfi1_lp_ctrl_req            ,   0);
$deposit(test.top.dut.dfi1_lp_data_req            ,   0);
$deposit(test.top.dut.dfi1_lp_ctrl_wakeup         ,   0);
$deposit(test.top.dut.dfi1_lp_data_wakeup         ,   0);
$deposit(test.top.dut.dfi1_phymstr_ack            ,   0);
$deposit(test.top.dut.dfi1_phymstr_cs_state       ,   0);
$deposit(test.top.dut.dfi1_phymstr_req            ,   0);
$deposit(test.top.dut.dfi1_phymstr_state_sel      ,   0);
$deposit(test.top.dut.dfi1_phymstr_type           ,   0);
$deposit(test.top.dut.dfi1_phyupd_ack             ,   0);
$deposit(test.top.dut.dfi1_phyupd_req             ,   0);
$deposit(test.top.dut.dfi1_phyupd_type            ,   0);
$deposit(test.top.dut.dfi1_rddata_cs_P0           ,   0);
$deposit(test.top.dut.dfi1_rddata_cs_P1           ,   0);
$deposit(test.top.dut.dfi1_rddata_cs_P2           ,   0);
$deposit(test.top.dut.dfi1_rddata_cs_P3           ,   0);
$deposit(test.top.dut.dfi1_rddata_en_P0           ,   0);
$deposit(test.top.dut.dfi1_rddata_en_P1           ,   0);
$deposit(test.top.dut.dfi1_rddata_en_P2           ,   0);
$deposit(test.top.dut.dfi1_rddata_en_P3           ,   0);
$deposit(test.top.dut.dfi1_rddata_valid_W0        ,   0);
$deposit(test.top.dut.dfi1_rddata_valid_W1        ,   0);
$deposit(test.top.dut.dfi1_rddata_valid_W2        ,   0);
$deposit(test.top.dut.dfi1_rddata_valid_W3        ,   0);
$deposit(test.top.dut.dfi1_rddata_dbi_W0          ,   0);
$deposit(test.top.dut.dfi1_rddata_dbi_W1          ,   0);
$deposit(test.top.dut.dfi1_rddata_dbi_W2          ,   0);
$deposit(test.top.dut.dfi1_rddata_dbi_W3          ,   0);
$deposit(test.top.dut.dfi1_rddata_W0              ,   0);
$deposit(test.top.dut.dfi1_rddata_W1              ,   0);
$deposit(test.top.dut.dfi1_rddata_W2              ,   0);
$deposit(test.top.dut.dfi1_rddata_W3              ,   0);
$deposit(test.top.dut.dfi1_wrdata_P0              ,   0);
$deposit(test.top.dut.dfi1_wrdata_P1              ,   0);
$deposit(test.top.dut.dfi1_wrdata_P2              ,   0);
$deposit(test.top.dut.dfi1_wrdata_P3              ,   0);
$deposit(test.top.dut.dfi1_wrdata_cs_P0           ,   0);
$deposit(test.top.dut.dfi1_wrdata_cs_P1           ,   0);
$deposit(test.top.dut.dfi1_wrdata_cs_P2           ,   0);
$deposit(test.top.dut.dfi1_wrdata_cs_P3           ,   0);
$deposit(test.top.dut.dfi1_wrdata_en_P0           ,   0);
$deposit(test.top.dut.dfi1_wrdata_en_P1           ,   0);
$deposit(test.top.dut.dfi1_wrdata_en_P2           ,   0);
$deposit(test.top.dut.dfi1_wrdata_en_P3           ,   0);
$deposit(test.top.dut.dfi1_wrdata_mask_P0         ,   0);
$deposit(test.top.dut.dfi1_wrdata_mask_P1         ,   0);
$deposit(test.top.dut.dfi1_wrdata_mask_P2         ,   0);
$deposit(test.top.dut.dfi1_wrdata_mask_P3         ,   0);
`endif



end

