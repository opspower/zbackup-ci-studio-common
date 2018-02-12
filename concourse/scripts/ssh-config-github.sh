#!/bin/bash

set -e

# hide secrets
set +x

private_key_name="${1,,}"

echo "Setting up github.com ssh config for $private_key_name"

mkdir ~/.ssh 2> /dev/null || true
chmod 700 ~/.ssh

cat >> ~/.ssh/config <<EOF
Host github.com
  User git
  IdentityFile ~/.ssh/$private_key_name
  StrictHostKeyChecking no
EOF
chmod 600 ~/.ssh/config
