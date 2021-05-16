#!/usr/bin/env bash

####################################################
#  CO2 Data:
#  https://edgar.jrc.ec.europa.eu/booklet/$EDGAR
####################################################

EDGAR="EDGARv5.0_FT2019_fossil_CO2_booklet2020.xls"
COUNTRY_SHEET="fossil_CO2_totals_by_country"
SECTOR_SHEET="fossil_CO2_by_sector_and_countr"

# Download EDGAR Dataset
if [[ ! -f "$EDGAR" ]]; then
  echo "Downloading $EDGAR..."
  wget https://edgar.jrc.ec.europa.eu/booklet/$EDGAR
else
  echo "$EDGAR has already been downloaded"
fi

# Get CSV for fossil_CO2_totals_by_country Sheet
if [[ ! -f "EDGAR_$COUNTRY_SHEET.csv" ]]; then
  echo "Extracting $COUNTRY_SHEET from $EDGAR"
  python3 export.py $EDGAR $COUNTRY_SHEET EDGAR_$COUNTRY_SHEET.csv
else
  echo "$COUNTRY_SHEET has already been extracted"
fi

# Get CSV for fossil_CO2_totals_by_sector_and_countr Sheet
if [[ ! -f "EDGAR_$SECTOR_SHEET.csv" ]]; then
  echo "Extracting $SECTOR_SHEET from $EDGAR"
  python3 export.py $EDGAR $SECTOR_SHEET EDGAR_$SECTOR_SHEET.csv
else
  echo "$SECTOR_SHEET has already been extracted"
fi
CWD=$(pwd)
cd data_worker
cargo run

mv data.js ../../front/src/data/data.js
cd $CWD
