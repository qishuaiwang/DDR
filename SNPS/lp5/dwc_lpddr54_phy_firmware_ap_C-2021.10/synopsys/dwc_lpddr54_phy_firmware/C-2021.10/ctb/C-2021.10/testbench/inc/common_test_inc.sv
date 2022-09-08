import uvm_pkg::*;

`ifdef LP5_STD
`define DWC_DDRPHY_DFI_ADDRESS_WIDTH  7
`else 
`define DWC_DDRPHY_DFI_ADDRESS_WIDTH  `DWC_DDRPHY_DFI0_ADDRESS_WIDTH
`endif

//-------------------------------------------------------------------------
// shared include
//-------------------------------------------------------------------------
`ifdef DDR4_UDIMM
  `include "ddr4_udimm_test_inc.sv"
`elsif DDR4_RDIMM
  `include "ddr4_rdimm_test_inc.sv"
`elsif DDR4_LRDIMM
  `include "ddr4_lrdimm_test_inc.sv"
`elsif DDR3_UDIMM
  `include "ddr3_udimm_test_inc.sv"
`elsif DDR3_RDIMM
  `include "ddr3_rdimm_test_inc.sv"
`elsif LPDDR4
  `include "lpddr4_test_inc.sv"
//`elsif LPDDR4X
//  `include "lpddr4x_test_inc.sv"
`elsif LPDDR4X
  `include "lpddr4_test_inc.sv"
`elsif LPDDR5
  `include "lpddr5_test_inc.sv"
`elsif LPDDR3
  `include "lpddr3_test_inc.sv"
`endif
// include phyinit output
chandle phyctx; //Define phyctx for apb_config.sv
`include "apb_config.sv"
// top module instantiation
`ifdef PREFIX_OPT_ENABLE
  `include "dwc_ddrphy_top_unprefix.vh"
`endif
`ifdef QUICKBOOT  
  `include "msgBlk_quickboot.sv"
  `include "csr_defines_quickboot.sv"
`endif

`define CEIL(dividend,divisor) (dividend/divisor + 1)

int tb_error_count;
int tb_error_limit=5;
int checker_error_count;
int checker_error_limit=1000000;
int Watchdog=0;
int data_id = 0;
int bubble_num;
int b2bnum;
`ifdef LP5_STD
int burst_per_col = 16; //Max num of WR is 16 in one column
`else
int burst_per_col=32;
`endif
reg [3:0]   rank=4'b1110;
reg [3:0]   bank=4'b0000;
reg [2:0]   bg=3'b000;
reg [16:0]  row = 17'h30;
reg [9:0]   col = 10'h70;
bit [3:0]   rank_b2b[4];
bit [2:0]   bg_b2b[4];
bit [2:0]   bank_b2b[8];
bit [9:0]   col_b2b[4];
int tDQSCK  ; 
int tDQS2DQ ; 
int tCK     ;
int DQSCK   ;
int DQS2DQ  ;
int wtr     ;
int tWTR    ;
int tWCK2DQO;
int same_wr2wr_tCCD ; // Fixed BL 16
int same_rd2rd_tCCD ; // Fixed BL 16
int same_rd2wr_tCCD ; // RL + tDQSCK/tCK + BL/2 + tRPST - WL + tWPRE, pUserInputAdvanced->WDQSExt = 0x0000     ;
int same_wr2rd_tCCD ; // WL + 1 + BL/2 + tWTR/tCK + 1(if tWPST = 1.5tCK), pUserInputAdvanced->WDQSExt = 0x0000 ;



`ifdef DWC_DDRPHY_HWEMUL
bit tb_pass_flag =1'b0;
bit [15:0] RxClkT2UIDly_prog_data;
bit [15:0] RxClkT2UIDly_default;
bit [2:0] RxClkT2UIDly_core;
bit [2:0] RxClkT2UIDly_fine_cnt = 1 ;
bit [7:0] RxClkT2UIDly_PROG_TOTAL_NUM = 1 ;
bit [0:0] RxClkT2UIDly_core_plus = 1'b1 ;
bit [31:0] csr_RxClkC2UIDly_addr = 32'h10012;
bit [31:0] csr_RxClkC2UIDly_addr_base = 32'h10012;
bit [31:0] csr_RxClkC2UIDly_addr_r = 32'h0;
bit [31:0] csr_RxClkC2UIDly_addr_t = 32'h0;
bit [31:0] csr_RxClkC2UIDly_addr_d = 32'h0;
bit [31:0] csr_RxClkT2UIDly_addr = 32'h10010;
bit [31:0] csr_RxClkT2UIDly_addr_base = 32'h10010;
bit [31:0] csr_RxClkT2UIDly_addr_r = 32'h0;
bit [31:0] csr_RxClkT2UIDly_addr_t = 32'h0;
bit [31:0] csr_RxClkT2UIDly_addr_d = 32'h0;
`endif

event finish_ev;

reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] DATA[17000];
reg [`DWC_DDRPHY_NUM_DBYTES-1:0] DATA_DM[17000];
reg [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] ADDR[16];
bit W_DM,W_DBI,R_DBI;
int init_bubble;
int init_b2b_num=2;
reg [7:0] int8;

reg [71:0]              acsm_sram_quickboot[1024];
bit                     NeverGateAcCsrClock_quickboot;
bit [2:0]               csrUcclkFull;
bit                     ucClkFull;
bit                     quickboot_flag = 0;
phy_csr_state_checker   phy_csr_state_chk;
bit                     phy_csr_state_checker_run;
//--------------------------------------------------------------------------------
task automatic apb_wr;
input [31:0] addr;
input [15:0] data;
  `ifdef DWC_DDRPHY_JTAG
  top.jtag.write (addr,data);
  `else
  top.apb.write (addr,data);
  `endif
endtask

//--------------------------------------------------------------------------------
task automatic apb_rd;
input [31:0] addr;
output [15:0] data;
  `ifdef DWC_DDRPHY_JTAG
  top.jtag.read (addr,data);
  `else
  top.apb.read (addr,data);
  `endif
endtask

// -------------------------------------------------------------------------------
// Error task: register an error in the environemnt
// -------------------------------------------------------------------------------
task automatic error;
begin
  tb_error_count++;
  if (tb_error_count == tb_error_limit) finish_test;
end
endtask

// ---------------------------------------------------------------
// Write simulation status to external .status file
// ---------------------------------------------------------------
parameter [1:0] FAIL=2, ERROR=1, PASS=0;
task automatic write_status;
input [1:0] status;
integer file;
begin
  file = $fopen(".status");
  $fdisplay(file,"%0d",status);
  $fclose(file);
end
endtask


// ---------------------------------------------------------------
// Finish_test: exit simualtion, write to status file.
// ---------------------------------------------------------------
task automatic finish_test;
begin
  -> finish_ev;
