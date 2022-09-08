`include "test_head.sv"

module test;

`include "common_test_inc.sv"
`ifdef DDRPHY_POWERSIM
  `include "power_common_inc.sv"
`endif

// For callbacks
`ifdef USER_TEST

`ifndef PRE_WRITE0
task pre_write0(int rank=0); endtask
`endif
`ifndef POST_WRITE0
task post_write0(int rank=0); endtask
`endif
`ifndef PRE_READ0
task pre_read0(int rank=0); endtask
`endif
`ifndef POST_READ0
task post_read0(int rank=0); endtask
`endif
`ifndef PRE_WRITE1
task pre_write1(int rank=0); endtask
`endif
`ifndef POST_WRITE1
task post_write1(int rank=0); endtask
`endif
`ifndef PRE_READ1
task pre_read1(int rank=0); endtask
`endif
`ifndef POST_READ1
task post_read1(int rank=0); endtask
`endif
`ifndef PRE_DFI_LP
task pre_dfi_lp(); endtask
`endif
`ifndef POST_DFI_LP
task post_dfi_lp(); endtask
`endif
`ifndef PRE_FREQ_CHANGE
task pre_freq_change(int pstate=0); endtask
`endif
`ifndef POST_FREQ_CHANGE
task post_freq_change(int pstate=0); endtask
`endif
`ifndef PRE_LP3
task pre_lp3(); endtask
`endif
`ifndef POST_LP3
task post_lp3(); endtask
`endif
`ifndef PRE_RETENTION
task pre_retention(); endtask
`endif
`ifndef POST_RETENTION
task post_retention(); endtask
`endif

