#!/usr/bin/env bash

# set the db data folder full path
DATAPATH=$(cd ..; pwd)/data
sed -i -e "s|\$DATAPATH|$DATAPATH|g" pv.yaml
