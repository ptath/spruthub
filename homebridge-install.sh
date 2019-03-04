#!/bin/bash

# Скрипт для установки Homebridge с автоматическим определением платформы,
#   подходит (тестировался) для Raspberry Pi 3 и Raspberry Pi zero
# Версия 0.1

# Начало

# Определяем платформу (код: https://github.com/sdesalas/node-pi-zero/blob/master/install-node-v.lts.sh)
#get pi ARM version
PI_ARM_VERSION=$(
  uname -a |
  egrep 'armv[0-9]+l' -o
);
echo "=== $PI_ARM_VERSION"

case $PI_ARM_VERSION in
  armv6l )
    # Похоже у нас zero или pi 1/2/3A
    echo "=== > $PI_ARM_VERSION - нет поддержки nodejs из репозитория, будем ставить вручную"
    echo "=== Ищем доступные версии..."

    #get latest nodejs version from node website
    #read the first version that matches the arm platform
    NODE_VERSION=$(
      curl https://nodejs.org/dist/index.json |
      egrep "{\"version\":\"v([0-9]+\.?){3}\"[^{]*\"linux-"$PI_ARM_VERSION"[^}]*lts\":\"[^\"]+\"" -o |
      head -n 1
    );

    #get the version
    VERSION=$(
      echo $NODE_VERSION |
      egrep 'v([0-9]+\.?){3}' -o
    );
    echo "=== > Последняя доступная версия $VERSION"

    #get lts version
    LTS_VERSION=$(echo $NODE_VERSION |
      egrep '"[^"]+"$' -o |
      egrep '[a-zA-Z]+' -o |
      tr '[:upper:]' '[:lower:]'
    );
    echo "=== > Версия длительной поддержки LTS (Long Term Support): $LTS_VERSION"

    read -t 10 -n 1 -p "=== Установить LTS (Stable, рекомендуется) или последнюю $VERSION (Latest)? (S/l): " version_choice
    [ -z "$version_choice" ] && version_choice="s"
    case $version_choice in
            s|S )
              echo " Ставим LTS" &&
              script_url="https://github.com/sdesalas/node-pi-zero/raw/master/install-node-v.lts.sh"
            ;;
            l|L|* )
              echo " Ставим $VERSION" &&
              script_url="https://github.com/sdesalas/node-pi-zero/raw/master/install-node-v.last.sh"
            ;;
    esac

    echo "=== Будем ставить отсюда $script_url"
    

  ;;
  armv7l ) echo "=== > $PI_ARM_VERSION - ставим nodejs из системного репозитория"
  ;;
  armv8l ) echo "=== > $PI_ARM_VERSION - наконец-то! 64-битность завезли!!! Ура!!!!" && exit;;
  *) echo "=== > $PI_ARM_VERSION Что ты такое? Не знаю что делать с такой архитектурой процессора" && exit;;
esac

# Ставим менеджер пакетов nodejs
echo "=== Устанавливаем менеджер пакетов npm"

#wget -O - https://raw.githubusercontent.com/sdesalas/node-pi-zero/master/install-node-v.lts.sh | bash
