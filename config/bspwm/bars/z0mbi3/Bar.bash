TOP_PADDING="1"
BOTTOM_PADDING="1"
LEFT_PADDING="60"
RIGHT_PADDING="1"

color_file=${HOME}"/.config/bspwm/rices/"${RICE}"/bar-colors.ini"

change_used_color() {
	config_file=${HOME}"/.config/bspwm/bars/"${1}"/config.ini"
	sed -i 's~include-file.*bar-colors.ini~include-file = '"$color_file"'~' "$config_file" 
}
change_current_bar() {
	theme_config=${HOME}"/.config/bspwm/rices/"${RICE}"/theme-config.bash"
	sed -i 's~CURRENT_BAR=.*~CURRENT_BAR="'$DEFAULT_BAR'"~' "$theme_config" 
}

# This file launch the bar/s

# Function for generating workspaces.yuck file with eww widgets
generate_eww_workspaces() {
    eww_file="${HOME}/.config/bspwm/bars/${CURRENT_BAR}/bar/workspaces.yuck"
    monitors=$(bspc query -M --names)
    count=0
    listen_workspaces=""
    widgets=""
    workspace_widgets=";; Workspaces Widgets ;;\n"

    printf "%s\n" ";; Workspaces ;;" > "$eww_file"

    for m in $monitors; do
        workspace_name="workspace${count}"
        listen_workspaces="${listen_workspaces}(deflisten ${workspace_name} \"scripts/WorkSpaces $m\")\n"
        widgets="${widgets}           (box :visible { monitor==\"$m\" } (${workspace_name}))\n"
        workspace_widgets="${workspace_widgets}(defwidget ${workspace_name} [] (literal :content ${workspace_name}))\n"
        count=$((count + 1))
    done
    printf "%b" "$listen_workspaces" >> "$eww_file"
    printf "%b" "$workspace_widgets" >> "$eww_file"
    printf "%b" ";; Workspaces Main Widget ;;\n(defwidget workspaces [monitor]\n   (box    :orientation \"v\"\n           :space-evenly \"false\"\n           :valign \"start\"\n$widgets))" >> "$eww_file"
}

generate_eww_workspaces

# Get a list of monitors and sort them so that the primary monitor is first
monitors=$(xrandr -q | grep -w 'connected' | sort -k3n | cut -d' ' -f1)
count=0
if [ -n "$1" ] && [ "$1" == "current" ]
then
	change_used_color $CURRENT_BAR
	# This file launch the bar/s
	for m in $monitors; do
        eww -c "${HOME}/.config/bspwm/bars/${CURRENT_BAR}/bar" open bar --id "$m" --arg monitor="$m" --toggle --screen "$count"
        count=$((count + 1))
    done
else
	change_used_color $DEFAULT_BAR
	change_current_bar
	# This file launch the bar/s	
	for m in $monitors; do
        eww -c "${HOME}/.config/bspwm/bars/${DEFAULT_BAR}/bar" open bar --id "$m" --arg monitor="$m" --toggle --screen "$count"
        count=$((count + 1))
    done
fi

# Fix eww when entering fullscreen state
	bspc subscribe node_state | while read -r _ _ _ _ state flag; do
		[ "$state" = "fullscreen" ] || continue
			if [ "$flag" = "on" ]; then
				HideBar -h
			else
				HideBar -u
			fi
	done &
