GRAPH= $EF9C
SAVMSC=$58
x=$F0
y=$F1
xmax=319
ymax=192
HROW=84
HCOL=85


  	org $4000
  	LDA #8 ; gr mode
  	JSR GRAPH ;graphics mode
	RTS

PLOT 
	LDA x
	STA HROW
	LDA y
	STA HCOL
	
	LDA X
	LDA Y
	STA (SAVMSC),Y
	RTS
 	