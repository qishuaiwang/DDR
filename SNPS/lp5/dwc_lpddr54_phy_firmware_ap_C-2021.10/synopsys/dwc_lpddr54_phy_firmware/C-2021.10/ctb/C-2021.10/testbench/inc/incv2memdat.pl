#! /usr/bin/perl


############################################################################################################################################
#
#this tools is to change the imem.incv and dmem.incv into imemdat.dat and dmemdat.dat which used to be loaded into the iccm and dccm  by $readmemh
#
############################################################################################################################################


# Help information
# -f filename : input filename.incv
# -o filename1 : output filename1.dat 
# -ecc :  generate the ecc bits for sram, default off
# -h : help infomation
# -type :
# -iccm : 
#

sub Help{
 
  print " 
# -f filename  : input filename.incv
# -o filename1 : output filename1.dat 
# -ecc         :  generate the ecc bits for sram,not support now 
# -type [0/1/2]: 0 default, 1 apb_wr format, 2 text format
# -iccm        : iccm mode
# -h           : help infomation
  \n";


}

# parse the command 
my $inFileName;
my $outFileName;
my $ECC = 0;
my $type = 0;
my $iccm = 0;
my $dccm_cnt = 0;


sub ParseCmd{
  my (@args) = @ARGV;
  my $cmd = "";

  while (@args){
     $cmd = shift @args;
     if ($cmd eq "-f")
     {
        $inFileName = shift @args;
     }
     elsif ($cmd eq "-o"){
        $outFileName = shift @args;
     }
     elsif ($cmd eq "-ecc"){
        $ECC = 1 ;
     }
     elsif ($cmd eq "-type"){
        $type = shift @args;
     }
     elsif ($cmd eq "-iccm"){
        $iccm = 1;
     }
     elsif ($cmd eq "-h"){
        Help();
        exit 0;
     }
     else {
        print "Unsupport command option, please use -h for help\n";
        exit 0;
     }
  }
}

# type 0 , default format , address data
# type 1 , apb_wr format  , apb_wr(32'h5800d, 16'h0000);;
# type 2,  txt format ,grap the dmem apb write and dwc_ddrphy_apb_wr(32'h58000,16'h600);

my @memdat;

