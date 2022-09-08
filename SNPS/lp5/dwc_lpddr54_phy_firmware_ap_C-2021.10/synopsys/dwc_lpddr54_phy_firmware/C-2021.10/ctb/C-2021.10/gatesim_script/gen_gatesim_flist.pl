#! /usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

my %opts;

GetOptions( \%opts,
            "gatesim_flist=s",
            "release=s",
            "orien_ac=s",
            "orien_dbyte=s",
		   	"orien_master=s",
            "multi_metal_stack=s",
            "sdf=s",
            "CTB_HOME=s",
            "help"
          ) || Help();

&Help if(defined $opts{help});

sub Help{
  print "
        gatesim_flist       :  handle of 1 stage gatesim_flist
        release             :  indicate different release environment
        orien_ac            :  indicate the orientation of ac
        orien_dbyte         :  indicate the orientation of dbyte
        orien_master        :  indicate the orientation of master
        multi_metal_stack   :  indicate existing multi metal stack 
        ";
}

system ("chmod 777 $opts{gatesim_flist}");
open (Af, "<$opts{gatesim_flist}") or die "ERROR:can not open $opts{gatesim_flist} for read!!!";

if ($opts{release} eq "0") {
  system("touch gatesim.f");
  system("chmod 777 gatesim.f");
  open (Bf, ">gatesim.f") or die "ERROR:can not open gatesim.f for write!!!";

  print Bf "\$\{BUILD_PATH\}\n";
  print Bf "//Top\ndwc_ddrphy_top.v\n";

  while (<Af>){
    if ($_ =~ /dwc_ddrphy_top\.v/) { print Bf "\/\/";}
    if($opts{orien_ac} ne "none"){
      if ($_ =~ /dwc_ddrphy_ac_wrapper\.v/) { print Bf "\/\/";}
    }
    if($opts{orien_dbyte} ne "none"){
      if ($_ =~ /dwc_ddrphy_dbyte_wrapper\.v/) { print Bf "\/\/";}
    }
    if ($_ =~ /dwc_ddrphy_cmdfifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_mtestmux\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphymaster_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphydiff_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_dlytest\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_dqssamp_fifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_lcdl_wrapper\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rsm_fifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_txfifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rxreplica\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_data_fifo_rx\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_lcdl_rxclk_wrapper\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rxdatfifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphyse_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphysec_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_dftclkmux\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rxen_training\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_and2_asst_clk\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_master_pclk_mux\.v/) { print Bf "\/\/";}
    print Bf $_;
  }

  if($opts{orien_ac} ne "none"){
    if($opts{orien_ac} eq "ns"){
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ns.v\n";
    } elsif ($opts{orien_ac} eq "ew") {
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ew.v\n";
    } else {
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ew.v\n";
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ns.v\n";
    }
  }
  if($opts{orien_dbyte} ne "none"){
    if($opts{orien_dbyte} eq "ns"){
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ns.v\n";
    } elsif($opts{orien_dbyte} eq "ew"){
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ew.v\n";
    } else {
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ew.v\n";
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ns.v\n";
    }
  }

  print Bf "$opts{CTB_HOME}/gatesim_script/dummy.v\n"; 

  if ($opts{multi_metal_stack} eq "1") {
	if ($opts{orien_master} eq "0") {
      print Bf "
        //  GateSim hard macro netlist with PG
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphymaster_top_ns/views/behavior/\$sdf_path/dwc_ddrphymaster_top_ns_pg.v \n";
	} elsif ($opts{orien_master} eq "1")  {
      print Bf "
        //  GateSim hard macro netlist with PG
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphymaster_top_ew/views/behavior/\$sdf_path/dwc_ddrphymaster_top_ew_pg.v \n";
    } else {
    print Bf "
      //  GateSim hard macro netlist with PG
      $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphymaster_top/views/behavior/\$sdf_path/dwc_ddrphymaster_top_pg.v \n";
   }
    if($opts{orien_ac} eq 'ns') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
      if($opts{orien_dbyte} ne 'ns') {
        if($opts{orien_dbyte} eq 'none'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/\$sdf_path/dwc_ddrphysec_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
        } else {
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
        }
      }
    }
    if($opts{orien_ac} eq 'ew') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
      if($opts{orien_dbyte} ne 'ew') {
        if($opts{orien_dbyte} eq 'none'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/\$sdf_path/dwc_ddrphysec_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
        } else {
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
        }
      }
    }
    if($opts{orien_ac} eq 'mix') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
      if($opts{orien_dbyte} eq 'none'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/\$sdf_path/dwc_ddrphysec_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
      }
    }
    if($opts{orien_ac} eq 'none') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/\$sdf_path/dwc_ddrphysec_top_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
      if($opts{orien_dbyte} ne 'none') {
        if($opts{orien_dbyte} eq 'ew'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
        } elsif($opts{orien_dbyte} eq 'ns') {
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
        } else {
          print Bf "
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
        }
      }
    }  
  } else {
	if ($opts{orien_master} eq "0") {
      print Bf "
        //  GateSim hard macro netlist with PG
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphymaster_top_ns/views/behavior/dwc_ddrphymaster_top_ns_pg.v \n";
	} elsif ($opts{orien_master} eq "1")  {
      print Bf "
        //  GateSim hard macro netlist with PG
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphymaster_top_ew/views/behavior/dwc_ddrphymaster_top_ew_pg.v \n";
    } else {
    print Bf "
      //  GateSim hard macro netlist with PG
      $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphymaster_top/views/behavior/dwc_ddrphymaster_top_pg.v \n";
   }
    if($opts{orien_ac} eq 'ns') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/dwc_ddrphydiff_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/dwc_ddrphysec_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/dwc_ddrphyse_top_ns_pg.v \n";
      if($opts{orien_dbyte} ne 'ns') {
        if($opts{orien_dbyte} eq 'none'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/dwc_ddrphydiff_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/dwc_ddrphysec_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/dwc_ddrphyse_top_pg.v \n";
        } else {
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/dwc_ddrphydiff_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/dwc_ddrphysec_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/dwc_ddrphyse_top_ew_pg.v \n";
        }
      }
    }
    if($opts{orien_ac} eq 'ew') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/dwc_ddrphydiff_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/dwc_ddrphysec_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/dwc_ddrphyse_top_ew_pg.v \n";
      if($opts{orien_dbyte} ne 'ew') {
        if($opts{orien_dbyte} eq 'none'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/dwc_ddrphydiff_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/dwc_ddrphysec_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/dwc_ddrphyse_top_pg.v \n";
        } else {
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/dwc_ddrphydiff_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/dwc_ddrphysec_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/dwc_ddrphyse_top_ns_pg.v \n";
        }
      }
    }
    if($opts{orien_ac} eq 'mix') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/dwc_ddrphydiff_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/dwc_ddrphydiff_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/dwc_ddrphysec_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/dwc_ddrphysec_top_ew_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/dwc_ddrphyse_top_ns_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/dwc_ddrphyse_top_ew_pg.v \n";
      if($opts{orien_dbyte} eq 'none'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/dwc_ddrphydiff_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/dwc_ddrphysec_top_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/dwc_ddrphyse_top_pg.v \n";
      }
    }
    if($opts{orien_ac} eq 'none') {
      print Bf "
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top/views/behavior/dwc_ddrphydiff_top_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top/views/behavior/dwc_ddrphysec_top_pg.v \n
        $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top/views/behavior/dwc_ddrphyse_top_pg.v \n";
      if($opts{orien_dbyte} ne 'none') {
        if($opts{orien_dbyte} eq 'ew'){
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/dwc_ddrphydiff_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/dwc_ddrphysec_top_ew_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/dwc_ddrphyse_top_ew_pg.v \n";
        } elsif($opts{orien_dbyte} eq 'ns') {
           print Bf "
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/dwc_ddrphydiff_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/dwc_ddrphysec_top_ns_pg.v \n
             $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/dwc_ddrphyse_top_ns_pg.v \n";
        } else {
          print Bf "
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ns/views/behavior/dwc_ddrphydiff_top_ns_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphydiff_top_ew/views/behavior/dwc_ddrphydiff_top_ew_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ns/views/behavior/dwc_ddrphysec_top_ns_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphysec_top_ew/views/behavior/dwc_ddrphysec_top_ew_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ns/views/behavior/dwc_ddrphyse_top_ns_pg.v \n
            $opts{CTB_HOME}/../../process/\$gatesim_project/dwc_ddrphyse_top_ew/views/behavior/dwc_ddrphyse_top_ew_pg.v \n";
        }
      }
    }  
  }
}

