#!/bin/bash

set -a

help() {
	echo "Insert:"
	echo "~/$0 --bar 4 --text <name_my_program> --icon <my_icon> --e272 <comand_for_left_button_mouse_click>"
	echo "Add:"
	echo "$0 --text <name_my_program> --icon <my_icon> --e272 <comand_for_left_button_mouse_click>"
	echo "Add separator:"
	echo "$0 --text <name_separator>"
	echo "Store bar:"
	echo "$0 -s"
	echo "Restore bar:"
	echo "$0 -r"
}


f_refresh_bar() {
    swaymsg -q bar hidden_state hide
    for (( i=1;i<=$(cat /tmp/swaybar/idb);i++ )); do
       swaymsg -q bar $i hidden_state show
    done
}

f_store_bar() {
    mkdir -p ${HOME}/.config/sway/swaybar.d/store
    rm -rfd ${HOME}/.config/sway/swaybar.d/store/*
    for (( i=1;i<=$(cat /tmp/swaybar/idb);i++ )); do
	if [ -e /tmp/swaybar/bar-$i/pid-file ]; then
	  echo "$(( ${i} - 1 ))" >/tmp/swaybar/idb
	  break
	fi
        cp -r /tmp/swaybar/bar-$i ${HOME}/.config/sway/swaybar.d/store/
    done
    cp -r /tmp/swaybar/idb ${HOME}/.config/sway/swaybar.d/store/
}

f_restore_bar() {
    for (( i=1;i<=$(cat ${HOME}/.config/sway/swaybar.d/store/idb);i++ )); do
       rm -f /tmp/swaybar/bar-$i/*
       cp -r ${HOME}/.config/sway/swaybar.d/store/bar-$i /tmp/swaybar/
    done
    cp -r ${HOME}/.config/sway/swaybar.d/store/idb /tmp/swaybar/
    f_refresh_bar
}

ff_get_id_bar() {
    xid_b=
    for (( i=1;i<=$(cat /tmp/swaybar/idb);i++ )); do
	if [ "$(cat /tmp/swaybar/bar-$i/full-text)" = "$1" ]; then
	    xid_b=$i
	    break
	fi
    done
    if [ "[$xid_b]" = "[]" ]; then
	return 255
    else
	return $xid_b
    fi
}

f_get_id_bar() {
   f_id_b=
  ff_get_id_bar "$1"
   f_id_b=$?

   if [ $f_id_b -ne 255 ] && [ ! $silent ]; then
     echo "[i] name='$1', id=$f_id_b"
   fi
   return $f_id_b
}

delete_bar() {
   ff_get_id_bar "$1"
   f_id=$?
   if [ $f_id -ne 255 ]; then
      swaymsg -q bar hidden_state hide
      rm -f /tmp/swaybar/bar-$f_id/*
      while true; do
        y=$(( ${f_id} + 1 ))
        if [ -e /tmp/swaybar/bar-${y}/full-text ]; then
	  mv /tmp/swaybar/bar-${y}/* /tmp/swaybar/bar-${f_id}/
	  f_id=${y}
	else
          z=$(( ${f_id} - 1 ))
	  echo "${z}" > /tmp/swaybar/idb
          break
 	fi
      done
   fi
   f_refresh_bar
}

main() {
  if [ "$t_icon" ]; then echo "$t_icon" > /tmp/swaybar/bar-$1/icon$2; fi
  if [ "$color_icon" ]; then echo "$color_icon" > /tmp/swaybar/bar-$1/icon-color$2; fi
  if [ "$color_text" ]; then echo "$color_text" > /tmp/swaybar/bar-$1/full-text-color$2; fi
  if [ "$event_272" ]; then echo "$event_272" > /tmp/swaybar/bar-$1/event-272$2; fi
  if [ "$event_273" ]; then echo "$event_273" > /tmp/swaybar/bar-$1/event-273$2; fi
  if [ "$event_768" ]; then echo "$event_768" > /tmp/swaybar/bar-$1/event-768$2; fi
  if [ "$event_769" ]; then echo "$event_769" > /tmp/swaybar/bar-$1/event-769$2; fi

  if [ "$f_text" ]; then echo "$f_text" > /tmp/swaybar/bar-$1/full-text$2 || return 255; fi

  if [ $2 ]; then
    for (( i=$1;i<=$(cat /tmp/swaybar/idb_max);i++ )); do
        cd /tmp/swaybar/bar-$i/
        if [ -e full-text.insert ]; then
            if [ -e full-text ]; then
                for file in *; do
                    name="${file%.*}";
                    ext="${file##*.}";
                    y=$(( ${i} + 1 ))
                    mv -f ${name} /tmp/swaybar/bar-${y}/${name}.insert >/dev/null 2>&1;
                done
            fi
            for file in *; do
                name="${file%.*}";
                ext="${file##*.}";
                mv -f ${name}.insert ${name} >/dev/null 2>&1;
            done
#        else
#	  break
        fi
    done
  fi
}

#-----

if ! options=$(getopt -o qhsr -l help,store,restore,refresh,rename:,get_id:,delete:,bar:,after:,ct:,ci:,text:,icon:,e272:,e273:,e768:,e769: -- "$@" 2>/dev/null); then
    echo "$0: error - unrecognized param" 1>&2
    exit 1
fi

eval set -- $options
while [ $# -gt 0 ]; do
    case $1 in
        --bar)
		id_bar="$2"; shift;;
        --after)
		after_bar="$2"; shift;;
        --text)
		f_text="$2"; shift;;
        --icon)
		t_icon="$2"; shift;;
        --ct)
		color_text="$2"; shift;;
        --ci)
		color_icon="$2"; shift;;
        --e272)
		event_272="$2"; shift;;
        --e273)
		event_273="$2"; shift;;
        --e768)
		event_768="$2"; shift;;
        --e769)
		event_769="$2"; shift;;
        -h|--help)
		help; exit;;
        -s|--store)
		f_store_bar; exit;;
        -r|--restore)
		f_restore_bar; exit;;
        -q)
		silent="y";;
        --get_id)
		f_get_id_bar "$2"; exit;;
        --refresh)
		f_refresh_bar; exit;;
        --rename)
		rename_bar="$2"; shift;;
        --delete)
		delete_bar "$2"; exit;;
        (--)
            shift; break;;
        (-*)
            echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
        (*)
            break;;
    esac
    shift
done

ext=".insert"
id_temp=$(cat /tmp/swaybar/idb)

if [ ! "$id_bar" ]; then
# add to end
  bar=$(( $(cat /tmp/swaybar/idb) + 1 ))
  ext=""
  id_temp=$(( $(cat /tmp/swaybar/idb) + 1 ))
fi

if [ "$rename_bar" ]; then
   ff_get_id_bar "$rename_bar"
   f_id=$?
   if [ $f_id ]; then
     ext=""
     swaymsg bar hidden_state hide
     main "$f_id" "$ext"
     rc=$?
     if [ $? -ne 255 ]; then echo "$id_temp" > /tmp/swaybar/idb; fi
  fi
  f_refresh_bar
  exit $rc
fi

if [ "$after_bar" ]; then
    for (( i=1;i<=$(cat /tmp/swaybar/idb);i++ )); do
	if [ "x$(cat /tmp/swaybar/bar-$i/full-text)" = "x$after_bar" ]; then
	    bar=$(( $i + 1 ))
	    b_found=y
	    ext=".insert"
	    id_temp=$(( $(cat /tmp/swaybar/idb) + 1 ))
	    break
	fi
    done
    if [ ! ${b_found} ]; then
      exit 255
    fi
fi

if [ "$f_text" ]; then
  swaymsg bar hidden_state hide
  main "$bar" "$ext"
  rc=$?
  if [ $? -ne 255 ]; then echo "$id_temp" > /tmp/swaybar/idb; fi
  f_refresh_bar
  exit $rc
fi
