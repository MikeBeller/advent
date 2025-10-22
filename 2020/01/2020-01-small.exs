import String
import Enum
import File, [:stream!]
import IO, [:puts]
inp = stream!("input.txt") |> map(&trim/1) |> map(&to_integer/1)
(for x<-inp, y<-inp, y < x,
  do: [x,y]) |> filter(&(sum(&1) == 2020)) |> hd |> product |> puts

(for x<-inp, y<-inp, z<-inp,
  (y < x and z < y), do: [x,y,z])
  |> filter(&(sum(&1) == 2020)) |> hd |> product |> puts

