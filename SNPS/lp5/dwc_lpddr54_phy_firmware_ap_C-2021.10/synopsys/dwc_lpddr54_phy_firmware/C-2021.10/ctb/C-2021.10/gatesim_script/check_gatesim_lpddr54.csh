#!/bin/csh


@ total = 0
@ running = 0
@ check_passed = 0
@ check_failed = 0
@ compile_error = 0
@ check_sdf_log_warning = 0
@ sdf_no_load = 0
#@ Unsupport = 0
set sdf1_log_name = master_sdf.log
set sdf2_log_name = ac0_se0_sdf.log
set sdf3_log_name = ac0_sec0_sdf.log
set sdf4_log_name = ac0_diff_ck_sdf.log
set sdf5_log_name = dbyte0_se0_sdf.log
set sdf6_log_name = dbyte0_diff_DQS_sdf.log
set sdf7_log_name = dbyte0_diff_WCK_sdf.log

if(`ls |grep simv.log` !~ "") then
   set testcase_temp = "./"
else
   set testcase_temp = `find -maxdepth 2 -type d -name "demo_*"`
endif

foreach testcase($testcase_temp)
#foreach testcase(`find -name "demo_*"`)

@ simv_passed = 0
@ simv_failed = 0
@ single_compile_error = 0
@ single_running = 0
@ single_sdf_no_load = 0

@ sdf1_log_error = 0
@ sdf2_log_error = 0
@ sdf3_log_error = 0
@ sdf4_log_error = 0
@ sdf5_log_error = 0
@ sdf6_log_error = 0
@ sdf7_log_error = 0


@ sdf1_log_warning_1 = 0
@ sdf1_log_warning_2 = 0
@ sdf2_log_warning_1 = 0
@ sdf2_log_warning_2 = 0
@ sdf3_log_warning_1 = 0
@ sdf3_log_warning_2 = 0
@ sdf4_log_warning_1 = 0
@ sdf4_log_warning_2 = 0
@ sdf5_log_warning_1 = 0
@ sdf5_log_warning_2 = 0
@ sdf6_log_warning_1 = 0
@ sdf6_log_warning_2 = 0
@ sdf7_log_warning_1 = 0
@ sdf7_log_warning_2 = 0
@ sdf1_log_warning_unknown = 0
@ sdf2_log_warning_unknown = 0
@ sdf3_log_warning_unknown = 0
@ sdf4_log_warning_unknown = 0
@ sdf5_log_warning_unknown = 0
@ sdf6_log_warning_unknown = 0
@ sdf7_log_warning_unknown = 0

echo "check $testcase ************************************"

#check compile.log
  if(`tail ./$testcase/compile.log | grep "CPU time"` !~ "") then
  
    if(`grep "Syntax error" ./$testcase/compile.log` !~ "") then
      echo "Compile Error"
      @ single_compile_error = 1
      @ compile_error = $compile_error + 1
    else
