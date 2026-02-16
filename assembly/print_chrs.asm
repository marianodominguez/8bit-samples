SAVMSC 	=	$58
MAXLEN 	=	255
  		org	$0600
  		
start 	ldy #0
  		lda #0
loop	tya 
		cmp #$9B
		beq pause
		sta (SAVMSC),Y
		iny
		cpy MAXLEN
		bne loop
pause 	jmp pause
