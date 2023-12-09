#include <stdio.h>
#include <stdlib.h>
#include <atari.h>
#include "atari_draw.h"
#include <peekpoke.h>
#include <conio.h>
#include "fp_trig.h"

void wait_start() {
    unsigned int i;
    unsigned char key=0;
    while (key!=6) {
        key = PEEK(0xD01f);
        for (i=0; i<500; i++);
    }
}
const unsigned char nvert=4;
const unsigned char nfaces=6;

int CUBE[]={

    -100,-100,-100, //X=-1
    -100, 100,-100,
    -100, 100, 100,
    -100,-100, 100,

    -100,-100,-100, //Y=-1
    -100,-100, 100,
     100,-100, 100,
     100,-100,-100,

    -100,-100,-100,  //Z=-1
     100,-100,-100,
     100, 100,-100,
    -100, 100,-100,

     100,-100, 100,  //Z=1
    -100,-100, 100,
    -100, 100, 100,
     100, 100, 100,

     100,-100,-100,  //X=1
     100, 100,-100,
     100, 100, 100,
     100,-100, 100,

     100, 100, 100, //Y=1
     100, 100,-100,
    -100, 100,-100,
     100, 100,-100
};


int main(void) {
    int x,y,z,xp,yp,yr,zr,th;
    unsigned int i,j,xs,ys,x1,y1,x0,y0;
    unsigned char idx;
    int sqrt2=1414;
    int sqrt6=2449;
    int fd = _graphics(8+16);

    if (fd == -1) {
        cputsxy(0,0,"Unable to get graphic mode");
        exit(1);
    }
    cursor(0);

    // Store fd for screen
    _setscreen(fd);

    _setcolor(1,1,14);
    _setcolor(2,7,4);
    _color(1);

    for (th=0;th<360;th+=20) {
        idx=0;
        for(i=0;i<nfaces;i++) {
            for(j=0; j<nvert; j++) {
                x=CUBE[idx++];
                y=CUBE[idx++];
                z=CUBE[idx++];

                x=x/2;
                z=z/2;
                y=y/3;

                //rotation
                yr =  ((long) y*f_cos(th)  - (long) z*f_sin(th))  / SCALE_FACTOR;
                zr =  ((long) y*f_sin(th)  + (long) z*f_cos(th))  / SCALE_FACTOR;

                xp = (long) 1000*(x-zr)/sqrt2;
                yp = (long) 1000*(x+2*yr+zr)/sqrt6;

                xs = xp + 160;
                ys = 96 - yp;

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
            //printf("\n");
        }
        _clear();
    }
    wait_start();

    return EXIT_SUCCESS;
}