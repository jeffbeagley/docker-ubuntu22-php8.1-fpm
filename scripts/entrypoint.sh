#!/bin/bash

set -e

echo -e "\nEntrypoint of app"
cd ${WEB_ROOT}
echo "[ OK ]"

echo -e '\nStarting rsyslog'
rsyslogd
echo "[ OK ]"
