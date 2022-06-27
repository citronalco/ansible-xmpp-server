#!/bin/sh
# Ansible managed

# Apache2
systemctl is-active --quiet apache2.service && systemctl reload apache2.service

# Coturn
cp -Lr /var/lib/dehydrated/certs/* /etc/pki/coturn/
chown -R coturn:coturn /etc/pki/coturn/*
systemctl is-active --quiet coturn.service && systemctl restart coturn.service

# Prosody
/usr/bin/prosodyctl --root cert import /var/lib/dehydrated/certs
