
jq -sRr '
 . | split("\n") |  map((.[1:] | tonumber) * (if (.[0:1] == "R") then 1 else -1 end))
   | foreach .[] as $y (50; (. + $y) % 100)
   | select(. == 0)
' 01.txt | wc -l
