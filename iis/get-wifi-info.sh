#!/bin/bash
ipconfig | tr -d '\r' | awk '
/Wireless LAN adapter Wi-Fi/ {flag=1}
flag && /^$/ {blank++}
flag {print}
blank==2 {flag=0}
'

