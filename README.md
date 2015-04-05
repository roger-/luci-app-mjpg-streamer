# Notice

A version of this has been integrated into the OpenWrt LuCI package feed [here](https://github.com/openwrt/luci/tree/master/applications/luci-app-mjpg-streamer). Please use/modify that one instead!


# LuCI module for MJPG-streamer

Let's you configure MJPG-streamer from the LuCI web UI and preview HTTP streams.

![](http://i.imgur.com/ecFIcFy.png)

Basic features work, but the code is still incomplete.

# Todo

* opkg package for easier installation
* Finish support for MJPG-streamer plugins
* Support multiple input/output plugins?

# Installation

Copy `root/` to `/` on your OpenWrt installation.

# Credit

Based on a patch by vargagab found [here](http://luci.subsignal.org/trac/ticket/543) and a package from OpenWrt DreamBox found [here](https://code.google.com/p/openwrt-dreambox/source/browse/luci/trunk/applications/luci-webcam).