sub GenMemDat{
  
  if ($type == 0){
  # type 0
  #read dat from incv file
  open InFile, "<$inFileName" or die "can not open the input file $inFileName\n";
  
  while(<InFile>){
  
    #remove the address colum 
  
    #my ($add, $dat) = split /\s/,$_; 
    my ($add, $dat) = split /\s/ ; 
    #DEBUG print "$add - $dat\n";
   
    #remove the 0x prefix
    $dat =~ s/0x//;
    
    push @memdat,$dat;
  
    #DEBUG 
    #print "$dat\n"; 
  }
  
  CreateMemData("");
  close InFile;
  }
  elsif ($type == 1){
  # type 1 apb_wr(32'h5800d, 16'h0000);
  # read dat from incv file
  open InFile, "<$inFileName" or die "can not open the input file $inFileName\n";
  
  while(<InFile>){
  
    #remove the apb_wr  
    s/apb_wr//g;

    #remove the '(',')',',',';'
    s/\(|\)|\;//g; 

    #remove the address colum 
  
    #my ($add, $dat) = split /\s/,$_; 
    my ($add, $dat) = split /,/ ; 
    #DEBUG print "$add - $dat\n";
   
    #remove the 16'h prefix
    $dat =~ s/16'h//;
    #remove the /\s+/
    $dat =~ s/\s+//g;
    
    push @memdat,$dat;
  
    #DEBUG 
    #print "$dat\n"; 
  }
  
  CreateMemData("");
  close InFile;

  } elsif ($type == 2){
  # type 2,  txt format ,grap the dmem apb write and dwc_ddrphy_apb_wr(32'h58000,16'h600);
  # read dat from text file
  open InFile, "<$inFileName" or die "can not open the input file $inFileName\n";
   
  my $DmemStart = 0;
  my $DmemDone = 0 ;

  #my @dmem_dwc_apbwr;
  
  while(<InFile>){

    if($iccm == 1) {
      # grap the data segment, iccm can use the same flag as dccm
      if( /dwc_ddrphy_phyinit_WriteOutMem.*0x50000/ ) {
        $DmemStart = 1 ;
        $DmemDone = 0 ;
      }
      if ( /dwc_ddrphy_phyinit_WriteOutMem.*DONE/) {
        if(($DmemStart == 1) && ($DmemDone == 0)) { CreateMemData("");}
        $DmemDone = 1 ;
        #after use the @memdat, clear it
        @memdat = ();
      }
    } 
    else {

      # grap the data segment
      if( /dwc_ddrphy_phyinit_WriteOutMem.*0x58000/ ) {
        $DmemStart = 1 ;
        $DmemDone = 0 ;
        $dccm_cnt = $dccm_cnt + 1 ;
      }
      if ( /dwc_ddrphy_phyinit_WriteOutMem.*DONE/) {
        if(($DmemStart == 1) && ($DmemDone == 0)) { CreateMemData($dccm_cnt); }
        $DmemDone = 1 ;
        @memdat = ();
      }
    }

    if(($DmemStart == 1) && ($DmemDone == 0)) {
      if(/dwc_ddrphy_apb_wr/) {
        #remove the  dwc_ddrphy_apb_wr
        s/dwc_ddrphy_apb_wr//g;

        #remove the '(',')',',',';'
        s/\(|\)|\;//g; 

        #remove the address colum 
  
        #my ($add, $dat) = split /\s/,$_; 
        my ($add, $dat) = split /,/ ; 
        #DEBUG print "$add - $dat\n";
   
        #change the 16'h prefix to 0x format
        $dat =~ s/16'h//;
        # format the output ,string has /0 as the end of string 
        $dat = sprintf "%05s",$dat;

        # remove the 0x
        #$dat =~ s/0x//;

        #remove the /\s+/
        $dat =~ s/\s+//g;
        
        push @memdat,$dat;
  
        #DEBUG 
        #print "$dat\n"; 

      }
    }
  }
  
  close InFile;
  }
}
  #current issue for more than 1 pstate
  # put follow code in to a task and 

sub CreateMemData { 
  my $dccm_cnt = shift ; 
  #change 16 bit dat into 32 bit
  my $cnt = 0;
  my $predat ;
  
  my @outmemdat;
  
  foreach (@memdat){
    
    if($cnt == 0){
      $predat = $_;
    }
    else
    {
      push @outmemdat,"$_"."$predat";
    }
    $cnt = !$cnt;
  }
  
  #if the last address[0] is 0, add 0000
  if($cnt == 1){
    push @outmemdat,"0000".$predat;
  
  }
  
  #DEBUG
  #foreach (@outmemdat){
  #  print $_."\n";
  #}
  

  # ADD ECC bit , default 00
  # $ECC == 1
  
  
  open OutFile, ">$outFileName"."$dccm_cnt".".txt" or die "can not open outfile $outFileName\n";
  
  if($ECC == 1){
    my $ecc_bit;
    my $addr_cnt = 0 ;
    foreach (@outmemdat) {
      $ecc_bit = GenEcc($addr_cnt,$_);
      print  OutFile "$ecc_bit"."$_\n"; 
      $addr_cnt++;
    }
    #print "not support currently\n";
  }
  else {
    foreach (@outmemdat) {
  
    print OutFile "00"."$_\n";
    }
  }
  
  close OutFile;

}

