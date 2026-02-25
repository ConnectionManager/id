#!/bin/bash

CONFIG_FILE="/etc/xray/config.json"
BACKUP_FILE="${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Erro: Arquivo de configuração não encontrado em $CONFIG_FILE"
    exit 1
fi

cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "Backup criado: $BACKUP_FILE"

echo ""
echo "Informe o número do path (ex: 123456):"
read -r path_number

if [ -z "$path_number" ]; then
    echo "Erro: Número inválido"
    exit 1
fi

path_input="/$path_number"

temp_file=$(mktemp)

jq --arg new_path "$path_input" \
   '(.. | .xhttpSettings? // empty).path = $new_path' \
   "$CONFIG_FILE" > "$temp_file"

if [ $? -eq 0 ]; then
    mv "$temp_file" "$CONFIG_FILE"
    echo "Path alterado para: $path_input"
    echo "Arquivo de configuração atualizado: $CONFIG_FILE"
    
    echo ""
    echo "Reiniciando serviço Xray..."
    chmod 644 /usr/local/etc/xray/config.json
    chown root:root /usr/local/etc/xray/config.json
    systemctl restart xray
    echo "Serviço Xray reiniciado."
else
    echo "Erro ao modificar o arquivo de configuração"
    rm -f "$temp_file"
    exit 1
fi
