#!/bin/bash

#log="/tmp/start.log"
log="/dev/null"

echo " $0 : Start" >$log
echo " $0 : goto create" >>$log

mkdir -p /tmp/swaybar
rm -rf /tmp/swaybar/bar-task-manager
mkdir -p /tmp/swaybar/bar-task-manager

~/.config/sway/swaybar.d/create.sh >/dev/null 2>&1

sc_width=$(swaymsg -p -t get_outputs | awk '/mode:/ {print $3}' | cut -dx -f1)

st_icon_width=80
sys_tray_icon_width=40
scratch_icon_width=40
clock_width=80
scratch_windows_width=60
lang_width=40

task_width=$(( $sc_width - $st_icon_width - $sys_tray_icon_width - $scratch_icon_width - $scratch_windows_width - $clock_width - $lang_width - 5 ))

scratch_right=$(( $sys_tray_icon_width + $clock_width + $lang_width ))
#scratch_left=$(( $st_icon_width + $scratch_icon_width + $scratch_windows_width ))
scratch_left=$(( $st_icon_width + $scratch_icon_width ))


echo "off" > /tmp/swaybar/bar-task-manager/id_window_status
echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
echo "off" > /tmp/swaybar/bar-task-manager/id_time_status
echo "off" > /tmp/swaybar/bar-task-manager/id_scratch_windows_status

echo "0" > /tmp/swaybar/bar-task-manager/scratch_windows

~/.config/sway/swaybar.d/scratch.sh "$task_width" "$scratch_right" "$scratch_left" & >/dev/null 2>&1

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

echo " $0 : goto loop" >>$log

