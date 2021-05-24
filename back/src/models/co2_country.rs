use diesel::prelude::*;
use diesel::PgConnection;
use schema::co2_countries;
use schema::co2_countries::dsl::*;

#[derive(Queryable, Serialize, Deserialize)]
pub struct Country {
    pub country_id: i32,
    pub country_name: String,
    pub amount_2019: f64,
}

#[derive(Queryable, Serialize, Deserialize, Clone, Debug)]
pub struct ApiCountry {
    pub country_name: String,
    pub amount_2019: f64,
    pub percent_2019: f64,
}

impl Country {
    // TO BE DEPRECATED---
    pub fn find_all(conn: &PgConnection) -> Vec<Country> {
        co2_countries.order(country_id.asc()).load::<Country>(conn).unwrap()
    }

    pub fn old_find_main(conn: &PgConnection) -> Vec<Country> {
        co2_countries
            .filter(co2_countries::country_name.like("GLOBAL TOTAL")).
            load::<Country>(conn).unwrap()
    }

    pub fn old_find_countries(conn: &PgConnection) -> Vec<Country> {
        co2_countries
            .filter(co2_countries::country_name.not_like("GLOBAL TOTAL"))
            .filter(co2_countries::country_name.not_like("EU27+UK"))
                .load::<Country>(conn).unwrap()
    }
    // ---UNTIL HERE 

    pub fn find_main(conn: &PgConnection) -> Vec<ApiCountry> {
        let mut result: Vec<ApiCountry> = [].to_vec();
        let db = co2_countries
            .filter(co2_countries::country_name.like("GLOBAL TOTAL")).
            load::<Country>(conn).unwrap();
        for d in db {
            let ad = ApiCountry {
                country_name: d.country_name,
                amount_2019: d.amount_2019,
                percent_2019: 100.0,
            };
            result.push(ad);
        }
        result
    }

    pub fn find_countries(conn: &PgConnection) -> Vec<ApiCountry> {
        let mut result: Vec<ApiCountry> = [].to_vec();
        let db_total = Country::find_main(conn);
        let db = co2_countries
            .filter(co2_countries::country_name.not_like("GLOBAL TOTAL"))
            .filter(co2_countries::country_name.not_like("EU27+UK"))
                .load::<Country>(conn).unwrap();
        for d in db {
            let p = d.amount_2019 * 100.0 / db_total[0].amount_2019;
            let ad = ApiCountry {
                country_name: d.country_name,
                amount_2019: d.amount_2019,
                percent_2019: p,
            };
            result.push(ad);
        }
        result
    }
}
