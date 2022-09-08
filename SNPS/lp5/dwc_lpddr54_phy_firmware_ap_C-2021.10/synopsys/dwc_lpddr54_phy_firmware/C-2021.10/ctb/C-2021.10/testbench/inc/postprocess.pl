#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use File::Spec;

my $file;
my $all = 0;
my $install_dir = "./.fw/lpddr4/userCustom";
my $debug = 1;
my $gatesim = 0;
my $skip_train = 1;
my %opts;

GetOptions(\%opts,
  "file|f=s" => \$file,
  "all" => \$all, 
  "install_dir=s" => \$install_dir,
  "debug|d" => \$debug,
  "gatesim" => \$gatesim, 
  "skip_train|d=s"  => \$skip_train 
  );

print"<postprocess> skip_train = $skip_train\n";
my $log = "postprocess.log";
my $log_path = File::Spec->rel2abs( $log);    #absolute path
open DEBUG, ">$log_path" or die "cannot create $log_path:$!\n";

### PHYINIT variables
# user_input_basic
my $dram_type       = "DDR3";     # dram type
my $dimm_type       = "UDIMM";    # dimm type
my $num_dbyte       = 0;
my $num_anib        = 0;
my $num_rank        = 1;
my @num_rank_dfi    = (0,0);      # per-dfi
my $dram_datawidth  = 0;
my $num_pstates     = 1;
my $CfgPStates      = 1;
my @Frequency       = (0,0,0,0);  # per-pstate
my @PllBypass       = (0,0,0,0);  # per-pstate
my @DllEnable       = (1,1,1,1);  # per-pstate
my @dfi_freq_ratio  = (0,0,0,0);  # per-pstate
my @ReadDBIEnable   = (0,0,0,0);  # per-pstate, 1: Read DBI enable, 0: Read DBI disable
my $dfi1_exists     = 0;  
my $dfi_mode        = 0;  
my $disable2d       = 1;
my $Lp4xMode        = 0;
my @vrcg            = (0,0,0,0);
my @fsp_op          = (0,0,0,0);
my @fsp_wr          = (0,0,0,0);

# user_input_advanced
#my @Lp4RxPreambleMode = (1,1,1,1); # per-pstate, Read preamble 0: static, 1: toggle
my @Lp4RxPostambleMode = (1,1,1,1); # per-pstate, Read postamble 0: 0.5tCK, 1: 1.5tCK 
my @Lp4PostambleExt  = (1,1,1,1);  # per-pstate, Write postamble 0: 0.5tCK, 1: 1.5tCK
my @D4RxPreambleLength= (0,0,0,0); # per-pstate, 0: 1nCK, 1: 2nCK
my @D4TxPreambleLength= (0,0,0,0); # per-pstate, 0: 1nCK, 1: 2nCK
my @is2t             = (0,0,0,0); # per-pstate
my $FirstPState      = 0; #DRAM fisrt mission pstate.
my $wdqsext          = 0;
my $RxEnBackOff      = 0;
#my $Lp4Quickboot     = 0;
my @Lp4DbiRd         = (0,0,0,0); # MR3[6], per-pstate LPDDR4 only
my @Lp4DbiWr         = (0,0,0,0); # MR3[7], per-pstate LPDDR4 only
my @Lp4nWR           = (0,0,0,0); # MR1[6:4], per-pstate LPDDR4 only
my @Lp4WL            = (0,0,0,0); # MR2[5:3], per-pstate LPDDR4 only
my @Lp4RL            = (0,0,0,0); # MR2[2:0], per-pstate LPDDR4 only
my @Lp4WLS           = (0,0,0,0); # per-pstate, LPDDR4 only
my @DFIMRLMargin     = (0,0,0,0); # per-pstate
my @Lp5WL            = (0,0,0,0); # MR1[7:4], per-pstate LPDDR5 only
my @Lp5RL            = (0,0,0,0); # MR2[3:0], per-pstate LPDDR5 only
my $fsp_disable     = 0;
my $DisablePmuEcc   = 0;
my $DisableRetraining = 0; # < Disable PHY DRAM Drift compensation re-training
my @OdtImpedanceDqs = (0,0,0,0);
my @TxImpedanceDq = (0,0,0,0);
my @TxImpedanceAc = (0,0,0,0);
my @TxImpedanceCs = (0,0,0,0);
my @TxImpedanceCk = (0,0,0,0);
my @TxImpedanceDqs = (0,0,0,0);
my @TxImpedanceWCK = (0,0,0,0);

# user_input_sim
my $tDQS2DQ          = 0;
my $PHY_tDQS2DQ      = 312;
my $tWCK2DQO         = 0;
my $tWCK2DQI         = 0;
my $tDQSCK           = 0;
my @tSTAOFF          = (0,0,0,0); # per-pstate
my @tPDM             = (0,0,0,0); # per-pstate

# user_input_snps_internal

### Message block variables
# all mb info are per-pstate
# (MsgMisc[7-6] RFU, must be zero, MsgMisc[5], MsgMisc[4], MsgMisc[3], MsgMisc[2], MsgMisc[1], MsgMisc[0])
my $disabled_dbyte = 0;
my $num_active_dbyte_dfi0 = 0;
my $num_active_dbyte_dfi1 = 0;
my $cspresent    = 0;
my $cspresent_cha = 0;
my $cspresent_chb = 0;
my $enableddqs_cha = 0;
my $enableddqs_chb = 0;
my $cspresent_d0  = 0;
my $cspresent_d1  = 0;
my $SequenceCtrl  = 0;
my $SequenceCtrl_2d  = 0;
my $MRLCalcAdj  = 0;
my $hdtctrl       = 0;
my $x16present    = 0;
my @CsSetupGDDec  = (0,0,0,0);
my @PhyCfg        = (0,0,0,0); # per-pstate, DDR4 only, for 2T timing training
my $Misc       = 0; 
my $CATrainOpt    = 0; 
my $addrmirror    = 0;
my @VrefDq        = (0,0,0,0);  # per-pstate, DDR4 only
my @VrefCa        = (0,0,0,0);  # per-pstate, DDR4 only
my @tCCD_L        = (0,0,0,0);  # per-pstate, DDR4 only
# 2D train
my $CATerminatingRankChA = 0; # 0: rank0 is terminating rank, 1: rank1 is terminating rank
my $CATerminatingRankChB = 0; # 0: rank0 is terminating rank, 1: rank1 is terminating rank
my @alt_cl        = (0,0,0,0); # per-pstate ALT_CAS_L
my @alt_cwl       = (0,0,0,0); # per-pstate ALT_WCAS_L
my @Lp4PDDS       = (0,0,0,0); # per-pstate
my @Lp4CaOdt      = (0,0,0,0); # per-pstate
my @DqOdt         = (0,0,0,0); # LPDDR3/4 only, per-pstate
my @Lp3DS         = (0,0,0,0); # per-pstate
my @Lp3PDControl  = (0,0,0,0); # per-pstate

# RCD
my $F0RC00        = 0;
my $F0RC01        = 0;
my $F0RC08        = 0;
my $F0RC0A        = 0;
my $F0RC0D        = 0;
my $F0RC0E        = 0;
my $F0RC0F        = 0;
my $F0RC3x        = 0;
my $F0RC0D_D0     = 0;
my $F0RC0D_D1     = 0; 
# DB
my $BC00          = 0;
my $BC01          = 0;
my $BC02          = 0;
my $BC03          = 0;
my $BC04          = 0;
my $BC05          = 0;
my $BC0A          = 0;
my $F5BC5x        = 0;
my $F5BC6x        = 0;
my $F0BC6x        = 0;

### internal variables
my @rd_latency    = (0,0,0,0);  # per-pstate
my @wr_latency    = (0,0,0,0);  # per-pstate
my $csMode        = 0;  # for DDR4/3PHY 0: Direct DualCS, 1: Direct QuadCS, 2: reserved, 3: Encoded QuadCS (DDR4-only)
                        # for LPDDR4_multiphy_v2, only one operating mode (Direct DualCS)
my @TDQS          = (0,0,0,0);  # per-pstate
my @DM            = (0,0,0,0);  # per-pstate
my @RDBI          = (0,0,0,0);  # per-pstate
my @WDBI          = (0,0,0,0);  # per-pstate

