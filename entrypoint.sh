#!/bin/bash
set -x

sudo chown -R vagrant: ${VAGRANT_DATA}
sudo /usr/sbin/sshd -D
