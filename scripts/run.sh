#!/bin/bash

set -e

while ! nc -z ${CMS_HOST} 22; do
  echo "waiting for wordpress listening..."
  sleep 0.25
done
echo "WordPress started"

# prepare and restore wp files
/scripts/restore.sh

# make env accessible to cron
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

# install crontab
sed -e "s#\${BACKUP_SCHEDULE}#$BACKUP_SCHEDULE#" /crontab > /etc/cron.d/scheduler
chmod +x /etc/cron.d/scheduler
crontab /etc/cron.d/scheduler

echo "Starting cron"
cron -f
