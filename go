#!/usr/bin/env bash
sudo -v
# Keep-alive: update existing `sudo` time stamp until we're done
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
here="$(dirname "$0")"
chef-client -z -c "$here/solo.rb" -o 'role[workstation]' -l fatal
