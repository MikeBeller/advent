'use strict';
var assert = require('assert');
var fs = require('fs');

const isKey = c => c >= 'a' && c <= 'z';
const isDoor = c => c >= 'A' && c <= 'Z';
function keyForDoor(c) {
    assert(isDoor(c), "Invalid door in keyForDoor");
    return c.toLowerCase();
}

class KeySet {
    constructor(n=0) {
        this.n = n;
    }
    keyNum(b) {
        assert(isKey(b), "invalid key");
        return b.charCodeAt(0) - 97;
    }
    add(b) {
        let k = this.keyNum(b);
        this.n += 1 << k;
        return this;
    }
    has(b) {
        let k = this.keyNum(b);
        return this.n & (1 << k);
    }
}


function readData(inStr) {
    let gr = [];
    let loc = {};
    let nKeys = 0;
    let lines = inStr.split("\n");
    for (const [y,row1] of lines.entries()) {
        const row = row1.trim();
        if (row == "") continue;
        gr.push(row);
        assert(row.length == gr[0].length);
        for (const [x,c] of row.split("").entries()) {
            if (c != '.' && c != '#') {
                loc[c] = [x, y];
                if (isKey(c)) nKeys++;
            }
        }
    }
    return [gr, loc, nKeys];
}

const gridSize = (gr) => {return {nr: gr.length, nc: gr[0].length}};

function move(gr, x, y, dr) {
    let toX = 0;
    let toY = 0;
    switch (dr) {
        case 0:
            toX = x;
            toY = y-1;
            break;
        case 1:
            toX = x + 1;
            toY = y;
            break;
        case 2:
            toX = x;
            toY = y+1;
            break;
        case 3:
            toX = x - 1;
            toY = y;
            break;
        default:
            assert(false, "invalid direction");
    }
    let {nr, nc} = gridSize(gr);
    if (toX < 0 || toX >= nc || toY < 0 || toY >= nr) {
        return [toX, toY, '#'];
    }
    //return [toX, toY, gr[toY][toX]];
    return {x: toX, y: toY, c: gr[toY][toX]};
}

function keyDistances(gr, fromX, fromY, keys) {
    let dst = {};
    let {nr, nc} = gridSize(gr);
    let vs = new Array(nr);
    for (let y = 0; y < nr; y++) {
        vs[y] = new Array(gr.length).fill(false);
    }

    let q = [{x: fromX, y: fromY, dist: 0}];
    while (q.length != 0) {
        let {x, y, dist} = q.shift();
        if (!vs[y][x]) {
            vs[y][x] = true;
            let c = gr[y][x];
            if (isKey(c) && !keys.has(c)) {
                dst[c] = dist;
            }
            for (let dr = 0; dr < 4; dr++) {
                let nw = move(gr, x, y, dr);
                if (nw.c == '#' || (isDoor(nw.c) && !keys.has(keyForDoor(nw.c)))) continue;
                q.push({x: nw.x, y: nw.y, dist:dist+1});
            }
        }
    }
    return dst;
}

class State {
    constructor(pos, keys) {
        this.pos = pos;
        this.keys = keys;
    }
    toString() {
        return this.pos[0] + "," + this.pos[1] + "," + this.keys.n;
    }
    static fromString(s) {
        let [x, y, k] = s.split(",").map(f => parseInt(f));
        return new State([x, y], new KeySet(k));
    }
}

function partOne(inStr) {
    const [gr, loc, nKeys] = readData(inStr);
    let pathLengths = new Map();
    const state0 = new State(loc['@'], new KeySet(0));
    pathLengths.set(state0.toString(), 0);
    for (let depth = 0; depth < nKeys; depth++) {
        console.log("GEN:", depth, "SIZE:", pathLengths.size);
        const oldPathLengths = pathLengths;
        pathLengths = new Map();
        for (const [stateString,totalDist] of oldPathLengths) {
            const state = State.fromString(stateString);
            const kds = keyDistances(gr, state.pos[0], state.pos[1], state.keys);
            for (const [k, dist] of Object.entries(kds)) {
                const newTotalDist = totalDist + dist;
                const newPos = loc[k];
                const newKeys = (new KeySet(state.keys.n)).add(k);
                const newState = new State(newPos, newKeys);
                const newStateString = newState.toString();
                if (!(pathLengths.has(newStateString)) || newTotalDist < pathLengths.get(newStateString)) {
                    pathLengths.set(newStateString, newTotalDist);
                }
            }
        }
    }
    return Math.min(...pathLengths.values());
}

function runTests() {
    assert(isKey('b') && !isKey('Z'));
    assert(!isDoor('b') && isDoor('Z'));
    assert(keyForDoor('A') == 'a');

    const test1 = "###\n#.a\n.Z.";
    let [gr,loc,nKeys] = readData(test1);
    assert.deepEqual(gr, ["###", "#.a", ".Z."]);
    assert.deepEqual(loc, { a: [ 2, 1 ], Z: [ 1, 2 ] });
    assert(nKeys == 1);

    //assert.deepEqual(move(gr, 1,1, 1), [2, 1, 'a']);
    //assert.deepEqual(move(gr, 2,2, 2), [2, 3, '#']);

    let ks = new KeySet(0).add('c');
    console.log(ks);
    assert(ks.has('c') && !ks.has('a'));

    let st = new State([1,2], new KeySet(0));
    st.keys.add('c');
    assert(st.toString() == "1,2,4");
    let st2 = State.fromString(st.toString());
    console.log(st2);
    assert(st2.pos[0] == 1 && st2.pos[1] == 2 && st2.keys.n == 4);

    const test2 = `########################
    #f.D.E.e.C.b.A.@.a.B.c.#
    ######################.#
    #d.....................#
    ########################`;

    [gr,loc,nKeys] = readData(test2);
    let dst = keyDistances(gr, loc['@'][0], loc['@'][1], new KeySet().add('a').add('c'));
    assert.deepEqual(dst, {b: 4, e: 8});

    let ans2 = partOne(test2);
    assert(ans2 == 86);

    const test3 = `########################
    #...............b.C.D.f#
    #.######################
    #.....@.a.B.c.d.A.e.F.g#
    ########################`;
    let ans3 = partOne(test3);
    assert(ans3 == 132);

}

runTests();

let inputStr = fs.readFileSync('input.txt', 'utf8');
let ans1 = partOne(inputStr);
console.log("PART1:", ans1);
