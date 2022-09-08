// Library ARCv2EM-4.0.28
//----------------------------------------------------------------------------
//
// Copyright 2010-2015 Synopsys, Inc. All rights reserved.
//
/// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary 
// work of Synopsys, Inc., and is fully protected under copyright and 
// trade secret laws. You may not view, use, disclose, copy, or distribute 
// this file or any information contained herein except pursuant to a 
// valid written license from Synopsys, Inc.
//
// Certain materials incorporated herein are copyright (C) 2010 - 2011, The
// University Court of the University of Edinburgh. All Rights Reserved.
//
// The entire notice above must be reproduced on all authorized copies.
//
//----------------------------------------------------------------------------
//
// ###   ####   ####   #     #     #####      #     #     #
//  #   #    # #    #  ##   ##     #    #    # #    ##   ##
//  #   #      #       # # # #     #    #   #   #   # # # #
//  #   #      #       #  #  #     #####   #     #  #  #  #
//  #   #      #       #     #     #  #    #######  #     #
//  #   #    # #    #  #     #     #   #   #     #  #     #
// ###   ####   ####   #     # ### #    #  #     #  #     #
//
// ===========================================================================
//
// Description:
//
//  This file implements a behavioural model of an ICCM memory, for
//  use in simulation of the ARCv2EM processor.
//
//  The polarity of the cs, and we signals is configured through the
//  DWC_DDRPHY_PMU_RAM_POLARITY macro, which takes values 0, 1 to indicate the active
//  logic value for these signals. The DWC_DDRPHY_PMU_RAM_POLARITY macro is set in the
//  ramlib.vpp file for the technology selected at configuration time.
//
//  NOTE: this module should not be synthesized, nor should it be used
//  for gate-level simulation as it contains no delay information.
//
//  This .vpp source file must be pre-processed with the Verilog Pre-Processor
//  (VPP) to produce the equivalent .v file using a command such as:
//
//   vpp +q +o dwc_ddrphy_pmu_iccm_ram.vpp
//
// ===========================================================================

// LEDA off
// spyglass disable_block ALL

// Configuration-dependent macro definitions
//

// Simulation timestep information
//
// synopsys translate_off

///////////////////////////////////////////////////////////////////////////
// Common Verilog definitions
///////////////////////////////////////////////////////////////////////////

// Verilog simulator timescale definition for all modules
//
`timescale 1 ps / 1 ps

// synopsys translate_on
`ifdef DWC_DDRPHY_PMU_VERILATOR
`define DWC_DDRPHY_PMU_XCAM_MODEL
`endif
`ifdef DWC_DDRPHY_PMU_TTVTOC
`define DWC_DDRPHY_PMU_XCAM_MODEL
`endif
module dwc_ddrphy_pmu_iccm_ram #(
  parameter  par_data_msb =  31,
  parameter  par_addr_msb =  19,
  parameter  par_addr_lsb =  2
  ) (
  input                                ls,   // light sleep control - no behavioural modelling needed.
  input                                clk,  // clock input
  input   [par_data_msb: 0]            din,  // write data input
  input   [par_addr_msb:par_addr_lsb]  addr, // address for read or write
  input                                cs,   // RAM chip select, active high
  input                                we,   // memory write enable, active high
  output  [par_data_msb           :0]  dout  // read data output
  );
parameter par_addr_width = (par_addr_msb-par_addr_lsb+1);
parameter par_mem_size = (1 << par_addr_width);
parameter par_byte_addressing = (par_data_msb > 31);
parameter par_dpi_addr_msb = par_byte_addressing ? par_addr_msb : (par_addr_msb-par_addr_lsb);

`ifdef DWC_DDRPHY_PMU_FPGA_INFER_MEMORIES // {

fpga_sram #(
  .MEM_SIZE(par_mem_size),
  .DWC_DDRPHY_PMU_ADDR_MSB(par_addr_msb),
  .DWC_DDRPHY_PMU_ADDR_LSB(par_addr_lsb),
  .PIPELINED(1'b0),
  .DATA_WIDTH(39),
  .WR_SIZE(39),
  .SYNC_OUT(0),
  .RAM_STL("no_rw_check"))
