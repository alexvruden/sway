#!/bin/bash

#log="/tmp/start.log"
log="/dev/null"
echo " $0 : Start" >>$log

rm -rf /tmp/swaybar/color-theme
mkdir -p /tmp/swaybar/color-theme
mkdir -p /tmp/swaybar/color-theme/default
mkdir -p /tmp/swaybar/color-theme/sway
mkdir -p /tmp/swaybar/color-theme/my

default_colors="background:#000000ff, statusline:#ffffffff, separator:#666666ff, \
				focused_background:#000000ff, focused_statusline:#ffffffff, focused_separator:#666666ff, \
				focused_workspace_border:#4c7899ff, focused_workspace_bg:#285577ff, focused_workspace_text:#ffffffff, \
				inactive_workspace_border:#333333ff, inactive_workspace_bg:#222222ff, inactive_workspace_text:#888888ff, \
				active_workspace_border:#333333ff, active_workspace_bg:#5f676aff, active_workspace_text:#ffffffff, \
				urgent_workspace_border:#2f343aff, urgent_workspace_bg:#900000ff, urgent_workspace_text:#ffffffff, \
				binding_mode_border:#2f343aff, binding_mode_bg:#900000ff, binding_mode_text:#ffffffff"

sway_colors="background:#323232ff, statusline:#ffffffff, inactive_workspace_text:#5c5c5cff, inactive_workspace_bg:#323232ff, inactive_workspace_border:#323232ff"
my_colors="background:#323232ff, statusline:#ffffffff"

color_n=$1
if [ ! $color_n ]; then
	color_n="my-colors"
fi

echo "$default_colors" > /tmp/swaybar/color-theme/default/colors
echo "$sway_colors" > /tmp/swaybar/color-theme/sway/colors

echo "$my_colors" > /tmp/swaybar/color-theme/my/colors
echo "30" > /tmp/swaybar/color-theme/my/height

set_color() {
	#echo "[d] bar_name=$1"
	i=1
	while true;
	do
		color=$( echo "$colors" | cut -d, -f${i} )
		#echo "[d][$i] color=$color"
		if [ "x${color}" != "x" ]; then
			color_name=$( echo "${color}" | cut -d: -f1 )
			color_value=$( echo "${color}" | cut -d: -f2 )
			#echo "[d] swaymsg -q bar $1 colors ${color_name} \"${color_value}\""
			swaymsg -q bar $1 colors ${color_name} "${color_value}"
#			swaymsg -q bar $1 font "pango:monospace 10"
#			swaymsg -q bar $1 height 30
			
		else
			break
		fi
		i=$(( ${i} + 1 ))
	done
	return
}
	
bar_name=$2
bar_names="$( swaymsg -t get_bar_config | tr -d '\]\[\"\r\t\v\n ' | tr -s ',' ' ' )"

if [ $bar_name ]; then
	st=
	for i in $bar_names
	do
		if [ "$i" = "$bar_name" ]; then 
			st=1
			break
		fi
	done
	if [ ! $st ]; then
		echo " $0 : not valid bar name, exit" >>$log
		exit 1
	fi
fi


go=1

if [ -e /tmp/swaybar/color-theme/default/colors ] && [ "x$(cat /tmp/swaybar/color-theme/default/colors)" != "x" ] && [ "x$color_n" = "xdefault" ]; then
	colors=$(cat /tmp/swaybar/color-theme/default/colors | tr -d '\r\t\v\n ' )
elif [ -e /tmp/swaybar/color-theme/sway/colors ] && [ "x$(cat /tmp/swaybar/color-theme/sway/colors)" != "x" ] && [ "x$color_n" = "xsway-colors" ]; then
	colors=$(cat /tmp/swaybar/color-theme/sway/colors | tr -d '\r\t\v\n ' )
elif [ -e /tmp/swaybar/color-theme/my/colors ] && [ "x$(cat /tmp/swaybar/color-theme/my/colors)" != "x" ] && [ "x$color_n" = "xmy-colors" ]; then
	colors=$(cat /tmp/swaybar/color-theme/my/colors | tr -d '\r\t\v\n ' )
else
	go=
fi

if [ $go ]; then
	if [ ! $bar_name ]; then
		for bar_name in $bar_names
		do
			set_color "$bar_name"
		done
	else
		set_color "$bar_name"
	fi
fi

echo " $0 : end" >>$log
