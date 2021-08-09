# Ansible: Install a XMPP server on openSUSE Leap

This playbook installs a complete XMPP server for one to many domains.
As of August 2021 it gets 100% compliance in Conversations.im compliance test and an "A" score on xmpp.net.
Tested on openSUSE Leap 15.2 and 15.3

Included are:
* Prosody
* PostgreSQL
* Coturn
* Apache2
* Converse.js with OMEMO support
* LetsEncrypt certificates

Supports internal user authentication and authentication against an IMAP server.
For documentation see the example configuration in `host_vars/xmpp.example.com`

