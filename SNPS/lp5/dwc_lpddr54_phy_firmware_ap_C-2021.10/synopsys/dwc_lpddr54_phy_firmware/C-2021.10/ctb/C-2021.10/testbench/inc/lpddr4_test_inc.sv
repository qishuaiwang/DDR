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
    catalog_file = {`CTB_DW_HOME,"/vip/svt/lpddr_svt/latest/catalog/lpddr4C/dram/JEDEC/jedec_lpddr4C_2G_x16_4267_0_468.cfg"};
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

  `ifndef WARM_RESET_MODE
    disable_checkers();
  `endif

  end

//after add warm_reset, dram wrong detect cmd mrw_1,cause to invalid_command_combination_recieved_check
//occor error in vip2018.12.This issue fixed in vip2019.12
  always@(posedge top.clk_rst_drv.reset )begin
        //#0.1;
        #1;
        set_invalid_command_combination_recieved_check(0);
        set_invalid_command_in_idle_state_check(0);
        set_power_down_exit_command_in_non_power_down_states_check(0); 
  end
   
  function void do_lpddr_config();

  `ifndef DWC_DDRPHY_NUM_CHANNELS_2
    //`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.load_prop_vals(catalog_file));
      void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.load_prop_vals(catalog_file));
      `ifdef RANK2
        void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.load_prop_vals(catalog_file));
        void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.load_prop_vals(catalog_file));
      `endif//RANK2
    //`endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    //`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    //  void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    //  void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.load_prop_vals(catalog_file));
    //  `ifdef RANK2
    //    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.load_prop_vals(catalog_file));
    //    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.load_prop_vals(catalog_file));
    //  `endif//RANK2
    //`endif//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `else//DWC_DDRPHY_NUM_CHANNELS_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.load_prop_vals(catalog_file));
      void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.load_prop_vals(catalog_file));
      `ifdef RANK2
        void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.load_prop_vals(catalog_file));
        void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.load_prop_vals(catalog_file));
      `endif//RANK2
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
      void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.load_prop_vals(catalog_file));
      void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.load_prop_vals(catalog_file));
      void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.load_prop_vals(catalog_file));
      void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.load_prop_vals(catalog_file));
      `ifdef RANK2
        void'(`LPDDR4_DRAM3.cfg.cfg_channel_a.load_prop_vals(catalog_file));
        void'(`LPDDR4_DRAM3.cfg.cfg_channel_b.load_prop_vals(catalog_file));
        void'(`LPDDR4_DRAM4.cfg.cfg_channel_a.load_prop_vals(catalog_file));
        void'(`LPDDR4_DRAM4.cfg.cfg_channel_b.load_prop_vals(catalog_file));
      `endif//RANK2
    `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `endif//DWC_DDRPHY_NUM_CHANNELS
  
//  // Configuration FSP for PState1 before dev_init by backdoor
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM1.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
//`ifdef RANK2
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_a.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b00,svt_lpddr_mode_register::MR_FSP_WR);
//    void'(`LPDDR4_DRAM2.cfg.cfg_channel_b.mode_register_cfg.set_mr_field(2'b01,svt_lpddr_mode_register::MR_FSP_OP);
//`endif
//`endif
//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
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
//-----------------------------------------------------------
//Cloase checker about warmreset
//-----------------------------------------------------------  
	  `ifdef WARM_RESET_MODE
      $display("<%m> Before warmreset, LPDDR4_DRAM1.cfg.cfg_channel_a.enable_checks=%0d",`LPDDR4_DRAM1.cfg.cfg_channel_a.enable_checks);
      $display("<%m> Before warmreset, LPDDR4_DRAM1.cfg.cfg_channel_b.enable_checks=%0d",`LPDDR4_DRAM1.cfg.cfg_channel_b.enable_checks);
      `LPDDR4_DRAM1.cfg.cfg_channel_a.enable_checks=0;
      `LPDDR4_DRAM1.cfg.cfg_channel_b.enable_checks=0;
      `ifdef RANK2    
        `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_checks=0;
        `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_checks=0;
      `endif
      $display("<%m> Close checkers during warmreset, LPDDR4_DRAM1.cfg_channel_a.cfg.enable_checks=%0d",`LPDDR4_DRAM1.cfg.cfg_channel_a.enable_checks);
      $display("<%m> Close checkers during warmreset, LPDDR4_DRAM1.cfg_channel_b.cfg.enable_checks=%0d",`LPDDR4_DRAM1.cfg.cfg_channel_b.enable_checks);
	  `endif
//-----------------------------------------------------------
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
    if(cfg.skip_train != 0) begin
    `LPDDR4_DRAM1.cfg.cfg_channel_a.bypass_initialization=1'b1;
    end
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
    if(cfg.skip_train != 0) begin
    `LPDDR4_DRAM1.cfg.cfg_channel_b.bypass_initialization=1'b1;
    end

  `ifndef DWC_DDRPHY_NUM_CHANNELS_2
    //`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
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
        if(cfg.skip_train != 0) begin
        `LPDDR4_DRAM2.cfg.cfg_channel_a.bypass_initialization=1'b1;
        end

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
        if(cfg.skip_train != 0) begin
        `LPDDR4_DRAM2.cfg.cfg_channel_b.bypass_initialization=1'b1;
        end

        if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
         `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_checks=00;
         `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_checks=00;
        end
      `endif//RANK2
    //`endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    //`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    //  `ifdef RANK2
    //  `endif//RANK2
    //`endif//`ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `else//DWC_DDRPHY_NUM_CHANNELS_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
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
        if(cfg.skip_train != 0) begin
        `LPDDR4_DRAM2.cfg.cfg_channel_b.bypass_initialization=1'b1;
        end

        if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
         `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_checks=00;
         `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_checks=00;
        end

      `endif//RANK2
    `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
    `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4

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
        if(cfg.skip_train != 0) begin
        `LPDDR4_DRAM2.cfg.cfg_channel_a.bypass_initialization=1'b1;
        end

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
        if(cfg.skip_train != 0) begin
        `LPDDR4_DRAM2.cfg.cfg_channel_b.bypass_initialization=1'b1;
        end

        if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
         `LPDDR4_DRAM2.cfg.cfg_channel_a.enable_checks=00;
         `LPDDR4_DRAM2.cfg.cfg_channel_b.enable_checks=00;
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
        if(cfg.skip_train != 0) begin
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
        if(cfg.skip_train != 0) begin
        `LPDDR4_DRAM4.cfg.cfg_channel_a.bypass_initialization=1'b1;
        end

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
        if(cfg.skip_train != 0) begin
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
        if(cfg.skip_train != 0) begin
        `LPDDR4_DRAM4.cfg.cfg_channel_b.bypass_initialization=1'b1;
        end

        if((cfg.NumRank_dfi0==1) && (cfg.NumRank_dfi1==1)) begin
          `LPDDR4_DRAM4.cfg.cfg_channel_a.enable_checks=00;
          `LPDDR4_DRAM4.cfg.cfg_channel_b.enable_checks=00;
        end

      `endif//RANK2
    `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
  `endif//DWC_DDRPHY_NUM_CHANNELS

  `LPDDR4_DRAM1.cfg.save_prop_vals("lpddr4.cfg");

  endfunction

//--------------------------------------------------------------------------------
    // This checker has VIP issue, and will be fixed in 2017.09, should be re-enabled after fixed.
  function void set_invalid_mpc_cmd_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.invalid_cmd_rcvd_within_two_cycles_after_mpc_cmd_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_invalid_tCSCKE_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.cs_remain_low_tcscke_bfr_pwr_down_entry_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_invalid_tCKELCS_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.invalid_command_after_cke_low_tckelcs_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_invalid_tCSCKEH_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.invalid_command_before_cke_high_tcsckeh_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_ca_invalid_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.ca_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.ca_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_invalid_command_combination_recieved_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.invalid_command_combination_recieved_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_wr_mwr_cmd_wdqs_on_time_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.wr_mwr_cmd_wdqs_on_time_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

   function void set_invalid_command_in_idle_state_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.invalid_command_in_idle_state_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction
  
   function void set_power_down_exit_command_in_non_power_down_states_check(bit value);
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.power_down_exit_command_in_non_power_down_states_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_dmi_is_invalid_check(bit value);// Close for cfg that unsupport dmi
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2dmi_is_invalid_check
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.dmi_is_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

    function void set_cke_invalid_check(bit value);// When channelB is off disabling this check.
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.cke_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_no_refresh_recieved_within_9_trefi_check(bit value);// Close for full training cases
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2dmi_is_invalid_check
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.no_refresh_recieved_within_9_trefi_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_more_refreshes_postponed_check(bit value);// Close for full training cases
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2dmi_is_invalid_check
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.more_refreshes_postponed_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

  function void set_reset_n_during_tinit1_check(bit value);// Close for full training cases
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2dmi_is_invalid_check
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.reset_n_during_tinit1_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction

 function void set_dq_is_invalid_check(bit value);// Close for full training cases
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2dmi_is_invalid_check
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM2.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM2.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM1.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `LPDDR4_DRAM2.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `ifdef RANK2
          `LPDDR4_DRAM3.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM3.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_a.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
          `LPDDR4_DRAM4.agent.channel_b.monitor.checks.dq_is_invalid_check.set_is_enabled(value);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS
  endfunction


  always @(posedge top.dfi0.clk) begin
    wait(top.dfi0_init_complete);
    // Close for full training and devinit tests
    set_no_refresh_recieved_within_9_trefi_check(1);
    set_reset_n_during_tinit1_check(1);
    set_dq_is_invalid_check(1);
  end

  task automatic disable_checkers();
    #0;
    //set_invalid_mpc_cmd_check(0);
//--------------------------------------------------------------------------------
    // This checker has PHY issue, which should be re-enabled after fixed.
    set_invalid_tCSCKE_check(0);
    set_invalid_tCKELCS_check(0);
    set_invalid_tCSCKEH_check(0);
    `ifndef WDQSEXT
      set_wr_mwr_cmd_wdqs_on_time_check(0);
    `endif
    `ifndef DWC_DDRPHY_DBYTE_DMI_ENABLED
      set_dmi_is_invalid_check(0);
    `endif

    if(cfg.skip_train != 1) begin // Close for full training and devinit cases
      set_no_refresh_recieved_within_9_trefi_check(0);
      set_more_refreshes_postponed_check(0);
      set_reset_n_during_tinit1_check(0);
      set_dq_is_invalid_check(0);
    end
    `ifdef DFI_MODE1
      set_cke_invalid_check(0);
    `endif
//--------------------------------------------------------------------------------
  endtask

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
    `ifndef DWC_DDRPHY_NUM_CHANNELS_2
      `LPDDR4_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
      `LPDDR4_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);  
      `ifdef RANK2
        `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
      `endif//RANK2
    `else//DWC_DDRPHY_NUM_CHANNELS_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `LPDDR4_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
      `LPDDR4_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);  
        `ifdef RANK2
          `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `endif//RANK2
      `endif //DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2
      `ifdef DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
        `LPDDR4_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `LPDDR4_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);  
        `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `ifdef RANK2
          `LPDDR4_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
          `LPDDR4_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, 0,0, max_addr);
        `endif//RANK2
      `endif//DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4
    `endif//DWC_DDRPHY_NUM_CHANNELS

  endtask


