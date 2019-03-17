#!/bin/bash

set -ex

apt-get update -y
apt-get install -y build-essential libyaml-dev desktop-file-utils curl wget file
curl -o /usr/local/bin/pkg2appimage https://raw.githubusercontent.com/AppImage/pkg2appimage/master/pkg2appimage
chmod +x /usr/local/bin/pkg2appimage
pkg2appimage ./build/drone/appimage.yml