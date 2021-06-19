#!/usr/bin/env bash
KK="sudo k3s kubectl"

git pull

db() {

}

front() {
  $KK apply -f front/k8s/deployment.yaml
}



if [[ "$1" == "db" || "$1" == "data" || "$1" == "database" ]]; then
  echo db
elif [[ "$1" == "back" || "$1" == "backend" || "$1" == "api" ]]; then
  echo back
elif [[ "$1" == "test" ]]; then
  echo test_api
elif [[ "$1" == "front" || "$1" == "frontend" ]]; then
  front
fi
