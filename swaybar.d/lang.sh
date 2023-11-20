#!/bin/bash

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

w_icon=40
w_t=60
w_text=$(( $1 - $w_icon - $w_t ))

while true;
do
	ilang=$(swaymsg -p -t get_inputs | tail -n 32 | grep -m 1 'Active Keyboard Layout' | awk '{print $4}')

	echo -n ",["
	echo -n "{"
	echo -n "\"name\":\"id_lang\","
	echo -n "\"separator\":true,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_icon,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\":\"\""
	echo -n "}"

	echo -n ","
	
	echo -n "{"
	echo -n "\"name\":\"id_lang\","
	echo -n "\"separator\":false,"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $w_t,"
	echo -n "\"align\": \"left\","
	if [ "x${ilang}" = "xRussian" ]; then
		echo -n "\"full_text\":\" [RU]\""
	else
		echo -n "\"full_text\":\" [US]\""
	fi
	echo -n "}"

	echo -n ","

	echo -n "{"
	echo -n "\"name\":\"id_lang\","
	echo -n "\"min_width\": $w_text,"
	echo -n "\"full_text\":\" ${ilang}\","
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"align\": \"left\""
	echo -n "}"

	echo -n "]"

	sleep 1s

	read -t 1 line
	case  $line  in
		*"id_lang"*"event"*"272"*) 
									swaymsg -q input "49396:1216:SZH_usb_keyboard" xkb_switch_layout next 
									;;
	esac
done
