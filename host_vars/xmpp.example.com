# Note on passwords in this file:
# All passwords here are optional, but if you set a password it will be used.
# If you don't set a password and the server was already set up with this playbook, then the password currently in use will no be changed.
# If you don't set a password and the server was NOT already set up with this playbook, a random password will be generated and used.


##### EXAMPLE:
# In this example we're setting up a XMPP server for two XMPP domains:
# - foobar.org:
#   Open for anyone, users can register with their XMPP client
# - server.net:
#   Restricted to users who already have an account on the IMAP server mail.server.net.
#   Any of them can immediatelly use the XMPP server, no extra registration required.
#   JIDs: <IMAP-username>@server.net, password: <IMAP-password>
#
# "xmpp.example.com" will be used for BOSH, websockets, STUN/TURN server, Converse.js and a info web page, for all XMPP domains.
# The example server you're setting up has IPv4 12.34.56.78 and IPv6 2a02:1234:5678::72:1
#
#
#### PREREQUISITES:
# - TLS certificate and private key of foobar.org and server.net
# - Access to the web servers of foobar.org and server.net to be able to set up a reverse proxy configuration for Prosody's well-known URLs
# - Access to the DNS configuration of foobar.org, server.net and example.com to add some entries
#
#### 1. DNS CONFIGURATION
# DNS configuration must be set up BEFORE installing this playbook, so let's start with this:
# XMPP clients and servers heavily use DNS to figure out possible connection methods.
# So quite a few DNS entries in the name servers for foobar.org, server.net and xmpp.webexample.com are required.
# Please not the subtile differences between the DNS entries for foobar.org and server.net and how they correspond with the component's host names in the configuration below.
#
# Name server entries for example.com:
#  xmpp.example.com.                              300 IN A 12.34.56.78
#  xmpp.example.com.                              300 IN AAAA 2a02:1234:5678::72:1
#
# Name server entries for foobar.org:
#  conference.foobar.org.                        300 IN A 12.34.56.78                  # muc component
#  conference.foobar.org.                        300 IN AAAA 2a02:1234:5678::72:1      # muc component
#  proxy.foobar.org.                             300 IN A 12.34.56.78                  # proxy65 component
#  proxy.foobar.org.                             300 IN AAAA 2a02:1234:5678::72:1      # proxy65 component
#  upload.foobar.org.                            300 IN A 12.34.56.78                  # upload component
#  upload.foobar.org.                            300 IN AAAA 2a02:1234:5678::72:1      # upload component
#  pubsub.foobar.org.                            300 IN A 12.34.56.78                  # pubsub component
#  pubsub.foobar.org.                            300 IN AAAA 2a02:1234:5678::72:1      # pubsub component
#  _xmpp-client._tcp.foobar.org.                 300 IN SRV 0 5 5222 xmpp.example.com.
#  _xmpps-client._tcp.foobar.org.                300 IN SRV 0 5 5223 xmpp.example.com.  # legacy SSL port is 5223, see below
#  _xmpp-server._tcp.foobar.org.                 300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmpp-server._tcp.conference.foobar.org.      300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmpp-server._tcp.proxy.foobar.org.           300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmpp-server._tcp.pubsub.foobar.org.          300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmppconnect.foobar.org.                      300 IN TXT "_xmpp-client-xbosh=https://xmpp.example.com/http-bind"             # bosh
#  _xmppconnect.foobar.org.                      300 IN TXT "_xmpp-client-websocket=wss://xmpp.example.com/xmpp-websocket"      # websocket
#
# Name server entries for server.net:
#  muc.server.net.                              300 IN A 12.34.56.78                  # muc component
#  muc.server.net.                              300 IN AAAA 2a02:1234:5678::72:1      # muc component
#  proxy65.server.net.                          300 IN A 12.34.56.78                  # proxy65 component
#  proxy65.server.net.                          300 IN AAAA 2a02:1234:5678::72:1      # proxy65 component
#  uploads.server.net.                          300 IN A 12.34.56.78                  # upload component
#  uploads.server.net.                          300 IN AAAA 2a02:1234:5678::72:1      # upload component
#  pubsub.server.net.                           300 IN A 12.34.56.78                  # pubsub component
#  pubsub.server.net.                           300 IN AAAA 2a02:1234:5678::72:1      # pubsub component
#  _xmpp-client._tcp.server.net.                300 IN SRV 0 5 5222 xmpp.example.com.
#  _xmpps-client._tcp.server.net.               300 IN SRV 0 5 5225 xmpp.example.com.  # legacy SSL port is 5225, see below
#  _xmpp-server._tcp.server.net.                300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmpp-server._tcp.conference.server.net.     300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmpp-server._tcp.proxy.server.net.          300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmpp-server._tcp.pubsub.server.net.         300 IN SRV 0 5 5269 xmpp.example.com.
#  _xmppconnect.server.net.                     300 IN TXT "_xmpp-client-xbosh=https://xmpp.example.com/http-bind"             # bosh
#  _xmppconnect.server.net.                     300 IN TXT "_xmpp-client-websocket=wss://xmpp.example.com/xmpp-websocket"      # websocket
#
#### 2. RUN THE PLAYBOOK
#
#### 3. INSTALL TLS CERTIFICATES FOR foobar.org AND server.net
# After installing this playbook you have to copy the certificate and the private key of foobar.org and server.net to this server:
#   /etc/prosody/certs/foobar.org/privkey.pem
#   /etc/prosody/certs/foobar.org/fullchain.pem
#   /etc/prosody/certs/server.net/privkey.pem
#   /etc/prosody/certs/server.net/fullchain.pem
# Then change ownership on those files to the user "prosody" and execute "sudo prosodyctl reload". Do the same when updating certificates/keys.
# All other certificates are created and updated automatically. 
#
#### 4. SET UP well-known URLs
# Some XMPP clients query so called well-known URLs to figure out a domain's XMPP server.
# Prosody provides the content for those URLs, so you only have to configure the web servers of foobar.org and example.com to deliver that content when those well-known URLs are called.
# Simple HTTP redirects do NOT work (resets the CORS header), you have to configure it as reverse proxy.
#
# Web server of foobar.org:
#   https://foobar.org/.well-known/host-meta.json -> https://xmpp.example.com/.well-known/host-meta.json
#   https://foobar.org/.well-known/host-meta -> https://xmpp.example.com/.well-known/host-meta
# Web server of server.net:
#   https://server.net/.well-known/host-meta.json -> https://xmpp.example.com/.well-known/host-meta.json
#   https://server.net/.well-known/host-meta -> https://xmpp.example.com/.well-known/host-meta
#

