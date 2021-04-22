import xlrd
import csv
import sys

def csv_from_excel(xls_file):
    wb = xlrd.open_workbook(xls_file)
    sh = wb.sheet_by_name('fossil_CO2_totals_by_country')
    your_csv_file = open(xls_file + 'fossil_CO2_totals_by_country.csv', 'w')
    wr = csv.writer(your_csv_file, quoting=csv.QUOTE_ALL)

    for rownum in range(sh.nrows):
        wr.writerow(sh.row_values(rownum))

    your_csv_file.close()

csv_from_excel(sys.argv[1])
