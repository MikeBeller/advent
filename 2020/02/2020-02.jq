#!/bin/bash
cat input.txt | jq -Rs '
 split("\n")
   | map(capture("(?<mn>[0-9]+)-(?<mx>[0-9]+) (?<ch>[a-z]): (?<pw>[a-z]+)"))
   |  map([(.mn | tonumber), (.mx | tonumber), .ch as $ch | (.pw | split("") | indices($ch) | length)])
   | map(select(.[0] <= .[2] and .[2] <= .[1])) | length
 '
cat input.txt | jq -Rs '
 split("\n")
   | map(capture("(?<a>[0-9]+)-(?<b>[0-9]+) (?<ch>[a-z]): (?<pw>[a-z]+)"))
   | map(select(
     (.ch == ((.pw | split(""))[.a | tonumber | . -1])) as $a
      | (.ch == ((.pw | split(""))[.b | tonumber | . -1])) as $b
      | ($a and ($b | not)) or (($a | not) and $b))
      ) | length
 '
