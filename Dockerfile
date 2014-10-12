FROM ubuntu:trusty

RUN locale-gen pt_BR.UTF-8  
ENV LANG pt_BR.UTF-8  
ENV LANGUAGE pt_BR:pt  
ENV LC_ALL pt_BR.UTF-8  


MAINTAINER Eduardo Junior <ej@eduardojunior.com>

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 php5 supervisor php5-intl php5-mysql mysql-server phpmyadmin php5-mcrypt

# extension mcrypt
#RUN mv -i /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available/
RUN php5enmod mcrypt

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
#RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
#ENV APACHE_RUN_USER www-data
#ENV APACHE_RUN_GROUP www-data
#ENV APACHE_LOG_DIR /var/log/apache2
#ENV APACHE_LOCK_DIR /var/lock/apache2
#ENV APACHE_PID_FILE /var/run/apache2.pid


# Copy site into place.
#ADD www /var/www/site

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf



# Scripts
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-apache2.sh /supervisord-apache2.sh
#ADD supervisord-postgresql.conf /etc/supervisor/conf.d/supervisord-postgresql.conf
#ADD supervisord-postgresql.sh /supervisord-postgresql.sh
ADD start.sh /start.sh
RUN chmod 755 /*.sh
    

EXPOSE 80 3306

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/app"]

CMD ["/start.sh"]