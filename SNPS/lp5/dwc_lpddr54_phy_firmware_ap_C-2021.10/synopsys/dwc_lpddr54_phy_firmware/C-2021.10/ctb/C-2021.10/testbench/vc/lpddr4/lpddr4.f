//
// Common 
//
-timescale=1ps/1fs

//
// VIP
//
+define+UVM_DISABLE_AUTO_ITEM_RECORDING 
+define+UVM_PACKER_MAX_BYTES=24000 
+define+UVM_REPORT_DISABLE_FILE_LINE 
+define+SYNOPSYS_SV 
+incdir+$CTB_VIP_HOME/include/sverilog 
+incdir+$CTB_VIP_HOME/src/sverilog/vcs 

$DESIGNWARE_HOME/vip/svt/common/latest/C/lib/amd64/libmemserver.so

+incdir+$CTB_HOME/testbench/vc/lpddr4/env
+incdir+$CTB_HOME/testbench/vc/lpddr4/src
+incdir+$CTB_HOME/testbench/vc/lpddr4/src/lpddr

$CTB_HOME/testbench/vc/lpddr4/src/uvmvlog_pkg.sv 
$CTB_HOME/testbench/vc/lpddr4/env/svt_vip_models.sv 
$CTB_HOME/testbench/vc/lpddr4/src/lpddr/lpddr4_dram_uvmvlog.sv


