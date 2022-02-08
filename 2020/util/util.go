package util

import (
	"strconv"
	"strings"
)

func Assert(ex bool, what string) {
	if (!ex) {
		panic(what);
	}
}

func Check[T any](res T, err error) T {
	if (err != nil) {
		panic(err)
	}
	return res
}

func ParseInts(instr string, sep string) []int {
	strs := strings.Split(instr, sep)
	ints := make([]int, len(strs))
	for i,s := range strs {
		ints[i] = Check(strconv.Atoi(s))
	}
	return ints
}
