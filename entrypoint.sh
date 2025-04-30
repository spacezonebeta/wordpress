#!/bin/bash
set -e

if ! [ -e wp-config.php ]; then
  echo "Generating wp-config.php..."
  cat <<EOF > wp-config.php
<?php
define( 'DB_NAME', '${MYSQL_DATABASE}' );
define( 'DB_USER', '${MYSQL_USER}' );
define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );
define( 'DB_HOST', '${MYSQL_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// Optional security keys
EOF

  for key in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT; do
    if [ -n "${!key}" ]; then
      echo "define( '$key', '${!key}' );" >> wp-config.php
    fi
  done

  cat <<'EOF' >> wp-config.php

$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF
fi

# Set PHP limits to allow large uploads (e.g. theme ZIP files)
echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/uploads.ini
echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/uploads.ini
echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini

# Start Apache
exec apache2-foreground
