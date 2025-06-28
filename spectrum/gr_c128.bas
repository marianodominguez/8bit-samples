10 PAPER 0:INK 6:CLS
20 LET xp=90:LET yp=45:LET z=0:LET x1=0:LET y1=0:LET zt=0:LET z1=0:LET x=0
30 LET xr=3.14*1.5
60 LET xf=xr/xp
70 LET zf=xr/yp
100 FOR z=-yp TO yp
110 LET zt=z1*xp/yp
120 LET xl=INT(SQR(ABS(xp*xp-zt*zt))+0.5)
130 FOR x=-xl TO xl
140 LET xt=SQR(x*x+zt*zt)*xf
150 LET yy=(SIN(xt)+SIN(xt*3))*0.4*yp
160 LET x1=INT((x+z+140)/2)
170 LET y1=INT(yy-z+90)
180 INK 6: PLOT x1,y1
190 INK 0: DRAW x1,171-y1
200 NEXT x:NEXT z
