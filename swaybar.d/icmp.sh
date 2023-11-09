while true;
do
    st="off"
    ping -c 1 8.8.8.8 >/dev/null 2>&1
    if [ $? -eq 0 ]; then st="on"; fi
    echo $st > /tmp/icmp
    sleep 10s
done