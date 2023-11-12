#!/bin/bash

set -a

name_scrath_separator="--Scratch--"

while true; do

  swaymsg -p -t get_tree >/tmp/get_tree
  id="$(cat /tmp/get_tree | tr -d '\n')"
# cut scratch
  id="${id#*scratch}"
  id="${id%output*}"

 pid_prev=0

while true; do
# find first item
  name_w="$(echo "${id}" | tr -d '\"\(\)\r\t\v\n')"

  id="${id#*pid:}"
  pid=$(echo "${id}" | cut -d, -f1 | tr -d ' ')

  if [ "${pid}" = "${pid_prev}" ]; then break; fi

  pid_prev=${pid}
  test_str=$(echo "${id}" | awk -F ' ' '{print $2}')
  if [ "${test_str}" != "app_id:" ]; then break; fi
  app_id=$(echo "${id}" | awk -F'"' '{print $2}')

# todo
  name_w="${name_w#*con}"
  len_1_name=${#name_w}
  name_w_t="${name_w#*xdg_shell, pid: $pid, app_id: $app_id}"
  var_name="xdg_shell, pid: $pid, app_id: $app_id"
  len_2_name=${#name_w_t}
  len_var_name=${#var_name}
  len_name=$(( $len_1_name - $len_2_name - $len_var_name ))
  names=$(echo "$name_w" | cut -c-$len_name)

  ~/.config/sway/swaybar.d/manage_bar.sh -q --get_id "${app_id}[${pid}]"
  id_bar=$?

  if [ $id_bar -eq 255 ]; then
      ~/.config/sway/swaybar.d/manage_bar.sh --after "$name_scrath_separator" --text "${app_id}[${pid}]"
      if [ $? -ne 0 ]; then break; fi
      ~/.config/sway/swaybar.d/manage_bar.sh -q --get_id "${app_id}[${pid}]"
      id_bar=$?
      if [ $id_bar -eq 255 ]; then break; fi

      echo "${pid}" >/tmp/swaybar/bar-${id_bar}/pid-file
      event_272="sway [pid=\"${pid}\"] focus & . ~/.config/sway/swaybar.d/manage_bar.sh --delete \"${app_id}[${pid}]\" "
      echo "$event_272" > /tmp/swaybar/bar-${id_bar}/event-272
      about=$(cat /tmp/get_tree | grep "pid: ${pid}")
      echo "${names}" > /tmp/swaybar/bar-${id_bar}/about_bar
  fi

done

sleep 5s
done

