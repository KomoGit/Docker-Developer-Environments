FROM php:8.2.0-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    p7zip-full\
    nano\
    && apt-get clean

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Xdebug extension
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Set the working directory
WORKDIR /var/www/html

# Copy contents of volume to container
COPY . .

# Expose ports for Apache (80), Xdebug(9003)
EXPOSE 80
EXPOSE 9003

RUN echo 'root:your_password' | chpasswd

# Copy Xdebug configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/

CMD ["apache2-foreground"]