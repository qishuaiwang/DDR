`timescale 1ps/1fs
`ifdef DWC_DDRPHY_UPF_MODE
import UPF::*; 
`endif
module clk_rst_drv (apb_clk, dfi_clk, dfi_phy_clk, dfi_ctl_clk, bypass_clk, tdr_clk, pwrok_in, retention,
  reset, dfi_reset_n, presetn, tdr_reset, vddq, vaa, vdd);

output reg apb_clk = 0;
output  dfi_clk ;
output  dfi_phy_clk ;
output wire dfi_ctl_clk ;
output reg bypass_clk = 0;
output reg tdr_clk = 0;
reg        ddr_clk=0;
reg        ddr_clk_2=0;
reg        ddr_clk_4=0;
reg        ddr_clk_8=0;

output reg  dfi_reset_n = 1'b0;
output reg  presetn     = 1'b1;
output reg  pwrok_in    = 1'b0;
output reg  retention   = 1'b0;
output reg  reset       = 1'b1;
output reg  tdr_reset   = 1'b0;
output reg  vaa         = 1'b0;
output reg  vdd         = 1'b0;
output reg  vddq        = 1'b0;

// --------------------------------------------------------
// Clocks generation
// --------------------------------------------------------


//-----configuration--------------------------------
reg apb_clk_en = 1'b1;       // enable apb     clock
reg dfi_clk_en = 1'b1;       // enable dfi     clock
reg dfi_ctl_clk_en = 1'b1;   // enable dfi_ctl clock
reg bypass_clk_en = 1'b1;    // enable bypass  clock
reg tdr_clk_en = 1'b1;       // enable jtag    clock
//-----configuration--------------------------------

real apb_clk_hp        = 1000;
real tdr_clk_hp        = 12386;
real bypass_clk_hp     = 10000;
real bypass_clk_hp_tmp = 10000;
real dfi_phy_clk_hp    = 250;
real ddr_hp = 1000;
int FreqRatio;
real DRAMFreq;
real ui_cal_ps;

logic wck = 0;
logic wck_2 = 0;
logic wck_4 = 0;
/**===================================*/
/*!      float to fs interger         */                 
function real Floating_Ps2Fs_integer(real float);
   int float_tem ;
   real int_return;
   float_tem = float * 1000;
   int_return = float_tem / 1000.0;
   return int_return;
endfunction

task init_clocks(int unsigned PState);
  bypass_clk_en = cfg.PllBypass[PState];
  FreqRatio = cfg.DfiFreqRatio[PState];//update FreqRatio
  bypass_clk_en = cfg.PllBypass[PState];
  // DDR data rate for the target Pstate in units of MT/s.
  `ifdef LP5_STD
    //DRAMFreq = cfg.Frequency[PState] * (bypass_clk_en ? ((cfg.DfiFreqRatio[PState] * 2) * 2) : 8);
    DRAMFreq = cfg.Frequency[PState] * ((cfg.DfiFreqRatio[PState] * 2) * 2);
  `elsif ATE_LP5
    DRAMFreq = cfg.Frequency[PState] * ((cfg.DfiFreqRatio[PState] * 2) * 2);
  `else
    DRAMFreq = cfg.Frequency[PState] * 2;
  `endif
  //Bypass clk needs to be running as datarate
  //Bypass_hp is the half pulse toggle in bypassclk
  bypass_clk_hp_tmp =  1000000.0/(DRAMFreq*2);
  bypass_clk_hp = Floating_Ps2Fs_integer(bypass_clk_hp_tmp);
  //Phy gets DFICLK input and generate WCK
  ui_cal_ps = bypass_clk_hp*2;

  $display("[%0t] <%m> Initial clock info: cfg.Frequency[%0d] = %0d, cfg.DfiFreqRatio[%0d] = %0d, DRAMFreq = %0f, bypass_clk_hp = %0f, ui_cal_ps = %0f, bypass_clk_en = %0f", $realtime, cfg.PState, cfg.Frequency[cfg.PState], cfg.PState, cfg.DfiFreqRatio[cfg.PState], DRAMFreq, bypass_clk_hp, ui_cal_ps, bypass_clk_en);
endtask:init_clocks
  
initial begin
  @(posedge test.top.dfi_clk);
  if(cfg.PllBypass[cfg.PState]==1)begin
    bypass_clk_en = 1'b1 ;
  end else begin
    bypass_clk_en = 1'b0 ;
  end
end

initial #1 begin
  init_clocks(cfg.PState);
end  

always @(cfg.PState) if ($time > 2) begin
  wait(!top.dfi0_init_complete);
  init_clocks(cfg.PState);
  //ddr_hp = 1000000.0/cfg.Frequency[cfg.PState]/2;
  //`ifdef LP5_STD
  //`else
  //  `ifdef DWC_DDRPHY_HWEMUL
  //    if(cfg.DfiFreqRatio[cfg.PState]==1&&cfg.Frequency[cfg.PState]>=1600)begin
  //      bypass_clk_hp_tmp = 1000000.0/cfg.Frequency[cfg.PState]/2/(2/FreqRatio);
  //      bypass_clk_hp = Floating_Ps2Fs_integer(bypass_clk_hp_tmp);
  //      ddr_hp = bypass_clk_hp * (2/FreqRatio);
  //    end else begin
  //      bypass_clk_hp_tmp = 1000000.0/cfg.Frequency[cfg.PState]/2/(4/FreqRatio);
  //      bypass_clk_hp = Floating_Ps2Fs_integer(bypass_clk_hp_tmp);
  //      ddr_hp = bypass_clk_hp * (4/FreqRatio);
  //    end
  //  `else
  //  `endif
  //`endif
