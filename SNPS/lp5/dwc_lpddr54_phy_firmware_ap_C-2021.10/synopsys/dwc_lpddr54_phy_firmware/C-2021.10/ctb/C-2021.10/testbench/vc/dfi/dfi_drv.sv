`ifndef SVT_DFI

`ifdef DWC_DDRPHY_NUM_ANIBS_12
  `define DFI_CS_WIDTH 4
`else
  `define DFI_CS_WIDTH 2
`endif
`timescale 1ps/1ps
module dfi_drv 
#(
parameter pDFI_DRV_NUM              = 0
,         pERROR_INFO_WIDTH         = 4
,         pPHYUPD_TYPE_WIDTH        = 2
,         pPHYMSTR_CS_STATE_WIDTH   = 2
,         pPHYMSTR_TYPE_WIDTH       = 2
,         pFREQ_WIDTH               = 5
,         pFREQ_RATIO_WIDTH         = 2
,         pCKE_WIDTH                = 4
,         pCS_WIDTH                 = 4
,         pDRAM_CLK_DIS_WIDTH       = 4
`ifndef DWC_DDRPHY_NUM_ANIBS_6
`ifndef DWC_DDRPHY_NUM_ANIBS_3
,         pBANK_WIDTH               = 3
,         pBG_WIDTH                 = 2
,         pCID_WIDTH                = 3
`endif
`endif
,         pADDRESS_WIDTH            = 4
,         pDFI_PHY_INFO_CMD_WIDTH   = 8
,         pDFI_PHY_INFO_DATA_WIDTH  = 8
,         pDFI_NUM                  = 0
)
(
input clk,

output reg                          init_start,
input                               init_complete,
input                               ctrlupd_ack,
input                               phyupd_req,
input                               phymstr_req,
input                               phymstr_state_sel,
input                               error,
input [pERROR_INFO_WIDTH-1:0]       error_info,
input                               dfi_phy_info_ack,
`ifndef DWC_DDRPHY_NUM_ANIBS_6
`ifndef DWC_DDRPHY_NUM_ANIBS_3
//input                               alert_n_P0,
//input                               alert_n_P1,
//input                               alert_n_P2,
//input                               alert_n_P3,
`endif
`endif 
input [pPHYUPD_TYPE_WIDTH-1:0]      phyupd_type,
input [pPHYMSTR_CS_STATE_WIDTH-1:0] phymstr_cs_state,
input [pPHYMSTR_TYPE_WIDTH -1:0]    phymstr_type,
input                               lp_ctrl_ack,
input                               lp_data_ack,
output reg                          lp_ctrl_req,
output reg                          lp_data_req,
output reg [4:0]                    lp_ctrl_wakeup,
output reg [4:0]                    lp_data_wakeup,
output [pDFI_PHY_INFO_CMD_WIDTH-1:0] dfi_phy_info_cmd,
output [pDFI_PHY_INFO_DATA_WIDTH-1:0] dfi_phy_info_data,
output                               dfi_phy_info_req,                    
output reg [pDRAM_CLK_DIS_WIDTH-1:0] dfi_dram_clk_disable_P0, 
output reg [pDRAM_CLK_DIS_WIDTH-1:0] dfi_dram_clk_disable_P1, 


output reg [pFREQ_WIDTH-1:0]        freq,
output reg [pFREQ_RATIO_WIDTH-1:0]  freq_ratio,

output  [pCKE_WIDTH-1:0]            cke_P0,
output  [pCKE_WIDTH-1:0]            cke_P1,
output  [pCKE_WIDTH-1:0]            cke_P2,
output  [pCKE_WIDTH-1:0]            cke_P3,
output  [pCS_WIDTH-1:0]             cs_P0,
output  [pCS_WIDTH-1:0]             cs_P1,
output  [pCS_WIDTH-1:0]             cs_P2,
output  [pCS_WIDTH-1:0]             cs_P3,

`ifndef DWC_DDRPHY_NUM_ANIBS_6
`ifndef DWC_DDRPHY_NUM_ANIBS_3       	  
//output                              act_n_P0,
//output                              act_n_P1,
//output                              act_n_P2,
//output                              act_n_P3,
//       	  
//output                              ras_n_P0,
//output                              ras_n_P1,
//output                              ras_n_P2,
//output                              ras_n_P3,
//       	  
//output                              cas_n_P0,
//output                              cas_n_P1,
//output                              cas_n_P2,
//output                              cas_n_P3,
//       	  
//output                              we_n_P0,
//output                              we_n_P1,
//output                              we_n_P2,
//output                              we_n_P3,
//
//output                              parity_in_P0,
//output                              parity_in_P1,
//output                              parity_in_P2,
//output                              parity_in_P3,
//
//output  [pBANK_WIDTH-1:0]           bank_P0,
//output  [pBANK_WIDTH-1:0]           bank_P1,
//output  [pBANK_WIDTH-1:0]           bank_P2,
//output  [pBANK_WIDTH-1:0]           bank_P3,
//
//output  [pBG_WIDTH-1:0]             bg_P0,
//output  [pBG_WIDTH-1:0]             bg_P1,
//output  [pBG_WIDTH-1:0]             bg_P2,
//output  [pBG_WIDTH-1:0]             bg_P3,
//
//output  [pCID_WIDTH-1:0]            cid_P0,
//output  [pCID_WIDTH-1:0]            cid_P1,
//output  [pCID_WIDTH-1:0]            cid_P2,
//output  [pCID_WIDTH-1:0]            cid_P3,
`endif
`endif

output  [pADDRESS_WIDTH-1:0]          address_P0,
output  [pADDRESS_WIDTH-1:0]          address_P1,
output  [pADDRESS_WIDTH-1:0]          address_P2,
output  [pADDRESS_WIDTH-1:0]          address_P3
);

timeunit 1ps;
timeprecision 1ps;

reg [3:0][pCKE_WIDTH-1:0] cke = {4*pCKE_WIDTH{1'b0}};
assign {cke_P3,cke_P2,cke_P1,cke_P0} = cke;

`ifdef LP4_STD
reg [3:0][pCS_WIDTH-1:0] cs = {(4*pCS_WIDTH){1'b0}};
`else
reg [3:0][pCS_WIDTH-1:0] cs = {(4*pCS_WIDTH){1'b1}};
`endif

assign {cs_P3,cs_P2,cs_P1,cs_P0} = cs;

reg [3:0] act_n = 4'b1111;
assign {act_n_P3,act_n_P2,act_n_P1,act_n_P0} = act_n;

reg [3:0] ras_n = 4'b1111;
assign {ras_n_P3,ras_n_P2,ras_n_P1,ras_n_P0} = ras_n;

reg [3:0] cas_n = 4'b1111;
assign {cas_n_P3,cas_n_P2,cas_n_P1,cas_n_P0} = cas_n;

reg [3:0] we_n = 4'b1111;
assign {we_n_P3,we_n_P2,we_n_P1,we_n_P0} = we_n;

reg [3:0] parity_in = 4'b0;
assign {parity_in_P3,parity_in_P2,parity_in_P1,parity_in_P0} = 4'b0;

`ifndef DWC_DDRPHY_NUM_ANIBS_6
`ifndef DWC_DDRPHY_NUM_ANIBS_3
reg [3:0][pBANK_WIDTH-1:0] bank = {4*pBANK_WIDTH{1'b0}};
assign {bank_P3,bank_P2,bank_P1,bank_P0} = bank;

reg [3:0][pBG_WIDTH-1:0] bg = {4*pBG_WIDTH{1'b0}};
assign {bg_P3,bg_P2,bg_P1,bg_P0} = bg;

reg [3:0][pCID_WIDTH-1:0] cid = {4*pCID_WIDTH{1'b0}};
assign {cid_P3,cid_P2,cid_P1,cid_P0} = cid;
`endif
`endif

reg [3:0][pADDRESS_WIDTH-1:0] address = {4*pADDRESS_WIDTH{1'b0}};
assign {address_P3,address_P2,address_P1,address_P0} = address;

int sub_lat = 5;

reg lp_error = 0;

initial begin
  #2; // wait to avoid race conditions with cfg 
  init_start = 1'b0;
  freq = 'b0;
  freq_ratio = 'b0;
  lp_ctrl_req = 1'b0;
  lp_data_req = 1'b0;
  lp_ctrl_wakeup = 1'b0;
  lp_data_wakeup = 1'b0;
  dfi_dram_clk_disable_P0 = {pDRAM_CLK_DIS_WIDTH{1'b0}};
  dfi_dram_clk_disable_P1 = {pDRAM_CLK_DIS_WIDTH{1'b0}};
end


task set_wrdata_en_q(bit [pCS_WIDTH -1 :0] rank, int pad, int burst_len, int b2b=0); 
  #1; //make sure pop at next edge
  if(!b2b)begin
    for(int i =0 ; i<pad; i++) begin
      `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      if (pDFI_DRV_NUM==1)
        dfi_data1.wrdata_en_q.push_back(1'b0);
      else
      `endif
        dfi_data0.wrdata_en_q.push_back(1'b0);
 
      //`ifdef LP4_STD
      //dfi_data0.wrdata_cs_q.push_back({pCS_WIDTH{1'b0}});
      //`else
      `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      if (pDFI_DRV_NUM==1)
        dfi_data1.wrdata_cs_q.push_back(1'b0);
      else
      `endif
        dfi_data0.wrdata_cs_q.push_back(1'b0);
      //`endif
    end
  end
  for(int i =0; i<burst_len/2; i++) begin
    if (pDFI_DRV_NUM==1) begin
      `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      dfi_data1.wrdata_en_q.push_back(1'b1);
      dfi_data1.wrdata_cs_q.push_back(~rank);
      `endif
    end
    else begin
      dfi_data0.wrdata_en_q.push_back(1'b1);
      dfi_data0.wrdata_cs_q.push_back(~rank);
    end
  end
endtask

task set_wrdata_q(bit [pCS_WIDTH -1 :0] rank, int pad, int burst_len, int b2b=0, int b2b_num=0); 
  #1; //make sure pop at next edge
  if(!b2b)begin
    for(int i =0 ; i<pad; i++) begin
      `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      if (pDFI_DRV_NUM==1)
        dfi_data1.wrdata_q.push_back('b0);
      else
      `endif
        dfi_data0.wrdata_q.push_back('b0);
    end
  end
  for(int i = b2b_num*burst_len/2; i< ((b2b_num+1)*burst_len/2); i++) begin
    `ifdef DWC_DDRPHY_NUM_CHANNELS_2
    if (pDFI_DRV_NUM==1)
      dfi_data1.wrdata_q.push_back({dfi_data1.data[i*2+1],dfi_data1.data[i*2]});
    else
    `endif
      dfi_data0.wrdata_q.push_back({dfi_data0.data[i*2+1],dfi_data0.data[i*2]});
  end
endtask

task set_rddata_en_q(bit [pCS_WIDTH -1 :0] rank, int pad, int burst_len, int b2b=0); 
  #1; //make sure pop at next edge
  if(!b2b)begin
    for(int i =0 ; i<pad; i++) begin
      if (pDFI_DRV_NUM==1)begin
        `ifdef DWC_DDRPHY_NUM_CHANNELS_2
        dfi_data1.rddata_en_q.push_back(1'b0);
        dfi_data1.rddata_cs_q.push_back(1'b0);
        `endif
      end
      else begin
        dfi_data0.rddata_en_q.push_back(1'b0);
        dfi_data0.rddata_cs_q.push_back(1'b0);
      end
    end
  end
  for(int i =0; i<burst_len/2; i++) begin
    if (pDFI_DRV_NUM==1)begin
      `ifdef DWC_DDRPHY_NUM_CHANNELS_2
      dfi_data1.rddata_en_q.push_back(1'b1);
      dfi_data1.rddata_cs_q.push_back(~rank);
      `endif
    end
    else begin
      dfi_data0.rddata_en_q.push_back(1'b1);
      dfi_data0.rddata_cs_q.push_back(~rank);
    end
  end
endtask
//------------------------------------------
task start_init;
begin
  repeat(20) @(clk); //wait apb mux turns to 'b1
  $display("[%0t] <%m>", $time);
  if(cfg.skip_train == 1) begin
    #20us;//to make sure RESET_n keep low for at least 20us for lpddr4
  end
  init_start = 1'b1;
  cfg.PState = cfg.NumPStates - 1;
  freq = cfg.NumPStates - 1;
  freq_ratio = cfg.DfiFreqRatio[cfg.PState];  
  @(posedge init_complete);
  //In RDIMM skip_train case, Mem reset_n de-asserted the same time as init_complete asserted, wait 500_000 ps
  if(cfg.skip_train ==1 && (cfg.DimmType == CTB_RDIMM || cfg.DimmType == CTB_LRDIMM)) begin
    #500000; 
  end
  repeat (8) @(clk);
  init_start = 1'b0;
  dram_clk_disable(0);
  if(cfg.skip_train ==1) begin
    #270ns; // wait for tXPR
  end
end
endtask
//------------------------------------------
task dram_clk_disable(bit flag);
  repeat (50) @(posedge clk);
  if(flag) begin
    cke = {4*pCKE_WIDTH{1'b0}};
    repeat (50) @(posedge clk);
    dfi_dram_clk_disable_P0 = {pDRAM_CLK_DIS_WIDTH{1'b1}};
    dfi_dram_clk_disable_P1 = {pDRAM_CLK_DIS_WIDTH{1'b1}};
  end else begin
    dfi_dram_clk_disable_P0 = {pDRAM_CLK_DIS_WIDTH{1'b0}};
    dfi_dram_clk_disable_P1 = {pDRAM_CLK_DIS_WIDTH{1'b0}};
    repeat (50) @(posedge clk);
    cke = {4*pCKE_WIDTH{1'b1}};
  end  
endtask
//------------------------------------------
task freq_change(bit [4:0] next_freq);
  int lp2_us = 10;

  $display("[%0t] <%m> dfi_freq=%d", $time, next_freq);
  freq = next_freq;
  if(next_freq!=5'h1f) freq_ratio = cfg.DfiFreqRatio[next_freq[1:0]];  
  repeat (100) @(clk);
  init_start = 1'b1;
  $display("[%0t] <%m> init_start asserted", $time);
  @(negedge init_complete);
  $display("[%0t] <%m> init_complete de-asserted", $time);
  repeat (4) @(posedge clk);
  if(next_freq!=5'h1f) cfg.PState = next_freq[1:0];
  `ifdef DDR4_STD
  if(next_freq!=5'h1f) test.update_timing_parameters();
  `endif
  //Disable dfi_clk
  top.clk_rst_drv.dfi_ctl_clk_en = 1'b0;
  top.clk_rst_drv.dfi_clk_en = 1'b0;
  top.clk_rst_drv.tdr_clk_en = 1'b0;
  #(lp2_us*1000_000);
  //Enable dfi clk
  top.clk_rst_drv.dfi_ctl_clk_en = 1'b1;
  top.clk_rst_drv.dfi_clk_en = 1'b1;
  top.clk_rst_drv.tdr_clk_en = 1'b1;
  repeat (4) @(posedge clk);
  init_start = 1'b0;
  $display("[%0t] <%m> init_start de-asserted", $time);
  @(posedge init_complete);
  $display("[%0t] <%m> init_complete asserted", $time);
  repeat (8) @(posedge clk);
endtask
//------------------------------------------
task dfi_lp_ctrl_assert_req(bit [3:0] dfi_lp_wakeup=0,bit [pDRAM_CLK_DIS_WIDTH-1:0] dfi_dram_clk_dis = {pDRAM_CLK_DIS_WIDTH{1'b0}});    // all command in ideal ,except for CKE 
int tlp_resp=8;
begin
  lp_ctrl_req = 1'b1;
  dfi_dram_clk_disable_P0 = dfi_dram_clk_dis;
  dfi_dram_clk_disable_P1 = dfi_dram_clk_dis;
  lp_ctrl_wakeup = dfi_lp_wakeup;
  $display("The dfi_dram_clk_disable is=%b,,@ %0t",dfi_dram_clk_disable_P0, $time);

  address = {4*pADDRESS_WIDTH{1'b0}};
  act_n = 4'b1111;
`ifndef DWC_DDRPHY_NUM_ANIBS_6
`ifndef DWC_DDRPHY_NUM_ANIBS_3
  bank = {4*pBANK_WIDTH{1'b0}};
  bg = {4*pBG_WIDTH{1'b0}};
  cid = {4*pCID_WIDTH{1'b0}};
`endif
`endif
  ras_n = 4'b1111;
  cas_n = 4'b1111;
  we_n = 4'b1111;
  parity_in = 4'b0;
`ifdef LP4_STD
  cs = {(4*pCS_WIDTH){1'b0}};
`else
  cs = {(4*pCS_WIDTH){1'b1}};
`endif
fork
  begin
  repeat (tlp_resp+2)@(posedge clk);
   lp_error = 1;
  $display("The dfi_lp_ctrl_ack is=%d, exepect to be 1, @ %0t",lp_ctrl_ack, $time);
  end
  begin
   $display("begining,The lp_ctrl_req is=%d,@ %0t",lp_ctrl_req, $time);
   @(lp_ctrl_ack);
   $display("finished,The dfi_lp_ctrl_ack is=%d,,@ %0t",lp_ctrl_ack, $time);
  end
join_any
disable fork;
end
endtask
//--------------------------------------------------------------------
task dfi_lp_data_assert_req(bit [3:0] dfi_lp_wakeup= 4'b0);
int tlp_resp=8;
begin
  lp_data_req = 1'b1;
  lp_data_wakeup = dfi_lp_wakeup;
fork
  begin
  repeat (tlp_resp+2)@(posedge clk);
  lp_error = 1;
  $display("The dfi_lp_data_ack is=%d, exepect to be 1, @ %0t",lp_data_ack, $time);
  end
  begin
  wait(lp_data_ack);
  end
join_any
disable fork;
end
endtask
//--------------------------------------------------------------------
task dfi_lp_ctrl_deassert_req;
  lp_ctrl_req = 1'b0;
  dfi_dram_clk_disable_P0 = {pDRAM_CLK_DIS_WIDTH{1'b0}};
  dfi_dram_clk_disable_P1 = {pDRAM_CLK_DIS_WIDTH{1'b0}};
  //lp_wakeup ='hx ;
endtask
//--------------------------------------------------------------------
task dfi_lp_data_deassert_req;
  lp_data_req = 1'b0;
  //lp_wakeup ='hx ;
endtask
//--------------------------------------------------------------------
// DDR4
//--------------------------------------------------------------------
`ifdef DDR4_STD
//`ifndef DDRPHY_POWERSIM
task automatic drive_ddr4_cmd(bit [pCKE_WIDTH-1:0] t_cke = {pCKE_WIDTH{1'b1}}, 
                    bit [pCS_WIDTH-1:0] t_cs = {pCS_WIDTH{1'b1}},
                    bit t_act_n = 1'b1, 
                    bit t_ras_n = 1'b1, 
                    bit t_cas_n = 1'b1, 
                    bit t_we_n = 1'b1, 
                    bit [1:0] t_bg = 2'b0, 
                    bit [2:0] t_ba = 3'b0,
                    bit [13:0] t_addr = 14'b0,
                    bit [1:0] t_ph = 2'b0);
//`else
//task automatic drive_ddr4_cmd(bit [pCKE_WIDTH-1:0] t_cke = {pCKE_WIDTH{1'b1}}, 
//                    bit [pCS_WIDTH-1:0] t_cs = {pCS_WIDTH{1'b1}},
//                    bit t_act_n = 1'b1, 
//                    bit t_ras_n = 1'b1, 
//                    bit t_cas_n = 1'b1, 
//                    bit t_we_n = 1'b1, 
//                    bit [1:0] t_bg = 2'b0, 
//                    bit [2:0] t_ba = 3'b0,
//                    bit [17:0] t_addr = 18'b0,
//                    bit [1:0] t_ph = 2'b0);
//`endif

  cke[t_ph] = t_cke;
  cs[t_ph] = t_cs;
  act_n[t_ph] = t_act_n;
  ras_n[t_ph] = t_ras_n;
  cas_n[t_ph] = t_cas_n;
  we_n[t_ph] = t_we_n;
  bg[t_ph] = t_bg;
  bank[t_ph] = t_ba;
  address[t_ph] = t_addr;

endtask

task automatic send_rcw(bit [17:0] addr);
  @(posedge clk);
  cs[0] = 'b1110;
  {ras_n[0], cas_n[0], we_n[0]} = 3'b0;
  {bg[0][0],bank[0][1:0]} = 7; //MR7 used for RCW
  address[0] = addr;
  @(posedge clk);
  cs[0] = 4'hF;
  {ras_n[0], cas_n[0], we_n[0]} = 3'b111;
  {bg, bank} = 20'b0;
  address[0] = 18'b0; 
  repeat(50) @(posedge clk);
endtask

task automatic ddr4_send_rcw_before_sre();
  bit [17:0] addr = 0;
  //F0RC0A_D0                    DIMM operating speed, sent before sre for freq_change
                                 //000 :        f <= 1600 : DDR4-1600
                                 //001 : 1600 < f <= 1866 : DDR4-1866
                                 //010 : 1866 < f <= 2133 : DDR4-2133
                                 //011 : 2133 < f <= 2400 : DDR4-2400
                                 //100 : 2400 < f <= 2666 : DDR4-2666
                                 //101 : 2666 < f <= 2933 : DDR4-2933
                                 //110 : 2933 < f <= 3200 : DDR4-3200  
  addr[7:4] = 'ha;
  addr[3:0] = cfg.F0RC0A_D0[cfg.PState];
  send_rcw(addr);
  $display("[%0t] <%m> Write F0RC0A = %h", $time, addr);
  //F0RC3x_D0            (userInputBasic.Frequency[0]*2-1241)/20; //Fine Granularity RDIMM Operating Speed, sent before sre for freq_change
  addr[11:8] = 'h3;
  addr[7:0] = cfg.F0RC3x_D0[cfg.PState];
  send_rcw(addr);
  $display("[%0t] <%m> Write F0RC3x = %h", $time, addr);
  if(cfg.DimmType == CTB_LRDIMM) begin
    //F0BC6x_D0
    addr[12:8] = 'h16;
    addr[7:0] = cfg.F0RC3x_D0[cfg.PState];
    send_rcw(addr);
    $display("[%0t] <%m> Write F0BC6x = %h", $time, addr);
  end
endtask

task automatic ddr4_send_rcw(bit freq_change=0);
  bit [17:0] addr=0;
  if(freq_change == 0)begin
    ddr4_send_rcw_before_sre();
  end
  //F0RC0D_D0
  addr[7:4] = 'hd;
  addr[3:0] = cfg.F0RC0D_D0[cfg.PState]; //No mirror, RDIMM/LRDIMM, direct quad CS
  send_rcw(addr);
  $display("[%0t] <%m> Write F0RC0D = %h", $time, addr);
  //F0RC0F_D0
  addr[7:4] = 'hf;
  addr[3:0] = cfg.F0RC0F_D0[cfg.PState]; //Command Latency Adder Control Word, [0:3]: 1~4CK delay add to CA; 4: 0CK delay add to CA, RCD Init
  send_rcw(addr);
  $display("[%0t] <%m> Write F0RC0F = %h", $time, addr);
  if(cfg.DimmType == CTB_LRDIMM) begin
    //Write to BC09
    //addr[12:0] = {5'h10,4'h9,4'b1000}; //CKE Power Down Mode Enabled. 
    //send_rcw(addr);
    //$display("Write BC09 =%0h",addr);
    //Write to BC0A
    addr[3:0] = cfg.F0RC0A_D0[cfg.PState];
    addr[12:4] = {5'h10,4'ha};
    send_rcw(addr);
    $display("Write BC0A = %0h",addr);
    /*
    // -----------------------------------
    // Set F[1:0]BCCx and F[1:0]BCEx for rank 0-3
    // -----------------------------------
    // Set function space 0 through BC7x
    // -----------------------------------
    addr[12:0] = {5'h17,4'b0,4'b0};
    send_rcw(addr);
    $display("Select function space 0.");
    addr[12:0] = {5'h1c,8'h0};//0nCK receive enable timing latency adder for rank0
    send_rcw(addr);
    $display("Write F0BCCx = %0h",addr);
    addr[12:0] = {5'h1e,8'h0};//0nCK receive enable timing latency adder for rank2
    send_rcw(addr);
    $display("Write F0BCEx = %0h",addr);
    // -----------------------------------
    // Set function space 1 through BC7x
    // -----------------------------------
    addr[12:0] = {5'h17,4'b0,4'b1};
    send_rcw(addr);
    $display("Select function space 1.");
    addr[12:0] = {5'h1c,8'h0};//0nCK receive enable timing latency adder for rank0
    send_rcw(addr);
    $display("Write F1BCCx = %0h",addr);
    addr[12:0] = {5'h1e,8'h0};//0nCK receive enable timing latency adder for rank2
    send_rcw(addr);
    $display("Write F1BCEx = %0h",addr);
    */
    // -----------------------------------
    // Set F4BC2x
    // -----------------------------------
    //addr = {5'h17,4'h0,4'h4};
    //send_rcw(addr);
    //$display("Select function space 4.");
    //addr = {5'h12,cfg.MR2[cfg.PState][12],4'h0,cfg.MR2[cfg.PState][5:3]}; // F4BC2x MRS2 snoop
    //send_rcw(addr);
    /*
    // -----------------------------------
    // Set F[0:3]BC2x BC3x BC4x BC5x
    // -----------------------------------
    // Set function space 0 through BC7x
    // -----------------------------------
    addr[12:0] = {5'h17,4'b0,4'b0};
    send_rcw(addr);
    $display("Select function space 0 for BC2x/BC3x/BC4x/BC5x.");
    addr[12:0] = {5'h12,8'h0};  //F0BC2x
    send_rcw(addr);
    addr[12:0] = {5'h13,8'h0};  //F0BC3x
    send_rcw(addr);
    addr[12:0] = {5'h14,8'h0};  //F0BC4x
    send_rcw(addr,'b1010);
    addr[12:0] = {5'h15,8'h0};  //F0BC5x
    send_rcw(addr);
    // -----------------------------------
    // Set function space 1 through BC7x
    // -----------------------------------
    addr[12:0] = {5'h17,4'b0,4'b1};
    send_rcw(addr);
    $display("Select function space 1 for BC2x/BC3x/BC4x/BC5x.");
    addr[12:0] = {5'h12,8'h0};  //F0BC2x
    send_rcw(addr);
    addr[12:0] = {5'h13,8'h0};  //F0BC3x
    send_rcw(addr);
    addr[12:0] = {5'h14,8'h0};  //F0BC4x
    send_rcw(addr);
    addr[12:0] = {5'h15,8'h0};  //F0BC5x
    send_rcw(addr);    
    // -----------------------------------
    // Set function space 2 through BC7x
    // -----------------------------------
    addr[12:0] = {5'h17,4'b0,4'h2};
    send_rcw(addr);
    $display("Select function space 2 for BC2x/BC3x/BC4x/BC5x.");
    addr[12:0] = {5'h12,8'h0};  //F0BC2x
    send_rcw(addr);
    addr[12:0] = {5'h13,8'h0};  //F0BC3x
    send_rcw(addr);
    addr[12:0] = {5'h14,8'h0};  //F0BC4x
    send_rcw(addr);
    addr[12:0] = {5'h15,8'h0};  //F0BC5x
    send_rcw(addr); 
    // -----------------------------------
    // Set function space 3 through BC7x
    // -----------------------------------
    addr[12:0] = {5'h17,4'b0,4'h3};
    send_rcw(addr);
    $display("Select function space 3 for BC2x/BC3x/BC4x/BC5x.");
    addr[12:0] = {5'h12,8'h0};  //F0BC2x
    send_rcw(addr);
    addr[12:0] = {5'h13,8'h0};  //F0BC3x
    send_rcw(addr);
    addr[12:0] = {5'h14,8'h0};  //F0BC4x
    send_rcw(addr);
    addr[12:0] = {5'h15,8'h0};  //F0BC5x
    send_rcw(addr);
    */    
    // -----------------------------------
    // Set function space 0
    // -----------------------------------
    addr[12:0] = {5'h17,4'b0,4'b0};
    send_rcw(addr);
    $display("Select function space 0.");
  end
endtask



task automatic ddr4_write_mrs(bit [pCS_WIDTH-1:0] rank, bit [2:0] addr);
//reg [15:0] mode_regs[0:6] = {16'h041c, 16'h0201, 16'h0010, 16'h0000, 16'h0000, 16'h0080, 16'h040f}; //CWL:11, CL:12
//reg [15:0] mode_regs[0:6] = {16'h041c, 16'h0201, 16'h0000, 16'h0000, 16'h0000, 16'h0080, 16'h040f}; //CWL:9, CL:12
//reg [15:0] mode_regs[0:6] = {16'h041c, 16'h0201, 16'h0028, 16'h0000, 16'h0000, 16'h0080, 16'h040f}; //CWL:16, CL:12
//reg [15:0] mode_regs[0:6] = {16'h0408, 16'h0201, 16'h0010, 16'h0000, 16'h0000, 16'h0080, 16'h040f}; //CWL:11, CL:9
//reg [15:0] mode_regs[0:6] = {16'h0448, 16'h0201, 16'h0010, 16'h0000, 16'h0000, 16'h0080, 16'h040f}; //CWL:11, CL:18
  bit [17:0] data;

  //data = mode_regs[addr];
  case(addr)
    0: data = cfg.MR0[cfg.PState];
    1: data = cfg.MR1[cfg.PState];
    2: data = cfg.MR2[cfg.PState];
    3: data = cfg.MR3[cfg.PState];
    4: data = cfg.MR4[cfg.PState];
    5: data = cfg.MR5[cfg.PState];
    6: data = cfg.MR6[cfg.PState];
    default: begin $display("<%m> ERROR: Unexpected MRS."); $finish; end
  endcase
  $display("[%0t] <%m> rank=%0b, MR addr = %d, data = %h", $time, rank, addr, data);
  @(posedge clk);
  cs[0] = rank;
  {ras_n[0], cas_n[0], we_n[0]} = 3'b0;
  {bg[0][0],bank[0][1:0]} = addr;
  address[0] = data;
  @(posedge clk);
  cs[0] = 4'hF;
  {ras_n[0], cas_n[0], we_n[0]} = 3'b111;
  {bg, bank} = 20'b0;
  address[0] = 18'b0; 

  if(cfg.DimmType == CTB_RDIMM || cfg.DimmType == CTB_LRDIMM) begin
    data = data  ^ (18'h22bf8);
    $display("[%0t] <%m> [RDIMM b-side]MR addr = %d, data = %h", $time, addr, data);
    @(posedge clk);
    cs[0] = rank;
    {ras_n[0], cas_n[0], we_n[0]} = 3'b0;
    {bg[0][1],bg[0][0],bank[0][1:0]} = {1'b1, ~addr};
    address[0] = data;
    @(posedge clk);
    cs[0] = 4'hF;
    {ras_n[0], cas_n[0], we_n[0]} = 3'b111;
    {bg, bank} = 20'b0;
    address[0] = 18'b0; 
  end
endtask

task ddr4_zqcl (bit [pCS_WIDTH-1:0] rank);
  $display("[%0t] <%m>, rank = %b", $time, rank);
  @(posedge clk);
  drive_ddr4_cmd(.t_cs(rank),
                 .t_ras_n(1'b1),.t_cas_n(1'b1),.t_we_n(1'b0),
                 .t_addr({14'b100_0000_0000})); //A10=1, ZQCL
  @(posedge clk);
  drive_ddr4_cmd();
endtask  
//`ifdef DDRPHY_POWERSIM
//task ddr4_activate (bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [17:0] my_row);
//`else
task ddr4_activate (bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [16:0] my_row);
//`endif
  $display("[%0t] <%m>, rank=%b, bg = %d, ba = %d, row = %h", $time, rank, my_bg, my_ba, my_row);
  @(posedge clk);
  //`ifndef DDRPHY_POWERSIM
  drive_ddr4_cmd(.t_cs(rank),
                 .t_act_n(1'b0),.t_ras_n(my_row[16]),.t_cas_n(my_row[15]),.t_we_n(my_row[14]),
                 .t_bg(my_bg),.t_ba(my_ba),.t_addr(my_row[13:0]));
  //`else
  //drive_ddr4_cmd(.t_cs(rank),
  //               .t_act_n(1'b0),.t_ras_n(my_row[16]),.t_cas_n(my_row[15]),.t_we_n(my_row[14]),
  //               .t_bg(my_bg),.t_ba(my_ba),.t_addr(my_row[17:0]));
  //`endif
  @(posedge clk);
  drive_ddr4_cmd();
endtask
task ddr4_wrs8(bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [9:0] my_col);
  ddr4_wr_burst(rank,my_bg,my_ba,my_col,8,0);
endtask

task ddr4_wr_burst(bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [9:0] my_col, int burst_len, int phase, int b2b = 0, int b2b_num = 0);
  reg power_cmd0;
  power_cmd0 = 1;
  $display("[%0t] <%m>, rank=%b, bg=%b, ba = %b, col_addr = %h", $time, rank, my_bg, my_ba, my_col);
  set_wrdata_en_q(rank,cfg.CWL[cfg.PState] - sub_lat + phase, burst_len, b2b);
  set_wrdata_q(rank,cfg.CWL[cfg.PState] - sub_lat + 2 + phase, burst_len, b2b, b2b_num);
  @(posedge clk);
  `ifndef DDRPHY_POWERSIM
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(rank),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(0),.t_we_n(0),
                 .t_bg(my_bg),.t_ba(my_ba),.t_addr({4'b0,my_col}),.t_ph(phase)); 
  `else
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(rank),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(0),.t_we_n(0),
                 .t_bg(my_bg),.t_ba(my_ba),.t_addr({{~power_cmd0,3'b0,power_cmd0,~power_cmd0,power_cmd0,1'b0},my_col}),.t_ph(phase)); 
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(0),.t_ras_n(0),.t_cas_n(1),.t_we_n(1),
                 .t_bg(~my_bg),.t_ba(~my_ba),.t_addr({{power_cmd0,3'b0,~power_cmd0,power_cmd0,~power_cmd0,1'b1},~my_col}),.t_ph(1));
  `endif
  @(posedge clk);
  `ifndef DDRPHY_POWERSIM
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(1),.t_we_n(1),
                 .t_bg(2'b0),.t_ba(2'b0),.t_addr(14'b0),.t_ph(phase));
  `else
   drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(0),.t_we_n(1),
                 .t_bg(my_bg),.t_ba(my_ba),.t_addr({{~power_cmd0,3'b0,power_cmd0,~power_cmd0,power_cmd0,1'b0},my_col}),.t_ph(0));
   drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(0),.t_ras_n(0),.t_cas_n(1),.t_we_n(0),
                 .t_bg(~my_bg),.t_ba(~my_ba),.t_addr({{power_cmd0,3'b0,~power_cmd0,power_cmd0,~power_cmd0,1'b1},~my_col}),.t_ph(1));
  `endif
endtask

task ddr4_rds8(bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [9:0] my_col);
  ddr4_rd_burst(rank,my_bg,my_ba,my_col,8,0);
endtask

task ddr4_rd_burst(bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [9:0] my_col, int burst_len, int phase, int b2b = 0);
  reg power_cmd0;
  power_cmd0 = 1;
  $display("[%0t] <%m>, rank=%b, bg=%b, ba = %b, col_addr = %h", $time, rank, my_bg, my_ba, my_col);
  set_rddata_en_q(rank,cfg.CL[cfg.PState] - sub_lat + phase, burst_len, b2b);
  @(posedge clk);
  `ifndef DDRPHY_POWERSIM
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(rank),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(0),.t_we_n(1),
                 .t_bg(my_bg),.t_ba(my_ba),.t_addr({4'b0,my_col}),.t_ph(phase)); 
  `else
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(rank),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(0),.t_we_n(1),
                 .t_bg(my_bg),.t_ba(my_ba),.t_addr({{~power_cmd0,3'b0,power_cmd0,~power_cmd0,power_cmd0,1'b0},my_col}),.t_ph(phase)); 
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(0),.t_ras_n(0),.t_cas_n(1),.t_we_n(0),
                 .t_bg(~my_bg),.t_ba(~my_ba),.t_addr({{power_cmd0,3'b0,~power_cmd0,power_cmd0,~power_cmd0,1'b1},~my_col}),.t_ph(1));
  `endif
  @(posedge clk);
  `ifndef DDRPHY_POWERSIM
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(1),.t_we_n(1),
                 .t_bg(2'b0),.t_ba(2'b0),.t_addr(14'b0),.t_ph(phase));
  `else
   drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(0),.t_we_n(1),
                 .t_bg(my_bg),.t_ba(my_ba),.t_addr({{~power_cmd0,3'b0,power_cmd0,~power_cmd0,power_cmd0,1'b0},my_col}),.t_ph(0));
   drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(0),.t_ras_n(0),.t_cas_n(1),.t_we_n(0),
                 .t_bg(~my_bg),.t_ba(~my_ba),.t_addr({{power_cmd0,3'b0,~power_cmd0,power_cmd0,~power_cmd0,1'b1},~my_col}),.t_ph(1));
  `endif
endtask

task ddr4_precharge_all(bit [pCS_WIDTH-1:0] rank);
  $display("[%0t] <%m>, rank=%b", $time, rank);
@(posedge clk);
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(rank),
                 .t_act_n(1),.t_ras_n(0),.t_cas_n(1),.t_we_n(0),
                 .t_bg(),.t_ba(),.t_addr({3'b0,1'b1,10'b0})); 
  @(posedge clk);
  drive_ddr4_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_act_n(1),.t_ras_n(1),.t_cas_n(1),.t_we_n(1),
                 .t_bg(2'b0),.t_ba(2'b0),.t_addr(14'b0));
endtask

task ddr4_sre();
  cke = {4*pCKE_WIDTH{1'b0}};
endtask

task ddr4_srx();
  cke = {4*pCKE_WIDTH{1'b1}};
endtask
task ddr4_wr_b2b(bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [9:0] my_col, int b2b_num);
`ifdef DDRPHY_POWERSIM
int i=3;
reg [0:3][9:0] col_value;
    col_value[0]=10'h398;
    col_value[1]=10'h1e8;
    col_value[2]=10'h398;
    col_value[3]=10'h1e8;
`endif
`ifndef DDRPHY_POWERSIM
  //@(posedge clk);
  //ddr4_wr_burst(rank,my_bg,my_ba,my_col,8,0);
  //@(posedge clk);
  //ddr4_wr_burst(rank,my_bg,my_ba+1,my_col,8,0);
  ddr4_wr_burst(rank,my_bg,my_ba,my_col,8,0);
`endif
  for (int j=1 ; j < b2b_num +1; j++)begin
   `ifdef DDRPHY_POWERSIM
      if (j%2)begin
        i= (i==3)? 0:i+1;
        my_col = col_value[i];
      end
      else
        my_col = my_col;
      ddr4_wr_burst(rank,my_bg,my_ba,my_col,8,0,1,j);
      my_bg = (my_bg ==3 )? 0 : (my_bg + 1);
      my_ba = (my_ba ==3 )? 0 : (my_ba + 1);
    `else
    //my_ba = (my_ba ==0 )? (my_ba + 1) : 0;
    my_bg = (my_bg ==0 )? (my_bg + 1) : 0;
    ddr4_wr_burst(rank,my_bg,my_ba,my_col,8,0,1,j);
    my_col = my_col +8;
    `endif
  end
endtask

task ddr4_rd_b2b(bit [pCS_WIDTH-1:0] rank, bit [1:0] my_bg, bit [2:0] my_ba, bit [9:0] my_col, int b2b_num =1);
`ifdef DDRPHY_POWERSIM
int i=3;
reg [0:3][9:0] col_value;
    col_value[0]=10'h398;
    col_value[1]=10'h1e8;
    col_value[2]=10'h398;
    col_value[3]=10'h1e8;
`endif
`ifndef DDRPHY_POWERSIM
  //@(posedge clk);
  //ddr4_rd_burst(rank,my_bg,my_ba,my_col,8,0);
  //@(posedge clk);
  //ddr4_rd_burst(rank,my_bg,my_ba+1,my_col,8,0);
  ddr4_rd_burst(rank,my_bg,my_ba,my_col,8,0);
`endif
  for (int j=1 ; j < b2b_num +1; j++)begin
    `ifdef DDRPHY_POWERSIM
      if (j%2)begin
        i= (i==3)? 0:i+1;
        my_col = col_value[i];
      end
      else
        my_col = my_col;

      ddr4_rd_burst(rank,my_bg,my_ba,my_col,8,0,1);     
      
      my_bg = (my_bg ==3 )? 0 : (my_bg + 1);
      my_ba = (my_ba ==3 )? 0 : (my_ba + 1) ;
    `else
    //my_ba = (my_ba ==0 )? (my_ba + 1) : 0;
    my_bg = (my_bg ==0 )? (my_bg + 1) : 0;
    ddr4_rd_burst(rank,my_bg,my_ba,my_col,8,0,1);
    my_col = my_col +8;
    `endif
  end
endtask
`endif
//--------------------------------------------------------------------
// DDR3
//--------------------------------------------------------------------
`ifdef DDR3_STD
task drive_ddr3_cmd(bit [pCKE_WIDTH-1:0] t_cke = {pCKE_WIDTH{1'b1}}, 
                    bit [pCS_WIDTH-1:0] t_cs = {pCS_WIDTH{1'b1}},
                    bit t_ras_n = 1'b1, 
                    bit t_cas_n = 1'b1, 
                    bit t_we_n = 1'b1, 
                    bit [2:0] t_ba = 3'b0,
                    bit [15:0] t_addr = 14'b0,
                    bit [1:0] t_ph = 2'b0);

  cke[t_ph] = t_cke;
  cs[t_ph] = t_cs;
  ras_n[t_ph] = t_ras_n;
  cas_n[t_ph] = t_cas_n;
  we_n[t_ph] = t_we_n;
  bank[t_ph] = t_ba;
  address[t_ph] = t_addr;

endtask

//--------------------------------------------
task ddr3_activate (bit [pCS_WIDTH-1:0] rank, bit [2:0] my_ba, bit [15:0] my_row);
  $display("[%0t] <%m>, rank = %b, ba = %d, row = %h", $time, rank, my_ba, my_row);
  @(posedge clk);
  drive_ddr3_cmd(.t_cke(2'b11),.t_cs(rank),
                 .t_ras_n(0),.t_cas_n(1),.t_we_n(1),
                 .t_ba(my_ba),.t_addr(my_row[15:0]));
  @(posedge clk);
  drive_ddr3_cmd();
endtask
//--------------------------------------------
task ddr3_wrs8 (bit [pCS_WIDTH-1:0] rank, bit [2:0] my_ba, bit [10:0] my_col);
  int burst_len=8;
  int phase=0;
  $display("[%0t] <%m>, rank=%b, ba = %d, col_addr = %h", $time, rank, my_ba, my_col);
  set_wrdata_en_q(rank,cfg.CWL[cfg.PState] - sub_lat + phase, burst_len);
  set_wrdata_q(rank,cfg.CWL[cfg.PState] - sub_lat + 2 + phase, burst_len);
  @(posedge clk);
  drive_ddr3_cmd(.t_cke(2'b11),.t_cs(rank),
                 .t_ras_n(1),.t_cas_n(0),.t_we_n(0),
                 .t_ba(my_ba),.t_addr({4'h0,my_col[10],1'b0,my_col[9:0]}),.t_ph(phase)); 
  @(posedge clk);
  drive_ddr3_cmd(.t_cke(2'b11),.t_cs(4'hf),
                 .t_ras_n(1),.t_cas_n(1),.t_we_n(1),
                 .t_ba(2'b0),.t_addr(15'b0),.t_ph(phase));
endtask

//--------------------------------------------
task ddr3_rds8 (bit [pCS_WIDTH-1:0] rank, bit [2:0] my_ba, bit [10:0] my_col);
  int burst_len=8;
  int phase=0;
  $display("[%0t] <%m>, rank=%b, ba = %b, col_addr = %h", $time, rank, my_ba, my_col);
  set_rddata_en_q(rank,cfg.CL[cfg.PState] - sub_lat + phase, burst_len);
  @(posedge clk);
  drive_ddr3_cmd(.t_cke(2'b11),.t_cs(rank),
                 .t_ras_n(1),.t_cas_n(0),.t_we_n(1),
                 .t_ba(my_ba),.t_addr({4'h0,my_col[10],1'b0,my_col[9:0]}),.t_ph(phase));
  @(posedge clk);
  drive_ddr3_cmd(.t_cke(2'b11),.t_cs(4'hf),
                 .t_ras_n(1),.t_cas_n(1),.t_we_n(1),
                 .t_ba(2'b0),.t_addr(15'b0),.t_ph(phase));
endtask

task ddr3_precharge_all(bit [pCS_WIDTH-1:0] rank);
  $display("[%0t] <%m>, rank=%b", $time, rank);
@(posedge clk);
  drive_ddr3_cmd(.t_cke(4'hf),.t_cs(rank),
                 .t_ras_n(0),.t_cas_n(1),.t_we_n(0),
                 .t_ba(),.t_addr({4'b0,1'b1,10'b0})); 
  @(posedge clk);
  drive_ddr3_cmd(.t_cke(4'hf),.t_cs(4'hf),
                 .t_ras_n(1),.t_cas_n(1),.t_we_n(1),
                 .t_ba(2'b0),.t_addr(15'b0));
endtask
`endif

//--------------------------------------------------------------------
// LPDDR3
//--------------------------------------------------------------------
`ifdef LP3_STD
task drive_lpddr3_cmd(bit [pCKE_WIDTH-1:0] t_cke = {pCKE_WIDTH{1'b1}},
                      bit [pCS_WIDTH -1 :0] t_cs = {pCS_WIDTH{1'b1}},
                      bit [19:0] t_addr = 20'h00000,
                      bit [1:0] t_ph = 2'b0);
  cke[t_ph] = t_cke;
  cs[t_ph] = t_cs;
  address[t_ph] = t_addr;
endtask
//--------------------------------------------
task lpddr3_activate(bit [pCS_WIDTH - 1:0] rank, bit[2:0] my_ba, bit[14:0] my_row);
  $display("[%0t] <%m>, rank = %b, ba = %d, row = %h", $time, rank, my_ba, my_row);
  @(posedge clk);
  drive_lpddr3_cmd(.t_cke(4'hf),.t_cs(rank),.t_addr({my_row[14:13],my_row[7:0],my_ba,my_row[12:8],2'b10}));
  @(posedge clk);
  drive_lpddr3_cmd();
endtask
task lpddr3_rds8(bit[pCS_WIDTH-1:0] rank, bit[2:0] my_ba, bit[11:0] my_col);
  int phase =0;
  int burst_len = 8;
  $display("[%0t] <%m>, rank=%b, ba = %b, col_addr = %h", $time, rank, my_ba, my_col);
  set_rddata_en_q(rank,cfg.CL[cfg.PState] - sub_lat + phase, burst_len);
  @(posedge clk);
  drive_lpddr3_cmd(.t_cke(4'hf),.t_cs(rank),.t_addr({my_col[11:3],1'b0,my_ba,my_col[2:1],5'b00101}));
  @(posedge clk);
  drive_lpddr3_cmd();
endtask
//--------------------------------------------
task lpddr3_wrs8(bit [pCS_WIDTH-1:0] rank, bit [2:0] my_ba, bit [11:0] my_col);
  int phase = 0;
  int burst_len = 8;
  int tDQSS = 1;

  $display("[%0t] <%m>, rank=%b, ba = %d, col_addr = %h", $time, rank,  my_ba, my_col);
  set_wrdata_en_q(rank,cfg.CWL[cfg.PState] - sub_lat + phase + tDQSS , burst_len);
  set_wrdata_q(rank, cfg.CWL[cfg.PState] - sub_lat + 2 + phase + tDQSS , burst_len);
  @(posedge clk);
  drive_lpddr3_cmd(.t_cke(4'hf),.t_cs(rank),.t_addr({my_col[11:3],1'b0,my_ba,my_col[2:1],5'b00001}));
  @(posedge clk);
  drive_lpddr3_cmd();
  endtask
//--------------------------------------------
task lpddr3_precharge_all(bit [pCS_WIDTH-1:0] rank);
  $display("[%0t] <%m>, rank=%b", $time, rank);
  @(posedge clk);
  drive_lpddr3_cmd(.t_cke(4'hf),.t_cs(rank),.t_addr({11'b0,4'b1100})); 
  @(posedge clk);
  drive_lpddr3_cmd();
 endtask

`endif
//--------------------------------------------------------------------
// LPDDR4
//--------------------------------------------------------------------
`ifdef LP4_STD
task drive_lpddr4_cmd(bit [pCS_WIDTH -1 :0] t_cs = {pCS_WIDTH{1'b0}},
                      bit [5:0] t_addr = 6'b0,
                      bit [1:0] t_ph = 2'b0);

  cs[t_ph] = t_cs;
  address[t_ph] = t_addr;
endtask

task lpddr4_deselect(int number=1);
  repeat(number) begin
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs({pCS_WIDTH{1'b0}}), .t_addr(6'h0), .t_ph(0));
  end
endtask

task lpddr4_des(bit [`DWC_DDRPHY_DFI0_ADDRESS_WIDTH-1:0] Addr);
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs({pCS_WIDTH{1'b0}}), .t_addr(6'h0), .t_ph(0));
endtask
/*
task lpddr4_mpc(bit [pCS_WIDTH - 1:0] rank; bit [6:0] op=7'h0);
  @(posedge clk);
  drive_lpddr4_cmd(.t_cs(~rank), .t_addr(op[5:0]), .t_ph(0));
  @(posedge clk);
  drive_lpddr4_cmd(              .t_addr({op[6],5'h0}), .t_ph(0));
endtask

task lpddr4_pre(bit [pCS_WIDTH - 1:0] rank; bit [2:0] bank=3'h0);
  @(posedge clk);
  drive_lpddr4_cmd(.t_cs(~rank), .t_addr(), .t_ph(0));
  @(posedge clk);
  drive_lpddr4_cmd(              .t_addr({op[6],5'h0}), .t_ph(0));
endtask

task lpddr4_ref(bit [pCS_WIDTH - 1:0] rank; bit [2:0] bank=3'h0);
  @(posedge clk);
  drive_lpddr4_cmd(.t_cs(~rank), .t_addr(op[5:0]), .t_ph(0));
  @(posedge clk);
  drive_lpddr4_cmd(              .t_addr({op[6],5'h0}), .t_ph(0));
endtask
*/
task lpddr4_activate(bit [pCS_WIDTH - 1:0] rank, bit[2:0] my_ba, bit[16:0] my_row);
  $display("[%0t] <%m>, rank = %b, ba = %d, row = %h", $time, rank, my_ba, my_row);
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_row[15:12],2'b01}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(             .t_addr({my_row[11:10],1'b0,my_ba}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_row[9:6],2'b11}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(             .t_addr({my_row[5:0]}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd();
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_row[15:12],2'b01}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({my_row[11:10],1'b0,my_ba}),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_row[9:6],2'b11}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({my_row[5:0]}),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else if(cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_ratio 1:4
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_row[15:12],2'b01}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({my_row[11:10],1'b0,my_ba}),.t_ph(1));
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_row[9:6],2'b11}),.t_ph(2));
    drive_lpddr4_cmd(             .t_addr({my_row[5:0]}),.t_ph(3));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
    drive_lpddr4_cmd(.t_ph(2));
    drive_lpddr4_cmd(.t_ph(3));
  end else begin
    $display("ERROR: <%m> Wrong freq ratio: cfg.DfiFreqRatio[%0d]=%0d.",cfg.PState,cfg.DfiFreqRatio[cfg.PState] );
    $finish();
  end
endtask

task lpddr4_sre(bit [pCS_WIDTH - 1:0] rank);
  $display("[%0t] <%m>, rank = %b", $time, rank);
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b011000),.t_ph(0));
    @(posedge clk)
    drive_lpddr4_cmd(             .t_addr(6'b111111),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd();
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b011000),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(6'b111111),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else if (cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_ratio 1:4
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b011000),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(6'b111111),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end
endtask

task lpddr4_srx(bit [pCS_WIDTH - 1:0] rank);
  $display("[%0t] <%m>, rank = %b", $time, rank);
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b010100),.t_ph(0));
    @(posedge clk)
    drive_lpddr4_cmd(             .t_addr(6'b111111),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd();
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b010100),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(6'b111111),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else if (cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_ratio 1:4
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b010100),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(6'b111111),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else begin
    $display("ERROR: <%m> Wrong freq ratio: cfg.DfiFreqRatio[%0d]=%0d.",cfg.PState,cfg.DfiFreqRatio[cfg.PState] );
    $finish();
  end
endtask

task automatic lpddr4_write_mrs(bit [pCS_WIDTH-1:0] rank, bit [5:0] ma, bit freq_change=0, bit[1:0] PState=0, bit [8:0] op=0);
  //bit [7:0] op;
  
  if(op[8]==0) begin
    if(freq_change==0) begin
      case(ma)
        1: op = cfg.MR1[cfg.PState];
        2: op = cfg.MR2[cfg.PState];
        3: op = cfg.MR3[cfg.PState];
        default: begin $display("<%m> ERROR: Unexpected MRS."); $finish; end
      endcase
    end else begin
      case(ma)
        1: op = cfg.MR1[PState];
        2: op = cfg.MR2[PState];
        3: op = cfg.MR3[PState];
        default: begin $display("<%m> ERROR: Unexpected MRS."); $finish; end
      endcase
    end
  end
  $display("[%0t] <%m> rank=%0b, MR[%d] = %h", $time, rank, ma, op);
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({op[7],5'b00110}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(             .t_addr(ma[5:0]),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({op[6],5'b10110}),.t_ph(0));
    @(posedge clk)
    drive_lpddr4_cmd(             .t_addr(op[5:0]),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd();
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({op[7],5'b00110}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(ma[5:0]),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({op[6],5'b10110}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(op[5:0]),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else if(cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_Ratio 1:4 
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({op[7],5'b00110}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(ma[5:0]),.t_ph(1));
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({op[6],5'b10110}),.t_ph(2));
    drive_lpddr4_cmd(             .t_addr(op[5:0]),.t_ph(3));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
    drive_lpddr4_cmd(.t_ph(2));
    drive_lpddr4_cmd(.t_ph(3));
  end
endtask
  
task lpddr4_rds16(bit[pCS_WIDTH-1:0] rank, bit[2:0] my_ba, bit[9:0] my_col, int b2b = 0);
  int phase =3;
  int burst_len = 16;

  $display("[%0t] <%m>, rank=%b, ba = %b, col_addr = %h", $time, rank, my_ba, my_col);
  set_rddata_en_q(rank,cfg.CL[cfg.PState] - sub_lat + phase, burst_len, b2b);
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b000010),.t_ph(0));
    @(posedge clk);
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(             .t_addr({1'b0,my_col[9],1'b0,my_ba}),.t_ph(0));
    `else
    drive_lpddr4_cmd(             .t_addr({3'b000,my_ba}),.t_ph(0));
    `endif
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_col[8],5'b10010}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(             .t_addr(my_col[7:2]),.t_ph(0));
    @(posedge clk);
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
    `else
    drive_lpddr4_cmd();
    `endif
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b000010),.t_ph(0));
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(             .t_addr({1'b0,my_col[9],1'b0,my_ba}),.t_ph(1));
    `else
    drive_lpddr4_cmd(             .t_addr({3'b000,my_ba}),.t_ph(1));
    `endif
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_col[8],5'b10010}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(my_col[7:2]),.t_ph(1));
    @(posedge clk);
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
    drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(1));
    `else
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
    `endif
  end else if(cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_Ratio 1:4 
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b000010),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({3'b000,my_ba}),.t_ph(1));
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_col[8],5'b10010}),.t_ph(2));
    drive_lpddr4_cmd(             .t_addr(my_col[7:2]),.t_ph(3));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
    drive_lpddr4_cmd(.t_ph(2));
    drive_lpddr4_cmd(.t_ph(3));
  end else begin
    $display("ERROR: <%m> Wrong freq ratio: cfg.DfiFreqRatio[%0d]=%0d.",cfg.PState,cfg.DfiFreqRatio[cfg.PState] );
    $finish();
  end
endtask

//--------------------------------------------
task lpddr4_wrs16(bit [pCS_WIDTH-1 :0] rank, bit [2:0] my_ba, bit [9:0] my_col, int b2b = 0, int b2b_num = 0);
  int phase = 3;
  int burst_len = 16;
  int tDQSS = 1;

  $display("[%0t] <%m>, rank=%b, ba = %d, col_addr = %h", $time, rank,  my_ba, my_col);
  if((cfg.Lp4xMode == 1) && (cfg.HardMacroVer == 3)) begin
    set_wrdata_en_q(rank, phase, burst_len, b2b);
    set_wrdata_q(rank, cfg.CWL[cfg.PState] - sub_lat + 2 + phase + tDQSS, burst_len, b2b, b2b_num);  
  end else begin
    set_wrdata_en_q(rank,cfg.CWL[cfg.PState] - sub_lat + phase + tDQSS, burst_len, b2b);
    set_wrdata_q(rank, cfg.CWL[cfg.PState] - sub_lat + 2 + phase + tDQSS, burst_len, b2b, b2b_num);
  end
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b000100),.t_ph(0));
    @(posedge clk);
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(             .t_addr({1'b0,my_col[9],1'b0,my_ba}),.t_ph(0));
    `else
    drive_lpddr4_cmd(             .t_addr({3'b000,my_ba}),.t_ph(0));
    `endif
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_col[8],5'b10010}),.t_ph(0));
    @(posedge clk)
    drive_lpddr4_cmd(             .t_addr(my_col[7:2]),.t_ph(0));
    @(posedge clk);
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(             .t_addr(~my_col[7:2]),.t_ph(0));
    `else
    drive_lpddr4_cmd();
    `endif
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b000100),.t_ph(0));
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(             .t_addr({1'b0,my_col[9],1'b1,my_ba}),.t_ph(1));
    `else
    drive_lpddr4_cmd(             .t_addr({3'b000,my_ba}),.t_ph(1));
    `endif
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_col[8],5'b10010}),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr(my_col[7:2]),.t_ph(1));
    @(posedge clk);
    `ifdef DDRPHY_POWERSIM
    drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
    drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(1));
    `else
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
    `endif
  end else if(cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_Ratio 1:4 
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b000100),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({3'b000,my_ba}),.t_ph(1));
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr({my_col[8],5'b10010}),.t_ph(2));
    drive_lpddr4_cmd(             .t_addr(my_col[7:2]),.t_ph(3));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
    drive_lpddr4_cmd(.t_ph(2));
    drive_lpddr4_cmd(.t_ph(3));
  end else begin
    $display("ERROR: <%m> Wrong freq ratio: cfg.DfiFreqRatio[%0d]=%0d.",cfg.PState,cfg.DfiFreqRatio[cfg.PState] );
    $finish();
  end
endtask

task lpddr4_wr_b2b(bit [pCS_WIDTH-1 :0] rank, bit [2:0] my_ba, bit [9:0] my_col, int b2b_num);
`ifdef DDRPHY_POWERSIM
  int i=3;
  reg [0:3][9:0] col_value;
  col_value[0]=10'h390;
  col_value[1]=10'h360;
  col_value[2]=10'h390;
  col_value[3]=10'h360;
`endif
`ifndef DDRPHY_POWERSIM
  lpddr4_wrs16(rank,my_ba,my_col);
`endif
  for(int j=1; j<b2b_num+1; j++)begin
    `ifdef DDRPHY_POWERSIM
     if (j%2)begin
       i= (i==3)? 0:i+1;
       my_col = col_value[i];
     end
     else
       my_col = {my_col[9:8],~my_col[7:4],my_col[3:0]};
   
     lpddr4_wrs16(rank,my_ba,my_col,1,j);
    `endif
    if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
      @(posedge clk);
      `ifdef DDRPHY_POWERSIM
      drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(0));
      @(posedge clk);
      drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
      @(posedge clk);
      drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(0));
      `else
      drive_lpddr4_cmd();
      `endif
     end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
      @(posedge clk);
      `ifdef DDRPHY_POWERSIM
      drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
      drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(1));
      `else
      drive_lpddr4_cmd();
      drive_lpddr4_cmd(.t_ph(1));
      `endif
     end else if(cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_Ratio 1:4
      @(posedge clk);
      drive_lpddr4_cmd();
      drive_lpddr4_cmd(.t_ph(1));
      drive_lpddr4_cmd(.t_ph(2));
      drive_lpddr4_cmd(.t_ph(3));
    end
    `ifdef DDRPHY_POWERSIM
    my_ba=(my_ba==7)? 0:my_ba+1;
    `else
    my_ba=(my_ba==0)? my_ba+1:0;
    lpddr4_wrs16(rank,my_ba,my_col,1,j);
    my_col=my_col+16;
    `endif
  end
endtask

task lpddr4_rd_b2b(bit [pCS_WIDTH-1 :0] rank, bit [2:0] my_ba, bit [9:0] my_col, int b2b_num);
`ifdef DDRPHY_POWERSIM
  int i=3;
  reg [0:3][9:0] col_value;
  col_value[0]=10'h3b0;
  col_value[1]=10'h360;
  col_value[2]=10'h390;
  col_value[3]=10'h360;
`endif
`ifndef DDRPHY_POWERSIM
  lpddr4_rds16(rank,my_ba,my_col);
`endif
  for(int j=1; j<b2b_num+1; j++)begin
    `ifdef DDRPHY_POWERSIM
      if (j%2)begin
        i= (i==3)? 0:i+1;
        my_col = col_value[i];
      end
      else
        my_col = {my_col[9:8],~my_col[7:4],my_col[3:0]};
      
      lpddr4_rds16(rank,my_ba,my_col,1);
    `endif
    if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
      @(posedge clk);
      `ifdef DDRPHY_POWERSIM
      drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(0));
      @(posedge clk);
      drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
      @(posedge clk);
      drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(0));
      //@(posedge clk);
      //drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
      `else
      drive_lpddr4_cmd();
      `endif
     end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
      @(posedge clk);
      `ifdef DDRPHY_POWERSIM
      drive_lpddr4_cmd(.t_addr(~my_col[7:2]),.t_ph(0));
      drive_lpddr4_cmd(.t_addr(my_col[7:2]),.t_ph(1));
      `else
      drive_lpddr4_cmd();
      drive_lpddr4_cmd(.t_ph(1));
      `endif
     end else if(cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_Ratio 1:4
      @(posedge clk);
      drive_lpddr4_cmd();
      drive_lpddr4_cmd(.t_ph(1));
      drive_lpddr4_cmd(.t_ph(2));
      drive_lpddr4_cmd(.t_ph(3));
    end
    `ifdef DDRPHY_POWERSIM
     my_ba=(my_ba==7)? 0:my_ba+1;
    `else
    my_ba=(my_ba==0)? my_ba+1:0;
    lpddr4_rds16(rank,my_ba,my_col,1);
    my_col=my_col+16;
    `endif
  end
endtask

task lpddr4_precharge_all(bit [pCS_WIDTH-1:0] rank);
  $display("[%0t] <%m>, rank=%b", $time, rank);
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b110000),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(             .t_addr({6'b000000}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd();
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b110000),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({6'b000000}),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else if (cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_ratio 1:4
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b110000),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({6'b000000}),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else begin
    $display("ERROR: <%m> Wrong freq ratio: cfg.DfiFreqRatio[%0d]=%0d.",cfg.PState,cfg.DfiFreqRatio[cfg.PState] );
    $finish();
  end
endtask

task lpddr4_refresh_all(bit [pCS_WIDTH-1:0] rank);
  $display("[%0t] <%m>, rank=%b", $time, rank);
  if(cfg.DfiFreqRatio[cfg.PState] == 0) begin //Freq_Ratio 1:1
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b101000),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd(             .t_addr({6'b000000}),.t_ph(0));
    @(posedge clk);
    drive_lpddr4_cmd();
  end else if(cfg.DfiFreqRatio[cfg.PState] == 1) begin //Freq_Ratio 1:2
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b101000),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({6'b000000}),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else if (cfg.DfiFreqRatio[cfg.PState] == 2) begin //Freq_ratio 1:4
    @(posedge clk);
    drive_lpddr4_cmd(.t_cs(~rank),.t_addr(6'b101000),.t_ph(0));
    drive_lpddr4_cmd(             .t_addr({6'b000000}),.t_ph(1));
    @(posedge clk);
    drive_lpddr4_cmd();
    drive_lpddr4_cmd(.t_ph(1));
  end else begin
    $display("ERROR: <%m> Wrong freq ratio: cfg.DfiFreqRatio[%0d]=%0d.",cfg.PState,cfg.DfiFreqRatio[cfg.PState] );
    $finish();
  end
endtask


`endif

endmodule

`endif
