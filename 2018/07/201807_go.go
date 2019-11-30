package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

type Task struct {
	Name           string
	Requires       []*Task
	Done           bool
	CompletionTime int
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

func partOne(tasks map[string]*Task) []string {
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

	return ans
}

func aToI(s string) int {
	i, err := strconv.Atoi(s)
	if err != nil {
		log.Fatal("invalid integer", s)
	}
	return i
}

func taskDuration(n string, baseTime int) int {
	return int(n[0]) - 64 + baseTime
}

/*
func maxTaskCompletion(n string, tasks map[string]*Task) int {
	mx := -1
	for _, t := range tasks[n].Requires {
		if t.CompletionTime > mx {
			mx = t.CompletionTime
		}
	}
	return mx
}

type Sim struct {
	BaseTime int
	Time     int
	Workers  []*Task
	Queue    []*Task
	Tasks    map[string]*Task
}

func (s *Sim) processTask(n string) {
	task := tasks[n]
	if sim.hasUnsatisfiedDependencies(task) {
		s.advance()
	}
}

func NewSim(baseTime, numWorkers int, tasks map[string]*Task) *Sim {
	return &Sim{BaseTime: baseTime, Workers: make([]*Task, numWorkers), Tasks: tasks}
}
*/

func partTwo(tasks map[string]*Task, baseTime int, numWorkers int) int {
	tm := 0
	for {
		ready := []string{}
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
				ready = append(ready, task.Name)
			}
		}
		if len(ready) == 0 {
			break
		}

		sort.StringSlice(ready).Sort()
		for _, n := range ready {
			tasks[n].CompletionTime = tm + taskDuration(n, baseTime)
		}
		sort.Slice(ready, func(i, j int) bool { return tasks[ready[i]].CompletionTime < tasks[ready[j]].CompletionTime })
		tasks[ready[0]].Done = true
		tm = tasks[ready[0]].CompletionTime
	}
	return tm
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

	taskOrder := partOne(tasks)
	fmt.Println("PartOne:", strings.Join(taskOrder, ""))

	for _, t := range tasks {
		t.Done = false
	}

	baseTime := aToI(os.Args[1])
	numWorkers := aToI(os.Args[2])

	time := partTwo(tasks, baseTime, numWorkers)
	fmt.Println("PartTwo:", time)
}
