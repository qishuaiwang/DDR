`timescale 1ps/1ps
module jtag_drv (DdrPhyCsrCmdTdrCaptureEn, DdrPhyCsrCmdTdrShiftEn, DdrPhyCsrCmdTdrUpdateEn, DdrPhyCsrCmdTdr_Tdo, DdrPhyCsrRdDataTdrCaptureEn, DdrPhyCsrRdDataTdrShiftEn, DdrPhyCsrRdDataTdrUpdateEn, DdrPhyCsrRdDataTdr_Tdo, TDRCLK, WRSTN, WSI);

output reg DdrPhyCsrCmdTdrCaptureEn = 1'b0; //TDR capture enable for JTAG CfgCmd for reads and writes of CSRs
output reg DdrPhyCsrCmdTdrShiftEn = 1'b0; //TDR register control signals used to have JTAG set up CfgCmd for reads and writes of CSRs
output reg DdrPhyCsrCmdTdrUpdateEn = 1'b0; //TDR update enable for JTAG CfgCmd for reads and writes of CSRs
input  DdrPhyCsrCmdTdr_Tdo     ; //TDR output data for JTAG CfgCmd for reads and writes of CSRs

output reg DdrPhyCsrRdDataTdrCaptureEn = 1'b0; //TDR capture enable for JTAG Cfg for reads and writes of CSRs      
output reg DdrPhyCsrRdDataTdrShiftEn = 1'b0; //TDR register control signals used to have JTAG read data back from Cfg bus to access CSRs       
output reg DdrPhyCsrRdDataTdrUpdateEn = 1'b0; //TDR update enable for JTAG Cfg for reads and writes of CSRs   
input  DdrPhyCsrRdDataTdr_Tdo      ; //TDR output data for JTAG Cfg for reads and writes of CSRs

input  TDRCLK ; //TDR clock                                                
output reg WRSTN = 1'b1; //Low true reset to TDR                                              
output reg WSI = 1'b0; //TDR Serial Data In

//initial begin
//reg DdrPhyCsrCmdTdrCaptureEn = 1'b0;
//reg DdrPhyCsrCmdTdrShiftEn = 1'b0;
//reg DdrPhyCsrCmdTdrUpdateEn = 1'b0;
//reg DdrPhyCsrRdDataTdrCaptureEn = 1'b0;
//reg DdrPhyCsrRdDataTdrShiftEn = 1'b0;
//reg DdrPhyCsrRdDataTdrUpdateEn = 1'b0;
//reg WRSTN = 1'b1;
//reg WSI   = 1'b0;
//end

task write;
input [27:0] addr;
input [15:0] data;

reg [44:0] tdr_cmd_reg;

begin
  if(cfg.debug >=1 ) begin
    $display("[%0t] <%m> %h %h", $time, addr, data);
  end
  @ (posedge TDRCLK);
  tdr_cmd_reg = {data,1'b1,addr};
  
  WSI =  tdr_cmd_reg[0] ; //bring the WSI to a stable value to avoid a race caused due to possible change of WSI & CmdTdrShiftEn to be changing at the same tdrclk edge.
  //assert
  DdrPhyCsrCmdTdrCaptureEn = 1'b1 ;
  @ (posedge TDRCLK);
  DdrPhyCsrCmdTdrCaptureEn = 1'b0 ;
  
  @ (posedge TDRCLK);
  DdrPhyCsrCmdTdrShiftEn = 1'b1 ; //Assert DdrPhyCsrCmdTdrShiftEn for 45 clock cycles
  for (int cnt = 0 ; cnt < 45 ; cnt = cnt + 1 )  begin
    WSI = tdr_cmd_reg[cnt] ;
    @ (posedge TDRCLK);
  end
  DdrPhyCsrCmdTdrShiftEn = 1'b0 ;
  @ (posedge TDRCLK);
  DdrPhyCsrCmdTdrUpdateEn = 1'b1;
  @ (posedge TDRCLK);
  DdrPhyCsrCmdTdrUpdateEn = 1'b0;
end
endtask

task read;
input  [27:0] addr;
output [15:0] data;

reg [44:0] tdr_cmd_reg;
int        max_delay  = 0;

begin
  @ (posedge TDRCLK);
  tdr_cmd_reg = {15'h0,1'b0,addr};
  DdrPhyCsrCmdTdrCaptureEn = 1'b1 ;
  @ (posedge TDRCLK);
  DdrPhyCsrCmdTdrCaptureEn = 1'b0 ;
  WSI =  tdr_cmd_reg[0] ; //bring the WSI to a stable value to avoid a race caused due to possible change of WSI & CmdTdrShiftEn to be changing at the same tdrclk edge.
  
  @ (posedge TDRCLK);
  DdrPhyCsrCmdTdrShiftEn = 1'b1 ;
  for (int cnt = 0 ; cnt < 45 ; cnt = cnt + 1 )  begin
    WSI = tdr_cmd_reg[cnt] ;
    @ (posedge TDRCLK);
  end
  DdrPhyCsrCmdTdrShiftEn = 1'b0 ;
  @ (posedge TDRCLK);
  //assert DdrPhyCsrCmdTdrUpdateEn to update the command to the csr path
  DdrPhyCsrCmdTdrUpdateEn = 1'b1;
  @ (posedge TDRCLK);
  DdrPhyCsrCmdTdrUpdateEn = 1'b0;
  
  //Wait at least 10 TDRCLK cycles
  repeat(30) @ (posedge TDRCLK);
  //TDR Transaction to DdrPhyCsrRdDataTdr
  DdrPhyCsrRdDataTdrCaptureEn = 1'b1;
  @ (posedge TDRCLK);
  DdrPhyCsrRdDataTdrCaptureEn = 1'b0;
  
  max_delay = $urandom_range(17,10);
  
  repeat(max_delay) @ (posedge TDRCLK);
   DdrPhyCsrRdDataTdrShiftEn= 1'b1 ;
  @ (posedge TDRCLK);
  for ( int cnt = 0 ; cnt < 16 ; cnt = cnt +1) begin    
    data[cnt] = DdrPhyCsrRdDataTdr_Tdo;
    if ( cnt == 15 ) DdrPhyCsrRdDataTdrShiftEn = 1'b0;  //Assert DdrPhyCsrRdDataTdrShiftEn for 16 clock cycles
    @ (posedge TDRCLK);
  end
  DdrPhyCsrRdDataTdrUpdateEn = 1'b1;
  @ (posedge TDRCLK);
  DdrPhyCsrRdDataTdrUpdateEn = 1'b0;
  if(cfg.debug >=1 ) begin
    $display("[%0t] <%m> %h %h", $time, addr, data);
  end
end
endtask

task tdr_reset;
  begin
    WRSTN = 1'b0;
    repeat(10) @ (posedge TDRCLK);
    WRSTN = 1'b1;
  end
endtask
endmodule
