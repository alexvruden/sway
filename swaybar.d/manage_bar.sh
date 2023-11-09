#!/bin/bash

set -a

while true;
do
 for (( i=1;1<=$(cat /tmp/swaybar/idb);i++ )); do
  if [ -e /tmp/swaybar/bar-$i/bar_shift ]; then
    rm -f /tmp/swaybar/bar-$i/bar_shift
    for file in /tmp/swaybar/bar-$i/*; do cp $file $file.shift; done

  fi
 done

done
