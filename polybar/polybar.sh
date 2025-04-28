#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch bar and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		if [ $m = "eDP-1" ]; then
			continue	
		fi	
		MONITOR=$m polybar bar2 --config=~/.config/polybar/config.ini 2>&2 | tee -a /tmp/polybar2.log & disown
	done
else
	polybar --reload bar &
fi
polybar bar --config=~/.config/polybar/config.ini 1>&2 | tee -a /tmp/polybar1.log & disown
	
echo "Bars launched..."
