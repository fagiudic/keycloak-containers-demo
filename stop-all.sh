#!/bin/bash

docker stop demo-js-console demo-keycloak demo-ldap demo-mail
docker network rm demo-network
