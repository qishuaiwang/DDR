#!/usr/local/bin/tclsh

set test        [lindex $argv 0]
set protocol    [lindex $argv 1]
set skip_train  [lindex $argv 2]
set disable2d   [lindex $argv 3]
set cfg         [lindex $argv 4]
set default_c   [lindex $argv 5]
set override_c  [lindex $argv 6]
set hard_macro  [lindex $argv 7]
set emul        [lindex $argv 8]
set ret_en      [lindex $argv 9]

set ipxact_old  0

#add for back door
set bkdoor      [lindex $argv 10]
#add for different pub version in phyinit
set pub_ver    [lindex $argv 11]
#add for quickboot mode
set quickboot    [lindex $argv 12]

set ctb_home $env(CTB_HOME)
set release $env(release)

if { [info exists env(CORETOOLS)]} {
  set coretools $env(CORETOOLS)
} else {
  set coretools 1
}
# ------------------------------------------------
# locations
# ------------------------------------------------
if {$release==0} {
  set phyinit_dir $env(CTB_HOME)/../build/c/init/
  set ipxact_dir $env(CTB_HOME)/../build/rtl/src/dwc_ddrphy_top/export   
} elseif {$release==1} {
  set phyinit_dir $env(CTB_PHYINIT_DIR)
  if {$coretools==1} {
    set ipxact_dir $env(CTB_HOME)/../../export
  } else {
    set ipxact_dir $env(CTB_HOME)/../../macro/Latest/ipxact
  }
} elseif {$release==2} {
  set phyinit_dir $env(CTB_PHYINIT_DIR)
  if {$coretools==1} {
    set ipxact_dir $env(CTB_HOME)/../../export
  } else {
  set ipxact_dir $env(CTB_PUB_DIR)/phy_top/ipxact
  }
}  


#--------------------------------------------------------------------------------
proc read_xml_old {xml_file} {
  set XF [open $xml_file r]
  set OF [open ".map.tcl" w]
  set blk 0; set reg 0; set fld 0
  set map_name dwc_ddrphy_top
  puts $OF "create_memory_map $map_name"
  while {[gets $XF line] >=0} {
    set line [string trim $line]
    regexp {<(.+)>(.+)<(.+)>} $line m s d e

    if {$line == "<spirit:addressBlock>"} {set blk 1; continue}
    if {$line == "<spirit:register>"} {
      if $blk {
        puts $OF "create_address_block $bname -map $map_name -base_address $baddr -range $brange -width $bwidth"
        set blk 0
      }
      set reg 1;continue
    }
    if {$line == "<spirit:field>"}    {set fld 1;continue}
    if {$line == "</spirit:register>"} {
      set reg 0
    }
    if {$line == "</spirit:reset>"} {
      puts $OF "create_register $rname -block $map_name/$bname -offset $raddr -size 32"
      puts $OF "set_register_attribute $rname Description \{$rdes\}"
      puts $OF "set_register_attribute $rname RegisterResetValue $rval"
      continue
    }
    if {$line == "</spirit:field>"} {
      set fld 0
      puts $OF "create_register_field $fname -register $rname -offset $foffs -size $fwidth"
      puts $OF "set_register_field_attribute $rname/$fname Description \{$fdes\}"
      puts $OF "set_register_field_attribute $rname/$fname MemoryAccess $ftype"
      continue
    }
    if {$line == "</spirit:field>"} {set fld 0;continue}
    if $blk {
      if {$s == "spirit:name"}        {set bname  $d}
      if {$s == "spirit:description"} {set bdescr $d}
      if {$s == "spirit:baseAddress"} {set baddr  $d}
      if {$s == "spirit:range"}       {set brange $d}
      if {$s == "spirit:width"}       {set bwidth $d}
    }
    if $reg {
      if $fld {
        set fdes ""
        if {$s == "spirit:name"} {set fname $d}
        if {$s == "spirit:description"} {set fdes $d}
        if {$s == "spirit:bitOffset"}   {set foffs $d}
        if {$s == "spirit:bitWidth"}    {set fwidth $d}
        if {$s == "spirit:access"}      {set ftype $d}
      } else {   
        if {$s == "spirit:name"}          {set rname $d}
        if {$s == "spirit:description"}   {set rdes $d}
        if {$s == "spirit:value"}         {set rval $d}
        if {$s == "spirit:addressOffset"} {set raddr $d}
      } 
    }
  }  
  close $XF; close $OF
  uplevel 1 {source .map.tcl}
#  uplevel 1 {set_fld_reset_vals}
}


