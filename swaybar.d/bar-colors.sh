#!/bin/bash

rm -rf /tmp/swaybar/color-theme
mkdir -p /tmp/swaybar/color-theme
mkdir -p /tmp/swaybar/color-theme/{other,rgb,default,sway,my,silver}

#default
echo "#000000ff" > /tmp/swaybar/color-theme/default/background
echo "#ffffffff" > /tmp/swaybar/color-theme/default/statusline
echo "#666666ff" > /tmp/swaybar/color-theme/default/separator
echo "#000000ff" > /tmp/swaybar/color-theme/default/focused_background
echo "#ffffffff" > /tmp/swaybar/color-theme/default/focused_statusline
echo "#666666ff" > /tmp/swaybar/color-theme/default/focused_separator
echo "#4c7899ff" > /tmp/swaybar/color-theme/default/focused_workspace_border
echo "#285577ff" > /tmp/swaybar/color-theme/default/focused_workspace_bg
echo "#ffffffff" > /tmp/swaybar/color-theme/default/focused_workspace_text
echo "#333333ff" > /tmp/swaybar/color-theme/default/inactive_workspace_border
echo "#222222ff" > /tmp/swaybar/color-theme/default/inactive_workspace_bg
echo "#888888ff" > /tmp/swaybar/color-theme/default/inactive_workspace_text
echo "#333333ff" > /tmp/swaybar/color-theme/default/active_workspace_border
echo "#5f676aff" > /tmp/swaybar/color-theme/default/active_workspace_bg
echo "#ffffffff" > /tmp/swaybar/color-theme/default/active_workspace_text
echo "#2f343aff" > /tmp/swaybar/color-theme/default/urgent_workspace_border
echo "#900000ff" > /tmp/swaybar/color-theme/default/urgent_workspace_bg
echo "#ffffffff" > /tmp/swaybar/color-theme/default/urgent_workspace_text
echo "#2f343aff" > /tmp/swaybar/color-theme/default/binding_mode_border
echo "#900000ff" > /tmp/swaybar/color-theme/default/binding_mode_bg
echo "#ffffffff" > /tmp/swaybar/color-theme/default/binding_mode_text

#sway
echo "#323232ff" > /tmp/swaybar/color-theme/sway/background
echo "#ffffffff" > /tmp/swaybar/color-theme/sway/statusline
echo "#323232ff" > /tmp/swaybar/color-theme/sway/inactive_workspace_border
echo "#323232ff" > /tmp/swaybar/color-theme/sway/inactive_workspace_bg
echo "#5c5c5cff" > /tmp/swaybar/color-theme/sway/inactive_workspace_text

#my
echo "#323232ff" > /tmp/swaybar/color-theme/my/background
echo "#ffffffff" > /tmp/swaybar/color-theme/my/statusline

mkdir -p /tmp/swaybar/color-theme/my/body-bar-color
ln -s /tmp/swaybar/color-theme/my/background /tmp/swaybar/color-theme/my/body-bar-color/background
ln -s /tmp/swaybar/color-theme/my/statusline /tmp/swaybar/color-theme/my/body-bar-color/color
echo '#323232ff' > /tmp/swaybar/color-theme/my/body-bar-color/border

#silver
echo "#c0c0c0ff" > /tmp/swaybar/color-theme/silver/background
echo "#000000FF" > /tmp/swaybar/color-theme/silver/statusline

echo "#FF0000" > /tmp/swaybar/color-theme/rgb/red
echo "#00FF00" > /tmp/swaybar/color-theme/rgb/green
echo "#0000FF" > /tmp/swaybar/color-theme/rgb/blue

echo "#088F8F" > /tmp/swaybar/color-theme/other/group-color
echo "#E4D00A" > /tmp/swaybar/color-theme/other/log-color
#echo "#" > /tmp/swaybar/color-theme/other/text-color
#echo "#" > /tmp/swaybar/color-theme/other/active-color
#echo "#" > /tmp/swaybar/color-theme/other/inactive-color
#echo "#" > /tmp/swaybar/color-theme/other/focused-color
#echo "#" > /tmp/swaybar/color-theme/other/unfocused-color

color_n=$1
if [ ! $color_n ]; then
	color_n="my"
fi
rm -f /tmp/swaybar/color-theme/current
ln -s /tmp/swaybar/color-theme/$color_n /tmp/swaybar/color-theme/current

set_color() {
	for file in /tmp/swaybar/color-theme/current/*; do
		if [ -f $file ]; then
			swaymsg -q bar $1 colors ${file##*/} "$(cat $file)"
		fi
	done
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
		exit 1
	fi
fi

#echo "Use [$color_n] color theme for bar"
if [ ! $bar_name ]; then
	for i in $bar_names
	do
		set_color "$i"
	done
	# hidden bars : alpha=0
	for i in w_next w_prev w_by_name; do
		swaymsg bar $i colors focused_background "#00000000"
		swaymsg bar $i colors focused_statusline "#00000000"
		swaymsg bar $i colors focused_separator "#00000000"
	done
else
	set_color "$bar_name"
fi
