#include <stdio.h>
#include <stdlib.h>
#include <atari.h>
#include "atari_draw.h"
#include <peekpoke.h>
#include <conio.h>
#include "fp_trig.h"

void wait_start() {
    int i;
    int key=0;
    while (key!=6) {
        key = PEEK(0xD01f);
        for (i=0; i<500; i++);
    }
}

int main(void) {
    long x,y,x1,y1;
    int ph,th;
    int fd = _graphics(8);
    unsigned int r = 80;
    if (fd == -1) {
        cputsxy(0,0,"Unable to get graphic mode");
        exit(1);
    }
    wait_start();

    cursor(0);
    printf("Diamond\n");

    // Store fd for screen
    _setscreen(fd);

    _setcolor(1,1,14);
    _setcolor(2,5,4);
    _color(1);

    for(th=0;th<360;th+=20) {
        x = (long) (r+10)*f_sin(th) / SCALE_FACTOR + 160;
        y = 96 - (long) r*f_cos(th) / SCALE_FACTOR -15;

        for(ph=0;ph<360;ph+=20) {
            x1 = (long) (r+10)*f_sin(ph)  / SCALE_FACTOR + 160;
            y1 = 96- (long) r*f_cos(ph)  / SCALE_FACTOR -15;
            _plot(x,y);
            _drawto(x1,y1);
        }
    }

    wait_start();

    return EXIT_SUCCESS;
}