#! /usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

my %opts;


GetOptions(\%opts,
          "cfg=s",
          "tphy_dqs2dq=s",
          "test=s", 
          "dram=s",
          "dimm=s",
          "lp4x_mode=s",
          "skip_train=s",
          "disable2d=s",
          "freq0=s",
          "freq1=s",
          "freq2=s",
          "freq3=s",
          "freq_ratio0=s",
          "freq_ratio1=s",
          "freq_ratio2=s",
          "freq_ratio3=s",
          "pll_bypass0=s",
          "pll_bypass1=s",
          "pll_bypass2=s",
          "pll_bypass3=s",
          "rank=s",
          "pstates=s",
          "seqCtrl=s",
          "MRLCalcAdj=s",
          "hdtCtrl=s",
          "dfi_mode=s",
          "rdbi0=s",
          "rdbi1=s",
          "rdbi2=s",
          "rdbi3=s",
          "wdbi0=s",
          "wdbi1=s",
          "wdbi2=s",
          "wdbi3=s",
          "dm0=s",
          "dm1=s",
          "dm2=s",
          "dm3=s",
          "fsp_disable=s",
          "wdqsext=s",
          "wck_free0=s",
          "wck_free1=s",
          "wck_free2=s",
          "wck_free3=s",
          "DisablePmuEcc=s",
          "DisableRetraining=s",
          "emul=s",
          "help"
           ) || HelpUser();

HelpUser() if (defined $opts{help});

#===================================================================================================
sub HelpUser {
#===================================================================================================
  print "
usage:  gen_override_c.pl 
        -cfg=<cfg_name>         : Hardware configuration name, such as: cfg=ac12d9ch1.              
        -tphy_dqs2dq=<delay of PHY_dqs2dq> : should be set 111 for gatesim
        -test=<test_name>       : Test case name. Tests are defined as a directories under the /ctb/tc.  Required argument.
        -dram=<dram tye>        : SDRAM Standard name. Currently, either ddr4 or lpddr4 or none (for ATE testing).
        -dimm=<dimm type>       : DIMM type: udimm, rdimm, lrdimm.
        -lp4x_mode=<0|1>        : Enable/Disable lp4x mode
        -skip_train=<0|1|2>     : 0 - training, 1 - skip training, 2 - devInit.
        -disable2d=<0|1>          : Execute 2d training when training enabled. Default don't execute 2d training
        -freq0=<freq of P0>     : DRAM working frequency of Pstate 0, unit MHz. Default: 800
        -freq1=<freq of P0>     : DRAM working frequency of Pstate 1, unit MHz. Default: 800
        -freq2=<freq of P0>     : DRAM working frequency of Pstate 2, unit MHz. Default: 800
        -freq3=<freq of P0>     : DRAM working frequency of Pstate 3, unit MHz. Default: 800
        -freq_ratio0=<0|1|2>    : Freq ratio of Pstate0, 0 - 1:1, 1 - 1:2, 2 - 1:4. Default: 0 - 1:1
        -freq_ratio1=<0|1|2>    : Freq ratio of Pstate1, 0 - 1:1, 1 - 1:2, 2 - 1:4. Default: 0 - 1:1
        -freq_ratio2=<0|1|2>    : Freq ratio of Pstate2, 0 - 1:1, 1 - 1:2, 2 - 1:4. Default: 0 - 1:1
        -freq_ratio3=<0|1|2>    : Freq ratio of Pstate3, 0 - 1:1, 1 - 1:2, 2 - 1:4. Default: 0 - 1:1        
        -pll_bypass0=<0|1>       : Pclk come from bypass_clk for Pstate0
        -pll_bypass1=<0|1>       : Pclk come from bypass_clk for Pstate1
        -pll_bypass2=<0|1>       : Pclk come from bypass_clk for Pstate2
        -pll_bypass3=<0|1>       : Pclk come from bypass_clk for Pstate3
        -rank=<1|2|4>           : Total rank number in one channel.
        -pstates=<1|2|3|4>      : Total number of PStates.
        -seqCtrl=<SequenceCtrl> : Hex, control which training steps are executed. Default : 1
        -MRLCalcAdj=<MRLCalcAdj> : Decimal, adjust intermediate DFIMRL values . Default : 0
        -hdtCtrl=<HdtCtrl>      : Hex, control the mailbox debug messages verbosity, default : c8
        -dfi_mode=<1|3|5>       : dfi_mode configuration name, only apply to LPDDR, such as: dfi_mode=5
        -rdbi0=<0|1>            : read dbi for Pstate0
        -rdbi1=<0|1>            : read dbi for Pstate1
        -rdbi2=<0|1>            : read dbi for Pstate2
        -rdbi3=<0|1>            : read dbi for Pstate3
        -wdbi0=<0|1>             : write dbi for Pstate0
        -wdbi1=<0|1>             : write dbi for Pstate1
        -wdbi2=<0|1>             : write dbi for Pstate2
        -wdbi3=<0|1>             : write dbi for Pstate3
        -dm0                     : dm value will toggle for Pstate0
        -dm1                     : dm value will toggle for Pstate1
        -dm2                     : dm value will toggle for Pstate2
        -dm3                     : dm value will toggle for Pstate3
        -fsp_disable=<0|1>       : Frequency-Set-Point enable signal. 0 - enable, 1 - disable
        -wdqsext=<0|1>           : Write DQS Extension feature enable signal. 0 -disable, 1 - enable
        -wck_free0=<0|1>         : Set wck running mode: 0 - non free running mode, 1- wck free running mode for Pstate0 
        -wck_free1=<0|1>         : Set wck running mode: 0 - non free running mode, 1- wck free running mode for Pstate1 
        -wck_free2=<0|1>         : Set wck running mode: 0 - non free running mode, 1- wck free running mode for Pstate2 
        -wck_free3=<0|1>         : Set wck running mode: 0 - non free running mode, 1- wck free running mode for Pstate3 
        -help                    : print help message.
        -DisablePmuEcc=<0|1>     : 1,disable Pmu ECC; 0,enable Pmu ECC 
        -DisableRetraining=<0|1> : Disable PHY DRAM Drift compensation re-training: 0 - enable, 1 - disable
";
  exit 1;
}

