package main

import (
	"fmt"
	"strconv"
	"strings"
)

func rc(code string) []int {
	r := []int{}
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

func runProgram(inProg []int, inChan chan int, outChan chan int) {
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
				//fmt.Println("add", a, b, "storing", a+b, "in", ci)
			} else {
				prog[ci] = a * b
				//fmt.Println("mult", a, b, "storing", a*b, "in", ci)
			}
			pc += 4
		case op == 3:
			a := <-inChan
			i := prog[pc+1]
			prog[i] = a
			//fmt.Println("storing", a, "in", i)
			pc += 2
		case op == 4:
			a := getParameter(prog, prog[pc+1], m[0])
			outChan <- a
			//fmt.Println("wrote", a, "from", prog[pc+1], m[0])
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
	for _, ph := range phases {
		toAmp := make(chan int, 2)
		fromAmp := make(chan int, 1)
		toAmp <- ph
		toAmp <- sig
		runProgram(prog, toAmp, fromAmp)
		sig = <-fromAmp
	}
	return sig
}

func testSimpleChain(pstr string, phases []int, exp int) {
	if simpleChainAmps(rc(pstr), phases) != exp {
		panic("test failed " + pstr)
	}
}

func runTests() {
	testSimpleChain("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", []int{4, 3, 2, 1, 0}, 43210)
	testSimpleChain("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", []int{0, 1, 2, 3, 4}, 54321)
	testSimpleChain("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", []int{1, 0, 4, 3, 2}, 65210)
}

func main() {
	runTests()
	fmt.Println("yay")
}
