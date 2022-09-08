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
`include "uvmvlog_macros.svh"

package uvmvlog_pkg;
  import uvm_pkg::*;

`include "uvm_macros.svh"

  string pkg_name = "uvmvlog_pkg";
  
  typedef enum {
    S_IDLE,
    S_INIT,
    S_INIT_DONE,
    S_RUN,
    S_STOP_REQ,
    S_STOP
  } state_t;
  
  state_t  m_state = S_IDLE;

  function automatic void state_set(state_t __state);
    m_state = __state;
    `uvm_info(pkg_name, $sformatf("state = %s", m_state.name()), UVM_HIGH);
  endfunction

  task automatic wait_for_state(state_t __state);
    wait(m_state == __state);
  endtask

  int  m_children_id[string];
  int  m_children_count = 0;
  int  m_children_init_done_count = 0;

  /////////////////////////////////////////////////////////
  // uvmvlog root callback class
  //
  class uvmvlog_root_callback extends uvm_callback;
    function new(string name = "uvmvlog_root_callback");
      super.new(name);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_component component); endfunction
  endclass

  /////////////////////////////////////////////////////////
  // uvmvlog root class
  //
  class uvmvlog_root extends uvm_test;
    `uvm_component_utils(uvmvlog_root)
    `uvm_register_cb(uvmvlog_root, uvmvlog_root_callback);

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual function void start_of_simulation(); 
       uvm_report_server srvr = uvm_report_server::get_server();
       `ifndef SVT_UVM_12_OR_HIGHER
       srvr.enable_report_id_count_summary = 0; 
       `endif  
    endfunction 

    virtual function void end_of_elaboration_phase(uvm_phase phase);
      `uvm_do_callbacks(uvmvlog_root, uvmvlog_root_callback, 
                        end_of_elaboration_phase(this));
    endfunction

    virtual task run_phase(uvm_phase phase);
      uvm_root top = uvm_root::get();

      state_set(S_RUN);

      if (!top.has_child("uvm_test_top")) begin
        phase.raise_objection(this);

        wait_for_state(S_STOP_REQ);

        phase.drop_objection(this);
        state_set(S_STOP);
      end
    endtask

  endclass

  uvmvlog_root uvmvlog_top = new("uvmvlog_top", uvm_root::get());

  /////////////////////////////////////////////////////////
  // Global tasks for TESTs
  //
  //   UVMvlog package provides user interface for using uvm vips
  //  wrapped by verilog module. User need to follow follwing 
  //  usage in user test module.
  //
  //  initial begin
  //    uvmvlog_pkg::init();   // 1) Initialize VIPs
  //      <Do Configuration>   // 2) Do configuration VIPs
  //    uvmvlog_pkg::start();  // 3) Start UVM VIPs
  //      <Do Test>            // 4) Do test
  //    uvmvlog_pkg::stop();   // 5) Stop UVM VIPs
  //  end

  int unsigned  _init_count = 0;  //  _init_count and _start_count values cannot be checked 
  int unsigned  _start_count = 0; // before UVM build phase. Checked in end of start task.

  function void check_init_start_count();
    if (_init_count >= 2) begin  // Init count check
      `uvm_error(pkg_name,
        $sformatf("Do not call uvmvlog_pkg::init() multiple times.(count = %0d)", _init_count))
    end

    if (_start_count >= 2) begin  // Start count check. 
      `uvm_error(pkg_name,
        $sformatf("Do not call uvmvlog_pkg::start() multiple times.(count = %0d)", _start_count))
    end
  endfunction

  // Initialization
  task automatic init();
    `uvm_info(pkg_name, "init() entered.", UVM_MEDIUM);
    _init_count++;
    state_set(S_INIT);

    for (int i = 0; i < 1000; i++) begin
      #0;
      if (m_children_count == m_children_init_done_count) begin
        state_set(S_INIT_DONE);
        return;
      end
    end
    `uvm_info(pkg_name, "init() exiting.", UVM_MEDIUM);
  endtask

  // Run 
  task automatic run();
    uvm_root top = uvm_root::get();

    repeat(2) #0;

    if (!top.has_child("uvm_test_top")) begin
      run_test();
    end
    else begin
      `uvm_info(pkg_name, "uvm_pkg::run_test has already called.", UVM_MEDIUM);
    end
  endtask

  // Start UVM VIPs
  task automatic start();
    `uvm_info(pkg_name, "start() entered.", UVM_MEDIUM);

    _start_count++;

    fork
      run();
    join_none
    #0;
    wait_for_state(S_RUN);

    check_init_start_count();

    `uvm_info(pkg_name, "start() exiting.", UVM_MEDIUM);
  endtask



  // Stop UVM VIPs
  function automatic void stop();
    `uvm_info(pkg_name, "stop() entered.", UVM_MEDIUM);
    state_set(S_STOP_REQ);
  endfunction

  /////////////////////////////////////////////////////////
  // For VIP modules
  //

  // Add component
  function automatic int add_component(string name);
    m_children_count++;
    if(m_children_id.exists(name)) begin
      m_children_id[name]++;
      `uvm_warning(pkg_name,
        $sformatf("Component (%s) is registered multiply. (count = %0d)", name,  m_children_id[name]))
    end
    else begin
      m_children_id[name] = 0;
    end
    `uvm_info(pkg_name,
              $sformatf("add_component(name = %s, id = %0d)", name, m_children_id[name]),
              UVM_HIGH);
    return  m_children_id[name];
  endfunction

  // Get component name
  function automatic string get_component_name(string name, int id, string heir);
    string  component_name;
    
    component_name = name;
    if (id != 0) begin
      component_name = {name, $sformatf("_%0d", id)};
      `uvm_warning(pkg_name, 
        $sformatf("Component name (%s) of the %s is changed to (%s).", name, heir, component_name))
    end
    return component_name;
  endfunction

  // Config done
  function automatic config_done(string name, int id);
    `uvm_info(pkg_name,
              $sformatf("config_done(name = %s, id = %0d)", name, id),
              UVM_HIGH);
    m_children_init_done_count++;
  endfunction

endpackage
