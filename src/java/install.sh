#!/bin/sh
scripts="$(realpath $(dirname $0))"
temurin=/opt/hbdesiato.github.io/temurin
mkdir -p "$temurin"
cd "$temurin"
"$scripts/dl-temurin-bundle.sh"
rm *.tgz *.tgz.checksum

gradle=/opt/hbdesiato.github.io/gradle
mkdir -p "$gradle"
cd "$gradle"
"$scripts/dl-gradle-current.sh"
rm *.zip *.zip.checksum
ln -s /opt/hbdesiato.github.io/gradle/current/bin/gradle /usr/local/bin/gradle

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh
