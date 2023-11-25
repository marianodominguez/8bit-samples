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
    int fd = _graphics(8);

    if (fd == -1) {
        cputsxy(0,0,"Unable to get graphic mode");
        exit(1);
    }

    cursor(0);
    printf("Moire pattern\n");

    // Store fd for screen
    _setscreen(fd);

    _setcolor(1,1,14);
    _setcolor(2,4,4);
    _color(1);

    for(x=0;x<320;x+=2) {
        _plot(160,0);
        _drawto(x,160);
    }

    wait_start();

    return EXIT_SUCCESS;
}