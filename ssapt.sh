#!/bin/bash

# Скрипт установки приложений из системного репозитория ssapt.sh (sprut script apt)
# Версия 0.1

# Начало

echo "=== Скачиваем файл с перечнем необходимых пакетов..."
wget -q -N -O ~/spruthub/apt.list https://github.com/ptath/spruthub/raw/master/apt.list
[ -e ~/spruthub/apt.list ] && echo "=== Успешно, нам нужны следующие пакеты:" && cat ~/spruthub/apt.list
[ ! -e ~/spruthub/apt.list ] && echo "=== Ошибка" && exit

IFS=$'\n' GLOBIGNORE='*' command eval 'SSM=($(cat ~/spruthub/apt.list))'
apts=${SSM[*]}

echo "=== Выполняем sudo apt update"
sudo apt update

echo "=== Устанавливаем скрипты из списка..."
for item in ${apts[*]}
do
  package_name=$item
  if [ $(dpkg-query -W -f='${Status}' "$package_name" 2>/dev/null | grep -c "ok installed") -eq 0 ];then
        echo "=== " $package_name" не установлен, ставим..."
        sudo apt install "$package_name" -y
  else
        echo "=== "       $package_name" уже установлен"
  fi
done

echo "====== ssapt.sh завершён ======"

# Конец
