echo "==================================== START ===================================="
apt-get install ca-certificates apt-transport-https software-properties-common wget curl lsb-release -y
echo "==================================== PHP INSTALL START ===================================="
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list &&
wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - &&
apt update -y && apt install php8.1 && apt install php8.1-mysql &&
apt install php8.1-{bcmath,fpm,xml,mysql,zip,intl,ldap,gd,cli,bz2,curl,mbstring,pgsql,opcache,soap,cgi}
php --modules
echo "==================================== PHP INSTALL FINISH ===================================="
echo "==================================== PHP SETTINGS START ===================================="
sed -i 's#;date.timezone =#date.timezone = Europe/Istanbul#' /etc/php/8.1/fpm/php.ini
sed -i 's#;date.timezone =#date.timezone = Europe/Istanbul#' /etc/php/8.1/cli/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1G/' /etc/php/8.1/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php/8.1/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php/8.1/cli/php.ini
echo 'detect_unicode = Off' | tee -a /etc/php/8.1/fpm/php.ini
echo 'detect_unicode = Off' | tee -a /etc/php/8.1/cli/php.ini
echo "==================================== PHP SETTINGS FINISH ===================================="
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
