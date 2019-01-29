#!/bin/bash
set -x

nohup /usr/sbin/sshd -D &

chown -R vagrant: ${VAGRANT_DATA}
su - vagrant
cd ${VAGRANT_PATH} && ${BUNDLE} binstubs bundler --force

