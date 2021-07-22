DROP TABLE population_raw;
CREATE TABLE population_raw
(
LocID double precision,
Location varchar,
VarID double precision,
Variant varchar,
Time integer,
MidPeriod double precision,
PopMale double precision,
PopFemale double precision,
PopTotal double precision,
PopDensity double precision
);

DROP TABLE population;
CREATE TABLE population
(
country_name varchar,
"amount_2019" double precision,
country_id SERIAL PRIMARY KEY
);

\copy population_raw(LocID, Location, VarID, Variant, Time, MidPeriod, PopMale, PopFemale, PopTotal, PopDensity ) FROM './population_by_sex.csv' WITH(FORMAT csv, DELIMITER ',');

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT P1.location as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = c1.country_name;

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Bolivia (Plurinational State of)' AND C1.country_name = 'Bolivia';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Brunei Darussalam' AND C1.country_name = 'Brunei';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE '%Ivoire' AND C1.country_name LIKE '%Ivoire';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Falkland Islands (Malvinas)' AND C1.country_name = 'Falkland Islands';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Faroe Islands' AND C1.country_name = 'Faroes';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'China, Hong Kong SAR' AND C1.country_name = 'Hong Kong';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Iran (Islamic Republic of)' AND C1.country_name = 'Iran';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'Lao People%s Democratic Republic' AND C1.country_name = 'Laos';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'China, Macao SAR' AND C1.country_name = 'Macao';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Republic of Moldova' AND C1.country_name = 'Moldova';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'Myanmar%' AND C1.country_name LIKE 'Myanmar%';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'Dem. People%s Republic of Korea' AND C1.country_name = 'North Korea';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Russian Federation' AND C1.country_name = 'Russia';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'Saint Helena%' AND C1.country_name LIKE 'Saint Helena%';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'S%o Tom% and Pr%ncipe' AND C1.country_name LIKE 'S%o Tom% and Pr%ncipe';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Republic of Korea' AND C1.country_name = 'South Korea';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Syrian Arab Republic' AND C1.country_name = 'Syria';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'China%Taiwan Province of China' AND C1.country_name = 'Taiwan';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'United Republic of Tanzania' AND C1.country_name = 'Tanzania';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Gambia' AND C1.country_name = 'The Gambia';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'United States of America%dependencies%' AND C1.country_name = 'United States';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'Venezuela%' AND C1.country_name = 'Venezuela';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'Viet Nam' AND C1.country_name = 'Vietnam';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'World' AND C1.country_name = 'International Aviation';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'World' AND C1.country_name = 'International Shipping';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location LIKE 'European Union%28%' AND C1.country_name LIKE 'EU27%';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, P1.poptotal as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location = 'World' AND C1.country_name = 'GLOBAL TOTAL';

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, SUM (P1.poptotal) as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location IN ('France', 'Monaco') AND C1.country_name = 'France and Monaco' GROUP BY C1.country_name, C1.country_id;

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, SUM (P1.poptotal) as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location IN ('Israel', 'State of Palestine') AND C1.country_name = 'Israel and Palestine, State of' GROUP BY C1.country_name, C1.country_id;

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, SUM (P1.poptotal) as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location IN ('Holy See', 'Italy', 'San Marino') AND C1.country_name = 'Italy, San Marino and the Holy See' GROUP BY C1.country_name, C1.country_id;

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, SUM (P1.poptotal) as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location IN ('Serbia', 'Montenegro') AND C1.country_name = 'Serbia and Montenegro' GROUP BY C1.country_name, C1.country_id;

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, SUM (P1.poptotal) as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location IN ('Spain', 'Andorra') AND C1.country_name = 'Spain and Andorra' GROUP BY C1.country_name, C1.country_id;

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, SUM (P1.poptotal) as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location IN ('Sudan', 'South Sudan') AND C1.country_name = 'Sudan and South Sudan' GROUP BY C1.country_name, C1.country_id;

INSERT INTO population (country_name, amount_2019, country_id) SELECT DISTINCT C1.country_name as country_name, SUM (P1.poptotal) as amount_2019, C1.country_id as country_id FROM population_raw P1, co2_countries C1 WHERE P1.time = '2019' AND P1.location IN ('Switzerland', 'Liechtenstein') AND C1.country_name = 'Switzerland and Liechtenstein' GROUP BY C1.country_name, C1.country_id;
