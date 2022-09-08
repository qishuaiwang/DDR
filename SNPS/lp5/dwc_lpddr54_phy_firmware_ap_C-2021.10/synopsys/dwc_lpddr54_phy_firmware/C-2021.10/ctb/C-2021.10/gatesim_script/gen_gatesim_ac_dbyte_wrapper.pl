#! /usr/bin/env perl

#use strict;
#use warnings;

use Getopt::Long;

my %opts;

GetOptions(\%opts,
           "ac_wrapper_org=s",
           "dbyte_wrapper_org=s"
          ) || Help();
&Help if(defined $opts{help});
sub Help{
  print "
        ";
};

system ("chmod 777 $opts{ac_wrapper_org}");
system ("chmod 777 $opts{dbyte_wrapper_org}");
open (AcWrapperOrg, "<$opts{ac_wrapper_org}") or die "ERROR: cannot read $opts{ac_wrapper_org}";
open (AcWrapperOrg1, "<$opts{ac_wrapper_org}") or die "ERROR1: cannot read $opts{ac_wrapper_org}";
open (DbyteWrapperOrg, "<$opts{dbyte_wrapper_org}") or die "ERROR: cannot read $opts{dbyte_wrapper_org}";
open (DbyteWrapperOrg1, "<$opts{dbyte_wrapper_org}") or die "ERROR1: cannot read $opts{dbyte_wrapper_org}";

system("touch dwc_ddrphy_ac_wrapper_ew.v");
system("chmod 777 dwc_ddrphy_ac_wrapper_ew.v");
open (AcWrapperEWOut, ">dwc_ddrphy_ac_wrapper_ew.v") or die "ERROR: cannot open dwc_ddrphy_ac_wrapper_ew.v for write!!!";

system("touch dwc_ddrphy_ac_wrapper_ns.v");
system("chmod 777 dwc_ddrphy_ac_wrapper_ns.v");
open (AcWrapperNSOut, ">dwc_ddrphy_ac_wrapper_ns.v") or die "ERROR: cannot open dwc_ddrphy_ac_wrapper_ns.v for write!!!";

system("touch dwc_ddrphy_dbyte_wrapper_ew.v");
system("chmod 777 dwc_ddrphy_dbyte_wrapper_ew.v");
open (DbyteWrapperEWOut, ">dwc_ddrphy_dbyte_wrapper_ew.v") or die "ERROR: cannot open dwc_ddrphy_dbyte_wrapper_ew.v for write!!!";

system("touch dwc_ddrphy_dbyte_wrapper_ns.v");
system("chmod 777 dwc_ddrphy_dbyte_wrapper_ns.v");
open (DbyteWrapperNSOut, ">dwc_ddrphy_dbyte_wrapper_ns.v") or die "ERROR: cannot open dwc_ddrphy_dbyte_wrapper_ns.v for write!!!";

while (<AcWrapperOrg>){
  $_=~ s/dwc_ddrphy_ac_wrapper/dwc_ddrphy_ac_wrapper_ew/;
  $_=~ s/dwc_ddrphydiff_top/dwc_ddrphydiff_top_ew/;
  $_=~ s/dwc_ddrphysec_top/dwc_ddrphysec_top_ew/;
  $_=~ s/dwc_ddrphyse_top/dwc_ddrphyse_top_ew/;
  
  print AcWrapperEWOut $_;
}

while (<AcWrapperOrg1>){
  $_=~ s/dwc_ddrphy_ac_wrapper/dwc_ddrphy_ac_wrapper_ns/;
  $_=~ s/dwc_ddrphydiff_top/dwc_ddrphydiff_top_ns/;
  $_=~ s/dwc_ddrphysec_top/dwc_ddrphysec_top_ns/;
  $_=~ s/dwc_ddrphyse_top/dwc_ddrphyse_top_ns/;
  
  print AcWrapperNSOut $_;
}

while (<DbyteWrapperOrg>){
  $_=~ s/dwc_ddrphy_dbyte_wrapper/dwc_ddrphy_dbyte_wrapper_ew/;
  $_=~ s/dwc_ddrphydiff_top/dwc_ddrphydiff_top_ew/;
  $_=~ s/dwc_ddrphysec_top/dwc_ddrphysec_top_ew/;
  $_=~ s/dwc_ddrphyse_top/dwc_ddrphyse_top_ew/;
  
  print DbyteWrapperEWOut $_;
}

while (<DbyteWrapperOrg1>){
  $_=~ s/dwc_ddrphy_dbyte_wrapper/dwc_ddrphy_dbyte_wrapper_ns/;
  $_=~ s/dwc_ddrphydiff_top/dwc_ddrphydiff_top_ns/;
  $_=~ s/dwc_ddrphysec_top/dwc_ddrphysec_top_ns/;
  $_=~ s/dwc_ddrphyse_top/dwc_ddrphyse_top_ns/;
  
  print DbyteWrapperNSOut $_;
}

print "Generate successfully: AC/DBYTE Wrapper has been generated\n";


