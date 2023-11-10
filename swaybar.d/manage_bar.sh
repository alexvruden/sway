#!/bin/bash

#set -a

while true;
do
    for (( i=1;i<=$(cat /tmp/swaybar/idb_max);i++ )); do
        cd /tmp/swaybar/bar-$i/
        if [ -e full-text.insert ]; then
            if [ -e full-text ]; then
                for file in *; do
                    name="${file%.*}";
                    ext="${file##*.}";
                    y=$(( ${i} + 1 ))
	            echo "${y}" > /tmp/swaybar/idb
                    mv -f ${name} /tmp/swaybar/bar-${y}/${name}.insert >/dev/null 2>&1;
                done
            fi
            for file in *; do
                name="${file%.*}";
                ext="${file##*.}";
                mv -f ${name}.insert ${name} >/dev/null 2>&1;
            done
    	    swaymsg bar hidden_state hide
    	    for (( i=1;i<=$(cat /tmp/swaybar/idb);i++ )); do
        	swaymsg bar $i hidden_state show
    	    done
        fi
    done
    sleep 1s
done
