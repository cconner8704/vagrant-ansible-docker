#!/bin/bash
set -x

chmown -R vagrant: ${VAGRANT_DATA}
su - vagrant
cd ${VAGRANT_PATH} && ${BUNDLE} binstubs bundler --force
exit
/usr/sbin/sshd -D
