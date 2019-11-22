package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func atoi(s string) int {
	r, e := strconv.Atoi(s)
	if e != nil {
		panic("scanInt: " + s)
	}
	return r
}

func getData() [][3]int {
	r := [][3]int{}
	scanner := bufio.NewScanner(os.Stdin)
	lines := []string{}
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	sort.StringSlice(lines).Sort()

	g := -1
	s := -1
	e := -1
	for _, line := range lines {
		f := strings.Split(line, " ")
		if f[2] == "Guard" {
			if g != -1 && s != -1 {
				r = append(r, [3]int{g, s, 60})
			}
			g = atoi(f[3][1:])
			s = -1
			e = -1
		} else if f[2] == "falls" {
			s = atoi(f[1][3:5])
		} else {
			e = atoi(f[1][3:5])
			r = append(r, [3]int{g, s, e})
			s = -1
			e = -1
		}
	}
	return r
}

func main() {
	data := getData()
	naps := make(map[int][][2]int)
	for _, d := range data {
		naps[d[0]] = append(naps[d[0]], [2]int{d[1], d[2]})
	}

	mxg := -1
	mxn := -1
	for g, ns := range naps {
		t := 0
		for _, n := range ns {
			t += n[1] - n[0]
		}
		if t > mxn {
			mxn = t
			mxg = g
		}
	}
	fmt.Println(mxg)

	a := [60]int{}
	for _, n := range naps[mxg] {
		for i := n[0]; i < n[1]; i++ {
			a[i] += 1
		}
	}

	mx := -1
	mxi := -1
	for i := 0; i < 60; i++ {
		if a[i] > mx {
			mx = a[i]
			mxi = i
		}
	}

	fmt.Println(mxi*mxg, mxg, mxi)
}
