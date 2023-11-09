# sway
My sway config
<br><br>
<b>/etc/fstab</b>
<br>
<code>tmpfs /tmp tmpfs rw,nosuid,noatime,nodev,size=40G,mode=1777 0 0</code>
<br>
<br>
<b>~/.bash_login</b>
<code>
export XDG_RUNTIME_DIR=/tmp/1000-runtime-dir
if ! test -d "${XDG_RUNTIME_DIR}"; then
mkdir "${XDG_RUNTIME_DIR}"
chmod 700 "${XDG_RUNTIME_DIR}"
fi
export $(dbus-launch)
. ~/.config/sway/swaybar.d/icmp.sh &
. ~/.config/sway/swaybar.d/create_bar.sh &
sway --unsupported-gpu 2>/tmp/sway.log 1>&2
clear
exit
</code>
<br>
<br>
<b>Custom Swaybar. Manage bar without reload sway config. </b>
<br>

![Custom Swaybar](https://github.com/alexvruden/sway/blob/main/image1.png?raw=true)