my $BK_ORG        = 0x01;    #   00: 4Bank / 4Bank Group ;  01: 8 Bank;  10: 16 Bank
my $RDQS          = 0x02;  # RDQS_t and RDQS_c enabled
my @WCK_ON        = (0x01,0x01,0x01,0x01);   # WCK Always On Mode. 0:disable  1:enable
my @wck_fm        = (0,0,0,0);  # WCK frequency mode. 0: low frequency mode(default), 1: High frequency mode. WCK Low Frequency mode should be used up to 3200Mbps data rates
my @CKR           = (0,0,0,0);     # WCK to CK frequency ratio . 0: 4:1; 1: 2:1;
my @WLS           = (0,0,0,0);     # 0:Write Latency Set "A"; 1: Write Latency Set "B" 
my @WCK_PST       = (0x01,0x01,0,0);
my @RDQS_PST      = (0x01,0x01,0,0);
my @RDQS_PRE      = (0x01,0x01,0,0);
# cs populate per-rank
# 0 "unpopulated" 
# 1 "connected to PCB" 
# 2 "connected to PCB with address-mirroring" 
# 3 "connected to DIMM0" 
# 4 "connected to DIMM0 with address-mirroring" 
# 5 "connected to DIMM1" 
# 6 "connected to DIMM1 with address-mirroring"
my @cs_pop         = (0,0,0,0);  # per-rank
my @rttNom         = (0,0,0,0);  # per-pstate
my @rttPark        = (0,0,0,0);  # per-pstate
my @rttWr          = (0,0,0,0);  # per-pstate
my $addrmirror_d0  = 0;
my $addrmirror_d1  = 0;
my $train_enable   = 0;
my @BypassPclkFrequency = (0,0,0,0);  # per-pstate
my @Dfi_Frequency    = (0,0,0,0);  # per-pstate
my @DfiCtl_Frequency = (0,0,0,0);  # per-pstate
my @Lp3nWR           = (0,0,0,0);  # MR1[7:5], per-pstate LPDDR3 only
my @Lp3nWRE          = (0,0,0,0);  # MR2[4], per-pstate LPDDR3 only
my @Lp3WLS           = (0,0,0,0);  # MR2[6], per-pstate, LPDDR3 only, default 0
my @Lp3RLWL          = (0,0,0,0);  # MR2[3:0], per-pstate, LPDDR3 only, default 0
my @D4RL             = (0,0,0,0);  # MR0[12,6:4,2], per-pstate, DDR4 only
my @D4WL             = (0,0,0,0);  # MR2[5:3], per-pstate
my @D4WR_RTP         = (0,0,0,0);  # MR0[13,11:9], write recovery and read to precharge, per-pstate, DDR4 only
my @D3RL             = (0,0,0,0);  # MR0[3:0], per-pstate, DDR3 only, default 0
my @D3WL             = (0,0,0,0);  # MR0[3:0], per-pstate, DDR3 only, default 0
my @RTT_NOM          = (0,0,0,0);  # per-pstate
my @RTT_WR           = (0,0,0,0);  # per-pstate
my @RTT_PARK         = (0,0,0,0);  # per-pstate

# VDEFINE params
my $PIPE_DFI         = 0;  # RD,WR,MISC, 0-3

### MR value
my @ALT_CAS_L   = (0,0,0,0); # DDR4 only
my @ALT_WCAS_L  = (0,0,0,0); # DDR4 only
my @MR0  = (0,0,0,0);
my @MR1  = (0,0,0,0);
my @MR2  = (0,0,0,0);
my @MR3  = (0,0,0,0);
my @MR4  = (0,0,0,0);
my @MR5  = (0,0,0,0);
my @MR6  = (0,0,0,0);
my @MR10  = (0,0,0,0);
my @MR11  = (0,0,0,0);
my @MR12  = (0,0,0,0);
my @MR13  = (0,0,0,0);
my @MR14  = (0,0,0,0);
my @MR16  = (0,0,0,0);
my @MR17  = (0,0,0,0);
my @MR18  = (0,0,0,0);
my @MR19  = (0,0,0,0);
my @MR20  = (0,0,0,0);
my @MR22  = (0,0,0,0);
my @MR24  = (0,0,0,0);

########################################
# Main-routine
########################################
# 1. parse result file to get params, and store into a hash
#    keep the key of hash the same as the PHYINIT/MB inputs variables.
&parse_params($file);
# 2. generate and calc all variables based on the hash, including:
#    MRs of different frequency based on protocol
#    RCD registers
#    DB registers
#    Other related variables
&calc_configs;
# 3. modify override .c files based on customer's setting
&write_out_override_cfile;
## 4. writeout switch files for UVM QA purpose
if ($all) {
  &write_out_uvm_switch_file;
}

print "<postprocess> Postprocess Done\n" if $debug;
close (DEBUG);

