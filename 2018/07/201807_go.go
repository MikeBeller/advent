package main

import (
	"fmt"
	"sort"
	"strings"
)

type Task struct {
	Name     string
	Requires []*Task
	Done     bool
}

func readData() (data [][2]string) {
	var x, y string
	for {
		n, err := fmt.Scanf("Step %s must be finished before step %s can begin.\n", &x, &y)
		if n != 2 || err != nil {
			break
		}
		data = append(data, [2]string{x, y})
	}
	return
}

func notDone(ts []string, done map[string]bool) (nd []string) {
	for _, t := range ts {
		if !done[t] {
			nd = append(nd, t)
		}
	}
	return
}

func main() {
	data := readData()
	tasks := make(map[string]*Task)
	for _, p := range data {
		t0, ok := tasks[p[0]]
		if !ok {
			t0 = &Task{Name: p[0]}
			tasks[p[0]] = t0
		}
		t1, ok := tasks[p[1]]
		if !ok {
			t1 = &Task{Name: p[1]}
			tasks[p[1]] = t1
		}
		t1.Requires = append(t1.Requires, t0)
	}

	ans := []string{}
	for {
		ts := []string{}
		for _, task := range tasks {
			if task.Done {
				continue
			}
			nnd := 0
			for _, tt := range task.Requires {
				if !tt.Done {
					nnd++
				}
			}
			if nnd == 0 {
				ts = append(ts, task.Name)
			}
		}
		if len(ts) == 0 {
			break
		}

		// Only add the min (could write min loop but i'm lazy)
		sort.StringSlice(ts).Sort()
		ans = append(ans, ts[0])
		tasks[ts[0]].Done = true
	}

	fmt.Println(strings.Join(ans, ""))
}