##############################################################
####################release package###########################
##############################################################
if ($opts{release} eq "1") {
  system("touch gatesim_rel.f");
  system("chmod 777 gatesim_rel.f");
  open (Bf, ">gatesim_rel.f") or die "ERROR:can not open gatesim_rel.f for write!!!";

  print Bf "\$\{BUILD_PATH\}\n";
  print Bf "//Top\ndwc_ddrphy_top.v\n";

  while (<Af>){
    if ($_ =~ /dwc_ddrphy_top\.v/) { print Bf "\/\/";}
    if($opts{orien_ac} ne "none"){
      if ($_ =~ /dwc_ddrphy_ac_wrapper\.v/) { print Bf "\/\/";}
    }
    if($opts{orien_dbyte} ne "none"){
      if ($_ =~ /dwc_ddrphy_dbyte_wrapper\.v/) { print Bf "\/\/";}
    }
    if ($_ =~ /dwc_ddrphy_cmdfifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_mtestmux\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphymaster_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphydiff_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_dlytest\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_dqssamp_fifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_lcdl_wrapper\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rsm_fifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_txfifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rxreplica\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_data_fifo_rx\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_lcdl_rxclk_wrapper\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rxdatfifo\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphyse_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphysec_top\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_dftclkmux\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_rxen_training\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_and2_asst_clk\.v/) { print Bf "\/\/";}
    if ($_ =~ /dwc_ddrphy_master_pclk_mux\.v/) { print Bf "\/\/";}
    print Bf $_;
  }

  if($opts{orien_ac} ne "none"){
    if($opts{orien_ac} eq "ns"){
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ns.v\n";
    } elsif ($opts{orien_ac} eq "ew") {
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ew.v\n";
    } else {
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ew.v\n";
      print Bf "//Top\n dwc_ddrphy_ac_wrapper_ns.v\n";
    }
  }
  if($opts{orien_dbyte} ne "none"){
    if($opts{orien_dbyte} eq "ns"){
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ns.v\n";
    } elsif($opts{orien_dbyte} eq "ew"){
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ew.v\n";
    } else {
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ew.v\n";
      print Bf "//Top\n dwc_ddrphy_dbyte_wrapper_ns.v\n";
    }
  }

  print Bf "$opts{CTB_HOME}/gatesim_script/dummy.v\n"; 

  if($opts{orien_master} eq '0') {
    print Bf "
      //  GateSim hard macro netlist with PG
      $opts{CTB_HOME}/../../master_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphymaster_top_ns_pg.v \n";
  }
  elsif($opts{orien_master} eq '1') {
    print Bf "
      //  GateSim hard macro netlist with PG
      $opts{CTB_HOME}/../../master_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphymaster_top_ew_pg.v \n";
  } else {
  print Bf "
    //  GateSim hard macro netlist with PG
    $opts{CTB_HOME}/../../master/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphymaster_top_pg.v \n";
 }
  if($opts{orien_ac} eq 'ns') {
    print Bf "
      $opts{CTB_HOME}/../../diff_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
      $opts{CTB_HOME}/../../sec_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
      $opts{CTB_HOME}/../../se_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
    if($opts{orien_dbyte} ne 'ns') {
      if($opts{orien_dbyte} eq 'none'){
         print Bf "
           $opts{CTB_HOME}/../../diff/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
           $opts{CTB_HOME}/../../sec/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_pg.v \n
           $opts{CTB_HOME}/../../se/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
      } else {
         print Bf "
           $opts{CTB_HOME}/../../diff_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
           $opts{CTB_HOME}/../../sec_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
           $opts{CTB_HOME}/../../se_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
      }
    }
  }
  if($opts{orien_ac} eq 'ew') {
    print Bf "
      $opts{CTB_HOME}/../../diff_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
      $opts{CTB_HOME}/../../sec_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
      $opts{CTB_HOME}/../../se_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
    if($opts{orien_dbyte} ne 'ew') {
      if($opts{orien_dbyte} eq 'none'){
         print Bf "
           $opts{CTB_HOME}/../../diff/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
           $opts{CTB_HOME}/../../sec/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_pg.v \n
           $opts{CTB_HOME}/../../se/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
      } else {
         print Bf "
           $opts{CTB_HOME}/../../diff_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
           $opts{CTB_HOME}/../../sec_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
           $opts{CTB_HOME}/../../se_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
      }
    }
  }
  if($opts{orien_ac} eq 'mix') {
    print Bf "
      $opts{CTB_HOME}/../../diff_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
      $opts{CTB_HOME}/../../sec_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
      $opts{CTB_HOME}/../../se_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n
      $opts{CTB_HOME}/../../diff_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
      $opts{CTB_HOME}/../../sec_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
      $opts{CTB_HOME}/../../se_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
    if($opts{orien_dbyte} eq 'none'){
         print Bf "
           $opts{CTB_HOME}/../../diff/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
           $opts{CTB_HOME}/../../sec/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_pg.v \n
           $opts{CTB_HOME}/../../se/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
    }
  }
  if($opts{orien_ac} eq 'none') {
    print Bf "
      $opts{CTB_HOME}/../../diff/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_pg.v \n
      $opts{CTB_HOME}/../../sec/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_pg.v \n
      $opts{CTB_HOME}/../../se/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_pg.v \n";
    if($opts{orien_dbyte} ne 'none') {
      if($opts{orien_dbyte} eq 'ew'){
         print Bf "
           $opts{CTB_HOME}/../../diff_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
           $opts{CTB_HOME}/../../sec_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
           $opts{CTB_HOME}/../../se_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n";
      } elsif($opts{orien_dbyte} eq 'ns') {
         print Bf "
           $opts{CTB_HOME}/../../diff_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
           $opts{CTB_HOME}/../../sec_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
           $opts{CTB_HOME}/../../se_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
      } else {
        print Bf "
          $opts{CTB_HOME}/../../diff_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ew_pg.v \n
          $opts{CTB_HOME}/../../sec_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ew_pg.v \n
          $opts{CTB_HOME}/../../se_ew/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ew_pg.v \n
          $opts{CTB_HOME}/../../diff_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphydiff_top_ns_pg.v \n
          $opts{CTB_HOME}/../../sec_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphysec_top_ns_pg.v \n
          $opts{CTB_HOME}/../../se_ns/Latest/gate_level_netlist/\$sdf_path/dwc_ddrphyse_top_ns_pg.v \n";
      }
    }
  }  

}









