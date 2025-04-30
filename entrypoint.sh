#!/bin/bash
set -e

# 如果 /var/www/html 目录下没有 WordPress，就复制核心代码
if [ ! -e /var/www/html/wp-settings.php ]; then
  echo "WordPress not found in /var/www/html – copying now..."
  cp -a /usr/src/wordpress/. /var/www/html/
fi

cd /var/www/html

# 如果 wp-config.php 不存在则生成它
if [ ! -f wp-config.php ]; then
  echo "Generating wp-config.php..."

  cat > wp-config.php <<EOF
<?php
define( 'DB_NAME', '${WORDPRESS_DB_NAME}' );
define( 'DB_USER', '${WORDPRESS_DB_USER}' );
define( 'DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}' );
define( 'DB_HOST', '${WORDPRESS_DB_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

EOF

  # 添加 secret keys（可为空）
  for key in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT
  do
    echo "define('$key', '$(eval echo \$$key)');" >> wp-config.php
  done

  cat >> wp-config.php <<EOF

\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF

  echo "wp-config.php created."
fi

# 权限修复
chown -R www-data:www-data /var/www/html

# 启动 Apache
exec docker-entrypoint.sh apache2-foreground
