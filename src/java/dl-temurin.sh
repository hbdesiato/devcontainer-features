#!/bin/sh
set -e
release="$1"
url="https://api.adoptium.net/v3/assets/latest/$release/hotspot?architecture=x64&image_type=jdk&os=linux&vendor=eclipse"
echo "getting: $url" >&2
assets=$(curl "$url")
release_name=$(echo "$assets" | jq -r .[0].release_name)
archive_file="${release_name}.tgz"
checksum_file="${archive_file}.checksum"
link=$(echo "$assets" | jq -r .[0].binary.package.link)
checksum=$(echo "$assets" | jq -r .[0].binary.package.checksum)
echo "$checksum *$archive_file" > "$checksum_file"
[ ! -e "$archive_file" ] || sha256sum -c "$checksum_file" >&2 || rm "$archive_file"

if [ ! -e "$archive_file" ]; then
    rm -rf "$release_name"
    echo "downloading: $link" >&2
    curl -Lo "$archive_file" "$link"
    sha256sum -c "$checksum_file" >&2
    tar xzf "$archive_file"
fi
echo "$release_name"
