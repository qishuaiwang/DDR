#!/usr/local/bin/bash



#######################################################################
dis_dir=$1;
dis_src=$2;
fw_file=$3;
#"fw_addr.v"

fw_adr="fw_adr"

#######################################################################
rm  -f  ${dis_src}_* ${fw_adr}*   ${fw_file}

sed   's/: /: \n/g'  ${dis_dir}/${dis_src}      > ${dis_src}_1
grep  ":"  ${dis_src}_1  |  grep  -v  "Dump of"  > ${dis_src}_adr
echo  "NULL"                                    >> ${dis_src}_adr

#######################################################################
fw_line=1
#fw_adr_end=""

bak=$IFS                     
IFS=$'\r' 
echo "" > ${dis_src}_list
while read fw_s
do
    let "fw_line+=1" 

    if [[ "${fw_s}" =~ ": " ]]; then 
      fw_adr_end=${fw_s}
    elif [[ "${fw_s}" =~ "NULL" ]]; then
      echo "32'h${fw_adr_end}"  >> ${dis_src}_list
    else
      fw_adr_start=`sed -n "${fw_line},${fw_line}p" ${dis_src}_adr`
      echo "32'h${fw_adr_end}"    >> ${dis_src}_list
      echo "${fw_s}"              >> ${dis_src}_list
      echo "32'h${fw_adr_start}"  >> ${dis_src}_list
    fi
done < ${dis_src}_adr
IFS=$bak

sed -i "1,2d" ${dis_src}_list

sed -i "s/h /h/" ${dis_src}_list
sed -i "s/h /h/" ${dis_src}_list
sed -i "s/h /h/" ${dis_src}_list
sed -i "s/h /h/" ${dis_src}_list
sed -i "s/://"   ${dis_src}_list
      
#######################################################################
    cp  ${dis_src}_list  ${dis_src}_list_tmp

#######################################################################
#------------------------------------
fw_1st_lvl=(halt_handler _start __crt_callmain  _exit_halt main pmu_train)
fw_num=0;

echo "reg [255:0] fw_s_lvl_0 [127:0];"  > ${fw_file}
echo "initial begin"                  >> ${fw_file}

for fw_s in ${fw_1st_lvl[@]}
do
  fw_line=`sed -n  "/\<${fw_s}\>/="  ${dis_src}_list`
  if [[ "$fw_line" == "" ]]; then
    echo "the ${fw_s} is not avalible"
  else
    adr_start_line=`expr ${fw_line} + 1`
    adr_end_line=`expr ${fw_line} + 2`
    adr_start=`sed -n "${adr_start_line},${adr_start_line}p" ${dis_src}_list`
    adr_end=`sed -n "${adr_end_line},${adr_end_line}p" ${dis_src}_list`

    #func name
    echo "fw_s_lvl_0[${fw_num}] = \"${fw_s}\" ;"   >> ${fw_file}
    fw_num=`expr ${fw_num} + 1`
    #start addr
    echo "fw_s_lvl_0[${fw_num}] = ${adr_start} ;"  >> ${fw_file}
    fw_num=`expr ${fw_num} + 1`
    #end addr
    echo "fw_s_lvl_0[${fw_num}] = ${adr_end} ;"    >> ${fw_file}
    fw_num=`expr ${fw_num} + 1`

    sed -i "${fw_line},${adr_end_line}d" ${dis_src}_list
  fi
done

echo "end" >> ${fw_file}
echo "" >> ${fw_file}
echo "" >> ${fw_file}

#------------------------------------
fw_line=0
fw_num=0

echo "reg [255:0] fw_s_lvl_n[1023:0];" >> ${fw_file}
echo "initial begin"                   >> ${fw_file}

bak=$IFS                     
IFS=$'\r' 
while read fw_s
do
    let "fw_line+=1" 
    fw_s=`sed -n "${fw_line},${fw_line}p" ${dis_src}_list`

    if [[ `expr $fw_line % 3` == 1 ]]; then       #func name
      echo "fw_s_lvl_n[${fw_num}] = \"${fw_s}\" ;" >> ${fw_file}
    elif [[ `expr $fw_line % 3` == 2 ]]; then     #start addr
      echo "fw_s_lvl_n[${fw_num}] = ${fw_s} ;" >> ${fw_file}
    else                                          #end addr
      echo "fw_s_lvl_n[${fw_num}] = ${fw_s} ;" >> ${fw_file}
    fi

    fw_num=`expr ${fw_num} + 1`
done < ${dis_src}_list
IFS=$bak


echo "end" >> ${fw_file}
echo "" >> ${fw_file}
echo "" >> ${fw_file}


# #######################################################################
if [ ! -f  ${dis_dir}/${dis_src} ]; then
   rm -f ${fw_file}
   echo "reg [255:0] fw_s_lvl_0 [127:0];"  > ${fw_file}
   echo "reg [255:0] fw_s_lvl_n[1023:0];" >> ${fw_file}
fi

# #######################################################################
echo "INFO: fw source list generation complete"
rm  -f  ${dis_src}_* ${fw_adr}
