#!/usr/bin/env bash

find ./modules/other -name "*.tf" -exec dirname {} + | sort | uniq | while read -r line ; do
  echo "Run test on $line"
  cp ./main_override.tf "$line/main_override.tf"
  cd "$line" || exit
  terraform init
  terraform validate
  cd - || exit
  rm "$line/main_override.tf"
done
