# Database

Database to feed the Polizai app.

## Steps
- Build an empty container with a small postgres server (using v12.6 to have the same version of pg_dump as ubuntu 20.04 provides currently)
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
./GetData.sh # JSON_GetData.sh is being phased out
```
  - This script does the following:
    - Download the datasets, extract CSVs and correct formatting issues on them.
    - Create the Tables on Postgres
    - Load the CSV files into the tables
    - Dump the data into a file
- Load image with data, TBD
- Use it, TBD