# PostgreSQL
postgresql:
  databasename: prosody				# optional, default: prosody
  username: prosody				# optional, default: prosody
  password: 5xyfqhtehvtBJMiQt4L90X2e		# optional, default: random


# Coturn
turnserver:
  shared_password: kjhwef8721hkqhwdXXX		# optional, default: random


# Prosody
prosody:
  delete_uploads_after_days: 31			# delete uploaded files after XX days. optional, default: 365
  delete_messages_after_days: 31		# delete archived messages after XX days. optional, default: 365

  # only required if any of the xmpp_domains below should authenticate against an IMAP server ("authentication_provider = imap")
  imap_auth:
    host: mail.server.net
    port: 993

  # virtual host on this server offering BOSH, websockets, Converse.js and optionally a web site (see "content_git") for all xmpp_domains
  web_domain:
    name: "xmpp.example.com"
    admin_email: "webmaster@example.com"		# mail address of webserver admin
    content_git:				# optional. If you want https://xmpp.example.net display some content put that in a git repo and set it's URL below.
      url: http://git.bingo-ev.de/geierb/bytewerk-xmpp-server-website.git
      branch: master

  # list here your XMPP domains
  xmpp_domains:
    - name: "foobar.org"

      # Components - all four are required
      conference: "conference.foobar.org"
      proxy: "proxy.foobar.org"
      upload: "upload.foobar.org"
      pubsub: "pubsub.foobar.org"

      legacy_ssl_port: 5223			# port for "legacy SSL" connections, must be listed in DNS and not be shared with other XMPP domains

      authentication_provider: internal_hashed	# where to store user accounts (optional. possible values: internal_hashed, imap. default: internal_hashed)
      allow_registration: true			# enable anyone to register (default: false)

      admin_jids:				# list of JIDs that should have admin access
        - admin@foobar.org
        - someone@otherexample.com
      admin_group: "foobar admins"		# create a chatroom called "foobar admins" and automatically put all "admin_jids" into it (optional, default: do not create a group)

      conversejs:
        weblocation: /conversejs-foobar		# offer Converse.js for foobar.org in https://xmpp.example.com/conversejs-foobar

      testuser:					# create a test user for NRPE (optional, default: no testuser)
        name: "nrpe-testuser"			# testuser's jid will be "nrpe-testuser@foobar.org"
        password: "hkjwhd8u230wjl"		# optional, default: random

    - name: "server.net"

      # Components
      muc: "conference.server.net"
      proxy65: "proxy65.server.net"
      uploads: "upload.server.net"
      pubsub: "pubsub.server.net"

      legacy_ssl_port: 5225

      authentication_provider: imap		# use the IMAP server configured above for user authentication

      admin_jids:
        - admin@foobar.org
        - chef@server.net

      conversejs:
        weblocation: /conversejs-bingo


# Converse.js
conversejs:
  conversejs_release_tag: v6.0.1		# select a converse.js release (optional, default: newest)
  libsignal_release_tag: v1.3.0			# select a release of converse.js's OMEMO library (optional, default: newest)


# NRPE
nrpe:
  # list hostnames, IPv4 or IPv6 addresses allowed to query the nrpe server (optional, default: none)
  allowed_hosts:
    - www.my-icinga2-server.at
    - 23.45.67.89


ansible_python_interpreter: /usr/bin/python3