proc read_xml_new {xml_file} {
  set XF [open $xml_file r]
  set OF [open ".map.tcl" w]
  set blk 0; set reg 0; set fld 0
  set map_name dwc_ddrphy_top
  puts $OF "create_memory_map $map_name"
  while {[gets $XF line] >=0} {
    set line [string trim $line]
    regsub {\'h} $line 0x line
    regexp {<(.+)>(.+)<(.+)>} $line m s d e

    if {$line == "<ipxact:addressBlock>"} {set blk 1; continue}
    if {$line == "<ipxact:register>"} {
      if $blk {
        puts $OF "create_address_block $bname -map $map_name -base_address $baddr -range $brange -width $bwidth"
        set blk 0
      }
      set reg 1;continue
    }
    if {$line == "<ipxact:field>"}    {set fld 1;continue}
    if {$line == "</ipxact:register>"} {
      set reg 0
    }
    if {$line == "</ipxact:reset>"} {
      puts $OF "create_register $rname -block $map_name/$bname -offset $raddr -size 32"
      puts $OF "set_register_attribute $rname Description \{$rdes\}"
      #puts $OF "set_register_attribute $rname RegisterResetValue $rval"
      continue
    }
    if {$line == "</ipxact:field>"} {
      set fld 0
      puts $OF "create_register_field $fname -register $rname -offset $foffs -size $fwidth"
      puts $OF "set_register_field_attribute $rname/$fname Description \{$fdes\}"
      puts $OF "set_register_field_attribute $rname/$fname MemoryAccess $ftype"
      continue
    }
    if {$line == "</ipxact:field>"} {set fld 0;continue}
    if $blk {
      if {$s == "ipxact:name"}        {set bname  $d}
      if {$s == "ipxact:description"} {set bdescr $d}
      if {$s == "ipxact:baseAddress"} {set baddr  $d}
      if {$s == "ipxact:range"}       {set brange $d}
      if {$s == "ipxact:width"}       {set bwidth $d}
    }
    if $reg {
      if $fld {
        set fdes ""
        if {$s == "ipxact:name"} {set fname $d}
        if {$s == "ipxact:description"} {set fdes $d}
        if {$s == "ipxact:bitOffset"}   {set foffs $d}
        if {$s == "ipxact:bitWidth"}    {set fwidth $d}
        if {$s == "ipxact:access"}      {set ftype $d}
      } else {   
        if {$s == "ipxact:name"}          {set rname $d}
        if {$s == "ipxact:description"}   {set rdes $d}
        if {$s == "ipxact:value"}         {set rval $d}
        if {$s == "ipxact:addressOffset"} {set raddr $d}
      } 
    }
  }  
  close $XF; close $OF
  uplevel 1 {source .map.tcl}
#  uplevel 1 {set_fld_reset_vals}
}

#==========================================================
proc hex2bin {hex} {
  set bin ""
  for {set i 0} {$i < [string length $hex]} {incr i} {
    switch [string index $hex $i] {
	0 {set bin "${bin}0000"}
	1 {set bin "${bin}0001"}
	2 {set bin "${bin}0010"}
	3 {set bin "${bin}0011"}
	4 {set bin "${bin}0100"}
	5 {set bin "${bin}0101"}
	6 {set bin "${bin}0110"}
	7 {set bin "${bin}0111"}
	8 {set bin "${bin}1000"}
	9 {set bin "${bin}1001"}
	a {set bin "${bin}1010"}
	b {set bin "${bin}1011"}
	c {set bin "${bin}1100"}
	d {set bin "${bin}1101"}
	e {set bin "${bin}1110"}
	f {set bin "${bin}1111"}
    }
  }
  return $bin
}
#-----------------------------------------------------------------------
proc bin2hex {bin} {
    set t {
         0000 0 0001 1 0010 2 0011 3 0100 4 0101 5 0110 6 0111 7
         1000 8 1001 9 1010 a 1011 b 1100 c 1101 d 1110 e 1111 f
    }
    if {[set diff [expr {4-[string length $bin]%4}]] != 4} {
         set bin [format %0${diff}d$bin 0]
    }
    return [string map $t $bin]
 }


########################################################################
# Reg DB procs
########################################################################

proc read_map {file} {
  set IF [open $file r]
  set OF [open ".mem_map.tcl" w]
  while {[gets $IF line] >=0} {
    regsub -all @ $line \$ line
    regsub -all eval_param $line expr line
    if [string match "*RegisterResetValue \{=*" $line] {
      regsub "RegisterResetValue \{=" $line "RegisterResetValue \[expr " line
      regsub {\}$} $line \] line
    }
    puts $OF $line
  }
  close $OF
  close $IF
  uplevel 1 {source .mem_map.tcl}
}


