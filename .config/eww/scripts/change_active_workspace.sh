#!/usr/bin/env bash

direction=$1
current=$2

if [[ $direction == "down" ]]; then
	target=$((current + 1))
	if [[ $target == 11 ]]; then
		target=1
	fi
	swaymsg workspace "$target"
elif [[ $direction == "up" ]]; then
	target=$((current - 1))
	if [[ $target == 0 ]]; then
		target=10
	fi
	swaymsg workspace "$target"
fi