########################################
# Sub-routines
########################################
# Parsing file
sub parse_params {
  my $file = $_[0];
  my $file_path = File::Spec->rel2abs( $file );    #absolute path
  open( my $fh, "<", $file_path ) or die "File cannot be read: " . $file_path;
  print "<postprocess> Start parse params from $file_path\n" if $debug; 

  while ( my $row = <$fh> ) {
    chomp $row;
    $row =~ s/#.*//g;
    $row =~ s/[\s;]+$//g;
  
    my $title;
    my $value;
    if ( $row =~ /^set_configuration_parameter/ ) {
      my @row_arr = split( /[\s]+/, $row, 3 );
      $title = $row_arr[1];
      $value = $row_arr[2];
    }
    elsif ( $row =~ /^set_activity_parameter PHYInitializationsettings/ ) {
      my @row_arr = split( /[\s]+/, $row, 4 );
      $title = $row_arr[2];
      $value = $row_arr[3];
    }
    else {
      next;
    }
    
    $value =~ s/^{//g;
    $value=~ s/}$//g;
    $title =~ s/^userInputBasic_/userInputBasic./g;
    $title =~ s/^userInputAdvanced_/userInputAdvanced./g;
    $title =~ s/^userInputSim_/userInputSim./g;
    $title =~ s/^((userInputBasic|userInputAdvanced|userInputSim)\..*[a-zA-Z])([0-3])$/$1\[$3\]/g;
    $title =~ s/^(mb_DDR4U_[1-2]D)([0-3])_/$1\[$2\]./g;

    # decode some coreTools's output into PHYINIT/MB inputs
    if ($title =~ /^userInput/) {
      if ( $title =~ /^userInputBasic.DramType$/ ) {
        $dram_type=$value;
        print DEBUG "Capture params: userInputBasic.DramType = $dram_type\n" if $debug;
      }
      elsif ( $title =~ /^userInputBasic.DimmType$/ ) {
        $dimm_type=$value;
        print DEBUG "Capture params: userInputBasic.DimmType = $dimm_type\n" if $debug;
      }
      elsif ( $title =~ /^userInputBasic.Lp4xMode$/ ) {
        $Lp4xMode=$value;
      }
      elsif ( $title =~ /^userInputAdvanced.DisablePmuEcc$/ ) {
        $DisablePmuEcc=$value;
      }
      elsif ( $title =~ /^userInputAdvanced.DisableRetraining$/ ) {
        $DisableRetraining=$value;
      }
      elsif ( $title =~ /^userInputBasic.Dfi1Exists$/) {
        $dfi1_exists = $value; 
      }
      elsif ( $title =~ /^userInputBasic.DramDataWidth$/) {
        $dram_datawidth = $value;
      }
      elsif ( $title =~ /^userInputBasic.Frequency\[([0-3])\]$/ ) {
        my $p = $1;
        $Frequency[$p] = $value;
        if ( $Frequency[$p] > 0) {
          $PllBypass[$p] = 0;
        }
        else {
          $PllBypass[$p] = 1;
        }
        print DEBUG "Capture params: userInputBasic.PllBypass[$p] = $PllBypass[$p]\n" if $debug;
      }
      elsif ( $title =~ /^userInputBasic.PllBypass\[([0-3])\]$/) {
        my $p = $1;
        $PllBypass[$p] = $value;
        #if( $PllBypass[$p] > 0){
        #  $DllEnable[$p] = 0;
        #}
        #else {
        #  $DllEnable[$p] = 1;
        #} 
      }
      elsif ( $title =~ /^userInputBasic.NumDbyte$/) {
        $num_dbyte = $value;
      }
      elsif ( $title =~ /^userInputBasic.NumAnib$/) {
        $num_anib = $value;
      }
      elsif ( $title =~ /^userInputBasic.NumActiveDbyteDfi\[0\]$/) {
        $num_active_dbyte_dfi0 = $value;
      }
      elsif ( $title =~ /^userInputBasic.NumActiveDbyteDfi\[1\]$/) {
        $num_active_dbyte_dfi1 = $value;
      }
      elsif ($title =~ /userInputBasic.NumRank$/) {
        $num_rank = $value;
      }
      elsif ($title =~ /userInputBasic.NumRank_dfi\[([0-1])\]$/) {
        $num_rank_dfi[$1] = $value;
        $title =~ s/[\[\]]//g;  # remove []
      }
      elsif ( $title =~ /^userInputBasic.NumPStates$/) {
        $num_pstates = $value;
      }
      elsif ( $title =~ /^userInputBasic.CfgPStates$/) {
        $CfgPStates = $value;
      }
      elsif ( $title =~ /^userInputBasic.DfiFreqRatio\[([0-3])\]$/) {
        my $p = $1;
        $dfi_freq_ratio[$p] = $value;
      }
      elsif ( $title =~ /^userInputBasic.\[([0-3])\]$/) {
        my $p = $1;
        $dfi_freq_ratio[$p] = $value;
      }
      elsif ( $title =~ /^userInputBasic.DfiMode$/) {
        $dfi_mode = $value;
      }
      # fsp disable
      elsif ( $title =~ /^userInputBasic.DisableFspOp$/ ) {
        $fsp_disable = $value;
        #if($value == 0){
          @vrcg   = (0x0,0x1,0x0,0x0);
          @fsp_op = (0x0,0x1,0x0,0x0);
          @fsp_wr = (0x0,0x1,0x0,0x0);
          #} 
      }
      # wck_free
      elsif ( $title =~ /^userInputBasic.WckFree\[([0-3])\]$/ ) {
        my $p = $1;
        $WCK_ON[$p] = $value;
      }
      # DDR4 or LPDDR4
      elsif ($title =~ /^userInputBasic.RDBI\[([0-3])\]$/) {
        my $p = $1;
        $RDBI[$p] = $value;
        $Lp4DbiRd[$p] = $value;
      } 
      elsif ($title =~ /^userInputBasic.WDBI\[([0-3])\]$/) {
        my $p = $1;
        $WDBI[$p] = $value;
        $Lp4DbiWr[$p] = $value;
      } 
      elsif ($title =~ /^userInputBasic.DM\[([0-3])\]$/) {
        my $p = $1;
        $DM[$p] = hex($value);
      } 
      elsif ($title =~ /userInputAdvanced.D4RxPreambleLength\[([0-3])\]$/) {
        $D4RxPreambleLength[$1] = $value;
      }
      elsif ($title =~ /userInputAdvanced.D4TxPreambleLength\[([0-3])\]$/) {
        $D4TxPreambleLength[$1] = $value;
      }
      #elsif ($title =~ /userInputAdvanced.Lp4RxPreambleMode\[([0-3])\]$/) {
      #  $Lp4RxPreambleMode[$1] = $value;
      #}
      #elsif ($title =~ /userInputAdvanced.Lp4RxPostambleMode\[([0-3])\]$/) {
      #  $Lp4RxPostambleMode[$1] = $value;
      #}
      elsif ($title =~ /userInputAdvanced.Lp4PostambleExt\[([0-3])\]$/) {
        $Lp4PostambleExt[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.Is2Ttiming\[([0-3])\]$/) {
        $is2t[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.OdtImpedanceDqs\[([0-3])\]$/) {
        $OdtImpedanceDqs[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.TxImpedanceDq\[([0-3])\]$/) {
        $TxImpedanceDq[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.TxImpedanceAc\[([0-3])\]$/) {
        $TxImpedanceAc[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.TxImpedanceDqs\[([0-3])\]$/) {
        $TxImpedanceDqs[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.TxImpedanceCk\[([0-3])\]$/) {
        $TxImpedanceCk[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.TxImpedanceCs\[([0-3])\]$/) {
        $TxImpedanceCs[$1] = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.TxImpedanceWCK\[([0-3])\]$/) {
        $TxImpedanceWCK[$1] = $value;
      }
      elsif ($title =~ /userInputBasic.FirstPState$/) {
        $FirstPState = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.WDQSExt$/) {
        $wdqsext = $value;
      }
      elsif ( $title =~ /^userInputAdvanced.RxEnBackOff$/) {
        $RxEnBackOff = $value;
      }
     # elsif ( $title =~ /^userInputAdvanced.Lp4DbiRd\[([0-3])\]$/) {
     #   $Lp4DbiRd[$1] = $value;
     # }
      elsif ( $title =~ /^userInputAdvanced.Lp4DbiWr\[([0-3])\]$/) {
        $Lp4DbiWr[$1] = $value;
      }
#      elsif ( $title =~ /^userInputAdvanced_Lp4Quickboot$/) {
#        $Lp4Quickboot = $value;
#      }
      elsif ($title =~ /userInputAdvanced.DFIMRLMargin\[([0-3])\]$/) {
        $DFIMRLMargin[$1] = $value;
      }

      elsif ( $title =~ /^userInputSim.tDQS2DQ$/) {
        $tDQS2DQ = $value;
      }
      elsif ( $title =~ /^userInputSim.PHY_tDQS2DQ$/) {
        $PHY_tDQS2DQ = $value;
      }
      elsif ( $title =~ /^userInputSim.tWCK2DQO$/) {
        $tWCK2DQO = $value;
      }
      elsif ( $title =~ /^userInputSim.tWCK2DQI$/) {
        $tWCK2DQI = $value;
      }
      elsif ( $title =~ /^userInputSim.tDQSCK$/) { 
        $tDQSCK = $value;
        $title = "userInputSim.tDQSCK";
      }
      elsif ( $title =~ /^userInputSim.tSTAOFF\[([0-3])\]$/) {
        $tSTAOFF[$1] = $value;
      }
      elsif ( $title =~ /^userInputSim.tPDM\[([0-3])\]$/) {
        $tPDM[$1] = $value;
      }
      else {
        print DEBUG "WARNING: get a new PHYINIT params: $title = $value\n" if $debug;
      }

      print DEBUG "Capture PHYINIT params: $title = $value\n" if $debug;
    }
    else {
      #########################################
      # create mb and other variables
      # These variables will calculate phyinit/mb inputs in sub derive_configs
      if ( $title =~ /^mb_SequenceCtrl$/) {
        $SequenceCtrl = hex($value);
      }
      elsif ( $title =~ /^mb_MRLCalcAdj$/) {
        $MRLCalcAdj = hex($value);
      }
      elsif ( $title =~ /^mb_Disable2D$/ ) {
        $disable2d = $value;
      }
      elsif ( $title =~ /^mb_HdtCtrl$/) {
          $hdtctrl = hex($value);
      }
      elsif ( $title =~ /mb_DDR4U_1D\[([0-3])\]_CsSetupGDDec/ ) {
        $CsSetupGDDec[$1] = $value;
      }
      elsif ( $title =~ /CATrainOpt/ ) {
        $CATrainOpt= $value;
      }
      elsif ( $title =~ /Misc/ ) {
        $Misc = $value;
      }
      elsif ($title =~ /^csMode/) {
        $csMode = $value; 
      }
      elsif ( $title =~ /^rttNom([0-3])$/ ) { #DDR4
        $rttNom[$1] = $value;
      }
      elsif ( $title =~ /^rttPark([0-3])$/ ) { #DDR3/4
        $rttPark[$1] = $value;
      }
      elsif ( $title =~ /^rttWr([0-3])$/ ) { #DDR3/4
        $rttWr[$1] = $value;
      }
      elsif ( $title =~ /^pdds([0-3])$/ ) { #DDR4
        $Lp4PDDS[$1] = $value;
      }
      elsif ( $title =~ /^caODT([0-3])$/ ) { #DDR4
        $Lp4CaOdt[$1] = $value;
      }
      elsif ( $title =~ /^dqODT([0-3])$/ ) { #DDR4
        $DqOdt[$1] = $value;
      }
      elsif ( $title =~ /^ds([0-3])$/ ) { #DDR4
        $Lp3DS[$1] = $value;
      }
      elsif ( $title =~ /^pdCtrl([0-3])$/ ) { #DDR4
        $Lp3PDControl[$1] = $value;
      }
      elsif ( $title =~ /^cs([0-3])Pop$/) {
        $cs_pop[$1] = $value;
        my $rank = $1;
        if ($value != 0) {
          $cspresent |= 1<<$rank; # DDR3/4 in DDR3/4PHY
        }
        if ( $value == 3 || $value == 4) {
          $cspresent_d0 |= 1<<$rank;
        }
        elsif ( $value  == 5 || $value == 6) {
          $cspresent_d1 |= 1<<$rank;
        }
        if ($value ==2 || $value ==4 || $value == 6) {
          $addrmirror |= 1<<$rank;
          if ($value == 4 ) {
            $addrmirror_d0 = 1;
          }
          elsif ($value == 6) {
            $addrmirror_d1 = 1;
          }
        }
      }
      elsif ($title =~ /cs([0-3])AddrMirrorV2$/) { #LPDDRx only
        $addrmirror |= $value<<$1;
      }
      elsif ( $title =~ /^vrefControl_([0-3])$/) {
        my $p = $1;
        my $vrefControl = $value; # Note: no need this param, here just avoid warning 
      }
      elsif ( $title =~ /^caVrefSetting_([0-3])$/) {
        my $p = $1;
        if($value <= 30) {
          $VrefCa[$p] = (10*$value - 100)/4;  # multiply by 10 to avoid float issue in perl 
          $VrefCa[$p] |= 0<<6; 
        }
        elsif(($value > 30) && ($value <=42)){
          $VrefCa[$p] = (10*$value - 100)/4; 
          $VrefCa[$p] |= 1<<6; 
        }
        $VrefCa[$p] =  int($VrefCa[$p]);
      }
      elsif ($title =~ /TrainEnable/) {
        $train_enable = $value;
      }
      elsif ($title =~ /CATerminatingRank([0-3])ChA$/) {
        $CATerminatingRankChA |= $value<<$1;
      }
      elsif ($title =~ /CATerminatingRank([0-3])ChB$/) {
        $CATerminatingRankChB |= $value<<$1;
      }
      elsif ($title =~ /\[([0-3])\]\.ALT_CAS_L/) {
        my $p = $1;
        if ($value =~ /^unset - MR0 value will be used$/) {
          $value = 0;
        }
        $alt_cl[$p] = $value;
      }
      elsif ($title =~ /\[([0-3])\]\.ALT_WCAS_L/) {
        my $p = $1;
        if ($value =~ /^unset - MR2 value will be used$/) {
          $value = 0;
        }
        $alt_cwl[$p] = $value;
      }
      elsif ($title =~ /DWC_DDRPHY_PIPE_DFI/) {
        $PIPE_DFI = $value;
      }
      elsif ($title =~ /^BypassPclkFrequency([0-3])$/) {
        if ($value !~ /^\s*$/) {
          $BypassPclkFrequency[$1] = $value;
        }
      }
      elsif ($title =~ /^Dfi_Frequency([0-3])$/) {
        $Dfi_Frequency[$1] = $value;
      }
      elsif ($title =~ /^DfiCtl_Frequency([0-3])$/) {
        $DfiCtl_Frequency[$1] = $value;
      }
      else {
        print DEBUG "WARNING: get a new params: $title = $value\n" if $debug;
        next;
      }

      print DEBUG "Capture params: $title = $value\n" if $debug;

    }
  } # while
} # sub parse_params

# other varaibles derive from known variables from parse_params
sub calc_configs {
  print "<postprocess> Start calc all configs\n" if $debug; 

  print DEBUG "Capture params: userInputBasic.NumPStates = $num_pstates\n" if $debug;
  #foreach my $p (0..$num_pstates-1) {
  #  if ($PllBypass[$p] == 1) {
  #    $Frequency[$p] = $BypassPclkFrequency[$p];
  #    print DEBUG "Capture params: userInputBasic.Frequency[$p] = $Frequency[$p]\n" if $debug;
  #  }
  #}

 
  # LPDDR4 only
  # If 1, set all applicable (i.e., corresponding to existing DBYTEs) bits to 1.  
  # If 0, leave all bits as zero.

  if ($disable2d == 0) {
    $SequenceCtrl_2d = 0x61;
  }

  if ($dram_datawidth==16) {
    $x16present    = 0xff;
  }

  # CATerminatingRankChA = 0 or 1
  if ($CATerminatingRankChA & 0x1) {
    $CATerminatingRankChA = 0;
  }
  elsif ($CATerminatingRankChA & 0x2) {
    $CATerminatingRankChA = 1;
  }
  if ($CATerminatingRankChB & 0x1) {
    $CATerminatingRankChB = 0;
  }
  elsif ($CATerminatingRankChB & 0x2) {
    $CATerminatingRankChB = 1;
  }

  # AddrMirror
  # Encoded quad CS, need to extend addrmirror when logic_rank = 8 (LRDIMM)
  if ($csMode == 3) {
    if ($num_rank_dfi[0] >= 8) {
        $addrmirror |= $addrmirror<<4;
    }
  }

  # calc params
  foreach my $p (0..$num_pstates-1) {
    if ($dram_type eq "DDR3") {
      &get_ddr3_timing($p);
      &get_ddr3_mr($p);
    }
    elsif ($dram_type eq "DDR4") {
      &get_ddr4_timing($p);
      &get_ddr4_mr($p);
      &get_alt_cl_cwl($p);
    }
    elsif ($dram_type eq "LPDDR3") {
      &get_lpddr3_timing($p);
      &get_lpddr3_mr($p);
    }
    elsif ($dram_type eq "LPDDR4") {
      &get_lpddr4_timing($p);
      &get_lpddr4_mr($p);
    }
    elsif ($dram_type eq "LPDDR5") {
      &get_lpddr5_timing($p);
      &get_lpddr5_mr($p);
    }


    if (($dram_type eq "DDR4") and ($dimm_type eq "RDIMM")) {
     &init_rcd($p, $dimm_type, $csMode);
    }
    elsif ($dimm_type eq "LRDIMM") {
     &init_rcd($p, $dimm_type, $csMode);
     &init_db($p);
    } 
  }


} # sub calc_configs

#
sub get_lpddr4_timing {
  my $p = $_[0];

  if ( $Frequency[$p] <= 266 ) {
      $Lp4RL[$p]         = 0x0000; 
      $Lp4WL[$p]         = 0x0000; 
      $Lp4nWR[$p]        = 0x0000; 
  }
  elsif ( $Frequency[$p] <= 533) {
      $Lp4RL[$p]         = 0x0001; 
      $Lp4WL[$p]         = 0x0001; 
      $Lp4nWR[$p]        = 0x0001; 
  }
  elsif ( $Frequency[$p] <= 800) {
      $Lp4RL[$p]         = 0x0002; 
      $Lp4WL[$p]         = 0x0002; 
      $Lp4nWR[$p]        = 0x0002; 
  }
  elsif ( $Frequency[$p] <= 1066) { 
      $Lp4RL[$p]         = 0x0003;
      $Lp4WL[$p]         = 0x0003;
      $Lp4nWR[$p]        = 0x0003; 
  }
  elsif ( $Frequency[$p] <= 1333) {
      $Lp4RL[$p]         = 0x0004;
      $Lp4WL[$p]         = 0x0004;
      $Lp4nWR[$p]        = 0x0004; 
  }
  elsif ( $Frequency[$p] <= 1600) {
      $Lp4RL[$p]         = 0x0005;
      $Lp4WL[$p]         = 0x0005;
      $Lp4nWR[$p]        = 0x0005; 
  }
  elsif ( $Frequency[$p] <= 1866) {
      $Lp4RL[$p]         = 0x0006;
      $Lp4WL[$p]         = 0x0006;
      $Lp4nWR[$p]        = 0x0006; 
  } 
  else {
      $Lp4RL[$p]         = 0x0007;
      $Lp4WL[$p]         = 0x0007;
      $Lp4nWR[$p]        = 0x0007; 
  }


  if ($Frequency[$p] <= 266) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 6; 
      } else {
        $rd_latency[$p] = 6; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 4;          
      } else {
        $wr_latency[$p] = 4;          
      }
  }
  elsif ($Frequency[$p] <= 533) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 12; 
      } else {
        $rd_latency[$p] = 10; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 8;          
      } else {
        $wr_latency[$p] = 6;          
      }
  }
  elsif ( $Frequency[$p] <= 800) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 16; 
      } else {
        $rd_latency[$p] = 14; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 12;          
      } else {
        $wr_latency[$p] = 8;          
      }
  }
  elsif ( $Frequency[$p] <= 1066) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 22; 
      } else {
        $rd_latency[$p] = 20; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 18;          
      } else {
        $wr_latency[$p] = 10;          
      }
  }
  elsif ( $Frequency[$p] <= 1333) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 28; 
      } else {
        $rd_latency[$p] = 24; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 22;          
      } else {
        $wr_latency[$p] = 12;          
      }
  }
  elsif ( $Frequency[$p] <= 1600) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 32; 
      } else {
        $rd_latency[$p] = 28; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 26;          
      } else {
        $wr_latency[$p] = 14;          
      }
  }
  elsif ( $Frequency[$p] <= 1866) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 36; 
      } else {
        $rd_latency[$p] = 32; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 30;          
      } else {
        $wr_latency[$p] = 16;          
      }
  }
  elsif ( $Frequency[$p] <= 2133) {
      if ($Lp4DbiRd[$p] == 1) {
        $rd_latency[$p] = 40; 
      } else {
        $rd_latency[$p] = 36; 
      }
      if ($Lp4WLS[$p] == 1) {
        $wr_latency[$p] = 34;          
      } else {
        $wr_latency[$p] = 18;          
      }
  }
  else {
      print DEBUG "WARNING: LPDDR4 set to unsupported Frequency[$p]uency: $Frequency[$p]\n" if $debug;
  }

}

