#!/bin/bash

set -e

# hide secrets
set +x

private_key_name="${1,,}"
private_key="${!1}"

echo "Setting up ssh private key for $private_key_name"

mkdir ~/.ssh 2> /dev/null || true
chmod 700 ~/.ssh

echo "$private_key" > ~/.ssh/"$private_key_name"
chmod 400 ~/.ssh/"$private_key_name"
