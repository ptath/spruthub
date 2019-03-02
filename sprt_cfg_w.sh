#!/bin/bash

# Скрипт для записи и изменения значений в конфигурационном файле spruthub
# Версия 0.1

# Начало

sprutcfg_json_write()
{
        S_JSON_KEY="$1"
        S_JSON_VALUE="$2"
        jq --arg key "$S_JSON_KEY" --arg value "$S_JSON_VALUE" '. + {($key): ($value)}' ~/spruthub/spruthub.json
}

sprutcfg_json_write $1 $2

# Показываем лог
#cat ~/spruthub/spruthub.json

# Конец
