#!/bin/bash
set -e

# Carregar variáveis de ambiente (se necessário, de um arquivo .env ou similar)
# Exemplo: NGINX_SERVER_NAME="192.168.1.100"

echo "Preparando configuração NGINX..."
envsubst < nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Testando configuração NGINX..."
sudo nginx -t

echo "Reiniciando NGINX..."
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "NGINX implantado com sucesso."