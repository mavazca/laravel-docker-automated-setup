# Argumentos para as versões do PHP e FrankenPHP
ARG PHP_VERSION=8.4
ARG FRANKENPHP_VERSION=1.5
ARG OS=bookworm

# Usando a tag do FrankenPHP com a versão do PHP e o sistema operacional (bookworm ou alpine)
FROM dunglas/frankenphp:${FRANKENPHP_VERSION}-php${PHP_VERSION}-${OS}

# Argumentos para o usuário
ARG user=code
ARG uid=1000

# Instala dependências do sistema
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
    lsb-release

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala extensões do PHP
RUN docker-php-ext-install pdo pdo_mysql mysqli mbstring xml exif pcntl bcmath gd sockets intl zip

# Instalar redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Instalar composer
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

# Instalar Node.js e NPM
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Expondo a porta 80 para acesso direto
EXPOSE 80

# Definir diretório de trabalho
WORKDIR /var/www

# Trocar para usuário não-root para segurança
USER $user

# Comando de entrada
ENTRYPOINT ["entrypoint"]
