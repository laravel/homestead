#!/usr/bin/env bash

cat > /root/.my.cnf << EOF
[client]
user = root
password = secret
host = 127.0.0.1
EOF

cat > /home/vagrant/.my.cnf << EOF
[client]
user = homestead
password = secret
host = 127.0.0.1
EOF

chown vagrant /home/vagrant/.my.cnf


DB=$1;

mysql=$(ps ax | grep mysql | wc -l)
mariadb=$(ps ax | grep mariadb | wc -l)

if [ "$mysql" -gt 1 ]
then
    mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
else
    # Skip Creating MySQL database
    echo "We didn't find MySQL (\$mysql), skipping \$DB creation"
fi

if [ "$mariadb" -gt 1 ]
then
    mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
else
    # Skip Creating MariaDB database
    echo "We didn't find MariaDB (\$mariadb), skipping \$DB creation"
fi
