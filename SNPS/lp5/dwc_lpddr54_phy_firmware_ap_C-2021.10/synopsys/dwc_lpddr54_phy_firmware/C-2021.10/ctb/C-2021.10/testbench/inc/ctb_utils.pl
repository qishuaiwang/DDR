#!/usr/bin/perl

use strict;
use warnings;
#use Switch;

my @CL;
my @CWL;

my $numpstate=1;
my $numpstate_tmp;
my @freq;
my @freq_ratio;
my $cust_override_c;
my $test;
my $protocol;
my $NumDbyte;
my $NumAnib ;
my $ch      ;
my $NumDbytesPerCh;
my $NumCh;
my $NumActiveDbyteDfi0;
my $NumActiveDbyteDfi1;
my $NumRank_dfi0;
my $NumRank_dfi1;
my $default_c;
my @mr0;
my @mr1;
my @mr2;
my @mr3;
my @mr4;
my @mr5;
my @mr6;
my @mr10;
my @mr16;
my @mr18;
my @mr19;
my @mr20;
my @mr13;
my @mr22;
my @f0RC0A_D0;
my @f0RC3x_D0;
my @f0RC0D_D0;
my @f0RC0F_D0;
my $Lp4xMode;
my $HardMacroVer;

my $Train2D;
my @PllBypass;
my $Dfi1Exists;
my $DfiMode;
my @ReadDBIEnable;
my $DramDataWidth;

my $DramByteSwap;
my @DisDynAdrTri;
my @Is2Ttiming;
my @D4RxPreambleLength;
my @D4TxPreambleLength;
my $WDQSExt;
my $RxEnBackOff;
#my @Lp4RxPreambleMode;
my @Lp4PostambleExt;
my @Lp4DbiRd;
my @Lp4DbiWr;
my @Lp4WLS;

my $CsPresent;
my $AddrMirror;
my $EnabledDQs;
my $CsSetupGDDec;
my @ALT_CAS_L;
my @ALT_WCAS_L;
my $UseBroadcastMR;
my $X8Mode;
my $FirstPState;
my $DisableFspOp;

my @tWCKPRE_WFR;
my @tWCKPRE_RFR;
my @tWCKENL_FS;
my @tWCKPRE_Static;
my @tWCKPRE_toggle_RD;
my @tWCKPRE_toggle_WR;
my @tWCKPRE_total_WR;
my @tWCKPRE_total_RD;

my $row_tmp;
my @arry;
my $row;
my $i;
my $DramType;
my $DimmType;

#Configuration for CTB only
my $TestsToRun;

&load_command_line();### Assign the ARGV values

$TestsToRun=&str2val($TestsToRun);
$TestsToRun=sprintf("16'h%04x", $TestsToRun);

$test=~s/^\s+|\s+$//g;

chomp(my $cur_dir = `pwd`);
my $setDefault_path = "$cur_dir/.fw/$protocol/userCustom/dwc_ddrphy_phyinit_setDefault.c";
my $tc_override_c="$ENV{CTB_HOME}/testbench/tc/$test/dwc_ddrphy_phyinit_userCustom_overrideUserInput.c";


###### Main ######
if($default_c==1)                # use default c files
{
  if($protocol ne "none"){&get_c_params($setDefault_path);}
  &gen_ctb_params(); 
}
else{ 
  if($cust_override_c eq "undefined") # use tc/override_c
  {
    if($protocol ne "none"){&get_c_params($setDefault_path);}
    &get_c_params($tc_override_c);
    &gen_ctb_params();
  }
  else                           # use specified override_c
  {
    if($protocol ne "none"){&get_c_params($setDefault_path);}
    &get_c_params($cust_override_c);
    &gen_ctb_params(); 
  }
}
if($ENV{release} == 1) {
  &gen_release_flist();
}
###### Set command line parameters ########
sub load_command_line{
 $cust_override_c=$ARGV[0];
 $test=$ARGV[1];
 $default_c=$ARGV[2]; 
 $protocol=$ARGV[3];
 $TestsToRun=$ARGV[4];
}

