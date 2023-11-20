#!/bin/bash

iface=none
w_icon=40
w_t=60
w_s=$(( $1 - $w_icon - $w_t ))

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

while true;
do
	echo -n ",["
	
	echo -n "{"
	echo -n "\"name\":\"id_vpn\","
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_icon,"
	echo -n "\"align\": \"center\","

	ifconfig tun0 2>/dev/null 1>&2
	if [ $? -eq 0 ]; then
		echo -n "\"color\":\"#088F8F\","
		echo "on" > /tmp/swaybar/bar-task-manager/vpn_status
	else
		echo -n "\"color\":\"#FF0000\","
		echo "off" > /tmp/swaybar/bar-task-manager/vpn_status
	fi

	echo -n "\"full_text\":\"\""
	echo -n "}"

	echo -n ","

	echo -n "{"
	echo -n "\"name\":\"id_vpn\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_t,"
	echo -n "\"full_text\":\" [VPN]\","
	echo -n "\"separator\":false,"
	echo -n "\"align\": \"left\""
	echo -n "}"

	echo -n ","

	echo -n "{"

#	ifconfig tun0 2>/dev/null 1>&2
#
#	if [ $? -eq 0 ]; then
#		echo -n "\"color\":\"#088F8F\","
#		echo -n "\"full_text\":\" on\","
#	else
#		echo -n "\"color\":\"#FF0000\","
		echo -n "\"full_text\":\"  \","
#	fi
#
	echo -n "\"min_width\": $w_s,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\""
	echo -n "}"

	echo -n "]"

	read -t 1 line
	case  $line  in
		 *"id_vpn"*"event"*"272"*) 
									if [ -e /tmp/swaybar/bar-task-manager/vpn_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/vpn_status)" = "off" ]; then
										swaymsg -q exec 'sudo rc-service openvpn start'
										echo "on" > /tmp/swaybar/bar-task-manager/vpn_status
									else
										swaymsg -q exec 'sudo rc-service openvpn stop'
										echo "off" > /tmp/swaybar/bar-task-manager/vpn_status
									fi
									;;
#		 *"id_vpn"*"event"*"273"*) 
#									swaymsg -q exec 'sudo rc-service openvpn stop'
#									;;
	esac
done
