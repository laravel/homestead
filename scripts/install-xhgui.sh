#!/usr/bin/env bash

# Check If xhgui Has Been Installed

if [ -f /home/vagrant/.homestead-features/xhgui ]
then
    echo "xhgui already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/xhgui
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

apt install -y php-tideways
phpenmod -v ALL tideways

git clone https://github.com/perftools/xhgui.git /opt/xhgui

cat <<'EOT' > /opt/xhgui/webroot/.htaccess
<IfModule mod_rewrite.c>
	RewriteEngine On
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteRule ^ /xhgui/index.php [QSA,L]
</IfModule>
EOT

cat <<'EOT' > /opt/xhgui/config/config.php
<?php
/**
 * Configuration for XHGui.
 */
return array(
    // Which backend to use for Xhgui_Saver.
    // Must be one of 'mongodb', or 'file'.
    //
    // Example (save to a temporary file):
    //
    //     'save.handler' => 'file',
    //     # Beware of file locking. You can adujst this file path
    //     # to reduce locking problems (eg uniqid, time ...)
    //     'save.handler.filename' => __DIR__.'/../data/xhgui_'.date('Ymd').'.dat',
    //
    'save.handler' => 'mongodb',

    // Database options for MongoDB.
    //
    // - db.host: Connection string in the form `mongodb://[ip or host]:[port]`.
    //
    // - db.db: The database name.
    //
    // - db.options: Additional options for the MongoClient contructor,
    //               for example 'username', 'password', or 'replicaSet'.
    //               See <https://secure.php.net/mongoclient_construct#options>.
    //
    'db.host' => 'mongodb://127.0.0.1:27017',
    'db.db' => 'xhprof',
    'db.options' => array('username' => 'homestead', 'password' => 'secret'),

    // Whether to instrument a user request.
    //
    // NOTE: Only applies to using the external/header.php include.
    //
    // Must be a function that returns a boolean,
    // or any non-function value to disable the profiler.
    //
    // Default: Profile 1 in 100 requests.
    //
    // Example (profile all requests):
    //
    //     'profiler.enabled' => function() {
    //         return true;
    //     },
    //
    'profiler.enable' => function() {
      // Never profile ourself.
      if (isset($_SERVER['REQUEST_URI']) && strpos($_SERVER['REQUEST_URI'], '/xhgui') === 0) {
        return false;
      }

      // Profile if ?xhgui=on, and continue to profile for the next hour.
      foreach (array('xhgui') as $switch) {
        if (isset($_GET[$switch]) && $_GET[$switch] == 'on') {
          setcookie('xhgui', 'on', time() + 3600);
          return true;
        }
      }

      // Profile if we have been set to profiling mode.
      if (isset($_COOKIE['xhgui']) && $_COOKIE['xhgui'] == 'on') {
        return true;
      }

      // Profile the CLI when the XHGUI environment variable is set.
      if (getenv('XHGUI') == 'on') {
        return true;
      }
    },

    // Transformation for the "simple" variant of the URL.
    // This is stored as `meta.simple_url` and used for
    // aggregate data.
    //
    // NOTE: Only applies to using the external/header.php include.
    //
    // Must be a function that returns a string, or any
    // non-callable value for the default behaviour.
    //
    // Default: Remove numeric values after `=`. For example,
    // it turns "/foo?page=2" into "/foo?page".
    'profiler.simple_url' => null,

    // Additional options to be passed to the `_enable()` function
    // of the profiler extension (xhprof, tideways, etc.).
    //
    // NOTE: Only applies to using the external/header.php include.
    'profiler.options' => array(),

    // Date format used when browsing XHGui pages.
    //
    // Must be a format supported by the PHP date() function.
    // See <https://secure.php.net/date>.
    'date.format' => 'M jS H:i:s',

    // The number of items to show in "Top lists" with functions
    // using the most time or memory resources, on XHGui Run pages.
    'detail.count' => 6,

    // The number of items to show per page, on XHGui list pages.
    'page.limit' => 25,

    );
EOT

# Add indexes documented at https://github.com/perftools/xhgui#installation
mongo --eval "db.results.ensureIndex( { 'meta.SERVER.REQUEST_TIME' : -1 } ); \
db.results.ensureIndex( { 'profile.main().wt' : -1 } ); \
db.results.ensureIndex( { 'profile.main().mu' : -1 } ); \
db.results.ensureIndex( { 'profile.main().cpu' : -1 } ); \
db.results.ensureIndex( { 'meta.url' : 1 } ); \
db.results.ensureIndex( { 'meta.simple_url' : 1 } ); \
db.results.ensureIndex( { "meta.request_ts" : 1 }, { expireAfterSeconds : 432000 } )" xhprof

cd /opt/xhgui
php install.php

for version in 5.6 7.0 7.1 7.2 7.3 7.4
do
  cat << 'EOT' > /etc/php/$version/mods-available/xhgui.ini
; Include xhgui's header for performance profiling.
auto_prepend_file="/opt/xhgui/external/header.php"
EOT
done
phpenmod -v ALL xhgui

