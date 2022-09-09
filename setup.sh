#!/bin/bash
# Author: Alperen Sah
#Date 08.09.2022
clear
PHP_VERSION=8.1
apt update -y
echo "===================== OroCRM Sample Application 5.0 Installation https://github.com/oroinc/crm-application ====================="
echo "===================== Author: Alperen Sah Abursum | github.com/alperen-cpu ====================="
echo "==================================== START ===================================="
apt-get install sudo zlib1g zlib1g-dev libgd-dev libxml2 libxml2-dev uuid-dev curl libpcre3 libpcre3-dev libssl-dev openssl ca-certificates apt-transport-https software-properties-common wget curl lsb-release gnupg2 unzip build-essential -y
echo "==================================== Nginx 1.23.0 START ===================================="
#https://www.nginx.com/resources/wiki/start/topics/tutorials/install/
#https://nginx.org/en/linux_packages.html#Debian
apt update -y
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

apt update -y

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx  

apt update -y
apt install nginx -y
service nginx stop
echo "==================================== Nginx 1.23.0 FINISH ===================================="
echo "==================================== PHP $PHP_VERSION INSTALL START ===================================="
apt-get install software-properties-common
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update -y
apt-get install php$PHP_VERSION php$PHP_VERSION-fpm -y
apt-get install php8.1-curl -y &&
apt-get install php8.1-dom -y &&
apt-get install php8.1-simplexml -y &&
apt-get install php8.1-xml -y &&
apt-get install php8.1-zip -y &&
apt-get install php8.1-gd -y &&
apt-get install php8.1-intl -y
apt update -y
echo "==================================== PHP INSTALL FINISH ===================================="
echo "==================================== PHP SETTINGS START ===================================="
sed -i 's#;date.timezone =#date.timezone = Europe/Istanbul#' /etc/php/$PHP_VERSION/fpm/php.ini
sed -i 's#;date.timezone =#date.timezone = Europe/Istanbul#' /etc/php/$PHP_VERSION/cli/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1G/' /etc/php/$PHP_VERSION/fpm/php.ini
sed -i 's/realpath_cache_ttl = 120/realpath_cache_ttl=600/' /etc/php/$PHP_VERSION/fpm/php.ini
sed -i 's/listen.owner \= www-data/listen.owner \= nginx/g' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/listen.group \= www-data/listen.group \= nginx/g' /etc/php/8.1/fpm/pool.d/www.conf
service php8.1-fpm restart
echo "==================================== PHP SETTINGS FINISH ===================================="
echo "==================================== PHP COMPOSER START ===================================="
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
echo "==================================== PHP COMPOSER FINISH ===================================="
echo "==================================== NODE v16 START ===================================="
curl -sL https://deb.nodesource.com/setup_16.x | bash -
apt update -y
apt-get install -y nodejs
npm -v && node -v
echo "==================================== NODE v16 FINISH ===================================="
echo "==================================== Supervisor START ===================================="
apt update
apt install python3 python3-pip -y
pip install setuptools
pip install supervisor
echo "==================================== Supervisor FINISH ===================================="
echo "==================================== MySQL 8.0.29 START ===================================="
#https://computingforgeeks.com/how-to-install-mysql-8-0-on-debian/
wget https://repo.mysql.com//mysql-apt-config_0.8.22-1_all.deb
dpkg -i mysql-apt-config_0.8.22-1_all.deb
apt update
apt install mysql-server -y
stty -echo
read -p "Enter Root MYSQL Password : " rootpass
read -p "Enter New User Password: " newpass
stty echo
mysql --user=root --password=$rootpass -e "CREATE DATABASE orodb;use orodb;CREATE USER 'orouser'@'localhost' IDENTIFIED BY '$newpass';GRANT ALL PRIVILEGES ON orodb.* TO orouser@'localhost';FLUSH PRIVILEGES;"
echo "==================================== MySQL 8.0.29 FINISH ===================================="
echo "==================================== APP START ===================================="
cd /usr/share/nginx/html/
git clone -b 5.0 https://github.com/oroinc/crm-application.git orocrm
cd orocrm
composer install --prefer-dist --no-dev
echo "==================================== APP FINISH ===================================="

