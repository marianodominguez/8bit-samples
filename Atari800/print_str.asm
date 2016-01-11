SAVMSC 	=	$58
MAXLEN 	=	100
  		org	$0600
  		
start 	ldy #0
  		lda #0
loop	lda string,Y
		cmp #$FF
		beq pause
		sta (SAVMSC),Y
		iny
		cpy MAXLEN
		bne loop
pause 	jmp pause
string 	.byte $0,$40,"  Hello 6502 World !  ",$40,$FF
 		.byte "please terminate your strings with $FF",$FF