#!/bin/bash

cpu_total0=0
cpu_u0_n0_s0=0

w_icon=40
w_t=60
w_text=60
w_p=$(( $1 - $w_t - $w_text - $w_icon ))

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

#echo "x" > /tmp/swaybar/bar-sys-tray-cpu/t_over_70

while true;
do
	echo -n ",["

	cpu_total1=$(cat /proc/stat | grep -w cpu | awk '{print $2+$3+$4+$5}')
	cpu_u1_n1_s1=$(cat /proc/stat | grep -w cpu | awk '{print $2+$3+$4}')

	cpu_total=$(($cpu_total1-$cpu_total0))
	cpu_u_n_s=$(($cpu_u1_n1_s1-$cpu_u0_n0_s0))

	cpu_usage=$((100*$cpu_u_n_s/$cpu_total))

	cpu_cels=$(cat /sys/class/hwmon/hwmon3/temp1_input)
	cpu_t=$(($cpu_cels/1000))

	echo -n "{"
	echo -n "\"name\":\"id_cpu\","
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_icon,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\":\"\""
	echo -n "}"

	echo -n ","

	echo -n "{"
	echo -n "\"name\":\"id_cpu\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_text,"
	echo -n "\"separator\":false,"
	echo -n "\"full_text\":\" [CPU]\""
	echo -n "}"

	echo -n ","

	echo -n "{"
	echo -n "\"separator\":false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_p,"
	echo -n "\"align\": \"right\","
	echo -n "\"full_text\":\"$cpu_usage%\""
	echo -n "}"

	echo -n ","
	
	if [ $cpu_t -gt 70 ] && [ ! -e /tmp/swaybar/bar-sys-tray-cpu/t_over_70 ]; then
		echo "true" > /tmp/swaybar/bar-sys-tray-cpu/t_over_70
		echo "#ff0000" >/tmp/swaybar/bar-task-manager/id-sys-tray-color
	elif [ $cpu_t -lt 70 ] && [ -e /tmp/swaybar/bar-sys-tray-cpu/t_over_70 ]; then
		rm -f /tmp/swaybar/bar-sys-tray-cpu/t_over_70 >/dev/null 2>&1
		rm -f /tmp/swaybar/bar-task-manager/id-sys-tray-color >/dev/null 2>&1
	fi
	
	echo -n "{"
	echo -n "\"min_width\": $w_t,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"right\","
	echo -n "\"full_text\":\"$cpu_t°C \""
	echo -n "}"

	cpu_total0=$cpu_total1
	cpu_u0_n0_s0=$cpu_u1_n1_s1

	echo -n "]"

	read -t 1 line
	case  $line  in
		*"id_cpu"*"event"*"272"*) 
									swaymsg -q exec 'foot -T "htop" -a "cpu" htop' 
									;;
	esac
done
