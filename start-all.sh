#!/bin/bash

docker network create demo-network
docker run --name demo-js-console --rm -d -p 8000:80 demo-js-console
docker run --name demo-keycloak --rm -d -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -p 8080:8080 --net demo-network demo-keycloak
docker run --name demo-ldap --rm -d --net demo-network demo-ldap
docker run --name demo-mail --rm -d -p 8025:8025 --net demo-network mailhog/mailhog
