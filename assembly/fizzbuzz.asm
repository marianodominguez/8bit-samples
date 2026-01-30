SAVMSC 	=	$58
ASC    	=	$C4
TMP    	=	$C8
MAXLEN 	=	5
STR    	=	$C6
MAXNUM 	=	40
fizzbuzz = $F0
offset   =  $F2

  		org	$0600
  		
start 	
		lda SAVMSC
		sta ASC
		lda SAVMSC+1
		sta ASC+1
		ldy #0
		ldx #0
		lda #0
		clc
loop	
		lda #0
		sta fizzbuzz
		inx
		txa
		jsr mof3
		txa
		jsr mof5
		lda fizzbuzz
		cmp #1
		beq next
		txa
		;print number
		adc #16
		sta TMP
		lda #TMP
		sta STR
		lda #0
		sta STR+1
		jsr print
next    cpx #MAXNUM
		bne loop
pause	jmp pause
; find if number is multiple of 3
mof3	cmp #3
		beq prfizz
		bmi ret3
		sbc #3
		jmp mof3
prfizz	lda #fizz&255
		sta STR
		lda #fizz/256
		sta STR+1
		lda #1
		sta fizzbuzz
		jsr print
ret3	rts

; find if number is multiple of 5
mof5	cmp #5
		beq prbuzz
		bmi ret5
		sbc #5
		jmp mof5
prbuzz	lda #buzz&255
		sta STR
		lda #buzz/256
		sta STR+1
		lda #1
		sta fizzbuzz
		jsr print
ret5	rts

; print string at SAVMSC
print	clc
		lda (STR),Y
		cmp #$9B
		beq exit
		sta (ASC),Y
		iny
		cpy #MAXLEN
		bne print
exit	clc
		lda ASC
		sty offset
		adc offset
		sta ASC
		lda ASC+1
		adc #0
		sta ASC+1
		ldy #0
		rts


fizz  	.byte "FIZZ ",$9B ; EOL,
buzz  	.byte "BUZZ ",$9B