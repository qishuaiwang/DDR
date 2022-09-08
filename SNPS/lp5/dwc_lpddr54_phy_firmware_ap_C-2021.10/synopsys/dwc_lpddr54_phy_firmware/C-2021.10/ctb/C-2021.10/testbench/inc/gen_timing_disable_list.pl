#!/usr/bin/perl

#use strict;
use warnings;
#use Switch;

my $dbyte_num=$ARGV[0];
my $timing_disable_list;
my $count=0;
my @data_regs;

system ("chmod 777 $ARGV[1]");
open (Af, "<$ARGV[1]") or die "ERROR: cannot read $ARGV[1]";
#open (Bf, ">$ARGV[2]") or die "ERROR: cannot write $ARGV[2]";
open($timing_disable_list,">./gatesim_timing_disable_list_sub.sv")or die "Could not open file gatesim_timing_disable_list_sub.sv";

while (<Af>){
  if($_ =~ /F.*DP.*Q.*RxDatLn0_/){
    my @words = split /\s+/,$_;
    for my $word (@words){
      if ($word =~ /RxDatLn0_/){
        if ($count < 8){
          #print Bf "$word\n";
          push(@data_regs,$word);
          $count++;
        }
      } 
    }
  }
}

  print $timing_disable_list "`ifdef DWC_DDRPHY_GATESIM_SDF\n";
  print $timing_disable_list "initial begin\n";
  print $timing_disable_list "  wait(test.top.dut.u_DWC_ddrphy_pub.csrResetToMicro===1'b1);\n";
  print $timing_disable_list "  forever begin\n";
  print $timing_disable_list "    @(negedge test.top.dut.u_DWC_ddrphy_pub.csrStallToMicro);\n";
  print $timing_disable_list "    fork\n";
  for(my $i=0;$i<$dbyte_num;$i=$i+1) {
    print $timing_disable_list "      begin\n";
    print $timing_disable_list "        wait(test.top.dut.u_DWC_ddrphy_pub.dx_${i}.csrDFIMRL[4:0]==0);\n";
    print $timing_disable_list "      `ifdef DWC_DDRPHY_EXISTS_DB${i}\n";
    for(my $j=0;$j<8;$j=$j+1) {
      for my $data_reg (@data_regs){
        print $timing_disable_list "        force test.top.dut.u_DBYTE_WRAPPER_${i}.SE_${j}.RXDATAFIFO.DFE0_RXDATA.$data_reg.viol_0=1'b0;\n";
        print $timing_disable_list "        force test.top.dut.u_DBYTE_WRAPPER_${i}.SE_${j}.RXDATAFIFO.DFE1_RXDATA.$data_reg.viol_0=1'b0;\n";
      }
    }
    print $timing_disable_list "        `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED\n";
    for my $data_reg (@data_regs){
      print $timing_disable_list "        force test.top.dut.u_DBYTE_WRAPPER_${i}.SE_8.RXDATAFIFO.DFE0_RXDATA.$data_reg.viol_0=1'b0;\n";
      print $timing_disable_list "        force test.top.dut.u_DBYTE_WRAPPER_${i}.SE_8.RXDATAFIFO.DFE1_RXDATA.$data_reg.viol_0=1'b0;\n";
    }
    print $timing_disable_list "        `endif\n";
    print $timing_disable_list "      `endif\n";
  print $timing_disable_list "      end\n";
  }
  print $timing_disable_list "    join\n";
  print $timing_disable_list "    @(posedge test.top.dut.u_DWC_ddrphy_pub.csrStallToMicro);\n";
  for(my $i=0;$i<$dbyte_num;$i=$i+1) {
    print $timing_disable_list "    `ifdef DWC_DDRPHY_EXISTS_DB${i}\n";
    for(my $j=0;$j<8;$j=$j+1) {
      for my $data_reg (@data_regs){
        print $timing_disable_list "      release test.top.dut.u_DBYTE_WRAPPER_${i}.SE_${j}.RXDATAFIFO.DFE0_RXDATA.$data_reg.viol_0;\n";
        print $timing_disable_list "      release test.top.dut.u_DBYTE_WRAPPER_${i}.SE_${j}.RXDATAFIFO.DFE1_RXDATA.$data_reg.viol_0;\n";
      }
    }
    print $timing_disable_list "      `ifdef DWC_DDRPHY_DBYTE_DMI_ENABLED\n";
    for my $data_reg (@data_regs){
      print $timing_disable_list "      release test.top.dut.u_DBYTE_WRAPPER_${i}.SE_8.RXDATAFIFO.DFE0_RXDATA.$data_reg.viol_0;\n";
      print $timing_disable_list "      release test.top.dut.u_DBYTE_WRAPPER_${i}.SE_8.RXDATAFIFO.DFE1_RXDATA.$data_reg.viol_0;\n";
    }
    print $timing_disable_list "      `endif\n";
    print $timing_disable_list "    `endif\n";
  }
  print $timing_disable_list "  end\n";
  print $timing_disable_list "end\n";
  print $timing_disable_list "`endif\n";

close $timing_disable_list;
