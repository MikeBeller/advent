#include "stdio.h"

/* This runs 4,765,174,225 clock cycles (around 20 minutes) vs 12 minutes for dxforth! */

struct poly {
    short x1;
    short y1;
    short x2;
    short y2;
};

struct poly polys[1500];
unsigned int num_polys;
unsigned char grid[10][1000];

int min(x,y)
  unsigned int x,y;
{
    return ((x < y) ? x : y);
}

int max(x,y) 
  unsigned int x,y;
{
    return ((x > y) ? x : y);
}

void zero_grid() {
    int x,y;
    for (y = 0; y < 10; y++) {
        for (x = 0; x < 1000; x++) {
            grid[y][x] = 0;
        }
    }
}

void blit_grid(x1, y1, x2, y2)
  unsigned int x1, y1, x2, y2;
 {
    unsigned int x, y;
    for (y = y1; y < y2; y++) {
        for (x = x1; x < x2; x++) {
            grid[y][x] = grid[y][x] + 1;
        }
    }     
}

unsigned count_overlap(ymin) 
    unsigned int ymin;
{
    unsigned int ymax, ox1, oy1, ox2, oy2;
    unsigned int i, x, y;
    unsigned long count;
    ymax = ymin + 10;
    zero_grid();
    for (i = 0; i < num_polys; i++) {
        ox1 = polys[i].x1;
        ox2 = polys[i].x2;
        oy1 = max(ymin, polys[i].y1);
        oy2 = min(ymax, polys[i].y2);
        if (oy2 > oy1) {
            blit_grid(ox1, oy1-ymin, ox2, oy2-ymin);
        }
    }

    count = 0;
    for (y = 0; y < 10; y++) {
        for (x = 0; x < 1000; x++) {
            if (grid[y][x] > 1) {
                count++;
            }
        }
    }
    return count;
}

int main() {
    FILE *fp;
    unsigned short x, y, w, h;
    unsigned int n, ymin;
    unsigned long total_overlap;

    if ((fp = fopen("T1803.TXT", "r")) == NULL) {
        printf("Can't open file");
        exit(1);
    }

    num_polys = 0;
    while (!feof(fp)) {
        fscanf(fp, "#%*d @ %d,%d: %dx%d\n", &x, &y, &w, &h);
        polys[num_polys].x1 = x;
        polys[num_polys].y1 = y;
        polys[num_polys].x2 = x + w;
        polys[num_polys].y2 = y + h; 
        num_polys++;
    }
    printf("Num polys: %d\n", num_polys);

    total_overlap = 0;
    for (ymin = 0; ymin < 1000; ymin += 10) {
        printf("TOP %d %ld\n", ymin, total_overlap);
        total_overlap += count_overlap(ymin);
    }
    printf("%ld\n", total_overlap);
}
