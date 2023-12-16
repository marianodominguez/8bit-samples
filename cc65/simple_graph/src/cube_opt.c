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
int x,y,z,xp,yp,yr,zr,th,pixel_adr;
unsigned char idx,val,bit;
int sqrt2=1414;
int sqrt6=2449;
unsigned int screen,row,col;

#define SAVMSC 89
#define BYTES_PER_ROW 40
#define MODE 8
#define MAX_X 320
#define MAX_Y 192

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

const unsigned char PIXTAB[]={128,64,32,16,8,4,2,1};

void put_pixel(unsigned int x, unsigned char y) {
    row = y*BYTES_PER_ROW;
    col = x / 8;
    pixel_adr=screen+row+col;
    val = PEEK(pixel_adr);
    bit = PIXTAB[x & 7];
    POKE(pixel_adr, val | bit);
}

void line(unsigned int x, unsigned char y, unsigned int x1, unsigned char y1) {
    int x0=x;
    int y0=y;
    int dx=abs(x1-x0);
    int dy=abs(y1-y0);
    int sx = -1;
    int sy = -1;
    int rx=x1;
    int ry=y1;
    int e2,error;

    if (x0<x1) {
        sx=1;
        rx=x0;
    }
    if (y0<y1) {
        sy=1;
        ry=y0;
    }

    error = dx - dy;

    while(x0!=x1 || y0!=y1) {
        put_pixel(x0,y0);
        e2=2*error;
        if(e2 > -dy) {
            error-= dy;
            x0 += sx;
        }
        if(e2 < dx) {
            error+= dx;
            y0 += sy;
        }
    }
}

void bline(unsigned int x, unsigned char y, unsigned int u, unsigned char v) {
    int x0=x;
    int y0=y;
    int x1=u;
    int y1=v;
    int dx=abs(x1-x0);
    int dy=-abs(y1-y0);
    int sx = -1;
    int sy = -1;
    int e2,error;

    if (x0<x1) {
        sx=1;
    }
    if (y0<y1) {
        sy=1;
    }

    error = dx + dy;

    while(1==1) {
        put_pixel(x0,y0);
        put_pixel(x1,y1);

        if (abs(x0-x1)<=1 && abs(y0-y1)<=1) return;

        e2=2*error;
        if(e2 >= dy) {
            error+= dy;
            x0 += sx;
            x1 -= sx;
        }
        if(e2 <= dx) {
            error+= dx;
            y0 += sy;
            y1 -= sy;
        }
    }
}

void cube(void) {
    unsigned int i,j,xs,ys,x1,y1,x0,y0;
    idx=0;
    for(i=0;i<nfaces-1;i++) {
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
    _clear();

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
    wait_start();
    screen = PEEK(SAVMSC)*256+PEEK(SAVMSC-1);

    for (th=0;th<360;th+=20) {
        cube();
    }
    wait_start();
    _graphics(0);
    return EXIT_SUCCESS;
}