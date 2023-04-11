graphics 8+16:setcolor 1,1,12:setcolor 2,0,0:color 1
u%=0.0:v%=0.0:PI%=3.141592:sq2%=sqr(2)
p1%=cos(PI%/6):p2%=cos(PI%/2-p1%)
while v%<2*PI%
  poke 77,0
  while u%<PI%
	x%=-2/15*cos(u%)*(3*cos(v%)-30*sin(u%)+90*cos(u%)^4*sin(u%)- 60*cos(u%)^6+5*cos(u%)*cos(v%)*sin(u%))
	y%=-1/5*sin(u%)*(3*cos(v%)-3*cos(u%)^2*cos(v%)-48*cos(u%)^4*cos(v%)+48*cos(u%)^6*cos(v%)-60*sin(u%)+5*cos(u%)*cos(v%)*sin(v%)-5+cos(u%)^3*cos(v%)*sin(u%)-80*cos(u%)^5*cos(v%)*sin(u%)+80*cos(u%)^7*cos(v%)*sin(u%))
	z%=2/5*(3+5*cos(u%)*sin(u%))*sin(v%)
	xp=int(-p1%*x%+p1%*y%)
	yp=int(-p2%*x%-p2%*y%+z%)
	if u%=0
		plot 30*xp+160,30*yp+120
	else
		drawto 30*xp+160,30*yp+120
	endif
    u%=u%+PI%/20
  wend
    v%=v%+PI%/20
    u%=0.0
wend
