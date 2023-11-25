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
        fi
        if [ -e /tmp/swaybar/bar-$idb/icon-background-color ]; then
            echo -n "\"background\":\"$(cat /tmp/swaybar/bar-$idb/icon-background-color)\","
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
    fi
    if [ -e /tmp/swaybar/bar-$idb/full-text-background-color ]; then
        echo -n "\"background\":\"$(cat /tmp/swaybar/bar-$idb/full-text-background-color)\","
    fi
    echo -n "\"name\":\"id_bar_$idb\","
    echo -n "\"separator\": false,"
    echo -n "\"separator_block_width\": 0,"
    if [ ! -e /tmp/swaybar/bar-$idb/icon ] || [ "$(cat /tmp/swaybar/bar-$idb/icon)" == "" ]; then
        echo -n "\"min_width\": $(( $SWB_TEXT_WIDTH + $SWB_ICON_WIDTH )),"
    else
        echo -n "\"min_width\": $SWB_TEXT_WIDTH,"
    fi
    if [ ! -e /tmp/swaybar/bar-$idb/icon ] || [ "$(cat /tmp/swaybar/bar-$idb/icon)" == "" ]; then
        echo -n "\"align\": \"center\","
    fi

    if [ -e /tmp/swaybar/bar-$idb/full-text ]; then
        echo -n "\"full_text\":\"$(cat /tmp/swaybar/bar-$idb/full-text)\""
    fi
    echo -n "}"

    echo -n "]"
    if [ -e /tmp/swaybar/bar-$idb/event-272 ] || [ -e /tmp/swaybar/bar-$idb/event-273 ] || [ -e /tmp/swaybar/bar-$idb/event-768 ] || [ -e /tmp/swaybar/bar-$idb/event-769 ]; then
        read -t 1 line
        case  $line  in
            *"id_bar_$idb"*"event"*"272"*)
                # mouse LBUTTON
                if [ -e /tmp/swaybar/bar-$idb/event-272 ]; then
                    swaymsg -q exec "$(cat /tmp/swaybar/bar-$idb/event-272)"
                fi
                ;;
            *"id_bar_$idb"*"event"*"273"*)
                # mouse RBUTTON
                if [ -e /tmp/swaybar/bar-$idb/event-273 ]; then
                    swaymsg -q exec "$(cat /tmp/swaybar/bar-$idb/event-273)"
                fi
                ;;
            *"id_bar_$id"*"event"*"768"*)
                # mouse WHEEL_UP
                if [ -e /tmp/swaybar/bar-$idb/event-768 ]; then
                    $(cat /tmp/swaybar/bar-$idb/event-768)
                fi
                ;;
            *"id_bar_$id"*"event"*"769"*)
                # mouse WHEEL_DOWN
                if [ -e /tmp/swaybar/bar-$idb/event-769 ]; then
                    $(cat /tmp/swaybar/bar-$idb/event-769)
                fi
                ;;
        esac
    else
        sleep 7d
    fi
done
