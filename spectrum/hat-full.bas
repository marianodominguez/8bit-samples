10 CLS : LET t=(65536*PEEK 23674+256*PEEK 23673+PEEK 23672)/50
20 LET p=160: LET q=100
30 LET xp=144: LET xr=1.5*PI
40 LET yp=56: LET yr=1: LET zp=64
50 LET xf=xr/xp: LET yf=yp/yr: LET zf=xr/zp
60 FOR z=-q TO q-1
70 IF z<-zp OR z>zp THEN GO TO 150
80 LET zt=z*xp/zp: LET zz=z
90 LET xl=INT (.5+SQR (xp*xp-zt*zt))
100 FOR x=-xl TO xl
110 LET xt=SQR (x*x+zt*zt)*xf: LET xx=x
120 LET yy=(SIN (xt)+.4*SIN (3*xt))*yf
130 GO SUB 170
140 NEXT x
150 NEXT z
160 PRINT AT 0,0;INT ((65536*PEEK 23674+256*PEEK 23673+PEEK 23672)/50-t): GO TO 9999
170 LET x1=xx+zz+p
180 LET y1=yy-zz+q
190 IF x1>=0 AND x1<=255 AND y1>=0 AND y1<=175 THEN PLOT x1,y1
200 IF y1=0 THEN RETURN
210 IF x1>=0 AND x1<=255 AND y1>=0 AND y1<=176 THEN PLOT x1,y1-1
220 RETURN
