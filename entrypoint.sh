#!/bin/bash
set -x

$VAGRANT_PATH && $BUNDLE binstubs bundler --force
/usr/sbin/init
