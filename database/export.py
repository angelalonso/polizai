import xlrd
import csv
import sys

def csv_from_excel(xls_file, sheetname, output):
    wb = xlrd.open_workbook(xls_file)
    sh = wb.sheet_by_name(sheetname)
    your_csv_file = open(output, 'w')
    wr = csv.writer(your_csv_file, quoting=csv.QUOTE_ALL)

    for rownum in range(sh.nrows):
        wr.writerow(sh.row_values(rownum))

    your_csv_file.close()

csv_from_excel(sys.argv[1], sys.argv[2], sys.argv[3] )
