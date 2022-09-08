`ifndef SVT_DFI


`timescale 1ps/1ps
module dfi_data_drv
#(
parameter pDFI_CS_WIDTH=2
,         pDFI_WRDATA_WIDTH=48
,         pDFI_WRDATA_CS_WIDTH=6
,         pDFI_RDDATA_CS_WIDTH=6
,         pDFI_WRDATA_EN_WIDTH=3
,         pDFI_WRDATA_MASK_WIDTH=6
,         pDFI_RDDATA_EN_WIDTH=3
,         pDFI_RDDATA_VALID_WIDTH=3
,         pDFI_RDDATA_DBI_WIDTH=6
,         pDFI_RDDATA_WIDTH=48
)
(
input clk,

output  reg [pDFI_WRDATA_WIDTH-1:0]   dfi_wrdata_P0, dfi_wrdata_P1, dfi_wrdata_P2, dfi_wrdata_P3,
output  reg [pDFI_WRDATA_CS_WIDTH-1:0]   dfi_wrdata_cs_P0, dfi_wrdata_cs_P1, dfi_wrdata_cs_P2, dfi_wrdata_cs_P3,
output  reg [pDFI_RDDATA_CS_WIDTH-1:0]   dfi_rddata_cs_P0, dfi_rddata_cs_P1, dfi_rddata_cs_P2, dfi_rddata_cs_P3,
output  reg [pDFI_WRDATA_EN_WIDTH-1:0]     dfi_wrdata_en_P0,  dfi_wrdata_en_P1,  dfi_wrdata_en_P2, dfi_wrdata_en_P3,
output  reg [pDFI_WRDATA_MASK_WIDTH-1:0]   dfi_wrdata_mask_P0, dfi_wrdata_mask_P1, dfi_wrdata_mask_P2, dfi_wrdata_mask_P3,
output  reg [pDFI_RDDATA_EN_WIDTH-1:0]     dfi_rddata_en_P0, dfi_rddata_en_P1, dfi_rddata_en_P2, dfi_rddata_en_P3,
input       [pDFI_RDDATA_VALID_WIDTH-1:0]     dfi_rddata_valid_W0, dfi_rddata_valid_W1, dfi_rddata_valid_W2, dfi_rddata_valid_W3,
input       [pDFI_RDDATA_DBI_WIDTH-1:0]   dfi_rddata_dbi_W0, dfi_rddata_dbi_W1, dfi_rddata_dbi_W2, dfi_rddata_dbi_W3,
input       [pDFI_RDDATA_WIDTH-1:0]  dfi_rddata_W0, dfi_rddata_W1, dfi_rddata_W2, dfi_rddata_W3

);


bit                                 wrdata_en_q[$];
bit [16*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL-1:0] wrdata_q[$];
bit                                 rddata_en_q[$];
bit [pDFI_WRDATA_CS_WIDTH - 1:0]           wrdata_cs_q[$];
bit [pDFI_RDDATA_CS_WIDTH - 1:0]           rddata_cs_q[$];


// data register
// value of this reg may be changed from the test case
// -----------------------------------------------------
reg [8*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL-1:0] data[17000:0];
initial begin
  for (int i=0; i<17000; i++) begin
   `ifdef DDRPHY_POWERSIM
      if(i%2)
        `ifdef DDR4_STD
        data[i] = 64'haaffaaffaaffaaff;
        `else
        data[i] = 128'haaffffaaaaffffaaaaffffaaaaffffaa;
        `endif
      else
        `ifdef DDR4_STD
        data[i] = 64'h5500550055005500;
        `else
        data[i] = 128'h55000055550000555500005555000055;
        `endif
   `else
      data[i] = i+1;
   `endif
  end
end

// Error flag: if read data not equal to write data, 
// the rror flag is set to 1
// -----------------------------------------------------
reg error = 0;
//reg disable_data_compare =0;

`ifdef WRITE_DM
 reg disable_data_compare = 1;
`elsif READ_DBI
 reg disable_data_compare = 1;
`else
 reg disable_data_compare =0;
