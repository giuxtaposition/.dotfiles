#!/usr/bin/env bash

WORKDIR="$HOME/.config/ags"

_ags() {
	pkill ags
	ags &
}

_ags

inotifywait --quiet --monitor --event create,modify,delete --recursive $WORKDIR | while read DIRECTORY EVENT FILE; do
	file_extension=${FILE##*.}
	case $file_extension in
	ts)
		echo "reload TS..."
		_ags
		;;
	esac
done
