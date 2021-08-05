#!/bin/sh
# Ansible managed

cd /usr/local/lib/prosody-modules
hg pull
hg update --clean
