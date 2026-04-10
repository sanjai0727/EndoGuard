# Use PHP 8.2 with FPM (FastCGI Process Manager)
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libcurl4-openssl-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql curl

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

# PHP-FPM runs on port 9000
EXPOSE 9000

