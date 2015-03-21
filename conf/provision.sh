#!/bin/bash

# My phalcon app's testing results.
# pass PHP 5.4.38-1+deb.sury.org~precise+2 (cli) (built: Feb 20 2015 12:16:47)
# fail PHP 5.6.6-1+deb.sury.org~trusty+1 (cli) (built: Feb 20 2015 11:22:10)
# fail PHP 5.5.9-1ubuntu4.6 (cli) (built: Feb 13 2015 19:17:11)

MYSQL_ROOT_PASS='pass'

apt-get update
apt-get upgrade -y

# add-apt-repositories
apt-get install -y software-properties-common
add-apt-repository ppa:ondrej/php5
# add-apt-repository ppa:ondrej/php5-oldstable
# add-apt-repository ppa:ondrej/php5-5.6
# apt-add-repository ppa:phalcon/stable
apt-get update

# timezone
echo 'Asia/Tokyo' > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# locale
locale-gen ja_JP.UTF-8
update-locale LANG=ja_JP.UTF-8

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

# PHP(php5.5.9 has a routing bug)
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

# # Phalcon from repository
# apt-get install -y php5-phalcon

# Phalcon Compile
apt-get install -y php5-dev gcc libpcre3-dev
git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd cphalcon/build/
./install
cd /home/vagrant
rm -rf cphalcon/
echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini
php5enmod phalcon

# Composer(global)
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Phalcon DevTools(home)
mkdir composer
cd composer/
composer require phalcon/devtools:dev-master
cd /home/vagrant
ln -s /home/vagrant/composer/vendor/phalcon/devtools/phalcon.php /usr/local/bin/phalcon

# auto security update
cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

service apache2 restart
