use std::io::BufRead;
use std::collections::HashSet;

fn read_data() -> Vec<i64> {
    let stdin = std::io::stdin();
    stdin.lock().lines()
        .map(|s| s.unwrap().parse().unwrap())
        .collect::<Vec<i64>>()
}

fn main() {
    let d = read_data();
    let mut t = 0;
    let mut s = HashSet::new();
    for k in d.iter().cycle() {
        if s.contains(&t) {
            println!("{}", t);
            break;
        }
        s.insert(t);
        t += k;
    }
}
