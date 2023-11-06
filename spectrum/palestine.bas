border 7: ink 0:paper 2:cls
ink 0: for y=128 to 191: plot 191-y,y:draw 254-PEEK 23677,0:next y
ink 7: for y=64 to 95: plot y,y:draw 254-PEEK 23677,0:next y
for y=96 to 127: plot 192-y,y:draw 254-PEEK 23677,0:next y
ink 4: for y=0 to 63: plot y,y:draw 254-y,0:next y
ink 7:paper 0: print flash 1; at 1,10;"  FREE !"
pause 10000