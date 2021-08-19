#!/bin/bash

chown -R www-data:www-data /var/www/html/
chmod -R 777 /var/www/html/
apachectl -D FOREGROUND
