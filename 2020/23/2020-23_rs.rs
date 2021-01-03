// rustc -O 2020-23_rs.rs
// time ./2020-23_rs

fn mv(nxt: &mut [i32]) {
    let ln = nxt.len() - 1;
    let cur = nxt[0] as usize;
    let n1 = nxt[cur] as usize;
    let n2 = nxt[n1] as usize;
    let n3 = nxt[n2] as usize;
    nxt[cur] = nxt[n3];

    let mut dc = cur - 1;
    if dc == 0 { dc = ln; }
    while dc == n1 || dc == n2 || dc == n3 {
        dc -= 1;
        if dc == 0 { dc = ln; }
    }

    let nx = nxt[dc];
    nxt[dc] = n1 as i32;
    nxt[n3] = nx;
    nxt[0] = nxt[cur];
}

fn part2(init: &[i32], nmoves: usize) -> i64 {
    //const MX:usize = 9;
    const MX:usize = 1000000;
    let mut nxt: [i32;MX+1] = [0; MX+1];
    let mut p = init[0] as usize;
    nxt[0] = p as i32;
    for i in 1..=MX {
        if i == 9 {continue;}
        let nv = if i < 9 {
            init[i] as usize
        } else {
            i
        };
        nxt[p as usize] = nv as i32;
        p = nv;
    }
    nxt[p as usize] = nxt[0];

    for _i in 0..nmoves {
        mv(&mut nxt);
    }

    let l1 = nxt[1];
    let l2 = nxt[l1 as usize];
    return (l1 as i64) * (l2 as i64);
}


fn main() {
    //println!("{}", part2(&[3, 8, 9, 1, 2, 5, 4, 6, 7], 10000000));
    println!("{}", part2(&[2, 1, 9, 7, 4, 8, 3, 6, 5], 10000000));
    //part2(&[2, 1, 9, 7, 4, 8, 3, 6, 5], 10000000);
}

