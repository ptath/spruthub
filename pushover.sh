#!/bin/bash

# Скрипт отправки сообщений на iOS/Android устройства
# Версия 0.1

# Начало

# Проверка конфигурации и в случае необходимости установка ключей

USER_TOKEN=$(jq -r '."PUSHOVER_USER_TOKEN"' < ~/spruthub/spruthub.conf)

if [ $USER_TOKEN == "null" ] || [ $USER_TOKEN == \"\" ];then
	echo "=== USER TOKEN ((https://pushover.net) не установлен, введи его и ENTER:"
	# Таймаут 5 минут
	read -t 300 PUSHOVER_USER_TOKEN
		if [ "$PUSHOVER_USER_TOKEN" != "" ]; then
        		~/spruthub/sprt_cfg_w.sh PUSHOVER_USER_TOKEN "$PUSHOVER_USER_TOKEN"
			echo "$(jq '."PUSHOVER_USER_TOKEN"' < ~/spruthub/spruthub.conf)"
		else
			echo "=== USER TOKEN не установлен"
		fi
else
	echo "=== USER TOKEN установлен: $(jq '."PUSHOVER_USER_TOKEN"' < ~/spruthub/spruthub.conf)"
fi

API_TOKEN=$(jq -r '."PUSHOVER_API_TOKEN"' < ~/spruthub/spruthub.conf)

if [ $API_TOKEN == "null" ] || [ $API_TOKEN == \"\" ];then
	echo "=== API TOKEN (https://pushover.net/apps) не установлен, введи его и ENTER:"
	# Таймаут 5 минут
	read -t 300 PUSHOVER_API_TOKEN
  	if [ "$PUSHOVER_API_TOKEN" != "" ]; then
              ~/spruthub/sprt_cfg_w.sh PUSHOVER_API_TOKEN "$PUSHOVER_API_TOKEN"
              echo "$(jq '."PUSHOVER_API_TOKEN"' < ~/spruthub/spruthub.conf)"
    else
      echo "=== API TOKEN не установлен"
    fi
else
        echo "=== API TOKEN установлен: $(jq '."PUSHOVER_API_TOKEN"' < ~/spruthub/spruthub.conf)"
fi

# Сброс ключей

if [ "$1" = "setup" ];then
        echo "=== Режим настройки, удаляем старые токены..."
        ~/spruthub/sprt_cfg_w.sh PUSHOVER_USER_TOKEN ""
        ~/spruthub/sprt_cfg_w.sh PUSHOVER_API_TOKEN ""

        echo "=== Введи USER TOKEN: "
        read -t 300 PUSHOVER_USER_TOKEN
                if [ "$PUSHOVER_USER_TOKEN" != "" ]; then
                        ~/spruthub/sprt_cfg_w.sh PUSHOVER_USER_TOKEN "$PUSHOVER_USER_TOKEN"
                        echo "$(jq '."PUSHOVER_USER_TOKEN"' < ~/spruthub/spruthub.conf)"
                else
                        echo "=== USER TOKEN не установлен"
                fi

        echo "=== Введи API TOKEN: "
        read PUSHOVER_API_TOKEN
                if [ "$PUSHOVER_API_TOKEN" != "" ]; then
                        ~/spruthub/sprt_cfg_w.sh PUSHOVER_API_TOKEN "$PUSHOVER_API_TOKEN"
                        echo "$(jq '."PUSHOVER_API_TOKEN"' < ~/spruthub/spruthub.conf)"
                else
                        echo "=== API TOKEN не установлен"
                fi

exit
fi


# Если нет параметров, показываем инструкцию и выходим
if [ $# -eq 0 ]; then
        cat <<INFO

Pushover (https://pushover.net) - сервис для отравки push-сообщений на iOS/Android устройства.
Требует установленного приложения на телефоне и стоит 5 долларов навсегда (через неделю).

Использование:
        ./pushover.sh "сообщение" "заголовок" "звук" setup

        Кавычки обязательны если сообщение или заголовок состоят более чем из одного слова

        "сообщение" обязательный параметр
        "заголовок" необязательно
        "звук" необязательно, смотри https://pushover.net/api#sounds для названий звуков
	setup (БЕЗ кавычек всегда) произойдет сброс и новая установка API ключей

Примеры:
        ./pushover.sh "Пару дней назад я познакомился с ..."
                только сообщение
        ./pushover.sh "Пару дней" "ЛОЛ" "echo"
                сообщение с заголовком и звуком echo
        ./pushover.sh "\`ls -la\`"
                вывод результата shell команды "ls -la"
		Если вызванное приложение не завершится (ping или подобное, всё зависнет =)

INFO
        exit
fi

# Отправка сообщений

MESSAGE=$1
TITLE=$2
SOUND=$3

if [ $# -lt 2 ]; then
	TITLE="`whoami`@${HOSTNAME}"
fi

wget https://api.pushover.net/1/messages.conf --post-data="token=$API_TOKEN&user=$USER_TOKEN&message=$MESSAGE&title=$TITLE&sound=$SOUND&priority=$PRIORITY&device=$DEVICE" -qO- > /dev/null 2>&1 &
echo "=== Сообщение отправлено"

# Конец
