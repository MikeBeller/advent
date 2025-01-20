require 'pl'
stringx.import()
pp = pretty.dump
inp = file.read("input.txt")

function main(part)
  s = 0
  m = 1
  for i = 1,#inp do
    if inp:find("^don't%(%)", i) then
      m = (part == 1) and 1 or 0
    elseif  inp:find("^do%(%)", i) then
      m = 1
    else
      x,y,a,b = inp:find("^mul%((%d+),(%d+)%)", i)
      if x then
        s = s + m * ((a+0)<1000 and a or 0) * ((b+0)<1000 and b or 0)
      end
    end
  end
  return s
end

print(main(1))
print(main(2))