#-----------------------------------------------------------------------
proc set_reg_value {name value} {
  global reg fld
  if {$release==0} {
    set reg($name,value) "0x$value"
    set bval [hex2bin $value]
    foreach f $reg($name,flds) {
      set start [expr 32 - [get_fld_attr $f size] - [get_fld_attr $f offset]]
      set end   [expr 31 - [get_fld_attr $f offset]]
      set fld($f,value) "0x[bin2hex [string range $bval $start $end]]"
    }
  } else {
    set reg($name,value) "'h$value"
    set bval [hex2bin $value]
    foreach f $reg($name,flds) {
      set start [expr 32 - [get_fld_attr $f size] - [get_fld_attr $f offset]]
      set end   [expr 31 - [get_fld_attr $f offset]]
      set fld($f,value) "'h[bin2hex [string range $bval $start $end]]"
    }
  }
}

#-----------------------------------------------------------------------
proc read_macros {define_file} {
  set IF [open $define_file r]
  while {[gets $IF line] >=0} {
    if [regexp {(.+) = (.+)} $line m name value] {
      set ::$name $value
    }
  }
  close $IF
}

#-----------------------------------------------------------------------
proc check_reg_changed {r} {
  set retval 0
  foreach f [get_reg_attr $r flds] {
    if {[get_fld_attr $f value] != "" & [get_fld_attr $f RegisterResetValue] != ""} {
      if {[get_fld_attr $f value] != [get_fld_attr $f RegisterResetValue]} {set retval 1}
    }
  }
  return $retval
}

#-----------------------------------------------------------------------
proc eval_str {str} {
  if [regsub "=" $str "expr " retval] {
    return [eval $retval]
  } else {
   return $str
  }
} 

#-----------------------------------------------------------------------
proc create_memory_map {name} {
  global map
  set map($name,blocks) ""
}

#-----------------------------------------------------------------------
proc set_memory_map_attribute {name attr_name attr_value} {
  global map
  set map($name,$attr_name) $attr_value
}

#-----------------------------------------------------------------------
proc create_address_block {args} {
  global map block 
  for {set i 0} {$i< [llength $args]} {incr i} {
    set arg [lindex $args $i]
    set narg [lindex $args [expr $i+1]]

    if {$i==0} {set name $arg}
      if {$arg == "-map"}        {set name $narg/$name; set block($name,map) $narg; lappend map($narg,blocks) $name}
    if {$arg == "-base_address"} {set block($name,base_address) $narg}
    if {$arg == "-range"}        {set block($name,range) $narg}
    if {$arg == "-width"}        {set block($name,width) $narg}
  }
  set block($name,regs) ""
}

#-----------------------------------------------------------------------
proc set_address_block_attribute {args} {
  global block
  set block([lindex $args 0],[lindex $args 1]) [lindex $args 2]
}

#-----------------------------------------------------------------------
proc create_register {args} {
  global block reg adr
  if {[llength $args] >= 7} {
    for {set i 0} {$i< [llength $args]} {incr i} {
        set arg [lindex $args $i]
        set narg [lindex $args [expr $i+1]]
        if {$i==0} {set name $arg}
        if {$arg == "-block"}  {set name $narg/$name; lappend block($narg,regs) $name; set base_address $block($narg,base_address)}
        if {$arg == "-offset"} {
          set reg($name,offset) $narg
	  set adr([format %04X [expr $narg + $base_address]]) $name
        }
        if {$arg == "-size"}   {set reg($name,size) $narg}
    }
    set reg($name,flds) ""
  }
}
#-----------------------------------------------------------------------
proc set_register_attribute {args} {
  global reg
  set name [lindex $args 0]
  regsub "=" [lindex $args 2] "expr" attr_value
  set reg($name,[lindex $args 1]) $attr_value
}

#-----------------------------------------------------------------------
proc create_register_field {args} {
  global fld reg
  for {set i 0} {$i< [llength $args]} {incr i} {
     set arg [lindex $args $i]
     set narg [lindex $args [expr $i+1]]
     if {$i==0} {set name $arg}
     if {$arg == "-register"}  {set rname $narg; lappend reg($rname,flds) $rname/$name}
      if {$arg == "-offset"}    {set fld($rname/$name,offset) [eval_str $narg]}
      if {$arg == "-size"}      {set fld($rname/$name,size) [eval_str $narg]}
  }
}

#-----------------------------------------------------------------------
proc set_register_field_attribute {args} {
  global fld
  set attr_value [string trimleft [lindex $args 2] "="]
  set fld([lindex $args 0],[lindex $args 1]) $attr_value
}
    
#-----------------------------------------------------------------------
proc eval_param {arg} {
  return [expr $arg]
}

#-----------------------------------------------------------------------
proc current_map {name} {
  global map
  set map(current) $name
}
#-----------------------------------------------------------------------
proc all_blocks {} {
  global map
  return $map($map(current),blocks) 
}
#-----------------------------------------------------------------------
proc current_block {name} {
  global block
  set block(current) $name
}
#-----------------------------------------------------------------------
proc all_regs {{short 0}} {
  global block
  set rl ""
  if $short {
    foreach r $block($block(current),regs) {
      lappend rl [file tail $r]
    }
    return $rl
  } else {
    return $block($block(current),regs) 
  }
}

