use webcontainer::api::Api;
use webcontainer::lang::Lang;
use std::sync::Arc;
use std::sync::Mutex;

fn main() {
    let mut l_state = Arc::new(Mutex::new(Lang::new().unwrap()));
    let mut a = Api::new().unwrap();
    a.run(&l_state);
}