#-----------------------------------------------------------------------------------------------------
# Copy phyinit to .fw
#-----------------------------------------------------------------------------------------------------
my $phyinit_dir;
if ($ENV{release}==0) {
  $phyinit_dir = "$ENV{CTB_HOME}/../build/c/init" ;
} elsif ($ENV{release}==1) {
  $phyinit_dir = "$ENV{CTB_PHYINIT_DIR}";
} elsif ($ENV{release}==2) {
  $phyinit_dir = "$ENV{CTB_PHYINIT_DIR}";
}

system("rm -rf .fw");
system("mkdir .fw");
system("cp -srf $phyinit_dir/* .fw/");
system("chmod -R 775 .fw");

#-----------------------------------------------------------------------------------------------------
# Generate input file(.result) of postprocess.pl
#-----------------------------------------------------------------------------------------------------
system("rm -f ./.result;");
system("touch ./.result; chmod 775 ./.result");
open(my $FH,'>:encoding(UTF-8)',"./.result")or die "Could not open file '.result"; 

my $head = "set_activity_parameter PHYInitializationsettings";
my $tmp;
my $num_rank   ;
my $num_anib   ;
my $num_dbyte  ;
my $num_ch     ;

# Anib num/DByte num/DFI1 exits
if($opts{cfg} =~ /cs(\d+)ac(\d+)d(\d+)ch(\d+)/){ 
  $num_rank   = $1; 
  $num_anib   = $2; 
  $num_dbyte  = $3; 
  $num_ch     = $4; 

  print $FH "$head userInputBasic_NumRank $num_rank;\n";
  print $FH "$head userInputBasic_NumAnib $num_anib;\n"; 
  print $FH "$head userInputBasic_NumDbyte $num_dbyte;\n";
  $tmp = $num_ch-1;
  print $FH "$head userInputBasic_Dfi1Exists $tmp;\n";
} else {
   die "[gen_override_c: Illegal cfg=$opts{cfg}]";
}