sub get_lpddr4_mr{
  my $p  = $_[0];
   
  my $Lp4PuCal       = 0x1;
  my $Lp4SocOdt      = 0x0;
  my $Lp4CkOdtEn     = 0x1;
  my $Lp4CsOdtEn     = 0x1;
  my $Lp4CaOdtDis    = 0x0;


  $MR1[$p] =
      ( (0x0                                       << 0) & 0x03) |
      ( (0x1                                       << 2) & 0x04) |
      #( ($Lp4RxPreambleMode[$p] << 3) & 0x08) |
      ( (0x1                     << 3) & 0x08) |
      ( ($Lp4nWR[$p]             << 4) & 0x70) |
      ( ($Lp4RxPostambleMode[$p] << 7) & 0x80) ;
  
  $MR2[$p] =
      ( ($Lp4RL[$p]            << 0) & 0x07) |
      ( ($Lp4WL[$p]            << 3) & 0x38) |
      ( ($Lp4WLS[$p]           << 6) & 0x40) |
      ( (($SequenceCtrl & 0x2) << 7) & 0x80) ;
  
  $MR3[$p] =
      ( ($Lp4PuCal             << 0) & 0x01) |
      ( ($Lp4PostambleExt[$p]  << 1) & 0x02) |
      ( (0x0                   << 2) & 0x04) |
      ( ($Lp4PDDS[$p]          << 3) & 0x38) |
      ( ($Lp4DbiRd[$p]         << 6) & 0x40) |
      ( ($Lp4DbiWr[$p]         << 7) & 0x80) ;
  
  $MR4[$p] = 0x0;
  
  $MR11[$p] =
      ( ($DqOdt[$p]           << 0) & 0x07) |
      ( ($Lp4CaOdt[$p]        << 4) & 0x70) ;
  
  $MR12[$p] =
      ( ($VrefCa[$p]       << 0) & 0x7f) ;
  
  $MR13[$p] =
      ( (0x0           << 0) & 0x01) | # CBT
      ( (0x0           << 1) & 0x02) | # RPT
      ( (0x0           << 2) & 0x04) | # VRO
      ( ($vrcg[$p]     << 3) & 0x08) | # VRCG
      ( (0x0           << 4) & 0x10) | # RRO
      ( ((~$DM[$p])    << 5) & 0x20) | # DMD
      ( ($fsp_wr[$p]   << 6) & 0x40) | # FSP-WR
      ( ($fsp_op[$p]   << 7) & 0x80) ; # FSP-OP

  $MR14[$p] =
      ( ($VrefDq[$p]      << 0) & 0x7f);
  
  $MR16[$p] = 0x0;
  $MR17[$p] = 0x0;
  
  $MR22[$p] =
      ( ($Lp4SocOdt      << 0) & 0x07) |
      ( ($Lp4CkOdtEn     << 1) & 0x08) |
      ( ($Lp4CsOdtEn     << 2) & 0x10) |
      ( ($Lp4CaOdtDis    << 3) & 0x20) |
      ( (0x0             << 6) & 0xc0) ;
  $MR24[$p] = 0x0;

} # sub get_lpddr4_mr


