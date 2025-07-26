#!/bin/sh
scripts="$(realpath $(dirname $0))"
export DL_TOOLS=/opt/dl-tools
tools_bin="$DL_TOOLS/bin"
mkdir -p "$tools_bin"

"$scripts/dl-temurin-bundle"

"$scripts/dl-gradle-current"
ln -s "$DL_TOOLS/gradle/current/bin/gradle" "$tools_bin/gradle"

for script in "$scripts"/dl-*; do
    ln -s "$script" "$tools_bin/$(basename "$script")"
done

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh
