use std::io::BufRead;

fn get_data() -> Vec<[i32; 3]> {
    let stdin = std::io::stdin();
    let mut lines = stdin.lock().lines()
        .filter_map(Result::ok)
        .collect::<Vec<String>>();
    lines.sort();
    let mut r = vec![];
    let mut g = -1;
    let mut s = -1;
    let mut e = -1;
    for line in lines {
        let f = line.split_whitespace().collect::<Vec<&str>>();
        if f[2] == "Guard" {
            if g != -1 && s != -1 && e == -1 {
                r.push([g, s, 60])
            }
            g = f[3][1..].parse::<i32>().unwrap();
            s = -1;
            e = -1;
        } else if f[2] == "falls" {
            s = f[1][3..5].parse::<i32>().unwrap();
        } else if f[2] == "wakes" {
            e = f[1][3..5].parse::<i32>().unwrap();
            r.push([g, s, e]);
            s = -1;
            e = -1;
        }
    }
    r
}

fn main() {
    let data = get_data();
    println!("{:?}", data);
}
