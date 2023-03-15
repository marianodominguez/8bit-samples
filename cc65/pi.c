#include <stdio.h>
#include <conio.h>

void main () {
unsigned int d=0;
unsigned long n=3;
unsigned long q=1,r=0,t=1,k=1,l=3;
unsigned long qt,rt,tt,kt;
while(d<18) {
    if (4*q+r-t<n*t) {
        printf("%lu",n);
        if(d==0) printf(".");
        d=d+1;
        qt=q;
        q=10*q;
        rt=r;
        r=10*(r-n*t);
        n=(10*(3*qt+rt)/t)-10*n;
    } else {
        qt=q;
        q=q*k;
        rt=r;
        r=(2*qt+r)*l;
        tt=t;
        t=t*l;
        kt=k;
        k=k+1;
        n=(qt*(7*kt+2)+rt*l)/(tt*l);
        l=l+2;
        }
    }
    cgetc();
}
