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

void draw(unsigned int x1,unsigned char y1,unsigned int x2,unsigned char y2) {
    unsigned int x;
    for(x=x1;x<x2;x+=10) {
       _fast_draw(x1,y1,x,y2);
    }
}

int main(void) {

    unsigned int x2=0;
    unsigned char y2=0;
    int fd = _graphics(6+16);

    if (fd == -1) {
        cputsxy(0,0,"Unable to get graphic mode");
        exit(1);
    }
    cursor(0);
    // Store fd for screen
    _setscreen(fd);

    _setcolor(0,1,14);

    _color(1);
    _clear();
    _setcolor(4,4,4);
    _plot(10,10);
    _drawto(159,95);
    draw(0,0,159,95);
    wait_start();

    return EXIT_SUCCESS;
}