FROM wordpress:5.3.2-apache

# 安装你想要的东西（可选）
RUN apt-get update && apt-get install -y magic-wormhole


COPY entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

RUN echo "DirectoryIndex index.php" >> /etc/apache2/apache2.conf
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["apache2-foreground"]

RUN usermod -s /bin/bash www-data
RUN chown www-data:www-data /var/www
USER www-data:www-data
