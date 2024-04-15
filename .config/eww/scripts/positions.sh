#!/usr/bin/env bash

playerctl metadata -F -f '{{position}} {{mpris:length}}' | while read -r line; do
	position=$(playerctl metadata -f "{{position / 1000000}}")
	position=$(echo "($position + 0.5) / 1" | bc)
	echo "$position"
	positionStr=$(playerctl metadata -f "{{duration(position)}}")
	player=$(playerctl metadata -f "{{playerName}}")

	JSON_STRING=$(jaq -n \
		--arg position "$position" \
		--arg positionStr "$positionStr" \
		--arg player "$player" \
		"{$player: {position: \"$position\", positionStr: \"$positionStr\"}}")
	echo $JSON_STRING

done
