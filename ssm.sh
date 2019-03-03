#!/bin/bash

# Скрипт установки ssm.sh (sprut script manager)
# Версия 0.2

# Начало

if [ -d ~/spruthub ]; then
        echo "=== Каталог со скриптами найден в ~/spruthub"
        echo "=== Ищем конфигурационный файл ~/spruthub"
        if [ -s ~/spruthub/spruthub.conf ]; then
                echo "=== Конфигурационный файл найден в ~/spruthub:"
                cat ~/spruthub/spruthub.conf
        else
                jq -n '{"installed":"yes"}' > ~/spruthub/spruthub.conf
                echo "=== Конфигурационный файл не найден и создан в ~/spruthub"
                cat ~/spruthub/spruthub.conf
        fi
else
        echo "=== Каталог со скриптами не найден в ~/spruthub, создаём его"
        mkdir ~/spruthub
        echo "=== Создаем пустой файл конфигурации"
        jq -n '{"installed":"yes"}' > ~/spruthub/spruthub.conf
        cat ~/spruthub/spruthub.conf
fi


echo "=== Скачиваем файл с перечнем скриптов..."
wget -q -N -O ~/spruthub/ssm.list https://github.com/ptath/spruthub/raw/master/ssm.list
[ -e ~/spruthub/ssm.list ] && echo "===	Успешно"
[ ! -e ~/spruthub/ssm.list ] && echo "===	Ошибка" && exit

IFS=$'\n' GLOBIGNORE='*' command eval 'SSM=($(cat ~/spruthub/ssm.list))'
scripts=${SSM[*]}

echo "=== Устанавливаем скрипты из списка..."
for item in ${scripts[*]}
do
  scriptname="${item##*/}"
	cd ~/spruthub/
	wget -q -N -O ~/spruthub/"$scriptname" $item
	[ -e ~/spruthub/"$scriptname" ] &&
		chmod +x ~/spruthub/"$scriptname" &&
		echo "===	$scriptname установлен"
	[ ! -e ~/spruthub/"$scriptname" ] &&
    echo "===       Ошибка при установке $scriptname!"
done

echo "echo "====== ssm.sh завершён ======""

# Конец
