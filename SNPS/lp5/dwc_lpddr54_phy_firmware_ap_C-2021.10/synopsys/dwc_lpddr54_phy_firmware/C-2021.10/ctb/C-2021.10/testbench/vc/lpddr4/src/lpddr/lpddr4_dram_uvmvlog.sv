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
module lpddr4_dram_uvmvlog #(
    parameter string name = "lpddr4_dram_uvmvlog"
  )
  (
    input                                       RESET_n,

    input                                       CK_t_a,
    input                                       CK_c_a,
    input                                       CKE_a,
    input                                       CS_a,
    input [(6-1):0]                             CA_a,
    input                                       ODT_a,
    inout [(2-1):0]                             DQS_t_a,
    inout [(2-1):0]                             DQS_c_a,
    inout [(16-1):0]                            DQ_a,
    inout [(2-1):0]                             DMI_a,

    input                                       CK_t_b,
    input                                       CK_c_b,
    input                                       CKE_b,
    input                                       CS_b,
    input [(6-1):0]                             CA_b,
    input                                       ODT_b,
    inout [(2-1):0]                             DQS_t_b,
    inout [(2-1):0]                             DQS_c_b,
    inout [(16-1):0]                            DQ_b,
    inout [(2-1):0]                             DMI_b
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

  // Unconnected interface instance 
  wire zq_unconn;

   svt_lpddr4_jedec_chip_if memory_if  (
     .reset_n  (RESET_n),
     .zq       (zq_unconn),

     .ck_t_a   (CK_t_a),
     .ck_c_a   (CK_c_a),
     .cke_a    (CKE_a),
     .cs_p_a   (CS_a),
     .ca_a     (CA_a),
     .odt_a    (ODT_a),
     .dqs_t_a  (DQS_t_a),
     .dqs_c_a  (DQS_c_a),
     .dq_a     (DQ_a),
     .dmi_a    (DMI_a),

     .ck_t_b   (CK_t_b),
     .ck_c_b   (CK_c_b),
     .cke_b    (CKE_b),
     .cs_p_b   (CS_b),
     .ca_b     (CA_b),
     .odt_b    (ODT_b),
     .dqs_t_b  (DQS_t_b),
     .dqs_c_b  (DQS_c_b),
     .dq_b     (DQ_b),
     .dmi_b    (DMI_b)
   );

  ////////////////////////////////////////////////////////////////////////////
  //
  // DDR Memory Component
  //
typedef class lpddr4_dram_root_callback;

  int  agent_id = uvmvlog_pkg::add_component(name);

  string                      agent_name;

  svt_lpddr4_configuration    cfg;
  svt_lpddr4_env              agent;
  svt_mem_core                mem_core_a;
  svt_mem_core                mem_core_b;
  svt_mem_backdoor            mem_backdoor_a;
  svt_mem_backdoor            mem_backdoor_b;

  initial begin
    agent_name = uvmvlog_pkg::get_component_name(name, agent_id, $sformatf("%m"));

    uvmvlog_pkg::wait_for_state(uvmvlog_pkg::S_INIT);

    // Configulation
    cfg           = new({agent_name, "_cfg"});
    cfg.lpddr4_jedec_chip_vif = memory_if;

    cfg.cfg_channel_a.vip_type                     = svt_lpddr_type::LPDDR4;
    cfg.cfg_channel_a.enable_trefi_event_debug     = 1'b1;
    //cfg.cfg_channel_a.enable_ref_prepone_postpone_checks     = 1'b0;
    cfg.cfg_channel_a.bypass_initialization        = 1'b0;
    cfg.cfg_channel_a.enable_memcore_xml_gen       = 1'b0;
    cfg.cfg_channel_a.enable_xact_xml_gen          = 1'b0;
    cfg.cfg_channel_a.enable_fsm_xml_gen           = 1'b0;
    cfg.cfg_channel_a.enable_cfg_xml_gen           = 1'b0;
    cfg.cfg_channel_a.enable_transaction_tracing   = 1'b0;
    cfg.cfg_channel_a.enable_transaction_reporting = 1'b0;
    cfg.cfg_channel_a.enable_cov                   = 5'b00000;

    cfg.cfg_channel_b.vip_type                     = svt_lpddr_type::LPDDR4;
    cfg.cfg_channel_b.enable_trefi_event_debug     = 1'b1;
    //cfg.cfg_channel_b.enable_ref_prepone_postpone_checks     = 1'b0;
    cfg.cfg_channel_b.bypass_initialization        = 1'b0;
    cfg.cfg_channel_b.enable_memcore_xml_gen       = 1'b0;
    cfg.cfg_channel_b.enable_xact_xml_gen          = 1'b0;
    cfg.cfg_channel_b.enable_fsm_xml_gen           = 1'b0;
    cfg.cfg_channel_b.enable_cfg_xml_gen           = 1'b0;
    cfg.cfg_channel_b.enable_transaction_tracing   = 1'b0;
    cfg.cfg_channel_b.enable_transaction_reporting = 1'b0;
    cfg.cfg_channel_b.enable_cov                   = 5'b00000;

    uvm_config_db#(svt_lpddr4_configuration)::set(
        uvmvlog_pkg::uvmvlog_top, agent_name, "cfg", cfg);

    // Create an Agent
    agent = svt_lpddr4_env::type_id::create(agent_name, uvmvlog_pkg::uvmvlog_top);

    // Register a callback
    begin
      lpddr4_dram_root_callback  lpddr4_dram_root_cb = new("lpddr4_dram_root_cb");

      uvm_callbacks #(uvmvlog_pkg::uvmvlog_root, uvmvlog_pkg::uvmvlog_root_callback)::add(
                      uvmvlog_pkg::uvmvlog_top,  lpddr4_dram_root_cb);
    end

    uvmvlog_pkg::config_done(name, agent_id);
  end

  //
  // Phase Callback : set mem_core and mem_backdoor at end_of_elaboration phase
  //
  class lpddr4_dram_root_callback extends uvmvlog_pkg::uvmvlog_root_callback;

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

  ////////////////////////////////////////////////////////////////////////////
  // Debug commands
  //

  ////////////////////////////////////////////////////////////////////////////
  // Debug status
  //

