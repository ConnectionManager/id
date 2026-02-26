#!/bin/bash
read -p "Digite o domínio: " dominio
mkdir -p /usr/local/etc/xray/ssl
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout /usr/local/etc/xray/ssl/priv.key \
  -out /usr/local/etc/xray/ssl/cert.pem \
  -days 365 \
  -subj "/CN=$dominio"
chmod 600 /usr/local/etc/xray/ssl/priv.key
chmod 644 /usr/local/etc/xray/ssl/cert.pem
echo "Certificado gerado para $dominio em /usr/local/etc/xray/ssl/"
service xray restart
