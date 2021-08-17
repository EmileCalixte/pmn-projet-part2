FROM debian:buster

RUN apt update && \
    apt install -y apache2 php7.3

COPY dolibarr /app
COPY vhost-apache-dolibarr.conf /etc/apache2/sites-available/

RUN rm -rf /app/.git && \
    touch /app/htdocs/conf/conf.php && \
    chown -R www-data:www-data /app/ && \
    chmod -R 777 /app/ && \
    rm /etc/apache2/sites-available/000-default.conf && \
    rm /etc/apache2/sites-enabled/000-default.conf && \
    a2ensite vhost-apache-dolibarr

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
