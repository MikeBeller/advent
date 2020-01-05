use std::collections::{HashMap,VecDeque};
use std::fs;

fn is_key(c: u8) -> bool {
    c >= b'a' && c <= b'z'
}

fn is_door(c: u8) -> bool {
    c >= b'A' && c <= b'Z'
}

#[derive(Debug,Copy,Clone,Hash,PartialEq,Eq)]
struct Point {
    x: i32,
    y: i32,
}

#[derive(Debug,Copy,Clone,Hash,PartialEq,Eq)]
struct KeySet {
    d: i32,
}

impl KeySet {
    fn new() -> KeySet {
        KeySet{d: 0}
    }

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

    fn get(&self, x: i32, y: i32) -> u8 {
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

fn try_move(gr: &Grid, f: Point, dr: i32) -> (Point, u8) {
    let t = match dr {
        0 => Point{x: f.x, y: f.y - 1},
        1 => Point{x: f.x + 1, y: f.y},
        2 => Point{x: f.x, y: f.y + 1},
        3 => Point{x: f.x - 1, y: f.y},
        _ => panic!("invalid direction"),
    };
    (t, gr.get(t.x, t.y))
}

fn key_for_door(c: u8) -> u8 {
    c + 32
}

fn key_distances(gr: &Grid, st: State) -> HashMap<u8, i32> {
    let mut dst = HashMap::new();
    let mut vs = Grid::new(gr.nr as usize, gr.nc as usize);
    let mut q: VecDeque<(Point,i32)> = VecDeque::with_capacity(10000);
    q.push_back((st.pos, 0i32));

    while let Some((pos,dist)) = q.pop_front() {
        if vs.get(pos.x, pos.y) == 0 {
            vs.set(pos.x, pos.y, 1);
            let c = gr.get(pos.x, pos.y);
            if is_key(c) && !st.keys.contains(c) {
                dst.insert(c, dist);
            }
            for dr in 0..4 {
                let (p, cc) = try_move(&gr, pos, dr);
                if cc == b'#' || (is_door(cc) && !st.keys.contains(key_for_door(cc))) {
                    continue;
                }
                q.push_back((p, dist + 1));
            }
        }
    }
    dst
}

#[derive(Debug,Clone,Copy)]
struct State {
    pos: Point,
    total_dist: i32,
    keys: KeySet,
}

fn get_key(k: u8, p: Point, dist: i32, s: State) -> State {
    State{pos: p, total_dist: s.total_dist + dist, keys: s.keys.insert(k)}
}

fn best_states_by_pos_and_keys(q: &Vec<State>) -> Vec<State> {
    let mut uq = HashMap::new();
    for s in q {
        let ms = uq.entry((s.pos,s.keys)).or_insert(*s);
        if s.total_dist < (*ms).total_dist {
            *ms = *s
        }
    }
    uq.values().copied().collect::<Vec<State>>()
}

fn part1(instr: &str) -> i32 {
    let (gr, loc, n_keys) = read_data(instr);
    let mut q = vec![State{pos: loc[&b'@'], total_dist: 0, keys: KeySet::new()}];
    for depth in 0..n_keys {
        println!("GEN {} SIZE {}", depth, q.len());
        let best_states = best_states_by_pos_and_keys(&q);
        q.clear();
        for s in best_states {
            let kds = key_distances(&gr, s);
            for (k,dist) in kds {
                q.push(get_key(k, loc[&k], dist, s));
            }
        }
    }

    let s_min = q.iter().min_by_key(|s| s.total_dist).unwrap();
    println!("SMIN: {:?}", s_min);
    s_min.total_dist
}

fn main() {
    let test2 = "########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################";
    println!("{}", part1(test2));

	let test3 = "########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################";
    println!("{}", part1(test3));

	let test4 = "#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################";
    println!("{}", part1(test4));


	let test5 = "########################
#@..............ac.GI.b#
###d#e#f################
###A#B#C################
###g#h#i################
########################";
    println!("{}", part1(test5));

    let inp = fs::read_to_string("input.txt").unwrap();
    let ans1 = part1(&inp);
    println!("PART1: {}", ans1);
}