end  

initial begin  #3 ; apb_clk     = 1'b1 ; forever  #apb_clk_hp     apb_clk     = ~apb_clk     & apb_clk_en ; end
initial begin  #3 ; tdr_clk     = 1'b1 ; forever  #tdr_clk_hp     tdr_clk     = ~tdr_clk     & tdr_clk_en ; end
//Bypass clk needs to be running as datarate
initial begin  #3 ; bypass_clk  = 1'b1 ; forever  #bypass_clk_hp  bypass_clk = ~bypass_clk; end

always  @(posedge bypass_clk ) wck   = ~wck;// wck = lpddr4_ck
always  @(posedge wck        ) wck_2 = ~wck_2;
always  @(posedge wck_2      ) wck_4 = ~wck_4;

assign dfi_phy_clk = wck;
assign dfi_clk     = ((FreqRatio == 1) ? wck_2 : wck_4 ) & dfi_clk_en;
assign dfi_ctl_clk = ((FreqRatio == 1) ? wck_2 : wck_4 ) & dfi_ctl_clk_en;

initial begin
     `ifdef DWC_DDRPHY_UPF_MODE
     fork
        $display("[%0t] <%m> [inition power_off]-->Begin power_off", $realtime);
        begin
           UPF::supply_off("test/top/dut/VDDQ");
        end
        begin
           UPF::supply_off("test/top/dut/VDD");
        end
        begin
           UPF::supply_off("test/top/dut/VDD2H");
        end
        begin
           UPF::supply_off("test/top/dut/VAA_VDD2H");
        end
     join
     $display("[%0t] <%m> [inition power_off]-->End inition power_off ", $time); 
     `endif
end

// --------------------------------------------------------
// Reset generation
// --------------------------------------------------------

//-----configuration--------------------------------
time presetn_on_dly      =  1590000;
time presetn_off_dly     =  4831000;
time pwrok_in_on_dly     =  2910000;     
time dfi_reset_n_off_dly =  3951000;
time tdr_reset_off_dly   =  4000000;
time reset_off_dly       =  4211000;
time vddq_dly            =  918000;
time vdd_dly             =  762000;
time vaa_dly             =  750000;
time vss_dly             =  0;

time presetn_to_reset_dly=  50000 ;  // dly >=Tapbclk * 16
time reset_dly           =  230000;  // reset impuse >= Tdficlk * 64 + presetn_to_reset_dly
time presetn_deassert_dly=  230010;  // presetn_deassert after reset
//-----configuration--------------------------------



