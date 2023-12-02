#!/bin/bash

mkdir -p /tmp/swaybar
rm -rf /tmp/swaybar/bar-task-manager
mkdir -p /tmp/swaybar/bar-task-manager

. ~/.config/sway/swaybar.d/icmp.sh &
~/.config/sway/swaybar.d/create.sh >/dev/null 2>&1

sc_width=$(swaymsg -p -t get_outputs | awk '/mode:/ {print $3}' | cut -dx -f1)

count_workspace=1
all_workspaces=0
c_workspace=
for file in ${HOME}/.config/sway/workspaces.d/*; do
	wsp_name="$(cat $file | cut -d' ' -f3)"
	if [ $wsp_name ]; then
		c_workspace="$wsp_name $c_workspace"
		((all_workspaces++))
	fi
done
cur_wspc_name="$(echo "$c_workspace" | cut -d' ' -f1)"

st_icon_width=80
sys_tray_icon_width=40
scratch_icon_width=40
clock_width=80
scratch_windows_width=60
lang_width=40
lan_width=40
rotate_workspace_width=40

width_widgets_right=$(( $sys_tray_icon_width + $clock_width + $lang_width + $rotate_workspace_width + $lan_width ))
width_widgets_left=$(( $st_icon_width + $scratch_icon_width + $scratch_windows_width ))
width_widgets=$(( $width_widgets_left + $width_widgets_right ))
space_task_width=$(( $sc_width - $width_widgets - 5 ))

if [ $space_task_width -gt 2000 ]; then
	num_focused_workspace_win=20
elif [ $sc_width -gt 1000 ]; then
	num_focused_workspace_win=10
else
	num_focused_workspace_win=5
fi

focused_workspace_win_width=$(( 2000 / $num_focused_workspace_win ))

task_width=$(( $space_task_width - $focused_workspace_win_width * $num_focused_workspace_win ))

echo "off" > /tmp/swaybar/bar-task-manager/id_window_status
echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
echo "off" > /tmp/swaybar/bar-task-manager/id_time_status
echo "off" > /tmp/swaybar/bar-task-manager/id_scratch_windows_status
echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_lan_status

echo "0" > /tmp/swaybar/bar-task-manager/scratch_windows

~/.config/sway/swaybar.d/scratch.sh "$space_task_width" "$width_widgets_right" "$width_widgets_left" & >/dev/null 2>&1

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'


while true;
do
	swaymsg -p -t get_tree >/tmp/get_tree
	id="$(cat /tmp/get_tree | tr -d '\n')"
	all_workspace="$id"
	# cut scratch
	id="${id#*scratch}"
	id="${id%output*}"

	num_scratch=0
	pid_prev=0
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
	
	echo "true" > /tmp/swaybar/bar-task-manager/id-scratch-windows-separator

	echo -n "{"
	echo -n "\"name\":\"id_scratch_windows\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $scratch_windows_width,"
	if [ "x$num_scratch" != "x0" ]; then
		echo -n "\"full_text\":\" [$num_scratch]\","
	else
		echo -n "\"full_text\":\" \","
	fi
	if [ -e /tmp/swaybar/bar-task-manager/id-scratch-windows-separator ] && [ "x$(cat /tmp/swaybar/bar-task-manager/id-scratch-windows-separator)" != "x" ]; then
		echo -n "\"separator\":$(cat /tmp/swaybar/bar-task-manager/id-scratch-windows-separator),"
	else
		echo -n "\"separator\":false,"
	fi
	echo -n "\"align\": \"left\""
	echo -n "}"
	
	echo -n ","
	
	name_focused_workspace="$(swaymsg -p -t get_workspaces | grep focused | cut -d' ' -f2)"

	id=${all_workspace#*$name_focused_workspace}

	for ((i=1;i<=20;i++)); do
		id=${id%workspace*}
	done

	num_win=0
	pid_prev=0
	
	for ((i=1;i<=$num_focused_workspace_win;i++)); do
		rm -f /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-* >/dev/null 2>&1
	done

	while true; do
		name_w="$(echo "${id}" | tr -d '\"\(\)\r\t\v\n')"
		id="${id#*pid:}"
		pid=$(echo "${id}" | cut -d, -f1 | tr -d ' ')
		if [ "${pid}" = "${pid_prev}" ]; then break; fi
		pid_prev=${pid}
		app_id_test_str=$(echo "${id}" | awk -F ' ' '{print $2}')
		if [ "${app_id_test_str}" != "app_id:" ]; then break; fi
		app_id=$(echo "${id}" | awk -F'"' '{print $2}')
		lenght_app_id=${#app_id}
		app_id_short="$(echo "${app_id}" | cut -c1-10)~"
		num_win=$(( ${num_win} + 1 ))
		#full_text="[$app_id_short:$pid]"
		if [ $lenght_app_id -gt 11 ]; then
			full_text="$app_id_short"
		else
			full_text="$app_id"
		fi
		echo "${full_text}" > /tmp/swaybar/bar-task-manager/id-focused-workspace-win-${num_win}-full-text
		echo "${app_id}" > /tmp/swaybar/bar-task-manager/id-focused-workspace-win-${num_win}-app_id
		echo "${pid}" > /tmp/swaybar/bar-task-manager/id-focused-workspace-win-${num_win}-pid

		echo "true" > /tmp/swaybar/bar-task-manager/id-focused-workspace-win-${num_win}-separator
	done
	
	for ((i=1;i<=$num_focused_workspace_win;i++)); do
		
		echo -n "{"
		echo -n "\"name\":\"id_focused_workspace_win_$i\","
		echo -n "\"separator_block_width\": 0,"
		echo -n "\"min_width\": $focused_workspace_win_width,"
		if [ -e /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-full-text ] && [ "x$(cat /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-full-text)" != "x" ]; then
			echo -n "\"full_text\":\"$(cat /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-full-text)\","
		else
			echo -n "\"full_text\":\" \","
		fi
		if [ -e /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-separator ] && [ "x$(cat /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-separator)" != "x" ]; then
			echo -n "\"separator\":$(cat /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-separator),"
		else
			echo -n "\"separator\":false,"
		fi
		if [ $i -eq $num_win ]; then
			echo -n "\"color\":\"#00ff00\","
		fi
		echo -n "\"align\": \"center\""
		echo -n "}"	
		echo -n ","
	done
	
	echo -n "{"
	echo -n "\"name\":\"id_null\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $task_width,"
	echo -n "\"full_text\":\" \","
	echo -n "\"separator\":false,"
	echo -n "\"align\": \"left\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"name\":\"id_sys_tray\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $sys_tray_icon_width,"
	echo -n "\"full_text\":\"\","
	#for test put in foot: echo "#ff0000" >/tmp/swaybar/bar-task-manager/id-sys-tray-color
	if [ -e /tmp/swaybar/bar-task-manager/id-sys-tray-color ] && [ "x$(cat /tmp/swaybar/bar-task-manager/id-sys-tray-color)" != "x" ] && [ ${id_sys_tray_color} ]; then
		id_sys_tray_color=
		echo -n "\"color\":\"$(cat /tmp/swaybar/bar-task-manager/id-sys-tray-color)\","
	else
		echo -n "\"color\":\"#ffffffff\","
		id_sys_tray_color="x"
	fi
	echo -n "\"separator\":true,"
	echo -n "\"align\": \"center\""
	echo -n "}"
	
	echo -n ","
	
	echo -n "{"
	echo -n "\"name\":\"id_lan\","
	if [ -e /tmp/swaybar/bar-task-manager/icmp-enp4s0 ] || [ -e /tmp/swaybar/bar-task-manager/icmp-wlan0 ] || [ -e /tmp/swaybar/bar-task-manager/icmp-tun0 ]; then
		echo -n "\"color\":\"#088F8F\","
	else
		echo -n "\"color\":\"#FF0000\","
	fi
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $lan_width,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\":\"\""
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
	echo -n "\"separator\": true,"
	echo -n "\"min_width\": $clock_width,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\": \"$(date "+%H:%M")\""
	echo -n "}"
	
	echo -n ","

	echo -n "{"
	echo -n "\"name\": \"id_rotate_workspace\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $rotate_workspace_width,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\": \"\""
	echo -n "}"

	echo  -n "]"

	read -t 1 line
	line_win="$line"
	
	case  $line  in
		*"id_rotate_workspace"*"event"*"768"*) 
									swaymsg -q workspace next 
									;;
		*"id_rotate_workspace"*"event"*"769"*) 
									swaymsg -q workspace prev 
									;;
		*"id_lang"*"event"*"272"*) 
									swaymsg -q input "49396:1216:SZH_usb_keyboard" xkb_switch_layout next 
									;;
		*"id_lan"*"event"*"272"*) 
									if [ -e /tmp/swaybar/bar-task-manager/id_sys_tray_lan_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/id_sys_tray_lan_status)" = "off" ]; then
										echo "off" > /tmp/swaybar/bar-task-manager/id_time_status
										swaymsg -q bar sys-tray-clock-full hidden_state hide

										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
										for bar_id in $(cat /tmp/swaybar/id_menu_tray)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done

										echo "on" > /tmp/swaybar/bar-task-manager/id_sys_tray_lan_status
										for bar_id in $(cat /tmp/swaybar/id_menu_lan)
										do 
											swaymsg -q bar $bar_id hidden_state show
										done
										
									else
										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_lan_status
										for bar_id in $(cat /tmp/swaybar/id_menu_lan)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done
									fi
									;;
		 *"id_window"*"event"*"768"*)
		 							if [ $count_workspace -le $all_workspaces ]; then
										cur_wspc_name="$(echo "$c_workspace" | cut -d' ' -f$count_workspace)"
										if [ $cur_wspc_name ]; then
											swaymsg -q workspace $cur_wspc_name >/dev/null 2>&1
											((count_workspace++))
										fi
									else
										count_workspace=1
									fi
									;;
		 *"id_window"*"event"*"769"*)
		 							if [ $count_workspace -gt 0 ]; then
										cur_wspc_name="$(echo "$c_workspace" | cut -d' ' -f$count_workspace)"
										if [ $cur_wspc_name ]; then
											swaymsg -q workspace $cur_wspc_name >/dev/null 2>&1
											((count_workspace--))
										fi
									else
										count_workspace=$all_workspaces
		 							fi
									;;
		 *"id_window"*"event"*"272"*)
									if [ -e /tmp/swaybar/bar-task-manager/id_window_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/id_window_status)" = "off" ]; then
										for bar_id in $(cat /tmp/swaybar/id_menu_start)
										do 
											swaymsg -q bar $bar_id hidden_state show
										done
										echo "on" > /tmp/swaybar/bar-task-manager/id_window_status
									else
										for bar_id in $(cat /tmp/swaybar/id_menu_start)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done
										echo "off" > /tmp/swaybar/bar-task-manager/id_window_status
									fi
									;;
		 *"id_time"*"event"*"272"*)
									if [ -e /tmp/swaybar/bar-task-manager/id_time_status ] && [ "$(cat /tmp/swaybar/bar-task-manager/id_time_status)" = "off" ]; then
										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_lan_status
										for bar_id in $(cat /tmp/swaybar/id_menu_lan)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done

										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
										for bar_id in $(cat /tmp/swaybar/id_menu_tray)
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
										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_lan_status
										for bar_id in $(cat /tmp/swaybar/id_menu_lan)
										do 
											swaymsg -q bar $bar_id hidden_state hide
										done

										echo "off" > /tmp/swaybar/bar-task-manager/id_time_status
										swaymsg -q bar sys-tray-clock-full hidden_state hide

										echo "on" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
										for bar_id in $(cat /tmp/swaybar/id_menu_tray)
										do 
											swaymsg -q bar $bar_id hidden_state show
										done
										
									else
										echo "off" > /tmp/swaybar/bar-task-manager/id_sys_tray_status
										for bar_id in $(cat /tmp/swaybar/id_menu_tray)
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
		 *"id_focused_workspace_win_"*"event"*"272"*)
									for ((i=1;i<=$num_focused_workspace_win;i++)); do
										if [ "x$(echo $line | grep id_focused_workspace_win_$i)" != "x" ]; then
											id_focused_workspace_win_pid="$(cat /tmp/swaybar/bar-task-manager/id-focused-workspace-win-$i-pid)"
											swaymsg -q exec sway [pid="$id_focused_workspace_win_pid"] focus
											break
										fi
									done
									;;
	esac
done
