// require 'fs' to read the input file
const fs = require('fs');

// function parse
// Parse the input string into a list of lines, then convert each
// line to a list of integers
// Each line has format "aa-bb,cc-dd" and should
// be converted to [aa, bb, cc, dd]
function parse(input) {
    return input.split('\n').map(line => line.split(/-|,/).map(x => parseInt(x)));
}

// read the file "tinput.txt" and parse it into the variable tinput
const tinput = parse(fs.readFileSync('tinput.txt', 'utf8'));

// read the file "input.txt" and parse it into the variable input
const input = parse(fs.readFileSync('input.txt', 'utf8'));

// contains
// return 1 if the range represented by the first two numbers in "command"
// completely contains the range represented by the second two numbers in "command",
// or vice versa,
// return 0 otherwise
function contains(command) {
    let [a, b, c, d] = command;
    return (a <= c && b >= d) || (c <= a && d >= b);
}

// part1
// Return the number of commands where the range represented by the first two numbers
// completely contains the range represented by the second two numbers
// (or vice versa)
function part1(commands) {
    return commands.reduce((count, command) => count + contains(command), 0);
}

// assert that part1(tinput) returns 2
console.assert(part1(tinput) === 2);

// compute part1(input) and print it
console.log(part1(input));


