#!/usr/bin/env bash

# set the db data folder full path
DATAPATH=$(cd ..; pwd)/data
sed -i -e "s|\$DATAPATH|$DATAPATH|g" pv.yaml

# ask the user for the values of the secrets
read -r -p "What will the DB USER be? " user
read -r -s -p "What will the DB PASSWORD be? " pass
dbname="public"

DB_NAME=$(echo -n $dbname | base64 -)
DB_USER=$(echo -n $user | base64 -)
DB_PASS=$(echo -n $pass | base64 -)
sed -i -e "s|\$DB_NAME|$DB_NAME|g" secret.yaml
sed -i -e "s|\$DB_USER|$DB_USER|g" secret.yaml
sed -i -e "s|\$DB_PASS|$DB_PASS|g" secret.yaml
# We need this for the API too
back_dbs_string="'{postgres_database={url=\"postgres://$user:$pass@polizai-db:5432/$dbname\"}}'"
BACK_DBS=$(echo -n $back_dbs_string | base64 -)
sed -i -e "s|\$BACK_DBS|$BACK_DBS|g" ../../back/k8s/secret.yaml


# Correct the dump: MODIFY THIS IF YOU CREATED THE DUMP INITIALLY WITH OTHER USER NAME!!
sed -i -e "s|Owner: postgres|Owner: $user|g" ../data/full_datadump.sql
sed -i -e "s|OWNER TO postgres|OWNER TO $user|g" ../data/full_datadump.sql
