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
- Add Data
```
psql -h <your_container_ip> -p 5432 -U postgres # You'll be prompted for the <some_password>
```
TO DO: automate this:
  - Create the Tables by running the contents of ./schemas inside postgres
  - Clean any CSVs from empty rows
  - Load the file(s)
```
\copy co2_countries FROM '/path/to/EDGAR_fossil_CO2_totals_by_country.csv' DELIMITER ',' CSV;
```

- Test Data
- Export Data
- Load image with data
- Use it
