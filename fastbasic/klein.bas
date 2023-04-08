graphics 8+16:setcolor 1,1,12:setcolor 2,0,0:color 1
u%=0.0:v%=0.0:PI%=3.141592:sq2%=sqr(2)
p1%=cos(PI%/6):p2%=cos(PI%/2-p1%)
while v%<2*PI%
  while u%<2*PI%
	x%=cos(u%)*(cos(1/2*u%)*(sq2%+cos(v%))+sin(1/2*u%)*sin(v%)*cos(v%))
	y%=sin(u%)*(cos(1/2*u%)*(sq2%+cos(v%))+sin(1/2*u%)*sin(v%)*cos(v%))
	z%=-sin(1/2*u%)*(sq2%+cos(v%))+cos(1/2*u%)*sin(v%)*cos(v%)
	xp=int(35*(-p1%*x%+p1%*y%))
	yp=int(35*(-p2%*x%-p2%*y%+z%))
	if u%=0
		plot xp+160,yp+120
	else
		drawto xp+160,yp+120
	endif
    u%=u%+PI%/20
  wend
    v%=v%+PI%/20
    u%=0.0
wend