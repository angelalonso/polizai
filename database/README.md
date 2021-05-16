# Database

Database to feed the Polizai app.

## Steps
- Build an empty container with a small postgres server
```
docker build -f Dockerfile -t polizai_db:v0.1 .
```
- Configure user password (store safely)
```
docker run -it --rm -e POSTGRES_PASSWORD=<some_password> polizai_db:v0.1
```
- Get your environment ready
  - copy env.template to .env
  - adapt it to your needs
- Add Data
```
./GetData.sh # GetData_JSON.sh is being phased out
```
  - This script does the following:
    - Download the datasets, extract CSVs and correct formatting issues on them.
    - Create the Tables on Postgres
    - Load the CSV files
```
\copy co2_countries FROM '/path/to/EDGAR_fossil_CO2_totals_by_country.csv' DELIMITER ',' CSV;
\copy co2_sectors FROM '/path/to/EDGAR_fossil_CO2_by_sector_and_countr.csv' DELIMITER ',' CSV;
```

- Export Data, TBD
- Load image with data, TBD
- Use it, TBD
