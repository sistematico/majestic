#!/bin/sh
# send a notify message without access to DISPLAY
# taken from src/notify-osd.xml in notify-osd and from example in gdbus(1)
# 'notify-send' requires 'DISPLAY' and access to other context
# this script does not

# src/notify-osd.xml shows
#    <method name="Notify">
#      <annotation name="org.freedesktop.DBus.GLib.CSymbol" value="stack_notify_handler"/>
#      <annotation name="org.freedesktop.DBus.GLib.Async" value=""/>
#      <arg type="s" name="app_name" direction="in" />
#      <arg type="u" name="id" direction="in" />
#      <arg type="s" name="icon" direction="in" />
#      <arg type="s" name="summary" direction="in" />
#      <arg type="s" name="body" direction="in" />
#      <arg type="as" name="actions" direction="in" />
#      <arg type="a{sv}" name="hints" direction="in" />
#      <arg type="i" name="timeout" direction="in" />
#      <arg type="u" name="return_id" direction="out" />
#    </method>
#
# That is introspectable with:
# gdbus introspect --session \
#    --dest org.freedesktop.Notifications  \
#    --object-path /org/freedesktop/Notifications

app_name="${1:-'My APP'}"
id="42"
icon="${2:-'/usr/share/pixmaps/archlinux-logo.svg'}"
summary="$3"
body="$4"
actions="[]"
hints="{}"
timeout="5000" # in milliseconds

exec gdbus call --session   \
   --dest org.freedesktop.Notifications \
   --object-path /org/freedesktop/Notifications \
   --method org.freedesktop.Notifications.Notify \
   "${app_name}" "${id}" "${icon}" "${summary}" "${body}" \
   "${actions}" "${hints}" "${timeout}"
