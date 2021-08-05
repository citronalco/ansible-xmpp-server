#!/bin/sh
# Ansible managed

cp -Lr /etc/letsencrypt/live/* /etc/pki/coturn/
chown -R coturn:coturn /etc/pki/coturn/*
systemctl is-active --quiet coturn.service && systemctl restart coturn.service