#No compile error checking others log
      head -200 ./$testcase/simv.log | grep "Annotating SDF file" | sort |uniq
      if ( (`head -200 ./$testcase/simv.log | grep "Annotating SDF file" | sort | uniq |grep -c Done`) != 0 ) then
         @ single_sdf_no_load = 0
      else
         @ single_sdf_no_load = 1
      endif
      if ( -e ./$testcase/$sdf1_log_name ) then
          printf "\t$sdf1_log_name \n"
          grep " Total errors" ./$testcase/$sdf1_log_name | awk -F ":" '{print "\t  Errors   :" $2}'
          grep "Warning-" ./$testcase/$sdf1_log_name |sort | awk -F " " '{print $1}' | uniq -c | awk -F " " '{print "\t  Warnings : " $1 "\t -> " $2}'
          @ sdf1_log_error = $sdf1_log_error + `grep " Total errors" ./$testcase/$sdf1_log_name | awk -F ":" '{printf $2}'`
          if ( `grep -c "Warning-\[SDFCOM_IANE\]" ./$testcase/$sdf1_log_name` != 0 ) then
             @ sdf1_log_warning_1 = $sdf1_log_warning_1 + 1
          endif
          if ( (`grep -c "Warning-\[SDFCOM_NICD\]" ./$testcase/$sdf1_log_name` != 0 ) && ( `head -200 ./$testcase/simv.log |grep ".sdf" |grep -c "_ff"` != 0 ) ) then
             @ sdf1_log_warning_2 = $sdf1_log_warning_2 + 1
          endif
          if ( `grep "Warning-\[" ./$testcase/$sdf1_log_name | sort | uniq |grep -vcE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"` != 0 ) then
             @ sdf1_log_warning_unknown = $sdf1_log_warning_unknown + 1
          endif
      endif

      if ( -e ./$testcase/$sdf2_log_name ) then
          printf "\t$sdf2_log_name \n"
          grep " Total errors" ./$testcase/$sdf2_log_name  | awk -F ":" '{print "\t  Errors   :" $2}'
          grep "Warning-" ./$testcase/$sdf2_log_name |sort | awk -F " " '{print $1}' | uniq -c | awk -F " " '{print "\t  Warnings : " $1 "\t -> " $2}'
          @ sdf2_log_error = $sdf2_log_error + `grep " Total errors" ./$testcase/$sdf2_log_name | awk -F ":" '{printf $2}'`
          if ( `grep -c "Warning-\[SDFCOM_IANE\]" ./$testcase/$sdf2_log_name` != 0 ) then
             @ sdf2_log_warning_1 = $sdf2_log_warning_1 + 1
          endif
          if ( (`grep -c "Warning-\[SDFCOM_NICD\]" ./$testcase/$sdf2_log_name` != 0 ) && ( `head -200 ./$testcase/simv.log |grep ".sdf"|grep -c "_ff"` != 0 ) ) then
             @ sdf2_log_warning_2 = $sdf2_log_warning_2 + 1
          endif
          if ( `grep "Warning-\[" ./$testcase/$sdf2_log_name | sort | uniq |grep -vcE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"` != 0 ) then
             @ sdf2_log_warning_unknown = $sdf2_log_warning_unknown + 1
          endif
      endif

      if ( -e ./$testcase/$sdf3_log_name ) then
          printf "\t$sdf3_log_name \n"
          grep " Total errors" ./$testcase/$sdf3_log_name  | awk -F ":" '{print "\t  Errors   :" $2}'
          grep "Warning-" ./$testcase/$sdf3_log_name |sort | awk -F " " '{print $1}' | uniq -c | awk -F " " '{print "\t  Warnings : " $1 "\t -> " $2}'
          @ sdf3_log_error = $sdf3_log_error + `grep " Total errors" ./$testcase/$sdf3_log_name | awk -F ":" '{printf $2}'`
          if ( `grep -c "Warning-\[SDFCOM_IANE\]" ./$testcase/$sdf3_log_name` != 0 ) then
             @ sdf3_log_warning_1 = $sdf3_log_warning_1 + 1
          endif
          if ( (`grep -c "Warning-\[SDFCOM_NICD\]" ./$testcase/$sdf3_log_name` != 0 ) && ( `head -200 ./$testcase/simv.log |grep ".sdf"|grep -c "_ff"` != 0 ) ) then
             @ sdf3_log_warning_2 = $sdf3_log_warning_2 + 1
          endif
          if ( `grep "Warning-\[" ./$testcase/$sdf3_log_name | sort | uniq |grep -vcE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"` != 0 ) then
             @ sdf3_log_warning_unknown = $sdf3_log_warning_unknown + 1
          endif  
      endif

      if ( -e ./$testcase/$sdf4_log_name ) then
          printf "\t$sdf4_log_name \n"
          grep " Total errors" ./$testcase/$sdf4_log_name  | awk -F ":" '{print "\t  Errors   :" $2}'
          grep "Warning-" ./$testcase/$sdf4_log_name |sort | awk -F " " '{print $1}' | uniq -c | awk -F " " '{print "\t  Warnings : " $1 "\t -> " $2}'
          @ sdf4_log_error = $sdf4_log_error + `grep " Total errors" ./$testcase/$sdf4_log_name | awk -F ":" '{printf $2}'`
          if ( `grep -c "Warning-\[SDFCOM_IANE\]" ./$testcase/$sdf4_log_name` != 0 ) then
             @ sdf4_log_warning_1 = $sdf4_log_warning_1 + 1
          endif
          if ( (`grep -c "Warning-\[SDFCOM_NICD\]" ./$testcase/$sdf4_log_name` != 0 ) && ( `head -200 ./$testcase/simv.log |grep ".sdf"|grep -c "_ff"` != 0 ) ) then
             @ sdf4_log_warning_2 = $sdf4_log_warning_2 + 1
          endif
          if ( `grep "Warning-\[" ./$testcase/$sdf4_log_name | sort | uniq |grep -vcE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"` != 0 ) then
             @ sdf4_log_warning_unknown = $sdf4_log_warning_unknown + 1
          endif  
      endif

      if ( -e ./$testcase/$sdf5_log_name ) then
          printf "\t$sdf5_log_name \n"
          grep " Total errors" ./$testcase/$sdf5_log_name  | awk -F ":" '{print "\t  Errors   :" $2}'
          grep "Warning-" ./$testcase/$sdf5_log_name |sort | awk -F " " '{print $1}' | uniq -c | awk -F " " '{print "\t  Warnings : " $1 "\t -> " $2}'
          @ sdf5_log_error = $sdf5_log_error + `grep " Total errors" ./$testcase/$sdf5_log_name | awk -F ":" '{printf $2}'`
          if ( `grep -c "Warning-\[SDFCOM_IANE\]" ./$testcase/$sdf5_log_name` != 0 ) then
             @ sdf5_log_warning_1 = $sdf5_log_warning_1 + 1
          endif
          if ( (`grep -c "Warning-\[SDFCOM_NICD\]" ./$testcase/$sdf5_log_name` != 0 ) && ( `head -200 ./$testcase/simv.log |grep ".sdf"|grep -c "_ff"` != 0 ) ) then
             @ sdf5_log_warning_2 = $sdf5_log_warning_2 + 1
          endif
          if ( `grep "Warning-\[" ./$testcase/$sdf5_log_name | sort | uniq |grep -vcE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"` != 0 ) then
             @ sdf5_log_warning_unknown = $sdf5_log_warning_unknown + 1
          endif  
       endif

      if ( -e ./$testcase/$sdf6_log_name ) then
          printf "\t$sdf6_log_name \n"
          grep " Total errors" ./$testcase/$sdf6_log_name  | awk -F ":" '{print "\t  Errors   :" $2}'
          grep "Warning-" ./$testcase/$sdf6_log_name |sort | awk -F " " '{print $1}' | uniq -c | awk -F " " '{print "\t  Warnings : " $1 "\t -> " $2}'
          @ sdf6_log_error = $sdf6_log_error + `grep " Total errors" ./$testcase/$sdf6_log_name | awk -F ":" '{printf $2}'`
          if ( `grep -c "Warning-\[SDFCOM_IANE\]" ./$testcase/$sdf6_log_name` != 0 ) then
             @ sdf6_log_warning_1 = $sdf6_log_warning_1 + 1
          endif
          if ( (`grep -c "Warning-\[SDFCOM_NICD\]" ./$testcase/$sdf6_log_name` != 0 ) && ( `head -200 ./$testcase/simv.log |grep ".sdf"|grep -c "_ff"` != 0 ) ) then
             @ sdf6_log_warning_2 = $sdf6_log_warning_2 + 1
          endif
          if ( `grep "Warning-\[" ./$testcase/$sdf6_log_name | sort | uniq |grep -vcE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"` != 0 ) then
             @ sdf6_log_warning_unknown = $sdf6_log_warning_unknown + 1
          endif
      endif

      if ( -e ./$testcase/$sdf7_log_name ) then
          printf "\t$sdf7_log_name \n"
          grep " Total errors" ./$testcase/$sdf7_log_name  | awk -F ":" '{print "\t  Errors   :" $2}'
          grep "Warning-" ./$testcase/$sdf7_log_name |sort | awk -F " " '{print $1}' | uniq -c | awk -F " " '{print "\t  Warnings : " $1 "\t -> " $2}'
          @ sdf7_log_error = $sdf7_log_error + `grep " Total errors" ./$testcase/$sdf7_log_name | awk -F ":" '{printf $2}'`
          if ( `grep -c "Warning-\[SDFCOM_IANE\]" ./$testcase/$sdf7_log_name` != 0 ) then
             @ sdf7_log_warning_1 = $sdf7_log_warning_1 + 1
          endif
          if ( (`grep -c "Warning-\[SDFCOM_NICD\]" ./$testcase/$sdf7_log_name` != 0 ) && ( `head -200 ./$testcase/simv.log |grep ".sdf"|grep -c "_ff"` != 0 ) ) then
             @ sdf7_log_warning_2 = $sdf7_log_warning_2 + 1
          endif
          if ( `grep "Warning-\[" ./$testcase/$sdf7_log_name | sort | uniq |grep -vcE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"` != 0 ) then
             @ sdf7_log_warning_unknown = $sdf7_log_warning_unknown + 1
          endif  
      endif

