#!/bin/bash
set -x

nohup sleep 200000

nohup /usr/sbin/sshd -D &

chown -R vagrant: ${VAGRANT_DATA}
su - vagrant

env
#cd ${VAGRANT_PATH} && ${BUNDLE} binstubs bundler --force

