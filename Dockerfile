FROM php:7.4-apache

# 安装依赖
RUN apt-get update && apt-get install -y \
    libzip-dev unzip zip git \
    && docker-php-ext-install pdo_mysql zip

# 启用 mod_rewrite
RUN a2enmod rewrite

# 添加 Apache 配置
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# 设置工作目录
WORKDIR /var/www/html

# 赋权限给 Apache 运行用户
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

