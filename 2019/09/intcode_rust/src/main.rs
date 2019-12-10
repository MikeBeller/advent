
struct Intcode {
    memory: Vec<i64>,
    input: Vec<i64>,
    output: Vec<i64>,
    pc: i64,
    relative_base: i64,
}

impl Intcode {
    fn new(prog: &Vec<i64>, inp: &Vec<i64>) -> Intcode {
        Intcode{
            memory: prog.clone(),
            input: inp.clone(),
            output: vec![],
            pc: 0,
            relative_base: 0
        }
    }

    fn resize_memory(&mut self, ad: usize) {
        if ad > self.memory.len() {
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

        99
    }
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