// Check for data comparison errors in the dfi_data_drv component
  $display("-------------------------------------------------------");
  `ifndef ATE_TEST
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      if (top.dfi0.compare_error || top.dfi1.compare_error) begin
    `else
      if (top.dfi0.compare_error) begin
    `endif
        `ifndef DWC_DDRPHY_HWEMUL     // for rd rxen training
          $display("TC ERROR: test failed, wrong data received");
        `else
          $display("TC INFO: test need re-training for emulation case!!");
        `endif
        write_status(ERROR);
      end
  else 
  `endif
   if (tb_error_count > 0) begin
    `ifdef ATE_TEST
     $display("TC ERROR: test failed");
     write_status(ERROR);
    `else
     $display("TC ERROR: test failed: JEDEC Protocol Violation, UVM_ERROR messages found");
     write_status(ERROR);
    `endif
   end  
   else if (checker_error_count > 0) begin
    $display("TC ERROR: test failed: Checker error found");
    write_status(ERROR);
   end
  else begin
    $display("TC INFO: test passed");
    `ifdef DWC_DDRPHY_HWEMUL
      tb_pass_flag = 1'b1;
      $display("Emul program pass:DfiFreqRatio[0]=%0d, Frequency[0]=%0d, RxClkT2UIDly_prog_data=%h RxClkT2UIDly_PROG_TOTAL_NUM=%d ",cfg.DfiFreqRatio[0],cfg.Frequency[0],RxClkT2UIDly_prog_data,RxClkT2UIDly_PROG_TOTAL_NUM);
    `endif
    write_status(PASS);
  end
  $display("-------------------------------------------------------");
  $display("Watchdog=%0d",Watchdog);

  `ifdef GLITCH_CHECK
    $fclose(top.glitch_checker_insts.log_file);
  `endif

  `ifndef DWC_DDRPHY_HWEMUL    
    $finish;
  `else    // for rd rxen training  DWC_DDRPHY_HWEMUL
    if(tb_pass_flag === 1'b0 ) begin
      $display("cust_csr_prog need reprogram !!!! RxClkT2UIDly_fine_cnt=%d, RxClkT2UIDly_prog_data=%h RxClkT2UIDly_PROG_TOTAL_NUM=%d %t" ,RxClkT2UIDly_fine_cnt,RxClkT2UIDly_prog_data,RxClkT2UIDly_PROG_TOTAL_NUM,$realtime,);
      cust_csr_for_emul_reprog();  //reprogram RxClkT2UIDlyTg0 
      `ifdef DWC_DDRPHY_NUM_CHANNELS_2
        top.dfi0.compare_error=0;
        top.dfi1.compare_error=0;
      `else
        top.dfi0.compare_error=0;
      `endif
    end else if(tb_pass_flag == 1'b1)      $finish;
  `endif
end
endtask

//-------------------------------------------------------------------------
// Waveform management
//-------------------------------------------------------------------------
string wave_name_vpd  = "test.vpd";
string wave_name_fsdb = "test.fsdb";
string wave_name_vcd  = "test.vcd";
typedef enum bit [3:0]{NORMAL=4'b0000, DFI_LP_DATA=4'b0001, DFI_LP_CTRL=4'b0010, DFI_LP_CLK_DIS=4'b0011, LP2=4'b0100, LP3=4'b0101, IO_RETENTION=4'b0110, IDLE=4'b0111, B2B_WRITE=4'b1000, B2B_READ=4'b1001} lp_state;
lp_state ddrphy_lp_state;
event checkpoint_level0;
event checkpoint_level1;
event checkpoint_level2;

`ifdef DDRPHY_POWERSIM 
initial begin
  ddrphy_lp_state = 4'b0000;
  fork
    `ifdef DFI_LP_DATA
    forever begin
      wait(test.top.dut.dfi0_lp_data_ack==1);
      ddrphy_lp_state = 4'b0001;
      wait(test.top.dut.dfi0_lp_data_ack==0);
      ddrphy_lp_state = 4'b0000;
    end
    `endif
    `ifdef DFI_LP_CTRL
    forever begin
      wait(test.top.dut.dfi0_lp_ctrl_ack==1);
      ddrphy_lp_state = 4'b0010;
      wait(test.top.dut.dfi0_lp_ctrl_ack==0);
      ddrphy_lp_state = 4'b0000;
    end
    `endif
    `ifdef DFI_LP_CTRL_CLK_DISABLE
    forever begin
      wait((test.top.dut.dfi0_lp_ctrl_ack==1)||(test.top.dut.dfi0_lp_data_ack==1));
      ddrphy_lp_state = 4'b0011;
      wait((test.top.dut.dfi0_lp_ctrl_ack==0)&&(test.top.dut.dfi0_lp_data_ack==0));
      ddrphy_lp_state = 4'b0000;
    end
    `endif
    `ifdef FREQ_CHANGE
    forever begin
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==1) ;
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_complete==1);
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==0) ;
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==1) ;
      ddrphy_lp_state = 4'b0100;
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==0) ;
      ddrphy_lp_state = 4'b0000;
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==1) ;
      ddrphy_lp_state = 4'b0100;
      wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==0) ;
      ddrphy_lp_state = 4'b0000;
    end
    `endif
    `ifdef RET_EN
    forever begin
      wait((test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==1)&&(test.top.dfi0_frequency[4:0]==5'h1f));
      ddrphy_lp_state = 4'b0110;
      wait((test.top.vdd==0)&&(test.top.vddq==0));
      $display("dump_point:@ %0t enter LP3/IO_retention ", $time);
      wait((test.top.vdd==1)&&(test.top.vddq==1));
      $display("dump_point:@ %0t exit LP3/IO_retention ", $time);
      wait(test.top.BP_RET==0);
      $display("dump_point:@ %0t LP3/IO_retention exit done", $time);
      ddrphy_lp_state = 4'b0000;
    end
    `endif
    `ifdef POWERSIM_DEVICE_IDLE
    forever begin
      `ifdef RANK2   
        wait((test.top.BP_DFI0_CA[7]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30)); 
      `else
        wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
      `endif
      ddrphy_lp_state = 4'b0111;
      wait(test.top.BP_DFI0_CA[5:0]==6'h3f);
      ddrphy_lp_state = 4'b0000;
    end
    `endif
    `ifdef DDRPHY_B2B_WR
    forever begin
      wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[4:0]==5'h4));
      ddrphy_lp_state = 4'b1000;
      `ifdef RANK2   
        wait((test.top.BP_DFI0_CA[7]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30)); 
      `else
        wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
      `endif
      ddrphy_lp_state = 4'b0111;
      wait(test.top.BP_DFI0_CA[5:0]==6'h3f);
      ddrphy_lp_state = 4'b0000;
    end
    `endif
    `ifdef DDRPHY_B2B_RD
    forever begin
      wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[4:0]==5'h2));
      ddrphy_lp_state = 4'b1001;
      `ifdef RANK2   
        wait((test.top.BP_DFI0_CA[7]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30)); 
      `else
        wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
      `endif
      ddrphy_lp_state = 4'b0111;
      wait(test.top.BP_DFI0_CA[5:0]==6'h3f);
      ddrphy_lp_state = 4'b0000;
    end
    `endif
  join
end
`endif

`ifndef SAVE_RESTART_CHECKPOINT
initial begin
`ifdef VPD
  $vcdplusfile(wave_name_vpd);
  $vcdpluson();
`ifdef VPD_MEM
  $vcdplusmemon();
`endif
`endif
`ifdef FSDB
  `ifdef DWC_DDRPHY_GATESIM
    `ifdef SPLIT_FSDB
      $fsdbAutoSwitchDumpfile(1000,wave_name_fsdb,100);
    `else
      $fsdbDumpfile(wave_name_fsdb);
    `endif
  `else
    $fsdbDumpfile(wave_name_fsdb);
  `endif
  $fsdbDumpvars(0,"+all");
`endif
`ifdef VCD
  `ifndef DDRPHY_POWERSIM  
  $dumpfile(wave_name_vcd);
  $dumpvars();
  `else
    `ifdef DFI_LP_CTRL_CLK_DISABLE
    wait((test.top.dut.dfi0_lp_ctrl_ack==1)||(test.top.dut.dfi0_lp_data_ack==1));
    $display("dump_point:@ %0t dfi ctrl&data low power request acknowledged", $time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
    wait((test.top.dut.dfi0_lp_ctrl_ack==0)&&(test.top.dut.dfi0_lp_data_ack==0));
    $display("dump_point:@ %0t dfi ctrl&data low power exit", $time);
    $dumpoff;

    `elsif DFI_LP_DATA
    wait(test.top.dut.dfi0_lp_data_ack==1);
    $display("dump_point:@ %0t dfi data low power request acknowledged", $time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
    wait(test.top.dut.dfi0_lp_data_ack==0);
    $display("dump_point:@ %0t dfi data low power exit", $time);
    $dumpoff;

    `elsif DFI_LP_CTRL
    wait(test.top.dut.dfi0_lp_ctrl_ack==1);
    $display("dump_point:@ %0t dfi ctrl low power request acknowledged", $time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
    wait(test.top.dut.dfi0_lp_ctrl_ack==0);
    $display("dump_point:@ %0t dfi ctrl low power exit", $time);
    $dumpoff;

    `elsif FREQ_CHANGE
    wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==1) ;
    $display("dump_point:@ %0t dfi_init_start 1st assert for dfi initiation start ",$time);
    wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_complete==1);
    $display("dump_point:@ %0t dfi_init_complete 1st assert for dfi initiation done ",$time);
    wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==0) ;
    wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==1) ;
    $display("dump_point:@ %0t dfi_init_start 2st assert for dfi freq change start ",$time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
    wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==0) ;
    $display("dump_point:@ %0t dfi_init_start 2st deassert and LP2 exit",$time);
    $dumpoff;

    `elsif RET_EN
    wait((test.top.dut.u_DWC_ddrphy_pub.ac_0.dfi_init_start==1)&&(test.top.dfi0_frequency[4:0]==5'h1f));
    $display("dump_point:@ %0t dfi_init_start assert for dfi freq change to enter LP3", $time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
    wait((test.top.vdd==0)&&(test.top.vddq==0));
    $display("dump_point:@ %0t enter LP3/IO_retention ", $time);
    wait((test.top.vdd==1)&&(test.top.vddq==1));
    $display("dump_point:@ %0t exit LP3/IO_retention ", $time);
    wait(test.top.BP_RET==0);
    $display("dump_point:@ %0t LP3/IO_retention exit done", $time);
    $dumpoff;

    `elsif POWERSIM_DEVICE_IDLE
      `ifdef RANK2   
        `ifdef LPDDR4
          wait((test.top.BP_DFI0_CA[7]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
        `else
          wait((test.top.lpddr5_svt_if1.cs_p_a==1'b1)&&(test.top.lpddr5_svt_if1.ca_a[6:0]==7'h78));
        `endif 
      `else
        `ifdef LPDDR4
          wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
        `else
          wait((test.top.lpddr5_svt_if0.cs_p_a==1'b1)&&(test.top.lpddr5_svt_if0.ca_a[6:0]==7'h78));
        `endif 
      `endif
    $display("dump_point:@ %0t precharge to all banks operation executed,go to idle", $time);
    //wait(test.top.dut.u_DWC_ddrphy_pub.ac_1.AcOdtEn[0]==1'b0);
    //$display("dump_point:@ %0t, DBYTE&AC OdtEn clear", $time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
    `ifdef LPDDR4
      wait(test.top.BP_DFI0_CA[5:0]==6'h3f);
    `else
      wait(test.top.lpddr5_svt_if0.ca_a[6:0]==7'h7f);
    `endif
    $display("dump_point:@ %0t DES triggered", $time);
    $dumpoff;
    
    `elsif DDRPHY_B2B_WR
      `ifdef LPDDR4
        wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[4:0]==5'h4));
      `else
        wait((test.top.lpddr5_svt_if0.cs_p_a==1)&&(test.top.lpddr5_svt_if0.ca_a[6:0]==7'h76));
      `endif
    $display("dump_point:@ %0t write operation start", $time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
      `ifdef RANK2   
        `ifdef LPDDR4
          wait((test.top.BP_DFI0_CA[7]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
        `else
          wait((test.top.lpddr5_svt_if1.cs_p_a==1'b1)&&(test.top.lpddr5_svt_if1.ca_a[6:0]==7'h78));
        `endif 
      `else
        `ifdef LPDDR4
          wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
        `else
          wait((test.top.lpddr5_svt_if0.cs_p_a==1'b1)&&(test.top.lpddr5_svt_if0.ca_a[6:0]==7'h78));
        `endif 
      `endif
    $display("dump_point:@ %0t precharge to all banks operation executed", $time);
    $dumpoff;

    `elsif DDRPHY_B2B_RD
      `ifdef LPDDR4
        wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[4:0]==5'h2));
      `else
        wait((test.top.lpddr5_svt_if0.cs_p_a==1)&&(test.top.lpddr5_svt_if0.ca_a[6:0]==7'h71));
      `endif
    $display("dump_point:@ %0t read operation start", $time);
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
      `ifdef RANK2   
        `ifdef LPDDR4
          wait((test.top.BP_DFI0_CA[7]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
        `else
          wait((test.top.lpddr5_svt_if1.cs_p_a==1'b1)&&(test.top.lpddr5_svt_if1.ca_a[6:0]==7'h78));
        `endif 
      `else
        `ifdef LPDDR4
          wait((test.top.BP_DFI0_CA[6]==1)&&(test.top.BP_DFI0_CA[5:0]==6'h30));
        `else
          wait((test.top.lpddr5_svt_if0.cs_p_a==1'b1)&&(test.top.lpddr5_svt_if0.ca_a[6:0]==7'h78));
        `endif 
      `endif
    $display("dump_point:@ %0t precharge to all banks operation executed", $time);
    $dumpoff;

    `else
    $dumpfile(wave_name_vcd);
    $dumpvars(0, test.top);
    `endif
  `endif
`endif
end
`else
initial begin
  fork
    begin
    @(posedge test.top.dut.PwrOkIn);
    $display("checkpoint_level2 pre-condition occur");
    ->checkpoint_level2; 
    end
    begin
    @(negedge test.top.dut.u_DWC_ddrphy_pub.MRTUB.l4micro.csrStallToMicro); 
    $display("checkpoint_level1 pre-condition occur");
    ->checkpoint_level1; 
    end
    begin
    @(posedge test.top.dut.u_DWC_ddrphy_pub.dfi0_init_start); 
    $display("checkpoint_level0 pre-condition occur");
    ->checkpoint_level0; 
    end
  join
end
always@(checkpoint_level2) begin
  $display("Save checkpoint_level2 occur");
  $save("save1.chk");
  #0
  dump_checkpoint_wave;
end
always@(checkpoint_level1) begin
  $display("Save checkpoint_level1 occur");
  $save("save0.chk");
  #0
  dump_checkpoint_wave;
end
always@(checkpoint_level0) begin
  $display("Save checkpoint_level0 occur");
  $save("save.chk");
  #0
  dump_checkpoint_wave;
end
`endif

task dump_checkpoint_wave;
  string wave_name_vpd  = "test.vpd";
  string wave_name_fsdb = "test.fsdb";
  if($test$plusargs("dump_checkpoint")) begin
    `ifdef VPD
      $vcdplusfile(wave_name_vpd);
      $vcdpluson();
      `ifdef VPD_MEM
       $vcdplusmemon();
      `endif
    `endif
    `ifdef FSDB
      $fsdbDumpfile(wave_name_fsdb);
      $fsdbDumpvars(0,"+all");
    `endif	  
  end
endtask

// -------------------------------------------------------------------------------
// Error task: register an checker error in the environemnt
// -------------------------------------------------------------------------------
task automatic checker_error;
begin
  checker_error_count++;
  if (checker_error_count == checker_error_limit) finish_test;
end
endtask

//--------------------------------------------------------------------------------
// passes APB write transaction to the top.apb.write
//--------------------------------------------------------------------------------
task automatic dwc_ddrphy_apb_wr;
input [31:0] addr;
input [15:0] data;
  `ifdef DWC_DDRPHY_JTAG
  top.jtag.write (addr,data);
  `else
  top.apb.write (addr,data);
  `endif
endtask

//--------------------------------------------------------------------------------
// passes APB read transaction to the top.apb.read
//--------------------------------------------------------------------------------
task automatic dwc_ddrphy_apb_rd;
input [31:0] addr;
output [15:0] data;
  `ifdef DWC_DDRPHY_JTAG
  top.jtag.read (addr,data);
  `else
  top.apb.read (addr,data);
  `endif
endtask

//-------------------------------------------------------------------------
// Watchdog
//-------------------------------------------------------------------------
initial begin
  $display("[%0t] <%m> common_test_inc: initial begin for watchdog", $time);
  while(1) begin
    repeat(1000) @(posedge top.dfi_clk);
    Watchdog ++;
    if(Watchdog%100 == 0)
      $display($time, " <%m> Current Watchdog numbger is %d",Watchdog);
    if(Watchdog > cfg.Timeout) begin
      $display($time, " <%m> TC Error: Watchdog time out.");
      $finish;
    end
  end
  $display("[%0t] <%m> common_test_inc: initial end for watchdog", $time);
end


`ifndef ATE_TEST
initial begin
  $display("[%0t] <%m> common_test_inc: initial begin ifndef ATE_TEST", $time);
  for (int i=0; i<17000; i++) begin
   DATA[i] = i+31;
   DATA_DM[i] = i%4;
   //$display("genarated DATA[%0d]=%b, @ %0t",i,DATA[i], $time);
  end
  for (int i=0; i<16; i++) begin
   ADDR[i] =i;
  end
  `ifdef LP4_STD
     init_bubble=4;
   `elsif LP5_STD
     init_bubble=3;
   `endif
  $display("[%0t] <%m> common_test_inc: initial end ifndef ATE_TEST", $time);
end 


//-------------------------------------------------------------------------
// UVM catcher
//-------------------------------------------------------------------------
class cust_error_catcher extends uvm_report_catcher;
  `uvm_object_utils(cust_error_catcher)
  function new(string name="cust_error_catcher");
    super.new(name);
  endfunction :new
  
  bit error_enable = 1'b1;
 
  function pattern_match(string str1, str2);
    int l1, l2;
    l1 = str1.len();
    l2 = str2.len();
    pattern_match = 0 ;
    if(l2 > l1) begin
      return 0;
    end  
    for(int i = 0;i < l1-l2+1;i++) begin
      if(str1.substr(i,i+l2-1) == str2) begin
         return 1;
      end   
    end  
  endfunction       

  function action_e catch();
    if(get_severity() == UVM_ERROR) begin
      if (pattern_match(get_message(),"not in the range of allowed values for the selected speed bin")) 
        set_severity(UVM_WARNING);
      else if (pattern_match(get_message(),"The minimum time from CKE rising edge to a valid command (tXPR) is not satisfied")) 
        set_severity(UVM_WARNING);
      `ifdef PLL_BYPASS
      else if (pattern_match(get_message(),"DQS DQS# differental input high pulse width (tDQSH) is not within the range of tDQSH_min and tDQSH_max")) 
        set_severity(UVM_WARNING);
      `endif
      else begin 
        if (error_enable) begin
          $display("ERROR: %s",get_message()); 
          fork
            error;
          join_none
        end
      end
    end 
	if(get_severity() == UVM_WARNING) begin
	  if(pattern_match(get_message(),"Description: During WRITE if DBI function is disabled then DMI will be driven Z")) begin
	    //DFI VIP::svt_dfi_mc_transaction set bit instead of reg [(`SVT_DFI_DATA_ENABLE_WIDTH -1) : 0]  dm[], Z state can not send out from DFI VIP even if TB set Z state for DM
		set_severity(UVM_INFO);	  
		set_verbosity(UVM_HIGH);
	  end
	end
    return THROW; 
  endfunction 
endclass  

cust_error_catcher catcher; 

//-------------------------------------------------------------------------
// Skip unsupported override_c--Added by Cunming Shi
//-------------------------------------------------------------------------
`ifndef SKIP_UNSUPPORT_CHECK
string ParNam;
int ParVal;

task automatic unsupport;
    begin
    $display("CTB can not support %s = %0d",ParNam, ParVal); 
    $finish;
    end
endtask

initial begin
    #1;
    if(cfg.Train2D != 0) begin 
       ParNam = "Train2D"; ParVal = cfg.Train2D; unsupport; 
    end
    //if((cfg.DramType == CTB_DDR4 && ( cfg.NumDbyte < 3 || cfg.NumDbyte > 9 )) || 
    //   (cfg.DramType == CTB_LPDDR4 && ( cfg.NumDbyte != 2 && cfg.NumDbyte != 4 && cfg.NumDbyte != 8)) ||
    //   (cfg.DramType == CTB_LPDDR3 && ( cfg.NumDbyte != 4 && cfg.NumDbyte != 8))) begin
    //   ParNam = "NumDbyte"; ParVal = cfg.NumDbyte; unsupport; 
    //end
    //if((cfg.DramType == CTB_DDR4 && (cfg.NumAnib != 10 && cfg.NumAnib != 12)) || 
    //   (cfg.DramType == CTB_DDR3 && (cfg.NumAnib != 10 && cfg.NumAnib != 12)) ||
    //   (cfg.DramType == CTB_LPDDR4 && (cfg.NumAnib != 3 && cfg.NumAnib != 6 && cfg.NumAnib != 10 && cfg.NumAnib != 12)) ||
    //   (cfg.DramType == CTB_LPDDR3 && (cfg.NumAnib != 6 && cfg.NumAnib != 10 && cfg.NumAnib != 12))) begin
    //   ParNam = "NumAnib"; ParVal = cfg.NumAnib; unsupport; end
    if((cfg.DramType == CTB_LPDDR4 && cfg.NumRank_dfi0 != 1 && cfg.NumRank_dfi0 != 2 )) begin
       ParNam = "NumRank_dfi0"; ParVal = cfg.NumRank_dfi0; unsupport; 
    end
    if((cfg.DramType == CTB_DDR4 && cfg.NumRank_dfi1 != 0) ||
       (cfg.DramType == CTB_DDR3 && cfg.NumRank_dfi1 != 0) ||
       (cfg.DramType == CTB_LPDDR3 && cfg.NumRank_dfi1 != 0 && cfg.NumRank_dfi1 != 1 && cfg.NumRank_dfi1 != 2) ||
       (cfg.DramType == CTB_LPDDR4 && cfg.NumRank_dfi1 != 0 && cfg.NumRank_dfi1 != 1 && cfg.NumRank_dfi1 != 2)) begin
       ParNam = "NumRank_dfi1"; ParVal = cfg.NumRank_dfi1; unsupport; 
    end

    if(((cfg.DramType == CTB_DDR3)   && (cfg.Frequency[0] < 25 || cfg.Frequency[0] > 1067)) ||
       ((cfg.DramType == CTB_DDR4)   && (cfg.Frequency[0] < 25 || cfg.Frequency[0] > 1600)) ||
       ((cfg.DramType == CTB_LPDDR3) && (cfg.Frequency[0] < 25 || cfg.Frequency[0] > 1067)) ||
       ((cfg.DramType == CTB_LPDDR4) && (cfg.Frequency[0] < 25 || cfg.Frequency[0] > 2133))) begin 
       ParNam = "Frequency[0]"; ParVal = cfg.Frequency[0]; unsupport; 
    end
    if(cfg.NumPStates >= 2) begin
      if(((cfg.DramType == CTB_DDR3)   && (cfg.Frequency[1] < 25 || cfg.Frequency[1] > 1067)) ||
         ((cfg.DramType == CTB_DDR4)   && (cfg.Frequency[1] < 25 || cfg.Frequency[1] > 1600)) ||
         ((cfg.DramType == CTB_LPDDR3) && (cfg.Frequency[1] < 25 || cfg.Frequency[1] > 1067)) ||
         ((cfg.DramType == CTB_LPDDR4) && (cfg.Frequency[1] < 25 || cfg.Frequency[1] > 2133))) begin 
         ParNam = "Frequency[1]"; ParVal = cfg.Frequency[1]; unsupport; 
      end
    end
    if(cfg.NumPStates >= 3) begin
      if(((cfg.DramType == CTB_DDR3)   && (cfg.Frequency[2] < 25 || cfg.Frequency[2] > 1067)) ||
         ((cfg.DramType == CTB_DDR4)   && (cfg.Frequency[2] < 25 || cfg.Frequency[2] > 1600)) ||
         ((cfg.DramType == CTB_LPDDR3) && (cfg.Frequency[2] < 25 || cfg.Frequency[2] > 1067)) ||
         ((cfg.DramType == CTB_LPDDR4) && (cfg.Frequency[2] < 25 || cfg.Frequency[2] > 2133))) begin 
         ParNam = "Frequency[2]"; ParVal = cfg.Frequency[2]; unsupport; 
      end
    end
    if(cfg.NumPStates == 4) begin
      if(((cfg.DramType == CTB_DDR3)   && (cfg.Frequency[3] < 25 || cfg.Frequency[3] > 1067)) ||
         ((cfg.DramType == CTB_DDR4)   && (cfg.Frequency[3] < 25 || cfg.Frequency[3] > 1600)) ||
         ((cfg.DramType == CTB_LPDDR3) && (cfg.Frequency[3] < 25 || cfg.Frequency[3] > 1067)) ||
         ((cfg.DramType == CTB_LPDDR4) && (cfg.Frequency[3] < 25 || cfg.Frequency[3] > 2133))) begin 
         ParNam = "Frequency[3]"; ParVal = cfg.Frequency[3]; unsupport; 
      end
    end
    //Follow PllBypass checker LPDDR4 only
    `ifdef LP4_STD
      `ifndef DWC_DDRPHY_HWEMUL    
        if(((cfg.Frequency[0] >= 25) && (cfg.Frequency[0] < 333) && (cfg.PllBypass[0] == 0)) ||
           ((cfg.Frequency[0] > 533) && (cfg.PllBypass[0] == 1))) begin 
           ParNam = "PllBypass[0]"; ParVal = cfg.PllBypass[0]; unsupport; 
        end
        if(cfg.NumPStates >= 2) begin
          if(((cfg.Frequency[1] >= 25) && (cfg.Frequency[1] < 333) && (cfg.PllBypass[1] == 0)) ||
             ((cfg.Frequency[1] > 533) && (cfg.PllBypass[1] == 1))) begin 
             ParNam = "PllBypass[1]"; ParVal = cfg.PllBypass[1]; unsupport; 
          end
        end
      `endif
    `endif
          
 
    //if(cfg.PllBypass[0] != 0 || cfg.PllBypass[1] != 0 || cfg.PllBypass[2] != 0 || cfg.PllBypass[3] != 0) begin
    //   ParNam = "PllBypass"; ParVal = cfg.PllBypass[0]; unsupport; 
    //end
    //All DfiFreqRatio is supported.
    //if((cfg.DramType == CTB_DDR4 && cfg.Dfi1Exists != 0) ||
    //   (cfg.DramType == CTB_LPDDR4 && cfg.Dfi1Exists != 1)) begin
    //   ParNam = "Dfi1Exists"; ParVal = cfg.Dfi1Exists; unsupport; 
    //end
    //if((cfg.DramType == CTB_DDR4 && cfg.DfiMode != 5) ||
    //   (cfg.DramType == CTB_LPDDR4 && cfg.DfiMode != 3)) begin
    //if(cfg.DramType == CTB_LPDDR4 && cfg.DfiMode != 3) begin
    //   ParNam = "DfiMode"; ParVal = cfg.DfiMode; unsupport; 
    //end
    //if((cfg.DramType == CTB_DDR4 && (cfg.ReadDBIEnable[0] != 0 && cfg.ReadDBIEnable[0] != 1)) || 
    //   (cfg.DramType == CTB_LPDDR4 && cfg.ReadDBIEnable[0] != 0)) begin
   // if(cfg.ReadDBIEnable[0] != 0) begin 
   //    ParNam = "ReadDBIEnable[0]"; ParVal = cfg.ReadDBIEnable[0]; unsupport; 
   // end
   // if(cfg.ReadDBIEnable[1] != 0) begin 
   //    ParNam = "ReadDBIEnable[1]"; ParVal = cfg.ReadDBIEnable[1]; unsupport; 
   // end
   // if(cfg.ReadDBIEnable[2] != 0) begin 
   //    ParNam = "ReadDBIEnable[2]"; ParVal = cfg.ReadDBIEnable[2]; unsupport; 
   // end
   // if(cfg.ReadDBIEnable[3] != 0) begin 
   //    ParNam = "ReadDBIEnable[3]"; ParVal = cfg.ReadDBIEnable[3]; unsupport; 
   // end
    if((cfg.DramType == CTB_DDR4 && (cfg.DimmType == CTB_UDIMM || cfg.DimmType == CTB_RDIMM) && cfg.DramDataWidth != 8) ||
       (cfg.DramType == CTB_DDR3 && (cfg.DimmType == CTB_UDIMM || cfg.DimmType == CTB_RDIMM) && cfg.DramDataWidth != 8) ||
       (cfg.DramType == CTB_DDR4 && cfg.DimmType == CTB_LRDIMM && cfg.DramDataWidth != 4) ||
       (cfg.DramType == CTB_LPDDR4 && cfg.DimmType == CTB_LRDIMM && cfg.DramDataWidth != 16)) begin
       ParNam = "DramDataWidth"; ParVal = cfg.DramDataWidth; unsupport; 
    end
    //if(cfg.DramType == CTB_DDR3 && (cfg.DimmType != CTB_UDIMM ))begin
    //   ParNam = "DimmType";ParVal = cfg.DimmType;unsupport;
    //end
    if(cfg.DramByteSwap != 0) begin
       ParNam = "DramByteSwap"; ParVal = cfg.DramByteSwap; unsupport; 
    end
    //if((cfg.DramType == CTB_DDR4 && cfg.DisDynAdrTri[0] != 0) ||
    //   (cfg.DramType == CTB_LPDDR4 && cfg.DisDynAdrTri[0] != 1)) begin
    //   ParNam = "DisDynAdrTri[0]"; ParVal = cfg.DisDynAdrTri[0]; unsupport; 
    //end
    //if((cfg.DramType == CTB_DDR4 && cfg.DisDynAdrTri[1] != 0) ||
    //   (cfg.DramType == CTB_LPDDR4 && cfg.DisDynAdrTri[1] != 1)) begin
    //   ParNam = "DisDynAdrTri[1]"; ParVal = cfg.DisDynAdrTri[1]; unsupport; 
    //end
    //if((cfg.DramType == CTB_DDR4 && cfg.DisDynAdrTri[2] != 0) ||
    //   (cfg.DramType == CTB_LPDDR4 && cfg.DisDynAdrTri[2] != 1)) begin
    //   ParNam = "DisDynAdrTri[2]"; ParVal = cfg.DisDynAdrTri[2]; unsupport; 
    //end
    //if((cfg.DramType == CTB_DDR4 && cfg.DisDynAdrTri[3] != 0) ||
    //   (cfg.DramType == CTB_LPDDR4 && cfg.DisDynAdrTri[3] != 1)) begin
    //   ParNam = "DisDynAdrTri[3]"; ParVal = cfg.DisDynAdrTri[3]; unsupport; 
    //end
    if((cfg.DramType == CTB_DDR4 || cfg.DramType == CTB_DDR3 || cfg.DramType == CTB_LPDDR3) &&
       (cfg.Is2Ttiming[0] !=0 || cfg.Is2Ttiming[1] != 0 ||cfg.Is2Ttiming[2] !=0 || cfg.Is2Ttiming[3] != 0 )) begin
       ParNam = "Is2Ttiming"; ParVal = cfg.Is2Ttiming[0]; unsupport; 
    end
    if((cfg.DramType == CTB_DDR4 || cfg.DramType == CTB_DDR3)&& (cfg.DimmType == CTB_RDIMM || cfg.DimmType == CTB_LRDIMM) && cfg.CsMode != 0) begin
       ParNam = "CsMode"; ParVal = cfg.CsMode; unsupport; 
    end
    if(cfg.DramType == CTB_DDR4 && cfg.WDQSExt != 0) begin
       ParNam = "WDQSExt"; ParVal = cfg.WDQSExt; unsupport; 
    end
    //if((cfg.DramType == CTB_LPDDR4) && 
    //   (cfg.Lp4DbiRd[0] != 0 || cfg.Lp4DbiRd[1] != 0 || cfg.Lp4DbiRd[2] != 0 || cfg.Lp4DbiRd[3] != 0)) begin
    //   ParNam = "Lp4DbiRd"; ParVal = cfg.Lp4DbiRd[0]; unsupport; 
    //end
    if((cfg.DramType == CTB_LPDDR4) && 
       (cfg.Lp4DbiWr[0] != 0 || cfg.Lp4DbiWr[1] != 0 || cfg.Lp4DbiWr[2] != 0 || cfg.Lp4DbiWr[3] != 0)) begin
       ParNam = "Lp4DbiWr"; ParVal = cfg.Lp4DbiWr[0]; unsupport; 
    end
    if((cfg.DramType == CTB_LPDDR4) && 
       (cfg.Lp4WLS[0] != 0 || cfg.Lp4WLS[1] != 0 || cfg.Lp4WLS[2] != 0 || cfg.Lp4WLS[3] != 0)) begin
       ParNam = "Lp4WLS"; ParVal = cfg.Lp4WLS[0]; unsupport; 
    end

    //if(cfg.DramType == CTB_DDR4 && cfg.CsPresent != 1) begin
    //   ParNam = "CsPresent"; ParVal = cfg.CsPresent; unsupport; 
    //end
    //if(cfg.DramType == CTB_DDR4 && (cfg.AddrMirror!= 0 && cfg.AddrMirror != 10)) begin 
    //   ParNam = "AddrMirror"; ParVal = cfg.AddrMirror; unsupport; 
    //end
    if((cfg.DramType == CTB_DDR4) && (cfg.EnabledDQs != 0 && 
        cfg.EnabledDQs != 16 && cfg.EnabledDQs != 24 && cfg.EnabledDQs != 32 && 
        cfg.EnabledDQs != 40 && cfg.EnabledDQs != 48 && cfg.EnabledDQs != 56 &&
        cfg.EnabledDQs != 64 && cfg.EnabledDQs != 72)) begin
       ParNam = "EnabledDQs"; ParVal = cfg.EnabledDQs; unsupport; 
    end

    //if(cfg.DramType == CTB_DDR4 && cfg.CsSetupGDDec!= 0) begin
    //   ParNam = "CsSetupGDDec"; ParVal = cfg.CsSetupGDDec; unsupport; 
    //end
    if(cfg.DramType == CTB_DDR4 && 
      (cfg.ALT_CAS_L[0] != 0 || cfg.ALT_CAS_L[1] != 0 || cfg.ALT_CAS_L[2] != 0 || cfg.ALT_CAS_L[3] != 0)) begin
       ParNam = "ALT_CAS_L"; ParVal = cfg.ALT_CAS_L[0]; unsupport; 
    end
    if(cfg.DramType == CTB_DDR4 && 
      (cfg.ALT_WCAS_L[0] != 0 || cfg.ALT_WCAS_L[1] != 0 || cfg.ALT_WCAS_L[2] != 0 || cfg.ALT_WCAS_L[3] != 0)) begin
       ParNam = "ALT_WCAS_L"; ParVal = cfg.ALT_WCAS_L[0]; unsupport; 
    end
    if(cfg.DramType == CTB_LPDDR4 && cfg.X8Mode != 0) begin
       ParNam = "X8Mode"; ParVal = cfg.X8Mode; unsupport; 
    end

end
`endif

 //---------------------------------------------------------------------------------------
  string pmu_train_string[int];
  //---------------------------------------------------------------------------------------
  task automatic read_pmu_string_file;
    integer data_file;
    integer code;
    string line;
    string index_str;
    string message;
    int index;
    begin
      `ifdef QUICKBOOT
      if (quickboot_flag == 1)
        data_file = $fopen(debug_message_file_path_quickboot, "r");
      else
      `endif
        data_file = $fopen(debug_message_file_path, "r");
      if (!data_file ) begin
        $display("data_file handle was NULL");
        $fclose(data_file);
        $finish;
      end else begin
        $display("data_file is opened ");
        while (!$feof(data_file)) begin
          code = $fgets(line,data_file);
          //index = line.substr(2,9).atohex();
          index_str = line.substr(2,9);
          index = index_str.atohex();
          message = line.substr(11,line.len()-1);
          pmu_train_string[index] = message;
        end
      end
    end
  endtask
  
  //---------------------------------------------------------------------------------------
  task automatic decode_streaming_message;
    reg [31:0] codede_message_hex;
    reg [15:0] num_args;
    reg [15:0] args_list[20];
    string debug_string;
    begin
      get_mail(1,codede_message_hex);
      if(pmu_train_string.exists(codede_message_hex))begin
        // Get the number of argument need to be read from mailbox
        num_args = 16'hFFFF & codede_message_hex;
        for(integer i=0;i<num_args;i++) begin
           get_mail(1,args_list[i]);
        end
        $display ($time, " <%m> PMU Streaming Msg decoded ...  ");
        case(num_args)
          0:  $display ( pmu_train_string[codede_message_hex]);
          1:  $display ( pmu_train_string[codede_message_hex],args_list[0]);
          2:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1]);
          3:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2]);
          4:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3]);
          5:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4]);
          6:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5]);
          7:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6]);
          8:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7]);
          9:  $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8]);
          10: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9]);
          11: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9],args_list[10]);
          12: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9],args_list[10],args_list[11]);
          13: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9],args_list[10],args_list[11],args_list[12]);
          14: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9],args_list[10],args_list[11],args_list[12],args_list[13]);
          15: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9],args_list[10],args_list[11],args_list[12],args_list[13],args_list[14]);
          16: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9],args_list[10],args_list[11],args_list[12],args_list[13],args_list[14],args_list[15]);
          17: $display ( pmu_train_string[codede_message_hex],args_list[0],args_list[1],args_list[2],args_list[3],args_list[4],args_list[5],args_list[6],args_list[7],args_list[8],args_list[9],args_list[10],args_list[11],args_list[12],args_list[13],args_list[14],args_list[15],args_list[16]);
          default:$display ( pmu_train_string[codede_message_hex]);
        endcase
      end else begin
        $display ($time, " <%m> PMU Streaming Msg: Debug message not recognized !!  code: %h", codede_message_hex);
        error;
      end
    end
  endtask
  
  
  //---------------------------------------------------------------------------------------
  `include "fw_addr.v"
  //---------------------------------------------------------------------------------------
  reg   [255:0] fw_lvl[31:0];
  wire  [255:0] fw_lvl_0  = fw_lvl[0];
  wire  [255:0] fw_lvl_1  = fw_lvl[1];
  wire  [255:0] fw_lvl_2  = fw_lvl[2];
  wire  [255:0] fw_lvl_3  = fw_lvl[3];
  wire  [255:0] fw_lvl_4  = fw_lvl[4];
  wire  [255:0] fw_lvl_5  = fw_lvl[5];
  wire  [255:0] fw_lvl_6  = fw_lvl[6];
  wire  [255:0] fw_lvl_7  = fw_lvl[7];
  wire  [255:0] fw_lvl_8  = fw_lvl[8];
  wire  [255:0] fw_lvl_9  = fw_lvl[9];
  wire  [255:0] fw_lvl_10 = fw_lvl[10];
  wire  [255:0] fw_lvl_11 = fw_lvl[11];
  wire  [255:0] fw_lvl_12 = fw_lvl[12];
  wire  [255:0] fw_lvl_13 = fw_lvl[13];
  wire  [255:0] fw_lvl_14 = fw_lvl[14];
  wire  [255:0] fw_lvl_15 = fw_lvl[15];
  wire  [255:0] fw_lvl_16 = fw_lvl[16];
  wire  [255:0] fw_lvl_17 = fw_lvl[17];
  wire  [255:0] fw_lvl_18 = fw_lvl[18];
  wire  [255:0] fw_lvl_19 = fw_lvl[19];
  wire  [255:0] fw_lvl_20 = fw_lvl[20];
  wire  [255:0] fw_lvl_21 = fw_lvl[21];
  wire  [255:0] fw_lvl_22 = fw_lvl[22];
  wire  [255:0] fw_lvl_23 = fw_lvl[23];
  wire  [255:0] fw_lvl_24 = fw_lvl[24];
  wire  [255:0] fw_lvl_25 = fw_lvl[25];
  wire  [255:0] fw_lvl_26 = fw_lvl[26];
  wire  [255:0] fw_lvl_27 = fw_lvl[27];
  wire  [255:0] fw_lvl_28 = fw_lvl[28];
  wire  [255:0] fw_lvl_29 = fw_lvl[29];
  wire  [255:0] fw_lvl_30 = fw_lvl[30];
  wire  [255:0] fw_lvl_31 = fw_lvl[31];

  reg   [255:0] fw_lvl_tmp;
  reg   [4:0]   fw_cur_lvl, fw_pre_lvl;
  reg   [1:0]   fw_chk_val;  // bit 0 for top level fw check; bit 1 for the other level fw check

  wire  [16:0]  iccm_adr_full  = {top.u_srams.iccm_data_addr[16:2], 2'b00};
`ifdef DWC_DDRPHY_TOP_PG_PINS
  wire          fw_take_branch =  top.dut.u_DWC_ddrphy_pub.pub_mu.u_cpu.u_pd1_domain.u_core.u_pipe.da_take_branch;
