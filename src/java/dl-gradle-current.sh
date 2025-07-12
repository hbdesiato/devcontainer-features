#!/bin/sh
set -e
url="https://services.gradle.org/versions/current"
echo "getting: $url" >&2
current=$(curl "$url")
version=$(echo "$current" | jq -r .version)
current_name=$("$(dirname $0)/dl-gradle.sh" "$version")
rm -f current
ln -s "$current_name" current
