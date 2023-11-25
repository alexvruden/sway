while true;
do
 	ifconfig | grep -q enp4s0 >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		ifconfig enp4s0 | grep -q inet >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			ping -I enp4s0 -c 1 -W 3 8.8.8.8 >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				if [ ! -e /tmp/swaybar/bar-task-manager/icmp-enp4s0 ]; then 
					echo "on" > /tmp/swaybar/bar-task-manager/icmp-enp4s0
				fi
			else
				if [ -e /tmp/swaybar/bar-task-manager/icmp-enp4s0 ]; then 
					rm /tmp/swaybar/bar-task-manager/icmp-enp4s0
				fi
			fi
		else
			if [ -e /tmp/swaybar/bar-task-manager/icmp-enp4s0 ]; then 
				rm /tmp/swaybar/bar-task-manager/icmp-enp4s0
			fi
		fi
	else
		if [ -e /tmp/swaybar/bar-task-manager/icmp-enp4s0 ]; then 
			rm /tmp/swaybar/bar-task-manager/icmp-enp4s0
		fi
	fi

 	ifconfig | grep -q wlan0 >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		ifconfig wlan0 | grep -q inet >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			ping -I wlan0 -c 1 -W 3 8.8.8.8 >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				if [ ! -e /tmp/swaybar/bar-task-manager/icmp-wlan0 ]; then 
					echo "on" > /tmp/swaybar/bar-task-manager/icmp-wlan0
				fi
			else
				if [ -e /tmp/swaybar/bar-task-manager/icmp-wlan0 ]; then 
					rm /tmp/swaybar/bar-task-manager/icmp-wlan0
				fi
			fi
		else
			if [ -e /tmp/swaybar/bar-task-manager/icmp-wlan0 ]; then 
				rm /tmp/swaybar/bar-task-manager/icmp-wlan0
			fi
		fi
	else
		if [ -e /tmp/swaybar/bar-task-manager/icmp-wlan0 ]; then 
			rm /tmp/swaybar/bar-task-manager/icmp-wlan0
		fi
	fi

 	ifconfig | grep -q tun0 >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		ifconfig tun0 | grep -q inet >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			ping -I tun0 -c 1 -W 3 8.8.8.8 >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				if [ ! -e /tmp/swaybar/bar-task-manager/icmp-tun0 ]; then 
					echo "on" > /tmp/swaybar/bar-task-manager/icmp-tun0
				fi
			else
				if [ -e /tmp/swaybar/bar-task-manager/icmp-tun0 ]; then 
					rm /tmp/swaybar/bar-task-manager/icmp-tun0
				fi
			fi
		else
			if [ -e /tmp/swaybar/bar-task-manager/icmp-tun0 ]; then 
				rm /tmp/swaybar/bar-task-manager/icmp-tun0
			fi
		fi
	else
		if [ -e /tmp/swaybar/bar-task-manager/icmp-tun0 ]; then 
			rm /tmp/swaybar/bar-task-manager/icmp-tun0
		fi
	fi

    sleep 10s
done
