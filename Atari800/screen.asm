SAVMSC 	= 	$58
		org $0600
start	ldy #0
		lda #0
loop	sta (SAVMSC),Y
		iny
		tya
		bne loop
pause 	jmp pause