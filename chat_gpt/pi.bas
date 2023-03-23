10 d=0
20 while d<10
30 q = 1:r=0:t=1:k=1:n=3:l=3
40 if 4*q+r-t < n*t 
50 print n
60 d=d+1
70 qt=q
80 q=10*q
90 rt=r
100 r=10*(r-n*t)
110 n=(10*(3*qt+rt))/t-10*n
120 else
130 qt=q
140 q=q*k
150 r=(2*qt+r)*l
160 t=t*l
170 k=k+1
180 kt=k
190 n=(q*(7*kt+2)+r*l)/(t*l)
200 l=l+2
210 endif
220 wend