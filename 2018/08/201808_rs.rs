use std::io::Read;
use std::iter::Iterator;


#[derive(Debug)]
struct Node {
    meta: Vec<i32>,
    children: Vec<Box<Node>>,
}

fn read_data() -> Vec<i32> {
    let mut buf = String::new();
    std::io::stdin().lock()
        .read_to_string(&mut buf).unwrap();
    buf.split_whitespace()
        .map(|s| s.parse::<i32>().unwrap())
        .collect::<Vec<i32>>()
}

fn read_tree<'a, I: std::iter::Iterator<Item=&'a i32>>(it: &mut I) -> Box<Node> {
    let mut node = Box::new(Node{meta: vec![], children: vec![]});
    let n_nodes = it.next().unwrap();
    let n_meta = it.next().unwrap();
    for _i in 0..*n_nodes {
        let child = read_tree(it);
        node.children.push(child);
    }

    for _i in 0..*n_meta {
        node.meta.push(*(it.next().unwrap()));
    }

    node
}

fn sum_meta(t: &Box<Node>) -> i32 {
    t.meta.iter().map(|&x| x).sum::<i32>()
        + t.children.iter().map(sum_meta).sum::<i32>()
}

fn sum_code(t: &Box<Node>) -> i32 {
    if t.children.len() == 0 {
        t.meta.iter().map(|&x| x).sum::<i32>()
    } else {
        t.meta.iter()
            .map(|&x| if x > 0 && (x as usize) <= t.children.len() {
                sum_code(&t.children[(x-1) as usize])
            } else {
                0
            }).sum::<i32>()
    }
}
    
fn main() {
    let data = read_data();
    let tree = read_tree(&mut data.iter());
    let ans1 = sum_meta(&tree);
    println!("{}", ans1);

    let ans2 = sum_code(&tree);
    println!("{}", ans2);
}

