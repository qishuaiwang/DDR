import uvm_pkg::*;
  import svt_uvm_pkg::*;
  import svt_mem_uvm_pkg::*;
  import svt_lpddr_full_uvm_pkg::*;

  string catalog_file;
  
  initial begin
    $display("[%0t] <%m> lpddr5_test_inc: initial begin", $time);
    uvmvlog_pkg::init();
    $write("Configuration Started\n");
    // Load Memory parameters
    catalog_file = {`CTB_DW_HOME,"/vip/svt/lpddr_svt/latest/catalog/lpddr5/dram/JEDEC/jedec_lpddr5_32G_x16_6400_1_25.cfg"};
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
    $display("[%0t] <%m> lpddr5_test_inc: initial end", $time);
  end

  function void do_lpddr_config();
    $display("[%0t] <%m> do_lpddr_config", $time);

    void'(`LPDDR5_DRAM1.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR5_DRAM1.cfg.cfg_channel_b.load_prop_vals(catalog_file));
    void'(`LPDDR5_DRAM2.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR5_DRAM2.cfg.cfg_channel_b.load_prop_vals(catalog_file));
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    void'(`LPDDR5_DRAM3.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR5_DRAM3.cfg.cfg_channel_b.load_prop_vals(catalog_file));
    void'(`LPDDR5_DRAM4.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    void'(`LPDDR5_DRAM4.cfg.cfg_channel_b.load_prop_vals(catalog_file));
    `endif
    //set task svt_lpddr5_jedec_common::detect_clock_stop_optimized() to run correct in freq=5MHz.
    `LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg.tclock_stop_ns = 100ps;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.timing_cfg.tclock_stop_ns = 100ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.timing_cfg.tclock_stop_ns = 100ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.timing_cfg.tclock_stop_ns = 100ps;
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.cfg.cfg_channel_a.timing_cfg.tclock_stop_ns = 100ps;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.timing_cfg.tclock_stop_ns = 100ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.timing_cfg.tclock_stop_ns = 100ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.timing_cfg.tclock_stop_ns = 100ps;
    `endif

    //set task svt_lpddr5_jedec_common::detect_wck_stop_optimized() to run correct in freq=5MHz.
    `LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg.twck_stop_ns = 50ps;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.timing_cfg.twck_stop_ns = 50ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.timing_cfg.twck_stop_ns = 50ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.timing_cfg.twck_stop_ns = 50ps;
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.cfg.cfg_channel_a.timing_cfg.twck_stop_ns = 50ps;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.timing_cfg.twck_stop_ns = 50ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.timing_cfg.twck_stop_ns = 50ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.timing_cfg.twck_stop_ns = 50ps;
    `endif

    //set task svt_lpddr5_jedec_common::wait_for_cas_ws_fs_sync_off_timing() to correct CAS(WS_FS) Command Timing 
    //Jira P80002216-59805
    `LPDDR5_DRAM1.cfg.cfg_channel_a.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.cfg.cfg_channel_a.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.max_cas_ws_fs_to_first_data_cmd_delay = 200;
    `endif


    // Memory Channel A Configuration
    `LPDDR5_DRAM1.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM1.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    $display("LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg: tinit3_ms = %0f .",`LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg.tinit3_ms);
    `LPDDR5_DRAM1.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM1.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM1.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end

    `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM2.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR5_DRAM2.cfg.cfg_channel_a.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM2.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end

    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM3.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM3.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR5_DRAM3.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM3.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM3.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM3.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end

    `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_transaction_reporting = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM4.cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_osc = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM4.cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM4.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end
    `endif

    // Memory Channel B Configuration
    `LPDDR5_DRAM1.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM1.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM1.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR5_DRAM1.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM1.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM1.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM1.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end

    `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM2.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM2.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM2.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end

    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM3.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM3.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR5_DRAM3.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM3.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM3.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM3.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end

    `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_memcore_xml_gen       = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_xact_xml_gen          = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_fsm_xml_gen           = 1;
    if(cfg.debug >=1) begin
    `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_transaction_reporting = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_transaction_tracing   = 1;
    end
    `LPDDR5_DRAM4.cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_osc = 1;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.dqs_osc_multi_val = 2;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.wck2dqi_osc_multi_val = 2;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.wck2dqo_osc_multi_val = 2;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_wck_osc_ck_cycle_output = 0;

    //`LPDDR5_DRAM4.cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 0ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500ps;
    `LPDDR5_DRAM4.cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500ps;

    if(cfg.skip_train == 1 || cfg.skip_train == 2) begin
    `LPDDR5_DRAM4.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end
    `endif

  `LPDDR5_DRAM1.cfg.save_prop_vals("lpddr5.cfg");

