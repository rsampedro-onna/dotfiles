#!/bin/bash
while [ "$select" != "NO" -a "$select" != "YES" ]; do
    select=$(echo -e 'NO\nYES' | dmenu -nb '#151515' -nf '#999999' -sb '#f00060' -sf '#000000' -fn 'System San Francisco Display 10' -i -p "You pressed the shutdown shortcut. Do you really want to shutdown the system?")
    [ -z "$select" ] && exit 0
done
[ "$select" = "NO" ] && exit 0
i3-msg exit
