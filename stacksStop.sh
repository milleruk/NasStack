#!/bin/bash

for file in $PWD/enabled/stacks/*.yml; do
  filename=$(basename -- "$file")
  name="${filename%.*}"
  docker-compose -p "$name" -f stacks/enabled/$filename down -d
done