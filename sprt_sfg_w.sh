#!/bin/bash

# Скрипт для записи и изменения значений в конфигурационном файле spruthub

# Начало

sprutcfg_json_write()
{
	S_JSON_KEY="$1"
	S_JSON_VALUE="$2"
	jq --arg key "$S_JSON_KEY" --arg value "$S_JSON_VALUE" '. + {($key): ($value)}' ~/spruthub/spruthub.json > ~/spruthub/tmp.spruthub.$$.json && mv ~/spruthub/tmp.spruthub.$$.json ~/spruthub/spruthub.json
}

sprutcfg_json_write $1 $2

tail ~/spruthub/spruthub.json