if($num_ch==1){    #ch1
  #if(($num_dbyte > 8) && ($opts{dimm} ne "lrdimm") ) {  #CTB limitaion, ddr4 udimm doesn't support DByte number 9
  #  print $FH "$head userInputBasic_NumActiveDbyteDfi0 8\n";
  #} else{
    print $FH "$head userInputBasic_NumActiveDbyteDfi0 $num_dbyte;\n"
  #}
} else {      #ch2
  $tmp = $num_dbyte/2;
  if($opts{dfi_mode} == 5){ #DFI0 override DFI1
    print $FH "$head userInputBasic_NumActiveDbyteDfi0 $num_dbyte;\n";
  } elsif($opts{dfi_mode} == 1){ #DFI1 disabled
    print $FH "$head userInputBasic_NumActiveDbyteDfi0 $tmp;\n";
  }else{     #dfi_mode=3
    print $FH "$head userInputBasic_NumActiveDbyteDfi0 $tmp;\n";
    print $FH "$head userInputBasic_NumActiveDbyteDfi1 $tmp;\n";
  }
}

# DramDataWidth
if($opts{dram} eq "lpddr4"){
  print $FH "$head userInputBasic_DramDataWidth 16;\n";
} elsif($opts{dram} eq "lpddr3"){
  print $FH "$head userInputBasic_DramDataWidth 32;\n";
} elsif($opts{dimm} eq "lrdimm"){
  print $FH "$head userInputBasic_DramDataWidth 4;\n";
}else{
  print $FH "$head userInputBasic_DramDataWidth 16;\n";
}

# Dram type, Dimm type, Lp4x mode
$tmp = uc($opts{dram}); 
print $FH "$head userInputBasic_DramType $tmp;\n";
$tmp = uc($opts{dimm});
print $FH "$head userInputBasic_DimmType $tmp;\n";
if ($opts{dram} eq "lpddr4"){
  print $FH "$head userInputBasic_Lp4xMode $opts{lp4x_mode};\n";
}

# Rank
print $FH "$head userInputBasic_NumRank_dfi0 $opts{rank};\n";
if($opts{dfi_mode} == 3 && $num_ch ==2){ # DFI1 exists and enabled
  print $FH "$head userInputBasic_NumRank_dfi1 $opts{rank};\n";
} else{
  print $FH "$head userInputBasic_NumRank_dfi1 0;\n";
}

# Pstats number
print $FH "$head userInputBasic_NumPStates $opts{pstates};\n";
if($opts{pstates} == 2){
  print $FH "$head userInputBasic_CfgPStates 3;\n";
  print $FH "$head userInputBasic_FirstPState 1;\n";
} else{
  print $FH "$head userInputBasic_CfgPStates 1;\n";
}

# Frequency
my @freqs = ($opts{freq0}, $opts{freq1}, $opts{freq2}, $opts{freq3});
foreach my $i(0..$opts{pstates}-1){
print $FH "$head userInputBasic_Frequency$i $freqs[$i];\n";
}

# Freq_ratio
my @freq_ratios = ($opts{freq_ratio0}, $opts{freq_ratio1}, $opts{freq_ratio2}, $opts{freq_ratio3});
foreach my $i(0..$opts{pstates}-1){
print $FH "$head userInputBasic_DfiFreqRatio$i $freq_ratios[$i];\n";
}

# PllBypass
my @pll_bypass = ($opts{pll_bypass0}, $opts{pll_bypass1}, $opts{pll_bypass2}, $opts{pll_bypass3});
if ($opts{emul}==1){ 
@pll_bypass = (1,1,1,1)};
foreach my $i(0..$opts{pstates}-1){
 print $FH "$head userInputBasic_PllBypass$i $pll_bypass[$i];\n";
} 

#rdbi
my @rdbi = ($opts{rdbi0}, $opts{rdbi1}, $opts{rdbi2}, $opts{rdbi3});
foreach my $i(0..$opts{pstates}-1){
print $FH "$head userInputBasic_RDBI$i $rdbi[$i];\n";
}

#wdbi
my @wdbi = ($opts{wdbi0}, $opts{wdbi1}, $opts{wdbi2}, $opts{wdbi3});
foreach my $i(0..$opts{pstates}-1){
print $FH "$head userInputBasic_WDBI$i $wdbi[$i];\n";
}

#dm
my @dm = ($opts{dm0}, $opts{dm1}, $opts{dm2}, $opts{dm3});
foreach my $i(0..$opts{pstates}-1){
print $FH "$head userInputBasic_DM$i $dm[$i];\n";
}
#fsp_disable
print $FH "$head userInputBasic_DisableFspOp $opts{fsp_disable};\n";

#wdqsext
print $FH "$head userInputAdvanced_WDQSExt $opts{wdqsext};\n";

