#!/bin/bash

scratch_width=$1
scratch_right=$2
scratch_left=$3

sc_heigth=$(swaymsg -p -t get_outputs | awk '/mode:/ {print $3}' | cut -dx -f2)

_height=30
cut_left=$scratch_left
cut_right=$scratch_right
cut_top=0

while true; do

	for (( i=1;i<=$(cat /tmp/swaybar/bar-task-manager/scratch_windows);i++ )); do
		if [ ! -d /tmp/swaybar/bar-scratch-window-$i ]; then break; fi
		swaymsg -q bar scratch-window-$i mode hide
		if [ "$(cat /tmp/swaybar/bar-task-manager/id_scratch_windows_status )" = "off" ]; then
			swaymsg -q bar scratch-window-$i hidden_state hide
		else
			swaymsg -q bar scratch-window-$i hidden_state show
		fi
		swaymsg -q bar scratch-window-$i workspace_buttons no
		swaymsg -q bar scratch-window-$i modifier none
		swaymsg -q bar scratch-window-$i height $_height

		cut_bottom=$(( 5 + $i * $_height ))
		cut_top=$(( $sc_heigth - ${cut_bottom} - $_height - 30 ))

		swaymsg -q bar scratch-window-$i gaps ${cut_top} ${cut_right} ${cut_bottom} ${cut_left}
		swaymsg -q bar scratch-window-$i status_padding 0
		swaymsg -q bar scratch-window-$i status_edge_padding 0
		swaymsg -q bar scratch-window-$i status_command "${HOME}/.config/sway/swaybar.d/bar-scratch-x.sh scratch-window-$i $scratch_width"
		~/.config/sway/swaybar.d/bar-colors.sh "my" "scratch-window-$i" >/dev/null 2>&1
	done
	sleep 1s
done