u_iccm0_sram (
  .clk              (clk),
  .din              (din),
  .addr             (addr),
  .regen            (1'b1),
  .rden             (cs & !we),
  .wren             (cs & we),
  .dout             (dout));

`else        // } { not DWC_DDRPHY_PMU_FPGA_INFER_MEMORIES follows...



// =============== Verilog RAM model instantiation =====================

reg  [par_data_msb:0]            iccm_mem_0[0:(par_mem_size-1)];
reg  [par_addr_msb:par_addr_lsb] addr_r;
reg                              iccm_read_r;
reg                              dout_vld_r;

wire [par_data_msb:0]            iccm_mem_rd_data_prel;
wire [par_data_msb:0]            iccm_mem_rd_data;

// Module Definition

wire iccm_read;
assign #1 iccm_read = cs & !we;

wire [par_addr_msb:par_addr_lsb] addr_dly;
assign #1 addr_dly = addr;

always @(posedge clk)
begin

  iccm_read_r <= #1 iccm_read;

  if (iccm_read)
  begin
    addr_r    <= #1 addr_dly;
    dout_vld_r <= #1 1'b1;
  end
  else if (cs)  // Meaning write
  begin
    dout_vld_r <= #1 1'b0;    // dout is not valid, till next read
  end
end

wire iccm_write;
assign #1 iccm_write = cs & we;

reg[par_data_msb:0]    rd_data;
reg[par_data_msb:0]    rd_mod_data;

reg[par_data_msb:0]    rd_data_end;
reg[par_data_msb:0]    rd_mod_data_end;

wire [par_data_msb: 0] din_dly;
assign #1 din_dly = din;

always @(posedge clk)
begin
  if (iccm_write)
  begin
    // First do a read
    rd_data            = iccm_mem_0[addr_dly];

    // FIX BY ML: don't reorder byte order
    rd_data_end = rd_data;
    //rd_data_end = {
    //  rd_data[38:32],                             
    //  rd_data[7:0],
    //  rd_data[15:8],
    //  rd_data[23:16],
    //  rd_data[31:24]
    //  };

    rd_mod_data           = din_dly; 
   
    // FIX BY ML: don't reorder byte order
    rd_mod_data_end = rd_mod_data;
    //rd_mod_data_end = {
    //  rd_mod_data[38:32],                             
    //  rd_mod_data[7:0],
    //  rd_mod_data[15:8],
    //  rd_mod_data[23:16],
    //  rd_mod_data[31:24]
    //  };

    iccm_mem_0[addr_dly] = rd_mod_data_end;
  end
end

// Data is always stored in big endian representation in the memory model
// FIX BY ML: no I am chaning this, otherwise backdoor don't work

// The following assumes a little endian dwc_ddrphy_pmu_core
assign #1 iccm_mem_rd_data_prel = iccm_mem_0[addr_r];

`ifndef DWC_DDRPHY_PMU_XCAM_MODEL   // {
assign #1  iccm_mem_rd_data[38:32] =
      (iccm_mem_rd_data_prel[38:32] === 7'bx) ? 7'b0 : iccm_mem_rd_data_prel[38:32];
assign #1 iccm_mem_rd_data[7:0] =
      (iccm_mem_rd_data_prel[7:0] === 8'bx) ? 8'b0 : iccm_mem_rd_data_prel[7:0];
assign #1 iccm_mem_rd_data[15:8] =
      (iccm_mem_rd_data_prel[15:8] === 8'bx) ? 8'b0 : iccm_mem_rd_data_prel[15:8];
assign #1  iccm_mem_rd_data[23:16] =
      (iccm_mem_rd_data_prel[23:16] === 8'bx) ? 8'b0 : iccm_mem_rd_data_prel[23:16];
assign #1 iccm_mem_rd_data[31:24] =
      (iccm_mem_rd_data_prel[31:24] === 8'bx) ? 8'b0 : iccm_mem_rd_data_prel[31:24];
`else            // } {
assign #1 iccm_mem_rd_data = iccm_mem_rd_data_prel;
`endif           // }

wire  [par_data_msb:0]  dout_pre;      // read data output

assign
    // FIX BY ML: don't reorder byte order
    #1 dout_pre = iccm_mem_rd_data;
    //dout_pre = {
    //  iccm_mem_rd_data[38:32],                             
    //  iccm_mem_rd_data[7:0],
    //  iccm_mem_rd_data[15:8],
    //  iccm_mem_rd_data[23:16],
    //  iccm_mem_rd_data[31:24]
    //  };
assign #1 dout =   (dout_vld_r) ? dout_pre : {32{1'bx}};
//reg   wr_r;
//always @(posedge clk)
//begin : wr_r_PROC
//  wr_r <= #1 cs & we;
//end
//
//assign #1 dout = wr_r ? 39'b0 : dout_pre;


`endif       // }
endmodule // dwc_ddrphy_pmu_iccm_ram
// LEDA on
// spyglass enable_block ALL

