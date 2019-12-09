package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
	"sync"
)

func rc(code string) []int {
	r := []int{}
	code = strings.TrimSpace(code)
	for _, s := range strings.Split(code, ",") {
		n, err := strconv.Atoi(s)
		if err != nil {
			panic(err)
		}
		r = append(r, n)
	}
	return r
}

func getParameter(prog []int, operand int, mode int) int {
	if mode == 1 {
		return operand
	} else {
		return prog[operand]
	}
}

func runProgram(id int, inProg []int, inChan chan int, outChan chan int) {
	prog := append([]int{}, inProg...) // make it safe
	pc := 0
	for {
		if prog[pc] == 99 {
			break
		}

		o := prog[pc]
		op := o % 100
		m := []int{}
		for i := 100; i <= 10000; i *= 10 {
			m = append(m, (o/i)%10)
		}

		switch {
		case op == 1 || op == 2:
			a := getParameter(prog, prog[pc+1], m[0])
			b := getParameter(prog, prog[pc+2], m[1])
			ci := prog[pc+3]
			if op == 1 {
				prog[ci] = a + b
			} else {
				prog[ci] = a * b
			}
			pc += 4
		case op == 3:
			a := <-inChan
			//fmt.Println("ID", id, "GOT", a)
			i := prog[pc+1]
			prog[i] = a
			pc += 2
		case op == 4:
			a := getParameter(prog, prog[pc+1], m[0])
			//fmt.Println("ID", id, "SENDING", a)
			outChan <- a
			pc += 2
		case op == 5 || op == 6:
			a := getParameter(prog, prog[pc+1], m[0])
			b := getParameter(prog, prog[pc+2], m[1])
			if (op == 5 && a != 0) || (op == 6 && a == 0) {
				pc = b
			} else {
				pc += 3
			}
		case op == 7 || op == 8:
			a := getParameter(prog, prog[pc+1], m[0])
			b := getParameter(prog, prog[pc+2], m[1])
			ci := prog[pc+3]
			if (op == 7 && a < b) || (op == 8 && a == b) {
				prog[ci] = 1
			} else {
				prog[ci] = 0
			}
			pc += 4
		default:
			panic("wtf?")
		}
	}
}

func simpleChainAmps(prog []int, phases []int) int {
	sig := 0
	for i, ph := range phases {
		toAmp := make(chan int, 2)
		fromAmp := make(chan int, 1)
		toAmp <- ph
		toAmp <- sig
		runProgram(i, prog, toAmp, fromAmp)
		sig = <-fromAmp
	}
	return sig
}

func genPermutations(a []int) [][]int {
	perms := [][]int{}

	var perm func([]int, int)

	perm = func(a []int, k int) {
		if k == 1 {
			perms = append(perms, append([]int{}, a...))
		} else {
			perm(a, k-1)

			for i := 0; i < k-1; i++ {
				if k%2 == 0 {
					a[i], a[k-1] = a[k-1], a[i]
				} else {
					a[0], a[k-1] = a[k-1], a[0]
				}
				perm(a, k-1)
			}
		}
	}
	perm(a, len(a))

	return perms
}

func testSimpleChain(pstr string, phases []int, exp int) {
	if simpleChainAmps(rc(pstr), phases) != exp {
		panic("test failed " + pstr)
	}
}

func testPartOne() {
	testSimpleChain("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", []int{4, 3, 2, 1, 0}, 43210)
	testSimpleChain("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", []int{0, 1, 2, 3, 4}, 54321)
	testSimpleChain("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", []int{1, 0, 4, 3, 2}, 65210)
	if len(genPermutations([]int{1, 2, 3, 4, 5})) != 120 {
		panic("permutations wrong")
	}
}

func partOneTwo(part int) (int, []int) {
	pstr, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic("input")
	}
	prog := rc(string(pstr))

	var perms [][]int
	if part == 1 {
		perms = genPermutations([]int{0, 1, 2, 3, 4})
	} else {
		perms = genPermutations([]int{5, 6, 7, 8, 9})
	}
	mxsig := -999999999
	mxperm := -1
	for i, p := range perms {
		var sig int
		if part == 1 {
			sig = simpleChainAmps(prog, p)
		} else {
			sig = parallelChainAmps(prog, p)
		}
		if sig > mxsig {
			mxsig = sig
			mxperm = i
		}
	}
	return mxsig, perms[mxperm]
}

const MX = 100

func parallelChainAmps(prog []int, phases []int) int {
	sig := 0
	np := len(phases)
	chans := make([]chan int, np)
	for i, ph := range phases {
		chans[i] = make(chan int, MX)
		chans[i] <- ph
	}

	var wg sync.WaitGroup
	for i := 0; i < np; i++ {
		wg.Add(1)
		go func(i int) {
			defer wg.Done()
			runProgram(i, prog, chans[i], chans[(i+1)%np])
		}(i)
	}
	chans[0] <- 0
	wg.Wait()
	sig = <-chans[0]
	return sig
}

func testParallelChain(pstr string, phases []int, exp int) {
	if parallelChainAmps(rc(pstr), phases) != exp {
		panic("test failed " + pstr)
	}
}

func testPartTwo() {
	testParallelChain("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5", []int{9, 8, 7, 6, 5}, 139629729)
	testParallelChain("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10", []int{9, 7, 8, 5, 6}, 18216)
}

func partTwo() {
}

func main() {
	testPartOne()
	ans1, p1 := partOneTwo(1)
	fmt.Println("Part 1", ans1, p1)

	testPartTwo()
	ans2, p2 := partOneTwo(2)
	fmt.Println("Part 2", ans2, p2)
}
