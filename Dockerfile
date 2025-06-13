FROM php:7.4-apache

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    libzip-dev unzip zip git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql zip gd bcmath

# 安装 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 启用 mod_rewrite
RUN a2enmod rewrite

# 添加 Apache 配置
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# 设置工作目录
WORKDIR /var/www/html

# 复制 composer.json 和 composer.lock (如果存在)
COPY composer.json composer.lock* ./

# 安装 PHP 依赖到 vendor 目录
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 创建启动脚本
RUN echo '#!/bin/bash\n\
# 修复权限\n\
chown -R www-data:www-data /var/www/html/runtime /var/www/html/public/uploads 2>/dev/null || true\n\
chmod -R 755 /var/www/html/runtime /var/www/html/public/uploads 2>/dev/null || true\n\
# 启动 Apache\n\
exec apache2-foreground' > /start.sh && chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]

