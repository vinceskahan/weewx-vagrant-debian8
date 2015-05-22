# Vagrant file(s) for weewx 3.1.0 on Debian 8.0

These files will configure the following virtual box:

  * debian 8.0 with a rather minimal footprint
  * weewx-3.1.0 installed in Simulator mode
  	* debug=1 in weewx.conf
	* weewx.service is patched to work with Debian 8
  * nginx used as the webserver
  * lynx installed for a text-mode browser (after you 'vagrant ssh' in)

The virtual machine comes up with two network adaptors
  * eth0 dhcp up and NAT'd toward Internet
  * eth1 statically configured to the host-only adaptor


To install:
  * clone this directory into a scratch directory of your choosing
  * type 'vagrant up' to download the base box and build the weewx-enabled result
  * wait a few minutes, connect your host browser to http://localhost:8080 for the weewx web
  * and/or 'vagrant ssh' into the VM to look at /var/log/messages as needed

Disclaimer - set your passwords as you wish, don't expose this box on Internet, usual best practices apply

Warning - this was uploaded from msysgit on Windows, so beware your EOL in the files herein.
