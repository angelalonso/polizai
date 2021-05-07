#![feature(with_options)]
extern crate csv;
extern crate serde_json;
#[macro_use] extern crate serde;

use std::fs;
use std::fs::File;
use std::process;

use serde::{Deserialize, Serialize};
use serde_json::Result;

#[derive(Serialize, Deserialize, Debug, Clone)]
struct Entry {
    k: String,
    name: String,
    amount: f32,
    percent: f32,
    childof: String,
    source: String,
}

fn load_edgar() -> Result<()> {
    let source = "https://edgar.jrc.ec.europa.eu booklet2020, year 2019";

    let mut all_entries: Vec<Entry> = [].to_vec();
    let file_path = "../EDGAR_fossil_CO2_totals_by_country.csv";
    let head_f = match File::open(file_path) {
        Ok(f) => f,
        Err(e) => {
            println!("{:?}", e);
            std::process::exit(2);
        }
    };
    let mut head_rdr = csv::ReaderBuilder::new()
        .has_headers(true)
        .from_reader(head_f);
    // get "Global Total" entry first
    let mut totalco2 = 0.0;
    let mut ix_totalco2 = 0.0;
    for result in head_rdr.records() {
        let record = match result {
            Ok(r) => Some(r),
            Err(_err) => {
                None
            }
        };
        // we clean up manually here because we dont need the other 48 fields now
        match record {
            Some(r) => {
                let country = r.get(0);
                let co2_2019 = r.get(50);
                let co2_amount = match co2_2019.unwrap().parse::<f32>() {
                    Ok(i) => i,
                    Err(_err) => 0.0
                };
                if country == Some("GLOBAL TOTAL") {
                    let e = Entry {
                        k: "00".to_string(),
                        name: country.unwrap().to_string(),
                        amount: co2_amount,
                        percent: 100.0,
                        childof: "".to_string(),
                        source: source.to_string(),
                    };
                    all_entries.push(e);
                    totalco2 = co2_amount;
                };

                ()
            },
            None => ()
        }
    };
    //  get the rest
    let mut key = 0;
    let f = match File::open(file_path) {
        Ok(f) => f,
        Err(e) => {
            println!("{:?}", e);
            std::process::exit(2);
        }
    };
    let mut rdr = csv::ReaderBuilder::new()
        .has_headers(true)
        .from_reader(f);
    for result in rdr.records() {
        let record = match result {
            Ok(r) => Some(r),
            Err(_err) => {
                None
            }
        };
        // we clean up manually here because we dont need the other 48 fields now
        match record {
            Some(r) => {
                let country = r.get(0);
                let co2_2019 = r.get(50);
                let co2_amount = match co2_2019.unwrap().parse::<f32>() {
                    Ok(i) => i,
                    Err(_err) => 0.0
                };
                if (country != Some("GLOBAL TOTAL")) && 
                    (country != Some("EU27+UK")) &&
                    (country != Some("")) {
                    key += 1;
                    let formatted_key = format!("00_{}", key);
                    let this_percent = co2_amount * 100.0 / totalco2;
                    let e = Entry {
                        k: formatted_key,
                        name: country.unwrap().to_string(),
                        amount: co2_amount,
                        percent: this_percent,
                        childof: "00".to_string(),
                        source: source.to_string(),
                    };
                    ix_totalco2 += co2_amount;
                    all_entries.push(e);
                };

                ()
            },
            None => ()
        }
    }

    println!("{:#x?}", all_entries);
    // check the sum of all is the same as the global total
    //println!("{:#x?}", ix_totalco2);
    //println!("{:#x?}", totalco2);
    ::serde_json::to_writer(&File::create("data_json_temp").unwrap(), &all_entries)?;
    let json_start = "export const inData = ";
    fs::write("data.js", json_start).expect("Unable to write to file");
    ::serde_json::to_writer(&File::with_options().append(true).open("data.js").unwrap(), &all_entries)?;
    Ok(())
}

// /// Returns the first positional argument sent to this process. If there are no
// /// positional arguments, then this returns an error.
// fn get_first_arg() -> Result<OsString, Box<dyn Error>> {
//     match env::args_os().nth(1) {
//         None => Err(From::from("expected 1 argument, but got none")),
//         Some(file_path) => Ok(file_path),
//     }
// }

fn main() {
    if let Err(err) = load_edgar() {
        println!("{}", err);
        process::exit(1);
    }
}
