TOP_PADDING="50"
BOTTOM_PADDING="1"
LEFT_PADDING="1"
RIGHT_PADDING="1"

# path to the file with colors of the current theme
color_file=${HOME}"/.config/bspwm/rices/"${RICE}"/bar-colors.ini"

# change bar color scheme
# when using you need to pass $CURRENT_BAR or $DEFAULT_BAR
change_bar_colors() {
	# path to the config file of the selected bar
	config_file=${HOME}"/.config/bspwm/rices/"${1}"/config.ini"
	# changes the color scheme for the selected bar in the file "config.ini"
	sed -i 's~include-file.*bar-colors.ini~include-file = '"$color_file"'~' "$config_file" 
}
# changes the value of the string "CURRENT_BAR" to the default value
change_current_bar() {
	theme_config=${HOME}"/.config/bspwm/rices/"${RICE}"/theme-config.bash"
	sed -i 's~CURRENT_BAR=.*~CURRENT_BAR="'$DEFAULT_BAR'"~' "$theme_config" 
}


if [ -n "$1" ] && [ "$1" == "current" ]
then
	change_bar_colors $CURRENT_BAR
    # This file launch the bar/s
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q emi-bar -c "${HOME}"/.config/bspwm/rices/"${CURRENT_BAR}"/config.ini &
	done
else
	change_bar_colors $DEFAULT_BAR
	change_current_bar
    # This file launch the bar/s
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q emi-bar -c "${HOME}"/.config/bspwm/rices/"${DEFAULT_BAR}"/config.ini &
	done
fi