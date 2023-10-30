FROM php:8.2.0-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    p7zip-full\
    supervisor \
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

# Expose ports for Apache (80), Xdebug(9003), and SSH (22)
EXPOSE 80
EXPOSE 9003
EXPOSE 22

# SSH Configuration
RUN echo 'root:your_password' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Generate SSH host keys
RUN ssh-keygen -y -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -y -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -y -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

# Configure supervisord to run Apache and SSH
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy Xdebug configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/

CMD ["/usr/bin/supervisord"]