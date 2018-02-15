#!/bin/bash

set -e

# hide secrets
set +x

profile="${1:-chef-cd}"
region="${AWS_DEFAULT_REGION:-us-west-2}"

echo "Setting up AWS config for $profile"

mkdir ~/.aws 2> /dev/null || true

cat >> ~/.aws/config <<EOF
[profile $profile]
region = $region
EOF

chmod 600 ~/.aws/config
