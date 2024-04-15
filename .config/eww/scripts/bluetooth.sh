#!/bin/sh

powered="$(bluetoothctl show | rg Powered | cut -f 2- -d ' ')"
status="$(bluetoothctl info)"
name="$(echo "$status" | rg Name | cut -f 2- -d ' ')"
battery="$(echo "$status" | rg Percentage)"

icon() {
	if [ "$powered" = "yes" ]; then
		if [ "$status" != "Missing device address argument" ]; then
			icon="󰂱"
		else
			icon="󰂯"
		fi
	else
		icon="󰂲"
	fi

	echo "$icon"
}

connected_device() {
	if [ "$battery" != "" ]; then
		tooltip="Connected to $name, 󰥈: $battery"
	elif [ "$name" != "" ]; then
		tooltip="Connected to $name"
	fi

	echo "$tooltip"
}

[ "$1" = "icon" ] && icon && exit
[ "$1" = "connected_device" ] && connected_device && exit
[ "$1" = "blueman-manager" ] && blueman-manager && exit
exit
