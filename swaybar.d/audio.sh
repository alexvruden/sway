#!/bin/bash


echo "mute" > /tmp/swaybar/bar-task-manager/_volume
amixer -Mq set PCM 0% >/dev/null 2>&1

w_icon=40
w_text=$(( $1 - $w_icon ))

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

while true;
do

	echo -n ",["
	
	echo -n "{"
	echo -n "\"name\":\"id_volume\","
    echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_icon,"
	echo -n "\"align\": \"center\","
	if [ -e /tmp/swaybar/bar-task-manager/_volume ] && [ "x$(cat /tmp/swaybar/bar-task-manager/_volume)" = "xmute" ]; then
		echo -n "\"full_text\":\"\""
	elif [ -e /tmp/swaybar/bar-task-manager/_volume ] && [ "x$(cat /tmp/swaybar/bar-task-manager/_volume)" = "xunmute" ]; then
		echo -n "\"full_text\":\"\""
	else
		echo -n "\"full_text\":\"\""
		echo "mute" > /tmp/swaybar/bar-task-manager/_volume
		amixer -Mq set PCM 0% >/dev/null 2>&1
	fi
	echo -n "}"

	echo -n ","

	echo -n "{"
	echo -n "\"name\":\"id_volume\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"separator\": false,"
	echo -n "\"min_width\": $w_text,"
	echo -n "\"align\": \"left\","
	
	vol=$(amixer sget PCM | awk -F"[][]" '/Left:/ { print $2 }')
	echo -n "\"full_text\":\" ${vol}\""
	echo -n "}"

	echo -n "]"

	read -t 1 line
	case  $line  in
		 *"id_volume"*"event"*"272"*) 
									if [ -e /tmp/swaybar/bar-task-manager/_volume ] && [ "$(cat /tmp/swaybar/bar-task-manager/_volume)" = "mute" ]; then
										echo "unmute" > /tmp/swaybar/bar-task-manager/_volume
										amixer -Mq sset PCM 127
									else
										echo "mute" > /tmp/swaybar/bar-task-manager/_volume
										amixer -Mq set PCM 0%
									fi
									;;
#		 *"id_volume"*"event"*"273"*) 
#									echo "mute" > /tmp/swaybar/bar-task-manager/_volume
#									amixer -Mq set PCM 0%
#									;;
		 *"id_volume"*"button"*"4"*"event"*"768"*) 
									amixer -Mq set PCM 5%+
									;;  # WHEEL UP
		 *"id_volume"*"button"*"5"*"event"*"769"*)
									amixer -Mq set PCM 5%-
									;;  # WHEEL DOWN
	esac
done


