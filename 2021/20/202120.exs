defmodule Advent20 do
  import List, only: [duplicate: 2, to_tuple: 1]
  import Tuple, only: [to_list: 1]

  def cvt(?#), do: 1
  def cvt(?.), do: 0

  def size(img) do
    {tuple_size(img), tuple_size(elem(img, 0))}
  end

  def show(img) do
    img
    |> to_list()
    |> Enum.each(&IO.inspect/1)
  end

  def line_to_tuple(line) do
    line
    |> String.to_charlist()
    |> Enum.map(&cvt/1)
    |> to_tuple()
  end

  def parse(instr) do
    [alg_s, img_s] = String.split(instr, "\n\n", parts: 2)
    alg = line_to_tuple(alg_s)

    img =
      img_s
      |> String.split("\n")
      |> Enum.map(&line_to_tuple/1)
      |> to_tuple()

    {alg, img}
  end

  def pad(img, n) do
    {_nr, nc} = size(img)
    zero_row = to_tuple(duplicate(0, nc + 2 * n))
    margin = duplicate(zero_row, n)
    side = duplicate(0, n)

    (margin ++
       for row <- to_list(img) do
         to_tuple(side ++ to_list(row) ++ side)
       end ++ margin)
    |> to_tuple()
  end

  def compute_n(img, r, c, nr, nc, default_val) do
    pvals =
      for ri <- -1..1, ci <- -1..1, rr = r + ri, cc = c + ci do
        if rr >= 0 and rr < nr and cc >= 0 and cc < nc do
          elem(elem(img, rr), cc)
        else
          default_val
        end
      end

    Enum.reduce(pvals, 0, fn p, n -> 2 * n + p end)
  end

  def enhance_round(round, img, alg, nr, nc) do
    default_val = if elem(alg, 0) == 1 and rem(round, 2) == 0, do: 1, else: 0

    for r <- 0..(nr - 1) do
      for c <- 0..(nc - 1) do
        n = compute_n(img, r, c, nr, nc, default_val)
        elem(alg, n)
      end
      |> to_tuple()
    end
    |> to_tuple()
  end

  def enhance(alg, img, n_rounds) do
    {nr, nc} = size(img)

    Enum.reduce(1..n_rounds, img, &enhance_round(&1, &2, alg, nr, nc))
  end

  def sum_img(img) do
    for row <- to_list(img) do
      Tuple.sum(row)
    end
    |> Enum.sum()
  end

  def part1(alg, img) do
    img = pad(img, 4)
    enhanced_img = enhance(alg, img, 2)
    sum_img(enhanced_img)
  end

  def part2(alg, img) do
    img = pad(img, 55)
    enhanced_img = enhance(alg, img, 50)
    sum_img(enhanced_img)
  end
end

{talg, timg} = File.read!("tinput.txt") |> Advent20.parse()

35 = Advent20.part1(talg, timg)

{alg, img} = File.read!("input.txt") |> Advent20.parse()
IO.puts("PART1: #{Advent20.part1(alg, img)}")

3351 = Advent20.part2(talg, timg)
IO.puts("PART1: #{Advent20.part2(alg, img)}")
