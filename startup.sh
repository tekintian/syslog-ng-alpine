#!/bin/sh
set -ex

false | cp -i /app/syslog-ng.conf /etc/syslog-ng/ 2>/dev/null


directories="/etc/syslog-ng/ /var/run/syslog-ng/ /var/log/syslog-ng/"
fpm="0644"
dpm="0755"

for directory in $directories; do
    find "$directory" -type d -exec chmod $dpm {} \;
    find "$directory" -type f -exec chmod $fpm {} \;
done