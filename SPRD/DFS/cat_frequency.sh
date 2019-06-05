#!bin/sh
cd /sys/class/devfreq/sprd_dfs.0/sprd_governor
cur_freq=0
count=0
F0=0
F1=0
F2=0
F3=0
echo -n "enter test times:"
read times
while [ $count -lt $times ]
do
	let count+=1
	cur_freq=`cat ddrinfo_cur_freq`
	case $cur_freq in
		1200)
			let F3+=1
			;;
		600)
			let F2+=1
			;;
		400)
			let F1+=1
			;;
		*)
			let F0+=1
			;;
	esac
	sleep 0.0027
done
echo -e "counter = ${count}, 1200 = ${F3}, 600 = ${F2}, 400 = ${F1}, 200 = ${F0} \n"
let F3=${F3}*100/${count}
let F2=${F2}*100/${count}
let F1=${F1}*100/${count}
let F0=${F0}*100/${count}
echo -e "1200 = ${F3}, 600 = ${F2}, 400 = ${F1}, 200 = ${F0} \n"
