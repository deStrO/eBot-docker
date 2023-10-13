FROM node:18

RUN apt-get update && apt-get install -y --force-yes git && apt-get clean

RUN npm install -g typescript ts-node

WORKDIR /app

RUN git clone https://github.com/deStrO/ebot-project.git

WORKDIR /app/ebot-project

RUN npm install

CMD ["ts-node", "src/logs-receiver", "./configs/config.json"]