sub get_lpddr5_timing {
  my $p = $_[0];

  if ($dfi_freq_ratio[$p] == 2) {
    $CKR[$p] = 0;        
    if ( $Frequency[$p] <= 67 ) {
        $Lp5RL[$p]         = 0x0000; 
        $Lp5WL[$p]         = 0x0000; 
    }
    elsif ( $Frequency[$p] <= 133) {
        $Lp5RL[$p]         = 0x0001; 
        $Lp5WL[$p]         = 0x0001; 
    }
    elsif ( $Frequency[$p] <= 200) {
        $Lp5RL[$p]         = 0x0002; 
        $Lp5WL[$p]         = 0x0002; 
    }
    elsif ( $Frequency[$p] <= 267) { 
        $Lp5RL[$p]         = 0x0003;
        $Lp5WL[$p]         = 0x0003;
    }
    elsif ( $Frequency[$p] <= 344) {
        $Lp5RL[$p]         = 0x0004;
        $Lp5WL[$p]         = 0x0004;
    }
    elsif ( $Frequency[$p] <= 400) {
        $Lp5RL[$p]         = 0x0005;
        $Lp5WL[$p]         = 0x0005;
    }
    elsif ( $Frequency[$p] <= 467) {
        $Lp5RL[$p]         = 0x0006;
        $Lp5WL[$p]         = 0x0006;
        $wck_fm[$p]        = 0x0001;
    } 
    elsif ( $Frequency[$p] <= 533) {
        $Lp5RL[$p]         = 0x0007;
        $Lp5WL[$p]         = 0x0007;
        $wck_fm[$p]        = 0x0001;
    } 
    elsif ( $Frequency[$p] <= 600) {
        $Lp5RL[$p]         = 0x0008;
        $Lp5WL[$p]         = 0x0008;
        $wck_fm[$p]        = 0x0001;
    }
    elsif ( $Frequency[$p] <= 688) {
        $Lp5RL[$p]         = 0x0009;
        $Lp5WL[$p]         = 0x0009;
        $wck_fm[$p]        = 0x0001;
    }
    elsif ( $Frequency[$p] <= 750) {
        $Lp5RL[$p]         = 0x000a;
        $Lp5WL[$p]         = 0x000a;
        $wck_fm[$p]        = 0x0001;
    }
    elsif ( $Frequency[$p] <= 800) {
        $Lp5RL[$p]         = 0x000b;
        $Lp5WL[$p]         = 0x000b;
        $wck_fm[$p]        = 0x0001;
    }    
  } else {
    $CKR[$p] = 1; 
    if ( $Frequency[$p] <= 133) {
        $Lp5RL[$p]         = 0x0000; 
        $Lp5WL[$p]         = 0x0000; 
    }
    elsif ( $Frequency[$p] <= 267) { 
        $Lp5RL[$p]         = 0x0001;
        $Lp5WL[$p]         = 0x0001;
    }
    elsif ( $Frequency[$p] <= 400) {
        $Lp5RL[$p]         = 0x0002;
        $Lp5WL[$p]         = 0x0002;
    }
    elsif ( $Frequency[$p] <= 533) {
        $Lp5RL[$p]         = 0x0003;
        $Lp5WL[$p]         = 0x0003;
    } 
    elsif ( $Frequency[$p] <= 688) {
        $Lp5RL[$p]         = 0x0004;
        $Lp5WL[$p]         = 0x0004;
    }
    elsif ( $Frequency[$p] <= 800) {
        $Lp5RL[$p]         = 0x0005;
        $Lp5WL[$p]         = 0x0005;
    }    
  }
} # get_lpddr5_timing 

sub get_lpddr5_mr{
  my $p  = $_[0];

  $MR1[$p] =
      ( (0x0        << 0) & 0x07) |
      ( (0x0        << 3) & 0x08) |
      ( ($Lp5WL[$p] << 4) & 0xf0) ;

  $MR2[$p] =
      ( ($Lp5RL[$p] << 0) & 0x0f);

  $MR3[$p] =
      ( (0x6       << 0) & 0x07) |
      ( ($BK_ORG   << 3) & 0x18) |
      ( ($WLS[$p]  << 5) & 0x20) |
      ( ($RDBI[$p] << 6) & 0x40) |
      ( ($WDBI[$p] << 7) & 0x80);

  $MR10[$p] =
       ( (0x0           << 0) & 0x01) |
       ( ($WCK_PST[$p]  << 2) & 0x0c) |
       ( ($RDQS_PRE[$p] << 4) & 0x30) |
       ( ($RDQS_PST[$p] << 6) & 0xc0);

  $MR13[$p] =
      ( (0x0        << 0) & 0x01) |
      ( (0x0        << 1) & 0x02) | # Thermal offset
      ( (0x0        << 2) & 0x04) | # VRO
      ( (0x0        << 3) & 0x08) | #
      ( (0x0        << 4) & 0x10) | # RFU
      ( ((~$DM[$p]) << 5) & 0x20) | # DMD
      ( (0x0        << 6) & 0x40) | # CBT_mode
      ( (0x0        << 7) & 0x80) ; # Dual VDD2

  $MR16[$p] = 
       ( ($fsp_wr[$p] << 0) & 0x03) | # FSP-WR
       ( ($fsp_op[$p] << 2) & 0x0c) | # FSP-OP
       ( (0x0         << 4) & 0x30) | # CBT
       ( ($vrcg[$p]   << 6) & 0x40) | # VRCG
       ( (0x0         << 7) & 0x80) ; # CBT_Phase

  $MR17[$p] = 0x38; # Disable ODT during training stage
  $MR18[$p] = 
       ( (0x0         << 0) & 0x07) |
       ( ($wck_fm[$p] << 3) & 0x08) |
       ( ($WCK_ON[$p] << 4) & 0x10) |
       ( (0x0         << 5) & 0x20) |
       ( ($CKR[$p]    << 7) & 0x80);

  $MR19[$p] = 
       ( (0x0 << 0) & 0x03) |
       ( (0x0 << 2) & 0x06);

  $MR20[$p] =
       ( ($RDQS << 0) & 0x03) |
       ( (0x0   << 2) & 0x0c) |
       ( (0x0   << 6) & 0x40) |
       ( (0x0   << 7) & 0x80);

  $MR22[$p] =
       ( (0x0   << 0) & 0x03) |
       ( (0x0   << 2) & 0x0c) |
       ( (0x0   << 6) & 0x40) |
       ( (0x0   << 7) & 0x80);
                
} #  get_lpddr5_mr    

#
sub init_rcd {
  my $p = $_[0];
  my $dimm_type = $_[1];
  my $csMode   = $_[2];
  
  $F0RC00 |= 0;  # [0]: output inversion
  $F0RC01 |= 0;
  $F0RC08 |= 0;  # TODO: 3DS

  if ( $Frequency[$p] <= 125) {
    $F0RC0A = 0x7;  # PLL bypass mode
  }
  elsif ( $Frequency[$p] <= 800) {
    $F0RC0A = 0x0;
  }
  elsif ( $Frequency[$p] <= 933) {
    $F0RC0A = 0x1;
  }
  elsif ( $Frequency[$p] <= 1066) {
    $F0RC0A = 0x2;
  }
  elsif ( $Frequency[$p] <= 1200) {
    $F0RC0A = 0x3;
  }
  elsif ( $Frequency[$p] <= 1333 ) {
    $F0RC0A = 0x4;
  }
  elsif ($Frequency[$p] <= 1466) {
    $F0RC0A = 0x5;
  }
  else {
    $F0RC0A = 0x6;
  }

  if ($csMode == 0) {
    $F0RC0D |= 0x0; # [1:0]
  }
  elsif ($csMode == 1) {
    $F0RC0D |= 0x1; # [1:0]
  }
  elsif ($csMode == 3) {
    $F0RC0D |= 0x3; # [1:0]
  }
  if ( $dimm_type eq "RDIMM" ) {
    $F0RC0D |= 0x4; # [2]
  } elsif ($dimm_type eq "LRDIMM") {
    $F0RC0D |= 0x0; # [2]
  }
  $F0RC0D_D0 |= $F0RC0D;        
  if ($addrmirror_d0) {
    $F0RC0D_D0 |= 0x8;        
  }
  $F0RC0D_D1 |= $F0RC0D;        
  if ($addrmirror_d1) {
    $F0RC0D_D1 |= 0x8;        
  }

  $F0RC0E |= 0xc; #[0] Parity, [2] ALERT_n Assertion [3] ALERT_n Re-enable

  $F0RC0F = 0x4; # 0nCK

  if ($Frequency[$p] <= 620) {
    $F0RC3x = 0x0;
  }
  else {
    $F0RC3x = abs(($Frequency[$p] - 621 )/10); 
  }

} #sub init_rcd