//`ifdef DWC_DDRPHY_NUM_DBYTES_4
//`ifdef RANK2
//     if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
//      `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_checks=00;
//      `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_checks=00;
//    end
//`endif
//`endif
//`ifdef DWC_DDRPHY_NUM_DBYTES_8
//    if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
//      `LPDDR5_DRAM2.cfg.cfg_channel_a.enable_checks=00;
//      `LPDDR5_DRAM2.cfg.cfg_channel_b.enable_checks=00;
//`ifdef RANK2
//      `LPDDR5_DRAM4.cfg.cfg_channel_a.enable_checks=00;
//      `LPDDR5_DRAM4.cfg.cfg_channel_b.enable_checks=00;
//`endif
//    end
//`endif
  endfunction

//--------------------------------------------------------------------------------
    // This checker has VIP issue, and will be fixed in 2017.09, should be re-enabled after fixed.
  function void set_invalid_mpc_cmd_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
    `endif

    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
    `endif

  endfunction

  function void set_reset_n_during_tinit1_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
    `endif
  endfunction

  function void set_static_wck_preamble_twckpre_static_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.static_wck_preamble_twckpre_static_check.set_is_enabled(value);
    `endif
  endfunction

  function void set_wck_toggle_before_wck2ck_sync_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.wck_toggle_before_wck2ck_sync_check.set_is_enabled(value);
    `endif
  endfunction

  function void set_zq_calib_stop_tzqoff_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.zq_calib_stop_tzqoff_check.set_is_enabled(value);
    `endif
  endfunction

  function void set_wck_postamble_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.wck_toggle_for_burst_length_duration_check.set_is_enabled(value);
    `endif

    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.wck_postamble_twckpst_check.set_is_enabled(value);
    `endif
  endfunction

  function void set_valid_ca_low_after_cs_low_tcscal_time_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.valid_ca_low_after_cs_low_tcscal_time_check.set_is_enabled(value);
    `endif

    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.exit_power_down_to_valid_command_delay_txp_check.set_is_enabled(value);
    `endif
  endfunction

  function void set_read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR5_DRAM3.agent.channel_a.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
      `LPDDR5_DRAM3.agent.channel_b.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_a.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
      `LPDDR5_DRAM4.agent.channel_b.monitor.checks.read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check.set_is_enabled(value);
    `endif
  endfunction
  function void set_data_not_rcvd_for_write_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.data_not_rcvd_for_write_check.set_is_enabled(value);
    `endif
  endfunction
  function void set_invalid_cmd_during_fsp_switching_time_tfc_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.invalid_cmd_during_fsp_switching_time_tfc_check.set_is_enabled(value);
    `endif  
  endfunction  
  function void set_ck_t_ck_c_invalid_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.ck_t_ck_c_invalid_check.set_is_enabled(value);
    `endif  
  endfunction
  function void set_ck_differential_mode_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.ck_differential_mode_check.set_is_enabled(value);
    `endif  
  endfunction
  function void set_invalid_cas_ws_off_during_sync_off_state_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.invalid_cas_ws_off_during_sync_off_state_check.set_is_enabled(value);
    `endif  
  endfunction
  function void set_data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.data_cmd_not_rcvd_within_max_delay_after_cas_ws_fs_check.set_is_enabled(value);
    `endif  
  endfunction
  function void set_burst_refresh_window_trefw_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.burst_refresh_window_trefw_check.set_is_enabled(value);
    `endif  
  endfunction
  function void set_average_time_between_all_bank_refresh_command_trefiab_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.average_time_between_all_bank_refresh_command_trefiab_check.set_is_enabled(value);
    `endif  
  endfunction

  function void set_average_time_between_per_bank_refresh_command_trefipb_check(bit value);
    `LPDDR5_DRAM1.agent.channel_a.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `LPDDR5_DRAM1.agent.channel_b.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_a.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `LPDDR5_DRAM2.agent.channel_b.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    `LPDDR5_DRAM3.agent.channel_a.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `LPDDR5_DRAM3.agent.channel_b.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_a.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `LPDDR5_DRAM4.agent.channel_b.monitor.checks.average_time_between_per_bank_refresh_command_trefipb_check.set_is_enabled(value);
    `endif  
  endfunction
  task automatic disable_checkers();
    $display("[%0t] <%m> disable_checkers", $time);
    #0;
    set_invalid_mpc_cmd_check(0);
    set_reset_n_during_tinit1_check(0);// Close tinit1 checker as fw_tb
    //-------------Need to confirm the reason of these chackers  with VIP team--------------//

    //-------------------------tZQOFF---------------------------------//
    /*
       UVM_ERROR @ 843799271838: uvmvlog_top.lpddr5_svt_if0.channel_b [register_fail:mpc_zqcal_group:LPDDR5:zq_calib_stop_tzqoff_check] Description: ZQ Stop bit in MR28 should be reset to 0 before tZQOFF time from its assertion to ensure proper functionality of ZQ Calibration, Reference: LPDDR5 JEDEC Spec. Section-Dual ZQ Calibration - ZQ Stop bit should be deasserted within tZQOFF time =50.000000us, to maintain accurate ZQ calbration,tzqstop got asserted at time =793.799271us
    */
    //if(cfg.Frequency[cfg.NumPStates - 1] < 67 )begin // Close these checkers when freq<67
      set_zq_calib_stop_tzqoff_check(0);//VIP will close this checker in P2019.06-2 release
    //end
