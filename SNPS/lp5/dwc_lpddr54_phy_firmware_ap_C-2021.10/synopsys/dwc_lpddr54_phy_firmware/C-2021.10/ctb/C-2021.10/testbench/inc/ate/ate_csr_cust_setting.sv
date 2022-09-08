//This file is applied to reconfig APB CSR for ATE if "-ate_cust_csr_cfg_file=file_name.sv" is added.
//
//Example for pll configuration

//NewCsr: PllCtrl1 14:0 RW_R0
//Where: p_tttt_cccc_0000_0100_1010 MASTER
//OneLiner: PState dependent PLL Control Register 1
//Description: This csr is to be programmed by bios or other means to define PLL frequency
//Description: in various PStates.
//Description: Refer to PLL subsection in PUB databook for valid values.
//Subfield: PllCpIntCtrl 6:0
// FieldDescription: Connects directly to cp_int_cntrl<6:0> PLL input.
// FieldDescription: Charge pump integrating current control.
//Subfield: ReservedPllCpIntCtrl 7:7
// FieldDescription: Reserved for future use
//Subfield: PllCpPropCtrl 14:8
// FieldDescription: Connects directly to cp_prop_cntrl<6:0> PLL input.
// FieldDescription: Charge pump proportional current control.
//CdcBufPresent: no
//Reset: 010_1100__0001_1000b
//ioSubGroup: mastermac
  apb_wr(32'h02004a, 'b000011000000010); //DWC_DDRPHYA_MASTER0_p0__PllCtrl1_p0
  apb_wr(32'h12004a, 'b000011000000010); //DWC_DDRPHYA_MASTER0_p1__PllCtrl1_p1

//NewCsr: PllCtrl4 14:0 RW_R0
//Where: p_tttt_cccc_0000_0100_1011 MASTER
//OneLiner: PState dependent PLL Control Register 4
//Description: This csr is to be programmed by bios or other means to set PLL charge-pump settings
//Description: in various PStates.
//Description: Refer to PLL subsection in PUB databook for valid values.
//Subfield: PllCpIntGsCtrl 6:0
// FieldDescription: Connects directly to cp_int_gs_cntrl<6:0> in PLL.
// FieldDescription: Charge pump integrating current control for fast relock and gearshift.
//Subfield: ReservedPllCpIntGsCtrl 7:7
// FieldDescription: Reserved for future use
//Subfield: PllCpPropGsCtrl 14:8
// FieldDescription: Connects directly to cp_prop_gs_cntrl<6:0> of PLL.
// FieldDescription: Charge pump proportional current control for fast relock and gearshift.
//CdcBufPresent: no
//Reset: 011_1100__0001_1111b
//ioSubGroup: mastermac
  apb_wr(32'h02004b, 'b010111001111111);//DWC_DDRPHYA_MASTER0_p0__PllCtrl4_p0
  apb_wr(32'h12004b, 'b010111001111111);//DWC_DDRPHYA_MASTER0_p1__PllCtrl4_p1





