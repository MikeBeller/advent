use std::fs;

struct Intcode {
    memory: Vec<i64>,
    input: Vec<i64>,
    output: Vec<i64>,
    pc: i64,
    relative_base: i64,
}

impl Intcode {
    fn new(prog: &[i64], inp: &[i64]) -> Intcode {
        let mut input = inp.to_vec();
        input.reverse();
        Intcode{
            memory: prog.to_vec(),
            input: input,
            output: vec![],
            pc: 0,
            relative_base: 0
        }
    }

    // Resize memory to be big enough to include ad, which
    // means one greater than ad itself.
    fn resize_memory(&mut self, ad: usize) {
        if ad+1 > self.memory.len() {
            self.memory.resize(ad+1, 0);
        }
    }

    fn get_mem(&mut self, addr: i64) -> i64 { 
        assert!(addr >= 0);
        let ad = addr as usize;
        self.resize_memory(ad);
        self.memory[ad]
    }

    fn set_mem(&mut self, addr: i64, val: i64) { 
        assert!(addr >= 0);
        let ad = addr as usize;
        self.resize_memory(ad);
        self.memory[ad] = val;
    }

    fn get_parameter(&mut self, addr: i64, mode: i64) -> i64 {
        let param = self.get_mem(addr);
        match mode {
            1 => param,
            0 => self.get_mem(param),
            2 => self.get_mem(param + self.relative_base),
            _ => panic!("invalid mode")
        }
    }

    fn set_parameter(&mut self, addr: i64, mode: i64, val: i64) {
        assert!(mode != 1); // illegal
        let param = self.get_mem(addr);
        if mode == 0 {
            self.set_mem(param, val);
        } else {
            self.set_mem(self.relative_base + param, val);
        }
    }

    fn run(&mut self) {
        while self.step() != 99 {
        }
    }

    fn step(&mut self) -> i64 {
        let o = self.get_mem(self.pc);
        if o == 99 {
            return 99;
        }

        let op = o % 100;
        let m = vec![100,1000,10000]
            .iter()
            .map(|i| (o/i) % 10)
            .collect::<Vec<i64>>();

        match op {
            1 | 2 => {
                let a = self.get_parameter(self.pc+1, m[0]);
                let b = self.get_parameter(self.pc+2, m[1]);
                self.set_parameter(self.pc+3, m[2],
                                   if op == 1 { a + b } else { a * b });
                self.pc += 4;
            },

            3 => {
                let n = self.input.pop().unwrap();
                self.set_parameter(self.pc+1, m[0], n);
                self.pc += 2;
            },

            4 => {
                let n = self.get_parameter(self.pc+1, m[0]);
                self.output.push(n);
                self.pc += 2;
            },

            5 | 6 => {
                let a = self.get_parameter(self.pc+1, m[0]);
                let b = self.get_parameter(self.pc+2, m[1]);
                if (op == 5 && a != 0) || (op == 6 && a == 0) {
                    self.pc = b;
                } else {
                    self.pc += 3;
                }
            },

            7 | 8 => {
                let a = self.get_parameter(self.pc+1, m[0]);
                let b = self.get_parameter(self.pc+2, m[1]);
                if (op == 7 && a < b) || (op == 8 && a == b) {
                    self.set_parameter(self.pc+3, m[2], 1);
                } else {
                    self.set_parameter(self.pc+3, m[2], 0);
                }
                self.pc += 4;
            },

            9 => {
                let a = self.get_parameter(self.pc+1, m[0]);
                self.relative_base += a;
                self.pc += 2;
            },

            _ => {panic!("invalid opcode {}", op);},
        }

        op
    }
}

fn runprog(prgstr: &str, inp: &[i64]) -> Vec<i64> {
    let prog = prgstr.split(',')
        .map(|s| s.parse::<i64>().unwrap())
        .collect::<Vec<i64>>();
    let mut ic = Intcode::new(&prog, inp);
    ic.run();
    ic.output
}

#[test]
fn test_mem() {
    let mut ic = Intcode::new(&vec![1,2,3], &vec![1]);
    assert_eq!(ic.get_mem(1), 2);
    assert_eq!(ic.get_mem(10), 0);
    assert_eq!(ic.memory.len(), 11);

    ic.set_mem(100, 9);
    assert_eq!(ic.get_mem(100), 9);
    assert_eq!(ic.memory.len(), 101);
}

#[test]
fn test_param() {
    let mut ic = Intcode::new(&vec![1,20,2, 44], &vec![1]);
    assert_eq!(ic.get_parameter(0, 1), 1);
    assert_eq!(ic.get_parameter(0, 0), 20);
    ic.relative_base = 1;
    assert_eq!(ic.get_parameter(2, 2), 44);

    ic.set_parameter(0, 0, 22);
    assert_eq!(ic.memory[1], 22);
    ic.set_parameter(2, 2, 88);
    assert_eq!(ic.memory[3], 88);
}

#[test]
fn test_run() {
    assert!(runprog("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", &[0]) == [0]);
    assert!(runprog("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", &[1]) == [1]);

    assert!(runprog("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", &[-11]) == [999]);
    assert!(runprog("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", &[8]) == [1000]);
    assert!(runprog("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", &[999]) == [1001]);

    assert!(runprog("1102,34915192,34915192,7,4,7,99,0", &[]) == [1219070632396864]);
    assert!(runprog("104,1125899906842624,99", &[]) == [1125899906842624]);
    //assert!(runprog("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99", &[]) == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]);
    println!("{:?}", runprog("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99", &[]));

}

fn main() {
    let instr = fs::read_to_string("../input.txt").unwrap();
    let progstr = instr.trim_end();
    let ans1 = runprog(progstr, &[1]);
    println!("{:?}", ans1);

    let ans2 = runprog(progstr, &[2]);
    println!("{:?}", ans2);

}
