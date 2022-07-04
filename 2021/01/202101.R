td <- c(199, 200, 208, 210, 200, 207, 240, 269, 260, 263)
data <- scan("input.txt")

part1 <- function(d) {
  sum(diff(d) > 0)
}
stopifnot(part1(td) == 7)
cat("PART1: ", part1(data), "\n")

rsum <- function(x, n)
  tail(cumsum(x) - cumsum(c(rep(0, n), head(x, -n))), -n + 1)

part2 <- function(d) {
  part1(rsum(d, 3))
}

stopifnot(part2(td) == 5)
cat("PART1: ", part2(data), "\n")
