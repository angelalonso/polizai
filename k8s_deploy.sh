#!/usr/bin/env bash
CWD=$(pwd)
KK="sudo k3s kubectl"
ENV=".env"
ENV_TEMPLATE=${ENV}.template

update() {
  echo "pulling latest from Git..."
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
  # reload env vars
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

data() {
  DATA_DIR="${CWD}/database/k8s"
  DUMP_DIR="${CWD}/database/data"
  DUMP_IN_USE_DIR="${DUMP_DIR}/in_use"
  source $ENV

  # Backup files we will modify
  cp ${DATA_DIR}/pv.yaml ${DATA_DIR}/pv.yaml.orig
  cp ${DATA_DIR}/secret.yaml ${DATA_DIR}/secret.yaml.orig
  cp ${DUMP_DIR}/full_datadump.sql ${DUMP_DIR}/full_datadump.sql.orig
  

  DB_NAME_HASH=$(echo -n $DB_NAME | base64 -)
  DB_USER_HASH=$(echo -n $DB_USER | base64 -)
  DB_PASS_HASH=$(echo -n $DB_PASS | base64 -)
  sed -i -e "s|\$DB_NAME|$DB_NAME_HASH|g" ${DATA_DIR}/secret.yaml
  sed -i -e "s|\$DB_USER|$DB_USER_HASH|g" ${DATA_DIR}/secret.yaml
  sed -i -e "s|\$DB_PASS|$DB_PASS_HASH|g" ${DATA_DIR}/secret.yaml

  # Correct the dump (it was created with a generic user name)
  sed -i -e "s|Owner: postgres|Owner: $DB_USER|g" ${DUMP_DIR}/full_datadump.sql
  sed -i -e "s|OWNER TO postgres|OWNER TO $DB_USER|g" ${DUMP_DIR}/full_datadump.sql

  # Create another folder+file to isolate what we keep in Git, what we modify, and what the pods will use
  mkdir -p ${DUMP_IN_USE_DIR}
  cp ${DUMP_DIR}/full_datadump.sql ${DUMP_IN_USE_DIR}/data.sql
  sed -i -e "s|\$DATAPATH|$DUMP_IN_USE_DIR|g" ${DATA_DIR}/pv.yaml
  
  
  # deploy, then recover files to original values
  $KK apply -f ${DATA_DIR}/pv.yaml
  $KK apply -f ${DATA_DIR}/pvc.yaml
  $KK apply -f ${DATA_DIR}/secret.yaml
  $KK apply -f ${DATA_DIR}/deployment.yaml
  $KK apply -f ${DATA_DIR}/service.yaml
  
  cp ${DATA_DIR}/pv.yaml.orig ${DATA_DIR}/pv.yaml
  cp ${DATA_DIR}/secret.yaml.orig ${DATA_DIR}/secret.yaml
  cp ${DUMP_DIR}/full_datadump.sql.orig ${DUMP_DIR}/full_datadump.sql
}

back() {
  BACK_DIR="${CWD}/back/k8s"
  source $ENV

  # Backup files we will modify
  cp ${BACK_DIR}/secret.yaml ${BACK_DIR}/secret.yaml.orig

  back_dbs="{postgres_database={url=postgres://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME}}"
  sed -i -e "s|\$BACK_DBS|\"$back_dbs\"|g" ${BACK_DIR}/secret.yaml

  # deploy, then recover files to original values
  $KK apply -f ${BACK_DIR}/secret.yaml
  $KK apply -f ${BACK_DIR}/hpa.yaml
  $KK apply -f ${BACK_DIR}/deployment.yaml
  $KK apply -f ${BACK_DIR}/service.yaml
  $KK apply -f ${BACK_DIR}/ingress.yaml

  cp ${BACK_DIR}/secret.yaml.orig ${BACK_DIR}/secret.yaml
}

front() {
  FRONT_DIR="${CWD}/front/k8s"
  source $ENV

  # Backup and modify file(s)
  cp ${FRONT_DIR}/deployment.yaml ${FRONT_DIR}/deployment.yaml.orig
  cp ${FRONT_DIR}/secret.yaml ${FRONT_DIR}/secret.yaml.orig

  if [[ $API_TOKEN != "" ]]; then
    read -r -p "Do you want to get a new TOKEN? [y/n]" change_token 
    if [[ $change_token == "y" ]]; then
      curl --header "Content-Type: application/json" --request POST --data '{"username": "${API_USER}", "email": "${API_EMAIL}", "password": "${API_PASS}"}' "${API_URL}"/api/auth/signup
      TOKEN=$(curl --header "Content-Type: application/json" --request POST --data '{"username_or_email": "${API_EMAIL}", "password": "${API_PASS}"}' "${API_URL}"/api/auth/login | jq .data.token)
      sed -i -e "s|API_TOKEN=.*|API_TOKEN=$TOKEN|g" $ENV
      source $ENV
    fi
  else
    curl --header "Content-Type: application/json" --request POST --data '{"username": "${API_USER}", "email": "${API_EMAIL}", "password": "${API_PASS}"}' "${API_URL}"/api/auth/signup
    TOKEN=$(curl --header "Content-Type: application/json" --request POST --data '{"username_or_email": "${API_EMAIL}", "password": "${API_PASS}"}' "${API_URL}"/api/auth/login | jq .data.token)
    sed -i -e "s|API_TOKEN=.*|API_TOKEN=$TOKEN|g" $ENV
    source $ENV
  fi

  sed -i -e "s|\$REACT_APP_API_URL|$API_URL|g" ${FRONT_DIR}/deployment.yaml
  sed -i -e "s|\$REACT_APP_JWT_TOKEN|$API_TOKEN|g" ${FRONT_DIR}/deployment.yaml

  API_TOKEN_HASH=$(echo -n $API_TOKEN | base64 -)
  API_USER_HASH=$(echo -n $API_USER | base64 -)
  API_EMAIL_HASH=$(echo -n $API_EMAIL | base64 -)
  API_PASS_HASH=$(echo -n $API_PASS | base64 -)
  # TODO: make the JWT work here too (careful with special characters)
  #sed -i -e "s|\$JWT_TOKEN|$API_TOKEN_HASH|g" ${FRONT_DIR}/secret.yaml
  sed -i -e "s|\$API_USER|$API_USER_HASH|g" ${FRONT_DIR}/secret.yaml
  sed -i -e "s|\$API_EMAIL|$API_EMAIL_HASH|g" ${FRONT_DIR}/secret.yaml
  sed -i -e "s|\$API_PASS|$API_PASS_HASH|g" ${FRONT_DIR}/secret.yaml

  # Apply and rollback modified file(s)
  $KK apply -f ${FRONT_DIR}/secret.yaml
  $KK apply -f ${FRONT_DIR}/deployment.yaml
  $KK apply -f ${FRONT_DIR}/service.yaml
  $KK apply -f ${FRONT_DIR}/ingress.yaml
  
  cp ${FRONT_DIR}/deployment.yaml.orig ${FRONT_DIR}/deployment.yaml
  cp ${FRONT_DIR}/secret.yaml.orig ${FRONT_DIR}/secret.yaml

}

update
get_envs

if [[ "$1" == "db" || "$1" == "data" || "$1" == "database" ]]; then
  data 
elif [[ "$1" == "back" || "$1" == "backend" || "$1" == "api" ]]; then
  back
elif [[ "$1" == "front" || "$1" == "frontend" ]]; then
  front
else
  echo "We will deploy all"
  data
  back
  front
fi

