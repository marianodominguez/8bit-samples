PI%=3.1415926535
gr. 8+16:c.1
th%=0:r=60
while th%<10
xp=int(160+r*sin(th%))
yp=int(96+r*cos(th%))
if th%=0
plot xp,yp
else
dr. xp,yp
endif
th%=th%+PI%/20
r=r-1
wend
pause 30000