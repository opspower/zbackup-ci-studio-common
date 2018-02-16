#!/bin/bash

set -ex

hab install --binlink core/terraform

cd "$TF_MAKE_DIRECTORY"
make "$TF_MAKE_TARGET"
