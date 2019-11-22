use std::io::BufRead;
use std::collections::HashMap;

fn get_data() -> Vec<(i32,i32,i32)> {
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
                r.push((g, s, 60))
            }
            g = f[3][1..].parse::<i32>().unwrap();
            s = -1;
            e = -1;
        } else if f[2] == "falls" {
            s = f[1][3..5].parse::<i32>().unwrap();
        } else if f[2] == "wakes" {
            e = f[1][3..5].parse::<i32>().unwrap();
            r.push((g, s, e));
            s = -1;
            e = -1;
        }
    }
    r
}

fn main() {
    let data = get_data();
    let mut naps: HashMap::<i32,Vec<(i32,i32)>> = HashMap::new();
    for (g,s,e) in data {
        let en = naps.entry(g).or_insert_with(Vec::new);
        (*en).push((s,e));
    }

    let mut mxs = vec![];
    for (g,ns) in &naps {
        let t = (*ns).iter().map(|(s,e)| e - s).sum::<i32>();
        mxs.push((g,t));
    }

    let mxg = mxs.iter().max_by_key(|(_g,t)| t).unwrap().0;

    let mut a = [0; 60];
    for (s,e) in &naps[&mxg] {
        for i in (*s)..(*e) {
            a[i as usize] += 1;
        }
    }
    let mxm = a.iter().enumerate()
        .max_by_key(|t| t.1)
        .unwrap().0 as i32;
    
    println!("{} {} {}", mxg * mxm, mxg, mxm);
}
