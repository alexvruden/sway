#!/bin/bash

iface="$2"

prev_rx=0
prev_tx=0

w_icon=40
w_t=160
w_tx=60
w_rx=60
w_s=$(( $1 - $w_t - $w_tx - $w_rx - $w_icon ))
w_speed=$(( $w_s / 2 ))
ssid=""

echo "x" > /tmp/swaybar/bar-task-manager/${iface}_status

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

while true;
do
	echo -n ",["

	ifconfig | grep -q $iface >/dev/null 2>&1
 	if [ $? -eq 0 ]; then
		ifconfig $iface | grep -q inet >/dev/null 2>&1
		if [ $? -eq 0 ] && [ "$iface_on_off" = "on" ]; then
			iface_inet="true"
			echo "con" > /tmp/swaybar/bar-task-manager/${iface}_status
		else
			iface_inet="false"
			if [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then echo "nocon" > /tmp/swaybar/bar-task-manager/${iface}_status; fi
		fi
	fi

	ifconfig | grep -q $iface >/dev/null 2>&1
 	if [ $? -eq 0 ]; then
		iface_on_off="on"
		echo "up" > /tmp/swaybar/bar-task-manager/${iface}_status
	else
		iface_on_off="off"
		if [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then echo "down" > /tmp/swaybar/bar-task-manager/${iface}_status; fi
	fi
	
	cat /proc/net/dev | grep -q $iface >/dev/null 2>&1
	if [ $? -eq 0 ] && [ "$iface_inet" = "true" ]; then 
		echo "con" > /tmp/swaybar/bar-task-manager/${iface}_status
		curr_rx="$(cat /proc/net/dev | grep $iface | awk '{print $2}')"
		curr_tx="$(cat /proc/net/dev | grep $iface | awk '{print $10}')"
		speed_rx="$(($curr_rx/1024-$prev_rx/1024))"
		speed_tx="$(($curr_tx/1024-$prev_tx/1024))"
	else
		curr_rx=0
		curr_tx=0
		speed_rx="-"
		speed_tx="-"
	fi
	
	prev_rx=$curr_rx
	prev_tx=$curr_tx
	
	echo -n "{"
	echo -n "\"name\":\"id_iface\","
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_icon,"
	echo -n "\"align\": \"center\","
	if [ -e /tmp/swaybar/bar-task-manager/icmp-$iface ]; then
		echo -n "\"color\":\"#088F8F\","
	else
		echo -n "\"color\":\"#FF0000\","
	fi
	
	if [ "$iface" = "enp4s0" ]; then
		echo -n "\"full_text\":\"\""
	elif [ "$iface" = "wlan0" ]; then
		echo -n "\"full_text\":\"\""
	elif [ "$iface" = "tun0" ]; then
		echo -n "\"full_text\":\"\""
	fi
	
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"name\":\"id_iface\","
	echo -n "\"separator\": false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_t,"
	
	if [ "$iface" = "enp4s0" ]; then
		echo -n "\"full_text\":\" [LAN]\""
	elif [ "$iface" = "wlan0" ]; then
		if [ ! $ssid ]; then
			if [ -f /tmp/wpa_supplicant.log ] && [ "$iface_inet" = "true" ]; then 
				ssid="$(sudo cat /tmp/wpa_supplicant.log | grep -r -m 1 "Trying to associate with" - | cut -d\' -f2 )"
			elif [ -f /var/log/wpa_supplicant.log ] && [ "$iface_inet" = "true" ]; then 
				ssid="$(sudo cat /var/log/wpa_supplicant.log | grep -r -m 1 'Trying to associate with' - | cut -d\' -f2 )"
			fi
		fi
		
		if [ $ssid ] && [ "$iface_inet" = "true" ]; then
			lenght_ssid=${#ssid}
			if [ $lenght_ssid -gt 8 ]; then
				short_ssid="$(echo "${ssid}" | cut -c1-7)~"
				echo -n "\"full_text\":\" [WiFi]: ${short_ssid}\""	
			else
				echo -n "\"full_text\":\" [WiFi]: $ssid\""	
			fi
		else
			echo -n "\"full_text\":\" [WiFi]\""
		fi
	elif [ "$iface" = "tun0" ]; then
		echo -n "\"full_text\":\" [VPN]\""
	fi
	
	echo -n "}"
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator\": false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_rx,"
	if [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" = "wait" ]; then
		echo -n "\"full_text\":\" \""
	else
		if [ "$iface_on_off" = "off" ]; then
			echo -n "\"full_text\":\" down\""
		else
			if [ "$iface_inet" = "false" ]; then 
				echo -n "\"full_text\":\" not\""
			else
				echo -n "\"full_text\":\" RX: \""
			fi
		fi
	fi
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"separator\": false,"
	echo -n "\"min_width\": $w_speed,"
	if [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" = "wait" ]; then
		echo -n "\"full_text\":\" waiting...\""
	else
		if [ "$iface_on_off" = "off" ]; then
			echo -n "\"align\": \"right\","
			echo -n "\"full_text\":\" \""
		else
			if [ "$iface_inet" = "false" ]; then 
				echo -n "\"align\": \"left\","
				echo -n "\"full_text\":\"connected \""
			else
				echo -n "\"align\": \"right\","
				echo -n "\"full_text\":\"$speed_rx KiB \""
			fi
		fi
	fi
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"separator\": false,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_tx,"
	if [ "$iface_on_off" = "off" ]; then
		echo -n "\"full_text\":\" \""
	else
		if [ "$iface_inet" = "false" ]; then 
			echo -n "\"full_text\":\" \""
		else
			echo -n "\"full_text\":\" TX: \""
		fi
	fi
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_speed,"
	echo -n "\"align\": \"right\","
	if [ "$iface_on_off" = "off" ]; then
		echo -n "\"full_text\":\" \""
	else
		if [ "$iface_inet" = "false" ]; then 
			echo -n "\"full_text\":\" \""
		else
			echo -n "\"full_text\":\"$speed_tx KiB \""
		fi
	fi
	echo -n "}"

	echo -n "]"
	
	read -t 1 line
	case  $line  in
		*"id_iface"*"event"*"272"*) 
								if [ "$iface" = "tun0" ]; then
									swaymsg -q exec 'foot -T "Starting OpenVPN" ~/.config/sway/swaybar.d/ovpn.sh'
#									echo "wait" > /tmp/swaybar/bar-task-manager/${iface}_status
								elif [ "$iface" = "wlan0" ]; then
									if [ ! -L /etc/init.d/net.${iface} ]; then
										sudo ln -s /etc/init.d/net.lo /etc/init.d/net.${iface} >/dev/null 2>&1
									fi
									swaymsg -q exec 'sudo /etc/init.d/net.wlan0 start' >/dev/null 2>&1
									echo "wait" > /tmp/swaybar/bar-task-manager/${iface}_status
								elif [ "$iface" = "enp4s0" ]; then
									swaymsg -q exec 'sudo ifconfig enp4s0 up'
									echo "wait" > /tmp/swaybar/bar-task-manager/${ifacSe}_status
								fi
								;;
		*"id_iface"*"event"*"273"*) 
								if [ "$iface" = "tun0" ]; then
									#for file in /etc/init.d/openvpn.*; do
									for file in /run/openvpn.*; do
										ff=${file##*/}
										ff=${ff%.*}
									done
									if [ ${ff} ]; then
										swaymsg -q exec "sudo /etc/init.d/${ff} stop" >/dev/null 2>&1
										echo "down" > /tmp/swaybar/bar-task-manager/${iface}_status
									fi
								elif [ "$iface" = "wlan0" ]; then
									swaymsg -q exec 'sudo /etc/init.d/net.wlan0 stop' >/dev/null 2>&1
									while ifconfig | grep -q wlan0; do sleep 1s; done
									if [ -L /etc/init.d/net.wlan0 ]; then
										sudo rm -f /etc/init.d/net.wlan0 >/dev/null 2>&1
									fi
									echo "down" > /tmp/swaybar/bar-task-manager/${iface}_status
								elif [ "$iface" = "enp4s0" ]; then
									swaymsg -q exec 'sudo ifconfig enp4s0 down'
									echo "down" > /tmp/swaybar/bar-task-manager/${iface}_status
								fi
								;;
	esac
done
