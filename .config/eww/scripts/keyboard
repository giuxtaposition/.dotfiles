#!/bin/sh

layout="$(swaymsg -t get_inputs | grep -E "\"$KEYBOARD_NAME\"" -A 12 | grep -oP '(?<=xkb_active_layout_name": ").*?(?=",)')"
status="$(swaymsg -t get_inputs | grep -E "\"$KEYBOARD_NAME\"" -A 15 | grep -oP '(?<=send_events": ").*?(?=")')"

toggle_keyboard() {
	swaymsg input "$KEYBOARD_NAME" events toggle enabled disabled
}

switch_layout() {
	swaymsg input "$KEYBOARD_NAME" xkb_switch_layout next
}

get_layout() {

	if [ "$layout" = "Italian" ]; then
		echo "it"
	elif [ "$layout" = "English (US)" ]; then
		echo "en"
	fi
}

get_status() {
	if [ "$status" = "enabled" ]; then
		echo "true"
	else
		echo "false"
	fi
}

[ "$1" = "layout" ] && get_layout && exit
[ "$1" = "status" ] && get_status && exit
[ "$1" = "switch_layout" ] && switch_layout && exit
[ "$1" = "toggle_keyboard" ] && toggle_keyboard && exit

exit
