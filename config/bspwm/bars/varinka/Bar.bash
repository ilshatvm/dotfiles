TOP_PADDING="42"
BOTTOM_PADDING="1"
LEFT_PADDING="1"
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

if [ -n "$1" ] && [ "$1" == "current" ]
then
	change_used_color $CURRENT_BAR
	# This file launch the bar/s
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q varinka-bar -c "${HOME}"/.config/bspwm/bars/"${CURRENT_BAR}"/config.ini &
	done
else
	change_used_color $DEFAULT_BAR
	change_current_bar
	# This file launch the bar/s
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q varinka-bar -c "${HOME}"/.config/bspwm/bars/"${DEFAULT_BAR}"/config.ini &
	done
fi