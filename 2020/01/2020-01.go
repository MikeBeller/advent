package main

import (
	"advent20/util"
	"fmt"
	"os"
	"strings"
)

func part1(data []int) int {
	ln := len(data)
	for i := 0; i < (ln - 1); i++ {
		for j := i + 1; j < ln; j++ {
			if data[i]+data[j] == 2020 {
				return data[i] * data[j]
			}
		}
	}
	panic("no")
}

func part2(data []int) int {
	ln := len(data)
	for i := 0; i < (ln - 2); i++ {
		for j := i + 1; j < (ln - 1); j++ {
			for k := j + 1; k < ln; k++ {
				if data[i]+data[j]+data[k] == 2020 {
					return data[i] * data[j] * data[k]
				}
			}
		}
	}
	panic("no")

}

func main() {
	util.Assert(part1([]int{1721, 979, 366, 299, 675, 1456}) == 514579, "part1")
	instr := string(util.Check(os.ReadFile("input.txt")))
	data := util.ParseInts(strings.Trim(instr, "\n "), "\n")
	fmt.Println("PART1:", part1(data))

	util.Assert(part2([]int{1721, 979, 366, 299, 675, 1456}) == 241861950, "part2")
	fmt.Println("PART2:", part2(data))
}
