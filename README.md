spaceship-conky
==============

#Warning
The setting contains a memory leak. It will fill the memory and freeze the system. Only use it with caution. 

#Short Description

A [conky](http://conky.sourceforge.net/) setting, which should look like a spaceship HUD/cockpit.
Additionally a bash-script is provided, which can raise conky above all other windows.

##Screenshots
###Normal
![Spaceship Conky](/screenshots/spaceship-conky.png "Spaceship Conky")
###Raised
![Spaceship Conky](/screenshots/spaceship-conky_raised.png "Spaceship Conky")

##This work is based on
This setting is based on a script by muzieca found on http://peppermintos.net/viewtopic.php?f=15&t=254&start=40 ,
the Ring Lua script was originally created by londonali1010.
The used background Lua script was also created by londonali1010.

#Detailed Description

This conky setting consists of two parts:
* conky.config - normal conky config file
* big_rings.lua - the rings, the background frame and the Rhythmbox functions
 
##Installation
Download this repository. Change to the used folder and execute conky. This could be done with a few bash commands:
```
cd /a/folder/I/really/like
git clone git@github.com:gillesB/spaceship-conky.git
conky -c ./conky.config
```
**Pay Attention that you execute conky in the folder where both files (conky.config, big_rings.lua) reside.**

*conky -c /a/folder/I/really/like/conky.config will not work, as conky will not find the lua script.*

##Monitored Information
Some monitored information will not work as they have to be adjusted for obvious reasons, like a filepath. If a
monitored information has to be changed, this has to be done in the conky.config and most of the times
also in the big_rings.lua.

As system temperatures are read, the **lm-sensors** package has to be installed.
###Rhythmbox
Rhythmbox is monitored and a message is shown if it active and plays songs.

**What happens if Rhythmbox is not installed?**

*I don't know. Please tell me. But I assume that nothing will break.*

## Raise conky
Requires:
* wmctrl
* xprop

Conky can be raised or decreased with the bash script toogle_conky.sh. This script raises Conky above every other window,
if it is below them and vice versa.

I use the script on the shortcut Super+S. To do that, just add the script to your favourite keybinder
(if your desktop environment does not provide one, you can use xbindkeys).

