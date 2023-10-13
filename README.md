# eBot Docker

## Overview
It is a containerized version of eBot, which is a full managed server-bot written in PHP and nodeJS. eBot features easy match creation and tons of player and matchstats. Once it's setup, using the eBot is simple and fast.

## How to run it
You should download the repository content, place it in a folder, and then execute the following commands in the specified order:
```
cp .env.sample .env
chmod a+x setup.sh configure.sh
./setup.sh
docker-compose build
docker-compose up
```

## What needs to be changed
To ensure everything works correctly, you must configure the external addresses for the web and socket services.

### Web
To configure the web service, navigate to etc/eBotWeb and update the ebot_ip property with your external address.

## Socket
To configure the socket service, go to etc/eBotSocket and update the LOG_ADDRESS_SERVER property with your external address.

## Security
To improve security, you should set the web socket secret key in two specific configuration files:

For the web service, go the etc/eBotWeb directory and open the app_user.yml file. Inside this file, locate the WEBSOCKET_SECRET_KEY parameter and replace its value with a strong and unique secret key

For the socket service, navigate to the etc/eBotSocket directory and open the config.ini file. Within this file, find the websocket_secret_key property and update its value with the same key used for the web service. 