#add to generate the iccm/dccm ecc bit from data and address
sub GenEcc {
  #
  #my $addr_width = shift;#D54 ,iccm/dccm 15
  #before use it, to check the iccm/dccm address width in different project
  my $addr_width = 15;#lp54 ,iccm/dccm 15
  my $addr = shift;
  my $data = shift;
  my $i;#index for loop

  #16 to 2 for addr
  #31 to 0 for data
 
  #change hex to binary 
  #my $addr_temp = hex($addr);
  my $addr_temp = $addr;
  my $data_temp = hex($data);

  my @addr_array; 
  my @data_array;


  $addr_array[0] = 0;
  $addr_array[1] = 0;
  for($i=2;$i<17;$i++){
    $addr_array[$i] = $addr_temp & 0x1 ;
    $addr_temp = $addr_temp>>1;
  }

  for($i=0;$i<32;$i++){
    $data_array[$i] =  $data_temp & 0x1 ;
    $data_temp = $data_temp>>1;
  }

  my @addr_ecc;
  #Generate PMU ECC address bit 0
  $addr_ecc[0] = $addr_array[2] ^ $addr_array[4];
  for($i=6;$i<($addr_width + 2);$i=$i+2){
    $addr_ecc[0] = $addr_ecc[0] ^ $addr_array[$i];
  } 

  #Generate PMU ECC address bit 1
  $addr_ecc[1] = $addr_array[2] ^ $addr_array[5];
  for($i=6;$i<($addr_width + 2);$i=$i+1){
    if ( ($i==6)  || ($i==9)  || ($i==10) || ($i==13) || 
    ($i==14) || ($i==17) || ($i==18) ){
      $addr_ecc[1] = $addr_ecc[1] ^ $addr_array[$i];
    } 
  }

  #Generate PMU ECC address bit 2
  $addr_ecc[2] = $addr_array[2] ^ $addr_array[7];
  for($i=8;$i<($addr_width + 2);$i=$i+1){
    if ( ($i==8)  || ($i==9)  || ($i==10) || ($i==15) || 
    ($i==16) || ($i==17) || ($i==18) ) {
      $addr_ecc[2] = $addr_ecc[2] ^ $addr_array[$i];
    }
  }


  #Generate PMU ECC address bit 3
  $addr_ecc[3] = $addr_array[3] ^ $addr_array[4];
  for($i=5;$i<($addr_width + 2);$i=$i+1){
      if ( ($i==5)  || ($i==6)  || ($i==7)  || ($i==8)  || 
      ($i==9)  || ($i==10) || ($i==19) || ($i==20) ){
        $addr_ecc[3] = $addr_ecc[3] ^ $addr_array[$i];
      }
  }

  #Generate PMU ECC address bit 4
  $addr_ecc[4] = 0;
  if($addr_width>9){
    for($i=11;$i<($addr_width + 2);$i=$i+1){
      if($i==11){
        $addr_ecc[4] = $addr_array[$i];
      }
      elsif (($i==12)  || ($i==13) || ($i==14) || ($i==15) || 
      ($i==16)  || ($i==17) || ($i==18) || ($i==19) || 
      ($i==20)){
        $addr_ecc[4] = $addr_ecc[4] ^ $addr_array[$i];
      }
    }
  }

  #Generate PMU ECC address bit 5
  $addr_ecc[5] = $addr_array[2] ^ $addr_array[3];
  for($i=4;$i<($addr_width + 2);$i=$i+1){
    $addr_ecc[5] = $addr_ecc[5] ^ $addr_array[$i];
  }

  my @ecc_code ;

  $ecc_code[0] = $data_array[0]  ^ $data_array[1]  ^ $data_array[3]  ^ $data_array[4]  ^  $data_array[6] ^  
  $data_array[8]  ^ $data_array[10] ^ $data_array[11] ^ $data_array[13] ^ $data_array[15] ^ 
  $data_array[17] ^ $data_array[19] ^ $data_array[21] ^ $data_array[23] ^ $data_array[25] ^ 
  $data_array[26] ^ $data_array[28] ^ $data_array[30] ^ $addr_ecc[0];

  $ecc_code[1] = $data_array[0]  ^ $data_array[2]  ^ $data_array[3]  ^ $data_array[5]  ^ $data_array[6]  ^ 
  $data_array[9]  ^ $data_array[10] ^ $data_array[12] ^ $data_array[13] ^ $data_array[16] ^ 
  $data_array[17] ^ $data_array[20] ^ $data_array[21] ^ $data_array[24] ^ $data_array[25] ^ 
  $data_array[27] ^ $data_array[28] ^ $data_array[31] ^ $addr_ecc[1];
  

  $ecc_code[2] = $data_array[1]  ^ $data_array[2]  ^ $data_array[3]  ^ $data_array[7]  ^ $data_array[8]  ^ 
  $data_array[9]  ^ $data_array[10] ^ $data_array[14] ^ $data_array[15] ^ $data_array[16] ^ 
  $data_array[17] ^ $data_array[22] ^ $data_array[23] ^ $data_array[24] ^ $data_array[25] ^ 
  $data_array[29] ^ $data_array[30] ^ $data_array[31] ^ $addr_ecc[2];


  $ecc_code[3] = $data_array[4]  ^ $data_array[5]  ^ $data_array[6]  ^ $data_array[7]  ^ $data_array[8]  ^ 
  $data_array[9]  ^ $data_array[10] ^ $data_array[18] ^ $data_array[19] ^ $data_array[20] ^ 
  $data_array[21] ^ $data_array[22] ^ $data_array[23] ^ $data_array[24] ^ $data_array[25] ^
  $addr_ecc[3];

  if($addr_width>9){
    $ecc_code[4] = $data_array[11] ^ $data_array[12] ^ $data_array[13] ^ $data_array[14] ^ $data_array[15] ^ 
    $data_array[16] ^ $data_array[17] ^ $data_array[18] ^ $data_array[19] ^ $data_array[20] ^ 
    $data_array[21] ^ $data_array[22] ^ $data_array[23] ^ $data_array[24] ^ $data_array[25] ^
    $addr_ecc[4];
  } else{
    $ecc_code[4] = $data_array[11] ^ $data_array[12] ^ $data_array[13] ^ $data_array[14] ^ $data_array[15] ^ 
    $data_array[16] ^ $data_array[17] ^ $data_array[18] ^ $data_array[19] ^ $data_array[20] ^ 
    $data_array[21] ^ $data_array[22] ^ $data_array[23] ^ $data_array[24] ^ $data_array[25];
  }

  $ecc_code[5] = $data_array[26] ^ $data_array[27] ^ $data_array[28] ^ $data_array[29] ^ $data_array[30] ^ 
  $data_array[31] ^ $addr_ecc[5];            
  
  # Final bit of the ecc code contains the overall parity bit of the 32-bit word. 
  # This allows us to be able to detect double bit errors.

  $ecc_code[6] = $data_array[0]  ^ $data_array[1]  ^ $data_array[2]  ^ $data_array[3]  ^ $data_array[4]  ^ 
  $data_array[5]  ^ $data_array[6]  ^ $data_array[7]  ^ $data_array[8]  ^ $data_array[9]  ^ 
  $data_array[10] ^ $data_array[11] ^ $data_array[12] ^ $data_array[13] ^ $data_array[14] ^ 
  $data_array[15] ^ $data_array[16] ^ $data_array[17] ^ $data_array[18] ^ $data_array[19] ^ 
  $data_array[20] ^ $data_array[21] ^ $data_array[22] ^ $data_array[23] ^ $data_array[24] ^ 
  $data_array[25] ^ $data_array[26] ^ $data_array[27] ^ $data_array[28] ^ $data_array[29] ^ 
  $data_array[30] ^ $data_array[31] ^ 
  $ecc_code[0] ^ $ecc_code[1] ^ $ecc_code[2] ^ 
  $ecc_code[3] ^ $ecc_code[4] ^ $ecc_code[5]; 

  #include the ADDR
  for($i=2;$i<($addr_width + 2);$i=$i+1){
    $ecc_code[6] = $ecc_code[6] ^ $addr_array[$i];
  }
  
  #binary to decimal
  my $ecc_code_deci = 0;
  for($i=0;$i<7;$i++){
    if($ecc_code[$i] == 1){
      $ecc_code_deci = $ecc_code_deci + (1<<$i);
    }
  }
 
  #decimal to hex
  my $ecc_code_hex = sprintf("%02x",$ecc_code_deci);
  return $ecc_code_hex;

} 



# parse the cmd and generate the dat file 

ParseCmd();
GenMemDat();
