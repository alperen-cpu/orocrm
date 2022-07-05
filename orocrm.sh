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
echo "==================================== PHP SETTINGS FINISH ===================================="










nano /etc/php/8.1/fpm/php.ini


echo "==================================== PHP COMPOSER START ===================================="
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
echo "==================================== PHP COMPOSER FINISH ===================================="
echo "==================================== NODE START ===================================="
curl --silent --location https://deb.nodesource.com/setup_18.x | bash -
apt install nodejs
echo "==================================== NODE FINISH ===================================="
echo "==================================== APP START ===================================="
cd /var/www/html/
git clone https://github.com/oroinc/crm-application.git
cd orocrm
composer install --prefer-dist --no-dev
php app/console oro:install --env=prod
chown -R www-data:www-data /var/www/html/orocrm/
chmod -R 755 /var/www/html/orocrm/
echo "==================================== APP FINISH ===================================="
