#!/bin/bash

set -a

idb="$1"
w_scratch=$2

echo '{"version": 1,"click_events": true}'

echo '['
echo '[]'

while true;
do
    echo -n ",["
    echo -n "{"
    if [ -e /tmp/swaybar/bar-$idb/full-text-color ]; then
        echo -n "\"color\":\"$(cat /tmp/swaybar/bar-$idb/full-text-color)\","
    fi
#    if [ -e /tmp/swaybar/bar-$idb/full-text-background-color ]; then
#        echo -n "\"background\":\"$(cat /tmp/swaybar/bar-$idb/full-text-background-color)\","
#    fi
    echo -n "\"name\":\"id_bar_$idb\","
    echo -n "\"separator\": false,"
    echo -n "\"separator_block_width\": 0,"
    echo -n "\"min_width\": $w_scratch,"
    echo -n "\"align\": \"left\","
    if [ -e /tmp/swaybar/bar-$idb/full-text ]; then
        echo -n "\"full_text\":\"$(cat /tmp/swaybar/bar-$idb/full-text)\""
    fi
    echo -n "}"

    echo "]"
    if [ -e /tmp/swaybar/bar-$idb/event-272 ]; then
        read -t 1 line
        case  $line  in
            *"id_bar_$idb"*"event"*"272"*)
                swaymsg -q exec "$(cat /tmp/swaybar/bar-$idb/event-272)"
				echo "off" > /tmp/swaybar/bar-task-manager/id_scratch_windows_status
				for (( i=1;i<=$(cat /tmp/swaybar/bar-task-manager/scratch_windows);i++ ))
				do 
					swaymsg -q bar scratch-window-$i hidden_state hide
				done
                ;;
        esac
    else
        sleep 1s
    fi
done
