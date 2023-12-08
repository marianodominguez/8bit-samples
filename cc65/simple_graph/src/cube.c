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

    -1,-1,-1, //Y=-1
    -1,-1, 1,
     1,-1, 1,
     1,-1,-1,

    -1,-1,-1,  //Z=-1
     1,-1,-1,
     1, 1,-1,
    -1, 1,-1,

     1,-1, 1,  //Z=1
    -1,-1, 1,
    -1, 1, 1,
     1, 1, 1,

     1,-1,-1,  //X=1
     1, 1,-1,
     1, 1, 1,
     1,-1, 1,

     1, 1, 1, //Y=1
     1, 1,-1,
    -1, 1,-1,
     1, 1,-1
};


int main(void) {
    int x,y,z,xp,yp;
    long yr,zr;
    unsigned int i,j,xs,ys,x1,y1,x0,y0;
    int idx=0,th=0;
    int sqrt2=1414;
    int sqrt6=2449;
    int fd = _graphics(8+16);

    unsigned int r = 80;
    if (fd == -1) {
        cputsxy(0,0,"Unable to get graphic mode");
        exit(1);
    }
    cursor(0);
    //printf("Cube\n");

    // Store fd for screen
    _setscreen(fd);

    _setcolor(1,1,14);
    _setcolor(2,7,4);
    _color(1);

    for (th=0;th<360;th+=20) {
        idx=0;
        for(i=0;i<nfaces;i++) {
            for(j=0; j<nvert; j++) {
                x=CUBE[idx++]*100;
                y=CUBE[idx++]*100;
                z=CUBE[idx++]*100;

                //scale

                x=x/2;
                z=z/2;
                y=y/3;

                //rotation
                //x = x;
                yr =  ((long) y*f_cos(th)  - (long) z*f_sin(th))  / SCALE_FACTOR;
                zr =  ((long) y*f_sin(th)  + (long) z*f_cos(th))  / SCALE_FACTOR;

                xp = (long) 1000*(x-zr)/sqrt2;
                yp = (long) 1000*(x+2*yr+zr)/sqrt6;

                //printf("%d,%d = ",xp,yp);

                xs = xp + 160;
                ys = 96 - yp;

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
            //printf("\n");
        }
        wait_start();
    }
    wait_start();

    return EXIT_SUCCESS;
}