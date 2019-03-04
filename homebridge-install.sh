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

#get latest nodejs version from node website
#read the first version that matches the arm platform
NODE_VERSION=$(
  curl https://nodejs.org/dist/index.json |
  egrep "{\"version\":\"v([0-9]+\.?){3}\"[^{]*\"linux-"$PI_ARM_VERSION"[^}]*lts\":\"[^\"]+\"" -o |
  head -n 1
);
echo "=== $NODE_VERSION"

#get the version
VERSION=$(
  echo $NODE_VERSION |
  egrep 'v([0-9]+\.?){3}' -o
);
echo "=== $VERSION"

#get lts version
LTS_VERSION=$(echo $NODE_VERSION |
  egrep '"[^"]+"$' -o |
  egrep '[a-zA-Z]+' -o |
  tr '[:upper:]' '[:lower:]'
);
echo "=== $LTS_VERSION"

#wget -O - https://raw.githubusercontent.com/sdesalas/node-pi-zero/master/install-node-v.lts.sh | bash
