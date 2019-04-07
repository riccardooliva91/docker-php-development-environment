#!/bin/bash

BASE_FOLDER=$PWD

for FOLDER in `find -maxdepth 1 -type d ! -path . ! -path ./template ! -path ./.idea ! -path ./.git ! -path ./nginx-proxy`
do
    cd ${FOLDER}
    docker-compose down
    cd ${BASE_FOLDER}
done