#!/bin/bash

mkdir -p /tmp/swaybar
mkdir -p /tmp/swaybar/config.d

i=0

echo "bar {" > /tmp/swaybar/config.d/bar-$i.conf
echo "    id $i" >> /tmp/swaybar/config.d/bar-$i.conf
echo "    workspace_min_width 150 px" >> /tmp/swaybar/config.d/bar-$i.conf
echo "    height 30" >> /tmp/swaybar/config.d/bar-$i.conf
echo "    position top" >> /tmp/swaybar/config.d/bar-$i.conf
echo "    status_command \"${HOME}/.config/sway/swaybar.d/bar-0.sh\"" >> /tmp/swaybar/config.d/bar-$i.conf
echo "    colors {" >> /tmp/swaybar/config.d/bar-$i.conf
echo "      statusline #ffffff" >> /tmp/swaybar/config.d/bar-$i.conf
echo "      background #323232" >> /tmp/swaybar/config.d/bar-$i.conf
echo "      inactive_workspace #323232 #323232 #5c5c5c" >> /tmp/swaybar/config.d/bar-$i.conf
echo "    }" >> /tmp/swaybar/config.d/bar-$i.conf
echo "}" >> /tmp/swaybar/config.d/bar-$i.conf

echo "$(( 1400/30 ))" > /tmp/swaybar/idb_max

for (( i=1;i<=$(cat /tmp/swaybar/idb_max);i++ )); do
 echo "bar {" > /tmp/swaybar/config.d/bar-$i.conf
 echo "    id $i" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    workspace_buttons no" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    mode hide" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    modifier none" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    hidden_state hide" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    height 30" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    gaps 0 5 $(( 1400 - $i * 30 )) 2355" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    status_command \"${HOME}/.config/sway/swaybar.d/bar-x.sh $i\"" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    colors {" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "      statusline #ffffff" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "      background #323232" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "    }" >> /tmp/swaybar/config.d/bar-$i.conf
 echo "}" >> /tmp/swaybar/config.d/bar-$i.conf
 rm -rf /tmp/swaybar/bar-$i
 mkdir -p /tmp/swaybar/bar-$i
done

i=1
echo " -= Internet =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " Firefox" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "firefox" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " Torrent" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "transmission-daemon" > /tmp/swaybar/bar-$i/event-272
echo "pkill transmission-daemon" > /tmp/swaybar/bar-$i/event-273

((i++))
echo " -= Tools =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " Commander" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot -a 'commander' mc" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " Foot" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " -= Logs =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " syslog" > /tmp/swaybar/bar-$i/full-text
echo "#E4D00A" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot -a 'log' sudo tail -f /var/log/messages" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " openvpn" > /tmp/swaybar/bar-$i/full-text
echo "#E4D00A" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot -a 'log' tail -f /var/log/openvpn-client.log" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " -= System =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "i" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " Log Out" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "sway exit" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " Reboot" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
echo "foot sudo reboot" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " Poweroff" > /tmp/swaybar/bar-$i/full-text
echo "#FFFFFF" > /tmp/swaybar/bar-$i/full-text-color
echo "" > /tmp/swaybar/bar-$i/icon
echo "#FF0000" > /tmp/swaybar/bar-$i/icon-color
echo "foot sudo poweroff" > /tmp/swaybar/bar-$i/event-272

((i++))
echo " -= Tray =-" > /tmp/swaybar/bar-$i/full-text
echo "#088F8F" > /tmp/swaybar/bar-$i/full-text-color
#echo "i" > /tmp/swaybar/bar-$i/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$i/icon-color
#echo "" > /tmp/swaybar/bar-$i/event-272


echo "$i" > /tmp/swaybar/idb