#check simv.log
      printf "\tsimv.log \n"
      if(`tail -n 40 ./$testcase/simv.log |grep "CPU Time"` !~ "") then
        if(`tail -n 40 ./$testcase/simv.log |grep "TC INFO: test passed"` !~ "") then
          echo "\t  Passed"
          @ simv_passed = 1
        else
          echo "\t  Failed"
          @ simv_failed = 1
        endif
      else
       echo "\t  running"
       @ single_running  = 1
      endif
    endif  
  else
   echo "check compile.log : running"
   @ single_running = 1
  endif

# counting ...
@ total = $total + 1
if( $single_compile_error == 0 ) then
#
  if( $single_sdf_no_load != 0 ) then
     @ sdf_no_load = $sdf_no_load + 1
     # echo "Fail :It is not SDF GateSim, please check the runnning command \!\!\!"
     # echo "Reason :SDF file is not annotated on the top of simv.log \!\!\!"
  endif
#
#  if(( $sdf1_log_warning_1 + $sdf1_log_warning_2 \
#     + $sdf2_log_warning_1 + $sdf2_log_warning_2 \
#     + $sdf3_log_warning_1 + $sdf3_log_warning_2 \
#     + $sdf4_log_warning_1 + $sdf4_log_warning_2 \
#     + $sdf5_log_warning_1 + $sdf5_log_warning_2 \
#     + $sdf6_log_warning_1 + $sdf6_log_warning_2 \
#     + $sdf7_log_warning_1 + $sdf7_log_warning_2 ) != 0 ) then
#     echo "Exist undesired Warning, please check it \!\!\!"
#  endif
##
#  if( $sdf_log_warning_unknown != 0 ) then
##     @ check_sdf_log_unknown_warning = 1
#     echo "Exist unknown Warning, please check it \!\!\!"
#  endif

  if( ( ($sdf1_log_warning_1 + $sdf1_log_warning_2 \
     + $sdf2_log_warning_1 + $sdf2_log_warning_2 \
     + $sdf3_log_warning_1 + $sdf3_log_warning_2 \
     + $sdf4_log_warning_1 + $sdf4_log_warning_2 \
     + $sdf5_log_warning_1 + $sdf5_log_warning_2 \
     + $sdf6_log_warning_1 + $sdf6_log_warning_2 \
     + $sdf7_log_warning_1 + $sdf7_log_warning_2 ) != 0 ) \
     || ( ( $sdf1_log_warning_unknown + \
            $sdf2_log_warning_unknown + \
            $sdf3_log_warning_unknown + \
            $sdf4_log_warning_unknown + \
            $sdf5_log_warning_unknown + \
            $sdf6_log_warning_unknown + \
            $sdf7_log_warning_unknown + ) != 0 ) ) then
     @ check_sdf_log_warning = $check_sdf_log_warning + 1
  endif
