10 INK 6:PAPER 0:CLS
20 FOR x=0 TO 255 STEP 2
30 PLOT x,0: DRAW 255-x,175
33 LET y=x/2
35 PLOT x,175-y
40 NEXT x