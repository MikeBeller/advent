
function arr(a) {
    let [x,y] = a;
    return [x+1, y+1];
}

function testarr() {
    let a = [0, 0];
    for (let i = 0; i < 100000000; i++) {
        a = arr(a);
    }
    console.log(a);
}

console.time("arr");
testarr();
console.timeEnd("arr");

function ref(a) {
    a[0]++;
    a[1]++;
}

function testref() {
    let a = [0, 0];
    for (let i = 0; i < 100000000; i++) {
        ref(a);
    }
    console.log(a);
}

console.time("ref");
testref();
console.timeEnd("ref");

function inc(a) {
    a++;
    return a;
}

function testinc() {
    let a = [0, 0];
    for (let i = 0; i < 100000000; i++) {
        a[0] = inc(a[0]);
        a[1] = inc(a[1]);
    }
    console.log(a);
}

console.time("inc");
testinc();
console.timeEnd("inc");

function testdup() {
    let a = [0, 0];
    for (let i = 0; i < 100000000; i++) {
        a = [++a[0], ++a[1]];
    }
    console.log(a);
}

console.time("dup");
testdup();
console.timeEnd("dup");

function testdupobj() {
    let x = 0;
    let y = 0;
    let a = {x, y};
    for (let i = 0; i < 100000000; i++) {
        let {x, y} = a;
        x++;
        y++;
        a = {x, y};
    }
    console.log(a);
}

console.time("dupObj");
testdupobj();
console.timeEnd("dupObj");

