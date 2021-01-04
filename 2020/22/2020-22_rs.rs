use std::collections::VecDeque;
use std::fs;
use std::collections::HashSet;
use std::iter::FromIterator;

static TDS: &str = r#"
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10"#;

fn read_data(data: &str) -> (VecDeque<i32>, VecDeque<i32>) {
    let mut xs = VecDeque::new();
    let mut ys = VecDeque::new();
    let mut current = &mut xs;
    for line in data.lines() {
        if line.starts_with("Player") {
            if line.ends_with("2:") {
                current = &mut ys;
            }
            continue;
        }
        if line == "" {
            continue;
        }
        current.push_back(line.parse::<i32>().unwrap());
    }
    (xs, ys)
}

fn score<'a, I>(xs: I) -> i64 
    where
        I:DoubleEndedIterator<Item = &'a i32>,
{
    xs.rev()
        .enumerate()
        .map(|(i,v)| ((i as i64)+1)*(*v as i64))
        .sum()
}

fn part1(inp: &str) -> i64 {
    let (mut xs, mut ys) = read_data(inp);
    while xs.len() > 0 && ys.len() > 0 {
        let x = xs.pop_front().unwrap();
        let y = ys.pop_front().unwrap();
        if x > y {
            xs.push_back(x);
            xs.push_back(y);
        } else {
            ys.push_back(y);
            ys.push_back(x);
        }
    }
    let wins = if xs.len() > 0 { xs } else { ys };
    score(wins.iter())
}

fn recursive_combat(lv: usize, mut xs: VecDeque<i32>, mut ys: VecDeque<i32>) -> (usize, i64) {
    let mut seen = HashSet::new();
    while xs.len() > 0 && ys.len() > 0 {
        let gm = (xs.iter().map(|x| *x).collect::<Vec<i32>>(),
            ys.iter().map(|y| *y).collect::<Vec<i32>>());
        if seen.contains(&gm) {
            return (0, score(xs.iter()));
        }
        seen.insert(gm);
        let x = xs.pop_front().unwrap();
        let y = ys.pop_front().unwrap();
        if (x as usize) <= xs.len() && (y as usize) <= ys.len() {
            let (who,_) = recursive_combat(lv+1,
                VecDeque::from_iter(xs.iter().map(|x| *x).take(x as usize)),
                VecDeque::from_iter(ys.iter().map(|y| *y).take(y as usize)));
            if who == 0 {
                xs.push_back(x);
                xs.push_back(y);
            } else {
                ys.push_back(y);
                ys.push_back(x);
            }
        } else if x > y {
            xs.push_back(x);
            xs.push_back(y);
        } else {
            ys.push_back(y);
            ys.push_back(x);
        }
    }

    if xs.len() > 0 {
        (0, score(xs.iter()))
    } else {
        (1, score(ys.iter()))
    }
}

fn part2(inp: &str) -> i64 {
    let (xs, ys) = read_data(inp);
    let (_,sc) = recursive_combat(0, xs, ys);
    sc
}

fn main() {
    assert!(part1(TDS) == 306);
    let input = fs::read_to_string("input.txt").unwrap();
    println!("PART1: {}", part1(&input));
    println!("{}", part2(&input));
}
