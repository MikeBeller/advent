library(tidyr)

rx <- r <- "([:digit:]+)-([:digit:]+) ([:lower:]): ([:lower:]+)"
parse_line <- function(line) {
  gs <- str_match(line, rx)
  list(
    a=as.integer(gs[2]),
    b=as.integer(gs[3]),
    c=gs[4],
    pw=gs[5])
}

tds <- "1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc" %>% str_split("\n") %>% flatten()

td <- tds %>%
  map_dfr(parse_line)

part1 <- function(df) {
  df %>%
    mutate(n=str_count(pw,c)) %>%
    filter(n >= a & n <=b) %>%
    count() %>%
    pull()
}

stopifnot(part1(td) == 2)
data <- readLines("input.txt") %>% map_dfr(parse_line)
cat("PART1", part1(data), "\n")

part2 <- function(df) {
  df %>%
    mutate(ca=str_sub(pw,a,a), cb=str_sub(pw,b,b)) %>%
    filter(xor(ca==c, cb==c))  %>%
    count() %>%
    pull()
}

stopifnot(part2(td) == 1)
cat("PART2", part2(data), "\n")
