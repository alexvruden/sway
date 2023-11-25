#!/bin/bash

sc_width=$(swaymsg -p -t get_outputs | awk '/mode:/ {print $3}' | cut -dx -f1)
sc_heigth=$(swaymsg -p -t get_outputs | awk '/mode:/ {print $3}' | cut -dx -f2)


_bar() {
	swaymsg bar $1 mode hide
	swaymsg bar $1 gaps $b_top $b_right $b_bottom $b_left
	swaymsg bar $1 height $b_height
	swaymsg bar $1 hidden_state hide
	swaymsg bar $1 workspace_buttons no
	swaymsg bar $1 modifier none
	swaymsg bar $1 status_padding 0
	swaymsg bar $1 status_edge_padding 0
}

#-----------------------------------------------------------------------
#-----------------------------------------------------------------------------------
# invisible WORKSPACE PREV/NEXT

# NEXT (right)

b_width=5
b_top=0
b_bottom=30
b_height=$(( $sc_heigth - $b_bottom ))
b_right=0
b_left=$(( $sc_width - $b_width ))

i="w_next"

swaymsg bar $i mode hide
swaymsg bar $i gaps $b_top $b_right $b_bottom $b_left
swaymsg bar $i height $b_height
swaymsg bar $i hidden_state hide
swaymsg bar $i workspace_buttons no
swaymsg bar $i modifier none
swaymsg bar $i status_padding 0
swaymsg bar $i status_edge_padding 0
swaymsg bar $i hidden_state show
swaymsg bar $i colors focused_background "#00000000"
swaymsg bar $i colors focused_statusline "#00000000"
swaymsg bar $i colors focused_separator "#00000000"
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-i.sh next"

##PREV (left)
b_width=5
b_top=10
b_bottom=30
b_left=0
b_right=$(( $sc_width - $b_width ))
b_height=$(( $sc_heigth - $b_bottom - $b_top ))

i="w_prev"

swaymsg bar $i mode hide
swaymsg bar $i gaps $b_top $b_right $b_bottom $b_left
swaymsg bar $i height $b_height
swaymsg bar $i hidden_state hide
swaymsg bar $i workspace_buttons no
swaymsg bar $i modifier none
swaymsg bar $i status_padding 0
swaymsg bar $i status_edge_padding 0
swaymsg bar $i hidden_state show
swaymsg bar $i colors focused_background "#00000000"
swaymsg bar $i colors focused_statusline "#00000000"
swaymsg bar $i colors focused_separator "#00000000"
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-i.sh prev"

## by_name (top left) - choise empty workspace

b_height=5
b_width=5
b_top=0
b_bottom=$(( $sc_heigth - $b_height ))
b_left=0
b_right=$(( $sc_width - $b_width ))

i="w_by_name"

swaymsg bar $i mode hide
swaymsg bar $i gaps $b_top $b_right $b_bottom $b_left
swaymsg bar $i height $b_height
swaymsg bar $i hidden_state hide
swaymsg bar $i workspace_buttons no
swaymsg bar $i modifier none
swaymsg bar $i status_padding 0
swaymsg bar $i status_edge_padding 0
swaymsg bar $i hidden_state show
swaymsg bar $i colors focused_background "#00000000"
swaymsg bar $i colors focused_statusline "#00000000"
swaymsg bar $i colors focused_separator "#00000000"
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-i.sh by_name"

#-----------------------------------------------------------------------
#-----------------------------------------------------------------------------------
# MENU START

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

i="swaylog"
b_list="$i $b_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/bar-x.sh $i"
echo " swaylog" > /tmp/swaybar/bar-$i/full-text
echo "#E4D00A" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot -a 'log' tail -f /tmp/sway.log" > /tmp/swaybar/bar-$i/event-272

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

echo "$b_list" > /tmp/swaybar/id_menu_start

#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
# MENU LAN

b_sys_tray_lan_list=
b_height=30
b_width=500

b_bottom=5
b_right=5
b_left=$(( $sc_width - $b_width - $b_right ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))

i="sys-tray-inet"
b_sys_tray_lan_list="$i $b_sys_tray_lan_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/inet.sh $b_width enp4s0"

i="sys-tray-vpn"
b_sys_tray_lan_list="$i $b_sys_tray_lan_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/inet.sh $b_width tun0"

i="sys-tray-wlan"
b_sys_tray_lan_list="$i $b_sys_tray_lan_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/inet.sh $b_width wlan0"

echo "$b_sys_tray_lan_list" > /tmp/swaybar/id_menu_lan

#-----------------------------------------------------------------------------------
# MENU TRAY

b_sys_tray_list=
b_height=30
b_width=200

b_bottom=5
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

i="sys-tray-lang"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/lang.sh $b_width"

i="sys-tray-audio"
b_sys_tray_list="$i $b_sys_tray_list"
b_bottom=$(( $b_bottom + $b_height ))
b_top=$(( $sc_heigth - $b_bottom - $b_height - 30 ))
rm -rf /tmp/swaybar/bar-$i
mkdir -p /tmp/swaybar/bar-$i
_bar $i
swaymsg bar $i status_command "${HOME}/.config/sway/swaybar.d/audio.sh $b_width"

echo "$b_sys_tray_list" > /tmp/swaybar/id_menu_tray

#-----------------------------------------------------------------------------------
# MENU DATE
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


~/.config/sway/swaybar.d/bar-colors.sh "my-colors" >/dev/null 2>&1
