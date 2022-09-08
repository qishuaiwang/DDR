#!/bin/awk -f



function count_s(cha_s,search_s)
{
    cha_num = 0
    split(cha_s,cha_ss,search_s)
    cha_num = length(cha_ss) - 1
    return cha_num
}

function add_assign(insert_dly_net,insert_net_width,UI_num)
{
  print "wire ["insert_net_width":0] " insert_dly_net"_dly;"
  print "assign "insert_dly_net"_dly = "insert_dly_net";"
}

function add_block(insert_dly_net,insert_net_width,dly_time,UI_num)
{
  print "wire ["insert_net_width":0] " insert_dly_net"_dly;"
#  print "DLY_PUB_HM #(.dly("dly_time"), .WIDTH("insert_net_width")) DLY_"UI_num"(.dout("insert_dly_net"_dly), .din("insert_dly_net"));"
  print "DLY_PUB #(.dly("dly_time"), .WIDTH("insert_net_width")) DLY_"UI_num"(.dout(top.dut."insert_dly_net"_dly), .din(top.dut."insert_dly_net"));" >> "DLY_PUB_HM.v"
}

function get_width(string_line)
{
   split(string_line,string_line_tmp,"\\[|\\]|:")
   string_width = string_line_tmp[2]
   return string_width
}


function check_more_lines(check_line)
{
   if(check_line ~ /\./)
    {
      right_flag_1 = count_s(check_line,")")
	   left_flag_1 = count_s(check_line,"(")
	   if(right_flag_1 == left_flag_1)
		{
		  next_s = 0
        return 0
		}
	   else
		{
		  next_s = 1
		  return 1
		}
    }
  else
	{
	 if(next_s == 1)
		{
		if(right_flag_1 == left_flag_1)
			{print "this is a bug"}
		else
			{
			right_flag_1 = count_s(check_line,")") + right_flag_1
			left_flag_1 = count_s(check_line,"(") + left_flag_1
			if(right_flag_1 == left_flag_1)
				{
				next_s = 0
				return 0
				}
			else
				{
				return 1
				}
			}
		}
	}
}

BEGIN{
module_head = 0
module_tail = 0
instance_master_head = 0
instance_master_tail = 0
instance_dbyte_head = 0
instance_dbyte_tail = 0
instance_ac_head = 0
instance_ac_tail = 0
instance_pub_head = 0
instance_pub_tail = 0
remove_tail = 0
width_num=0
right_flag_1 = 0
left_flag_1 = 0
next_s = 0
## Delay time
#dly_time_glo = 666
# Detect file dwc_ddrphy_top.v
ddrphy_top = 0
# Flag for add delay cell for dut -> master
tb_master_add = 0
# Delay wire for dut -> master
tb_master["PllBypClk"]="0"
tb_master["PllRefClk"]="0"
#add for define with annotation `end //`ifdef xxxxxx
define_flag = 1

print "module DLY_PUB_HM();" > "DLY_PUB_HM.v"
}
##############  detect MASTER
{
if(FILENAME ~ /dwc_ddrphymaster_top/)
{
module_line = $0
##
if(( module_line ~ /dwc_ddrphymaster_top/) && (module_line ~ /module/))
{
   module_head = 1
   module_tail = 0
}
## option
if(module_head == 1 && module_tail == 0)
{
if((module_line ~ /input/) || (module_line ~ /inout/))
{
   gsub(" wire"," ",module_line)
   gsub(" reg"," ",module_line)
   if(module_line !~ /\[/)
      {
         split(module_line,module_line_tmp,",| ")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /input/) && (module_line_tmp[i] !~ /inout/) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {master_in["."module_line_tmp[i]] = "0"}
         }
      }
    else
      {
         gsub(" ","",module_line)
         split(module_line,module_line_tmp,"\\[|\\]|\\:|,")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /input/) && (module_line_tmp[i] !~ /inout/) && (i > 3) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {master_in["."module_line_tmp[i]] = module_line_tmp[2]}
         }
      }
}

}
##
if( ( module_line ~ /);/ || module_line ~ /)[ ]*;/ ) && (module_head == 1 && module_tail == 0) )
{
   module_tail = 1
   module_head = 0
}
}
}
############### MASTER detect end

