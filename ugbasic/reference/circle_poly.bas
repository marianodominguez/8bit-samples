BITMAP ENABLE
CLS
w = SCREEN WIDTH / 2
h = SCREEN HEIGHT / 2
IF SCREEN HEIGHT > SCREEN WIDTH THEN
    d = w/2 
ELSE
    d = h/2 
ENDIF
CIRCLE w,h,d
POLYLINE w-d,h-d TO w+d,h+d TO w+d,h-d TO w-d,h-d TO w-d,h+d TO w-d,h-d
