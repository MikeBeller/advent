package main

import (
	"fmt"
	"os"
)

func readData() [][2]int {
	var c, r int
	ps := [][2]int{}
	for {
		n, err := fmt.Fscanf(os.Stdin, "%d, %d", &c, &r)
		if err != nil || n != 2 {
			break
		}
		ps = append(ps, [2]int{c, r})
	}
	return ps
}

func nRowCol(ps [][2]int) (int, int) {
	mxc, mxr := -1, -1
	for _, d := range ps {
		if d[0] > mxc {
			mxc = d[0]
		}
		if d[1] > mxr {
			mxr = d[1]
		}
	}
	return mxc + 2, mxr + 2
}

func makeMatrix(nc, nr int) [][]int {
	a := make([][]int, nr)
	m := make([]int, nr*nc)
	for i := range a {
		a[i] = m[(i * nc):(i*nc + nc)]
		for j := range a[i] {
			a[i][j] = -1
		}
	}
	return a
}

func abs(i int) int {
	if i < 0 {
		return -i
	}
	return i
}

func dist(c1, r1, c2, r2 int) int {
	return abs(c2-c1) + abs(r2-r1)
}

func printBoard(a [][]int) {
	for r := range a {
		for c := range a[r] {
			fmt.Printf("%02d ", a[r][c])
		}
		fmt.Println("")
	}
}

func partOne(d [][2]int) int {
	nc, nr := nRowCol(d)
	a := makeMatrix(nc, nr)

	for r := 0; r < nr; r++ {
		for c := 0; c < nc; c++ {
			mnd := 999999
			for i := range d {
				if dst := dist(c, r, d[i][0], d[i][1]); dst < mnd {
					mnd = dst
					a[r][c] = i
				} else if dst == mnd {
					a[r][c] = -2
				}

			}
		}
	}

	// find which areas don't touch edge and count their size
	ss := make(map[int]int)
	for r := 0; r < nr; r++ {
		for c := 0; c < nc; c++ {
			v := a[r][c]
			if r == 0 || r == nr-1 || c == 0 || c == nc-1 {
				ss[v] = -1
			}

			if ss[v] != -1 {
				ss[v] += 1
			}
		}
	}

	mxc := -1
	for _, c := range ss {
		if c > mxc {
			mxc = c
		}
	}

	return mxc
}

func partTwo(d [][2]int) int {
	nc, nr := nRowCol(d)
	a := makeMatrix(nc, nr)

	for r := 0; r < nr; r++ {
		for c := 0; c < nc; c++ {
			for i := range d {
				a[r][c] += dist(c, r, d[i][0], d[i][1])

			}
		}
	}

	// find which points have less than 10,000
	count := 0
	for r := 0; r < nr; r++ {
		for c := 0; c < nc; c++ {
			if a[r][c] < 10000 {
				count++
			}
		}
	}

	return count
}

func main() {
	d := readData()
	ans1 := partOne(d)
	fmt.Println("Part 1:", ans1)

	ans2 := partTwo(d)
	fmt.Println("Part 2:", ans2)
}
