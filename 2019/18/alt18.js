'use strict';
var assert = require('assert');

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
    }
    has(b) {
        let k = this.keyNum(b);
        return this.n | (2 << k);
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

const gridSize = (gr) => [gr.length, gr[0].length];

function move(gr, from, dr) {
    let to = [0, 0];
    const [x,y] = from;
    switch (dr) {
        case 0:
            to = [x, y-1];
            break;
        case 1:
            to = [x + 1, y];
            break;
        case 2:
            to = [x, y + 1];
            break;
        case 3:
            to = [x - 1, y];
            break;
        default:
            assert(false, "invalid direction");
    }
    const [newX,newY] = to;
    let [nr, nc] = gridSize(gr);
    if (newX < 0 || newX >= nc || newY < 0 || newY >= nr) {
        return [to, '#'];
    }
    return [to, gr[newY][newX]];
}

function keyDistances(gr, from_pos, keys) {
    let dst = {};
    let [nr, nc] = gridSize(gr);
    for (let y = 0; y < nr; y++) {
        vs[y] = new Array(gr.length).fill(false);
    }

    let q = [[...from_pos, 0]];
    while (q.length != 0) {
        let [x,y,dist] = q.shift();
        if (!vs[y][x]) {
            vs[y][x] = true;
            let c = gr[y][x];
            if (isKey(c) && !keys.has(c)) {
                dst[c] = dist;
            }
            for (let dr = 0; dr < 4; dr++) {
                let [[xNew,yNew], cc] = move(gr, [x, y], dr);
                if (cc == '#' || (isDoor(cc) && !keys.has(keyForDoor(cc)))) {
                    continue
                }
                q.push([xNew, yNew, dist+1]);
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
        let [x, y, kn] = s.split(",");
        return new State([x, y], new KeySet(parseInt(kn)));
    }
}

function partOne(inStr) {
    const [gr, loc, nKeys] = readData(inStr);
    let pathLengths = {};
    const state0 = new State(loc['@'], new KeySet(0));
    pathLengths[state0.toString()] = 0;
    for (let depth = 0; depth < nKeys; depth++) {
        console.log("GEN:", depth, "SIZE:", pathLengths.length);
        const oldPathLengths = pathLengths;
        pathLengths = {};
        for (const [plKey,totalDist] of Object.entries(pathLengths)) {
            const state = State.fromString(plKey);
            const kds = keyDistances(gr, state.pos, state.keys);
            for (const [k, dist] of Object.entries(kds)) {
                const newTotalDist = totalDist + dist;
                const newPos = loc[k];
                const newKeys = (new KeySet(keys.n)).add(k);
                const newState = new State(newPos, newKeys);
                const newStateString = newState.toString();
                if (!(newStateString in pathLengths) || newTotalDist < pathLengths[newStateString]) {
                    pathLengths[newStateString] = newTotalDist;
                }
            }
        }
    }
    return Math.min(...Object.values(pathLengths));
}

function runTests() {
    assert(isKey('b') && !isKey('Z'));
    assert(!isDoor('b') && isDoor('Z'));
    assert(keyForDoor('A') == 'a');

    const test1 = "###\n#.a\n.Z.";
    const [gr,loc,nKeys] = readData(test1);
    assert.deepEqual(gr, ["###", "#.a", ".Z."]);
    assert.deepEqual(loc, { a: [ 2, 1 ], Z: [ 1, 2 ] });
    assert(nKeys == 1);

    assert.deepEqual(move(gr, [1,1], 1), [[2, 1], 'a']);
    assert.deepEqual(move(gr, [2,2], 2), [[2, 3], '#']);

    let st = new State([1,2], new KeySet(0));
    st.keys.add('c');
    assert(st.toString() == "1,2,4");
    let st2 = State.fromString(st.toString());
    assert(st2.pos[0] == 1 && st2.pos[1] == 2 && st2.keys.n == 4);

    const test2 = `########################
    #f.D.E.e.C.b.A.@.a.B.c.#
    ######################.#
    #d.....................#
    ########################`

    const n = partOne(test2);
    console.log(n);

}

runTests();

