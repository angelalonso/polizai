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

  #### DATABASE VARS

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

  #### API VARS

  if [[ $API_URL == "" ]]; then 
    API_URL="https://api.poliz.ai"
  fi
  read -r -p "What will the API URL be? (default: $API_URL )" api_url
  if [[ $api_url == "" ]]; then api_url=$API_URL; fi

  if [[ $API_USER == "" ]]; then 
    API_USER="PolizaiApp"
  fi
  read -r -p "What will the API USER NAME be? (default: $API_USER )" api_user
  if [[ $api_user == "" ]]; then api_user=$API_USER; fi

  if [[ $API_EMAIL == "" ]]; then 
    API_EMAIL="app@poliz.ai"
  fi
  read -r -p "What will the API User's EMAIL be? (default: $API_EMAIL )" api_email
  if [[ $api_email == "" ]]; then api_email=$API_EMAIL; fi

  while [ "$api_pass" == "" ]; do
    read -r -s -p "What will the API USER's PASSWORD be? " api_pass
    echo 
  done


  # change contents of $ENV
  sed -i -e "s|DB_HOST=.*|DB_HOST=$db_host|g" $ENV
  sed -i -e "s|DB_NAME=.*|DB_NAME=$db_name|g" $ENV
  sed -i -e "s|DB_USER=.*|DB_USER=$db_user|g" $ENV
  sed -i -e "s|DB_PASS=.*|DB_PASS=$db_pass|g" $ENV
  sed -i -e "s|API_URL=.*|API_URL=$api_url|g" $ENV
  sed -i -e "s|API_USER=.*|API_USER=$api_user|g" $ENV
  sed -i -e "s|API_EMAIL=.*|API_EMAIL=$api_email|g" $ENV
  sed -i -e "s|API_PASS=.*|API_PASS=$api_pass|g" $ENV
  echo
  source $ENV
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
  echo "all will be done"
  echo db
  echo back
  front
fi

