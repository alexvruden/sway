#!/bin/bash

nap="$1"

count_workspace=1
all_workspaces=0
c_workspace=
for file in ${HOME}/.config/sway/workspaces.d/*; do
	wsp_name="$(cat $file | cut -d' ' -f3)"
	if [ $wsp_name ]; then
		c_workspace="$wsp_name $c_workspace"
		((all_workspaces++))
	fi
done
#cur_wspc_name="$(echo "$c_workspace" | cut -d' ' -f1)"

echo '{"version": 1,"click_events": true}'
echo '['
echo '[]'

while true;
do
    echo -n ',['
    echo -n '{'
    echo -n "\"name\":\"id_bar_$nap\","
	echo -n '"min_width": 5,'
    echo -n '"separator": false,'
    echo -n '"separator_block_width": 0,'
    echo -n '"border_top": 0,'
    echo -n '"border_bottom": 0,'
    echo -n '"border_left": 0,'
    echo -n '"border_right": 0,'
    echo -n '"color":"#00000000",'
	echo -n '"background":"#00000000",'
	#echo -n '"border":"#00000000",'
    echo -n '"align": "center",'
    echo -n '"full_text":" "'
    echo -n '}'
    echo -n ']'
    
	read -t 1 line
	case  $line  in
		*"id_bar_prev"*"event"*"272"*)
								swaymsg -q workspace prev 
								;;
		*"id_bar_next"*"event"*"272"*)
								swaymsg -q workspace next
								;;
		 *"id_bar_by_name"*"event"*"272"*)
	 							if [ $count_workspace -le $all_workspaces ]; then
									cur_wspc_name="$(echo "$c_workspace" | cut -d' ' -f$count_workspace)"
									if [ $cur_wspc_name ]; then
										swaymsg -q workspace $cur_wspc_name >/dev/null 2>&1
										((count_workspace++))
									fi
								else
									count_workspace=1
								fi
								;;
	esac
done
