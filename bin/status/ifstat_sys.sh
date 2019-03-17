#!/bin/bash
# Show if stats by sampling /sys/.
# Originally stolen from http://unix.stackexchange.com/questions/41346/upload-download-speed-in-tmux-status-line

sleeptime="0.5"
if ((0)); then
    iface="en0"
    type="⎆" # "☫" for wlan
    RXB=$(netstat -i -b | grep -m 1 $iface | awk '{print $7}')
    TXB=$(netstat -i -b | grep -m 1 $iface | awk '{print $10}')
    sleep "$sleeptime"
    RXBN=$(netstat -i -b | grep -m 1 $iface | awk '{print $7}')
    TXBN=$(netstat -i -b | grep -m 1 $iface | awk '{print $10}')
else
    iface=$(/bin/cat /proc/net/dev | /usr/bin/awk '{if($2>0 && NR > 2) print substr($1, 0, index($1, ":") - 1)}' | /bin/sed '/^lo$/d' | /bin/sed '/^docker0$/d')
    type=" " # "☫" for wlan
    RXB=$(</sys/class/net/"$iface"/statistics/rx_bytes)
    TXB=$(</sys/class/net/"$iface"/statistics/tx_bytes)
    sleep "$sleeptime"
    RXBN=$(</sys/class/net/"$iface"/statistics/rx_bytes)
    TXBN=$(</sys/class/net/"$iface"/statistics/tx_bytes)
fi
RXDIF=$(echo "$((RXBN - RXB)) / 1024 / ${sleeptime}" | bc)
TXDIF=$(echo "$((TXBN - TXB)) / 1024 / ${sleeptime}" | bc)

    RXDIF=$(echo "scale=1;${RXDIF} / 1024" | bc)
    RXDIF_UNIT="M/s"

    TXDIF=$(echo "scale=1;${TXDIF} / 1024" | bc)
    TXDIF_UNIT="M/s"

# NOTE: '%5.01' for fixed length always
printf "${type} ↓ %4.01f${RXDIF_UNIT} ↑%5.01f${TXDIF_UNIT}\n" ${RXDIF} ${TXDIF}
