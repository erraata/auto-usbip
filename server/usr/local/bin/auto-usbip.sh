#!/bin/bash

busid="$1"
client_ip="$2"

# Detect the IP address of the machine's default interface.
local_ip=$(ip route get 8.8.8.8 | head -n1 | awk '{print $7}')

echo "Binding device $busid to usbip..."
usbip bind -b $busid

sleep 2

echo "Attaching device $busid to client $client_ip..."
ssh $client_ip "usbip attach -r $local_ip -b $busid"