###############  detect AC
{
if(FILENAME ~ /dwc_ddrphy_ac_wrapper/)
{
module_line = $0
##
if((module_line ~ /dwc_ddrphy_ac_wrapper/) && (module_line ~ /module/))
{
   module_head = 1
   module_tail = 0
}
## option
if(module_head == 1 && module_tail == 0)
{
if((module_line ~ /input/) || (module_line ~ /inout/))
{
   gsub(" wire"," ",module_line)
   gsub(" reg"," ",module_line)
   if(module_line !~ /\[/)
      {
         split(module_line,module_line_tmp,",| ")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /input/) && (module_line_tmp[i] !~ /inout/) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {ac_in["."module_line_tmp[i]] = "0"}
         }
      }
    else
      {
         gsub(" ","",module_line)
         split(module_line,module_line_tmp,"\\[|\\]|\\:|,")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /input/) && (module_line_tmp[i] !~ /inout/) && (i > 3) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {ac_in["."module_line_tmp[i]] = module_line_tmp[2]}
         }
      }
}
}
##
if( ( module_line ~ /);/ || module_line ~ /)[ ]*;/ ) && (module_head == 1 && module_tail == 0) )
{
   module_tail = 1
   module_head = 0
}
}
}
############### AC detect end

###############  detect DBYTE
{
if(FILENAME ~ /dwc_ddrphy_dbyte_wrapper/)
{
module_line = $0
##
if((module_line ~ /dwc_ddrphy_dbyte_wrapper/) && (module_line ~ /module/))
{
   module_head = 1
   module_tail = 0
}
## option
if(module_head == 1 && module_tail == 0)
{
if((module_line ~ /input/) || (module_line ~ /inout/))
{
   gsub(" wire"," ",module_line)
   gsub(" reg"," ",module_line)
   if(module_line !~ /\[/)
      {
         split(module_line,module_line_tmp,",| ")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /input/) && (module_line_tmp[i] !~ /inout/) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {dbyte_in["."module_line_tmp[i]] = "0"}
         }
      }
    else
      {
         gsub(" ","",module_line)
         split(module_line,module_line_tmp,"\\[|\\]|\\:|,")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /input/) && (module_line_tmp[i] !~ /inout/) && (i > 3) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {dbyte_in["."module_line_tmp[i]] = module_line_tmp[2]}
         }
      }
}
}
##
if( ( module_line ~ /);/ || module_line ~ /)[ ]*;/ ) && (module_head == 1 && module_tail == 0) )
{
   module_tail = 1
   module_head = 0
}
}
}
############### DBYTE detect end

###############  detect PUB
{
if(FILENAME ~ /dwc_ddrphypub/)
{
module_line = $0
##
if((module_line ~ /dwc_ddrphypub/) && (module_line ~ /module/))
{
   module_head = 1
   module_tail = 0
}
## option
if(module_head == 1 && module_tail == 0)
{
if((module_line ~ /output/) || (module_line ~ /inout/))
{
   gsub(" wire"," ",module_line)
   gsub(" reg"," ",module_line)
   if(module_line !~ /\[/)
      {
         split(module_line,module_line_tmp,",| ")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /input/) && (module_line_tmp[i] !~ /inout/) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {pub_out["."module_line_tmp[i]] = "0"}
         }
      }
    else
      {
         gsub(" ","",module_line)
         split(module_line,module_line_tmp,"\\[|\\]|\\:|,")
         for(i in module_line_tmp)
         {
            if((module_line_tmp[i] !~ /output/) && (module_line_tmp[i] !~ /inout/) && (i > 3) && (module_line_tmp[i] ~ /[A-Z,a-z]/))
            {pub_out["."module_line_tmp[i]] = module_line_tmp[2]}
         }
      }
}
}
##
if( ( module_line ~ /);/ || module_line ~ /)[ ]*;/ ) && (module_head == 1 && module_tail == 0) )
{
   module_tail = 1
   module_head = 0
}
}
}
############### pub detect end







