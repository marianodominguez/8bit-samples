paper 1:border 0:bright 1:cls
dim x,y as uinteger:dim th:dim o(5) as ubyte =>{0,2,4,1,3,0}:dim xs(5): dim ys(5)
ink 2: for y=20 to 96:plot 0,y:draw 255,0:next y
ink 7: for x=96 to 255:plot x,96:draw 0,95:next x
ink 0:paper 0: PRINT AT 21, 0;:FOR i = 1 TO 128: PRINT " ";: NEXT i
ink 7:paper 1
for r=25 to 1 step -1 
for j=0 to 5
th=th+2/5*PI
xs(j)=r*sin(th)+45:ys(j)=r*cos(th)+96+48
next j
for i=0 to 5
plot xs(o(i)),ys(o(i))
draw xs(o(i+1))-PEEK 23677,ys(o(i+1))-PEEK 23678
next i
next r
