FROM debian:buster

RUN apt update && \
    apt install -y apache2 php7.3 libapache2-mod-php7.3 php7.3-gd php7.3-curl php7.3-zip php7.3-intl wget unzip php7.3-mysql && \
    rm -rf /var/www/html/* && \
    wget https://github.com/Dolibarr/dolibarr/archive/refs/tags/14.0.1.zip && \
    unzip 14.0.1.zip -d /usr/src && \
    mv /usr/src/dolibarr-14.0.1/* /var/www/html/

COPY vhost-apache-dolibarr.conf /etc/apache2/sites-available/

RUN chown -R www-data:www-data /var/www/html/ && \
    rm /etc/apache2/sites-available/000-default.conf && \
    rm /etc/apache2/sites-enabled/000-default.conf && \
    a2ensite vhost-apache-dolibarr

COPY entrypoint.sh /

RUN chmod +x entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
