#!/bin/sh
#
# vnstat -i ffrl-a-ak-ber --add --setalias bb1
# vnstat -i ffrl-a-ix-dus --add --setalias bb2
# vnstat -i ffrl-b-ak-ber --add --setalias bb3
# vnstat -i ffrl-b-ix-dus --add --setalias bb4
# vnstat -i icVPN --add
# vnstat -i ggrzBAT --setalias intern
# vnstat -i eth0 --setalias server

set -e

##IFACES=("ffrl-a-ak-ber+ffrl-a-ix-dus+ffrl-b-ak-ber+ffrl-b-ix-dus" "icVPN" "ggrzBAT")
##IFTXT=("Backbone-Rheinland" "Intercity-VPN" "intern")
IFACES=("ffrl-a-ak-ber+ffrl-a-ix-dus+ffrl-b-ak-ber+ffrl-b-ix-dus" "eth0" "ggrzBAT")
IFTXT=("Backbone-Rheinland" "Server" "intern")

TARGET=/var/www/localhost/htdocs/vnstat/

for i in ${!IFACES[@]}; do
    /usr/bin/vnstati -i ${IFACES[$i]} --headertext "${IFTXT[$i]} (hourly)" -h -o ${TARGET}${IFACES[$i]}_hourly.png
    /usr/bin/vnstati -i ${IFACES[$i]} --headertext "${IFTXT[$i]} (daily)" -d -o ${TARGET}${IFACES[$i]}_daily.png
    /usr/bin/vnstati -i ${IFACES[$i]} --headertext "${IFTXT[$i]} (monthly)" -m -o ${TARGET}${IFACES[$i]}_monthly.png
    /usr/bin/vnstati -i ${IFACES[$i]} --headertext "${IFTXT[$i]} (Top10)" -t -o ${TARGET}${IFACES[$i]}_top10.png
    /usr/bin/vnstati -i ${IFACES[$i]} --headertext "${IFTXT[$i]} (Summary)" -s -o ${TARGET}${IFACES[$i]}_summary.png
done

cat > ${TARGET}index.html <<EOT
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <titleu1 - Network Traffic</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Language" content="en" />
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
</head>

<body style="white-space: nowrap">
EOT


for i in ${!IFACES[@]}; do
    sed s/IFACE/${IFACES[$i]}/g >> ${TARGET}index.html <<EOT
    <div style="display:inline-block;vertical-align: top">
    <img src="IFACE_summary.png" alt="traffic summary" /><br>
    <img src="IFACE_monthly.png" alt="traffic per month" /><br>
    <img src="IFACE_hourly.png" alt="traffic per hour" /><br>
    <img src="IFACE_top10.png" alt="traffic top10" /><br>
    <img src="IFACE_daily.png" alt="traffic per day" />
    </div>
EOT

done

echo "</body></html>" >> ${TARGET}index.html
