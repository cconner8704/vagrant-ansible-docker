#!/bin/bash
set -x

chown -R vagrant: ${VAGRANT_DATA}
nohup /usr/sbin/sshd -D &
su - vagrant
cd ${VAGRANT_PATH} && ${BUNDLE} binstubs bundler --force

