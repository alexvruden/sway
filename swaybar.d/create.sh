#!/bin/bash

#log="/tmp/start.log"
log="/dev/null"
echo " $0 : Start" >>$log

sc_width=$(swaymsg -p -t get_outputs | awk '/mode:/ {print $3}' | cut -dx -f1)
sc_heigth=$(swaymsg -p -t get_outputs | awk '/mode:/ {print $3}' | cut -dx -f2)

b_height=30

#i="task-manager"

#echo "bar {" > /tmp/swaybar/config.d/bar-$i.conf
#echo "    id $i" >> /tmp/swaybar/config.d/bar-$i.conf
#echo "    workspace_buttons no" >> /tmp/swaybar/config.d/bar-$i.conf
#echo "    height $b_height" >> /tmp/swaybar/config.d/bar-$i.conf
#echo "    status_padding 0" >> /tmp/swaybar/config.d/bar-$i.conf
#echo "    status_edge_padding 0" >> /tmp/swaybar/config.d/bar-$i.conf
#echo "    position bottom" >> /tmp/swaybar/config.d/bar-$i.conf
#echo "    status_command \"${HOME}/.config/sway/swaybar.d/start.sh\"" >> /tmp/swaybar/config.d/bar-$i.conf
#echo "}" >> /tmp/swaybar/config.d/bar-$i.conf

#if [ -e ~/.config/sway/swaybar.d/store/idb ]; then
#	~/.config/sway/swaybar.d/manage_bar.sh -r
#	exit 1
#fi

_bar() {
	swaymsg bar $1 mode hide
	swaymsg bar $1 hidden_state hide
	swaymsg bar $1 workspace_buttons no
	swaymsg bar $1 modifier none
	swaymsg bar $1 height $b_height
	swaymsg bar $1 gaps $b_top $b_right $b_bottom $b_left
	swaymsg bar $1 status_padding 0
	swaymsg bar $1 status_edge_padding 0
}

#-----------------------------------------------------------------------

b_list=

b_height=30
b_width=200

#b_bottom=$(( $b_height + 5 ))

b_bottom=5
#b_top=0
b_left=5
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
b_right=$(( $sc_width - $b_width + $b_left ))

#-----------------------------------------------------------------------
i="logout"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Log Out" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "sway exit" > /tmp/swaybar/bar-$i/event-272

i="reboot"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Reboot" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot sudo reboot" > /tmp/swaybar/bar-$i/event-272

i="poweroff"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Poweroff" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FF0000" > /tmp/swaybar/bar-$i/icon-color
echo "foot sudo poweroff" > /tmp/swaybar/bar-$i/event-272

i="group-system"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo "-= System =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "i" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

#-----------------------------------------------------------------------

i="firefox"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Firefox" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "firefox" > /tmp/swaybar/bar-$i/event-272

i="torrent"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Torrent" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "transmission-daemon" > /tmp/swaybar/bar-$i/event-272
echo "transmission-remote --exit" > /tmp/swaybar/bar-$i/event-273

i="group-internet"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo "-= Internet =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

#-----------------------------------------------------------------------

i="commander"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Commander" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot -a 'commander' mc" > /tmp/swaybar/bar-$i/event-272

i="bash"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Foot" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot" > /tmp/swaybar/bar-$i/event-272

i="geany"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " Geany" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "geany" > /tmp/swaybar/bar-$i/event-272

i="group-tools"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo "-= Tools =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

#-----------------------------------------------------------------------

i="syslog"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " syslog" > /tmp/swaybar/bar-$i/full-text
echo "#E4D00A" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot -a 'log' sudo tail -f /var/log/messages" > /tmp/swaybar/bar-$i/event-272

i="openvpn"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " openvpn" > /tmp/swaybar/bar-$i/full-text
echo "#E4D00A" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot -a 'log' tail -f /var/log/openvpn-client.log" > /tmp/swaybar/bar-$i/event-272

i="group-logs"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo "-= Logs =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

#-----------------------------------------------------------------------

echo "$b_list" > /tmp/swaybar/idb

#------------

b_sys_tray_list=
b_height=30
b_width=400

#b_bottom=$(( $b_height + 5 ))

b_bottom=5
#b_top=0
b_right=5
b_left=$(( $sc_width - $b_width - $b_right ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))

i="sys-tray-cpu"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/cpu.sh $b_width"

i="sys-tray-mem"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/mem.sh $b_width"

i="sys-tray-inet"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/inet.sh $b_width"

i="sys-tray-lang"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/lang.sh $b_width"

i="sys-tray-vpn"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/vpn.sh $b_width"

i="sys-tray-audio"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/audio.sh $b_width"

i="sys-tray-clock-full"

b_height=30
b_width=500
#b_top=0
b_right=5
b_left=$(( $sc_width - $b_width - $b_right ))
b_bottom=$(( 5 + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))

rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/full_time.sh 500"

echo "$b_sys_tray_list" > /tmp/swaybar/idb_sys_tray

echo " $0 : goto bar-colors.sh" >>$log
~/.config/sway/swaybar.d/bar-colors.sh "my-colors" >/dev/null 2>&1
echo " $0 : end" >>$log
