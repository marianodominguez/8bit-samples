10 PAPER 6:CLS
15 BORDER 6:INK 0
20 PRINT AT 0,4;"3D plots"
25 DEF FN a(x,y)=25*(SIN(0.001*(x*x+y*y)))
30 FOR x=0 TO 127
35 LET y=SQR(16129-x*x)
40 LET max=-1E9
45 FOR z=-y TO y STEP 4
50 LET v=FN a(x,z)
55 LET p=v+z/4+88
60 IF p<=max THEN GO TO 75
65 LET max=p
70 PLOT 128+x,p:PLOT 128-x,p
75 NEXT z
80 NEXT x