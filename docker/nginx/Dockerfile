# Argumento para versão do PHP
ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-fpm

# Argumentos para o usuário
ARG user=code
ARG uid=1000

# Instalar dependências do sistema e ferramentas necessárias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    supervisor \
    ca-certificates \
    openssl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libbrotli-dev \
    gnupg \
    lsb-release \
    nginx \
    ghostscript \
    ffmpeg \
    libmagickwand-dev \
    libpq-dev

# Instalar imagick via PECL e limpar cache
RUN pecl install imagick && \
    docker-php-ext-enable imagick && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensões PHP necessárias para Laravel
RUN docker-php-ext-install pdo pdo_mysql mysqli pdo_pgsql pgsql mbstring xml exif pcntl bcmath gd sockets intl zip

# Instalar redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Criar usuário para rodar a aplicação
RUN useradd -u $uid -G www-data,root -m -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Copiar código do Laravel para a pasta do servidor
COPY . /var/www

# Definir permissões corretas
RUN chown -R $user:www-data /var/www

# Copia o arquivo entrypoint
COPY entrypoint /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

# Copia o arquivo do supervisord e php
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

# Criar diretório de logs do Supervisor
RUN mkdir -p /var/log/supervisor && \
    chown -R $user:www-data /var/log/supervisor

# Copiar configurações do Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Instalar Node.js e NPM de forma cacheável
ADD https://deb.nodesource.com/setup_20.x /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt-get install -y nodejs && npm install -g npm@latest

# Expondo a porta 80 para acesso direto
EXPOSE 80

# Definir diretório de trabalho
WORKDIR /var/www

# Trocar para usuário não-root para segurança
USER $user

# Comando de entrada
ENTRYPOINT ["entrypoint"]
