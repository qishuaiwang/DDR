

import uvm_pkg::*;
`include "uvm_macros.svh"

`ifdef PREFIX_OPT_ENABLE
  `include "dwc_ddrphy_top_unprefix.vh"
`endif

class phy_csr;
  string       phyCSRName;
  int unsigned phyCSRAddr;
  logic [15:0] phyCSRData;

  function new(string phy_csr_name, int unsigned phy_csr_addr);
    phyCSRName = phy_csr_name;  
    phyCSRAddr = phy_csr_addr;
  endfunction

  task phy_csr_read();
    top.apb.read(phyCSRAddr,phyCSRData);
  endtask
endclass : phy_csr


class phy_csr_state_checker;

  logic [15:0]  trainingPhyState[string];
  logic [15:0]  phyState[string];
  int unsigned  tolerance[string];
  int unsigned  ignorePhyState[string];
  int unsigned  rxReplicaStatusPhyState[string];
  logic [15:0]  rxReplicaStatusCSRData[bit][int][$]; //the first index 'bit' indicates that the related rxReplica CSRs are from train mode or quickboot mode; 
  logic [20:0]  rxReplicaStatusCSRAddr[bit][int][$]; //-- [0][][]: train mode;  [1][][]: quickboot mode
  phy_csr       arr[string];

  function new();
    //create class object arr[*]
    `ifdef QUICKBOOT
      `include "aarr.sv"
    `endif
    //Set Tolerance CSRs
    for(int db=0; db<4; db++) begin
      tolerance[$sformatf("DWC_DDRPHYA_DBYTE%0d__DxPhase1UI_p0", db)] = 1;
      tolerance[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaLcdlPh1UI_p0", db)] = 1;
    end

    for(int ac=0; ac<2; ac++) begin
      tolerance[$sformatf("DWC_DDRPHYA_AC%0d__AcPhase1UI_p0", ac)] = 1;
    end

    tolerance["DWC_DDRPHYA_MASTER0__ZCalCodePU_p0"] = 1;
    tolerance["DWC_DDRPHYA_MASTER0__ZCalCodePD_p0"] = 1;

    tolerance["DWC_DDRPHYA_MASTER0__ZCalCompResult_p0"] = 2; //mantis 0054668

    tolerance["DWC_DDRPHYA_MASTER0__ZCalPDResult_p0"] = 1;
    tolerance["DWC_DDRPHYA_MASTER0__ZCalPUResult_p0"] = 1;

    tolerance["DWC_DDRPHYA_MASTER0__ZQCalCodePD_p0"] = 1;
    tolerance["DWC_DDRPHYA_MASTER0__ZQCalCodePU_p0"] = 1;

    //List the ignore CSRs
    for(int ac=0; ac<2; ac++) begin
      for(int se=0; se<8; se++) begin
        ignorePhyState[$sformatf("DWC_DDRPHYA_AC%0d__ATestPrbsErrCntSE%0d_p0", ac, se)] = 1;
      end
    end

    for(int ac=0; ac<2; ac++) begin
      for(int lcdl=8; lcdl<11; lcdl++) begin
        ignorePhyState[$sformatf("DWC_DDRPHYA_AC%0d__DlyTestCntRingOscAclcdl%0d_p0", ac, lcdl)] = 1;
      end
    end

    for(int db=0; db<4; db++) begin
      for(int r=0; r<9; r++) begin
        //JIRA:P80001562-178313
        ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__DlyTestCntRingOscDblcdlDq_r%0d_p0", db,r)] = 1;
        ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxDfe0FifoInfo_r%0d_p0", db,r)] = 1;
      end
    end

    for(int db=0; db<4; db++) begin
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__DlyTestCntRingOscDblcdlDqs_p0", db)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__DlyTestCntRingOscDblcdlWck_p0", db)] = 1;
    end

    for(int dfi=0; dfi<2; dfi++) begin
      for(int i=0; i<2; i++) begin
        ignorePhyState[$sformatf("DWC_DDRPHYA_APBONLY0__Dfi%0dDebugCapture%0d_p0", dfi, i)] = 1;
      end
    end

    for(int db=0; db<4; db++) begin
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__PptRxDqsTrackInfo_p0", db)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaLcdlStatus2_p0", db)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__DxLcdlCalPhDetOut0_p0", db)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__DxLcdlCalPhDetOut1_p0", db)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__DxLcdlCalPhDetOut2_p0", db)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__DxPDsampleDIFF_p0", db)] = 1;
    end
    for(int ac=0; ac<2; ac++) begin
      ignorePhyState[$sformatf("DWC_DDRPHYA_AC%0d__AcLcdlCalPhDetOut_p0", ac)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_AC%0d__AcPDsampleDIFF_p0", ac)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_AC%0d__AcPDsampleSEC0_p0", ac)] = 1;
      ignorePhyState[$sformatf("DWC_DDRPHYA_AC%0d__AcPDsampleSEC1_p0", ac)] = 1;
    end

    for(int dfi=0; dfi<2; dfi++) begin
      ignorePhyState[$sformatf("DWC_DDRPHYA_MASTER0__Dfi%0dStatus_p0", dfi)] = 1;
    end
    ignorePhyState["DWC_DDRPHYA_MASTER0__ZCalCodePD_p0"] = 1;
    ignorePhyState["DWC_DDRPHYA_MASTER0__ZCalCodePU_p0"] = 1;
    ignorePhyState["DWC_DDRPHYA_MASTER0__ZCalPDResult_p0"] = 1;
    ignorePhyState["DWC_DDRPHYA_MASTER0__ZCalPUResult_p0"] = 1;
    ignorePhyState["DWC_DDRPHYA_MASTER0__ZCalCompResult_p0"] = 1;

    ignorePhyState["DWC_DDRPHYA_APBONLY0__MicroContMuxSel"] = 1;
    //
    //PllLockedCSR is sticky. It's a don't care for us at this point. Check
    //PllLockCSR instead. See P80001562-82553 for details and testcase.
    //
    ignorePhyState["DWC_DDRPHYA_MASTER0__PllLockedStatus_p0"] = 1;
    //List the rxreplica CSRs which should be checked after dfi_init_complete
    //Disable the checking of RxReplica CSRs in disabled Dbyte when PUB version is 200 and below, or TC60/TC61. mantis 0059356  
    for(int db=0; db<4; db++) begin
      if((((`DWC_DDRPHY_PUB_RID & 'hFFF) <= 'h220) || ((`DWC_DDRPHY_PUB_RID & 'hFFF) == 'h600) && ((`DWC_DDRPHY_PUB_RID & 'hFFF) != 'h100)) && ((((cfg.NumCh == 1) || ((cfg.NumCh == 2) && (cfg.NumActiveDbyteDfi1 == 0))) && (db > cfg.NumActiveDbyteDfi0 - 1)) || ((cfg.NumCh == 2) && (((db > cfg.NumActiveDbyteDfi0 - 1) && (db < cfg.NumDbytesPerCh)) || (db > cfg.NumDbytesPerCh + cfg.NumActiveDbyteDfi1 - 1))))) begin
        ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaLcdlPh1UI_p0", db)] = 1;
        ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaStatus00_p0", db)] = 1;
        ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaRatioNow_p0", db)] = 1;
        ignorePhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaRxClkDlyCorrection_p0", db)] = 1;
      end
      else begin
        rxReplicaStatusPhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaLcdlPh1UI_p0", db)] = 1;
        rxReplicaStatusPhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaStatus00_p0", db)] = 1;
        rxReplicaStatusPhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaRatioNow_p0", db)] = 1;
        rxReplicaStatusPhyState[$sformatf("DWC_DDRPHYA_DBYTE%0d__RxReplicaRxClkDlyCorrection_p0", db)] = 1;
      end
    end
  endfunction : new

  task getPhyState(ref logic [15:0] phyCSRData[string]);
    string idx;
    while (arr.next(idx)) begin
      arr[idx].phy_csr_read();
      phyCSRData[idx] = arr[idx].phyCSRData;
    end
  endtask

  function bit do_check();
    string idx;
    automatic int unsigned upr;
    automatic int unsigned lwr;

    $display("PHY_CSR_STATE_CHK: #################################################################");
    $display("PHY_CSR_STATE_CHK: #              PHY CSR STATE CHECKER Starting (0)               #");
    $display("PHY_CSR_STATE_CHK: #################################################################");

    while(phyState.next(idx)) begin
      if(ignorePhyState.exists(idx)) begin
        `uvm_info("PHY_CSR_STATE_CHK",$sformatf("%s -> ignore this CSR", idx),UVM_HIGH)
      end
      else if(rxReplicaStatusPhyState.exists(idx)) begin
        `uvm_info("PHY_CSR_STATE_CHK",$sformatf("%s -> this CSR will be checked after dfi_init_complete", idx),UVM_HIGH)
      end
      else if($isunknown(phyState[idx])) begin
        `uvm_error("PHY_CSR_STATE_CHK",$sformatf("%s -> phyState: 'h%0x, trainingPhyState: 'h%0x -> 'X' be detected on CSR.", idx, phyState[idx], trainingPhyState[idx]))
      end
      else if(tolerance.exists(idx)) begin
        upr = trainingPhyState[idx] + tolerance[idx];
        lwr = trainingPhyState[idx] < tolerance[idx] ? 0 : trainingPhyState[idx] - tolerance[idx];
        if(phyState[idx] inside {[lwr : upr]})
          `uvm_info("PHY_CSR_STATE_CHK",$sformatf("%s -> phyState: 'h%0x, trainingPhyState: 'h%0x ", idx, phyState[idx], trainingPhyState[idx]),UVM_HIGH)
        else
          `uvm_error("PHY_CSR_STATE_CHK",$sformatf("%s -> phyState: 'h%0x, trainingPhyState: 'h%0x, tolerance: 'h%0X", idx, phyState[idx], trainingPhyState[idx], tolerance[idx]))
      end
      else if(phyState[idx] != trainingPhyState[idx]) begin
        `uvm_error("PHY_CSR_STATE_CHK",$sformatf("%s -> phyState: 'h%0x, trainingPhyState: 'h%0x ", idx, phyState[idx], trainingPhyState[idx]))
      end
      else begin //just for debug
        `uvm_info("PHY_CSR_STATE_CHK",$sformatf("%s -> phyState: 'h%0x, trainingPhyState: 'h%0x ", idx, phyState[idx], trainingPhyState[idx]),UVM_HIGH)
      end
    end

    $display("PHY_CSR_STATE_CHK: #################################################################");
    $display("PHY_CSR_STATE_CHK: #                PHY CSR STATE CHECKER Done (0)                 #");
    $display("PHY_CSR_STATE_CHK: #################################################################");
  endfunction : do_check


  //The list RxReplica CSRs should be checked after dfi_init_complete
  task collect_status_csrRxReplica(bit quickbootRun);
    foreach(rxReplicaStatusPhyState[idx]) begin
      arr[idx].phy_csr_read();
      rxReplicaStatusCSRAddr[quickbootRun][cfg.PState].push_back(arr[idx].phyCSRAddr);
      rxReplicaStatusCSRData[quickbootRun][cfg.PState].push_back(arr[idx].phyCSRData);
    end
  endtask

//  function void do_check_csrRxReplica();
//    $display("PHY_CSR_STATE_CHK: #################################################################");
//    $display("PHY_CSR_STATE_CHK: #              PHY CSR STATE CHECKER Starting (1)               #");
//    $display("PHY_CSR_STATE_CHK: #################################################################");
//    foreach(rxReplicaStatusCSRData[1][j]) begin
//      if(rxReplicaStatusCSRData[1][j].size > 0) begin
//        foreach(rxReplicaStatusCSRData[1][cfg.PState][i]) begin
//          if((rxReplicaStatusCSRData[1][j][i] != rxReplicaStatusCSRData[0][j][i]) && cfg.phyinit.RxReplicaTrackEn[j]) begin 
//            `uvm_error("PHY_CSR_STATE_CHK",$sformatf("pstate %0d -> %0d -> rxReplicaStatusCSR: 'h%0x -> quickboot: 'h%0x, training: 'h%0x ", j, i, rxReplicaStatusCSRAddr[1][j][i], rxReplicaStatusCSRData[1][j][i], rxReplicaStatusCSRData[0][j][i]))
//          end
//          else begin
//            `uvm_info("PHY_CSR_STATE_CHK",$sformatf("pstate %0d -> %0d -> rxReplicaStatusCSR: 'h%0x -> quickboot: 'h%0x, training: 'h%0x, RxReplicaTrackEn: 'h%0x ", j, i, rxReplicaStatusCSRAddr[1][j][i], rxReplicaStatusCSRData[1][j][i], rxReplicaStatusCSRData[0][j][i], cfg.phyinit.RxReplicaTrackEn[j]),UVM_HIGH)
//          end
//        end
//      end
//    end
//    $display("PHY_CSR_STATE_CHK: #################################################################");
//    $display("PHY_CSR_STATE_CHK: #                PHY CSR STATE CHECKER Done (1)                 #");
//    $display("PHY_CSR_STATE_CHK: #################################################################");
//  endfunction

endclass
