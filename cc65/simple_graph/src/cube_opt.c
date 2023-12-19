#include <stdio.h>
#include <stdlib.h>
#include <atari.h>
#include "atari_draw.h"
#include <peekpoke.h>
#include <conio.h>
#include "fp_trig.h"

#pragma data-name (push, "BUFFER")
unsigned char BUFFER[0x2000] ={};
#pragma  data-name (pop)

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
unsigned int buf[2];

#define MODE 8
#define MAX_X 160
#define MAX_Y 192
#define SAVMSC 89

unsigned int dl,dl4,dl5,dljmp,bhi,blo,rhi,rlo;
unsigned int rh,rl;
int fd;


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

            x=x/5;
            z=z/4;
            y=y/4;

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

void reserve_ram() {
    int i;
    //first buffer setup

    fd = _graphics(MODE+16);        //initialize graphics mode
    rh = PEEK(SAVMSC);
    rl = PEEK(SAVMSC-1);            // get video memory start
    dl = PEEK(560)+256*PEEK(561);   // Get display list location
    dl4=dl+4;                       // 4th (low byte) of memory to display
    dl5=dl+5;                       // 5th (high byte) of memory to display
    _clear();

    for(i=dl5+1; i<dl5+192; i++) {      //Look for second jump instruction after 4k
        if(PEEK(i)==79) dljmp=i+1;
    }

    //original ram jump
    rlo=PEEK(dljmp);                    //Store address of ssecond half of display location
    rhi=PEEK(dljmp+1);

    POKE(SAVMSC-1,(unsigned int) &BUFFER & 0x00ff);     // point write video to buffer
    POKE(SAVMSC,(unsigned int) &BUFFER/256);
    fd = _graphics(MODE+16);                            //initialize grahics over buffer
    _clear();

}

void switch_buffer( unsigned char n) {
    unsigned int buf_hi=(unsigned int) &BUFFER/256;
    unsigned int buf_lo=(unsigned int) &BUFFER & 0x00FF;
    //original buffer jump

    //fix this offset

    bhi=buf_hi+0x0E;
    blo=buf_lo+0xB0;

    if (n==0) {
        POKE(SAVMSC,rh);      //write to video RAM
        POKE(SAVMSC-1,rl);
        POKE(dl5, buf_hi);    //Display buffer contents
        POKE(dl4,buf_lo);
        POKE(dljmp, blo);     //jump to second 4k of buffer
        POKE(dljmp+1, bhi);

        _setcolor(2,0,4);

    } else {
        POKE(SAVMSC,buf_hi);     //write to buffer
        POKE(SAVMSC-1,buf_lo);
        POKE(dl5, rh);              //display video Ram
        POKE(dl4, rl);
        POKE(dljmp, rlo);           // Jump to second 4k of video
        POKE(dljmp+1, rhi);
        _setcolor(2,7,4);
    }
}

int main(void) {
    unsigned int n=0;

    reserve_ram();

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

    //switch_buffer(n);
    for (th=0;th<360;th+=10) {
        switch_buffer(n);
        _clear();
        cube();
        if (n==0) {
            n=1;
        } else {
            n=0;
        }
    }
    wait_start();
    _graphics(0);
    return EXIT_SUCCESS;
}