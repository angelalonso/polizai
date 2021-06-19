#!/usr/bin/env bash
KK="sudo k3s kubectl"
ENV=".env"
ENV_TEMPLATE=${ENV}.template

update() {
  git pull
}

ask_for_vars() {
  # load current values
  source $ENV

  # ask the user for the values of the secrets, using current as default
  if [[ $DB_HOST == "" ]]; then 
    DB_HOST="polizai-db:5432"
  fi
  read -r -p "What will the DB HOST:PORT be? (default: $DB_HOST )" db_host
  if [[ $db_host == "" ]]; then db_host=$DB_HOST; fi

  if [[ $DB_NAME == "" ]]; then 
    DB_NAME="public"
  fi
  read -r -p "What will the DB NAME be? (default: $DB_NAME )" db_name
  if [[ $db_name == "" ]]; then db_name=$DB_NAME; fi

  if [[ $DB_USER == "" ]]; then 
    DB_USER="polizai"
  fi
  read -r -p "What will the DB USER be? (default: $DB_USER )" db_user
  if [[ $db_user == "" ]]; then db_user=$DB_USER; fi

  while [ "$db_pass" == "" ]; do
    read -r -s -p "What will the DB PASSWORD be? " db_pass
    echo 
  done

  # change contents of $ENV
  sed -i -e "s|DB_HOST=.*|DB_HOST=$db_host|g" $ENV
  sed -i -e "s|DB_NAME=.*|DB_NAME=$db_name|g" $ENV
  sed -i -e "s|DB_USER=.*|DB_USER=$db_user|g" $ENV
  sed -i -e "s|DB_PASS=.*|DB_PASS=$db_pass|g" $ENV
  echo
}

get_envs() {
  if [[ ! -f "$ENV" ]]; then
  # if there is no ENV file, create it from template
    cp $ENV_TEMPLATE $ENV
    new_env="true"
  fi
  # ask for vars if its a new file
  if [[ $new_env == "true" ]]; then
    ask_for_vars
  else 
    # offer possibility to change vars too
    read -r -p "Do you want to adapt the ENV Variables? [y/n]" change 
    if [[ $change == "y" ]]; then
      ask_for_vars
    fi
  fi

}

db() {
  echo "db"

}

front() {
  $KK apply -f front/k8s/deployment.yaml
}

update
get_envs

if [[ "$1" == "db" || "$1" == "data" || "$1" == "database" ]]; then
  echo db
elif [[ "$1" == "back" || "$1" == "backend" || "$1" == "api" ]]; then
  echo back
elif [[ "$1" == "test" ]]; then
  echo test_api
elif [[ "$1" == "front" || "$1" == "frontend" ]]; then
  front
else
  echo "nothing to be done"
fi
