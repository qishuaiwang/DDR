//----------------------------------------------------------------//
//              PowerSim AC/Dbyte Pattern Generation              //                                       
//----------------------------------------------------------------//
function power_ac_pattern_generation(int pattern_mode, output bit [2:0] bank[4], bit [9:0] col[4], bit [`DWC_DDRPHY_DFI_ADDRESS_WIDTH-1:0] des_addr[16]);
  if(pattern_mode==1) begin
  `ifdef LP4_STD
    bank[0]      = 3'h0;
    bank[1]      = 3'h1;
    bank[2]      = 3'h2;
    bank[3]      = 3'h3;
    `ifndef DDRPHY_B2B_RD
      col[0]       = 10'h330;
      col[1]       = 10'h130;
      col[2]       = 10'h330;
      col[3]       = 10'h130;
      des_addr[0]  = 6'h33;
      des_addr[1]  = 6'hc;
      des_addr[2]  = 6'h33;
      des_addr[3]  = 6'hc;
    `else
      col[0]       = 10'h334;
      col[1]       = 10'h134;
      col[2]       = 10'h334;
      col[3]       = 10'h134;
      des_addr[0]  = 6'h32;
      des_addr[1]  = 6'hd;
      des_addr[2]  = 6'h32;
      des_addr[3]  = 6'hd;
    `endif
  `else
    `ifndef DDRPHY_B2B_RD
      bank[0]      = 3'h1;
      bank[1]      = 3'h1;
      bank[2]      = 3'h1;
      bank[3]      = 3'h1;
      col[0]       = 10'h38;
      col[1]       = 10'h38;
      col[2]       = 10'h38;
      col[3]       = 10'h38;
      des_addr[0]  = 7'h7e;
      des_addr[1]  = 7'h1;
      des_addr[2]  = 7'h7e;
      des_addr[3]  = 7'h1;
      des_addr[4]  = 7'h7e;
      des_addr[5]  = 7'h1;
      des_addr[6]  = 7'h7e;
      des_addr[7]  = 7'h1;
      des_addr[8]  = 7'h7e;
      des_addr[9]  = 7'h1;
      des_addr[10] = 7'h7e;
      des_addr[11] = 7'h1;
      des_addr[12] = 7'h7e;
      des_addr[13] = 7'h1;
    `else
      bank[0]      = 3'h6;
      bank[1]      = 3'h6;
      bank[2]      = 3'h6;
      bank[3]      = 3'h6;
      col[0]       = 10'h30;
      col[1]       = 10'h30;
      col[2]       = 10'h30;
      col[3]       = 10'h30;
      des_addr[0]  = 7'h79;
      des_addr[1]  = 7'h6;
      des_addr[2]  = 7'h79;
      des_addr[3]  = 7'h6;
      des_addr[4]  = 7'h79;
      des_addr[5]  = 7'h6;
      des_addr[6]  = 7'h79;
      des_addr[7]  = 7'h6;
      des_addr[8]  = 7'h79;
      des_addr[9]  = 7'h6;
      des_addr[10] = 7'h79;
      des_addr[11] = 7'h6;
      des_addr[12] = 7'h79;
      des_addr[13] = 7'h6;
    `endif
  `endif
  end 
  else begin
  `ifdef LP4_STD
    bank[0]      = 3'h0;
    bank[1]      = 3'h1;
    bank[2]      = 3'h2;
    bank[3]      = 3'h3;
    col[0]       = 10'h0;
    col[1]       = 10'h0;
    col[2]       = 10'h0;
    col[3]       = 10'h0;
    des_addr[0]  = 6'h0;
    des_addr[1]  = 6'h0;
    des_addr[2]  = 6'h0;
    des_addr[3]  = 6'h0;
  `else
    bank[0]      = 3'h0;
    bank[1]      = 3'h0;
    bank[2]      = 3'h0;
    bank[3]      = 3'h0;
    col[0]       = 10'h38;
    col[1]       = 10'h38;
    col[2]       = 10'h38;
    col[3]       = 10'h38;
    des_addr[0]  = 7'h0;
    des_addr[1]  = 7'h0;
    des_addr[2]  = 7'h0;
    des_addr[3]  = 7'h0;
    des_addr[4]  = 7'h0;
    des_addr[5]  = 7'h0;
    des_addr[6]  = 7'h0;
    des_addr[7]  = 7'h0;
    des_addr[8]  = 7'h0;
    des_addr[9]  = 7'h0;
    des_addr[10] = 7'h0;
    des_addr[11] = 7'h0;
    des_addr[12] = 7'h0;
    des_addr[13] = 7'h0;
  `endif
  end
endfunction

function power_data_pattern_generation(int pattern_mode, output bit [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[32]);
  if(pattern_mode==1) begin
    for(int i=0; i<32; i++) begin
      if(i%2) begin
        Data[i]={`DWC_DDRPHY_NUM_DBYTES/2{16'haa00}};
      end
      else begin
        Data[i]={`DWC_DDRPHY_NUM_DBYTES/2{16'h55ff}};
      end
    end
  end
  else begin
    for(int i=0; i<32; i++) begin
       Data[i]={`DWC_DDRPHY_NUM_DBYTES/2{16'h00ff}};
    end
  end
endfunction

function power_data_prbs_pattern_generation(output bit [8*`DWC_DDRPHY_NUM_DBYTES-1:0] Data[32]);
bit [7:1] temp_lfsr;
bit [7:1] temp_lfsr_updt;
bit       xor_val;
bit [8*`DWC_DDRPHY_NUM_DBYTES-1:0] lfsr_data;

temp_lfsr[7:1] = 7'h00;
for (int i=0; i<32; i++) begin
  while ( temp_lfsr[7:1] === 7'h00) temp_lfsr[7:1] = $urandom_range(127,1);
  for ( int cnt = 0 ; cnt < 8*`DWC_DDRPHY_NUM_DBYTES ; cnt++ ) begin
    temp_lfsr_updt[7:1] = temp_lfsr[7:1];
    //do xor of bit 7 & 6
    xor_val = temp_lfsr_updt[7]^temp_lfsr_updt[6];
    temp_lfsr_updt[7:1] = {temp_lfsr_updt[6:1],xor_val}; 
    lfsr_data[cnt] = temp_lfsr_updt[1];
    temp_lfsr[7:1] = temp_lfsr_updt[7:1]; 
  end
  Data[i] = lfsr_data;
end
endfunction

function power_rd_data_prbs_pattern_generation(output bit [31:0] Data);
bit [7:1] temp_lfsr;
bit [7:1] temp_lfsr_updt;
bit       xor_val;
bit [31:0] lfsr_data;

temp_lfsr[7:1] = 7'h00;
for ( int cnt = 0 ; cnt < 32 ; cnt++ ) begin
  while ( temp_lfsr[7:1] === 7'h00) temp_lfsr[7:1] = $urandom_range(127,1);
  temp_lfsr_updt[7:1] = temp_lfsr[7:1];
  //do xor of bit 7 & 6
  xor_val = temp_lfsr_updt[7]^temp_lfsr_updt[6];
  temp_lfsr_updt[7:1] = {temp_lfsr_updt[6:1],xor_val}; 
  lfsr_data[cnt] = temp_lfsr_updt[1];
  temp_lfsr[7:1] = temp_lfsr_updt[7:1]; 
end
Data=lfsr_data;
endfunction
//----------------------------------------------------------------//
//                             End                                //                    
//----------------------------------------------------------------//


//----------------------------------------------------------------//
//                      DRAM MEMCORE Initialize                   //                    
//                      Read operation Only                       //                    
//----------------------------------------------------------------//

task automatic do_mem_core_initializaion();
  reg [9:0] col = 10'h30;
  reg [3:0] ba  = 3'b0;
  bit [31:0] data_pattern; 
  bit [63:0] data_pattern1; 
  reg [4:0] column ;

  for(int i=0;i<3000;i++)begin      // read time
   `ifdef POWERSIM_DATA_PATTERN0
     data_pattern1=64'h00ff00ff00ff00ff;
   `endif
   `ifdef POWERSIM_DATA_PATTERN1
     data_pattern1=64'h0055ffaaffaa0055;
   `endif
   data_pattern= data_pattern1[31:0];

  `ifdef LP4_STD
    for(reg[9:0] j=0;j<16;j++)begin   //burst lenth is 16
      //data_pattern1={data_pattern1[31:0],data_pattern1[63:32]};
      //data_pattern= data_pattern1[31:0];
      data_pattern={data_pattern[15:0],data_pattern[31:16]};
      for(int m=0; m<8; m++)begin
          //data_pattern={data_pattern[15:0],data_pattern[31:16]};    
          ba=m;
          `ifdef POWERSIM_DATA_PATTERN2
            power_rd_data_prbs_pattern_generation(data_pattern);
          `endif
          `LPDDR4_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
       `ifdef DWC_DDRPHY_NUM_DBYTES_4
       `ifdef RANK2
          `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
       `endif
       `endif
       `ifdef DWC_DDRPHY_NUM_DBYTES_8
          `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
       `ifdef RANK2
          `LPDDR4_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
          `LPDDR4_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,16'h70,col+j}, {ba,16'h70,col+j});
        `endif
        `endif
      end
        $display("write to addr=%h is data=%h, @ %0t",{ba,16'h70,col+j},data_pattern[15:0], $time);
    end
    col=col+16;
  `else
    for(reg[9:0] j=0;j<32;j++)begin   //burst lenth is 32
      //data_pattern1={data_pattern1[31:0],data_pattern1[63:32]};
      //data_pattern= data_pattern1[31:0];
      data_pattern={data_pattern[15:0],data_pattern[31:16]};
      for(int m=0; m<8; m++)begin
          //data_pattern={data_pattern[15:0],data_pattern[31:16]};    
          ba=m;
          column = j;
          `ifdef POWERSIM_DATA_PATTERN2
            power_rd_data_prbs_pattern_generation(data_pattern);
          `endif
          `LPDDR5_DRAM1.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM1.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
       `ifdef DWC_DDRPHY_NUM_DBYTES_4
       `ifdef RANK2
          `LPDDR5_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
       `endif
       `endif
       `ifdef DWC_DDRPHY_NUM_DBYTES_8
          `LPDDR5_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM2.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM2.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
       `ifdef RANK2
          `LPDDR5_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM3.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM3.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM4.mem_core_a.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
          `LPDDR5_DRAM4.mem_core_b.initialize(svt_mem_core::INIT_CONST, data_pattern[15:0], {ba,17'h70,col[5:0],column}, {ba,17'h70,col[5:0],column});
        `endif
        `endif
      end
        $display("write to addr=%h is data=%h, @ %0t",{ba,17'h70,col[5:0],5'b0},data_pattern[15:0], $time);
    end
    col=col+1;
  `endif
  end

endtask
//----------------------------------------------------------------//
//                             End                                //                    
//----------------------------------------------------------------//
task automatic PClkWckDis_set;
reg [3:0]  inst_addr;
reg [31:0] apb_addr;
reg [15:0] rddata;
reg [15:0] wrdata;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int i=0; i<8;i++)begin
      inst_addr = i;
      apb_addr = {16'h1,inst_addr,12'h4};
      dwc_ddrphy_apb_rd(apb_addr,rddata);
      $display("apb_addr %h, apb read PClkWckDis is %b",apb_addr,rddata);
      wrdata = {rddata[15:11],1'b1,rddata[9:0]};
      dwc_ddrphy_apb_wr(apb_addr,wrdata); 
      $display("apb_addr %h, apb write PClkWckDis is %b",apb_addr,wrdata);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask 

//task automatic OdtEn_set(bit sel_dbyte=0,bit sel_ac=0,bit [1:0] PState=0);
//reg [3:0]  inst_addr_dx;
//reg [31:0] apb_addr_dx;
//reg [15:0] rddata_dx;
//reg [15:0] wrdata_dx;
//reg [3:0]  inst_addr_ac;
//reg [31:0] apb_addr_ac;
//reg [15:0] rddata_ac;
//reg [15:0] wrdata_ac;
//begin
//  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
//  for(int i=0; i<8;i++)begin
//      inst_addr_dx = i;
//      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h97};
//      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx);
//      $display("apb_addr_dx %h, apb read DxOdtEn is %h",apb_addr_dx,rddata_dx);
//      if(!sel_dbyte) wrdata_dx = {rddata_dx[15:11],11'h0};
//      else           wrdata_dx = {rddata_dx[15:11],11'h7ff};
//      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
//      $display("apb_addr_dx %h, apb write DxOdtEn is %h",apb_addr_dx,wrdata_dx);
//  end
//  for(int j=0; j<2;j++)begin
//      inst_addr_ac = j;
//      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h88};
//      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac);
//      $display("apb_addr_ac %h, apb read AcOdtEn is %h",apb_addr_ac,rddata_ac);
//      if(!sel_ac) wrdata_ac = {rddata_ac[15:9],9'h0};
//      else        wrdata_ac = {rddata_ac[15:9],9'h1ff};
//      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
//      $display("apb_addr_ac %h, apb write AcOdtEn is %h",apb_addr_ac,wrdata_ac);
//  end
//  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
//end
//endtask

task automatic Zcal_set;
reg [15:0] rddata;
reg [15:0] wrdata;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0); 
  //dwc_ddrphy_apb_rd(32'h20326,rddata);
  //$display("apb_addr 32'h20326, apb read is %h",rddata);
  //wrdata = {8'hff,rddata[7:0]};
  //dwc_ddrphy_apb_wr(32'h20326,wrdata); 
  //$display("apb_addr 32'h20326, apb write is %h",wrdata);    //set ZQCalCodeOvrValPU = 8'hff

  //dwc_ddrphy_apb_rd(32'h20327,rddata);
  //$display("apb_addr 32'h20327, apb read is %h",rddata);
  //wrdata = {8'hff,rddata[7:0]};
  //dwc_ddrphy_apb_wr(32'h20327,wrdata); 
  //$display("apb_addr 32'h20327, apb write is %h",wrdata);    //set ZQCalCodeOvrValPD = 8'hff

  //dwc_ddrphy_apb_rd(32'h20326,rddata);
  //$display("apb_addr 32'h20326, apb read is %h",rddata);
  //wrdata = {rddata[15:1],1'b1};
  //dwc_ddrphy_apb_wr(32'h20326,wrdata); 
  //$display("apb_addr 32'h20326, apb write is %h",wrdata);    //set ZQCalCodeOvrEnPU=1'b1 

  //dwc_ddrphy_apb_rd(32'h20327,rddata);
  //$display("apb_addr 32'h20327, apb read is %h",rddata);
  //wrdata = {rddata[15:1],1'b1};
  //dwc_ddrphy_apb_wr(32'h20327,wrdata); 
  //$display("apb_addr 32'h20327, apb write is %h",wrdata);    //set ZQCalCodeOvrEnPD=1'b1 

  //dwc_ddrphy_apb_rd(32'h20311,rddata);
  //$display("apb_addr 32'h20311, apb read is %h",rddata);
  //wrdata = {rddata[15:1],1'b0};
  //dwc_ddrphy_apb_wr(32'h20311,wrdata); 
  //$display("apb_addr 32'h20311, apb write is %h",wrdata);    //set ZCalRun = 1'b0

  //dwc_ddrphy_apb_rd(32'h20310,rddata);
  //$display("apb_addr 32'h20310, apb read is %h",rddata);
  //wrdata = {rddata[15:1],1'b0};
  //dwc_ddrphy_apb_wr(32'h20310,wrdata); 
  //$display("apb_addr 32'h20310, apb write is %h",wrdata);    //set ZCalReset = 1'b0

  //dwc_ddrphy_apb_rd(32'h20311,rddata);
  //$display("apb_addr 32'h20311, apb read is %h",rddata);
  //wrdata = {rddata[15:1],1'b1};
  //dwc_ddrphy_apb_wr(32'h20311,wrdata); 
  //$display("apb_addr 32'h20311, apb write is %h",wrdata);    //set ZCalRun = 1'b1

  wait(test.top.dfi0_init_complete==1'b1);
  `ifndef DWC_DDRPHY_TOP_PG_PINS
  wait(test.top.dut.pac4a.u_DWC_ddrphy_pub.MASTER_dig.l4regs_MASTER.csrZCalBusy[0]==1'b0);
  `else
  wait(test.top.dut.u_DWC_ddrphy_pub.MASTER_dig.l4regs_MASTER.csrZCalBusy[0]==1'b0);
  `endif
  dwc_ddrphy_apb_rd(32'h20311,rddata);
  $display("apb_addr 32'h20311, apb read is %h",rddata);
  wrdata = {rddata[15:1],1'b0};
  dwc_ddrphy_apb_wr(32'h20311,wrdata); 
  $display("apb_addr 32'h20311, apb write is %h",wrdata);    //set ZCalRun = 1'b0

  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic Replica_set(bit [1:0] PState=0);
reg [3:0]  inst_addr_dx;
reg [31:0] apb_addr_dx;
reg [15:0] rddata_dx;
reg [15:0] wrdata_dx;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int i=0; i<8;i++)begin
      inst_addr_dx = i;
      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'hf};
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx);
      $display("apb_addr_dx %h, apb read RxReplicaCtl04 is %h",apb_addr_dx,rddata_dx);
      wrdata_dx = {rddata_dx[15:1],1'b0};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write RxReplicaCtl04 is %h",apb_addr_dx,wrdata_dx);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic DTO_set;
reg [15:0] rddata;
reg [15:0] wrdata;
begin
  force test.top.dut.TxBypassMode_DTO = 1'b0;
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  dwc_ddrphy_apb_rd(32'h200ab,rddata);
  $display("apb_addr 32'h200ab, apb read is %h",rddata);
  wrdata = {rddata[15:1],1'b0};
  dwc_ddrphy_apb_wr(32'h200ab,wrdata); 
  $display("apb_addr 32'h200ab, apb write is %h",wrdata);
 
  dwc_ddrphy_apb_rd(32'h200aa,rddata);
  $display("apb_addr 32'h200aa, apb read is %h",rddata);
  wrdata = {rddata[15:1],1'b1};
  dwc_ddrphy_apb_wr(32'h200aa,wrdata); 
  $display("apb_addr 32'h200aa, apb write is %h",wrdata);

  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic AC_PowerDown(bit [1:0] PState=0);
reg [3:0]  inst_addr_ac;
reg [31:0] apb_addr_ac;
reg [15:0] rddata_ac;
reg [15:0] wrdata_ac;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int j=0; j<2;j++)begin
      inst_addr_ac = j;
      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h82};
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac);
      $display("apb_addr_ac %h, apb read AcRxPowerDown is %h",apb_addr_ac,rddata_ac);
      wrdata_ac = {rddata_ac[15:9],9'h1ff};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AcRxPowerDown is %h",apb_addr_ac,wrdata_ac);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic DX_PowerDown(bit [1:0] PState=0,bit [11:0] Data=12'h7ff);
reg [3:0]  inst_addr_dx;
reg [31:0] apb_addr_dx;
reg [15:0] rddata_dx;
reg [15:0] wrdata_dx;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int i=0; i<8;i++)begin
      inst_addr_dx = i;
      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h93};
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx);
      $display("apb_addr_dx %h, apb read DxRxPowerDown is %h",apb_addr_dx,rddata_dx);
      //[8:0]: se; [9]:dqs; [10]:wck; [11]: RxReplica
      wrdata_dx = {rddata_dx[15:11],Data[10:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write DxRxPowerDown is %h",apb_addr_dx,wrdata_dx);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic DX_PowerDown_clr(bit [1:0] PState=0);
reg [3:0]  inst_addr_dx;
reg [31:0] apb_addr_dx;
reg [15:0] rddata_dx;
reg [15:0] wrdata_dx;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int i=0; i<8;i++)begin
      inst_addr_dx = i;
      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h93};
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx);
      $display("apb_addr_dx %h, apb read DxRxPowerDown is %h",apb_addr_dx,rddata_dx);
      wrdata_dx = {rddata_dx[15:11],11'h0};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write DxRxPowerDown is %h",apb_addr_dx,wrdata_dx);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic DqsClk_Dis(bit [1:0] PState=0);
reg [3:0]  inst_addr_dx;
reg [31:0] apb_addr_dx;
reg [15:0] rddata_dx;
reg [15:0] wrdata_dx;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int i=0; i<8;i++)begin
      inst_addr_dx = i;
      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h4};
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx);
      $display("apb_addr_dx %h, apb read PClkDqsDis(bit[9]) is %h",apb_addr_dx,rddata_dx);
      wrdata_dx = {rddata_dx[15:10],1'b1,rddata_dx[8:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write PClkDqsDis(bit[9]) is %h",apb_addr_dx,wrdata_dx);
  end
  for(int i=0; i<8;i++)begin
      inst_addr_dx = i;
      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h3};
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx);
      $display("apb_addr_dx %h, apb read DfiClkDqsDis(bit[9]) is %h",apb_addr_dx,rddata_dx);
      wrdata_dx = {rddata_dx[15:10],1'b1,rddata_dx[8:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write DfiClkDqsDis(bit[9]) is %h",apb_addr_dx,wrdata_dx);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic AC_OdtStrenCodePD;
input  [1:0]  PState;
input  [23:0] Data[2];
output [23:0] OdtStrenCodePD_ac[2];
reg [3:0]  inst_addr_ac;
reg [31:0] apb_addr_ac;
reg [15:0] rddata_ac0;
reg [15:0] rddata_ac1;
reg [15:0] rddata_ac2;
reg [15:0] rddata_ac3;
reg [15:0] rddata_ac4;
reg [15:0] rddata_ac5;
reg [15:0] wrdata_ac;
reg [3:0]  wrdata_ac0;
reg [3:0]  wrdata_ac1;
reg [3:0]  wrdata_ac2;
reg [3:0]  wrdata_ac3;
reg [3:0]  wrdata_ac4;
reg [3:0]  wrdata_ac5;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int j=0; j<2;j++)begin
      inst_addr_ac = j;
      {wrdata_ac5,wrdata_ac4,wrdata_ac3,wrdata_ac2,wrdata_ac1,wrdata_ac0}=Data[j];

      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h48}; //OdtStrenCodePDSE0
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac0);
      $display("apb_addr_ac %h, apb read AC OdtStrenCodePDSE0 is %h",apb_addr_ac,rddata_ac0);
      wrdata_ac = {rddata_ac0[15:12],wrdata_ac0,rddata_ac0[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AC OdtStrenCodePDSE0 is %h",apb_addr_ac,wrdata_ac);

      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h49}; //OdtStrenCodePDSE1
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac1);
      $display("apb_addr_ac %h, apb read AC OdtStrenCodePDSE1 is %h",apb_addr_ac,rddata_ac1);
      wrdata_ac = {rddata_ac1[15:12],wrdata_ac1,rddata_ac1[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AC OdtStrenCodePDSE1 is %h",apb_addr_ac,wrdata_ac);

      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h4a}; //OdtStrenCodePDDIFF0T
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac2);
      $display("apb_addr_ac %h, apb read AC OdtStrenCodePDDIFF0T is %h",apb_addr_ac,rddata_ac2);
      wrdata_ac = {rddata_ac2[15:12],wrdata_ac2,rddata_ac2[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AC OdtStrenCodePDDIFF0T is %h",apb_addr_ac,wrdata_ac);

      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h4b}; //OdtStrenCodePDDIFF0C
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac3);
      $display("apb_addr_ac %h, apb read AC OdtStrenCodePDDIFF0C is %h",apb_addr_ac,rddata_ac3);
      wrdata_ac = {rddata_ac3[15:12],wrdata_ac3,rddata_ac3[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AC OdtStrenCodePDDIFF0C is %h",apb_addr_ac,wrdata_ac);

      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h4c}; //OdtStrenCodePDDIFF1T
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac4);
      $display("apb_addr_ac %h, apb read AC OdtStrenCodePDDIFF1T is %h",apb_addr_ac,rddata_ac4);
      wrdata_ac = {rddata_ac4[15:12],wrdata_ac4,rddata_ac4[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AC OdtStrenCodePDDIFF1T is %h",apb_addr_ac,wrdata_ac);

      apb_addr_ac = {10'h0,PState,4'h3,inst_addr_ac,12'h4d}; //OdtStrenCodePDDIFF1C
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac5);
      $display("apb_addr_ac %h, apb read AC OdtStrenCodePDDIFF1C is %h",apb_addr_ac,rddata_ac5);
      wrdata_ac = {rddata_ac5[15:12],wrdata_ac5,rddata_ac5[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AC OdtStrenCodePDDIFF1C is %h",apb_addr_ac,wrdata_ac);

      OdtStrenCodePD_ac[j]={rddata_ac5[11:8],rddata_ac4[11:8],rddata_ac3[11:8],rddata_ac2[11:8],rddata_ac1[11:8],rddata_ac0[11:8]};
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask
task automatic DX_OdtStrenCodePD;
input  [1:0]  PState;
input  [23:0] Data[8];
output [23:0] OdtStrenCodePD_dx[8];
reg [3:0]  inst_addr_dx;
reg [31:0] apb_addr_dx;
reg [15:0] rddata_dx0;
reg [15:0] rddata_dx1;
reg [15:0] rddata_dx2;
reg [15:0] rddata_dx3;
reg [15:0] rddata_dx4;
reg [15:0] rddata_dx5;
reg [15:0] wrdata_dx;
reg [3:0]  wrdata_dx0;
reg [3:0]  wrdata_dx1;
reg [3:0]  wrdata_dx2;
reg [3:0]  wrdata_dx3;
reg [3:0]  wrdata_dx4;
reg [3:0]  wrdata_dx5;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int j=0; j<8;j++)begin
      inst_addr_dx = j;
      {wrdata_dx5,wrdata_dx4,wrdata_dx3,wrdata_dx2,wrdata_dx1,wrdata_dx0}=Data[j];

      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h48}; //OdtStrenCodePDSE0
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx0);
      $display("apb_addr_dx %h, apb read AC OdtStrenCodePDSE0 is %h",apb_addr_dx,rddata_dx0);
      wrdata_dx = {rddata_dx0[15:12],wrdata_dx0,rddata_dx0[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write AC OdtStrenCodePDSE0 is %h",apb_addr_dx,wrdata_dx);

      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h49}; //OdtStrenCodePDSE1
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx1);
      $display("apb_addr_dx %h, apb read AC OdtStrenCodePDSE1 is %h",apb_addr_dx,rddata_dx1);
      wrdata_dx = {rddata_dx1[15:12],wrdata_dx1,rddata_dx1[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write AC OdtStrenCodePDSE1 is %h",apb_addr_dx,wrdata_dx);

      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h4a}; //OdtStrenCodePDDIFF0T
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx2);
      $display("apb_addr_dx %h, apb read AC OdtStrenCodePDDIFF0T is %h",apb_addr_dx,rddata_dx2);
      wrdata_dx = {rddata_dx2[15:12],wrdata_dx2,rddata_dx2[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write AC OdtStrenCodePDDIFF0T is %h",apb_addr_dx,wrdata_dx);

      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h4b}; //OdtStrenCodePDDIFF0C
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx3);
      $display("apb_addr_dx %h, apb read AC OdtStrenCodePDDIFF0C is %h",apb_addr_dx,rddata_dx3);
      wrdata_dx = {rddata_dx3[15:12],wrdata_dx3,rddata_dx3[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write AC OdtStrenCodePDDIFF0C is %h",apb_addr_dx,wrdata_dx);

      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h4c}; //OdtStrenCodePDDIFF1T
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx4);
      $display("apb_addr_dx %h, apb read AC OdtStrenCodePDDIFF1T is %h",apb_addr_dx,rddata_dx4);
      wrdata_dx = {rddata_dx4[15:12],wrdata_dx4,rddata_dx4[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write AC OdtStrenCodePDDIFF1T is %h",apb_addr_dx,wrdata_dx);

      apb_addr_dx = {10'h0,PState,4'h1,inst_addr_dx,12'h4d}; //OdtStrenCodePDDIFF1C
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx5);
      $display("apb_addr_dx %h, apb read AC OdtStrenCodePDDIFF1C is %h",apb_addr_dx,rddata_dx5);
      wrdata_dx = {rddata_dx5[15:12],wrdata_dx5,rddata_dx5[7:0]};
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write AC OdtStrenCodePDDIFF1C is %h",apb_addr_dx,wrdata_dx);

      OdtStrenCodePD_dx[j]={rddata_dx5[11:8],rddata_dx4[11:8],rddata_dx3[11:8],rddata_dx2[11:8],rddata_dx1[11:8],rddata_dx0[11:8]};
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic AcOdtEn_set;
input  [1:0]  sel_ac;
input  [8:0]  data[2];
output [8:0]  AcOdtEn[2];
reg [3:0]  inst_addr_ac;
reg [31:0] apb_addr_ac;
reg [15:0] rddata_ac;
reg [15:0] wrdata_ac;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int j=0; j<2;j++)begin
      inst_addr_ac = j;
      apb_addr_ac = {12'h0,4'h3,inst_addr_ac,12'h88};
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac);
      AcOdtEn[j] = rddata_ac[8:0];
      $display("apb_addr_ac %h, apb read AcOdtEn is %h",apb_addr_ac,rddata_ac);
      if(sel_ac == 2'h0) wrdata_ac = {rddata_ac[15:9],data[j]};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write AcOdtEn is %h",apb_addr_ac,wrdata_ac);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic DxOdtEn_set;
input  [1:0]  sel_dbyte;
input  [10:0] data[8];
output [10:0] DxOdtEn[8];
reg [3:0]  inst_addr_dx;
reg [31:0] apb_addr_dx;
reg [15:0] rddata_dx;
reg [15:0] wrdata_dx;
reg [8:0]  data_dq;
reg        data_dqs;
reg        data_wck;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int i=0; i<8;i++)begin
      {data_wck,data_dqs,data_dq}=data[i];
      inst_addr_dx = i;
      apb_addr_dx = {12'h0,4'h1,inst_addr_dx,12'h97};
      dwc_ddrphy_apb_rd(apb_addr_dx,rddata_dx);
      DxOdtEn[i] = rddata_dx[10:0];
      $display("apb_addr_dx %h, apb read DxOdtEn is %h",apb_addr_dx,rddata_dx);
      if(sel_dbyte == 2'h0)      wrdata_dx = {rddata_dx[15:11],data[i]}; //write OdtEn
      else if(sel_dbyte == 2'h1) wrdata_dx = {rddata_dx[15:9],data_dq}; //write OdtEnDq
      else if(sel_dbyte == 2'h2) wrdata_dx = {rddata_dx[15:10],data_dqs,rddata_dx[8:0]}; //write OdtEnDqs
      else if(sel_dbyte == 2'h3) wrdata_dx = {rddata_dx[15:11],data_wck,rddata_dx[9:0]}; //write OdtEnWck
      dwc_ddrphy_apb_wr(apb_addr_dx,wrdata_dx); 
      $display("apb_addr_dx %h, apb write DxOdtEn is %h",apb_addr_dx,wrdata_dx);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask

task automatic DbyteDynOdtEn_set(bit data=0);
reg [3:0]  inst_addr_ac;
reg [31:0] apb_addr_ac;
reg [15:0] rddata_ac;
reg [15:0] wrdata_ac;
begin
  dwc_ddrphy_apb_wr(32'hd0000,16'h0);
  for(int j=0; j<2;j++)begin
      inst_addr_ac = j;
      apb_addr_ac = {12'h0,4'h3,inst_addr_ac,12'haa};
      dwc_ddrphy_apb_rd(apb_addr_ac,rddata_ac);
      $display("apb_addr_ac %h, apb read DbyteDynOdtEn is %h",apb_addr_ac,rddata_ac);
      wrdata_ac = {rddata_ac[15:9],data};
      dwc_ddrphy_apb_wr(apb_addr_ac,wrdata_ac); 
      $display("apb_addr_ac %h, apb write DbyteDynOdtEn is %h",apb_addr_ac,wrdata_ac);
  end
  dwc_ddrphy_apb_wr(32'hd0000,16'h1);
end
endtask
