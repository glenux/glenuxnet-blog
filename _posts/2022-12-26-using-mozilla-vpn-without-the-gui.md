---
layout: post
tags:
- overview
- technology
- business
title: Using MozillaVPN without the GUI
categories:
- Wanderings
date: 2022-12-26 22:54 +0100
---
MozillaVPN is a virtual private network (VPN) service that offers security and privacy while browsing the internet. While it can be used through the Mozilla VPN interface, some users may prefer to use it in a different way. This is where MozWire comes in. MozWire is an open-source command-line utility that allows users to easily manage their MozillaVPN connections. It can be used to import MozillaVPN configurations into other VPN clients, such as NetworkManager, which is a popular choice for Linux systems. 

In this article, we will guide you through how to extract MozillaVPN connections with MozWire and then import them into NetworkManager, allowing for greater flexibility and control in managing your MozillaVPN connections.

<!-- more -->

### Prepare your system

First install requirements for wireguard

```shell-session
$ sudo apt install resolvconf wireguard-tools
```

First, grant access to the `/etc/wireguard` directory to the `wireguard` group, and add your current user to this group.

```shell-session
$ sudo addgroup wireguard
$ sudo chmod -R ug+rw /etc/wireguard/
$ sudo chown -R root:wireguard /etc/wireguard/
$ sudo adduser $(whoami) wireguard
```

### Extracting MozillaVPN connections with MozWire


To use MozWire, first download and build it by running the following commands:


```shell-session
$ git clone https://github.com/NilsIrl/MozWire.git
$ cd MozWire
$ sudo apt install cargo
$ cargo build -r
```

Next, you need to extract the configuration for all MozillaVPN connections into the `/tmp/wireguard` directory. To do this, you will need to run the following commands (as root):

<style>
.highlight .go {
color: inherit;
background: inherit;
}
</style>

```shell-session
$ sudo mkdir -p /etc/wireguard
$ export MOZ_TOKEN=$(mozwire --print-token)
$ ./target/release/mozwire relay save -o /etc/wireguard -n 0
Public key not in device list, uploading it.

Wrote configuration to /tmp/wireguard/au3-wireguard.conf.
Wrote configuration to /tmp/wireguard/au4-wireguard.conf.
Wrote configuration to /tmp/wireguard/au10-wireguard.conf.
[...]
Wrote configuration to /tmp/wireguard/us-sea-wg-208.conf.
Wrote configuration to /tmp/wireguard/us-sea-wg-301.conf.
Wrote configuration to /tmp/wireguard/us-sea-wg-302.conf.
```


## Importing wireguard configuration files into NetworkManager

Once you have extracted wireguard configuration files for MozillaVPN, you can import them all at once into NetworkManager with the [Wireguard importer script for NetworkManager](https://gitlab.com/-/snippets/2476741):

Please read the script, download it, and save it as `wgimport.sh` on your system. Then run it with the following command:

```shell-session
# bash wgimport.sh MozillaVPN /etc/wireguard/
```


## Using NetworkManager, step by step...

Imagine we want to import the `/etc/wireguard/jp-osa-wg-001.conf` a configuration file.

The first step would be to import the configuration file into NetworkManager, which can be done with the following command:

```shell-session
$ nmcli connection import type wireguard file /etc/wireguard/jp-osa-wg-001.conf
Connection 'jp-osa-wg-001' (a1fce7d4-2e38-416d-bac1-6a517e25eaa6) successfully added.
```

__Note:__ by default, the connection is started as soon as the file is loaded. 

Once you have imported the MozillaVPN configurations into NetworkManager, you can easily manage your VPN connections through your favorite NetworkManager interface (in KDE/Plasma, Gnome, XFCE, etc.): 

* You can connect to a VPN by selecting it from the list of available connections and clicking the "Connect" button. 
* To disconnect from a VPN, simply select the connection and click the "Disconnect" button. 

Alternatively, you can use the NetworkManager CLI to list active connections:

```shell-session
$ nmcli connection show
$ # or to limit to active connections:
$ nmcli connection show --active
```

You can start your VPN connection by typing:

```shell-session
$ nmcli connection up jp-osa-wg-001
$ # or
$ nmcli connection up uuid a1fce7d4-2e38-416d-bac1-6a517e25eaa6
```


You can stop the connection with one of the following commands:

```shell-session
$ nmcli connection down jp-osa-wg-001
Connection 'jp-osa-wg-001' successfully deactivated (D-Bus active path: ...)
$ # or
$ nmcli connection down uuid a1fce7d4-2e38-416d-bac1-6a517e25eaa6
Connection 'jp-osa-wg-001' successfully deactivated (D-Bus active path: ...)
```

You may also want to disable the autoconnect feature for these connections, as it can be inconvenient to have your imported VPN automatically connecting whenever you start your computer. 

To do this, you can run either of the following commands:

```shell-session
$ nmcli connection modify jp-osa-wg-001 autoconnect no
$ # or
$ nmcli connection modify uuid a1fce7d4-2e38-416d-bac1-6a517e25eaa6 autoconnect no
```

You may also want to rename yout VPN connections, which is feasible with the next command:

```shell-session
$ nmcli connection modify jp-osa-wg-001 connection.id "MozillaVPN (jp-osa-wg-001)"
$ # or
$ nmcli connection modify uuid a1fce7d4-2e38-416d-bac1-6a517e25eaa6 \
     connection.id "MozillaVPN (jp-osa-wg-001)"
```

As usual, use the ping, ip and wg commands to test your connections, view IP
routing and other information:

```shell-session
$ ping -c3 linuxfr.org
PING linuxfr.org (213.36.253.176) 56(84) bytes of data.
64 bytes from prod.linuxfr.org (213.36.253.176): icmp_seq=1 ttl=59 time=37.8 ms
64 bytes from prod.linuxfr.org (213.36.253.176): icmp_seq=2 ttl=59 time=39.1 ms
...

$ sudo wg
$ sudo ip -c route list table all 
```

__Note:__ Listing all tables may be needed since the VPN rules seems to be assigned to a specific routing table with Wireguard.


## Références

* [MozWire](https://github.com/NilsIrl/MozWire) -  An unofficial configuration manager giving Linux, macOS users (among others), access to MozillaVPN. 
* [MozillaVPN](https://www.mozilla.org/products/vpn/) - A Virtual Private Network from the makers of Firefox.
* [nmcli](https://linux.die.net/man/1/nmcli) - A command-line tool for controlling NetworkManager.
