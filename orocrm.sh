clear
echo "==================================== START ===================================="
apt-get install ca-certificates apt-transport-https software-properties-common wget curl lsb-release -y
echo "==================================== Nginx 1.20.2 START ===================================="
apt install git unzip build-essential openssl libssl-dev libpcre3 libpcre3-dev zlib1g zlib1g-dev libgd-dev libxml2 libxml2-dev uuid-dev curl -y
apt update -y
bash <(curl -f -L -sS https://ngxpagespeed.com/install) --nginx-version 1.20.2 -a '--prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module' -y
echo "==================================== Nginx FINISH ===================================="
echo "==================================== PHP 8.1 INSTALL START ===================================="
apt update
apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
apt install php8.1
apt install php8.1-bcmath php8.1-common php8.1-curl php8.1-fpm php8.1-gd php8.1-imap php8.1-intl php8.1-ldap php8.1-mbstring php8.1-mysql php8.1-mongodb php8.1-opcache php8.1-soap php8.1-tidy php8.1-xml php8.1-zip -y
rm -rf /usr/lib/apache2 /usr/lib/php/8.1/sapi/apache2 /usr/share/apache2 /usr/sbin/apache2 /etc/apache2 /etc/php/8.1/apache2 /var/lib/apache2 /var/lib/php/modules/8.1/apache2
apt autoremove apache2 -y
apt purge apache2 -y
apt remove apache2 -y
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
/lib/systemd/systemd-sysv-install enable php8.1-fpm
systemctl enable php8.1-fpm.service
echo "==================================== PHP SETTINGS FINISH ===================================="
echo "==================================== PHP COMPOSER START ===================================="
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
echo "==================================== PHP COMPOSER FINISH ===================================="
echo "==================================== NODE v16 START ===================================="
curl -sL https://deb.nodesource.com/setup_16.x | bash -
apt update -y
apt install nodejs -y
npm -v && node -v
echo "==================================== NODE FINISH ===================================="
echo "==================================== Supervisor START ===================================="
apt update
apt install python3 python3-pip
pip install setuptools
pip install supervisor
echo "==================================== Supervisor FINISH ===================================="
echo "==================================== MySQL 8.0.29 START ===================================="
https://computingforgeeks.com/how-to-install-mysql-8-0-on-debian/
wget https://repo.mysql.com//mysql-apt-config_0.8.22-1_all.deb
dpkg -i mysql-apt-config_0.8.22-1_all.deb
apt update
apt install mysql-server -y
read -p "Enter Root Password : " rootpass
mysql --user=root --password=$rootpass -e "CREATE DATABASE orodb;use orodb;CREATE USER 'orouser'@'localhost' IDENTIFIED BY 'SxdS9NpKKuZU';GRANT ALL PRIVILEGES ON orodb.* TO orouser@'localhost';FLUSH PRIVILEGES;"
echo "==================================== MySQL FINISH ===================================="
echo "==================================== APP START ===================================="
echo "==================================== APP FINISH ===================================="