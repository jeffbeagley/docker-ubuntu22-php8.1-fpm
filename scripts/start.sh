#!/bin/bash

set -e

# Run entrypoint script
/bin/bash /bootstrap/entrypoint.sh

echo -e "\nStarting Webserver..."

/etc/init.d/php8.1-fpm start && /usr/sbin/apache2ctl -DFOREGROUND
