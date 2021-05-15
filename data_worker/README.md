# Data Worker Tools for the C=2 comparison

Set of tools to get the data from the source to the JSON our Frontend uses.

Currently it supports only one dataset from https://edgar.jrc.ec.europa.eu/report_2020 and it is a set of three tools:
- 'export.py' - A script in Python that extracts a CSV from a predefined Sheet at an .xlsx file.
- The data worker as such - An app in Rust that creates JSON objects in the way the app will expect them, from the base of the data at the CSV the previous tool created.
- 'GetData.sh' - A script in Bash that downloads the original dataset, calls the two previous tools, and copies over the result to ../front/src/data.


