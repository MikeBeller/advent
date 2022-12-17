let fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf8').trim();

// search_unique(s, n)
// return the the first index in s for which the preceding n characters are unique
// return -1 if no such index exists
function search_unique(s, n) {
    let buf = new Array(n);
    let count = new Map();
    for (let i = 0; i < s.length; i++) {
        let c = s[i];
        let oc = buf[i % n];
        if (oc) {
            count.set(oc, count.get(oc) - 1);
            if (count.get(oc) == 0) count.delete(oc);
        }
        buf[i % n] = c;
        count.set(c, (count.get(c) || 0) + 1);
        if (count.size == n) return i + 1;
    }
    return -1;
}

function part1(s) {
    return search_unique(s, 4);
}

let assert = console.assert;
assert(part1("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7)
assert(part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5)
assert(part1("nppdvjthqldpwncqszvftbrmjlhg") == 6)
assert(part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10)
assert(part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11)

let print = console.log;
print(part1(input))

function part2(s) {
    return search_unique(s, 14);
}

assert(part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19)
assert(part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23)
assert(part2("nppdvjthqldpwncqszvftbrmjlhg") == 23)
assert(part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29)
assert(part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26)

print(part2(input))

function bench(n) {

    let t0 = Date.now();
    for (let i = 0; i < n; i++) {
        let r = part2(input);
    }
    let t1 = Date.now();
    print("Time:", t1 - t0);
}

bench(1000)
