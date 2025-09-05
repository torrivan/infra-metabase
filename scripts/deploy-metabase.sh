#!/bin/bash
set -e

# Carregar variáveis de ambiente
# Exemplo:
# export MYSQL_HOST_IP="IP_DO_SERVIDOR_MYSQL"
# export MYSQL_DB_NAME="metabase_app"
# export MYSQL_USER="metabaseuser"
# export MYSQL_PASSWORD="your_metabase_password_for_external_db"
# export METABASE_SYSTEM_USER="metabaseuser"
# export METABASE_SYSTEM_GROUP="metabasegroup"

echo "Preparando configuração Metabase Instance 1..."
envsubst < metabase/metabase1.service.template | sudo tee /etc/systemd/system/metabase1.service > /dev/null

echo "Preparando configuração Metabase Instance 2..."
envsubst < metabase/metabase2.service.template | sudo tee /etc/systemd/system/metabase2.service > /dev/null

echo "Recarregando systemd..."
sudo systemctl daemon-reload

echo "Baixando metabase.jar (se ainda não estiver lá)..."
# Certifique-se de que /opt/metabase existe e tem as permissões corretas
sudo mkdir -p /opt/metabase/instance1 /opt/metabase/instance2
sudo chown -R ${METABASE_SYSTEM_USER}:${METABASE_SYSTEM_GROUP} /opt/metabase

if [ ! -f /opt/metabase/metabase.jar ]; then
    sudo wget https://downloads.metabase.com/v0.49.6/metabase.jar -O /opt/metabase/metabase.jar
fi
sudo cp /opt/metabase/metabase.jar /opt/metabase/instance1/metabase.jar
sudo cp /opt/metabase/metabase.jar /opt/metabase/instance2/metabase.jar

echo "Iniciando Metabase services..."
# Iniciar apenas um para setup inicial do DB
sudo systemctl start metabase1
sudo systemctl enable metabase1

echo "Aguardando Metabase Instance 1 iniciar e criar o esquema no DB..."
# Adicionar um pequeno atraso para o primeiro Metabase criar o DB esquema
sleep 30

# Iniciar a segunda instância
sudo systemctl start metabase2
sudo systemctl enable metabase2

echo "Metabase implantado com sucesso."