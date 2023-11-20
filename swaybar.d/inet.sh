#!/bin/bash

. ~/.config/sway/swaybar.d/icmp.sh &

prev_rx=0
prev_tx=0

w_icon=40
w_t=60
w_tx=60
w_rx=60
w_s=$(( $1 - $w_t - $w_tx - $w_rx - $w_icon ))
w_speed=$(( $w_s / 2 ))

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

while true;
do
	echo -n ",["

	ifconfig tun0 2>/dev/null 1>&2
	if [ $? -eq 0 ]; then
		curr_rx=$(cat /proc/net/dev | awk '/tun0/ {print $2}')
		curr_tx=$(cat /proc/net/dev | awk '/tun0/ {print $10}')
	else
		curr_rx=$(cat /proc/net/dev | awk '/enp4s0/ {print $2}')
		curr_tx=$(cat /proc/net/dev | awk '/enp4s0/ {print $10}')
	fi

	speed_rx=$(($curr_rx/1024-$prev_rx/1024))
	speed_tx=$(($curr_tx/1024-$prev_tx/1024))

	echo -n "{"
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_icon,"
	echo -n "\"align\": \"center\","
	if [ -e /tmp/swaybar/bar-task-manager/icmp ]; then
		echo -n "\"color\":\"#088F8F\","
	else
		echo -n "\"color\":\"#FF0000\","
	fi
	echo -n "\"full_text\":\"\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator\": false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_t,"
	
	ifconfig tun0 2>/dev/null 1>&2
	if [ $? -eq 0 ]; then
		echo -n "\"full_text\":\" [VPN]\""
	else
		echo -n "\"full_text\":\" [LAN]\""
	fi
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator\": false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_rx,"
	echo -n "\"full_text\":\" RX: [\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"separator\": false,"
	echo -n "\"min_width\": $w_speed,"
	echo -n "\"align\": \"right\","
	echo -n "\"full_text\":\"$speed_rx KiB] \""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"separator\": false,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_tx,"
	echo -n "\"full_text\":\" TX: [\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_speed,"
	echo -n "\"align\": \"right\","
	echo -n "\"full_text\":\"$speed_tx KiB] \""
	echo -n "}"

	prev_rx=$curr_rx
	prev_tx=$curr_tx

	echo -n "]"
	
	sleep 1s

#	read -t 1 line
#	case  $line  in
#		*"id_cpu"*"event"*"272"*) 
#									swaymsg -q exec 'foot -a "cpu" htop' 
#									;;
#	esac
done
