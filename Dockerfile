# Use PHP 8.2 with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libcurl4-openssl-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql curl

# Enable Apache mod_rewrite
RUN a2enmod rewrite headers

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install PHP dependencies
RUN if [ -f composer.json ]; then \
    composer install --no-interaction --optimize-autoloader --no-dev; \
    fi

# Set permissions for folders EndoGuard needs to write to
RUN chown -R www-data:www-data /var/www/html/assets /var/www/html/tmp /var/www/html/config

# Expose port 80
EXPOSE 80
