#!/bin/bash

# Скрипт для изменения имени хоста (hostname)
# Версия 0.1

# Начало

echo "=== Сейчас hostname (сетевое имя устройства):"
cat /etc/hostname

echo "=== Новое hostname (ENTER или 30 сек. чтобы оставить как есть):"
read -t 30 HOSTNAME
if [ "$HOSTNAME" != "" ]; then
        sudo hostnamectl set-hostname $HOSTNAME
        echo "=== Проверяем hostname:"
        cat /etc/hostname
        echo "=== Изменения вступят в силу после перезагрузки (sudo reboot now)"
else
        echo "=== Hostname не изменено"
fi

echo "====== sprt-hostname.sh завершён ======"

# Конец
