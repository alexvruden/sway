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
			echo "nocon" > /tmp/swaybar/bar-task-manager/${iface}_status
		fi
	fi

	ifconfig | grep -q $iface >/dev/null 2>&1
 	if [ $? -eq 0 ]; then
		iface_on_off="on"
		echo "up" > /tmp/swaybar/bar-task-manager/${iface}_status
	else
		iface_on_off="off"
		echo "down" > /tmp/swaybar/bar-task-manager/${iface}_status
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
	if [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
		echo -n "\"name\":\"id_iface\","
	fi
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
	if [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
		echo -n "\"name\":\"id_iface\","
	fi
	echo -n "\"separator\": false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\","
	echo -n "\"min_width\": $w_t,"
	
	if [ "$iface" = "enp4s0" ]; then
		echo -n "\"full_text\":\" [LAN]\""
	elif [ "$iface" = "wlan0" ]; then
		if [ -e /tmp/wpa_supplicant.log ]; then 
			ssid="$(sudo cat /tmp/wpa_supplicant.log | grep -r -m 1 "Trying to associate with" - | cut -d\' -f2 )"
		elif [ -e /var/log/wpa_supplicant.log ]; then 
			ssid="$(sudo cat /var/log/wpa_supplicant.log | grep -r -m 1 'Trying to associate with' - | cut -d\' -f2 )"
		else
			ssid=""
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
	if [ "$iface_on_off" = "off" ]; then
		echo -n "\"full_text\":\" down\""
	else
		if [ "$iface_inet" = "false" ]; then 
			echo -n "\"full_text\":\" not\""
		else
			echo -n "\"full_text\":\" RX: [\""
		fi
	fi
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"separator\": false,"
	echo -n "\"min_width\": $w_speed,"
	if [ "$iface_on_off" = "off" ]; then
		echo -n "\"align\": \"right\","
		echo -n "\"full_text\":\" \""
	else
		if [ "$iface_inet" = "false" ]; then 
			echo -n "\"align\": \"left\","
			echo -n "\"full_text\":\"connected \""
		else
			echo -n "\"align\": \"right\","
			echo -n "\"full_text\":\"$speed_rx KiB] \""
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
			echo -n "\"full_text\":\" TX: [\""
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
			echo -n "\"full_text\":\"$speed_tx KiB] \""
		fi
	fi
	echo -n "}"

	echo -n "]"
	
	read -t 1 line
	case  $line  in
		*"id_iface"*"event"*"272"*) 
								if [ "$iface" = "tun0" ]; then
									if [ -e /tmp/swaybar/bar-task-manager/${iface}_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" = "down" ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
										swaymsg -q exec 'sudo rc-service openvpn start' >/dev/null 2>&1
									elif [ -e /tmp/swaybar/bar-task-manager/${iface}_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "down" ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
										swaymsg -q exec 'sudo rc-service openvpn stop' >/dev/null 2>&1
									fi
									echo "wait" > /tmp/swaybar/bar-task-manager/${iface}_status
								elif [ "$iface" = "wlan0" ]; then
									if [ -e /tmp/swaybar/bar-task-manager/${iface}_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" = "down" ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
										if [ ! -L /etc/init.d/net.${iface} ]; then
											sudo ln -s /etc/init.d/net.lo /etc/init.d/net.${iface} >/dev/null 2>&1
										fi
										swaymsg -q exec 'sudo /etc/init.d/net.wlan0 start' >/dev/null 2>&1
									elif [ -e /tmp/swaybar/bar-task-manager/${iface}_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "down" ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
										swaymsg -q exec 'sudo /etc/init.d/net.wlan0 stop' >/dev/null 2>&1
										while ifconfig | grep -q wlan0; do sleep 1s; done
										if [ -L /etc/init.d/net.wlan0 ]; then
											sudo rm -f /etc/init.d/net.wlan0 >/dev/null 2>&1
										fi
									fi
									echo "wait" > /tmp/swaybar/bar-task-manager/${iface}_status
								elif [ "$iface" = "enp4s0" ]; then
									if [ -e /tmp/swaybar/bar-task-manager/${iface}_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" = "down" ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
										swaymsg -q exec 'sudo ifconfig enp4s0 up'
									elif [ -e /tmp/swaybar/bar-task-manager/${iface}_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "down" ] && [ "$(cat /tmp/swaybar/bar-task-manager/${iface}_status)" != "wait" ]; then
										swaymsg -q exec 'sudo ifconfig enp4s0 down'
									fi
									echo "wait" > /tmp/swaybar/bar-task-manager/${iface}_status
								fi
								;;
	esac
done
