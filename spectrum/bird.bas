cls
dim k,a,b,r
dim x,y as uinteger
function pow(x,y as uinteger) as float
    if x<0 and y mod 2=0 return abs(x)^y
    if x<0 and y mod 2=1 return -(abs(x)^y)
    return x^y 
end function

for k=-20000 to 20000 step 13


a=3*k/45000 + sin(17*PI/20*pow(k/20000,5)) * pow(cos(41*PI*k/20000),6) + (1/3*pow(cos(41*PI*k/20000) ,16) + 1/3*pow(cos(41*PI*k/20000),80) )*pow(cos(PI*k/40000),12)*sin(6*PI*k/20000)

b=15/30* pow(k/20000,4) - cos(17*PI/20*pow(k/20000,5)) * ( 11/10+45/20*pow(cos(PI*k/40000),8)*pow(cos(3*PI*k/40000),6) ) * pow(cos(41*PI*k/20000),6) + 12/20*pow(cos(3*PI*k/200000),10) * pow(cos(9*PI*k/200000),10) * pow(cos(18*PI*k/200000),10)
    
r=1/50+1/40*pow(sin(41*PI*k/20000),2)*pow(sin(9*PI*k/200000),2)+1/17*pow(cos(41*PI*k/20000),2)*pow(cos(PI*k/40000),10)

x=30*a+120 
y=42*b+120
circle x, y, int(r*130)
next k
pause 255
