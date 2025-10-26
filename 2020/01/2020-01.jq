#!/bin/bash
cat input.txt | jq -s ' first(combinations(2) | select(add == 2020) ) |  (.[0] * .[1]) '
cat input.txt | jq -s ' first(combinations(3) | select(add == 2020) ) |  (.[0] * .[1] * .[2]) '
