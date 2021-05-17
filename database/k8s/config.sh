#!/usr/bin/env bash

# set the db data folder full path
DATAPATH=$(cd ..; pwd)/data
sed -i -e "s|\$DATAPATH|$DATAPATH|g" pv.yaml

# ask the user for the values of the secrets
read -r -p "What will the DB NAME be? " name
read -r -p "What will the DB USER be? " user
read -r -s -p "What will the DB PASSWORD be? " pass

DB_NAME=$(echo -n $name | base64 -)
DB_USER=$(echo -n $user | base64 -)
DB_PASS=$(echo -n $pass | base64 -)
sed -i -e "s|\$DB_NAME|$DB_NAME|g" secret.yaml
sed -i -e "s|\$DB_USER|$DB_USER|g" secret.yaml
sed -i -e "s|\$DB_PASS|$DB_PASS|g" secret.yaml


sed -i -e "s|Owner: postgres|Owner: $DB_USER|g" ../data/full_datadump.sql
sed -i -e "s|OWNER TO postgres|OWNER TO $DB_USER|g" ../data/full_datadump.sql
