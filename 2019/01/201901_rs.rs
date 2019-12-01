use std::io::BufRead;

fn fuel_r(m: i32) -> i32 {
    let f = m / 3 - 2;
    if f < 0 {
        0
    } else {
        f + fuel_r(f)
    }
}


fn main() {
    let data = std::io::stdin().lock()
        .lines()
        .map(|s| s.unwrap().parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    let ans1 : i32 = data.iter()
        .map(|m| (m / 3) - 2)
        .sum();
    println!("{}", ans1);

    let ans2 : i32 = data.iter()
        .map(|m| fuel_r(*m))
        .sum();
    println!("{}", ans2);
}

