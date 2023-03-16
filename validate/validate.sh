#!/usr/bin/env bash

set -e

find ./modules -name "*.tf" -exec dirname {} + | sort | uniq | while read -r line ; do
  echo
  echo "================================================================================================"
  echo
  echo "Run test on $line"
  cp ./validate/main_override.tf.dist "$line/main_override.tf"
  cd "$line" || exit
  terraform init
  terraform validate
  cd - || exit
  rm "$line/main_override.tf"
done
