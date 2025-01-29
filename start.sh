#!/bin/bash

# Nome do novo projeto Laravel
PROJECT_NAME="Projeto_base"

# Verifica se o nome do projeto foi fornecido
if [ -z "$PROJECT_NAME" ]; then
    echo "Por favor, forneça um nome para o projeto Laravel."
    exit 1
fi

# Geração do certificado SSL
mkdir -p ./docker/nginx/certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ./docker/nginx/certs/server.key \
  -out ./docker/nginx/certs/server.crt \
  -subj "/C=BR/ST=SP/L=São Paulo/O=MyCompany/OU=Dev/CN=localhost"


# Inicia a Subida do Container
docker compose up -d

# Aguarda 10 segundos para garantir que o container esteja completamente ativo
sleep 5

echo -e '\n' && \
clear && \

# Entra no Container e realiza operação pra iniciar o desenvolvimento
docker compose exec app bash -c "
    echo 'Baixando última versão do Laravel' && \
    composer create-project --prefer-dist laravel/laravel $PROJECT_NAME && \
    cd $PROJECT_NAME && \
    rm -f .env && \
    cd .. && \
    cp -r $PROJECT_NAME/* . && \
    rm -rf $PROJECT_NAME && \
    php artisan key:generate && \
    echo 'Criando banco e rodando as Migrations' && \
    php artisan migrate --seed && \
    echo 'Projeto Laravel criado com sucesso!' && \
    echo 'Instalando o Filament' && \
    composer require filament/filament:'^3.2' -W && \
    php artisan filament:install --panels && \
    echo 'Publicando arquivo de configuração do Filament' && \
    php artisan vendor:publish --tag=filament-config && \
    echo 'Publicando arquivos de tradução do Filament' && \
    php artisan vendor:publish --tag=filament-panels-translations && \
    php artisan vendor:publish --tag=filament-actions-translations && \
    php artisan vendor:publish --tag=filament-forms-translations && \
    php artisan vendor:publish --tag=filament-infolists-translations && \
    php artisan vendor:publish --tag=filament-notifications-translations && \
    php artisan vendor:publish --tag=filament-tables-translations && \
    php artisan vendor:publish --tag=filament-translations && \
    echo 'Instalação e migração concluídas com sucesso!'
"