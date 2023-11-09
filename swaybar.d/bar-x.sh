#!/bin/bash

set -a

#mkdir -p /tmp/swaybar
#rm -rf /tmp/swaybar/bar-$1
#mkdir -p /tmp/swaybar/bar-$1

idb=$1

#echo "$(echo "$2" | cut -d: -f1)" > /tmp/swaybar/bar-$idb/icon
#echo "$(echo "$2" | cut -d: -f2)" > /tmp/swaybar/bar-$idb/icon-text-color

#echo "" > /tmp/swaybar/bar-$idb/icon
#echo "#FFFFFF" > /tmp/swaybar/bar-$idb/icon-color
#echo "#323232" > /tmp/swaybar/bar-$idb/icon-background-color

#echo "$(echo "$3" | cut -d: -f1)" > /tmp/swaybar/bar-$idb/full-text
#echo "$(echo "$3" | cut -d: -f2)" > /tmp/swaybar/bar-$idb/full-text-color
#echo "" > /tmp/swaybar/bar-$idb/full-text
#echo "#FFFFFF" > /tmp/swaybar/bar-$idb/full-text-color
#echo "#323232" > /tmp/swaybar/bar-$idb/full-text-background-color

#SWB_ICON_WIDTH=$(echo "$4" | cut -d: -f1)
#SWB_TEXT_WIDTH=$(echo "$4" | cut -d: -f2)
SWB_ICON_WIDTH=40
SWB_TEXT_WIDTH=150

#events_shell=$5

#if [ "$(echo "$events_shell" | cut -d: -f1)" != "" ]; then
#    echo "$(echo "$events_shell" | cut -d: -f1)" > /tmp/swaybar/bar-$idb/event-272
#else
#    rm -f /tmp/swaybar/bar-$idb/event-272
#fi
#if [ "$(echo "$events_shell" | cut -d: -f2)" != "" ]; then
#    echo "$(echo "$events_shell" | cut -d: -f2)" > /tmp/swaybar/bar-$idb/event-273
#else
#    rm -f /tmp/swaybar/bar-$idb/event-273
#fi
#if [ "$(echo "$events_shell" | cut -d: -f3)" != "" ]; then
#    echo "$(echo "$events_shell" | cut -d: -f3)" > /tmp/swaybar/bar-$idb/event-768
#else
#    rm -f /tmp/swaybar/bar-$idb/event-768
#fi
#if [ "$(echo "$events_shell" | cut -d: -f4)" != "" ]; then
#    echo "$(echo "$events_shell" | cut -d: -f4)" > /tmp/swaybar/bar-$idb/event-769
#else
#    rm -f /tmp/swaybar/bar-$idb/event-769
#fi

#if [ -e /tmp/swaybar/bar-$idb/event-272 ] || [ -e /tmp/swaybar/bar-$idb/event-273 ] || [ -e /tmp/swaybar/bar-$idb/event-768 ] || [ -e /tmp/swaybar/bar-$idb/event-769 ]; then
    echo '{"version": 1,"click_events": true}'
#else
#    echo '{"version": 1,"click_events": false}'
#fi

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

    echo "]"
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
        sleep 1s
    fi
done
