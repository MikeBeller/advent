package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"math"
)

type Point struct {
	x int
	y int
}

type State struct {
	pos       Point
	totalDist int
	keys      KeySet
	path      string
}

type KeySet int32

func isKey(b byte) bool {
	return b >= 'a' && b <= 'z'
}

func isDoor(b byte) bool {
	return b >= 'A' && b <= 'Z'
}

func (k KeySet) Add(b byte) KeySet {
	if !isKey(b) {
		panic("invalid key")
	}
	return k | (1 << (b - 'a'))
}

func (k KeySet) Has(b byte) bool {
	if !isKey(b) {
		panic("invalid key")
	}
	return (k & (1 << (b - 'a'))) != 0
}

func read_data(inp []byte) ([][]byte, map[byte]Point, int) {
	gr := [][]byte{}
	loc := make(map[byte]Point)
	nKeys := 0
	for y, row := range bytes.Split(inp, []byte("\n")) {
		if len(row) == 0 {
			break
		}
		gr = append(gr, row)
		if len(row) != len(gr[0]) {
			panic("Invalid input")
		}
		for x, c := range row {
			if c != '.' && c != '#' {
				loc[c] = Point{x, y}
				if isKey(c) {
					nKeys++
				}
			}
		}
	}
	return gr, loc, nKeys
}

func move(gr [][]byte, from Point, dr int) (Point, byte) {
	var to Point
	switch dr {
	case 0:
		to = Point{from.x, from.y - 1}
	case 1:
		to = Point{from.x + 1, from.y}
	case 2:
		to = Point{from.x, from.y + 1}
	case 3:
		to = Point{from.x - 1, from.y}
	default:
		panic("invalid direction")
	}
	if to.x < 0 || to.x >= len(gr[0]) || to.y < 0 || to.y >= len(gr) {
		return to, '#'
	}
	return to, gr[to.y][to.x]
}

func keyForDoor(c byte) byte {
	if !isDoor(c) {
		panic("invalid door")
	}
	return c + 32
}

func keyDistances(gr [][]byte, st State) map[byte]int {
	dst := make(map[byte]int)
	vs := make(map[Point]bool)

	type PD struct {
		pos  Point
		dist int
	}
	q := []PD{PD{st.pos, 0}}

	for len(q) != 0 {
		var pd PD
		pd, q = q[0], q[1:]
		if !vs[pd.pos] {
			vs[pd.pos] = true
			c := gr[pd.pos.y][pd.pos.x]
			if isKey(c) && !st.keys.Has(c) {
				dst[c] = pd.dist
			}
			for dr := 0; dr < 4; dr++ {
				p, cc := move(gr, pd.pos, dr)
				if cc == '#' || (isDoor(cc) && !st.keys.Has(keyForDoor(cc))) {
					continue
				}
				q = append(q, PD{p, pd.dist + 1})
			}
		}
	}

	return dst
}

func minState(q []State) State {
	minDist := math.MaxInt64
	var minState State
	for _, s := range q {
		if s.totalDist < minDist {
			minState = s
			minDist = s.totalDist
		}
	}
	return minState
}

func getKey(k byte, p Point, dist int, s State) State {
	return State{p, s.totalDist + dist, s.keys.Add(k), s.path + string(k)}
}

func bestStatesByPosAndKeys(q []State) []State {
	type PK struct {
		p  Point
		ks KeySet
	}
	uq := make(map[PK]State)
	for _, s := range q {
		pk := PK{s.pos, s.keys}
		if _, ok := uq[pk]; !ok {
			uq[pk] = s
		}
		if s.totalDist < uq[pk].totalDist {
			uq[pk] = s
		}
	}
	r := []State{}
	for _, s := range uq {
		r = append(r, s)
	}
	return r
}

func part1(instr []byte) int {
	gr, loc, nKeys := read_data(instr)
	q := []State{State{loc['@'], 0, KeySet(0), ""}}
	for depth := 0; depth < nKeys; depth++ {
		fmt.Println("GEN", depth, "SIZE", len(q))
		bestStates := bestStatesByPosAndKeys(q)

		q = q[:0]
		for _, s := range bestStates {
			kds := keyDistances(gr, s)
			for k, dist := range kds {
				q = append(q, getKey(k, loc[k], dist, s))
			}
		}
	}

	sMin := minState(q)
	fmt.Println(sMin)
	return sMin.totalDist
}

func runTests() {
	test2 := []byte(`########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################`)
	fmt.Println("TEST2", part1(test2))

	test3 := []byte(`########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################`)
	fmt.Println("TEST3", part1(test3))

	test4 := []byte(`#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################`)
	fmt.Println("TEST4", part1(test4))

	test5 := []byte(`########################
#@..............ac.GI.b#
###d#e#f################
###A#B#C################
###g#h#i################
########################`)
	fmt.Println("TEST5", part1(test5))
}

func main() {
	runTests()

	inBytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic("input")
	}
	ans1 := part1(inBytes)
	fmt.Println("PART1", ans1)
}
