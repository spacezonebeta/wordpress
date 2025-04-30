# 基于原来的 WordPress 镜像（可改为其他版本）
FROM wordpress:5.3.2-apache

# 安装 magic-wormhole（保留原有功能）
RUN apt-get update && apt-get install -y magic-wormhole unzip \
  && docker-php-ext-install mysqli \
  && a2enmod rewrite \
  && rm -rf /var/lib/apt/lists/*

# 修改默认 shell，设置权限（保留原有配置）
RUN usermod -s /bin/bash www-data \
  && chown www-data:www-data /var/www

# 拷贝自定义的 entrypoint.sh 脚本
COPY entrypoint.sh /usr/local/bin/custom-entrypoint.sh

# 授权执行权限
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# 使用你自己的入口脚本（会自动生成 wp-config.php）
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]

# 启动 Apache（与 WordPress 默认一致）
CMD ["apache2-foreground"]
