#!/usr/bin/env bash
apt-get update
apt-get install -y alien libaio1

# apt-get install -y php5 php-apc php5-intl php5-cli php5-dev build-essential php-pear libaio1
# rm -rf /var/www
# ln -fs /vagrant /var/www
# apt-get install unzip

oraclefullversionno="11.2.0.4.0-1"
oracleshortversionno=${oraclefullversionno:0:4}
os="x86_64"
filetype="rpm"

prefix="oracle-instantclient"$oracleshortversionno"-"
suffix="-"$oraclefullversionno"."$os"."$filetype

initialdir="/vagrant/files/oracle/"
dir="/home/vagrant/instantclient_"$oracleshortversionno"/"

# Define file names.
oraclebasic=$prefix"basic"$suffix
oraclesqlplus=$prefix"sqlplus"$suffix
oracledevel=$prefix"devel"$suffix


if [ -e $initialdir$oraclebasic ] && [ -e $initialdir$oraclesqlplus ] && [ -e $initialdir$oracledevel ]; then

    if [ ! -d $dir ]; then

        mkdir $dir

    fi

    if [ ! -e $dir$oraclebasic ]; then

        mv $initialdir$oraclebasic $dir

    fi

    if [ ! -e $dir$oraclesqlplus ]; then

        mv $initialdir$oraclesqlplus $dir

    fi

    if [ ! -e $dir$oracledevel ]; then

        mv $initialdir$oracledevel $dir

    fi

    if [ -d $dir ]; then

        # cd /home/vagrant
        # Download from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
        # unzip instantclient-basic-linux.x64-11.2.0.3.0.zip
        # unzip instantclient-sqlplus-linux.x64-11.2.0.3.0.zip
        # unzip instantclient-sdk-linux.x64-11.2.0.3.0.zip
        # cd instantclient_11_2/
        # ln -s libclntsh.so.11.1 libclntsh.so
        # ln -s libocci.so.11.1 libocci.so

        # Install Instant Client and SQLPlus.
        alien -i $dir$oraclebasic
        alien -i $dir$oraclesqlplus
        alien -i $dir$oracledevel

        # Create Oracle configuration file.
        oraclepath=/usr/lib/oracle/$oracleshortversionno/client64/lib
        sh -c 'echo '$oraclepath' > /etc/ld.so.conf.d/oracle.conf'

        # Add Oracle to path.
        sh -c 'echo export ORACLE_HOME=/usr/lib/oracle/'$oracleshortversionno'/client64 >> /home/vagrant/.bashrc'
        sh -c 'echo export PATH=\$PATH:\$ORACLE_HOME/bin >> /home/vagrant/.bashrc'
        source /home/vagrant/.bashrc

        # Reload config.
        ldconfig

        # Install OCI8
        mkdir -p /usr/local/src
        cd /usr/local/src
        wget http://pecl.php.net/get/oci8-1.4.9.tgz
        tar xzf oci8-1.4.9.tgz
        cd oci8-1.4.9
        phpize
        ./configure --with-oci8=shared,instantclient,$oraclepath
        make
        make install

        # chown vagrant /etc/php5/fpm/php.ini
        echo extension=oci8.so >> /etc/php5/fpm/php.ini
        echo extension=oci8.so >> /etc/php5/cli/php.ini
        /etc/init.d/nginx restart
        service php5-fpm restart
        # nginx -s reload

        # Add Oracle database IP to hosts.
        echo 172.28.128.3 oracle.$oracleshortversionno >> /etc/hosts

    fi

fi
