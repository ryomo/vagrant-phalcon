#!/bin/bash

MYSQL_ROOT_PASS='pass'
HOME=/home/vagrant

apt-get update
apt-get upgrade -y

# add-apt-repositories
apt-get install -y software-properties-common
# Warning: PHP5.5.9(Ubuntu's default) has some bugs affecting Phalcon routing.
# That's why this repository is needed.
add-apt-repository ppa:ondrej/php5
apt-get update

# Ignore client locale settings.
sed -i 's/AcceptEnv/#AcceptEnv/' /etc/ssh/sshd_config

# tools
apt-get install -y nano git-core

# apache
apt-get install -y apache2
mv /var/www/html/index.html /var/www/html/index.html_backup

# apache settings
a2enmod rewrite
a2enmod ssl
a2ensite default-ssl
# https://help.ubuntu.com/community/ApacheMySQLPHP#Troubleshooting_Apache
echo 'ServerName localhost' > /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn
cp /vagrant/conf/apache.conf /etc/apache2/sites-available/myapache.conf
a2ensite myapache.conf

# PHP
apt-get install -y php5 php5-common php5-mcrypt curl php5-curl
cp /vagrant/conf/php.ini /etc/php5/mods-available/myphp.ini
php5enmod myphp

# MySQL
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS"
apt-get install -y mysql-server php5-mysqlnd
cp /vagrant/conf/mysql.cnf /etc/mysql/conf.d/mysql.cnf
service mysql restart

# phpMyAdmin
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password"
apt-get -y install phpmyadmin
echo "\$cfg['LoginCookieValidity'] = 14400;" >> /etc/phpmyadmin/config.inc.php

# Phalcon
apt-get install -y php5-dev gcc libpcre3-dev re2c
git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd ~/cphalcon/build/
./install
cd ~
rm -rf cphalcon/
echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini
php5enmod phalcon

# Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Phalcon DevTools
mkdir composer
cd ~/composer/
composer require phalcon/devtools:dev-master
cd ~
ln -s /home/vagrant/composer/vendor/phalcon/devtools/phalcon.php /usr/local/bin/phalcon

# auto security update
cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

apt-get autoremove -y

service apache2 restart
