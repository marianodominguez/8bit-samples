; Text mode gr.0 prints a string at x,y

.macro print str, x, y
		lda SAVMSC
		adc :x
		adc :y+80
		sta offset
		lda SAVMSC+1
		;adc #<(:x+:y*#40)
		sta offset+1
		ldy #0
		lda #0
loop:	
		lda :str,Y
		cmp #$FF
		beq pexit
		sta (offset),Y
		iny
		cpy MAXLEN
		bne loop
pexit:	nop
	.endm

