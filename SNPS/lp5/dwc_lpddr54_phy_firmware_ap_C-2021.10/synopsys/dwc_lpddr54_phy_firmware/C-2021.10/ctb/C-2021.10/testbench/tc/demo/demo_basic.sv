`include "test_head.sv"

module test;

`include "common_test_inc.sv"

// For callbacks
`ifdef USER_TEST

`ifndef PRE_WRITE
task pre_write(int rank=0); endtask
`endif
`ifndef POST_WRITE
task post_write(int rank=0); endtask
`endif
`ifndef PRE_READ
task pre_read(int rank=0); endtask
`endif
`ifndef POST_READ
task post_read(int rank=0); endtask
`endif

`endif

  reg [3:0]   rank=4'b1110;
  reg [3:0]   bank=4'b0000;
  reg [2:0]   bg=3'b000;
  reg [16:0]  row = 17'h30;
  reg [9:0]   col = 10'h70;


initial begin
  $display("[%0t] <%m> demo_basic: initial begin", $time);
  
  `ifdef USER_SCENARIO
  //  top.dfi_data.disable_data_compare=1;
    user_scenario();
    repeat(1000) @(posedge top.dfi_clk);
  `else
    rank=4'b1110;
    init();
    `ifdef QUICKBOOT
      quickboot_init ();
    `endif

    `ifdef DWC_DDRPHY_HWEMUL
      data_id=0;
      forever begin
    `endif

    mission_mode_wr_rd(); //Support single wr/rd and b2b wr/rd 

    `ifdef BUBBLE
      rank = 4'b1110;
      des(50);
      refresh();
      des(300);
      set_tccd_delay();
      des(50);
      for (int i=0;i< cfg.NumRank_dfi0;i++)begin
        activate(rank,bg,bank,row);
        des(80);
        `ifdef WR2RD
          wr2rd(rank, bg, bank, col,rank,bg,bank,col,same_wr2rd_tCCD);
        `endif
        `ifdef RD2WR
          rd2wr(rank, bg, bank, col,rank,bg+1,bank,col+16'h10,same_rd2wr_tCCD);
        `endif
        `ifdef LP5_STD
          des(50);
          if(cfg.MR18[cfg.PState][4] == 1) cas(rank,111); 
        `endif
        des(200);
        precharge_all(rank);    
        rank = {rank[2:0],1'b1};
      end
    `endif


    finish_test;

    `ifdef DWC_DDRPHY_HWEMUL
      end
    `endif
  `endif 
end


endmodule
