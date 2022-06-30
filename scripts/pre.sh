#!/bin/bash

set -exu

echo "==> Install Ansible"
apt -y update
apt -y install ansible

echo "==> Add user airmobisim to password-less sudoers"
echo "airmobisim        ALL=(ALL)        NOPASSWD: ALL" > /etc/sudoers.d/airmobisim

echo "==> Create directories to hold uploaded files"
mkdir -p ~airmobisim/src; chown airmobisim:airmobisim ~airmobisim/src
mkdir -p ~airmobisim/Documents; chown airmobisim:airmobisim ~airmobisim/Documents
