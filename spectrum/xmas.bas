
paper 0: border 0 :cls:dim x,y,z,p1,p2,r
ink 2: print at 20,5; "Happy holidays !!"
ink 4
r=1:p1=cos(PI/6):p2=cos(PI/2-p1)
for th=0 to 99 step PI/15

x=(r/40+th)/2*cos(th)
y=(r/40+th)/2*sin(th)
z=-r/5+100
r=r+1

xp=-p1*x+p1*y
yp=-p2*x-p2*y+z
if th=0 then plot xp+128,yp+92 else DRAW xp+128-PEEK 23677,yp+92-PEEK 23678
if rnd*6<1 and z<50 then ink 2: circle xp+128,yp+95,3 : ink 4: plot xp+128,yp+92
next th
DO LOOP WHILE INKEY$ = ""