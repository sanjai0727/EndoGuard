# Use PHP 8.2 with Apache
FROM php:8.2-apache

# Install PostgreSQL and Curl extensions
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_pgsql curl

# Enable Apache modules required for routing
RUN a2enmod rewrite headers

# Set Working Directory
WORKDIR /var/www/html

# Copy all project files
COPY . .

# Secure permissions for assets and config
RUN chown -R www-data:www-data /var/www/html/assets /var/www/html/tmp /var/www/html/config

EXPOSE 80
