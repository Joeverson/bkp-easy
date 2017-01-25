#!/usr/bin/env bash

# verificando se existe parametros no sistema

# functions

#connectando com o servidor e fazendo o serviço
connect()
{
    if [ $1 == 'db' ]
    then
        if [ ! -d "./bkp_db_$5/" ] #verificando se existe o arquivo
        then
            sudo mkdir "./bkp_db_$5/"
        fi

        echo "Loading...(Pode demorar um pouco)"

        #conectando com o banco de dados
        #echo "mysqldump -u$4 -p$3 -h $2 -P $6 $5 > ./bkp_db_$5/bkp.$5.$(date +%Y-%m-%d_%H-%M-%S).sql"
        mysqldump -u$4 -p$3 -h $2 -P $6 $5 > "./bkp_db_$5/bkp.$5.$(date +%Y-%m-%d_%H-%M-%S).sql"

        echo "Done $2"
    elif [ $1 == 'ftp' ]
    then
        if [ ! -d "./bkp_files_$4/" ] #verificando se existe o arquivo
        then
            sudo mkdir "./bkp_files_$4/"
        fi

        #echo "Informe o path do arquivo para backup"
#        read PATH ===> ./html/multiplicador/deploy/

        echo "Conectando ao servidor..."

        #criando o zip e baixando o arquivo
        $(ssh $4@$2 "echo \"Compactando arquivos...\" && zip -r ./html/multiplicador/deploy/bkp.$4.$(date +%Y-%m-%d_%H-%M-%S).zip ./html/multiplicador/deploy/ && echo \"Baixando arquivos...\" && cat ./html/multiplicador/deploy/bkp.$4.$(date +%Y-%m-%d_%H-%M-%S).zip" > "./bkp_files_$4/bkp.$4.$(date +%Y-%m-%d_%H-%M-%S).zip")

    fi
}


#lendo as infromações do arquivo
read_file()
{
    i=0

    #pegando as informações do arquivo de configurações e colocando num array
    while read LINHA; do
      ARR[$i]="$(echo $LINHA | awk '{print $2}')"
      i=$((i+1))
    done < "./backup_setup/$1.env"


    # verificando se é para conectar logo
    if [ $2 == 'connect' ]
    then
        connect $1  ${ARR[0]} ${ARR[1]} ${ARR[2]} ${ARR[3]} ${ARR[4]}
    fi
}



# verificando os comandos dado pelo usuario.
case $# in
    0)
        read_file ;;
    1)
        read_file $1 'connect' ;;
    2)
        read_file $1 ;;
esac

