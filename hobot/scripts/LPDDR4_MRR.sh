# !/bin/sh

function help() {
	echo "Usage: ./LPDDR4_MRR.sh <mrr_addr> <mrr_rank>"
	echo "mrr_addr: 0, 1..."
	echo "mrr_rank: 0, 1."
	exit 
}

if [ -n "$1" ] && [ -n "$2" ]; then
	mrr_addr=$1
	if [ $2 -ne 0 ] && [ $2 -ne 1 ]; then
		help
	else
		mrr_rank=$2
	fi
else
	help
fi

mrstat=`devmem 0xA2D00018`
while [ $(($mrstat&0x1)) -ne 0 ]
do
 sleep 1s
 mrstat=`devmem 0xA2D00018`
done

mrctrl1=$(($mrr_addr<<8))
devmem 0xA2D00014 32  $mrctrl1

mrctrl0=$(((((1<<$mrr_rank)&0x3)<<4)|0x1))
devmem 0xA2D00010 32  $mrctrl0
## mrctrl0=`devmem 0xA2D00010`
mrctrl0=$(($mrctrl0|(1 << 31)))
devmem 0xA2D00010 32  $mrctrl0

MRCTRL0=`devmem 0xA2D00010`
while [ $(($MRCTRL0&1<<31)) -ne 0 ]
do
 MRCTRL0=`devmem 0xA2D00010`
 sleep 1
done

mrstat=`devmem 0xA2D00018`
while [ $(($mrstat&0x1)) -ne 0 ]
do
 sleep 1s
 mrstat=`devmem 0xA2D00018`
done

sleep 1s

RD0=`devmem 0xA2D10010`
RD1=`devmem 0xA2D10014`
RD2=`devmem 0xA2D10018`
RD3=`devmem 0xA2D1001C`

if [ $(((RD0!=RD1) || (RD0!=RD2) || (RD0!=RD3) || (RD1!=RD2) || (RD1!=RD3) || (RD2!=RD3))) -eq 1 ]; then
	echo "lpddr4 read mr"$mrr_addr "fail:" $RD0 $RD1 $RD2 $RD3
else
	echo "lpddr4 read mr"$mrr_addr "value:" $RD0 $RD1 $RD2 $RD3
fi

# if [ $mrr_addr -eq 4 ]; then
# 	refresh_rate=$((($RD0>>16)&0xFF))
# 	if [ $refresh_rate -eq 3 ]; then
# 		echo "ddr device temperature is equal 85℃"
# 	elif [ $refresh_rate -lt 3 ]; then
# 		echo "ddr device temperature is lower than 85℃"
# 	else
# 		echo "ddr device temperature is greater than 85℃"
# 	fi
# fi
