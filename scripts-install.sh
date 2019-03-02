#!/bin/bash

# Скрипт установки shell-скриптов
#       SprutHub (https://sprut.ai/client/projects/105)

# Начало

if [ -d ~/spruthub ]; then
        echo "=== Каталог со скриптами найден в ~/spruthub"
        ls -la ~/spruthub
        echo "=== Ищем конфигурационный файл ~/spruthub"
        if [ -s ~/spruthub/spruthub.json ]; then
                echo "=== Конфигурационный файл найден в ~/spruthub"
                cat ~/spruthub/spruthub.json
        else
                jq -n '{"installed":"yes"}' > ~/spruthub/spruthub.json
                echo "=== Конфигурационный файл не найден и создан в ~/spruthub"
                cat ~/spruthub/spruthub.json
        fi
else
        echo "=== Каталог со скриптами не найден в ~/spruthub, создаём его"
        mkdir ~/spruthub
        echo "=== Создаем пустой файл конфигурации"
        jq -n '{"installed":"yes"}' > ~/spruthub/spruthub.json
        cat ~/spruthub/spruthub.json
fi

# echo "=== Получаем последнюю версию скрипта установки"
# echo "===   В дальнейшем обновление скриптов всегда можно запустить командой"
# echo "===   ~/spruthub/scripts-install.sh"
# wget -N -O ~/spruthub/sprt-hostname.sh BROKEN_LINK

# echo "=== Установка и запуск скрипта hostname.sh"
# wget -N -O ~/spruthub/sprt-hostname.sh BROKEN_LINK | bash

# echo "=== Установка и запуск скрипта обновлений update.sh"
# wget -N -O ~/spruthub/update.sh BROKEN_LINK | bash

# echo "=== Установка jq - приложение для работы с JSON-файлами"
# sudo apt install jq -y

# echo "=== Установка sprt_cfg_w.sh - скрипт для записи конфигурационного файла Spruthub"
# wget -N -O ~/spruthub/sprt_cfg_w.sh BROKEN_LINK

# echo "=== Установка и запуск pushover.sh"
# wget -N -O ~/spruthub/pushover.sh BROKEN_LINK | bash

# Конец
