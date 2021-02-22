#!/bin/sh
cp -Lr /etc/letsencrypt/live/* /etc/coturn/certs/
chown -R coturn:coturn /etc/coturn/certs/*
systemctl is-active --quiet coturn.service && systemctl restart coturn.service
