#!/usr/bin/env bash

CWD=$(pwd)
DB_USER="postgres"
DB_PASS="postgres"
DB_HOST="172.17.0.2"

db() {
  # Start DB and wait a bit
  cd database
  docker run --rm -v /home/aaf/Software/Dev/polizai/database/data:/docker-entrypoint-initdb.d -e POSTGRES_PASSWORD=${DB_PASS} polizai_db:v0.1 &
  sleep 15
}

back() {
  # Start Backend
  export ROCKET_DATABASES="{postgres_database={url=postgres://${DB_USER}:${DB_PASS}@${DB_HOST}:5432/postgres}}" 
  cd $CWD/back; cargo run
}

test_api() {
  # Authenticate to Backend and get token
  BACKIP="127.0.0.1"
  CMD_2="curl --header \"Content-Type: application/json\" --request POST --data '{\"username\": \"test\", \"email\": \"test@test.com\", \"password\": \"pass1234\"}' http://$BACKIP:8000/api/auth/signup"
  terminator -T "<NAME-1>" -e "${CMD_2}" &
  TOKEN=$(curl --header "Content-Type: application/json" --request POST --data '{"username_or_email": "test", "password": "pass1234"}' http://$BACKIP:8000/api/auth/login | jq '.data.token')
  echo Token: $TOKEN
}

back

