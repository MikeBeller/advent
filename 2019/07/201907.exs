ExUnit.start
defmodule Advent07.Test do
  use ExUnit.Case

  def read_data(inp) do
    inp
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer(&1))
  end

  def get(mem, a), do: Map.get(mem, a, 0)
  def put(mem, a, v), do: Map.put(mem, a, v)
  def get_param(mem, o, m), do: if m == 1, do: o, else: get(mem, o)

  def step(%{m: mem, pc: pc, i: is, o: os} = state, in_f, out_f) do
    o = get(mem, pc)
    if o == 99 do
      {o, state}
    else
      op = rem(o, 100)
      [m0,m1,_m2] = for i <- [100, 1000, 10000], do: rem(div(o,i), 10)
      case op do
        x when x in [1,2] ->
          a = get_param(mem, get(mem, pc+1), m0)
          b = get_param(mem, get(mem, pc+2), m1)
          ci = get(mem, pc+3)
          r = if op == 1, do: a + b, else: a * b
          {op, %{state | m: put(mem, ci, r), pc: pc+4}}
        3 -> 
          {n,nis} = in_f.(is)
          {3, %{state | m: put(mem, get(mem, pc+1), n), pc: pc+2, i: nis}}
        4 ->
          n = get_param(mem, get(mem, pc+1), m0)
          no = out_f.(os, n)
          {4, %{state | pc: pc+2, o: no}}
        x when x in [5,6] ->
          a = get_param(mem, get(mem, pc+1), m0)
          b = get_param(mem, get(mem, pc+2), m1)
          if (op == 5 and a != 0) or (op == 6 and a == 0) do
            {5, %{state | pc: b}}
          else
            {5, %{state | pc: pc+3}}
          end
        x when x in [7,8] ->
          a = get_param(mem, get(mem, pc+1), m0)
          b = get_param(mem, get(mem, pc+2), m1)
          ci = get(mem, pc+3)
          r = if (op == 7 and a < b) or (op == 8 and a == b), do: 1, else: 0
          {op, %{state | m: put(mem, ci, r), pc: pc+4}}
        _ -> raise "invalid opcode #{op}"
      end
    end
  end

  def rwi(state, in_f, out_f) do
    case step(state, in_f, out_f) do
      {99, next_state} -> next_state
      {_op, next_state} -> rwi(next_state, in_f, out_f)
    end
  end

  def list_to_mem(mlist), do:
    for {v,i} <- Enum.with_index(mlist), into: %{}, do: {i,v}

  def run_with_input(mlist, inp) do
    mem = list_to_mem(mlist)
    in_f = fn [h | t] -> {h, t} end
    out_f = fn ls, v -> [v | ls] end
    state = %{m: mem, pc: 0, i: inp, o: []}
    final_state = rwi(state, in_f, out_f)
    final_state.o
  end

  def run_to_out(state, in_f, out_f) do
    case step(state, in_f, out_f) do
      {4, next_state} -> next_state
      {_op, next_state} -> run_to_out(next_state, in_f, out_f)
    end
  end

  def run_phases(prog, phases) do
    mem = list_to_mem(prog)
    in_f = fn [h | t] -> {h, t} end
    out_f = fn ls, v -> [v | ls] end
    Enum.reduce(phases, 0, fn ph,sg  ->
      st = %{m: mem, pc: 0, i: [ph, sg], o: []}
      nst = run_to_out(st, in_f, out_f)
      %{o: [sg]} = nst
      sg
    end)
  end

  def perms([]), do: [[]]
  def perms(l) do
    for h <- l, t <- perms(l -- [h]), do: [h|t]
  end

  def part1(prog) do
    perms([0,1,2,3,4])
    |> Enum.map(fn phases -> {run_phases(prog, phases), phases} end)
    |> Enum.max()
  end


  test "test intcode" do
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
  end

  test "run_phases" do
    assert {43210,[4, 3, 2, 1, 0]} == part1([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0])
    assert {54321, [0, 1, 2, 3, 4]}  == part1([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0])
    assert {65210, [1,0,4,3,2]}  == part1([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33, 1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0])

    data = read_data(File.read!("input.txt"))
    IO.puts "PART1: #{inspect part1(data)}"
  end
end