###### Get value from setDefault.c/override_c ######
sub get_c_params{
die "<ctb_utils> ERROR: Can't find $_[0]" unless(-e $_[0]);
@arry=`cat $_[0]`;
  foreach $row(@arry)
 { 
    if(!($row=~/^(\s*|\t*)\/\//))#whithout comment line
    {
        #print "row:$row";
        if($row=~/DramType\s*=.*;/){$DramType=$row;$DramType=~s/(.*)=(.*);(.*)/$2/g;$DramType=~s/^\s+|\s+$//g;}
        elsif($row=~/DimmType\s*=.*;/){$DimmType=$row;$DimmType=~s/(.*)=(.*);(.*)/$2/g;$DimmType=~s/^\s+|\s+$//g;}
        elsif($row=~/NumPStates\s*=.*;/){$numpstate=$row;$numpstate=~s/(.*)=(.*);(.*)/$2/g;$numpstate=~s/^\s+|\s+$//g;$numpstate=&str2val($numpstate);} 
        elsif($row=~/Frequency\[0\]\s*=.*;/){$freq[0]=$row;$freq[0]=~s/(.*)=(.*);(.*)/$2/g;$freq[0]=~s/^\s+|\s+$//g;$freq[0]=&str2val($freq[0]);}
        elsif($row=~/Frequency\[1\]\s*=.*;/){$freq[1]=$row;$freq[1]=~s/(.*)=(.*);(.*)/$2/g;$freq[1]=~s/^\s+|\s+$//g;$freq[1]=&str2val($freq[1]);}
        elsif($row=~/Frequency\[2\]\s*=.*;/){$freq[2]=$row;$freq[2]=~s/(.*)=(.*);(.*)/$2/g;$freq[2]=~s/^\s+|\s+$//g;$freq[2]=&str2val($freq[2]);}
        elsif($row=~/Frequency\[3\]\s*=.*;/){$freq[3]=$row;$freq[3]=~s/(.*)=(.*);(.*)/$2/g;$freq[3]=~s/^\s+|\s+$//g;$freq[3]=&str2val($freq[3]);}
        elsif($row=~/mr0\[0\]\s*=.*;/){$mr0[0]=$row;$mr0[0]=~s/(.*)=(.*);(.*)/$2/g;$mr0[0]=~s/^\s+|\s+$//g;$mr0[0]=&str2val($mr0[0]);}
        elsif($row=~/mr0\[1\]\s*=.*;/){$mr0[1]=$row;$mr0[1]=~s/(.*)=(.*);(.*)/$2/g;$mr0[1]=~s/^\s+|\s+$//g;$mr0[1]=&str2val($mr0[1]);}
        elsif($row=~/mr0\[2\]\s*=.*;/){$mr0[2]=$row;$mr0[2]=~s/(.*)=(.*);(.*)/$2/g;$mr0[2]=~s/^\s+|\s+$//g;$mr0[2]=&str2val($mr0[2]);}
        elsif($row=~/mr0\[3\]\s*=.*;/){$mr0[3]=$row;$mr0[3]=~s/(.*)=(.*);(.*)/$2/g;$mr0[3]=~s/^\s+|\s+$//g;$mr0[3]=&str2val($mr0[3]);}
        elsif($row=~/mr1\[0\]\s*=.*;/){$mr1[0]=$row;$mr1[0]=~s/(.*)=(.*);(.*)/$2/g;$mr1[0]=~s/^\s+|\s+$//g;$mr1[0]=&str2val($mr1[0]);}
        elsif($row=~/mr1\[1\]\s*=.*;/){$mr1[1]=$row;$mr1[1]=~s/(.*)=(.*);(.*)/$2/g;$mr1[1]=~s/^\s+|\s+$//g;$mr1[1]=&str2val($mr1[1]);}
        elsif($row=~/mr1\[2\]\s*=.*;/){$mr1[2]=$row;$mr1[2]=~s/(.*)=(.*);(.*)/$2/g;$mr1[2]=~s/^\s+|\s+$//g;$mr1[2]=&str2val($mr1[2]);}
        elsif($row=~/mr1\[3\]\s*=.*;/){$mr1[3]=$row;$mr1[3]=~s/(.*)=(.*);(.*)/$2/g;$mr1[3]=~s/^\s+|\s+$//g;$mr1[3]=&str2val($mr1[3]);}
        elsif($row=~/mr2\[0\]\s*=.*;/){$mr2[0]=$row;$mr2[0]=~s/(.*)=(.*);(.*)/$2/g;$mr2[0]=~s/^\s+|\s+$//g;$mr2[0]=&str2val($mr2[0]);}
        elsif($row=~/mr2\[1\]\s*=.*;/){$mr2[1]=$row;$mr2[1]=~s/(.*)=(.*);(.*)/$2/g;$mr2[1]=~s/^\s+|\s+$//g;$mr2[1]=&str2val($mr2[1]);}
        elsif($row=~/mr2\[2\]\s*=.*;/){$mr2[2]=$row;$mr2[2]=~s/(.*)=(.*);(.*)/$2/g;$mr2[2]=~s/^\s+|\s+$//g;$mr2[2]=&str2val($mr2[2]);}
        elsif($row=~/mr2\[3\]\s*=.*;/){$mr2[3]=$row;$mr2[3]=~s/(.*)=(.*);(.*)/$2/g;$mr2[3]=~s/^\s+|\s+$//g;$mr2[3]=&str2val($mr2[3]);}
        elsif($row=~/mr3\[0\]\s*=.*;/){$mr3[0]=$row;$mr3[0]=~s/(.*)=(.*);(.*)/$2/g;$mr3[0]=~s/^\s+|\s+$//g;$mr3[0]=&str2val($mr3[0]);}
        elsif($row=~/mr3\[1\]\s*=.*;/){$mr3[1]=$row;$mr3[1]=~s/(.*)=(.*);(.*)/$2/g;$mr3[1]=~s/^\s+|\s+$//g;$mr3[1]=&str2val($mr3[1]);}
        elsif($row=~/mr3\[2\]\s*=.*;/){$mr3[2]=$row;$mr3[2]=~s/(.*)=(.*);(.*)/$2/g;$mr3[2]=~s/^\s+|\s+$//g;$mr3[2]=&str2val($mr3[2]);}
        elsif($row=~/mr3\[3\]\s*=.*;/){$mr3[3]=$row;$mr3[3]=~s/(.*)=(.*);(.*)/$2/g;$mr3[3]=~s/^\s+|\s+$//g;$mr3[3]=&str2val($mr3[3]);}
        elsif($row=~/mr4\[0\]\s*=.*;/){$mr4[0]=$row;$mr4[0]=~s/(.*)=(.*);(.*)/$2/g;$mr4[0]=~s/^\s+|\s+$//g;$mr4[0]=&str2val($mr4[0]);}
        elsif($row=~/mr4\[1\]\s*=.*;/){$mr4[1]=$row;$mr4[1]=~s/(.*)=(.*);(.*)/$2/g;$mr4[1]=~s/^\s+|\s+$//g;$mr4[1]=&str2val($mr4[1]);}
        elsif($row=~/mr4\[2\]\s*=.*;/){$mr4[2]=$row;$mr4[2]=~s/(.*)=(.*);(.*)/$2/g;$mr4[2]=~s/^\s+|\s+$//g;$mr4[2]=&str2val($mr4[2]);}
        elsif($row=~/mr4\[3\]\s*=.*;/){$mr4[3]=$row;$mr4[3]=~s/(.*)=(.*);(.*)/$2/g;$mr4[3]=~s/^\s+|\s+$//g;$mr4[3]=&str2val($mr4[3]);}
        elsif($row=~/mr5\[0\]\s*=.*;/){$mr5[0]=$row;$mr5[0]=~s/(.*)=(.*);(.*)/$2/g;$mr5[0]=~s/^\s+|\s+$//g;$mr5[0]=&str2val($mr5[0]);}
        elsif($row=~/mr5\[1\]\s*=.*;/){$mr5[1]=$row;$mr5[1]=~s/(.*)=(.*);(.*)/$2/g;$mr5[1]=~s/^\s+|\s+$//g;$mr5[1]=&str2val($mr5[1]);}
        elsif($row=~/mr5\[2\]\s*=.*;/){$mr5[2]=$row;$mr5[2]=~s/(.*)=(.*);(.*)/$2/g;$mr5[2]=~s/^\s+|\s+$//g;$mr5[2]=&str2val($mr5[2]);}
        elsif($row=~/mr5\[3\]\s*=.*;/){$mr5[3]=$row;$mr5[3]=~s/(.*)=(.*);(.*)/$2/g;$mr5[3]=~s/^\s+|\s+$//g;$mr5[3]=&str2val($mr5[3]);}
        elsif($row=~/mr6\[0\]\s*=.*;/){$mr6[0]=$row;$mr6[0]=~s/(.*)=(.*);(.*)/$2/g;$mr6[0]=~s/^\s+|\s+$//g;$mr6[0]=&str2val($mr6[0]);}
        elsif($row=~/mr6\[1\]\s*=.*;/){$mr6[1]=$row;$mr6[1]=~s/(.*)=(.*);(.*)/$2/g;$mr6[1]=~s/^\s+|\s+$//g;$mr6[1]=&str2val($mr6[1]);}
        elsif($row=~/mr6\[2\]\s*=.*;/){$mr6[2]=$row;$mr6[2]=~s/(.*)=(.*);(.*)/$2/g;$mr6[2]=~s/^\s+|\s+$//g;$mr6[2]=&str2val($mr6[2]);}
        elsif($row=~/mr6\[3\]\s*=.*;/){$mr6[3]=$row;$mr6[3]=~s/(.*)=(.*);(.*)/$2/g;$mr6[3]=~s/^\s+|\s+$//g;$mr6[3]=&str2val($mr6[3]);}
        elsif($row=~/mr10\[0\]\s*=.*;/){$mr10[0]=$row;$mr10[0]=~s/(.*)=(.*);(.*)/$2/g;$mr10[0]=~s/^\s+|\s+$//g;$mr10[0]=&str2val($mr10[0]);}
        elsif($row=~/mr10\[1\]\s*=.*;/){$mr10[1]=$row;$mr10[1]=~s/(.*)=(.*);(.*)/$2/g;$mr10[1]=~s/^\s+|\s+$//g;$mr10[1]=&str2val($mr10[1]);}
        elsif($row=~/mr10\[2\]\s*=.*;/){$mr10[2]=$row;$mr10[2]=~s/(.*)=(.*);(.*)/$2/g;$mr10[2]=~s/^\s+|\s+$//g;$mr10[2]=&str2val($mr10[2]);}
        elsif($row=~/mr10\[3\]\s*=.*;/){$mr10[3]=$row;$mr10[3]=~s/(.*)=(.*);(.*)/$2/g;$mr10[3]=~s/^\s+|\s+$//g;$mr10[3]=&str2val($mr10[3]);}
        elsif($row=~/mr16\[0\]\s*=.*;/){$mr16[0]=$row;$mr16[0]=~s/(.*)=(.*);(.*)/$2/g;$mr16[0]=~s/^\s+|\s+$//g;$mr16[0]=&str2val($mr16[0]);}
        elsif($row=~/mr16\[1\]\s*=.*;/){$mr16[1]=$row;$mr16[1]=~s/(.*)=(.*);(.*)/$2/g;$mr16[1]=~s/^\s+|\s+$//g;$mr16[1]=&str2val($mr16[1]);}
        elsif($row=~/mr16\[2\]\s*=.*;/){$mr16[2]=$row;$mr16[2]=~s/(.*)=(.*);(.*)/$2/g;$mr16[2]=~s/^\s+|\s+$//g;$mr16[2]=&str2val($mr16[2]);}
        elsif($row=~/mr16\[3\]\s*=.*;/){$mr16[3]=$row;$mr16[3]=~s/(.*)=(.*);(.*)/$2/g;$mr16[3]=~s/^\s+|\s+$//g;$mr16[3]=&str2val($mr16[3]);}
        elsif($row=~/mr18\[0\]\s*=.*;/){$mr18[0]=$row;$mr18[0]=~s/(.*)=(.*);(.*)/$2/g;$mr18[0]=~s/^\s+|\s+$//g;$mr18[0]=&str2val($mr18[0]);}
        elsif($row=~/mr18\[1\]\s*=.*;/){$mr18[1]=$row;$mr18[1]=~s/(.*)=(.*);(.*)/$2/g;$mr18[1]=~s/^\s+|\s+$//g;$mr18[1]=&str2val($mr18[1]);}
        elsif($row=~/mr18\[2\]\s*=.*;/){$mr18[2]=$row;$mr18[2]=~s/(.*)=(.*);(.*)/$2/g;$mr18[2]=~s/^\s+|\s+$//g;$mr18[2]=&str2val($mr18[2]);}
        elsif($row=~/mr18\[3\]\s*=.*;/){$mr18[3]=$row;$mr18[3]=~s/(.*)=(.*);(.*)/$2/g;$mr18[3]=~s/^\s+|\s+$//g;$mr18[3]=&str2val($mr18[3]);}
        elsif($row=~/mr19\[0\]\s*=.*;/){$mr19[0]=$row;$mr19[0]=~s/(.*)=(.*);(.*)/$2/g;$mr19[0]=~s/^\s+|\s+$//g;$mr19[0]=&str2val($mr19[0]);}
        elsif($row=~/mr19\[1\]\s*=.*;/){$mr19[1]=$row;$mr19[1]=~s/(.*)=(.*);(.*)/$2/g;$mr19[1]=~s/^\s+|\s+$//g;$mr19[1]=&str2val($mr19[1]);}
        elsif($row=~/mr19\[2\]\s*=.*;/){$mr19[2]=$row;$mr19[2]=~s/(.*)=(.*);(.*)/$2/g;$mr19[2]=~s/^\s+|\s+$//g;$mr19[2]=&str2val($mr19[2]);}
        elsif($row=~/mr19\[3\]\s*=.*;/){$mr19[3]=$row;$mr19[3]=~s/(.*)=(.*);(.*)/$2/g;$mr19[3]=~s/^\s+|\s+$//g;$mr19[3]=&str2val($mr19[3]);}
        elsif($row=~/mr20\[0\]\s*=.*;/){$mr20[0]=$row;$mr20[0]=~s/(.*)=(.*);(.*)/$2/g;$mr20[0]=~s/^\s+|\s+$//g;$mr20[0]=&str2val($mr20[0]);}
        elsif($row=~/mr20\[1\]\s*=.*;/){$mr20[1]=$row;$mr20[1]=~s/(.*)=(.*);(.*)/$2/g;$mr20[1]=~s/^\s+|\s+$//g;$mr20[1]=&str2val($mr20[1]);}
        elsif($row=~/mr20\[2\]\s*=.*;/){$mr20[2]=$row;$mr20[2]=~s/(.*)=(.*);(.*)/$2/g;$mr20[2]=~s/^\s+|\s+$//g;$mr20[2]=&str2val($mr20[2]);}
        elsif($row=~/mr20\[3\]\s*=.*;/){$mr20[3]=$row;$mr20[3]=~s/(.*)=(.*);(.*)/$2/g;$mr20[3]=~s/^\s+|\s+$//g;$mr20[3]=&str2val($mr20[3]);}
        elsif($row=~/mr13\[0\]\s*=.*;/){$mr13[0]=$row;$mr13[0]=~s/(.*)=(.*);(.*)/$2/g;$mr13[0]=~s/^\s+|\s+$//g;$mr13[0]=&str2val($mr13[0]);}
        elsif($row=~/mr13\[1\]\s*=.*;/){$mr13[1]=$row;$mr13[1]=~s/(.*)=(.*);(.*)/$2/g;$mr13[1]=~s/^\s+|\s+$//g;$mr13[1]=&str2val($mr13[1]);}
        elsif($row=~/mr13\[2\]\s*=.*;/){$mr13[2]=$row;$mr13[2]=~s/(.*)=(.*);(.*)/$2/g;$mr13[2]=~s/^\s+|\s+$//g;$mr13[2]=&str2val($mr13[2]);}
        elsif($row=~/mr13\[3\]\s*=.*;/){$mr13[3]=$row;$mr13[3]=~s/(.*)=(.*);(.*)/$2/g;$mr13[3]=~s/^\s+|\s+$//g;$mr13[3]=&str2val($mr13[3]);}
        elsif($row=~/mr22\[0\]\s*=.*;/){$mr22[0]=$row;$mr22[0]=~s/(.*)=(.*);(.*)/$2/g;$mr22[0]=~s/^\s+|\s+$//g;$mr22[0]=&str2val($mr22[0]);}
        elsif($row=~/mr22\[1\]\s*=.*;/){$mr22[1]=$row;$mr22[1]=~s/(.*)=(.*);(.*)/$2/g;$mr22[1]=~s/^\s+|\s+$//g;$mr22[1]=&str2val($mr22[1]);}
        elsif($row=~/mr22\[2\]\s*=.*;/){$mr22[2]=$row;$mr22[2]=~s/(.*)=(.*);(.*)/$2/g;$mr22[2]=~s/^\s+|\s+$//g;$mr22[2]=&str2val($mr22[2]);}
        elsif($row=~/mr22\[3\]\s*=.*;/){$mr22[3]=$row;$mr22[3]=~s/(.*)=(.*);(.*)/$2/g;$mr22[3]=~s/^\s+|\s+$//g;$mr22[3]=&str2val($mr22[3]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DramType\", (\w+)/){$DramType=$1;}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DimmType\", (\w+)/){$DimmType=$1;}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumPStates\", (\w+)/){$numpstate=$1; $numpstate=&str2val($numpstate);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Frequency\[(\d+)\]\", (\w+)/){$freq[$1]=$2; $freq[$1]=&str2val($freq[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DfiFreqRatio\[(\d+)\]\", (\w+)/){$freq_ratio[$1]=$2; $freq_ratio[$1]=&str2val($freq_ratio[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumDbyte\", (\w+)/){$NumDbyte=&str2val($1);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumDbytesPerCh\", (\w+)/){$NumDbytesPerCh=$1; $NumDbytesPerCh=&str2val($NumDbytesPerCh);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumCh\", (\w+)/){$NumCh=$1; $NumCh=&str2val($NumCh);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumActiveDbyteDfi0\", (\w+)/){$NumActiveDbyteDfi0=$1; $NumActiveDbyteDfi0=&str2val($NumActiveDbyteDfi0);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumActiveDbyteDfi1\", (\w+)/){$NumActiveDbyteDfi1=$1; $NumActiveDbyteDfi1=&str2val($NumActiveDbyteDfi1);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumRank_dfi0\", (\w+)/){$NumRank_dfi0=$1; $NumRank_dfi0=&str2val($NumRank_dfi0);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumRank_dfi1\", (\w+)/){$NumRank_dfi1=$1; $NumRank_dfi1=&str2val($NumRank_dfi1);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"NumAnib\", (\w+)/){$NumAnib=$1; $NumAnib=&str2val($NumAnib);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Lp4xMode\", (\w+)/){$Lp4xMode=$1; $Lp4xMode=&str2val($Lp4xMode);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"HardMacroVer\", (\w+)/){$HardMacroVer=$1; $HardMacroVer=&str2val($HardMacroVer);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Train2D\", (\w+)/){$Train2D=$1; $Train2D=&str2val($Train2D);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"PllBypass\[(\d+)\]\", (\w+)/){$PllBypass[$1]=$2; $PllBypass[$1]=&str2val($PllBypass[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DisableFspOp\", (\w+)/){$DisableFspOp=$1; $DisableFspOp=&str2val($DisableFspOp);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"WDQSExt\", (\w+)/){$WDQSExt=$1; $WDQSExt=&str2val($WDQSExt);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"FirstPState\", (\w+)/){$FirstPState=$1; $FirstPState=&str2val($FirstPState);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Dfi1Exists\", (\w+)/){$Dfi1Exists=$1; $Dfi1Exists=&str2val($Dfi1Exists);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DfiMode\", (\w+)/){$DfiMode=$1; $DfiMode=&str2val($DfiMode);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"ReadDBIEnable(\d+)\", (\w+)/){$ReadDBIEnable[$1]=$2; $ReadDBIEnable[$1]=&str2val($ReadDBIEnable[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DramDataWidth\", (\w+)/){$DramDataWidth=$1; $DramDataWidth=&str2val($DramDataWidth);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DramByteSwap\", (\w+)/){$DramByteSwap=$1; $DramByteSwap=&str2val($DramByteSwap);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"DisDynAdrTri(\d+)\", (\w+)/){$DisDynAdrTri[$1]=$2; $DisDynAdrTri[$1]=&str2val($DisDynAdrTri[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Is2Ttiming(\d+)\", (\w+)/){$Is2Ttiming[$1]=$2; $Is2Ttiming[$1]=&str2val($Is2Ttiming[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"D4RxPreambleLength(\d+)\", (\w+)/){$D4RxPreambleLength[$1]=$2; $D4RxPreambleLength[$1]=&str2val($D4RxPreambleLength[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"D4TxPreambleLength(\d+)\", (\w+)/){$D4TxPreambleLength[$1]=$2; $D4TxPreambleLength[$1]=&str2val($D4TxPreambleLength[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"RxEnBackOff\", (\w+)/){$RxEnBackOff=$1; $RxEnBackOff=&str2val($RxEnBackOff);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Lp4PostambleExt(\d+)\", (\w+)/){$Lp4PostambleExt[$1]=$2; $Lp4PostambleExt[$1]=&str2val($Lp4PostambleExt[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Lp4DbiRd(\d+)\", (\w+)/){$Lp4DbiRd[$1]=$2; $Lp4DbiRd[$1]=&str2val($Lp4DbiRd[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Lp4DbiWr(\d+)\", (\w+)/){$Lp4DbiWr[$1]=$2; $Lp4DbiWr[$1]=&str2val($Lp4DbiWr[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"Lp4WLS(\d+)\", (\w+)/){$Lp4WLS[$1]=$2; $Lp4WLS[$1]=&str2val($Lp4WLS[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"CsPresent\", (\w+)/){$CsPresent=$1; $CsPresent=&str2val($CsPresent);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"AddrMirror\", (\w+)/){$AddrMirror=$1; $AddrMirror=&str2val($AddrMirror);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"UseBroadcastMR\", (\w+)/){$UseBroadcastMR=$1; $UseBroadcastMR=&str2val($UseBroadcastMR);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"ALT_CAS_L(\d+)\", (\w+)/){$ALT_CAS_L[$1]=$1; $ALT_CAS_L[$1]=&str2val($ALT_CAS_L[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setUserInput \(phyctx, \"ALT_WCAS_L(\d+)\", (\w+)/){$ALT_WCAS_L[$1]=$1; $ALT_WCAS_L[$1]=&str2val($ALT_WCAS_L[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR0(\D.*)\", (\w+)/){$mr0[$1]=$3; $mr0[$1]=&str2val($mr0[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR1(\D.*)\", (\w+)/){$mr1[$1]=$3; $mr1[$1]=&str2val($mr1[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR2(\D.*)\", (\w+)/){$mr2[$1]=$3; $mr2[$1]=&str2val($mr2[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR3(\D.*)\", (\w+)/){$mr3[$1]=$3; $mr3[$1]=&str2val($mr3[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR4(\D.*)\", (\w+)/){$mr4[$1]=$3; $mr4[$1]=&str2val($mr4[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR5(\D.*)\", (\w+)/){$mr5[$1]=$3; $mr5[$1]=&str2val($mr5[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR6(\D.*)\", (\w+)/){$mr6[$1]=$3; $mr6[$1]=&str2val($mr6[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR10(\D.*)\", (\w+)/){$mr10[$1]=$3; $mr10[$1]=&str2val($mr10[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR16(\D.*)\", (\w+)/){$mr16[$1]=$3; $mr16[$1]=&str2val($mr16[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR18(\D.*)\", (\w+)/){$mr18[$1]=$3; $mr18[$1]=&str2val($mr18[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR19(\D.*)\", (\w+)/){$mr19[$1]=$3; $mr19[$1]=&str2val($mr19[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR20(\D.*)\", (\w+)/){$mr20[$1]=$3; $mr20[$1]=&str2val($mr20[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR13(\D.*)\", (\w+)/){$mr13[$1]=$3; $mr13[$1]=&str2val($mr13[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"MR22(\D.*)\", (\w+)/){$mr22[$1]=$3; $mr22[$1]=&str2val($mr22[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"F0RC0A_D0"\, (\w+)/){$f0RC0A_D0[$1]=$2; $f0RC0A_D0[$1]=&str2val($f0RC0A_D0[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"F0RC3x_D0"\, (\w+)/){$f0RC3x_D0[$1]=$2; $f0RC3x_D0[$1]=&str2val($f0RC3x_D0[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"F0RC0D_D0"\, (\w+)/){$f0RC0D_D0[$1]=$2; $f0RC0D_D0[$1]=&str2val($f0RC0D_D0[$1]);}
        elsif($row=~/dwc_ddrphy_phyinit_setMb \(phyctx, (\d+), \"F0RC0F_D0"\, (\w+)/){$f0RC0F_D0[$1]=$2; $f0RC0F_D0[$1]=&str2val($f0RC0F_D0[$1]);}
        elsif($row=~/DfiFreqRatio\[0\]\s*=.*;/){$freq_ratio[0]=$row;$freq_ratio[0]=~s/(.*)=(.*);(.*)/$2/g;$freq_ratio[0]=~s/^\s+|\s+$//g;$freq_ratio[0]=&str2val($freq_ratio[0]);}
        elsif($row=~/DfiFreqRatio\[1\]\s*=.*;/){$freq_ratio[1]=$row;$freq_ratio[1]=~s/(.*)=(.*);(.*)/$2/g;$freq_ratio[1]=~s/^\s+|\s+$//g;$freq_ratio[1]=&str2val($freq_ratio[1]);}
        elsif($row=~/DfiFreqRatio\[2\]\s*=.*;/){$freq_ratio[2]=$row;$freq_ratio[2]=~s/(.*)=(.*);(.*)/$2/g;$freq_ratio[2]=~s/^\s+|\s+$//g;$freq_ratio[2]=&str2val($freq_ratio[2]);}
        elsif($row=~/DfiFreqRatio\[3\]\s*=.*;/){$freq_ratio[3]=$row;$freq_ratio[3]=~s/(.*)=(.*);(.*)/$2/g;$freq_ratio[3]=~s/^\s+|\s+$//g;$freq_ratio[3]=&str2val($freq_ratio[3]);}
        elsif($row=~/NumDbyte\s*=.*;/){$NumDbyte=$row;$NumDbyte=~s/(.*)=(.*);(.*)/$2/g;$NumDbyte=~s/^\s+|\s+$//g;$NumDbyte=&str2val($NumDbyte);} 
        elsif($row=~/NumDbytesPerCh\s*=.*;/){$NumDbytesPerCh=$row;$NumDbytesPerCh=~s/(.*)=(.*);(.*)/$2/g;$NumDbytesPerCh=~s/^\s+|\s+$//g;$NumDbytesPerCh=hex($NumDbytesPerCh);}
        elsif($row=~/NumCh\s*=.*;/){$NumCh=$row;$NumCh=~s/(.*)=(.*);(.*)/$2/g;$NumCh=~s/^\s+|\s+$//g;$NumCh=hex($NumCh);}
        elsif($row=~/NumActiveDbyteDfi0\s*=.*;/){$NumActiveDbyteDfi0=$row;$NumActiveDbyteDfi0=~s/(.*)=(.*);(.*)/$2/g;$NumActiveDbyteDfi0=~s/^\s+|\s+$//g;$NumActiveDbyteDfi0=hex($NumActiveDbyteDfi0);}
        elsif($row=~/NumActiveDbyteDfi1\s*=.*;/){$NumActiveDbyteDfi1=$row;$NumActiveDbyteDfi1=~s/(.*)=(.*);(.*)/$2/g;$NumActiveDbyteDfi1=~s/^\s+|\s+$//g;$NumActiveDbyteDfi1=hex($NumActiveDbyteDfi1);}
        elsif($row=~/NumRank_dfi0\s*=.*;/){$NumRank_dfi0=$row;$NumRank_dfi0=~s/(.*)=(.*);(.*)/$2/g;$NumRank_dfi0=~s/^\s+|\s+$//g;$NumRank_dfi0=&str2val($NumRank_dfi0);}
        elsif($row=~/NumRank_dfi1\s*=.*;/){$NumRank_dfi1=$row;$NumRank_dfi1=~s/(.*)=(.*);(.*)/$2/g;$NumRank_dfi1=~s/^\s+|\s+$//g;$NumRank_dfi1=&str2val($NumRank_dfi1);}
        elsif($row=~/NumAnib\s*=.*;/){$NumAnib=$row;$NumAnib=~s/(.*)=(.*);(.*)/$2/g;$NumAnib=~s/^\s+|\s+$//g;$NumAnib=&str2val($NumAnib);}
        elsif($row=~/Lp4xMode\s*=.*;/){$Lp4xMode=$row;$Lp4xMode=~s/(.*)=(.*);(.*)/$2/g;$Lp4xMode=~s/^\s+|\s+$//g;$Lp4xMode=&str2val($Lp4xMode);}
        elsif($row=~/DisableFspOp\s*=.*;/){$DisableFspOp=$row;$DisableFspOp=~s/(.*)=(.*);(.*)/$2/g;$DisableFspOp=~s/^\s+|\s+$//g;$DisableFspOp=&str2val($DisableFspOp);}
        elsif($row=~/WDQSExt\s*=.*;/){$WDQSExt=$row;$WDQSExt=~s/(.*)=(.*);(.*)/$2/g;$WDQSExt=~s/^\s+|\s+$//g;$WDQSExt=&str2val($WDQSExt);}
        elsif($row=~/HardMacroVer\s*=.*;/){$HardMacroVer=$row;$HardMacroVer=~s/(.*)=(.*);(.*)/$2/g;$HardMacroVer=~s/^\s+|\s+$//g;$HardMacroVer=&str2val($HardMacroVer);}
        elsif($row=~/Train2D\s*=\s*0.*;/){$Train2D=$row;$Train2D=~s/(.*)=(.*);(.*)/$2/g;$Train2D=~s/^\s+|\s+$//g;$Train2D=&str2val($Train2D);}
        elsif($row=~/PllBypass\[0\]\s*=.*;/){$PllBypass[0]=$row;$PllBypass[0]=~s/(.*)=(.*);(.*)/$2/g;$PllBypass[0]=~s/^\s+|\s+$//g;$PllBypass[0]=&str2val($PllBypass[0]);}
        elsif($row=~/PllBypass\[1\]\s*=.*;/){$PllBypass[1]=$row;$PllBypass[1]=~s/(.*)=(.*);(.*)/$2/g;$PllBypass[1]=~s/^\s+|\s+$//g;$PllBypass[1]=&str2val($PllBypass[1]);}
        elsif($row=~/PllBypass\[2\]\s*=.*;/){$PllBypass[2]=$row;$PllBypass[2]=~s/(.*)=(.*);(.*)/$2/g;$PllBypass[2]=~s/^\s+|\s+$//g;$PllBypass[2]=&str2val($PllBypass[2]);}
        elsif($row=~/PllBypass\[3\]\s*=.*;/){$PllBypass[3]=$row;$PllBypass[3]=~s/(.*)=(.*);(.*)/$2/g;$PllBypass[3]=~s/^\s+|\s+$//g;$PllBypass[3]=&str2val($PllBypass[3]);}
        elsif($row=~/Dfi1Exists\s*=.*;/){$Dfi1Exists=$row;$Dfi1Exists=~s/(.*)=(.*);(.*)/$2/g;$Dfi1Exists=~s/^\s+|\s+$//g;$Dfi1Exists=&str2val($Dfi1Exists);}
        elsif($row=~/DfiMode\s*=.*;/){$DfiMode=$row;$DfiMode=~s/(.*)=(.*);(.*)/$2/g;$DfiMode=~s/^\s+|\s+$//g;$DfiMode=&str2val($DfiMode);}
        elsif($row=~/ReadDBIEnable\[0\]\s*=.*;/){$ReadDBIEnable[0]=$row;$ReadDBIEnable[0]=~s/(.*)=(.*);(.*)/$2/g;$ReadDBIEnable[0]=~s/^\s+|\s+$//g;$ReadDBIEnable[0]=&str2val($ReadDBIEnable[0]);}
        elsif($row=~/ReadDBIEnable\[1\]\s*=.*;/){$ReadDBIEnable[1]=$row;$ReadDBIEnable[1]=~s/(.*)=(.*);(.*)/$2/g;$ReadDBIEnable[1]=~s/^\s+|\s+$//g;$ReadDBIEnable[1]=&str2val($ReadDBIEnable[1]);}
        elsif($row=~/ReadDBIEnable\[2\]\s*=.*;/){$ReadDBIEnable[2]=$row;$ReadDBIEnable[2]=~s/(.*)=(.*);(.*)/$2/g;$ReadDBIEnable[2]=~s/^\s+|\s+$//g;$ReadDBIEnable[2]=&str2val($ReadDBIEnable[2]);}
        elsif($row=~/ReadDBIEnable\[3\]\s*=.*;/){$ReadDBIEnable[3]=$row;$ReadDBIEnable[3]=~s/(.*)=(.*);(.*)/$2/g;$ReadDBIEnable[3]=~s/^\s+|\s+$//g;$ReadDBIEnable[3]=&str2val($ReadDBIEnable[3]);}
        elsif($row=~/DramDataWidth\s*=.*;/){$DramDataWidth=$row;$DramDataWidth=~s/(.*)=(.*);(.*)/$2/g;$DramDataWidth=~s/^\s+|\s+$//g;$DramDataWidth=&str2val($DramDataWidth);}
        elsif($row=~/DramByteSwap\s*=.*;/){$DramByteSwap=$row;$DramByteSwap=~s/(.*)=(.*);(.*)/$2/g;$DramByteSwap=~s/^\s+|\s+$//g;$DramByteSwap=&str2val($DramByteSwap);}
        elsif($row=~/DisDynAdrTri\[0\]\s*=.*;/){$DisDynAdrTri[0]=$row;$DisDynAdrTri[0]=~s/(.*)=(.*);(.*)/$2/g;$DisDynAdrTri[0]=~s/^\s+|\s+$//g;$DisDynAdrTri[0]=&str2val($DisDynAdrTri[0]);}
        elsif($row=~/DisDynAdrTri\[1\]\s*=.*;/){$DisDynAdrTri[1]=$row;$DisDynAdrTri[1]=~s/(.*)=(.*);(.*)/$2/g;$DisDynAdrTri[1]=~s/^\s+|\s+$//g;$DisDynAdrTri[1]=&str2val($DisDynAdrTri[1]);}
        elsif($row=~/DisDynAdrTri\[2\]\s*=.*;/){$DisDynAdrTri[2]=$row;$DisDynAdrTri[2]=~s/(.*)=(.*);(.*)/$2/g;$DisDynAdrTri[2]=~s/^\s+|\s+$//g;$DisDynAdrTri[2]=&str2val($DisDynAdrTri[2]);}
        elsif($row=~/DisDynAdrTri\[3\]\s*=.*;/){$DisDynAdrTri[3]=$row;$DisDynAdrTri[3]=~s/(.*)=(.*);(.*)/$2/g;$DisDynAdrTri[3]=~s/^\s+|\s+$//g;$DisDynAdrTri[3]=&str2val($DisDynAdrTri[3]);}
        elsif($row=~/Is2Ttiming\[0\]\s*=.*;/){$Is2Ttiming[0]=$row;$Is2Ttiming[0]=~s/(.*)=(.*);(.*)/$2/g;$Is2Ttiming[0]=~s/^\s+|\s+$//g;$Is2Ttiming[0]=&str2val($Is2Ttiming[0]);}
        elsif($row=~/Is2Ttiming\[1\]\s*=.*;/){$Is2Ttiming[1]=$row;$Is2Ttiming[1]=~s/(.*)=(.*);(.*)/$2/g;$Is2Ttiming[1]=~s/^\s+|\s+$//g;$Is2Ttiming[1]=&str2val($Is2Ttiming[1]);}
        elsif($row=~/Is2Ttiming\[2\]\s*=.*;/){$Is2Ttiming[2]=$row;$Is2Ttiming[2]=~s/(.*)=(.*);(.*)/$2/g;$Is2Ttiming[2]=~s/^\s+|\s+$//g;$Is2Ttiming[2]=&str2val($Is2Ttiming[2]);}
        elsif($row=~/Is2Ttiming\[3\]\s*=.*;/){$Is2Ttiming[3]=$row;$Is2Ttiming[3]=~s/(.*)=(.*);(.*)/$2/g;$Is2Ttiming[3]=~s/^\s+|\s+$//g;$Is2Ttiming[3]=&str2val($Is2Ttiming[3]);}
        elsif($row=~/D4RxPreambleLength\[0\]\s*=.*;/){$D4RxPreambleLength[0]=$row;$D4RxPreambleLength[0]=~s/(.*)=(.*);(.*)/$2/g;$D4RxPreambleLength[0]=~s/^\s+|\s+$//g;$D4RxPreambleLength[0]=&str2val($D4RxPreambleLength[0]);}
        elsif($row=~/D4RxPreambleLength\[1\]\s*=.*;/){$D4RxPreambleLength[1]=$row;$D4RxPreambleLength[1]=~s/(.*)=(.*);(.*)/$2/g;$D4RxPreambleLength[1]=~s/^\s+|\s+$//g;$D4RxPreambleLength[1]=&str2val($D4RxPreambleLength[1]);}
        elsif($row=~/D4RxPreambleLength\[2\]\s*=.*;/){$D4RxPreambleLength[2]=$row;$D4RxPreambleLength[2]=~s/(.*)=(.*);(.*)/$2/g;$D4RxPreambleLength[2]=~s/^\s+|\s+$//g;$D4RxPreambleLength[2]=&str2val($D4RxPreambleLength[2]);}
        elsif($row=~/D4RxPreambleLength\[3\]\s*=.*;/){$D4RxPreambleLength[3]=$row;$D4RxPreambleLength[3]=~s/(.*)=(.*);(.*)/$2/g;$D4RxPreambleLength[3]=~s/^\s+|\s+$//g;$D4RxPreambleLength[3]=&str2val($D4RxPreambleLength[3]);}
        elsif($row=~/D4TxPreambleLength\[0\]\s*=.*;/){$D4TxPreambleLength[0]=$row;$D4TxPreambleLength[0]=~s/(.*)=(.*);(.*)/$2/g;$D4TxPreambleLength[0]=~s/^\s+|\s+$//g;$D4TxPreambleLength[0]=&str2val($D4TxPreambleLength[0]);}
        elsif($row=~/D4TxPreambleLength\[1\]\s*=.*;/){$D4TxPreambleLength[1]=$row;$D4TxPreambleLength[1]=~s/(.*)=(.*);(.*)/$2/g;$D4TxPreambleLength[1]=~s/^\s+|\s+$//g;$D4TxPreambleLength[1]=&str2val($D4TxPreambleLength[1]);}
        elsif($row=~/D4TxPreambleLength\[2\]\s*=.*;/){$D4TxPreambleLength[2]=$row;$D4TxPreambleLength[2]=~s/(.*)=(.*);(.*)/$2/g;$D4TxPreambleLength[2]=~s/^\s+|\s+$//g;$D4TxPreambleLength[2]=&str2val($D4TxPreambleLength[2]);}
        elsif($row=~/D4TxPreambleLength\[3\]\s*=.*;/){$D4TxPreambleLength[3]=$row;$D4TxPreambleLength[3]=~s/(.*)=(.*);(.*)/$2/g;$D4TxPreambleLength[3]=~s/^\s+|\s+$//g;$D4TxPreambleLength[3]=&str2val($D4TxPreambleLength[3]);}
        elsif($row=~/RxEnBackOff\s*=.*;/){$RxEnBackOff=$row;$RxEnBackOff=~s/(.*)=(.*);(.*)/$2/g;$RxEnBackOff=~s/^\s+|\s+$//g;$RxEnBackOff=&str2val($RxEnBackOff);}
#        elsif($row=~/Lp4RxPreambleMode\[0\]\s*=.*;/){$Lp4RxPreambleMode[0]=$row;$Lp4RxPreambleMode[0]=~s/(.*)=(.*);(.*)/$2/g;$Lp4RxPreambleMode[0]=~s/^\s+|\s+$//g;$Lp4RxPreambleMode[0]=&str2val($Lp4RxPreambleMode[0]);}
#        elsif($row=~/Lp4RxPreambleMode\[1\]\s*=.*;/){$Lp4RxPreambleMode[1]=$row;$Lp4RxPreambleMode[1]=~s/(.*)=(.*);(.*)/$2/g;$Lp4RxPreambleMode[1]=~s/^\s+|\s+$//g;$Lp4RxPreambleMode[1]=&str2val($Lp4RxPreambleMode[1]);}
#        elsif($row=~/Lp4RxPreambleMode\[2\]\s*=.*;/){$Lp4RxPreambleMode[2]=$row;$Lp4RxPreambleMode[2]=~s/(.*)=(.*);(.*)/$2/g;$Lp4RxPreambleMode[2]=~s/^\s+|\s+$//g;$Lp4RxPreambleMode[2]=&str2val($Lp4RxPreambleMode[2]);}
#        elsif($row=~/Lp4RxPreambleMode\[3\]\s*=.*;/){$Lp4RxPreambleMode[3]=$row;$Lp4RxPreambleMode[3]=~s/(.*)=(.*);(.*)/$2/g;$Lp4RxPreambleMode[3]=~s/^\s+|\s+$//g;$Lp4RxPreambleMode[3]=&str2val($Lp4RxPreambleMode[3]);}
        elsif($row=~/Lp4PostambleExt\[0\]\s*=.*;/){$Lp4PostambleExt[0]=$row;$Lp4PostambleExt[0]=~s/(.*)=(.*);(.*)/$2/g;$Lp4PostambleExt[0]=~s/^\s+|\s+$//g;$Lp4PostambleExt[0]=&str2val($Lp4PostambleExt[0]);}
        elsif($row=~/Lp4PostambleExt\[1\]\s*=.*;/){$Lp4PostambleExt[1]=$row;$Lp4PostambleExt[1]=~s/(.*)=(.*);(.*)/$2/g;$Lp4PostambleExt[1]=~s/^\s+|\s+$//g;$Lp4PostambleExt[1]=&str2val($Lp4PostambleExt[1]);}
        elsif($row=~/Lp4PostambleExt\[2\]\s*=.*;/){$Lp4PostambleExt[2]=$row;$Lp4PostambleExt[2]=~s/(.*)=(.*);(.*)/$2/g;$Lp4PostambleExt[2]=~s/^\s+|\s+$//g;$Lp4PostambleExt[2]=&str2val($Lp4PostambleExt[2]);}
        elsif($row=~/Lp4PostambleExt\[3\]\s*=.*;/){$Lp4PostambleExt[3]=$row;$Lp4PostambleExt[3]=~s/(.*)=(.*);(.*)/$2/g;$Lp4PostambleExt[3]=~s/^\s+|\s+$//g;$Lp4PostambleExt[3]=&str2val($Lp4PostambleExt[3]);}
        elsif($row=~/Lp4DbiRd\[0\]\s*=.*;/){$Lp4DbiRd[0]=$row;$Lp4DbiRd[0]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiRd[0]=~s/^\s+|\s+$//g;$Lp4DbiRd[0]=&str2val($Lp4DbiRd[0]);}
        elsif($row=~/Lp4DbiRd\[1\]\s*=.*;/){$Lp4DbiRd[1]=$row;$Lp4DbiRd[1]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiRd[1]=~s/^\s+|\s+$//g;$Lp4DbiRd[1]=&str2val($Lp4DbiRd[1]);}
        elsif($row=~/Lp4DbiRd\[2\]\s*=.*;/){$Lp4DbiRd[2]=$row;$Lp4DbiRd[2]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiRd[2]=~s/^\s+|\s+$//g;$Lp4DbiRd[2]=&str2val($Lp4DbiRd[2]);}
        elsif($row=~/Lp4DbiRd\[3\]\s*=.*;/){$Lp4DbiRd[3]=$row;$Lp4DbiRd[3]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiRd[3]=~s/^\s+|\s+$//g;$Lp4DbiRd[3]=&str2val($Lp4DbiRd[3]);}
        elsif($row=~/Lp4DbiWr\[0\]\s*=.*;/){$Lp4DbiWr[0]=$row;$Lp4DbiWr[0]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiWr[0]=~s/^\s+|\s+$//g;$Lp4DbiWr[0]=&str2val($Lp4DbiWr[0]);}
        elsif($row=~/Lp4DbiWr\[1\]\s*=.*;/){$Lp4DbiWr[1]=$row;$Lp4DbiWr[1]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiWr[1]=~s/^\s+|\s+$//g;$Lp4DbiWr[1]=&str2val($Lp4DbiWr[1]);}
        elsif($row=~/Lp4DbiWr\[2\]\s*=.*;/){$Lp4DbiWr[2]=$row;$Lp4DbiWr[2]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiWr[2]=~s/^\s+|\s+$//g;$Lp4DbiWr[2]=&str2val($Lp4DbiWr[2]);}
        elsif($row=~/Lp4DbiWr\[3\]\s*=.*;/){$Lp4DbiWr[3]=$row;$Lp4DbiWr[3]=~s/(.*)=(.*);(.*)/$2/g;$Lp4DbiWr[3]=~s/^\s+|\s+$//g;$Lp4DbiWr[3]=&str2val($Lp4DbiWr[3]);}
        elsif($row=~/Lp4WLS\[0\]\s*=.*;/){$Lp4WLS[0]=$row;$Lp4WLS[0]=~s/(.*)=(.*);(.*)/$2/g;$Lp4WLS[0]=~s/^\s+|\s+$//g;$Lp4WLS[0]=&str2val($Lp4WLS[0]);}
        elsif($row=~/Lp4WLS\[1\]\s*=.*;/){$Lp4WLS[1]=$row;$Lp4WLS[1]=~s/(.*)=(.*);(.*)/$2/g;$Lp4WLS[1]=~s/^\s+|\s+$//g;$Lp4WLS[1]=&str2val($Lp4WLS[1]);}
        elsif($row=~/Lp4WLS\[2\]\s*=.*;/){$Lp4WLS[2]=$row;$Lp4WLS[2]=~s/(.*)=(.*);(.*)/$2/g;$Lp4WLS[2]=~s/^\s+|\s+$//g;$Lp4WLS[2]=&str2val($Lp4WLS[2]);}
        elsif($row=~/Lp4WLS\[3\]\s*=.*;/){$Lp4WLS[3]=$row;$Lp4WLS[3]=~s/(.*)=(.*);(.*)/$2/g;$Lp4WLS[3]=~s/^\s+|\s+$//g;$Lp4WLS[3]=&str2val($Lp4WLS[3]);}

        elsif($row=~/CsPresent\s*= 0x.*;/){$CsPresent=$row;$CsPresent=~s/(.*)=(.*);(.*)/$2/g;$CsPresent=~s/^\s+|\s+$//g;$CsPresent=&str2val($CsPresent);}
        elsif($row=~/AddrMirror\s*= 0x.*;/){$AddrMirror=$row;$AddrMirror=~s/(.*)=(.*);(.*)/$2/g;$AddrMirror=~s/^\s+|\s+$//g;$AddrMirror=&str2val($AddrMirror);}
        elsif($row=~/mb_DDR4U_1D\[myps\].EnabledDQs\s*=.*;/){$EnabledDQs=$row;$EnabledDQs=~s/(.*)=(.*);(.*)/$2/g;$EnabledDQs=~s/^\s+|\s+$//g;$EnabledDQs=&str2val($EnabledDQs);}
        elsif($row=~/mb_DDR4U_1D\[myps\].CsSetupGDDec\s*=.*;/){$CsSetupGDDec=$row;$CsSetupGDDec=~s/(.*)=(.*);(.*)/$2/g;$CsSetupGDDec=~s/^\s+|\s+$//g;$CsSetupGDDec=&str2val($CsSetupGDDec);}
        elsif($row=~/ALT_CAS_L\[0\]\s*=.*;/){$ALT_CAS_L[0]=$row;$ALT_CAS_L[0]=~s/(.*)=(.*);(.*)/$2/g;$ALT_CAS_L[0]=~s/^\s+|\s+$//g;$ALT_CAS_L[0]=&str2val($ALT_CAS_L[0]);}
        elsif($row=~/ALT_CAS_L\[1\]\s*=.*;/){$ALT_CAS_L[1]=$row;$ALT_CAS_L[1]=~s/(.*)=(.*);(.*)/$2/g;$ALT_CAS_L[1]=~s/^\s+|\s+$//g;$ALT_CAS_L[1]=&str2val($ALT_CAS_L[1]);}
        elsif($row=~/ALT_CAS_L\[2\]\s*=.*;/){$ALT_CAS_L[2]=$row;$ALT_CAS_L[2]=~s/(.*)=(.*);(.*)/$2/g;$ALT_CAS_L[2]=~s/^\s+|\s+$//g;$ALT_CAS_L[2]=&str2val($ALT_CAS_L[2]);}
        elsif($row=~/ALT_CAS_L\[3\]\s*=.*;/){$ALT_CAS_L[3]=$row;$ALT_CAS_L[3]=~s/(.*)=(.*);(.*)/$2/g;$ALT_CAS_L[3]=~s/^\s+|\s+$//g;$ALT_CAS_L[3]=&str2val($ALT_CAS_L[3]);}
        elsif($row=~/ALT_WCAS_L\[0\]\s*=.*;/){$ALT_WCAS_L[0]=$row;$ALT_WCAS_L[0]=~s/(.*)=(.*);(.*)/$2/g;$ALT_WCAS_L[0]=~s/^\s+|\s+$//g;$ALT_WCAS_L[0]=&str2val($ALT_WCAS_L[0]);}
        elsif($row=~/ALT_WCAS_L\[1\]\s*=.*;/){$ALT_WCAS_L[1]=$row;$ALT_WCAS_L[1]=~s/(.*)=(.*);(.*)/$2/g;$ALT_WCAS_L[1]=~s/^\s+|\s+$//g;$ALT_WCAS_L[1]=&str2val($ALT_WCAS_L[1]);}
        elsif($row=~/ALT_WCAS_L\[2\]\s*=.*;/){$ALT_WCAS_L[2]=$row;$ALT_WCAS_L[2]=~s/(.*)=(.*);(.*)/$2/g;$ALT_WCAS_L[2]=~s/^\s+|\s+$//g;$ALT_WCAS_L[2]=&str2val($ALT_WCAS_L[2]);}
        elsif($row=~/ALT_WCAS_L\[3\]\s*=.*;/){$ALT_WCAS_L[3]=$row;$ALT_WCAS_L[3]=~s/(.*)=(.*);(.*)/$2/g;$ALT_WCAS_L[3]=~s/^\s+|\s+$//g;$ALT_WCAS_L[3]=&str2val($ALT_WCAS_L[3]);}
        elsif($row=~/UseBroadcastMR\s*= 0x.*;/){$UseBroadcastMR=$row;$UseBroadcastMR=~s/(.*)=(.*);(.*)/$2/g;$UseBroadcastMR=~s/^\s+|\s+$//g;$UseBroadcastMR=&str2val($UseBroadcastMR);}
        elsif($row=~/mb_DDR4U_1D\[myps\].X8Mode\s*=.*;/){$X8Mode=$row;$X8Mode=~s/(.*)=(.*);(.*)/$2/g;$X8Mode=~s/^\s+|\s+$//g;$X8Mode=&str2val($X8Mode);}
    } 
  } 
}

sub str2val{
  if($_[0]=~/^0/) {
     oct($_[0]);
  }
  else {
     int($_[0]);
  }
}

###### Write values into "cfg_data.sv" ######
sub gen_ctb_params{

  if(defined $Train2D){$Train2D=sprintf("16'h%04x",$Train2D);}
  if(defined $PllBypass[0]){$PllBypass[0]=sprintf("16'h%04x",$PllBypass[0]);} 
  if(defined $PllBypass[1]){$PllBypass[1]=sprintf("16'h%04x",$PllBypass[1]);} 
  if(defined $PllBypass[2]){$PllBypass[2]=sprintf("16'h%04x",$PllBypass[2]);} 
  if(defined $PllBypass[3]){$PllBypass[3]=sprintf("16'h%04x",$PllBypass[3]);}
  if(defined $Dfi1Exists){$Dfi1Exists=sprintf("16'h%04x",$Dfi1Exists);}
  if(defined $DfiMode){$DfiMode=sprintf("16'h%04x",$DfiMode);}
  if(defined $ReadDBIEnable[0]){$ReadDBIEnable[0]=sprintf("16'h%04x",$ReadDBIEnable[0]);} 
  if(defined $ReadDBIEnable[1]){$ReadDBIEnable[1]=sprintf("16'h%04x",$ReadDBIEnable[1]);} 
  if(defined $ReadDBIEnable[2]){$ReadDBIEnable[2]=sprintf("16'h%04x",$ReadDBIEnable[2]);} 
  if(defined $ReadDBIEnable[3]){$ReadDBIEnable[3]=sprintf("16'h%04x",$ReadDBIEnable[3]);}
  if(defined $DramDataWidth){$DramDataWidth=sprintf("16'h%04x",$DramDataWidth);}
  if(defined $DramByteSwap){$DramByteSwap=sprintf("16'h%04x",$DramByteSwap);}
  if(defined $DisDynAdrTri[0]){$DisDynAdrTri[0]=sprintf("16'h%04x",$DisDynAdrTri[0]);}
  if(defined $DisDynAdrTri[1]){$DisDynAdrTri[1]=sprintf("16'h%04x",$DisDynAdrTri[1]);}
  if(defined $DisDynAdrTri[2]){$DisDynAdrTri[2]=sprintf("16'h%04x",$DisDynAdrTri[2]);}
  if(defined $DisDynAdrTri[3]){$DisDynAdrTri[3]=sprintf("16'h%04x",$DisDynAdrTri[3]);}
  if(defined $Is2Ttiming[0]){$Is2Ttiming[0]=sprintf("16'h%04x",$Is2Ttiming[0]);}
  if(defined $Is2Ttiming[1]){$Is2Ttiming[1]=sprintf("16'h%04x",$Is2Ttiming[1]);}
  if(defined $Is2Ttiming[2]){$Is2Ttiming[2]=sprintf("16'h%04x",$Is2Ttiming[2]);}
  if(defined $Is2Ttiming[3]){$Is2Ttiming[3]=sprintf("16'h%04x",$Is2Ttiming[3]);}
  if(defined $D4RxPreambleLength[0]){$D4RxPreambleLength[0]=sprintf("16'h%04x",$D4RxPreambleLength[0]);}
  if(defined $D4RxPreambleLength[1]){$D4RxPreambleLength[1]=sprintf("16'h%04x",$D4RxPreambleLength[1]);}
  if(defined $D4RxPreambleLength[2]){$D4RxPreambleLength[2]=sprintf("16'h%04x",$D4RxPreambleLength[2]);}
  if(defined $D4RxPreambleLength[3]){$D4RxPreambleLength[3]=sprintf("16'h%04x",$D4RxPreambleLength[3]);}
  if(defined $D4TxPreambleLength[0]){$D4TxPreambleLength[0]=sprintf("16'h%04x",$D4TxPreambleLength[0]);}
  if(defined $D4TxPreambleLength[1]){$D4TxPreambleLength[1]=sprintf("16'h%04x",$D4TxPreambleLength[1]);}
  if(defined $D4TxPreambleLength[2]){$D4TxPreambleLength[2]=sprintf("16'h%04x",$D4TxPreambleLength[2]);}
  if(defined $D4TxPreambleLength[3]){$D4TxPreambleLength[3]=sprintf("16'h%04x",$D4TxPreambleLength[3]);}
  if(defined $RxEnBackOff){$RxEnBackOff=sprintf("16'h%04x",$RxEnBackOff);}
#  if(defined $Lp4RxPreambleMode[0]){$Lp4RxPreambleMode[0]=sprintf("16'h%04x",$Lp4RxPreambleMode[0]);}
#  if(defined $Lp4RxPreambleMode[1]){$Lp4RxPreambleMode[1]=sprintf("16'h%04x",$Lp4RxPreambleMode[1]);}
#  if(defined $Lp4RxPreambleMode[2]){$Lp4RxPreambleMode[2]=sprintf("16'h%04x",$Lp4RxPreambleMode[2]);}
#  if(defined $Lp4RxPreambleMode[3]){$Lp4RxPreambleMode[3]=sprintf("16'h%04x",$Lp4RxPreambleMode[3]);}
  if(defined $Lp4PostambleExt[0]){$Lp4PostambleExt[0]=sprintf("16'h%04x",$Lp4PostambleExt[0]);}
  if(defined $Lp4PostambleExt[1]){$Lp4PostambleExt[1]=sprintf("16'h%04x",$Lp4PostambleExt[1]);}
  if(defined $Lp4PostambleExt[2]){$Lp4PostambleExt[2]=sprintf("16'h%04x",$Lp4PostambleExt[2]);}
  if(defined $Lp4PostambleExt[3]){$Lp4PostambleExt[3]=sprintf("16'h%04x",$Lp4PostambleExt[3]);}
  if(defined $Lp4DbiRd[0]){$Lp4DbiRd[0]=sprintf("16'h%04x",$Lp4DbiRd[0]);}
  if(defined $Lp4DbiRd[1]){$Lp4DbiRd[1]=sprintf("16'h%04x",$Lp4DbiRd[1]);}
  if(defined $Lp4DbiRd[2]){$Lp4DbiRd[2]=sprintf("16'h%04x",$Lp4DbiRd[2]);}
  if(defined $Lp4DbiRd[3]){$Lp4DbiRd[3]=sprintf("16'h%04x",$Lp4DbiRd[3]);}
  if(defined $Lp4DbiWr[0]){$Lp4DbiWr[0]=sprintf("16'h%04x",$Lp4DbiWr[0]);}
  if(defined $Lp4DbiWr[1]){$Lp4DbiWr[1]=sprintf("16'h%04x",$Lp4DbiWr[1]);}
  if(defined $Lp4DbiWr[2]){$Lp4DbiWr[2]=sprintf("16'h%04x",$Lp4DbiWr[2]);}
  if(defined $Lp4DbiWr[3]){$Lp4DbiWr[3]=sprintf("16'h%04x",$Lp4DbiWr[3]);}
  if(defined $Lp4WLS[0]){$Lp4WLS[0]=sprintf("16'h%04x",$Lp4WLS[0]);}
  if(defined $Lp4WLS[1]){$Lp4WLS[1]=sprintf("16'h%04x",$Lp4WLS[1]);}
  if(defined $Lp4WLS[2]){$Lp4WLS[2]=sprintf("16'h%04x",$Lp4WLS[2]);}
  if(defined $Lp4WLS[3]){$Lp4WLS[3]=sprintf("16'h%04x",$Lp4WLS[3]);}

  if(defined $CsPresent){$CsPresent=sprintf("16'h%04x",$CsPresent);}
  if(defined $AddrMirror){$AddrMirror=sprintf("16'h%04x",$AddrMirror);}
  if(defined $EnabledDQs){$EnabledDQs=sprintf("16'h%04x",$EnabledDQs);}
  if(defined $CsSetupGDDec){$CsSetupGDDec=sprintf("16'h%04x",$CsSetupGDDec);}
  if(defined $ALT_CAS_L[0]){$ALT_CAS_L[0]=sprintf("16'h%04x",$ALT_CAS_L[0]);}
  if(defined $ALT_CAS_L[1]){$ALT_CAS_L[1]=sprintf("16'h%04x",$ALT_CAS_L[1]);}
  if(defined $ALT_CAS_L[2]){$ALT_CAS_L[2]=sprintf("16'h%04x",$ALT_CAS_L[2]);}
  if(defined $ALT_CAS_L[3]){$ALT_CAS_L[3]=sprintf("16'h%04x",$ALT_CAS_L[3]);}
  if(defined $ALT_WCAS_L[0]){$ALT_WCAS_L[0]=sprintf("16'h%04x",$ALT_WCAS_L[0]);}
  if(defined $ALT_WCAS_L[1]){$ALT_WCAS_L[1]=sprintf("16'h%04x",$ALT_WCAS_L[1]);}
  if(defined $ALT_WCAS_L[2]){$ALT_WCAS_L[2]=sprintf("16'h%04x",$ALT_WCAS_L[2]);}
  if(defined $ALT_WCAS_L[3]){$ALT_WCAS_L[3]=sprintf("16'h%04x",$ALT_WCAS_L[3]);}
  if(defined $UseBroadcastMR){$UseBroadcastMR=sprintf("16'h%04x",$UseBroadcastMR);}
  if(defined $X8Mode){$X8Mode=sprintf("16'h%04x",$X8Mode);}
  if(defined $DisableFspOp){$DisableFspOp=sprintf("16'h%04x",$DisableFspOp);}
  if(defined $WDQSExt){$WDQSExt=sprintf("16'h%04x",$WDQSExt);}
  if(defined $FirstPState){$FirstPState=sprintf("16'h%04x",$FirstPState);}

for($i=0;$i<$numpstate;$i=$i+1) 
{
  if(($protocol eq "lpddr4") || ($protocol eq "lpddr4x")) {
   if(defined $mr2[$i]){
      if((($mr3[$i]&0b1000000)>>6)==1){
         if(($mr2[$i]&0b111)==0){$CL[$i]=6;}
         elsif(($mr2[$i]&0b111)==1){$CL[$i]=12;}
         elsif(($mr2[$i]&0b111)==2){$CL[$i]=16;}
         elsif(($mr2[$i]&0b111)==3){$CL[$i]=22;}
         elsif(($mr2[$i]&0b111)==4){$CL[$i]=28;}
         elsif(($mr2[$i]&0b111)==5){$CL[$i]=32;}
         elsif(($mr2[$i]&0b111)==6){$CL[$i]=36;}
         elsif(($mr2[$i]&0b111)==7){$CL[$i]=40;}
            else{die "<ctb_modify> Error: mr2 get wrong value.\n";}
   }
      else {if(($mr2[$i]&0b111)==0){$CL[$i]=6;}
            elsif(($mr2[$i]&0b111)==1){$CL[$i]=10;}
            elsif(($mr2[$i]&0b111)==2){$CL[$i]=14;}
            elsif(($mr2[$i]&0b111)==3){$CL[$i]=20;}
            elsif(($mr2[$i]&0b111)==4){$CL[$i]=24;}
            elsif(($mr2[$i]&0b111)==5){$CL[$i]=28;}
            elsif(($mr2[$i]&0b111)==6){$CL[$i]=32;}
            elsif(($mr2[$i]&0b111)==7){$CL[$i]=36;}
            else{die "<ctb_modify> Error: mr2 get wrong value.\n";}
            }
      if((($mr2[$i]&0b1000000)>>6)==1){ 
         if((($mr2[$i]&0b111000)>>3)==0){$CWL[$i]=4;}
         elsif((($mr2[$i]&0b111000)>>3)==1){$CWL[$i]=8;}
         elsif((($mr2[$i]&0b111000)>>3)==2){$CWL[$i]=12;}
         elsif((($mr2[$i]&0b111000)>>3)==3){$CWL[$i]=18;}
         elsif((($mr2[$i]&0b111000)>>3)==4){$CWL[$i]=22;}
         elsif((($mr2[$i]&0b111000)>>3)==5){$CWL[$i]=26;}
         elsif((($mr2[$i]&0b111000)>>3)==6){$CWL[$i]=30;}
         elsif((($mr2[$i]&0b111000)>>3)==7){$CWL[$i]=34;} 
         else{die "<ctb_modify> Error: mr2 get wrong value.\n";}
      }
      else {if((($mr2[$i]&0b111000)>>3)==0){$CWL[$i]=4;}
            elsif((($mr2[$i]&0b111000)>>3)==1){$CWL[$i]=6;}
            elsif((($mr2[$i]&0b111000)>>3)==2){$CWL[$i]=8;}
            elsif((($mr2[$i]&0b111000)>>3)==3){$CWL[$i]=10;}
            elsif((($mr2[$i]&0b111000)>>3)==4){$CWL[$i]=12;}
            elsif((($mr2[$i]&0b111000)>>3)==5){$CWL[$i]=14;}
            elsif((($mr2[$i]&0b111000)>>3)==6){$CWL[$i]=16;}
            elsif((($mr2[$i]&0b111000)>>3)==7){$CWL[$i]=18;} 
            else{die "<ctb_modify> Error: mr2 get wrong value.\n";}
      }
   } 
   else
    {
      if    ( $freq[$i] <= 266 ){$CL[$i]=6; $CWL[$i]=4;}
      elsif ( $freq[$i] <= 533) {$CL[$i]=10;$CWL[$i]=6;}
      elsif ( $freq[$i] <= 800) {$CL[$i]=14;$CWL[$i]=8;}
      elsif ( $freq[$i] <= 1066){$CL[$i]=20;$CWL[$i]=10;}
      elsif ( $freq[$i] <= 1333){$CL[$i]=24;$CWL[$i]=12;}
      elsif ( $freq[$i] <= 1600){$CL[$i]=28;$CWL[$i]=14;}
      elsif ( $freq[$i] <= 1866){$CL[$i]=32;$CWL[$i]=16;} 
      else                      {$CL[$i]=36;$CWL[$i]=18;}
    } 
  }
  elsif($protocol eq "lpddr5") {
    if(defined $mr1[$i]){
      if($freq_ratio[$i] ==2){
        if   ((($mr1[$i]&0b11110000)>>4)==0 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=2} else{$CWL[$i]=2}}
        elsif((($mr1[$i]&0b11110000)>>4)==1 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=3} else{$CWL[$i]=2}}
        elsif((($mr1[$i]&0b11110000)>>4)==2 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=4} else{$CWL[$i]=3}}
        elsif((($mr1[$i]&0b11110000)>>4)==3 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=5} else{$CWL[$i]=4}}
        elsif((($mr1[$i]&0b11110000)>>4)==4 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=7} else{$CWL[$i]=4}}
        elsif((($mr1[$i]&0b11110000)>>4)==5 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=8} else{$CWL[$i]=5}}
        elsif((($mr1[$i]&0b11110000)>>4)==6 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=9} else{$CWL[$i]=6}}
        elsif((($mr1[$i]&0b11110000)>>4)==7 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=11} else{$CWL[$i]=6}}
        elsif((($mr1[$i]&0b11110000)>>4)==8 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=12} else{$CWL[$i]=7}}
        elsif((($mr1[$i]&0b11110000)>>4)==9 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=14} else{$CWL[$i]=8}}
        elsif((($mr1[$i]&0b11110000)>>4)==10 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=15} else{$CWL[$i]=9}}
        elsif((($mr1[$i]&0b11110000)>>4)==11 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=16} else{$CWL[$i]=9}}
        else{die "<ctb_modify> Error: mr1 get wrong value.\n";}
      } else {
        if   ((($mr1[$i]&0b11110000)>>4)==0 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=2} else{$CWL[$i]=4}}
        elsif((($mr1[$i]&0b11110000)>>4)==1 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=3} else{$CWL[$i]=4}}
        elsif((($mr1[$i]&0b11110000)>>4)==2 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=4} else{$CWL[$i]=6}}
        elsif((($mr1[$i]&0b11110000)>>4)==3 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=5} else{$CWL[$i]=8}}
        elsif((($mr1[$i]&0b11110000)>>4)==4 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=7} else{$CWL[$i]=8}}
        elsif((($mr1[$i]&0b11110000)>>4)==5 ){if(($mr3[$i]&0b100000)>>5){$CWL[$i]=8} else{$CWL[$i]=10}}

        else{die "<ctb_modify> Error: mr1 get wrong value.\n";}
      }
    }
    if(defined $mr2[$i]){
      if($freq_ratio[$i] ==2){
        if   (($mr2[$i]&0b1111)==0 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=3} else{$CL[$i]=3} }
        elsif(($mr2[$i]&0b1111)==1 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=4} else {$CL[$i]=4} }
        elsif(($mr2[$i]&0b1111)==2 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=5} else {$CL[$i]=5} }
        elsif(($mr2[$i]&0b1111)==3 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=7} else {$CL[$i]=6} }
        elsif(($mr2[$i]&0b1111)==4 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=8} else {$CL[$i]=8} }
        elsif(($mr2[$i]&0b1111)==5 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=10} else {$CL[$i]=9} }
        elsif(($mr2[$i]&0b1111)==6 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=11} else {$CL[$i]=10} }
        elsif(($mr2[$i]&0b1111)==7 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=13} else {$CL[$i]=12} }
        elsif(($mr2[$i]&0b1111)==8 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=14} else {$CL[$i]=13} }
        elsif(($mr2[$i]&0b1111)==9 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=16} else {$CL[$i]=15} }
        elsif(($mr2[$i]&0b1111)==10){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=17} else {$CL[$i]=16} }
        elsif(($mr2[$i]&0b1111)==11){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=18} else {$CL[$i]=17} }
        else{die "<ctb_modify> Error: mr2 get wrong value.\n";}
      } else{
        if   (($mr2[$i]&0b1111)==0 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=6} else {$CL[$i]=6} }
        elsif(($mr2[$i]&0b1111)==1 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=8} else {$CL[$i]=8} }
        elsif(($mr2[$i]&0b1111)==2 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=10} else {$CL[$i]=10} }
        elsif(($mr2[$i]&0b1111)==3 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=14} else {$CL[$i]=12} }
        elsif(($mr2[$i]&0b1111)==4 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=16} else {$CL[$i]=16} }
        elsif(($mr2[$i]&0b1111)==5 ){if(($mr3[$i]&0b1000000)>>6){$CL[$i]=20} else {$CL[$i]=18} }
        else{die "<ctb_modify> Error: mr2 get wrong value.\n";}
      }
    }   
    if($freq_ratio[$i] ==2){
      $tWCKPRE_WFR[$i] = 1;
      #if   ($freq[$i] >> 5 && $freq[$i] <= 67) {
      if   ( $freq[$i] <= 67 ) {
      $tWCKENL_FS[$i] = 0;
      $tWCKPRE_Static[$i] = 1;
      $tWCKPRE_toggle_RD[$i] = 3;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 2
      }
      #elsif($freq[$i] >> 67 && $freq[$i] <= 133) {
      elsif($freq[$i] <= 133) {
      $tWCKENL_FS[$i] = 0;
      $tWCKPRE_Static[$i] = 1;
      $tWCKPRE_toggle_RD[$i] = 4;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 2
      }
      #elsif($freq[$i] >> 133 && $freq[$i] <= 200) {
      elsif($freq[$i] <= 200) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 1;
      $tWCKPRE_toggle_RD[$i] = 4;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 3
      }
      #elsif($freq[$i] >> 200 && $freq[$i] <= 267) {
      elsif($freq[$i] <= 267) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 2;
      $tWCKPRE_toggle_RD[$i] = 4;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 3
      }
      #elsif($freq[$i] >> 267 && $freq[$i] <= 344) {
      elsif($freq[$i] <= 344) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 2;
      $tWCKPRE_toggle_RD[$i] = 5;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 4
      }
      #elsif($freq[$i] >> 344 && $freq[$i] <= 400) {
      elsif($freq[$i] <= 400) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 2;
      $tWCKPRE_toggle_RD[$i] = 5;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 4
      }
      #elsif($freq[$i] >> 400 && $freq[$i] <= 467) {
      elsif($freq[$i] <= 467) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 3;
      $tWCKPRE_toggle_RD[$i] = 5;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 4
      }
      #elsif($freq[$i] >> 467 && $freq[$i] <= 533) {
      elsif($freq[$i] <= 533) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 3;
      $tWCKPRE_toggle_RD[$i] = 6;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 5
      }
      #elsif($freq[$i] >> 533 && $freq[$i] <= 600) {
      elsif($freq[$i] <= 600) {
      $tWCKENL_FS[$i] = 2;
      $tWCKPRE_Static[$i] = 3;
      $tWCKPRE_toggle_RD[$i] = 6;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 5
      }
      #elsif($freq[$i] >> 600 && $freq[$i] <= 688) {
      elsif($freq[$i] <= 688) {
      $tWCKENL_FS[$i] = 2;
      $tWCKPRE_Static[$i] = 4;
      $tWCKPRE_toggle_RD[$i] = 6;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 5
      }
      #elsif($freq[$i] >> 688 && $freq[$i] <= 750) {
      elsif($freq[$i] <= 750) {
      $tWCKENL_FS[$i] = 2;
      $tWCKPRE_Static[$i] = 4;
      $tWCKPRE_toggle_RD[$i] = 7;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 6
      }
      else {
      $tWCKENL_FS[$i] = 2;
      $tWCKPRE_Static[$i] = 4;
      $tWCKPRE_toggle_RD[$i] = 7;
      $tWCKPRE_toggle_WR[$i] = 2;
      $tWCKPRE_RFR[$i] = 6
      #$tWCKENL_FS[$i] = 1;
      #$tWCKPRE_Static[$i] = 2;
      #$tWCKPRE_toggle_RD[$i] = 5;
      #$tWCKPRE_toggle_WR[$i] = 2;
      #$tWCKPRE_RFR[$i] = 4
      }
      $tWCKPRE_total_WR[$i] = $tWCKPRE_toggle_WR[$i] + $tWCKPRE_Static[$i];
      $tWCKPRE_total_RD[$i] = $tWCKPRE_toggle_RD[$i] + $tWCKPRE_Static[$i]
    } else {
      $tWCKPRE_WFR[$i] = 1;
      if   ($freq[$i] <= 133) {
      $tWCKENL_FS[$i] = 0;
      $tWCKPRE_Static[$i] = 1;
      $tWCKPRE_toggle_RD[$i] = 6;
      $tWCKPRE_toggle_WR[$i] = 3;
      $tWCKPRE_WFR[$i] = 2;
      $tWCKPRE_RFR[$i] = 5
      }
      elsif($freq[$i] <= 267) {
      $tWCKENL_FS[$i] = 0;
      $tWCKPRE_Static[$i] = 2;
      $tWCKPRE_toggle_RD[$i] = 7;
      $tWCKPRE_toggle_WR[$i] = 3;
      $tWCKPRE_WFR[$i] = 2;
      $tWCKPRE_RFR[$i] = 6
      }
      elsif($freq[$i] <= 400) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 2;
      $tWCKPRE_toggle_RD[$i] = 8;
      $tWCKPRE_toggle_WR[$i] = 4;
      $tWCKPRE_WFR[$i] = 3;
      $tWCKPRE_RFR[$i] = 7
      }
      elsif($freq[$i] <= 533) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 3;
      $tWCKPRE_toggle_RD[$i] = 8;
      $tWCKPRE_toggle_WR[$i] = 4;
      $tWCKPRE_WFR[$i] = 3;
      $tWCKPRE_RFR[$i] = 7
      }
      elsif($freq[$i] <= 688) {
      $tWCKENL_FS[$i] = 1;
      $tWCKPRE_Static[$i] = 4;
      $tWCKPRE_toggle_RD[$i] = 10;
      $tWCKPRE_toggle_WR[$i] = 4;
      $tWCKPRE_WFR[$i] = 3;
      $tWCKPRE_RFR[$i] = 9
      }
      else {
      $tWCKENL_FS[$i] = 2;
      $tWCKPRE_Static[$i] = 4;
      $tWCKPRE_toggle_RD[$i] = 10;
      $tWCKPRE_toggle_WR[$i] = 4;
      $tWCKPRE_WFR[$i] = 3;
      $tWCKPRE_RFR[$i] = 9
      }
      $tWCKPRE_total_WR[$i] = $tWCKPRE_toggle_WR[$i] + $tWCKPRE_Static[$i];
      $tWCKPRE_total_RD[$i] = $tWCKPRE_toggle_RD[$i] + $tWCKPRE_Static[$i]
    
    }
  } 
  elsif($protocol eq "lpddr3") { 
    if(defined $mr2[$i]){
      if   (($mr2[$i]&0b1111)==1 ){$CL[$i]=3 ; $CWL[$i]=1}
      elsif(($mr2[$i]&0b1111)==4 ){$CL[$i]=6 ; $CWL[$i]=3}
      elsif(($mr2[$i]&0b1111)==6 ){$CL[$i]=8 ; $CWL[$i]=4}
      elsif(($mr2[$i]&0b1111)==7 ){$CL[$i]=9 ; $CWL[$i]=5}
      elsif(($mr2[$i]&0b1111)==8 ){$CL[$i]=10; $CWL[$i]=6}
      elsif(($mr2[$i]&0b1111)==9 ){$CL[$i]=11; $CWL[$i]=6}
      elsif(($mr2[$i]&0b1111)==10){$CL[$i]=12; $CWL[$i]=6}
      elsif(($mr2[$i]&0b1111)==12){$CL[$i]=14; $CWL[$i]=8}
      elsif(($mr2[$i]&0b1111)==14){$CL[$i]=16; $CWL[$i]=8}
      else{die "<ctb_modify> Error: mr2 get wrong value.\n";}
    }
    else{
      if   ($freq[$i] <= 166 ){$CL[$i]=3 ; $CWL[$i]=1}
      elsif($freq[$i] <= 400 ){$CL[$i]=6 ; $CWL[$i]=3}
      elsif($freq[$i] <= 533 ){$CL[$i]=8 ; $CWL[$i]=4}
      elsif($freq[$i] <= 600 ){$CL[$i]=9 ; $CWL[$i]=5}
      elsif($freq[$i] <= 667 ){$CL[$i]=10; $CWL[$i]=6}
      elsif($freq[$i] <= 733 ){$CL[$i]=11; $CWL[$i]=6}
      elsif($freq[$i] <= 800 ){$CL[$i]=12; $CWL[$i]=6}
      elsif($freq[$i] <= 933 ){$CL[$i]=14; $CWL[$i]=8}
      elsif($freq[$i] <= 1066){$CL[$i]=16; $CWL[$i]=8}
      else{die "<ctb_modify> Error: freq get wrong value.\n";}
    }
  } 
  elsif(($protocol eq "ddr3") || ($protocol eq "ddr3_rdimm")) { 
   if(defined $mr0[$i]) {
      if((($mr0[$i]&0b1110100)>>2)==0b00100){$CL[$i]=5;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01000){$CL[$i]=6;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01100){$CL[$i]=7;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b10000){$CL[$i]=8;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b10100){$CL[$i]=9;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b11000){$CL[$i]=10;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b11100){$CL[$i]=11;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00001){$CL[$i]=12;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00101){$CL[$i]=13;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01001){$CL[$i]=14;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01101){$CL[$i]=15;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b10001){$CL[$i]=16;}
      else{die "<ctb_modify> Error: CL not assinged.\n";}
    }
    
    if(defined $mr2[$i]){
      if((($mr2[$i]&0b111000)>>3)==0b000){$CWL[$i]=5;}
      elsif((($mr2[$i]&0b111000)>>3)==0b001){$CWL[$i]=6;}
      elsif((($mr2[$i]&0b111000)>>3)==0b010){$CWL[$i]=7;}
      elsif((($mr2[$i]&0b111000)>>3)==0b011){$CWL[$i]=8;}
      elsif((($mr2[$i]&0b111000)>>3)==0b100){$CWL[$i]=9;}
      elsif((($mr2[$i]&0b111000)>>3)==0b101){$CWL[$i]=10;}
      elsif((($mr2[$i]&0b111000)>>3)==0b110){$CWL[$i]=11;}
      elsif((($mr2[$i]&0b111000)>>3)==0b111){$CWL[$i]=12;}
      else{die "<ctb_modify> Error: CWL not assinged.\n";} 
    }
  }
  else #ddr4
  {
    
    if(defined $mr0[$i]) {
      if((($mr0[$i]&0b1110100)>>2)==0b00000){$CL[$i]=9;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00001){$CL[$i]=10;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00100){$CL[$i]=11;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00101){$CL[$i]=12;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01000){$CL[$i]=13;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01001){$CL[$i]=14;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01100){$CL[$i]=15;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01101){$CL[$i]=16;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b10000){$CL[$i]=18;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b10001){$CL[$i]=20;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b10100){$CL[$i]=22;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b10101){$CL[$i]=24;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b11000){$CL[$i]=23;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b11001){$CL[$i]=17;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b11100){$CL[$i]=19;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b11101){$CL[$i]=21;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00000){$CL[$i]=25;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00001){$CL[$i]=26;} 
      elsif((($mr0[$i]&0b1110100)>>2)==0b00100){$CL[$i]=27;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b00101){$CL[$i]=28;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01000){$CL[$i]=29;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01001){$CL[$i]=30;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01100){$CL[$i]=31;}
      elsif((($mr0[$i]&0b1110100)>>2)==0b01101){$CL[$i]=32;}
      else{die "<ctb_modify> Error: CL not assinged.\n";}
    }
    
    if(defined $mr2[$i]){
      if((($mr2[$i]&0b111000)>>3)==0b000){$CWL[$i]=9;}
      elsif((($mr2[$i]&0b111000)>>3)==0b001){$CWL[$i]=10;}
      elsif((($mr2[$i]&0b111000)>>3)==0b010){$CWL[$i]=11;}
      elsif((($mr2[$i]&0b111000)>>3)==0b011){$CWL[$i]=12;}
      elsif((($mr2[$i]&0b111000)>>3)==0b100){$CWL[$i]=14;}
      elsif((($mr2[$i]&0b111000)>>3)==0b101){$CWL[$i]=16;}
      elsif((($mr2[$i]&0b111000)>>3)==0b110){$CWL[$i]=18;}
      else{die "<ctb_modify> Error: CWL not assinged.\n";} 
    }
  }
}

if(defined $NumDbyte){$NumDbyte=sprintf("16'h%04x",$NumDbyte);}
if(defined $NumDbytesPerCh){$NumDbytesPerCh=sprintf("16'h%04x",$NumDbytesPerCh);}
if(defined $NumCh){$NumCh=sprintf("16'h%04x",$NumCh);}
if(defined $NumActiveDbyteDfi0){$NumActiveDbyteDfi0=sprintf("16'h%04x",$NumActiveDbyteDfi0);}
if(defined $NumActiveDbyteDfi1){$NumActiveDbyteDfi1=sprintf("16'h%04x",$NumActiveDbyteDfi1);}
if(defined $NumRank_dfi0){$NumRank_dfi0=sprintf("16'h%04x",$NumRank_dfi0);}
if(defined $NumRank_dfi1){$NumRank_dfi1=sprintf("16'h%04x",$NumRank_dfi1);}
if(defined $NumAnib){$NumAnib=sprintf("16'h%04x",$NumAnib);}
if(defined $Lp4xMode){$Lp4xMode=sprintf("16'h%04x",$Lp4xMode);}
if(defined $HardMacroVer){$HardMacroVer=sprintf("16'h%04x",$HardMacroVer);}
if(defined $numpstate){$numpstate_tmp=sprintf("16'h%04x",$numpstate);}
for($i=0;$i<$numpstate;$i=$i+1) {
  if(defined $freq_ratio[$i]) {$freq_ratio[$i]=sprintf("16'h%04x",$freq_ratio[$i]);}
  if(defined $mr0[$i]) {$mr0[$i]=sprintf("16'h%04x",$mr0[$i]);} 
  if(defined $mr1[$i]) {$mr1[$i]=sprintf("16'h%04x",$mr1[$i]);} 
  if(defined $mr2[$i]) {$mr2[$i]=sprintf("16'h%04x",$mr2[$i]);} 
  if(defined $mr3[$i]) {$mr3[$i]=sprintf("16'h%04x",$mr3[$i]);} 
  if(defined $mr4[$i]) {$mr4[$i]=sprintf("16'h%04x",$mr4[$i]);} 
  if(defined $mr5[$i]) {$mr5[$i]=sprintf("16'h%04x",$mr5[$i]);} 
  if(defined $mr6[$i]) {$mr6[$i]=sprintf("16'h%04x",$mr6[$i]);} 
  if(defined $mr10[$i]) {$mr10[$i]=sprintf("16'h%04x",$mr10[$i]);} 
  if(defined $mr16[$i]) {$mr16[$i]=sprintf("16'h%04x",$mr16[$i]);} 
  if(defined $mr13[$i]) {$mr13[$i]=sprintf("16'h%04x",$mr13[$i]);}
  if(defined $mr18[$i]) {$mr18[$i]=sprintf("16'h%04x",$mr18[$i]);} 
  if(defined $mr19[$i]) {$mr19[$i]=sprintf("16'h%04x",$mr19[$i]);} 
  if(defined $mr20[$i]) {$mr20[$i]=sprintf("16'h%04x",$mr20[$i]);}
  if(defined $mr22[$i]) {$mr22[$i]=sprintf("16'h%04x",$mr22[$i]);}
  if(defined $f0RC0A_D0[$i]) {$f0RC0A_D0[$i]=sprintf("16'h%04x",$f0RC0A_D0[$i]);}
  if(defined $f0RC3x_D0[$i]) {$f0RC3x_D0[$i]=sprintf("16'h%04x",$f0RC3x_D0[$i]);}
  if(defined $f0RC0D_D0[$i]) {$f0RC0D_D0[$i]=sprintf("16'h%04x",$f0RC0D_D0[$i]);}
  if(defined $f0RC0F_D0[$i]) {$f0RC0F_D0[$i]=sprintf("16'h%04x",$f0RC0F_D0[$i]);}
}

  system("rm -f ./cfg_data.sv;");
  system("touch ./cfg_data.sv; chmod 775 cfg_data.sv");
  open(my $FH_cfg_data,'>:encoding(UTF-8)',"./cfg_data.sv")or die "Could not open file 'cfg_data.sv"; 
  if(defined $NumDbyte)           {print $FH_cfg_data "NumDbyte                 = $NumDbyte;\n";}
  if(defined $NumDbytesPerCh) {print $FH_cfg_data "NumDbytesPerCh       = $NumDbytesPerCh;\n";}
  if(defined $NumCh) {print $FH_cfg_data "NumCh       = $NumCh;\n";}
  if(defined $NumActiveDbyteDfi0) {print $FH_cfg_data "NumActiveDbyteDfi0       = $NumActiveDbyteDfi0;\n";}
  if(defined $NumActiveDbyteDfi1) {print $FH_cfg_data "NumActiveDbyteDfi1       = $NumActiveDbyteDfi1;\n";}
  if(defined $NumRank_dfi0)       {print $FH_cfg_data "NumRank_dfi0             = $NumRank_dfi0;\n";}
  if(defined $NumRank_dfi1)       {print $FH_cfg_data "NumRank_dfi1             = $NumRank_dfi1;\n";}
  if(defined $NumAnib)            {print $FH_cfg_data "NumAnib                  = $NumAnib;\n";}
  if(defined $Lp4xMode)           {print $FH_cfg_data "Lp4xMode                 = $Lp4xMode;\n";}
  if(defined $HardMacroVer)       {print $FH_cfg_data "HardMacroVer             = $HardMacroVer;\n";}
                                   print $FH_cfg_data "NumPStates               = $numpstate_tmp;\n";
  if(defined $DramType)           {print $FH_cfg_data "DramType                 = CTB_$DramType;\n";}
  if(defined $DimmType)           {print $FH_cfg_data "DimmType                 = CTB_$DimmType;\n";}
  for($i=0;$i<$numpstate;$i=$i+1) { 
    if(defined $freq[$i])         {print $FH_cfg_data "Frequency[$i]             = $freq[$i];\n";}
    if(defined $CL[$i])           {print $FH_cfg_data "CL[$i]                    = $CL[$i];\n";}
    if(defined $CWL[$i])          {print $FH_cfg_data "CWL[$i]                   = $CWL[$i];\n";}
    if(defined $freq_ratio[$i])   {print $FH_cfg_data "DfiFreqRatio[$i]          = $freq_ratio[$i];\n";}
    if(defined $PllBypass[$i])    {print $FH_cfg_data "PllBypass[$i]             = $PllBypass[$i];\n";}
    if(defined $ReadDBIEnable[$i]){print $FH_cfg_data "ReadDBIEnable[$i]         = $ReadDBIEnable[$i];\n";}
    if(defined $DisDynAdrTri[$i]) {print $FH_cfg_data "DisDynAdrTri[$i]          = $DisDynAdrTri[$i];\n";}
    if(defined $Is2Ttiming[$i])   {print $FH_cfg_data "Is2Ttiming[$i]            = $Is2Ttiming[$i];\n";}
    if(defined $D4RxPreambleLength[$i]) {print $FH_cfg_data "D4RxPreambleLength[$i]    = $D4RxPreambleLength[$i];\n";}
    if(defined $D4TxPreambleLength[$i]) {print $FH_cfg_data "D4TxPreambleLength[$i]    = $D4TxPreambleLength[$i];\n";}
#    if(defined $Lp4RxPreambleMode[$i])    {print $FH_cfg_data "Lp4RxPreambleMode[$i]      = $Lp4RxPreambleMode[$i];\n";}
    if(defined $Lp4PostambleExt[$i])      {print $FH_cfg_data "Lp4PostambleExt[$i]        = $Lp4PostambleExt[$i];\n";}
    if(defined $Lp4DbiRd[$i])     {print $FH_cfg_data "Lp4DbiRd[$i]              = $Lp4DbiRd[$i];\n";}
    if(defined $Lp4DbiWr[$i])     {print $FH_cfg_data "Lp4DbiWr[$i]              = $Lp4DbiWr[$i];\n";}
    if(defined $Lp4WLS[$i])       {print $FH_cfg_data "Lp4WLS[$i]                = $Lp4WLS[$i];\n";}
    if(defined $mr0[$i])          {print $FH_cfg_data "MR0[$i]                   = $mr0[$i];\n";}
    if(defined $mr1[$i])          {print $FH_cfg_data "MR1[$i]                   = $mr1[$i];\n";}
    if(defined $mr2[$i])          {print $FH_cfg_data "MR2[$i]                   = $mr2[$i];\n";}
    if(defined $mr3[$i])          {print $FH_cfg_data "MR3[$i]                   = $mr3[$i];\n";}
    if(defined $mr4[$i])          {print $FH_cfg_data "MR4[$i]                   = $mr4[$i];\n";}
    if(defined $mr5[$i])          {print $FH_cfg_data "MR5[$i]                   = $mr5[$i];\n";}
    if(defined $mr6[$i])          {print $FH_cfg_data "MR6[$i]                   = $mr6[$i];\n";}
    if(defined $mr10[$i])         {print $FH_cfg_data "MR10[$i]                  = $mr10[$i];\n";}
    if(defined $mr16[$i])         {print $FH_cfg_data "MR16[$i]                  = $mr16[$i];\n";}
    if(defined $mr18[$i])         {print $FH_cfg_data "MR18[$i]                  = $mr18[$i];\n";}
    if(defined $mr19[$i])         {print $FH_cfg_data "MR19[$i]                  = $mr19[$i];\n";}
    if(defined $mr20[$i])         {print $FH_cfg_data "MR20[$i]                  = $mr20[$i];\n";}
    if(defined $mr13[$i])         {print $FH_cfg_data "MR13[$i]                  = $mr13[$i];\n";}
    if(defined $mr22[$i])         {print $FH_cfg_data "MR22[$i]                  = $mr22[$i];\n";}
    if(defined $f0RC0A_D0[$i])    {print $FH_cfg_data "F0RC0A_D0[$i]             = $f0RC0A_D0[$i];\n";}
    if(defined $f0RC3x_D0[$i])    {print $FH_cfg_data "F0RC3x_D0[$i]             = $f0RC3x_D0[$i];\n";}
    if(defined $f0RC0D_D0[$i])    {print $FH_cfg_data "F0RC0D_D0[$i]             = $f0RC0D_D0[$i];\n";}
    if(defined $f0RC0F_D0[$i])    {print $FH_cfg_data "F0RC0F_D0[$i]             = $f0RC0F_D0[$i];\n";}
    if($protocol eq "lpddr5") {
    if(defined $tWCKPRE_WFR[$i])          {print $FH_cfg_data "tWCKPRE_WFR[$i]            = $tWCKPRE_WFR[$i];\n";}
    if(defined $tWCKPRE_RFR[$i])          {print $FH_cfg_data "tWCKPRE_RFR[$i]            = $tWCKPRE_RFR[$i];\n";}
    if(defined $tWCKENL_FS[$i])          {print $FH_cfg_data "tWCKENL_FS[$i]            = $tWCKENL_FS[$i];\n";}
    if(defined $tWCKPRE_Static[$i])      {print $FH_cfg_data "tWCKPRE_Static[$i]        = $tWCKPRE_Static[$i];\n";}
    if(defined $tWCKPRE_toggle_RD[$i])   {print $FH_cfg_data "tWCKPRE_toggle_RD[$i]     = $tWCKPRE_toggle_RD[$i];\n";}
    if(defined $tWCKPRE_toggle_WR[$i])   {print $FH_cfg_data "tWCKPRE_toggle_WR[$i]     = $tWCKPRE_toggle_WR[$i];\n";}
    if(defined $tWCKPRE_total_WR[$i])    {print $FH_cfg_data "tWCKPRE_total_WR[$i]      = $tWCKPRE_total_WR[$i];\n";}
    if(defined $tWCKPRE_total_RD[$i])    {print $FH_cfg_data "tWCKPRE_total_RD[$i]      = $tWCKPRE_total_RD[$i];\n";}
    }
  }

  if(defined $Train2D)          {print $FH_cfg_data "Train2D                  = $Train2D;\n";}
  if(defined $Dfi1Exists)       {print $FH_cfg_data "Dfi1Exists               = $Dfi1Exists;\n";}
  if(defined $DfiMode)          {print $FH_cfg_data "DfiMode                  = $DfiMode;\n";}
  if(defined $DramDataWidth)    {print $FH_cfg_data "DramDataWidth            = $DramDataWidth;\n";}
  if(defined $DramByteSwap)     {print $FH_cfg_data "DramByteSwap             = $DramByteSwap;\n";}
  if(defined $RxEnBackOff)      {print $FH_cfg_data "RxEnBackOff              = $RxEnBackOff;\n";}

  if(defined $CsPresent)        {print $FH_cfg_data "CsPresent                = $CsPresent;\n";}
  if(defined $AddrMirror)       {print $FH_cfg_data "AddrMirror               = $AddrMirror;\n";}
  if(defined $EnabledDQs)       {print $FH_cfg_data "EnabledDQs               = $EnabledDQs;\n";}
  if(defined $CsSetupGDDec)     {print $FH_cfg_data "CsSetupGDDec             = $CsSetupGDDec;\n";}
  if(defined $UseBroadcastMR)   {print $FH_cfg_data "UseBroadcastMR           = $UseBroadcastMR;\n";}
  if(defined $X8Mode)           {print $FH_cfg_data "X8Mode                   = $X8Mode;\n";}
  if(defined $DisableFspOp)     {print $FH_cfg_data "DisableFspOp             = $DisableFspOp;\n";}
  if(defined $WDQSExt)          {print $FH_cfg_data "WDQSExt                  = $WDQSExt;\n";}
  if(defined $FirstPState)      {print $FH_cfg_data "FirstPState              = $FirstPState;\n";}
  if(defined $TestsToRun)       {print $FH_cfg_data "TestsToRun              = $TestsToRun;\n";}

 close $FH_cfg_data; 
 print "<ctb_utils> the cfg_data.sv file generated successfully\n";
}

sub gen_release_flist{
  system("rm -f ./rtl_rel.f;");
  system("touch ./rtl_rel.f; chmod 775 rtl_rel.f");
  open(my $FH_flist,'>:encoding(UTF-8)',"./rtl_rel.f")or die "Could not open file 'rtl_rel.f";
  my $_ =`ls $ENV{CTB_HOME}/../..`;
  if ((!defined $ENV{CORETOOLS}) || ($ENV{CORETOOLS} == 1)) {
    print $FH_flist "\n-f $ENV{CTB_HOME}/../../src/dwc_ddrphy_top.lst\n";
    if (!-d "$ENV{CTB_HOME}/../../master/Latest/rtl" && !-d "$ENV{CTB_HOME}/../../master_ns/Latest/rtl" && !-d "$ENV{CTB_HOME}/../../master_ew/Latest/rtl") {
        print $FH_flist "-y $ENV{BUILD_DIR}/d2c/rtl\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_cdc_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_rtl_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_se_rx_base.v\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_diff_rx_base.v\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_cmdfifo.v\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_dbyte_dig.v\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_lcdl.v\n";
        print $FH_flist "-v $ENV{BUILD_DIR}/d2c/rtl/dwc_ddrphy_repeater_blocks.v\n";
    }
  } else {
    print $FH_flist '${BUILD_PATH}';
    print $FH_flist "\n$ENV{CTB_HOME}/../../macro/Latest/rtl/dwc_ddrphy_dbyte_wrapper.v\n";
    print $FH_flist "\n$ENV{CTB_HOME}/../../macro/Latest/rtl/dwc_ddrphy_ac_wrapper.v\n";
    print $FH_flist "\n$ENV{CTB_HOME}/../../macro/Latest/rtl/dwc_ddrphy_top.v\n";
    print $FH_flist "-v $ENV{CTB_HOME}/../../pub/Latest/rtl/dwc_ddrphy_premap_do_not_synthesize.v\n";
    print $FH_flist "-v $ENV{CTB_HOME}/../../pub/Latest/rtl/dwc_ddrphy_dbyte_dig.v\n";
    print $FH_flist "-y $ENV{CTB_HOME}/../../pub/Latest/rtl\n";
  }
  if (-d "$ENV{CTB_HOME}/../../master/Latest/rtl" || -d "$ENV{CTB_HOME}/../../master_ns/Latest/rtl" || -d "$ENV{CTB_HOME}/../../master_ew/Latest/rtl") {    
      if(/(sec.*)/) {
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/rtl\n";
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/behavior\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_rtl_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cdc_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cmdfifo.v\n";
        if (-e "$ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_lcdl.v") {
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_lcdl.v\n";
        } else {
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_lcdl.v\n";
        }
      } 
      if( (m/(^se$)/) || (m/(se_.*)/) ) {
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/rtl\n";
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/behavior\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_rtl_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cdc_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cmdfifo.v\n";
        if (-e "$ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_lcdl.v") {
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_lcdl.v\n";
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_se_rx_base.v\n";
        } else {
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_lcdl.v\n";
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_se_rx_base.v\n";
        }
      } 
      if(/(diff.*)/) {
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/rtl\n";
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/behavior\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_rtl_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cdc_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cmdfifo.v\n";
        if (-e "$ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_lcdl.v") {
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_lcdl.v\n";
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/behavior/dwc_ddrphy_diff_rx_base.v\n";
        } else {
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_lcdl.v\n";
          print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_diff_rx_base.v\n";
        }
      } 
      if(/(master.*)/) {
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/rtl\n";
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/behavior\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_rtl_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cdc_syn_stdlib.v\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_cmdfifo.v\n";
      }
      if(/(repeater_blocks.*)/) {
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/rtl\n";
        print $FH_flist "-y $ENV{CTB_HOME}/../../$1/Latest/behavior\n";
        print $FH_flist "-v $ENV{CTB_HOME}/../../$1/Latest/rtl/dwc_ddrphy_repeater_blocks.v\n";
      }
  } 

  if ((defined $ENV{CORETOOLS}) && ($ENV{CORETOOLS} == 0)) {
    my $stdlib_file = "$ENV{CTB_HOME}/../../pub/Latest/rtl/dwc_ddrphy_premap_do_not_synthesize.v";
    if(-e $stdlib_file) {
    print $FH_flist "-v $ENV{CTB_HOME}/../../pub/Latest/rtl/dwc_ddrphy_premap_do_not_synthesize.v\n";
    } else {
    print $FH_flist "-v $ENV{CTB_HOME}/../../pub/Latest/rtl/dwc_ddrphy_rtl_syn_stdlib_pub.v\n";
    print $FH_flist "-v $ENV{CTB_HOME}/../../pub/Latest/rtl/dwc_ddrphy_cdc_syn_stdlib_pub.v\n";
    }
  }
  close $FH_flist;
}

