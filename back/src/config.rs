use api::account_controller::*;
use api::co2_controller::*;
use diesel::pg::PgConnection;
use rocket::fairing::AdHoc;
use rocket::Rocket;
use rocket::http::Method;
use rocket_cors::{AllowedOrigins, CorsOptions};

embed_migrations!();

#[database("postgres_database")]
pub struct DbConn(PgConnection);

pub fn rocket() -> (Rocket, Option<DbConn>) {
    // TODO: check if we really want to set the CORS like this on prod
    let cors = CorsOptions::default()
        .allowed_origins(AllowedOrigins::all())
        .allowed_methods(
            vec![Method::Get, Method::Post]
                .into_iter()
                .map(From::from)
                .collect(),
        )
        .allow_credentials(true);
    let rocket = rocket::ignite()
        .attach(cors.to_cors().unwrap())
        .attach(DbConn::fairing())
        .attach(AdHoc::on_attach("Database Migrations", |rocket| {
            let conn = DbConn::get_one(&rocket).expect("database connection");
            match embedded_migrations::run(&*conn) {
                Ok(()) => Ok(rocket),
                Err(e) => {
                    error!("Failed to run database migrations: {:?}", e);
                    Err(rocket)
                }
            }
        })).mount("/api/auth", routes![login, signup])
        .mount(
            "/api/co2",
            routes![
            co2_get_main 
            ,co2_get_countries
            ,co2_get_sectors
            ,co2_get_population
            ],
        );

    let conn = if cfg!(test) {
        DbConn::get_one(&rocket)
    } else {
        None
    };

    (rocket, conn)
}
