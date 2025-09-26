#!/bin/bash
ipconfig | tr -d '\r' | awk '
/Wireless LAN adapter Wi-Fi/ {flag=1}
flag && /^$/ {blank++}
flag {print}
blank==2 {flag=0}
' | awk -F: '/IPv4 Address/ {gsub(/ /,"",$2); print $2}'

