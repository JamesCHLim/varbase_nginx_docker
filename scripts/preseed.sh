#!/bin/bash
set -eux

CONTAINER_NAME="${1:-james/varbase-base:0.1}"
#CONTAINER_NAME="james/varbase-base:0.1"

for folder in "modules" "profiles" "sites" "themes"
do
    mkdir -p "./drupal/${folder}"
    docker run --rm "$CONTAINER_NAME" tar -cC "/var/www/html/${folder}" . | tar -xC "./drupal/${folder}"
done
