#!/usr/bin/env python3

import i3ipc
import subprocess

i3 = i3ipc.Connection()

def on_window_focus(i3, e):
    focused = i3.get_tree().find_focused()
    name = focused.window_class
    if name == "VirtualBox":
        subprocess.call(["killall", "xcape"])
    else:
        subprocess.call(["killall", "xcape"])
        subprocess.call(["/home/rafael/bin/xcape.sh"])

i3.on("window::focus", on_window_focus)

i3.main()
