#!/bin/bash

# Check if the .installed file exists
if [ ! -f .installed ]; then
    
    git clone https://github.com/deStrO/eBot-CSGO.git temp

    cp -n -R temp/* eBot-CSGO && rm -rf temp

    cd eBot-CSGO
    
    npm install

    composer install
    
    cd ..

    touch .installed

    cd eBot-CSGO

    sleep 120
    
    php bootstrap.php
else
    echo "eBot Socket is already installed. Skipping setup."
    cd eBot-CSGO
    php bootstrap.php
fi
