#!/bin/bash

mkdir -p /tmp/swaybar

sway_bar_dir="${HOME}/.config/sway/swaybar.d/bar-0"

for file in $sway_bar_dir/*; do
  if [ -f "$file" ]; then
    . $file
  fi
done

#---------------------------------------------------------------
# launched in a background process

#header_json
 echo '{"version": 1,"click_events": true}'
 echo '['
 echo '[]'

while true;
do

#body_json_begin
 echo -n ",["

#---------------------------------------------------------------
scratch && comma

volume && comma
mem && comma
cpu && comma
vpn && comma
inet_speed && comma
lang && comma
clock && comma
window
#---------------------------------------------------------------

#body_json_end
 echo -n "]"

#---------------------------------------------------------------
# Real mode

read -t 1 line
#sleep 1
#---------------------------------------------------------------
# Debug mode

# read line
# echo $line > ${HOME}/.config/sway/click_events
### find codes run in tty: tail -f ${HOME}/.config/sway/click_events
#---------------------------------------------------------------

case  $line  in

 *"id_cpu"*"event"*"272"*) 
							swaymsg -q exec 'foot -a "cpu" htop' 
							;; #BTN_LEFT (272) pressed
 *"id_window"*"event"*"272"*) 
							for bar_id in $(cat /tmp/swaybar/idb)
							do 
								swaymsg -q bar $bar_id hidden_state show
							done
							;;
 *"id_window"*"event"*"273"*) 
							swaymsg -q bar hidden_state hide
							;;
 *"id_vpn"*"event"*"272"*) 
							swaymsg -q exec 'sudo rc-service openvpn start'
							;;
 *"id_vpn"*"event"*"273"*) 
							swaymsg -q exec 'sudo rc-service openvpn stop'
							;;
 *"id_volume"*"event"*"272"*) 
							echo "unmute" > $XDG_RUNTIME_DIR/_volume;
							amixer -Mq sset PCM 127
							;;
 *"id_volume"*"event"*"273"*) 
							echo "mute" > $XDG_RUNTIME_DIR/_volume;
							amixer -Mq set PCM 0%
							;;
 *"id_volume"*"button"*"4"*"event"*"768"*) 
							amixer -Mq set PCM 5%+
							;;  # WHEEL UP
 *"id_volume"*"button"*"5"*"event"*"769"*)
							amixer -Mq set PCM 5%-
							;;  # WHEEL DOWN

esac

done
