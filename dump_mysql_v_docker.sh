#!/bin/bash
echo -e "\033[01;32mPor:Carlesandro Gaspar!\033[00;37m"
echo -e "\033[01;31mATENÇÃO:SE USUARIO NÃO TIVER PERMISSÃO ROOT, INSERIR SUDO ANTES DOS COMANDOS DOCKER EXEC, EXEMPLO:\033[00;31m"
echo -e "sudo docker exec $ID_CONTAINER mysql -u root --password=$PASSWD  -e "CREATE DATABASE $database "\033[00;37m"
##INFORME O ID OU NOME DO CONTAINER | dica: execute docker ps para coletar essas informações
ID_CONTAINER='palasnet-db'

###ARMAZENA SENHA DO BANCO###
read -s -p "Informe sua senha do Banco: " PASSWD
###PERGUNTAS###
INFO_DATABASE='Informe nome database'
INFO_ARQUIVO='Informe nome do arquivo'

while :; do
    read -p "SCRIPT BANCO DE DADOS VERSÃO DOCKER
	(1) Criar Database
	(2) Dropar Database
	(3) Executar o dump
	(4) Restaurar o dump
	(5) Listar Databases
	(6) Listar Tabelas
	(7) Entrar no MariaDB
	(8) Entrar no container
	(0) sair

	Digite a opção: " opcao

	case "$opcao" in
    	1) echo '#CREATE DATABASE' 
			read -p "$INFO_DATABASE: " database
				docker exec $ID_CONTAINER mysql -u root --password=$PASSWD  -e "CREATE DATABASE $database ";;
		2) echo '#DROPANDO DATABASE'
				docker exec $ID_CONTAINER mysql -u root --password=$PASSWD -e "show databases"
			read -p "$INFO_DATABASE: " database
				docker exec $ID_CONTAINER mysql -u root --password=$PASSWD -e "DROP DATABASE $database";;
		3) echo '#EXECUTANDO DUMP'
				docker exec $ID_CONTAINER mysql -u root --password=$PASSWD -e "show databases"
			read -p "$INFO_DATABASE: " database
			read -p "$INFO_ARQUIVO: " namearquivo
				docker exec $ID_CONTAINER /usr/bin/mysqldump -u root --password=$PASSWD $database > $namearquivo.sql;;
		4) echo '#Restaurando dump'
				docker exec $ID_CONTAINER mysql -u root --password=$PASSWD -e "show databases"
			read -p "$INFO_DATABASE: " database
			echo -e "\033[00;31mLista de arquivos de dump. Insera nome do arquivo incluindo a extensão \033[01;31m.sql\033[00;37m"
			echo -e "\033[01;32m"
				ls *.sql
			echo -e "\033[00;37m"
			read -p "$INFO_ARQUIVO: " namearquivo
				cat $namearquivo | docker exec -i $ID_CONTAINER /usr/bin/mysql -u root --password=$PASSWD $database;;
		5) echo '#LIST DATABASE'
				docker exec $ID_CONTAINER mysql -u root --password=$PASSWD -e "show databases"
				continue;;
		6) echo '#LIST TABLES'
				docker exec $ID_CONTAINER mysql -u root --password=$PASSWD -e "show databases"
			read -p "$INFO_DATABASE: " database
                docker exec $ID_CONTAINER mysql -u root --password=$PASSWD -e "use $database;show tables;select found_rows() as QUANT_TABELAS;"
                continue;;
		7) echo '#Entrando no Mysql'
                docker exec -ti $ID_CONTAINER mysql -u root --password=$PASSWD ;;
		8) echo '#Entrando no container'
                docker exec -ti $ID_CONTAINER bash -c "cd /docker-entrypoint-initdb.d/ && /bin/bash";;
		
		0) exit ;;
	esac

	sleep 2s
	clear	
done
