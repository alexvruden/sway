#!/bin/bash

#p="$1"
#s="$2"
s=1
ovpn_str=
echo "wait" > /tmp/swaybar/bar-task-manager/tun0_status

echo "Choise OVPN:" >/tmp/ovpn
for file in ~/.config/openvpn/*.ovpn; do
	if [ -f $file ]; then
		ovpn_str="${ovpn_str} $file"
		echo "$s. $file" >>/tmp/ovpn
		((s++))
	fi
done

for folder in `ls ~/.config/openvpn/ | tr -s '\n' ' '`; do
	if [ -d ~/.config/openvpn/${folder} ]; then
		for file in ~/.config/openvpn/${folder}/*.ovpn; do
			if [ -f $file ]; then
				ovpn_str="${ovpn_str} $file"
				echo "$s. ${folder}/${file##*/}" >>/tmp/ovpn
				((s++))
			fi
		done
	fi
done
echo "" >>/tmp/ovpn

cat /tmp/ovpn
read -p "[?]: " line
if [ ! $line ]; then 
	echo "down" > /tmp/swaybar/bar-task-manager/tun0_status
	exit 1
fi
c=$(( $line + 1 ))
govpn="$(echo "${ovpn_str}" | cut -d' ' -f$c)"
if [ ! $govpn ]; then
	echo "down" > /tmp/swaybar/bar-task-manager/tun0_status
	exit 1
fi
if [ ! -f $govpn ]; then
	echo "down" > /tmp/swaybar/bar-task-manager/tun0_status
	exit 1
fi
p=$govpn

p1=${p%/*}
n=${p##*/}

if [ -f ${p1}/auth ]; then 
	exist_usname="$(cat ${p1}/auth | tr -s '\n' ' ' | cut -d' ' -f1)"
	exist_upass="$(cat ${p1}/auth | tr -s '\n' ' ' | cut -d' ' -f2)"
fi

echo ""
echo "Enter UserName and Password, or empty:"
read -p "UserName [$exist_usname]: " usnam
read -p "Password [$exist_upass]: " upass
if [ $usnam ]; then 
	echo "$usnam" > /tmp/auth 
else
	echo "$exist_usname" > /tmp/auth 
fi
if [ $upass ]; then
	echo "$upass" >>/tmp/auth
else
	echo "$exist_upass" >>/tmp/auth
fi

cp $p $p.edited
echo "" >> $p.edited
if [ -f /tmp/auth ]; then
	len="$(cat /tmp/auth)"
	len=${#len}
fi

if [ $len ] && [ $len -ne 0 ]; then
	echo "auth-user-pass ${p1}/auth" >> $p.edited
	cp /tmp/auth ${p1}/auth >/dev/null 2>&1
fi
echo "log /tmp/openvpn-client.log" >> $p.edited

if [ -L /etc/openvpn/$n.conf ]; then
	sudo rm -f /etc/openvpn/$n.conf
fi

if [ ! -L /etc/openvpn/$n.conf ]; then
	sudo ln -s $p.edited /etc/openvpn/$n.conf
fi

sudo rm -f /etc/init.d/openvpn.*

if [ -L /etc/openvpn/$n.conf ]; then
	sudo ln -s /etc/init.d/openvpn /etc/init.d/openvpn.$n >/dev/null 2>&1
	sudo /etc/init.d/openvpn.$n start
fi
#sudo tail -f /tmp/openvpn-client.log
