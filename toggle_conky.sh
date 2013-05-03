#!/bin/bash

win_name="gillesB_spaceship_hud_conky"
xprop -name $win_name | grep "_NET_WM_STATE_BELOW" 2>&1 > /dev/null
if [[ $? == 0 ]]
then #raise conky
	wmctrl -r $win_name -b remove,below
	wmctrl -r $win_name -b add,above
else
	wmctrl -r $win_name -b remove,above
	wmctrl -r $win_name -b add,below
fi


