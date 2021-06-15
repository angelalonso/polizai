use diesel::prelude::*;
use diesel::PgConnection;
use schema::co2_sectors;
use schema::co2_sectors::dsl::*;

#[derive(Queryable, Serialize, Deserialize)]
pub struct Sector {
    pub country_id: i32,
    pub sector: String,
    pub country_name: String,
    pub amount_2019: f64,
}

#[derive(Queryable, Serialize, Deserialize, Clone, Debug)]
pub struct ApiSector {
    pub country: String,
    pub name: String,
    pub amount_2019: f64,
}

impl Sector {
    pub fn find_sectors(conn: &PgConnection) -> Vec<ApiSector> {
        let mut result: Vec<ApiSector> = [].to_vec();
        let db = co2_sectors
            .filter(co2_sectors::country_name.not_like("GLOBAL TOTAL"))
                .load::<Sector>(conn).unwrap();
        for d in db {
            let ad = ApiSector {
                country: d.country_name,
                // TODO: correct this capital at the DB
                name: d.sector,
                amount_2019: d.amount_2019,
            };
            result.push(ad);
        }
        result
    }
}
