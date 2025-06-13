FROM php:7.4-apache

# 安装扩展
RUN apt-get update && apt-get install -y \
    libzip-dev unzip zip git \
    && docker-php-ext-install pdo_mysql zip

# 启用 Apache 的 rewrite 模块
RUN a2enmod rewrite

# 添加自定义虚拟主机配置
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# 设置工作目录
WORKDIR /var/www/html

# 设置权限（可选）
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

