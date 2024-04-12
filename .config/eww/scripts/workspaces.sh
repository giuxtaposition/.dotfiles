#!/usr/bin/env bash

get_workspace_info() {
	focused=$(swaymsg -t get_workspaces | jaq -r '.[] | select(.focused==true).name')
	not_empty=$(swaymsg -t get_workspaces | jaq -r '.[] | {name}')

	echo -n '['

	for i in {1..10}; do
		if [[ $focused = "$i" ]]; then
			status=2
		elif grep -q "\"name\": \"$i\"" <<<"$not_empty"; then
			status=1
		else
			status=0
		fi

		echo -n ''"$([ "$i" -eq 1 ] || echo ,)" '{"name": '"$i"', "focused": '"$([ "$focused" = "$i" ] && echo "true" || echo "false")"', "status": '"$status"'}'
	done

	echo ' ]'
}

get_workspace_info

swaymsg -t subscribe '["workspace"]' --monitor | {
	while read -r event; do
		get_workspace_info
	done
}
