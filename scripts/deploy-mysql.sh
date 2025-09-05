#!/bin/bash
set -e

# Carregar variáveis de ambiente
# Exemplo:
# export MYSQL_ROOT_PASSWORD="your_root_password_for_external_db"
# export MYSQL_DB_NAME="metabase_app"
# export MYSQL_USER="metabaseuser"
# export MYSQL_PASSWORD="your_metabase_password_for_external_db"

echo "Preparando configuração Docker Compose para MySQL..."
envsubst < mysql/docker-compose.yml.template > ~/docker-compose.yml

echo "Iniciando MySQL container..."
docker compose -f ~/docker-compose.yml up -d

echo "MySQL implantado com sucesso."