0 PAPER 0: INK 6:CLS:DIM s(30):LET x=107: LET y=142:LET h=0:LET v=6:LET s(1)=9:LET s(2)=1:LET p=3:GO SUB 1:STOP
1 LET p=p-2:LET n=s(p):LET a=s(p+1):IF n=0 THEN LET u=x+h:LET w=y-v:PLOT x,y:DRAW u-x,w-y:LET x=u:LET y=w:RETURN
2 LET s(p)=n-1:LET s(p+1)=-1:LET s(p+2)=a:LET s(p+3)=n-1:LET s(p+4)=1:LET p=p+5:GO SUB 1:GO SUB 3:GO SUB 1:RETURN
3 LET p=p-1:LET a=s(p):LET t=-a*h:LET h=a*v:LET v=t:RETURN
