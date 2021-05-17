#!/usr/bin/env bash

# set the db data folder full path
DATAPATH=$(cd ..; pwd)/data
sed -i -e "s|\$DATAPATH|$DATAPATH|g" pv.yaml

# ask the user for the values of the secrets
read -r -p "What will the DB USER be? " user
read -r -s -p "What will the DB PASSWORD be? " pass

DB_NAME=$(echo -n "public" | base64 -)
DB_USER=$(echo -n $user | base64 -)
DB_PASS=$(echo -n $pass | base64 -)
sed -i -e "s|\$DB_NAME|$DB_NAME|g" secret.yaml
sed -i -e "s|\$DB_USER|$DB_USER|g" secret.yaml
sed -i -e "s|\$DB_PASS|$DB_PASS|g" secret.yaml


# Correct the dump: MODIFY THIS IF YOU CREATED THE DUMP WITH OTHER USER/SCHEMA NAMES!!
sed -i -e "s|Owner: postgres|Owner: $user|g" ../data/full_datadump.sql
sed -i -e "s|OWNER TO postgres|OWNER TO $user|g" ../data/full_datadump.sql

sed -i -e "s|Schema: public|Schema $name|g" ../data/full_datadump.sql
sed -i -e "s|COPY public\.co2|COPY $name.co2|g" ../data/full_datadump.sql
sed -i -e "s|TABLE public\.co2|TABLE $name.co2|g" ../data/full_datadump.sql
