#!/bin/sh

get_data() {
	volume="$(pamixer --default-source --get-volume-human | grep -Po '\d+(?=%)')"

	if [ "$volume" = "" ]; then
		icon="󰍭"
		volume="0"
	else
		icon="󰍬"
	fi

	echo "{\"content\": \"$volume\", \"icon\": \"$icon\"}"
}

[ "$1" = "" ] && get_data && exit
[ "$1" = "toggle" ] && (pamixer --default-source -t) && exit
exit
