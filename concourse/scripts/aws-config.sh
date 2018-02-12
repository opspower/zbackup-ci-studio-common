#!/bin/bash

set -e

# hide secrets
set +x

profile="$1"
region="$2"

echo "Setting up AWS config for $profile"

mkdir ~/.aws 2> /dev/null || true

cat >> ~/.aws/config <<EOF
[profile $profile]
region = $region
EOF

chmod 600 ~/.aws/config
