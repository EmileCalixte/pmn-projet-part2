FROM debian:buster

RUN apt update && \
    apt install -y apache2 php7.3 libapache2-mod-php7.3 php7.3-gd php7.3-curl php7.3-zip php7.3-intl

COPY dolibarr /var/www/html
COPY vhost-apache-dolibarr.conf /etc/apache2/sites-available/

RUN rm -rf /var/www/html/.git && \
    touch /var/www/html/htdocs/conf/conf.php && \
    chown -R www-data:www-data /var/www/html/ && \
    rm /etc/apache2/sites-available/000-default.conf && \
    rm /etc/apache2/sites-enabled/000-default.conf && \
    a2ensite vhost-apache-dolibarr

COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
