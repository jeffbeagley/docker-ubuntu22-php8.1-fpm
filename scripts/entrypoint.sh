#!/bin/bash

set -e

echo -e "\nEntrypoint of app"
cd ${WEB_ROOT}
echo -e "[ OK ]"

echo -e '\nStarting rsyslog'
rsyslogd
echo -e "[ OK ]"
