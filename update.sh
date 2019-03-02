#!/bin/bash

# Скрипт обновления системных и nodejs приложений для образа
# Версия 0.1

# Начало

# === 1
# Обновление приложений, установленных через стандартный менеджер пакетов (apt)
# Это надо делать постоянно в любом случае, поэтому интерактива нет

cat ~/spruthub/logo.ascii

echo "=== Обновляем приложения (первый раз весьма долго)..."
sudo apt clean && sudo apt update && sudo apt upgrade -y

# === 2
# Обновление менеджера пакетов npm до последней мажорной версии
# Существуют разные мнения на этот счёт, в том числе угроза того, что
#       некоторые старые приложения/скрипты перестанут работать.
# Но зачем жить прошлым? По умолчанию выполняется обновление.

echo "=== Обновляем npm: "
npm install -g npm
read -t 7 -n 1 -p "=== Будем обновлять сам менеджер пакетов npm? (Y/n): " npm_update_choice
[ -z "$npm_update_choice" ] && npm_update_choice="y"
case $npm_update_choice in
        y|Y ) echo " Установка..." && npm update;;
        n|N|* ) echo " Установка отменена";;
esac

# === 3
# Обновление пакетов nodejs, установленных через npm
# Получаем их перечень и решаем, обновляться или нет. Стоит насторожиться
#       если версия часто используемого пакета очень сильно отличается от новой.

echo "=== Получаем список установленных пакетов nodejs..."
npm list -g --depth 0

echo "=== Проверяем наличие обновлений..."
[ -e /tmp/npm_outdated_list ] && rm /tmp/npm_outdated_list
npm outdated > /tmp/npm_outdated_list
if [ -s /tmp/npm_outdated_list ]; then
        echo "=== Доступны обновления:"
        cat /tmp/npm_outdated_list
        read -t 7 -n 1 -p "=== Установить? (Y/n): " npm_update_choice
        [ -z "$npm_update_choice" ] && npm_update_choice="y"
        case $npm_update_choice in
          y|Y ) echo " Пробуем установить..." && npm update;;
          n|N|* ) echo " Не будем ставить";;
esac
else
echo "=== Обновления пакетов nodejs не требуются"
fi

# === 4
# Обновление дополнительных shell-скриптов (вручную)
echo "=== Для обновления скриптов ~/spruthub/scripts-install.sh"

# Конец
