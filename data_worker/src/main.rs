#![feature(with_options)]
extern crate csv;
extern crate serde_json;

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

    // Per Country Sheet
    let file_country_path = "./EDGAR_fossil_CO2_totals_by_country.csv";
    let head_f = match File::open(file_country_path) {
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
    #[allow(unused_variables)]
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
    let f = match File::open(file_country_path) {
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

    // Per Sector Sheet
    let file_sector_path = "./EDGAR_fossil_CO2_by_sector_and_countr.csv";
    let f_sct = match File::open(file_sector_path) {
        Ok(f) => f,
        Err(e) => {
            println!("{:?}", e);
            std::process::exit(2);
        }
    };
    let mut rdr_sct = csv::ReaderBuilder::new()
        .has_headers(true)
        .from_reader(f_sct);
    for result in rdr_sct.records() {
        let record = match result {
            Ok(r) => Some(r),
            Err(_err) => {
                None
            }
        };
        // we clean up manually here because we dont need the other 48 fields now
        match record {
            Some(r) => {
                let sector = r.get(0);
                let country = r.get(1);
                let co2_2019 = r.get(51);
                let co2_amount = match co2_2019.unwrap().parse::<f32>() {
                    Ok(i) => i,
                    Err(_err) => 0.0
                };
                if (country != Some("GLOBAL TOTAL")) && 
                    (country != Some("EU27+UK")) &&
                    (country != Some("")) {
                    for p_e in all_entries.clone(){
                        if p_e.name == country.unwrap() {
                            let this_percent = (co2_amount * 100.0 / p_e.amount) * p_e.percent / 100.0;
                            //TODO: generate keys
                            let mut existing_keys: Vec<String> = [].to_vec();
                            for k_e in all_entries.clone(){
                                if (k_e.k.starts_with(&p_e.k)) && (k_e.k != p_e.k) {
                                    existing_keys.push(k_e.k);
                                }
                            }
                            let sct_key = existing_keys.len() + 1;
                            let formatted_key = format!("{}_{}", p_e.k, sct_key);
                            //println!("{} {}-{} -> {} | {} ", formatted_key, country.unwrap(), sector.unwrap(), co2_amount, this_percent);
                            let e = Entry {
                                k: formatted_key,
                                name: sector.unwrap().to_string(),
                                amount: co2_amount,
                                percent: this_percent,
                                childof: p_e.k.to_string(),
                                source: source.to_string(),
                            };
                            all_entries.push(e);
                        }
                    }
                };

                ()
            },
            None => ()
        }
    }

    let mut sorted_entries = all_entries.clone();
    //sorted_entries.sort_by_key(|d| d.clone().name);
    sorted_entries.sort_by(|a, b| b.amount.partial_cmp(&a.amount).unwrap());
    // check the sum of all is the same as the global total
    //println!("{:#x?}", ix_totalco2);
    //println!("{:#x?}", totalco2);
    // TODO: NEEDED? ::serde_json::to_writer(&File::create("data_json_temp").unwrap(), &sorted_entries)?;
    let json_start = "export const inData = ";
    fs::write("data.js", json_start).expect("Unable to write to file");
    ::serde_json::to_writer(&File::with_options().append(true).open("data.js").unwrap(), &sorted_entries)?;
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
