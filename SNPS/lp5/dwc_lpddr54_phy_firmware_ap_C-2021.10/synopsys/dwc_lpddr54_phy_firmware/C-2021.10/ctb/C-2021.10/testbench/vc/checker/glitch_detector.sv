
`timescale 1ps/1ps
module glitch_detector(
  input dis, // Disable the glitch detector if asserted 
  input clk, // Clcok for din if it's sync signal
  input rst, // Reset, will be 
  input din, // Input signal for detecting
  input pol, // Polarity for Input signal, 0: high active; 1: low active
  output err // Error detected flag 
);

parameter mode=0;     // Detect mode: 0: check by during time; 1: check by persent of clk period;
parameter severity=0; // Report severity: 0: report by ERROR; 1: report by WARNING; 2: report by FATAL; 3: report by INFO;
parameter during=10;  // Only valid when mode is specified as 0, Pulse width less than the value of this parameter will be considered as a glitch,unit is ps
parameter percent=50; // Only valid when mode is specified as 1, Pulse width less than the percent of clk period will be considered as a glitch
parameter ex=0; // 1: check if X exists
parameter zed=0; // 1: check if high-Z exists

bit err_det;

wire en;
assign en = (~dis) && rst;
//wire err;
assign err = err_det;

time t_pre=0;
time t_post=0;
time t_pulse=0;
time t_x_pre=0;
time t_x_post=0;
time t_x_pulse=0;
time t_z_pre=0;
time t_z_post=0;
time t_z_pulse=0;
time t_clk_pre=0;
time t_clk_post=0;
time t_clk_pulse=0;

initial begin
  #1;
  wait(din!==1'bx);
  fork
    begin
      wait(clk==0||clk==1);
      forever begin
        @(clk);
        t_clk_pre = $time;
        t_clk_pulse = t_clk_pre - t_clk_post;
        t_clk_post = t_clk_pre;
        `ifdef DEBUG_CLK
          $display("@%0t, t_clk_pre is %0t, t_clk_post is %0t, t_clk_pulse is %0t", $time, t_clk_pre, t_clk_post, t_clk_pulse);
        `endif
      end
    end
    forever begin
//      fork
//        begin
//          wait(en==1);
          wait(din===(~pol));
          t_pre = $time;
          wait(din!==(~pol));
          t_post = $time;
          t_pulse = t_post - t_pre;
          `ifdef DEBUG_CLK
            $display("@%0t, t_pre is %0t, t_post is %0t, t_pulse is %0t", $time, t_pre, t_post, t_pulse);
          `endif
          if(en == 1 && mode == 0 && t_pulse < during) begin
            report($psprintf("glitch detected: mode = %0d, pulse during %0t againest check threshold %0t", mode, t_pulse, during)); 
            err_det = 1;
          end
          if(en == 1 && mode == 1 && t_pulse < (percent*t_clk_pulse/100)) begin
            report($psprintf("glitch detected: mode = %0d, pulse during %0t againest check threshold %0t(clock period:%0t, percent:%0d)", mode, t_pulse, (percent*t_clk_pulse/100), t_clk_pulse, percent));
            err_det = 1;
          end
          if(en == 1 && mode == 2) begin
            report($psprintf("unexpect value detected: mode = %0d, unexpect value %0d occurs at %0t and lasts for %0t", mode, ~pol, t_pre, t_pulse)); 
            err_det = 1;
          end
//        end
//        begin
//          @(negedge en);
//          $info($psprintf("%0t: glitch_detector disabled",$time));
//        end
//      join_any
//      disable fork;
    end
    forever begin // detect X pluse
      wait(din===1'bx);
      t_x_pre = $time;
      wait(din!==1'bx);
      t_x_post = $time;
      t_x_pulse = t_x_post - t_x_pre;
      if(en == 1 && ex == 1) begin
        report($psprintf("X detected: X occurs at %0t and lasts for %0t", mode, t_x_pre, t_x_pulse)); 
        err_det = 1;
      end
    end
    forever begin // detect Z pluse
      wait(din===1'bz);
      t_z_pre = $time;
      wait(din!==1'bz);
      t_z_post = $time;
      t_z_pulse = t_z_post - t_z_pre;
      if(en == 1 && zed == 1 ) begin
        report($psprintf("high-Z detected: tristated at %0t and lasts for %0t", t_z_pre, t_z_pulse)); 
        err_det = 1;
      end
    end
  join
end

task report(string msg);
  case (severity) 
    1: $warning($psprintf("%0t:%s",$time,msg));
    2: $fatal(1,$psprintf("%0t:%s",$time,msg));
    3: $info($psprintf("%0t:%s",$time,msg));
    default: $error($psprintf("%0t:%s",$time,msg));
  endcase
endtask

endmodule

