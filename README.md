## auto-usbip
A primitive implementation of automatically binding plugged in usb devices to the usbip server and attaching them to a client via SSH. SSH is only used to execute the `usbip attach` command on the client and does *not* provide any secure tunneling for the usbip communication itself.

## Instructions
Install usbip on the client and server. For example, if the client and server are both using Debian, run the following on each
```
$ sudo apt install usbip 
```
The package above includes both the usbip daemon and utility used to attach and bind usb devices.

### Client
Load kernel modules
```
$ sudo echo "vhci-hcd" >> /etc/modules
$ sudo modprobe vhci-hcd
```

### Server
Load kernel modules
```
$ sudo echo "usbip_core" >> /etc/modules
$ sudo echo "usbip_host" >> /etc/modules
$ sudo modprobe -a usbip_core usbip_host
``` 
Setup systemd unit scripts
```
$ sudo cp server/etc/systemd/system/* /etc/systemd/system
$ sudo systemctl enable --now usbipd
```
Replace `192.168.0.5` with your client's IP address in `auto-usbip@.service`
```
$ sudo vi /etc/systemd/system/auto-usbip@.service
```
Copy script
```
$ sudo cp server/usr/local/bin/auto-usbip.sh /usr/local/bin
$ sudo chmod +x /usr/local/bin/auto-usbip.sh
```
Setup udev rules to execute the auto-usbip systemd unit when any usb device is plugged into the server
```
$ sudo cp server/etc/udev/rules.d/90-usb-device-connected.rules /etc/udev/rules.d
$ sudo udevadm control --reload
```

Finally, make sure `ssh root@client` is accessible via passwordless public key authentication. You should now be able to plug in a usb device to the server and have it automatically attach to the client.
