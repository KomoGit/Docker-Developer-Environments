FROM php:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    p7zip-full\
    && apt-get clean

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www/html

# Expose ports for Apache (80) and SSH (22)
EXPOSE 80
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

# Start Apache 
CMD ["apache2-foreground"]