while true;
do
	echo " $0 : main loop" >>$log
	swaymsg -p -t get_tree >/tmp/get_tree
	id="$(cat /tmp/get_tree | tr -d '\n')"
	# cut scratch
	id="${id#*scratch}"
	id="${id%output*}"

	num_scratch=0
	pid_prev=0
	echo " $0 : calculate scratch" >>$log
	while true; do
		# find first item
		name_w="$(echo "${id}" | tr -d '\"\(\)\r\t\v\n')"

		id="${id#*pid:}"
		pid=$(echo "${id}" | cut -d, -f1 | tr -d ' ')

		if [ "${pid}" = "${pid_prev}" ]; then break; fi

		pid_prev=${pid}
		test_str=$(echo "${id}" | awk -F ' ' '{print $2}')
		if [ "${test_str}" != "app_id:" ]; then break; fi
		app_id=$(echo "${id}" | awk -F'"' '{print $2}')
		
		num_scratch=$(( ${num_scratch} + 1 ))

		#rm -rf /tmp/swaybar/bar-scratch-window-${num_scratch}
		mkdir -p /tmp/swaybar/bar-scratch-window-${num_scratch} >/dev/null 2>&1 

		name_w="${name_w#*con}"
		len_1_name=${#name_w}
		name_w_t="${name_w#*xdg_shell, pid: $pid, app_id: $app_id}"
		var_name="xdg_shell, pid: $pid, app_id: $app_id"
		len_2_name=${#name_w_t}
		len_var_name=${#var_name}
		len_name=$(( $len_1_name - $len_2_name - $len_var_name ))
		names=$(echo "$name_w" | cut -c-$len_name)

		echo "${pid}" >/tmp/swaybar/bar-scratch-window-${num_scratch}/pid-file
		event_272="sway [pid=\"${pid}\"] focus"
		echo "$event_272" > /tmp/swaybar/bar-scratch-window-${num_scratch}/event-272
		echo "Name: [${names}], Pid: [${pid}]" > /tmp/swaybar/bar-scratch-window-${num_scratch}/full-text
		echo "#FFFFFF" > /tmp/swaybar/bar-scratch-window-${num_scratch}/full-text-color

	done
	echo "$num_scratch" > /tmp/swaybar/bar-task-manager/scratch_windows
	echo " $0 : num_scratch=$num_scratch" >>$log
	
#	if [ "x$num_scratch" != "x0" ]; then
		#. ~/.config/sway/swaybar.d/scratch.sh "$scratch_right" "$scratch_left" >/dev/null 2>&1
#	fi

	echo -n ",["
	
	echo -n "{"
	echo -n "\"separator\":true,"
	echo -n "\"name\":\"id_window\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $st_icon_width,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\":\" Start\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"name\":\"id_move_to_scratch\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $scratch_icon_width,"
	echo -n "\"full_text\":\" \","
	echo -n "\"separator\":false,"
	echo -n "\"align\": \"right\""
	echo -n "}"
	
	echo -n ","

	#if [ -e /tmp/swaybar/bar-task-manager/scratch_windows ] && [ "x$(cat /tmp/swaybar/bar-task-manager/scratch_windows)" != "x" ]; then
		#scratch_windows="$(cat /tmp/swaybar/bar-task-manager/scratch_windows)"
	#fi
	
	echo -n "{"
	echo -n "\"name\":\"id_scratch_windows\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $scratch_windows_width,"
	if [ "x$num_scratch" != "x0" ]; then
		echo -n "\"full_text\":\" [$num_scratch]\","
	else
		echo -n "\"full_text\":\" \","
	fi
	echo -n "\"separator\":false,"
	echo -n "\"align\": \"left\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"name\":\"id_null\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $task_width,"
	echo -n "\"full_text\":\"  \","
	echo -n "\"separator\":false,"
	echo -n "\"align\": \"left\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"name\":\"id_sys_tray\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $sys_tray_icon_width,"
	echo -n "\"full_text\":\"\","
	echo -n "\"separator\":true,"
	echo -n "\"align\": \"center\""
	echo -n "}"
	
	echo -n ","
	
	ilang=$(swaymsg -p -t get_inputs | tail -n 32 | grep -m 1 'Active Keyboard Layout' | awk '{print $4}')

	echo -n "{"
	echo -n "\"name\":\"id_lang\","
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $lang_width,"
	echo -n "\"align\": \"center\","
	if [ "x${ilang}" = "xRussian" ]; then
		echo -n "\"full_text\":\"RU\""
	else
		echo -n "\"full_text\":\"US\""
	fi
	echo -n "}"

	echo -n ","

	echo -n "{"
	echo -n "\"name\": \"id_time\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $clock_width,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\": \"$(date "+%H:%M")\""
	echo -n "}"

	echo  -n "]"

	read -t 1 line
	case  $line  in
		*"id_lang"*"event"*"272"*) 
									swaymsg -q input "49396:1216:SZH_usb_keyboard" xkb_switch_layout next 
									;;
		 *"id_window"*"event"*"272"*)
									if [ -e /tmp/swaybar/bar-task-manager/id_window_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/id_window_status)" = "off" ]; then
										for bar_id in $(cat /tmp/swaybar/idb)
										do 
											swaymsg -q bar $bar_id hidden_state show
										done
										echo "on" > /tmp/swaybar/bar-task-manager/id_window_status
									else
										for bar_id in $(cat /tmp/swaybar/idb)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done
										echo "off" > /tmp/swaybar/bar-task-manager/id_window_status
									fi
									;;
		 *"id_time"*"event"*"272"*)
									if [ -e /tmp/swaybar/bar-task-manager/id_time_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/id_time_status)" = "off" ]; then
										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
										for bar_id in $(cat /tmp/swaybar/idb_sys_tray)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done

										echo "on" > /tmp/swaybar/bar-task-manager/id_time_status
										swaymsg -q bar sys-tray-clock-full hidden_state show

									else
										echo "off" > /tmp/swaybar/bar-task-manager/id_time_status
										swaymsg -q bar sys-tray-clock-full hidden_state hide
									fi
									;;
		 *"id_sys_tray"*"event"*"272"*)
									if [ -e /tmp/swaybar/bar-task-manager/id_sys_tray_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/id_sys_tray_status)" = "off" ]; then
										echo "off" > /tmp/swaybar/bar-task-manager/id_time_status
										swaymsg -q bar sys-tray-clock-full hidden_state hide

										echo "on" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
										for bar_id in $(cat /tmp/swaybar/idb_sys_tray)
										do 
											swaymsg -q bar $bar_id hidden_state show
										done
										
									else
										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
										for bar_id in $(cat /tmp/swaybar/idb_sys_tray)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done
									fi
									;;
		 *"id_move_to_scratch"*"event"*"272"*)
									swaymsg -q move scratchpad
									;;
		 *"id_scratch_windows"*"event"*"272"*)
									if [ -e /tmp/swaybar/bar-task-manager/id_scratch_windows_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/id_scratch_windows_status)" = "off" ]; then
#										echo "off" > /tmp/swaybar/id_time_status
#										swaymsg -q bar sys-tray-clock-full hidden_state hide
										
#										echo "off" > /tmp/swaybar/id_sys_tray_status
#										for bar_id in $(cat /tmp/swaybar/idb_sys_tray)
#										do 
#											swaymsg -q bar $bar_id hidden_state hide
#										done
										
										echo "on" > /tmp/swaybar/bar-task-manager/id_scratch_windows_status
										for (( i=1;i<=$(cat /tmp/swaybar/bar-task-manager/scratch_windows);i++ ))
										do 
											swaymsg -q bar scratch-window-$i hidden_state show
										done
									else
										echo "off" > /tmp/swaybar/bar-task-manager/id_scratch_windows_status
										for (( i=1;i<=$(cat /tmp/swaybar/bar-task-manager/scratch_windows);i++ ))
										do 
											swaymsg -q bar scratch-window-$i hidden_state hide
										done
									fi
									;;
	esac
done
