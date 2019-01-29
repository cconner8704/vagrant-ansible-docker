#!/bin/bash
set -x

chown -R vagrant: ${VAGRANT_DATA}
su - vagrant
cd ${VAGRANT_PATH} && ${BUNDLE} binstubs bundler --force