#
  if( $single_running == 1 ) then
      @ running = $running + 1
  else
    if( ( $simv_failed \
       + $sdf1_log_error + $sdf2_log_error + $sdf3_log_error + $sdf4_log_error + $sdf5_log_error + $sdf6_log_error + $sdf7_log_error \
       + $single_sdf_no_load ) != 0 ) then
      @ check_failed = $check_failed + 1
    else
      if( $simv_passed == 1 ) then
        @ check_passed = $check_passed + 1
      else
        printf "error for this script, please check me \!\n"
      endif
    endif
  endif
endif

echo "\n\n C H E C K   S U M M A R Y --- ---> :"
if ( $single_running == 1 ) then
   echo "check result : Simulation not finish . . . "
else
  if ( ( $simv_failed + $sdf1_log_error + $sdf2_log_error + $sdf3_log_error + $sdf4_log_error + \
     $sdf5_log_error + $sdf6_log_error + $sdf7_log_error + $single_sdf_no_load + $single_compile_error ) == 0 ) then
   echo "check result : Passed. No simulation error,no SDF error."
  else
   echo "check result : Failed."
  endif
endif

if( $single_compile_error != 0 ) then
   echo "check failed compile Error"
endif
if ( $simv_failed == 1 ) then
   echo "check failed simv.log : simulation failed"
