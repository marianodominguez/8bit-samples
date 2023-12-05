cls:dim x,y,z
r=50:p1=cos(PI/6):p2=cos(PI/3)
for th=0 to 2*PI step PI/20
for ph=0 to  2*PI step PI/20
x=r*sin(th)*cos(ph)
y=r*sin(th)*sin(ph)
z=r*cos(th)

xp=-p1*x+p1*y
yp=-p2*x-p2*y+z

if th=0 then plot xp+128,yp+92 else DRAW xp+128-PEEK 23677,yp+92-PEEK 23678
next ph
next th