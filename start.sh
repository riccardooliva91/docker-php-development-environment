#!/bin/bash

BASE_FOLDER=$PWD

cd nginx-proxy && docker-compose up -d && cd ..

for FOLDER in `find -maxdepth 1 -type d ! -path . ! -path ./template ! -path ./.idea ! -path ./.git`
do
    cd ${FOLDER}
    docker-compose up -d
    cd ${BASE_FOLDER}
done