--[[
LuCI - Lua Configuration Interface - Transmission support

Copyright 2013 Gabor Varga <vargagab@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

m = Map("mjpg-streamer", "MJPG-streamer", translate("mjpg streamer is a streaming application for Linux-UVC compatible webcams"))

s=m:section(TypedSection, "mjpg-streamer", translate("mjpg streamer settings"))
s.addremove=false
s.anonymous=true

s:tab("input",translate("Input plugin"))
s:tab("output_http", translate("HTTP output"))
s:tab("output_file", translate("File output"))

enable=s:taboption("input", Flag, "enabled", translate("Enabled"))
enable.rmempty=false
device=s:taboption("input", Value, "device", translate("Device"))
resolution=s:taboption("input", Value, "resolution", translate("Resolution"))
fps=s:taboption("input", Value, "fps", translate("Frames per second"))
fps.datatype = "uinteger"
yuv=s:taboption("input", Flag, "yuv", translate("Enable YUYV format"), translate("Automatic disabling of MJPEG mode"))
quality=s:taboption("input", Value, "quality", translate("JPEG compression quality"), translate("Set the quality in percent. This setting activates YUYV format, disables MJPEG"))
quality.datatype = "uinteger"
minimum_size=s:taboption("input", Value, "minimum_size", translate("Drop frames smaller then this limit"),translate("Set the minimum size if the webcam produces small-sized garbage frames. May happen under low light conditions"))
minimum_size.datatype = "uinteger"
no_dynctrl=s:taboption("input", Flag, "no_dynctrl", translate("Don't initalize dynctrls"), translate("Do not initalize dynctrls of Linux-UVC driver"))
led=s:taboption("input", ListValue, "led", translate("Led control"))
led:value("on", translate("On"))
led:value("off", translate("Off"))
led:value("blink", translate("Blink"))
led:value("auto", translate("Auto"))

http_enabled=s:taboption("output_http", Flag, "http_enabled", translate("Enabled"))
www=s:taboption("output_http", Value, "www", translate("WWW folder"), translate("Folder that contains webpages"))
www:depends("http_enabled", "1")
port=s:taboption("output_http", Value, "port", translate("Port"), translate("TCP port for this HTTP server"))
port:depends("http_enabled", "1")
port.datatype = "uinteger"
authentication=s:taboption("output_http", Flag, "authentication", translate("Authentication required"), translate("Ask for username and password on connect"))
authentication:depends("http_enabled", "1")
username=s:taboption("output_http", Value, "username", translate("Username"))
username:depends("authentication", "1")
password=s:taboption("output_http", Value, "password", translate("Password"))
password:depends("authentication", "1")
password.password=true

file_enabled=s:taboption("output_file", Flag, "file_enabled", translate("Enabled"))
folder=s:taboption("output_file", Value, "folder", translate("Folder"), translate("Set folder to save pictures"))
folder:depends("file_enabled", "1")
folder.placeholder="/tmp/images"
--mjpeg=s:taboption("output_file", Value, "mjpeg", translate("Mjpeg output"), translate("Check to save the stream to an mjpeg file"))
--mjpeg:depends("file_enabled", "1")
delay=s:taboption("output_file", Value, "delay", translate("Interval between saving pictures"), translate("Set the inteval in millisecond"))
delay:depends("file_enabled", "1")
delay.placeholder="5000"
delay.datatype = "uinteger"
ringbuffer=s:taboption("output_file", Value, "ringbuffer", translate("Ring buffer size"), translate("Max. number of pictures to hold"))
ringbuffer:depends("file_enabled", "1")
ringbuffer.placeholder="10"
ringbuffer.datatype = "uinteger"
exceed=s:taboption("output_file", Value, "exceed", translate("Exceed"), translate("Allow ringbuffer to exceed limit by this amount"))
exceed:depends("file_enabled", "1")
exceed.datatype = "uinteger"
command=s:taboption("output_file", Value, "command", translate("Command to run"), translate("Execute command after saving picture. Mjpg-streamer parse the filename as first parameter to your script."))
command:depends("file_enabled", "1")
return m