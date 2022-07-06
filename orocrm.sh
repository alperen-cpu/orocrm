clear
echo "==================================== START ===================================="
apt-get install ca-certificates apt-transport-https software-properties-common wget curl lsb-release -y
echo "==================================== PHP INSTALL START ===================================="
wget https://packages.sury.org/php/apt.gpg && apt-key add apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update && apt install -y php8.1
apt install php8.1 php8.1-bcmath php8.1-common php8.1-curl php8.1-fpm php8.1-gd php8.1-imap php8.1-intl php8.1-ldap php8.1-mbstring php8.1-mysql php8.1-mongodb php8.1-opcache php8.1-soap php8.1-tidy php8.1-xml php8.1-zip -y &&
php --modules
php -v &&
echo "==================================== PHP INSTALL FINISH ===================================="
echo "==================================== PHP SETTINGS START ===================================="
sed -i 's#;date.timezone =#date.timezone = Europe/Istanbul#' /etc/php/8.1/fpm/php.ini
sed -i 's#;date.timezone =#date.timezone = Europe/Istanbul#' /etc/php/8.1/cli/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1G/' /etc/php/8.1/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php/8.1/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php/8.1/cli/php.ini
echo 'detect_unicode = Off' | tee -a /etc/php/8.1/fpm/php.ini
echo 'detect_unicode = Off' | tee -a /etc/php/8.1/cli/php.ini
sed -i 's/opcache.enable=1/opcache.enable=1/' /etc/php/8.1/fpm/php.ini
sed -i 's/opcache.enable_cli=0/opcache.enable_cli=0/' /etc/php/8.1/fpm/php.ini
sed -i 's/opcache.memory_consumption=128/opcache.memory_consumption=512/' /etc/php/8.1/fpm/php.ini
sed -i 's/opcache.max_accelerated_files=10000/opcache.max_accelerated_files=65407/' /etc/php/8.1/fpm/php.ini
sed -i 's/opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=32/' /etc/php/8.1/fpm/php.ini
sed -i 's/realpath_cache_size=4096K/realpath_cache_size=4096K/' /etc/php/8.1/fpm/php.ini
sed -i 's/realpath_cache_ttl = 120/realpath_cache_ttl=600/' /etc/php/8.1/fpm/php.ini
sed -i 's/opcache.save_comments=1/opcache.save_comments=1/' /etc/php/8.1/fpm/php.ini
sed -i 's/opcache.validate_timestamps=1/opcache.validate_timestamps=0/' /etc/php/8.1/fpm/php.ini
sed -i 's/opcache.enable_cli=0/opcache.enable_cli=0/' /etc/php/8.1/cli/php.ini
sed -i 's/pm.max_children = 5/pm.max_children = 128/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/pm.start_servers = 2/pm.start_servers = 8/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 4/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 8/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/;pm.max_requests = 500/pm.max_requests = 512/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/;catch_workers_output = yes/catch_workers_output = yes/' /etc/php/8.1/fpm/pool.d/www.conf
systemctl start php8.1-fpm.service
systemctl enable php8.1-fpm.service
echo "==================================== PHP SETTINGS FINISH ===================================="
echo "==================================== PHP COMPOSER START ===================================="
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
composer -V
echo "==================================== PHP COMPOSER FINISH ===================================="
echo "==================================== NODE START ===================================="
curl --silent --location https://deb.nodesource.com/setup_18.x | bash -
apt install nodejs -y
node -v
echo "==================================== NODE FINISH ===================================="
echo "==================================== Supervisor START ===================================="
apt install supervisor
supervisord -v
echo "==================================== Supervisor FINISH ===================================="
echo "==================================== MySQL START ===================================="
#maridb 10.8 install
#apt-get install apt-transport-https curl
#curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
#sh -c "echo 'deb https://mirror.truenetwork.ru/mariadb/repo/10.8/debian bullseye main' >>/etc/apt/sources.list"
#apt-get update
#apt-get install mariadb-server -y
read -p "enter mysql root password : " dbpass
mysql --user=root --password=$dbpass -e 'CREATE DATABASE orodb;'
mysql --user=root --password=$dbpass -e 'CREATE USER 'orouser'@'localhost' IDENTIFIED BY 'KHNUVA6P';'
mysql --user=root --password=$dbpass -e 'GRANT ALL PRIVILEGES ON orodb.* TO 'orouser'@'localhost';'
mysql --user=root --password=$dbpass -e 'flush privileges;'
mysql --user=root --password=$dbpass -e 'show databases;'
mysql --user=root --password=$dbpass -e 'exit;'
#root şifresi mevcut değil ise eğer,
#mysql -uroot -p -e 'CREATE DATABASE orodb;'
#mysql -uroot -p -e 'CREATE USER 'orouser'@'localhost' IDENTIFIED BY 'KHNUVA6P';'
#mysql -uroot -p -e 'GRANT ALL PRIVILEGES ON orodb.* TO 'orouser'@'localhost';'
echo "==================================== MySQL FINISH ===================================="
echo "==================================== Nginx START ===================================="
apt-get install nginx -y
systemctl start nginx
systemctl enable nginx
echo "==================================== Nginx FINISH ===================================="
echo "==================================== APP START ===================================="
git clone -b https://github.com/oroinc/crm-application.git crm.google.com
rmdir /var/www/crm.google.com
mv /home/orosa/crm.google.com /var/www/
chown -R orosa:orosa /var/www/crm.google.com
php app/console oro:install --env=prod
echo "==================================== APP FINISH ===================================="






