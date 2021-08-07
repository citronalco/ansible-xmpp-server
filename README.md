# Ansible: Install a XMPP server on openSUSE Leap

This playbook installs a complete XMPP server for one to many domains.
Included are:
* Prosody
* PostgreSQL
* Coturn
* Apache2
* Converse.js with OMEMO support
* LetsEncrypt certificates

As of August 2021 it gets 100% compliance in Conversations.im compliance test and gets an "A" score on xmpp.net.

Tested on openSUSE Leap 15.2 and 15.3

For documentation please see the example configuration at `host_vars/xmpp.example.com`

