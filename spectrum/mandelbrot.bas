cls
dim za,zb,x0,y0
for xs=0 to 255
    for ys=0 to 191
        x0=xs*(3.5/255)-2.5
        y0=ys*(3/191)-1.5
        za=0:zb=0
        i=0
        while i<=20 and za*za+zb*zb<16
            zt=(za*za-zb*zb)+x0
            zb=2*za*zb+y0
            za=zt
            i=i+1
        end while
    if i>=20 ink 0:plot xs,ys
    if i<6 ink 6: plot xs,ys
    if i<4 ink 1: plot xs,ys
    next ys
next xs
