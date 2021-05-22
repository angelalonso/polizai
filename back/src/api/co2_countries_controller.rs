use config::DbConn;
use jwt::UserToken;
use models::person::PersonDTO;
use models::response::Response;
use rocket::http::RawStr;
use rocket::http::Status;
use rocket::response::status;
use rocket_contrib::json::Json;
use services::co2_countries_service;

#[get("/")]
pub fn co2_countries_find_all(
    token: Result<UserToken, status::Custom<Json<Response>>>,
    conn: DbConn,
) -> status::Custom<Json<Response>> {
    if let Err(e) = token {
        return e;
    }
    let response = co2_countries_service::find_all(conn);
    status::Custom(
        Status::from_code(response.status_code).unwrap(),
        Json(response.response),
    )
}

#[get("/get_main")]
pub fn co2_countries_get_main(
    token: Result<UserToken, status::Custom<Json<Response>>>,
    conn: DbConn,
) -> status::Custom<Json<Response>> {
    if let Err(e) = token {
        return e;
    }
    let response = co2_countries_service::find_main(conn);
    status::Custom(
        Status::from_code(response.status_code).unwrap(),
        Json(response.response),
    )
}

#[get("/get_countries")]
pub fn co2_countries_get_countries(
    token: Result<UserToken, status::Custom<Json<Response>>>,
    conn: DbConn,
) -> status::Custom<Json<Response>> {
    if let Err(e) = token {
        return e;
    }
    let response = co2_countries_service::find_countries(conn);
    status::Custom(
        Status::from_code(response.status_code).unwrap(),
        Json(response.response),
    )
}
