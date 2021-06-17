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

front() {
  # Start Backend
  export REACT_APP_API_URL="http://127.0.0.1:8000"
  export REACT_APP_JWT_TOKEN="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MjM5NTc2MDksImV4cCI6MTYyNDU2MjQwOSwidXNlciI6InRlc3QiLCJsb2dpbl9zZXNzaW9uIjoiNjMyMjRmYzg5MmZmNDUyMWI4YmZiNjBjYmRmZTdhY2EifQ.yOP-WzkUsb2zsULeZE2Doe6nTcpLV8-lJIxEGf7aZBI"
  cd $CWD/front; npm start
}

test_api() {
  # Authenticate to Backend and get token
  BACKIP="127.0.0.1"
  curl --header "Content-Type: application/json" --request POST --data '{"username": "test", "email": "test@test.com", "password": "pass1234"}' http://$BACKIP:8000/api/auth/signup
  TOKEN=$(curl --header "Content-Type: application/json" --request POST --data '{"username_or_email": "test", "password": "pass1234"}' http://$BACKIP:8000/api/auth/login | jq '.data.token')
  echo Token: $TOKEN
}

if [[ "$1" == "db" || "$1" == "data" || "$1" == "database" ]]; then
  db
elif [[ "$1" == "back" || "$1" == "backend" || "$1" == "api" ]]; then
  back
elif [[ "$1" == "test" ]]; then
  test_api
elif [[ "$1" == "front" || "$1" == "frontend" ]]; then
  front
fi
