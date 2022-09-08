glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_DIFF_CK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SEC_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SEC_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_0_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_DIFF_CK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.DIFF_CK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SEC_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SEC_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SEC_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_AC_WRAPPER_1_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_AC_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_0_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_0.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_1_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_1.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_2_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_2.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_3_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_3.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_4_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_4.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_5_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_5.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_6_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_6.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_DQS_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_DQS.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_rxen_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_rxen_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_DIFF_WCK_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.DIFF_WCK.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_0_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_0.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_1_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_1.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_2_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_2.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_3_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_3.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_4_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_4.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_5_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_5.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_6_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_6.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_7_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_7.lcdl_tx_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_c_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_c_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_rxclk_t_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_rxclk_t_wrapper.LCDL.cal_mode),
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
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dly_in),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dly_out),
`endif
  .rst (1'b1),
  .pol (1'b0),
  .err (err_det0_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper)
);
glitch_detector #(.mode(1), .severity(0), .during(10), .percent(49)) det1_u_DBYTE_WRAPPER_7_SE_8_lcdl_tx_wrapper(
`ifdef ATE_lcdl_linearity
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
  .clk (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dti),
  .din (test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.dto),
`else
  .dis ((!test.top.vddq)||test.top.dut.u_DBYTE_WRAPPER_7.SE_8.lcdl_tx_wrapper.LCDL.cal_mode),
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
