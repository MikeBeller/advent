use std::io::BufRead;

fn get_data() -> Vec<[i32; 4]> {
    let stdin = std::io::stdin();
    for line in stdin.lock().lines() {
        let line = line.unwrap();
        let f = line.split_whitespace().collect::<Vec<&str>>();
        println!("{:?}", f);
    }
    vec![]
}

fn main() {
    let data = get_data();
    println!("{:?}", data);
}
