#!/bin/bash
set -x

sudo chown -R vagrant: ${VAGRANT_DATA}
cd ${VAGRANT_PATH} && ${BUNDLE} binstubs bundler --force
sudo /usr/sbin/sshd -D
