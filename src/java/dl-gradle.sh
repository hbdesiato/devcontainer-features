#!/bin/sh
set -e
version="$1"
release_name="gradle-$version"
archive_file="${release_name}-bin.zip"
checksum_file="${archive_file}.checksum"
link="https://services.gradle.org/distributions/$archive_file"
checksumUrl="https://services.gradle.org/distributions/${archive_file}.sha256"
echo "getting: $checksumUrl" >&2
checksum=$(curl -L "$checksumUrl")
echo "$checksum *$archive_file" > "$checksum_file"
[ ! -e "$archive_file" ] || sha256sum -c "$checksum_file" >&2 || rm -f "$archive_file"
if [ ! -e "$archive_file" ]; then
    rm -rf "$release_name"
    echo "downloading: $link" >&2
    curl -Lo "$archive_file" "$link"
    sha256sum -c "$checksum_file" >&2
    unzip "$archive_file" >/dev/null
fi
echo "$release_name"
