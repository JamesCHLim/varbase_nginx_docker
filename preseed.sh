#!/bin/bash
set -eux

CONTAINER_NAME="${1:=james/varbase-base:0.1}"

for folder in "modules" "profiles" "sites" "themes"
do
    docker run --rm "$1" tar -cC "/var/www/html/${folder}" . | tar -xC "./drupal/${folder}"
done