#-----------------------------------------------------------------------
proc all_control_regs {} {
  global reg
  set ret_val ""
  foreach rname [all_regs] {
    if ![string match "*Status *" $reg($rname,Description)] {lappend ret_val $rname}
  }
  return $ret_val
}

#-----------------------------------------------------------------------
proc all_status_regs {} {
  global reg
  set ret_val ""
  foreach rname [all_regs] {
    if [string match "*Status *" $reg($rname,Description)] {lappend ret_val $rname}
  }
  return $ret_val
}

#-----------------------------------------------------------------------
proc current_reg {name} {
  global reg
  set reg(current) $name
}
#-----------------------------------------------------------------------
proc all_fields {} {
  global reg
  return $reg($reg(current),flds) 
}
#-----------------------------------------------------------------------
proc get_reg_attr {obj name} {
  global reg
  if [info exists reg($obj,$name)] { 
    return $reg($obj,$name) 
  } else {
    return ""
  }
}
#-----------------------------------------------------------------------
proc get_fld_attr {obj name} {
  global fld
  if [info exists fld($obj,$name)] { 
    return $fld($obj,$name) 
  } else {
    return ""
  }
}

#-----------------------------------------------------------------------
proc put {line } {
  global channel
  if [info exists channel] {
    $channel insert end "$line\n"
  } else {
   puts $line
  }
}

#-----------------------------------------------------------------------
proc print_reg {r} {
  put "--------------------------------------------------------------------------------------------------------"
  put "[file tail $r] : [get_reg_attr $r offset]"
  put "--------------------------------------------------------------------------------------------------------"
  put "Field Name           |From |To   | Reset Val  | Actual Val | Description"
  put "--------------------------------------------------------------------------------------------------------"

  foreach f [get_reg_attr $r flds] {
    put [format "%-20s | %-3d | %-3d | %-10s | %-10s | %-40s"  [file tail $f]  [expr [get_fld_attr $f offset] + [get_fld_attr $f size] -1]  [get_fld_attr $f offset]  [get_fld_attr $f RegisterResetValue]  [get_fld_attr $f value]  [get_fld_attr $f Description]]
  }
  put "--------------------------------------------------------------------------------------------------------"
}

#-----------------------------------------------------------------------
proc write_defines {out_file} {
  global adr
  set OF [open $out_file w]
  foreach a [array names adr] {
    set rs [split $adr($a) /]
    puts $OF  "`define [lindex $rs 1]_[lindex $rs 2] 32'h$a"
  }   
  close $OF
}

#-----------------------------------------------------------------------
proc write_apb_map {out_file} {
  global adr
  set OF [open $out_file w]
  foreach a [array names adr] {
    set rs [split $adr($a) /]
    set rname "[lindex $rs 1]_[lindex $rs 2]"
    puts $OF "if (addr == 32'h$a && cfg.debug >=1 ) \$display\(\"  access to $rname\"\)\;"
  }
  close $OF
}

proc GenDmemData { textfile} {
# grap the dmem apb write data and change it into pmu_train_dmem_ecc1.txt

eval exec "./incv2memdat.pl -f $textfile -o pmu_train_dmem_ecc -type 2 -ecc"

}

proc GenImemData { textfile} {

eval exec "./incv2memdat.pl -f $textfile -o pmu_train_imem_ecc -type 2 -iccm -ecc"

}

