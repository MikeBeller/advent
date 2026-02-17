
jq -sRr '
 . | split("\n")
   |  map((.[1:] | tonumber) * (if (.[0:1] == "R") then 1 else -1 end))
   | [foreach .[] as $y (50; (. + $y) % 100) | select(. == 0) ]
   | length
' 01.txt 

jaq -sRr '. | split("\n")
  |  map((.[1:] | tonumber) * (if (.[0:1] == "R") then 1 else -1 end))
  | foreach .[] as $y (
     {sm: 50, n: 0};
       (.sm + $y) as $z | {sm: $z % 100,
       n: .n +
       if ($z >= 100)
       then ($y/100 | floor)
       else
         if ($z < 0) then (((101 - $y)/100) | floor) else 0 end
       end
       })' 01.txt 
