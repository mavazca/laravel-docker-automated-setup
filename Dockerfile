# Base image PHP-FPM
FROM php:8.4-rc-fpm

# Argumentos para o usuário
ARG user=wallace
ARG uid=1000

# Instalar dependências do sistema e ferramentas necessárias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    gnupg \
    ca-certificates \
    lsb-release \
    nginx \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Node.js e NPM
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Instalar extensões PHP necessárias para Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets intl zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Criar usuário para rodar a aplicação
RUN useradd -u $uid -G www-data,root -m -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Instalar Redis PHP extension
RUN pecl install -o -f redis && \
    docker-php-ext-enable redis

# Copiar código do Laravel para a pasta do servidor
COPY . /var/www

# Definir permissões corretas
RUN chown -R $user:www-data /var/www

# Copiar configurações do Nginx (sem copiar certificados do host)
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Expor portas HTTP e HTTPS
EXPOSE 80 443

# Definir diretório de trabalho
WORKDIR /var/www

# Trocar para usuário não-root para segurança
USER $user

# Comando padrão do container
CMD ["php-fpm"]