{
if(FILENAME ~ /dwc_ddrphy_top/)
{
   if(FNR == 1)
   {
      ddrphy_top ++
      if(ddrphy_top == 2)
      {
        for(i in pub_wire)
          {
            if( i in ac_wire)
            {pub_ac[i]="0"}
            if( i in dbyte_wire)
            {pub_dbyte[i]="0"}
            if( i in master_wire)
            {
               pub_master[i]="0"
               if(tb_master_add == 1)
               {pub_master["PllRefClk"]="0";pub_master["PllBypClk"]="0"}
            }
          }
       #remove No DLY net
       delete pub_master["PUB_MASTER_DfiClk"]
      }
   }
}
}


############### DETECT dwc_ddrphy_top, get connection info PUB->MASTER,PUB->AC,PUB->DBYTE 
{
if((FILENAME ~ /dwc_ddrphy_top/) && (ddrphy_top == 1))
{
##############  detect MASTER
{
instance_line = $0
##
#if( (instance_line ~ /dwc_ddrphymaster_top/) && (instance_line ~ /u_DWC_DDRPHYMASTER_top/) )
if(instance_line ~ /u_DWC_DDRPHYMASTER_top/)
{
   instance_master_head = 1
   instance_master_tail = 0
}
## option
if(instance_master_head == 1 && instance_master_tail == 0)
{
      if( (instance_line ~ /\./) || (next_s == 1) )
      {
          split(instance_line,instance_line_tmp,"\\(|\\)|\\{|\\}|\\,|\\[| ")
          if(next_s == 0)
          {
             if(instance_line_tmp[1] in master_in)
             {
                next_y = 1
                for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {master_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          else
          {
             if(next_y == 1)
             {
               for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {master_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          check_more_lines(instance_line)
          if(next_s == 0)
          {next_y =0}
      }
}
##
if( ( instance_line ~ /);/ || instance_line ~ /)[ ]*;/ ) && (instance_master_head == 1 && instance_master_tail == 0) )
{
   instance_master_tail = 1
   instance_master_head = 0
}
}
############### MASTER detect end
##############  detect DBYTE
{
instance_line = $0
##
#if( (instance_line ~ /dwc_ddrphy_dbyte_wrapper/) && (instance_line ~ /u_DBYTE_WRAPPER_/) )
if(instance_line ~ /u_DBYTE_WRAPPER_/)
{
   instance_dbyte_head = 1
   instance_dbyte_tail = 0
}
## option
if(instance_dbyte_head == 1 && instance_dbyte_tail == 0)
{
      if( (instance_line ~ /\./) || (next_s == 1) )
      {
          split(instance_line,instance_line_tmp,"\\(|\\)|\\{|\\}|\\,|\\[| ")
          if(next_s == 0)
          {
             if(instance_line_tmp[1] in dbyte_in)
             {
                next_y = 1
                for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {dbyte_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          else
          {
             if(next_y == 1)
             {
               for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {dbyte_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          check_more_lines(instance_line)
          if(next_s == 0)
          {next_y =0}
      }
}

##
if( ( instance_line ~ /);/ || instance_line ~ /)[ ]*;/ ) && (instance_dbyte_head == 1 && instance_dbyte_tail == 0) )
{
   instance_dbyte_tail = 1
   instance_dbyte_head = 0
}
}
############### dbyte detect end
##############  detect AC
{
instance_line = $0
##
#if( (instance_line ~ /dwc_ddrphy_ac_wrapper/) && (instance_line ~ /u_AC_WRAPPER_/) )
if(instance_line ~ /u_AC_WRAPPER_/)
{
   instance_ac_head = 1
   instance_ac_tail = 0
}
## option
if(instance_ac_head == 1 && instance_ac_tail == 0)
{
      if( (instance_line ~ /\./) || (next_s == 1) )
      {
          split(instance_line,instance_line_tmp,"\\(|\\)|\\{|\\}|\\,|\\[| ")
          if(next_s == 0)
          {
             if(instance_line_tmp[1] in ac_in)
             {
                next_y = 1
                for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {ac_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          else
          {
             if(next_y == 1)
             {
               for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {ac_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          check_more_lines(instance_line)
          if(next_s == 0)
          {next_y =0}
      }
}

##
if( ( instance_line ~ /);/ || instance_line ~ /)[ ]*;/ ) && (instance_ac_head == 1 && instance_ac_tail == 0) )
{
   instance_ac_tail = 1
   instance_ac_head = 0
}
}
############### ac detect end
##############  detect PUB
{
instance_line = $0
##
#if( (instance_line ~ /dwc_ddrphypub/) && (instance_line ~ /u_DWC_ddrphy_pub/) )
if(instance_line ~ /u_DWC_ddrphy_pub/)
{
   instance_pub_head = 1
   instance_pub_tail = 0
}
## option
if(instance_pub_head == 1 && instance_pub_tail == 0)
{
      if( (instance_line ~ /\./) || (next_s == 1) )
      {
          split(instance_line,instance_line_tmp,"\\(|\\)|\\{|\\}|\\,|\\[| ")
          if(next_s == 0)
          {
             if(instance_line_tmp[1] in pub_out)
             {
                next_y = 1
                for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {pub_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          else
          {
             if(next_y == 1)
             {
               for(n in instance_line_tmp)
                {
                   if( (instance_line_tmp[n] !~ /\./) && (instance_line_tmp[n] !~ /\:/) && (instance_line_tmp[n] !~ /\]/) && (instance_line_tmp[n] !~ /'b/) && (instance_line_tmp[n] !~ /'h/) && (instance_line_tmp[n] ~ /[A-Z]/) && (instance_line_tmp[n] ~ /[a-z]/) )
                   {pub_wire[instance_line_tmp[n]]="0"}
                }
             }
          }
          check_more_lines(instance_line)
          if(next_s == 0)
          {next_y =0}
      }
}

##
if( ( instance_line ~ /);/ || instance_line ~ /)[ ]*;/ ) && (instance_pub_head == 1 && instance_pub_tail == 0) )
{
   instance_pub_tail = 1
   instance_pub_head = 0
}
}
############### ac detect end


}}



###############  detect TOP connect ,modify dwc_ddrphy_top.v   wire_name -> wire_name_dly
{
if((FILENAME ~ /dwc_ddrphy_top/) && (ddrphy_top == 2))
{
##############  detect MASTER
{
instance_line = $0
##
#if( (instance_line ~ /dwc_ddrphymaster_top/) && (instance_line ~ /u_DWC_DDRPHYMASTER_top/) )
if(instance_line ~ /u_DWC_DDRPHYMASTER_top/)
{
   instance_master_head = 1
   instance_master_tail = 0
   # add DLY cell for dut -> master
   if(tb_master_add == 1)
   {
      for(i in tb_master)
      {
         add_block(i,tb_master[i],dly_time_glo,i)
      }
   }
   # add dut -> master DLY cell end
}
## option
if(instance_master_head == 1 && instance_master_tail == 0)
{
#print "master ---"master_line
split(instance_line,instance_line_tmp,"\\[|\\]|\\(|\\)|\\{|\\}|\\,| ")
j = 1
for (i in instance_line_tmp)
{
   if( instance_line_tmp[i] in pub_master)
   {
      y = instance_line_tmp[i] count
      if( y in master_dup)
      {master_dup[y]="6Z"}
      else
      {
         master_dly[j] = instance_line_tmp[i]
         master_dly[j+1] = instance_line_tmp[i]"_dly"
         j = j+2
      }
      master_dup[y]="6Z"
   }
}
gsub("\\(","( ",instance_line)
gsub(",",", ",instance_line)
if(j > 1)
{
   for(k=1;k<j;k=k+2)
   {
      gsub(" "master_dly[k]," "master_dly[k+1],instance_line)
   }
   print instance_line
}
else
{print instance_line}
}

##
if( ( instance_line ~ /);/ || instance_line ~ /)[ ]*;/ ) && (instance_master_head == 1 && instance_master_tail == 0) )
{
   instance_master_tail = 1
   instance_master_head = 0
   remove_tail = 1
}
}
############### MASTER detect end


##############  detect DBYTE
{
instance_line = $0
##
#if( (instance_line ~ /dwc_ddrphy_dbyte_wrapper/) && (instance_line ~ /u_DBYTE_WRAPPER_/) )
if(instance_line ~ /u_DBYTE_WRAPPER_/)
{
   instance_dbyte_head = 1
   instance_dbyte_tail = 0
}
## option
if(instance_dbyte_head == 1 && instance_dbyte_tail == 0)
{
#print "dbyte ---"dbyte_line
split(instance_line,instance_line_tmp,"\\[|\\]|\\(|\\)|\\{|\\}|\\,| ")
j = 1
for (i in instance_line_tmp)
{
   if( instance_line_tmp[i] in pub_dbyte)
   {
      y = instance_line_tmp[i] count
      if( y in dbyte_dup)
      {dbyte_dup[y]="6Z"}
      else
      {
         wire_dly[j] = instance_line_tmp[i]
         wire_dly[j+1] = instance_line_tmp[i]"_dly"
         j = j+2
      }
      dbyte_dup[y]="6Z"
   }
}
gsub("\\(","( ",instance_line)
gsub(",",", ",instance_line)
if(j > 1)
{
   for(k=1;k<j;k=k+2)
   {
      gsub(" "wire_dly[k]," "wire_dly[k+1],instance_line)
   }
   print instance_line
}
else
{print instance_line}
}

##
if( ( instance_line ~ /);/ || instance_line ~ /)[ ]*;/ ) && (instance_dbyte_head == 1 && instance_dbyte_tail == 0) )
{
   instance_dbyte_tail = 1
   instance_dbyte_head = 0
   remove_tail = 1
}
}
############### DBYTE detect end

##############  detect AC
{
instance_line = $0
##
#if( (instance_line ~ /dwc_ddrphy_ac_wrapper/) && (instance_line ~ /u_AC_WRAPPER_/) )
if(instance_line ~ /u_AC_WRAPPER_/)
{
   instance_ac_head = 1
   instance_ac_tail = 0
}
## option
if(instance_ac_head == 1 && instance_ac_tail == 0)
{
#print "ac ---"ac_line
split(instance_line,instance_line_tmp,"\\[|\\]|\\(|\\)|\\{|\\}|\\,| ")
j = 1
for (i in instance_line_tmp)
{
   if( instance_line_tmp[i] in pub_ac)
   {
      y = instance_line_tmp[i] count
      if( y in ac_dup)
      {ac_dup[y]="6Z"}
      else
      {
         wire_dly[j] = instance_line_tmp[i]
         wire_dly[j+1] = instance_line_tmp[i]"_dly"
         j = j+2
      }
      ac_dup[y]="6Z"
   }
}
gsub("\\(","( ",instance_line)
gsub(",",", ",instance_line)
if(j > 1)
{
   for(k=1;k<j;k=k+2)
   {
      gsub(" "wire_dly[k]," "wire_dly[k+1],instance_line)
   }
   print instance_line
}
else
{print instance_line}
}

##
if( ( instance_line ~ /);/ || instance_line ~ /)[ ]*;/ ) && (instance_ac_head == 1 && instance_ac_tail == 0) )
{
   instance_ac_tail = 1
   instance_ac_head = 0
   remove_tail = 1
}
}
############### AC detect end


############## NO PUB_*
{
if( ((instance_master_head != 1) || (instance_master_tail != 0)) && ((instance_dbyte_head != 1) || (instance_dbyte_tail != 0)) && ((instance_ac_head != 1) || (instance_ac_tail != 0)) && ((instance_pub_head != 1) || (instance_pub_tail != 0)) )
{
   if(remove_tail == 1)
   {
      remove_tail = 0
   }
   else
   {
      #print $0
      if ($0 ~ /define/)
      {
      instance_line=$0
      gsub("\\("," (",instance_line )
      print instance_line
      }
      else
      {
         if( (instance_line ~ /module/) && (instance_line ~ /dwc_ddrphy_top/) )
         {
            print "`include \"DLY_PUB_HM.v\""
            print $0
         }
         else
#         {print $0}
#####begin of unexp case
         {
#            if( (instance_line ~ /dwc_ddrphypub/) && (instance_line ~ /u_DWC_ddrphy_pub/) )
            if(instance_line ~ /u_DWC_ddrphy_pub/)
            {
                for( i in pub_master)
                {all_net[i]="0"}
                for( i in pub_dbyte)
                {all_net[i]="0"}
                for( i in pub_ac)
                {all_net[i]="0"}
                for(i in all_net)
                {
                   if( i in string_instance_undefine )
                      {delete all_net[i]}
                   else
                   {
                    print "wire "i";"
                    add_block(i,0,dly_time_glo,i)
                   }
                }
            }
            print $0
         }
####end of unexp case
      }
   }
   instance_line = $0
   ######add wire/assign/dly_block for PUB_ 
   if( (instance_line ~ /`if/) && (define_flag == 1) )
   {print $0 >>  "DLY_PUB_HM.v";define_flag = 0}
   
   if(instance_line ~ /wire/)
   {
      ####get wire width 
      if(instance_line ~ /\[/)
      {
         width = get_width(instance_line)
      }
      else
      {
         width = 0
      }
      ## case 1
      split(instance_line,instance_line_tmp,"\\]|,|;| ")
      j=1
      for( i in instance_line_tmp)
      {
         if( (instance_line_tmp[i] in pub_master) || (instance_line_tmp[i] in pub_dbyte) || (instance_line_tmp[i] in pub_ac) )
         {
            string_instance[j] = instance_line_tmp[i]
#####begin of unexp case
            string_instance_undefine[instance_line_tmp[i]]="0"
####end of unexp case
            j++
         }
      }
      ##case 2
      if(instance_line ~ /=/)
      {
         for(h=1;h<j;h++)
         {
            add_assign(string_instance[h],width,count)
         }
      }
      else
      {
         for(h=1;h<j;h++)
         {
            add_block(string_instance[h],width,dly_time_glo,string_instance[h])
         }
      }
   }
   
  if( ( (instance_line ~ /`el/) || (instance_line ~ /`endif/) ) && (define_flag == 1) )
      {print $0 >>  "DLY_PUB_HM.v";define_flag = 0}

     define_flag = 1

}
}
##################NO PUB end

}}

{
   count ++
}

END{
   print "endmodule" >> "DLY_PUB_HM.v"

   print "module DLY_PUB" >> "DLY_PUB_HM.v"
   print"#(" >> "DLY_PUB_HM.v"
   print "parameter dly," >> "DLY_PUB_HM.v"
   print "parameter WIDTH" >> "DLY_PUB_HM.v"
   print ")" >> "DLY_PUB_HM.v"
   print "(" >> "DLY_PUB_HM.v"
   print "output reg [WIDTH:0] dout," >> "DLY_PUB_HM.v"
   print "input wire [WIDTH:0] din" >> "DLY_PUB_HM.v"
   print ");" >> "DLY_PUB_HM.v"
   print "always @* dout <= #dly din;" >> "DLY_PUB_HM.v"
   print "endmodule" >> "DLY_PUB_HM.v"
}