#
sub init_db {
  my $p = $_[0];

  $BC00 = 0x1;  # RTT_NOM
  $BC01 = 0x0;  # RTT_WR
  $BC02 = 0x0;  # RTT_PARK
  $BC03 = 0x0;  # Host driver
  $BC04 = 0x0;  # Dram odt
  $BC05 = 0x0;  # Dram driver
  $F5BC5x = 0x0014;  # Host DQ VREF
  $F5BC6x = 0x001C;  # Dram DQ VREF

  if ( $Frequency[$p] <= 125) {
    $BC0A = 0x7;  # PLL bypass mode
  }
  elsif ( $Frequency[$p] <= 800) {
    $BC0A = 0x0;
  }
  elsif ( $Frequency[$p] <= 933) {
    $BC0A = 0x1;
  }
  elsif ( $Frequency[$p] <= 1066) {
    $BC0A = 0x2;
  }
  elsif ( $Frequency[$p] <= 1200) {
    $BC0A = 0x3;
  }
  elsif ( $Frequency[$p] <= 1333 ) {
    $BC0A = 0x4;
  }
  elsif ($Frequency[$p] <= 1466) {
    $BC0A = 0x5;
  }
  else {  #1600
    $BC0A = 0x6;
  }

  if ($Frequency[$p] <= 620) {
    $F0BC6x = 0x0;   
  }
  else {
    $F0BC6x = abs(($Frequency[$p] - 621 )/10); 
  }

} # sub init_db


# get ALT_CAS_L/ALT_WCAS_L depends on CL/CWL
sub get_alt_cl_cwl {
  my $p = $_[0];

  my $cl = $alt_cl[$p];
  my $cwl = $alt_cwl[$p];
  my $mr0_cl=0;
  my $mr2_cwl=0;
  my $use_alt_cl  = 1; # 0: use the value in MR0/MR2, 1: use the value in ALT_CAS_L/ALT_WCAS_L
  my $use_alt_cwl = 1; # 0: use the value in MR0/MR2, 1: use the value in ALT_CAS_L/ALT_WCAS_L

  # ALT_CAS_L[12,6,5,4,2]
  if    ($cl ==  9) { $mr0_cl = 0; }
  elsif ($cl == 10) { $mr0_cl = 1; }
  elsif ($cl == 11) { $mr0_cl = 2; }
  elsif ($cl == 12) { $mr0_cl = 3; }
  elsif ($cl == 13) { $mr0_cl = 4; }
  elsif ($cl == 14) { $mr0_cl = 5; }
  elsif ($cl == 15) { $mr0_cl = 6; }
  elsif ($cl == 16) { $mr0_cl = 7; }
  elsif ($cl == 18) { $mr0_cl = 8; }
  elsif ($cl == 20) { $mr0_cl = 9; }
  elsif ($cl == 22) { $mr0_cl = 10; }
  elsif ($cl == 24) { $mr0_cl = 11; }
  elsif ($cl == 23) { $mr0_cl = 12; }
  elsif ($cl == 17) { $mr0_cl = 13; }
  elsif ($cl == 19) { $mr0_cl = 14; }
  elsif ($cl == 21) { $mr0_cl = 15; }
  elsif ($cl == 25) { $mr0_cl = 16; }  
  elsif ($cl == 26) { $mr0_cl = 17; }
  elsif ($cl == 27) { $mr0_cl = 18; }  
  elsif ($cl == 28) { $mr0_cl = 19; }
  elsif ($cl == 29) { $mr0_cl = 20; }
  elsif ($cl == 30) { $mr0_cl = 21; }
  elsif ($cl == 31) { $mr0_cl = 22; }
  elsif ($cl == 32) { $mr0_cl = 23; }
  elsif ($cl == 0)  { $use_alt_cl = 0; }
  else {print DEBUG "WARNING: wrong ALT_CAS_L value format: $cl\n" if $debug;}

  # ALT_WCAS_L[5,4,3]
  #1tCK WPRE 1st Set,  1tCK WPRE 2st Set,  2tCK WPRE 1st Set,  2tCK WPRE 2st Set
  if    ($cwl == 9)  { $mr2_cwl = 0; }#     1600        ,       ----        ,       ----        ,       ----
  elsif ($cwl ==10)  { $mr2_cwl = 1; }#     1866        ,       ----        ,       ----        ,       ----
  elsif ($cwl ==11)  { $mr2_cwl = 2; }#     2133        ,       1600        ,       ----        ,       ----
  elsif ($cwl ==12)  { $mr2_cwl = 3; }#     2400        ,       1866        ,       ----        ,       ----
  elsif ($cwl ==14)  { $mr2_cwl = 4; }#     2666        ,       2133        ,       2400        ,       ----
  elsif ($cwl ==16)  { $mr2_cwl = 5; }#     3200        ,       2400        ,       2666        ,       2400
  elsif ($cwl ==18)  { $mr2_cwl = 6; }#     ----        ,       2666        ,       3200        ,       2666
  elsif ($cwl ==20)  { $mr2_cwl = 7; }#     ----        ,       3200        ,       ----        ,       3200
  elsif ($cwl == 0)  { $use_alt_cwl = 0;   }
  else {print DEBUG "WARNING: wrong ALT_WCAS_L value format: $cwl\n" if $debug;}

  $ALT_CAS_L[$p] = 
      ( ($use_alt_cl  << 0) & 0x1) |
      ( ($mr0_cl      << 2) & 0x4) |
      ( (($mr0_cl>>1) << 4) & 0x70) |
      ( (($mr0_cl>>4) << 12) & 0x1000);

  $ALT_WCAS_L[$p] =
      ( ($use_alt_cwl << 0) & 0x1) |
      ( ($mr2_cwl     << 3) & 0x38);

}

