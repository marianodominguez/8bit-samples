graphics 8+16:setcolor 1,1,12:setcolor 2,0,0:color 1
u%=0.0:v%=0.0:PI%=3.141592:sq2%=sqr(2)
p1%=cos(PI%/6):p2%=cos(PI%/2-p1%)
while v%<2*PI%
  poke 77,0
  cosv%=cos(v%)
  sinv%=sin(v%)
  while u%<PI%
    cosu%=cos(u%)
  	sinu%=sin(u%)
	c7u%=cosu%*cosu%*cosu%*cosu%*cosu%*cosu%*cosu%
	c6u%=cosu%*cosu%*cosu%*cosu%*cosu%*cosu%
	c5u%=cosu%*cosu%*cosu%*cosu%*cosu%
	c4u%=cosu%*cosu%*cosu%*cosu%
	c3u%=cosu%*cosu%*cosu%
	
	x%=(-2/15)*cosu%*(3*cosv%-30*sinu%+90*c4u%*sinu%-60*c6u%*sinu%+5*cosu%*cosv%*sinu%)
	y%=(-1/15)*sinu%*(3*cosv%-3*cosu%*cosu%*cosv%-48*c4u%*cosv%+48*c6u%*cosv%-60*sinu%+5*cosu%*cosv%*sinv%-5*c3u%*cosv%*sinu%-80*c5u%*cosv%*sinu%+80*c7u%*cosv%*sinu%)
	z%=(2/15)*(3+5*cosu%*sinu%)*sinv%
	x%=25*x%:y%=25*y%:z%=25*z%
	xp=int(-p1%*x%+p1%*y%)
	yp=int(-p2%*x%-p2%*y%+z%)
	if u%=0
		plot xp+100,80-yp
	else
		drawto xp+100,80-yp
	endif
    u%=u%+PI%/20
  wend
    v%=v%+PI%/20
    u%=0.0
wend
