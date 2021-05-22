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

impl Country {
    pub fn find_all(conn: &PgConnection) -> Vec<Country> {
        co2_countries.order(country_id.asc()).load::<Country>(conn).unwrap()
    }

    pub fn find_main(conn: &PgConnection) -> Vec<Country> {
        co2_countries
            .filter(co2_countries::country_name.like("GLOBAL TOTAL")).
            load::<Country>(conn).unwrap()
    }

    pub fn find_countries(conn: &PgConnection) -> Vec<Country> {
        co2_countries
            .filter(co2_countries::country_name.not_like("GLOBAL TOTAL"))
            .filter(co2_countries::country_name.not_like("EU27+UK"))
                .load::<Country>(conn).unwrap()
    }
}
