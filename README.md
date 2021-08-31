# Ansible: Install a XMPP server on openSUSE Leap

This playbook installs a complete XMPP server for one to many domains.\
As of August 2021 you will get 100% compliance in Conversations.im compliance test and an "A" score on xmpp.net.

Tested on openSUSE Leap 15.2 and 15.3.

Included are:
* Prosody
* PostgreSQL
* Coturn
* Apache2
* Converse.js with OMEMO support
* LetsEncrypt certificates

Supports multiple domains, internal user authentication and authentication against an IMAP server.

### Documentation:
See the example configuration in `host_vars/xmpp.example.com` \
The configuration for `host_vars/xmpp.bytewerk.org` is used for a productive server.


### Requirements:
* Server running openSUSE Leap 15.2 or 15.3 with a fixed IPv4 address
* A domain name, and you are able to edit its nameserver entries


### Usage:
1. Install Ansible on your machine (e.g. on Suse: `zypper install ansible`, on Debian/Ubuntu/Mint: `apt-get install ansible`)\
Ansible >= 2.10 is required.
1. Make sure you can log in on the server as root, without having to type in a password. (Use SSH Public Key authentication.)
1. Rename the file `hosts.example` to `hosts`, edit it and set your server's hostname and IP address
1. In directory `host_vars` rename the file `xmpp.example.com` to your server's hostname and set your preferences in that file
1. Execute `ansible-playbook -i hosts xmpp.yml` to start the installation.\
You can use the option  `--diff` to see in detail what Ansible does on your server, and/or `--check` for a dry-run.
