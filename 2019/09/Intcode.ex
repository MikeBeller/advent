defmodule Intcode do

  def get(mem, a), do: Map.get(mem, a, 0)
  def put(mem, a, v), do: Map.put(mem, a, v)

  def get_param(mem, _rb, a, 0), do: get(mem, get(mem, a))
  def get_param(mem, _rb, a, 1), do: get(mem, a)
  def get_param(mem, rb, a, 2), do: get(mem, get(mem, a) + rb)

  def set_param(mem, _rb, a, 0, v), do: put(mem, get(mem, a), v)
  def set_param(mem, rb, a, 2, v), do: put(mem, rb + get(mem, a), v)

  def step(%{m: mem, pc: pc, i: is, o: os, rb: rb} = state, in_f, out_f) do
    o = get(mem, pc)
    if o == 99 do
      {o, state}
    else
      op = rem(o, 100)
      [m0,m1,m2] = for i <- [100, 1000, 10000], do: rem(div(o,i), 10)
      case op do
        x when x in [1,2] ->
          a = get_param(mem, rb, pc+1, m0)
          b = get_param(mem, rb, pc+2, m1)
          r = if op == 1, do: a + b, else: a * b
          {op, %{state | m: set_param(mem, rb, pc+3, m2, r), pc: pc+4}}
        3 -> 
          {n,nis} = in_f.(is)
          {3, %{state | m: set_param(mem, rb, pc+1, m0, n), pc: pc+2, i: nis}}
        4 ->
          n = get_param(mem, rb, pc+1, m0)
          no = out_f.(os, n)
          {4, %{state | pc: pc+2, o: no}}
        x when x in [5,6] ->
          a = get_param(mem, rb, pc+1, m0)
          b = get_param(mem, rb, pc+2, m1)
          if (op == 5 and a != 0) or (op == 6 and a == 0) do
            {5, %{state | pc: b}}
          else
            {5, %{state | pc: pc+3}}
          end
        x when x in [7,8] ->
          a = get_param(mem, rb, pc+1, m0)
          b = get_param(mem, rb, pc+2, m1)
          r = if (op == 7 and a < b) or (op == 8 and a == b), do: 1, else: 0
          {op, %{state | m: set_param(mem, rb, pc+3, m2, r), pc: pc+4}}
        9 ->
          a = get_param(mem, rb, pc+1, m0)
          {9, %{state | rb: rb+a, pc: pc+2}}
        _ -> raise "invalid opcode #{op}"
      end
    end
  end

  def run_to_end(state, in_f, out_f) do
    case step(state, in_f, out_f) do
      {99, next_state} -> next_state
      {_op, next_state} -> run_to_end(next_state, in_f, out_f)
    end
  end

  def list_to_mem(mlist), do:
  for {v,i} <- Enum.with_index(mlist), into: %{}, do: {i,v}

  def run_with_input(mlist, inp) do
    mem = list_to_mem(mlist)
    in_f = fn [h | t] -> {h, t} end
    out_f = fn ls, v -> [v | ls] end
    state = %{m: mem, pc: 0, i: inp, o: [], rb: 0}
    final_state = run_to_end(state, in_f, out_f)
    Enum.reverse final_state.o
  end

  def run_to_out(state, in_f, out_f) do
    case step(state, in_f, out_f) do
      {4, next_state} -> next_state
      {_op, next_state} -> run_to_out(next_state, in_f, out_f)
    end
  end
end

ExUnit.start()
defmodule Intcode.Test do
  use ExUnit.Case, async: false
  import Intcode

  test "test intcode" do
    # tests from modes 0,1 (2019-07)
    assert [1] == run_with_input([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [8])
    assert [0] == run_with_input([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], [-1])
    assert [0] == run_with_input([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [0])
    assert [1] == run_with_input([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [22])
    assert [0] == run_with_input([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], [0])
    assert [1] == run_with_input([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], [-1])
    big_prog = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    assert [999] == run_with_input(big_prog, [7])
    assert [1000] == run_with_input(big_prog, [8])
    assert [1001] == run_with_input(big_prog, [9393])

    # test mode 2 (2019-09)
    prog = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    assert prog == run_with_input(prog, [])  # outputs a copy of itself
    assert [1219070632396864] == run_with_input([1102,34915192,34915192,7,4,7,99,0], [])
    assert [1125899906842624] == run_with_input([104,1125899906842624,99],[])
  end
end