//  ////////////////////////////////////////////////////////////////////////////
//  // Memory Tasks
//  //
//  // Word Write
//  function automatic mem_word_write(input longint unsigned  addr,
//                                    input logic [`SVT_MEM_MAX_DATA_WIDTH-1:0] data,
//                                    input logic [`SVT_MEM_MAX_DATA_WIDTH/8-1:0] wstrb = '1);
//    int unsigned    data_width;
//    svt_mem_data_t  rdata;
//    svt_mem_data_t  mask;
//    svt_mem_data_t  wdata;
//
//    data_width = mem_backdoor.get_data_width();
//    wdata = '0;
//    if (data_width < 8) begin
//      if (wstrb[0]) begin
//        void'(mem_backdoor.poke(addr, 4'hf & data));
//      end
//    end
//    else begin
//      void'(mem_backdoor.peek(addr, rdata));
//      for (int i = 0; i < data_width/8; i++) begin
//        mask = 1024'hff << (i*8);
//        wdata |= wstrb[i] ? (mask & data) : (mask & rdata);
//      end
//      void'(mem_backdoor.poke(addr, wdata));
//    end
//  endfunction
//
//  // Word Read
//  function automatic void mem_word_read(input  longint unsigned  addr, 
//                                        output logic [`SVT_MEM_MAX_DATA_WIDTH-1:0] data);
//    void'(mem_backdoor.peek(addr, data));
//  endfunction
//
//  // Byte Write
//  function automatic mem_byte_write(input longint unsigned  addr,
//                                    input logic [7:0]       byte_data);
//    int unsigned      data_width;
//    longint unsigned  word_addr;
//    longint unsigned  addr_base;
//    int               byte_offset;
//    logic [`SVT_MEM_MAX_DATA_WIDTH-1:0] word_data;
//    logic [`SVT_MEM_MAX_DATA_WIDTH/8-1:0] wstrb;
//
//    data_width = mem_backdoor.get_data_width();
//    if (data_width == 4) begin
//      word_addr    = addr * 2;
//      mem_word_write(word_addr  ,  'h0f & byte_data, 1'b1);
//      mem_word_write(word_addr+1, ('hf0 & byte_data) >> 4, 1'b1);
//    end
//    else begin
//      word_addr    = addr / (data_width/8);
//      addr_base    = word_addr * (cfg.data_width/8);
//      byte_offset  = addr - addr_base;
//      wstrb        = 1 << byte_offset;
//      word_data    = byte_data << (byte_offset*8);
//
//      mem_word_write(word_addr, word_data, wstrb);
//    end
//  endfunction
//
//  // Byte Read
//  function automatic void mem_byte_read(input  longint unsigned  addr, 
//                                        output logic [7:0] byte_data);
//    int unsigned      data_width;
//    longint unsigned  word_addr;
//    longint unsigned  addr_base;
//    int               byte_offset;
//    logic [`SVT_MEM_MAX_DATA_WIDTH-1:0] word_data0;
//    logic [`SVT_MEM_MAX_DATA_WIDTH-1:0] word_data1;
//    
//    data_width  = mem_backdoor.get_data_width();
//    if (data_width == 4) begin
//      word_addr    = addr * 2;
//      mem_word_read(word_addr,   word_data0);
//      mem_word_read(word_addr+1, word_data1);
//      byte_data =  ('hf0 & (word_data1 << 4))| ('h0f & word_data0);
//    end
//    else begin
//      word_addr   = addr / (data_width/8);
//      addr_base   = word_addr * (cfg.data_width/8);
//      byte_offset = addr - addr_base;
//      mem_word_read(word_addr, word_data0);
//      byte_data = 'hff & (word_data0 >> (byte_offset*8));
//    end
//  endfunction
//
//  //
//  // Dump
//  //
//  function automatic void mem_dump(longint unsigned  byte_addr,
//                                   longint unsigned  length);
//    longint unsigned dump_start_addr = byte_addr & 'hffff_ffff_ffff_fff0;
//    longint unsigned end_addr = byte_addr + length;
//    logic [7:0] rdata[16];
//
//    $write("-------------------------------------------------------------\n");
//    $write("[%s] address   : 0f -- 0c 0b -- 08 07 -- 04 03 -- 00", agent_name);
//    for (longint unsigned i = dump_start_addr; i < end_addr; i += 16) begin
//      for (int j = 0; j < 16; j++) begin
//        mem_byte_read(i + j, rdata[j]);
//      end
//
//      $write("\n[%s] 0x%08h:", agent_name, i);
//      $write(" %08h", {rdata[15], rdata[14], rdata[13], rdata[12]});
//      $write(" %08h", {rdata[11], rdata[10], rdata[ 9], rdata[ 8]});
//      $write(" %08h", {rdata[ 7], rdata[ 6], rdata[ 5], rdata[ 4]});
//      $write(" %08h", {rdata[ 3], rdata[ 2], rdata[ 1], rdata[ 0]});
//    end
//    $write("\n");
//    $write("-------------------------------------------------------------\n");
//  endfunction
//

// The user-specified defines (if any) for adding tasks
`ifdef LPDDR4_DRAM_UVMVLOG_INCLUDE_USER_CODES
`include "lpddr4_dram_uvmvlog_user_codes.sv"
`endif // LPDDR4_DRAM_UVMVLOG_INCLUDE_USER_CODES

endmodule

