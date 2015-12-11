#!/bin/bash

PHALCON_BRANCH='2.1.x'
MYSQL_ROOT_PASS='pass'

# Set $HOME.
HOME=/home/vagrant
cd ~

apt-get update
apt-get upgrade -y

# Add repositories
apt-get install -y software-properties-common
# PHP5.6.x repository
add-apt-repository ppa:ondrej/php5-5.6
# Jenkins repository
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
echo 'deb http://pkg.jenkins-ci.org/debian binary/' > /etc/apt/sources.list.d/jenkins.list
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
apt-get install -y php5 php5-common php5-mcrypt curl php5-curl php5-xdebug
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

# memcached
apt-get -y install php5-memcached memcached

# Jenkins
apt-get install -y jenkins
# Enable sudo in Jenkins
echo 'jenkins ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/jenkins

# Phalcon
apt-get install -y php5-dev gcc libpcre3-dev re2c
git clone -b $PHALCON_BRANCH --depth=1 git://github.com/phalcon/cphalcon.git
cd ~/cphalcon/build/
./install
cd ~
rm -rf cphalcon/
echo 'extension=phalcon.so' > /etc/php5/mods-available/phalcon.ini
php5enmod phalcon

# Zephir
git clone https://github.com/phalcon/zephir
cd zephir
./install-json
./install -c
cd ~

# Composer(global)
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
echo 'PATH="$HOME/.composer/vendor/bin:$PATH"' >> .profile
echo 'Defaults !secure_path' > /etc/sudoers.d/00-keep-env-path
echo 'Defaults env_keep+="PATH"' >> /etc/sudoers.d/00-keep-env-path

# Phalcon DevTools
composer global require phalcon/devtools:dev-master
ln -s /home/vagrant/.composer/vendor/bin/phalcon.php /home/vagrant/.composer/vendor/bin/phalcon

# Codeception
composer global require codeception/codeception

# auto security update
cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

chown -R vagrant:vagrant $HOME

apt-get autoremove -y

service apache2 restart
