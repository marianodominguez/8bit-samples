function Hs(a)
 if a<0 then return 0
 if a=0 then return 1/2
 return 1
end function

function pow2(x)
    return x*x
end function

function sqrt(x)
    if x<0 then return 0
    return sqr(x)
end function

sub pl(x,yt)
 if x=-7 then 
    PLOT int(12*x+120),int(12*yt+92) 
 else
     DRAW int(12*x+120)-PEEK 23677,int(12*yt+92)-PEEK 23678
 end if
end sub

border 1:ink 0:paper 6:cls
for x = -7 to 7 step 0.1 
 w=3*sqr(1-pow2(x/7))
 l=(6/7)*sqr(10) + (3+x)/2 -3/7*sqr(10)*sqrt(4-pow2(x+1))
 h= ( 3*( abs(x-1/2) + abs(x+1/2) + 6 ) - 11 * ( abs(x-3/4) + abs(x+3/4) ) ) / 2
 r=6/7*sqr(10)+(3-x)/2-3/7*sqr(10)*sqrt(4-pow2(x-1))
 yt=(h-l)*Hs(x+1)+(r-h)*Hs(x-1)+(l-w)*Hs(x+3)+(w-r)*Hs(x-3)+w
 pl(x,yt)
next x

for x = -7 to 7 step 0.1
  a=abs(x/2) + sqrt( 1-pow2( abs(abs(x)-2) -1) ) - (3*sqrt(33)-7)/112 * pow2(x) + 3 * sqrt(1 - pow2(x/7) -3)
  yb=(1/2)*a*(sgn(x+4) - sgn(x-4))- 3*sqrt(1-pow2(x/7))    
  pl(x,yb)
next x