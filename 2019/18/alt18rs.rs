use std::collections::HashMap;

fn is_key(c: u8) -> bool {
    c >= b'a' && c <= b'z'
}

#[derive(Debug,Copy,Clone)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Debug,Copy,Clone)]
struct KeySet {
    d: i32,
}

impl KeySet {
    fn insert(self, b: u8) -> KeySet {
        KeySet{d: self.d | (1 << (b - b'a'))}
    }
    fn contains(self, b: u8) -> bool {
        (self.d & (1 << (b - b'a'))) != 0
    }
}

#[derive(Debug,Clone)]
struct Grid {
    nr: i32,
    nc: i32,
    data: Vec<u8>,
}

impl Grid {
    fn new(nr: usize, nc: usize) -> Grid {
        Grid{nr: nr as i32, nc: nc as i32, data: vec![0u8; (nr * nc) as usize]}
    }

    fn get(self, x: i32, y: i32) -> u8 {
        if x < 0 || x >= self.nc || y < 0 || y >= self.nr {
            b'#'
        } else {
            self.data[(y * self.nc + x) as usize]
        }
    }

    fn set(&mut self, x: i32, y: i32, v: u8) {
        self.data[(y * self.nc + x) as usize] = v;
    }
}

fn read_data(inp: &str) -> (Grid, HashMap<u8,Point>, i32) {
    let lines = inp.split('\n').collect::<Vec<&str>>();
    let mut gr = Grid::new(lines.len(), lines[0].len());
    let mut loc = HashMap::new();
    let mut n_keys = 0;

    for y in 0..lines.len() {
        let row = lines[y];
        if row.len() == 0 {
            break
        }
        assert!(row.len() == lines[0].len());
        for (x,cc) in row.chars().enumerate() {
            let c = cc as u8;
            gr.set(x as i32, y as i32, c);
            if c != b'.' && c != b'#' {
                loc.insert(c, Point{x: x as i32, y: y as i32});
                if is_key(c ) {
                    n_keys += 1;
                }
            }
        }
    }
    
    (gr, loc, n_keys)
}

struct State {
    pos: Point,
    total_dist: i32,
    keys: KeySet,
}

fn main() {
    let mut k = KeySet{d: 0};
    k = k.insert(b'a');
    assert!( k.contains(b'a'));

    let test2 = "########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################";

    let (gr, loc, n_keys) = read_data(test2);
    println!("{:?}", gr);
    println!("{:?}", loc);
    println!("{}", n_keys);

}

