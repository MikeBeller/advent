use std::io::BufRead;
use std::collections::{HashMap,HashSet};

fn main() {
    let stdin = std::io::stdin();
    let mut twos = 0;
    let mut threes = 0;
    for line in stdin.lock().lines() {
        let st = line.unwrap();
        let mut h : HashMap<char,i32> = HashMap::new();
        for c in st.chars() {
            let e = h.entry(c).or_insert(0);
            *e += 1;
        }
        let s = h.values().collect::<HashSet<&i32>>();
        if s.contains(&2) {
            twos += 1;
        }
        if s.contains(&3) {
            threes += 1;
        }
    }
    println!("{}", twos * threes);
}
