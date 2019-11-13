use std::io::BufRead;

fn main() {
    let stdin = std::io::stdin();
    let mut t = 0i64;
    for line in stdin.lock().lines() {
        let n: i64 = line.unwrap().parse().unwrap();
        t += n;
    }
    println!("{}", t);
}
