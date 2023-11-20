#!/bin/bash

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

w_icon=40
w_t=60
w_m=$(( $1 - $w_icon - $w_t ))

while true;
do
	echo -n ",["

	mem_free=$(cat /proc/meminfo | awk '/MemFree:/{print $2/1024/1024}')

	echo -n "{"
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_icon,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\":\"\""
	echo -n "}"

	echo -n ","

	echo -n "{"
	echo -n "\"separator\":false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_t,"
	echo -n "\"align\": \"left\","
	echo -n "\"name\":\"id_mem\","
	echo -n "\"full_text\":\" [MEM]\""
	echo -n "}"

	echo -n ","

	echo -n "{"
	#echo -n "\"separator\":false,"
	echo -n "\"min_width\": $w_m,"
	echo -n "\"align\": \"right\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"full_text\":\"${mem_free} Gi \""
	echo -n "}"

	echo -n "]"

	sleep 1s
	
#	read -t 1 line
#	case  $line  in
#		*"id_cpu"*"event"*"272"*) 
#									swaymsg -q exec 'foot -a "cpu" htop' 
#									;;
#	esac
done
