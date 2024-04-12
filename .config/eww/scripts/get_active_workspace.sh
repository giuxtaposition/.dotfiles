#!/usr/bin/env bash

get_active() {
	active=$(swaymsg -t get_workspaces | jaq '.[] | select(.focused==true) | .name | tonumber')
	echo "$active"
}

swaymsg -t subscribe '["workspace"]' --monitor | {
	while read -r event; do
		get_active
	done
}
