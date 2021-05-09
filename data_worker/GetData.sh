EDGAR="EDGARv5.0_FT2019_fossil_CO2_booklet2020.xls"
EDGAR_SHEET="fossil_CO2_totals_by_country"
EDGAR_RESULT="EDGAR_fossil_CO2_totals_by_country.csv"

wget https://edgar.jrc.ec.europa.eu/booklet/$EDGAR
python3 export.py $EDGAR $EDGAR_SHEET $EDGAR_RESULT

rm $EDGAR

cargo run

#rm $EDGAR_RESULT
mv data.js ../front/src/data/data.js

