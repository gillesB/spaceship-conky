spaceship-conky
==============

A conky script, which should look like a spaceship HUD/cockpit.

This seeting is based on a script by muzieca found on http://peppermintos.net/viewtopic.php?f=15&t=254&start=40 , the Ring Lua script was originally created by londonali1010.
The used background Lua script was also created by londonali1010.

### Raise conky
install xkeybind and add the following lines to the .xbindkeysrc.

```
"xset -r && path/to/raise_conky.sh"
  mod4 + s

"path/to/decrease_conky.sh && set r"
  release + mod4 + s
``` 
xset -r and r is to disable and enable the autorepeat function of the keyboard. If it is disabled anyway, xset is not needed.
