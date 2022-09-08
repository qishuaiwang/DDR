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
module lpddr4_1ch_dram_uvmvlog #(
    parameter string name = "lpddr4_1ch_dram_uvmvlog"
  )
  (
    input                                       CK_t,
    input                                       CK_c,
    input                                       CKE,

    input                                       CS,
    input                                       ODT,
    input                                       RESET_n,
    input [(`SVT_LPDDR_CA_WIDTH-1):0]           CA,
    input [(`SVT_LPDDR_MAX_DQS_WIDTH-1):0]      DQS_t,
    input [(`SVT_LPDDR_MAX_DQS_WIDTH-1):0]      DQS_c,
    input [(`SVT_LPDDR_MAX_DQ_WIDTH-1):0]       DQ,
    inout [(`SVT_LPDDR4_MAX_DMI_WIDTH-1):0]     DMI
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
  wire cs_n_unconn;
  wire zq_unconn;
  wire [(`SVT_LPDDR_MAX_DM_WIDTH-1):0]   dm_unconn;

  svt_lpddr_jedec_chip_if memory_if (
    .ck_t    (CK_t),
    .ck_c    (CK_c),
    .cke     (CKE),
    .cs_n    (cs_n_unconn),
    .odt     (ODT),
    .ca      (CA),
    .dqs_t   (DQS_t),
    .dqs_c   (DQS_c),
    .dq      (DQ),
    .dm      (dm_unconn),
    .cs_p    (CS),
    .reset_n (RESET_n),
    .zq      (zq_unconn),
    .dmi     (DMI)
  );
 
  ////////////////////////////////////////////////////////////////////////////
  //
  // DDR Memory Component
  //
  typedef class lpddr4_dram_root_callback;

  int  agent_id = uvmvlog_pkg::add_component(name);

  string                      agent_name;

  svt_lpddr_configuration     cfg;
  svt_lpddr_agent             agent;
  svt_mem_core                mem_core;
  svt_mem_backdoor            mem_backdoor;

  initial begin
    agent_name = uvmvlog_pkg::get_component_name(name, agent_id, $sformatf("%m"));

    uvmvlog_pkg::wait_for_state(uvmvlog_pkg::S_INIT);

    // Configulation
    cfg           = new({agent_name, "_cfg"});
    cfg.vip_type  = svt_lpddr_type::LPDDR4;
    cfg.bypass_initialization        = 1'b0;

    cfg.enable_memcore_xml_gen       = 1'b0;
    cfg.enable_xact_xml_gen          = 1'b0;
    cfg.enable_fsm_xml_gen           = 1'b0;
    cfg.enable_cfg_xml_gen           = 1'b0;
    cfg.enable_transaction_tracing   = 1'b0;
    cfg.enable_transaction_reporting = 1'b0;

    cfg.enable_cov                   = 5'b00000;

    uvm_config_db#(svt_lpddr_configuration)::set(
        uvmvlog_pkg::uvmvlog_top, agent_name, "cfg", cfg);

    uvm_config_db#(svt_lpddr_jedec_chip_vif)::set(uvmvlog_pkg::uvmvlog_top,
      agent_name, "jedec_chip_vif", memory_if);

    // Create an Agent
    agent = svt_lpddr_agent::type_id::create(agent_name, uvmvlog_pkg::uvmvlog_top);

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
      mem_core     = agent.mem_sequencer.m_get_core();
      mem_backdoor = agent.mem_sequencer.get_backdoor();
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

