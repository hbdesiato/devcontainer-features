#!/bin/sh
url="https://api.adoptium.net/v3/info/available_releases"
echo "getting: $url"
releases=$(curl "$url")
latest=$(echo "$releases" | jq -r .most_recent_feature_release)
# latest=21
latest_name=$("$(dirname $0)/dl-temurin.sh" "$latest")
rm -f latest
ln -s "$latest_name" latest

stable=$(echo "$releases" | jq -r .most_recent_lts)
if [ "$latest" == "$stable" ]; then
    stable=$(echo $releases | jq "[.available_lts_releases[] | select(. < $stable)] | max")
fi
stable_name=$("$(dirname $0)/dl-temurin.sh" "$stable")
rm -f stable
ln -s "$stable_name" stable
