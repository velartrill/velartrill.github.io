# taming the Pi4
% Lexi Hale's continued harrowing adventures in computing
% with style ../res/code.css

out of a desire to centralize my music repositories and due to the small hard drive of my cheap-ass main laptop, i recently decided i needed a media center machine of some kind. i took a look at the Pi4's specs, noted in shock that it was cheap enough i could actually afford it, and decided, hey. maybe this will actually work. and it did!

technically.

after a full day of fucking around, googling hither and thither at varying levels of frustration and desperation, i finally have a media center box that just about works. achieving this sisyphean feat required a great deal of original research, since there is not actually any information about the Raspberry Pi 4 on the internet. given how hit-and-miss, trial-and-error this process was, i felt obligated to write it up and hopefully spare at least one other person the pain of dealing with this atrocity.

## caveats
there are a couple things you need to be immediately aware of when it comes to the Pi 4.

the first is that, while it uses USB-C power, it is not USB-C compliant, and compliant adapters will not power the device. you have to use el-cheapo chinesium hardware to have any chance of getting the thing to work. this fuckup is pretty infamous and the RPi clowns have been excoriated at length for it already by people who understand hardware much better than me, so i won't waste any more breath on it.

the second is a problem shared with the Pi3 that goes mysteriously unmentioned in the specs: specifically, bluetooth audio output and the wireless card cannot be used simultaneously. i ended up having to buy an AUX<->RCA cable to wire the damn thing directly into my stereo system -- which, whatever, it's the objectively correct thing to do anyway, but it's incredibly irritating. if your audio setup depends on A2DP, stay the Hel away from this awful contraption.

## the nightmare begins
while i briefly toyed with the idea of running a BSD on the thing, i quickly decided to stick with my usual Arch Linux setup. Arch is the only Linux i can stand -- it's the least worst of the `systemd`-afflicted distros, insert ritual condemnation of poettering here, and is the only linux distro besides maybe void or alpine that still respects the unix philosophy, instead of trying to paper over the system with User Friendly GUI trash.

i downloaded the Arch Linux ARM package, set up my SD card, and copied everything into place. booting and ethernet both worked out of the box -- and nothing else. however, this at least meant i was able to ssh in like a civilized person and didn't have to break out the UART cable.

the first problem i came across was wifi. the device did not appear to exist. lshw found nothing, rfkill shrugged its shoulders, showing only bluetooth. despite being so bleak and mysterious, this one ended up being the easiest to fix -- `pacman -Syu && reboot` did the job, and `wlan0` was up and working flawlessly by next boot.

bluetooth… bluetooth was less easy.

despite appearing in rfkill's output, bluetooth genuinely just doesn't work. for some reason, the default arch linux arm pi image is defective. to fix it, you need to install [alarm-bluetooth-raspberrypi](https://github.com/RoEdAl/alarm-bluetooth-raspberrypi) -- which, no, in case you are wondering, is not in the official repos *or* the AUR. then you need to change `/boot/cmdline.txt` to read `root=/dev/mmcblk0p2 rw rootwait console=tty1 selinux=0 plymouth.enable=0 smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 kgdboc=ttyAMA0,115200 elevator=noop`, removing the inexplicable reference to `/dev/ttyAMA0` (presumably the bluetooth device?) as a console. *then*, you need to add the line `dtoverlay=bcmbt` to `/boot/config.txt` and reboot.

after this, just install bluez and all per the usual and linux will be able to talk to the onboard bluetooth. however, initially, only root will be able to - you need to place [this dbus policy](taming-pi4.bt-dbus.txt) file in `/etc/dbus-1/system.d/bluetooth.conf`to allow users in the group `bluetooth` to send signals over dbus to bluez. you'll have to do something similar with pulseaudio. i have no idea why this is an issue when it isn't on normal (i.e. x86-64) Arch systems.

## audio
i'm unclear on what exactly the fuck is going on with audio on the Pi4. output from libao is reliably garbled; you can sometimes get it to work for a few minutes by switching to OSS mode and using `padsp` to wrap the offending binary, but i've had mixed success, and have given up on getting pianobar to work reliably. what i can say for certain is that libao's pulseaudio output module appears to be completely broken on the Pi4 in all circumstances, either emitting garbage or not connecting at all.

 * maybe the cache thing? see if that works; otherwise, do the null loopback trick

the normal means of accessing pulseaudio, the `PULSE_RUNTIME_PATH` directory, in general only seems to work if the process is being run under the `pulse` user herself, not merely an account with the `pulse-access` group as the docs imply should be sufficient. however, since i was [setting up pulseaudio for network audio transmission](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#index22h3) anyway (you can do this with the server zeroconf-publish/client zeroconf-discover modules, or create a sink pointed directly at that IP address  with e.g. `$ pactl load-module module-tunnel-sink-new sink-name=whatever server=10.1.2.3`) i was able to mostly bypass this and use `PULSE_SERVER=127.0.0.1` instead. (you can also control volume from a remote client this way -- just run `env PULSE_SERVER=10.1.2.3 pavucontrol/ncpamixer/whatever`; just note that `PULSE_SERVER` can only be an IP address. `env PULSE_SERVER=$(dig +short $host)` is one way to hack around that if you really need to.) note that while pactl is fine with using `PULSE_SERVER`, `pacmd` require `PULSE_RUNTIME_DIR`and to be run as the `pulse` user.


by comparison, mpd was much simpler to set up, and required no special bullshit. note, however, that for zeroconf to work, you may need to repeat the dbus workaround with avahi-daemon.