#--------------------------------------------------------------------------------
proc gen_apb_config {protocol init_type ret_en} {
  global test
  global ctb_home
  global bkdoor
  


  if {$init_type == 0} { ;#no train
    set phyinit_txt   ".fw/$protocol/output/dwc_ddrphy_phyinit_out_${protocol}_skiptrain.txt"
  } elseif {$init_type == 1} {  ;# train
    set phyinit_txt   ".fw/$protocol/output/dwc_ddrphy_phyinit_out_${protocol}_train.txt"
  } elseif {$init_type == 2} {;#disable2d=0
    set phyinit_txt   ".fw/$protocol/output/dwc_ddrphy_phyinit_out_${protocol}_train1d2d.txt"
  } elseif {$init_type == 3} {;# devinit
    set phyinit_txt   ".fw/$protocol/output/dwc_ddrphy_phyinit_out_${protocol}_devinit_skiptrain.txt"
  } elseif {$init_type == 5} {;# dc characterization
    set phyinit_txt   "$ctb_home/../build/c/ate/rl/vihl_out/dwc_ddrphy_dqs_vix_setup.txt"
  }
  
  if {$bkdoor !=0} {
    GenImemData $phyinit_txt
    GenDmemData $phyinit_txt
  }

  set IF [open $phyinit_txt r]
  
  set OF [open "apb_config.sv" w]
  
  puts $OF "//Generate from $phyinit_txt"
  puts $OF "task apb_config_all;"

  #while {[gets $IF line] >= 0} {
  #  puts $OF $line;
  #}   



  if {$bkdoor==1} {
    set IMemStart 0
    set DMemStart 0
    set MemDone 0
    #set IReadMemh "\$readmemh(\"pmu_train_imem_ecc.txt\",top.u_srams.u_iccm_ram0.iccm_mem_0);"
    #set IWriteMemh "\$writememh(\"writedaticcm.txt\",top.u_srams.u_iccm_ram0.iccm_mem_0);"
    ##set DReadMemh "\$readmemh(\"pmu_train_dmem_ecc.txt\",top.u_srams.u_dccm_ram0.dccm_mem_1);"
    #set DReadMemh "\$readmemh(\"pmu_train_dmem_ecc.txt\",top.u_srams.u_dccm_ram0.dccm_mem_1);"
    #set DWriteMemh "\$writememh(\"writedatdccm.txt\",top.u_srams.u_dccm_ram0.dccm_mem_1);"
    set DmemNum 0

    while {[gets $IF line] >= 0} {
    
      if [regexp {(dwc_ddrphy_phyinit_WriteOutMem).*0x50000} $line m  ] {
        puts $OF $line;
        puts $OF "\$readmemh(\"pmu_train_imem_ecc.txt\",top.u_srams.u_iccm_ram0.iccm_mem_0);";
        puts $OF "\$writememh(\"writedaticcm.txt\",top.u_srams.u_iccm_ram0.iccm_mem_0);";
        set IMemStart 1
        set MemDone 0
      }
      if [regexp {(dwc_ddrphy_phyinit_WriteOutMem).*0x58000} $line m  ] {
        puts $OF $line;
        set DmemNum [expr $DmemNum + 1]
        puts $OF "\$readmemh(\"pmu_train_dmem_ecc$DmemNum.txt\",top.u_srams.u_dccm_ram0.dccm_mem_1);";
        puts $OF "\$writememh(\"writedatdccm$DmemNum.txt\",top.u_srams.u_dccm_ram0.dccm_mem_1);";
        set DMemStart 1
        set MemDone 0
      }
      if [regexp {(dwc_ddrphy_phyinit_WriteOutMem).*(DONE)} $line m Done ] {
        puts $OF $line;
        set MemDone 1
      }
    
    
      if {$IMemStart == 1 & $DMemStart == 0 & $MemDone == 0} {;
      
      } elseif {$IMemStart == 1 & $DMemStart == 1 & $MemDone == 0} {;
    
      } else {;
    
      puts $OF $line;
    
      }
      
    }
  } else {
    while {[gets $IF line] >= 0} {
      puts $OF $line;
    } 
  }

  puts $OF "endtask : apb_config_all\n"
  
  if {$ret_en == 1} {;
    close $IF
    set IF [open $phyinit_txt r]
    puts "INFO: start processing retention txt"
    set valid_line 0
    set ret_line 0
    set ret_end 0
    set csr_idx 0
    array set ret_reg_addr ""
    while {[gets $IF line] >= 0} {
      if [regexp {(.*)Start of dwc_ddrphy_phyinit_C_initPhyConfig\(\)} $line m dm] {
        puts "INFO: start task: dwc_ddrphy_phyinit_C_initPhyConfig()"
        puts $OF "task dwc_ddrphy_phyinit_C_initPhyConfig();";
        set valid_line 1
      }
      if [regexp {(.*)End of dwc_ddrphy_phyinit_C_initPhyConfig\(\)} $line m dm] {
        puts "INFO: end task: dwc_ddrphy_phyinit_C_initPhyConfig()"
        puts $OF "endtask // dwc_ddrphy_phyinit_C_initPhyConfig()\n";
        set valid_line 0
      }
      if [regexp {(.*)start of dwc_ddrphy_phyinit_userCustom_saveRetRegs()} $line m dm] {
        puts "INFO: new task: dwc_ddrphy_phyinit_userCustom_saveRetRegs()"
        set ret_line 1
      }
      if [regexp {(.*)End of dwc_ddrphy_phyinit_userCustom_saveRetRegs()} $line m dm] {
        puts "INFO: end task: dwc_ddrphy_phyinit_userCustom_saveRetRegs()"
        set ret_line 0
        set ret_end 1
      }
      if [regexp {(.*)Start of dwc_ddrphy_phyinit_I_loadPIEImage\(\)} $line m dm] {
        puts "INFO: new task: dwc_ddrphy_phyinit_I_loadPIEImage()"
        puts $OF "task dwc_ddrphy_phyinit_I_loadPIEImage();";
        set valid_line 1
      }
      if [regexp {(.*)End of dwc_ddrphy_phyinit_I_loadPIEImage\(\)} $line m dm] {
        puts "INFO: end task: dwc_ddrphy_phyinit_I_loadPIEImage()"
        puts $OF "endtask // dwc_ddrphy_phyinit_I_loadPIEImage()\n";
        set valid_line 0
      }
      if $valid_line {
        puts $OF $line;
      }
      if $ret_line {
        if [regexp {(.*)dwc_ddrphy_apb_rd\((.*)\);(.*)} $line m dm addr name] {
          set ret_reg_addr($csr_idx) $addr
          set csr_idx [expr $csr_idx + 1]
        }
      }
      if $ret_end {
        set ret_end 0
        if {$protocol == "lpddr3" || $protocol == "lpddr4"} {
          set uhclk_dis "2"
        } else {
          set uhclk_dis "0"
        }
        puts $OF "bit\[15:0\] ret_csrs\[$csr_idx:0\];\n";
        puts "INFO: new task: apb_save_ret_csrs()"
        puts $OF "task apb_save_ret_csrs();";
        puts $OF "dwc_ddrphy_apb_wr(32'hd0000,16'h0); // DWC_DDRPHYA_APBONLY0_MicroContMuxSel";
        puts $OF "dwc_ddrphy_apb_wr(32'hc0080,16'h3); // DWC_DDRPHYA_DRTUB0_UcclkHclkEnables\n";
        for {set i 0} {$i < $csr_idx} {incr i} {
          puts $OF "dwc_ddrphy_apb_rd($ret_reg_addr($i),ret_csrs\[$i\]);";
        }
        puts $OF "\ndwc_ddrphy_apb_wr(32'hc0080,16'h$uhclk_dis); // DWC_DDRPHYA_DRTUB0_UcclkHclkEnables";
        puts $OF "dwc_ddrphy_apb_wr(32'hd0000,16'h1); // DWC_DDRPHYA_APBONLY0_MicroContMuxSel\n";
        puts $OF "endtask // apb_save_ret_csrs()\n";
        
        puts "INFO: new task: apb_restore_ret_csrs()"
        puts $OF "task apb_restore_ret_csrs();";
        puts $OF "dwc_ddrphy_apb_wr(32'hd0000,16'h0); // DWC_DDRPHYA_APBONLY0_MicroContMuxSel";
        puts $OF "dwc_ddrphy_apb_wr(32'hc0080,16'h3); // DWC_DDRPHYA_DRTUB0_UcclkHclkEnables\n";
        for {set i 0} {$i < $csr_idx} {incr i} {
          puts $OF "dwc_ddrphy_apb_wr($ret_reg_addr($i),ret_csrs\[$i\]);";
        }
        puts $OF "\ndwc_ddrphy_apb_wr(32'hc0080,16'h$uhclk_dis); // DWC_DDRPHYA_DRTUB0_UcclkHclkEnables";
        puts $OF "dwc_ddrphy_apb_wr(32'hd0000,16'h1); // DWC_DDRPHYA_APBONLY0_MicroContMuxSel\n";
        puts $OF "endtask // apb_restore_ret_csrs()\n";
      }
    }
  }
  close $IF
  close $OF
}

