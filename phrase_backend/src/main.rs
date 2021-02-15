use phrase_backend::api::Api;
use phrase_backend::lang::Lang;
use std::sync::Arc;
use std::sync::Mutex;

fn main() {
    let l_state = Arc::new(Mutex::new(Lang::new().unwrap()));
    let mut a = Api::new().unwrap();
    a.run(&l_state);
}
