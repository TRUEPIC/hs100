# hs100

A tool for using TP-Link HS100/HS105/HS110 wi-fi smart plugs. You can turn
them on and off, reboot them, and so on. You can even set them up without
using TP-Link's app (see Initial Setup).

Tested to work on Linux, OSX, IRIX, and Windows under WSL.

Loosely based on [pyHS100](https://github.com/GadgetReactor/pyHS100) and
[research from softScheck](https://www.softscheck.com/en/reverse-engineering-tp-link-hs110/).

## Antony's quick start instruction

To compile,

```bash
meson build
cd build
ninja
```

Then, discover the smartplug by
```bash
bash ../discover.sh
```

And then probe the smart plug for info
```bash
cd build/
./hs100 [smartplug ip address] info
```

To install, type
```bash
cd build
ninja install
```
If prompted, select the admin account and then type password.

## Usage

`hs100 <ip> <command>`

Commands:
- `associate <ssid> <key> <key_type>`: set wifi AP to connect to. get your
key\_type by doing a scan
- `emeter`: realtime power consumption (only works with HS110)
- `factory-reset`: reset the plug to factory settings
- `off`: turn the power off
- `on`: turn the power on
- `reboot`: reboot the plug
- `scan`: scan for nearby wifi APs (probably only 2.4 GHz ones)
- `set_server <url>`: set cloud server to \<url\> instead of TP-Link's
- Alternatively, you can supply a JSON string to be sent directly to the
device. Note that the JSON string must be quoted, like so:
`hs100 <ip> '{"system":{"set_relay_state":{"state":1}}}'`

## Initial Setup

According to TP-Link, initial setup of the plugs is performed by installing
their "Kasa" app on your smartphone (free account required), and using its
setup tool. This sucks and I do not recommend it. Instead, follow these
alternative instructions.

You want to get the plug into the "blinking amber and blue" state, in which
it will spin up its own AP and await commands. If you have a brand new plug,
then it should do this automatically. Otherwise, hold down one of the buttons
(depending on your model) for about 5 seconds, until its light blinks amber
and blue.

You should see a wifi AP called "TP-Link\_Smart Plug\_XXXX" or similar.
Connect to this AP. You will be given an IP of 192.168.0.100, with the plug
at 192.168.0.1.

Issue the following commands to the plug:
- Factory reset the plug to get rid of any settings from a previous owner:
`hs100 192.168.0.1 factory-reset`. You will be disconnected from its wifi AP.
Once the factory reset is done (usually a few seconds), reconnect to the
plug's AP.
- Disable cloud nonsense by setting a bogus server URL: `hs100 192.168.0.1 set_server localhost`
- Scan for your wifi AP using `hs100 192.168.0.1 scan`. Find your AP in the
list and note its `key_type`; you will need this to associate.
- Associate with your AP using `hs100 192.168.0.1 associate <ssid> <password> <key_type>`
. Your key\_type is a number that indicates the kind of wifi security that
your AP is using. You can find it by doing a wifi scan (see previous step).

If the light turns solid amber, then it was unable to associate-- factory
reset the plug and try again. Otherwise, the light on your plug will change
first to blinking blue, then to solid blue indicating that it has successfully
connected to your AP.

## Build

Ubuntu instructions
You will need `build-essential` installed. Then run `make`. This will produce a `hs100` binary which you can use. E.g. `./hs100 192.168.0.1 off`

## Todo

- better error checking
- plug discovery

This program is very basic. Patches welcome!
