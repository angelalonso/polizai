EDGAR="EDGARv5.0_FT2019_fossil_CO2_booklet2020.xls"
wget https://edgar.jrc.ec.europa.eu/booklet/$EDGAR
python3 export.py $EDGAR
rm $EDGAR
#libreoffice --headless --convert-to xlsx $EDGAR --outdir ./tmp/
#cd ./tmp/
#
#for i in 1 2 3 4; do
#  xlsx2csv -s $i $EDGAR ../tmp/$EDGAR-$i.csv
#done
