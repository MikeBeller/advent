
partx <- function(ns, n) {
    t <- combn(ns, n)
    #x <- apply(t, 2, sum)  -- slow
    x <- colSums(t)
    i <- which(x == 2020)
    #i <- detect_index(x, ~ . == 2020) -- slow
    prod(t[,i])
}

td <- c(1721,979,366,299,675,1456)
stopifnot(partx(td, 2) == 514579)
data <- scan("input.txt")
cat("PART1:", partx(data, 2), "\n")

stopifnot(partx(td, 3) == 241861950)
system.time(ans2 <- partx(data, 3))
cat("PART2:", ans2, "\n")