//-------------------------tZQOFF---------------------------------//

//-------------------------WCK2CK Sync operation---------------------------------//
    //Workaround for UVM_ERROR 
    set_static_wck_preamble_twckpre_static_check(0); // Caused by glitch, this checker is modified at new VIP version.
    `ifdef PUB_VERSION_LT_0105
      set_ck_t_ck_c_invalid_check(0); //mantis 0059133
      set_ck_differential_mode_check(0);  //JIRA P80001562-71457
    `endif
    `ifdef PUB_200A
      set_ck_t_ck_c_invalid_check(0); //mantis 0059133
      set_ck_differential_mode_check(0);  //JIRA P80001562-85014
    `endif

    //set_wck_postamble_check(0);
    //set_valid_ca_low_after_cs_low_tcscal_time_check(0);//Waite PHYINIT confirm in mantis: 0048884
    //set_read_rd_fifo_or_rd_dq_cal_to_mrw_delay_check(0);// Wait PIE stabilization

//-------------------------WCK2CK Sync operation---------------------------------//
	
//-------------------------LPDDR5 Training---------------------------------------//	
	//Workaround for UVM_ERROR from FW TB
	`ifdef TRAINING_MODE
    set_data_not_rcvd_for_write_check(0);
	set_invalid_cmd_during_fsp_switching_time_tfc_check(0);
  set_invalid_cas_ws_off_during_sync_off_state_check(0);  //M0058487 - Spec ambiguous. Iijima-San confirmed w/ vendors the PIE behavior is legal.
  //close as fw tb does
  set_average_time_between_all_bank_refresh_command_trefiab_check(0);
  set_average_time_between_per_bank_refresh_command_trefipb_check(0);
  set_burst_refresh_window_trefw_check(0);
	`endif
    //-------------Need to confirm the reason of these checkers  with VIP team--------------//
  endtask
`ifdef TRAINING_MODE  
  always @(posedge top.dfi0.clk) begin
	  wait(top.dfi0_init_complete);
      set_data_not_rcvd_for_write_check(1);
      set_invalid_cas_ws_off_during_sync_off_state_check(1);
      set_average_time_between_all_bank_refresh_command_trefiab_check(1);
      set_average_time_between_per_bank_refresh_command_trefipb_check(1);
      set_burst_refresh_window_trefw_check(1);
  end
`endif
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
//          `LPDDR5_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR5_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//
//          `LPDDR5_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});  
//          `LPDDR5_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//          `LPDDR5_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR5_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//          `LPDDR5_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR5_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//          `ifdef DWC_DDRPHY_NUM_CHANNELS_2
//          `LPDDR5_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR5_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//          `LPDDR5_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR5_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//          `LPDDR5_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR5_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//          `LPDDR5_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank,14'h30,col+j}, {bank,14'h30,col+j});
//          `LPDDR5_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data, {bank+3'b1,14'h30,col+j}, {bank+3'b1,14'h30,col+j});
//          `endif
//         //$display("write to addr=%h is data=%h, @ %0t",{bank,14'h30,col+j},data, $time);
//      end
//      col=col+16;
//    end
//    `endif
       `LPDDR5_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
       `LPDDR5_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
       `LPDDR5_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
       `LPDDR5_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
      `ifdef DWC_DDRPHY_NUM_CHANNELS_2
       `LPDDR5_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
       `LPDDR5_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
       `LPDDR5_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
       `LPDDR5_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST,0,0,max_addr);
     `endif
  endtask