proc create_ipxact {} {
  global ipxact_dir
  puts "ipxact_dir=$ipxact_dir"
  set create_ipxact [open $ipxact_dir/create_ipxact.tcl w+]
  puts $create_ipxact "echo \"start open workspace ${ipxact_dir}/..\""
  puts $create_ipxact "open_workspace ${ipxact_dir}/.."
  puts $create_ipxact "gui_set_pref_value -key xml_schema_version -value \"1685-2014\""
  #puts $create_ipxact "gui_get_pref_value -key xml_schema_version"
  puts $create_ipxact "write_ipxact_component -directory \[get_logical_dir export\]"
  puts $create_ipxact "close_workspace"
  puts $create_ipxact "echo \"close_workspace\""
  puts $create_ipxact "exit"
  close $create_ipxact
  puts "gen create_ipxact.tcl"
}

#--------------------------------------------------------------------------------
# MAIN
#--------------------------------------------------------------------------------

puts "<gen_fw> running ctb_prep, test=$test, config=$cfg"
if [regexp {ac([0-9]+)d([0-9]+)ch([1-2])} $cfg m anum bnum chnum] {
  if {$release==0} {
    set ipxact_file "dwc_ddrphy_top.ipxact.xml"
  } elseif {$release==1 || $release==2} {
    if {$coretools ==1} {
      set ipxact_file dwc_ddrphy_top.xml
      if {![file exists $ipxact_dir/$ipxact_file]} {
        if {![file exists $ipxact_dir/../.lock]} {
            create_ipxact
            puts "start generate ipxact"
            exec coreConsultant -shell -f $ipxact_dir/create_ipxact.tcl  2>@ stdout | tee create_ipxact.log
        } else {
            puts "IPXACT_ERROR: Sorry, ipxact can't be generated automatically when workspace is opened in coreConsultant. "
            puts "IPXACT_ERROR: Please take the following steps: (1) close the workspace in coreConsultant or generate ipxact by hand in coreConsultant report page; (2) launch the simulation again; "
            exit 1
        }
      } else {
             # regenerate IP-XACT whenever VDEFINE is new
             set ipxact_timestamp [exec date +%Y%m%d%H%M%S -r $ipxact_dir/$ipxact_file]
             set vdefine_timestamp [exec date +%Y%m%d%H%M%S -r [glob $ipxact_dir/src/*dwc_ddrphy_VDEFINES.v]]
             if {$vdefine_timestamp > $ipxact_timestamp} {
                create_ipxact
                puts "start generate ipxact"
                exec rm -rf create_ipxact.log
                exec rm -rf $ipxact_dir/$ipxact_file
                exec coreConsultant -shell -f $ipxact_dir/create_ipxact.tcl  2>@ stdout | tee create_ipxact.log
             }
      }
    } else {
      set ipxact_file ac${chnum}_dbyte$bnum.dwc_ddrphy_top.ipxact.xml
    }
  } 
  puts "<gen_fw> using ipxact file: $ipxact_file"
} else {
  puts "<gen_fw> ERROR: wrong cfg format, must be such as: ac12d9ch1"
  exit
}

# init types : 0 - no train, 1 - train 1d, 2 - train 2d, 3 - devinit, 4 - ate, 5 - dcchar
switch -glob $test {
  demo_ate             {set init_type 4; puts "<gen_fw> protocol:$protocol, init_type:$init_type (ATE)"}
  dcchar               {set init_type 5; puts "<gen_fw> protocol:$protocol, init_type:$init_type (dcchar)"}
  dcodt                {set init_type 5; puts "<gen_fw> protocol:$protocol, init_type:$init_type (dcodt)"}
  demo_*               {
                        if {$skip_train==0 && $disable2d==1} {
                           set init_type 1; puts "<gen_fw> protocol:$protocol, init_type:$init_type (Train 1D)"
                        } elseif {$skip_train==0 && $disable2d==0} {
                           set init_type 2; puts "<gen_fw> protocol:$protocol, init_type:$init_type (Train 2D)"
                        } elseif {$skip_train==2} {
                           set init_type 3; puts "<gen_fw> protocol:$protocol, init_type:$init_type (Devinit)"
                        } elseif {$skip_train==1} {
                           set init_type 0; puts "<gen_fw> protocol:$protocol, init_type:$init_type (No Train)"}
                       }
  default              {puts "ERROR: [gen_fw_cfg.tcl] test does not exist; exit"}
}

#exec rm -rf .fw
#exec cp -rf $phyinit_dir .fw 
#exec chmod -R 775 .fw

if {$protocol != "none" && $default_c !=1}  {
  set IF [open $override_c]
  set OF [open dwc_ddrphy_phyinit_userCustom_overrideUserInput.c w]
  while {[gets $IF line] >=0} {
     if {[string match "\}" $line]} {
      #if {$hard_macro == "A"} {
      #   puts $OF "    userInputBasic.HardMacroVer = 0; //HardMacro family A"
      #} elseif {$hard_macro == "B"} {
      #   puts $OF "    userInputBasic.HardMacroVer = 1; //HardMacro family B"
      #} elseif {$hard_macro == "C"} {
      #   puts $OF "    userInputBasic.HardMacroVer = 2; //HardMacro family C"
      #} elseif {$hard_macro == "D"} {
      #   puts $OF "    userInputBasic.HardMacroVer = 3; //HardMacro family D"
      #} elseif {$hard_macro == "E"} {
      #   puts $OF "    userInputBasic.HardMacroVer = 4; //HardMacro family E"
      #} else {puts "<gen_fw> Use default hard_macro."}
      }    
    puts $OF $line
  }  
 close $IF
 close $OF
 foreach file [glob *.c] {
   file copy -force $file .fw/$protocol/userCustom
 }
} else {
exec cp $override_c dwc_ddrphy_phyinit_userCustom_overrideUserInput.c
}

#if {$release==0} { 
#read_xml_old $ipxact_dir/$ipxact_file
#} else {
#read_xml_new $ipxact_dir/$ipxact_file
#}
set IPXACT [open $ipxact_dir/$ipxact_file] 
while {[gets $IPXACT line] >=0} {
      if [regexp {(.*)XMLSchema/SPIRIT/1685-2009} $line m dm] {
        set ipxact_old 1
      }
}
close $IPXACT
puts "ipxact_old= $ipxact_old"
if {$ipxact_old==0} {
  read_xml_new $ipxact_dir/$ipxact_file
} else {
  read_xml_old $ipxact_dir/$ipxact_file
}

current_map dwc_ddrphy_top
write_defines  csr_defines.sv
puts "<gen_fw> the csr_defines.sv file generated successfully"
write_apb_map  csr_apb_map.sv
puts "<gen_fw> the csr_apb_map.sv file generated successfully"


# copy the readmemh data into current path

if {$release==0 } {
file copy -force "$env(CTB_HOME)/testbench/inc/incv2memdat.pl" .
} elseif {$release==1 || $release==2} {
file copy -force "$env(CTB_HOME)/testbench/inc/incv2memdat.pl" .
}




set current_dir [eval pwd]
puts "current dir: $current_dir"
cd .fw
if {$release==0 } {
   if {$protocol != "none"} {
      set cmd "make -C $protocol PUB=$pub_ver FIRMWARE_PATH=$phyinit_dir../fw/rel RET_EN=$ret_en"
      puts $cmd
      eval exec "make -C $protocol clean" 
      eval exec  $cmd
   }
   cd $current_dir
   if {$test != "demo_ate"} {
    gen_apb_config $protocol $init_type $ret_en
   } else {
    set OF [open "apb_config.sv" w]
    puts $OF "//dummy apb_config file"
    puts $OF "task apb_config_all;"
    puts $OF "endtask : apb_config_all"
   }
} elseif {$release==1 || $release==2} {
   if {$protocol != "none"} {
      set cmd "make -C $protocol PUB=$pub_ver FIRMWARE_PATH=$env(CTB_FW_DIR)/training RET_EN=$ret_en >& make_phyinit.log"
      puts $cmd
      eval exec "make -C $protocol clean" 
      eval exec $cmd
   }
   cd $current_dir
   if {$test != "demo_ate"} {
    gen_apb_config $protocol $init_type $ret_en
   } else {
    set OF [open "apb_config.sv" w]
    puts $OF "//dummy apb_config file"
    puts $OF "task apb_config_all;"
    puts $OF "endtask : apb_config_all"
   }
}


if {$quickboot==1} {
   # YIANNISK: Remove old XML parse code.
   # We need generic parsing code which supports new IPXACT & old.
   exec ./xmlparse.py --ipxact $ipxact_dir/$ipxact_file

   if {$release==0 } {
      set fw_dir_qb "$phyinit_dir../fw/rel/${protocol}_quickboot"
   } else {
      set fw_dir_qb $env(CTB_FW_DIR)/training/${protocol}_quickboot
       if {![file exists ${fw_dir_qb}]} {
         set fw_dir_qb $env(CTB_FW_DIR)/quickboot/${protocol}_quickboot
      }
       if {![file exists ${fw_dir_qb}]} {
         set fw_dir_qb $env(CTB_FW_DIR)/../quickboot/${protocol}_quickboot
      }
   }

   exec cp -r ${fw_dir_qb}/${protocol}_quickboot_dmem.incv quickboot_dmem.incv
   exec cp -r ${fw_dir_qb}/${protocol}_quickboot_imem.incv quickboot_imem.incv
   foreach file [glob ${fw_dir_qb}/PUB\*_REG_LIST_DBYTE\*.txt] {
     file copy  $file ./
   }

   set IF [open ".fw/$protocol/output/dwc_ddrphy_phyinit_out_${protocol}_train.txt" r]
   set OF [open "msgBlk_quickboot.sv" w]
   set msgBlk_qb_save 0
   while {[gets $IF line] >=0} {
      if {[string match "*dwc_ddrphy_phyinit_WriteOutMem*" $line] && [string match "*STARTING*" $line] && [string match "*0x58000*" $line]} {
         set msgBlk_qb_save 1
         puts $OF "task msgBlk_write_quickboot;"
      }
      if {$msgBlk_qb_save==1} {
         # SequenceCtrl should be set to 1 in quickboot mode
         if {[string match "*32'h58008*" $line]} {
            puts $OF "dwc_ddrphy_apb_wr(32'h58008,16'h1);"
         # should enable CSR Quickboot 
         } elseif {[string match "*32'h5800c*" $line]} {
            puts $OF "dwc_ddrphy_apb_wr(32'h5800c,16'h1);"
         } elseif {[string match "*32'h58200*" $line]} {
            set msgBlk_qb_save 0
            puts $OF "endtask "
         } else {
            puts $OF $line
         }
      }
   }
   close $IF
   close $OF
}
puts "<gen_fw> the apb_config.sv file generated successfully"
