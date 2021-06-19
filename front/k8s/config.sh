#!/usr/bin/env bash

# ask the user for the values of the secrets
read -r -p "What is the URL to the API? (include protocol)" URL
read -r -p "What is the USER NAME for the API?" USER
read -r -p "What is the User EMAIL for the API?" EMAIL
read -r -s -p "What is the User PASSWORD for the API?" PASS

curl --header "Content-Type: application/json" --request POST --data '{"username": "${USER}", "email": "${EMAIL}", "password": "${PASS}"}' "${URL}"/api/auth/signup
TOKEN=$(curl --header "Content-Type: application/json" --request POST --data '{"username_or_email": "${EMAIL}", "password": "${PASS}"}' https://api.poliz.ai/api/auth/login)

sed -i -e "s|\$REACT_APP_API_URL|$REACT_APP_API_URL|g" deployment.yaml
sed -i -e "s|\$REACT_APP_JWT_TOKEN|$REACT_APP_JWT_TOKEN|g" deployment.yaml
sed -i -e "s|\$REACT_APP_API_USER|$REACT_APP_API_USER|g" deployment.yaml
sed -i -e "s|\$REACT_APP_API_EMAIL|$REACT_APP_API_EMAIL|g" deployment.yaml
sed -i -e "s|\$REACT_APP_API_PASS|$REACT_APP_API_PASS|g" deployment.yaml
