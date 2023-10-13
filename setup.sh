#!/usr/bin/env bash

red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'
magenta='\e[1;35m%s\e[0m\n'
cyan='\e[1;36m%s\e[0m\n'

function yesNo() {
    while true; do
        read -p "$1 [y/n]: " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

function ask_with_default() {
    local prompt="$1"
    local default_value="$2"

    read -p "${prompt} [current: ${default_value}]: " input_value
    if [[ -z "$input_value" ]]; then
        echo "$default_value"
    else
        echo "$input_value"
    fi
}


printf "$green" "eBot setup script"
printf "This script will only configure the .env file. You must run or accept to run the ./configure.sh\r\n"


if yesNo "Would you like to fresh the configs files by downloading recent configuration from github (main branch) ?"
then
  wget https://raw.githubusercontent.com/deStrO/eBot-CSGO-Web/master/config/app_user.yml.default -O ./etc/eBotWeb/app_user.yml
  wget https://raw.githubusercontent.com/deStrO/eBot-CSGO-Web/master/config/databases.yml -O ./etc/eBotWeb/databases.yml
  wget https://raw.githubusercontent.com/deStrO/eBot-CSGO/master/config/config.ini.smp -O ./etc/eBotSocket/config.ini
fi

function generatePassword() {
    openssl rand -hex 16
}

cp .env .env.bak
if yesNo "Would you like generate a new random websocket secrets ?"
then
  NEW_WEBSOCKET_SECRET_KEY=$(generatePassword)
  sed -i -e "s#WEBSOCKET_SECRET_KEY=.*#WEBSOCKET_SECRET_KEY=${NEW_WEBSOCKET_SECRET_KEY}#g" \
      "$(dirname "$0")/.env"
fi

if  yesNo "Would you like generate new mysql random password "
then
  NEW_MYSQL_ROOT_PASSWORD=$(generatePassword)
  NEW_MYSQL_PASSWORD=$(generatePassword)
  sed -i -e "s#MYSQL_ROOT_PASSWORD=.*#MYSQL_ROOT_PASSWORD=${NEW_MYSQL_ROOT_PASSWORD}#g" \
      -e "s#MYSQL_PASSWORD=.*#MYSQL_PASSWORD=${NEW_MYSQL_PASSWORD}#g" \
      "$(dirname "$0")/.env"
fi

source .env

printf "$green" "Now doing the default configuration of eBot web"

EBOT_ADMIN_LOGIN=$(ask_with_default "eBot Web login" $EBOT_ADMIN_LOGIN)
EBOT_ADMIN_PASSWORD=$(ask_with_default "eBot Web password" $EBOT_ADMIN_PASSWORD)
EBOT_ADMIN_EMAIL=$(ask_with_default "eBot Web email" $EBOT_ADMIN_EMAIL)

sed -i -e "s#EBOT_ADMIN_LOGIN=.*#EBOT_ADMIN_LOGIN=${EBOT_ADMIN_LOGIN}#g" \
    -e "s#EBOT_ADMIN_PASSWORD=.*#EBOT_ADMIN_PASSWORD=${EBOT_ADMIN_PASSWORD}#g" \
    -e "s#EBOT_ADMIN_EMAIL=.*#EBOT_ADMIN_EMAIL=${EBOT_ADMIN_EMAIL}#g" \
    "$(dirname "$0")/.env"

printf "$green" "Now configuring IP & logs receiver"
echo "Before going further, you need to understand the concept with the new system of logs"
echo "The CS2 server will send the logs via HTTP to the logs-receiver"
echo "This log receiver is exposed by docker on port 12345 by default"
echo "On the next question, you will have to give the full web address of the logger, that have to be reachable from the server"
echo "If your ip is 123.123.123.123, you must fill http://123.123.123.123:12345"
LOG_ADDRESS_SERVER=$(ask_with_default "Log address server" $LOG_ADDRESS_SERVER)

sed -i -e "s#LOG_ADDRESS_SERVER=.*#LOG_ADDRESS_SERVER=${LOG_ADDRESS_SERVER}#g" \
    "$(dirname "$0")/.env"

echo "Now, for the web part, we need to know on which IP the server will run, please fill in the IP of the server (public or lan) (format 123.123.123.123)"
echo "You won't be able to connect to the websocket server for realtime updates if you don't give us the right IP."

EBOT_IP=$(ask_with_default "Log address server" $EBOT_IP)
sed -i -e "s#EBOT_IP=.*#EBOT_IP=${EBOT_IP}#g" \
    "$(dirname "$0")/.env"

if yesNo "Would you like regenerate all configuration files ?"
then
    ./configure.sh
fi
