#!/bin/bash
set -x

cd ${VAGRANT_PATH} && ${BUNDLE} binstubs bundler --force
/usr/sbin/sshd -D
