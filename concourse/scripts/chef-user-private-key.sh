#!/bin/bash

set -e

# hide secrets
set +x

private_key_name="${1,,}"
private_key="${!1}"

echo "Setting up chef private key for $private_key_name"

mkdir ~/.chef 2> /dev/null || true

echo "$private_key" > ~/.chef/"$private_key_name"
chmod 400 ~/.chef/"$private_key_name"
