#!/bin/bash

# Скрипт для установки Homebridge с автоматическим определением платформы,
#   подходит (тестировался) для Raspberry Pi 3 и Raspberry Pi zero
# Версия 0.1

# Начало

if [ $(dpkg-query -W -f='${Status}' "node" 2>/dev/null | grep -c "ok installed") -eq 0 ];then
      echo "=== > Node.js не установлен, ставим..."
else
      echo "=== > Node.js уже установлен:"
      node -v
fi

# Определяем платформу (код: https://github.com/sdesalas/node-pi-zero/blob/master/install-node-v.lts.sh)
#get pi ARM version
PI_ARM_VERSION=$(
  uname -a |
  egrep 'armv[0-9]+l' -o
);

case $PI_ARM_VERSION in
  armv6l )
    # Похоже у нас zero или pi 1/2/3A
    echo "=== > $PI_ARM_VERSION - нет поддержки Node.js из репозитория, будем ставить вручную"
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
    echo "=== > Последняя доступная версия: $VERSION"

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
            s|S|* )
              echo " Ставим LTS" &&
              script_url="https://github.com/sdesalas/node-pi-zero/raw/master/install-node-v.lts.sh"
            ;;
            l|L )
              echo " Ставим $VERSION" &&
              script_url="https://github.com/sdesalas/node-pi-zero/raw/master/install-node-v.last.sh"
            ;;
    esac

    echo "=== > Будем ставить отсюда $script_url"
    wget -q -N -O /tmp/install-node.sh "$script_url" &&
      chmod +x /tmp/install-node.sh &&
      /tmp/install-node.sh &&
      rm /tmp/install-node.sh

    if [ $(cat ~/.profile 2>/dev/null | grep -c "export PATH=\$PATH:/opt/nodejs/bin") -eq 0 ];then
      echo "=== > Добавляем /opt/nodejs/bin в PATH ~/.profile"
      echo "export PATH=\$PATH:/opt/nodejs/bin" >> ~/.profile
    else
      echo "=== > Путь /opt/nodejs/bin найден в ~/.profile, пропускаем"
    fi
  ;;

  armv7l )
    # Похоже у нас современная Raspberry Pi (2B или лучше)
    if [ $(dpkg-query -W -f='${Status}' "node" 2>/dev/null | grep -c "ok installed") -eq 0 ];then
          echo "=== > $PI_ARM_VERSION - ставим nodejs из системного репозитория"
          sudo apm install nodejs -y
    else
          echo "=== > Node.js уже установлен"
    fi
  ;;

  armv8l ) echo "=== > $PI_ARM_VERSION - наконец-то! 64-битность завезли!!! Ура!!!!" && exit;;
  *) echo "=== > $PI_ARM_VERSION Что ты такое? Не знаю что делать с такой архитектурой процессора" && exit;;
esac

# Проверяем версию
echo "=== Проверяем установленную версию Node.js..."
node -v

# Ставим дополнительные пакеты, необходимые для Homebridge
echo "=== Установка дополнительных пакетов..."

# Списком потому что возможно добавятся еще
packages2install=(
libavahi-compat-libdnssd-dev
jq
)

for item in ${packages2install[*]}
do
  package_name=$item
  if [ $(dpkg-query -W -f='${Status}' "$package_name" 2>/dev/null | grep -c "ok installed") -eq 0 ];then
        echo "=== > "$package_name" не установлен, ставим..."
        sudo apt install "$package_name" -y
  else
        echo "=== > "$package_name" уже установлен"
  fi
done

# Ставим менеджер пакетов nodejs (он стандартный?)
# echo "=== Устанавливаем (обновляем) менеджер пакетов npm"
echo "=== Установка Homebridge и дополнительных пакетов Node.js"

# Список пакетов
npm_packages2install=(
homebridge
homebridge-config-ui-x
homebridge-zigbee
pm2
)

[ -e /tmp/npm_installed_list ] &&
  rm /tmp/npm_installed_list &&
  echo $(npm list -g --depth 0) > /tmp/npm_installed_list

for item in ${npm_packages2install[*]}
do
  package_name=$item
  if [ $(cat /tmp/npm_installed_list 2>/dev/null | grep -c "$package_name@") -eq 0 ];then
    echo "=== > "$package_name" не установлен, ставим..."
    npm install -g "$package_name"
  else
    read -t 10 -n 1 -p "=== > "$package_name" уже установлен, переустановить? (N/y): " reinstall_choice
    [ -z "$reinstall_choice" ] && reinstall_choice="n"
    case $version_choice in
            y|Y )
              echo " Переустанавливаем..." &&
              npm remove -g "$package_name" &&
              npm install -g "$package_name"
            ;;
            n|N|* )
              echo " Оставляем"
            ;;
    esac
  fi
done

#

#wget -O - https://raw.githubusercontent.com/sdesalas/node-pi-zero/master/install-node-v.lts.sh | bash
