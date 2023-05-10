# jq -rRs -f 202201.jq <input.txt
(split("\n\n")
| map(split("\n") | map(tonumber) | add))
| @text "PART1: \(max)",
  @text "PART2: \((sort | .[-3:]) | add)"