endif
if ( $single_sdf_no_load == 1 ) then
   echo "check failed SDF load : No SDF file is loaded"
endif
#check each sdf log's error
if ( $sdf1_log_error != 0 ) then
   echo "check failed $sdf1_log_name : error $sdf1_log_error"
endif
if ( $sdf2_log_error != 0 ) then
   echo "check failed $sdf2_log_name : error $sdf2_log_error"
endif
if ( $sdf3_log_error != 0 ) then
   echo "check failed $sdf3_log_name : error $sdf3_log_error"
endif
if ( $sdf4_log_error != 0 ) then
   echo "check failed $sdf4_log_name : error $sdf4_log_error"
endif
if ( $sdf5_log_error != 0 ) then
   echo "check failed $sdf5_log_name : error $sdf5_log_error"
endif
if ( $sdf6_log_error != 0 ) then
   echo "check failed $sdf6_log_name : error $sdf6_log_error"
endif
if ( $sdf7_log_error != 0 ) then
   echo "check failed $sdf7_log_name : error $sdf7_log_error"
endif

#display WARNING info for each sdf log
if ( $sdf1_log_warning_1 == 1 ) then
   echo "WARNING $sdf1_log_name : Warning-[SDFCOM_IANE]"
endif
if ( $sdf1_log_warning_2 == 1 ) then
   echo "WARNING $sdf1_log_name : Warning-[SDFCOM_NICD] (ff corner)"
endif
if ( $sdf1_log_warning_unknown == 1 ) then
   echo "WARNING $sdf1_log_name : Exist unknown warning";
   printf "\t";
   cat ./$testcase/$sdf1_log_name | grep "Warning-\[" | sort | uniq |grep -vE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD" | awk -F "]" '{print $1 "]"}'
endif

if ( $sdf2_log_warning_1 == 1 ) then
   echo "WARNING $sdf2_log_name : Warning-[SDFCOM_IANE]"
endif
if ( $sdf2_log_warning_2 == 1 ) then
   echo "WARNING $sdf2_log_name : Warning-[SDFCOM_NICD] (ff corner)"
endif
if ( $sdf2_log_warning_unknown == 1 ) then
   echo "WARNING $sdf2_log_name : Exist unknown warning";
   printf "\t";
   cat ./$testcase/$sdf2_log_name | grep "Warning-\[" | sort | uniq |grep -vE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"| awk -F "]" '{print $1 "]"}'
endif

if ( $sdf3_log_warning_1 == 1 ) then
   echo "WARNING $sdf3_log_name : Warning-[SDFCOM_IANE]"
endif
if ( $sdf3_log_warning_2 == 1 ) then
   echo "WARNING $sdf3_log_name : Warning-[SDFCOM_NICD] (ff corner)"
endif
if ( $sdf3_log_warning_unknown == 1 ) then
   echo "WARNING $sdf3_log_name : Exist unknown warning";
   printf "\t";
   cat ./$testcase/$sdf3_log_name | grep "Warning-\[" | sort | uniq |grep -vE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"| awk -F "]" '{print $1 "]"}'
