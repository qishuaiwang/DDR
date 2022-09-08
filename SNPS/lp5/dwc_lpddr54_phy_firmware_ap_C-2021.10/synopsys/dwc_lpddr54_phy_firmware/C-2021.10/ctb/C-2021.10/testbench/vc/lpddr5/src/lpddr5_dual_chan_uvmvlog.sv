//=======================================================================
// COPYRIGHT (C) 2014 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------
module lpddr5_dual_chan_uvmvlog #(
    parameter string name = "lpddr5_dual_chan_uvmvlog",
    parameter string idx = "0"
  )
  (
//-----------------------------------------------------------------------
// LPDDR Interface Signals
//-----------------------------------------------------------------------

  /** 
   * Clock signal :All Double Data Rate (DDR) CA inputs are
   * sampled on both positive and negative edge of ck_t.
   */
  input logic ck_t_a,
  input logic ck_t_b,

  /** 
   * Complementary clock signal of ck_t : The positive clock edge is defined 
   * by the crosspoint of a rising ck_t and a falling ck_c. The negative 
   * clock edge is defined by the crosspoint of a falling ck_t and a rising CK_c.
   */
  input logic ck_c_a,
  input logic ck_c_b,

  /** 
   * Clock signal :All Double Data Rate (DDR) DQ inputs are
   * sampled on both positive and negative edge of wck_t.
   */
  input logic [(`SVT_LPDDR5_MAX_WCK_WIDTH-1):0] wck_t_a,
  input logic [(`SVT_LPDDR5_MAX_WCK_WIDTH-1):0] wck_t_b,

  /** 
   * Complementary clock signal of wck_t : The positive clock edge is defined 
   * by the crosspoint of a rising wck_t and a falling wck_c. The negative 
   * clock edge is defined by the crosspoint of a falling wck_t and a rising wck_c.
   */
  input logic [(`SVT_LPDDR5_MAX_WCK_WIDTH-1):0] wck_c_a,
  input logic [(`SVT_LPDDR5_MAX_WCK_WIDTH-1):0] wck_c_b,
  
  /** 
   * Chip Select (Active High): part of the command code. This is valid for LPDDR4/LPDDR5 
   * only and should be left unconnected in case of LPDDR2/3. 
   * cs_p is the input signal.
   */
  input logic cs_p_a,
  input logic cs_p_b,

   /** 
   * Command/Address Inputs: Uni-directional command/address bus inputs.
   * In case of LPDDR5, only connect ca[6:0] and the remaining should be
   * left unconnected.
   * CA is considered part of the command code.
   */
  input logic [(`SVT_LPDDR5_CA_WIDTH-1):0] ca_a,
  input logic [(`SVT_LPDDR5_CA_WIDTH-1):0] ca_b,
    
  /** 
   * Reset : This signal when asserted LOW, resets the device. This is valid 
   * for LPDDR4/LPDDR5 only and should be left unconnected in case of LPDDR2/3.
   * Reset_n is input signal.
   */
  input logic reset_n,
  
  /** 
   * Calibration Reference: This signal is used to calibrate the output driver 
   * strength and termination resistance. This is valid for LPDDR4/LPDDR5 only and 
   * should be left unconnected in case of LPDDR2/3.
   * ZQ is input signal.
   */
  input logic zq,
  
  /** 
   * RDQS_t Input/Output. 
   */
  inout wire  [(`SVT_LPDDR5_MAX_RDQS_WIDTH-1):0] rdqs_t_a,
  inout wire  [(`SVT_LPDDR5_MAX_RDQS_WIDTH-1):0] rdqs_t_b,

  /** 
   * RDQS_c Input/Output. 
   */
  inout wire  [(`SVT_LPDDR5_MAX_RDQS_WIDTH-1):0] rdqs_c_a,
  inout wire  [(`SVT_LPDDR5_MAX_RDQS_WIDTH-1):0] rdqs_c_b,

  /** 
   * Data Inputs/Output: Bi-directional data bus. 
   */
  inout wire  [(`SVT_LPDDR5_MAX_DQ_WIDTH-1):0] dq_a,
  inout wire  [(`SVT_LPDDR5_MAX_DQ_WIDTH-1):0] dq_b,

  /** 
   * Data Mask/Data Bus Inversion Input/Output: Bi-directional data mask or
   * data bus inversion. This is valid for LPDDR4/LPDDR5 only and should be left 
   * unconnected in case of LPDDR2/3. 
   */
  inout wire  [(`SVT_LPDDR5_MAX_DMI_WIDTH-1):0] dmi_a,
  inout wire  [(`SVT_LPDDR5_MAX_DMI_WIDTH-1):0] dmi_b

  );

