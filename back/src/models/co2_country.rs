use diesel::prelude::*;
use diesel::PgConnection;
use schema::countries_co2;
use schema::countries_co2::dsl::*;

#[derive(Queryable, Serialize, Deserialize)]
pub struct Country {
    pub id: i32,
    pub country_name: String,
    pub amount_2019: f32,
}

impl Country {
    pub fn find_all(conn: &PgConnection) -> Vec<Country> {
        countries_co2.order(id.asc()).load::<Country>(conn).unwrap()
    }
}
