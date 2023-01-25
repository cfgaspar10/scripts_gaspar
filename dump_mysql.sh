#!/bin/bash
echo -e "\033[01;32mPor:Carlesandro Gaspar!\033[00;37m"
read -s -p "Informe sua senha do Banco: " password

##---PERGUNTAS---##
INFO_DATABASE='Informe nome da base de dados'	
INFO_ARQUIVO='Informe nome do arquivo'

function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}

# Variables
_start=1

# This accounts as the "totalState" variable for the ProgressBar function
_end=100

#---Barra de progresso dump---
declare -r STEPS=('step0' 'step1' 'step2' 'step3' 'step4' 'step5')
# Calcula o length (tamanho) do array
declare -r MAX_STEPS=${#STEPS[@]}
# Tamanho máximo da barra quando estiver em 100%
declare -r BAR_SIZE="##########################"
# Calcula o length (tamanho) da string
declare -r MAX_BAR_SIZE=${#BAR_SIZE}

while :; do
    read -p "BANCO DE DADOS PALASNET

	(1) Criar Database
	(2) Apagar Database
	(3) Executar o dump
	(4) Restaurar o dump
	(5) Listar databases
	(6) Listar Tabelas
	(7) Listar Diretório
	(8) Acessar MariaDB
	(0) sair

	Digite a opção: " opcao

	case "$opcao" in
		1) echo '#CREATE DATABASES' 
			read -p "$INFO_DATABASE: " database
				mysql -u root --password="$password" -e "CREATE DATABASE $database ";;
		2) echo '#DROPANDO DATABASE'
				mysql -u root --password="$password" -e "show databases"
			read -p "$INFO_DATABASE: " database
			echo -e "\033[00;32mPara confirmar essa ação, informe sua senha!\033[00;37m"
				mysql -u root -p -e "DROP DATABASE $database";;
		3) echo 'Executando dump...'
				mysql -u root --password="$password" -e "show databases"
			read -p "$INFO_DATABASE: " database
			read -p "$INFO_ARQUIVO: " namearquivo
			echo -e "\033[01;32mExecutando dump, aguarde!\033[00;37m"
				mysqldump -u root --password="$password" $database > $namearquivo.sql
					for step in "${!STEPS[@]}"; do
					# Calcula a porcentagem do loop corrente
					perc=$(((step + 1) * 100 / MAX_STEPS))
					# Calcula o último caracteres da barra baseado na porcentagem
					percBar=$((perc * MAX_BAR_SIZE / 100))
					sleep 2
					# Exibo a porcentagem do loop corrente
					# Flag -n para manter o ponteiro na mesma linha
					# Flag -e para voltar o ponteiro no inicio da linha
					echo -ne "\\r[${BAR_SIZE:0:percBar}] $perc %"
					done;;
					# Resultado:
					# 100 %%	;;
		4) echo '#Restaurando dump'
				mysql -u root --password="$password" -e "show databases"
			read -p "$INFO_DATABASE: " namedatabase
			echo -e "\033[00;31mLista de arquivos de dump. Insera nome do arquivo incluindo a extensão \033[01;31m.sql\033[00;37m"
			echo -e "\033[01;32m"
				ls *.sql
			echo -e "\033[00;37m"
			read -p "$INFO_ARQUIVO: " namearquivo
			echo -e "\033[01;32mExecutando restauração, aguarde!\033[00;37m"
				mysql -u root --password="$password" $namedatabase < $namearquivo
					for step in "${!STEPS[@]}"; do
					# Calcula a porcentagem do loop corrente
					perc=$(((step + 1) * 100 / MAX_STEPS))
					# Calcula o último caracteres da barra baseado na porcentagem
					percBar=$((perc * MAX_BAR_SIZE / 100))
					sleep 2
					# Exibo a porcentagem do loop corrente
					# Flag -n para manter o ponteiro na mesma linha
					# Flag -e para voltar o ponteiro no inicio da linha
					echo -ne "\\r[${BAR_SIZE:0:percBar}] $perc %"
					done;;
					# Resultado:
					# 100 %%	;;
		5) echo '#Listando databases'
				mysql -u root --password="$password" -e "show databases"
				continue;;
		6) echo '#Listando tables'
				mysql -u root --password="$password" -e "show databases"
		read -p "$INFO_DATABASE: " database
				mysql -u root --password="$password" -e "use $database;show tables;SELECT FOUND_ROWS() AS QUANT_TABELAS;"
				continue;;
		7) echo '#Listando arquivo(s) sql no diretório...'
				ls *.sql -l
				continue;;
		8) echo '#Acessando MariaDB'
				mysql -u root --password="$password" ;;

		0) exit ;;
	esac

	sleep 2s
	clear	
done