`else
  wire          fw_take_branch =  top.dut.pac4a.u_DWC_ddrphy_pub.pub_mu.u_cpu.u_pd1_domain.u_core.u_pipe.da_take_branch;
`endif

  initial begin
    #1; 
    if(cfg.skip_train == 0) begin
      fw_moni();
    end
  end


  task fw_get_val;
  output [1:0] fw_chk;
    fw_chk = 0;
    for (int i=0; i<16*3; i=i+3) begin
      if(fw_adr_chk(iccm_adr_full, fw_s_lvl_0[i+1], fw_s_lvl_0[i+2])) begin
        fw_chk[0]=1'b1;
        fw_lvl_tmp=fw_s_lvl_0[i];
      end
    end
    for (int i=0; i<300*3; i=i+3) begin
      if(fw_adr_chk(iccm_adr_full, fw_s_lvl_n[i+1], fw_s_lvl_n[i+2])) begin
        fw_chk[1]=1'b1;
        fw_lvl_tmp=fw_s_lvl_n[i];
      end
    end
  endtask

  function int fw_adr_chk(int chk_adr, int start_adr, int end_adr);
    if((chk_adr >= (start_adr & 'hff_fffc)) && (chk_adr <= end_adr))
      return 1;
    else
      return 0;
  endfunction

  task fw_moni;
    #1;
    `ifdef DWC_DDRPHY_TOP_PG_PINS
    @(posedge top.dut.u_DWC_ddrphy_pub.pub_mu.csrResetToMicro);
   `else
    @(posedge top.dut.pac4a.u_DWC_ddrphy_pub.pub_mu.csrResetToMicro);
   `endif
    forever begin
      @ (posedge top.u_srams.iccm_data_ce);
      if (fw_take_branch) begin
        fw_get_val(fw_chk_val);
        if(fw_chk_val[0] == 1) begin
          fw_cur_lvl = 5'h0;
          fw_lvl[0] = fw_lvl_tmp;
          if(fw_pre_lvl != fw_cur_lvl) begin
            fw_lvl[1] = "NULL";
          end
        end
        else if (fw_chk_val[1] == 1) begin
          if(fw_pre_lvl == 0) begin
            fw_lvl[1]  = fw_lvl_tmp;
            fw_cur_lvl = fw_pre_lvl +1;
          end
          else begin
            if(fw_lvl_tmp == fw_lvl[fw_pre_lvl-1]) begin
              fw_cur_lvl           = fw_pre_lvl -1;
              fw_lvl[fw_pre_lvl-1] = fw_lvl_tmp;
              fw_lvl[fw_pre_lvl]   = "NULL";
            end
            else if(fw_lvl_tmp == fw_lvl[fw_pre_lvl-2]) begin
              fw_cur_lvl = fw_pre_lvl -2;
              fw_lvl[fw_pre_lvl-2] = fw_lvl_tmp;
              fw_lvl[fw_pre_lvl-1] = "NULL";
              fw_lvl[fw_pre_lvl]   = "NULL";
            end
            else if(fw_lvl_tmp == fw_lvl[fw_pre_lvl]) begin
              fw_cur_lvl = fw_pre_lvl;
            end
            else begin
              fw_cur_lvl           = fw_pre_lvl +1;
              fw_lvl[fw_pre_lvl+1] = fw_lvl_tmp;
            end
          end
        end
        fw_pre_lvl = fw_cur_lvl;
      end
    end
  endtask

  
  //---------------------------------------------------------------------------------------
  int wd_timer2;
  
  //---------------------------------------------------------------------------------------
  task automatic dwc_ddrphy_phyinit_userCustom_G_waitFwDone(chandle ctx);
    reg [15:0] data;
    reg        train_done=0;
    reg [31:0] mail;
    begin
      repeat(10) @(posedge top.dfi_clk);
  
      $display ($time, " <%m> INFO: polling DWC_DDRPHYA_APBONLY0_UctShadowRegs, bit 0...");
      while(train_done == 0)begin
        repeat(500) @(posedge top.dfi_clk);
        apb_rd(`DWC_DDRPHYA_APBONLY0_UctShadowRegs,  data);
        if(data[0] == 0)begin
          get_mail(0,mail);
          if(mail==16'hff || mail==16'h07)begin
            train_done = 1;
          end
          decode_major_message(mail);
          if(mail == 16'h08) decode_streaming_message;
          else               $display($time,"INFO: Mail Box = %x", mail);
        end
      end
      if(mail==16'hff) begin
        $display("Error: Firmware training failed.");
        $finish();
      end
    end
  endtask  
  
  //---------------------------------------------------------------------------------------
  task automatic get_mail;
    input         mode_32bits;
    output [31:0] mail;
    reg    [31:0] rd_data;
    begin
      apb_rd(`DWC_DDRPHYA_APBONLY0_UctShadowRegs,  rd_data);
      while(rd_data[0] !=0) begin
        apb_rd(`DWC_DDRPHYA_APBONLY0_UctShadowRegs,  rd_data);
      end
      apb_rd(`DWC_DDRPHYA_APBONLY0_UctWriteOnlyShadow,  mail);
      if(mode_32bits)begin
        reg [31:0] high_byte_data;
        apb_rd(`DWC_DDRPHYA_APBONLY0_UctDatWriteOnlyShadow,  high_byte_data);
        mail = (high_byte_data<<16) | mail;
      end
      apb_wr(`DWC_DDRPHYA_APBONLY0_DctWriteProt, 16'h0000);
      apb_rd(`DWC_DDRPHYA_APBONLY0_UctShadowRegs,  rd_data);
      while(rd_data[0] == 0)begin
        apb_rd(`DWC_DDRPHYA_APBONLY0_UctShadowRegs,  rd_data);
        $display ($time, " <%m> INFO: Msg read. Waiting acknowledgement from uCtl ...");
        // Watchdog timer to ensure no infiit looping during polling
        wd_timer2++;
        if(wd_timer2 > 1000) begin
          $display("TC ERROR: <%m> Watchdog timer2 overflow");
          $finish();
        end 
      end
      wd_timer2 = 0;
      apb_wr (`DWC_DDRPHYA_APBONLY0_DctWriteProt, 16'h0001);
    end
  endtask
  
  //---------------------------------------------------------------------------------------
  task automatic decode_major_message;
    input [15:0] mail;
    begin
      case(mail)
        16'h00: $display ($time, " <%m> PMU Major Msg: End of initialization                                         ");
        16'h01: $display ($time, " <%m> PMU Major Msg: End of fine write leveling                                    ");
        16'h02: $display ($time, " <%m> PMU Major Msg: End of read enable training                                   ");
        16'h03: $display ($time, " <%m> PMU Major Msg: End of read delay center optimization                         ");
        16'h04: $display ($time, " <%m> PMU Major Msg: End of write delay center optimization                        ");
        16'h05: $display ($time, " <%m> PMU Major Msg: End of 2D read delay/voltage center optimization              ");
        16'h06: $display ($time, " <%m> PMU Major Msg: End of 2D write delay /voltage center optimization            ");
        16'h07: $display ($time, " <%m> PMU Major Msg: Firmware run has completed                                    ");
        16'h08: $display ($time, " <%m> PMU Major Msg: Enter streaming message mode                                  ");
        16'h09: $display ($time, " <%m> PMU Major Msg: End of max read latency training                              ");
        16'h0a: $display ($time, " <%m> PMU Major Msg: End of read dq deskew training                                ");
        16'h0b: $display ($time, " <%m> PMU Major Msg: End of LCDL offset calibration                                ");
        16'h0c: $display ($time, " <%m> PMU Major Msg: End of LRDIMM Specific training (DWL, MREP, MRD and MWD)      ");
        16'h0d: $display ($time, " <%m> PMU Major Msg: End of CA training                                            ");
        16'hfd: $display ($time, " <%m> PMU Major Msg: End of MPR read delay center optimization                     ");
        16'hfe: $display ($time, " <%m> PMU Major Msg: End of Write leveling coarse delay                            ");
        16'hff: $display ($time, " <%m> PMU Major Msg: FATAL ERROR.                                                  ");
        default: $display ($time, " <%m> PMU Major Msg: Un-recognized message... !");
      endcase
    end
  endtask


//-------------------this function is used to judge which check should be used.
`ifndef ATE_TEST
initial
 begin
  forever
   begin
    @(posedge test.top.dfi_clk);
    check_DBI();
      {top.dfi0.W_DM,top.dfi0.W_DBI,top.dfi0.R_DBI} = {W_DM,W_DBI,R_DBI};
    `ifndef DFI_MODE1
      {top.dfi1.W_DM,top.dfi1.W_DBI,top.dfi1.R_DBI} = {W_DM,W_DBI,R_DBI};
    `endif
   end
 end
`endif


function  check_DBI();
      case(cfg.PState)
        0: begin
//---write mask
            `ifdef WRITE_DM0
              W_DM = 1'b1;
            `else
              W_DM = 1'b0;
            `endif
//---write dbi
            `ifdef WRITE_DBI0
              W_DBI = 1'b1;
            `else
              W_DBI = 1'b0;
            `endif
//---read dbi
            `ifdef READ_DBI0
              R_DBI = 1'b1;
            `else
              R_DBI = 1'b0;
            `endif
          end
        1: begin
//---write mask
            `ifdef WRITE_DM1
              W_DM = 1'b1;
            `else
              W_DM = 1'b0;
            `endif
//---write dbi
            `ifdef WRITE_DBI1
              W_DBI = 1'b1;
            `else
              W_DBI = 1'b0;
            `endif
//---read dbi
            `ifdef READ_DBI1
              R_DBI = 1'b1;
            `else
              R_DBI = 1'b0;
            `endif
          end
        2: begin
//---write mask
            `ifdef WRITE_DM2
              W_DM = 1'b1;
            `else
              W_DM = 1'b0;
            `endif
//---write dbi
            `ifdef WRITE_DBI2
              W_DBI = 1'b1;
            `else
              W_DBI = 1'b0;
            `endif
//---read dbi
            `ifdef READ_DBI2
              R_DBI = 1'b1;
            `else
              R_DBI = 1'b0;
            `endif
          end
        3: begin
//---write mask
            `ifdef WRITE_DM3
              W_DM = 1'b1;
            `else
              W_DM = 1'b0;
            `endif
//---write dbi
            `ifdef WRITE_DBI3
              W_DBI = 1'b1;
            `else
              W_DBI = 1'b0;
            `endif
//---read dbi
            `ifdef READ_DBI3
              R_DBI = 1'b1;
            `else
              R_DBI = 1'b0;
            `endif
          end
        default: {W_DM,W_DBI,R_DBI} = 'b0;
      endcase
endfunction


`ifndef ATE_TEST
initial begin
  `ifndef DFI_MODE1
  fork
    begin
      top.dfi0.set_default;
    end
    begin
      top.dfi1.set_default;
    end
  join
  `else
    top.dfi0.set_default;
  `endif
end
`endif

task des (int des_num=1,bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr[16]=ADDR);
`ifdef LP4_STD
  for (int i=0;i<des_num;i++)begin
  `ifndef DFI_MODE1
  fork
    begin
      top.dfi0.lpddr4_des();
    end
    begin
      top.dfi1.lpddr4_des();
    end
  join
  `else
     top.dfi0.lpddr4_des();
  `endif  
  end
`endif  
`ifdef LP5_STD
  for (int i=0;i<des_num;i++)begin
  `ifdef DDRPHY_POWERSIM
    `ifndef DFI_MODE1
      fork
        begin
          top.dfi0.lpddr5_des({Addr[(i*2+1)%16],Addr[(i*2)%16]});
        end
        begin
          top.dfi1.lpddr5_des({Addr[(i*2+1)%16],Addr[(i*2)%16]});
        end
      join
    `else
       top.dfi0.lpddr5_des({Addr[(i*2+1)%16],Addr[(i*2)%16]});
    `endif  
  `else
    `ifndef DFI_MODE1
      fork
        begin
          top.dfi0.lpddr5_des();
        end
        begin
          top.dfi1.lpddr5_des();
        end
      join
    `else
       top.dfi0.lpddr5_des();
    `endif  
  `endif
  end
`endif
endtask

//Beat time
task beat_time(int Time, bit [1:0] pstate=cfg.PState );
  int tCK;
  int des_num;
  tCK  = (1_000_000.0/cfg.Frequency[pstate]);//cycle
  des_num = `CEIL(Time,tCK);
  $display("Des time is %0d",des_num);
  des(des_num);//ceil
endtask 

//Max time
task max_time(int Time, int nck, bit [1:0] pstate=cfg.PState );
  int Num_cycle;
  int tCK;
  int des_num;
  tCK  = (1_000_000.0/cfg.Frequency[pstate]);//cycle
  des_num = `CEIL(Time,tCK);
  if(des_num > nck)begin//ceil
  end else begin
    des_num = nck;
  end
  des(des_num);
  $display("Des time is %0d",des_num);
endtask 

//Min time
task min_time(int Time, int nck, bit [1:0] pstate=cfg.PState );
  int Num_cycle;
  int tCK;
  int des_num;
  tCK  = (1_000_000.0/cfg.Frequency[pstate]);//cycle
  des_num = `CEIL(Time,tCK);
  if(des_num < nck)begin//ceil
  end else begin
    des_num = nck;
  end
  $display("Des time is %0d",des_num);
  des(des_num);
endtask 

// -------------------------------------------------------------------------------
// Sideband task
// -------------------------------------------------------------------------------

task automatic ctrlupd(int t_ctrlupd_max=0);
begin
  des(1100);
  top.dfi0.dfi0_ctrlupd(t_ctrlupd_max);
end
endtask: ctrlupd

task automatic phyupd;
begin
  top.dfi0.dfi0_phyupd();
end
endtask: phyupd 

task automatic phymstr;
begin
  `ifdef DWC_DDRPHY_PG_PINS
  force test.top.dut.u_DWC_ddrphy_pub.MASTER_dig.dwc_ddrphy_phymasint0.ttr_ctr[27:0] = 28'd20480;
  repeat(550) @(posedge top.dfi_clk);
  release test.top.dut.u_DWC_ddrphy_pub.MASTER_dig.dwc_ddrphy_phymasint0.ttr_ctr[27:0];
  `else
  force test.top.dut.pac4a.u_DWC_ddrphy_pub.MASTER_dig.dwc_ddrphy_phymasint0.ttr_ctr[27:0] = 28'd20480;
  repeat(550) @(posedge top.dfi_clk);
  release test.top.dut.pac4a.u_DWC_ddrphy_pub.MASTER_dig.dwc_ddrphy_phymasint0.ttr_ctr[27:0];
  `endif
  @(posedge top.dfi_clk);  
  self_refresh_enter(); 
  top.dfi0.dfi0_phymstr();
  self_refresh_exit();
end
endtask: phymstr

`ifdef USER_TEST
task automatic dfi_des(int number=1);
  `ifdef LPDDR4
    top.dfi0.lpddr4_deselect(number);
  `endif
endtask
/*
task automatic dfi_mpc(bit [3:0] rank=0, bit [6:0] op=0);
  `ifdef LPDD4
    top.dfi0.lpddr4_mpc(rank,op);
  `endif
endtask
*/
task automatic dfi_srx();
  self_refresh_exit();
endtask

task automatic dfi_mrw(bit [3:0] rank=4'b1110, bit [5:0] ma=3'h0, bit [7:0] op=8'h0);
  `ifdef LPDDR4
    top.dfi0.lpddr4_write_mrs (rank,ma,0,0,{1'b1,op[7:0]});
  `endif
endtask

task automatic dfi_act(bit [3:0] rank=4'b1110, bit [2:0] ba=3'h0, bit [16:0] row=17'h0);
  `ifdef LPDDR4
    top.dfi0.lpddr4_activate(rank, ba, row);
  `endif
endtask

task automatic dfi_write(bit [3:0] rank=4'b1110, bit [2:0] ba=3'h0, bit [9:0] col=10'h0);
  `ifdef LPDDR4
    top.dfi0.lpddr4_wrs16(rank, ba, col);
  `endif
endtask

task automatic dfi_read(bit [3:0] rank=4'b1110, bit [2:0] ba=3'h0, bit [9:0] col=10'h0);
  `ifdef LPDDR4
    top.dfi0.lpddr4_rds16(rank, ba, col);
  `endif
endtask
`endif



//--------------------------------------------------------------------------------
task automatic cust_csr_prog_for_emul(bit [1:0] PState=0);
bit [15:0] cfg_data;

`ifdef LP4_STD
if(cfg.DfiFreqRatio[PState]==1) begin              // Frequency Ratio 1:2  freq =  533 800 1066 1333 1600  2133 
  if(cfg.Frequency[PState] == 533)                 // Data Rate 1066Mbps frq=533
    cfg_data = 16'h4b;
  if(cfg.Frequency[PState] == 1866)                // Data Rate 1066Mbps frq=1866 '96
    cfg_data = 16'h16;
  if(cfg.Frequency[PState] == 2133)                // Data Rate 4267Mbps
    cfg_data = 16'hcb;     
end else if(cfg.DfiFreqRatio[PState]==2) begin     // Frequency Ratio 1:4  freq= 533  1066 1333 1600  1866  2133
  if(cfg.Frequency[PState] == 1066)                // Data Rate 2133Mbps freq=1066
    cfg_data = 16'h136;
  if(cfg.Frequency[PState] == 1333)                // Data Rate 2666Mbps freq=1333
    cfg_data = 16'h12b;
  if(cfg.Frequency[PState] == 1600)                // Data Rate 2666Mbps freq=1600 'a1
    cfg_data = 16'ha2;
  if(cfg.Frequency[PState] == 1866)                // Data Rate 3733Mbps freq=1866
    cfg_data = 16'h16;
  if(cfg.Frequency[PState] == 2133)                // Data Rate 4267Mbps
    cfg_data = 16'hcb;
end
`endif

`ifdef LP5_STD
if(cfg.DfiFreqRatio[PState]==1) begin              // Ck:Wck ratio 1:2  freq= 267 400 533 688 800
  if(cfg.Frequency[PState] == 267)                 // Data Rate 1068Mbps freq=267
    cfg_data = 16'h1cb;
  if(cfg.Frequency[PState] == 400)                 // Data Rate 1600Mbps freq=400
    cfg_data = 16'h241;
end else if(cfg.DfiFreqRatio[PState]==2) begin     // Ck:Wck ratio 1:4  freq= 133  200  267  344  400  467  533  600  688  750  800
  //if(cfg.Frequency[PState] == 133)                 // Data Rate 1064Mbps 
  //  cfg_data = 16'h24b;
  if(cfg.Frequency[PState] ==200)                  // Data Rate 1600Mbps freq=200
    cfg_data = 16'h241;
  if(cfg.Frequency[PState] == 533)                 // Data Rate 4264Mbps
    cfg_data = 16'h1cb;
  if(cfg.Frequency[PState] == 600)                 // Data Rate 4800Mbps freq=600
    cfg_data = 16'h1c1;
  if(cfg.Frequency[PState] == 688)                 // Data Rate 5504Mbps freq=688
    cfg_data = 16'h1b3;
  if(cfg.Frequency[PState] == 750)                 // Data Rate 6000Mbps
    cfg_data = 16'h1a9;
end
`endif

if(cfg_data!=0) begin
  $display("Start of cust_csr_prog_for_emul for Pstate %0d",PState);
  $display("DfiFreqRatio[%0d]=%0d, Frequency[%0d]=%0d, cfg_data=%h",PState,cfg.DfiFreqRatio[PState],PState,cfg.Frequency[PState],cfg_data);

  dwc_ddrphy_apb_wr(32'hd0000,16'h0); // Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 0

`ifdef DWC_DDRPHY_EXISTS_DB0
  dwc_ddrphy_apb_wr(32'h10010,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h10012,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h10110,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h10112,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h10210,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h10212,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h10310,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h10312,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h10410,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h10412,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h10510,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h10512,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h10610,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h10612,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h10710,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h10712,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h10810,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h10812,cfg_data); // DWC_DDRPHYA_DBYTE0_p0_RxClkC2UIDlyTg0_r8_p0
`endif
`ifdef DWC_DDRPHY_EXISTS_DB1
  dwc_ddrphy_apb_wr(32'h11010,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h11012,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h11110,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h11112,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h11210,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h11212,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h11310,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h11312,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h11410,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h11412,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h11510,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h11512,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h11610,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h11612,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h11710,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h11712,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h11810,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h11812,cfg_data); // DWC_DDRPHYA_DBYTE1_p0_RxClkC2UIDlyTg0_r8_p0
`endif
`ifdef DWC_DDRPHY_EXISTS_DB2
  dwc_ddrphy_apb_wr(32'h12010,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h12012,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h12110,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h12112,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h12210,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h12212,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h12310,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h12312,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h12410,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h12412,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h12510,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h12512,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h12610,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h12612,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h12710,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h12712,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h12810,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h12812,cfg_data); // DWC_DDRPHYA_DBYTE2_p0_RxClkC2UIDlyTg0_r8_p0
`endif
`ifdef DWC_DDRPHY_EXISTS_DB3
  dwc_ddrphy_apb_wr(32'h13010,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h13012,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h13110,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h13112,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h13210,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h13212,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h13310,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h13312,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h13410,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h13412,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h13510,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h13512,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h13610,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h13612,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h13710,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h13712,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h13810,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h13812,cfg_data); // DWC_DDRPHYA_DBYTE3_p0_RxClkC2UIDlyTg0_r8_p0
`endif
`ifdef DWC_DDRPHY_EXISTS_DB4
  dwc_ddrphy_apb_wr(32'h14010,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h14012,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h14110,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h14112,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h14210,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h14212,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h14310,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h14312,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h14410,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h14412,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h14510,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h14512,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h14610,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h14612,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h14710,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h14712,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h14810,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h14812,cfg_data); // DWC_DDRPHYA_DBYTE4_p0_RxClkC2UIDlyTg0_r8_p0
`endif
`ifdef DWC_DDRPHY_EXISTS_DB5
  dwc_ddrphy_apb_wr(32'h15010,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h15012,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h15110,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h15112,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h15210,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h15212,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h15310,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h15312,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h15410,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h15412,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h15510,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h15512,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h15610,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h15612,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h15710,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h15712,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h15810,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h15812,cfg_data); // DWC_DDRPHYA_DBYTE5_p0_RxClkC2UIDlyTg0_r8_p0
`endif
`ifdef DWC_DDRPHY_EXISTS_DB6
  dwc_ddrphy_apb_wr(32'h16010,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h16012,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h16110,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h16112,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h16210,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h16212,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h16310,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h16312,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h16410,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h16412,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h16510,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h16512,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h16610,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h16612,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h16710,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h16712,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h16810,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h16812,cfg_data); // DWC_DDRPHYA_DBYTE6_p0_RxClkC2UIDlyTg0_r8_p0
`endif
`ifdef DWC_DDRPHY_EXISTS_DB7
  dwc_ddrphy_apb_wr(32'h17010,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h17012,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r0_p0
  dwc_ddrphy_apb_wr(32'h17110,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h17112,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r1_p0
  dwc_ddrphy_apb_wr(32'h17210,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h17212,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r2_p0
  dwc_ddrphy_apb_wr(32'h17310,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h17312,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r3_p0
  dwc_ddrphy_apb_wr(32'h17410,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h17412,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r4_p0
  dwc_ddrphy_apb_wr(32'h17510,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h17512,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r5_p0
  dwc_ddrphy_apb_wr(32'h17610,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h17612,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r6_p0
  dwc_ddrphy_apb_wr(32'h17710,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h17712,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r7_p0
  dwc_ddrphy_apb_wr(32'h17810,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkT2UIDlyTg0_r8_p0
  dwc_ddrphy_apb_wr(32'h17812,cfg_data); // DWC_DDRPHYA_DBYTE7_p0_RxClkC2UIDlyTg0_r8_p0
`endif

  dwc_ddrphy_apb_wr(32'hd0000,16'h1); // Isolate the APB access from the internal CSRs by setting the MicroContMuxSel CSR to 1
  $display("End of cust_csr_prog_for_emul for Pstate %0d",PState);
end

endtask

//
// Supported speed bins
// LPDDR4: 1066 1600 2133 2667 3200 3733 4267 (533 is not supported dut to FW limitaiton)
// LPDDR5: 1066 1600 2133 2750 3200 3733 4266 4800 5420 6000 6400 (533 is not supported dut to FW limitaiton)
// Wck2ck ratio:
// 1:2  1066, 1600, 2133, 2750, 3200
// 1:4  1066 1600 2133 2750 3200 3733 4267 4800 5500 6000 6400
//--------------------------------------------------------------------------------
task automatic cust_csr_for_emul_reprog(bit [1:0] PState=0);
bit [2:0] EnRxClkCorAnytime;
bit       EnRxClkCor;
bit [15:0] cfg_data ;
$display("Start of cust_csr_for_emul_reprog for Pstate %0d %t",PState,$realtime);

`ifdef DWC_DDRPHY_HWEMUL
if(RxClkT2UIDly_fine_cnt == 4)begin           //need to change core RxClkT2UIDly_default[9:7] ;
   RxClkT2UIDly_fine_cnt  = 0;
   if(RxClkT2UIDly_core <=3  && RxClkT2UIDly_core_plus === 1'b1) begin
      RxClkT2UIDly_core++;
   end
   else if(RxClkT2UIDly_core ==4)begin        //RxClkT2UIDly_default[9:7] need subtract
      RxClkT2UIDly_core_plus = 1'b0;
      RxClkT2UIDly_core = RxClkT2UIDly_default[9:7] ;
   end
   if(RxClkT2UIDly_core_plus === 1'b0)begin
      if(RxClkT2UIDly_core == 0)begin         //RxClkT2UIDly_default[9:7] can't subtract,case fail
         $display("TC INFO: RxClkT2UIDly RxClkT2UIDly_prog_data =%h RxClkT2UIDly_PROG_TOTAL_NUM=%d can't find !!!! ",RxClkT2UIDly_prog_data,RxClkT2UIDly_PROG_TOTAL_NUM);
         $display("TC ERROR: test failed, wrong data received");
         $finish;
      end else if(RxClkT2UIDly_core > 0)  
          RxClkT2UIDly_core--;
   end
end
RxClkT2UIDly_PROG_TOTAL_NUM++;
dwc_ddrphy_apb_wr(32'hd0000,16'h0); // Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 0
dwc_ddrphy_apb_rd(32'h10010,cfg_data);
cfg_data = {cfg_data[15:10],RxClkT2UIDly_core,cfg_data[6:2],(cfg_data[1:0] + 1'b1)};
RxClkT2UIDly_prog_data = cfg_data;
RxClkT2UIDly_fine_cnt ++;
$display("cust_csr_for_emul_reprog DfiFreqRatio[%0d]=%0d, Frequency[%0d]=%0d, cfg_data=%h %t",PState,cfg.DfiFreqRatio[PState],PState,cfg.Frequency[PState],cfg_data,$realtime);

dwc_ddrphy_apb_wr(32'h200A0,16'h1);      //DWC_DDRPHYA_MASTER0_p0_RxFifoInit 
dwc_ddrphy_apb_wr(32'h200A0,16'h0);      //DWC_DDRPHYA_MASTER0_p0_RxFifoInit 


`ifdef DWC_DDRPHY_EXISTS_DB0
  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end

   
  dwc_ddrphy_apb_rd(32'h10056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE0_p0_RxClkCntl
  $display("read back 0 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h10056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE0_p0_RxClkCntl
  $display("write in 0 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);

  dwc_ddrphy_apb_rd(32'h10057,EnRxClkCor); // DWC_DDRPHYA_DBYTE0_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h10057,EnRxClkCor); // DWC_DDRPHYA_DBYTE0_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h110057,EnRxClkCor); // DWC_DDRPHYA_DBYTE0_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h110057,EnRxClkCor); // DWC_DDRPHYA_DBYTE0_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

`endif
`ifdef DWC_DDRPHY_EXISTS_DB1
 for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base +32'h1000 + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base + 32'h1000 + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end


  dwc_ddrphy_apb_rd(32'h11056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE1_p0_RxClkCntl
  $display("read back 1 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h11056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE1_p0_RxClkCntl
  $display("write in 1 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);

  dwc_ddrphy_apb_rd(32'h11057,EnRxClkCor); // DWC_DDRPHYA_DBYTE1_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h11057,EnRxClkCor); // DWC_DDRPHYA_DBYTE1_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h111057,EnRxClkCor); // DWC_DDRPHYA_DBYTE1_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h111057,EnRxClkCor); // DWC_DDRPHYA_DBYTE1_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

`endif
`ifdef DWC_DDRPHY_EXISTS_DB2
  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base +32'h2000 + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base +32'h2000 + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end


  dwc_ddrphy_apb_rd(32'h12056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl
  $display("read back 2 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h12056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl
  $display("write in 1 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);

  dwc_ddrphy_apb_rd(32'h12057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h12057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h112057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h112057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
`endif
`ifdef DWC_DDRPHY_EXISTS_DB3
  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base +32'h3000 + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base +32'h3000 + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end

  dwc_ddrphy_apb_rd(32'h13056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE3_p0_RxClkCntl
  $display("read back 3 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h13056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE3_p0_RxClkCntl
  $display("write in 3 EnRxClkCorAnytime =%h  @%t", EnRxClkCorAnytime,$realtime);

  dwc_ddrphy_apb_rd(32'h13057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h13057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h113057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h113057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

`endif
`ifdef DWC_DDRPHY_EXISTS_DB4
 for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base +32'h4000 + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base +32'h4000 + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end


  dwc_ddrphy_apb_rd(32'h14056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE4_p0_RxClkCntl
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h14056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE4_p0_RxClkCntl

  dwc_ddrphy_apb_rd(32'h14057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h14057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h114057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h114057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

`endif
`ifdef DWC_DDRPHY_EXISTS_DB5
 for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base +32'h5000 + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base +32'h5000 + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end


  dwc_ddrphy_apb_rd(32'h15056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE5_p0_RxClkCntl
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h15056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE5_p0_RxClkCntl

  dwc_ddrphy_apb_rd(32'h15057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h15057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h115057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h115057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

`endif
`ifdef DWC_DDRPHY_EXISTS_DB6
 for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base +32'h6000 + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base +32'h6000 + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end

  dwc_ddrphy_apb_rd(32'h16056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE6_p0_RxClkCntl
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h16056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE6_p0_RxClkCntl

  dwc_ddrphy_apb_rd(32'h16057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h16057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h116057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h116057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

`endif
`ifdef DWC_DDRPHY_EXISTS_DB7
 for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkT2UIDly_addr, cfg_data);
      //$display ($time, " <%m> New csr_RxClkT2UIDly_addr = %0h, csr_RxClkT2UIDly = %0h. ",csr_RxClkT2UIDly_addr, cfg_data);
      csr_RxClkT2UIDly_addr = csr_RxClkT2UIDly_addr_base +32'h7000 + csr_RxClkT2UIDly_addr_r + csr_RxClkT2UIDly_addr_t;
      csr_RxClkT2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkT2UIDly_addr_r = 0;
    end
    csr_RxClkT2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkT2UIDly_addr_t = 0;
  end


  for (int t=0; t<4; t++) begin 
    for (int r=0; r<9; r++) begin
      dwc_ddrphy_apb_wr(csr_RxClkC2UIDly_addr, cfg_data);
      csr_RxClkC2UIDly_addr = csr_RxClkC2UIDly_addr_base +32'h7000 + csr_RxClkC2UIDly_addr_r + csr_RxClkC2UIDly_addr_t;
      csr_RxClkC2UIDly_addr_r += 31'h100;
      if (r == 8) csr_RxClkC2UIDly_addr_r = 0;
    end
    csr_RxClkC2UIDly_addr_t += 31'h1;
    if (t == 3) csr_RxClkC2UIDly_addr_t = 0;
  end

  dwc_ddrphy_apb_rd(32'h17056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE7_p0_RxClkCntl
  EnRxClkCorAnytime =  {EnRxClkCorAnytime[2:1],1'b1};
  dwc_ddrphy_apb_wr(32'h17056,EnRxClkCorAnytime); // DWC_DDRPHYA_DBYTE7_p0_RxClkCntl

  dwc_ddrphy_apb_rd(32'h17057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
  EnRxClkCor =  1'b0;
  dwc_ddrphy_apb_wr(32'h17057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p0_RxClkCntl1_p0
  $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

 // dwc_ddrphy_apb_rd(32'h117057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("read back 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);
 // EnRxClkCor =  1'b0;
 // dwc_ddrphy_apb_wr(32'h117057,EnRxClkCor); // DWC_DDRPHYA_DBYTE2_p1_RxClkCntl1_p1
 // $display("write in 0 EnRxClkCor =%h  @%t", EnRxClkCor,$realtime);

`endif
  
  dwc_ddrphy_apb_wr(32'hd0000,16'h1); // Isolate the APB access from the internal CSRs by setting the MicroContMuxSel CSR to 1
  $display("End of cust_csr_for_emul_reprog for Pstate %0d",PState);
`endif
endtask
//--------------------------------------------------------------------------------
task automatic rxclkdly_set(bit [1:0] PState=0);
reg [7:0]  reg_addr;
reg [3:0]  se_addr; 
reg [31:0] apb_addr;
reg [15:0] addend;
reg [3:0]  dbyte_num;
reg [3:0]  dbyte_addr;
reg [15:0] rddata;
reg [15:0] wrdata;
reg [15:0] sum;
reg [15:0] sum_fine;
reg [1:0]  addend_coarse;
reg [2:0]  sum_coarse;
begin
  dbyte_num = cfg.NumActiveDbyteDfi0 + cfg.NumActiveDbyteDfi1;
  `ifdef LP4_STD
  addend = $floor(cfg.Frequency[PState]*256/10000); 
  `else
  addend = $floor(cfg.Frequency[PState]*cfg.DfiFreqRatio[PState]*512/10000); 
  `endif
  `ifndef TRAINING_MODE
    `ifdef LP4_STD
    $display("The DRAM CK frequecy is %0d, DfiFreqRatio is %0d ",cfg.Frequency[0],cfg.DfiFreqRatio[0]);
    `else
    $display("The DfiClk frequecy is %0d, DfiFreqRatio is %0d ",cfg.Frequency[0],cfg.DfiFreqRatio[0]);
    `endif
    dwc_ddrphy_apb_wr(32'hd0000,16'h0);
    for( int k=0;k<dbyte_num;k++)begin
      dbyte_addr= k;
      apb_addr = {10'b0,PState,4'h1,dbyte_addr,12'h56};
      dwc_ddrphy_apb_rd(apb_addr,rddata);
      $display("apb_addr %h, apb read EnRxClkCorAnytime is %b",apb_addr,rddata);
      wrdata = {rddata[15:1],1'b1};
      dwc_ddrphy_apb_wr(apb_addr,wrdata);
      $display("apb_addr %h, apb write EnRxClkCorAnytime is %b",apb_addr,wrdata);
      for( int i=0;i<9;i++)begin
        for ( int j=0; j<4; j++)begin
          se_addr = i;
            reg_addr = 8'h10 + j;
            apb_addr = {10'b0,PState,4'h1,dbyte_addr,se_addr,reg_addr};
            dwc_ddrphy_apb_rd(apb_addr,rddata);
            $display("apb_addr %h, apb read RxClkT2UIDly is %b",apb_addr,rddata);
            sum = rddata[6:0] + addend;
            if (sum[7]==1)begin 
                sum_fine = sum - 16'd128;
                addend_coarse = 2'd2;
              end
            else
              begin
                sum_fine = sum;
                addend_coarse = 2'b0;
              end
            sum_coarse = rddata[9:7] + addend_coarse;
            wrdata = {6'b0,sum_coarse,sum_fine[6:0]};
            //end
          dwc_ddrphy_apb_wr(apb_addr,wrdata);
          $display("apb_addr %h, apb write RxClkT2UIDly is %b",apb_addr,wrdata);
        end
      end
    end
    dwc_ddrphy_apb_wr(32'hd0000,16'h1);
  `endif
  des(10); //Ensure apb write finish
end
endtask

// ---------------------------------------------------------------
// PHY Init Relevant Tasks
// ---------------------------------------------------------------
task automatic dwc_ddrphy_phyinit_userCustom_overrideUserInput(chandle ctx);
  $display("In dwc_ddrphy_phyinit_userCustom_overrideUserInput.");
endtask

task automatic dwc_ddrphy_phyinit_userCustom_A_bringupPower(chandle ctx);
  $display("In dwc_ddrphy_phyinit_userCustom_A_bringupPower, @%0t",$time);
  test.top.clk_rst_drv.power_up();
endtask

task automatic dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy(chandle ctx);
  $display("In dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy, @%0t",$time);
  test.top.clk_rst_drv.start_clkRst();
endtask

task automatic dwc_ddrphy_phyinit_userCustom_customPreTrain(chandle ctx);
  $display("In dwc_ddrphy_phyinit_userCustom_customPreTrain.");
endtask

task automatic dwc_ddrphy_phyinit_userCustom_E_setDfiClk(chandle ctx, int PState); //does the task still exist?
  $display("In dwc_ddrphy_phyinit_userCustom_E_setDfiClk(%0d)", PState);
  phyctx     = ctx;
  cfg.PState = PState;
`ifdef DDR4_STD
  update_timing_parameters();
`endif
  repeat(30) @(posedge top.dfi_clk);
endtask

task automatic dwc_ddrphy_phyinit_userCustom_H_readMsgBlock(chandle ctx, int Train2D=0);
  $display("In dwc_ddrphy_phyinit_userCustom_H_readMsgBlock.");
  phyctx = ctx;
endtask
  
task automatic dwc_ddrphy_phyinit_userCustom_customPostTrain(chandle ctx);
    int unsigned MicroContMuxSel;
    automatic string pubstr;
    automatic string fileName;

  $display("In dwc_ddrphy_phyinit_userCustom_customPostTrain.");
  `ifdef RET_EN
    apb_save_ret_csrs();
  `endif
  `ifdef DWC_DDRPHY_HWEMUL
   //cust_csr_prog_for_emul();
   dwc_ddrphy_apb_wr(32'hd0000,16'h0);         // Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 0
   dwc_ddrphy_apb_rd(32'h10010,RxClkT2UIDly_default);     //get the default value
   RxClkT2UIDly_core = RxClkT2UIDly_default[9:7];
   if(RxClkT2UIDly_core > 4) begin
   $display("TC INFO : RxClkT2UIDly_default[9:7] > 4 ");
   $finish;
   end
   $display("RxClkT2UIDly_default[9:7] = %h ",RxClkT2UIDly_default);
   dwc_ddrphy_apb_wr(32'hd0000,16'h1);         // Enable access to the internal CSRs by setting the MicroContMuxSel CSR to 1
  `endif
  `ifdef DDRPHY_POWERSIM
    `ifdef LP_MODE
      case(`LP_MODE)
      1,3: begin
        DbyteDynOdtEn_set(1);
        end
      endcase
    `endif
  `endif


  `ifdef QUICKBOOT
    apb_rd(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);
    apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h0);
    phy_csr_state_chk = new();
    phy_csr_state_chk.getPhyState(phy_csr_state_chk.trainingPhyState);
    apb_rd(`DWC_DDRPHYA_APBONLY0_NeverGateAcCsrClock, NeverGateAcCsrClock_quickboot);
    apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);

    case (`DWC_DDRPHY_PUB_RID & 16'h0FFF)
      'h220 : pubstr = "220";
      'h210 : pubstr = "210";
      'h200 : pubstr = "200";
      'h110 : pubstr = "110";
      'h105 : pubstr = "105";
      'h104 : pubstr = "104";
      'h103 : pubstr = "103";
      'h102 : pubstr = "102";
      default : pubstr = "DEV";
    endcase
      
    fileName = $sformatf("PUB%s_REG_LIST_DBYTE%0d.txt", pubstr ,cfg.NumDbytesPerCh*cfg.NumCh);
    `uvm_info("Quickboot in dwc_ddrphy_phyinit_userCustom_customPostTrain", $sformatf("Loading %s",fileName),UVM_INFO)
    $display ($time, " <%m> INFO: Quickboot save step TRAIN&I related CSRs starts ... \n");
    save_reg_quickboot(fileName, "saved_regs_quickboot.txt");
    save_acsm_sram_quickboot();
    $display ($time, " <%m> INFO: Quickboot save step TRAIN&I related CSRs completed ... \n");
  `endif //QUICKBOOT
endtask


`ifdef QUICKBOOT
assign ucClkFull =  top.dut.u_DWC_ddrphy_pub.MRTUB.csrUcclkFull[2:2];
task quickboot_init ();
  bit [3:0] rank=4'b1110;
  apb_config_quickboot();
  dwc_ddrphy_phyinit_userCustom_J_enterMissionMode (phyctx);
  `ifdef LP5_STD
    // Config 8B Mode.
    rank='b1110;
    for( int i=0;i< cfg.NumRank_dfi0;i++)begin
      `ifndef DFI_MODE1
        fork
          begin
            top.dfi0.lpddr5_mrs(rank,'h3,cfg.MR3[0]);
            for(int i=0; i<50;i++)begin
            top.dfi0.lpddr5_des();
            end
          end
          begin
            top.dfi1.lpddr5_mrs(rank,'h3,cfg.MR3[0]);
            for(int i=0; i<50;i++)begin
            top.dfi1.lpddr5_des();
            end
          end
        join
      `else
        top.dfi0.lpddr5_mrs(rank,'h3,cfg.MR3[0]);
        for(int i=0; i<50;i++)begin
        top.dfi0.lpddr5_des();
        end
      `endif 
      rank = {rank[2:0],1'b1};
    end
  `endif
  `ifdef LP4_STD
    power_down_exit();
  `endif          
  // Training FW puts device into self-refresh
  self_refresh_exit();// exit self-refresh
  #100;
endtask //quickboot_init


task automatic apb_config_quickboot();
  reg [15:0] data;

  quickboot_flag=1;
  //reload  quickboot mode pmu string
  read_pmu_string_file();

    power_down_enter();

  //======  bringup Voltage ;  strat clock and reset Phy ==========//
  //VDDQCheck does not allow multiple power cycles in same simulation.
  apb_rd(`DWC_DDRPHYA_MASTER0_p0_MemResetL,   data);

  repeat(10) @(posedge top.apb_clk);
  test.top.clk_rst_drv.power_down_reset_phy_sdram();
  //TODO: This can be randomized.
  //Add randomization later.
  repeat(10) @(posedge top.apb_clk);
  dwc_ddrphy_phyinit_userCustom_A_bringupPower(phyctx);
  dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy(phyctx);

  apb_wr(`DWC_DDRPHYA_APBONLY0__MicroContMuxSel, 0);
  //Set Bypass Mode - Required for all PUBs prior to pub210, but can be done
  //for all.
  apb_wr(`DWC_DDRPHYA_AC0_p0_AsyncAcTxEn | 'hF<<12 , 'hF00);
  //Drive CK
  apb_wr(`DWC_DDRPHYA_AC0_p0_TxImpedanceDIFF0T_p0 | 'hF<<12 , 'hF0F);
  apb_wr(`DWC_DDRPHYA_AC0_p0_TxImpedanceDIFF0C_p0 | 'hF<<12 , 'hF0F);

  //Needed fix Jira P80001562-131946
  if((`DWC_DDRPHY_PUB_RID&16'h0FFF) inside {'h102,'h104,'h105,'h200} ) begin : PUB_CHECK
    for(int ch=0; ch<cfg.NumCh; ch++) begin : CHANNEL
        apb_wr(`DWC_DDRPHYA_AC0_p0_AcLnDisable | ch<<12, '1);//Disable all lanes to keep CMDFIFO + LCDL init signals high.
      for(int db=0; db<cfg.NumDbytesPerCh; db++) begin : DBYTE_PER_CHANNEL
        apb_wr(`DWC_DDRPHYA_DBYTE0_p0_RxReplicaCtl04_p0 | ((2*ch) +db) << 12, 'h6);
      end : DBYTE_PER_CHANNEL
    end : CHANNEL
    apb_wr ( `DWC_DDRPHYA_MASTER0_p0_TxRdPtrInit,0);
  end : PUB_CHECK
  repeat(100) @(posedge top.apb_clk);

  //======  step D load QuickBoot IMEM ============================//
  repeat(10) @(posedge top.apb_clk);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h0);
  apb_wr(`DWC_DDRPHYA_MASTER0_p0_PorControl, 16'h1);             
  apb_wr(`DWC_DDRPHYA_DRTUB0_UcclkHclkEnables, {ucClkFull, 2'b11});
  apb_wr(`DWC_DDRPHYA_APBONLY0_NeverGateAcCsrClock, NeverGateAcCsrClock_quickboot);
  load_image("quickboot_imem.incv");
  //======  step F load QuickBoot DMEM + saved Message Block ======//
  load_image("quickboot_dmem.incv");
  msgBlk_write_quickboot();  //write back the updated MsgBlk to DMEM.
  restore_reg_quickboot();   //Restore Training CSRs
  //======  step G Excute Quickboot FW ============================//
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h1);
  repeat(10) @(posedge top.apb_clk);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h1);

  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroReset, 16'h9);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroReset, 16'h1);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroReset, 16'h0);
  dwc_ddrphy_phyinit_userCustom_G_waitFwDone(phyctx);
  repeat(500) @(posedge test.top.dut.u_DWC_ddrphy_pub.UcClk);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 16'h0);
  //======  step H Restore ACSM SRAM ==============================//
  restore_acsm_sram_quickboot();
  //======  check the CSR =========================================//
  casez (`DWC_DDRPHY_PUB_RID&16'h0FFF)
    'h100 :   apb_wr(`DWC_DDRPHYA_APBONLY0_SequencerOverride,  16'h0600); //'h100 is dev
    'h1?? :   apb_wr(`DWC_DDRPHYA_APBONLY0_SequencerOverride,  16'h0400); 
    'h2?? :   apb_wr(`DWC_DDRPHYA_APBONLY0_SequencerOverride,  16'h0600); 
    default : `uvm_error($sformatf("%m"),$sformatf("Unknown PUBID 0x%X",`DWC_DDRPHY_PUB_RID)) 
  endcase
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroReset, 16'h1); // Stall ARC
  apb_wr(`DWC_DDRPHYA_DRTUB0_UcclkHclkEnables, 16'h2); // disable uC clk ,
  //read all CSRs after quickboot fw, and compare them with the trainingPhyState
  phy_csr_state_chk.getPhyState(phy_csr_state_chk.phyState);
  phy_csr_state_checker_run = phy_csr_state_chk.do_check();
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel   ,1);
endtask
  
task automatic load_image( string fn );
  int fd;
  int ret;
  int unsigned a=0,d=0;
  string inline;

  fd = $fopen(fn,"r");
  if(!fd)
    `uvm_fatal($sformatf("%m"),"Could not open file")
  while(!$feof(fd)) begin
    ret = $fscanf(fd,"apb_wr(32'h%x, 16'h%x);",a,d);
    if(ret==2) begin
      apb_wr(a,d);
    end
  end
endtask



task automatic save_reg_quickboot(string inFile = "reglist_quickboot.txt", string outFile = "saved_regs_quickboot.txt");
  int fhi,fho;
  int unsigned a,d;
  int ret;
  int unsigned MicroContMuxSel;

  apb_rd(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 0);
  fhi = $fopen(inFile,"r");
  fho = $fopen(outFile,"w");
  if(!fhi)
    `uvm_fatal($sformatf("%m"),"Could not open file")

  while(!$feof(fhi)) begin
    ret = $fscanf(fhi,"dwc_ddrphy_apb_rd(32'h%x)",a);
    if(ret==1) begin
      apb_rd(a,d);
      $fwrite(fho, "%h,%h\n",a,d);
    end
  end
  $fclose(fhi);
  $fclose(fho);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);
endtask




task automatic restore_reg_quickboot(string inFile = "saved_regs_quickboot.txt");
  int fhi;
  int unsigned a,d;
  int unsigned count;
  int unsigned offst;
  int ret;

  offst = 32'h200 + 32'h58000;  //quickboot is restored in DMEM, just after the MsgBlk
  $display ($time, " <%m> INFO: restore csr in Dmem  start ... \n"  );
  fhi = $fopen(inFile,"rb");
  if(!fhi)
    `uvm_fatal($sformatf("%m"),"Could not open file")
  while(!$feof(fhi)) begin
    ret = $fscanf(fhi," %h,%h\n",a,d);
    if(ret==2) begin
      apb_wr(offst+count, d);
    end
    count++;
  end
  $display ($time, " <%m> INFO: restore csr in Dmem  complete ... \n"  );
  $fclose(fhi);
endtask


task automatic save_acsm_sram_quickboot();
  int unsigned MicroContMuxSel;
  reg [15:0] data;
  acsm_sram_quickboot = '{default:0};
  apb_rd(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 0);
  $display ($time, " <%m> INFO: save_acsm_sram_quickboot  in progress ... \n"  );
  for (int sram_addr=0; sram_addr<1024; sram_addr++) begin
    for (int half_byte=0; half_byte<4; half_byte++) begin
      apb_rd((20'h41000 + (sram_addr*4) + half_byte ),   data);
      acsm_sram_quickboot[sram_addr] = acsm_sram_quickboot[sram_addr] | (data<<(16*half_byte));
    end
  end
  $display ($time, " <%m> INFO: save_acsm_sram_quickboot  completed  ... \n"  );
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);
endtask


task automatic restore_acsm_sram_quickboot();
  int unsigned MicroContMuxSel;
  reg [15:0] data;
  $display ($time, " <%m> INFO: restore_acsm_sram_quickboot  in progress ... \n"  );
  apb_rd(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, 0);
  for (int sram_addr=0; sram_addr<1024; sram_addr++) begin
    for (int half_byte=0; half_byte<4; half_byte++) begin
      data = (acsm_sram_quickboot[sram_addr]>>(16*half_byte)) &  16'hFFFF;
      apb_wr((20'h41000 + (sram_addr*4) + half_byte ),   data);
    end
  end
  $display ($time, " <%m> INFO: restore_acsm_sram_quickboot  completed ... \n"  );
  apb_wr(`DWC_DDRPHYA_APBONLY0_MicroContMuxSel, MicroContMuxSel);
endtask
`endif



task automatic dwc_ddrphy_phyinit_userCustom_J_enterMissionMode(chandle ctx);
  $display("In dwc_ddrphy_phyinit_userCustom_J_enterMissionMode");
  cfg.PState = cfg.NumPStates - 1;  //after init, the pub Pstate=cfg.NumPStates - 1, TB should keep consistance with pub
  `ifndef DFI_MODE1
  fork
    begin
      top.dfi0.start_init;
    end
    begin
      top.dfi1.start_init;
    end
  join
  `else
    top.dfi0.start_init;
  `endif
endtask

task automatic dwc_ddrphy_phy_warm_reset();
$display("In dwc_ddrphy_phy_warm_reset");
test.top.clk_rst_drv.warm_reset();
endtask 

//-------------------------------------------------------------------------
// Utility tasks for test case
//-------------------------------------------------------------------------

task automatic device_init(bit freq_change=0, bit [1:0] PState=0);
  $display("Start device init , freq_change = %0d, PState = %0d .",freq_change,PState);
  `ifdef LP4_STD
      fork
      begin
        top.dfi0.lpddr4_dev_init(freq_change, PState);
      end
      `ifndef DFI_MODE1 
      begin    
        top.dfi1.lpddr4_dev_init(freq_change, PState);
      end
      `endif
      join
  `endif 
  `ifdef LP5_STD
    `ifdef SVT_DFI
      fork
      begin
        top.dfi0.lpddr5_dev_init(freq_change, PState);
      end
      `ifndef DFI_MODE1 
      begin    
        top.dfi1.lpddr5_dev_init(freq_change, PState);
      end
      `endif
      join
    `endif 
  `endif
endtask: device_init

task automatic self_refresh_enter(int pd=0, int dsm=0);
bit [3:0] rank=4'b1110;

`ifdef LP4_STD
//This checker has VIP issue, which should be re-enabled after fixed.Close them after SRE. 
  set_ca_invalid_check(0);
  set_invalid_command_combination_recieved_check(0);
  for (int i=0; i<cfg.NumRank_dfi0;i++)begin
    des(50); // Clean CKE turns to low inexpertly
    fork
     begin
       top.dfi0.lpddr4_sre(rank);
     end
     `ifndef DFI_MODE1
     begin
       top.dfi1.lpddr4_sre(rank);
     end
     `endif
    join
    rank = {rank[2:0],1'b1};
  end
`endif
`ifdef LP5_STD
  rank=4'b1110;
  for (int i=0; i<cfg.NumRank_dfi0;i++)begin //SRE
    des(50); // Clean CKE turns to low inexpertly
    fork
      begin
        top.dfi0.lpddr5_sre(rank,pd,dsm);
      end
      `ifndef DFI_MODE1
         begin
           top.dfi1.lpddr5_sre(rank,pd,dsm);
         end
      `endif
    join
    rank = {rank[2:0],1'b1};
  end
`endif

endtask: self_refresh_enter

task automatic self_refresh_exit();
//LPDDR4 exit self-refresh
bit [3:0] rank=4'b1110;
`ifdef LP4_STD
  for (int i=0; i<cfg.NumRank_dfi0;i++)begin
    des(50);
    fork
     begin
       top.dfi0.lpddr4_srx(rank);
     end
     `ifndef DFI_MODE1
     begin
       top.dfi1.lpddr4_srx(rank);
     end
     `endif
    join
    rank = {rank[2:0],1'b1};
  end
//Open them after SRX. 
  set_ca_invalid_check(1);
  set_invalid_command_combination_recieved_check(1);
  beat_time(.Time(140_000), .pstate(cfg.PState));//tXSR=140ns
`endif //LP4_STD
`ifdef LP5_STD
  for (int i=0; i<cfg.NumRank_dfi0;i++)begin
    fork
     begin
       top.dfi0.lpddr5_srx(rank);
     end
     `ifndef DFI_MODE1
     begin
       top.dfi1.lpddr5_srx(rank);
     end
     `endif
    join
    rank = {rank[2:0],1'b1};
  end
  beat_time(.Time(380_000), .pstate(cfg.PState)); max_time(7_500,2);//tXSR>tRFCab(380ns) + Max(7.5ns, 2nCK)
`endif
endtask: self_refresh_exit

task automatic power_down_enter();
bit [3:0] rank=4'b1110;

  `ifdef LP4_STD
    rank=4'b1110;
    for (int i=0; i<cfg.NumRank_dfi0;i++)begin //PDE
    des(50);//tCKE>=max(7.5ns 4nCK).
      fork
        begin  
          top.dfi0.lpddr4_pde(rank);
          repeat(50) @(posedge top.dfi_ctl_clk);
          end
        `ifndef DFI_MODE1
        begin  
          top.dfi1.lpddr4_pde(rank);
          repeat(50) @(posedge top.dfi_ctl_clk);
        end
        `endif
      join
    end
  `endif

  `ifdef LP5_STD
    rank=4'b1110;
    for (int i=0; i<cfg.NumRank_dfi0;i++)begin //PDE
      fork
        begin
          top.dfi0.lpddr5_pde(rank);
          //tCKE>=max(7.5ns 4nCK).
          des(50);
        end
        `ifndef DFI_MODE1
          begin
            top.dfi1.lpddr5_pde(rank);
          //tCKE>=max(7.5ns 4nCK).
          des(50);
          end
        `endif
      join
      rank = {rank[2:0],1'b1};
    end
  `endif
endtask: power_down_enter


`ifndef ATE_TEST
task automatic power_down_exit();
bit [3:0] rank=4'b1110;

  for (int i=0; i<cfg.NumRank_dfi0;i++)begin //PDX
    fork
      begin  
        des(50);
        top.dfi0.pdx(rank);
        end
      `ifndef DFI_MODE1
      begin  
        des(50);
        top.dfi1.pdx(rank);
      end
      `endif
    join
    rank = {rank[2:0],1'b1};
  end
  max_time(7_500,3);  //tXP=max(7.5ns,3nCK)

  `ifdef LP5_STD
    rank=4'b1110;
    for (int i=0; i<cfg.NumRank_dfi0;i++)begin //zq_calib_stop_tzqoff_check
      fork
        begin
          top.dfi0.lpddr5_mrs(rank,'h1c,'b0); 
        end
        `ifndef DFI_MODE1
           begin
             top.dfi1.lpddr5_mrs(rank,'h1c,'b0); 
           end
        `endif
      join
      rank = {rank[2:0],1'b1};
    end
  `endif
endtask: power_down_exit
`endif

task automatic init;
  bit [3:0] rank=4'b1110;
  #1 cfg.PState = 0;
  read_pmu_string_file();
  catcher = new();
  uvm_report_cb::add(null,catcher);
  catcher.error_enable = 0;

  $display("[%0t] <%m> common_test_inc: init", $time);

  `ifdef USER_TEST
    pre_phyinit(); 
  `endif

  if(!cfg.disable_phyinit) begin
    apb_config_all();           //Load image, then enter mission mode. init_complete
  end

  `ifdef USER_TEST
    post_phyinit(); 
  `endif

  if(cfg.skip_train == 1) begin
    `ifdef USER_TEST
      pre_devinit(); 
    `endif
    des(42);
    //device_init(.freq_change(0),.PState(cfg.PState)); 
      for(int i=0; i<cfg.NumPStates; i++) begin
       device_init(.freq_change(1),.PState(i));
      end
    `ifdef USER_TEST
      post_devinit();
    `endif 
  end else begin
    `ifdef LP5_STD
      // Config 8B Mode.
      rank='b1110;
      for( int i=0;i< cfg.NumRank_dfi0;i++)begin
        `ifndef DFI_MODE1
          fork
            begin
              top.dfi0.lpddr5_mrs(rank,'h3,cfg.MR3[0]);
              for(int i=0; i<50;i++)begin
              top.dfi0.lpddr5_des();
              end
            end
            begin
              top.dfi1.lpddr5_mrs(rank,'h3,cfg.MR3[0]);
              for(int i=0; i<50;i++)begin
              top.dfi1.lpddr5_des();
              end
            end
          join
        `else
          top.dfi0.lpddr5_mrs(rank,'h3,cfg.MR3[0]);
          for(int i=0; i<50;i++)begin
          top.dfi0.lpddr5_des();
          end
        `endif 
        rank = {rank[2:0],1'b1};
      end
    `endif
    `ifdef LP4_STD
      power_down_exit();
    `endif          
    // Training FW puts device into self-refresh
    self_refresh_exit();// exit self-refresh
  end
endtask: init


task automatic refresh (int ab=1, bit [3:0] rank=0, bit[3:0] my_ba=0, bit[1:0] my_bg=0);
  `ifndef DFI_MODE1
    fork
      begin
        top.dfi0.dfi_refresh(ab,rank,my_ba,my_bg);
      end
      begin
        top.dfi1.dfi_refresh(ab,rank,my_ba,my_bg);
      end
    join
  `else
     top.dfi0.dfi_refresh(ab,rank,my_ba,my_bg);
  `endif 
  beat_time(.Time(380_000), .pstate(cfg.PState));//tRFCab=380ns
endtask



task automatic activate(bit [3:0] rank, bit[2:0] my_bg, bit[3:0] my_ba, bit[16:0] my_row);
  //repeat(550) @(posedge top.dfi_clk);
  `ifdef  LP5_STD
    `ifndef DFI_MODE1
      fork
        begin
          top.dfi0.lpddr5_activate(rank,my_ba,my_bg,my_row);
        end
         begin
           top.dfi1.lpddr5_activate(rank,my_ba,my_bg,my_row);
        end
      join
    `else
       top.dfi0.lpddr5_activate(rank,my_ba,my_bg,my_row);
    `endif  
  `else
   `ifndef DFI_MODE1
    fork
      begin
        top.dfi0.lpddr4_activate(rank,my_ba,my_row);
      end
      begin
        top.dfi1.lpddr4_activate(rank,my_ba,my_row);
      end
    join
  `else
     top.dfi0.lpddr4_activate(rank,my_ba,my_row);
  `endif 
  `endif  
  endtask: activate


task cas (bit [3 :0] rank, bit [2:0] sync_type = 3'b0);
  `ifdef LP5_STD
  $display("common send CAS command , sync_type=%0b",sync_type);
  `ifndef DFI_MODE1
  fork
    begin
      top.dfi0.lpddr5_cas(rank,sync_type);
    end
    begin
      top.dfi1.lpddr5_cas(rank,sync_type);
    end
  join
  `else
     top.dfi0.lpddr5_cas(rank,sync_type);
  `endif 
  `endif 
endtask 
//-----------------------------this function is used to reverse data for DBI
function bit [8*`DWC_DDRPHY_NUM_DBYTES -1:0] fun_dbi_extend(bit [8*`DWC_DDRPHY_NUM_DBYTES -1:0] din);
int count = 0;
    for(int i=0; i<`DWC_DDRPHY_NUM_DBYTES; i=i+1)
        for(int j=0; j<8; j=j+1)
          begin
            count=((din[i*8 +j]==1'b1)? (count + 1):count) ;
            if(j == 7)
             begin
              if(count > 4)
                for(int a=0;a<8;a++)
                  fun_dbi_extend[i*8+a] =(~ din[i*8+a]);
              else
                for(int a=0;a<8;a++)
                  fun_dbi_extend[i*8+a] =( din[i*8+a]);
              count = 0;
             end
          end
endfunction
//-----------------------------this function is used to generate dfi_wrdata_mask_pN for DBI
function bit [`DWC_DDRPHY_NUM_DBYTES -1:0] fun_dbi_extend_mask_w(bit [8*`DWC_DDRPHY_NUM_DBYTES -1:0] din);
int count = 0;
    for(int i=0; i<`DWC_DDRPHY_NUM_DBYTES; i=i+1)
        for(int j=0; j<8; j=j+1)
          begin
            count=((din[i*8 +j]==1'b1)? (count + 1):count) ;
            if(j == 7)
             begin
              fun_dbi_extend_mask_w[i]=(count>4)? 1'b1:1'b0;
              count = 0;
             end
          end
endfunction

task automatic wrs(bit [3:0] rank, bit[2:0] my_bg, bit[3:0] my_ba, bit[10:0] my_col,bit[16:0] my_row=17'h30);

  reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] data_DBI[32];
  reg [`DWC_DDRPHY_NUM_DBYTES-1:0] data_dm_DBI[32];
  $display("[%0t] <%m> Begin write command, base data_id=%0d.", $time, data_id);
  `ifdef LP5_STD
  for(int k=0;k<32;k++) begin
  `else
  for(int k=0;k<16;k++) begin
  `endif
  `ifdef DWC_DDRPHY_HWEMUL
    if((`EMUL_BUBBLE == 0) && (data_id>511) || (data_id > 16999)) data_id=0;
  `endif
    data_DBI[k] = DATA[data_id];
    if(W_DBI||W_DM) begin
      data_DBI[k] = fun_dbi_extend(DATA[data_id]);
      data_dm_DBI[k] = fun_dbi_extend_mask_w(DATA_DM[data_id]);
    end else begin
	`ifdef LP5_STD 
      data_dm_DBI[k] = {`DWC_DDRPHY_NUM_DBYTES{1'bz}};
	`else
      data_dm_DBI[k] = 0;
	`endif	
    end
    data_id++;
  end
`ifdef LP4_STD  
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr4_wrs16(rank,my_ba,my_col[9:0],data_DBI[0:15],data_dm_DBI[0:15]);
      end
      begin
        top.dfi1.lpddr4_wrs16(rank,my_ba,my_col[9:0],data_DBI[0:15],data_dm_DBI[0:15]);
      end
    join
  `else
      top.dfi0.lpddr4_wrs16(rank,my_ba,my_col[9:0],data_DBI[0:15],data_dm_DBI[0:15]);
  `endif  
  `elsif LP5_STD
    `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr5_wrs(rank,my_bg,my_ba,my_col[5:0],data_DBI,data_dm_DBI);
      end
      begin
        top.dfi1.lpddr5_wrs(rank,my_bg,my_ba,my_col[5:0],data_DBI,data_dm_DBI);
      end
    join
    `else
       top.dfi0.lpddr5_wrs(rank,my_bg,my_ba,my_col[5:0],data_DBI,data_dm_DBI);
    `endif  
  `endif  
endtask: wrs

task automatic rds(bit [3:0] rank, bit[2:0] my_bg, bit[3:0] my_ba, bit[10:0] my_col, bit ap=1, bit [16:0] my_row=17'h30);
  //repeat(42) @(posedge top.dfi_clk);
  `ifdef  LP4_STD 
      fork
        begin
          top.dfi0.lpddr4_rds16(rank,my_ba,my_col[9:0],ap);
        end
    `ifndef DFI_MODE1 
        begin
          top.dfi1.lpddr4_rds16(rank,my_ba,my_col[9:0],ap);
        end
    `endif
      join
  `elsif LP5_STD 
    fork
      begin
        top.dfi0.lpddr5_rds(rank,my_bg,my_ba,my_col[5:0],ap);
      end
    `ifndef DFI_MODE1 
        begin
          top.dfi1.lpddr5_rds(rank,my_bg,my_ba,my_col[5:0],ap);
        end
    `endif
    join
  `endif  
endtask: rds

task w2w (bit [3:0] rank0, bit [2:0] my_ba0, bit [9:0] my_col0,bit [3:0] rank1, bit [2:0] my_ba1, bit [9:0] my_col1,int bubble=16/2 -4, reg[`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] addr_des[16]=ADDR);
  reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] data[16];
  for(int k=0;k<16;k++) begin
    data[k] = DATA[data_id];
    data_id++;
  end
  `ifdef SVT_DFI
  `ifdef LP4_STD 
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr4_w2w(rank0[1:0],my_ba0,my_col0,rank1[1:0],my_ba1,my_col1,bubble,data,addr_des);
      end
      begin
        top.dfi1.lpddr4_w2w(rank0[1:0],my_ba0,my_col0,rank1[1:0],my_ba1,my_col1,bubble,data,addr_des);
      end
    join
  `else
      top.dfi0.lpddr4_w2w(rank0[1:0],my_ba0,my_col0,rank1[1:0],my_ba1,my_col1,bubble,data,addr_des);
  `endif
  `endif 
  `endif 
endtask: w2w

task wr_b2b(bit [3:0] rank, bit[2:0] my_bg, bit[2:0] my_ba, bit[10:0] my_col, int b2b_num);
`ifndef SVT_DFI  
  `ifdef DDR4_STD
    top.dfi0.ddr4_wr_b2b(.rank(rank),.my_bg(my_bg),.my_ba(my_ba),.my_col(my_col[9:0]),.b2b_num(b2b_num));
  `elsif LP4_STD  
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr4_wr_b2b(rank,my_ba,my_col[9:0],.b2b_num(b2b_num));
      end
      begin
        top.dfi1.lpddr4_wr_b2b(rank,my_ba,my_col[9:0],.b2b_num(b2b_num));
      end
    join
  `else
     top.dfi0.lpddr4_wr_b2b(rank,my_ba,my_col[9:0],.b2b_num(b2b_num));
  `endif  
  `endif  
`endif  
endtask 

task wr_b2b_pw(bit [3:0] rank[4], bit[2:0] my_bg[4], bit [2:0] my_ba[8], bit [9:0] my_col[4], int b2b_num,bit [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[32]=DATA[0:31],bit [`DWC_DDRPHY_NUM_DBYTES-1:0] Data_dm[32]=DATA_DM[0:31],bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr_des[16]=ADDR,int bubble=init_bubble);

reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data_DBI[32];
reg [`DWC_DDRPHY_NUM_DBYTES-1:0] Data_dm_DBI[32];
for(int k=0;k<32;k++)
  begin
    Data_DBI[k] = Data[k];
    if(W_DBI||W_DM)
     Data_dm_DBI[k] = Data_dm[k];
    else
     Data_dm_DBI[k] = 0;
  end
  
  `ifdef LP4_STD
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr4_wr_b2b(rank,my_ba,my_col,b2b_num,Data_DBI[0:15],Data_dm_DBI[0:15],Addr_des,bubble);
      end
      begin
        top.dfi1.lpddr4_wr_b2b(rank,my_ba,my_col,b2b_num,Data_DBI[0:15],Data_dm_DBI[0:15],Addr_des,bubble);
      end
    join
  `else
     top.dfi0.lpddr4_wr_b2b(rank,my_ba,my_col,b2b_num,Data_DBI[0:15],Data_dm_DBI[0:15],Addr_des,bubble);
  `endif  
  `endif  
  `ifdef LP5_STD
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr5_wr_b2b(rank,my_bg,my_ba,my_col,b2b_num,Data_DBI,Data_dm_DBI,Addr_des,bubble);
      end
      begin
        top.dfi1.lpddr5_wr_b2b(rank,my_bg,my_ba,my_col,b2b_num,Data_DBI,Data_dm_DBI,Addr_des,bubble);
      end
    join
  `else
     top.dfi0.lpddr5_wr_b2b(rank,my_bg,my_ba,my_col,b2b_num,Data_DBI,Data_dm_DBI,Addr_des,bubble);
  `endif  
  `endif


endtask

task rd_b2b_pw(bit [3:0] rank[4], bit[2:0] my_bg[4], bit [2:0] my_ba[8], bit [9:0] my_col[4], int b2b_num,bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] Addr_des[16]=ADDR,int bubble=init_bubble);
  `ifdef LP4_STD 
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr4_rd_b2b(rank,my_ba,my_col,b2b_num,Addr_des,bubble);
      end
      begin
        top.dfi1.lpddr4_rd_b2b(rank,my_ba,my_col,b2b_num,Addr_des,bubble);
      end
    join
  `else
     top.dfi0.lpddr4_rd_b2b(rank,my_ba,my_col,b2b_num,Addr_des,bubble);
  `endif  
  `endif  
 `ifdef LP5_STD
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr5_rd_b2b(rank,my_bg,my_ba,my_col,b2b_num,Addr_des,bubble);
      end
      begin
        top.dfi1.lpddr5_rd_b2b(rank,my_bg,my_ba,my_col,b2b_num,Addr_des,bubble);
      end
    join
  `else
     top.dfi0.lpddr5_rd_b2b(rank,my_bg,my_ba,my_col,b2b_num,Addr_des,bubble);
  `endif  
  `endif
endtask

// -------------------------------------------------------------------------------
// AC pattern generation for b2b task
// -------------------------------------------------------------------------------
function ac_pattern_generation(output bit [9:0] col[4], output bit [2:0] bg[4], output bit [2:0] bank[8]);
`ifdef LP4_STD
  col[0] = 10'h00;
  col[1] = 10'h10;
  col[2] = 10'h20;
  col[3] = 10'h30;
`endif
`ifdef LP5_STD
  col[0] = 10'h00;
  col[1] = 10'h30;
  col[2] = 10'h00;
  col[3] = 10'h30;
`endif
  bg[0] = 3'h0;
  bg[1] = 3'h0;
  bg[2] = 3'h0;
  bg[3] = 3'h0;
  bank[0] = 3'h0;
  bank[1] = 3'h1;
  bank[2] = 3'h2;
  bank[3] = 3'h3;
  bank[4] = 3'h4;
  bank[5] = 3'h5;
  bank[6] = 3'h6;
  bank[7] = 3'h7;
endfunction

task automatic long_wrs( bit [3:0] rank[4]    ,
            bit [2:0] my_bg[4]   ,
            bit [2:0] my_ba[8]   ,
            bit [9:0] my_col[4]  ,
            bit [16:0] my_row,
            int        bubble=init_bubble,
            int        b2b_num=init_b2b_num
            );
int bank=0;
`ifdef LP5_STD
int burst_per_bank = 2;
`else
int burst_per_bank=4;
`endif

  $display("[%0t] <%m> Begin long write command, data_id=%0d.", $time, data_id);
for(int j=0; j<(b2b_num/burst_per_bank); j++) begin // Num of WR command per bank
  for(int i=0; i<burst_per_bank;i++) begin
    wrs(rank[0],my_bg[0],my_ba[bank%8],my_col[i%burst_per_bank]);
    des(bubble);
  end
  bank++;
end
for(int j=0; j<(b2b_num%burst_per_bank); j++) begin // Compensate if b2b_num is odd
  wrs(rank[0],my_bg[0],my_ba[bank%8],my_col[j]);
  des(bubble);
end
endtask

task automatic long_rds( bit [3:0] rank[4]    ,
            bit [2:0] my_bg[4]   ,
            bit [2:0] my_ba[8]   ,
            bit [9:0] my_col[4]  ,
            bit [16:0] my_row,
            int        bubble=init_bubble,
            int        b2b_num=init_b2b_num
            );
int bank=0;
`ifdef LP5_STD
int burst_per_bank =2;
`else
int burst_per_bank=4;
`endif
for(int j=0; j<(b2b_num/burst_per_bank); j++) begin // Num of WR command per bank
  for(int i=0; i<burst_per_bank;i++) begin
    rds(rank[0],my_bg[0],my_ba[bank%8],my_col[i%burst_per_bank],0);
    des(bubble);
  end
  bank++;
end
for(int j=0; j<(b2b_num%burst_per_bank); j++) begin // Compensate if b2b_num is odd
  rds(rank[0],my_bg[0],my_ba[bank%8],my_col[j],0);
  des(bubble);
end
endtask


task wr2wr( bit [3:0] rank[4]    ,
            bit [2:0] my_bg[4]   ,
            bit [2:0] my_ba[8]   ,
            bit [9:0] my_col[4]  ,
            bit [3:0] rank2[4]   ,
            bit [2:0] my_bg2[4]  ,
            bit [2:0] my_ba2[8]  ,
            bit [9:0] my_col2[4] ,
            int        bubble=init_bubble,
            int        b2b_num=init_b2b_num
            );
  reg [8*`DWC_DDRPHY_NUM_DBYTES-1:0] data_DBI[32];
  reg [`DWC_DDRPHY_NUM_DBYTES-1:0] data_dm_DBI[32];
  for(int k=0;k<32;k++) begin
    data_DBI[k] = DATA[data_id];
    if(W_DBI||W_DM) begin
      data_DBI[k] = fun_dbi_extend(DATA[data_id]);
      data_dm_DBI[k] = fun_dbi_extend_mask_w(DATA_DM[data_id]);
    end else begin
	`ifdef LP5_STD 
      data_dm_DBI[k] = {`DWC_DDRPHY_NUM_DBYTES{1'bz}};
	`else
      data_dm_DBI[k] = 0;
	`endif	
    end
    data_id++;
  end

  `ifdef LP4_STD
  `ifndef DFI_MODE1 
    fork
      begin
        top.dfi0.lpddr4_wr_b2b(rank,my_ba,my_col,b2b_num,data_DBI[0:15],data_dm_DBI[0:15],ADDR,bubble);
      end
      begin
        top.dfi1.lpddr4_wr_b2b(rank,my_ba,my_col,b2b_num,data_DBI[0:15],data_dm_DBI[0:15],ADDR,bubble);
      end
    join
  `else
     top.dfi0.lpddr4_wr_b2b(rank,my_ba,my_col,b2b_num,data_DBI[0:15],data_dm_DBI[0:15],ADDR,bubble);
  `endif  
  `endif  
  `ifdef LP5_STD
    `ifndef DFI_MODE1 
      fork
        begin
          top.dfi0.lpddr5_wr_b2b(rank,my_bg,my_ba,my_col,b2b_num,data_DBI,data_dm_DBI,ADDR,bubble);
        end
        begin
          top.dfi1.lpddr5_wr_b2b(rank,my_bg,my_ba,my_col,b2b_num,data_DBI,data_dm_DBI,ADDR,bubble);
        end
      join
    `else
       top.dfi0.lpddr5_wr_b2b(rank,my_bg,my_ba,my_col,b2b_num,data_DBI,data_dm_DBI,ADDR,bubble);
    `endif  
  `endif
endtask

task rd2rd ( bit [3:0] rank[4]    ,
            bit [2:0] my_bg[4]   ,
            bit [2:0] my_ba[8]   ,
            bit [9:0] my_col[4]  ,
            bit [3:0] rank2[4]   ,
            bit [2:0] my_bg2[4]  ,
            bit [2:0] my_ba2[8]  ,
            bit [9:0] my_col2[4] ,
            int         bubble=init_bubble,
            int         b2b_num=init_b2b_num
            );

  `ifdef LP4_STD 
    `ifndef DFI_MODE1 
      fork
        begin
          top.dfi0.lpddr4_rd_b2b(rank,my_ba,my_col,b2b_num,ADDR,bubble);
        end
        begin
          top.dfi1.lpddr4_rd_b2b(rank,my_ba,my_col,b2b_num,ADDR,bubble);
        end
      join
    `else
       top.dfi0.lpddr4_rd_b2b(rank,my_ba,my_col,b2b_num,ADDR,bubble);
    `endif  
    `endif  
   `ifdef LP5_STD
    `ifndef DFI_MODE1 
      fork
        begin
          top.dfi0.lpddr5_rd_b2b(rank,my_bg,my_ba,my_col,b2b_num,ADDR,bubble);
        end
        begin
          top.dfi1.lpddr5_rd_b2b(rank,my_bg,my_ba,my_col,b2b_num,ADDR,bubble);
        end
      join
    `else
       top.dfi0.lpddr5_rd_b2b(rank,my_bg,my_ba,my_col,b2b_num,ADDR,bubble);
    `endif  
    `endif

endtask


task wr2rd( bit [ 3:0] rank1   ,
            bit [ 2:0] my_bg1  ,
            bit [ 2:0] my_ba1  ,
            bit [10:0] my_col1 ,
            bit [ 3:0] rank2   ,
            bit [ 2:0] my_bg2  ,
            bit [ 2:0] my_ba2  ,
            bit [10:0] my_col2 ,
            int bubble=init_bubble
            );
  `ifdef LP5_STD
    cas(rank1,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
  `endif
  wrs(rank1,my_bg1,my_ba1,my_col1);
  des(bubble,ADDR);
  rds(rank2,my_bg2,my_ba2,my_col2,0);
endtask

task rd2wr( bit [ 3:0] rank1   ,
            bit [ 2:0] my_bg1  ,
            bit [ 2:0] my_ba1  ,
            bit [10:0] my_col1 ,
            bit [ 3:0] rank2   ,
            bit [ 2:0] my_bg2  ,
            bit [ 2:0] my_ba2  ,
            bit [10:0] my_col2 ,
            int        bubble=init_bubble);
  des(50);
  `ifdef LP5_STD
    `ifdef POWERSIM_WCK_OFF
      cas(rank1,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
    `endif
  `endif
  wrs(rank1, my_bg1, my_ba1, my_col1);
  des(50);
  `ifdef LP5_STD
    `ifdef POWERSIM_WCK_OFF
      cas(rank1,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
    `endif
  `endif
 rds(rank1,my_bg1,my_ba1,my_col1,0);
 des(bubble,ADDR);
 wrs(rank2,my_bg2,my_ba2,my_col2);
 des(50);
  `ifdef LP5_STD
    `ifdef POWERSIM_WCK_OFF
      cas(rank2,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
    `endif
  `endif
 rds(rank2, my_bg2,my_ba2, my_col2,0);
endtask

task rd_b2b(bit [3:0] rank, bit[2:0] my_bg, bit[2:0] my_ba, bit[10:0] my_col, int b2b_num);
endtask 

task automatic precharge_all (bit [3:0] rank);
  `ifdef LP4_STD  
    `ifndef DFI_MODE1
     fork
      begin   
        top.dfi0.lpddr4_precharge_all(.rank(rank));
      end
      begin   
        top.dfi1.lpddr4_precharge_all(.rank(rank));
      end
     join
   `else
     top.dfi0.lpddr4_precharge_all(.rank(rank));
   `endif
  `elsif LP5_STD  
   `ifndef DFI_MODE1
    fork
      begin   
        top.dfi0.lpddr5_precharge_all(.rank(rank));
      end
      begin   
        top.dfi1.lpddr5_precharge_all(.rank(rank));
      end
    join
   `else
     top.dfi0.lpddr5_precharge_all(.rank(rank));
   `endif
  `endif
  max_time(21_000,4);  //tRPab=max(21ns,2nCK)
endtask:precharge_all

task automatic refresh_all (bit [3:0] rank);
  `ifdef LP4_STD  
    fork 
      begin
        top.dfi0.lpddr4_refa(rank);
      end
      `ifndef DFI_MODE1
        begin
          top.dfi1.lpddr4_refa(rank);
        end
      `endif
    join
  `elsif LP5_STD  
    fork 
      begin
        top.dfi0.lpddr5_refa(rank);
      end
      `ifndef DFI_MODE1
        begin
          top.dfi1.lpddr5_refa(rank);
        end
      `endif
    join
  `endif
  beat_time(.Time(380_000), .pstate(cfg.PState));//tRFCab=380ns in 32Gb density
endtask:refresh_all

task automatic dfi_lp (int hold_time = 4);
bit [3:0] rank=4'b1110;
//`ifdef LP4_STD
//  //This checker has VIP issue, which should be re-enabled after fixed.Close them duiring dfi_lp. 
//    set_ca_invalid_check(0);
//    set_invalid_command_combination_recieved_check(0);
//`endif  //LP4_STD
  // dfi_lp_data
  `ifdef DFI_LP_DATA
    repeat(10) @(posedge top.dfi_ctl_clk);
    fork
      begin
        top.dfi0.dfi_lp(.lp_mode(1) , .assert_en(1), .dfi_lp_wakeup(0) );
        repeat(hold_time) @(posedge top.dfi_ctl_clk);
        top.dfi0.dfi_lp(.lp_mode(1) , .assert_en(0), .dfi_lp_wakeup(0) );
      end
      `ifndef DFI_MODE1
      begin
        top.dfi1.dfi_lp(.lp_mode(1) , .assert_en(1), .dfi_lp_wakeup(0) );
        repeat(hold_time) @(posedge top.dfi_ctl_clk);
        top.dfi1.dfi_lp(.lp_mode(1) , .assert_en(0), .dfi_lp_wakeup(0) );
      end
      `endif
    join
  `endif
  // dfi_lp_ctl
  `ifdef DFI_LP_CTRL
    fork
      begin
        des(30);
      end
      begin
        top.dfi0.dfi_lp(.lp_mode(2) , .assert_en(1), .dfi_lp_wakeup(0) );
        des(hold_time);
        //repeat(hold_time) @(posedge top.dfi_ctl_clk);
        top.dfi0.dfi_lp(.lp_mode(2) , .assert_en(0), .dfi_lp_wakeup(0) );
      end
      `ifndef DFI_MODE1
      begin
        top.dfi1.dfi_lp(.lp_mode(2) , .assert_en(1), .dfi_lp_wakeup(0) );
        des(hold_time);
        top.dfi1.dfi_lp(.lp_mode(2) , .assert_en(0), .dfi_lp_wakeup(0) );
      end
      `endif
    join
  `endif
  // dfi_lp_ctl + DRAMCLKSTOP
  `ifdef DFI_LP_CTRL_CLK_DISABLE

    `ifdef LP5_STD
      rank=4'b1110;
      for (int i=0; i<cfg.NumRank_dfi0;i++)begin //zq_calib_stop_during_pd_entry
        fork
          begin
            top.dfi0.lpddr5_mrs(rank,'h1c,'b10); 
          end
          `ifndef DFI_MODE1
             begin
               top.dfi1.lpddr5_mrs(rank,'h1c,'b10); 
             end
          `endif
        join
        rank = {rank[2:0],1'b1};
      end
    `endif
  
    des(50);
    power_down_enter();
    fork
      begin
        top.dfi0.dram_clk_disable(1);
        top.dfi0.dfi_lp(.lp_mode(3) , .assert_en(1), .dfi_lp_wakeup(0) );
        repeat(hold_time) @(posedge top.dfi_ctl_clk); // keep dram in IDLE_POWER_DOWN_STATE 
        top.dfi0.dfi_lp(.lp_mode(3) , .assert_en(0), .dfi_lp_wakeup(0) );
        top.dfi0.dram_clk_disable(0);
      end
      `ifndef DFI_MODE1
      begin
        top.dfi1.dram_clk_disable(1);
        top.dfi1.dfi_lp(.lp_mode(3) , .assert_en(1), .dfi_lp_wakeup(0) );
        repeat(hold_time) @(posedge top.dfi_ctl_clk);
        top.dfi1.dfi_lp(.lp_mode(3) , .assert_en(0), .dfi_lp_wakeup(0) );
        top.dfi1.dram_clk_disable(0);
      end
      `endif
    join
    repeat(10) @(posedge top.dfi_ctl_clk);//tCKCKEH = 3ck
    power_down_exit();
  `endif
  des(50);
endtask

// frequency change
`ifndef ATE_TEST
task automatic pm_fc_wrapper(bit [4:0] next_freq);
  bit [3:0] rank=4'b1110;
  bit [15:0] mr16;
  bit [15:0] mr13;
  $display ("entering pm_fc_wrapper");
  for( int i=1;i< cfg.NumRank_dfi0;i++)begin //number of enabled rank should not more than cfg rank
    rank = {rank[2:0],1'b0};
  end
  precharge_all(rank);
  `ifdef LP5_STD //tRPab=max(21ns 2nCK), cfg.PState updates during freq_change step.
    max_time(21_000,2);
  `elsif LP4_STD //tRPab=max(21ns 4nCK), cfg.PState updates during freq_change step.
    max_time(21_000,4);
  `endif
  //Upon exit from Self Refresh, it is required that at least one REFRESH command (8 per-bank or 1 all-bank) is issued before entry into a subsequent Self Refresh
  //Refresh is needed between  two self_refresh
  refresh();
   `ifdef FSP_DIS
    // For LPDDR4, confgiure MRS before freq_change for PPT
     //device_init(.freq_change(1),.PState(next_freq[1:0]));
      `ifdef LP4_STD
        rank=4'b1110;
        for (int i=0; i<cfg.NumRank_dfi0;i++)begin 
          mr13 = 16'b0000_1000 | cfg.MR13[next_freq[1:0]];// When changing the FSP, the vrcg setting have to be changed into VREF Fast Response at same time.
          fork
            begin
              top.dfi0.lpddr4_mrs(rank,'hd,mr13); //mr13 for fsp_wr and fsp_op
            end
            `ifndef DFI_MODE1
               begin
                 top.dfi1.lpddr4_mrs(rank,'hd,mr13); 
               end
            `endif
          join
          rank = {rank[2:0],1'b1};
        end
        beat_time(.Time(150_000), .pstate(cfg.PState)); //tVRCG_ENABLE = 150 ns
        beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck
        mr13 = 16'b1111_0111 & cfg.MR13[next_freq[1:0]];// When finishing frequency change, the vrcg setting has to be changed into normal at same time.
      `endif

      `ifdef LP5_STD
        rank=4'b1110;
        for (int i=0; i<cfg.NumRank_dfi0;i++)begin 
          mr16 = 16'b0100_0000 | cfg.MR16[next_freq[1:0]];// When changing the FSP, the vrcg setting have to be changed into VREF Fast Response at same time.
          fork
            begin
              top.dfi0.lpddr5_mrs(rank,'h10,mr16); //mr16 for fsp_wr and fsp_op
            end
            `ifndef DFI_MODE1
               begin
                 top.dfi1.lpddr5_mrs(rank,'h10,mr16); //mr16 for fsp_wr and fsp_op
               end
            `endif
          join
          rank = {rank[2:0],1'b1};
        end
        beat_time(.Time(150_000), .pstate(cfg.PState)); //tVRCG_ENABLE = 150 ns
        beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck
        mr16 = 16'b1011_1111 & cfg.MR16[next_freq[1:0]];// When finishing frequency change, the VRCG setting has to be changed into normal at same time.
      `endif
   `endif

`ifdef LP5_STD
  rank=4'b1110;
  for (int i=0; i<cfg.NumRank_dfi0;i++)begin //zq_calib_stop_during_pd_entry
    fork
      begin
        top.dfi0.lpddr5_mrs(rank,'h1c,'b10); 
      end
      `ifndef DFI_MODE1
         begin
           top.dfi1.lpddr5_mrs(rank,'h1c,'b10); 
         end
      `endif
    join
    rank = {rank[2:0],1'b1};
  end
`endif

  self_refresh_enter(0);
  des(2);//tCMDPD
  beat_time(.Time(7_500), .pstate(cfg.PState)); //tCKEHCMD=7.5ns for LPDDR4
  des(60);// Ensure prior cmd finish
    `ifdef LP4_STD
      //After VRCG enabled, invalid Power Down command is received before VRCG disable
      power_down_enter();//ACSM excutes PDX during fc, fix during_clock_stop_with_cke_high_cs_n_high_check
    `endif
  fork 
   begin 
     top.dfi0.dram_clk_disable(1);
     top.dfi0.update_cfg(next_freq[1:0]); // keep the configuration to DFI VIP consistent with DRAM.
     repeat(50) @(posedge top.dfi_ctl_clk);
     top.dfi0.freq_change(next_freq);
     repeat(50) @(posedge top.dfi_ctl_clk);
     top.dfi0.dram_clk_disable(0);
   end
   `ifndef DFI_MODE1
     begin
       top.dfi1.dram_clk_disable(1);
       top.dfi1.update_cfg(next_freq[1:0]); // keep the configuration to DFI VIP consistent with DRAM.
       repeat(50) @(posedge top.dfi_ctl_clk);
       top.dfi1.freq_change(next_freq);
       repeat(50) @(posedge top.dfi_ctl_clk);
       top.dfi1.dram_clk_disable(0);
     end
   `endif
   begin
     fork
       begin
         @ (posedge top.dut.dfi0_init_start);
       end
       `ifndef DFI_MODE1
       begin
         @ (posedge top.dut.dfi1_init_start);
       end
       `endif
     join
     fork
       begin
         @ (negedge top.dut.dfi0_init_complete);
       end
       `ifndef DFI_MODE1
       begin
         @ (negedge top.dut.dfi1_init_complete);
       end
       `endif
     join
     force top.dut.DfiClk = 0;   //Disable dfi_clk of dut
   end
   begin
     fork
       begin
         @ (posedge top.dut.dfi0_init_start);
       end
       `ifndef DFI_MODE1
       begin
         @ (posedge top.dut.dfi1_init_start);
       end
       `endif
     join
     fork
       begin
         @ (negedge top.dut.dfi0_init_start);
       end
       `ifndef DFI_MODE1
       begin
         @ (negedge top.dut.dfi1_init_start);
       end
       `endif
     join
       release top.dut.DfiClk;
   end
  join
 //top.dfi0.dram_clk_disable(0);
 `ifndef DFI_MODE1
 //top.dfi1.dram_clk_disable(0);
 `endif
repeat(50) @(posedge top.dfi_ctl_clk);//tCKCKEH = 3ck
power_down_exit();
des(30);//Cleanm cmd queue
`ifdef LP5_STD
  `ifdef FSP_DIS
    //mr16 = 16'b1011_1111 | cfg.MR16[next_freq[1:0]];// When finishing frequency change, the vrcg setting has to be changed into normal at same time.
    rank=4'b1110;
    for (int i=0; i<cfg.NumRank_dfi0;i++)begin 
      fork
        begin
          top.dfi0.lpddr5_mrs(rank,'h10,mr16); //mr16 for fsp_wr and fsp_op
        end
        `ifndef DFI_MODE1
           begin
             top.dfi1.lpddr5_mrs(rank,'h10,mr16); //mr16 for fsp_wr and fsp_op
           end
        `endif
      join
      rank = {rank[2:0],1'b1};
    end
    beat_time(.Time(150_000), .pstate(cfg.PState)); //tVRCG_ENABLE = 150 ns
    beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck
  `endif
`else 
  `ifdef FSP_DIS
    //mr13 = 16'b1111_0111 & cfg.MR13[next_freq[1:0]];//When finishing frequency change, the vrcg setting has to be changed into normal at same time.
    rank=4'b1110;
    for (int i=0; i<cfg.NumRank_dfi0;i++)begin 
      fork
        begin
          top.dfi0.lpddr4_mrs(rank,'hd,mr13); //mr13 for fsp_wr and fsp_op
        end
        `ifndef DFI_MODE1
           begin
             top.dfi1.lpddr4_mrs(rank,'hd,mr13); 
           end
        `endif
      join
      rank = {rank[2:0],1'b1};
    end
    beat_time(.Time(150_000), .pstate(cfg.PState)); //tVRCG_ENABLE = 150 ns
    beat_time(.Time(250_000), .pstate(cfg.PState)); des();//tFC = 250ns + 0.5ck
  `endif
`endif

 max_time(14_000,5);//tMRD=Max (14ns, 5nCK)
 self_refresh_exit();

`ifdef LP5_STD
 rank=4'b1110;
 for (int i=0; i<cfg.NumRank_dfi0;i++)begin 
   fork
     begin
       if(cfg.NumPStates > 1) top.dfi0.check_datamask_for_pstate(rank); //To check datamask value for fsp based on -dm* option
     end
     `ifndef DFI_MODE1
        begin
          if(cfg.NumPStates > 1) top.dfi1.check_datamask_for_pstate(rank);
        end
     `endif
   join
   rank = {rank[2:0],1'b1};
 end
`endif

endtask //pm_fc_wrapper
`endif


 //LP3/IO retention(S3)
`ifndef ATE_TEST
task automatic pm_lp3_s3_wrapper(bit s3e=1);
  bit [3:0] rank=4'b1110;

////======================SVT_DFI RETENTION==================//
//  $display("[%0t] <%m> [IoRetention SVT]-->Begin Entry Svt_Dfi lp3_retention", $time);
//  //==================================================//
//  //----------------------precharge-------------------//
  for( int i=1;i< cfg.NumRank_dfi0;i++)begin //number of enabled rank should not more than cfg rank
    rank = {rank[2:0],1'b0};
  end
  precharge_all(rank);
    `ifdef LP5_STD //tRPab=max(21ns 2nCK), cfg.PState updates during freq_change step.
      max_time(21_000,2);
    `elsif LP4_STD //tRPab=max(21ns 4nCK), cfg.PState updates during freq_change step.
      max_time(21_000,4);
    `endif
    refresh();// Issue REFRESH between two Two SELF_REFRESH commands to compliance with LPDDR4 JEDEC Spec. Section 4.13
  //==================================================//
  //---------------------refresh entrer---------------//
  //SRE

  `ifdef LP5_STD
    rank=4'b1110;
    for (int i=0; i<cfg.NumRank_dfi0;i++)begin //zq_calib_stop_during_pd_entry
      fork
        begin
          top.dfi0.lpddr5_mrs(rank,'h1c,'b10); 
        end
        `ifndef DFI_MODE1
           begin
             top.dfi1.lpddr5_mrs(rank,'h1c,'b10); 
           end
        `endif
      join
      rank = {rank[2:0],1'b1};
    end
  `endif
  
    des(50);  $display("[%0t] <%m> [IoRetention SVT]-->Begin Svt_Dfi lp3 Self_refresh_enter", $time);
  `ifdef DEEP_SLEEP_MODE
    self_refresh_enter(0, 1);
    des(30);//Ensure SRE finish.
    #4ms; //Minimum Deep Sleep Mode duration time for SDRAM compliance with IDD6DS power specification section 7.5.8
  `else
    self_refresh_enter();
    des(30);//Ensure SRE finish.
  `endif
  //==================================================//
  //--------------------Disable dram ck---------------//
  $display("[%0t] <%m> [IoRetention SVT]-->Begin Svt_Dfi lp3 Disable dram ck", $time);
  `ifndef DEEP_SLEEP_MODE
    power_down_enter();
  `endif
  fork 
    begin
      top.dfi0.dram_clk_disable(1);
    end
  `ifndef DFI_MODE1
    begin
      top.dfi1.dram_clk_disable(1);
    end
  `endif
  join
  //==================================================//
  //----------------dfi proto freq=5`h1f--------------//
  $display("[%0t] <%m> [IoRetention SVT]-->Begin svt_dfi lp3 freq_change_LP3 5'h1f", $time);
  fork 
    begin
      top.dfi0.freq_change_LP3(5'h1f);
    end
  `ifndef DFI_MODE1
    begin
      top.dfi1.freq_change_LP3(5'h1f);
    end
  `endif
  join
  //==================================================//
  //-----------------------retention------------------//
  if(s3e) begin // Enter/exit S3
    //Set the PwrOkIn signal to 0
    //top.clk_rst_drv.deassert_pwrok();
    //Set the BP_RET signal to 1
    $display("[%0t] <%m> [IoRetention SVT]-->Begin entry s3e=1 BP_RET set 1", $time);
    top.clk_rst_drv.assert_ret();
    //Wait for 10ns according to design spec section 6.5.3.1
    #10ns;
    //Turn off the core VDD and VAA supplies
    $display("[%0t] <%m> [IoRetention SVT]-->Begin Turn Off VDD VAA", $time);
    top.clk_rst_drv.deassert_pwrok();
    top.clk_rst_drv.stop_clk_PwrOff();      //The PHY input clocks are not required to toggle when BP_PWROK=0.
    #10ns;
    top.clk_rst_drv.ret_power_down();
    //Wait for some time
    #1000ns;
    //Bring up VDD, VDDQ and VAA
    $display("[%0t] <%m> [IoRetention SVT]-->Begin Bring up VDDQ VAA", $time);
    dwc_ddrphy_phyinit_userCustom_A_bringupPower(phyctx);
    top.clk_rst_drv.assert_reset();        //Start clocks and reset the PHY
    top.clk_rst_drv.deassert_tdr_reset();   //but must be driven LOW at least 10ns prior to the deasserting edge of BP_PWROK.
    #20ns;
    dwc_ddrphy_phyinit_userCustom_B_startClockResetPhy(phyctx);
    //Set the BP_RET signal to 0
    top.clk_rst_drv.deassert_ret();
    @(posedge test.top.dfi_clk);
    test.top.clk_rst_drv.bypass_clk_en = cfg.PllBypass[cfg.PState];
    `ifdef RET_EN
      //Initialize the PHY configuration
      $display("[%0t] <%m> [IoRetention SVT]-->Begin dwc_ddrphy_phyinit_C_initPhyConfig", $time);
      dwc_ddrphy_phyinit_C_initPhyConfig();
      //Reload the save training state
      $display("[%0t] <%m> [IoRetention SVT]-->Begin apb_restore_ret_csrs", $time);
      apb_restore_ret_csrs();
      //Load the PHY Initialization Engine image
      $display("[%0t] <%m> [IoRetention SVT]-->Begin dwc_ddrphy_phyinit_I_loadPIEImage", $time);
      dwc_ddrphy_phyinit_I_loadPIEImage();
    `endif
    //Initialize the PHY to mission mode through a DFI initialization request
    $display("[%0t] <%m> [IoRetention SVT]-->Begin dwc_ddrphy_phyinit_userCustom_J_enterMissionMode", $time);
    dwc_ddrphy_phyinit_userCustom_J_enterMissionMode(phyctx);
  end
  else begin // Exit LP3
    fork 
    begin
      top.dfi0.freq_change(cfg.PState);
    end
    `ifndef DFI_MODE1
    begin
      top.dfi1.freq_change(cfg.PState);
    end
    `endif
    join
  end
  //Enable dram ck
  fork 
    begin
      top.dfi0.dram_clk_disable(0);
    end
  `ifndef DFI_MODE1
    begin
      top.dfi1.dram_clk_disable(0);
    end
  `endif
  join
  repeat(50) @(posedge top.dfi_clk);
  //==================================================//
  //---------------------refrech eixt-----------------//
  //SRX
  $display("[%0t] <%m> [IoRetention SVT]-->Begin svt_dfi lp3 self_refresh_exit", $time);
  des(10);
  `ifdef DEEP_SLEEP_MODE
    #200us; //Delay from Deep Sleep Mode Exit to SRX (min = 200us) spec section 7.5.8
  `endif
  self_refresh_exit();
  //min tXSR=tRFCab + Max(7.5ns, 2nCK)
  beat_time(.Time(380_000), .pstate(cfg.PState));//tRFCab=380ns
  max_time(7_500, 2);
  refresh();
  $display("[%0t] <%m> [IoRetention SVT]-->END IoRetention Flow", $time);
endtask
`endif


//LP2
task automatic pm_fast_standby_wrapper(bit [4:0] next_freq);
  bit [3:0] rank=4'b1110;
  $display ("entering fast_standby");
  for( int i=1;i< cfg.NumRank_dfi0;i++)begin //number of enabled rank should not more than cfg rank
    rank = {rank[2:0],1'b0};
  end
  precharge_all(rank);
  `ifdef LP5_STD //tRPab=max(21ns 2nCK), cfg.PState updates during freq_change step.
    max_time(21_000,2);
  `elsif LP4_STD //tRPab=max(21ns 4nCK), cfg.PState updates during freq_change step.
    max_time(21_000,4);
  `endif
  //Upon exit from Self Refresh, it is required that at least one REFRESH command (8 per-bank or 1 all-bank) is issued before entry into a subsequent Self Refresh
  //Refresh is needed between  two self_refresh
  refresh();

`ifdef LP5_STD
  rank=4'b1110;
  for (int i=0; i<cfg.NumRank_dfi0;i++)begin //zq_calib_stop_during_pd_entry
    fork
      begin
        top.dfi0.lpddr5_mrs(rank,'h1c,'b10); 
      end
      `ifndef DFI_MODE1
         begin
           top.dfi1.lpddr5_mrs(rank,'h1c,'b10); 
         end
      `endif
    join
    rank = {rank[2:0],1'b1};
  end
`endif

  des(50);  $display("[%0t] <%m> [LP2 SVT]-->Begin Svt_Dfi lp2 Self_refresh_enter", $time);
  self_refresh_enter(0);
  des(2);//tCMDPD
  beat_time(.Time(7_500), .pstate(cfg.PState)); //tCKEHCMD=7.5ns for LPDDR4
  des(60);// Ensure prior cmd finish 
  power_down_enter();

  fork 
   begin 
     top.dfi0.dram_clk_disable(1); 
     repeat(50) @(posedge top.dfi_ctl_clk);
     top.dfi0.freq_change(next_freq);
     repeat(50) @(posedge top.dfi_ctl_clk);
     top.dfi0.dram_clk_disable(0);
   end
   `ifndef DFI_MODE1
     begin
       top.dfi1.dram_clk_disable(1);
       repeat(50) @(posedge top.dfi_ctl_clk);
       top.dfi1.freq_change(next_freq);
       repeat(50) @(posedge top.dfi_ctl_clk);
       top.dfi1.dram_clk_disable(0);
     end
   `endif
   begin
     fork
       begin
         @ (posedge top.dut.dfi0_init_start);
       end
       `ifndef DFI_MODE1
       begin
         @ (posedge top.dut.dfi1_init_start);
       end
       `endif
     join
     fork
       begin
         @ (negedge top.dut.dfi0_init_complete);
       end
       `ifndef DFI_MODE1
       begin
         @ (negedge top.dut.dfi1_init_complete);
       end
       `endif
     join
     force top.dut.DfiClk = 0;   //Disable dfi_clk of dut
   end
   begin
     fork
       begin
         @ (posedge top.dut.dfi0_init_start);
       end
       `ifndef DFI_MODE1
       begin
         @ (posedge top.dut.dfi1_init_start);
       end
       `endif
     join
     fork
       begin
         @ (negedge top.dut.dfi0_init_start);
       end
       `ifndef DFI_MODE1
       begin
         @ (negedge top.dut.dfi1_init_start);
       end
       `endif
     join
       release top.dut.DfiClk;
   end
  join
 //top.dfi0.dram_clk_disable(0);
 `ifndef DFI_MODE1
 //top.dfi1.dram_clk_disable(0);
 `endif
repeat(50) @(posedge top.dfi_ctl_clk);//tCKCKEH = 3ck
power_down_exit();
des(30);//Cleanm cmd queue

 max_time(14_000,5);//tMRD=Max (14ns, 5nCK)
 self_refresh_exit();
endtask //fast_standby

task automatic set_tccd_delay();
  tCK  = (1000000.0/cfg.Frequency[0]);
  `ifdef LP5_STD
    //Refer to SPEC section 7.2.2 or section 8.1(Or search key word tWTR)
    wtr      = `CEIL(12000,tCK);
    tWTR     = (cfg.Frequency[0] > 333)? wtr : 4; //tWTR = max(12ns, 4nck)
    tWCK2DQO = `CEIL(1000,tCK);

    same_wr2wr_tCCD = 32/((cfg.DfiFreqRatio[0] == 1) ? 4 : 8 ) - 1;//BL/n - 1
    same_rd2rd_tCCD = 32/((cfg.DfiFreqRatio[0] == 1) ? 4 : 8 ) - 1;//BL/n - 1
    same_wr2rd_tCCD = 32/((cfg.DfiFreqRatio[0] == 1) ? 4 : 8 ) + cfg.CWL[0] + tWTR - 1;//W-R = BL/n + WL + tWTR - 1 for WCKSYNC timing
    //Description: Minimum delay between READ to WRITE command is tRTW which is equal to (RL+CEIL(tWCKDQO(max)/tCK)+BL/n-WL+RD(tRPST/tCK)) in case of DQ ODT Disable, tRPST will be ignored when Link Write ECC is off, Reference: LPDDR5 Spec.
    same_rd2wr_tCCD = 32/((cfg.DfiFreqRatio[0] == 1) ? 4 : 8 ) + cfg.CL[0] - cfg.CWL[0] + tWCK2DQO;//R-W = BL/n + RL - WL + tWCK2DQO
    //different timing group
    //twckcsgap  = (cfg.DfiFreqRatio[0] == 2)? 1: 3;
    //tWCKENL_RD = cfg.CL[0] + 1 - cfg.tWCKPRE_total_RD[0];
    //wckenL_rd  = (cfg.DfiFreqRatio[0] == 1) ? int'(tWCKENL_RD/2.0) : int'(tWCKENL_RD/4.0));
    //tWCKENL_WR = cfg.CWL[0] + 1 - cfg.tWCKPRE_total_WR[0];
    //wckenl_wr   = (cfg.DfiFreqRatio[0] == 1) ? int'(tWCKENL_WR/2.0) : int'(tWCKENL_WR/4.0));
    //same_wr2rd_tCCD = twckcsgap + cfg.CL[0];
    //`ifndef POWERSIM_WCK_OFF
    //  same_wr2rd_tCCD += 16 + 6 - wckenL_rd; //BL + twckpst - wckenL_rd
    //`else
    //  same_wr2rd_tCCD += 16 + 1 - cfg.CL[0];
    //`endif 
    //same_wr2rd_tCCD -= 1;

    //same_rd2wr_tCCD = cfg.CL[0];//RL
    //`ifndef POWERSIM_WCK_OFF
    //  same_rd2wr_tCCD += 16 + 6 - wckenl_wr; //BL + twckpst - wckenL_rd
    //`else
    //  same_rd2wr_tCCD += 16 + int`(2/cfg.DfiFreqRatio[0]) + (`CEIL(1000,tCK)) - cfg.CWL[0];// BL + tRPST + WCKDQO - WL
    //`endif 
    $display("WL = %0d, BL = 32 , WTR = %0d , RL = %0d , tWTR = %0d , tWCK2DQO = %0d .",cfg.CWL[0],tWTR,cfg.CL[0],tWTR,tWCK2DQO);
  `else
    tDQSCK  = 1500;//ps
    tDQS2DQ = 200;//ps
    DQSCK   = `CEIL(tDQSCK,tCK)  ;
    DQS2DQ  = `CEIL(tDQS2DQ,tCK) ;
    wtr     = `CEIL(10000,tCK)   ;
    tWTR    = (cfg.Frequency[0] > 800)? wtr : 8; //tWTR = max(10ns, 8nck)

    same_wr2wr_tCCD = 16/2 - 4 ; // Fixed BL 16, subtarct 4 since each cmd takes 4MEMCLKS ,this is # MEMCLKS INSERTED BETWEEN W-W
    same_rd2rd_tCCD = 16/2 - 4 ; // Fixed BL 16, subtarct 4 since each cmd takes 4MEMCLKS ,this is # MEMCLKS INSERTED BETWEEN R-R
    same_wr2rd_tCCD = cfg.CWL[0] + 1 + (16/2) + tWTR + 1; // WL + 1 + BL/2 + tWTR/tCK + 1(if tWPST = 1.5tCK), pUserInputAdvanced->WDQSExt = 0x0000;
    same_wr2rd_tCCD -= 4 ; //subtarct 4 since each cmd takes 4MEMCLKS ,this is # MEMCLKS INSERTED BETWEEN W-R
    same_rd2wr_tCCD = cfg.CL[0] + DQSCK + (16/2) + 2 - cfg.CWL[0] + 2; // RL + tDQSCK/tCK + BL/2 + tRPST - WL + tWPRE, pUserInputAdvanced->WDQSExt = 0x0000;
    `ifdef LPDDR4X
      same_rd2wr_tCCD += cfg.CWL[0] - 1;
    `endif
    same_rd2wr_tCCD -= 4; //subtarct 4 since each cmd takes 4MEMCLKS ,this is # MEMCLKS INSERTED BETWEEN R-W
    $display(" Bubble test timing cfg: tCK = 1000000.0/%0d = %0d , `CEIL((1500 - 200),tCK) = %0d ", cfg.Frequency[0],tCK , `CEIL((1500 - 200),tCK));
    $display("WL = %0d, BL = 16 , WTR = %0d , RL = %0d , DQSCK = %0d .",cfg.CWL[0],tWTR,cfg.CL[0],DQSCK);
  `endif

  $display("Bubble test bubble num: same_wr2wr_tCCD = %0d, same_rd2rd_tCCD = %0d , same_rd2wr_tCCD = %0d , same_wr2rd_tCCD = %0d .",same_wr2wr_tCCD, same_rd2rd_tCCD , same_rd2wr_tCCD , same_wr2rd_tCCD);
endtask


task automatic mission_mode_wr_rd();
    `ifdef LP4_STD
      bubble_num = 4 + `EMUL_BUBBLE;
    `else
      `ifdef FREQ_RATIO0_1
        bubble_num = 7 + `EMUL_BUBBLE;
      `else
        bubble_num = 3 + `EMUL_BUBBLE;
      `endif
    `endif
    b2bnum = `EMUL_B2BNNUM;
    `ifdef BUBBLE
      b2bnum = 2;
    `endif 

  ac_pattern_generation(col_b2b, bg_b2b, bank_b2b);
     
  rank = 4'b1110;
  des(500);
  repeat(5) refresh();
  des(300);
  for( int i=0;i< cfg.NumRank_dfi0;i++) begin
    
    rank_b2b[0] = rank;
    rank_b2b[1] = rank;
    rank_b2b[2] = rank;
    rank_b2b[3] = rank;
 

    row = 17'h30;// Reset row for long WR
    foreach(bank_b2b[j]) begin 
      activate(rank, bg_b2b[0], bank_b2b[j], row);
      `ifdef LP4_STD
        max_time(7_500,4);    //LP4: tRRD for data rate 4267
      `else
        max_time(10_000,2);  //LP5: tRRD
      `endif
    end
    des(50);
    `ifdef LP5_STD
      cas(rank,100);
    `endif
    if(`EMUL_BUBBLE > 0) begin //Bubble Pattern.
      for (int i = 0; i < (b2bnum/burst_per_col); i++ ) begin
        long_wrs(rank_b2b, bg_b2b, bank_b2b, col_b2b,row,bubble_num,burst_per_col); // Max num of WR is 16 in one column
        row++;
        des(80);
        precharge_all(rank);
        foreach(bank_b2b[j]) begin 
          activate(rank, bg_b2b[0], bank_b2b[j], row);
          des(80);
        end
      end
      long_wrs(rank_b2b, bg_b2b, bank_b2b, col_b2b,row,bubble_num,(b2bnum%burst_per_col));
    end else begin //b2s pattern, b2bnum needs to be burst_per_col*n
      b2bnum -= (b2bnum/burst_per_col) ? (b2bnum%burst_per_col) : 0;
      $display("[%0t] <%m> Corrected write b2bnum=%0d.", $time, b2bnum);
      long_wrs(rank_b2b, bg_b2b, bank_b2b, col_b2b,row,bubble_num,b2bnum);
    end
 
    des(50);
    `ifdef LP5_STD
      `ifdef POWERSIM_WCK_OFF 
        cas(rank,100);
      `endif
    `endif
    row = 17'h30;// Reset row for RD
    if(`EMUL_BUBBLE > 0) begin //Bubble Pattern.
      des(80);
      precharge_all(rank);
      foreach(bank_b2b[j]) begin 
        activate(rank, bg_b2b[0], bank_b2b[j], row);
        des(80);
      end
 
      for (int i = 0; i < (b2bnum/burst_per_col); i++ ) begin
        long_rds(rank_b2b, bg_b2b, bank_b2b, col_b2b,row,bubble_num,burst_per_col); // Max num of WR is 16 in one column
        row++;
        des(80);
        precharge_all(rank);
        foreach(bank_b2b[j]) begin 
          activate(rank, bg_b2b[0], bank_b2b[j], row);
          des(80);
        end
      end
      long_rds(rank_b2b, bg_b2b, bank_b2b, col_b2b,row,bubble_num,(b2bnum%burst_per_col));
    end else begin //b2b pattern, b2bnum needs to be burst_per_col*n
      b2bnum -= (b2bnum/burst_per_col) ? (b2bnum%burst_per_col) : 0;
      $display("[%0t] <%m> Corrected read b2bnum=%0d.", $time, b2bnum); 
      long_rds(rank_b2b, bg_b2b, bank_b2b, col_b2b,row,bubble_num,b2bnum);
    end
    `ifdef LP5_STD
      des(50);
      if(cfg.MR18[cfg.PState][4] == 1) cas(rank,111); 
    `endif
    des(10);
    precharge_all(rank);
    rank = {rank[2:0],1'b1};
  end
  des(200);   //wait rddata_valid --> 1

endtask //mission_mode_wr_rd




`endif    //add for exclude ATE case 

`ifdef USER_TEST

`include "user_test_file.sv"

`ifndef PRE_PHYINIT
task pre_phyinit(); endtask
`endif
`ifndef POST_PHYINIT
task post_phyinit(); endtask
`endif

`ifndef PRE_DEVINIT
task pre_devinit(); endtask
`endif
`ifndef POST_DEVINIT
task post_devinit(); endtask
`endif

`endif

top top (); 





