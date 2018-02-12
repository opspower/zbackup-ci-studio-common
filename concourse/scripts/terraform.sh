#!/bin/bash

set -ex

hab install --binlink core/terraform

echo cd "$TF_MAKE_DIRECTORY"
echo make "$TF_MAKE_TARGET"
