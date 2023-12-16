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
int x,y,z,xp,yp,yr,zr,th;
unsigned char idx;
int sqrt2=1414;
int sqrt6=2449;
unsigned int screen,row,col;

#define MODE 8
#define MAX_X 160
#define MAX_Y 192
#define SAVMSC 89

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

void cube(void) {
    unsigned int i,j,xs,ys,x1,y1,x0,y0;
    idx=0;
    for(i=0;i<nfaces-1;i++) {
        for(j=0; j<nvert; j++) {
            x=CUBE[idx++];
            y=CUBE[idx++];
            z=CUBE[idx++];

            x=x/3;
            z=z/3;
            y=y/3;

            //rotation
            yr =  ((long) y*f_cos(th)  - (long) z*f_sin(th))  / SCALE_FACTOR;
            zr =  ((long) y*f_sin(th)  + (long) z*f_cos(th))  / SCALE_FACTOR;

            xp = (long) 1000*(x-zr)/sqrt2;
            yp = (long) 1000*(x+2*yr+zr)/sqrt6;

            xs = xp + MAX_X/2;
            ys = MAX_Y/2 - yp;

            if (j==0) {
                x0=xs;
                y0=ys;
                //put_pixel(xs,ys);
            }
            else {
                _fast_draw(x1,y1,xs,ys);
            }
            x1=xs;
            y1=ys;
        }

    }
}

void switch_buffer( unsigned char n) {
    unsigned int buf[2];
    buf[0]=PEEK(SAVMSC)*256+PEEK(SAVMSC-1);
}

int main(void) {
    int fd = _graphics(MODE+16);

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
    //wait_start();

    for (th=0;th<360;th+=10) {
        switch_buffer(0);
        _clear();
        cube();
        switch_buffer(1);
    }
    wait_start();
    _graphics(0);
    return EXIT_SUCCESS;
}