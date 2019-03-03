#!/bin/bash

# Скрипт обновления системных (через apt) и nodejs (через npm) приложений
# Есть возможность вручную отменить установку некоторых разделов, если в течении
#   5 секунд после соответствующего вопроса ответить "n"
# Версия 0.2

# Начало

# === 0
# Если нет каталога, создаем его
[ ! -d ~/spruthub ] && mkdir ~/spruthub

# === 1
# Обновление программных пакетов (apt)

read -t 5 -n 1 -p "=== Обновляем программные пакеты через apt? (Y/n): " apt_update_choice
[ -z "$apt_update_choice" ] && apt_update_choice="y"
case $apt_update_choice in
        y|Y ) echo " Установка..." && sudo apt clean && sudo apt update && sudo apt upgrade -y;;
        n|N|* ) echo " Установка отменена";;
esac

# === 1.1
# Устанавливаем пакеты для скриптов через apt

wget -N -O /tmp/ssapt.sh https://github.com/ptath/spruthub/raw/master/ssapt.sh &&
  chmod +x /tmp/ssapt.sh &&
  /tmp/ssapt.sh


# === 1.2
# Устанавливаем все наши скрипты в домашнюю папку

wget -N -O /tmp/ssm.sh https://github.com/ptath/spruthub/raw/master/ssm.sh &&
  chmod +x /tmp/ssm.sh &&
  /tmp/ssm.sh

# === 2
# Обновление менеджера пакетов npm до последней мажорной версии
# Существуют разные мнения на этот счёт, в том числе угроза того, что
#       некоторые старые приложения/скрипты перестанут работать.
# Но зачем жить прошлым? По умолчанию выполняется обновление.

echo "=== Обновляем Node.js packet manager (npm): "

read -t 5 -n 1 -p "=== Обновляем node packet manager (npm)? (Y/n): " npm_update_choice
[ -z "$npm_update_choice" ] && npm_update_choice="y"
case $npm_update_choice in
        y|Y ) echo " Установка..." && npm install -g npm && npm update;;
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
        read -t 5 -n 1 -p "=== Установить? (Y/n): " npm_update_choice
        [ -z "$npm_update_choice" ] && npm_update_choice="y"
        case $npm_update_choice in
          y|Y ) echo " Пробуем установить..." && npm update;;
          n|N|* ) echo " Не будем ставить";;
esac
else
echo "=== Обновления пакетов nodejs не требуются"
fi

echo "=== Для обновления скриптов вручную ~/spruthub/update.sh"
echo "====== update.sh завершён ======"

# Конец
