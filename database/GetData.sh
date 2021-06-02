#!/usr/bin/env bash

####################################################
#  CO2 Data:
#  https://edgar.jrc.ec.europa.eu/booklet/$EDGAR
####################################################

EDGAR="EDGARv5.0_FT2019_fossil_CO2_booklet2020.xls"
COUNTRY_SHEET="fossil_CO2_totals_by_country"
SECTOR_SHEET="fossil_CO2_by_sector_and_countr"

source ./.env

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

# Correct the CSVs
sed -i -e '/^"","","","",/d' EDGAR_$COUNTRY_SHEET.csv
tail -n +2 EDGAR_$COUNTRY_SHEET.csv > EDGAR_$COUNTRY_SHEET.csv.tmp
cat EDGAR_$COUNTRY_SHEET.csv.tmp > EDGAR_$COUNTRY_SHEET.csv
rm EDGAR_$COUNTRY_SHEET.csv.tmp

cp EDGAR_$SECTOR_SHEET.csv EDGAR_$SECTOR_SHEET.csv.orig
sed -i -e 's/"NULL"/"0.0"/g' EDGAR_$SECTOR_SHEET.csv
sed -i -e 's/,,/,"0.0",/g' EDGAR_$SECTOR_SHEET.csv
tail -n +2 EDGAR_$SECTOR_SHEET.csv > EDGAR_$SECTOR_SHEET.csv.tmp
cat EDGAR_$SECTOR_SHEET.csv.tmp > EDGAR_$SECTOR_SHEET.csv
rm EDGAR_$SECTOR_SHEET.csv.tmp

# Load the Schemas and Data
psql -h "$PGRES_HOST" -p "$PGRES_PORT" -U "$PGRES_USER" -f schemas_n_data.sql

## Make a dump of the data
pg_dump -h "$PGRES_HOST" -p "$PGRES_PORT" -U "$PGRES_USER" postgres > full_datadump.sql
mv full_datadump.sql data/