endif

if ( $sdf4_log_warning_1 == 1 ) then
   echo "WARNING $sdf4_log_name : Warning-[SDFCOM_IANE]"
endif
if ( $sdf4_log_warning_2 == 1 ) then
   echo "WARNING $sdf4_log_name : Warning-[SDFCOM_NICD] (ff corner)"
endif
if ( $sdf4_log_warning_unknown == 1 ) then
   echo "WARNING $sdf4_log_name : Exist unknown warning";
   printf "\t";
   cat ./$testcase/$sdf4_log_name | grep "Warning-\[" | sort | uniq |grep -vE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"| awk -F "]" '{print $1 "]"}'
endif

if ( $sdf5_log_warning_1 == 1 ) then
   echo "WARNING $sdf5_log_name : Warning-[SDFCOM_IANE]"
endif
if ( $sdf5_log_warning_2 == 1 ) then
   echo "WARNING $sdf5_log_name : Warning-[SDFCOM_NICD] (ff corner)"
endif
if ( $sdf5_log_warning_unknown == 1 ) then
   echo "WARNING $sdf5_log_name : Exist unknown warning";
   printf "\t";
   cat ./$testcase/$sdf5_log_name | grep "Warning-\[" | sort | uniq |grep -vE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"| awk -F "]" '{print $1 "]"}'
endif

if ( $sdf6_log_warning_1 == 1 ) then
   echo "WARNING $sdf6_log_name : Warning-[SDFCOM_IANE]"
endif
if ( $sdf6_log_warning_2 == 1 ) then
   echo "WARNING $sdf6_log_name : Warning-[SDFCOM_NICD] (ff corner)"
endif
if ( $sdf6_log_warning_unknown == 1 ) then
   echo "WARNING $sdf6_log_name : Exist unknown warning";
   printf "\t";
   cat ./$testcase/$sdf6_log_name | grep "Warning-\[" | sort | uniq |grep -vE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"| awk -F "]" '{print $1 "]"}'
endif

if ( $sdf7_log_warning_1 == 1 ) then
   echo "WARNING $sdf7_log_name : Warning-[SDFCOM_IANE]"
endif
if ( $sdf7_log_warning_2 == 1 ) then
   echo "WARNING $sdf7_log_name : Warning-[SDFCOM_NICD] (ff corner)"
endif
if ( $sdf7_log_warning_unknown == 1 ) then
   echo "WARNING $sdf7_log_name : Exist unknown warning";
   printf "\t";
   cat ./$testcase/$sdf7_log_name | grep "Warning-\[" | sort | uniq |grep -vE "SDFCOM_SWC|SDFCOM_IWSBA|SDFCOM_IANE|SDFCOM_NICD"| awk -F "]" '{print $1 "]"}'
endif

if ( ( $simv_failed + $sdf1_log_error + $sdf2_log_error + $sdf3_log_error + $sdf4_log_error + \
   $sdf5_log_error + $sdf6_log_error + $sdf7_log_error + $single_sdf_no_load + $single_compile_error + $single_running ) == 0 ) then
   echo "check $testcase done ******************************* ^_^"
else
   if ( -e ./$testcase/job777.sh ) then
     printf "run option: "; cat ./$testcase/job777.sh |grep runtc
   endif
   echo ""
   echo "check $testcase done ******************************* T_T"
endif

echo ""
######

echo "\n"
end


