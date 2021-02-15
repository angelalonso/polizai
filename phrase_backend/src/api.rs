use rocket::State;
use rocket::http::RawStr;
use std::sync::mpsc::SyncSender;
use std::sync::Arc;
use std::sync::Mutex;

use crate::lang::Lang;

pub struct Api<'a> {
    #[allow(dead_code)]
    result: Vec<&'a str>,
}

impl Api<'_> {
    pub fn new() -> Result<Self, String> {
        let result = [].to_vec();

        Ok(Self {
            result,
        })
    }
    pub fn run(&mut self, lang: &Arc<Mutex<Lang<'static>>>) {
        rocket::ignite()
            .manage(Arc::clone(lang))
            .mount("/", routes![all],)
            .mount("/health/", routes![get_health],)
            .launch();
    }
}

#[get("/")]
fn all(lang: State<Arc<Mutex<Lang>>>) -> String {
    let test = match lang.lock() {
        Ok(mut t) => {
            let s = match t.get_phrase() {
                Ok(s) => {s},
                Err(es) => {
                    println!("ERROR: {}", es);
                    es.to_string()
                },
            };
            s
        },
        Err(e) => {
            println!("ERROR: {}", e);
            e.to_string()
        },
    };
    test
}

#[get("/")]
fn get_health() -> String {
    "OK".to_string()
}

// curl -X POST 127.0.0.1:8000/do/test=1,test=2
#[post("/<do_stuff>")]
fn post_do(do_stuff: &RawStr, channel: State<SyncSender<String>>) -> String {
    let do_stuff_corrected = do_stuff.replace(",", "|");
    channel.send(format!("DO: {}", do_stuff_corrected.as_str())).unwrap();
    "OK".to_string()
}