/////////////////////////////////////////////////
// Import Packages
`include "uvm_macros.svh"
  import uvm_pkg::*;
  import svt_uvm_pkg::*;
  import svt_mem_uvm_pkg::*;
  import svt_lpddr_full_uvm_pkg::*;

/////////////////////////////////////////////////

// Connect Interface signals
svt_lpddr5_dual_chan_jedec_chip_if memory_if (
  .ck_t_a    (ck_t_a),
  .ck_t_b    (ck_t_b),
  .ck_c_a    (ck_c_a),
  .ck_c_b    (ck_c_b),
  .wck_t_a   (wck_t_a),
  .wck_t_b   (wck_t_b),
  .wck_c_a   (wck_c_a),
  .wck_c_b   (wck_c_b),
  .cs_p_a    (cs_p_a),
  .cs_p_b    (cs_p_b),
  .ca_a      (ca_a),
  .ca_b      (ca_b),
  .rdqs_t_a  (rdqs_t_a),
  .rdqs_t_b  (rdqs_t_b),
  .rdqs_c_a  (rdqs_c_a),
  .rdqs_c_b  (rdqs_c_b),
  .dq_a      (dq_a),
  .dq_b      (dq_b),
  .dmi_a     (dmi_a),
  .dmi_b     (dmi_b),
  
  .reset_n   (reset_n),
  .zq        (zq)
);

// DDR Memory Component
  //
typedef class lpddr5_dram_root_callback;

  int  agent_id = uvmvlog_pkg::add_component(name);

  string                      agent_name;

  svt_lpddr5_configuration    cfg;
  svt_lpddr5_env              agent;
  svt_mem_core                mem_core_a;
  svt_mem_core                mem_core_b;
  svt_mem_backdoor            mem_backdoor_a;
  svt_mem_backdoor            mem_backdoor_b;

  initial begin
    agent_name = uvmvlog_pkg::get_component_name(name, agent_id, $sformatf("%m"));
    uvmvlog_pkg::wait_for_state(uvmvlog_pkg::S_INIT);

    // Configulation
    cfg           = new({agent_name, "_cfg"});
    cfg.lpddr5_dual_chan_jedec_chip_vif = memory_if;

    //cfg.cfg_channel_a.timing_cfg.set_scaled_initialization_timings();
    //$display("cfg.cfg_channel_a.timing_cfg: tinit3_ms = %0f .",cfg.cfg_channel_a.timing_cfg.tinit3_ms);
    //cfg.cfg_channel_b.timing_cfg.set_scaled_initialization_timings();
    cfg.cfg_channel_a.timing_cfg.tinit0_ms = 20;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tinit0_ms = 20;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_a.timing_cfg.tinit1_us = 1;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tinit1_us = 1;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_a.timing_cfg.tinit2_ck = 5;   //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tinit2_ck = 5;   //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_a.timing_cfg.tinit3_ms = 0.00001;//Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tinit3_ms = 0.00001;//Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_a.timing_cfg.tinit4_us = 0.01;   //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tinit4_us = 0.01;   //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_a.timing_cfg.tinit5_us = 0.0001;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tinit5_us = 0.0001;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps = 1500;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tdqsck_min_ps = 1500;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps = 1500;  //Overriding this parameter as we are not folling tinit1 timing
    cfg.cfg_channel_b.timing_cfg.tdqsck_max_ps = 1500;  //Overriding this parameter as we are not folling tinit1 timing
    //uvmtb_pkg::tdqsck_min_ps_c0_r0 = cfg.cfg_channel_a.timing_cfg.tdqsck_min_ps; //RR
    //uvmtb_pkg::tdqsck_max_ps_c0_r0 = cfg.cfg_channel_a.timing_cfg.tdqsck_max_ps; //RR
    cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps = 200;
    cfg.cfg_channel_b.timing_cfg.tdqs2dq_ps = 200;
    //uvmtb_pkg::tdqs2dq_ps_c0_r0 = cfg.cfg_channel_a.timing_cfg.tdqs2dq_ps; //RR
    cfg.cfg_channel_a.timing_cfg.twckdqi_ps = 500;//abby 
    cfg.cfg_channel_b.timing_cfg.twckdqi_ps = 500;
    //uvmtb_pkg::twckdqi_ps_c0_r0 = cfg.cfg_channel_a.timing_cfg.twckdqi_ps;
    cfg.cfg_channel_a.timing_cfg.twckdqo_ps = 1000;//abby 
    cfg.cfg_channel_b.timing_cfg.twckdqo_ps = 1000;
    //uvmtb_pkg::twckdqo_ps_c0_r0 = cfg.cfg_channel_a.timing_cfg.twckdqo_ps;
    cfg.cfg_channel_a.enable_osc = 1;
    cfg.cfg_channel_b.enable_osc = 1;
    cfg.cfg_channel_a.dqs_osc_multi_val = 2;
    cfg.cfg_channel_b.dqs_osc_multi_val = 2;
    cfg.cfg_channel_a.update_tdqsck_after_rl = 1'b1;
    cfg.cfg_channel_b.update_tdqsck_after_rl = 1'b1;

    cfg.cfg_channel_a.vip_type                     = svt_lpddr_type::LPDDR5;
    cfg.cfg_channel_b.vip_type                     = svt_lpddr_type::LPDDR5;

    uvm_config_db#(svt_lpddr5_configuration)::set(
        uvmvlog_pkg::uvmvlog_top, agent_name, "cfg", cfg);

    // Create an Agent
    agent = svt_lpddr5_env::type_id::create(agent_name, uvmvlog_pkg::uvmvlog_top);
     // Register a callback
    begin
      lpddr5_dram_root_callback  lpddr5_dram_root_cb = new($psprintf("lpddr5_dram_root_cb_%s",idx));

      uvm_callbacks #(uvmvlog_pkg::uvmvlog_root, uvmvlog_pkg::uvmvlog_root_callback)::add(
                      uvmvlog_pkg::uvmvlog_top,  lpddr5_dram_root_cb);
    end
    uvmvlog_pkg::config_done(name, agent_id);
  end

   // Phase Callback : set mem_core and mem_backdoor at end_of_elaboration phase
  //
  class lpddr5_dram_root_callback extends uvmvlog_pkg::uvmvlog_root_callback;

    function new(string name);
      super.new(name);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_component component); 
      mem_core_a     = agent.channel_a.mem_sequencer.m_get_core();
      mem_core_b     = agent.channel_b.mem_sequencer.m_get_core();
      mem_backdoor_a = agent.channel_a.mem_sequencer.get_backdoor();
      mem_backdoor_b = agent.channel_b.mem_sequencer.get_backdoor();
    endfunction
  endclass


endmodule
