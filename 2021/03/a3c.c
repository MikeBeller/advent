#include <stdio.h>
#include <assert.h>

#define MAXNUMS 1001
#define MAXBUF 32
#define MAXBITS 15

int nums[MAXNUMS];
int n_nums;
char buf[MAXBUF];
int col_counts[MAXBITS];
int n_bits;

int b2n(char *buf)
{
    int i;
    char c;
    int n = 0;
    int nb = 0;
    for (i = 0; i < MAXBITS; i++)
    {
        c = buf[i];
        if (c != '0' && c != '1')
            break;
        nb++;
        n = n * 2 + (c - 48);
    }
    if (nb > n_bits)
        n_bits = nb;
    return n;
}

void read_data(char *fname)
{
    FILE *file;
    file = fopen(fname, "r");
    assert(file);
    n_nums = 0;
    n_bits = 0;
    while (fgets(buf, MAXBUF, file))
    {
        assert(n_nums < MAXNUMS);
        nums[n_nums] = b2n(buf);
        n_nums++;
    }
    fclose(file);
    printf("Read data from %s -- n_nums: %d, n_bits: %d\n", fname, n_nums, n_bits);
}

void column_counts()
{
    int ni, bi, mask, c;
    for (bi = 0; bi < n_bits; bi++)
    {
        c = 0;
        mask = 1 << (n_bits - bi - 1);
        for (ni = 0; ni < n_nums; ni++)
        {
            if (nums[ni] & mask)
            {
                c++;
            }
        }
        col_counts[bi] = c;
    }
}

long part1(char *fpath)
{
    int eps, bi, l2;
    long leps, lgam;
    read_data(fpath);
    column_counts();
    for (bi = 0; bi < n_bits; bi++)
    {
        printf("cc: %d %d\n", bi, col_counts[bi]);
    }
    eps = 0;
    l2 = n_nums >> 1;
    for (bi = 0; bi < n_bits; bi++)
    {
        eps = eps << 1;
        if (col_counts[bi] >= l2)
        {
            eps++;
        }
    }
    leps = (long)eps;
    lgam = ~leps & ((1 << n_bits) - 1);
    printf("Eps: %ld, Gam: %ld\n", leps, lgam);
    return leps * lgam;
}

int main()
{
    long ans;
    ans = part1("tinput.txt");
    assert(ans == 198);
    ans = part1("input.txt");
    printf("PART1: %ld\n", ans);
}

/* hold */
