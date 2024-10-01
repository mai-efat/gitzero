# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy composer.lock and composer.json
COPY composer.lock composer.json ./

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application code
COPY . .

# Generate the autoload files
RUN composer dump-autoload

# Set permissions for storage and bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port 80
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
