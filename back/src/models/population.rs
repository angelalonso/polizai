use diesel::prelude::*;
use diesel::PgConnection;
use schema::population;
use schema::population::dsl::*;

#[derive(Queryable, Serialize, Deserialize)]
pub struct Population {
    pub country_id: i32,
    pub country_name: String,
    pub amount_2019: f64,
}

#[derive(Queryable, Serialize, Deserialize, Clone, Debug)]
pub struct ApiPopulation {
    pub id: i32,
    pub country: String,
    pub amount_2019: f64,
}

impl Population {
    pub fn find_population(conn: &PgConnection) -> Vec<ApiPopulation> {
        let mut result: Vec<ApiPopulation> = [].to_vec();
        let db = population
            .filter(population::country_name.not_like("GLOBAL TOTAL"))
                .load::<Population>(conn).unwrap();
        for d in db {
            let ad = ApiPopulation {
                country: d.country_name,
                // TODO: correct this capital at the DB
                id: d.country_id,
                amount_2019: d.amount_2019,
            };
            result.push(ad);
        }
        result
    }
}
