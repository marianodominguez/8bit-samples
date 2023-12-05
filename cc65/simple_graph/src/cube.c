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
const int nvert=4;
const int nfaces=6;

int CUBE[]={

    -1,-1,-1, //X=-1
    -1, 1,-1,
    -1, 1, 1,
    -1,-1, 1,

     1,-1,-1,  //X=1
     1, 1,-1,
     1, 1, 1,
     1,-1, 1,

    -1,-1,-1, //Y=-1
    -1,-1, 1,
     1,-1, 1,
     1,-1,-1,

     1,-1, 1,  //Z=1
    -1,-1, 1,
    -1, 1, 1,
     1, 1, 1,

     1, 1, 1, //Y=1
     1, 1,-1,
    -1, 1,-1,
     1, 1,-1,

    -1,-1,-1,  //Z=-1
     1,-1,-1,
     1, 1,-1,
    -1, 1,-1
};

int main(void) {
    int x,y,z,xp,yp;
    unsigned int i,j,xs,ys,x1,y1,x0,y0;
    int idx=0;
    int fd = _graphics(8);
    int p2=761;
    int p1=166;

    unsigned int r = 80;
    if (fd == -1) {
        cputsxy(0,0,"Unable to get graphic mode");
        exit(1);
    }
    cursor(0);
    printf("Cube\n");

    // Store fd for screen
    _setscreen(fd);

    _setcolor(1,1,14);
    _setcolor(2,7,4);
    _color(1);


    for(i=0;i<nfaces;i++) {
        for(j=0; j<nvert; j++)
        {
            x=CUBE[idx++]*100;
            y=CUBE[idx++]*100;
            z=CUBE[idx++]*100;

            //printf("%d,%d,%d = ",x,y,z);

            xp = -p1*x/1000 + p1*y/1000;
            yp = -p2*2/1000 - p2*y/1000 + z;

            xs = xp*2 + 160;
            ys = 96 - yp/3;

            //printf("%d,%d,%d ",i,j,idx);
            if (j==0) {
                x0=xs;
                y0=ys;
                _plot(xs,ys);
            }
            else {
                _plot(x1,y1);
                _drawto(xs,ys);
            }
            x1=xs;
            y1=ys;
        }
        _drawto(x0,y0);
        //wait_start();
        //printf("\n");
    }

    wait_start();

    return EXIT_SUCCESS;
}