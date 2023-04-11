10 gr.7:c.1
20 deg
30 xc=80:yc=92:r1=70:r2=40
40 circle xc,yc,r1
50 circle xc,yc,r2
60 r=r2
70 th=0
80 while r<r1
90 x=r2*sin(th)+xc
100 r=r+1
110 th=th+1
120 wend
130 pause 500