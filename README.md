
# Project Drop Bear

<img align="left" width="160" height="240" src="https://upload.wikimedia.org/wikipedia/commons/e/ea/Koala_in_suburban_park_in_Queensland_Australia..jpg" />

Also known as, Windows Puppet Development on a USB Stick

__This has nothing to do with the [dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) SSH utilities or the [puppet-dropbear](https://github.com/voxpupuli/puppet-dropbear) module__

## Problem

When going to a site that has restrictive or difficult to use download policies (I'm looking at you NTLM Authenticated Proxy Servers!), it's nice to have a Puppet Development Environment ready to go!  With the rise of portable application installation this is now much easier to do.

# How to use it

* Insert the USB Stick
* Run `dropbear.cmd` or `dropbear.ps1`
* This will start a [cmder](http://cmder.net/) shell listing the available tools
* Enter `dropbear` to show the help screen again

``` powershell
C:\Users\Administrator
λ dropbear

Puppet USB Stick Shell

Tools installed:
Visual Studio Code          - code
Puppet Agent                - puppet
Puppet Development Kit      - pdk
PE Client Tools Quick Start - init-pe-client-tools
PE Client Tools             - puppet-access
                            - puppet-app
                            - puppet-code
                            - puppet-db
                            - puppet-job
                            - puppet-query

C:\Users\Administrator
λ
```

## Requirements

* A minimum of PowerShell 4 installed

## Tools included

* Visual Studio Code
  * Puppet Extension
  * PowerShell Extension

* Puppet Agent

* Puppet Development Kit (PDK)

* Puppet Enterprise Client Tools

* Cmder Shell
  * Includes git for windows
  * Includes ssh, scp, 7z utilities

### Configuration that is stored on the stick

* Visual Studio Code

* Cmder

### Configuration that is stored elsewhere

* git configuration

* ssh keys

* PE Client Tool configuration

# How to build it

This repository is used to create a USB Stick with all the needed applications, and can also create a (quite large) ZIP file of the same.

## Requirements

* A USB Stick
* Preferred to have a clean virtual machine
  - With a minimum of PowerShell 4 installed
  - 10GB free diskspace
* Internet connection to allow downloads

## Simple method

Drop Bear has a simple boot-strapper which can be executed in PowerShell

``` powershell
PS> Invoke-WebRequest 'https://raw.githubusercontent.com/glennsarti/puppet-usb-stick/master/dropbear-bootstrap.ps1' | Invoke-Expression
  ...
```

## Not as simple method

* Clone this repository

* Run `create-dropbear-stick.ps1`

``` powershell
PS> git clone https://github.com/glennsarti/puppet-usb-stick.git
  ...
PS> cd puppet-usb-stick
PS> .\create-dropbear-stick.ps1
  ...
```


# Why don't I distribute the ZIP file?

Because software licensing and distribution rights are a legal minefield and not something I want to tackle.  Instead I've tried to make the process of building your own stick as easy as possible

---

Koala Image

https://commons.wikimedia.org/wiki/File:Koala_in_suburban_park_in_Queensland_Australia..jpg

Don McMullen - CC BY-SA 3.0
