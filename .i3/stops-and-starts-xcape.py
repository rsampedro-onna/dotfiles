#!/usr/bin/env python3

import i3ipc
import subprocess

i3 = i3ipc.Connection()

def on_window_focus(i3, e):
    focused = i3.get_tree().find_focused()
    name = focused.name
    if ( name.startswith("7") or name.startswith("10") ) and name.endswith('VirtualBox'):
        subprocess.call(["killall", "-KILL", "xcape"])
    else:
        subprocess.call(["killall", "-KILL", "xcape"])
        subprocess.call(["/home/rafael/bin/xcape.sh"])

i3.on("window::focus", on_window_focus)

i3.main()
