#!/usr/bin/env bash

# Get the user's home directory

# Define the cache file path
CACHE_FILE="$HOME/.cache/apps.json"

# Define the desktop directory path
DESKTOP_DIR="$HOME/.nix-profile/share/applications/"

ICON_DIR="$HOME/.local/share/icons/candy-icons/apps/scalable/"

# Function to get desktop entries
get_desktop_entries() {
	# Get all the .desktop files in the desktop directory
	desktop_files=($(find "$DESKTOP_DIR" -name "*.desktop"))

	entries=()

	# Loop through the desktop files
	for file_path in "${desktop_files[@]}"; do
		# Read the desktop file
		readarray -t lines <"$file_path"

		# Check if the "NoDisplay" key is set to "true"
		no_display=false
		for line in "${lines[@]}"; do
			if [[ "$line" == "NoDisplay=true" ]]; then
				no_display=true
				break
			fi
		done

		# If "NoDisplay" is set to "true", skip this entry
		if [[ "$no_display" == true ]]; then
			continue
		fi

		# Get the app name and icon path
		app_name=$(grep -m 1 -E "^Name=" "$file_path" | cut -d'=' -f2-)
		icon_path=$(grep -E "^Icon=" "$file_path" | cut -d'=' -f2-)
		icon_path=$(get_gtk_icon "$icon_path")

		# Add the entry to the array
		entries+=("{\"name\":\"$app_name\",\"icon\":\"$icon_path\",\"desktop\":\"$(basename "$file_path")\"}")
	done

	# Read the cached pinned apps
	pinned_apps=$(read_cache)

	# Return the desktop entries as a JSON object
	echo "{\"apps\":[$(
		IFS=,
		echo "${entries[*]}"
	)],\"pinned\":$pinned_apps,\"search\":false,\"filtered\":[]}"
}

# Function to get the GTK icon path
get_gtk_icon() {
	icon_name="$1"
	# Implement the logic to get the GTK icon path
	icon_path="$(find "$ICON_DIR" -name "*$icon_name*" -print -quit)"
	echo "$icon_path"
}

write_cache() {
	echo "$1" >"$CACHE_FILE"
}

read_cache() {
	if [ -f "$CACHE_FILE" ]; then
		value=$(<"$CACHE_FILE")
		if [ -z "$value" ]; then
			echo "[]"
		else
			echo "$value"
		fi
	else
		echo "[]"
	fi
}

filter_entries() {
	filtered=$(echo "$1" | jaq "[.apps[] | select(.name | test(\"^$2\"; \"i\"))]")
	echo "$filtered"
}

get_apps() {
	apps=$(echo "$1" | jaq ".apps")
	echo "$apps"
}

get_pinned() {
	pinned_apps=$(echo "$1" | jaq 'if (.pinned | type) == "array" then .pinned else [] end')
	echo "$pinned_apps"
}

update_eww() {
	eww update apps="$1"
}

add_pinned_entry() {
	entry=$(jaq -n --arg name "$1" --arg icon "$2" --arg desktop "$3" '{"name": $name, "icon": $icon, "desktop": $desktop}')
	cache=$(read_cache)

	isAlreadyPinned=$(echo "$cache" | jaq ".[] | select(.desktop == \"$3\")")
	echo "$isAlreadyPinned"

	if [ -z "$isAlreadyPinned" ]; then
		write_cache "$(echo "$cache" | jaq ". + [$entry]")"
		update_eww "$(get_desktop_entries)"
	else

		echo "App already pinned!"
		exit 1
	fi

}

remove_pinned_entry() {
	cache=$(read_cache)
	pins=$(echo "$cache" | jaq ". | map(select(.desktop != \"$1\"))")
	write_cache "$pins"
	update_eww "$(get_desktop_entries)"
}

if [ "$1" == "--query" ]; then
	if [ -n "$2" ]; then
		query=$2
		if [ "$query" == "" ]; then
			desktop_entries=$(get_desktop_entries)
			update_eww "$(get_desktop_entries)"
			exit 0
		fi

		desktop_entries=$(get_desktop_entries)
		filtered=$(filter_entries "$desktop_entries" "$query")
		apps=$(get_apps "$desktop_entries")
		pinned=$(get_pinned "$desktop_entries")
		update_eww '{"apps":'"$apps"', "pinned":'"$pinned"', "search": true, "filtered":'"$filtered"'}'
		# echo '{"apps":'"$apps"', "pinned":'"$pinned"', "search": true, "filtered":'"$filtered"'}'
	fi
elif [ "$1" == "--add-pin" ]; then
	name=$2
	icon=$3
	desktop=$4
	add_pinned_entry "$name" "$icon" "$desktop"

elif [ "$1" == "--remove-pin" ]; then
	desktop=$2
	remove_pinned_entry "$desktop"
else
	desktop_entries=$(get_desktop_entries)
	update_eww "$desktop_entries"
fi
