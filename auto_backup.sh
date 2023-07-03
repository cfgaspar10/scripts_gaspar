#!/bin/bash
echo -e "\033[01;32mPor:Carlesandro Gaspar!\033[00;37m"
#read -s -p "Informe sua senha do Banco: " password

# Defina as variáveis
SITE_DIR='/caminho'
BACKUP_DIR='/caminho/diretorio/de/backup'
DB_USER='usuario_do_banco_de_dados'
DB_PASSWORD='senha_do_banco_de_dados'
DB_NAME='nome_do_banco_de_dados'
DATE=$(date +%Y-%m-%d)

# Crie um diretório para o backup atual
mkdir -p "$BACKUP_DIR/$DATE"

# Copie os arquivos do site para o diretório de backup
cp -R "$SITE_DIR" "$BACKUP_DIR/$DATE"

# Faça o backup do banco de dados
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_DIR/$DATE/$DB_NAME.sql"

# Compacte o diretório de backup
cd $BACKUP_DIR
tar -zcf "$BACKUP_DIR/$DATE.tar.gz" -C "$BACKUP_DIR/$DATE" .
cd ~

# Remova o diretório de backup atual
rm -rf "$BACKUP_DIR/$DATE"

# Defina a data limite para backups antigos (1 mês atrás)
LIMIT=$(date -d "1 month ago" +%Y-%m-%d)

# Verifique se há backups mais antigos que a data limite e remova-os
find "$BACKUP_DIR" -type d -name "*-*-*" -prune -print | while read BACKUP; do
if [[ $(basename "$BACKUP") < "$LIMIT" ]]; then
echo "Removendo backup antigo: $BACKUP"
rm -rf "$BACKUP"
fi
done