if( $total == $check_passed ) then
echo "--No error/fail in all logs ----------------------------------------------------------------------------------------------------"
  echo "\t**************************************************************************"
  echo "\t*                                                                        *"
  echo "\t*  PPPPPPPPPPPPPPPP         AA             SSSSSSSSSSS     SSSSSSSSSSS   *"
  echo "\t*  PPP          PPP        AAAA          SSS             SSS             *"
  echo "\t*  PPP          PPP       AAAAAA        SSS             SSS              *"
  echo "\t*  PPP         PPP       AAA  AAA       SSS             SSS              *"
  echo "\t*  PPP        PPP       AAA    AAA       SSS             SSS             *"
  echo "\t*  PPPPPPPPPPPP        AAAAAAAAAAAA       SSSSSSSSSS      SSSSSSSSSS     *"
  echo "\t*  PPP                AAA        AAA               SSS             SSS   *"
  echo "\t*  PPP               AAA          AAA               SSS             SSS  *"
  echo "\t*  PPP              AAA            AAA              SSS             SSS  *"
  echo "\t*  PPP             AAA              AAA            SSS             SSS   *"
  echo "\t*  PPP            AAA                AAA SSSSSSSSSSS     SSSSSSSSSSS     *"
  echo "\t*                                                                        *"
  echo "\t**************************************************************************\n\n"
else
  if( $total == ($check_passed + $check_failed + $compile_error ) ) then
echo "--Have error/fail in logs or Not load SDF ------------------------------------------------------------------------------------"

    echo "\t**************************************************************************"
    echo "\t*                                                                        *"
    echo "\t*  FFFFFFFFFFFFFFFF         AA             IIIIIII     LLL               *"
    echo "\t*  FFFFFFFFFFFFFF          AAAA              III       LLL               *"
    echo "\t*  FFF                    AAAAAA             III       LLL               *"
    echo "\t*  FFF                   AAA  AAA            III       LLL               *"
    echo "\t*  FFF                  AAA    AAA           III       LLL               *"
    echo "\t*  FFFFFFFFFFFFFF      AAAAAAAAAAAA          III       LLL               *"
    echo "\t*  FFF                AAA        AAA         III       LLL               *"
    echo "\t*  FFF               AAA          AAA        III       LLL               *"
    echo "\t*  FFF              AAA            AAA       III       LLL               *"
    echo "\t*  FFF             AAA              AAA      III       LLL         LL    *"
    echo "\t*  FFF            AAA                AAA   IIIIIII     LLLLLLLLLLLLLLL   *"
    echo "\t*                                                                        *"
    echo "\t**************************************************************************\n\n"
  else
    echo "Not all testcase finish simulation ... ... \n\n"
  endif
endif

printf "Total testcase :$total\t"
printf "PASS :$check_passed\t"
printf "Fail :$check_failed\t"

if($running != 0) then
  printf " Running : $running\t"
endif

if ($check_sdf_log_warning != 0 ) then
  printf " Warning (With undesired/unknown Warnings): $check_sdf_log_warning\t"
endif

if($compile_error != 0) then
  printf " Compile error : $compile_error\t"
endif
echo "\n------------------------------------------------------------------------------------------------------------------------------"
if( $sdf_no_load != 0 ) then
   echo "FATAL : The simulation is not SDF GateSim,please check the running command \!\!\!"
endif

printf "\n"
printf "Note :\n"
printf "    PASS :\n"
printf "        a. There is no errors in\n"
printf "           compile.log, $sdf1_log_name, $sdf2_log_name, $sdf3_log_name,\n"
printf "           $sdf4_log_name,$sdf5_log_name,$sdf6_log_name,$sdf7_log_name.\n"
printf "        b. In simv.log, there also shows passed.\n"
printf "        c. SDF files have been loaded.\n"
printf "    Fail : Opposed to PASS.\n"


if ($running != 0) then
  printf "    Running :\n"
  printf "        a. The testcase still is running or have been killed.\n"
endif

if ($check_sdf_log_warning != 0 ) then
  printf "    Warning (With undesired/unknown Warnings) :\n"
  printf "        a. The testcases containing undesired SDF warning and unknown SDF warning.\n"
  printf "\n\n    Undesired Warnings are Warning-[SDFCOM_IANE],Warning-[SDFCOM_NICD](For corner=ff).\n"
  printf "    Neglectable Warnings are Warning-[SDFCOM_SWC],Warning-[SDFCOM_IWSBA].\n"
endif

if ($check_sdf_log_warning != 0 ) then
  printf " \n Please check the undesired/unknown Warnings(SDF warnings have been recorded above) \!\!\!\n"
endif

echo ""
