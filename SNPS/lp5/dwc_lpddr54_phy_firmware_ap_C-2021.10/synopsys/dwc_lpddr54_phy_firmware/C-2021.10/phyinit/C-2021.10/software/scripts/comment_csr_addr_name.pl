#!/usr/bin/perl -w

use Getopt::Long;

GetOptions (
   'reg=s'=> \$reg_map,
   'init=s'=>\$init,
   'o=s'=> \$outfile,
   ) or usage();

sub usage {
  print "perl $0 -reg=reg_map_file -init=init_input_file -o output_init_file\n";
  exit;
}

my %reg_name;
open (REG_MAP, "<$reg_map") || die "Error opening $reg_map";
while (<REG_MAP>) {
  if ($_ =~ /^\s*0x(\S+)\s+(\S+)\s*$/) {
    $reg_name{$1} = $2;
  }
}
close (REG_MAP);

my ($line, $i);
open (INIT, "<$init") || die "Error opening $init";
open (OUT, ">$outfile") || die "Error opening $outfile";
while ($line = <INIT>) {
  if ($line =~ /.*apb_wr\(32'h([^,]+),16'h\S+\);/ or $line =~ /.*apb_rd\(32'h([^,]+)\);/ ) {
    if (exists $reg_name{"$1"}) {
      $i = $reg_name{"$1"}; 
      $line =~ s/\)\;/); \/\/ $i/g;
    }
  }
  print OUT "$line";
}

close (INIT);
close (OUT);

