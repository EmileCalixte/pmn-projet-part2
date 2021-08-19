#!/bin/sh

chown -R www-data:www-data /var/www/html/htdocs/conf
chown -R www-data:www-data /var/www/html/documents
exec apachectl -D FOREGROUND
