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

# Constants
ES_PORT=9200

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
    displayMessage "elasticsearch version: `curl -s -XGET http://localhost:$ES_PORT | grep -E \"\\\"number\\\"\" | grep -Po '\d+(\.\d+)+'`"
    displayMessage "php version: `php -v | grep -Po 'PHP \d+(\.\d+)+' | sed -e 's/PHP //'`"
    displayMessage "mysql version: `mysql -Vmysql -V | grep -Po 'Distrib \d+(\.\d+)+' | sed -e 's/Distrib //g'`"
    displayMessage "node version: `node -v`"
    displayMessage "npm version: `npm -v`"
    displaySpacedMessage "java version: "
    java -version
    displayMessage "--------------------------------------"
}

#
## Manage current packages
#
displayTitle "Update current packages"

dpkg --configure -a --force-confnew
apt-get -o Dpkg::Options::="--force-confnew" update --fix-missing -y

displayOkMessage

#
## Install missing dependencies
#
displayTitle "Installing missing dependencies"

apt-get -o Dpkg::Options::="--force-confnew" install -y php7.1-fpm php7.1-bz2 php7.1-mcrypt php7.1-gmp php7.1-xdebug

displayOkMessage

#
## Fix global MySQL configuration for Craft CMS
#
displayTitle "MySQL configuration"

displaySpacedMessage "Fixing global MySQL configuration for Craft CMS..."
mysql --login-path=local  -e "SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';"

displayOkMessage

#
## Install Java
#
displayTitle "Installing Java"

apt-get -o Dpkg::Options::="--force-confnew" install -y default-jre

displaySpacedMessage "Export JAVA_HOME environment variable"
export JAVA_HOME="/usr/bin/java"

displayOkMessage

#
## Install ElasticSearch
#
displayTitle "Installing ElasticSearch"

displaySpacedMessage "Download and install PGP public signing key..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

displaySpacedMessage "Installing missing dependencies..."
apt-get -o Dpkg::Options::="--force-confnew" install -y apt-transport-https

displaySpacedMessage "Saving repository definition..."
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list

displaySpacedMessage "Installing ElasticSearch..."
apt-get -o Dpkg::Options::="--force-confnew" update -y && apt-get -o Dpkg::Options::="--force-confnew" install -y elasticsearch

displaySpacedMessage "Copying elasticsearch.yml (ES config)..."
mv /tmp/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

displaySpacedMessage "Configuring system to automatically start ElasticSearch at boot..."
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service

displaySpacedMessage "Starting Elasticsearch server..."
systemctl start elasticsearch.service

displayOkMessage

#
## Copying php.ini
#
displayTitle "Copying php.ini"

mv /tmp/php.ini /etc/php/7.1/cli/php.ini

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
