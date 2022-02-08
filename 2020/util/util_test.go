package util

import (
	"fmt"
	"golang.org/x/exp/slices"
	"testing"
)

func ReturnsError() (int, error) {
	return 0, fmt.Errorf("oops")
}

func ReturnsOk() (string, error) {
	return "foo", nil
}

func TestCheckFails(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Errorf("Didn't panic")
		}
	}()
	Check(ReturnsError())
}

func TestCheckOk(t *testing.T) {
	s := Check(ReturnsOk())
	if s != "foo" {
		t.Errorf("Check failed")
	}
}

func TestParseInts(t *testing.T) {
	ints := ParseInts("123,456,789", ",")
	if !slices.Equal(ints, []int{123, 456, 789}) {
		t.Errorf("ParseInts")
	}
}

func TestParseIntsFails(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Errorf("Didn't panic")
		}
	}()
	_ = ParseInts("123,x,789", ",")
}
