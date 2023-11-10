#!/bin/bash

while getopts b:ct:ci:t:i:e272:e273:e768:e769: flag
do
    case "${flag}" in
        b) bar=${OPTARG};;
        t) text=${OPTARG};;
        i) icon=${OPTARG};;
        ct) color_text=${OPTARG};;
        ci) color_icon=${OPTARG};;
        e272) event_272=${OPTARG};;
        e273) event_273=${OPTARG};;
        e768) event_768=${OPTARG};;
        e769) event_769=${OPTARG};;
    esac
done

if [ ! $bar ]; then bar=$(( $(cat /tmp/swaybar/idb) + 1 )); fi

if [ $icon ]; then echo "$icon" > /tmp/swaybar/bar-$bar/icon.insert; fi
if [ $color_icon ]; then echo "$color_icon" > /tmp/swaybar/bar-$bar/icon-color.insert; fi
if [ $color_text ]; then echo "$color_text" > /tmp/swaybar/bar-$bar/full-text-color.insert; fi
if [ $event_272 ]; then echo "$event_272" > /tmp/swaybar/bar-$bar/event-272.insert; fi
if [ $event_273 ]; then echo "$event_273" > /tmp/swaybar/bar-$bar/event-273.insert; fi
if [ $event_768 ]; then echo "$event_768" > /tmp/swaybar/bar-$bar/event-768.insert; fi
if [ $event_769 ]; then echo "$event_769" > /tmp/swaybar/bar-$bar/event-769.insert; fi

# last insert an go
if [ $text ]; then echo "$text" > /tmp/swaybar/bar-$bar/full-text.insert; fi
