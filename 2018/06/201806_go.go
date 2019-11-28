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

func main() {
	d := readData()
	nc, nr := nRowCol(d)
	fmt.Println(nc, nr)
	a := makeMatrix(nc, nr)

	for r := 0; r < nr; r++ {
		for c := 0; c < nc; c++ {
			mnd := 999999
			mni := -1
			for i := range d {
				if dst := dist(c, r, d[i][0], d[i][1]); dst < mnd {
					mnd = dst
					mni = i
				}
			}
			if a[r][c] == -1 {
				a[r][c] = mni
			} else {
				a[r][c] = -9
			}
		}
	}

	fmt.Println(d)
	for r := 0; r < nr; r++ {
		fmt.Println(a[r])
	}
}