# DisablePmuEcc
print $FH "$head userInputAdvanced_DisablePmuEcc $opts{DisablePmuEcc};\n";

#DisableRetraining
print $FH "$head userInputAdvanced_DisableRetraining $opts{DisableRetraining};\n";

#wck mode set
my @wck_frees = ($opts{wck_free0}, $opts{wck_free1}, $opts{wck_free2}, $opts{wck_free3});
foreach my $i(0..$opts{pstates}-1){
print $FH "$head userInputBasic_WckFree$i $wck_frees[$i];\n";
}

#PHY_dqs2dq set
print $FH "$head userInputSim_PHY_tDQS2DQ $opts{tphy_dqs2dq};\n";

# SeqeuencCtrl
print $FH "$head mb_SequenceCtrl $opts{seqCtrl};\n";

# MRLCalcAdj
print $FH "$head mb_MRLCalcAdj $opts{MRLCalcAdj};\n";

# Train2d
print $FH "$head mb_Disable2D $opts{disable2d};\n";

# HdtCtrl
print $FH "$head mb_HdtCtrl $opts{hdtCtrl};\n";

# DfiMode
if($opts{dram} =~ /lpddr/){
  print $FH "$head userInputBasic_DfiMode $opts{dfi_mode};\n";
}  

#OdtImpedanceDqs
my @OdtImpedanceDqs = (60,60,60,60);
foreach my $i(0..$opts{pstates}-1){
  if($opts{emul} == 1){
    @OdtImpedanceDqs = (0,0,0,0);
  }
  print $FH "$head userInputAdvanced_OdtImpedanceDqs$i $OdtImpedanceDqs[$i];\n";
}

#TxImpedanceDq
my @TxImpedanceDq = (60,60,60,60);
foreach my $i(0..$opts{pstates}-1){
  if($opts{emul} == 1){
    @TxImpedanceDq = (30,30,30,30);
  }
  print $FH "$head userInputAdvanced_TxImpedanceDq$i $TxImpedanceDq[$i];\n";
}

#TxImpedanceAc
my @TxImpedanceAc = (60,60,60,60);
foreach my $i(0..$opts{pstates}-1){
  if($opts{emul} == 1){
    @TxImpedanceAc = (30,30,30,30);
  }
  print $FH "$head userInputAdvanced_TxImpedanceAc$i $TxImpedanceAc[$i];\n";

}


#TxImpedanceCs
my @TxImpedanceCs = (60,60,60,60);
foreach my $i(0..$opts{pstates}-1){
  if($opts{emul} == 1){
    @TxImpedanceCs = (30,30,30,30);
  }
  if($opts{dram} eq "lpddr4"){
    print $FH "$head userInputAdvanced_TxImpedanceCs$i $TxImpedanceCs[$i];\n";
  }
}

#TxImpedanceCk
my @TxImpedanceCk = (60,60,60,60);
foreach my $i(0..$opts{pstates}-1){
  if($opts{emul} == 1){
    @TxImpedanceCk = (30,30,30,30);
  }
  print $FH "$head userInputAdvanced_TxImpedanceCk$i $TxImpedanceCk[$i];\n";
}


#TxImpedanceDqs
my @TxImpedanceDqs = (60,60,60,60);
foreach my $i(0..$opts{pstates}-1){
  if($opts{emul} == 1){
    @TxImpedanceDqs = (30,30,30,30);
  }
  print $FH "$head userInputAdvanced_TxImpedanceDqs$i $TxImpedanceDqs[$i];\n";
}


#TxImpedanceWCK
my @TxImpedanceWCK = (60,60,60,60);
foreach my $i(0..$opts{pstates}-1){
  if($opts{emul} == 1){
    @TxImpedanceWCK = (30,30,30,30);
  }
  if($opts{dram} eq "lpddr5"){
    print $FH "$head userInputAdvanced_TxImpedanceWCK$i $TxImpedanceWCK[$i];\n";
  }
}

# csMode
# only apply to RDIMM/LRDIM
# 0: Direct DualCS mode
# 1: Direct QuadCS mode
# 3: Encoded QuadCS mode
if($opts{dimm} eq "rdimm" || $opts{dimm} eq "lrdimm") {
  if($opts{rank} <3) {
    print $FH "$head csMode 0";
  } else{
    print $FH "$head csMode 1";
  }
}



close $FH;

