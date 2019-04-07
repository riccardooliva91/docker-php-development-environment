# docker-php-development-environment
A docker setup to quickly start with your dockerized development. This setup allows you to create custom domains for your installations and to hos them on the same machine without any hussle. This setup is intended for __development__, I've never tested this on production. Hovewer this should be fine if you don't need a swarm or more advanced infrastrucutures.

This environment comes bundled with PHP, but it's generic enough to be customizable with other languages. Feedbacks/suggestions are appreciated!

## What you've got
### The reverse proxy
The `nginx-proxy` folder contains a ready-to-go reverse proxy made by @jwilder (check out his work here: https://github.com/jwilder/nginx-proxy). You always need it up and running. You'll find a `cert`folder inside which contains demo self-signed SSL certifications. More information about local SSL ahead.
Be sure to launch the proxy __before__ launching every other project. If you need information about the proxy configuration, or if you want to customize it even further, refer to the documentation in the readme of the main project (link above).
*Before you start you will probably need to create a new network*. If that's the case just type `docker network create nginx-proxy` in a shell window.

### The `template` folder
This is an example setup used by the `create.sh` utlility script. More information ahead.
A default project will include:
* The latest NginX version (official image)
* A customizable PHP7.3-fpm image (the soruce is the official image)
* A MariaDB instance (official image)
* A Redis instance (official image)

## Manually creating a project
If you wish to create a new project, copy and paste the `template directory`, renaming it as you wish. Be sure to replace the `PROJECTNAME` and `PROJECTDOMAIN` placeholders in the `docker-compose.yml` file and in the `nginx/default.conf` file.

## Creating a project via the `create.sh` script
From the root folder, launch `./create.sh` and follow the instructions. You will be asked for the project name, the project domain and,if you provide sudo privileges, an entry will be added to your `/etc/hosts` file. __Don't__ launch this script as sudo, you will be propted for the password.

## Local domains
In order to connect a local domain to a project's nginx instance, you need to edit the `VIRTUAL_HOST` entry under the `environment` section:
```
nginx-example:
image: nginx:latest
container_name: PROJECTNAME-server
expose:
  - 80 # this should match encironment's VIRTUAL_HOST
volumes:
  - ./htdocs:/usr/share/nginx/htdocs
  - ./nginx:/etc/nginx/conf.d
environment:
  VIRTUAL_HOST: example.test    # here goes your domain
  VIRTUAL_PORT: 80              # This should be left 80
links:
  - php-example
```
You should also add a line to your `/etc/hosts` file to register your development domain. In this example it would be `127.0.0.1 example.test`

## Local SSL
In order to connect with SSL to your test domains, you need a `domainname.domainext.crt` and a `domainname.domainext.key` self-signed certificates in your `nginx-proxy/certs` folder. You may create them as you prefer, like using OpenSSL, the `create-ssl-certificate` npm package (https://www.npmjs.com/package/create-ssl-certificate) or online here: http://www.selfsignedcertificate.com/.
You will find some example files in the folder.

## Bulk start/stop
If you wish to start/stop the docker instances in bulk, you can just use the `start.sh` and the `stop.sh` scripts. The proxy will be launched before every other project.

## Customiziong php extension
There is a `php-Dockerfile` on each project you can use to add PHP extensions. If you need informations about that, you can refer to the official image documentation here: https://hub.docker.com/_/php 

## NginX configuration
The `nginx` folder contained in each project is shared with the nginx container's `/etc/nginx/conf.d` folder. The `default.conf` file should be customized in order to serve your code correctly. Of course, if you wish you can customize nginx even more. However I raccomend to keep one website/application per project in order to avoid issues with the reverse proxying.

## Refer to Redis/MariaDB
If you need to specify the host of Redis or MariaDB in your code, you can just type in `redis-projectname` or `mariadb-projectname` where of course `projectname` is the name of the project you are working in.
