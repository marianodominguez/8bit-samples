; Text mode gr.0 prints a string at x,y
MAXLEN 	  =	100
;text offset  		
offset = $F0

.macro print str, x, y
		clc
		lda SAVMSC
		adc :x
		;adc :y+80
		sta offset
		lda SAVMSC+1
		;adc #<(:x+:y*#40)
		sta offset+1
		ldy #0
		lda #0
loop:	
		lda :str,Y
		cmp #$9B
		beq pexit
		sta (SAVMSC),Y
		iny
		cpy #MAXLEN
		bne loop
pexit:	nop
.endm
	
;use CIO to set graphics mode
.macro graphics mode
; reset gr. 0
		lda :mode
		pha
		ldx #$60 		;screen
		lda #$C 		; CLOSE
		sta ICCOM,X
		jsr CIOV 		;do close
		ldx #$60
		lda #3 			;open
		sta ICCOM,X
		lda #name&255
		sta ICBAL,X
		lda #name/256
		sta ICBAH,X
		pla				; get gr. mode
		sta ICAX2,X
		and #$10 + $20
		eor #$10
		ora #$0C
		sta ICAX1,X
		jsr CIOV
name   .byte $53,$3A,$9B
.endm


