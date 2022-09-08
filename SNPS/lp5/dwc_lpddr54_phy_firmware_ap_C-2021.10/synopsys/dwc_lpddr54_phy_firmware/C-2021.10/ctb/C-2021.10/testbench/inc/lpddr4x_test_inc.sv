import uvm_pkg::*;
  import svt_uvm_pkg::*;
  import svt_mem_uvm_pkg::*;
  import svt_lpddr_full_uvm_pkg::*;

  string catalog_file;

  initial begin
    uvmvlog_pkg::init();
    $write("Configuration Started\n");
    // Load Memory parameters
    `ifdef DDRPHY_POWERSIM
    catalog_file = {`CTB_DW_HOME,"/vip/svt/lpddr_svt/latest/catalog/lpddr4/dram/JEDEC/jedec_lpddr4_8G_x16_4267_0_468.cfg"};
    `else
    catalog_file = {`CTB_DW_HOME,"/vip/svt/lpddr_svt/latest/catalog/lpddr4/dram/JEDEC/jedec_lpddr4_2G_x16_4267_0_468.cfg"};
    `endif
    do_lpddr_config();
    uvmvlog_pkg::start();
    disable_checkers();
  `ifndef DDRPHY_POWERSIM
    do_test();
  `else 
    `ifdef DDRPHY_B2B_RD
     do_mem_core_initializaion();
    `endif
    `ifdef DDRPHY_PWR_EM
     do_mem_core_initializaion();
    `endif
  `endif
  end

  function void do_lpddr_config();
//  // Configuration FSP for PState1 before dev_init by backdoor
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//`ifdef DWC_DDRPHY_NUM_DBYTES_4
//`ifdef RANK2
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//`endif
//`endif
//`ifdef DWC_DDRPHY_NUM_DBYTES_8
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//`ifdef RANK2
//    void'(`LPDDR4_DRAM3.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM3.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM3.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM3.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM4.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM4.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM4.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM4.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//`endif
//`endif

    void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.load_prop_vals(catalog_file));
`ifdef DWC_DDRPHY_NUM_DBYTES_4
`ifdef RANK2
    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.load_prop_vals(catalog_file));
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_8
    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.load_prop_vals(catalog_file));
`ifdef RANK2
    void'(`LPDDR4_DRAM3.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR4_DRAM3.cfg.cfg_channel_b.load_prop_vals(catalog_file));
    void'(`LPDDR4_DRAM4.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR4_DRAM4.cfg.cfg_channel_b.load_prop_vals(catalog_file));
`endif
`endif

    // Memory Channel A Configuration
    `LPDDR4_DRAM1.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM1.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM1.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM1.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_a.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM1.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM1.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM1.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM1.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end

`ifdef DWC_DDRPHY_NUM_DBYTES_4
`ifdef RANK2
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_8
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end

`ifdef RANK2
    `LPDDR4_DRAM3.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM3.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM3.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM3.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_a.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM3.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM3.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM3.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM3.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end

    `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM4.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_a.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM4.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM4.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM4.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM4.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end
`endif
`endif

    // Memory Channel B Configuration
    `LPDDR4_DRAM1.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM1.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM1.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM1.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR4_DRAM1.cfg.cfg_channel_b.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM1.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM1.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM1.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM1.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end

`ifdef DWC_DDRPHY_NUM_DBYTES_4
`ifdef RANK2
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_8
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM2.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end
`ifdef RANK2
    `LPDDR4_DRAM3.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM3.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM3.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM3.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR4_DRAM3.cfg.cfg_channel_b.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM3.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM3.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM3.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM3.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end

    `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR4_DRAM4.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR4_DRAM4.cfg.cfg_channel_b.dqs_osc_multi_val = 2;

    //`LPDDR4_DRAM4.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR4_DRAM4.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR4_DRAM4.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1) begin
    `LPDDR4_DRAM4.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end
`endif
`endif
  `LPDDR4_DRAM1.cfg.save_prop_vals("lpddr4.cfg");

`ifdef DWC_DDRPHY_NUM_DBYTES_4
`ifdef RANK2
     if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
      `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_checks=00;
      `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_checks=00;
    end
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_8
    if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
      `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_checks=00;
      `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_checks=00;
`ifdef RANK2
      `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_checks=00;
      `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_checks=00;
`endif
    end
`endif
  endfunction

//--------------------------------------------------------------------------------
    // This checker has VIP issue, and will be fixed in 2017.09, should be re-enabled after fixed.
  function void set_invalid_mpc_cmd_check(bit value);
    `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
    `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
`ifdef DWC_DDRPHY_NUM_DBYTES_4
`ifdef RANK2
    `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
    `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
`endif
`endif
`ifdef DWC_DDRPHY_NUM_DBYTES_8
    `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
    `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
`ifdef RANK2
    `LPDDR4_DRAM3.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
    `LPDDR4_DRAM3.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
    `LPDDR4_DRAM4.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
    `LPDDR4_DRAM4.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
`endif
`endif
  endfunction

  task automatic disable_checkers();
    #0;
    set_invalid_mpc_cmd_check(0);
  endtask
//--------------------------------------------------------------------------------
  task automatic do_test(); 
    longint max_addr = (1 << 9);
    longint data=0;
    reg [9:0] col = 10'h70;
    reg [2:0] bank=3'b0;
    reg [15:0] bit8;
    reg [31:0] data0;
    reg [31:0] data1;
    reg [0:3][9:0] col_value;
    col_value[0]=10'h3b0;
    col_value[1]=10'h360;
    col_value[2]=10'h390;
    col_value[3]=10'h360;
    // Initialize Memory
//     $display("%0t, <%m>", $time);
//    `ifndef DDRPHY_POWERSIM 
//    for(int i=0;i<1100;i++)begin      // read/write time
//      for(reg[9:0] j=0;j<16;j++)begin   //burst lenth is 16
//        //data=1+8*i+j;
//        bit8={$random} %256;
//        data={16{bit8}};
//          `LPDDR4_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR4_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//
//          `LPDDR4_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});  
//          `LPDDR4_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//        `ifdef DWC_DDRPHY_NUM_DBYTES_4
//        `ifdef RANK2
//           `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//           `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//        `endif
//        `endif
//        `ifdef DWC_DDRPHY_NUM_DBYTES_8
//           `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//           `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//        `ifdef RANK2
//           `LPDDR4_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//           `LPDDR4_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//           `LPDDR4_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//           `LPDDR4_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//           `LPDDR4_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//         `endif
//         `endif
//         //$display("write to addr=%h is data=%h, @ %0t",{bank,14'h30,col+j},data, $time);
//      end
//      col=col+16;
//    end
//    `endif
      `LPDDR4_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
      `LPDDR4_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);  
      `ifdef DWC_DDRPHY_NUM_DBYTES_4
        `ifdef RANK2
          `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `endif
      `endif
      `ifdef DWC_DDRPHY_NUM_DBYTES_8
        `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `ifdef RANK2
          `LPDDR4_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `endif
      `endif

  endtask


