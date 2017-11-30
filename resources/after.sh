#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

#
## Global setup
#
# Avoid apt-get calls to be interactive
export DEBIAN_FRONTEND=noninteractive

# Avoid mysql commands to show a warning for using an inline password
echo "secret" > mysql_config_editor set --login-path=local --host=localhost --user=homestead --password

# Set global output colors
NC="\033[0m"
WHITE="\033[0;0m"
GREEN="\033[0;37m"
WHITE_ON_PURPLE="\033[37;45m"
WHITE_ON_GREEN="\033[37;42m"

#
## Functions
#
displayTitle () {
    echo " "
    echo " "
    echo " "
    echo "${WHITE_ON_PURPLE}  $1  ${NC}"
    echo " "
}

displayOkMessage () {
    echo " "
    echo "${WHITE_ON_GREEN}  OK  ${NC}"
}

displayMessage () {
    echo "${WHITE}$1${NC}"
}

displaySpacedMessage () {
    echo " "
    displayMessage "$1"
}

displayServerInfo () {
    echo " "
    echo " "
    echo " "
    displayMessage "--------------------------------------"
    echo "${WHITE_ON_GREEN}  ALL READY!  ${NC}"
    echo " "

    displayMessage "bower version: `bower -v`"
    displayMessage "composer version: `composer -V | grep -Po '\d+(\.\d+)+'`"
    displayMessage "php version: `php -v | grep -Po 'PHP \d+(\.\d+)+' | sed -e 's/PHP //'`"
    displayMessage "mysql version: `mysql -Vmysql -V | grep -Po 'Distrib \d+(\.\d+)+' | sed -e 's/Distrib //g'`"
    displayMessage "node version: `node -v`"
    displayMessage "npm version: `npm -v`"
    displaySpacedMessage "java version: "
    java -version
    displayMessage "--------------------------------------"
}

#
## Install missing dependencies
#
displayTitle "Installing missing dependencies"

apt-get -o Dpkg::Options::="--force-confnew" install -y php7.0-bz2 php7.0-mcrypt php7.0-gmp php7.0-xdebug php7.1-bz2 php7.1-mcrypt php7.1-gmp php7.1-xdebug

displayOkMessage

#
## Fix global MySQL configuration for Craft CMS
#
displayTitle "MySQL configuration"

displaySpacedMessage "Fixing global MySQL configuration for Craft CMS..."
mysql --login-path=local  -e "SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';"

displayOkMessage

#
## Copying Configurations
#

displayTitle "Copying Configurations"

displaySpacedMessage "Copying elasticsearch.yml (ES config)..."
cp /home/vagrant/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

displaySpacedMessage "Copying PHP Configurations"
cp --force /home/vagrant/config/php.ini /etc/php/7.0/cli/php.ini
cp --force /home/vagrant/config/php.ini /etc/php/7.1/cli/php.ini
cp --force /home/vagrant/config/php.ini /etc/php/7.2/cli/php.ini

displaySpacedMessage "Copying PHP Configurations for Craft CMS"
cp --force /home/vagrant/config/craftConfig.ini /etc/php/7.0/mods-available/craftConfig.ini
cp --force /home/vagrant/config/craftConfig.ini /etc/php/7.1/mods-available/craftConfig.ini
cp --force /home/vagrant/config/craftConfig.ini /etc/php/7.2/mods-available/craftConfig.ini
rm /etc/php/7.0/fpm/conf.d/100-craftConfig.ini && ln -s /etc/php/7.0/mods-available/craftConfig.ini /etc/php/7.0/fpm/conf.d/100-craftConfig.ini
rm /etc/php/7.1/fpm/conf.d/100-craftConfig.ini && ln -s /etc/php/7.1/mods-available/craftConfig.ini /etc/php/7.1/fpm/conf.d/100-craftConfig.ini
rm /etc/php/7.2/fpm/conf.d/100-craftConfig.ini && ln -s /etc/php/7.2/mods-available/craftConfig.ini /etc/php/7.2/fpm/conf.d/100-craftConfig.ini

displayOkMessage

#
## Restarting Elasticsearch
#
displayTitle "Restarting elasticsearch"

/etc/init.d/elasticsearch restart

displayOkMessage

#
## Restarting PHP FPM
#
displayTitle "Restarting php-fpm"

/etc/init.d/php7.0-fpm restart
/etc/init.d/php7.1-fpm restart
/etc/init.d/php7.2-fpm restart

displayOkMessage

#
## Restarting nginx
#
displayTitle "Restarting nginx server"

/etc/init.d/nginx restart

displayOkMessage

#
## End
#
displayServerInfo
