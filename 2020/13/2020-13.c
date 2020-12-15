#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>

// Runs in 11ms on the SAMD21 chip -- vs 216ms for the
// CircuitPython version, so around 20 times faster.

// Sets rv to integer value of string pointed to by *s,
// up to any separator character in sep (a la strpbrk),
// or NULL char at end of *s.
//
// Updates *s to point to next char after the sep char, except
// if it hits a null char while scanning, in which case it sets
// it to point to the null char itself.
//
// Returns: 0 for no error, -1 for error (invalid integer or no
// conversion due to EOS)
int32_t get_int(char **s, int32_t *rv, char *sep) {
    if (s == NULL || *s == NULL || **s == 0)
        return -1;
    char *en = strpbrk(*s, sep);
    if (en == 0)
        en = *s + strlen(*s);
    *rv = strtol(*s, NULL, 10);
    *s = *en == 0 ? en : en + 1;
    return 0;
}

int64_t part1(char *inp) {
    int32_t b, dtm;
    char *s = inp;
    if (get_int(&s, &dtm, "\n") != 0)
        return -1;

    int32_t min_delay = 99999999;
    int32_t min_delay_bus = -1;
    while (get_int(&s, &b, ",") == 0) {
        if (b == 0) continue;
        int32_t delay = b - (dtm % b);
        if (delay < min_delay) {
            min_delay = delay;
            min_delay_bus = b;
        }
    }
    return (int64_t) min_delay * (int64_t) min_delay_bus;
}

int32_t norm(int32_t x, int32_t b) {
    int32_t v = x % b;
    return (v >= 0 ? v : v + b);
}

int64_t part2(char *inp) {
    int32_t b, dtm;
    char *s = inp;
    if (get_int(&s, &dtm, "\n") != 0)
        return -1;

    int32_t min_delay = 99999999;
    int32_t min_delay_bus = -1;
    int32_t i = 0;
    int64_t m = -1;
    int64_t r = -1;
    while (get_int(&s, &b, ",") == 0) {
        if (b == 0) {
            i++;
            continue;
        }
        int32_t o = norm(-i, b);
        if (m == -1) {
            m = b;
            r = o;
            i++;
            continue;
        }

        while (r % b != o) {
            r += m;
        }
        m *= b;
        i++;
    }
    return r;
}

char *test_data = "939\n7,13,x,x,59,x,31,19";
char *input_txt = "1000001\n29,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,577,x,x,x,x,x,x,x,x,x,x,x,x,13,17,x,x,x,x,19,x,x,x,23,x,x,x,x,x,x,x,601,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37";

void main() {
    assert(part1(test_data) == 295);
    printf("PART1: %ld\n", part1(input_txt));
    assert(part2(test_data) == 1068781);
    printf("PART2: %ld\n", part2(input_txt));
}

