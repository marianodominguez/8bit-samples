    opt l+h+f-

SDMCTL = $022F ;Disable screen DMA
COLOR1 = $D017
COLOR2 = $D018
COLOR3 = $D019
COLOR4 = $D01A
RTCLOK = $14

;text offset
offset    = $F0
MAXLEN	  = 100
	icl "hardware.asm"

    org $3000 ;Start of code

		; print message
start   NOP

loop	
		LDA string,Y
		CMP #$9B
		BEQ pause
		STA (SAVMSC),Y
		INY
		CPY #MAXLEN
		BNE loop
pause 	jmp pause

string 	.byte $0,$40,"  Hello 6502 World !  ",$40,$9B
 		.byte "please terminate your strings with $9B",$9B
