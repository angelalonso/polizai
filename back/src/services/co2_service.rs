use config::DbConn;
use constants::message_constants;
use models::co2_country::{Country};
use models::co2_sector::{Sector};
use models::population::{Population};
use models::response::{Response, ResponseWithStatus};
use rocket::http::Status;

pub fn find_main(conn: DbConn) -> ResponseWithStatus {
    ResponseWithStatus {
        status_code: Status::Ok.code,
        response: Response {
            message: String::from(message_constants::MESSAGE_OK),
            data: serde_json::to_value(Country::find_main(&conn)).unwrap(),
        },
    }
}

pub fn find_countries(conn: DbConn) -> ResponseWithStatus {
    ResponseWithStatus {
        status_code: Status::Ok.code,
        response: Response {
            message: String::from(message_constants::MESSAGE_OK),
            data: serde_json::to_value(Country::find_countries(&conn)).unwrap(),
        },
    }
}

pub fn find_sectors(conn: DbConn) -> ResponseWithStatus {
    ResponseWithStatus {
        status_code: Status::Ok.code,
        response: Response {
            message: String::from(message_constants::MESSAGE_OK),
            data: serde_json::to_value(Sector::find_sectors(&conn)).unwrap(),
        },
    }
}

pub fn find_population(conn: DbConn) -> ResponseWithStatus {
    ResponseWithStatus {
        status_code: Status::Ok.code,
        response: Response {
            message: String::from(message_constants::MESSAGE_OK),
            data: serde_json::to_value(Population::find_population(&conn)).unwrap(),
        },
    }
}