# PHYINIT 2.00, set inputs and message block
sub set_phyinit_inputs {
    my $inputs = "\n";
    my $format = "%-40s= 0x%04x;\n";
    my $format_dec = "%-40s= %0d;\n";
    my $format_s = "%-40s= %s;\n";

    ### Set PHYINIT inputs
    # userInputBasic
    $inputs .= sprintf($format_s, "userInputBasic.DramType",$dram_type); 
    $inputs .= sprintf($format_s, "userInputBasic.DimmType",$dimm_type); 
    #$inputs .= sprintf($format, "userInputBasic.NumDbyte",$num_dbyte); 
    $inputs .= sprintf($format, "userInputBasic.NumActiveDbyteDfi0",$num_active_dbyte_dfi0); 
    $inputs .= sprintf($format, "userInputBasic.NumActiveDbyteDfi1",$num_active_dbyte_dfi1); 
    #$inputs .= sprintf($format, "userInputBasic.NumAnib",$num_anib); 
    $inputs .= sprintf($format, "userInputBasic.NumDbytesPerCh",$num_active_dbyte_dfi0); 
    $inputs .= sprintf($format, "userInputBasic.NumRank",$num_rank); 
    $inputs .= sprintf($format, "userInputBasic.NumRank_dfi0",$num_rank_dfi[0]); 
    $inputs .= sprintf($format, "userInputBasic.NumRank_dfi1",$num_rank_dfi[1]); 
    $inputs .= sprintf($format_dec, "userInputBasic.DramDataWidth",$dram_datawidth); 
    $inputs .= sprintf($format, "userInputBasic.NumPStates",$num_pstates); 
    $inputs .= sprintf($format, "userInputBasic.CfgPStates",$CfgPStates); 
    $inputs .= sprintf($format, "userInputBasic.NumCh",$dfi1_exists+1); 
    $inputs .= sprintf($format, "userInputBasic.DisableFspOp",$fsp_disable); 
    if ($dram_type eq "LPDDR4"){
      $inputs .= sprintf($format, "userInputBasic.Lp4xMode",$Lp4xMode); 
    }
    $inputs .= sprintf($format, "userInputAdvanced.DisablePmuEcc",$DisablePmuEcc); 
    $inputs .= sprintf($format, "userInputAdvanced.DisableRetraining",$DisableRetraining); 
    foreach my $p (0..$num_pstates-1) {
      $inputs .= sprintf($format_dec, "userInputBasic.Frequency[$p]",$Frequency[$p]); 
      $inputs .= sprintf($format, "userInputBasic.PllBypass[$p]",$PllBypass[$p]); 
      $inputs .= sprintf($format, "userInputBasic.DfiFreqRatio[$p]",$dfi_freq_ratio[$p]); 
      #$inputs .= sprintf($format, "userInputBasic.ReadDBIEnable[$p]",$ReadDBIEnable[$p]);
    }

    # userInputAdvanced
     $inputs .= sprintf($format, "userInputBasic.FirstPState",$FirstPState);
    #if ($dram_type eq "LPDDR4") {
    #  $inputs .= sprintf($format, "userInputAdvanced.WDQSExt",$wdqsext); 
    #  $inputs .= sprintf($format, "userInputAdvanced.RxEnBackOff",$RxEnBackOff); 
    #  $inputs .= sprintf($format, "userInputAdvanced.Lp4Quickboot",$Lp4Quickboot); 
    #}
    $inputs .= sprintf($format, "userInputAdvanced.WDQSExt",$wdqsext); 
    if (($dimm_type eq "RDIMM") or ($dimm_type eq "LRDIMM")) {
      $inputs .= sprintf($format, "userInputAdvanced.CsMode",$csMode); 
    }

    foreach my $p (0..$num_pstates-1) {
      $inputs .= sprintf($format_dec, "userInputAdvanced.OdtImpedanceDqs[$p]",$OdtImpedanceDqs[$p]);
      $inputs .= sprintf($format_dec, "userInputAdvanced.TxImpedanceDq[$p]",$TxImpedanceDq[$p]);
      $inputs .= sprintf($format_dec, "userInputAdvanced.TxImpedanceAc[$p]",$TxImpedanceAc[$p]);
      if($dram_type eq "LPDDR4"){
        $inputs .= sprintf($format_dec, "userInputAdvanced.TxImpedanceCs[$p]",$TxImpedanceCs[$p]);
      }
      $inputs .= sprintf($format_dec, "userInputAdvanced.TxImpedanceCk[$p]",$TxImpedanceCk[$p]);
      $inputs .= sprintf($format_dec, "userInputAdvanced.TxImpedanceDqs[$p]",$TxImpedanceDqs[$p]);
      if($dram_type eq "LPDDR5"){
        $inputs .= sprintf($format_dec, "userInputAdvanced.TxImpedanceWCK[$p]",$TxImpedanceWCK[$p]);
      }
    }


    foreach my $p (0..$num_pstates-1) {
      if($DisableRetraining){
        $inputs .= sprintf($format_dec, "userInputAdvanced.RetrainMode[$p]",0);
      } else {
        if($dram_type eq "LPDDR4"){
          if($skip_train == 1){
            $inputs .= sprintf($format_dec, "userInputAdvanced.RetrainMode[$p]",0); 
          } else {  
            if ($Frequency[$p] <= 333) {
              $inputs .= sprintf($format_dec, "userInputAdvanced.RetrainMode[$p]",0);
            }
          }
        }
        if($dram_type eq "LPDDR5"){
          if($skip_train == 1){
            $inputs .= sprintf($format_dec, "userInputAdvanced.RetrainMode[$p]",0);
          } else {  
            if ((($Frequency[$p] <= 166) && ($dfi_freq_ratio[$p] == 1)) || (($Frequency[$p] <= 83) && ($dfi_freq_ratio[$p] == 2))) {
              $inputs .= sprintf($format_dec, "userInputAdvanced.RetrainMode[$p]",0);
            }
          }
        }
      }
    }

    # userInputSim
    #$inputs .= sprintf($format, "userInputSim.PHY_tDQS2DQ",625);
    $inputs .= sprintf($format_dec, "userInputSim.PHY_tDQS2DQ",$PHY_tDQS2DQ); 
    if ($dram_type eq "LPDDR4") {
      $tDQS2DQ = 200; # fix to CTB
      $inputs .= sprintf($format_dec, "userInputSim.tDQS2DQ",$tDQS2DQ); # LPDDR4 only
    }
    if ($dram_type eq "LPDDR4") {
      $tDQSCK = 1500;
    } 
    elsif ($dram_type eq "LPDDR3") {
      $tDQSCK = 2500;
    }
    elsif ($dimm_type eq "LRDIMM"){
      $tDQSCK = 0; 
    }
 
    if($dram_type ne "LPDDR5"){
    $inputs .= sprintf($format_dec, "userInputSim.tDQSCK",$tDQSCK); # ususally for LPDDR3/4, also DDR3/4 with DLL-off
    }
    if($dram_type eq "LPDDR5"){
    $tWCK2DQI = 500;
    $inputs .= sprintf($format_dec, "userInputSim.tWCK2DQI",$tWCK2DQI);   
    $tWCK2DQO = 1000;
    $inputs .= sprintf($format_dec, "userInputSim.tWCK2DQO",$tWCK2DQO);   
    }

    ### Set MB inputs
    $inputs .= "\n";
    my $MB_TAG = $dram_type;
    if (($dimm_type eq "UDIMM") or ($dimm_type eq "NODIMM")) {
      if (($dram_type eq "DDR3") or ($dram_type eq "DDR4")) {
        $MB_TAG .= "U";
      } else {
        $MB_TAG .= "";
      }
    }
    elsif ($dimm_type eq "RDIMM") {
      $MB_TAG .= "R";
    }
    elsif ($dimm_type eq "LRDIMM") {
      $MB_TAG .= "LR";
    }

    # only Pstate 0 need to do 2D train
    foreach my $d (1..(2-$disable2d)) {
      my $max_pstates = $num_pstates-1;
      if ($d > 1) {$max_pstates = 0;}
    foreach my $p (0..$max_pstates) {
      if($disable2d == 0) {
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].SequenceCtrl",$SequenceCtrl_2d);
      }
      else {
        if ($p > 0) {
          $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].SequenceCtrl",$SequenceCtrl&(~0x100)); # no need to do rddeskew for pstate1/2/3
        }
        else {
          $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].SequenceCtrl",$SequenceCtrl);
        }
      }
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MRLCalcAdj",$MRLCalcAdj); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].Disable2D",$disable2d); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].HdtCtrl",$hdtctrl); 
      #$inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].DFIMRLMargin",$DFIMRLMargin[$p]); 
      if ($dram_type eq "LPDDR5") {
        $cspresent_cha = ($num_rank_dfi[0] == 2) ? 0x3 : $num_rank_dfi[0];
        $cspresent_chb = ($num_rank_dfi[1] == 2) ? 0x3 : $num_rank_dfi[1];
        $enableddqs_cha = $num_active_dbyte_dfi0 * 8; 
        $enableddqs_chb = $num_active_dbyte_dfi1 * 8; 
        $CATrainOpt = 0x82; # Enable LP5 CS Training, and ca training step_size to reduce test run time during simulations.
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentChA",$cspresent_cha); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentChB",$cspresent_chb); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].EnabledDQsChA",$enableddqs_cha); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].EnabledDQsChB",$enableddqs_chb); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CATerminatingRankChA",$CATerminatingRankChA); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CATerminatingRankChB",$CATerminatingRankChB); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CATrainOpt",$CATrainOpt); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].Misc",$Misc); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_A0",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_A0",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_A0",$MR3[$p]); 
        #$inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_A0",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR10_A0",$MR10[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_A0",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_A0",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_A0",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_A0",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_A0",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_A0",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR18_A0",$MR18[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR19_A0",$MR19[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR20_A0",$MR20[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_A0",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_A0",$MR24[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_A1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_A1",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_A1",$MR3[$p]); 
        #$inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_A1",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR10_A1",$MR10[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_A1",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_A1",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_A1",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_A1",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_A1",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_A1",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR18_A1",$MR18[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR19_A1",$MR19[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR20_A1",$MR20[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_A1",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_A1",$MR24[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_B0",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_B0",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_B0",$MR3[$p]); 
        #$inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_B0",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR10_B0",$MR10[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_B0",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_B0",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_B0",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_B0",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_B0",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_B0",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR18_B0",$MR18[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR19_B0",$MR19[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR20_B0",$MR20[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_B0",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_B0",$MR24[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_B1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_B1",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_B1",$MR3[$p]); 
        #$inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_B1",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR10_B1",$MR10[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_B1",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_B1",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_B1",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_B1",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_B1",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_B1",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR18_B1",$MR18[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR19_B1",$MR19[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR20_B1",$MR20[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_B1",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_B1",$MR24[$p]); 
      }

      if ($dram_type eq "LPDDR4") {
        $cspresent_cha = ($num_rank_dfi[0] == 2) ? 0x3 : $num_rank_dfi[0];
        $cspresent_chb = ($num_rank_dfi[1] == 2) ? 0x3 : $num_rank_dfi[1];
        $enableddqs_cha = $num_active_dbyte_dfi0 * 8; 
        $enableddqs_chb = $num_active_dbyte_dfi1 * 8; 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentChA",$cspresent_cha); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentChB",$cspresent_chb); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].EnabledDQsChA",$enableddqs_cha); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].EnabledDQsChB",$enableddqs_chb); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_2D[$p].EnabledDQsChA",$enableddqs_cha); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_2D[$p].EnabledDQsChB",$enableddqs_chb); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CATerminatingRankChA",$CATerminatingRankChA); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CATerminatingRankChB",$CATerminatingRankChB); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CATrainOpt",$CATrainOpt); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].Misc",$Misc); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_A0",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_A0",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_A0",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_A0",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_A0",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_A0",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_A0",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_A0",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_A0",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_A0",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_A0",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_A0",$MR24[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_A1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_A1",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_A1",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_A1",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_A1",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_A1",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_A1",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_A1",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_A1",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_A1",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_A1",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_A1",$MR24[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_B0",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_B0",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_B0",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_B0",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_B0",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_B0",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_B0",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_B0",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_B0",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_B0",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_B0",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_B0",$MR24[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_B1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_B1",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_B1",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4_B1",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_B1",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR12_B1",$MR12[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR13_B1",$MR13[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR14_B1",$MR14[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_B1",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_B1",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR22_B1",$MR22[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR24_B1",$MR24[$p]); 
      }

      if ($dram_type eq "LPDDR3") {
        $cspresent_cha = ($num_rank_dfi[0] == 2) ? 0x3 : $num_rank_dfi[0];
        $cspresent_chb = ($num_rank_dfi[1] == 2) ? 0x3 : $num_rank_dfi[1];
        $enableddqs_cha = $num_active_dbyte_dfi0 * 8; 
        $enableddqs_chb = $num_active_dbyte_dfi1 * 8; 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentChA",$cspresent_cha); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentChB",$cspresent_chb); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].EnabledDQsChA",$enableddqs_cha); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].EnabledDQsChB",$enableddqs_chb); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_A0",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_A0",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_A0",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_A0",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_A0",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_A0",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_A1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_A1",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_A1",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_A1",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_A1",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_A1",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_B0",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_B0",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_B0",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_B0",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_B0",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_B0",$MR17[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1_B1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2_B1",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3_B1",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR11_B1",$MR11[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR16_B1",$MR16[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR17_B1",$MR17[$p]); 
      }

      if ($dram_type eq "DDR4") {
        if($num_rank_dfi[0] == 1) {
           $cspresent = 1;
           $cspresent_d0 = 1;
        } elsif($num_rank_dfi[0] == 2){
           $cspresent = 0x3;
           $cspresent_d0 = 0x3;        
        } elsif($num_rank_dfi[0] ==4) {
           $cspresent = 0xf;
           $cspresent_d0 = 0xf;         
        }
        $cspresent_d1 = 0;
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresent",$cspresent); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentD0",$cspresent_d0); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentD1",$cspresent_d1); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].AddrMirror",$addrmirror); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].X16Present",$x16present); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].PhyCfg",$PhyCfg[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsSetupGDDec",$CsSetupGDDec[$p]);
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR0",$MR0[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2",$MR2[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR3",$MR3[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR4",$MR4[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR5",$MR5[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR6",$MR6[$p]); 
        #$inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].ALT_CAS_L",$ALT_CAS_L[$p]); 
        #$inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].ALT_WCAS_L",$ALT_WCAS_L[$p]); 
        #for (my $rank=0; $rank<4; $rank++) {
        #  for (my $nibble=0; $nibble<20; $nibble++) {
        #    $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].VrefDqR${rank}Nib${nibble}",$VrefDq[$p]); 
        #  }
        #}
      }

      if ($dram_type eq "DDR3") {
           if($num_rank_dfi[0] == 1) {
           $cspresent = 1;
           $cspresent_d0 = 1;
        } elsif($num_rank_dfi[0] == 2){
           $cspresent = 0x3;
           $cspresent_d0 = 0x3;        
        } elsif($num_rank_dfi[0] ==4) {
           $cspresent = 0xf;
           $cspresent_d0 = 0xf;         
        }
        $cspresent_d1 = 0;
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresent",$cspresent); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentD0",$cspresent_d0); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].CsPresentD1",$cspresent_d1); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].AddrMirror",$addrmirror); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR0",$MR0[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR1",$MR1[$p]); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].MR2",$MR2[$p]); 
      }

    #DDR4 RDIMM/LRDIMM only
    if (($dram_type eq "DDR4") and (($dimm_type eq "RDIMM") or ($dimm_type eq "LRDIMM"))) {
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC00_D0",$F0RC00); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC01_D0",$F0RC01); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC08_D0",$F0RC08); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0A_D0",$F0RC0A); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0D_D0",$F0RC0D_D0); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0E_D0",$F0RC0E); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0F_D0",$F0RC0F); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC3x_D0",$F0RC3x); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC00_D1",$F0RC00); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC01_D1",$F0RC01); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC08_D1",$F0RC08); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0A_D1",$F0RC0A); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0D_D1",$F0RC0D_D1); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0E_D1",$F0RC0E); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC0F_D1",$F0RC0F); 
      $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0RC3x_D1",$F0RC3x); 
      if ($dimm_type eq "LRDIMM") {
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC00_D0",$BC00); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC01_D0",$BC01); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC02_D0",$BC02); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC03_D0",$BC03); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC04_D0",$BC04); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC05_D0",$BC05); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC0A_D0",$BC0A); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F5BC5x_D0",$F5BC5x); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F5BC6x_D0",$F5BC6x); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0BC6x_D0",$F0BC6x); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC00_D1",$BC00); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC01_D1",$BC01); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC02_D1",$BC02); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC03_D1",$BC03); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC04_D1",$BC04); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC05_D1",$BC05); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].BC0A_D1",$BC0A); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F5BC5x_D1",$F5BC5x); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F5BC6x_D1",$F5BC6x); 
        $inputs .= sprintf($format, "mb_${MB_TAG}_${d}D[$p].F0BC6x_D1",$F0BC6x); 
      }
    }

    } # pstates:0,1,2,3
    } #Train2d: 1D,2D
    
    # DDR4/LPDDR4 only
    $inputs .= "\n";
    
    # post process for inputs
    my @temp = split /\n/, $inputs;
    my $line;
    my $outputs;
    my $train1D = 0;
    my $train2D = 0;
    
    foreach $line (@temp) {
      #print "input: $line\n";
      if ($line =~ /userInput(\w+).(\w+)(\s+)=(\s+)(\w+)/) {
        $outputs .= "dwc_ddrphy_phyinit_setUserInput (phyctx, \"$2\", $5);\n";
      }
      if ($line =~ /userInput(\w+).(\w+)\[(\d+)\](\s+)=(\s+)(\w+)/) {
        $outputs .= "dwc_ddrphy_phyinit_setUserInput (phyctx, \"$2\[$3\]\", $6);\n";
      }
      if ($line =~ /mb_(\w+)_1D\[(\d+)\].(\w+)(\s+)=(\s+)(\w+)/) {
        if ($train1D == 0) {
        $outputs .= "phyctx->runtimeConfig.Train2D = 0;\n";
        $train1D = 1;
        $train2D = 0;
        }
        $outputs .= "dwc_ddrphy_phyinit_setMb (phyctx, $2, \"$3\", $6);\n";
      }
      if ($line =~ /mb_(\w+)_2D\[(\d+)\].(\w+)(\s+)=(\s+)(\w+)/) {
        if ($train2D == 0) {
        $outputs .= "phyctx->runtimeConfig.Train2D = 1;\n";
        $train1D = 0;
        $train2D = 1;
        }
        $outputs .= "dwc_ddrphy_phyinit_setMb (phyctx, $2, \"$3\", $6);\n";
      }
      #print "outputs: $outputs\n";
    }

    return $outputs;
}

