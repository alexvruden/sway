while true;
do
    ping -c 1 -W 10 8.8.8.8 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
		if [ ! -e /tmp/swaybar/bar-task-manager/icmp ]; then 
			echo "on" > /tmp/swaybar/bar-task-manager/icmp
		fi
    else
		if [ -e /tmp/swaybar/bar-task-manager/icmp ]; then 
			rm /tmp/swaybar/bar-task-manager/icmp
		fi
    fi

    sleep 10s
done
