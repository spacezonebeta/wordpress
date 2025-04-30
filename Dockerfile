FROM wordpress:5.3.2-apache

# 安装你想要的东西（可选）
RUN apt-get update && apt-get install -y magic-wormhole

# 添加你的 entrypoint.sh 到容器中
COPY entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# 使用自定义入口脚本
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["apache2-foreground"]
