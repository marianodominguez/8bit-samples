#include <stdio.h>
#include <stdlib.h>
#include <atari.h>
#include "atari_draw.h"
#include <peekpoke.h>
#include <conio.h>
#include "fp_trig.h"

#define BYTES_PER_ROW 20
#define SAVMSC 89

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
unsigned char idx,val,bit;
int pixel_adr;
unsigned int screen,row,col;

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


int main(void) {
    int x,y,z,xp,yp,yr,zr;
    unsigned int i,j,xs,ys,x1,y1,x0,y0;
    int th=0;
    int sqrt2=1414;
    int sqrt6=2449;
    int fd = _graphics(8+16);

    unsigned int r = 80;
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

    screen = PEEK(SAVMSC)*256+PEEK(SAVMSC-1);

    for (th=0;th<360;th+=10) {
        idx=0;
        _clear();
        for(i=0;i<nfaces-1;i++) {
            for(j=0; j<nvert; j++) {
                x=CUBE[idx++]*100;
                y=CUBE[idx++]*100;
                z=CUBE[idx++]*100;

                x=x/2;
                z=z/2;
                y=y/3;

                //rotation
                yr =  ((long) y*f_cos(th)  - (long) z*f_sin(th))  / SCALE_FACTOR;
                zr =  ((long) y*f_sin(th)  + (long) z*f_cos(th))  / SCALE_FACTOR;

                xp = (long) 1000*(x-zr)/sqrt2;
                yp = (long) 1000*(x+2*yr+zr)/sqrt6;

                xs = xp + 320/2;
                ys = 96 - yp;

                if (j==0) {
                    x0=xs;
                    y0=ys;
                }
                else {
                    bline(x1,y1,xs,ys);
                }
                x1=xs;
                y1=ys;
            }
        }
    }
    wait_start();

    return EXIT_SUCCESS;
}