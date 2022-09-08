#!/bin/awk -f





function master_sw(instance_name,line,ew_use_hex)
{
      if(ew_use_hex ==1)
      {gsub("dwc_ddrphymaster_top ","dwc_ddrphymaster_top_ew ",line)}
      else
      {gsub("dwc_ddrphymaster_top ","dwc_ddrphymaster_top_ns ",line)}
      print line
}
function dbyte_sw(instance_name,line,ew_use_hex)
{
   if(instance_name ~ /u_DBYTE_WRAPPER_0/)
   {
      if(and(ew_use_hex,0x01))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if( (instance_name ~ /u_DBYTE_WRAPPER_1/) && (instance_name !~ /u_DBYTE_WRAPPER_1[0-9]/) )
   {
      if(and(ew_use_hex,0x02))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_2/)
   {
      if(and(ew_use_hex,0x04))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_3/)
   {
      if(and(ew_use_hex,0x08))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_4/)
   {
      if(and(ew_use_hex,0x10))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_5/)
   {
      if(and(ew_use_hex,0x20))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_6/)
   {
      if(and(ew_use_hex,0x40))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_7/)
   {
      if(and(ew_use_hex,0x80))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_8/)
   {
      if(and(ew_use_hex,0x100))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_9/)
   {
      if(and(ew_use_hex,0x200))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_10/)
   {
      if(and(ew_use_hex,0x400))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_11/)
   {
      if(and(ew_use_hex,0x800))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
   if(instance_name ~ /u_DBYTE_WRAPPER_12/)
   {
      if(and(ew_use_hex,0x1000))
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_dbyte_wrapper","dwc_ddrphy_dbyte_wrapper_ns",line)}
  }
  print line
}
function ac_sw(instance_name,line,ew_use_hex)
{
   if(instance_name ~ /u_AC_WRAPPER_0/)
   {
      if(and(ew_use_hex,0x01))
      {gsub("dwc_ddrphy_ac_wrapper","dwc_ddrphy_ac_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_ac_wrapper","dwc_ddrphy_ac_wrapper_ns",line)}
  }
   if(instance_name ~ /u_AC_WRAPPER_1/)
   {
      if(and(ew_use_hex,0x02))
      {gsub("dwc_ddrphy_ac_wrapper","dwc_ddrphy_ac_wrapper_ew",line)}
      else
      {gsub("dwc_ddrphy_ac_wrapper","dwc_ddrphy_ac_wrapper_ns",line)}
  }

  print line
}

BEGIN{

if(master_ew_use !~ /undefined/)
{master_ew_use_hex = strtonum("0x"master_ew_use)}
else
{master_ew_use_hex = master_ew_use}

if(ac_ew_use !~ /undefined/)
{ac_ew_use_hex = strtonum("0x"ac_ew_use)}
else
{ac_ew_use_hex = ac_ew_use}

if(dbyte_ew_use !~ /undefined/)
{dbyte_ew_use_hex = strtonum("0x"dbyte_ew_use)}
else
{dbyte_ew_use_hex = dbyte_ew_use}

no_change_master = 1
no_change_dbyte = 1
no_change_ac = 1
# for module name and instance name is not the same line or in same line
line_nu = 0
module_master_nu = 0
module_dbyte_nu = 0
module_ac_nu = 0
top_file_count = 0
}

#{
#   ###############detect master
#   current_line = $0
#   if( (current_line ~ /dwc_ddrphymaster_top /) && (current_line ~ /u_DWC_DDRPHYMASTER_top/) && (master_ew_use_hex !~ /undefined/) )
#   {
#      if(master_ew_use_hex ==1)
#      {gsub("dwc_ddrphymaster_top ","dwc_ddrphymaster_top_ew ",current_line)}
#      else
#      {gsub("dwc_ddrphymaster_top ","dwc_ddrphymaster_top_ns ",current_line)}
#      print current_line
#      no_change_master = 0
#   }
#   else
#   {no_change_master = 1}
#  
#   if( (current_line ~ /dwc_ddrphy_dbyte_wrapper /) && (current_line ~ /u_DBYTE_WRAPPER_/) && (dbyte_ew_use_hex !~ /undefined/) )
#   {
#      #dbyte 0
#      if(and(dbyte_ew_use_hex,0x01))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_0","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_0",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_0","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_0",current_line)}
#      #dbyte 1
#      if(and(dbyte_ew_use_hex,0x02))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_1","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_1",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_1","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_1",current_line)}
#      #dbyte 2
#      if(and(dbyte_ew_use_hex,0x04))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_2","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_2",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_2","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_2",current_line)}
#      #dbyte 3
#      if(and(dbyte_ew_use_hex,0x08))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_3","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_3",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_3","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_3",current_line)}
#      #dbyte 4
#      if(and(dbyte_ew_use_hex,0x10))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_4","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_4",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_4","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_4",current_line)}
#      #dbyte 5
#      if(and(dbyte_ew_use_hex,0x20))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_5","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_5",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_5","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_5",current_line)}
#      #dbyte 6
#      if(and(dbyte_ew_use_hex,0x40))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_6","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_6",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_6","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_6",current_line)}
#      #dbyte 7
#      if(and(dbyte_ew_use_hex,0x80))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_7","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_7",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_7","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_7",current_line)}
#      #dbyte 8
#      if(and(dbyte_ew_use_hex,0x100))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_8","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_8",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_8","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_8",current_line)}
#      #dbyte 9
#      if(and(dbyte_ew_use_hex,0x200))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_9","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_9",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_9","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_9",current_line)}
#      #dbyte 10
#      if(and(dbyte_ew_use_hex,0x400))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_10","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_10",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_10","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_10",current_line)}
#      #dbyte 11
#      if(and(dbyte_ew_use_hex,0x800))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_11","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_11",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_11","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_11",current_line)}
#      #dbyte 12
#      if(and(dbyte_ew_use_hex,0x1000))
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_12","dwc_ddrphy_dbyte_wrapper_ew u_DBYTE_WRAPPER_12",current_line)}
#      else
#      {gsub("dwc_ddrphy_dbyte_wrapper u_DBYTE_WRAPPER_12","dwc_ddrphy_dbyte_wrapper_ns u_DBYTE_WRAPPER_12",current_line)}
#
#      
#      print current_line
#      no_change_dbyte = 0
#   }
#   else
#   {no_change_dbyte = 1}
#
#   #AC
#   if( (current_line ~ /dwc_ddrphy_ac_wrapper /) && (current_line ~ /u_AC_WRAPPER_/) && (ac_ew_use_hex !~ /undefined/) )
#   {
#      if(and(ac_ew_use_hex,0x01))
#      {gsub("dwc_ddrphy_ac_wrapper u_AC_WRAPPER_0","dwc_ddrphy_ac_wrapper_ew u_AC_WRAPPER_0",current_line)}
#      else
#      {gsub("dwc_ddrphy_ac_wrapper u_AC_WRAPPER_0","dwc_ddrphy_ac_wrapper_ns u_AC_WRAPPER_0",current_line)}
#
#      if(and(ac_ew_use_hex,0x02))
#      {gsub("dwc_ddrphy_ac_wrapper u_AC_WRAPPER_1","dwc_ddrphy_ac_wrapper_ew u_AC_WRAPPER_1",current_line)}
#      else
#      {gsub("dwc_ddrphy_ac_wrapper u_AC_WRAPPER_1","dwc_ddrphy_ac_wrapper_ns u_AC_WRAPPER_1",current_line)}
#
#      print current_line
#      no_change_ac = 0
#   }
#   else
#   {no_change_ac = 1}
#
#
#   if((no_change_master == 1) && (no_change_ac == 1) && (no_change_dbyte == 1) )
#   {print current_line }
#
#}

############# for module name and instance name is not the same line or in same line
{
   if((FILENAME ~ /dwc_ddrphy_top/) && (FNR ==1))
     {top_file_count = top_file_count + 1;line_nu = 0}
}



{if(top_file_count == 1)
{
   line_nu ++
   ###############detect module line
   current_line = $0
   if( (current_line ~ /dwc_ddrphymaster_top/) && (master_ew_use_hex !~ /undefined/) )
   {
      module_master_nu = line_nu
   }
   if( (current_line ~ /dwc_ddrphy_dbyte_wrapper/) && (dbyte_ew_use_hex !~ /undefined/) )
   {
      module_dbyte_nu = line_nu
   }
   if( (current_line ~ /dwc_ddrphy_ac_wrapper/) && (ac_ew_use_hex !~ /undefined/) )
   {
      module_ac_nu = line_nu
   }
   ###############detect instance line
   if( (current_line ~ /u_DWC_DDRPHYMASTER_top/) && (module_master_nu <= line_nu) )
   {
   if((line_nu - module_master_nu) <= 2)
   {ins_master_line[module_master_nu] = current_line; module_master_nu = 0}
   }

   if( (current_line ~ /u_DBYTE_WRAPPER_/) && (module_dbyte_nu <= line_nu) )
   {
   if((line_nu - module_dbyte_nu) <= 2)
   {ins_dbyte_line[module_dbyte_nu] = current_line;module_dbyte_nu = 0}
   }

   if( (current_line ~ /u_AC_WRAPPER_/) && (module_ac_nu <= line_nu) )
   {
   if((line_nu - module_ac_nu) <= 2)
   {ins_ac_line[module_ac_nu] = current_line;module_ac_nu = 0}
   }
}
}

{
   if(top_file_count == 2)
   {
      line_nu ++
      current_line = $0
         if( (current_line ~ /dwc_ddrphymaster_top/) && (master_ew_use_hex !~ /undefined/) )
            {
               if( line_nu in ins_master_line) {master_sw(ins_master_line[line_nu],current_line,master_ew_use_hex)}
            }
            else
            {
               if( (current_line ~ /dwc_ddrphy_dbyte_wrapper/) && (dbyte_ew_use_hex !~ /undefined/) )
                {
                   if( line_nu in ins_dbyte_line) {dbyte_sw(ins_dbyte_line[line_nu],current_line,dbyte_ew_use_hex)}
                }
                else
                {
                  if( (current_line ~ /dwc_ddrphy_ac_wrapper/) && (ac_ew_use_hex !~ /undefined/) )
                  {
                     if( line_nu in ins_ac_line) {ac_sw(ins_ac_line[line_nu],current_line,ac_ew_use_hex)}
                  }
                  else
                  {print $0}
                }
            }
   }
}

