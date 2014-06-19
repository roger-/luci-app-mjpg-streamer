m = Map("mjpg-streamer", "MJPG-streamer", translate("mjpg streamer is a streaming application for Linux-UVC compatible webcams"))


--- General settings ---

section_gen = m:section(TypedSection, "mjpg-streamer", "General")
    section_gen.addremove=false
    section_gen.anonymous=true

enabled = section_gen:option(Flag, "enabled", "Enabled", "Enable MJPG-streamer")

input = section_gen:option(ListValue, "input",  "Input plugin")
   input:depends("enabled", "1")
   input:value("uvc", "UVC")
   input:value("file", "File")

output = section_gen:option(ListValue, "output",  "Output plugin")
   output:depends("enabled", "1")
   output:value("http", "HTTP")
   output:value("file", "File")


--- Plugin settings ---

s = m:section(TypedSection, "mjpg-streamer", "Plugin settings")
    s.addremove=false
    s.anonymous=true

    s:tab("output_http", translate("HTTP output"))
    s:tab("output_file", translate("File output"))
    s:tab("input_uvc", translate("UVC input"))
    s:tab("input_file", translate("File input"))


--- Input UVC settings ---

device = s:taboption("input_uvc", Value, "device", translate("Device"))
    device.default="/dev/video0"
    device.datatype = "device"
    device:value("/dev/video0", "/dev/video0")
    device:value("/dev/video1", "/dev/video1")
    device:value("/dev/video2", "/dev/video2")
    device.optional = false

resolution = s:taboption("input_uvc", Value, "resolution", translate("Resolution"))
    resolution.placeholder = "VGA"
    resolution:value("320x240", "QVGA")
    resolution:value("640x480", "VGA")
    resolution:value("800x600", "SVGA")
    resolution:value("864x480", "864x480")
    resolution:value("960x544", "960x544")
    resolution:value("960x720", "960x720")
    resolution:value("1280x720", "1280x720")
    resolution:value("1280x960", "1280x960")
    resolution:value("1920x1080", "1920x1080")
    resolution.optional = true

fps = s:taboption("input_uvc", Value, "fps", translate("Frames per second"))
    fps.datatype = "uinteger"
    fps.placeholder = "5"
    fps.datatype = "min(1)"
    fps.optional = true

yuv = s:taboption("input_uvc", Flag, "yuv", translate("Enable YUYV format"), translate("Automatic disabling of MJPEG mode"))

quality = s:taboption("input_uvc", Value, "quality", translate("JPEG compression quality"), translate("Set the quality in percent. This setting activates YUYV format, disables MJPEG"))
    quality.datatype = "range(0, 100)"

minimum_size = s:taboption("input_uvc", Value, "minimum_size", translate("Drop frames smaller then this limit"),translate("Set the minimum size if the webcam produces small-sized garbage frames. May happen under low light conditions"))
    minimum_size.datatype = "uinteger"

no_dynctrl = s:taboption("input_uvc", Flag, "no_dynctrl", translate("Don't initalize dynctrls"), translate("Do not initalize dynctrls of Linux-UVC driver"))

led = s:taboption("input_uvc", ListValue, "led", translate("Led control"))
    led:value("on", translate("On"))
    led:value("off", translate("Off"))
    led:value("blink", translate("Blink"))
    led:value("auto", translate("Auto"))
    led.optional = true


--- Output HTTP settings ---

port=s:taboption("output_http", Value, "port", translate("Port"), translate("TCP port for this HTTP server"))
    port.datatype = "port"
    port.placeholder = "8080"

authentication = s:taboption("output_http", Flag, "authentication", translate("Authentication required"), translate("Ask for username and password on connect"))

username = s:taboption("output_http", Value, "username", translate("Username"))
    username:depends("authentication", "1")

password = s:taboption("output_http", Value, "password", translate("Password"))
    password:depends("authentication", "1")
    password.password = true

www = s:taboption("output_http", Value, "www", translate("WWW folder"), translate("Folder that contains webpages"))
    www.datatype = "directory"


--- HTTP preview  ---

html = [[<script type="text/javascript">

function _start_stream() {
	img = document.getElementById('video_preview');
	img.src = 'http://' + location.hostname + ':8080' + '/?action=stream#' + new Date().getTime();
	console.log('_start_stream')
}

function start_stream() {
	img = document.getElementById('video_preview');
	img.onerror=onerror;
	img.style.display='block';
	setTimeout(function() { _start_stream(); }, 500);
	console.log('start_stream');
}

function stop_stream() {
	img = document.getElementById('video_preview'); img.onerror=null; img.src=''; img.style.display='none'; stream_stopped(); console.log('stop_stream')
}

function stream_started() {
	btn = document.getElementById('play_button'); btn.value='stop'; btn.className='cbi-button cbi-button-reset'; btn.onclick=stop_stream; console.log('stream_started')
}
function stream_stopped() {
	btn = document.getElementById('play_button'); btn.value='start'; btn.className='cbi-button cbi-button-apply';btn.onclick=start_stream; console.log('stream_stopped')
}
function onerror() {
	console.log('onerror'); stream_stopped(); start_stream()
}

</script>

<div id="videodiv">
	<img id="video_preview" width="640\" onload="console.log('onload'); stream_started()" onerror="onerror"/>
	<p align="left"><input id="play_button" type="button" value="play" class="cbi-button cbi-button-apply" onclick="start_stream" />
	</p>
</div>]]

s:taboption("output_http", DummyValue, "_dummy", html)


--- Output file settings ---

folder=s:taboption("output_file", Value, "folder", translate("Folder"), translate("Set folder to save pictures"))
    folder.placeholder="/tmp/images"
    folder.datatype = "directory"

--mjpeg=s:taboption("output_file", Value, "mjpeg", translate("Mjpeg output"), translate("Check to save the stream to an mjpeg file"))

delay=s:taboption("output_file", Value, "delay", translate("Interval between saving pictures"), translate("Set the inteval in millisecond"))
    delay.placeholder="5000"
    delay.datatype = "uinteger"

ringbuffer=s:taboption("output_file", Value, "ringbuffer", translate("Ring buffer size"), translate("Max. number of pictures to hold"))
    ringbuffer.placeholder="10"
    ringbuffer.datatype = "uinteger"

exceed=s:taboption("output_file", Value, "exceed", translate("Exceed"), translate("Allow ringbuffer to exceed limit by this amount"))
    exceed.datatype = "uinteger"

command=s:taboption("output_file", Value, "command", translate("Command to run"), translate("Execute command after saving picture. Mjpg-streamer parse the filename as first parameter to your script."))


return m