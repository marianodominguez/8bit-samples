#include <stdio.h>
#include <stdlib.h>
#include <atari.h>
#include "atari_draw.h"
#include <peekpoke.h>
#include <conio.h>

void wait_start() {
    int i;
    int key=0;
    while (key!=6) {
        key = PEEK(0xD01f);
        for (i=0; i<500; i++);
    }
}

int main(void) {
    unsigned int x;
    unsigned char y;
    int fd = _graphics(8);

    if (fd == -1) {
        cputsxy(0,0,"Unable to get graphic mode");
        exit(1);
    }

    cursor(0);


    // Store fd for screen
    _setscreen(fd);

    _setcolor(1,1,14);
    _setcolor(2,4,4);
    _color(1);

    for(x=50;x<210;x++) {
        for (y=10;y<12; y++)
        {
            _fast_draw(x,y,0,0);
             printf("%d,%d ",x,y);
        }
        //_drawto(x,160);
    }

    wait_start();

    return EXIT_SUCCESS;
}