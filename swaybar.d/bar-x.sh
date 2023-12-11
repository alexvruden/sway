#!/bin/bash

set -a

idb="$1"

SWB_ICON_WIDTH=40
SWB_TEXT_WIDTH=150

echo '{"version": 1,"click_events": true}'

echo '['
echo '[]'

while true;
do
    echo -n ",["
    if [ -e /tmp/swaybar/bar-$idb/icon ] && [ "$(cat /tmp/swaybar/bar-$idb/icon)" != "" ]; then
        echo -n "{"
        if [ -e /tmp/swaybar/bar-$idb/icon-color ]; then
            echo -n "\"color\":\"$(cat /tmp/swaybar/bar-$idb/icon-color)\","
        else
            echo -n "\"color\":\"$(cat /tmp/swaybar/color-theme/current/body-bar-color/color)\","
        fi
        
        if [ -e /tmp/swaybar/bar-$idb/icon-background-color ]; then
            echo -n "\"background\":\"$(cat /tmp/swaybar/bar-$idb/icon-background-color)\","
		else
			echo -n "\"background\":\"$(cat /tmp/swaybar/color-theme/current/body-bar-color/background)\","
        fi
        echo -n "\"separator\":true,"
        echo -n "\"separator_block_width\": 0,"
        echo -n "\"min_width\": $SWB_ICON_WIDTH,"
        echo -n "\"align\": \"center\","
        echo -n "\"full_text\":\"$(cat /tmp/swaybar/bar-$idb/icon)\""
        echo -n "}"
        echo -n ","
    fi
    echo -n "{"
    if [ -e /tmp/swaybar/bar-$idb/full-text-color ]; then
        echo -n "\"color\":\"$(cat /tmp/swaybar/bar-$idb/full-text-color)\","
	else
		echo -n "\"color\":\"$(cat /tmp/swaybar/color-theme/current/body-bar-color/color)\","
    fi
    if [ -e /tmp/swaybar/bar-$idb/full-text-background-color ]; then
        echo -n "\"background\":\"$(cat /tmp/swaybar/bar-$idb/full-text-background-color)\","
	else
		echo -n "\"background\":\"$(cat /tmp/swaybar/color-theme/current/body-bar-color/background)\","
    fi
    echo -n "\"name\":\"id_bar_$idb\","
    echo -n "\"separator\": false,"
    echo -n "\"separator_block_width\": 0,"
    if [ ! -f /tmp/swaybar/bar-$idb/icon ] || [ "$(cat /tmp/swaybar/bar-$idb/icon)" == "" ]; then
        echo -n "\"min_width\": $(( $SWB_TEXT_WIDTH + $SWB_ICON_WIDTH )),"
    else
        echo -n "\"min_width\": $SWB_TEXT_WIDTH,"
    fi
    if [ ! -f /tmp/swaybar/bar-$idb/icon ] || [ "$(cat /tmp/swaybar/bar-$idb/icon)" == "" ]; then
        echo -n "\"align\": \"center\","
    fi

    if [ -f /tmp/swaybar/bar-$idb/full-text ]; then
        echo -n "\"full_text\":\"$(cat /tmp/swaybar/bar-$idb/full-text)\""
    fi
    echo -n "}"

    echo -n "]"
    if [ -f /tmp/swaybar/bar-$idb/event-272 ] || [ -f /tmp/swaybar/bar-$idb/event-273 ] || [ -f /tmp/swaybar/bar-$idb/event-768 ] || [ -f /tmp/swaybar/bar-$idb/event-769 ]; then
        read -t 1 line
        case  $line  in
            *"id_bar_$idb"*"event"*"272"*)
                # mouse LBUTTON
                if [ -f /tmp/swaybar/bar-$idb/event-272 ]; then
					if [ -f /tmp/swaybar/bar-$idb/only-one-instance ]; then
						proc_name="$(cat /tmp/swaybar/bar-$idb/only-one-instance)"
						proc_exist="$(ps -C $proc_name -o pid=)"
						if [ ! $proc_exist ]; then
							swaymsg -q exec "$(cat /tmp/swaybar/bar-$idb/event-272)"
						fi
					else
						swaymsg -q exec "$(cat /tmp/swaybar/bar-$idb/event-272)"
					fi
                fi
                ;;
            *"id_bar_$idb"*"event"*"273"*)
                # mouse RBUTTON
                if [ -f /tmp/swaybar/bar-$idb/event-273 ]; then
                    swaymsg -q exec "$(cat /tmp/swaybar/bar-$idb/event-273)"
                fi
                ;;
            *"id_bar_$id"*"event"*"768"*)
                # mouse WHEEL_UP
                if [ -f /tmp/swaybar/bar-$idb/event-768 ]; then
                    $(cat /tmp/swaybar/bar-$idb/event-768)
                fi
                ;;
            *"id_bar_$id"*"event"*"769"*)
                # mouse WHEEL_DOWN
                if [ -f /tmp/swaybar/bar-$idb/event-769 ]; then
                    $(cat /tmp/swaybar/bar-$idb/event-769)
                fi
                ;;
        esac
    else
        sleep 1s
    fi
done