`endif

initial begin
  reg [3:0]   rank=4'b1110;
  reg [2:0]   bank=3'b0;
  reg [1:0]   bg=2'b0;
  reg [16:0]  row = 17'h30;
  reg [9:0]   col = 10'h70;

  `ifdef DDRPHY_POWERSIM
    reg [1:0]  pstate;
    bit [10:0] odt_dx[8];
    bit [8:0]  odt0_ac[2];
    bit [10:0] odt0_dx[8];
    bit [8:0]  odt1_ac[2];
    bit [10:0] odt1_dx[8];
    bit [8:0]  AcOdtEn[2];
    bit [10:0] DxOdtEn[8];
    bit [8:0]  AcOdtEn1[2];
    bit [10:0] DxOdtEn1[8];
    bit [10:0] DxOdtEnWck[8];
    bit [23:0] odtpd_ac[2];
    bit [23:0] odtpd_dx[8];
    bit [23:0] OdtStrenCodePD_ac[2];
    bit [23:0] OdtStrenCodePD_dx[8];
    bit [23:0] OdtStrenCodePD_ac1[2];
    bit [23:0] OdtStrenCodePD_dx1[8];

    for (int i=0; i<8; i++) begin
      odt_dx[i] = 0;
    end
    for (int i=0; i<2; i++) begin
      odt0_ac[i]  = 0;
      odt1_ac[i]  = {9{1'b1}};
      odtpd_ac[i] = 0;
    end
    for (int i=0; i<8; i++) begin
      odt0_dx[i]  = 0;
      odt1_dx[i]  = {11{1'b1}};
      odtpd_dx[i] = 0;
    end
  `endif


init();
`ifdef LP_MODE
case(`LP_MODE)
    1,2,3:begin `ifdef DDRPHY_POWERSIM Zcal_set;/*Replica_set;*/DTO_set;AC_PowerDown(0);`endif
                /*`ifdef DWC_DDRPHY_GATESIM rxclkdly_set(2'h0); `endif */end
    4:begin `ifdef DDRPHY_POWERSIM Zcal_set;`endif
            /*`ifdef DWC_DDRPHY_GATESIM rxclkdly_set(2'h1);`endif */end
    5,6:begin `ifdef DDRPHY_POWERSIM Zcal_set;`endif 
              /*`ifdef DWC_DDRPHY_GATESIM rxclkdly_set(2'h0);`endif */end
endcase
`endif

`ifdef DDRPHY_POWERSIM 
  DxOdtEn_set(2'h3,odt_dx,DxOdtEnWck); //disable OdtEnWck
`endif 

`ifdef DDRPHY_POWERSIM
dwc_ddrphy_apb_wr(32'hd0000,16'h0);  // DWC_DDRPHYA_APBONLY0_MicroContMuxSel
`ifdef LP4_STD
dwc_ddrphy_apb_wr(32'h020019,16'h1);  //TristateMdodeCA 
dwc_ddrphy_apb_wr(32'h120019,16'h1);  // 
dwc_ddrphy_apb_wr(32'h220019,16'h1);  // 
dwc_ddrphy_apb_wr(32'h320019,16'h1);  //
`else
dwc_ddrphy_apb_wr(32'h020019,16'h1);  //TristateMdodeCA 
dwc_ddrphy_apb_wr(32'h120019,16'h1);  // 
dwc_ddrphy_apb_wr(32'h220019,16'h1);  // 
dwc_ddrphy_apb_wr(32'h320019,16'h1);  // 
`endif
dwc_ddrphy_apb_wr(32'hd0000,16'h1);
`endif

repeat(2) @(posedge top.dfi_clk);

for( int i=0;i< cfg.NumRank_dfi0;i++)begin
  `ifndef USER_TEST
    des(50);
  `endif
  repeat(4) begin
    refresh(1,rank,bank,bg);
  end
  activate(rank, bg, bank, row);
  `ifdef USER_TEST
  pre_write0(i); 
  `endif
  if(!cfg.disable_write0[i])begin
    `ifndef USER_TEST
      des(50);
    `endif 
    `ifdef LP5_STD
      cas(rank,100);
    `endif
    wrs(rank, bg, bank, col);
  end
  `ifdef USER_TEST
  post_write0(i); 
  `endif
  `ifdef USER_TEST
  pre_read0(i); 
  `endif
  if(!cfg.disable_read0[i])begin
      des(50);
    `ifdef LP5_STD
      if(`LP_MODE == 4 && cfg.NumPStates > 1) begin //lp_mode = 4 always access pstate1 in the first time
        `ifdef POWERSIM_WCK_OFF1
          cas(rank,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
        `endif
      end 
      else begin
        `ifdef POWERSIM_WCK_OFF
          cas(rank,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
        `endif
      end
    `endif
    rds(rank, bg, bank, col);
    des(50);//invalid_command_during_reading_a_state_for_same_bank_check
    max_time(18_000,4);//tRPpb>max(18ns, 4nCK)
    refresh(); //REFab for trefw window
    `ifdef LP5_STD
      des(100);//ensure that finished read and write
      if(`LP_MODE == 4 && cfg.NumPStates > 1) begin //lp_mode = 4 always access pstate1 in the first time
        `ifdef POWERSIM_WCK_FREE1
           cas(rank,3'b111);//Disable wck, fix wck2ck sync error
        `endif
      end 
      else begin
        `ifdef POWERSIM_WCK_FREE
           cas(rank,3'b111);//Disable wck, fix wck2ck sync error
        `endif
      end
    `endif
  end
  `ifdef USER_TEST
  post_read0(i); 
  `endif
  rank = {rank[2:0],1'b1};
end

des(100);  //ensure that finished read and write. CS_n shall be held HIGH during clock stop with CKE high

des(100);  //ensure CAS_OFF finished
`ifdef LP_MODE
case(`LP_MODE)
  1,2,3: begin
    `ifdef DDRPHY_POWERSIM
      `ifdef DFI_LP_DATA
        `ifdef POWERSIM_DIS_DX_ODT
          DxOdtEn_set(2'h0,odt0_dx,DxOdtEn);
        `endif
        `ifdef POWERSIM_EN_DX_ODT
          DxOdtEn_set(2'h0,odt1_dx,DxOdtEn);
        `endif
      `endif
      `ifdef DFI_LP_CTRL
        `ifdef POWERSIM_DIS_AC_ODT
          AcOdtEn_set(2'h0,odt0_ac,AcOdtEn);
        `endif
        `ifdef POWERSIM_EN_AC_ODT
          AcOdtEn_set(2'h0,odt1_ac,AcOdtEn);
        `endif
      `endif
      `ifdef DFI_LP_CTRL_CLK_DISABLE
        `ifdef POWERSIM_DIS_AC_ODT
          AcOdtEn_set(2'h0,odt0_ac,AcOdtEn);
        `endif
        `ifdef POWERSIM_EN_AC_ODT
          AcOdtEn_set(2'h0,odt1_ac,AcOdtEn);
        `endif
        `ifdef POWERSIM_DIS_DX_ODT
          DxOdtEn_set(2'h0,odt0_dx,DxOdtEn);
        `endif
        `ifdef POWERSIM_EN_DX_ODT
          DxOdtEn_set(2'h0,odt1_dx,DxOdtEn);
        `endif
      `endif
      if(`LP_MODE!=2) DX_PowerDown(0);
    `endif
    `ifdef USER_TEST
    pre_dfi_lp(); 
    `endif
    if(!cfg.disable_dfi_lp) 
    dfi_lp(5000);
    `ifdef USER_TEST
    post_dfi_lp(); 
    `endif
    `ifdef DDRPHY_POWERSIM
      if(`LP_MODE!=2) DX_PowerDown_clr(0);
      `ifdef DFI_LP_DATA
        `ifdef POWERSIM_DIS_DX_ODT
          DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
        `endif
        `ifdef POWERSIM_EN_DX_ODT
          DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
        `endif
      `endif
      `ifdef DFI_LP_CTRL
        `ifdef POWERSIM_DIS_AC_ODT
          AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
        `endif
        `ifdef POWERSIM_EN_AC_ODT
          AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
        `endif
      `endif
      `ifdef DFI_LP_CTRL_CLK_DISABLE
        `ifdef POWERSIM_DIS_AC_ODT
          AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
        `endif
        `ifdef POWERSIM_EN_AC_ODT
          AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
        `endif
        `ifdef POWERSIM_DIS_DX_ODT
          DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
        `endif
        `ifdef POWERSIM_EN_DX_ODT
          DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
        `endif
      `endif
    `endif
    //repeat(10) @(posedge top.dfi_clk);
    rank=4'b1110;
    for( int i=0;i<cfg.NumRank_dfi0;i++)begin
      des(300);//Ensure last RD finished
      activate(rank, bg, bank, col);
      `ifdef USER_TEST
      pre_write1(i); 
      `endif
      if(!cfg.disable_write1[i])begin
        `ifndef USER_TEST
        des(50);
        `endif
        `ifdef LP5_STD
            cas(rank,100);
        `endif
        wrs(rank, bg, bank, col);
      end
      `ifdef USER_TEST
      post_write1(i); 
      `endif
      `ifdef USER_TEST
      pre_read1(i); 
      `endif
      if(!cfg.disable_read1[i])begin
        `ifndef USER_TEST
        des(50);
        `endif 
        `ifdef LP5_STD
          `ifdef POWERSIM_WCK_OFF
            cas(rank,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
          `endif
        `endif
        rds(rank, bg, bank, col);
        des(50);//invalid_command_during_reading_a_state_for_same_bank_check
        max_time(18_000,4);//tRPpb>max(18ns, 4nCK)
        refresh(); //REFab for trefw window
      end
      `ifdef USER_TEST
      post_read1(i); 
      `endif
      rank = {rank[2:0],1'b1};
    end
  end
  4: begin
    des(50);
    //if(cfg.NumPStates >1 ) begin
      for(int i=0; i<cfg.NumPStates; i++) begin
        `ifdef DDRPHY_POWERSIM
          pstate = i+1;
          `ifdef POWERSIM_DIS_AC_ODT
            AcOdtEn_set(2'h0,odt0_ac,AcOdtEn);
          `endif
          `ifdef POWERSIM_EN_AC_ODT
            AcOdtEn_set(2'h0,odt1_ac,AcOdtEn);
          `endif
          `ifdef POWERSIM_DIS_DX_ODT
            DxOdtEn_set(2'h0,odt0_dx,DxOdtEn);
          `endif
          `ifdef POWERSIM_EN_DX_ODT
            DxOdtEn_set(2'h0,odt1_dx,DxOdtEn);
          `endif
          AC_OdtStrenCodePD(pstate[0],odtpd_ac,OdtStrenCodePD_ac);
          DX_OdtStrenCodePD(pstate[0],odtpd_dx,OdtStrenCodePD_dx);
        `endif 
        `ifdef USER_TEST
        pre_freq_change(i); 
        `endif 
        `ifdef DDRPHY_POWERSIM
          if(cfg.NumPStates > 1)
            pm_fast_standby_wrapper(1);//when PState=2, next_freq=1 in LP2
          else
            pm_fast_standby_wrapper(0);//when PState=1, next_freq=0 in LP2
        `else
            if(!cfg.disable_freq_change[i]) begin
              pm_fc_wrapper(i);
            end
        `endif
        `ifdef USER_TEST
        post_freq_change(i); 
        `endif
        `ifdef DDRPHY_POWERSIM
          `ifdef POWERSIM_DIS_AC_ODT
            AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
          `endif
          `ifdef POWERSIM_EN_AC_ODT
            AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
          `endif
          `ifdef POWERSIM_DIS_DX_ODT
            DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
          `endif
          `ifdef POWERSIM_EN_DX_ODT
            DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
          `endif
          AC_OdtStrenCodePD(i,OdtStrenCodePD_ac,OdtStrenCodePD_ac1);
          DX_OdtStrenCodePD(i,OdtStrenCodePD_dx,OdtStrenCodePD_dx1);
        `endif

        //`ifdef DWC_DDRPHY_GATESIM
        //  if(i==0) rxclkdly_set(i);
        //`endif

        `ifndef USER_TEST
          beat_time(.Time(280_000), .pstate(cfg.PState));//tRFCab=280ns
        `endif
        rank=4'b1110;
        col = (col+77*(i+1)) & 10'h3f3;//"77"for working around 2018.12 VIP error to support dm feature. Correct column address,Expected value for C3,C2 is 2'b00
        for( int j=0;j<cfg.NumRank_dfi0;j++)begin
          activate(rank, bg, bank, col); 
          `ifdef USER_TEST
          pre_write1(j); 
          `endif
          if(!cfg.disable_write1[j])begin
            `ifndef USER_TEST
              max_time(18_000,4);//tRCD>max(18ns, 4nCK)
            `endif 
            `ifdef LP5_STD
                cas(rank,100);
            `endif
            wrs(rank, bg, bank, col);
          end
          `ifdef USER_TEST
          post_write1(j); 
          `endif
          `ifdef USER_TEST
          pre_read1(j); 
          `endif
          if(!cfg.disable_read1[j])begin
           `ifndef USER_TEST
            des(50);
            `endif 
            `ifdef LP5_STD
              if (i == 0) begin // in case pstate0
                `ifdef POWERSIM_WCK_OFF
                  cas(rank,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
                `endif
              end
              else begin // case pstate1
                `ifdef POWERSIM_WCK_OFF1
                  cas(rank,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
                `endif
              end
            `endif
            rds(rank, bg, bank, col);
            des(50);//invalid_command_during_reading_a_state_for_same_bank_check
            max_time(18_000,4);//tRPpb>max(18ns, 4nCK)
            refresh(); //REFab for trefw window
            `ifdef LP5_STD
               des(100);//ensure that finished read and write
              if (i == 0) begin // in case pstate0
                `ifdef POWERSIM_WCK_FREE
                   cas(rank,3'b111); //only send CAS_OFF cmd in case WCK_FREE
                `endif
              end
              else begin // case pstate1
                `ifdef POWERSIM_WCK_FREE1
                   cas(rank,3'b111); //only send CAS_OFF cmd in case WCK_FREE
                `endif
              end
            `endif
          end
          `ifndef USER_TEST
            des(50);
          `endif
          `ifdef USER_TEST
          post_read1(j); 
          `endif
          rank = {rank[2:0],1'b1};
        end //rank
        `ifdef DDRPHY_POWERSIM
            break;//only 1 Pstate in LP2 mode
        `endif
      end //NumPState
   // end
  end
  5,6: begin
    `ifdef DDRPHY_POWERSIM
      `ifdef POWERSIM_DIS_AC_ODT
        AcOdtEn_set(2'h0,odt0_ac,AcOdtEn);
      `endif
      `ifdef POWERSIM_EN_AC_ODT
        AcOdtEn_set(2'h0,odt1_ac,AcOdtEn);
      `endif
      `ifdef POWERSIM_DIS_DX_ODT
        DxOdtEn_set(2'h0,odt0_dx,DxOdtEn);
      `endif
      `ifdef POWERSIM_EN_DX_ODT
        DxOdtEn_set(2'h0,odt1_dx,DxOdtEn);
      `endif
    `endif 
    if(`LP_MODE==5) begin
      `ifdef USER_TEST
      pre_lp3(); 
      `endif
      if(!cfg.disable_lp3)
      pm_lp3_s3_wrapper(0);
      `ifdef USER_TEST
      post_lp3(); 
      `endif
    end else begin
      `ifdef USER_TEST
      pre_retention(); 
      `endif
      if(!cfg.disable_retention)
      pm_lp3_s3_wrapper(1);
      `ifdef USER_TEST
      post_retention();
      `endif
    end
    `ifdef DDRPHY_POWERSIM
      `ifdef POWERSIM_DIS_AC_ODT
        AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
      `endif
      `ifdef POWERSIM_EN_AC_ODT
        AcOdtEn_set(2'h0,AcOdtEn,AcOdtEn1);
      `endif
      `ifdef POWERSIM_DIS_DX_ODT
        DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
      `endif
      `ifdef POWERSIM_EN_DX_ODT
        DxOdtEn_set(2'h0,DxOdtEn,DxOdtEn1);
      `endif
    `endif

    //`ifdef DWC_DDRPHY_GATESIM
    //  rxclkdly_set(0);
    //`endif

    rank=4'b1110;
    for( int i=0;i< cfg.NumRank_dfi0;i++)begin
      activate(rank, bg, bank, row);
      `ifdef USER_TEST
      pre_write1(i); 
      `endif
      if(!cfg.disable_write1[i])begin
        `ifndef USER_TEST
        des(50);
        `endif 
        `ifdef LP5_STD
            cas(rank,100);
        `endif
        wrs(rank, bg, bank, col);
      end
      `ifdef USER_TEST
      post_write1(i); 
      `endif
      `ifdef USER_TEST
      pre_read1(i); 
      `endif
      if(!cfg.disable_read1[i])begin
        `ifndef USER_TEST
        des(50);
        `endif 
        `ifdef LP5_STD
          `ifdef POWERSIM_WCK_OFF
            cas(rank,100);//LPDDR5 SDRAM recieves invalid_wck_sync CAS command with WCK2CK Sync when Model is already in WCK2CK synchronization state in WCK free running mode
          `endif
        `endif
        rds(rank, bg, bank, col);
        des(50);//invalid_command_during_reading_a_state_for_same_bank_check
        max_time(18_000,4);//tRPpb>max(18ns, 4nCK)
        refresh(); //REFab for trefw window
      end
      `ifdef USER_TEST
      post_read1(i); 
      `endif
      rank = {rank[2:0],1'b1};
    end
  end
  default: begin
    $display("Error: unsupported low power mode:%0d",`LP_MODE);
  end
endcase
`endif

finish_test;

end

endmodule

