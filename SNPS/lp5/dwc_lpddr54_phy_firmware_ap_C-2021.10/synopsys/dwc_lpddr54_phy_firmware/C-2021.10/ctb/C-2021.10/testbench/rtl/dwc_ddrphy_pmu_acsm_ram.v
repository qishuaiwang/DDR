`timescale 1ps/1ps
module dwc_ddrphy_pmu_acsm_ram
// BEHAVIORIAL - if used for flop implementation, disable _CE for simplicity
    #(
      parameter DATAWID=72,
      parameter DEPTH=1024
    ) (
    input                       DfiClk,
    input [DATAWID-1:0]         wrdata,
    input [log2(DEPTH)-1:0]     addr,
    input                       wr,
    input                       ce,
    output [DATAWID-1:0]        rddata
  );
 
reg [DATAWID-1:0] mem [DEPTH-1:0];
reg [log2(DEPTH)-1:0] addr_d;
`ifdef DWC_DDRPHY_HWEMUL
	wire wren;
`endif

`ifndef DWC_DDRPHY_HWEMUL   
  always @(posedge DfiClk) begin
    addr_d <= addr;
    if (ce && wr) mem[addr] <= wrdata;  
  end
  assign rddata = mem[addr_d];
`else
  assign #1 wren= ce && wr;
    always @(posedge DfiClk) begin
      addr_d <= #1 addr;
      if (wren) mem[addr] <= wrdata;  
    end
    assign #1 rddata = mem[addr_d];
`endif

function integer log2;
  input integer value;
  integer      value_m1;
  begin
     value_m1 = value-1;
     for (log2=0; value_m1>0; log2=log2+1) value_m1 = value_m1>>1;
  end
endfunction // log2

endmodule // dwc_ddrphy_pmu_acsm_ram

