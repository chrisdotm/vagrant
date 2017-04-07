#!/bin/sh

mkdir -p /var/www/html && cd /var/www/html
git clone https://github.com/twostairs/paperwork.git
cd /var/www/html/paperwork/frontend
curl -sS https://getcomposer.org/installer | php
php composer.phar install

cd /var/www/html/paperwork/frontend
php artisan migrate # Type yes

npm install

bower install
gulp

chown -R nginx:nginx /var/www/html