`endif

initial begin
  {dfi_wrdata_P0,dfi_wrdata_P1,dfi_wrdata_P2,dfi_wrdata_P3} = 'b0;
  {dfi_wrdata_cs_P0,dfi_wrdata_cs_P1,dfi_wrdata_cs_P2,dfi_wrdata_cs_P3} = {4*pDFI_WRDATA_CS_WIDTH{1'b0}};
  {dfi_rddata_cs_P0,dfi_rddata_cs_P1,dfi_rddata_cs_P2,dfi_rddata_cs_P3} = {4*pDFI_WRDATA_CS_WIDTH{1'b0}};  
  {dfi_wrdata_en_P0,dfi_wrdata_en_P1,dfi_wrdata_en_P2,dfi_wrdata_en_P3} = 'b0;
  {dfi_wrdata_mask_P0,dfi_wrdata_mask_P1,dfi_wrdata_mask_P2,dfi_wrdata_mask_P3} = 'b0;
  {dfi_rddata_en_P0, dfi_rddata_en_P1, dfi_rddata_en_P2, dfi_rddata_en_P3} = 'b0;
end

reg [`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL-1:0] active_dbyte;
reg [`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL-1:0] active_cs;
initial begin
   active_dbyte = 0;
   active_cs  = 0;
   if(cfg.NumActiveDbyteDfi1 == 0) begin
     //active_dbyte = {{(`DWC_DDRPHY_NUM_DBYTES-cfg.NumActiveDbyteDfi0){1'b0}}, {cfg.NumActiveDbyteDfi0{1'b1}}};
     for(int i=0; i<cfg.NumActiveDbyteDfi0; i++) active_dbyte[i] = 1'b1;
   end
   else begin
     //active_dbyte = {{(`DWC_DDRPHY_NUM_DBYTES/2 - cfg.NumActiveDbyteDfi1){1'b0}},{cfg.NumActiveDbyteDfi1{1'b1}},{(`DWC_DDRPHY_NUM_DBYTES/2 - cfg.NumActiveDbyteDfi0){1'b0}},{cfg.NumActiveDbyteDfi0{1'b1}}}; 
     for(int i=0; i<cfg.NumActiveDbyteDfi0; i++) active_dbyte[i] = 1'b1;
     for(int i=(`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL/2); i<((`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL/2)+cfg.NumActiveDbyteDfi1); i++) active_dbyte[i] = 1'b1;
   end

   for(int i=0; i<`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL; i++)begin
     if(active_dbyte[i]==0)
       active_cs[((pDFI_WRDATA_CS_WIDTH/`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)*i )+:pDFI_WRDATA_CS_WIDTH/`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL] = {(pDFI_WRDATA_CS_WIDTH/`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL/*-1*/){1'b0}};
       //active_cs[(cs_per_byte*i )+:2] = {(cs_per_byte-1){1'b0}};  
     else 
       active_cs[((pDFI_WRDATA_CS_WIDTH/`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL)*i)+:pDFI_WRDATA_CS_WIDTH/`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL] = {(pDFI_WRDATA_CS_WIDTH/`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL/*-1*/){1'b1}};
   end
end

task drive_wrdata_en();
forever begin
  @(posedge clk);
  {dfi_wrdata_en_P0,dfi_wrdata_en_P1,dfi_wrdata_en_P2,dfi_wrdata_en_P3} = 'b0;
  {dfi_wrdata_cs_P0,dfi_wrdata_cs_P1,dfi_wrdata_cs_P2,dfi_wrdata_cs_P3} = {4*pDFI_WRDATA_CS_WIDTH{1'b0}};
  if(wrdata_en_q.size()) begin
    bit wrdata_en ;
    bit [pDFI_CS_WIDTH-1:0] rank ;
    wrdata_en = wrdata_en_q.pop_front();
    rank = wrdata_cs_q.pop_front();
    dfi_wrdata_en_P0 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{wrdata_en}};
    dfi_wrdata_cs_P0 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}};
    if(wrdata_en_q.size() && cfg.DfiFreqRatio[cfg.PState] >0) begin
      wrdata_en = wrdata_en_q.pop_front();
      rank = wrdata_cs_q.pop_front();
      dfi_wrdata_en_P1 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{wrdata_en}};
      dfi_wrdata_cs_P1 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}}; 
      if(wrdata_en_q.size() && cfg.DfiFreqRatio[cfg.PState] >1) begin
        wrdata_en = wrdata_en_q.pop_front();
        rank = wrdata_cs_q.pop_front();
        dfi_wrdata_en_P2 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{wrdata_en}};
        dfi_wrdata_cs_P2 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}};      
        if(wrdata_en_q.size()) begin
          wrdata_en = wrdata_en_q.pop_front();
          rank = wrdata_cs_q.pop_front();
          dfi_wrdata_en_P3 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{wrdata_en}};
          dfi_wrdata_cs_P3 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}};   
        end
      end
    end
  end
end
endtask : drive_wrdata_en

task drive_wrdata();
forever begin
  @(posedge clk);
  {dfi_wrdata_P0,dfi_wrdata_P1,dfi_wrdata_P2,dfi_wrdata_P3} = 'b0;
  if(wrdata_q.size()) begin
    dfi_wrdata_P0 = wrdata_q.pop_front;
    `ifdef WRITE_DM
    dfi_wrdata_mask_P0 = dfi_wrdata_P0;
    `endif
    if(wrdata_q.size() && cfg.DfiFreqRatio[cfg.PState] >0) begin
      dfi_wrdata_P1 = wrdata_q.pop_front;
      `ifdef WRITE_DM
      dfi_wrdata_mask_P1 = dfi_wrdata_P1;
      `endif
      if(wrdata_q.size() && cfg.DfiFreqRatio[cfg.PState] >1) begin
        dfi_wrdata_P2 = wrdata_q.pop_front;
        `ifdef WRITE_DM
        dfi_wrdata_mask_P2 = dfi_wrdata_P2;
        `endif
        if(wrdata_q.size()) begin
          dfi_wrdata_P3 = wrdata_q.pop_front;
          `ifdef WRITE_DM
          dfi_wrdata_mask_P3 = dfi_wrdata_P3;
          `endif
        end
      end
    end
  end
end
endtask : drive_wrdata

task drive_rddata_en();
forever begin
  @(posedge clk);
  {dfi_rddata_en_P0, dfi_rddata_en_P1, dfi_rddata_en_P2, dfi_rddata_en_P3} = 'b0;
  {dfi_rddata_cs_P0,dfi_rddata_cs_P1,dfi_rddata_cs_P2,dfi_rddata_cs_P3} = {4*pDFI_RDDATA_CS_WIDTH{1'b0}};
  if(rddata_en_q.size()) begin
    bit rddata_en ;
    bit [pDFI_CS_WIDTH-1:0] rank ;
    rddata_en = rddata_en_q.pop_front();
    rank = rddata_cs_q.pop_front();
    dfi_rddata_en_P0 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rddata_en}} & active_dbyte;
    dfi_rddata_cs_P0 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}};
    if(rddata_en_q.size() && cfg.DfiFreqRatio[cfg.PState] >0) begin
      rddata_en = rddata_en_q.pop_front();
      rank = rddata_cs_q.pop_front();
      dfi_rddata_en_P1 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rddata_en}} & active_dbyte;
      dfi_rddata_cs_P1 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}}; 
      if(rddata_en_q.size() && cfg.DfiFreqRatio[cfg.PState] >1) begin
        rddata_en = rddata_en_q.pop_front();
        rank = rddata_cs_q.pop_front();
        dfi_rddata_en_P2 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rddata_en}} & active_dbyte;
        dfi_rddata_cs_P2 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}};      
        if(rddata_en_q.size()) begin
          rddata_en = rddata_en_q.pop_front();
          rank = rddata_cs_q.pop_front();
          dfi_rddata_en_P3 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rddata_en}} & active_dbyte;
          dfi_rddata_cs_P3 = {`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL{rank}};   
        end
      end
    end
  end
end
endtask : drive_rddata_en

task get_rddata();
int flag = 0;
int index = 0;
reg [8*`DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL-1:0] rddata[17000:0];
forever begin
  @(negedge clk);
  if(dfi_rddata_valid_W0) begin
    {rddata[index + 1],rddata[index]} = dfi_rddata_W0;
    index = index + 2;
    flag = 1;
  end else begin
    if (flag == 1 && (!disable_data_compare)) begin
      for(int i =0; i< index; i++) begin
        //rddata[i] = rddata[i] << (8*(cfg.NumDbyte - cfg.NumActiveDbyteDfi0 - cfg.NumActiveDbyteDfi1)) >> (8*(cfg.NumDbyte - cfg.NumActiveDbyteDfi0 - cfg.NumActiveDbyteDfi1));
        if (rddata[i] !== data[i]) begin
          error = 1;
          $display("<%m>,Mismatch rddata[%0d]=%h, @ %0t",i,rddata[i], $time);
        end else begin
          $display("<%m>,Match rddata[%0d]=%h, @ %0t",i,rddata[i], $time);
        end
      end
      flag = 0;
      index = 0;
    end
  end
  if(cfg.DfiFreqRatio[cfg.PState] > 0) begin
    if (dfi_rddata_valid_W1) begin
      {rddata[index + 1],rddata[index]} = dfi_rddata_W1;
      index = index + 2;
    end
    if(cfg.DfiFreqRatio[cfg.PState] > 1) begin
      if(dfi_rddata_valid_W2) begin
        {rddata[index + 1],rddata[index]} = dfi_rddata_W2;
        index = index + 2;
        {rddata[index + 1],rddata[index]} = dfi_rddata_W3;
        index = index + 2;
      end   
    end
  end
end   
endtask : get_rddata

initial begin
  fork
    drive_wrdata_en();
    drive_wrdata();
    drive_rddata_en();
    get_rddata();
  join
end

endmodule

`endif
