SAVMSC 	=	$58
MAXLEN 	=	100
		ORG $0600
START 	LDY #0
  		LDA #0
LOOP	LDA STRING,Y
		CMP #$9B
		BEQ PAUSE
		STA (SAVMSC),Y
		INY
		CPY MAXLEN
		BNE LOOP
PAUSE 	JMP PAUSE
STRING 	.byte $0,$40,"  Hello 6502 World !  ",$40,$9B ; EOL