# PHYINIT 2.00, write out overrideUserInput.c based on setting
sub write_out_override_cfile {
  my $match_end = 0;
  my $dram_type_lc = lc ($dram_type);
  $dram_type_lc .= "_" . lc($dimm_type) if (($dimm_type eq "RDIMM") or ($dimm_type eq "LRDIMM"));
  my $override_file     = "$install_dir/dwc_ddrphy_phyinit_userCustom_overrideUserInput.c";
  my $new_override_file = "./.dwc_ddrphy_phyinit_userCustom_overrideUserInput.c";

  my $inputs = &set_phyinit_inputs;
  # insert SPACE to align the code
  $inputs =~ s/\n/\n    /g;

  open( FILE, "<", $override_file ) or die "File cannot be open: " . $override_file;
  my $new_override_path = File::Spec->rel2abs( $new_override_file);    #absolute path
  open( NEW_FILE, ">", $new_override_path) or die "File not writable: " . $new_override_path;

  print "<postprocess> Start write out $new_override_path\n" if $debug;
  my $line = 0;
  while (my $row = <FILE>) {
    $line ++;
    if ($row =~ /End of/) {
        $row = $inputs . $row;
        $match_end=1;
    }
    print NEW_FILE $row;
  }
  if($match_end){
    close(FILE);
    close(NEW_FILE);
    print"<postprocess> Finish writing out $new_override_path\n";
  } else{
    die "ERROR: Fail to writing out override_c !!!\n";
  }
}

# write out uvm command switch
sub write_out_uvm_switch_file {
  my @all_list;

  print "<postprocess> Start write out uvm switches\n" if $debug;
  foreach (0..$num_pstates-1) {
    push @all_list, "userInputBasic.cas_read_latency[$_]=$rd_latency[$_];\n";
    push @all_list, "userInputBasic.cas_write_latency[$_]=$wr_latency[$_];\n";
  }

  if ($num_pstates==1) {
    push @all_list, "userInputBasic.pstate=0;\n";
  }

  my $all_file = "./all.c";
  if (-e $all_file) {
    system ("\\rm -f $all_file");
  }
  system ("\\cp -f dwc_ddrphy_phyinit_userCustom_overrideUserInput.c  $all_file");
  open( my $all_fh, ">>", $all_file ) or die "File not writable: " . $all_file;
  foreach (@all_list) {
    print $all_fh "$_";
  }
  close($all_fh);

} # sub write_out_uvm_switch
