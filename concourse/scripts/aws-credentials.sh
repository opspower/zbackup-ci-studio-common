#!/bin/bash

set -e

# hide secrets
set +x

profile="$1"
aws_access_key_id="${!2}"
aws_secret_access_key="${!3}"

echo "Setting up AWS credentials for $profile"

mkdir ~/.aws 2> /dev/null || true

cat >> ~/.aws/credentials <<EOF
[$profile]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key
EOF

chmod 600 ~/.aws/credentials
