#!/usr/bin/env bash

set -e

find ./modules -name "*.tf" -exec dirname {} + | sort | uniq | while read -r line ; do
  echo ""
  echo "================================================================================================"
  echo ""
  echo "Run test on $line"
  cp ./validate/temp_local_backend.tf.dist "$line/temp_local_backend.tf"
  cd "$line" || exit
  terraform init
  terraform validate
  cd - || exit
  rm "$line/temp_local_backend.tf"
done
