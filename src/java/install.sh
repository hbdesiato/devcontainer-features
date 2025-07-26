#!/bin/sh
set -e
scripts="$(realpath $(dirname $0))"
export DL_TOOLS=/opt/dl-tools
tools_bin="$DL_TOOLS/bin"
mkdir -p "$tools_bin"

if [ "$GRAALVM" = "true" ]; then
    jdk_latest=$("$scripts/dl-graalvm-latest")
else
    jdk_latest=$("$scripts/dl-temurin-latest")
fi
gradle_jdk_paths="org.gradle.java.installations.paths=$jdk_latest"

jdk_stable=$("$scripts/dl-temurin-stable")

gradle_current=$("$scripts/dl-gradle-current")
ln -s "$gradle_current/bin/gradle" "$tools_bin/gradle"

user_home=$( getent passwd $USERNAME | cut -d: -f6 )
gradle_user_home="$user_home/.gradle"
mkdir -p "$gradle_user_home"
echo "org.gradle.java.installations.paths=$jdk_latest" >> "$gradle_user_home/gradle.properties"

for script in "$scripts"/dl-*; do
    ln -s "$script" "$tools_bin/$(basename "$script")"
done

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=$tools_bin:$jdk_latest/bin:${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
echo "export JAVA_HOME=$jdk_stable" >> /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh
