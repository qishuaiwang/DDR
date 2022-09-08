`timescale 1ps/1ps
module apb_drv (pclk, paddr, pwrite, psel, penable, pwdata, pready, pslverr, prdata);

input  pclk, pready, pslverr;
input [15:0] prdata;
output bit pwrite, psel, penable;
output bit [31:0] paddr;
output bit [15:0] pwdata;

wire pclkd;
assign pclkd = pclk;

//---------------------------------------------------------------
task write;
input [31:0] addr;
input [15:0] data;

`ifndef DWC_DDRPHY_HWEMUL
begin
  if(cfg.debug >=1 ) begin
    $display("[%0t] <%m> %h %h", $time, addr, data);
    `include "csr_apb_map.sv";
  end
  @(posedge pclkd);
  {pwrite,psel} = 2'b11;  paddr = addr; pwdata = data;
  penable = 1'b0;
  @(posedge pclkd);  penable = 1'b1;
  wait (pready);
  //@(posedge pclkd) {paddr, penable, pwrite, pwdata, psel} = 46'b0;
  //@(posedge pclkd);
end

//begin
//  //if(cfg.debug >=1 ) begin
//  //  $display("[%0t] <%m> %h %h", $time, addr, data);
//  //end
//  `include "csr_apb_map.sv";
//  @(posedge pclkd);
//  {pwrite,psel} = 2'b11;  paddr = addr; pwdata = data;
//  @(posedge pclkd)  penable = 1'b1;
//  wait (pready);
//  @(posedge pclkd) {paddr, penable, pwrite, pwdata, psel} = 46'b0;
//  @(posedge pclkd);
//end
`else   //`ifdef DWC_DDRPHY_HWEMUL
begin
  `include "csr_apb_map.sv";
  @(posedge pclkd);
  #1 {pwrite,psel} = 2'b11;  #1 paddr = addr; #1 pwdata = data;
  @(posedge pclkd)  #1 penable = 1'b1;
  wait (pready);
  @(posedge pclkd) #1 {paddr, penable, pwrite, pwdata, psel} = 46'b0;
  @(posedge pclkd);
end

`endif

endtask

//---------------------------------------------------------------
task read;
input  [31:0] addr;
output [15:0] data;

`ifndef DWC_DDRPHY_HWEMUL
begin
  //repeat (5) @(posedge pclk);
  @(posedge pclkd);
  {pwrite,psel} = 2'b01;  paddr = addr;   
  penable = 1'b0;
  @(posedge pclkd); penable = 1'b1;
  wait (pready);
 // @(posedge pclkd);  data = prdata;
  @(negedge pclkd)  data = prdata;
 // @(posedge pclkd) {paddr, pwrite, psel, penable} = 14'b0;
  if(cfg.debug >=1 ) begin
    $display("[%0t] <%m> %h %h", $time, addr, data);
    `include "csr_apb_map.sv";
  end  
// @(posedge pclkd);
end


//begin
//  repeat (5) @(posedge pclk);
//  {pwrite,psel} = 2'b01;  paddr = addr;   
//  @(posedge pclkd)  penable = 1'b1;
//  wait (pready);
//  @(negedge pclkd) data = prdata;
//  @(posedge pclkd) {paddr, pwrite, psel, penable} = 14'b0;
//  //if(cfg.debug >=1 ) begin
//  //  $display("[%0t] <%m> %h %h", $time, addr, data);
//  //end  
//  `include "csr_apb_map.sv";
//  @(posedge pclkd);
//end

`else

begin
  repeat (5) @(posedge pclk);
   #1 {pwrite,psel} = 2'b01; #1  paddr = addr;   
  @(posedge pclkd)  #1 penable = 1'b1;
  wait (pready);
  @(negedge pclkd) #1  data = prdata;
  @(posedge pclkd) #1 {paddr, pwrite, psel, penable} = 14'b0;
  //if(cfg.debug >=1 ) begin
  //  $display("[%0t] <%m> %h %h", $time, addr, data);
  //end  
  `include "csr_apb_map.sv";
  @(posedge pclkd);
end


`endif 

endtask

endmodule


//---------------------------------------------------------------
//
//module apb_slv (pclk, penable, pready);
//input pclk, penable;
//output pready;
//
//integer num = 0;
//
//always @(posedge pclk) begin
//  if (num == 0) begin
//    if (penable) 
//      num = {$random()}%8 + 2;
//  end
//  else num <= num-1;
//end
//
//assign pready = (num == 1);
//endmodule
//
////---------------------------------------------------------------
//
//module test;
//
//bit clk;
//always #5 clk = ~clk;
//
//wire pwrite, psel, penable, pready;
//wire [31:0] paddr;
//wire [15:0] pwdata;
//
//apb_drv drv (clk, paddr, pwrite, psel, penable, pwdata, pready, 16);
//
//apb_slv slv (clk, penable, pready);
//
//bit [31:0] data;
//
//initial begin
//  $vcdpluson();
//  #30 drv.write(12, 1);
//  drv.write(13, 2);
//  drv.write(14, 3);
//
//  drv.read(16, data);
//  $display("data = %0d", data);
//
//  #100 $finish;
//end
//
//endmodule