task power_up();

  `ifndef DWC_DDRPHY_UPF_MODE
     fork
        #vddq_dly             vddq        = 1'b1;   // assert VDDQ
        #vdd_dly              vdd         = 1'b1;   // assert VDD
        #vaa_dly              vaa         = 1'b1;   // assert VAA
     join
  `else
     fork
       $display("[%0t] <%m> [power_up]-->Begin power_up", $realtime);
        begin
           #vddq_dly;vddq        = 1'b1;
           $display("[%0t] <%m> [power_up]-->Begin vddq_dly", $realtime);
           supply_on("test/top/dut/VDDQ", 1.20);
        end
        begin
           #vdd_dly; vdd         = 1'b1;
           supply_on("test/top/dut/VDD", 0.85);
           $display("[%0t] <%m> [power_up]-->End vdd_dly", $realtime);
        end
        begin
           #vaa_dly;vaa         = 1'b1;
           supply_on("test/top/dut/VDD2H", 0.80);
        end
        begin
           #vaa_dly;
           supply_on("test/top/dut/VAA_VDD2H", 1.80);
        end
        begin
           #vss_dly;
           supply_on("test/top/dut/VSS", 0.0);
        end
     join
     $display("[%0t] <%m> [power_up]-->End power_up vddq =%d vdd=%d vaa=%d ", $time,vddq,vdd,vaa );
  `endif
endtask : power_up

task deassert_pwrok();
  pwrok_in = 1'b0;   // deassert pwrok_in
endtask : deassert_pwrok

task assert_reset();
  reset = 1'b1;   // assert reset
endtask : assert_reset

task deassert_tdr_reset();
  tdr_reset = 1'b0;   // deassert tdr_reset
endtask : deassert_tdr_reset

task assert_ret();
  retention = 1'b1;   // assert retention
endtask : assert_ret

task deassert_ret();
  retention = 1'b0;   // deassert retention
endtask : deassert_ret

task ret_power_down();
  
 `ifndef DWC_DDRPHY_UPF_MODE
  vdd = 1'b0;   // deassert VDD
  vddq = 1'b0;   // deassert VDDQ
  `else 
    fork
      $display("[%0t] <%m> [ret_power_down]-->Begin ret_power_down vddq =%d vdd=%d vaa=%d ", $time,vddq,vdd,vaa );
      vdd = 1'b0;   // deassert VDD
      vddq = 1'b0;   // deassert VDDQ
      supply_off("test/top/dut/VDD");
      supply_off("test/top/dut/VDDQ");
      supply_off("test/top/dut/VAA_VDD2H");
    join
    $display("[%0t] <%m> [ret_power_down]-->End ret_power_down vddq =%d vdd=%d vaa=%d ", $time,vddq,vdd,vaa );
  `endif
endtask : ret_power_down

task start_clkRst();
  apb_clk_en = 1'b1;
  dfi_ctl_clk_en = 1;
  dfi_clk_en = 1;
  tdr_clk_en = 1'b1;
  fork
    begin
      #presetn_on_dly;
      @(posedge apb_clk); presetn     = 1'b0;   // assert   APB reset
    end
    begin
      #presetn_off_dly;
      @(posedge apb_clk); presetn     = 1'b1;   // deassert APB reset
    end
    #pwrok_in_on_dly      pwrok_in    = 1'b1;   // assert  pwrok_in
    begin
      #dfi_reset_n_off_dly;
      @(posedge dfi_clk); dfi_reset_n = 1'b1;   // de-assert dfi reset
    end
    begin
      reset = 1'b1;
      #reset_off_dly;
      @(posedge dfi_clk) reset       = 1'b0;   // de-assert reset
    end
    begin
      #tdr_reset_off_dly;    
      @(posedge tdr_clk); tdr_reset   = 1'b1;
    end
  join
endtask : start_clkRst

task stop_clk_PwrOff();           //The PHY input clocks are not required to toggle when BP_PWROK=0.

  apb_clk_en = 1'b0;    
  dfi_clk_en = 1'b0;    
  dfi_ctl_clk_en = 1'b0;
  bypass_clk_en = 1'b0; 
  tdr_clk_en = 1'b0;

endtask: stop_clk_PwrOff

task warm_reset();
 $display("[%0t] <%m> [warm_reset]-->Start warm_reset", $realtime );
fork
  begin//presetn-apb
     @(posedge apb_clk) presetn     = 1'b0; // assert   APB reset
     #presetn_deassert_dly
     @(posedge apb_clk) presetn     = 1'b1; // de-assert   APB reset 
  end
  begin//reset
     #presetn_to_reset_dly                  // presetn_apb need reset 16apbclk than reset
     @(posedge dfi_clk) reset       = 1'b1; // assert reset
     #reset_dly                             // reset delay >= 64 Dficlk
     @(posedge dfi_clk) reset       = 1'b0; // de-assert reset 
  end
join
$display("[%0t] <%m> [warm_reset]-->End warm_reset", $realtime );
endtask:warm_reset


task power_down_reset_phy_sdram();
  reset       = 1'b1;
  //Dfi clock is used all over the TB, we must leave this running
  repeat (100) @(posedge dfi_clk);
  bypass_clk = 0;
  wck = 0;
  wck_2 = 0;
  wck_4 = 0;
  tdr_clk     = 0;
  dfi_reset_n = 1'b0;
  presetn     = 1'b1;
  pwrok_in    = 1'b0;
  vaa         = 1'b0;
  vdd         = 1'b0;
  vddq        = 1'b0;
endtask:power_down_reset_phy_sdram

endmodule


