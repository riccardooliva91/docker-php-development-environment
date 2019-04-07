#!/bin/bash

# Simple string sanitization function
sanitize() {
    STRING=$1
    STRING=${STRING,,}      # lowercase
    STRING="${STRING// /-}" # replace spaces
    STRING="${STRING/\//-}" # replace slashes
    echo ${STRING}
}

# Check current directory
WORKING_DIR=$PWD

# Project name
echo "Which is your project name?"
read PROJECT_NAME
if [ -z "$PROJECT_NAME" ]
then
    echo "Invalid project name"
    exit 0
fi
if [ -d "${WORKING_DIR}/${PROJECT_NAME}" ]
then
    echo "Project already exists"
    exit 0
fi
PROJECT_NAME=$(sanitize "$PROJECT_NAME")

# Project domain
echo "Which is your project domain?"
read PROJECT_DOMAIN
if [ -z "$PROJECT_DOMAIN" ]
then
    echo "Invalid project domain"
    exit 0
fi
PROJECT_DOMAIN=$(sanitize "$PROJECT_DOMAIN")

# Copy template
cp -r "${WORKING_DIR}/template" "${WORKING_DIR}/${PROJECT_NAME}"
echo "Copied template"

# Replace
#find "./dockertest1" -type f -not -path "*.git" -not -name "*.backup" -not -name ".git*" -not -name "*-Dockerfile" | xargs sed -i -e 's/PROJECTNAME/dockertest1/g'
find "${WORKING_DIR}/${PROJECT_NAME}" -type f -not -path "*.git" -not -name "*.backup" -not -name ".git*" -not -name "*-Dockerfile" | \
    xargs sed -i -e "s/PROJECTNAME/$PROJECT_NAME/g"
# Replace
find "${WORKING_DIR}/${PROJECT_NAME}" -type f -not -path "*.git" -not -name "*.backup" -not -name ".git*" -not -name "*-Dockerfile" | \
    xargs sed -i -e "s/PROJECTDOMAIN/$PROJECT_DOMAIN/g"
echo "Replaced placeholders"

echo "I need admin permissions to update your /etc/hosts file. If you want to skip it, just exit with CTRL+C"
sudo -- sh -c -e "echo '127.0.0.1'  $PROJECT_DOMAIN >> /etc/hosts"
echo "Updated /etc/hosts file"
