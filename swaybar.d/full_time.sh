#!/bin/bash

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

while true;
do
	echo -n ",["

	echo -n "{"
	echo -n "\"separator_block_width\": 0,"
	echo -n "\"min_width\": $1,"
	echo -n "\"align\": \"center\","
	echo -n "\"full_text\":\"$(date +'%d %B [%m] %Y %H:%M [%Z: %:z] %A')\""
	echo -n "}"

	echo -n "]"

	sleep 1s
done
