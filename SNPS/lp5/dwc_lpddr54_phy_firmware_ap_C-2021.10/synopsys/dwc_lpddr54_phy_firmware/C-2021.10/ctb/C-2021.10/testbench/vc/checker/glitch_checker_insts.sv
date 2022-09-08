module glitch_checker_insts();  
`ifdef GLITCH_CHECK
  integer log_file = $fopen("glitch_checker.log", "w+");
  // Checker for BP_MEMRESET_L
  //wire dis_det0_BP_MEMRESET_L = (~test.top.dut.u_DWC_DDRPHYMASTER_top.PwrOnReset.FinalMemReset_VIO);
  wire dis_det0_BP_MEMRESET_L = 0;
  //wire dis_det1_BP_MEMRESET_L = test.top.dut.u_DWC_DDRPHYMASTER_top.PwrOnReset.FinalMemReset_VIO;
  wire dis_det1_BP_MEMRESET_L = 0;

  reg Reset;
  reg byp_mode,pwrdn,standby,preset;
  reg power_off;
  initial fork
    begin
      Reset = 1'b1;
      @(negedge test.top.dut.Reset);
      Reset = 1'b0;
    end
    begin
      forever begin
        @(test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.byp_mode);
        byp_mode = test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.byp_mode;
      end
    end
    begin
      forever begin
        @(test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pwrdn);
        pwrdn = test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pwrdn;
      end
    end
    begin
      forever begin
        @(test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.standby);
        standby = test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.standby;
      end
    end
    begin
      forever begin
        @(test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.preset);
        preset = test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.preset;
      end
    end
  join
 
  assign dis_pll_chk = byp_mode|pwrdn|standby|preset;

  initial begin
    @(negedge test.top.dut.Reset);
    power_off = 1'b0;
    wait((test.top.vdd == 1'b0) && (test.top.vddq == 1'b0));
    power_off = 1'b1;
    wait((test.top.vdd == 1'b1) && (test.top.vddq == 1'b1));
    power_off = 1'b0;
  end 


`ifndef NO_DRAM_CHK 
  wire [1:0]  err_det0_CKE_CS; //CKE(LPDDR4), CS(LPDDR5)
  wire [1:0]  err_det1_CKE_CS;
  wire [7:0]  err_det0_CA_CS;  //CA(LPDDR4:[5:0], LPDDR5:[6:0]), CS(LPDDR4:CA[7:6])(CS_a/b)
  wire [7:0]  err_det1_CA_CS;
  wire        err_det_CK_T;
  wire        err_det_CK_C;

  genvar n;
  `ifdef LP4_STD
  reg [1:0] cke_chk0_enable=0;  //check if cke becomes 1 or x or z during mission mode
  reg [1:0] cke_chk1_enable=0;  //check if cke becomes 0 or x or z during non-mission mode
  reg [1:0] hwt_cke_chk0_org=0;
  reg [1:0] hwt_cke_chk1_org=0;
  reg       HwtMemSrc_IN;
  wire [1:0] hwt_cke_chk0;
  wire [1:0] hwt_cke_chk1;

  genvar n;
  generate 
    for(n=0;n<2;n=n+1)
      begin: hwt_cke_chk
        initial begin
          @(posedge test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN); //i_dfi_cke in pub switched to hwt control
          $display("HWT CKE CHECK:@ %0t, HwtMemSrc_IN assert", $time);
          $display("HWT CKE CHECK:@ %0t, BP_DFI0_LP4CKE_LP5CS[%d] is %b", $time, n, test.top.BP_DFI0_LP4CKE_LP5CS[n]);
          $display("HWT CKE CHECK:@ %0t, hwt_cke is %b", $time, test.top.dut.u_DWC_ddrphy_pub.ac_0.hwt_cke[7:0]);
          if(test.top.BP_DFI0_LP4CKE_LP5CS[n] == 0)
            if(test.top.dut.u_DWC_ddrphy_pub.ac_0.hwt_cke[7:0] == 8'h0) begin 
              hwt_cke_chk0_org[n]=1'b1;
              $display("HWT CKE CHECK:@ %0t, hwt_cke_chk0_org[%d] assert", $time, n);
            end
            else begin
              @(posedge top.dfi_clk);
              repeat(3) @(posedge test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out); //strict, considering detailed synchronization 
              @(posedge test.top.BP_DFI0_LP4CKE_LP5CS[n]);
              hwt_cke_chk1_org[n]=1'b1;
              $display("HWT CKE CHECK:@ %0t, hwt_cke_chk1_org[%d] assert", $time, n);
            end
          else
            if(test.top.dut.u_DWC_ddrphy_pub.ac_0.hwt_cke[7:0] == 8'h0) begin 
              @(posedge top.dfi_clk);
              repeat(3) @(posedge test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out); //strict, considering detailed synchronization 
              @(negedge test.top.BP_DFI0_LP4CKE_LP5CS[n]);
              hwt_cke_chk0_org[n]=1'b1;
              $display("HWT CKE CHECK:@ %0t, hwt_cke_chk0_org[%d] assert", $time, n);
            end
            else begin
              hwt_cke_chk1_org[n]=1'b1;
              $display("HWT CKE CHECK:@ %0t, hwt_cke_chk1_org[%d] assert", $time, n);
            end   

          forever begin
            @(test.top.dut.u_DWC_ddrphy_pub.ac_0.hwt_cke[n]);
            $display("HWT CKE CHECK:@ %0t, hwt_cke[%d] is %b", $time, n, test.top.dut.u_DWC_ddrphy_pub.ac_0.hwt_cke[n]);
            if(test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN==0) begin 
              hwt_cke_chk0_org[n]=1'b0;
              hwt_cke_chk1_org[n]=1'b0;
              break;
            end
            else
              if(test.top.dut.u_DWC_ddrphy_pub.ac_0.hwt_cke[n]==0) begin
                @(posedge top.dfi_clk);
                repeat(3) @(posedge test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out); //strict, considering detailed synchronization 
                @(negedge test.top.BP_DFI0_LP4CKE_LP5CS[n]);
                hwt_cke_chk0_org[n]=1'b1;
                hwt_cke_chk1_org[n]=1'b0;
                $display("HWT CKE CHECK:@ %0t, hwt_cke[%d] turns to 0, hwt_cke_chk0_org[%d] assert, hwt_cke_chk1_org[%d] de-assert", $time, n, n, n);
              end
              else begin
                @(posedge top.dfi_clk);
                repeat(3) @(posedge test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out); //strict, considering detailed synchronization 
                @(posedge test.top.BP_DFI0_LP4CKE_LP5CS[n]);
                hwt_cke_chk0_org[n]=1'b0;
                hwt_cke_chk1_org[n]=1'b1;
                $display("HWT CKE CHECK:@ %0t, hwt_cke[%d] turns to 1, hwt_cke_chk0_org[%d] de-assert, hwt_cke_chk1_org[%d] assert", $time, n, n, n);
              end
          end
        end
      end
  endgenerate
  initial begin
    forever begin
      @(test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN);
      HwtMemSrc_IN = test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN;
    end 
  end
  assign hwt_cke_chk0 = hwt_cke_chk0_org & {2{HwtMemSrc_IN}};
  assign hwt_cke_chk1 = hwt_cke_chk1_org & {2{HwtMemSrc_IN}};

  generate 
    for(n=0;n<2;n=n+1)
      begin: CKE_CHK0
        initial begin
          @(posedge test.top.dut.BP_MEMRESET_L); //MEM RESET release, check if CKE is 0
          cke_chk0_enable[n] = 1'b1;
          $display("CKE CHECK: @ %0t, BP_MEMRESET_L release and cke_chk0_enable[%d] assert", $time, n);
          @(posedge test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN); //HWT takes control, CKE toggles
          cke_chk0_enable[n] = 1'b0;
          $display("CKE CHECK: @ %0t, HwtMemSrc_IN assert and cke_chk0_enable[%d] de-assert", $time, n);

          @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN); 
          $display("CKE CHECK: @ %0t, HwtMemSrc_IN de-assert", $time);
          @(posedge test.top.dfi0_init_complete);//switch to mission mode
          $display("CKE CHECK: @ %0t, dfi0_init_complete assert", $time);
          @(posedge test.top.dut.dfi0_cke_P0[n]); // wait for cke from DFI assert
          $display("CKE CHECK: @ %0t, dfi0_cke_P0[%d] assert", $time, n);
          repeat(2) @(posedge top.dfi_clk);
          repeat(3) @(posedge test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out); //strict, considering detailed synchronization 
          @(posedge test.top.BP_DFI0_LP4CKE_LP5CS[n]);
          cke_chk1_enable[n] = 1'b1; 
          $display("CKE CHECK: @ %0t, DFI dfi_cke sync 1,cke_chk1_enable[%d] assert", $time, n);

          forever begin
            @(posedge test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN); //HWT takes control
            cke_chk1_enable[n] = 1'b0; 
            $display("CKE CHECK: @ %0t, HwtMemSrc_IN assert,cke_chk1_enable[%d] de-assert", $time, n);

            @(posedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrTxRdPtrInit);//cause TxBypassMode asserts then CKE becomes 0
            $display("CKE CHECK: @ %0t, csrTxRdPtrInit assert which will cause CKE 0", $time);
            wait(test.top.BP_DFI0_LP4CKE_LP5CS[n] == 1'b0); //path delay time 
            cke_chk0_enable[n] = 1'b1;
            $display("CKE CHECK:@ %0t, BP_DFI0_LP4CKE_LP5CS de-assert, cke_chk0_enable[%d] assert", $time, n);

            @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.csrTxRdPtrInit);
            cke_chk0_enable[n] = 1'b0;
            $display("CKE CHECK: @ %0t, csrTxRdPtrInit de-assert and cke_chk0_enable[%d] de-assert", $time, n);

            @(negedge test.top.dut.u_DWC_ddrphy_pub.ac_0.HwtMemSrc_IN); //
            $display("CKE CHECK: @ %0t, HwtMemSrc_IN de-assert", $time);
            wait(test.top.dut.u_DWC_ddrphy_pub.ac_0.i_dfi_cke[n] == 1'b1); //as HwtMemSrc_IN desserts, i_dfi_cke in pub switches to value of dfi0_cke_P0 which didn't change and keep 1 
            $display("CKE CHECK: @ %0t, as HwtMemSrc_IN desserts, i_dfi_cke in pub switches to value of dfi0_cke_P0[%d] which is 1", $time, n);
            @(posedge top.dfi_clk);
            repeat(3) @(posedge test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out); 
            wait(test.top.BP_DFI0_LP4CKE_LP5CS[n] == 1'b1);
            cke_chk1_enable[n] = 1'b1; 
            $display("CKE CHECK: @ %0t, PUB i_dfi_cke sync 1,cke_chk1_enable[%d] assert", $time, n);
          end
        end
      end
  endgenerate 
  `endif

  generate 
    for(n=0;n<2;n=n+1)
      begin: CKE_CS      //check for CKE(LPDDR4), CS(LPDDR5)
        `ifdef LP5_STD
        glitch_detector #(.mode(1), .severity(0), .during(10), .percent(80), .ex(1), .zed(0)) det0_CKE_CS(
          .dis (Reset),
          .clk (test.top.BP_DFI0_CK_T),
        `else
        glitch_detector #(.mode(2), .severity(0), .during(1000000), .percent(50), .ex(1), .zed(1)) det0_CKE_CS(
          .dis (Reset | (!cke_chk0_enable[n] & !hwt_cke_chk0[n])),
          .clk (1'b0),
        `endif
          .rst (1'b1),
          .din (test.top.BP_DFI0_LP4CKE_LP5CS[n]),
          .pol (1'b0),
          .err (err_det0_CKE_CS[n])
        );

        `ifdef LP5_STD
        glitch_detector #(.mode(1), .severity(0), .during(10), .percent(80), .ex(1), .zed(0)) det1_CKE_CS(
          .dis (Reset),
          .clk (test.top.BP_DFI0_CK_T),
        `else
        glitch_detector #(.mode(2), .severity(0), .during(1000000), .percent(50), .ex(1), .zed(1)) det1_CKE_CS(
          .dis (Reset | (!cke_chk1_enable[n] & !hwt_cke_chk1[n])),
          .clk (1'b0),
        `endif
          .rst (1'b1),
          .din (test.top.BP_DFI0_LP4CKE_LP5CS[n]),
          .pol (1'b1),
          .err (err_det1_CKE_CS[n])
        );
      end
  endgenerate 

  genvar j;
  generate 
    for(j=0;j<8;j=j+1)
      begin: CS_CA               //check for CA(LPDDR4:[5:0], LPDDR5:[6:0]), CS(LPDDR4:CA[7:6])
        glitch_detector #(.mode(1), .severity(0), .during(10), .percent(80), .ex(1)) det0_CS_CA(
        `ifdef LP5_STD
          .dis (Reset | power_off),
        `else
          .dis (Reset | (!test.top.BP_DFI0_LP4CKE_LP5CS[0]) | power_off),
        `endif
          .clk (test.top.BP_DFI0_CK_T),
          .rst (1'b1),
          .din (test.top.BP_DFI0_CA[j]),
          .pol (1'b0),
          .err (err_det0_CA_CS[j])
        );
        glitch_detector #(.mode(1), .severity(0), .during(10), .percent(80), .ex(1)) det1_CS_CA(
        `ifdef LP5_STD
          .dis (Reset | power_off),
        `else
          .dis (Reset | (!test.top.BP_DFI0_LP4CKE_LP5CS[0]) | power_off),
        `endif
          .clk (test.top.BP_DFI0_CK_T),
          .rst (1'b1),
          .din (test.top.BP_DFI0_CA[j]),
          .pol (1'b1),
          .err (err_det1_CA_CS[j])
        );
      end
  endgenerate 

  //check for CK
  glitch_detector #(.mode(3), .ex(1)) det_CK_H( // mode=3 is an invalid mode
  `ifdef LP5_STD
    .dis (Reset | power_off),
  `else
    .dis (Reset | (!test.top.BP_DFI0_LP4CKE_LP5CS[0]) | power_off),
  `endif
    .clk (1'b0),
    .rst (1'b1),
    .din (test.top.BP_DFI0_CK_T),
    .pol (1'b0),
    .err (err_det_CK_T)
  );
  glitch_detector #(.mode(3), .ex(1)) det_CK_L(
  `ifdef LP5_STD
    .dis (Reset | power_off),
  `else
    .dis (Reset | (!test.top.BP_DFI0_LP4CKE_LP5CS[0]) | power_off),
  `endif
    .clk (1'b0),
    .rst (1'b1),
    .din (test.top.BP_DFI0_CK_C),
    .pol (1'b0),
    .err (err_det_CK_C)
  );

  glitch_detector #(.mode(0), .severity(0), .during(1000000), .percent(50)) det0_BP_MEMRESET_L(
    .dis (Reset | dis_det0_BP_MEMRESET_L),
    .clk (1'b0),
    .rst (1'b1),
    .din (BP_MEMRESET_L),
    .pol (1'b0),
    .err (err_det0_BP_MEMRESET_L)
  );
  glitch_detector #(.mode(0), .severity(0), .during(1000000), .percent(50)) det1_BP_MEMRESET_L(
    .dis (Reset | dis_det1_BP_MEMRESET_L),
    .clk (1'b0),
    .rst (1'b1),
    .din (BP_MEMRESET_L),
    .pol (1'b1),
    .err (err_det1_BP_MEMRESET_L)
  );

  generate 
    for(n=0;n<2;n=n+1)
      begin: CKE_CS_CHK               //check for CKE, CS
        initial begin
          fork
            begin wait(err_det0_CKE_CS[n]==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_CKE_CS[%0d] detected!",n);end
            begin wait(err_det1_CKE_CS[n]==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det1_CKE_CS[%0d] detected!",n);end
          join
        end
      end
  endgenerate 

  generate 
    for(j=0;j<8;j=j+1)
      begin: CS_CA_CHK               //check for CS, CA
        initial begin
          fork
            begin wait(err_det0_CA_CS[j]==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_CA_CS[%0d] detected!",j);end
            begin wait(err_det1_CA_CS[j]==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det1_CA_CS[%0d] detected!",j);end
            $display("CA[%0d] error write done", j);
          join
        end
      end
  endgenerate

  initial fork
    begin wait(err_det_CK_T==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det_CK_T detected!");end
    begin wait(err_det_CK_C==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det_CK_C detected!");end
    begin wait(err_det0_BP_MEMRESET_L==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_BP_MEMRESET_L detected!"); end
    begin wait(err_det1_BP_MEMRESET_L==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det1_BP_MEMRESET_L detected!"); end
  join
 
`endif //NO_DRAM_CHK 
  
  // Checker for PLL
  // if csrPllX4Mode=1, pllout_x4x8 = 4*pllin_x1
  glitch_detector #(.mode(1), .severity(0), .during(10), .percent(24)) det0_PLLOUT_X4(
    .dis (Reset | dis_pll_chk | !test.top.dut.u_DWC_DDRPHYMASTER_top.csrPllX4Mode),
    .clk (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllin_x1),
    .rst (1'b1),
    .din (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllout_x4x8),
    .pol (1'b0),
    .err (err_det0_PLLOUT)
  );
  glitch_detector #(.mode(1), .severity(0), .during(10), .percent(24)) det1_PLLOUT_X4(
    .dis (Reset | dis_pll_chk | !test.top.dut.u_DWC_DDRPHYMASTER_top.csrPllX4Mode),
    .clk (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllin_x1),
    .rst (1'b1),
    .din (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllout_x4x8),
    .pol (1'b1),
    .err (err_det1_PLLOUT)
  );
  // if csrPllX4Mode=0, pllout_x4x8 = 8*pllin_x1
  glitch_detector #(.mode(1), .severity(0), .during(10), .percent(12)) det0_PLLOUT_X8(
    .dis (Reset | dis_pll_chk | test.top.dut.u_DWC_DDRPHYMASTER_top.csrPllX4Mode),
    .clk (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllin_x1),
    .rst (1'b1),
    .din (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllout_x4x8),
    .pol (1'b0),
    .err (err_det0_PLLOUT)
  );
  glitch_detector #(.mode(1), .severity(0), .during(10), .percent(12)) det1_PLLOUT_X8(
    .dis (Reset | dis_pll_chk | test.top.dut.u_DWC_DDRPHYMASTER_top.csrPllX4Mode),
    .clk (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllin_x1),
    .rst (1'b1),
    .din (test.top.dut.u_DWC_DDRPHYMASTER_top.PLL.pllout_x4x8),
    .pol (1'b1),
    .err (err_det1_PLLOUT)
  );
  
  initial begin
    fork
      begin wait(err_det0_PLLOUT==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_PLLOUT detected!"); end
      begin wait(err_det1_PLLOUT==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det1_PLLOUT detected!"); end
    join
  end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_NUM_RANKS_2
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

`ifdef DWC_DDRPHY_NUM_CHANNELS_2
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_NUM_RANKS_2
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

`endif
  `ifdef DWC_DDRPHY_EXISTS_DB0
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB1
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB2
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB3
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB4
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB5
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB6
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
  `ifdef DWC_DDRPHY_EXISTS_DB7
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper detected!\n"); end
  join
end

  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper detected!\n"); end
  join
end

  `endif
  `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis (Reset||(!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b1),
  .err (err_det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper)
);
initial begin
  fork
    begin wait(err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper detected!\n"); end
    begin wait(err_det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper==1); checker_error(); $fwrite(log_file, "glitch_detector Error: err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper detected!\n"); end
  join
end

  `endif
  `endif
`endif //GLITCH_CHECK
endmodule
