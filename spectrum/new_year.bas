
paper 0: border 0 :cls:dim r
ink 1: print at 20,5; "Happy 2023 !!"
ink 4

for i=0 to 5
    r=5
    xc=RND*160:yc=RND*196
    for th=PI/2 to 10*PI step PI/4
    plot r*sin(th)+xc,r*cos(th)+yc
    r=r+1
    next th
next i
DO LOOP WHILE INKEY$ = ""