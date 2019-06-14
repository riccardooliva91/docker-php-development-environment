#!/bin/bash

BASE_FOLDER=$PWD

for FOLDER in `find -maxdepth 1 -type d ! -path . ! -path ./template ! -path ./.idea ! -path ./.git`
do
    cd ${FOLDER}
    docker-compose stop
    cd ${BASE_FOLDER}
done
