#! /usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use Time::Local;

my $prefix_file = "dfi_prefix_define.sv";
my %opts;
my $prefix;
my $ch_num;
my $upf;

GetOptions(\%opts,
          "prefix=s",
          "ch_num=s", 
          "upf=s", 
          "help"
           ) || HelpUser();

HelpUser() if (defined $opts{help});

#===================================================================================================
sub HelpUser {
#===================================================================================================
  print "
usage:  ctb_prefix.pl 
        -prefix=<cfg_name>        :.              
        -ch_num=<test_name>       :.
        -upf=<test_name>          : .
        -help                     : print help message.
";
  exit 1;
}

open (PREFIX, "> $prefix_file") or die "Can't open <$prefix_file>";

if(defined $opts{prefix}){
  $prefix =  $opts{prefix};
  #print $prefix;
  print PREFIX " \n";
  my $prefix_define = "$prefix"."_dwc_ddrphy_top";
  print PREFIX "`define dwc_ddrphy_top    $prefix_define   \n"; 

  print PREFIX " \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_DBYTES";
  print PREFIX "`define DWC_DDRPHY_NUM_DBYTES                       `$prefix_define   \n";     
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_RANKS";
  print PREFIX "`define DWC_DDRPHY_NUM_RANKS                        `$prefix_define   \n";     
  $prefix_define = "$prefix"."_DWC_DDRPHY_ATPG_SE_WIDTH";
  print PREFIX "`define DWC_DDRPHY_ATPG_SE_WIDTH                    `$prefix_define   \n";     
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_TOP_SCAN_CHAINS";   
  print PREFIX "`define DWC_DDRPHY_NUM_TOP_SCAN_CHAINS              `$prefix_define   \n";     
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL";
  print PREFIX "`define DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL           `$prefix_define   \n";     
  
  print PREFIX " \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WCK_CS_WIDTH";
  print PREFIX "`define DWC_DDRPHY_DFI0_WCK_CS_WIDTH           `$prefix_define   \n";           
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WCK_EN_WIDTH";
  print PREFIX "`define DWC_DDRPHY_DFI0_WCK_EN_WIDTH           `$prefix_define   \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_WCK_TOGGLE_WIDTH       `$prefix_define   \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_WCK_WRITE_WIDTH        `$prefix_define   \n"; 
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WRDATA_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_WRDATA_WIDTH           `$prefix_define   \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_WRDATA_CS_WIDTH        `$prefix_define   \n"; 
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_WRDATA_EN_WIDTH        `$prefix_define   \n"; 
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_WRDATA_LINK_ECC_WIDTH  `$prefix_define   \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH";
  print PREFIX "`define DWC_DDRPHY_DFI0_WRDATA_MASK_WIDTH      `$prefix_define   \n"; 
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_RDDATA_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_RDDATA_WIDTH           `$prefix_define   \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_RDDATA_CS_WIDTH        `$prefix_define   \n"; 
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_RDDATA_DBI_WIDTH       `$prefix_define   \n"; 
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_RDDATA_EN_WIDTH        `$prefix_define   \n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH";
  print PREFIX "`define DWC_DDRPHY_DFI0_RDDATA_VALID_WIDTH     `$prefix_define   \n";              
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_CKE_WIDTH";
  print PREFIX "`define DWC_DDRPHY_DFI0_CKE_WIDTH              `$prefix_define   \n"; 
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_CS_WIDTH";  
  print PREFIX "`define DWC_DDRPHY_DFI0_CS_WIDTH               `$prefix_define   \n";  
  $prefix_define = "$prefix"."_DWC_DDRPHY_DFI0_P0_ADDRESS_MSB";  
  print PREFIX "`define DWC_DDRPHY_DFI0_P0_ADDRESS_MSB         `$prefix_define   \n";  

  #================================================================================================
  #                                  channal = 2 
  #================================================================================================
  if(defined $opts{ch_num}){
     $ch_num = $opts{ch_num};
     if($ch_num == 2){
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WCK_CS_WIDTH";
       print PREFIX "`define DWC_DDRPHY_DFI1_WCK_CS_WIDTH           `$prefix_define   \n";           
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WCK_EN_WIDTH";
       print PREFIX "`define DWC_DDRPHY_DFI1_WCK_EN_WIDTH           `$prefix_define   \n";
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_WCK_TOGGLE_WIDTH       `$prefix_define   \n";
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_WCK_WRITE_WIDTH        `$prefix_define   \n"; 
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WRDATA_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_WRDATA_WIDTH           `$prefix_define   \n";
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_WRDATA_CS_WIDTH        `$prefix_define   \n"; 
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_WRDATA_EN_WIDTH        `$prefix_define   \n"; 
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_WRDATA_LINK_ECC_WIDTH  `$prefix_define   \n";
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH";
       print PREFIX "`define DWC_DDRPHY_DFI1_WRDATA_MASK_WIDTH      `$prefix_define   \n"; 
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_RDDATA_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_RDDATA_WIDTH           `$prefix_define   \n";
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_RDDATA_CS_WIDTH        `$prefix_define   \n"; 
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_RDDATA_DBI_WIDTH       `$prefix_define   \n"; 
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_RDDATA_EN_WIDTH        `$prefix_define   \n";
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH";
       print PREFIX "`define DWC_DDRPHY_DFI1_RDDATA_VALID_WIDTH     `$prefix_define   \n";              
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_CKE_WIDTH";
       print PREFIX "`define DWC_DDRPHY_DFI1_CKE_WIDTH              `$prefix_define   \n"; 
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_CS_WIDTH";  
       print PREFIX "`define DWC_DDRPHY_DFI1_CS_WIDTH               `$prefix_define   \n";  
       $prefix_define = "$prefix"."_DWC_DDRPHY_DFI1_P0_ADDRESS_MSB";  
       print PREFIX "`define DWC_DDRPHY_DFI1_P0_ADDRESS_MSB         `$prefix_define   \n";  
     };
  };

  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_TOP_PG_PINS";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_TOP_PG_PINS                                    \n";
  print PREFIX "`endif \n";

  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_DBYTES_8";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_DBYTES_8                                    \n";
  print PREFIX "`endif \n";

  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_DBYTES_4";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_DBYTES_4                                   \n";
  print PREFIX "`endif \n";

  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_LPDDR5_ENABLED";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_LPDDR5_ENABLED                                 \n";
  print PREFIX "`endif \n";

  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_CHANNELS_2";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_CHANNELS_2                                 \n";
  print PREFIX "`endif \n";
  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_2                       \n";
  print PREFIX "`endif \n";
  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_DBYTES_PER_CHANNEL_4                       \n";
  print PREFIX "`endif \n";

  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_DBYTE_DMI_ENABLED";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_DBYTE_DMI_ENABLED                              \n";
  print PREFIX "`endif \n";

  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_ANIBS_3";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_ANIBS_3                                    \n";
  print PREFIX "`endif \n";
  
  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_ANIBS_6";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_ANIBS_6                                    \n";
  print PREFIX "`endif \n";
  
  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_ANIBS_10";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_ANIBS_10                                   \n";
  print PREFIX "`endif \n";
  
  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_ANIBS_12";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_ANIBS_12                                   \n";
  print PREFIX "`endif \n";
  
  print PREFIX "\n";
  $prefix_define = "$prefix"."_DWC_DDRPHY_NUM_ANIBS_14";
  print PREFIX "`ifdef $prefix_define                                             \n";
  print PREFIX "`define DWC_DDRPHY_NUM_ANIBS_14                                   \n";
  print PREFIX "`endif \n";
  } else {
  print "the prefix define null !\n"; 
  };

close PREFIX;
system("chmod 775 ./$prefix_file");
print "[Prefix define] prefix define file end !\n"; 

