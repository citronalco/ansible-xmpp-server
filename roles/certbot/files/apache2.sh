#!/bin/sh
# Ansible managed

systemctl is-active --quiet apache2.service && systemctl reload apache2.service
