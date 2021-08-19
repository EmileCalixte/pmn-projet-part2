FROM debian:buster

RUN apt update && \
    apt install -y apache2 php7.3

COPY dolibarr /var/www/html
COPY vhost-apache-dolibarr.conf /etc/apache2/sites-available/

RUN rm -rf /var/www/html/.git && \
    touch /var/www/html/htdocs/conf/conf.php && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 777 /var/www/html/ && \
    rm /etc/apache2/sites-available/000-default.conf && \
    rm /etc/apache2/sites-enabled/000-default.conf && \
    a2ensite vhost-apache-dolibarr

COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["apachectl", "-D", "FOREGROUND"]
